

DROP TABLE walmart /* Upon checking that some fields initially were in Capital case and we wanted everyhting in lower case, hence we dropped the table and re uploaded an updated one*/

Select * from walmart

/* Solving Business Related Problems with the uploaded Dataset*/

1. /*Analyzing Payment methods and Sales */ 

Select walmart.payment_method, COUNT(*), SUM(walmart.quantity)
   FROM walmart
   GROUP BY walmart.payment_method
   ORDER BY 2 DESC,3 DESC

2. /* Highest-Rated Category in Each Branch */

--Select * FROM walmart

Select *
FROM (
SELECT walmart.branch, walmart.category, AVG(walmart.rating),
RANK() OVER(PARTITION BY walmart.branch ORDER BY AVG(walmart.rating)DESC) as rank
FROM walmart
GROUP BY 1,2
)
WHERE rank = 1
--ORDER BY 1,2

3. /*Busiest Day for each branch */

--Select * from walmart

SELECT
*
FROM
(
SELECT
	WALMART.BRANCH,
	TO_CHAR(TO_DATE(WALMART.DATE, 'DD/MM/YY'), 'Day') AS DAY_NAME,
	COUNT(*) AS NO_OF_TRX,
	RANK() OVER (
		PARTITION BY
			WALMART.BRANCH
		ORDER BY
			COUNT(*) DESC
	) AS RANK
FROM
	WALMART GROUP BY 1,2
)
WHERE RANK = 1


4. /* Total quantity sold per payment method */

  Select walmart.payment_method, SUM(walmart.quantity) as total_qty_sold
   FROM walmart
   GROUP BY walmart.payment_method
   ORDER BY 2 DESC 

5  /* Determin the average, minimum, max rating of category for each city */

  Select city, category, MAX(rating), MIN(rating), CEIL(AVG(rating))
  FROM walmart
  GROUP BY 1,2 
  ORDER BY 1,2


6 /*  Calculate the total profit as total profit * profit_margin. List category and total_profit  from highest to lowest profits */

 SELECT category, 
	 SUM(walmart.total_price) as total_revenue,
	 SUM(walmart.total_price * walmart.profit_margin) as total_profit 
 FROM walmart
 GROUP BY category
 ORDER BY 2 DESC 


7 /* Calculating the most common payment method for each branch. Display branch and preffered payment method */

--Select * from walmart

WITH base as 
(Select walmart.branch, walmart.payment_method, COUNT(*),
RANK() OVER(PARTITION BY walmart.branch ORDER BY COUNT(*) DESC) AS RANK
FROM walmart
GROUP BY 1,2
)

SELECT * FROM base 
WHERE RANK = 1
 


8 /* Categorize sales into 3 shifts -  Morning, Evening and Night. Then for these shifts calculate  the counts and the no. of invoices */

Select * from walmart

WITH
	SHIFTS AS (
		SELECT
			 *,
			CASE
				WHEN TIME::TIME < '12:00:00' THEN 'Morning'
				WHEN TIME::TIME >= '12:00:00'
				AND TIME::TIME < '19:00:00' THEN 'Evening'
				ELSE 'Night'
			END AS SHIFTS
		FROM
			WALMART
	)
SELECT
	BRANCH,
	SHIFTS,
	COUNT(*) FROM
	SHIFTS
GROUP BY
	1,2
ORDER BY 1,3 DESC	


9. /* Identify 5 branches with the maximum decrease ratio. Compare the years 2022 and 2023 respectively */

With both_yr_rev as (Select 
		BRANCH,
		SUM(CASE WHEN EXTRACT( YEAR FROM (TO_DATE(DATE, 'DD/MM/YY'))) = 2023 THEN TOTAL_PRICE ELSE 0 END) AS REV_2023,
		SUM(CASE WHEN EXTRACT( YEAR FROM (TO_DATE(DATE, 'DD/MM/YY'))) = 2022 THEN TOTAL_PRICE ELSE 0 END) AS REV_2022
from walmart
WHERE TO_DATE(DATE, 'DD/MM/YY') BETWEEN DATE '2022-01-01' AND DATE '2023-12-31'
GROUP BY 1
)

Select branch, rev_2023, rev_2022, ((rev_2022 - rev_2023)/rev_2022 )*100 as perc_decline
from both_yr_rev
order by 4 DESC 
limit 5


Select * FROM WALMART
WHERE  EXTRACT( YEAR FROM (TO_DATE(DATE, 'DD/MM/YY'))) = 2022


