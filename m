Return-Path: <linux-kernel-owner+w=401wt.eu-S1758938AbXEYLop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938AbXEYLop (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 07:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbXEYLok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 07:44:40 -0400
Received: from smtp-105-friday.noc.nerim.net ([62.4.17.105]:3466 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750944AbXEYLoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 07:44:39 -0400
Date: Fri, 25 May 2007 13:45:45 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>
Subject: [PATCH v2] tty_io: Use kzalloc
Message-ID: <20070525134545.64bee1f3@hyperion.delvare>
In-Reply-To: <20070525134344.0f93e797@hyperion.delvare>
References: <20070525124258.5b72f077@hyperion.delvare>
	<84144f020705250345x4faa23f7kc6276017285357e8@mail.gmail.com>
	<20070525134344.0f93e797@hyperion.delvare>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Also remove needless casts.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 drivers/char/tty_io.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- linux-2.6.22-rc2.orig/drivers/char/tty_io.c	2007-05-25 09:09:28.000000000 +0200
+++ linux-2.6.22-rc2/drivers/char/tty_io.c	2007-05-25 13:41:32.000000000 +0200
@@ -2009,11 +2009,9 @@ static int init_dev(struct tty_driver *d
 	}
 
 	if (!*ltp_loc) {
-		ltp = (struct ktermios *) kmalloc(sizeof(struct ktermios),
-						 GFP_KERNEL);
+		ltp = kzalloc(sizeof(struct ktermios), GFP_KERNEL);
 		if (!ltp)
 			goto free_mem_out;
-		memset(ltp, 0, sizeof(struct ktermios));
 	}
 
 	if (driver->type == TTY_DRIVER_TYPE_PTY) {
@@ -2042,11 +2040,9 @@ static int init_dev(struct tty_driver *d
 		}
 
 		if (!*o_ltp_loc) {
-			o_ltp = (struct ktermios *)
-				kmalloc(sizeof(struct ktermios), GFP_KERNEL);
+			o_ltp = kzalloc(sizeof(struct ktermios), GFP_KERNEL);
 			if (!o_ltp)
 				goto free_mem_out;
-			memset(o_ltp, 0, sizeof(struct ktermios));
 		}
 
 		/*
@@ -3732,9 +3728,8 @@ struct tty_driver *alloc_tty_driver(int 
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
