Return-Path: <linux-kernel-owner+w=401wt.eu-S932931AbXBTOp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931AbXBTOp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 09:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932947AbXBTOp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 09:45:28 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:42380 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932931AbXBTOp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 09:45:28 -0500
Date: Tue, 20 Feb 2007 15:45:21 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: "Adrian `trivial' Bunk" <bunk@stusta.de>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] tty_register_driver: Remove incorrect and superfluous cast
Message-ID: <Pine.LNX.4.62.0702201542510.10709@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

tty_register_driver: Remove incorrect and superfluous cast (expected and passed
types are both const char *)

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

--- ps3-linux-2.6.20.orig/drivers/char/tty_io.c
+++ ps3-linux-2.6.20/drivers/char/tty_io.c
@@ -3713,15 +3713,14 @@ int tty_register_driver(struct tty_drive
 
 	if (!driver->major) {
 		error = alloc_chrdev_region(&dev, driver->minor_start, driver->num,
-						(char*)driver->name);
+						driver->name);
 		if (!error) {
 			driver->major = MAJOR(dev);
 			driver->minor_start = MINOR(dev);
 		}
 	} else {
 		dev = MKDEV(driver->major, driver->minor_start);
-		error = register_chrdev_region(dev, driver->num,
-						(char*)driver->name);
+		error = register_chrdev_region(dev, driver->num, driver->name);
 	}
 	if (error < 0) {
 		kfree(p);

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium
