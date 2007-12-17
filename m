Return-Path: <linux-kernel-owner+w=401wt.eu-S1757409AbXLQGdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409AbXLQGdh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 01:33:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757646AbXLQGd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 01:33:29 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:30480 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757326AbXLQGd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 01:33:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AXuasvPqv6cqSKXiN8AFKxF/DatmsMtu5qJr6A1GuFmcXu9dHasHKEsrcz2i0awietFKQeqygAjJevkt5Una/WA09JKkg4FVz6nNCZPxmV/b/IkJhX1vLyuQzZpqmWNeUdPqFeJBxDgZH8FL34tC+khb7ANKvT1ZIiqaC5a7Jq0=
Message-ID: <f17812d70712162233h759432a9i15b8e12d1a5fb828@mail.gmail.com>
Date: Mon, 17 Dec 2007 14:33:27 +0800
From: "eric miao" <eric.y.miao@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: [PATCH 2.6.24-rc5-mm 3/3] gpiolib: obsolete drivers/i2c/chips/pca9539.c
Cc: "Linux Kernel list" <linux-kernel@vger.kernel.org>, i2c@lm-sensors.org,
       "David Brownell" <david-b@pacbell.net>,
       "Ben Gardner" <bgardner@wabtec.com>
In-Reply-To: <20071216204214.01fd7a16@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f17812d70712142016q73abffc2w99174c40f847152c@mail.gmail.com>
	 <20071216204214.01fd7a16@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Updated according to Jean's suggestion, thanks ]

>From 5b4d907da17d57ec168643ebd847278e8d7267f9 Mon Sep 17 00:00:00 2001
From: eric miao <eric.miao@marvell.com>
Date: Sat, 15 Dec 2007 12:07:26 +0800
Subject: [PATCH] gpiolib: obsolete drivers/i2c/chips/pca9539.c and related files

for the following reasons:

1. there is currently no known users of this driver

2. the functionality of this driver is well supported with the recent
   proposed drivers/gpio/pca9539.c, using GPIO_LIB

Signed-off-by: eric miao <eric.miao@marvell.com>
Acked-by: Ben Gardner <bgardner@wabtec.com>
---
 Documentation/i2c/chips/pca9539 |   47 ---------
 drivers/i2c/chips/Kconfig       |   10 --
 drivers/i2c/chips/Makefile      |    1 -
 drivers/i2c/chips/pca9539.c     |  196 ---------------------------------------
 4 files changed, 0 insertions(+), 254 deletions(-)
 delete mode 100644 Documentation/i2c/chips/pca9539
 delete mode 100644 drivers/i2c/chips/pca9539.c

diff --git a/Documentation/i2c/chips/pca9539 b/Documentation/i2c/chips/pca9539
deleted file mode 100644
index c4fce6a..0000000
--- a/Documentation/i2c/chips/pca9539
+++ /dev/null
@@ -1,47 +0,0 @@
-Kernel driver pca9539
-=====================
-
-Supported chips:
-  * Philips PCA9539
-    Prefix: 'pca9539'
-    Addresses scanned: 0x74 - 0x77
-    Datasheet:
-        http://www.semiconductors.philips.com/acrobat/datasheets/PCA9539_2.pdf
-
-Author: Ben Gardner <bgardner@wabtec.com>
-
-
-Description
------------
-
-The Philips PCA9539 is a 16 bit low power I/O device.
-All 16 lines can be individually configured as an input or output.
-The input sense can also be inverted.
-The 16 lines are split between two bytes.
-
-
-Sysfs entries
--------------
-
-Each is a byte that maps to the 8 I/O bits.
-A '0' suffix is for bits 0-7, while '1' is for bits 8-15.
-
-input[01]     - read the current value
-output[01]    - sets the output value
-direction[01] - direction of each bit: 1=input, 0=output
-invert[01]    - toggle the input bit sense
-
-input reads the actual state of the line and is always available.
-The direction defaults to input for all channels.
-
-
-General Remarks
----------------
-
-Note that each output, direction, and invert entry controls 8 lines.
-You should use the read, modify, write sequence.
-For example. to set output bit 0 of 1.
-  val=$(cat output0)
-  val=$(( $val | 1 ))
-  echo $val > output0
-
diff --git a/drivers/i2c/chips/Kconfig b/drivers/i2c/chips/Kconfig
index 2e1c24f..a676f57 100644
--- a/drivers/i2c/chips/Kconfig
+++ b/drivers/i2c/chips/Kconfig
@@ -65,16 +65,6 @@ config SENSORS_PCF8574
 	  These devices are hard to detect and rarely found on mainstream
 	  hardware.  If unsure, say N.

-config SENSORS_PCA9539
-	tristate "Philips PCA9539 16-bit I/O port"
-	depends on EXPERIMENTAL
-	help
-	  If you say yes here you get support for the Philips PCA9539
-	  16-bit I/O port.
-
-	  This driver can also be built as a module.  If so, the module
-	  will be called pca9539.
-
 config SENSORS_PCF8591
 	tristate "Philips PCF8591"
 	depends on EXPERIMENTAL
diff --git a/drivers/i2c/chips/Makefile b/drivers/i2c/chips/Makefile
index ca924e1..bc9e9ca 100644
--- a/drivers/i2c/chips/Makefile
+++ b/drivers/i2c/chips/Makefile
@@ -8,7 +8,6 @@ obj-$(CONFIG_DS1682)		+= ds1682.o
 obj-$(CONFIG_SENSORS_EEPROM)	+= eeprom.o
 obj-$(CONFIG_SENSORS_MAX6875)	+= max6875.o
 obj-$(CONFIG_SENSORS_M41T00)	+= m41t00.o
-obj-$(CONFIG_SENSORS_PCA9539)	+= pca9539.o
 obj-$(CONFIG_SENSORS_PCF8574)	+= pcf8574.o
 obj-$(CONFIG_SENSORS_PCF8591)	+= pcf8591.o
 obj-$(CONFIG_ISP1301_OMAP)	+= isp1301_omap.o
