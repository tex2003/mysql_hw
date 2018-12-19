#1a. Display the first and last names of all actors from the table `actor`.
SELECT first_name, last_name FROM actor;

#1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
SELECT concat(first_name," ", last_name)  AS 'Actor Name' FROM actor;

#2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name FROM actor WHERE first_name = "Joe";

#2b. Find all actors whose last name contain the letters `GEN`.
SELECT first_name, last_name FROM actor WHERE last_name LIKE '%gen%';

#2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
SELECT first_name, last_name FROM actor WHERE last_name LIKE '%li%' ORDER BY last_name, first_name;

#2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China.
SELECT country_id, country FROM country WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

#3a. You want to keep a description of each actor. You dont think you will be performing queries on a description, so create a column in the table `actor` named `description` and use the data type `BLOB` (Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).
ALTER TABLE actor
ADD COLUMN 'description' BLOB True After rating;

#3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.
ALTER TABLE actor
DROP COLUMN description;

#4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(last_name) FROM actor GROUP BY last_name;

#4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors.
SELECT last_name, COUNT(last_name) FROM actor GROUP BY last_name HAVING COUNT(last_name) >= 2;

#4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.
UPDATE actor SET first_name = 'HARPO' WHERE first_name = 'Groucho' AND last_name = "Williams";

#4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.
UPDATE actor SET first_name = 'GROUCHO' WHERE first_name = 'Harpo' AND last_name = "Williams";

5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
SHOW CREATE TABLE address;

#6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
SELECT first_name, last_name, address FROM staff s LEFT JOIN address a ON a.address_id = s.address_id;

#6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.
SELECT first_name, last_name, sum(amount) FROM staff s LEFT JOIN payment p ON s.staff_id = p.staff_id  WHERE payment_date > "2005-08-01" AND payment_date < "2005-09-01" GROUP BY first_name;

#6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.
SELECT title, COUNT(actor_id) FROM film f INNER JOIN film_actor a ON f.film_id = a.film_id GROUP BY title;

#6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
SELECT title, count(i.film_id) FROM film f LEFT JOIN inventory i ON f.film_id = i.film_id GROUP BY title;

#6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT first_name, last_name, sum(amount) FROM customer c JOIN payment p ON c.customer_id = p.customer_id  GROUP BY first_name, last_name ORDER BY last_name asc;

#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
SELECT title FROM film WHERE title IN
	(SELECT title FROM film WHERE title LIKE "k%" or title LIKE "q%") AND language_id = 1;
	
#7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
SELECT first_name, last_name FROM actor WHERE actor_id IN
	(SELECT actor_id FROM film_actor where film_id IN
			(SELECT film_id FROM film WHERE title = "Alone Trip"));	

#7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT first_name, last_name, email, a.city_id, ci.city, ci.country_id FROM customer c LEFT JOIN address a ON c.address_id = a.address_id LEFT JOIN city ci ON a.city_id = ci.city_id WHERE country_id = 20;  

#7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as _family_ films.
SELECT title FROM film f LEFT JOIN film_category fc ON f.film_id = fc.film_id LEFT JOIN category c ON fc.category_id = c.category_id WHERE name = "Family";

#7e. Display the most frequently rented movies in descending order.
SELECT f.title, count(f.title) FROM rental r LEFT JOIN inventory i ON r.inventory_id = i.inventory_id LEFT JOIN film f ON i.film_id=f.film_id GROUP BY title ORDER BY count(f.title) DESC;

#7f. Write a query to display how much business, in dollars, each store brought in.
SELECT s.store_id, CONCAT('$', FORMAT((SUM(amount)), 2)) AS Revenue FROM payment p LEFT JOIN staff s ON p.staff_id = s.staff_id GROUP BY s.store_id;

#7g. Write a query to display for each store its store ID, city, and country.
SELECT store_id, c.city, co.country FROM store s LEFT JOIN address a ON s.address_id = a.address_id LEFT JOIN city c ON a.city_id = c.city_id LEFT JOIN country co ON c.country_id=co.country_id;

#7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT c.name, sum(p.amount) as "Gross Revenue" from payment p LEFT JOIN rental r ON p.rental_id = r.rental_id LEFT JOIN inventory i ON r.inventory_id = i.inventory_id LEFT JOIN film f ON i.film_id = f.film_id LEFT JOIN film_category fc ON f.film_id = fc.film_id LEFT JOIN category c ON fc.category_id = c.category_id GROUP BY c.name ORDER BY sum(p.amount) DESC LIMIT 5;

#8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you havent solved 7h, you can substitute another query to create a view.
CREATE VIEW top_five_genres AS SELECT c.name, sum(p.amount) as "Gross Revenue" from payment p LEFT JOIN rental r ON p.rental_id = r.rental_id LEFT JOIN inventory i ON r.inventory_id = i.inventory_id LEFT JOIN film f ON i.film_id = f.film_id LEFT JOIN film_category fc ON f.film_id = fc.film_id LEFT JOIN category c ON fc.category_id = c.category_id GROUP BY c.name ORDER BY sum(p.amount) DESC LIMIT 5;

# 8b. How would you display the view that you created in 8a?
Select * from top_five_genres;

# 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it. *\/ */ */
DROP VIEW top_five_genres;