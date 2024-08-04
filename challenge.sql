
-----------------------QUESTION-1-------------------------------
SELECT Person.FirstName as FirstName , EmailAddress.EmailAddress as EmailAdress
from Sales.Store join Sales.Customer on StoreID = Store.BusinessEntityID 
join Person.Person  on Person.BusinessEntityID = Customer.PersonID
join Person.EmailAddress on EmailAddress.BusinessEntityID = Person.BusinessEntityID
WHERE Sales.Store.Name = 'Bike World';
----------------------------------------------------------------
-----------------------QUESTION-2-------------------------------
SELECT distinct Store.Name as CompanyName
from 
Sales.Store join Sales.Customer on Store.BusinessEntityID = Customer.StoreID 
join Sales.SalesOrderHeader on Customer.CustomerID = SalesOrderHeader.CustomerID
join Person.Address on BillToAddressID = AddressID
where Address.City = 'Dallas'
----------------------------------------------------------------
-----------------------QUESTION-3-------------------------------
select distinct count(SalesOrderDetail.ProductID) as ListPriceMoreThan1000
from Production.Product join Sales.SalesOrderDetail on SalesOrderDetail.ProductID = Product.ProductID
where ListPrice > 1000;
----------------------------------------------------------------
-----------------------QUESTION-4-------------------------------
select  Store.Name 
from Sales.SalesOrderHeader join Sales.Customer on Customer.CustomerID = SalesOrderHeader.CustomerID
join Sales.Store on  Customer.CustomerID = Store.BusinessEntityID
where TotalDue > 100000 
select Name from Sales.Store;
----------------------------------------------------------------
-----------------------QUESTION-5-------------------------------
SELECT
  SUM(SalesOrderDetail.OrderQty) As LeftRacingSocks
FROM
  Sales.SalesOrderDetail JOIN Production.Product ON SalesOrderDetail.ProductID = Product.ProductID
  JOIN Sales.SalesOrderHeader ON SalesOrderDetail.SalesOrderID = SalesOrderHeader.SalesOrderID
  JOIN Sales.Customer ON SalesOrderHeader.CustomerID = Customer.CustomerID
  JOIN Sales.Store on Customer.StoreID = Store.BusinessEntityID	
WHERE
  Product.Name = 'Racing Socks, L' AND Store.Name = 'Riding Cycles';
----------------------------------------------------------------
-----------------------QUESTION-6-------------------------------
SELECT
  SalesOrderID,
  UnitPrice
FROM
  Sales.SalesOrderDetail
WHERE
  OrderQty = 1;
---------------------------------------------------------------
-----------------------QUESTION-7------------------------------
SELECT
  Product.name as Product, Store.Name as CompanyName
FROM
  Production.ProductModel
  JOIN
    Production.Product
    ON ProductModel.ProductModelID = Product.ProductModelID
  JOIN
    Sales.SalesOrderDetail
    ON SalesOrderDetail.ProductID = Product.ProductID
  JOIN
    Sales.SalesOrderHeader
    ON SalesOrderDetail.SalesOrderID = SalesOrderHeader.SalesOrderID
  JOIN
    Sales.Customer
    ON SalesOrderHeader.CustomerID = Customer.CustomerID
	JOIN Sales.Store
	ON Customer.StoreID = Store.BusinessEntityID
WHERE
  ProductModel.Name = 'Racing Socks';
 ---------------------------------------------------------------
-----------------------QUESTION-8-------------------------------
select ProductDescription.Description as Description
from Production.ProductDescription join Production.ProductModelProductDescriptionCulture on ProductDescription.ProductDescriptionID = ProductModelProductDescriptionCulture.ProductDescriptionID
join Production.Culture on Culture.CultureID = ProductModelProductDescriptionCulture.CultureID
join Production.ProductModel on ProductModel.ProductModelID =  ProductModelProductDescriptionCulture.ProductModelID
join Production.Product on Product.ProductModelID = ProductModel.ProductModelID
where Production.Culture.Name = 'French' and ProductID = 736;
----------------------------------------------------------------
-----------------------QUESTION-9-------------------------------
select Store.Name as CompanyName  , SalesOrderHeader.SubTotal
from Sales.Store join Sales.Customer on Sales.Customer.StoreID = Sales.Store.BusinessEntityID 
join Sales.SalesOrderHeader on 	SalesOrderHeader.CustomerID = Customer.CustomerID
order by SubTotal desc ;
----------------------------------------------------------------
-----------------------QUESTION-10------------------------------
SELECT
  SUM(SalesOrderDetail.OrderQty)
