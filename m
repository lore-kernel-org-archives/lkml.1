Return-Path: <linux-kernel-owner+w=401wt.eu-S1765740AbXEVKZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765740AbXEVKZg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 06:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756884AbXEVKZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 06:25:29 -0400
Received: from www.osadl.org ([213.239.205.134]:59313 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756591AbXEVKZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 06:25:29 -0400
Subject: [PATCH] CDROM: replace jiffies busyloop with msleep
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jeff Garzik <jeff@garzik.org>
Content-Type: text/plain
Date: Tue, 22 May 2007 12:25:25 +0200
Message-Id: <1179829525.12708.118.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

The SJCD driver uses a jiffies busy loop. Replace it with msleep.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Thomas Gleixner <tglx@linutronix.de>

---
 drivers/cdrom/sjcd.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/cdrom/sjcd.c
===================================================================
--- linux-2.6.orig/drivers/cdrom/sjcd.c
+++ linux-2.6/drivers/cdrom/sjcd.c
@@ -69,6 +69,7 @@
 #include <linux/string.h>
 #include <linux/major.h>
 #include <linux/init.h>
+#include <linux/delay.h>
 
 #include <asm/system.h>
 #include <asm/io.h>
@@ -1709,12 +1710,11 @@ static int __init sjcd_init(void)
 	printk(KERN_INFO "SJCD: Resetting: ");
 	sjcd_send_cmd(SCMD_RESET);
 	for (i = 1000; i > 0 && !sjcd_status_valid; --i) {
-		unsigned long timer;
-
 		/*
 		 * Wait 10ms approx.
 		 */
-		for (timer = jiffies; time_before_eq(jiffies, timer););
+		msleep(10);
+
 		if ((i % 100) == 0)
 			printk(".");
 		(void) sjcd_check_status();


