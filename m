Return-Path: <linux-kernel-owner+w=401wt.eu-S1760361AbZFTSv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760361AbZFTSv7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 14:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759506AbZFTStz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 14:49:55 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:23733 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759498AbZFTStu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 14:49:50 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEALDMPEpR9SKv/2dsb2JhbAC9Vo8OCYIvBoFLBQ
Date: Sat, 20 Jun 2009 20:49:42 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       matthieu castet <castet.matthieu@free.fr>,
       Florian Fainelli <florian@openwrt.org>,
       Aleksandar Radovanovic <biblbroks@sezampro.rs>,
       Ralf Baechle <ralf@linux-mips.org>,
       Vitaly Wool <vital@embeddedalley.com>,
       Dmitry Pervushin <dpervushin@embeddedalley.com>,
       Timo Kokkonen <timo.t.kokkonen@nokia.com>,
       Atal Shargorodsky <ext-atal.shargorodsky@nokia.com>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Daniel Laird <daniel.j.laird@nxp.com>
Subject: [WATCHDOG] v2.6.31-rc patches - Part 2: new drivers
Message-ID: <20090620184942.GS32136@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 drivers/mfd/twl4030-core.c       |   12 
 drivers/watchdog/Kconfig         |   41 ++
 drivers/watchdog/Makefile        |    5 
 drivers/watchdog/bcm47xx_wdt.c   |  286 ++++++++++++++++++++
 drivers/watchdog/coh901327_wdt.c |  537 +++++++++++++++++++++++++++++++++++++++
 drivers/watchdog/pnx833x_wdt.c   |  282 ++++++++++++++++++++
 drivers/watchdog/stmp3xxx_wdt.c  |  296 +++++++++++++++++++++
 drivers/watchdog/twl4030_wdt.c   |  272 +++++++++++++++++++
 8 files changed, 1731 insertions(+)

with these Changes:

Author: matthieu castet <castet.matthieu@free.fr>
Date:   Fri Jun 5 18:57:18 2009 +0200

    [WATCHDOG] add bcm47xx watchdog driver
    
    This add watchdog driver for broadcom 47xx device.
    It uses the ssb subsytem to access embeded watchdog device.
    
    Because the watchdog timeout is very short (about 2s), a soft timer is used
    to increase the watchdog period.
    
    Note : A patch for exporting the ssb_watchdog_timer_set will
    be submitted on next linux-mips merge. Without this patch it can't
    be build as a module.
    
    Signed-off-by: Aleksandar Radovanovic <biblbroks@sezampro.rs>
    Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
    Tested-by: Florian Fainelli <florian@openwrt.org>
    Cc: Ralf Baechle <ralf@linux-mips.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Author: dmitry pervushin <dpervushin@embeddedalley.com>
Date:   Wed Jun 3 20:21:21 2009 +0400

    [WATCHDOG] Freescale STMP: watchdog driver
    
    Add watchdog timer support for Freescale STMP3xxx boards
    
    Signed-off-by: Vitaly Wool <vital@embeddedalley.com>
    Signed-off-by: Dmitry Pervushin <dpervushin@embeddedalley.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Timo Kokkonen <timo.t.kokkonen@nokia.com>
Date:   Fri Mar 27 16:42:17 2009 +0200

    [WATCHDOG] twl4030 watchdog driver
    
    Implementation of twl4030 watchdog driver.
    
    Signed-off-by: Timo Kokkonen <timo.t.kokkonen@nokia.com>
    Signed-off-by: Atal Shargorodsky <ext-atal.shargorodsky@nokia.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Linus Walleij <linus.walleij@stericsson.com>
Date:   Wed May 6 15:35:40 2009 +0200

    [WATCHDOG] U300 COH 901 327 watchdog driver
    
    This patch adds support for the U300 COH 901 327 watchdog for the
    U300 platform recently added to RMK:s ARM tree.
    
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Daniel Laird <daniel.j.laird@nxp.com>
Date:   Wed Nov 5 16:46:49 2008 +0100

    [WATCHDOG] Add pnx833x_wdt
    
    Add support for PNX833x watchdog timer.
    
    Signed-off-by: Daniel Laird <daniel.j.laird@nxp.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/mfd/twl4030-core.c b/drivers/mfd/twl4030-core.c
index cd1008c..ca54996 100644
--- a/drivers/mfd/twl4030-core.c
+++ b/drivers/mfd/twl4030-core.c
@@ -101,6 +101,12 @@
 #define twl_has_usb()	false
 #endif
 
+#if defined(CONFIG_TWL4030_WATCHDOG) || \
+	defined(CONFIG_TWL4030_WATCHDOG_MODULE)
+#define twl_has_watchdog()        true
+#else
+#define twl_has_watchdog()        false
+#endif
 
 /* Triton Core internal information (BEGIN) */
 
@@ -526,6 +532,12 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
 		usb_transceiver = child;
 	}
 
