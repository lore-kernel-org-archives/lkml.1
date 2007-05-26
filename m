Return-Path: <linux-kernel-owner+w=401wt.eu-S1762310AbXEZUOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762310AbXEZUOd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 16:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755099AbXEZUO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 16:14:26 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:41964 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753760AbXEZUOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 16:14:25 -0400
Date: Sat, 26 May 2007 22:13:34 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Auke Kok <auke-jan.h.kok@intel.com>
cc: randy.dunlap@oracle.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] [condingstyle] Add chapter on tests
In-Reply-To: <Pine.LNX.4.61.0705262121150.7344@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0705262213000.7344@yvahk01.tjqt.qr>
References: <20070525172509.5138.56430.stgit@localhost.localdomain>
 <20070525172515.5138.13652.stgit@localhost.localdomain>
 <Pine.LNX.4.61.0705262121150.7344@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Based in part on Auke's patch.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 Documentation/CodingStyle |   74 +++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 64 insertions(+), 10 deletions(-)

Index: linux-2.6.22-rc3/Documentation/CodingStyle
===================================================================
--- linux-2.6.22-rc3.orig/Documentation/CodingStyle
+++ linux-2.6.22-rc3/Documentation/CodingStyle
@@ -407,7 +407,61 @@ out:
 	return result;
 }
 
-		Chapter 8: Commenting
+		Chapyer 8: Tests
+
+Testing return values from function calls can get complex when you need
+to re-use the value later on. You should store the value before doing
+any tests on it. Do not assign values inside a condition to another
+variable.
+
+	err = test_something();
+	if (err) {
+		printk(KERN_ERR "Error: test_something() failed\n");
+		return err;
+	}
+
+Testing for a flag, as done in the following example, is redundant and
+can be shortened.
+
+	if ((v & GFP_KERNEL) == GFP_KERNEL)
+		return;
+
+should become
+
+	if (v & GFP_KERNEL)
+		return;
+
+The same goes for functions that return a bool:
+
+	if (is_prime(number) == true)
+		return 0;
+	if (is_prime(number) == false)
+		return 1;
+
+should be:
+
+	if (is_prime(number))
+		return 0;
+	if (!is_prime(number))
+		return 1;
+
+As far as pointers or functions returning an integer are concerned,
+using long form tests helps to distinguish between pointers and bools
+or functions returning boolean or integer, respectively.
+Examples are:
+
+	if (p == NULL)
+		return 1;
+	if (!p)
+		return 0;
+
+	if (strcmp(haystack, needle) == 0)
+		return 1;
+	if (!strcmp(haystack, needle))
+		return 0;
+
+
+		Chapter 9: Commenting
 
 Comments are good, but there is also a danger of over-commenting.  NEVER
 try to explain HOW your code works in a comment: it's much better to
@@ -447,7 +501,7 @@ multiple data declarations).  This leave
 item, explaining its use.
 
 
-		Chapter 9: You've made a mess of it
+		Chapter 10: You've made a mess of it
 
 That's OK, we all do.  You've probably been told by your long-time Unix
 user helper that "GNU emacs" automatically formats the C sources for
@@ -495,7 +549,7 @@ re-formatting you may want to take a loo
 remember: "indent" is not a fix for bad programming.
 
 
-		Chapter 10: Kconfig configuration files
+		Chapter 11: Kconfig configuration files
 
 For all of the Kconfig* configuration files throughout the source tree,
 the indentation is somewhat different.  Lines under a "config" definition
@@ -531,7 +585,7 @@ For full documentation on the configurat
 Documentation/kbuild/kconfig-language.txt.
 
 
-		Chapter 11: Data structures
+		Chapter 12: Data structures
 
 Data structures that have visibility outside the single-threaded
 environment they are created and destroyed in should always have
@@ -562,7 +616,7 @@ Remember: if another thread can find you
 have a reference count on it, you almost certainly have a bug.
 
 
-		Chapter 12: Macros, Enums and RTL
+		Chapter 13: Macros, Enums and RTL
 
 Names of macros defining constants and labels in enums are capitalized.
 
@@ -617,7 +671,7 @@ The cpp manual deals with macros exhaust
 covers RTL which is used frequently with assembly language in the kernel.
 
 
-		Chapter 13: Printing kernel messages
+		Chapter 14: Printing kernel messages
 
 Kernel developers like to be seen as literate. Do mind the spelling
 of kernel messages to make a good impression. Do not use crippled
@@ -628,7 +682,7 @@ Kernel messages do not have to be termin
 Printing numbers in parentheses (%d) adds no value and should be avoided.
 
 
-		Chapter 14: Allocating memory
+		Chapter 15: Allocating memory
 
 The kernel provides the following general purpose memory allocators:
 kmalloc(), kzalloc(), kcalloc(), and vmalloc().  Please refer to the API
@@ -647,7 +701,7 @@ from void pointer to any other pointer t
 language.
 
 
-		Chapter 15: The inline disease
+		Chapter 16: The inline disease
 
 There appears to be a common misperception that gcc has a magic "make me
 faster" speedup option called "inline". While the use of inlines can be
@@ -674,7 +728,7 @@ appears outweighs the potential value of
 something it would have done anyway.
 
 
-		Chapter 16: Function return values and names
+		Chapter 17: Function return values and names
 
 Functions can return values of many different kinds, and one of the
 most common is a value indicating whether the function succeeded or
@@ -708,7 +762,7 @@ result.  Typical examples would be funct
 NULL or the ERR_PTR mechanism to report failure.
 
 
-		Chapter 17:  Don't re-invent the kernel macros
+		Chapter 18:  Don't re-invent the kernel macros
 
 The header file include/linux/kernel.h contains a number of macros that
 you should use, rather than explicitly coding some variant of them yourself.
