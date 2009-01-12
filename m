Return-Path: <linux-kernel-owner+w=401wt.eu-S1756143AbZALUmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbZALUmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 15:42:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbZALUmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 15:42:44 -0500
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:60709 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751687AbZALUml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 15:42:41 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap4EAHA5a0lR93Zr/2dsb2JhbACBbNIVhW8
Date: Mon, 12 Jan 2009 21:42:37 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Martyn Welch <martyn.welch@gefanuc.com>,
       Sean MacLennan <smaclennan@pikatech.com>
Subject: [WATCHDOG] v2.6.29-rc patches
Message-ID: <20090112204237.GC13677@infomag.infomag.iguana.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 arch/powerpc/boot/dts/gef_sbc610.dts           |   15 +
 arch/powerpc/configs/86xx/gef_sbc610_defconfig |    1 
 drivers/watchdog/Kconfig                       |   14 +
 drivers/watchdog/Makefile                      |    2 
 drivers/watchdog/gef_wdt.c                     |  330 +++++++++++++++++++++++++
 drivers/watchdog/pika_wdt.c                    |  301 ++++++++++++++++++++++
 drivers/watchdog/wm8350_wdt.c                  |    6 
 7 files changed, 666 insertions(+), 3 deletions(-)

with these Changes:

Author: Sean MacLennan <smaclennan@pikatech.com>
Date:   Tue Sep 23 20:26:26 2008 -0400

    [WATCHDOG] Pika Warp appliance watchdog timer
    
    The FPGA based watchdog timer used by the Pika Warp appliance.
    
    Signed-off-by: Sean MacLennan <smaclennan@pikatech.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Martyn Welch <martyn.welch@gefanuc.com>
Date:   Mon Nov 10 12:31:33 2008 +0000

    [WATCHDOG] Enable watchdog timer on GE Fanuc's SBC610
    
    Support for the FPGA based watchdog timer on GE Fanuc's SBC610.
    
    This patch enables one of the watchdog timers found on the SBC610. There are
    two identical watchdog timers at different offsets in the above mentioned
    boards, however the current driver is only capable of supporting one of them.
    
    The watchdog timers are also capable of generating interrupts at a
    user-configurable threshold, though support for this operation is currently
    not supported by the driver.
    
    Signed-off-by: Martyn Welch <martyn.welch@gefanuc.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Martyn Welch <martyn.welch@gefanuc.com>
Date:   Mon Nov 10 12:31:26 2008 +0000

    [WATCHDOG] Basic support for GE Fanuc's FPGA based watchdog timer
    
    GE Fanuc SBC610
    
    Support for the FPGA based watchdog timer as found on GE Fanuc's SBC310,
    SBC610 and PPC9A Single Board Computers.
    
    This patch adds support for the watchdog timer found in one of the devices
    FPGAs. There are two identical watchdog timers at different offsets in the
    above mentioned boards, this driver is capable of supporting one of them.
    The watchdog timers are also capable of generating interrupts at a
    user-configurable threshold, though support for this operation is currently
    not supported by the driver.
    
    Signed-off-by: Martyn Welch <martyn.welch@gefanuc.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
Date:   Thu Jan 8 12:04:27 2009 +0000

    [WATCHDOG] wm8350: Fix section annotations
    
    The probe and remove functions were incorrectly annotated, with the
    misannotation of the remove function causing build failures when built
    in.
    
    Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/arch/powerpc/boot/dts/gef_sbc610.dts b/arch/powerpc/boot/dts/gef_sbc610.dts
index 9708b34..e78c355 100644
--- a/arch/powerpc/boot/dts/gef_sbc610.dts
+++ b/arch/powerpc/boot/dts/gef_sbc610.dts
@@ -88,6 +88,21 @@
 			compatible = "gef,fpga-regs";
 			reg = <0x4 0x0 0x40>;
 		};
