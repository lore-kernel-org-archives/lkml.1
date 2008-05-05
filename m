Return-Path: <linux-kernel-owner+w=401wt.eu-S1764678AbYEESnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764678AbYEESnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761763AbYEESbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:31:03 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:33180 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761729AbYEESa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:30:58 -0400
Date: Mon, 5 May 2008 21:29:50 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: i2c@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] the scheduled i2c driver removal
Message-ID: <20080505182950.GB17139@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the scheduled removal of i2c-i810, i2c-prosavage and 
i2c-savage4.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 Documentation/feature-removal-schedule.txt |    7 
 Documentation/i2c/busses/i2c-i810          |   47 ---
 Documentation/i2c/busses/i2c-prosavage     |   23 -
 Documentation/i2c/busses/i2c-savage4       |   26 -
 drivers/i2c/busses/Kconfig                 |   52 ---
 drivers/i2c/busses/Makefile                |    3 
 drivers/i2c/busses/i2c-i810.c              |  260 ----------------
 drivers/i2c/busses/i2c-prosavage.c         |  325 ---------------------
 drivers/i2c/busses/i2c-savage4.c           |  185 -----------
 9 files changed, 928 deletions(-)

9e29f7ff64f93923cd81c54c964daf780c8f2672 diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 3c35d45..aa7229e 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -222,13 +222,6 @@ Who:	Thomas Gleixner <tglx@linutronix.de>
 
 ---------------------------
 
-What:	i2c-i810, i2c-prosavage and i2c-savage4
-When:	May 2008
-Why:	These drivers are superseded by i810fb, intelfb and savagefb.
-Who:	Jean Delvare <khali@linux-fr.org>
-
----------------------------
-
 What (Why):
 	- include/linux/netfilter_ipv4/ipt_TOS.h ipt_tos.h header files
 	  (superseded by xt_TOS/xt_tos target & match)
diff --git a/Documentation/i2c/busses/i2c-i810 b/Documentation/i2c/busses/i2c-i810
deleted file mode 100644
index 778210e..0000000
--- a/Documentation/i2c/busses/i2c-i810
+++ /dev/null
@@ -1,47 +0,0 @@
-Kernel driver i2c-i810
-
-Supported adapters:
-  * Intel 82810, 82810-DC100, 82810E, and 82815 (GMCH)
-  * Intel 82845G (GMCH)
-
-Authors: 
-	Frodo Looijaard <frodol@dds.nl>, 
-	Philip Edelbrock <phil@netroedge.com>,
-        Kyösti Mälkki <kmalkki@cc.hut.fi>,
-	Ralph Metzler <rjkm@thp.uni-koeln.de>,
-	Mark D. Studebaker <mdsxyz123@yahoo.com>
-
-Main contact: Mark Studebaker <mdsxyz123@yahoo.com>
-
-Description 
------------ 
-
-WARNING: If you have an '810' or '815' motherboard, your standard I2C
-temperature sensors are most likely on the 801's I2C bus. You want the
-i2c-i801 driver for those, not this driver.
-
-Now for the i2c-i810...
-
-The GMCH chip contains two I2C interfaces.
-
-The first interface is used for DDC (Data Display Channel) which is a
-serial channel through the VGA monitor connector to a DDC-compliant
-monitor. This interface is defined by the Video Electronics Standards
-Association (VESA). The standards are available for purchase at
-http://www.vesa.org .
-
-The second interface is a general-purpose I2C bus. It may be connected to a
-TV-out chip such as the BT869 or possibly to a digital flat-panel display.
-
-Features
--------- 
-
-Both busses use the i2c-algo-bit driver for 'bit banging'
-and support for specific transactions is provided by i2c-algo-bit.
-
-Issues
-------
-
-If you enable bus testing in i2c-algo-bit (insmod i2c-algo-bit bit_test=1),
-the test may fail; if so, the i2c-i810 driver won't be inserted. However,
-we think this has been fixed.
diff --git a/Documentation/i2c/busses/i2c-prosavage b/Documentation/i2c/busses/i2c-prosavage
deleted file mode 100644
index 7036879..0000000
--- a/Documentation/i2c/busses/i2c-prosavage
+++ /dev/null
@@ -1,23 +0,0 @@
-Kernel driver i2c-prosavage
-
-Supported adapters:
-	
-	S3/VIA KM266/VT8375 aka ProSavage8 
-	S3/VIA KM133/VT8365 aka Savage4 
-
-Author: Henk Vergonet <henk@god.dyndns.org>
-
-Description
------------
-
-The Savage4 chips contain two I2C interfaces (aka a I2C 'master' or
-'host'). 
-
-The first interface is used for DDC (Data Display Channel) which is a
-serial channel through the VGA monitor connector to a DDC-compliant
-monitor. This interface is defined by the Video Electronics Standards
-Association (VESA). The standards are available for purchase at
-http://www.vesa.org . The second interface is a general-purpose I2C bus.
-
-Usefull for gaining access to the TV Encoder chips.
-
diff --git a/Documentation/i2c/busses/i2c-savage4 b/Documentation/i2c/busses/i2c-savage4
deleted file mode 100644
index 6ecceab..0000000
--- a/Documentation/i2c/busses/i2c-savage4
+++ /dev/null
@@ -1,26 +0,0 @@
-Kernel driver i2c-savage4
-
-Supported adapters:
-  * Savage4
-  * Savage2000
-
-Authors: 
-	Alexander Wold <awold@bigfoot.com>,
-	Mark D. Studebaker <mdsxyz123@yahoo.com> 
-
-Description
------------
-
-The Savage4 chips contain two I2C interfaces (aka a I2C 'master'
-or 'host'). 
-
-The first interface is used for DDC (Data Display Channel) which is a
-serial channel through the VGA monitor connector to a DDC-compliant
-monitor. This interface is defined by the Video Electronics Standards
-Association (VESA). The standards are available for purchase at
-http://www.vesa.org . The DDC bus is not yet supported because its register
-is not directly memory-mapped.
-
-The second interface is a general-purpose I2C bus. This is the only
-interface supported by the driver at the moment.
-
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 48438cc..40c2fa4 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -186,26 +186,6 @@ config I2C_I801
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-i801.
 
