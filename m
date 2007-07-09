Return-Path: <linux-kernel-owner+w=401wt.eu-S1756753AbXGIO5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753AbXGIO5e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 10:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754595AbXGIO4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 10:56:54 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:55602 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754470AbXGIO4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 10:56:52 -0400
Date: Mon, 9 Jul 2007 16:57:24 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: i2c@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] the scheduled i2c-rpx removal
Message-ID: <20070709145724.GC3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the scheduled removal of the i2c-rpx driver.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 Documentation/feature-removal-schedule.txt |    8 -
 Documentation/i2c/summary                  |    1 
 drivers/i2c/algos/Kconfig                  |    4 
 drivers/i2c/busses/Kconfig                 |    5 -
 drivers/i2c/busses/Makefile                |    1 
 drivers/i2c/busses/i2c-rpx.c               |  101 ---------------------
 6 files changed, 120 deletions(-)

--- linux-2.6.22-rc6-mm1/Documentation/feature-removal-schedule.txt.old	2007-07-09 01:26:13.000000000 +0200
+++ linux-2.6.22-rc6-mm1/Documentation/feature-removal-schedule.txt	2007-07-09 01:26:28.000000000 +0200
@@ -285,14 +285,6 @@
 
 ---------------------------
 
-What:	i2c-rpx driver
-When:	June 2007
-Why:	Broken. It depends on i2c-algo-8xx which has never been in the
-	mainline kernel.
-Who:	Jean Delvare <khali@linux-fr.org>
-
----------------------------
-
 What:	legacy RTC drivers (under drivers/i2c/chips)
 When:	November 2007
 Why:	Obsolete. We have a RTC subsystem with better drivers.
--- linux-2.6.22-rc6-mm1/drivers/i2c/busses/Kconfig.old	2007-07-09 01:26:42.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/i2c/busses/Kconfig	2007-07-09 01:26:53.000000000 +0200
@@ -391,11 +391,6 @@
 	  This support is also available as a module.  If so, the module 
 	  will be called i2c-prosavage.
 
-config I2C_RPXLITE
-	tristate "Embedded Planet RPX Lite/Classic support"
-	depends on RPXLITE || RPXCLASSIC
-	select I2C_ALGO8XX
-
 config I2C_S3C2410
 	tristate "S3C2410 I2C Driver"
 	depends on ARCH_S3C2410
--- linux-2.6.22-rc6-mm1/drivers/i2c/algos/Kconfig.old	2007-07-09 01:27:02.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/i2c/algos/Kconfig	2007-07-09 01:27:06.000000000 +0200
@@ -34,10 +34,6 @@
 	  This support is also available as a module.  If so, the module 
 	  will be called i2c-algo-pca.
 
-config I2C_ALGO8XX
-	tristate "MPC8xx CPM I2C interface"
-	depends on 8xx
-
 config I2C_ALGO_SGI
 	tristate "I2C SGI interfaces"
 	depends on SGI_IP22 || SGI_IP32 || X86_VISWS
--- linux-2.6.22-rc6-mm1/drivers/i2c/busses/Makefile.old	2007-07-09 01:27:18.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/i2c/busses/Makefile	2007-07-09 01:27:24.000000000 +0200
@@ -35,7 +35,6 @@
 obj-$(CONFIG_I2C_PNX)		+= i2c-pnx.o
 obj-$(CONFIG_I2C_PROSAVAGE)	+= i2c-prosavage.o
 obj-$(CONFIG_I2C_PXA)		+= i2c-pxa.o
-obj-$(CONFIG_I2C_RPXLITE)	+= i2c-rpx.o
 obj-$(CONFIG_I2C_S3C2410)	+= i2c-s3c2410.o
 obj-$(CONFIG_I2C_SAVAGE4)	+= i2c-savage4.o
 obj-$(CONFIG_I2C_SIBYTE)	+= i2c-sibyte.o
--- linux-2.6.22-rc6-mm1/Documentation/i2c/summary.old	2007-07-09 01:27:48.000000000 +0200
+++ linux-2.6.22-rc6-mm1/Documentation/i2c/summary	2007-07-09 01:27:56.000000000 +0200
@@ -81,6 +81,5 @@
 i2c-philips-par: Philips style parallel port adapter (uses i2c-algo-bit)
 i2c-adap-ibm_ocp: IBM 4xx processor I2C device (uses i2c-algo-ibm_ocp) (NOT BUILT BY DEFAULT)
 i2c-pport:       Primitive parallel port adapter (uses i2c-algo-bit)