diff --git a/drivers/i2c/chips/pca9539.c b/drivers/i2c/chips/pca9539.c
deleted file mode 100644
index f43c4e7..0000000
--- a/drivers/i2c/chips/pca9539.c
+++ /dev/null
@@ -1,196 +0,0 @@
-/*
-    pca9539.c - 16-bit I/O port with interrupt and reset
-
-    Copyright (C) 2005 Ben Gardner <bgardner@wabtec.com>
-
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; version 2 of the License.
-*/
-
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/slab.h>
-#include <linux/i2c.h>
-#include <linux/hwmon-sysfs.h>
-
-/* Addresses to scan */
-static unsigned short normal_i2c[] = {0x74, 0x75, 0x76, 0x77, I2C_CLIENT_END};
-
-/* Insmod parameters */
-I2C_CLIENT_INSMOD_1(pca9539);
-
-enum pca9539_cmd
-{
-	PCA9539_INPUT_0		= 0,
-	PCA9539_INPUT_1		= 1,
-	PCA9539_OUTPUT_0	= 2,
-	PCA9539_OUTPUT_1	= 3,
-	PCA9539_INVERT_0	= 4,
-	PCA9539_INVERT_1	= 5,
-	PCA9539_DIRECTION_0	= 6,
-	PCA9539_DIRECTION_1	= 7,
-};
-
-static int pca9539_attach_adapter(struct i2c_adapter *adapter);
-static int pca9539_detect(struct i2c_adapter *adapter, int address, int kind);
-static int pca9539_detach_client(struct i2c_client *client);
-
-/* This is the driver that will be inserted */
-static struct i2c_driver pca9539_driver = {
-	.driver = {
-		.name	= "pca9539",
-	},
-	.attach_adapter	= pca9539_attach_adapter,
-	.detach_client	= pca9539_detach_client,
-};
-
-struct pca9539_data {
-	struct i2c_client client;
-};
-
-/* following are the sysfs callback functions */
-static ssize_t pca9539_show(struct device *dev, struct device_attribute *attr,
-			    char *buf)
-{
-	struct sensor_device_attribute *psa = to_sensor_dev_attr(attr);
-	struct i2c_client *client = to_i2c_client(dev);
-	return sprintf(buf, "%d\n", i2c_smbus_read_byte_data(client,
-							     psa->index));
-}
-
-static ssize_t pca9539_store(struct device *dev, struct device_attribute *attr,
-			     const char *buf, size_t count)
-{
-	struct sensor_device_attribute *psa = to_sensor_dev_attr(attr);
-	struct i2c_client *client = to_i2c_client(dev);
-	unsigned long val = simple_strtoul(buf, NULL, 0);
-	if (val > 0xff)
-		return -EINVAL;
-	i2c_smbus_write_byte_data(client, psa->index, val);
-	return count;
-}
-
-/* Define the device attributes */
-
-#define PCA9539_ENTRY_RO(name, cmd_idx) \
-	static SENSOR_DEVICE_ATTR(name, S_IRUGO, pca9539_show, NULL, cmd_idx)
-
-#define PCA9539_ENTRY_RW(name, cmd_idx) \
-	static SENSOR_DEVICE_ATTR(name, S_IRUGO | S_IWUSR, pca9539_show, \
-				  pca9539_store, cmd_idx)
-
-PCA9539_ENTRY_RO(input0, PCA9539_INPUT_0);
-PCA9539_ENTRY_RO(input1, PCA9539_INPUT_1);
-PCA9539_ENTRY_RW(output0, PCA9539_OUTPUT_0);
-PCA9539_ENTRY_RW(output1, PCA9539_OUTPUT_1);
-PCA9539_ENTRY_RW(invert0, PCA9539_INVERT_0);
-PCA9539_ENTRY_RW(invert1, PCA9539_INVERT_1);
-PCA9539_ENTRY_RW(direction0, PCA9539_DIRECTION_0);
-PCA9539_ENTRY_RW(direction1, PCA9539_DIRECTION_1);
-
-static struct attribute *pca9539_attributes[] = {
-	&sensor_dev_attr_input0.dev_attr.attr,
-	&sensor_dev_attr_input1.dev_attr.attr,
-	&sensor_dev_attr_output0.dev_attr.attr,
-	&sensor_dev_attr_output1.dev_attr.attr,
-	&sensor_dev_attr_invert0.dev_attr.attr,
-	&sensor_dev_attr_invert1.dev_attr.attr,
-	&sensor_dev_attr_direction0.dev_attr.attr,
-	&sensor_dev_attr_direction1.dev_attr.attr,
-	NULL
-};
-
-static struct attribute_group pca9539_defattr_group = {
-	.attrs = pca9539_attributes,
-};
-
-static int pca9539_attach_adapter(struct i2c_adapter *adapter)
-{
-	return i2c_probe(adapter, &addr_data, pca9539_detect);
-}
-
-/* This function is called by i2c_probe */
-static int pca9539_detect(struct i2c_adapter *adapter, int address, int kind)
-{
-	struct i2c_client *new_client;
-	struct pca9539_data *data;
-	int err = 0;
-
-	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
-		goto exit;
-
-	/* OK. For now, we presume we have a valid client. We now create the
-	   client structure, even though we cannot fill it completely yet. */
-	if (!(data = kzalloc(sizeof(struct pca9539_data), GFP_KERNEL))) {
-		err = -ENOMEM;
-		goto exit;
-	}
-
-	new_client = &data->client;
-	i2c_set_clientdata(new_client, data);
-	new_client->addr = address;
-	new_client->adapter = adapter;
-	new_client->driver = &pca9539_driver;
-	new_client->flags = 0;
-
-	if (kind < 0) {
-		/* Detection: the pca9539 only has 8 registers (0-7).
-		   A read of 7 should succeed, but a read of 8 should fail. */
-		if ((i2c_smbus_read_byte_data(new_client, 7) < 0) ||
-		    (i2c_smbus_read_byte_data(new_client, 8) >= 0))
-			goto exit_kfree;
-	}
-
-	strlcpy(new_client->name, "pca9539", I2C_NAME_SIZE);
-
-	/* Tell the I2C layer a new client has arrived */
-	if ((err = i2c_attach_client(new_client)))
-		goto exit_kfree;
-
-	/* Register sysfs hooks */
-	err = sysfs_create_group(&new_client->dev.kobj,
-				 &pca9539_defattr_group);
-	if (err)
-		goto exit_detach;
-
-	return 0;
-
-exit_detach:
-	i2c_detach_client(new_client);
-exit_kfree:
-	kfree(data);
-exit:
-	return err;
-}
-
-static int pca9539_detach_client(struct i2c_client *client)
-{
-	int err;
-
-	sysfs_remove_group(&client->dev.kobj, &pca9539_defattr_group);
-
-	if ((err = i2c_detach_client(client)))
-		return err;
-
-	kfree(i2c_get_clientdata(client));
-	return 0;
-}
-
-static int __init pca9539_init(void)
-{
-	return i2c_add_driver(&pca9539_driver);
-}
-
-static void __exit pca9539_exit(void)
-{
-	i2c_del_driver(&pca9539_driver);
-}
-
-MODULE_AUTHOR("Ben Gardner <bgardner@wabtec.com>");
-MODULE_DESCRIPTION("PCA9539 driver");
-MODULE_LICENSE("GPL");
-
-module_init(pca9539_init);
-module_exit(pca9539_exit);
-
-- 
1.5.2.5.GIT

---
Cheers
- eric
