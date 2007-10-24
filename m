Return-Path: <linux-kernel-owner+w=401wt.eu-S1763281AbXJXQjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763281AbXJXQjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756060AbXJXQZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:25:03 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:60948 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754965AbXJXQZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:25:00 -0400
Date: Wed, 24 Oct 2007 18:25:28 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: i2c@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] some overdue I2C driver removal
Message-ID: <20071024162528.GX30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the overdue removal of three I2C drivers.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 Documentation/feature-removal-schedule.txt |    8 
 drivers/i2c/busses/Kconfig                 |   59 ------
 drivers/i2c/busses/Makefile                |    3 
 drivers/i2c/busses/i2c-ixp2000.c           |  167 -------------------
 drivers/i2c/busses/i2c-ixp4xx.c            |  178 ---------------------
 drivers/i2c/busses/scx200_i2c.c            |  131 ---------------
 6 files changed, 546 deletions(-)

6a8e0e37019c0ffeb0071fae30210baf2c3bdd75 
diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 2af3835..9114379 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -218,14 +218,6 @@ Who:	Len Brown <len.brown@intel.com>
 
 ---------------------------
 
-What:	i2c-ixp2000, i2c-ixp4xx and scx200_i2c drivers
-When:	September 2007
-Why:	Obsolete. The new i2c-gpio driver replaces all hardware-specific
-	I2C-over-GPIO drivers.
-Who:	Jean Delvare <khali@linux-fr.org>
-
----------------------------
-
 What:	'time' kernel boot parameter
 When:	January 2008
 Why:	replaced by 'printk.time=<value>' so that printk timestamps can be
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index c466c6c..1b1a1d7 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -259,34 +259,6 @@ config I2C_IOP3XX
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-iop3xx.
 
-config I2C_IXP4XX
-	tristate "IXP4xx GPIO-Based I2C Interface (DEPRECATED)"
-	depends on ARCH_IXP4XX
-	select I2C_ALGOBIT
-	help
-	  Say Y here if you have an Intel IXP4xx(420,421,422,425) based 
-	  system and are using GPIO lines for an I2C bus.
-
-	  This support is also available as a module. If so, the module
-	  will be called i2c-ixp4xx.
-
-	  This driver is deprecated and will be dropped soon. Use i2c-gpio
-	  instead.
-
-config I2C_IXP2000
-	tristate "IXP2000 GPIO-Based I2C Interface (DEPRECATED)"
-	depends on ARCH_IXP2000
-	select I2C_ALGOBIT
-	help
-	  Say Y here if you have an Intel IXP2000 (2400, 2800, 2850) based 
-	  system and are using GPIO lines for an I2C bus.
-
-	  This support is also available as a module. If so, the module
-	  will be called i2c-ixp2000.
-
-	  This driver is deprecated and will be dropped soon. Use i2c-gpio
-	  instead.
-
 config I2C_POWERMAC
 	tristate "Powermac I2C interface"
 	depends on PPC_PMAC
@@ -446,37 +418,6 @@ config I2C_SIMTEC
 	  This driver can also be built as a module. If so, the module
 	  will be called i2c-simtec.
 
-config SCx200_I2C
-	tristate "NatSemi SCx200 I2C using GPIO pins (DEPRECATED)"
-	depends on SCx200_GPIO
-	select I2C_ALGOBIT
-	help
-	  Enable the use of two GPIO pins of a SCx200 processor as an I2C bus.
-
-	  If you don't know what to do here, say N.
-
-	  This support is also available as a module.  If so, the module 
-	  will be called scx200_i2c.
-
-	  This driver is deprecated and will be dropped soon. Use i2c-gpio
-	  (or scx200_acb) instead.
-
-config SCx200_I2C_SCL
-	int "GPIO pin used for SCL"
-	depends on SCx200_I2C
-	default "12"
-	help
-	  Enter the GPIO pin number used for the SCL signal.  This value can
-	  also be specified with a module parameter.
-
-config SCx200_I2C_SDA
-	int "GPIO pin used for SDA"
-	depends on SCx200_I2C
-	default "13"
-	help
-	  Enter the GPIO pin number used for the SSA signal.  This value can
-	  also be specified with a module parameter.
-
 config SCx200_ACB
 	tristate "Geode ACCESS.bus support"
 	depends on X86_32 && PCI
diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
index 81d43c2..7141e4a 100644
--- a/drivers/i2c/busses/Makefile
+++ b/drivers/i2c/busses/Makefile
@@ -19,8 +19,6 @@ obj-$(CONFIG_I2C_I801)		+= i2c-i801.o
 obj-$(CONFIG_I2C_I810)		+= i2c-i810.o
 obj-$(CONFIG_I2C_IBM_IIC)	+= i2c-ibm_iic.o
 obj-$(CONFIG_I2C_IOP3XX)	+= i2c-iop3xx.o
-obj-$(CONFIG_I2C_IXP2000)	+= i2c-ixp2000.o
-obj-$(CONFIG_I2C_IXP4XX)	+= i2c-ixp4xx.o
 obj-$(CONFIG_I2C_POWERMAC)	+= i2c-powermac.o
 obj-$(CONFIG_I2C_MPC)		+= i2c-mpc.o
 obj-$(CONFIG_I2C_MV64XXX)	+= i2c-mv64xxx.o
@@ -52,7 +50,6 @@ obj-$(CONFIG_I2C_VIA)		+= i2c-via.o
 obj-$(CONFIG_I2C_VIAPRO)	+= i2c-viapro.o
 obj-$(CONFIG_I2C_VOODOO3)	+= i2c-voodoo3.o
 obj-$(CONFIG_SCx200_ACB)	+= scx200_acb.o
-obj-$(CONFIG_SCx200_I2C)	+= scx200_i2c.o
 
 ifeq ($(CONFIG_I2C_DEBUG_BUS),y)
 EXTRA_CFLAGS += -DDEBUG