+	if (twl_has_watchdog()) {
+		child = add_child(0, "twl4030_wdt", NULL, 0, false, 0, 0);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+	}
+
 	if (twl_has_regulator()) {
 		/*
 		child = add_regulator(TWL4030_REG_VPLL1, pdata->vpll1);
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index b166f28..e8d45b6 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -240,6 +240,32 @@ config ORION_WATCHDOG
 	  To compile this driver as a module, choose M here: the
 	  module will be called orion_wdt.
 
+config COH901327_WATCHDOG
+	bool "ST-Ericsson COH 901 327 watchdog"
+	depends on ARCH_U300
+	default y if MACH_U300
+	help
+	  Say Y here to include Watchdog timer support for the
+	  watchdog embedded into the ST-Ericsson U300 series platforms.
+	  This watchdog is used to reset the system and thus cannot be
+	  compiled as a module.
+
+config TWL4030_WATCHDOG
+	tristate "TWL4030 Watchdog"
+	depends on TWL4030_CORE
+	help
+	  Support for TI TWL4030 watchdog.  Say 'Y' here to enable the
+	  watchdog timer support for TWL4030 chips.
+
+config STMP3XXX_WATCHDOG
+	tristate "Freescale STMP3XXX watchdog"
+	depends on ARCH_STMP3XXX
+	help
+	  Say Y here if to include support for the watchdog timer
+	  for the Sigmatel STMP37XX/378X SoC.
+	  To compile this driver as a module, choose M here: the
+	  module will be called stmp3xxx_wdt.
+
 # AVR32 Architecture
 
 config AT32AP700X_WDT
@@ -703,6 +729,12 @@ config SBC_EPX_C3_WATCHDOG
 
 # MIPS Architecture
 
+config BCM47XX_WDT
+	tristate "Broadcom BCM47xx Watchdog Timer"
+	depends on BCM47XX
+	help
+	  Hardware driver for the Broadcom BCM47xx Watchog Timer.
+
 config RC32434_WDT
 	tristate "IDT RC32434 SoC Watchdog Timer"
 	depends on MIKROTIK_RB532
@@ -729,6 +761,15 @@ config WDT_MTX1
 	  Hardware driver for the MTX-1 boards. This is a watchdog timer that
 	  will reboot the machine after a 100 seconds timer expired.
 
+config PNX833X_WDT
+	tristate "PNX833x Hardware Watchdog"
+	depends on SOC_PNX8335
+	help
+	  Hardware driver for the PNX833x's watchdog. This is a
+	  watchdog timer that will reboot the machine after a programable
+	  timer has expired and no process has written to /dev/watchdog during
+	  that time.
+
 config WDT_RM9K_GPI
 	tristate "RM9000/GPI hardware watchdog"
 	depends on CPU_RM9000
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index c3afa14..3d77429 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_USBPCWATCHDOG) += pcwd_usb.o
 obj-$(CONFIG_AT91RM9200_WATCHDOG) += at91rm9200_wdt.o
 obj-$(CONFIG_AT91SAM9X_WATCHDOG) += at91sam9_wdt.o
 obj-$(CONFIG_OMAP_WATCHDOG) += omap_wdt.o
+obj-$(CONFIG_TWL4030_WATCHDOG) += twl4030_wdt.o
 obj-$(CONFIG_21285_WATCHDOG) += wdt285.o
 obj-$(CONFIG_977_WATCHDOG) += wdt977.o
 obj-$(CONFIG_IXP2000_WATCHDOG) += ixp2000_wdt.o
@@ -41,6 +42,8 @@ obj-$(CONFIG_PNX4008_WATCHDOG) += pnx4008_wdt.o
 obj-$(CONFIG_IOP_WATCHDOG) += iop_wdt.o
 obj-$(CONFIG_DAVINCI_WATCHDOG) += davinci_wdt.o
 obj-$(CONFIG_ORION_WATCHDOG) += orion_wdt.o
+obj-$(CONFIG_COH901327_WATCHDOG) += coh901327_wdt.o
+obj-$(CONFIG_STMP3XXX_WATCHDOG) += stmp3xxx_wdt.o
 
 # AVR32 Architecture
 obj-$(CONFIG_AT32AP700X_WDT) += at32ap700x_wdt.o
@@ -98,9 +101,11 @@ obj-$(CONFIG_SBC_EPX_C3_WATCHDOG) += sbc_epx_c3.o
 # M68KNOMMU Architecture
 
 # MIPS Architecture
+obj-$(CONFIG_BCM47XX_WDT) += bcm47xx_wdt.o
 obj-$(CONFIG_RC32434_WDT) += rc32434_wdt.o
 obj-$(CONFIG_INDYDOG) += indydog.o
 obj-$(CONFIG_WDT_MTX1) += mtx-1_wdt.o
+obj-$(CONFIG_PNX833X_WDT) += pnx833x_wdt.o
 obj-$(CONFIG_WDT_RM9K_GPI) += rm9k_wdt.o
 obj-$(CONFIG_SIBYTE_WDOG) += sb_wdog.o
 obj-$(CONFIG_AR7_WDT) += ar7_wdt.o
diff --git a/drivers/watchdog/bcm47xx_wdt.c b/drivers/watchdog/bcm47xx_wdt.c
new file mode 100644
index 0000000..5c7011c
--- /dev/null
+++ b/drivers/watchdog/bcm47xx_wdt.c
@@ -0,0 +1,286 @@
+/*
+ *  Watchdog driver for Broadcom BCM47XX
+ *
+ *  Copyright (C) 2008 Aleksandar Radovanovic <biblbroks@sezampro.rs>
+ *  Copyright (C) 2009 Matthieu CASTET <castet.matthieu@free.fr>
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation; either version
+ *  2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/bitops.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/reboot.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+#include <linux/watchdog.h>
+#include <linux/timer.h>
+#include <linux/jiffies.h>
+#include <linux/ssb/ssb_embedded.h>
+#include <asm/mach-bcm47xx/bcm47xx.h>
+
+#define DRV_NAME		"bcm47xx_wdt"
+
+#define WDT_DEFAULT_TIME	30	/* seconds */
+#define WDT_MAX_TIME		255	/* seconds */
+
+static int wdt_time = WDT_DEFAULT_TIME;
+static int nowayout = WATCHDOG_NOWAYOUT;
+
+module_param(wdt_time, int, 0);
+MODULE_PARM_DESC(wdt_time, "Watchdog time in seconds. (default="
+				__MODULE_STRING(WDT_DEFAULT_TIME) ")");
+
+#ifdef CONFIG_WATCHDOG_NOWAYOUT
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+#endif
+
+static unsigned long bcm47xx_wdt_busy;
+static char expect_release;
+static struct timer_list wdt_timer;
+static atomic_t ticks;
+
+static inline void bcm47xx_wdt_hw_start(void)
+{
+	/* this is 2,5s on 100Mhz clock  and 2s on 133 Mhz */
+	ssb_watchdog_timer_set(&ssb_bcm47xx, 0xfffffff);
+}
+
+static inline int bcm47xx_wdt_hw_stop(void)
+{
+	return ssb_watchdog_timer_set(&ssb_bcm47xx, 0);
+}
+
+static void bcm47xx_timer_tick(unsigned long unused)
+{
+	if (!atomic_dec_and_test(&ticks)) {
+		bcm47xx_wdt_hw_start();
+		mod_timer(&wdt_timer, jiffies + HZ);
+	} else {
+		printk(KERN_CRIT DRV_NAME "Watchdog will fire soon!!!\n");
+	}
+}
+
+static inline void bcm47xx_wdt_pet(void)
+{
+	atomic_set(&ticks, wdt_time);
+}
+
+static void bcm47xx_wdt_start(void)
+{
+	bcm47xx_wdt_pet();
+	bcm47xx_timer_tick(0);
+}
+
+static void bcm47xx_wdt_pause(void)
+{
+	del_timer_sync(&wdt_timer);
+	bcm47xx_wdt_hw_stop();
+}
+
+static void bcm47xx_wdt_stop(void)
+{
+	bcm47xx_wdt_pause();
+}
+
+static int bcm47xx_wdt_settimeout(int new_time)
+{
+	if ((new_time <= 0) || (new_time > WDT_MAX_TIME))
+		return -EINVAL;
+
+	wdt_time = new_time;
+	return 0;
+}
+
+static int bcm47xx_wdt_open(struct inode *inode, struct file *file)
+{
+	if (test_and_set_bit(0, &bcm47xx_wdt_busy))
+		return -EBUSY;
+
+	bcm47xx_wdt_start();
+	return nonseekable_open(inode, file);
+}
+
+static int bcm47xx_wdt_release(struct inode *inode, struct file *file)
+{
+	if (expect_release == 42) {
+		bcm47xx_wdt_stop();
+	} else {
+		printk(KERN_CRIT DRV_NAME
+			": Unexpected close, not stopping watchdog!\n");
+		bcm47xx_wdt_start();
+	}
+
+	clear_bit(0, &bcm47xx_wdt_busy);
+	expect_release = 0;
+	return 0;
+}
+
+static ssize_t bcm47xx_wdt_write(struct file *file, const char __user *data,
+				size_t len, loff_t *ppos)
+{
+	if (len) {
+		if (!nowayout) {
+			size_t i;
+
+			expect_release = 0;
+
+			for (i = 0; i != len; i++) {
+				char c;
+				if (get_user(c, data + i))
+					return -EFAULT;
+				if (c == 'V')
+					expect_release = 42;
+			}
+		}
+		bcm47xx_wdt_pet();
+	}
+	return len;
+}
+
+static struct watchdog_info bcm47xx_wdt_info = {
+	.identity 	= DRV_NAME,
+	.options 	= WDIOF_SETTIMEOUT |
+				WDIOF_KEEPALIVEPING |
+				WDIOF_MAGICCLOSE,
+};
+
+static long bcm47xx_wdt_ioctl(struct file *file,
+					unsigned int cmd, unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
+	int new_value, retval = -EINVAL;;
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &bcm47xx_wdt_info,
+				sizeof(bcm47xx_wdt_info)) ? -EFAULT : 0;
+
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+
+	case WDIOC_SETOPTIONS:
+		if (get_user(new_value, p))
+			return -EFAULT;
+
+		if (new_value & WDIOS_DISABLECARD) {
+			bcm47xx_wdt_stop();
+			retval = 0;
+		}
+
+		if (new_value & WDIOS_ENABLECARD) {
+			bcm47xx_wdt_start();
+			retval = 0;
+		}
+
+		return retval;
+
+	case WDIOC_KEEPALIVE:
+		bcm47xx_wdt_pet();
+		return 0;
+
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_value, p))
+			return -EFAULT;
+
+		if (bcm47xx_wdt_settimeout(new_value))
+			return -EINVAL;
+
+		bcm47xx_wdt_pet();
+
+	case WDIOC_GETTIMEOUT:
+		return put_user(wdt_time, p);
+
+	default:
+		return -ENOTTY;
+	}
+}
+
+static int bcm47xx_wdt_notify_sys(struct notifier_block *this,
+	unsigned long code, void *unused)
+{
+	if (code == SYS_DOWN || code == SYS_HALT)
+		bcm47xx_wdt_stop();
+	return NOTIFY_DONE;
+}
+
+static const struct file_operations bcm47xx_wdt_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.unlocked_ioctl	= bcm47xx_wdt_ioctl,
+	.open		= bcm47xx_wdt_open,
+	.release	= bcm47xx_wdt_release,
+	.write		= bcm47xx_wdt_write,
+};
+
+static struct miscdevice bcm47xx_wdt_miscdev = {
+	.minor		= WATCHDOG_MINOR,
+	.name		= "watchdog",
+	.fops		= &bcm47xx_wdt_fops,
+};
+
+static struct notifier_block bcm47xx_wdt_notifier = {
+	.notifier_call = bcm47xx_wdt_notify_sys,
+};
+
+static int __init bcm47xx_wdt_init(void)
+{
+	int ret;
+
+	if (bcm47xx_wdt_hw_stop() < 0)
+		return -ENODEV;
+
+	setup_timer(&wdt_timer, bcm47xx_timer_tick, 0L);
+
+	if (bcm47xx_wdt_settimeout(wdt_time)) {
+		bcm47xx_wdt_settimeout(WDT_DEFAULT_TIME);
+		printk(KERN_INFO DRV_NAME ": "
+			"wdt_time value must be 0 < wdt_time < %d, using %d\n",
+			(WDT_MAX_TIME + 1), wdt_time);
+	}
+
+	ret = register_reboot_notifier(&bcm47xx_wdt_notifier);
+	if (ret)
+		return ret;
+
+	ret = misc_register(&bcm47xx_wdt_miscdev);
+	if (ret) {
+		unregister_reboot_notifier(&bcm47xx_wdt_notifier);
+		return ret;
+	}
+
+	printk(KERN_INFO "BCM47xx Watchdog Timer enabled (%d seconds%s)\n",
+				wdt_time, nowayout ? ", nowayout" : "");
+	return 0;
+}
+
+static void __exit bcm47xx_wdt_exit(void)
+{
+	if (!nowayout)
+		bcm47xx_wdt_stop();
+
+	misc_deregister(&bcm47xx_wdt_miscdev);
+
+	unregister_reboot_notifier(&bcm47xx_wdt_notifier);
+}
+
+module_init(bcm47xx_wdt_init);
+module_exit(bcm47xx_wdt_exit);
+
+MODULE_AUTHOR("Aleksandar Radovanovic");
+MODULE_DESCRIPTION("Watchdog driver for Broadcom BCM47xx");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/drivers/watchdog/coh901327_wdt.c b/drivers/watchdog/coh901327_wdt.c
new file mode 100644
index 0000000..fecb307
--- /dev/null
+++ b/drivers/watchdog/coh901327_wdt.c
@@ -0,0 +1,537 @@
+/*
+ * coh901327_wdt.c
+ *
+ * Copyright (C) 2008-2009 ST-Ericsson AB
+ * License terms: GNU General Public License (GPL) version 2
+ * Watchdog driver for the ST-Ericsson AB COH 901 327 IP core
+ * Author: Linus Walleij <linus.walleij@stericsson.com>
+ */
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+#include <linux/watchdog.h>
+#include <linux/interrupt.h>
+#include <linux/pm.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/bitops.h>
+#include <linux/uaccess.h>
+#include <linux/clk.h>
+
+#define DRV_NAME "WDOG COH 901 327"
+
+/*
+ * COH 901 327 register definitions
+ */
+
+/* WDOG_FEED Register 32bit (-/W) */
+#define U300_WDOG_FR							0x00
+#define U300_WDOG_FR_FEED_RESTART_TIMER					0xFEEDU
+/* WDOG_TIMEOUT Register 32bit (R/W) */
+#define U300_WDOG_TR							0x04
+#define U300_WDOG_TR_TIMEOUT_MASK					0x7FFFU
+/* WDOG_DISABLE1 Register 32bit (-/W) */
+#define U300_WDOG_D1R							0x08
+#define U300_WDOG_D1R_DISABLE1_DISABLE_TIMER				0x2BADU
+/* WDOG_DISABLE2 Register 32bit (R/W) */
+#define U300_WDOG_D2R							0x0C
+#define U300_WDOG_D2R_DISABLE2_DISABLE_TIMER				0xCAFEU
+#define U300_WDOG_D2R_DISABLE_STATUS_DISABLED				0xDABEU
+#define U300_WDOG_D2R_DISABLE_STATUS_ENABLED				0x0000U
+/* WDOG_STATUS Register 32bit (R/W) */
+#define U300_WDOG_SR							0x10
+#define U300_WDOG_SR_STATUS_TIMED_OUT					0xCFE8U
+#define U300_WDOG_SR_STATUS_NORMAL					0x0000U
+#define U300_WDOG_SR_RESET_STATUS_RESET					0xE8B4U
+/* WDOG_COUNT Register 32bit (R/-) */
+#define U300_WDOG_CR							0x14
+#define U300_WDOG_CR_VALID_IND						0x8000U
+#define U300_WDOG_CR_VALID_STABLE					0x0000U
+#define U300_WDOG_CR_COUNT_VALUE_MASK					0x7FFFU
+/* WDOG_JTAGOVR Register 32bit (R/W) */
+#define U300_WDOG_JOR							0x18
+#define U300_WDOG_JOR_JTAG_MODE_IND					0x0002U
+#define U300_WDOG_JOR_JTAG_WATCHDOG_ENABLE				0x0001U
+/* WDOG_RESTART Register 32bit (-/W) */
+#define U300_WDOG_RR							0x1C
+#define U300_WDOG_RR_RESTART_VALUE_RESUME				0xACEDU
+/* WDOG_IRQ_EVENT Register 32bit (R/W) */
+#define U300_WDOG_IER							0x20
+#define U300_WDOG_IER_WILL_BARK_IRQ_EVENT_IND				0x0001U
+#define U300_WDOG_IER_WILL_BARK_IRQ_ACK_ENABLE				0x0001U
+/* WDOG_IRQ_MASK Register 32bit (R/W) */
+#define U300_WDOG_IMR							0x24
+#define U300_WDOG_IMR_WILL_BARK_IRQ_ENABLE				0x0001U
+/* WDOG_IRQ_FORCE Register 32bit (R/W) */
+#define U300_WDOG_IFR							0x28
+#define U300_WDOG_IFR_WILL_BARK_IRQ_FORCE_ENABLE			0x0001U
+
+/* Default timeout in seconds = 1 minute */
+static int margin = 60;
+static resource_size_t phybase;
+static resource_size_t physize;
+static int irq;
+static void __iomem *virtbase;
+static unsigned long coh901327_users;
+static unsigned long boot_status;
+static u16 wdogenablestore;
+static u16 irqmaskstore;
+static struct device *parent;
+
+/*
+ * The watchdog block is of course always clocked, the
+ * clk_enable()/clk_disable() calls are mainly for performing reference
+ * counting higher up in the clock hierarchy.
+ */
+static struct clk *clk;
+
+/*
+ * Enabling and disabling functions.
+ */
+static void coh901327_enable(u16 timeout)
+{
+	u16 val;
+
+	clk_enable(clk);
+	/* Restart timer if it is disabled */
+	val = readw(virtbase + U300_WDOG_D2R);
+	if (val == U300_WDOG_D2R_DISABLE_STATUS_DISABLED)
+		writew(U300_WDOG_RR_RESTART_VALUE_RESUME,
+		       virtbase + U300_WDOG_RR);
+	/* Acknowledge any pending interrupt so it doesn't just fire off */
+	writew(U300_WDOG_IER_WILL_BARK_IRQ_ACK_ENABLE,
+	       virtbase + U300_WDOG_IER);
+	/* Enable the watchdog interrupt */
+	writew(U300_WDOG_IMR_WILL_BARK_IRQ_ENABLE, virtbase + U300_WDOG_IMR);
+	/* Activate the watchdog timer */
+	writew(timeout, virtbase + U300_WDOG_TR);
+	/* Start the watchdog timer */
+	writew(U300_WDOG_FR_FEED_RESTART_TIMER, virtbase + U300_WDOG_FR);
+	/*
+	 * Extra read so that this change propagate in the watchdog.
+	 */
+	(void) readw(virtbase + U300_WDOG_CR);
+	val = readw(virtbase + U300_WDOG_D2R);
+	clk_disable(clk);
+	if (val != U300_WDOG_D2R_DISABLE_STATUS_ENABLED)
+		dev_err(parent,
+			"%s(): watchdog not enabled! D2R value %04x\n",
+			__func__, val);
+}
+
+static void coh901327_disable(void)
+{
+	u16 val;
+
+	clk_enable(clk);
+	/* Disable the watchdog interrupt if it is active */
+	writew(0x0000U, virtbase + U300_WDOG_IMR);
+	/* If the watchdog is currently enabled, attempt to disable it */
+	val = readw(virtbase + U300_WDOG_D2R);
+	if (val != U300_WDOG_D2R_DISABLE_STATUS_DISABLED) {
+		writew(U300_WDOG_D1R_DISABLE1_DISABLE_TIMER,
+		       virtbase + U300_WDOG_D1R);
+		writew(U300_WDOG_D2R_DISABLE2_DISABLE_TIMER,
+		       virtbase + U300_WDOG_D2R);
+		/* Write this twice (else problems occur) */
+		writew(U300_WDOG_D2R_DISABLE2_DISABLE_TIMER,
+		       virtbase + U300_WDOG_D2R);
+	}
+	val = readw(virtbase + U300_WDOG_D2R);
+	clk_disable(clk);
+	if (val != U300_WDOG_D2R_DISABLE_STATUS_DISABLED)
+		dev_err(parent,
+			"%s(): watchdog not disabled! D2R value %04x\n",
+			__func__, val);
+}
+
+static void coh901327_start(void)
+{
+	coh901327_enable(margin * 100);
+}
+
+static void coh901327_keepalive(void)
+{
+	clk_enable(clk);
+	/* Feed the watchdog */
+	writew(U300_WDOG_FR_FEED_RESTART_TIMER,
+	       virtbase + U300_WDOG_FR);
+	clk_disable(clk);
+}
+
+static int coh901327_settimeout(int time)
+{
+	/*
+	 * Max margin is 327 since the 10ms
+	 * timeout register is max
+	 * 0x7FFF = 327670ms ~= 327s.
+	 */
+	if (time <= 0 || time > 327)
+		return -EINVAL;
+
+	margin = time;
+	clk_enable(clk);
+	/* Set new timeout value */
+	writew(margin * 100, virtbase + U300_WDOG_TR);
+	/* Feed the dog */
+	writew(U300_WDOG_FR_FEED_RESTART_TIMER,
+	       virtbase + U300_WDOG_FR);
+	clk_disable(clk);
+	return 0;
+}
+
+/*
+ * This interrupt occurs 10 ms before the watchdog WILL bark.
+ */
+static irqreturn_t coh901327_interrupt(int irq, void *data)
+{
+	u16 val;
+
+	/*
+	 * Ack IRQ? If this occurs we're FUBAR anyway, so
+	 * just acknowledge, disable the interrupt and await the imminent end.
+	 * If you at some point need a host of callbacks to be called
+	 * when the system is about to watchdog-reset, add them here!
+	 *
+	 * NOTE: on future versions of this IP-block, it will be possible
+	 * to prevent a watchdog reset by feeding the watchdog at this
+	 * point.
+	 */
+	clk_enable(clk);
+	val = readw(virtbase + U300_WDOG_IER);
+	if (val == U300_WDOG_IER_WILL_BARK_IRQ_EVENT_IND)
+		writew(U300_WDOG_IER_WILL_BARK_IRQ_ACK_ENABLE,
+		       virtbase + U300_WDOG_IER);
+	writew(0x0000U, virtbase + U300_WDOG_IMR);
+	clk_disable(clk);
+	dev_crit(parent, "watchdog is barking!\n");
+	return IRQ_HANDLED;
+}
+
+/*
+ * Allow only one user (daemon) to open the watchdog
+ */
+static int coh901327_open(struct inode *inode, struct file *file)
+{
+	if (test_and_set_bit(1, &coh901327_users))
+		return -EBUSY;
+	coh901327_start();
+	return nonseekable_open(inode, file);
+}
+
+static int coh901327_release(struct inode *inode, struct file *file)
+{
+	clear_bit(1, &coh901327_users);
+	coh901327_disable();
+	return 0;
+}
+
+static ssize_t coh901327_write(struct file *file, const char __user *data,
+			       size_t len, loff_t *ppos)
+{
+	if (len)
+		coh901327_keepalive();
+	return len;
+}
+
+static long coh901327_ioctl(struct file *file, unsigned int cmd,
+			    unsigned long arg)
+{
+	int ret = -ENOTTY;
+	u16 val;
+	int time;
+	int new_options;
+	union {
+		struct watchdog_info __user *ident;
+		int __user *i;
+	} uarg;
+	static struct watchdog_info ident = {
+		.options		= WDIOF_CARDRESET |
+					  WDIOF_SETTIMEOUT |
+					  WDIOF_KEEPALIVEPING,
+		.identity		= "COH 901 327 Watchdog",
+		.firmware_version	= 1,
+	};
+	uarg.i = (int __user *)arg;
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		ret = copy_to_user(uarg.ident, &ident,
+				   sizeof(ident)) ? -EFAULT : 0;
+		break;
+
+	case WDIOC_GETSTATUS:
+		ret = put_user(0, uarg.i);
+		break;
+
+	case WDIOC_GETBOOTSTATUS:
+		ret = put_user(boot_status, uarg.i);
+		break;
+
+	case WDIOC_SETOPTIONS:
+		ret = get_user(new_options, uarg.i);
+		if (ret)
+			break;
+		if (new_options & WDIOS_DISABLECARD)
+			coh901327_disable();
+		if (new_options & WDIOS_ENABLECARD)
+			coh901327_start();
+		ret = 0;
+		break;
+
+	case WDIOC_KEEPALIVE:
+		coh901327_keepalive();
+		ret = 0;
+		break;
+
+	case WDIOC_SETTIMEOUT:
+		ret = get_user(time, uarg.i);
+		if (ret)
+			break;
+
+		ret = coh901327_settimeout(time);
+		if (ret)
+			break;
+		/* Then fall through to return set value */
+
+	case WDIOC_GETTIMEOUT:
+		ret = put_user(margin, uarg.i);
+		break;
+
+	case WDIOC_GETTIMELEFT:
+		clk_enable(clk);
+		/* Read repeatedly until the value is stable! */
+		val = readw(virtbase + U300_WDOG_CR);
+		while (val & U300_WDOG_CR_VALID_IND)
+			val = readw(virtbase + U300_WDOG_CR);
+		val &= U300_WDOG_CR_COUNT_VALUE_MASK;
+		clk_disable(clk);
+		if (val != 0)
+			val /= 100;
+		ret = put_user(val, uarg.i);
+		break;
+	}
+	return ret;
+}
+
+static const struct file_operations coh901327_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.write		= coh901327_write,
+	.unlocked_ioctl	= coh901327_ioctl,
+	.open		= coh901327_open,
+	.release	= coh901327_release,
+};
+
+static struct miscdevice coh901327_miscdev = {
+	.minor		= WATCHDOG_MINOR,
+	.name		= "watchdog",
+	.fops		= &coh901327_fops,
+};
+
+static int __exit coh901327_remove(struct platform_device *pdev)
+{
+	misc_deregister(&coh901327_miscdev);
+	coh901327_disable();
+	free_irq(irq, pdev);
+	clk_put(clk);
+	iounmap(virtbase);
+	release_mem_region(phybase, physize);
+	return 0;
+}
+
+
+static int __init coh901327_probe(struct platform_device *pdev)
+{
+	int ret;
+	u16 val;
+	struct resource *res;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENOENT;
+
+	parent = &pdev->dev;
+	physize = resource_size(res);
+	phybase = res->start;
+
+	if (request_mem_region(phybase, physize, DRV_NAME) == NULL) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	virtbase = ioremap(phybase, physize);
+	if (!virtbase) {
+		ret = -ENOMEM;
+		goto out_no_remap;
+	}
+
+	clk = clk_get(&pdev->dev, NULL);
+	if (IS_ERR(clk)) {
+		ret = PTR_ERR(clk);
+		dev_err(&pdev->dev, "could not get clock\n");
+		goto out_no_clk;
+	}
+	ret = clk_enable(clk);
+	if (ret) {
+		dev_err(&pdev->dev, "could not enable clock\n");
+		goto out_no_clk_enable;
+	}
+
+	val = readw(virtbase + U300_WDOG_SR);
+	switch (val) {
+	case U300_WDOG_SR_STATUS_TIMED_OUT:
+		dev_info(&pdev->dev,
+			"watchdog timed out since last chip reset!\n");
+		boot_status = WDIOF_CARDRESET;
+		/* Status will be cleared below */
+		break;
+	case U300_WDOG_SR_STATUS_NORMAL:
+		dev_info(&pdev->dev,
+			"in normal status, no timeouts have occurred.\n");
+		break;
+	default:
+		dev_info(&pdev->dev,
+			"contains an illegal status code (%08x)\n", val);
+		break;
+	}
+
+	val = readw(virtbase + U300_WDOG_D2R);
+	switch (val) {
+	case U300_WDOG_D2R_DISABLE_STATUS_DISABLED:
+		dev_info(&pdev->dev, "currently disabled.\n");
+		break;
+	case U300_WDOG_D2R_DISABLE_STATUS_ENABLED:
+		dev_info(&pdev->dev,
+			 "currently enabled! (disabling it now)\n");
+		coh901327_disable();
+		break;
+	default:
+		dev_err(&pdev->dev,
+			"contains an illegal enable/disable code (%08x)\n",
+			val);
+		break;
+	}
+
+	/* Reset the watchdog */
+	writew(U300_WDOG_SR_RESET_STATUS_RESET, virtbase + U300_WDOG_SR);
+
+	irq = platform_get_irq(pdev, 0);
+	if (request_irq(irq, coh901327_interrupt, IRQF_DISABLED,
+			DRV_NAME " Bark", pdev)) {
+		ret = -EIO;
+		goto out_no_irq;
+	}
+
+	clk_disable(clk);
+
+	ret = misc_register(&coh901327_miscdev);
+	if (ret == 0)
+		dev_info(&pdev->dev,
+			 "initialized. timer margin=%d sec\n", margin);
+	else
+		goto out_no_wdog;
+
+	return 0;
+
+out_no_wdog:
+	free_irq(irq, pdev);
+out_no_irq:
+	clk_disable(clk);
+out_no_clk_enable:
+	clk_put(clk);
+out_no_clk:
+	iounmap(virtbase);
+out_no_remap:
+	release_mem_region(phybase, SZ_4K);
+out:
+	return ret;
+}
+
+#ifdef CONFIG_PM
+static int coh901327_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	irqmaskstore = readw(virtbase + U300_WDOG_IMR) & 0x0001U;
+	wdogenablestore = readw(virtbase + U300_WDOG_D2R);
+	/* If watchdog is on, disable it here and now */
+	if (wdogenablestore == U300_WDOG_D2R_DISABLE_STATUS_ENABLED)
+		coh901327_disable();
+	return 0;
+}
+
+static int coh901327_resume(struct platform_device *pdev)
+{
+	/* Restore the watchdog interrupt */
+	writew(irqmaskstore, virtbase + U300_WDOG_IMR);
+	if (wdogenablestore == U300_WDOG_D2R_DISABLE_STATUS_ENABLED) {
+		/* Restart the watchdog timer */
+		writew(U300_WDOG_RR_RESTART_VALUE_RESUME,
+		       virtbase + U300_WDOG_RR);
+		writew(U300_WDOG_FR_FEED_RESTART_TIMER,
+		       virtbase + U300_WDOG_FR);
+	}
+	return 0;
+}
+#else
+#define coh901327_suspend NULL
+#define coh901327_resume  NULL
+#endif
+
+/*
+ * Mistreating the watchdog is the only way to perform a software reset of the
+ * system on EMP platforms. So we implement this and export a symbol for it.
+ */
+void coh901327_watchdog_reset(void)
+{
+	/* Enable even if on JTAG too */
+	writew(U300_WDOG_JOR_JTAG_WATCHDOG_ENABLE,
+	       virtbase + U300_WDOG_JOR);
+	/*
+	 * Timeout = 5s, we have to wait for the watchdog reset to
+	 * actually take place: the watchdog will be reloaded with the
+	 * default value immediately, so we HAVE to reboot and get back
+	 * into the kernel in 30s, or the device will reboot again!
+	 * The boot loader will typically deactivate the watchdog, so we
+	 * need time enough for the boot loader to get to the point of
+	 * deactivating the watchdog before it is shut down by it.
+	 *
+	 * NOTE: on future versions of the watchdog, this restriction is
+	 * gone: the watchdog will be reloaded with a defaul value (1 min)
+	 * instead of last value, and you can conveniently set the watchdog
+	 * timeout to 10ms (value = 1) without any problems.
+	 */
+	coh901327_enable(500);
+	/* Return and await doom */
+}
+
+static struct platform_driver coh901327_driver = {
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "coh901327_wdog",
+	},
+	.remove		= __exit_p(coh901327_remove),
+	.suspend	= coh901327_suspend,
+	.resume		= coh901327_resume,
+};
+
+static int __init coh901327_init(void)
+{
+	return platform_driver_probe(&coh901327_driver, coh901327_probe);
+}
+module_init(coh901327_init);
+
+static void __exit coh901327_exit(void)
+{
+	platform_driver_unregister(&coh901327_driver);
+}
+module_exit(coh901327_exit);
+
+MODULE_AUTHOR("Linus Walleij <linus.walleij@stericsson.com>");
+MODULE_DESCRIPTION("COH 901 327 Watchdog");
+
+module_param(margin, int, 0);
+MODULE_PARM_DESC(margin, "Watchdog margin in seconds (default 60s)");
+
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/drivers/watchdog/pnx833x_wdt.c b/drivers/watchdog/pnx833x_wdt.c
new file mode 100644
index 0000000..538ec2c
--- /dev/null
+++ b/drivers/watchdog/pnx833x_wdt.c
@@ -0,0 +1,282 @@
+/*
+ *  PNX833x Hardware Watchdog Driver
+ *  Copyright 2008 NXP Semiconductors
+ *  Daniel Laird <daniel.j.laird@nxp.com>
+ *  Andre McCurdy <andre.mccurdy@nxp.com>
+ *
+ *  Heavily based upon - IndyDog	0.3
+ *  A Hardware Watchdog Device for SGI IP22
+ *
+ * (c) Copyright 2002 Guido Guenther <agx@sigxcpu.org>, All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ *
+ * based on softdog.c by Alan Cox <alan@redhat.com>
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/miscdevice.h>
+#include <linux/watchdog.h>
+#include <linux/notifier.h>
+#include <linux/reboot.h>
+#include <linux/init.h>
+#include <asm/mach-pnx833x/pnx833x.h>
+
+#define PFX "pnx833x: "
+#define WATCHDOG_TIMEOUT 30		/* 30 sec Maximum timeout */
+#define WATCHDOG_COUNT_FREQUENCY 68000000U /* Watchdog counts at 68MHZ. */
+
+/** CONFIG block */
+#define PNX833X_CONFIG                      (0x07000U)
+#define PNX833X_CONFIG_CPU_WATCHDOG         (0x54)
+#define PNX833X_CONFIG_CPU_WATCHDOG_COMPARE (0x58)
+#define PNX833X_CONFIG_CPU_COUNTERS_CONTROL (0x1c)
+
+/** RESET block */
+#define PNX833X_RESET                       (0x08000U)
+#define PNX833X_RESET_CONFIG                (0x08)
+
+static int pnx833x_wdt_alive;
+
+/* Set default timeout in MHZ.*/
+static int pnx833x_wdt_timeout = (WATCHDOG_TIMEOUT * WATCHDOG_COUNT_FREQUENCY);
+module_param(pnx833x_wdt_timeout, int, 0);
+MODULE_PARM_DESC(timeout, "Watchdog timeout in Mhz. (68Mhz clock), default="
+			__MODULE_STRING(pnx833x_wdt_timeout) "(30 seconds).");
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
+					__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+static int start_enabled = 1;
+module_param(start_enabled, int, 0);
+MODULE_PARM_DESC(start_enabled, "Watchdog is started on module insertion "
+				"(default=" __MODULE_STRING(start_enabled) ")");
+
+static void pnx833x_wdt_start(void)
+{
+	/* Enable watchdog causing reset. */
+	PNX833X_REG(PNX833X_RESET + PNX833X_RESET_CONFIG) |= 0x1;
+	/* Set timeout.*/
+	PNX833X_REG(PNX833X_CONFIG +
+		PNX833X_CONFIG_CPU_WATCHDOG_COMPARE) = pnx833x_wdt_timeout;
+	/* Enable watchdog. */
+	PNX833X_REG(PNX833X_CONFIG +
+				PNX833X_CONFIG_CPU_COUNTERS_CONTROL) |= 0x1;
+
+	printk(KERN_INFO PFX "Started watchdog timer.\n");
+}
+
+static void pnx833x_wdt_stop(void)
+{
+	/* Disable watchdog causing reset. */
+	PNX833X_REG(PNX833X_RESET + PNX833X_CONFIG) &= 0xFFFFFFFE;
+	/* Disable watchdog.*/
+	PNX833X_REG(PNX833X_CONFIG +
+			PNX833X_CONFIG_CPU_COUNTERS_CONTROL) &= 0xFFFFFFFE;
+
+	printk(KERN_INFO PFX "Stopped watchdog timer.\n");
+}
+
+static void pnx833x_wdt_ping(void)
+{
+	PNX833X_REG(PNX833X_CONFIG +
+		PNX833X_CONFIG_CPU_WATCHDOG_COMPARE) = pnx833x_wdt_timeout;
+}
+
+/*
+ *	Allow only one person to hold it open
+ */
+static int pnx833x_wdt_open(struct inode *inode, struct file *file)
+{
+	if (test_and_set_bit(0, &pnx833x_wdt_alive))
+		return -EBUSY;
+
+	if (nowayout)
+		__module_get(THIS_MODULE);
+
+	/* Activate timer */
+	if (!start_enabled)
+		pnx833x_wdt_start();
+
+	pnx833x_wdt_ping();
+
+	printk(KERN_INFO "Started watchdog timer.\n");
+
+	return nonseekable_open(inode, file);
+}
+
+static int pnx833x_wdt_release(struct inode *inode, struct file *file)
+{
+	/* Shut off the timer.
+	 * Lock it in if it's a module and we defined ...NOWAYOUT */
+	if (!nowayout)
+		pnx833x_wdt_stop(); /* Turn the WDT off */
+
+	clear_bit(0, &pnx833x_wdt_alive);
+	return 0;
+}
+
+static ssize_t pnx833x_wdt_write(struct file *file, const char *data, size_t len, loff_t *ppos)
+{
+	/* Refresh the timer. */
+	if (len)
+		pnx833x_wdt_ping();
+
+	return len;
+}
+
+static long pnx833x_wdt_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
+{
+	int options, new_timeout = 0;
+	uint32_t timeout, timeout_left = 0;
+
+	static struct watchdog_info ident = {
+		.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT,
+		.firmware_version = 0,
+		.identity = "Hardware Watchdog for PNX833x",
+	};
+
+	switch (cmd) {
+	default:
+		return -ENOTTY;
+
+	case WDIOC_GETSUPPORT:
+		if (copy_to_user((struct watchdog_info *)arg,
+				 &ident, sizeof(ident)))
+			return -EFAULT;
+		return 0;
+
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, (int *)arg);
+
+	case WDIOC_SETOPTIONS:
+		if (get_user(options, (int *)arg))
+			return -EFAULT;
+
+		if (options & WDIOS_DISABLECARD)
+			pnx833x_wdt_stop();
+
+		if (options & WDIOS_ENABLECARD)
+			pnx833x_wdt_start();
+
+		return 0;
+
+	case WDIOC_KEEPALIVE:
+		pnx833x_wdt_ping();
+		return 0;
+
+	case WDIOC_SETTIMEOUT:
+	{
+		if (get_user(new_timeout, (int *)arg))
+			return -EFAULT;
+
+		pnx833x_wdt_timeout = new_timeout;
+		PNX833X_REG(PNX833X_CONFIG +
+			PNX833X_CONFIG_CPU_WATCHDOG_COMPARE) = new_timeout;
+		return put_user(new_timeout, (int *)arg);
+	}
+
+	case WDIOC_GETTIMEOUT:
+		timeout = PNX833X_REG(PNX833X_CONFIG +
+					PNX833X_CONFIG_CPU_WATCHDOG_COMPARE);
+		return put_user(timeout, (int *)arg);
+
+	case WDIOC_GETTIMELEFT:
+		timeout_left = PNX833X_REG(PNX833X_CONFIG +
+						PNX833X_CONFIG_CPU_WATCHDOG);
+		return put_user(timeout_left, (int *)arg);
+
+	}
+}
+
+static int pnx833x_wdt_notify_sys(struct notifier_block *this,
+					unsigned long code, void *unused)
+{
+	if (code == SYS_DOWN || code == SYS_HALT)
+		pnx833x_wdt_stop(); /* Turn the WDT off */
+
+	return NOTIFY_DONE;
+}
+
+static const struct file_operations pnx833x_wdt_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.write		= pnx833x_wdt_write,
+	.unlocked_ioctl	= pnx833x_wdt_ioctl,
+	.open		= pnx833x_wdt_open,
+	.release	= pnx833x_wdt_release,
+};
+
+static struct miscdevice pnx833x_wdt_miscdev = {
+	.minor		= WATCHDOG_MINOR,
+	.name		= "watchdog",
+	.fops		= &pnx833x_wdt_fops,
+};
+
+static struct notifier_block pnx833x_wdt_notifier = {
+	.notifier_call = pnx833x_wdt_notify_sys,
+};
+
+static char banner[] __initdata =
+	KERN_INFO PFX "Hardware Watchdog Timer for PNX833x: Version 0.1\n";
+
+static int __init watchdog_init(void)
+{
+	int ret, cause;
+
+	/* Lets check the reason for the reset.*/
+	cause = PNX833X_REG(PNX833X_RESET);
+	/*If bit 31 is set then watchdog was cause of reset.*/
+	if (cause & 0x80000000) {
+		printk(KERN_INFO PFX "The system was previously reset due to "
+			"the watchdog firing - please investigate...\n");
+	}
+
+	ret = register_reboot_notifier(&pnx833x_wdt_notifier);
+	if (ret) {
+		printk(KERN_ERR PFX
+			"cannot register reboot notifier (err=%d)\n", ret);
+		return ret;
+	}
+
+	ret = misc_register(&pnx833x_wdt_miscdev);
+	if (ret) {
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+			WATCHDOG_MINOR, ret);
+		unregister_reboot_notifier(&pnx833x_wdt_notifier);
+		return ret;
+	}
+
+	printk(banner);
+	if (start_enabled)
+		pnx833x_wdt_start();
+
+	return 0;
+}
+
+static void __exit watchdog_exit(void)
+{
+	misc_deregister(&pnx833x_wdt_miscdev);
+	unregister_reboot_notifier(&pnx833x_wdt_notifier);
+}
+
+module_init(watchdog_init);
+module_exit(watchdog_exit);
+
+MODULE_AUTHOR("Daniel Laird/Andre McCurdy");
+MODULE_DESCRIPTION("Hardware Watchdog Device for PNX833x");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/drivers/watchdog/stmp3xxx_wdt.c b/drivers/watchdog/stmp3xxx_wdt.c
new file mode 100644
index 0000000..5dd9526
--- /dev/null
+++ b/drivers/watchdog/stmp3xxx_wdt.c
@@ -0,0 +1,296 @@
+/*
+ * Watchdog driver for Freescale STMP37XX/STMP378X
+ *
+ * Author: Vitaly Wool <vital@embeddedalley.com>
+ *
+ * Copyright 2008 Freescale Semiconductor, Inc. All Rights Reserved.
+ * Copyright 2008 Embedded Alley Solutions, Inc All Rights Reserved.
+ */
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+#include <linux/watchdog.h>
+#include <linux/platform_device.h>
+#include <linux/spinlock.h>
+#include <linux/uaccess.h>
+
+#include <mach/platform.h>
+#include <mach/regs-rtc.h>
+
+#define DEFAULT_HEARTBEAT	19
+#define MAX_HEARTBEAT		(0x10000000 >> 6)
+
+/* missing bitmask in headers */
+#define BV_RTC_PERSISTENT1_GENERAL__RTC_FORCE_UPDATER     0x80000000
+
+#define WDT_IN_USE		0
+#define WDT_OK_TO_CLOSE		1
+
+#define WDOG_COUNTER_RATE	1000 /* 1 kHz clock */
+
+static DEFINE_SPINLOCK(stmp3xxx_wdt_io_lock);
+static unsigned long wdt_status;
+static const int nowayout = WATCHDOG_NOWAYOUT;
+static int heartbeat = DEFAULT_HEARTBEAT;
+static unsigned long boot_status;
+
+static void wdt_enable(u32 value)
+{
+	spin_lock(&stmp3xxx_wdt_io_lock);
+	__raw_writel(value, REGS_RTC_BASE + HW_RTC_WATCHDOG);
+	stmp3xxx_setl(BM_RTC_CTRL_WATCHDOGEN, REGS_RTC_BASE + HW_RTC_CTRL);
+	stmp3xxx_setl(BV_RTC_PERSISTENT1_GENERAL__RTC_FORCE_UPDATER,
+			REGS_RTC_BASE + HW_RTC_PERSISTENT1);
+	spin_unlock(&stmp3xxx_wdt_io_lock);
+}
+
+static void wdt_disable(void)
+{
+	spin_lock(&stmp3xxx_wdt_io_lock);
+	stmp3xxx_clearl(BV_RTC_PERSISTENT1_GENERAL__RTC_FORCE_UPDATER,
+			REGS_RTC_BASE + HW_RTC_PERSISTENT1);
+	stmp3xxx_clearl(BM_RTC_CTRL_WATCHDOGEN, REGS_RTC_BASE + HW_RTC_CTRL);
+	spin_unlock(&stmp3xxx_wdt_io_lock);
+}
+
+static void wdt_ping(void)
+{
+	wdt_enable(heartbeat * WDOG_COUNTER_RATE);
+}
+
+static int stmp3xxx_wdt_open(struct inode *inode, struct file *file)
+{
+	if (test_and_set_bit(WDT_IN_USE, &wdt_status))
+		return -EBUSY;
+
+	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
+	wdt_ping();
+
+	return nonseekable_open(inode, file);
+}
+
+static ssize_t stmp3xxx_wdt_write(struct file *file, const char __user *data,
+	size_t len, loff_t *ppos)
+{
+	if (len) {
+		if (!nowayout) {
+			size_t i;
+
+			clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
+
+			for (i = 0; i != len; i++) {
+				char c;
+
+				if (get_user(c, data + i))
+					return -EFAULT;
+				if (c == 'V')
+					set_bit(WDT_OK_TO_CLOSE, &wdt_status);
+			}
+		}
+		wdt_ping();
+	}
+
+	return len;
+}
+
+static struct watchdog_info ident = {
+	.options	= WDIOF_CARDRESET |
+			  WDIOF_MAGICCLOSE |
+			  WDIOF_SETTIMEOUT |
+			  WDIOF_KEEPALIVEPING,
+	.identity	= "STMP3XXX Watchdog",
+};
+
+static long stmp3xxx_wdt_ioctl(struct file *file, unsigned int cmd,
+	unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
+	int new_heartbeat, opts;
+	int ret = -ENOTTY;
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		ret = copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
+		break;
+
+	case WDIOC_GETSTATUS:
+		ret = put_user(0, p);
+		break;
+
+	case WDIOC_GETBOOTSTATUS:
+		ret = put_user(boot_status, p);
+		break;
+
+	case WDIOC_SETOPTIONS:
+		if (get_user(opts, p)) {
+			ret = -EFAULT;
+			break;
+		}
+		if (opts & WDIOS_DISABLECARD)
+			wdt_disable();
+		else if (opts & WDIOS_ENABLECARD)
+			wdt_ping();
+		else {
+			pr_debug("%s: unknown option 0x%x\n", __func__, opts);
+			ret = -EINVAL;
+			break;
+		}
+		ret = 0;
+		break;
+
+	case WDIOC_KEEPALIVE:
+		wdt_ping();
+		ret = 0;
+		break;
+
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_heartbeat, p)) {
+			ret = -EFAULT;
+			break;
+		}
+		if (new_heartbeat <= 0 || new_heartbeat > MAX_HEARTBEAT) {
+			ret = -EINVAL;
+			break;
+		}
+
+		heartbeat = new_heartbeat;
+		wdt_ping();
+		/* Fall through */
+
+	case WDIOC_GETTIMEOUT:
+		ret = put_user(heartbeat, p);
+		break;
+	}
+	return ret;
+}
+
+static int stmp3xxx_wdt_release(struct inode *inode, struct file *file)
+{
+	int ret = 0;
+
+	if (!nowayout) {
+		if (!test_bit(WDT_OK_TO_CLOSE, &wdt_status)) {
+			wdt_ping();
+			pr_debug("%s: Device closed unexpectdly\n", __func__);
+			ret = -EINVAL;
+		} else {
+			wdt_disable();
+			clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
+		}
+	}
+	clear_bit(WDT_IN_USE, &wdt_status);
+
+	return ret;
+}
+
+static const struct file_operations stmp3xxx_wdt_fops = {
+	.owner = THIS_MODULE,
+	.llseek = no_llseek,
+	.write = stmp3xxx_wdt_write,
+	.unlocked_ioctl = stmp3xxx_wdt_ioctl,
+	.open = stmp3xxx_wdt_open,
+	.release = stmp3xxx_wdt_release,
+};
+
+static struct miscdevice stmp3xxx_wdt_miscdev = {
+	.minor = WATCHDOG_MINOR,
+	.name = "watchdog",
+	.fops = &stmp3xxx_wdt_fops,
+};
+
+static int __devinit stmp3xxx_wdt_probe(struct platform_device *pdev)
+{
+	int ret = 0;
+
+	if (heartbeat < 1 || heartbeat > MAX_HEARTBEAT)
+		heartbeat = DEFAULT_HEARTBEAT;
+
+	boot_status = __raw_readl(REGS_RTC_BASE + HW_RTC_PERSISTENT1) &
+			BV_RTC_PERSISTENT1_GENERAL__RTC_FORCE_UPDATER;
+	boot_status = !!boot_status;
+	stmp3xxx_clearl(BV_RTC_PERSISTENT1_GENERAL__RTC_FORCE_UPDATER,
+			REGS_RTC_BASE + HW_RTC_PERSISTENT1);
+	wdt_disable();		/* disable for now */
+
+	ret = misc_register(&stmp3xxx_wdt_miscdev);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "cannot register misc device\n");
+		return ret;
+	}
+
+	printk(KERN_INFO "stmp3xxx watchdog: initialized, heartbeat %d sec\n",
+		heartbeat);
+
+	return ret;
+}
+
+static int __devexit stmp3xxx_wdt_remove(struct platform_device *pdev)
+{
+	misc_deregister(&stmp3xxx_wdt_miscdev);
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int wdt_suspended;
+static u32 wdt_saved_time;
+
+static int stmp3xxx_wdt_suspend(struct platform_device *pdev,
+				pm_message_t state)
+{
+	if (__raw_readl(REGS_RTC_BASE + HW_RTC_CTRL) &
+		BM_RTC_CTRL_WATCHDOGEN) {
+		wdt_suspended = 1;
+		wdt_saved_time = __raw_readl(REGS_RTC_BASE + HW_RTC_WATCHDOG);
+		wdt_disable();
+	}
+	return 0;
+}
+
+static int stmp3xxx_wdt_resume(struct platform_device *pdev)
+{
+	if (wdt_suspended) {
+		wdt_enable(wdt_saved_time);
+		wdt_suspended = 0;
+	}
+	return 0;
+}
+#else
+#define stmp3xxx_wdt_suspend	NULL
+#define stmp3xxx_wdt_resume	NULL
+#endif
+
+static struct platform_driver platform_wdt_driver = {
+	.driver = {
+		.name = "stmp3xxx_wdt",
+	},
+	.probe = stmp3xxx_wdt_probe,
+	.remove = __devexit_p(stmp3xxx_wdt_remove),
+	.suspend = stmp3xxx_wdt_suspend,
+	.resume = stmp3xxx_wdt_resume,
+};
+
+static int __init stmp3xxx_wdt_init(void)
+{
+	return platform_driver_register(&platform_wdt_driver);
+}
+
+static void __exit stmp3xxx_wdt_exit(void)
+{
+	return platform_driver_unregister(&platform_wdt_driver);
+}
+
+module_init(stmp3xxx_wdt_init);
+module_exit(stmp3xxx_wdt_exit);
+
+MODULE_DESCRIPTION("STMP3XXX Watchdog Driver");
+MODULE_LICENSE("GPL");
+
+module_param(heartbeat, int, 0);
+MODULE_PARM_DESC(heartbeat,
+		 "Watchdog heartbeat period in seconds from 1 to "
+		 __MODULE_STRING(MAX_HEARTBEAT) ", default "
+		 __MODULE_STRING(DEFAULT_HEARTBEAT));
+
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/drivers/watchdog/twl4030_wdt.c b/drivers/watchdog/twl4030_wdt.c
new file mode 100644
index 0000000..cb46556
--- /dev/null
+++ b/drivers/watchdog/twl4030_wdt.c
@@ -0,0 +1,272 @@
+/*
+ * Copyright (C) Nokia Corporation
+ *
+ * Written by Timo Kokkonen <timo.t.kokkonen at nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/watchdog.h>
+#include <linux/platform_device.h>
+#include <linux/miscdevice.h>
+#include <linux/uaccess.h>
+#include <linux/i2c/twl4030.h>
+
+#define TWL4030_WATCHDOG_CFG_REG_OFFS	0x3
+
+#define TWL4030_WDT_STATE_OPEN		0x1
+#define TWL4030_WDT_STATE_ACTIVE	0x8
+
+static struct platform_device *twl4030_wdt_dev;
+
+struct twl4030_wdt {
+	struct miscdevice	miscdev;
+	int			timer_margin;
+	unsigned long		state;
+};
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started "
+	"(default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+static int twl4030_wdt_write(unsigned char val)
+{
+	return twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, val,
+					TWL4030_WATCHDOG_CFG_REG_OFFS);
+}
+
+static int twl4030_wdt_enable(struct twl4030_wdt *wdt)
+{
+	return twl4030_wdt_write(wdt->timer_margin + 1);
+}
+
+static int twl4030_wdt_disable(struct twl4030_wdt *wdt)
+{
+	return twl4030_wdt_write(0);
+}
+
+static int twl4030_wdt_set_timeout(struct twl4030_wdt *wdt, int timeout)
+{
+	if (timeout < 0 || timeout > 30) {
+		dev_warn(wdt->miscdev.parent,
+			"Timeout can only be in the range [0-30] seconds");
+		return -EINVAL;
+	}
+	wdt->timer_margin = timeout;
+	return twl4030_wdt_enable(wdt);
+}
+
+static ssize_t twl4030_wdt_write_fop(struct file *file,
+		const char __user *data, size_t len, loff_t *ppos)
+{
+	struct twl4030_wdt *wdt = file->private_data;
+
+	if (len)
+		twl4030_wdt_enable(wdt);
+
+	return len;
+}
+
+static long twl4030_wdt_ioctl(struct file *file,
+		unsigned int cmd, unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
+	int new_margin;
+	struct twl4030_wdt *wdt = file->private_data;
+
+	static const struct watchdog_info twl4030_wd_ident = {
+		.identity = "TWL4030 Watchdog",
+		.options = WDIOF_SETTIMEOUT,
+		.firmware_version = 0,
+	};
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &twl4030_wd_ident,
+				sizeof(twl4030_wd_ident)) ? -EFAULT : 0;
+
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+
+	case WDIOC_KEEPALIVE:
+		twl4030_wdt_enable(wdt);
+		break;
+
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_margin, p))
+			return -EFAULT;
+		if (twl4030_wdt_set_timeout(wdt, new_margin))
+			return -EINVAL;
+		return put_user(wdt->timer_margin, p);
+
+	case WDIOC_GETTIMEOUT:
+		return put_user(wdt->timer_margin, p);
+
+	default:
+		return -ENOTTY;
+	}
+
+	return 0;
+}
+
+static int twl4030_wdt_open(struct inode *inode, struct file *file)
+{
+	struct twl4030_wdt *wdt = platform_get_drvdata(twl4030_wdt_dev);
+
+	/* /dev/watchdog can only be opened once */
+	if (test_and_set_bit(0, &wdt->state))
+		return -EBUSY;
+
+	wdt->state |= TWL4030_WDT_STATE_ACTIVE;
+	file->private_data = (void *) wdt;
+
+	twl4030_wdt_enable(wdt);
+	return nonseekable_open(inode, file);
+}
+
+static int twl4030_wdt_release(struct inode *inode, struct file *file)
+{
+	struct twl4030_wdt *wdt = file->private_data;
+	if (nowayout) {
+		dev_alert(wdt->miscdev.parent,
+		       "Unexpected close, watchdog still running!\n");
+		twl4030_wdt_enable(wdt);
+	} else {
+		if (twl4030_wdt_disable(wdt))
+			return -EFAULT;
+		wdt->state &= ~TWL4030_WDT_STATE_ACTIVE;
+	}
+
+	clear_bit(0, &wdt->state);
+	return 0;
+}
+
+static const struct file_operations twl4030_wdt_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.open		= twl4030_wdt_open,
+	.release	= twl4030_wdt_release,
+	.unlocked_ioctl	= twl4030_wdt_ioctl,
+	.write		= twl4030_wdt_write_fop,
+};
+
+static int __devinit twl4030_wdt_probe(struct platform_device *pdev)
+{
+	int ret = 0;
+	struct twl4030_wdt *wdt;
+
+	wdt = kzalloc(sizeof(struct twl4030_wdt), GFP_KERNEL);
+	if (!wdt)
+		return -ENOMEM;
+
+	wdt->state		= 0;
+	wdt->timer_margin	= 30;
+	wdt->miscdev.parent	= &pdev->dev;
+	wdt->miscdev.fops	= &twl4030_wdt_fops;
+	wdt->miscdev.minor	= WATCHDOG_MINOR;
+	wdt->miscdev.name	= "watchdog";
+
+	platform_set_drvdata(pdev, wdt);
+
+	twl4030_wdt_dev = pdev;
+
+	ret = misc_register(&wdt->miscdev);
+	if (ret) {
+		dev_err(wdt->miscdev.parent,
+			"Failed to register misc device\n");
+		platform_set_drvdata(pdev, NULL);
+		kfree(wdt);
+		twl4030_wdt_dev = NULL;
+		return ret;
+	}
+	return 0;
+}
+
+static int __devexit twl4030_wdt_remove(struct platform_device *pdev)
+{
+	struct twl4030_wdt *wdt = platform_get_drvdata(pdev);
+
+	if (wdt->state & TWL4030_WDT_STATE_ACTIVE)
+		if (twl4030_wdt_disable(wdt))
+			return -EFAULT;
+
+	wdt->state &= ~TWL4030_WDT_STATE_ACTIVE;
+	misc_deregister(&wdt->miscdev);
+
+	platform_set_drvdata(pdev, NULL);
+	kfree(wdt);
+	twl4030_wdt_dev = NULL;
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int twl4030_wdt_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct twl4030_wdt *wdt = platform_get_drvdata(pdev);
+	if (wdt->state & TWL4030_WDT_STATE_ACTIVE)
+		return twl4030_wdt_disable(wdt);
+
+	return 0;
+}
+
+static int twl4030_wdt_resume(struct platform_device *pdev)
+{
+	struct twl4030_wdt *wdt = platform_get_drvdata(pdev);
+	if (wdt->state & TWL4030_WDT_STATE_ACTIVE)
+		return twl4030_wdt_enable(wdt);
+
+	return 0;
+}
+#else
+#define twl4030_wdt_suspend        NULL
+#define twl4030_wdt_resume         NULL
+#endif
+
+static struct platform_driver twl4030_wdt_driver = {
+	.probe		= twl4030_wdt_probe,
+	.remove		= __devexit_p(twl4030_wdt_remove),
+	.suspend	= twl4030_wdt_suspend,
+	.resume		= twl4030_wdt_resume,
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= "twl4030_wdt",
+	},
+};
+
+static int __devinit twl4030_wdt_init(void)
+{
+	return platform_driver_register(&twl4030_wdt_driver);
+}
+module_init(twl4030_wdt_init);
+
+static void __devexit twl4030_wdt_exit(void)
+{
+	platform_driver_unregister(&twl4030_wdt_driver);
+}
+module_exit(twl4030_wdt_exit);
+
+MODULE_AUTHOR("Nokia Corporation");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+MODULE_ALIAS("platform:twl4030_wdt");
+
