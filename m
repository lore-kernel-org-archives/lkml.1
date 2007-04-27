Return-Path: <linux-kernel-owner+w=401wt.eu-S1755927AbXD0OGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbXD0OGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 10:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755925AbXD0OGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 10:06:37 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:31119 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755876AbXD0OE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 10:04:58 -0400
Message-Id: <20070427140516.978694861@de.ibm.com>
References: <20070427140503.087958775@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 27 Apr 2007 16:05:25 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 22/38] Get rid of console setup functions.
Content-Disposition: inline; filename=125-console-setup.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

We get this:

Section mismatch: reference to .init.text:con3270_consetup from .data
		  between 'con3270' (at offset 0x45c8) and 'con3270_fn'
Section mismatch: reference to .init.text:con3215_consetup from .data
		  between 'con3215' (at offset 0x4678) and
		  'raw3215_ccw_driver'

Since there is no difference between a non present console setup
function and one that returns only 0 remove them.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

 drivers/s390/char/con3215.c |    7 -------
 drivers/s390/char/con3270.c |    7 -------
 2 files changed, 14 deletions(-)

Index: quilt-2.6/drivers/s390/char/con3215.c
===================================================================
--- quilt-2.6.orig/drivers/s390/char/con3215.c	2007-04-27 16:01:49.000000000 +0200
+++ quilt-2.6/drivers/s390/char/con3215.c	2007-04-27 16:04:58.000000000 +0200
@@ -813,12 +813,6 @@
 	spin_unlock_irqrestore(get_ccwdev_lock(raw->cdev), flags);
 }
 
-static int __init 
-con3215_consetup(struct console *co, char *options)
-{
-	return 0;
-}
-
 /*
  *  The console structure for the 3215 console
  */
@@ -827,7 +821,6 @@
 	.write	 = con3215_write,
 	.device	 = con3215_device,
 	.unblank = con3215_unblank,
-	.setup	 = con3215_consetup,
 	.flags	 = CON_PRINTBUFFER,
 };
 
Index: quilt-2.6/drivers/s390/char/con3270.c
===================================================================
--- quilt-2.6.orig/drivers/s390/char/con3270.c	2007-04-27 16:01:49.000000000 +0200
+++ quilt-2.6/drivers/s390/char/con3270.c	2007-04-27 16:04:58.000000000 +0200
@@ -555,12 +555,6 @@
 	spin_unlock_irqrestore(&cp->view.lock, flags);
 }
 
-static int __init 
-con3270_consetup(struct console *co, char *options)
-{
-	return 0;
-}
-
 /*
  *  The console structure for the 3270 console
  */
@@ -569,7 +563,6 @@
 	.write	 = con3270_write,
 	.device	 = con3270_device,
 	.unblank = con3270_unblank,
-	.setup	 = con3270_consetup,
 	.flags	 = CON_PRINTBUFFER,
 };
 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

