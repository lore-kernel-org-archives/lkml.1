Return-Path: <linux-kernel-owner+w=401wt.eu-S1754093AbZCHTVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbZCHTVW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 15:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752913AbZCHTVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 15:21:12 -0400
Received: from mail-fx0-f176.google.com ([209.85.220.176]:56515 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbZCHTVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 15:21:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:disposition-notification-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=iIsp8oZ9Yo4EzqJTRWURfzQPeyXapV8BXH+GUlIKx2zOlqt1oOlPIUvZSDTgAEWE0x
         d1sKW05fGm+DJEnn2duop0CSPmouZdU4b2sDXyec24em65ib0Lz91y128NryZPEfEbIK
         VI0IFQqxND0MbLcfTAy7xD5PmSsVgc/NQVmhs=
From: Leonardo Potenza <leo.potenza@gmail.com>
To: kernel-janitors@vger.kernel.org
Subject: [PATCH] drivers/gpio: fix section mismatch warnings in twl4030-gpio.c
Date: Sun, 8 Mar 2009 20:17:34 +0100
User-Agent: KMail/1.9.9
Cc: hskinnemoen@atmel.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903082017.35072.lpotenza@inwind.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Leonardo Potenza <lpotenza@inwind.it>

Removed the __devexit annotation of gpio_twl4030_remove(), in order to suppress the following section mismatch messages:

WARNING: drivers/gpio/built-in.o(.devinit.text+0xa0b): Section mismatch in reference from the function gpio_twl4030_probe() to the function .devexit.text:gpio_twl4030_remove()
The function __devinit gpio_twl4030_probe() references
a function __devexit gpio_twl4030_remove().
This is often seen when error handling in the init function
uses functionality in the exit path.
The fix is often to remove the __devexit annotation of
gpio_twl4030_remove() so it may be used outside an exit section.

WARNING: drivers/built-in.o(.devinit.text+0xa0b): Section mismatch in reference from the function gpio_twl4030_probe() to the function .devexit.text:gpio_twl4030_remove()
The function __devinit gpio_twl4030_probe() references
a function __devexit gpio_twl4030_remove().
This is often seen when error handling in the init function
uses functionality in the exit path.
The fix is often to remove the __devexit annotation of
gpio_twl4030_remove() so it may be used outside an exit section.

WARNING: vmlinux.o(.devinit.text+0x1702): Section mismatch in reference from the function gpio_twl4030_probe() to the function .devexit.text:gpio_twl4030_remove()
The function __devinit gpio_twl4030_probe() references
a function __devexit gpio_twl4030_remove().
This is often seen when error handling in the init function
uses functionality in the exit path.
The fix is often to remove the __devexit annotation of
gpio_twl4030_remove() so it may be used outside an exit section.

Signed-off-by: Leonardo Potenza <lpotenza@inwind.it>
---
Index: linux-2.6/drivers/gpio/twl4030-gpio.c
===================================================================
--- linux-2.6.orig/drivers/gpio/twl4030-gpio.c	2009-03-08 19:23:06.000000000 +0100
+++ linux-2.6/drivers/gpio/twl4030-gpio.c	2009-03-08 20:07:41.000000000 +0100
@@ -460,7 +460,7 @@ no_irqs:
 	return ret;
 }
 
-static int __devexit gpio_twl4030_remove(struct platform_device *pdev)
+static int gpio_twl4030_remove(struct platform_device *pdev)
 {
 	struct twl4030_gpio_platform_data *pdata = pdev->dev.platform_data;
 	int status;
@@ -493,7 +493,7 @@ static struct platform_driver gpio_twl40
 	.driver.name	= "twl4030_gpio",
 	.driver.owner	= THIS_MODULE,
 	.probe		= gpio_twl4030_probe,
-	.remove		= __devexit_p(gpio_twl4030_remove),
+	.remove		= gpio_twl4030_remove,
 };
 
 static int __init gpio_twl4030_init(void)