diff --git a/drivers/i2c/busses/i2c-ixp2000.c b/drivers/i2c/busses/i2c-ixp2000.c
deleted file mode 100644
index 6352121..0000000
--- a/drivers/i2c/busses/i2c-ixp2000.c
+++ /dev/null
@@ -1,167 +0,0 @@
-/*
- * drivers/i2c/busses/i2c-ixp2000.c
- *
- * I2C adapter for IXP2000 systems using GPIOs for I2C bus
- *
- * Author: Deepak Saxena <dsaxena@plexity.net>
- * Based on IXDP2400 code by: Naeem M. Afzal <naeem.m.afzal@intel.com>
- * Made generic by: Jeff Daly <jeffrey.daly@intel.com>
- *
- * Copyright (c) 2003-2004 MontaVista Software Inc.
- *
- * This file is licensed under  the terms of the GNU General Public 
- * License version 2. This program is licensed "as is" without any 
- * warranty of any kind, whether express or implied.
- *
- * From Jeff Daly:
- *
- * I2C adapter driver for Intel IXDP2xxx platforms. This should work for any
- * IXP2000 platform if it uses the HW GPIO in the same manner.  Basically, 
- * SDA and SCL GPIOs have external pullups.  Setting the respective GPIO to 
- * an input will make the signal a '1' via the pullup.  Setting them to 
- * outputs will pull them down. 
- *
- * The GPIOs are open drain signals and are used as configuration strap inputs
- * during power-up so there's generally a buffer on the board that needs to be 
- * 'enabled' to drive the GPIOs.
- */
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/platform_device.h>
-#include <linux/module.h>
-#include <linux/i2c.h>
-#include <linux/i2c-algo-bit.h>
-
-#include <asm/hardware.h>	/* Pick up IXP2000-specific bits */
-#include <asm/arch/gpio.h>
-
-static inline int ixp2000_scl_pin(void *data)
-{
-	return ((struct ixp2000_i2c_pins*)data)->scl_pin;
-}
-
-static inline int ixp2000_sda_pin(void *data)
-{
-	return ((struct ixp2000_i2c_pins*)data)->sda_pin;
-}
-
-
-static void ixp2000_bit_setscl(void *data, int val)
-{
-	int i = 5000;
-
-	if (val) {
-		gpio_line_config(ixp2000_scl_pin(data), GPIO_IN);
-		while(!gpio_line_get(ixp2000_scl_pin(data)) && i--);
-	} else {
-		gpio_line_config(ixp2000_scl_pin(data), GPIO_OUT);
-	}
-}
-
-static void ixp2000_bit_setsda(void *data, int val)
-{
-	if (val) {
-		gpio_line_config(ixp2000_sda_pin(data), GPIO_IN);
-	} else {
-		gpio_line_config(ixp2000_sda_pin(data), GPIO_OUT);
-	}
-}
-
-static int ixp2000_bit_getscl(void *data)
-{
-	return gpio_line_get(ixp2000_scl_pin(data));
-}
-
-static int ixp2000_bit_getsda(void *data)
-{
-	return gpio_line_get(ixp2000_sda_pin(data));
-}
-
-struct ixp2000_i2c_data {
-	struct ixp2000_i2c_pins *gpio_pins;
-	struct i2c_adapter adapter;
-	struct i2c_algo_bit_data algo_data;
-};
-
-static int ixp2000_i2c_remove(struct platform_device *plat_dev)
-{
-	struct ixp2000_i2c_data *drv_data = platform_get_drvdata(plat_dev);
-
-	platform_set_drvdata(plat_dev, NULL);
-
-	i2c_del_adapter(&drv_data->adapter);
-
-	kfree(drv_data);
-
-	return 0;
-}
-
-static int ixp2000_i2c_probe(struct platform_device *plat_dev)
-{
-	int err;
-	struct ixp2000_i2c_pins *gpio = plat_dev->dev.platform_data;
-	struct ixp2000_i2c_data *drv_data = 
-		kzalloc(sizeof(struct ixp2000_i2c_data), GFP_KERNEL);
-
-	if (!drv_data)
-		return -ENOMEM;
-	drv_data->gpio_pins = gpio;
-
-	drv_data->algo_data.data = gpio;
-	drv_data->algo_data.setsda = ixp2000_bit_setsda;
-	drv_data->algo_data.setscl = ixp2000_bit_setscl;
-	drv_data->algo_data.getsda = ixp2000_bit_getsda;
-	drv_data->algo_data.getscl = ixp2000_bit_getscl;
-	drv_data->algo_data.udelay = 6;
-	drv_data->algo_data.timeout = 100;
-
-	drv_data->adapter.id = I2C_HW_B_IXP2000,
-	strlcpy(drv_data->adapter.name, plat_dev->dev.driver->name,
-		sizeof(drv_data->adapter.name));
-	drv_data->adapter.algo_data = &drv_data->algo_data,
-
-	drv_data->adapter.dev.parent = &plat_dev->dev;
-
-	gpio_line_config(gpio->sda_pin, GPIO_IN);
-	gpio_line_config(gpio->scl_pin, GPIO_IN);
-	gpio_line_set(gpio->scl_pin, 0);
-	gpio_line_set(gpio->sda_pin, 0);
-
-	if ((err = i2c_bit_add_bus(&drv_data->adapter)) != 0) {
-		dev_err(&plat_dev->dev, "Could not install, error %d\n", err);
-		kfree(drv_data);
-		return err;
-	} 
-
-	platform_set_drvdata(plat_dev, drv_data);
-
-	return 0;
-}
-
-static struct platform_driver ixp2000_i2c_driver = {
-	.probe		= ixp2000_i2c_probe,
-	.remove		= ixp2000_i2c_remove,
-	.driver		= {
-		.name	= "IXP2000-I2C",
-		.owner	= THIS_MODULE,
-	},
-};
-
-static int __init ixp2000_i2c_init(void)
-{
-	return platform_driver_register(&ixp2000_i2c_driver);
-}
-
-static void __exit ixp2000_i2c_exit(void)
-{
-	platform_driver_unregister(&ixp2000_i2c_driver);
-}
-
-module_init(ixp2000_i2c_init);
-module_exit(ixp2000_i2c_exit);
-
-MODULE_AUTHOR ("Deepak Saxena <dsaxena@plexity.net>");
-MODULE_DESCRIPTION("IXP2000 GPIO-based I2C bus driver");
-MODULE_LICENSE("GPL");
-
diff --git a/drivers/i2c/busses/i2c-ixp4xx.c b/drivers/i2c/busses/i2c-ixp4xx.c
deleted file mode 100644
index 069ed7f..0000000
--- a/drivers/i2c/busses/i2c-ixp4xx.c
+++ /dev/null
@@ -1,178 +0,0 @@
-/*
- * drivers/i2c/busses/i2c-ixp4xx.c
- *
- * Intel's IXP4xx XScale NPU chipsets (IXP420, 421, 422, 425) do not have
- * an on board I2C controller but provide 16 GPIO pins that are often
- * used to create an I2C bus. This driver provides an i2c_adapter 
- * interface that plugs in under algo_bit and drives the GPIO pins
- * as instructed by the alogorithm driver.
- *
- * Author: Deepak Saxena <dsaxena@plexity.net>
- *
- * Copyright (c) 2003-2004 MontaVista Software Inc.
- *
- * This file is licensed under the terms of the GNU General Public 
- * License version 2. This program is licensed "as is" without any 
- * warranty of any kind, whether express or implied.
- *
- * NOTE: Since different platforms will use different GPIO pins for
- *       I2C, this driver uses an IXP4xx-specific platform_data
- *       pointer to pass the GPIO numbers to the driver. This 
- *       allows us to support all the different IXP4xx platforms
- *       w/o having to put #ifdefs in this driver.
- *
- *       See arch/arm/mach-ixp4xx/ixdp425.c for an example of building a 
- *       device list and filling in the ixp4xx_i2c_pins data structure 
- *       that is passed as the platform_data to this driver.
- */
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/platform_device.h>
-#include <linux/module.h>
-#include <linux/i2c.h>
-#include <linux/i2c-algo-bit.h>
-
-#include <asm/hardware.h>	/* Pick up IXP4xx-specific bits */
-
-static inline int ixp4xx_scl_pin(void *data)
-{
-	return ((struct ixp4xx_i2c_pins*)data)->scl_pin;
-}
-
-static inline int ixp4xx_sda_pin(void *data)
-{
-	return ((struct ixp4xx_i2c_pins*)data)->sda_pin;
-}
-
-static void ixp4xx_bit_setscl(void *data, int val)
-{
-	gpio_line_set(ixp4xx_scl_pin(data), 0);
-	gpio_line_config(ixp4xx_scl_pin(data),
-		val ? IXP4XX_GPIO_IN : IXP4XX_GPIO_OUT );
-}
-
-static void ixp4xx_bit_setsda(void *data, int val)
-{
-	gpio_line_set(ixp4xx_sda_pin(data), 0);
-	gpio_line_config(ixp4xx_sda_pin(data),
-		val ? IXP4XX_GPIO_IN : IXP4XX_GPIO_OUT );
-}
-
-static int ixp4xx_bit_getscl(void *data)
-{
-	int scl;
-
-	gpio_line_config(ixp4xx_scl_pin(data), IXP4XX_GPIO_IN );
-	gpio_line_get(ixp4xx_scl_pin(data), &scl);
-
-	return scl;
-}	
-
-static int ixp4xx_bit_getsda(void *data)
-{
-	int sda;
-
-	gpio_line_config(ixp4xx_sda_pin(data), IXP4XX_GPIO_IN );
-	gpio_line_get(ixp4xx_sda_pin(data), &sda);
-
-	return sda;
-}	
-
-struct ixp4xx_i2c_data {
-	struct ixp4xx_i2c_pins *gpio_pins;
-	struct i2c_adapter adapter;
-	struct i2c_algo_bit_data algo_data;
-};
-
-static int ixp4xx_i2c_remove(struct platform_device *plat_dev)
-{
-	struct ixp4xx_i2c_data *drv_data = platform_get_drvdata(plat_dev);
-
-	platform_set_drvdata(plat_dev, NULL);
-
-	i2c_del_adapter(&drv_data->adapter);
-
-	kfree(drv_data);
-
-	return 0;
-}
-
-static int ixp4xx_i2c_probe(struct platform_device *plat_dev)
-{
-	int err;
-	struct ixp4xx_i2c_pins *gpio = plat_dev->dev.platform_data;
-	struct ixp4xx_i2c_data *drv_data = 
-		kzalloc(sizeof(struct ixp4xx_i2c_data), GFP_KERNEL);
-
-	if(!drv_data)
-		return -ENOMEM;
-
-	drv_data->gpio_pins = gpio;
-
-	/*
-	 * We could make a lot of these structures static, but
-	 * certain platforms may have multiple GPIO-based I2C
-	 * buses for various device domains, so we need per-device
-	 * algo_data->data. 
-	 */
-	drv_data->algo_data.data = gpio;
-	drv_data->algo_data.setsda = ixp4xx_bit_setsda;
-	drv_data->algo_data.setscl = ixp4xx_bit_setscl;
-	drv_data->algo_data.getsda = ixp4xx_bit_getsda;
-	drv_data->algo_data.getscl = ixp4xx_bit_getscl;
-	drv_data->algo_data.udelay = 10;
-	drv_data->algo_data.timeout = 100;
-
-	drv_data->adapter.id = I2C_HW_B_IXP4XX;
-	drv_data->adapter.class = I2C_CLASS_HWMON;
-	strlcpy(drv_data->adapter.name, plat_dev->dev.driver->name,
-		sizeof(drv_data->adapter.name));
-	drv_data->adapter.algo_data = &drv_data->algo_data;
-
-	drv_data->adapter.dev.parent = &plat_dev->dev;
-
-	gpio_line_config(gpio->scl_pin, IXP4XX_GPIO_IN);
-	gpio_line_config(gpio->sda_pin, IXP4XX_GPIO_IN);
-	gpio_line_set(gpio->scl_pin, 0);
-	gpio_line_set(gpio->sda_pin, 0);
-
-	err = i2c_bit_add_bus(&drv_data->adapter);
-	if (err) {
-		printk(KERN_ERR "ERROR: Could not install %s\n", plat_dev->dev.bus_id);
-
-		kfree(drv_data);
-		return err;
-	}
-
-	platform_set_drvdata(plat_dev, drv_data);
-
-	return 0;
-}
-
-static struct platform_driver ixp4xx_i2c_driver = {
-	.probe		= ixp4xx_i2c_probe,
-	.remove		= ixp4xx_i2c_remove,
-	.driver		= {
-		.name	= "IXP4XX-I2C",
-		.owner	= THIS_MODULE,
-	},
-};
-
-static int __init ixp4xx_i2c_init(void)
-{
-	return platform_driver_register(&ixp4xx_i2c_driver);
-}
-
-static void __exit ixp4xx_i2c_exit(void)
-{
-	platform_driver_unregister(&ixp4xx_i2c_driver);
-}
-
-module_init(ixp4xx_i2c_init);
-module_exit(ixp4xx_i2c_exit);
-
-MODULE_DESCRIPTION("GPIO-based I2C adapter for IXP4xx systems");
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Deepak Saxena <dsaxena@plexity.net>");
-
diff --git a/drivers/i2c/busses/scx200_i2c.c b/drivers/i2c/busses/scx200_i2c.c
deleted file mode 100644
index c3022a0..0000000
--- a/drivers/i2c/busses/scx200_i2c.c
+++ /dev/null
@@ -1,131 +0,0 @@
-/* linux/drivers/i2c/busses/scx200_i2c.c
-
-   Copyright (c) 2001,2002 Christer Weinigel <wingel@nano-system.com>
-
-   National Semiconductor SCx200 I2C bus on GPIO pins
-
-   Based on i2c-velleman.c Copyright (C) 1995-96, 2000 Simon G. Vogl
-
-   This program is free software; you can redistribute it and/or modify
-   it under the terms of the GNU General Public License as published by
-   the Free Software Foundation; either version 2 of the License, or
-   (at your option) any later version.
-   
-   This program is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of
-   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-   GNU General Public License for more details.
-   
-   You should have received a copy of the GNU General Public License
-   along with this program; if not, write to the Free Software
-   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.		     
-*/
-
-#include <linux/module.h>
-#include <linux/errno.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/i2c.h>
-#include <linux/i2c-algo-bit.h>
-#include <asm/io.h>
-
-#include <linux/scx200_gpio.h>
-
-#define NAME "scx200_i2c"
-
-MODULE_AUTHOR("Christer Weinigel <wingel@nano-system.com>");
-MODULE_DESCRIPTION("NatSemi SCx200 I2C Driver");
-MODULE_LICENSE("GPL");
-
-static int scl = CONFIG_SCx200_I2C_SCL;
-static int sda = CONFIG_SCx200_I2C_SDA;
-
-module_param(scl, int, 0);
-MODULE_PARM_DESC(scl, "GPIO line for SCL");
-module_param(sda, int, 0);
-MODULE_PARM_DESC(sda, "GPIO line for SDA");
-
-static void scx200_i2c_setscl(void *data, int state)
-{
-	scx200_gpio_set(scl, state);
-}
-
-static void scx200_i2c_setsda(void *data, int state)
-{
-	scx200_gpio_set(sda, state);
-} 
-
-static int scx200_i2c_getscl(void *data)
-{
-	return scx200_gpio_get(scl);
-}
-
-static int scx200_i2c_getsda(void *data)
-{
-	return scx200_gpio_get(sda);
-}
-
-/* ------------------------------------------------------------------------
- * Encapsulate the above functions in the correct operations structure.
- * This is only done when more than one hardware adapter is supported.
- */
-
-static struct i2c_algo_bit_data scx200_i2c_data = {
-	.setsda		= scx200_i2c_setsda,
-	.setscl		= scx200_i2c_setscl,
-	.getsda		= scx200_i2c_getsda,
-	.getscl		= scx200_i2c_getscl,
-	.udelay		= 10,
-	.timeout	= 100,
-};
-
-static struct i2c_adapter scx200_i2c_ops = {
-	.owner		   = THIS_MODULE,
-	.id		   = I2C_HW_B_SCX200,
-	.algo_data	   = &scx200_i2c_data,
-	.name	= "NatSemi SCx200 I2C",
-};
-
-static int scx200_i2c_init(void)
-{
-	pr_debug(NAME ": NatSemi SCx200 I2C Driver\n");
-
-	if (!scx200_gpio_present()) {
-		printk(KERN_ERR NAME ": no SCx200 gpio pins available\n");
-		return -ENODEV;
-	}
-
-	pr_debug(NAME ": SCL=GPIO%02u, SDA=GPIO%02u\n", scl, sda);
-
-	if (scl == -1 || sda == -1 || scl == sda) {
-		printk(KERN_ERR NAME ": scl and sda must be specified\n");
-		return -EINVAL;
-	}
-
-	/* Configure GPIOs as open collector outputs */
-	scx200_gpio_configure(scl, ~2, 5);
-	scx200_gpio_configure(sda, ~2, 5);
-
-	if (i2c_bit_add_bus(&scx200_i2c_ops) < 0) {
-		printk(KERN_ERR NAME ": adapter %s registration failed\n", 
-		       scx200_i2c_ops.name);
-		return -ENODEV;
-	}
-	
-	return 0;
-}
-
-static void scx200_i2c_cleanup(void)
-{
-	i2c_del_adapter(&scx200_i2c_ops);
-}
-
-module_init(scx200_i2c_init);
-module_exit(scx200_i2c_cleanup);
-
-/*
-    Local variables:
-        compile-command: "make -k -C ../.. SUBDIRS=drivers/i2c modules"
-        c-basic-offset: 8
-    End:
-*/

