Return-Path: <linux-kernel-owner+w=401wt.eu-S1757080AbZCVXwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080AbZCVXwq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 19:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756156AbZCVXwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 19:52:35 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:60849 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbZCVXwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 19:52:34 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Eric Piel <eric.piel@tremplin-utc.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/3] lis3: reorder functions to make forward decl obsolete
Date: Mon, 23 Mar 2009 00:51:25 +0100
Message-Id: <1237765887-32672-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090322234248.GG22927@buzzloop.caiaq.de>
References: <20090322234248.GG22927@buzzloop.caiaq.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

moved lis3lv02d_init_device() down so that the forward declaration of
lis3lv02d_add_fs() becomes unnecessary.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/hwmon/lis3lv02d.c |   64 +++++++++++++++++++++-----------------------
 1 files changed, 31 insertions(+), 33 deletions(-)

diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
index 4888ac5..eeae7c9 100644
--- a/drivers/hwmon/lis3lv02d.c
+++ b/drivers/hwmon/lis3lv02d.c
@@ -59,8 +59,6 @@ struct acpi_lis3lv02d lis3_dev = {
 
 EXPORT_SYMBOL_GPL(lis3_dev);
 
-static int lis3lv02d_add_fs(struct acpi_device *device);
-
 static s16 lis3lv02d_read_16(acpi_handle handle, int reg)
 {
 	u8 lo, hi;
@@ -377,37 +375,6 @@ void lis3lv02d_joystick_disable(void)
 }
 EXPORT_SYMBOL_GPL(lis3lv02d_joystick_disable);
 
-/*
- * Initialise the accelerometer and the various subsystems.
- * Should be rather independant of the bus system.
- */
-int lis3lv02d_init_device(struct acpi_lis3lv02d *dev)
-{
-	mutex_init(&dev->lock);
-	lis3lv02d_add_fs(dev->device);
-	lis3lv02d_increase_use(dev);
-
-	if (lis3lv02d_joystick_enable())
-		printk(KERN_ERR DRIVER_NAME ": joystick initialization failed\n");
-
-	printk("lis3_init_device: irq %d\n", dev->irq);
-
-	/* if we did not get an IRQ from ACPI - we have nothing more to do */
-	if (!dev->irq) {
-		printk(KERN_ERR DRIVER_NAME
-			": No IRQ in ACPI. Disabling /dev/freefall\n");
-		goto out;
-	}
-
-	printk("lis3: registering device\n");
-	if (misc_register(&lis3lv02d_misc_device))
-		printk(KERN_ERR DRIVER_NAME ": misc_register failed\n");
-out:
-	lis3lv02d_decrease_use(dev);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(lis3lv02d_init_device);
-
 /* Sysfs stuff */
 static ssize_t lis3lv02d_position_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
@@ -485,6 +452,37 @@ int lis3lv02d_remove_fs(void)
 }
 EXPORT_SYMBOL_GPL(lis3lv02d_remove_fs);
 
+/*
+ * Initialise the accelerometer and the various subsystems.
+ * Should be rather independant of the bus system.
+ */
+int lis3lv02d_init_device(struct acpi_lis3lv02d *dev)
+{
+	mutex_init(&dev->lock);
+	lis3lv02d_add_fs(dev->device);
+	lis3lv02d_increase_use(dev);
+
+	if (lis3lv02d_joystick_enable())
+		printk(KERN_ERR DRIVER_NAME ": joystick initialization failed\n");
+
+	printk("lis3_init_device: irq %d\n", dev->irq);
+
+	/* if we did not get an IRQ from ACPI - we have nothing more to do */
+	if (!dev->irq) {
+		printk(KERN_ERR DRIVER_NAME
+			": No IRQ in ACPI. Disabling /dev/freefall\n");
+		goto out;
+	}
+
+	printk("lis3: registering device\n");
+	if (misc_register(&lis3lv02d_misc_device))
+		printk(KERN_ERR DRIVER_NAME ": misc_register failed\n");
+out:
+	lis3lv02d_decrease_use(dev);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(lis3lv02d_init_device);
+
 MODULE_DESCRIPTION("ST LIS3LV02Dx three-axis digital accelerometer driver");
 MODULE_AUTHOR("Yan Burman, Eric Piel, Pavel Machek");
 MODULE_LICENSE("GPL");
-- 
1.6.2