-config I2C_I810
-	tristate "Intel 810/815 (DEPRECATED)"
-	default n
-	depends on PCI
-	select I2C_ALGOBIT
-	help
-	  If you say yes to this option, support will be included for the Intel
-	  810/815 family of mainboard I2C interfaces.  Specifically, the
-	  following versions of the chipset are supported:
-	    i810AA
-	    i810AB
-	    i810E
-	    i815
-	    i845G
-
-	  This driver is deprecated in favor of the i810fb and intelfb drivers.
-
-	  This driver can also be built as a module.  If so, the module
-	  will be called i2c-i810.
-
 config I2C_PXA
 	tristate "Intel PXA2XX I2C adapter (EXPERIMENTAL)"
 	depends on EXPERIMENTAL && ARCH_PXA
@@ -389,24 +369,6 @@ config I2C_PASEMI
 	help
 	  Supports the PA Semi PWRficient on-chip SMBus interfaces.
 
-config I2C_PROSAVAGE
-	tristate "S3/VIA (Pro)Savage (DEPRECATED)"
-	default n
-	depends on PCI
-	select I2C_ALGOBIT
-	help
-	  If you say yes to this option, support will be included for the
-	  I2C bus and DDC bus of the S3VIA embedded Savage4 and ProSavage8
-	  graphics processors.
-	  chipsets supported:
-	    S3/VIA KM266/VT8375 aka ProSavage8
-	    S3/VIA KM133/VT8365 aka Savage4
-
-	  This driver is deprecated in favor of the savagefb driver.
-
-	  This support is also available as a module.  If so, the module
-	  will be called i2c-prosavage.
-
 config I2C_S3C2410
 	tristate "S3C2410 I2C Driver"
 	depends on ARCH_S3C2410
@@ -414,20 +376,6 @@ config I2C_S3C2410
 	  Say Y here to include support for I2C controller in the
 	  Samsung S3C2410 based System-on-Chip devices.
 
-config I2C_SAVAGE4
-	tristate "S3 Savage 4 (DEPRECATED)"
-	default n
-	depends on PCI
-	select I2C_ALGOBIT
-	help
-	  If you say yes to this option, support will be included for the
-	  S3 Savage 4 I2C interface.
-
-	  This driver is deprecated in favor of the savagefb driver.
-
-	  This driver can also be built as a module.  If so, the module
-	  will be called i2c-savage4.
-
 config I2C_SIBYTE
 	tristate "SiByte SMBus interface"
 	depends on SIBYTE_SB1xxx_SOC
diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
index e8c882a..1ed74b7 100644
--- a/drivers/i2c/busses/Makefile
+++ b/drivers/i2c/busses/Makefile
@@ -16,7 +16,6 @@ obj-$(CONFIG_I2C_ELEKTOR)	+= i2c-elektor.o
 obj-$(CONFIG_I2C_GPIO)		+= i2c-gpio.o
 obj-$(CONFIG_I2C_HYDRA)		+= i2c-hydra.o
 obj-$(CONFIG_I2C_I801)		+= i2c-i801.o
-obj-$(CONFIG_I2C_I810)		+= i2c-i810.o
 obj-$(CONFIG_I2C_IBM_IIC)	+= i2c-ibm_iic.o
 obj-$(CONFIG_I2C_IOP3XX)	+= i2c-iop3xx.o
 obj-$(CONFIG_I2C_IXP2000)	+= i2c-ixp2000.o