+
+		wdt@4,2000 {
+			compatible = "gef,fpga-wdt";
+			reg = <0x4 0x2000 0x8>;
+			interrupts = <0x1a 0x4>;
+			interrupt-parent = <&gef_pic>;
+		};
+		/* Second watchdog available, driver currently supports one.
+		wdt@4,2010 {
+			compatible = "gef,fpga-wdt";
+			reg = <0x4 0x2010 0x8>;
+			interrupts = <0x1b 0x4>;
+			interrupt-parent = <&gef_pic>;
+		};
+		*/
 		gef_pic: pic@4,4000 {
 			#interrupt-cells = <1>;
 			interrupt-controller;
diff --git a/arch/powerpc/configs/86xx/gef_sbc610_defconfig b/arch/powerpc/configs/86xx/gef_sbc610_defconfig
index cd1ffa4..391874c 100644
--- a/arch/powerpc/configs/86xx/gef_sbc610_defconfig
+++ b/arch/powerpc/configs/86xx/gef_sbc610_defconfig
@@ -1164,6 +1164,7 @@ CONFIG_WATCHDOG=y
 # CONFIG_SOFT_WATCHDOG is not set
 # CONFIG_ALIM7101_WDT is not set
 # CONFIG_8xxx_WDT is not set
+CONFIG_GEF_WDT=y
 
 #
 # PCI-based Watchdog Cards
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index ec68c74..3efa12f 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -770,6 +770,12 @@ config TXX9_WDT
 
 # POWERPC Architecture
 
+config GEF_WDT
+	tristate "GE Fanuc Watchdog Timer"
+	depends on GEF_SBC610
+	---help---
+	  Watchdog timer found in a number of GE Fanuc single board computers.
+
 config MPC5200_WDT
 	tristate "MPC5200 Watchdog Timer"
 	depends on PPC_MPC52xx
@@ -790,6 +796,14 @@ config MV64X60_WDT
 	tristate "MV64X60 (Marvell Discovery) Watchdog Timer"
 	depends on MV64X60
 
+config PIKA_WDT
+	tristate "PIKA FPGA Watchdog"
+	depends on WARP
+	default y
+	help
+	  This enables the watchdog in the PIKA FPGA. Currently used on
+	  the Warp platform.
+
 config BOOKE_WDT
 	bool "PowerPC Book-E Watchdog Timer"
 	depends on BOOKE || 4xx
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index c19b866..806b3eb 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -111,9 +111,11 @@ obj-$(CONFIG_TXX9_WDT) += txx9wdt.o
 # PARISC Architecture
 
 # POWERPC Architecture
+obj-$(CONFIG_GEF_WDT) += gef_wdt.o
 obj-$(CONFIG_MPC5200_WDT) += mpc5200_wdt.o
 obj-$(CONFIG_8xxx_WDT) += mpc8xxx_wdt.o
 obj-$(CONFIG_MV64X60_WDT) += mv64x60_wdt.o
+obj-$(CONFIG_PIKA_WDT) += pika_wdt.o
 obj-$(CONFIG_BOOKE_WDT) += booke_wdt.o
 
 # PPC64 Architecture
diff --git a/drivers/watchdog/gef_wdt.c b/drivers/watchdog/gef_wdt.c
new file mode 100644
index 0000000..f0c2b7a
--- /dev/null
+++ b/drivers/watchdog/gef_wdt.c
@@ -0,0 +1,330 @@
+/*
+ * GE Fanuc watchdog userspace interface
+ *
+ * Author:  Martyn Welch <martyn.welch@gefanuc.com>
+ *
+ * Copyright 2008 GE Fanuc Intelligent Platforms Embedded Systems, Inc.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ * Based on: mv64x60_wdt.c (MV64X60 watchdog userspace interface)
+ *   Author: James Chapman <jchapman@katalix.com>
+ */
+
+/* TODO:
+ * This driver does not provide support for the hardwares capability of sending
+ * an interrupt at a programmable threshold.
+ *
+ * This driver currently can only support 1 watchdog - there are 2 in the
+ * hardware that this driver supports. Thus one could be configured as a
+ * process-based watchdog (via /dev/watchdog), the second (using the interrupt
+ * capabilities) a kernel-based watchdog.
+ */
+
+#include <linux/kernel.h>
+#include <linux/compiler.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/miscdevice.h>
+#include <linux/watchdog.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
+
+#include <sysdev/fsl_soc.h>
+
+/*
+ * The watchdog configuration register contains a pair of 2-bit fields,
+ *   1.  a reload field, bits 27-26, which triggers a reload of
+ *       the countdown register, and
+ *   2.  an enable field, bits 25-24, which toggles between
+ *       enabling and disabling the watchdog timer.
+ * Bit 31 is a read-only field which indicates whether the
+ * watchdog timer is currently enabled.
+ *
+ * The low 24 bits contain the timer reload value.
+ */
+#define GEF_WDC_ENABLE_SHIFT	24
+#define GEF_WDC_SERVICE_SHIFT	26
+#define GEF_WDC_ENABLED_SHIFT	31
+
+#define GEF_WDC_ENABLED_TRUE	1
+#define GEF_WDC_ENABLED_FALSE	0
+
+/* Flags bits */
+#define GEF_WDOG_FLAG_OPENED	0
+
+static unsigned long wdt_flags;
+static int wdt_status;
+static void __iomem *gef_wdt_regs;
+static int gef_wdt_timeout;
+static int gef_wdt_count;
+static unsigned int bus_clk;
+static char expect_close;
+static DEFINE_SPINLOCK(gef_wdt_spinlock);
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
+	__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+
+static int gef_wdt_toggle_wdc(int enabled_predicate, int field_shift)
+{
+	u32 data;
+	u32 enabled;
+	int ret = 0;
+
+	spin_lock(&gef_wdt_spinlock);
+	data = ioread32be(gef_wdt_regs);
+	enabled = (data >> GEF_WDC_ENABLED_SHIFT) & 1;
+
+	/* only toggle the requested field if enabled state matches predicate */
+	if ((enabled ^ enabled_predicate) == 0) {
+		/* We write a 1, then a 2 -- to the appropriate field */
+		data = (1 << field_shift) | gef_wdt_count;
+		iowrite32be(data, gef_wdt_regs);
+
+		data = (2 << field_shift) | gef_wdt_count;
+		iowrite32be(data, gef_wdt_regs);
+		ret = 1;
+	}
+	spin_unlock(&gef_wdt_spinlock);
+
+	return ret;
+}
+
+static void gef_wdt_service(void)
+{
+	gef_wdt_toggle_wdc(GEF_WDC_ENABLED_TRUE,
+		GEF_WDC_SERVICE_SHIFT);
+}
+
+static void gef_wdt_handler_enable(void)
+{
+	if (gef_wdt_toggle_wdc(GEF_WDC_ENABLED_FALSE,
+				   GEF_WDC_ENABLE_SHIFT)) {
+		gef_wdt_service();
+		printk(KERN_NOTICE "gef_wdt: watchdog activated\n");
+	}
+}
+
+static void gef_wdt_handler_disable(void)
+{
+	if (gef_wdt_toggle_wdc(GEF_WDC_ENABLED_TRUE,
+				   GEF_WDC_ENABLE_SHIFT))
+		printk(KERN_NOTICE "gef_wdt: watchdog deactivated\n");
+}
+
+static void gef_wdt_set_timeout(unsigned int timeout)
+{
+	/* maximum bus cycle count is 0xFFFFFFFF */
+	if (timeout > 0xFFFFFFFF / bus_clk)
+		timeout = 0xFFFFFFFF / bus_clk;
+
+	/* Register only holds upper 24 bits, bit shifted into lower 24 */
+	gef_wdt_count = (timeout * bus_clk) >> 8;
+	gef_wdt_timeout = timeout;
+}
+
+
+static ssize_t gef_wdt_write(struct file *file, const char __user *data,
+				 size_t len, loff_t *ppos)
+{
+	if (len) {
+		if (!nowayout) {
+			size_t i;
+
+			expect_close = 0;
+
+			for (i = 0; i != len; i++) {
+				char c;
+				if (get_user(c, data + i))
+					return -EFAULT;
+				if (c == 'V')
+					expect_close = 42;
+			}
+		}
+		gef_wdt_service();
+	}
+
+	return len;
+}
+
+static long gef_wdt_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
+{
+	int timeout;
+	int options;
+	void __user *argp = (void __user *)arg;
+	static struct watchdog_info info = {
+		.options =	WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE |
+				WDIOF_KEEPALIVEPING,
+		.firmware_version = 0,
+		.identity = "GE Fanuc watchdog",
+	};
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		if (copy_to_user(argp, &info, sizeof(info)))
+			return -EFAULT;
+		break;
+
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		if (put_user(wdt_status, (int __user *)argp))
+			return -EFAULT;
+		wdt_status &= ~WDIOF_KEEPALIVEPING;
+		break;
+
+	case WDIOC_SETOPTIONS:
+		if (get_user(options, (int __user *)argp))
+			return -EFAULT;
+
+		if (options & WDIOS_DISABLECARD)
+			gef_wdt_handler_disable();
+
+		if (options & WDIOS_ENABLECARD)
+			gef_wdt_handler_enable();
+		break;
+
+	case WDIOC_KEEPALIVE:
+		gef_wdt_service();
+		wdt_status |= WDIOF_KEEPALIVEPING;
+		break;
+
+	case WDIOC_SETTIMEOUT:
+		if (get_user(timeout, (int __user *)argp))
+			return -EFAULT;
+		gef_wdt_set_timeout(timeout);
+		/* Fall through */
+
+	case WDIOC_GETTIMEOUT:
+		if (put_user(gef_wdt_timeout, (int __user *)argp))
+			return -EFAULT;
+		break;
+
+	default:
+		return -ENOTTY;
+	}
+
+	return 0;
+}
+
+static int gef_wdt_open(struct inode *inode, struct file *file)
+{
+	if (test_and_set_bit(GEF_WDOG_FLAG_OPENED, &wdt_flags))
+		return -EBUSY;
+
+	if (nowayout)
+		__module_get(THIS_MODULE);
+
+	gef_wdt_handler_enable();
+
+	return nonseekable_open(inode, file);
+}
+
+static int gef_wdt_release(struct inode *inode, struct file *file)
+{
+	if (expect_close == 42)
+		gef_wdt_handler_disable();
+	else {
+		printk(KERN_CRIT
+		       "gef_wdt: unexpected close, not stopping timer!\n");
+		gef_wdt_service();
+	}
+	expect_close = 0;
+
+	clear_bit(GEF_WDOG_FLAG_OPENED, &wdt_flags);
+
+	return 0;
+}
+
+static const struct file_operations gef_wdt_fops = {
+	.owner = THIS_MODULE,
+	.llseek = no_llseek,
+	.write = gef_wdt_write,
+	.unlocked_ioctl = gef_wdt_ioctl,
+	.open = gef_wdt_open,
+	.release = gef_wdt_release,
+};
+
+static struct miscdevice gef_wdt_miscdev = {
+	.minor = WATCHDOG_MINOR,
+	.name = "watchdog",
+	.fops = &gef_wdt_fops,
+};
+
+
+static int __devinit gef_wdt_probe(struct of_device *dev,
+	const struct of_device_id *match)
+{
+	int timeout = 10;
+	u32 freq;
+
+	bus_clk = 133; /* in MHz */
+
+	freq = fsl_get_sys_freq();
+	if (freq > 0)
+		bus_clk = freq;
+
+	/* Map devices registers into memory */
+	gef_wdt_regs = of_iomap(dev->node, 0);
+	if (gef_wdt_regs == NULL)
+		return -ENOMEM;
+
+	gef_wdt_set_timeout(timeout);
+
+	gef_wdt_handler_disable();	/* in case timer was already running */
+
+	return misc_register(&gef_wdt_miscdev);
+}
+
+static int __devexit gef_wdt_remove(struct platform_device *dev)
+{
+	misc_deregister(&gef_wdt_miscdev);
+
+	gef_wdt_handler_disable();
+
+	iounmap(gef_wdt_regs);
+
+	return 0;
+}
+
+static const struct of_device_id gef_wdt_ids[] = {
+	{
+		.compatible = "gef,fpga-wdt",
+	},
+	{},
+};
+
+static struct of_platform_driver gef_wdt_driver = {
+	.owner		= THIS_MODULE,
+	.name		= "gef_wdt",
+	.match_table	= gef_wdt_ids,
+	.probe		= gef_wdt_probe,
+};
+
+static int __init gef_wdt_init(void)
+{
+	printk(KERN_INFO "GE Fanuc watchdog driver\n");
+	return of_register_platform_driver(&gef_wdt_driver);
+}
+
+static void __exit gef_wdt_exit(void)
+{
+	of_unregister_platform_driver(&gef_wdt_driver);
+}
+
+module_init(gef_wdt_init);
+module_exit(gef_wdt_exit);
+
+MODULE_AUTHOR("Martyn Welch <martyn.welch@gefanuc.com>");
+MODULE_DESCRIPTION("GE Fanuc watchdog driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+MODULE_ALIAS("platform: gef_wdt");
diff --git a/drivers/watchdog/pika_wdt.c b/drivers/watchdog/pika_wdt.c
new file mode 100644
index 0000000..2d22e99
--- /dev/null
+++ b/drivers/watchdog/pika_wdt.c
@@ -0,0 +1,301 @@
+/*
+ * PIKA FPGA based Watchdog Timer
+ *
+ * Copyright (c) 2008 PIKA Technologies
+ *   Sean MacLennan <smaclennan@pikatech.com>
+ */
+
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+#include <linux/watchdog.h>
+#include <linux/reboot.h>
+#include <linux/jiffies.h>
+#include <linux/timer.h>
+#include <linux/bitops.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
+#include <linux/of_platform.h>
+
+#define DRV_NAME "PIKA-WDT"
+#define PFX DRV_NAME ": "
+
+/* Hardware timeout in seconds */
+#define WDT_HW_TIMEOUT 2
+
+/* Timer heartbeat (500ms) */
+#define WDT_TIMEOUT	(HZ/2)
+
+/* User land timeout */
+#define WDT_HEARTBEAT 15
+static int heartbeat = WDT_HEARTBEAT;
+module_param(heartbeat, int, 0);
+MODULE_PARM_DESC(heartbeat, "Watchdog heartbeats in seconds. "
+	"(default = " __MODULE_STRING(WDT_HEARTBEAT) ")");
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started "
+	"(default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+static struct {
+	void __iomem *fpga;
+	unsigned long next_heartbeat;	/* the next_heartbeat for the timer */
+	unsigned long open;
+	char expect_close;
+	int bootstatus;
+	struct timer_list timer;	/* The timer that pings the watchdog */
+} pikawdt_private;
+
+static struct watchdog_info ident = {
+	.identity	= DRV_NAME,
+	.options	= WDIOF_CARDRESET |
+			  WDIOF_SETTIMEOUT |
+			  WDIOF_KEEPALIVEPING |
+			  WDIOF_MAGICCLOSE,
+};
+
+/*
+ * Reload the watchdog timer.  (ie, pat the watchdog)
+ */
+static inline void pikawdt_reset(void)
+{
+	/* -- FPGA: Reset Control Register (32bit R/W) (Offset: 0x14) --
+	 * Bit 7,    WTCHDG_EN: When set to 1, the watchdog timer is enabled.
+	 *           Once enabled, it cannot be disabled. The watchdog can be
+	 *           kicked by performing any write access to the reset
+	 *           control register (this register).
+	 * Bit 8-11, WTCHDG_TIMEOUT_SEC: Sets the watchdog timeout value in
+	 *           seconds. Valid ranges are 1 to 15 seconds. The value can
+	 *           be modified dynamically.
+	 */
+	unsigned reset = in_be32(pikawdt_private.fpga + 0x14);
+	/* enable with max timeout - 15 seconds */
+	reset |= (1 << 7) + (WDT_HW_TIMEOUT << 8);
+	out_be32(pikawdt_private.fpga + 0x14, reset);
+}
+
+/*
+ * Timer tick
+ */
+static void pikawdt_ping(unsigned long data)
+{
+	if (time_before(jiffies, pikawdt_private.next_heartbeat) ||
+			(!nowayout && !pikawdt_private.open)) {
+		pikawdt_reset();
+		mod_timer(&pikawdt_private.timer, jiffies + WDT_TIMEOUT);
+	} else
+		printk(KERN_CRIT PFX "I will reset your machine !\n");
+}
+
+
+static void pikawdt_keepalive(void)
+{
+	pikawdt_private.next_heartbeat = jiffies + heartbeat * HZ;
+}
+
+static void pikawdt_start(void)
+{
+	pikawdt_keepalive();
+	mod_timer(&pikawdt_private.timer, jiffies + WDT_TIMEOUT);
+}
+
+/*
+ * Watchdog device is opened, and watchdog starts running.
+ */
+static int pikawdt_open(struct inode *inode, struct file *file)
+{
+	/* /dev/watchdog can only be opened once */
+	if (test_and_set_bit(0, &pikawdt_private.open))
+		return -EBUSY;
+
+	pikawdt_start();
+
+	return nonseekable_open(inode, file);
+}
+
+/*
+ * Close the watchdog device.
+ */
+static int pikawdt_release(struct inode *inode, struct file *file)
+{
+	/* stop internal ping */
+	if (!pikawdt_private.expect_close)
+		del_timer(&pikawdt_private.timer);
+
+	clear_bit(0, &pikawdt_private.open);
+	pikawdt_private.expect_close = 0;
+	return 0;
+}
+
+/*
+ * Pat the watchdog whenever device is written to.
+ */
+static ssize_t pikawdt_write(struct file *file, const char __user *data,
+			     size_t len, loff_t *ppos)
+{
+	if (!len)
+		return 0;
+
+	/* Scan for magic character */
+	if (!nowayout) {
+		size_t i;
+
+		pikawdt_private.expect_close = 0;
+
+		for (i = 0; i < len; i++) {
+			char c;
+			if (get_user(c, data + i))
+				return -EFAULT;
+			if (c == 'V') {
+				pikawdt_private.expect_close = 42;
+				break;
+			}
+		}
+	}
+
+	pikawdt_keepalive();
+
+	return len;
+}
+
+/*
+ * Handle commands from user-space.
+ */
+static long pikawdt_ioctl(struct file *file,
+		unsigned int cmd, unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
+	int new_value;
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
+
+	case WDIOC_GETSTATUS:
+		return put_user(0, p);
+
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(pikawdt_private.bootstatus, p);
+
+	case WDIOC_KEEPALIVE:
+		pikawdt_keepalive();
+		return 0;
+
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_value, p))
+			return -EFAULT;
+
+		heartbeat = new_value;
+		pikawdt_keepalive();
+
+		return put_user(new_value, p);  /* return current value */
+
+	case WDIOC_GETTIMEOUT:
+		return put_user(heartbeat, p);
+	}
+	return -ENOTTY;
+}
+
+
+static const struct file_operations pikawdt_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.open		= pikawdt_open,
+	.release	= pikawdt_release,
+	.write		= pikawdt_write,
+	.unlocked_ioctl	= pikawdt_ioctl,
+};
+
+static struct miscdevice pikawdt_miscdev = {
+	.minor	= WATCHDOG_MINOR,
+	.name	= "watchdog",
+	.fops	= &pikawdt_fops,
+};
+
+static int __init pikawdt_init(void)
+{
+	struct device_node *np;
+	void __iomem *fpga;
+	static u32 post1;
+	int ret;
+
+	np = of_find_compatible_node(NULL, NULL, "pika,fpga");
+	if (np == NULL) {
+		printk(KERN_ERR PFX "Unable to find fpga.\n");
+		return -ENOENT;
+	}
+
+	pikawdt_private.fpga = of_iomap(np, 0);
+	of_node_put(np);
+	if (pikawdt_private.fpga == NULL) {
+		printk(KERN_ERR PFX "Unable to map fpga.\n");
+		return -ENOMEM;
+	}
+
+	ident.firmware_version = in_be32(pikawdt_private.fpga + 0x1c) & 0xffff;
+
+	/* POST information is in the sd area. */
+	np = of_find_compatible_node(NULL, NULL, "pika,fpga-sd");
+	if (np == NULL) {
+		printk(KERN_ERR PFX "Unable to find fpga-sd.\n");
+		ret = -ENOENT;
+		goto out;
+	}
+
+	fpga = of_iomap(np, 0);
+	of_node_put(np);
+	if (fpga == NULL) {
+		printk(KERN_ERR PFX "Unable to map fpga-sd.\n");
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* -- FPGA: POST Test Results Register 1 (32bit R/W) (Offset: 0x4040) --
+	 * Bit 31,   WDOG: Set to 1 when the last reset was caused by a watchdog
+	 *           timeout.
+	 */
+	post1 = in_be32(fpga + 0x40);
+	if (post1 & 0x80000000)
+		pikawdt_private.bootstatus = WDIOF_CARDRESET;
+
+	iounmap(fpga);
+
+	setup_timer(&pikawdt_private.timer, pikawdt_ping, 0);
+
+	ret = misc_register(&pikawdt_miscdev);
+	if (ret) {
+		printk(KERN_ERR PFX "Unable to register miscdev.\n");
+		goto out;
+	}
+
+	printk(KERN_INFO PFX "initialized. heartbeat=%d sec (nowayout=%d)\n",
+							heartbeat, nowayout);
+	return 0;
+
+out:
+	iounmap(pikawdt_private.fpga);
+	return ret;
+}
+
+static void __exit pikawdt_exit(void)
+{
+	misc_deregister(&pikawdt_miscdev);
+
+	iounmap(pikawdt_private.fpga);
+}
+
+module_init(pikawdt_init);
+module_exit(pikawdt_exit);
+
+MODULE_AUTHOR("Sean MacLennan <smaclennan@pikatech.com>");
+MODULE_DESCRIPTION("PIKA FPGA based Watchdog Timer");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+
diff --git a/drivers/watchdog/wm8350_wdt.c b/drivers/watchdog/wm8350_wdt.c
index 2bc0d4d..a2d2e8e 100644
--- a/drivers/watchdog/wm8350_wdt.c
+++ b/drivers/watchdog/wm8350_wdt.c
@@ -279,7 +279,7 @@ static struct miscdevice wm8350_wdt_miscdev = {
 	.fops = &wm8350_wdt_fops,
 };
 
-static int wm8350_wdt_probe(struct platform_device *pdev)
+static int __devinit wm8350_wdt_probe(struct platform_device *pdev)
 {
 	struct wm8350 *wm8350 = platform_get_drvdata(pdev);
 
@@ -296,7 +296,7 @@ static int wm8350_wdt_probe(struct platform_device *pdev)
 	return misc_register(&wm8350_wdt_miscdev);
 }
 
-static int __exit wm8350_wdt_remove(struct platform_device *pdev)
+static int __devexit wm8350_wdt_remove(struct platform_device *pdev)
 {
 	misc_deregister(&wm8350_wdt_miscdev);
 
@@ -305,7 +305,7 @@ static int __exit wm8350_wdt_remove(struct platform_device *pdev)
 
 static struct platform_driver wm8350_wdt_driver = {
 	.probe = wm8350_wdt_probe,
-	.remove = wm8350_wdt_remove,
+	.remove = __devexit_p(wm8350_wdt_remove),
 	.driver = {
 		.name = "wm8350-wdt",
 	},
