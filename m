Return-Path: <linux-kernel-owner+w=401wt.eu-S1762115AbXIUS5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762115AbXIUS5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 14:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760228AbXIUS5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 14:57:14 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:20312 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757579AbXIUS5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 14:57:13 -0400
Date: Fri, 21 Sep 2007 11:55:25 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, zach.brown@oracle.com
Subject: [PATCH] aio: don't confuse DEBUG define location
Message-Id: <20070921115525.84b0387c.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

I was debugging (via pr_debug()) why one test app was getting EINVAL
returns from aio.  However, using DEBUG to enable pr_debug() needs to
be done before #include linux/kernel.h, so remove it from below there
so that someone doesn't have to debug pr_debug().

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Zach Brown <zach.brown@oracle.com>
---
 fs/aio.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- linux-2.6.23-rc7.orig/fs/aio.c
+++ linux-2.6.23-rc7/fs/aio.c
@@ -8,6 +8,7 @@
  *
  *	See ../COPYING for licensing terms.
  */
+
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/errno.h>
@@ -17,8 +18,6 @@
 #include <linux/syscalls.h>
 #include <linux/uio.h>
 
-#define DEBUG 0
-
 #include <linux/sched.h>
 #include <linux/fs.h>
 #include <linux/file.h>