FROM Production.ProductCategory JOIN Production.ProductSubcategory ON ProductSubcategory.ProductCategoryID = ProductCategory.ProductCategoryID
  JOIN Production.Product  on Product.ProductSubcategoryID = ProductSubcategory.ProductSubcategoryID
  JOIN Sales.SalesOrderDetail ON Product.ProductID = SalesOrderDetail.ProductID
  JOIN Sales.SalesOrderHeader ON SalesOrderDetail.SalesOrderID = Sales.SalesOrderHeader.SalesorderID
  JOIN Person.Address  ON SalesOrderHeader.ShipToAddressID = Address.AddressID
WHERE
  Address.City = 'London' AND ProductSubcategory.Name = 'Cranksets';
----------------------------------------------------------------
-----------------------QUESTION-11------------------------------
SELECT
  Store.Name,
  MAX(CASE WHEN AddressType.Name = 'Main Office' THEN AddressLine1 ELSE '' END) AS 'Main Office Address',
  MAX(CASE WHEN AddressType.Name = 'Shipping' THEN AddressLine1 ELSE '' END) AS 'Shipping Address'
FROM
  Sales.Customer JOIN Sales.Store  ON Customer.StoreID = Store.BusinessEntityID	
  JOIN
    Sales.SalesOrderHeader ON SalesOrderHeader.CustomerID = Customer.CustomerID
  JOIN
    Person.Address
    ON SalesOrderHeader.BillToAddressID = Person.Address.AddressID	
	JOIN Person.BusinessEntityAddress  ON BusinessEntityAddress.AddressID = Address.AddressID	
	JOIN Person.AddressType ON BusinessEntityAddress.AddressTypeID = AddressType.AddressTypeID
WHERE
  Address.City = 'Dallas'
GROUP BY
Store.Name

----------------------------------------------------------------
-----------------------QUESTION-12------------------------------
----------------------FIRST-METHOD------------------------------
select SalesOrderID , SubTotal
from Sales.SalesOrderHeader
----------------------SECOND-METHOD-----------------------------
select SalesOrderHeader.SalesOrderID as SalesOrderID  , Sum(OrderQty * UnitPrice) as SubTotal
from Sales.SalesOrderDetail join Sales.SalesOrderHeader on SalesOrderDetail.SalesOrderID = SalesOrderHeader.SalesOrderID	
group by SalesOrderHeader.SalesOrderID ;
----------------------THIRD-METHOD-----------------------------
select SalesOrderHeader.SalesOrderID as SalesOrderID , Sum (OrderQty * ListPrice)
from Sales.SalesOrderHeader join Sales.SalesOrderDetail on Sales.SalesOrderDetail.SalesOrderID = Sales.SalesOrderHeader.SalesOrderID
join Sales.SpecialOfferProduct on Sales.SalesOrderDetail.ProductID = Sales.SpecialOfferProduct.ProductID	
join Production.Product on Sales.SpecialOfferProduct.ProductID = Production.Product.ProductID	
group by SalesOrderHeader.SalesOrderID;
----------------------------------------------------------------
-----------------------QUESTION-13------------------------------
SELECT Product.Name as Product_Name, SUM(OrderQty * UnitPrice) AS Total_Value
FROM Production.Product JOIN Sales.SalesOrderDetail ON Product.ProductID = SalesOrderDetail.ProductID
GROUP BY Product.Name
ORDER BY Total_Value DESC;
----------------------------------------------------------------
-----------------------QUESTION-14------------------------------
SELECT
  p.range AS 'RANGE',
  COUNT(p.Total) AS 'Num Orders',
  SUM(p.Total) AS 'Total Value'
