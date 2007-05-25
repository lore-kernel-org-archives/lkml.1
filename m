Return-Path: <linux-kernel-owner+w=401wt.eu-S1764445AbXEYRZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764445AbXEYRZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 13:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763168AbXEYRZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 13:25:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:60180 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763052AbXEYRZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 13:25:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,580,1170662400"; 
   d="scan'208";a="247332413"
From: Auke Kok <auke-jan.h.kok@intel.com>
Subject: [PATCH 2/2] [condingstyle] Add chapter on tests
To: randy.dunlap@oracle.com
Cc: auke-jan.h.kok@intel.com, linux-kernel@vger.kernel.org
Date: Fri, 25 May 2007 10:25:15 -0700
Message-ID: <20070525172515.5138.13652.stgit@localhost.localdomain>
In-Reply-To: <20070525172509.5138.56430.stgit@localhost.localdomain>
References: <20070525172509.5138.56430.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 May 2007 17:25:15.0639 (UTC) FILETIME=[A89B1070:01C79EF1]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Several standards have been established on how to format tests and use
NULL/false/true tests.

Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
---

 Documentation/CodingStyle |   51 +++++++++++++++++++++++++++++++++++----------
 1 files changed, 40 insertions(+), 11 deletions(-)

diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index f518395..3635b38 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -393,7 +393,7 @@ int fun(int a)
 	int result = 0;
 	char *buffer = kmalloc(SIZE);
 
-	if (buffer == NULL)
+	if (!buffer)
 		return -ENOMEM;
 
 	if (condition1) {
@@ -409,7 +409,36 @@ out:
 	return result;
 }
 
-		Chapter 8: Commenting
+		Chapyer 8: Tests
+
+Testing return values from function calls can get complex when you need
+to re-use the value later on. You should store the value before doing
+any tests on it. Never assign values inside a condition to another
+variable.
+
+	err = test_something();
+	if (err) {
+		printk(KERN_ERR "Error: test_something() failed\n");
+		return err;
+	}
+
+If you give your variables and pointers good names, there is never a need
+to compare the value stored in that variable to NULL or true/false, so
+omit all that and keep it short.
+
+	ptr = s->next;
+	if (!ptr)
+		return;
+
+	v = (read_byte(register));
+	if (v & mask)
+		return;
+
+	if (is_prime(number))
+		return 0;
+
+
+		Chapter 9: Commenting
 
 Comments are good, but there is also a danger of over-commenting.  NEVER
 try to explain HOW your code works in a comment: it's much better to
@@ -449,7 +478,7 @@ multiple data declarations).  This leaves you room for a small comment on each
 item, explaining its use.
 
 
-		Chapter 9: You've made a mess of it
+		Chapter 10: You've made a mess of it
 
 That's OK, we all do.  You've probably been told by your long-time Unix
 user helper that "GNU emacs" automatically formats the C sources for
@@ -497,7 +526,7 @@ re-formatting you may want to take a look at the man page.  But
 remember: "indent" is not a fix for bad programming.
 
 
-		Chapter 10: Configuration-files
+		Chapter 11: Configuration-files
 
 For configuration options (arch/xxx/Kconfig, and all the Kconfig files),
 somewhat different indentation is used.
@@ -522,7 +551,7 @@ support for file-systems, for instance) should be denoted (DANGEROUS), other
 experimental options should be denoted (EXPERIMENTAL).
 
 
-		Chapter 11: Data structures
+		Chapter 12: Data structures
 
 Data structures that have visibility outside the single-threaded
 environment they are created and destroyed in should always have
@@ -553,7 +582,7 @@ Remember: if another thread can find your data structure, and you don't
 have a reference count on it, you almost certainly have a bug.
 
 
-		Chapter 12: Macros, Enums and RTL
+		Chapter 13: Macros, Enums and RTL
 
 Names of macros defining constants and labels in enums are capitalized.
 
@@ -608,7 +637,7 @@ The cpp manual deals with macros exhaustively. The gcc internals manual also
 covers RTL which is used frequently with assembly language in the kernel.
 
 
-		Chapter 13: Printing kernel messages
+		Chapter 14: Printing kernel messages
 
 Kernel developers like to be seen as literate. Do mind the spelling
 of kernel messages to make a good impression. Do not use crippled
@@ -619,7 +648,7 @@ Kernel messages do not have to be terminated with a period.
 Printing numbers in parentheses (%d) adds no value and should be avoided.
 
 
-		Chapter 14: Allocating memory
+		Chapter 15: Allocating memory
 
 The kernel provides the following general purpose memory allocators:
 kmalloc(), kzalloc(), kcalloc(), and vmalloc().  Please refer to the API
@@ -638,7 +667,7 @@ from void pointer to any other pointer type is guaranteed by the C programming
 language.
 
 
-		Chapter 15: The inline disease
+		Chapter 16: The inline disease
 
 There appears to be a common misperception that gcc has a magic "make me
 faster" speedup option called "inline". While the use of inlines can be
@@ -665,7 +694,7 @@ appears outweighs the potential value of the hint that tells gcc to do
 something it would have done anyway.
 
 
-		Chapter 16: Function return values and names
+		Chapter 17: Function return values and names
 
 Functions can return values of many different kinds, and one of the
 most common is a value indicating whether the function succeeded or
@@ -699,7 +728,7 @@ result.  Typical examples would be functions that return pointers; they use
 NULL or the ERR_PTR mechanism to report failure.
 
 
-		Chapter 17:  Don't re-invent the kernel macros
+		Chapter 18:  Don't re-invent the kernel macros
 
 The header file include/linux/kernel.h contains a number of macros that
 you should use, rather than explicitly coding some variant of them yourself.