-i2c-rpx:         RPX board Motorola 8xx I2C device (uses i2c-algo-8xx) (NOT BUILT BY DEFAULT)
 i2c-velleman:    Velleman K8000 parallel port adapter (uses i2c-algo-bit)
 
--- linux-2.6.22-rc6-mm1/drivers/i2c/busses/i2c-rpx.c	2007-04-26 05:08:32.000000000 +0200
+++ /dev/null	2006-09-19 00:45:31.000000000 +0200
@@ -1,101 +0,0 @@
-/*
- * Embedded Planet RPX Lite MPC8xx CPM I2C interface.
- * Copyright (c) 1999 Dan Malek (dmalek@jlc.net).
- *
- * moved into proper i2c interface;
- * Brad Parker (brad@heeltoe.com)
- *
- * RPX lite specific parts of the i2c interface
- * Update:  There actually isn't anything RPXLite-specific about this module.
- * This should work for most any 8xx board.  The console messages have been 
- * changed to eliminate RPXLite references.
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/stddef.h>
-#include <linux/i2c.h>
-#include <linux/i2c-algo-8xx.h>
-#include <asm/mpc8xx.h>
-#include <asm/commproc.h>
-
-
-static void
-rpx_iic_init(struct i2c_algo_8xx_data *data)
-{
-	volatile cpm8xx_t *cp;
-	volatile immap_t *immap;
-
-	cp = cpmp;	/* Get pointer to Communication Processor */
-	immap = (immap_t *)IMAP_ADDR;	/* and to internal registers */
-
-	data->iip = (iic_t *)&cp->cp_dparam[PROFF_IIC];
-
-	/* Check for and use a microcode relocation patch.
-	*/
-	if ((data->reloc = data->iip->iic_rpbase))
-		data->iip = (iic_t *)&cp->cp_dpmem[data->iip->iic_rpbase];
-		
-	data->i2c = (i2c8xx_t *)&(immap->im_i2c);
-	data->cp = cp;
-
-	/* Initialize Port B IIC pins.
-	*/
-	cp->cp_pbpar |= 0x00000030;
-	cp->cp_pbdir |= 0x00000030;
-	cp->cp_pbodr |= 0x00000030;
-
-	/* Allocate space for two transmit and two receive buffer
-	 * descriptors in the DP ram.
-	 */
-	data->dp_addr = cpm_dpalloc(sizeof(cbd_t) * 4, 8);
-		
-	/* ptr to i2c area */
-	data->i2c = (i2c8xx_t *)&(((immap_t *)IMAP_ADDR)->im_i2c);
-}
-
-static int rpx_install_isr(int irq, void (*func)(void *), void *data)
-{
-	/* install interrupt handler */
-	cpm_install_handler(irq, func, data);
-
-	return 0;
-}
-
-static struct i2c_algo_8xx_data rpx_data = {
-	.setisr = rpx_install_isr
-};
-
-static struct i2c_adapter rpx_ops = {
-	.owner		= THIS_MODULE,
-	.name		= "m8xx",
-	.id		= I2C_HW_MPC8XX_EPON,
-	.algo_data	= &rpx_data,
-};
-
-int __init i2c_rpx_init(void)
-{
-	printk(KERN_INFO "i2c-rpx: i2c MPC8xx driver\n");
-
-	/* reset hardware to sane state */
-	rpx_iic_init(&rpx_data);
-
-	if (i2c_8xx_add_bus(&rpx_ops) < 0) {
-		printk(KERN_ERR "i2c-rpx: Unable to register with I2C\n");
-		return -ENODEV;
-	}
-
-	return 0;
-}
-
-void __exit i2c_rpx_exit(void)
-{
-	i2c_8xx_del_bus(&rpx_ops);
-}
-
-MODULE_AUTHOR("Dan Malek <dmalek@jlc.net>");
-MODULE_DESCRIPTION("I2C-Bus adapter routines for MPC8xx boards");
-
-module_init(i2c_rpx_init);
-module_exit(i2c_rpx_exit);

