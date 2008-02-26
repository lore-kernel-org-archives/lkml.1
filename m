Return-Path: <linux-kernel-owner+w=401wt.eu-S1764078AbYBZXAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764078AbYBZXAB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 18:00:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754043AbYBZW7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 17:59:51 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:52940 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988AbYBZW7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 17:59:50 -0500
Date: Tue, 26 Feb 2008 23:59:48 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: ricknu-0@student.ltu.se, khc@pm.waw.pl, bhalevy.lists@gmail.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] CodingStyle: multiple updates
In-Reply-To: <20080226135444.f83a0536.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0802262310050.15321@fbirervta.pbzchgretzou.qr>
References: <1204062430.47c488def40a4@portal.student.luth.se>
 <20080226135444.f83a0536.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 26 2008 13:54, Randy Dunlap wrote:
>>  	 	Chapter 1: Indentation
>>  
>> -Tabs are 8 characters, and thus indentations are also 8 characters.
>> -There are heretic movements that try to make indentations 4 (or even 2!)
>> -characters deep, and that is akin to trying to define the value of PI to
>> -be 3.
>> +This project is recommended to be viewed with a tab-width of 8 characters
>> +(and other code).
>
>FWIW I prefer the {deleted} language.  // PI = 3;

The whole paragraph is misworded anyway (before and after), because
it never says one has to use tabs. Just that tabs are 8. Oh wow.

Here's a rewording of everything I am unhappy with, and it goes
a bit further than tabs and spaces.

It may all sound like we are trying to be nitpicky about minuscule
things, but obviously, if there is a way to go against common practice
but still comply to CS, someone will do it in some patch.


Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>


diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index 6caa146..d80fd0f 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -15,23 +15,25 @@ Anyway, here goes:
 
 	 	Chapter 1: Indentation
 
-Tabs are 8 characters, and thus indentations are also 8 characters.
-There are heretic movements that try to make indentations 4 (or even 2!)
-characters deep, and that is akin to trying to define the value of PI to
-be 3.
+The whole idea behind indentation is to clearly define where a block of
+control starts and ends.
 
-Rationale: The whole idea behind indentation is to clearly define where
-a block of control starts and ends.  Especially when you've been looking
-at your screen for 20 straight hours, you'll find it a lot easier to see
-how the indentation works if you have large indentations.
+There are heretic movements that try to use spaces for indentation. But
+spaces force a specific indentation width on the user. Tabs on the other
+hand provide logical indentation, which means you can set the tab width
+in your editor preferences to any value you like. Especially when you
+have been looking at your screen for 20 straight hours, you will find it
+a lot easier if you can dynamically switch to a higher indent.
 
-Now, some people will claim that having 8-character indentations makes
+By default, tabs have a width of 8, and most developers use that.
+
+Now, some people will claim that having an 8-wide indentations makes
 the code move too far to the right, and makes it hard to read on a
 80-character terminal screen.  The answer to that is that if you need
 more than 3 levels of indentation, you're screwed anyway, and should fix
 your program.
 
-In short, 8-char indents make things easier to read, and have the added
+In short, 8-wide indents make things easier to read, and have the added
 benefit of warning you when you're nesting your functions too deep.
 Heed that warning.
 
@@ -77,26 +79,51 @@ Get a decent editor and don't leave whitespace at the end of lines.
 Coding style is all about readability and maintainability using commonly
 available tools.
 
-The limit on the length of lines is 80 columns and this is a strongly
-preferred limit.
+The limit on the length of lines is 80 columns, that is when tabs are
+displayed with a size of 8. 80 columns is a strongly preferred limit.
+
+Statements longer than 80 columns should be broken into sensible chunks.
+
+Continuation lines are always shorter than the initial one and are
+(1) indented as much as the initial line, plus (2) alignment spaces.
+Spaces are used so as to not cause odd aligning for users wishing to
+display tabs at sizes other than 8. In the example below, the
+continuation line of the printk call therefore has two tabs of logical
+indent, followed by a number of spaces to align it up.
 
-Statements longer than 80 columns will be broken into sensible chunks.
-Descendants are always substantially shorter than the parent and are placed
-substantially to the right. The same applies to function headers with a long
-argument list. Long strings are as well broken into shorter strings. The
-only exception to this is where exceeding 80 columns significantly increases
-readability and does not hide information.
+The same applies to function headers with a long argument list. Long
+strings are broken as well into shorter strings. The only exception to
+this is where exceeding 80 columns significantly increases readability
+and does not hide information.
 
-void fun(int a, int b, int c)
+void fun(int a, int b, int c, struct very_big_structure *ptr,
+         struct lots_of_parameters *ptr2)
 {
 	if (condition)
 		printk(KERN_WARNING "Warning this is a long printk with "
-						"3 parameters a: %u b: %u "
-						"c: %u \n", a, b, c);
+		       "3 parameters a: %u b: %u c: %u\n"
+		       "And our poitners are %p and %p\n",
+		       a, b, c);
 	else
 		next_statement;
 }
 
+When the function return type, tags and name already takes up a
+significant amount of valuable 80-column space, it is recommended to
+split the long line before the name to reduce the amount of indent
+needed for parameters.
+
+static int __init longmodule_initialize_driver(struct pci_driver *foo,
+                                               void *some_parameter,
+                                               void *another_parameter)
+
+into
+
+static int __init
+longmodule_initialize_driver(struct pci_driver *foo, void *some_parameter,
+                             void *another_parameter)
+
+
 		Chapter 3: Placing Braces and Spaces
 
 The other issue that always comes up in C styling is the placement of
@@ -134,7 +161,7 @@ opening brace at the beginning of the next line, thus:
 Heretic people all over the world have claimed that this inconsistency
 is ...  well ...  inconsistent, but all right-thinking people know that
 (a) K&R are _right_ and (b) K&R are right.  Besides, functions are
-special anyway (you can't nest them in C).
+special anyway (you can't nest them in standard C).
 
 Note that the closing brace is empty on a line of its own, _except_ in
 the cases where it is followed by a continuation of the same statement,
@@ -178,7 +205,7 @@ if (condition) {
 	otherwise();
 }
 
-		3.1:  Spaces
+		Subchapter 3.1: Spaces
 
 Linux kernel style for use of spaces depends (mostly) on
 function-versus-keyword usage.  Use a space after (most) keywords.  The
@@ -342,6 +369,10 @@ EVER use a typedef unless you can clearly match one of those rules.
 In general, a pointer, or a struct that has elements that can reasonably
 be directly accessed should _never_ be a typedef.
 
+Also, using typedefs always requires to #include the header they are
+defined in. If a predeclaration of a struct or union suffices to compile
+the unit without including the header, you even get a speedup.
+
 
 		Chapter 6: Functions
 
