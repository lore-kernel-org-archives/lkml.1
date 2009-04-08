Return-Path: <linux-kernel-owner+w=401wt.eu-S1761804AbZDHOs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761804AbZDHOs3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 10:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbZDHOsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:48:16 -0400
Received: from flounder.pepperfish.net ([87.237.62.181]:57224 "EHLO
	flounder.pepperfish.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbZDHOsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:48:15 -0400
Subject: PCA953x: Support GPIOLIB GPIO naming
From: Daniel Silverstone <dsilvers@simtec.co.uk>
Reply-To: dsilvers@simtec.co.uk
To: Ben Gardner <bgardner@wabtec.com>
Cc: Linux I2C <linux-i2c@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: Simtec Electronics
Date: Wed, 08 Apr 2009 15:48:12 +0100
Message-Id: <1239202092.21238.20.camel@petitemort>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support to the PCA953x driver to use the GPIOLIB
naming facility for GPIOs.

Signed-off-by: Daniel Silverstone <dsilvers@simtec.co.uk>

Index: linux-2.6.27/drivers/gpio/pca953x.c
===================================================================
--- linux-2.6.27.orig/drivers/gpio/pca953x.c	2008-12-11 13:09:44.287305039 +0000
+++ linux-2.6.27/drivers/gpio/pca953x.c	2008-12-11 13:53:54.283301612 +0000
@@ -45,6 +45,7 @@
 
 	struct i2c_client *client;
 	struct gpio_chip gpio_chip;
+	char **names;
 };
 
 /* NOTE:  we can't currently rely on fault codes to come from SMBus
@@ -190,6 +191,7 @@
 	gc->label = chip->client->name;
 	gc->dev = &chip->client->dev;
 	gc->owner = THIS_MODULE;
+	gc->names = chip->names;
 }
 
 static int __devinit pca953x_probe(struct i2c_client *client,
@@ -211,6 +213,8 @@
 
 	chip->gpio_start = pdata->gpio_base;
 
+	chip->names = pdata->names;
+
 	/* initialize cached registers from their original values.
 	 * we can't share this chip with another i2c master.
 	 */
Index: linux-2.6.27/include/linux/i2c/pca953x.h
===================================================================
--- linux-2.6.27.orig/include/linux/i2c/pca953x.h	2008-12-11 13:09:55.307306141 +0000
+++ linux-2.6.27/include/linux/i2c/pca953x.h	2008-12-11 13:55:53.139301080 +0000
@@ -15,4 +15,5 @@
 	int		(*teardown)(struct i2c_client *client,
 				unsigned gpio, unsigned ngpio,
 				void *context);
+	char		**names;
 };

-- 
Daniel Silverstone                              http://www.simtec.co.uk/
PGP mail accepted and encouraged.            Key Id: 2BC8 4016 2068 7895


