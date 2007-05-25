Return-Path: <linux-kernel-owner+w=401wt.eu-S1759308AbXEYKmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759308AbXEYKmP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 06:42:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751064AbXEYKmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 06:42:00 -0400
Received: from smtp-105-friday.noc.nerim.net ([62.4.17.105]:4262 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750762AbXEYKl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 06:41:59 -0400
Date: Fri, 25 May 2007 12:42:58 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] tty_io: Use kzalloc
Message-ID: <20070525124258.5b72f077@hyperion.delvare>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
Andrew, can you please pick this? I couldn't find any maintainer for
this driver. Thanks.

 drivers/char/tty_io.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- linux-2.6.22-rc2.orig/drivers/char/tty_io.c	2007-05-25 08:43:16.000000000 +0200
+++ linux-2.6.22-rc2/drivers/char/tty_io.c	2007-05-25 08:43:24.000000000 +0200
@@ -2009,11 +2009,10 @@ static int init_dev(struct tty_driver *d
 	}
 
 	if (!*ltp_loc) {
-		ltp = (struct ktermios *) kmalloc(sizeof(struct ktermios),
+		ltp = (struct ktermios *) kzalloc(sizeof(struct ktermios),
 						 GFP_KERNEL);
 		if (!ltp)
 			goto free_mem_out;
-		memset(ltp, 0, sizeof(struct ktermios));
 	}
 
 	if (driver->type == TTY_DRIVER_TYPE_PTY) {
@@ -2043,10 +2042,9 @@ static int init_dev(struct tty_driver *d
 
 		if (!*o_ltp_loc) {
 			o_ltp = (struct ktermios *)
-				kmalloc(sizeof(struct ktermios), GFP_KERNEL);
+				kzalloc(sizeof(struct ktermios), GFP_KERNEL);
 			if (!o_ltp)
 				goto free_mem_out;
-			memset(o_ltp, 0, sizeof(struct ktermios));
 		}
 
 		/*
@@ -3732,9 +3730,8 @@ struct tty_driver *alloc_tty_driver(int 
 {
 	struct tty_driver *driver;
 
-	driver = kmalloc(sizeof(struct tty_driver), GFP_KERNEL);
+	driver = kzalloc(sizeof(struct tty_driver), GFP_KERNEL);
 	if (driver) {
-		memset(driver, 0, sizeof(struct tty_driver));
 		driver->magic = TTY_DRIVER_MAGIC;
 		driver->num = lines;
 		/* later we'll move allocation of tables here */


-- 
Jean Delvare