@@ -34,10 +33,8 @@ obj-$(CONFIG_I2C_PCA_PLATFORM)	+= i2c-pca-platform.o
 obj-$(CONFIG_I2C_PIIX4)		+= i2c-piix4.o
 obj-$(CONFIG_I2C_PMCMSP)	+= i2c-pmcmsp.o
 obj-$(CONFIG_I2C_PNX)		+= i2c-pnx.o
-obj-$(CONFIG_I2C_PROSAVAGE)	+= i2c-prosavage.o
 obj-$(CONFIG_I2C_PXA)		+= i2c-pxa.o
 obj-$(CONFIG_I2C_S3C2410)	+= i2c-s3c2410.o
-obj-$(CONFIG_I2C_SAVAGE4)	+= i2c-savage4.o
 obj-$(CONFIG_I2C_SH7760)	+= i2c-sh7760.o
 obj-$(CONFIG_I2C_SH_MOBILE)	+= i2c-sh_mobile.o
 obj-$(CONFIG_I2C_SIBYTE)	+= i2c-sibyte.o
diff --git a/drivers/i2c/busses/i2c-i810.c b/drivers/i2c/busses/i2c-i810.c
deleted file mode 100644
index 42e8d94..0000000
--- a/drivers/i2c/busses/i2c-i810.c
+++ /dev/null
@@ -1,260 +0,0 @@
-/*
-    i2c-i810.c - Part of lm_sensors, Linux kernel modules for hardware
-              monitoring
-    Copyright (c) 1998, 1999, 2000  Frodo Looijaard <frodol@dds.nl>,
-    Philip Edelbrock <phil@netroedge.com>,
-    Ralph Metzler <rjkm@thp.uni-koeln.de>, and
-    Mark D. Studebaker <mdsxyz123@yahoo.com>
-    
-    Based on code written by Ralph Metzler <rjkm@thp.uni-koeln.de> and
-    Simon Vogl
-
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
-
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
-
-    You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-*/
-/*
-   This interfaces to the I810/I815 to provide access to
-   the DDC Bus and the I2C Bus.
-
-   SUPPORTED DEVICES	PCI ID
-   i810AA		7121           
-   i810AB		7123           
-   i810E		7125           
-   i815			1132           
-   i845G		2562
-*/
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/pci.h>
-#include <linux/i2c.h>
-#include <linux/i2c-algo-bit.h>
-#include <asm/io.h>
-
-/* GPIO register locations */
-#define I810_IOCONTROL_OFFSET	0x5000
-#define I810_HVSYNC		0x00	/* not used */
-#define I810_GPIOA		0x10
-#define I810_GPIOB		0x14
-
-/* bit locations in the registers */
-#define SCL_DIR_MASK		0x0001
-#define SCL_DIR			0x0002
-#define SCL_VAL_MASK		0x0004
-#define SCL_VAL_OUT		0x0008
-#define SCL_VAL_IN		0x0010
-#define SDA_DIR_MASK		0x0100
-#define SDA_DIR			0x0200
-#define SDA_VAL_MASK		0x0400
-#define SDA_VAL_OUT		0x0800
-#define SDA_VAL_IN		0x1000
-
-/* initialization states */
-#define INIT1			0x1
-#define INIT2			0x2
-#define INIT3			0x4
-
-/* delays */
-#define CYCLE_DELAY		10
-#define TIMEOUT			(HZ / 2)
-
-static void __iomem *ioaddr;
-
-/* The i810 GPIO registers have individual masks for each bit
-   so we never have to read before writing. Nice. */
-
-static void bit_i810i2c_setscl(void *data, int val)
-{
-	writel((val ? SCL_VAL_OUT : 0) | SCL_DIR | SCL_DIR_MASK | SCL_VAL_MASK,
-	     ioaddr + I810_GPIOB);
-	readl(ioaddr + I810_GPIOB);	/* flush posted write */
-}
-
-static void bit_i810i2c_setsda(void *data, int val)
-{
- 	writel((val ? SDA_VAL_OUT : 0) | SDA_DIR | SDA_DIR_MASK | SDA_VAL_MASK,
-	     ioaddr + I810_GPIOB);
-	readl(ioaddr + I810_GPIOB);	/* flush posted write */
-}
-
-/* The GPIO pins are open drain, so the pins could always remain outputs.
-   However, some chip versions don't latch the inputs unless they
-   are set as inputs.
-   We rely on the i2c-algo-bit routines to set the pins high before
-   reading the input from other chips. Following guidance in the 815
-   prog. ref. guide, we do a "dummy write" of 0 to the register before
-   reading which forces the input value to be latched. We presume this
-   applies to the 810 as well; shouldn't hurt anyway. This is necessary to get
-   i2c_algo_bit bit_test=1 to pass. */
-
-static int bit_i810i2c_getscl(void *data)
-{
-	writel(SCL_DIR_MASK, ioaddr + I810_GPIOB);
-	writel(0, ioaddr + I810_GPIOB);
-	return (0 != (readl(ioaddr + I810_GPIOB) & SCL_VAL_IN));
-}
-
-static int bit_i810i2c_getsda(void *data)
-{
-	writel(SDA_DIR_MASK, ioaddr + I810_GPIOB);
-	writel(0, ioaddr + I810_GPIOB);
-	return (0 != (readl(ioaddr + I810_GPIOB) & SDA_VAL_IN));
-}
-
-static void bit_i810ddc_setscl(void *data, int val)
-{
-	writel((val ? SCL_VAL_OUT : 0) | SCL_DIR | SCL_DIR_MASK | SCL_VAL_MASK,
-	     ioaddr + I810_GPIOA);
-	readl(ioaddr + I810_GPIOA);	/* flush posted write */
-}
-
-static void bit_i810ddc_setsda(void *data, int val)
-{
- 	writel((val ? SDA_VAL_OUT : 0) | SDA_DIR | SDA_DIR_MASK | SDA_VAL_MASK,
-	     ioaddr + I810_GPIOA);
-	readl(ioaddr + I810_GPIOA);	/* flush posted write */
-}
-
-static int bit_i810ddc_getscl(void *data)
-{
-	writel(SCL_DIR_MASK, ioaddr + I810_GPIOA);
-	writel(0, ioaddr + I810_GPIOA);
-	return (0 != (readl(ioaddr + I810_GPIOA) & SCL_VAL_IN));
-}
-
-static int bit_i810ddc_getsda(void *data)
-{
-	writel(SDA_DIR_MASK, ioaddr + I810_GPIOA);
-	writel(0, ioaddr + I810_GPIOA);
-	return (0 != (readl(ioaddr + I810_GPIOA) & SDA_VAL_IN));
-}
-
-static int config_i810(struct pci_dev *dev)
-{
-	unsigned long cadr;
-
-	/* map I810 memory */
-	cadr = dev->resource[1].start;
-	cadr += I810_IOCONTROL_OFFSET;
-	cadr &= PCI_BASE_ADDRESS_MEM_MASK;
-	ioaddr = ioremap_nocache(cadr, 0x1000);
-	if (ioaddr) {
-		bit_i810i2c_setscl(NULL, 1);
-		bit_i810i2c_setsda(NULL, 1);
-		bit_i810ddc_setscl(NULL, 1);
-		bit_i810ddc_setsda(NULL, 1);
-		return 0;
-	}
-	return -ENODEV;
-}
-
-static struct i2c_algo_bit_data i810_i2c_bit_data = {
-	.setsda		= bit_i810i2c_setsda,
-	.setscl		= bit_i810i2c_setscl,
-	.getsda		= bit_i810i2c_getsda,
-	.getscl		= bit_i810i2c_getscl,
-	.udelay		= CYCLE_DELAY,
-	.timeout	= TIMEOUT,
-};
-
-static struct i2c_adapter i810_i2c_adapter = {
-	.owner		= THIS_MODULE,
-	.id		= I2C_HW_B_I810,
-	.name		= "I810/I815 I2C Adapter",
-	.algo_data	= &i810_i2c_bit_data,
-};
-
-static struct i2c_algo_bit_data i810_ddc_bit_data = {
-	.setsda		= bit_i810ddc_setsda,
-	.setscl		= bit_i810ddc_setscl,
-	.getsda		= bit_i810ddc_getsda,
-	.getscl		= bit_i810ddc_getscl,
-	.udelay		= CYCLE_DELAY,
-	.timeout	= TIMEOUT,
-};
-
-static struct i2c_adapter i810_ddc_adapter = {
-	.owner		= THIS_MODULE,
-	.id		= I2C_HW_B_I810,
-	.name		= "I810/I815 DDC Adapter",
-	.algo_data	= &i810_ddc_bit_data,
-};
-
-static struct pci_device_id i810_ids[] __devinitdata = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82810_IG1) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82810_IG3) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82810E_IG) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82815_CGC) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82845G_IG) },
-	{ 0, },
-};
-
-MODULE_DEVICE_TABLE (pci, i810_ids);
-
-static int __devinit i810_probe(struct pci_dev *dev, const struct pci_device_id *id)
-{
-	int retval;
-
-	retval = config_i810(dev);
-	if (retval)
-		return retval;
-	dev_info(&dev->dev, "i810/i815 i2c device found.\n");
-
-	/* set up the sysfs linkage to our parent device */
-	i810_i2c_adapter.dev.parent = &dev->dev;
-	i810_ddc_adapter.dev.parent = &dev->dev;
-
-	retval = i2c_bit_add_bus(&i810_i2c_adapter);
-	if (retval)
-		return retval;
-	retval = i2c_bit_add_bus(&i810_ddc_adapter);
-	if (retval)
-		i2c_del_adapter(&i810_i2c_adapter);
-	return retval;
-}
-
-static void __devexit i810_remove(struct pci_dev *dev)
-{
-	i2c_del_adapter(&i810_ddc_adapter);
-	i2c_del_adapter(&i810_i2c_adapter);
-	iounmap(ioaddr);
-}
-
-static struct pci_driver i810_driver = {
-	.name		= "i810_smbus",
-	.id_table	= i810_ids,
-	.probe		= i810_probe,
-	.remove		= __devexit_p(i810_remove),
-};
-
-static int __init i2c_i810_init(void)
-{
-	return pci_register_driver(&i810_driver);
-}
-
-static void __exit i2c_i810_exit(void)
-{
-	pci_unregister_driver(&i810_driver);
-}
-
-MODULE_AUTHOR("Frodo Looijaard <frodol@dds.nl>, "
-		"Philip Edelbrock <phil@netroedge.com>, "
-		"Ralph Metzler <rjkm@thp.uni-koeln.de>, "
-		"and Mark D. Studebaker <mdsxyz123@yahoo.com>");
-MODULE_DESCRIPTION("I810/I815 I2C/DDC driver");
-MODULE_LICENSE("GPL");
-
-module_init(i2c_i810_init);
-module_exit(i2c_i810_exit);
diff --git a/drivers/i2c/busses/i2c-prosavage.c b/drivers/i2c/busses/i2c-prosavage.c
deleted file mode 100644
index 07c1f1e..0000000
--- a/drivers/i2c/busses/i2c-prosavage.c
+++ /dev/null
@@ -1,325 +0,0 @@
-/*
- *    kernel/busses/i2c-prosavage.c
- *
- *    i2c bus driver for S3/VIA 8365/8375 graphics processor.
- *    Copyright (c) 2003 Henk Vergonet <henk@god.dyndns.org>
- *    Based on code written by:
- *	Frodo Looijaard <frodol@dds.nl>,
- *	Philip Edelbrock <phil@netroedge.com>,
- *	Ralph Metzler <rjkm@thp.uni-koeln.de>, and
- *	Mark D. Studebaker <mdsxyz123@yahoo.com>
- *	Simon Vogl
- *	and others
- *
- *    Please read the lm_sensors documentation for details on use.
- *
- *    This program is free software; you can redistribute it and/or modify
- *    it under the terms of the GNU General Public License as published by
- *    the Free Software Foundation; either version 2 of the License, or
- *    (at your option) any later version.
- *
- *    This program is distributed in the hope that it will be useful,
- *    but WITHOUT ANY WARRANTY; without even the implied warranty of
- *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *    GNU General Public License for more details.
- *
- *    You should have received a copy of the GNU General Public License
- *    along with this program; if not, write to the Free Software
- *    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- *
- */
-/*  18-05-2003 HVE - created
- *  14-06-2003 HVE - adapted for lm_sensors2
- *  17-06-2003 HVE - linux 2.5.xx compatible
- *  18-06-2003 HVE - codingstyle
- *  21-06-2003 HVE - compatibility lm_sensors2 and linux 2.5.xx
- *		     codingstyle, mmio enabled
- *
- *  This driver interfaces to the I2C bus of the VIA north bridge embedded
- *  ProSavage4/8 devices. Usefull for gaining access to the TV Encoder chips.
- *
- *  Graphics cores:
- *   S3/VIA KM266/VT8375 aka ProSavage8
- *   S3/VIA KM133/VT8365 aka Savage4
- *
- *  Two serial busses are implemented:
- *   SERIAL1 - I2C serial communications interface
- *   SERIAL2 - DDC2 monitor communications interface
- *
- *  Tested on a FX41 mainboard, see http://www.shuttle.com
- * 
- *
- *  TODO:
- *  - integration with prosavage framebuffer device
- *    (Additional documentation needed :(
- */
-
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/pci.h>
-#include <linux/i2c.h>
-#include <linux/i2c-algo-bit.h>
-#include <asm/io.h>
-
-/*
- * driver configuration
- */
-#define MAX_BUSSES	2
-
-struct s_i2c_bus {
-	void __iomem *mmvga;
-	int	i2c_reg;
-	int	adap_ok;
-	struct i2c_adapter		adap;
-	struct i2c_algo_bit_data	algo;
-};
-
-struct s_i2c_chip {
-	void __iomem *mmio;
-	struct s_i2c_bus	i2c_bus[MAX_BUSSES];
-};
-
-
-/*
- * i2c configuration
- */
-#define CYCLE_DELAY	10
-#define TIMEOUT		(HZ / 2)
-
-
-/* 
- * S3/VIA 8365/8375 registers
- */
-#define VGA_CR_IX	0x3d4
-#define VGA_CR_DATA	0x3d5
-
-#define CR_SERIAL1	0xa0	/* I2C serial communications interface */
-#define MM_SERIAL1	0xff20
-#define CR_SERIAL2	0xb1	/* DDC2 monitor communications interface */
-
-/* based on vt8365 documentation */
-#define I2C_ENAB	0x10
-#define I2C_SCL_OUT	0x01
-#define I2C_SDA_OUT	0x02
-#define I2C_SCL_IN	0x04
-#define I2C_SDA_IN	0x08
-
-#define SET_CR_IX(p, val)	writeb((val), (p)->mmvga + VGA_CR_IX)
-#define SET_CR_DATA(p, val)	writeb((val), (p)->mmvga + VGA_CR_DATA)
-#define GET_CR_DATA(p)		readb((p)->mmvga + VGA_CR_DATA)
-
-
-/*
- * Serial bus line handling
- *
- * serial communications register as parameter in private data
- *
- * TODO: locks with other code sections accessing video registers?
- */
-static void bit_s3via_setscl(void *bus, int val)
-{
-	struct s_i2c_bus *p = (struct s_i2c_bus *)bus;
-	unsigned int r;
-
-	SET_CR_IX(p, p->i2c_reg);
-	r = GET_CR_DATA(p);
-	r |= I2C_ENAB;
-	if (val) {
-		r |= I2C_SCL_OUT;
-	} else {
-		r &= ~I2C_SCL_OUT;
-	}
-	SET_CR_DATA(p, r);
-}
-
-static void bit_s3via_setsda(void *bus, int val)
-{
-	struct s_i2c_bus *p = (struct s_i2c_bus *)bus;
-	unsigned int r;
-	
-	SET_CR_IX(p, p->i2c_reg);
-	r = GET_CR_DATA(p);
-	r |= I2C_ENAB;
-	if (val) {
-		r |= I2C_SDA_OUT;
-	} else {
-		r &= ~I2C_SDA_OUT;
-	}
-	SET_CR_DATA(p, r);
-}
-
-static int bit_s3via_getscl(void *bus)
-{
-	struct s_i2c_bus *p = (struct s_i2c_bus *)bus;
-
-	SET_CR_IX(p, p->i2c_reg);
-	return (0 != (GET_CR_DATA(p) & I2C_SCL_IN));
-}
-
-static int bit_s3via_getsda(void *bus)
-{
-	struct s_i2c_bus *p = (struct s_i2c_bus *)bus;
-
-	SET_CR_IX(p, p->i2c_reg);
-	return (0 != (GET_CR_DATA(p) & I2C_SDA_IN));
-}
-
-
-/*
- * adapter initialisation
- */
-static int i2c_register_bus(struct pci_dev *dev, struct s_i2c_bus *p, void __iomem *mmvga, u32 i2c_reg)
-{
-	int ret;
-	p->adap.owner	  = THIS_MODULE;
-	p->adap.id	  = I2C_HW_B_S3VIA;
-	p->adap.algo_data = &p->algo;
-	p->adap.dev.parent = &dev->dev;
-	p->algo.setsda	  = bit_s3via_setsda;
-	p->algo.setscl	  = bit_s3via_setscl;
-	p->algo.getsda	  = bit_s3via_getsda;
-	p->algo.getscl	  = bit_s3via_getscl;
-	p->algo.udelay	  = CYCLE_DELAY;
-	p->algo.timeout	  = TIMEOUT;
-	p->algo.data	  = p;
-	p->mmvga	  = mmvga;
-	p->i2c_reg	  = i2c_reg;
-    
-	ret = i2c_bit_add_bus(&p->adap);
-	if (ret) {
-		return ret;
-	}
-
-	p->adap_ok = 1;
-	return 0;
-}
-
-
-/*
- * Cleanup stuff
- */
-static void prosavage_remove(struct pci_dev *dev)
-{
-	struct s_i2c_chip *chip;
-	int i, ret;
-
-	chip = (struct s_i2c_chip *)pci_get_drvdata(dev);
-
-	if (!chip) {
-		return;
-	}
-	for (i = MAX_BUSSES - 1; i >= 0; i--) {
-		if (chip->i2c_bus[i].adap_ok == 0)
-			continue;
-
-		ret = i2c_del_adapter(&chip->i2c_bus[i].adap);
-	        if (ret) {
-			dev_err(&dev->dev, "%s not removed\n",
-				chip->i2c_bus[i].adap.name);
-		}
-	}
-	if (chip->mmio) {
-		iounmap(chip->mmio);
-	}
-	kfree(chip);
-}
-
-
-/*
- * Detect chip and initialize it
- */
-static int __devinit prosavage_probe(struct pci_dev *dev, const struct pci_device_id *id)
-{
-	int ret;
-	unsigned long base, len;
-	struct s_i2c_chip *chip;
-	struct s_i2c_bus  *bus;
-
-	pci_set_drvdata(dev, kzalloc(sizeof(struct s_i2c_chip), GFP_KERNEL));
-	chip = (struct s_i2c_chip *)pci_get_drvdata(dev);
-	if (chip == NULL) {
-		return -ENOMEM;
-	}
-
-	base = dev->resource[0].start & PCI_BASE_ADDRESS_MEM_MASK;
-	len  = dev->resource[0].end - base + 1;
-	chip->mmio = ioremap_nocache(base, len);
-
-	if (chip->mmio == NULL) {
-		dev_err(&dev->dev, "ioremap failed\n");
-		prosavage_remove(dev);
-		return -ENODEV;
-	}
-
-
-	/*
-	 * Chip initialisation
-	 */
-	/* Unlock Extended IO Space ??? */
-
-
-	/*
-	 * i2c bus registration
-	 */
-	bus = &chip->i2c_bus[0];
-	snprintf(bus->adap.name, sizeof(bus->adap.name),
-		"ProSavage I2C bus at %02x:%02x.%x",
-		dev->bus->number, PCI_SLOT(dev->devfn), PCI_FUNC(dev->devfn));
-	ret = i2c_register_bus(dev, bus, chip->mmio + 0x8000, CR_SERIAL1);
-	if (ret) {
-		goto err_adap;
-	}
-	/*
-	 * ddc bus registration
-	 */
-	bus = &chip->i2c_bus[1];
-	snprintf(bus->adap.name, sizeof(bus->adap.name),
-		"ProSavage DDC bus at %02x:%02x.%x",
-		dev->bus->number, PCI_SLOT(dev->devfn), PCI_FUNC(dev->devfn));
-	ret = i2c_register_bus(dev, bus, chip->mmio + 0x8000, CR_SERIAL2);
-	if (ret) {
-		goto err_adap;
-	}
-	return 0;
-err_adap:
-	dev_err(&dev->dev, "%s failed\n", bus->adap.name);
-	prosavage_remove(dev);
-	return ret;
-}
-
-
-/*
- * Data for PCI driver interface
- */
-static struct pci_device_id prosavage_pci_tbl[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_S3, PCI_DEVICE_ID_S3_SAVAGE4) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_S3, PCI_DEVICE_ID_S3_PROSAVAGE8) },
-	{ 0, },
-};
-
-MODULE_DEVICE_TABLE (pci, prosavage_pci_tbl);
-
-static struct pci_driver prosavage_driver = {
-	.name		=	"prosavage_smbus",
-	.id_table	=	prosavage_pci_tbl,
-	.probe		=	prosavage_probe,
-	.remove		=	prosavage_remove,
-};
-
-static int __init i2c_prosavage_init(void)
-{
-	return pci_register_driver(&prosavage_driver);
-}
-
-static void __exit i2c_prosavage_exit(void)
-{
-	pci_unregister_driver(&prosavage_driver);
-}
-
-MODULE_DEVICE_TABLE(pci, prosavage_pci_tbl);
-MODULE_AUTHOR("Henk Vergonet");
-MODULE_DESCRIPTION("ProSavage VIA 8365/8375 smbus driver");
-MODULE_LICENSE("GPL");
-
-module_init (i2c_prosavage_init);
-module_exit (i2c_prosavage_exit);
diff --git a/drivers/i2c/busses/i2c-savage4.c b/drivers/i2c/busses/i2c-savage4.c
deleted file mode 100644
index 8adf4ab..0000000
--- a/drivers/i2c/busses/i2c-savage4.c
+++ /dev/null
@@ -1,185 +0,0 @@
-/*
-    i2c-savage4.c - Part of lm_sensors, Linux kernel modules for hardware
-              monitoring
-    Copyright (C) 1998-2003  The LM Sensors Team
-    Alexander Wold <awold@bigfoot.com>
-    Mark D. Studebaker <mdsxyz123@yahoo.com>
-    
-    Based on i2c-voodoo3.c.
-
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
-
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
-
-    You should have received a copy of the GNU General Public License
-    along with this program; if not, write to the Free Software
-    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-*/
-
-/* This interfaces to the I2C bus of the Savage4 to gain access to
-   the BT869 and possibly other I2C devices. The DDC bus is not
-   yet supported because its register is not memory-mapped.
-*/
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/pci.h>
-#include <linux/i2c.h>
-#include <linux/i2c-algo-bit.h>
-#include <asm/io.h>
-
-/* device IDs */
-#define PCI_CHIP_SAVAGE4	0x8A22
-#define PCI_CHIP_SAVAGE2000	0x9102
-
-#define REG			0xff20	/* Serial Port 1 Register */
-
-/* bit locations in the register */
-#define I2C_ENAB		0x00000020
-#define I2C_SCL_OUT		0x00000001
-#define I2C_SDA_OUT		0x00000002
-#define I2C_SCL_IN		0x00000008
-#define I2C_SDA_IN		0x00000010
-
-/* delays */
-#define CYCLE_DELAY		10
-#define TIMEOUT			(HZ / 2)
-
-
-static void __iomem *ioaddr;
-
-/* The sav GPIO registers don't have individual masks for each bit
-   so we always have to read before writing. */
-
-static void bit_savi2c_setscl(void *data, int val)
-{
-	unsigned int r;
-	r = readl(ioaddr + REG);
-	if(val)
-		r |= I2C_SCL_OUT;
-	else
-		r &= ~I2C_SCL_OUT;
-	writel(r, ioaddr + REG);
-	readl(ioaddr + REG);	/* flush posted write */
-}
-
-static void bit_savi2c_setsda(void *data, int val)
-{
-	unsigned int r;
-	r = readl(ioaddr + REG);
-	if(val)
-		r |= I2C_SDA_OUT;
-	else
-		r &= ~I2C_SDA_OUT;
-	writel(r, ioaddr + REG);
-	readl(ioaddr + REG);	/* flush posted write */
-}
-
-/* The GPIO pins are open drain, so the pins always remain outputs.
-   We rely on the i2c-algo-bit routines to set the pins high before
-   reading the input from other chips. */
-
-static int bit_savi2c_getscl(void *data)
-{
-	return (0 != (readl(ioaddr + REG) & I2C_SCL_IN));
-}
-
-static int bit_savi2c_getsda(void *data)
-{
-	return (0 != (readl(ioaddr + REG) & I2C_SDA_IN));
-}
-
-/* Configures the chip */
-
-static int config_s4(struct pci_dev *dev)
-{
-	unsigned long cadr;
-
-	/* map memory */
-	cadr = dev->resource[0].start;
-	cadr &= PCI_BASE_ADDRESS_MEM_MASK;
-	ioaddr = ioremap_nocache(cadr, 0x0080000);
-	if (ioaddr) {
-		/* writel(0x8160, ioaddr + REG2); */
-		writel(0x00000020, ioaddr + REG);
-		dev_info(&dev->dev, "Using Savage4 at %p\n", ioaddr);
-		return 0;
-	}
-	return -ENODEV;
-}
-
-static struct i2c_algo_bit_data sav_i2c_bit_data = {
-	.setsda		= bit_savi2c_setsda,
-	.setscl		= bit_savi2c_setscl,
-	.getsda		= bit_savi2c_getsda,
-	.getscl		= bit_savi2c_getscl,
-	.udelay		= CYCLE_DELAY,
-	.timeout	= TIMEOUT
-};
-
-static struct i2c_adapter savage4_i2c_adapter = {
-	.owner		= THIS_MODULE,
-	.id		= I2C_HW_B_SAVAGE,
-	.name		= "I2C Savage4 adapter",
-	.algo_data	= &sav_i2c_bit_data,
-};
-
-static struct pci_device_id savage4_ids[] __devinitdata = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_S3, PCI_CHIP_SAVAGE4) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_S3, PCI_CHIP_SAVAGE2000) },
-	{ 0, }
-};
-
-MODULE_DEVICE_TABLE (pci, savage4_ids);
-
-static int __devinit savage4_probe(struct pci_dev *dev, const struct pci_device_id *id)
-{
-	int retval;
-
-	retval = config_s4(dev);
-	if (retval)
-		return retval;
-
-	/* set up the sysfs linkage to our parent device */
-	savage4_i2c_adapter.dev.parent = &dev->dev;
-
-	return i2c_bit_add_bus(&savage4_i2c_adapter);
-}
-
-static void __devexit savage4_remove(struct pci_dev *dev)
-{
-	i2c_del_adapter(&savage4_i2c_adapter);
-	iounmap(ioaddr);
-}
-
-static struct pci_driver savage4_driver = {
-	.name		= "savage4_smbus",
-	.id_table	= savage4_ids,
-	.probe		= savage4_probe,
-	.remove		= __devexit_p(savage4_remove),
-};
-
-static int __init i2c_savage4_init(void)
-{
-	return pci_register_driver(&savage4_driver);
-}
-
-static void __exit i2c_savage4_exit(void)
-{
-	pci_unregister_driver(&savage4_driver);
-}
-
-MODULE_AUTHOR("Alexander Wold <awold@bigfoot.com> "
-		"and Mark D. Studebaker <mdsxyz123@yahoo.com>");
-MODULE_DESCRIPTION("Savage4 I2C/SMBus driver");
-MODULE_LICENSE("GPL");
-
-module_init(i2c_savage4_init);
-module_exit(i2c_savage4_exit);

