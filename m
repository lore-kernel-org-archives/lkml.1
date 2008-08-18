Return-Path: <linux-kernel-owner+w=401wt.eu-S1754516AbYHROUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbYHROUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 10:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbYHROUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 10:20:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:56342 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105AbYHROUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 10:20:07 -0400
Subject: BUG: checkpatch
From: Jaswinder Singh <jaswinder@infradead.org>
To: LKML <linux-kernel@vger.kernel.org>, davej@codemonkey.org.uk,
       jschopp@austin.ibm.com, apw@uk.ibm.com,
       David Woodhouse <dwmw2@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain
Date: Mon, 18 Aug 2008 19:50:00 +0530
Message-Id: <1219069200.3208.4.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[jsr@jaswinder jaswinder-git]$ cat test.c
void test(int i, int j, int k)
{
	printk(KERN_INFO "/* Testing i, j, k */\n");
	printk(KERN_INFO "i: %d j: %d k:%d\n", i, j, k);
}
[jsr@jaswinder jaswinder-git]$ ./linux-2.6/scripts/checkpatch.pl --file test.c
ERROR: spaces required around that ':' (ctx:VxW)
#4: FILE: test.c:4:
+	printk(KERN_INFO "i: %d j: %d k:%d\n", i, j, k);
 	                   ^

ERROR: need consistent spacing around '%' (ctx:WxV)
#4: FILE: test.c:4:
+	printk(KERN_INFO "i: %d j: %d k:%d\n", i, j, k);
 	                     ^

ERROR: spaces required around that ':' (ctx:VxW)
#4: FILE: test.c:4:
+	printk(KERN_INFO "i: %d j: %d k:%d\n", i, j, k);
 	                         ^

ERROR: need consistent spacing around '%' (ctx:WxV)
#4: FILE: test.c:4:
+	printk(KERN_INFO "i: %d j: %d k:%d\n", i, j, k);
 	                           ^

ERROR: spaces required around that ':' (ctx:VxO)
#4: FILE: test.c:4:
+	printk(KERN_INFO "i: %d j: %d k:%d\n", i, j, k);
 	                               ^

total: 5 errors, 0 warnings, 5 lines checked

test.c has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.
[jsr@jaswinder jaswinder-git]$ cat test_working.c 
void test(int i, int j, int k)
{
	printk(KERN_INFO "/* Testing i, j, k * /\n");
	printk(KERN_INFO "i: %d j: %d k:%d\n", i, j, k);
}
[jsr@jaswinder jaswinder-git]$ ./linux-2.6/scripts/checkpatch.pl --file test_working.c 
total: 0 errors, 0 warnings, 5 lines checked

test_working.c has no obvious style problems and is ready for submission.
[jsr@jaswinder jaswinder-git]$ diff -uN test.c test_working.c 
--- test.c	2008-08-18 19:38:32.000000000 +0530
+++ test_working.c	2008-08-18 19:38:37.000000000 +0530
@@ -1,5 +1,5 @@
 void test(int i, int j, int k)
 {
-	printk(KERN_INFO "/* Testing i, j, k */\n");
+	printk(KERN_INFO "/* Testing i, j, k * /\n");
 	printk(KERN_INFO "i: %d j: %d k:%d\n", i, j, k);
 }
[jsr@jaswinder jaswinder-git]$ cp test.c test
[jsr@jaswinder jaswinder-git]$ ./linux-2.6/scripts/checkpatch.pl --file test
total: 0 errors, 0 warnings, 5 lines checked

test has no obvious style problems and is ready for submission.
[jsr@jaswinder jaswinder-git]$ 