FROM
  (
    SELECT
    CASE
      WHEN
        SalesOrderDetail.UnitPrice * SalesOrderDetail.OrderQty BETWEEN 0 AND 99
      THEN
        '0-99'
      WHEN
        SalesOrderDetail.UnitPrice * SalesOrderDetail.OrderQty BETWEEN 100 AND 999
      THEN
        '100-999'
      WHEN
        SalesOrderDetail.UnitPrice * SalesOrderDetail.OrderQty BETWEEN 1000 AND 9999
      THEN
        '1000-9999'
      WHEN
        SalesOrderDetail.UnitPrice * SalesOrderDetail.OrderQty > 10000
      THEN
        '10000-'
      ELSE
        'Not in Range'
    END AS 'Range',
    SalesOrderDetail.UnitPrice * SalesOrderDetail.OrderQty AS Total
  FROM
    Sales.SalesOrderDetail
  ) p
GROUP BY
  p.range;
----------------------------------------------------------------
-----------------------QUESTION-16------------------------------
SELECT
  SalesOrderHeader.SalesOrderNumber
FROM Sales.Store  JOIN Sales.Customer on Customer.StoreID = Store.BusinessEntityID
  LEFT JOIN Sales.SalesOrderHeader ON Customer.CustomerID = SalesOrderHeader.CustomerID
WHERE Store.Name LIKE '%Good Toys%' OR Store.Name LIKE '%Bike World%';
----------------------------------------------------------------
-----------------------QUESTION-17------------------------------
SELECT
  Product.Name,
  SalesOrderDetail.OrderQty
FROM
	Sales.Store JOIN Sales.Customer on Sales.Customer.StoreID = Sales.Store.BusinessEntityID
  JOIN Sales.SalesOrderHeader ON Customer.CustomerID = SalesOrderHeader.CustomerID
  JOIN Sales.SalesOrderDetail ON SalesOrderHeader.SalesOrderID = SalesOrderDetail.SalesOrderID
  JOIN Production.Product ON SalesOrderDetail.ProductID = Product.ProductID
WHERE
  Store.Name = 'Futuristic Bikes';
----------------------------------------------------------------
-----------------------QUESTION-18------------------------------
SELECT
  P.Name,
  Address.AddressLine1,
  Address.AddressLine2
FROM
  (
    SELECT DISTINCT
      CustomerID,
      Store.Name,
      1 AS 'Rank'
    FROM
      Sales.Customer JOIN Sales.Store ON  Customer.StoreID = Store.BusinessEntityID	
    WHERE
      lOWER(Store.Name) LIKE '%bike%'
    UNION
    SELECT DISTINCT
      CustomerID,
      Store.Name,
      2 AS 'Rank'
    FROM
      Sales.Customer JOIN Sales.Store ON Customer.StoreID = Store.BusinessEntityID	
    WHERE
      LOWER(Store.Name) LIKE '%cycle%'
  ) AS P
  JOIN
    Sales.SalesOrderHeader 
    ON SalesOrderHeader.CustomerID = P.CustomerID	
  JOIN
    Person.Address
    ON SalesOrderHeader.BillToAddressID = Address.AddressID
ORDER BY
  P.Rank,
  P.Name;
----------------------------------------------------------------
-----------------------QUESTION-19------------------------------
SELECT
  CountryRegion.Name,
  SUM(SubTotal) as Total
FROM
  Sales.SalesOrderHeader
  JOIN
    Person.Address
    ON SalesOrderHeader.ShipToAddressID = Address.AddressID
	JOIN Person.StateProvince on Address.StateProvinceID = StateProvince.StateProvinceID	
	JOIN Person.CountryRegion on  StateProvince.CountryRegionCode = CountryRegion.CountryRegionCode	
GROUP BY
  CountryRegion.Name
ORDER BY
  SUM(SubTotal) DESC;

----------------------------------------------------------------