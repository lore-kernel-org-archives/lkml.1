Return-Path: <linux-kernel-owner+w=401wt.eu-S1753540AbYGXQIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbYGXQIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 12:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbYGXQIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 12:08:16 -0400
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:43019 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbYGXQIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 12:08:16 -0400
X-Cam-SpamDetails: Not scanned
X-Cam-AntiVirus: No virus found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4888A8E5.6050700@gmail.com>
Date: Thu, 24 Jul 2008 17:08:05 +0100
From: Jonathan Cameron <Jonathan.Cameron@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070423)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@osdl.org>, David Brownell <david-b@pacbell.net>
Subject: [patch 2.6.26] gpio: pcf857x handle pca9500 and pca9501
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Cameron <jic23@cam.ac.uk>
Addition of pca9500 and pca9501 chips to the pcf857x driver.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.u>
--
These two chips have two elements (on different i2c addresses), the first is a clone
of the pcf8574 and the second 2kBit eeprom. Seems easiest to support these separately
so main query about this patch is should the device naming reflect this dual
functionality. 

I've been using the pcf857x driver with a 9500 for several months without problems and
just want this in to clean up a confusing element in a board config.

As the Kconfig title for these is getting a bit long and the datasheet for these starts
with stating they are pcf957x compatible so I haven't changed it.
--
diff -uprN -X a/Documentation/dontdiff a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
--- a/drivers/gpio/Kconfig	2008-07-24 16:55:57.000000000 +0100
+++ b/drivers/gpio/Kconfig	2008-07-24 16:51:45.000000000 +0100
@@ -54,6 +54,7 @@ config GPIO_PCF857X
 	  some of them.  Compatible models include:
 
 	  8 bits:   pcf8574, pcf8574a, pca8574, pca8574a,
+	    	    pca9500, pca9501,
 	            pca9670, pca9672, pca9674, pca9674a,
 	  	    max7328, max7329
 
diff -uprN -X a/Documentation/dontdiff a/drivers/gpio/pcf857x.c b/drivers/gpio/pcf857x.c
--- a/drivers/gpio/pcf857x.c	2008-07-24 16:55:57.000000000 +0100
+++ b/drivers/gpio/pcf857x.c	2008-07-24 16:56:51.000000000 +0100
@@ -29,6 +29,8 @@
 static const struct i2c_device_id pcf857x_id[] = {
 	{ "pcf8574", 8 },
 	{ "pca8574", 8 },
+	{ "pca9500", 8 },
+	{ "pca9501", 8 },
 	{ "pca9670", 8 },
 	{ "pca9672", 8 },
 	{ "pca9674", 8 },
@@ -44,9 +46,9 @@ static const struct i2c_device_id pcf857
 MODULE_DEVICE_TABLE(i2c, pcf857x_id);
 
 /*
- * The pcf857x, pca857x, and pca967x chips only expose one read and one
- * write register.  Writing a "one" bit (to match the reset state) lets
- * that pin be used as an input; it's not an open-drain model, but acts
+ * The pcf857x, pca857x, pca950x and pca967x chips only expose one read
+ * and one write register.  Writing a "one" bit (to match the reset state)
+ * lets that pin be used as an input; it's not an open-drain model, but acts
  * a bit like one.  This is described as "quasi-bidirectional"; read the
  * chip documentation for details.
  *
