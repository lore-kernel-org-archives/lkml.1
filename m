Return-Path: <linux-kernel-owner+w=401wt.eu-S1757966AbZIPAM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966AbZIPAM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 20:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754001AbZIPAM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 20:12:26 -0400
Received: from exprod6og104.obsmtp.com ([64.18.1.187]:54389 "HELO
	exprod6og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753795AbZIPAM0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 20:12:26 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] locomo.c: CodingStyle cleanups
Date: Tue, 15 Sep 2009 20:12:27 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901CBF2B3@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] locomo.c: CodingStyle cleanups
Thread-Index: Aco2YmAMu28Cdy0MSr+fhy8XqBL5cA==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
Cc: <lenz@cs.wisc.edu>
X-OriginalArrivalTime: 16 Sep 2009 00:12:28.0304 (UTC) FILETIME=[6040E100:01CA3662]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ARM] locomo.c: CodingStyle cleanups

EXPORT* macros should follow immediately after the closing function
brace line.

The prototype for locomo_chip_driver() is not needed since the static
(inline) function is located earlier in the file.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: John Lenz <lenz@cs.wisc.edu>

---

diff --git a/arch/arm/common/locomo.c b/arch/arm/common/locomo.c
index 2293f0c..bd36c77 100644
--- a/arch/arm/common/locomo.c
+++ b/arch/arm/common/locomo.c
@@ -865,6 +865,7 @@ void locomo_gpio_set_dir(struct device *dev, unsigned int bits, unsigned int dir
 
 	spin_unlock_irqrestore(&lchip->lock, flags);
 }
+EXPORT_SYMBOL(locomo_gpio_set_dir);
 
 int locomo_gpio_read_level(struct device *dev, unsigned int bits)
 {
@@ -882,6 +883,7 @@ int locomo_gpio_read_level(struct device *dev, unsigned int bits)
 	ret &= bits;
 	return ret;
 }
+EXPORT_SYMBOL(locomo_gpio_read_level);
 
 int locomo_gpio_read_output(struct device *dev, unsigned int bits)
 {
@@ -899,6 +901,7 @@ int locomo_gpio_read_output(struct device *dev, unsigned int bits)
 	ret &= bits;
 	return ret;
 }
+EXPORT_SYMBOL(locomo_gpio_read_output);
 
 void locomo_gpio_write(struct device *dev, unsigned int bits, unsigned int set)
 {
@@ -920,6 +923,7 @@ void locomo_gpio_write(struct device *dev, unsigned int bits, unsigned int set)
 
 	spin_unlock_irqrestore(&lchip->lock, flags);
 }
+EXPORT_SYMBOL(locomo_gpio_write);
 
 static void locomo_m62332_sendbit(void *mapbase, int bit)
 {
@@ -1084,13 +1088,12 @@ void locomo_m62332_senddata(struct locomo_dev *ldev, unsigned int dac_data, int
 
 	spin_unlock_irqrestore(&lchip->lock, flags);
 }
+EXPORT_SYMBOL(locomo_m62332_senddata);
 
 /*
  *	Frontlight control
  */
 
-static struct locomo *locomo_chip_driver(struct locomo_dev *ldev);
-
 void locomo_frontlight_set(struct locomo_dev *dev, int duty, int vr, int bpwf)
 {
 	unsigned long flags;
@@ -1182,11 +1185,13 @@ int locomo_driver_register(struct locomo_driver *driver)
 	driver->drv.bus = &locomo_bus_type;
 	return driver_register(&driver->drv);
 }
+EXPORT_SYMBOL(locomo_driver_register);
 
 void locomo_driver_unregister(struct locomo_driver *driver)
 {
 	driver_unregister(&driver->drv);
 }
+EXPORT_SYMBOL(locomo_driver_unregister);
 
 static int __init locomo_init(void)
 {
@@ -1208,11 +1213,3 @@ module_exit(locomo_exit);
 MODULE_DESCRIPTION("Sharp LoCoMo core driver");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("John Lenz <lenz@cs.wisc.edu>");
-
-EXPORT_SYMBOL(locomo_driver_register);
-EXPORT_SYMBOL(locomo_driver_unregister);
-EXPORT_SYMBOL(locomo_gpio_set_dir);
-EXPORT_SYMBOL(locomo_gpio_read_level);
-EXPORT_SYMBOL(locomo_gpio_read_output);
-EXPORT_SYMBOL(locomo_gpio_write);
-EXPORT_SYMBOL(locomo_m62332_senddata); 
