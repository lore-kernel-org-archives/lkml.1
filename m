Return-Path: <linux-kernel-owner+w=401wt.eu-S1759244AbXGQJ6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759244AbXGQJ6n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 05:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbXGQJ6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 05:58:34 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:64989 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752135AbXGQJ6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 05:58:31 -0400
Date: Tue, 17 Jul 2007 12:01:44 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [WATCHDOG] v2.6.22 patches part 1
Message-ID: <20070717100144.GA24169@infomag.infomag.iguana.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 drivers/char/watchdog/Kconfig            |    9 +
 drivers/char/watchdog/Makefile           |    3 
 drivers/char/watchdog/at32ap700x_wdt.c   |  386 +++++++++++++++++++++++++++++++
 drivers/char/watchdog/ep93xx_wdt.c       |    4 
 drivers/char/watchdog/mixcomwd.c         |  127 ++++++----
 drivers/char/watchdog/pnx4008_wdt.c      |    4 
 drivers/char/watchdog/s3c2410_wdt.c      |   41 ++-
 12 files changed, 878 insertions(+), 393 deletions(-)

with these Changes:

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Tue Jul 3 17:59:29 2007 +0000

    [WATCHDOG] at32ap700x_wdt.c - Fix compilation warnings
    
    Fix warning:
    * ISO C90 forbids mixed declarations and code
    * passing argument 2 of ‘test_and_set_bit’ from incompatible pointer type
    * passing argument 2 of ‘clear_bit’ from incompatible pointer type
    
    Signed-off-by: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
    Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Cc: Andrew Morton <akpm@linux-foundation.org>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Tue Jul 3 17:59:04 2007 +0000

    [WATCHDOG] at32ap700x_wdt.c - Add spinlock support
    
    Add spinlock support so that forked children can't
    do different io stuff at the same time.
    
    Signed-off-by: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
    Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Cc: Andrew Morton <akpm@linux-foundation.org>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Wed Jun 20 23:36:43 2007 +0200

    [WATCHDOG] at32ap700x_wdt.c - Add nowayout + MAGICCLOSE features
    
    Add nowayout + MAGICCLOSE features.
    
    Signed-off-by: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
    Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Cc: Andrew Morton <akpm@linux-foundation.org>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Mon Jun 18 22:49:35 2007 +0200

    [WATCHDOG] at32ap700x_wdt.c - timeout module parameter patch
    
    integrate the timeout/heartbeat as a module parameter and not as
    a CONFIG_* value.
    
    Signed-off-by: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
    Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Cc: Andrew Morton <akpm@linux-foundation.org>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Sun Jun 17 19:34:23 2007 +0000

    [WATCHDOG] at32ap700x_wdt.c - checkpatch.pl-0.05 clean-up's
    
    need space after that ',' (ctx:VxV)
    inline keyword should sit between storage class and type
    
    Signed-off-by: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
    Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Cc: Andrew Morton <akpm@linux-foundation.org>

Author: Ben Dooks <ben-linux@fluff.org>
Date:   Thu Jun 14 12:08:55 2007 +0100

    [WATCHDOG] change s3c2410_wdt to using dev_() macros for output
    
    Move to using dev_info(), dev_dbg() and dev_err() for
    reporting information from the driver.
    
    Signed-off-by: Ben Dooks <ben-linux@fluff.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Ben Dooks <ben-linux@fluff.org>
Date:   Thu Jun 14 12:08:54 2007 +0100

    [WATCHDOG] s3c2410_wdt announce initialisation
    
    Announce the watchdog once the initialisation is
    complete. This aides debugging problems where the
    watchdog driver has been loaded and shows the
    current state for the user.
    
    Signed-off-by: Ben Dooks <ben-linux@fluff.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Date:   Fri Jun 8 11:03:01 2007 -0700

    [WATCHDOG] at32ap700x-wdt: add iounmap if probe function fails
    
    Signed-off-by: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
    Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Author: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Date:   Fri Jun 8 11:01:47 2007 -0700

    [WATCHDOG] at32ap700x-wdt: add missing iounmap in _remove
    
    Signed-off-by: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
    Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Thu Jun 7 16:08:53 2007 -0700

    [WATCHDOG] watchdog-driver-for-at32ap700x-devices-fix-2
    
    standard ifdef-reduction trick.
    
    Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
    Cc: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Thu Jun 7 16:06:43 2007 -0700

    [WATCHDOG] watchdog-driver-for-at32ap700x-devices-fix
    
    little fiddles.
    
    Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
    Cc: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Author: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Date:   Thu Jun 7 16:06:41 2007 -0700

    [WATCHDOG] Watchdog driver for AT32AP700X devices
    
    Add support for the built in watchdog in AT32AP700X devices.
    
    Tested on AT32AP7000 and ATSTK1000.
    
    Hardware documentation can be found in the AT32AP7000 datasheet.
    
    Signed-off-by: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
    Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Mon Jun 4 19:13:28 2007 +0000

    [WATCHDOG] Mixcom Watchdog - CodingStyle clean-up
    
    Small clean-up in line with CodingStyle guide-lines.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Mon Jun 4 18:35:41 2007 +0000

    [WATCHDOG] Mixcom Watchdog - clean-up printk's
    
    Clean-up printk's.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Mon Jun 4 18:35:41 2007 +0000

    [WATCHDOG] Mixcom Watchdog - clean-up printk's
    
    Clean-up printk's.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Sun Jun 3 20:46:05 2007 +0000

    [WATCHDOG] Mixcom Watchdog - checkcard part 2
    
    Convert the mixcom and flashcom card checks to a
    single checkcard call by creating a new structure
    that contains all io-ports and their id's.
    This is part of the port to the isa watchdog device
    driver.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Sun Jun 3 19:01:38 2007 +0000

    [WATCHDOG] Mixcom Watchdog - checkcard
    
    Simplify the mixcomwd_checkcard and flashcom_checkcard
    functions to one checkcard function as part of the
    port to an isa watchdog device driver.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Sun Jun 3 15:39:25 2007 +0000

    [WATCHDOG] Mixcom Watchdog - get rid of port offset's
    
    Get rid of the port offset's used for the
    mixcom and flashcom watchdog devices.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Sun Jun 3 15:22:32 2007 +0000

    [WATCHDOG] Mixcom Watchdog - update "Documentation"
    
    Robert Radez started cleaning up the mixcomwd driver
    in 2002. All his changes have been incorporated.
    Since he owns that credit -> document it correctly.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Robert P. J. Day <rpjday@mindspring.com>
Date:   Mon May 28 14:51:29 2007 -0400

    [WATCHDOG] Remove the redundant check for pwrite() in EP93XXX watchdog.
    
    Remove the redundant check for pwrite(), given that the open() routine
    already invokes nonseekable_open().
    
    Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Robert P. J. Day <rpjday@mindspring.com>
Date:   Mon May 28 14:55:06 2007 -0400

    [WATCHDOG] Remove the redundant check for pwrite() in pnx4008 watchdog.
    
    Given that the open routine already calls nonseekable_open(), remove
    the redundant check for pwrite().
    
    Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/char/watchdog/Kconfig b/drivers/char/watchdog/Kconfig
index 1cad32c..2f48ba3 100644
--- a/drivers/char/watchdog/Kconfig
+++ b/drivers/char/watchdog/Kconfig
@@ -187,6 +187,15 @@ config PNX4008_WATCHDOG
 
 	  Say N if you are unsure.
 
+# AVR32 Architecture
+
+config AT32AP700X_WDT
+	tristate "AT32AP700x watchdog"
+	depends on WATCHDOG && CPU_AT32AP7000
+	help
+	  Watchdog timer embedded into AT32AP700x devices. This will reboot
+	  your system when the timeout is reached.
+
 # X86 (i386 + ia64 + x86_64) Architecture
 
 config ACQUIRE_WDT
diff --git a/drivers/char/watchdog/Makefile b/drivers/char/watchdog/Makefile
index 8bfc00c..3907ec0 100644
--- a/drivers/char/watchdog/Makefile
+++ b/drivers/char/watchdog/Makefile
@@ -36,6 +36,9 @@ obj-$(CONFIG_21285_WATCHDOG) += mpcore_wdt.o
 obj-$(CONFIG_EP93XX_WATCHDOG) += ep93xx_wdt.o
 obj-$(CONFIG_PNX4008_WATCHDOG) += pnx4008_wdt.o
 
+# AVR32 Architecture
+obj-$(CONFIG_AT32AP700X_WDT) += at32ap700x_wdt.o
+
 # X86 (i386 + ia64 + x86_64) Architecture
 obj-$(CONFIG_ACQUIRE_WDT) += acquirewdt.o
 obj-$(CONFIG_ADVANTECH_WDT) += advantechwdt.o
diff --git a/drivers/char/watchdog/at32ap700x_wdt.c b/drivers/char/watchdog/at32ap700x_wdt.c
new file mode 100644
index 0000000..54a5161
--- /dev/null
+++ b/drivers/char/watchdog/at32ap700x_wdt.c
@@ -0,0 +1,386 @@
+/*
+ * Watchdog driver for Atmel AT32AP700X devices
+ *
+ * Copyright (C) 2005-2006 Atmel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/miscdevice.h>
+#include <linux/fs.h>
+#include <linux/platform_device.h>
+#include <linux/watchdog.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
+#include <linux/spinlock.h>
+
+#define TIMEOUT_MIN		1
+#define TIMEOUT_MAX		2
+#define TIMEOUT_DEFAULT		TIMEOUT_MAX
+
+/* module parameters */
+static int timeout =  TIMEOUT_DEFAULT;
+module_param(timeout, int, 0);
+MODULE_PARM_DESC(timeout,
+		"Timeout value. Limited to be 1 or 2 seconds. (default="
+		__MODULE_STRING(TIMEOUT_DEFAULT) ")");
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
+		__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+/* Watchdog registers and write/read macro */
+#define WDT_CTRL		0x00
+#define WDT_CTRL_EN		   0
+#define WDT_CTRL_PSEL		   8
+#define WDT_CTRL_KEY		  24
+
+#define WDT_CLR			0x04
+
+#define WDT_BIT(name)		(1 << WDT_##name)
+#define WDT_BF(name, value)	((value) << WDT_##name)
+
+#define wdt_readl(dev, reg)				\
+	__raw_readl((dev)->regs + WDT_##reg)
+#define wdt_writel(dev, reg, value)			\
+	__raw_writel((value), (dev)->regs + WDT_##reg)
+
+struct wdt_at32ap700x {
+	void __iomem		*regs;
+	spinlock_t		io_lock;
+	int			timeout;
+	unsigned long		users;
+	struct miscdevice	miscdev;
+};
+
+static struct wdt_at32ap700x *wdt;
+static char expect_release;
+
+/*
+ * Disable the watchdog.
+ */
+static inline void at32_wdt_stop(void)
+{
+	unsigned long psel;
+
+	spin_lock(&wdt->io_lock);
+	psel = wdt_readl(wdt, CTRL) & WDT_BF(CTRL_PSEL, 0x0f);
+	wdt_writel(wdt, CTRL, psel | WDT_BF(CTRL_KEY, 0x55));
+	wdt_writel(wdt, CTRL, psel | WDT_BF(CTRL_KEY, 0xaa));
+	spin_unlock(&wdt->io_lock);
+}
+
+/*
+ * Enable and reset the watchdog.
+ */
+static inline void at32_wdt_start(void)
+{
+	/* 0xf is 2^16 divider = 2 sec, 0xe is 2^15 divider = 1 sec */
+	unsigned long psel = (wdt->timeout > 1) ? 0xf : 0xe;
+
+	spin_lock(&wdt->io_lock);
+	wdt_writel(wdt, CTRL, WDT_BIT(CTRL_EN)
+			| WDT_BF(CTRL_PSEL, psel)
+			| WDT_BF(CTRL_KEY, 0x55));
+	wdt_writel(wdt, CTRL, WDT_BIT(CTRL_EN)
+			| WDT_BF(CTRL_PSEL, psel)
+			| WDT_BF(CTRL_KEY, 0xaa));
+	spin_unlock(&wdt->io_lock);
+}
+
+/*
+ * Pat the watchdog timer.
+ */
+static inline void at32_wdt_pat(void)
+{
+	spin_lock(&wdt->io_lock);
+	wdt_writel(wdt, CLR, 0x42);
+	spin_unlock(&wdt->io_lock);
+}
+
+/*
+ * Watchdog device is opened, and watchdog starts running.
+ */
+static int at32_wdt_open(struct inode *inode, struct file *file)
+{
+	if (test_and_set_bit(1, &wdt->users))
+		return -EBUSY;
+
+	at32_wdt_start();
+	return nonseekable_open(inode, file);
+}
+
+/*
+ * Close the watchdog device.
+ */
+static int at32_wdt_close(struct inode *inode, struct file *file)
+{
+	if (expect_release == 42) {
+		at32_wdt_stop();
+	} else {
+		dev_dbg(wdt->miscdev.parent,
+			"Unexpected close, not stopping watchdog!\n");
+		at32_wdt_pat();
+	}
+	clear_bit(1, &wdt->users);
+	expect_release = 0;
+	return 0;
+}
+
+/*
+ * Change the watchdog time interval.
+ */
+static int at32_wdt_settimeout(int time)
+{
+	/*
+	 * All counting occurs at 1 / SLOW_CLOCK (32 kHz) and max prescaler is
+	 * 2 ^ 16 allowing up to 2 seconds timeout.
+	 */
+	if ((time < TIMEOUT_MIN) || (time > TIMEOUT_MAX))
+		return -EINVAL;
+
+	/*
+	 * Set new watchdog time. It will be used when at32_wdt_start() is
+	 * called.
+	 */
+	wdt->timeout = time;
+	return 0;
+}
+
+static struct watchdog_info at32_wdt_info = {
+	.identity	= "at32ap700x watchdog",
+	.options	= WDIOF_SETTIMEOUT |
+			  WDIOF_KEEPALIVEPING |
+			  WDIOF_MAGICCLOSE,
+};
+
+/*
+ * Handle commands from user-space.
+ */
+static int at32_wdt_ioctl(struct inode *inode, struct file *file,
+		unsigned int cmd, unsigned long arg)
+{
+	int ret = -ENOTTY;
+	int time;
+	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
+
+	switch (cmd) {
+	case WDIOC_KEEPALIVE:
+		at32_wdt_pat();
+		ret = 0;
+		break;
+	case WDIOC_GETSUPPORT:
+		ret = copy_to_user(argp, &at32_wdt_info,
+				sizeof(at32_wdt_info)) ? -EFAULT : 0;
+		break;
+	case WDIOC_SETTIMEOUT:
+		ret = get_user(time, p);
+		if (ret)
+			break;
+		ret = at32_wdt_settimeout(time);
+		if (ret)
+			break;
+		/* Enable new time value */
+		at32_wdt_start();
+		/* fall through */
+	case WDIOC_GETTIMEOUT:
+		ret = put_user(wdt->timeout, p);
+		break;
+	case WDIOC_GETSTATUS: /* fall through */
+	case WDIOC_GETBOOTSTATUS:
+		ret = put_user(0, p);
+		break;
+	case WDIOC_SETOPTIONS:
+		ret = get_user(time, p);
+		if (ret)
+			break;
+		if (time & WDIOS_DISABLECARD)
+			at32_wdt_stop();
+		if (time & WDIOS_ENABLECARD)
+			at32_wdt_start();
+		ret = 0;
+		break;
+	}
+
+	return ret;
+}
+
+static ssize_t at32_wdt_write(struct file *file, const char __user *data,
+				size_t len, loff_t *ppos)
+{
+	/* See if we got the magic character 'V' and reload the timer */
+	if (len) {
+		if (!nowayout) {
+			size_t i;
+
+			/*
+			 * note: just in case someone wrote the magic
+			 * character five months ago...
+			 */
+			expect_release = 0;
+
+			/*
+			 * scan to see whether or not we got the magic
+			 * character
+			 */
+			for (i = 0; i != len; i++) {
+				char c;
+				if (get_user(c, data+i))
+					return -EFAULT;
+				if (c == 'V')
+					expect_release = 42;
+			}
+		}
+		/* someone wrote to us, we should pat the watchdog */
+		at32_wdt_pat();
+	}
+	return len;
+}
+
+static const struct file_operations at32_wdt_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.ioctl		= at32_wdt_ioctl,
+	.open		= at32_wdt_open,
+	.release	= at32_wdt_close,
+	.write		= at32_wdt_write,
+};
+
+static int __init at32_wdt_probe(struct platform_device *pdev)
+{
+	struct resource	*regs;
+	int ret;
+
+	if (wdt) {
+		dev_dbg(&pdev->dev, "only 1 wdt instance supported.\n");
+		return -EBUSY;
+	}
+
+	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!regs) {
+		dev_dbg(&pdev->dev, "missing mmio resource\n");
+		return -ENXIO;
+	}
+
+	wdt = kzalloc(sizeof(struct wdt_at32ap700x), GFP_KERNEL);
+	if (!wdt) {
+		dev_dbg(&pdev->dev, "no memory for wdt structure\n");
+		return -ENOMEM;
+	}
+
+	wdt->regs = ioremap(regs->start, regs->end - regs->start + 1);
+	if (!wdt->regs) {
+		ret = -ENOMEM;
+		dev_dbg(&pdev->dev, "could not map I/O memory\n");
+		goto err_free;
+	}
+	spin_lock_init(&wdt->io_lock);
+	wdt->users = 0;
+	wdt->miscdev.minor = WATCHDOG_MINOR;
+	wdt->miscdev.name = "watchdog";
+	wdt->miscdev.fops = &at32_wdt_fops;
+
+	if (at32_wdt_settimeout(timeout)) {
+		at32_wdt_settimeout(TIMEOUT_DEFAULT);
+		dev_dbg(&pdev->dev,
+			"default timeout invalid, set to %d sec.\n",
+			TIMEOUT_DEFAULT);
+	}
+
+	ret = misc_register(&wdt->miscdev);
+	if (ret) {
+		dev_dbg(&pdev->dev, "failed to register wdt miscdev\n");
+		goto err_iounmap;
+	}
+
+	platform_set_drvdata(pdev, wdt);
+	wdt->miscdev.parent = &pdev->dev;
+	dev_info(&pdev->dev,
+		"AT32AP700X WDT at 0x%p, timeout %d sec (nowayout=%d)\n",
+		wdt->regs, wdt->timeout, nowayout);
+
+	return 0;
+
+err_iounmap:
+	iounmap(wdt->regs);
+err_free:
+	kfree(wdt);
+	wdt = NULL;
+	return ret;
+}
+
+static int __exit at32_wdt_remove(struct platform_device *pdev)
+{
+	if (wdt && platform_get_drvdata(pdev) == wdt) {
+		/* Stop the timer before we leave */
+		if (!nowayout)
+			at32_wdt_stop();
+
+		misc_deregister(&wdt->miscdev);
+		iounmap(wdt->regs);
+		kfree(wdt);
+		wdt = NULL;
+		platform_set_drvdata(pdev, NULL);
+	}
+
+	return 0;
+}
+
+static void at32_wdt_shutdown(struct platform_device *pdev)
+{
+	at32_wdt_stop();
+}
+
+#ifdef CONFIG_PM
+static int at32_wdt_suspend(struct platform_device *pdev, pm_message_t message)
+{
+	at32_wdt_stop();
+	return 0;
+}
+
+static int at32_wdt_resume(struct platform_device *pdev)
+{
+	if (wdt->users)
+		at32_wdt_start();
+	return 0;
+}
+#else
+#define at32_wdt_suspend NULL
+#define at32_wdt_resume NULL
+#endif
+
+static struct platform_driver at32_wdt_driver = {
+	.remove		= __exit_p(at32_wdt_remove),
+	.suspend	= at32_wdt_suspend,
+	.resume		= at32_wdt_resume,
+	.driver		= {
+		.name	= "at32_wdt",
+		.owner	= THIS_MODULE,
+	},
+	.shutdown	= at32_wdt_shutdown,
+};
+
+static int __init at32_wdt_init(void)
+{
+	return platform_driver_probe(&at32_wdt_driver, at32_wdt_probe);
+}
+module_init(at32_wdt_init);
+
+static void __exit at32_wdt_exit(void)
+{
+	platform_driver_unregister(&at32_wdt_driver);
+}
+module_exit(at32_wdt_exit);
+
+MODULE_AUTHOR("Hans-Christian Egtvedt <hcegtvedt@atmel.com>");
+MODULE_DESCRIPTION("Watchdog driver for Atmel AT32AP700X");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/drivers/char/watchdog/ep93xx_wdt.c b/drivers/char/watchdog/ep93xx_wdt.c
index 01cf123..0e4787a 100644
--- a/drivers/char/watchdog/ep93xx_wdt.c
+++ b/drivers/char/watchdog/ep93xx_wdt.c
@@ -107,10 +107,6 @@ static ssize_t
 ep93xx_wdt_write(struct file *file, const char __user *data, size_t len,
 		 loff_t *ppos)
 {
-	/* Can't seek (pwrite) on this device */
-	if (*ppos != file->f_pos)
-		return -ESPIPE;
-
 	if (len) {
 		if (!nowayout) {
 			size_t i;
diff --git a/drivers/char/watchdog/mixcomwd.c b/drivers/char/watchdog/mixcomwd.c
index f35e284..db2ccb8 100644
--- a/drivers/char/watchdog/mixcomwd.c
+++ b/drivers/char/watchdog/mixcomwd.c
@@ -29,11 +29,18 @@
  *		- support for one more type board
  *
  * Version 0.5 (2001/12/14) Matt Domsch <Matt_Domsch@dell.com>
- *              - added nowayout module option to override CONFIG_WATCHDOG_NOWAYOUT
+ *		- added nowayout module option to override CONFIG_WATCHDOG_NOWAYOUT
+ *
+ * Version 0.6 (2002/04/12): Rob Radez <rob@osinvestor.com>
+ *		- make mixcomwd_opened unsigned,
+ *		  removed lock_kernel/unlock_kernel from mixcomwd_release,
+ *		  modified ioctl a bit to conform to API
  *
  */
 
-#define VERSION "0.5"
+#define VERSION "0.6"
+#define WATCHDOG_NAME "mixcomwd"
+#define PFX WATCHDOG_NAME ": "
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
@@ -49,12 +56,46 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
-static int mixcomwd_ioports[] = { 0x180, 0x280, 0x380, 0x000 };
-
-#define MIXCOM_WATCHDOG_OFFSET 0xc10
+/*
+ * We have two types of cards that can be probed:
+ * 1) The Mixcom cards: these cards can be found at addresses
+ *    0x180, 0x280, 0x380 with an additional offset of 0xc10.
+ *    (Or 0xd90, 0xe90, 0xf90).
+ * 2) The FlashCOM cards: these cards can be set up at
+ *    0x300 -> 0x378, in 0x8 jumps with an offset of 0x04.
+ *    (Or 0x304 -> 0x37c in 0x8 jumps).
+ *    Each card has it's own ID.
+ */
 #define MIXCOM_ID 0x11
-#define FLASHCOM_WATCHDOG_OFFSET 0x4
 #define FLASHCOM_ID 0x18
+static struct {
+	int ioport;
+	int id;
+} mixcomwd_io_info[] __devinitdata = {
+	/* The Mixcom cards */
+	{0x0d90, MIXCOM_ID},
+	{0x0e90, MIXCOM_ID},
+	{0x0f90, MIXCOM_ID},
+	/* The FlashCOM cards */
+	{0x0304, FLASHCOM_ID},
+	{0x030c, FLASHCOM_ID},
+	{0x0314, FLASHCOM_ID},
+	{0x031c, FLASHCOM_ID},
+	{0x0324, FLASHCOM_ID},
+	{0x032c, FLASHCOM_ID},
+	{0x0334, FLASHCOM_ID},
+	{0x033c, FLASHCOM_ID},
+	{0x0344, FLASHCOM_ID},
+	{0x034c, FLASHCOM_ID},
+	{0x0354, FLASHCOM_ID},
+	{0x035c, FLASHCOM_ID},
+	{0x0364, FLASHCOM_ID},
+	{0x036c, FLASHCOM_ID},
+	{0x0374, FLASHCOM_ID},
+	{0x037c, FLASHCOM_ID},
+	/* The end of the list */
+	{0x0000, 0},
+};
 
 static void mixcomwd_timerfun(unsigned long d);
 
@@ -113,13 +154,13 @@ static int mixcomwd_release(struct inode *inode, struct file *file)
 {
 	if (expect_close == 42) {
 		if(mixcomwd_timer_alive) {
-			printk(KERN_ERR "mixcomwd: release called while internal timer alive");
+			printk(KERN_ERR PFX "release called while internal timer alive");
 			return -EBUSY;
 		}
 		mixcomwd_timer_alive=1;
 		mod_timer(&mixcomwd_timer, jiffies + 5 * HZ);
 	} else {
-		printk(KERN_CRIT "mixcomwd: WDT device closed unexpectedly.  WDT will not stop!\n");
+		printk(KERN_CRIT PFX "WDT device closed unexpectedly.  WDT will not stop!\n");
 	}
 
 	clear_bit(0,&mixcomwd_opened);
@@ -188,8 +229,7 @@ static int mixcomwd_ioctl(struct inode *inode, struct file *file,
 	return 0;
 }
 
-static const struct file_operations mixcomwd_fops=
-{
+static const struct file_operations mixcomwd_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= mixcomwd_write,
@@ -198,46 +238,30 @@ static const struct file_operations mixcomwd_fops=
 	.release	= mixcomwd_release,
 };
 
-static struct miscdevice mixcomwd_miscdev=
-{
+static struct miscdevice mixcomwd_miscdev = {
 	.minor	= WATCHDOG_MINOR,
 	.name	= "watchdog",
 	.fops	= &mixcomwd_fops,
 };
 
-static int __init mixcomwd_checkcard(int port)
+static int __init checkcard(int port, int card_id)
 {
 	int id;
 
-	port += MIXCOM_WATCHDOG_OFFSET;
-	if (!request_region(port, 1, "MixCOM watchdog")) {
-		return 0;
-	}
-
-	id=inb_p(port) & 0x3f;
-	if(id!=MIXCOM_ID) {
-		release_region(port, 1);
-		return 0;
-	}
-	return port;
-}
-
-static int __init flashcom_checkcard(int port)
-{
-	int id;
-
-	port += FLASHCOM_WATCHDOG_OFFSET;
 	if (!request_region(port, 1, "MixCOM watchdog")) {
 		return 0;
 	}
 
 	id=inb_p(port);
- 	if(id!=FLASHCOM_ID) {
+	if (card_id==MIXCOM_ID)
+		id &= 0x3f;
+
+	if (id!=card_id) {
 		release_region(port, 1);
 		return 0;
 	}
- 	return port;
- }
+	return 1;
+}
 
 static int __init mixcomwd_init(void)
 {
@@ -245,50 +269,50 @@ static int __init mixcomwd_init(void)
 	int ret;
 	int found=0;
 
-	for (i = 0; !found && mixcomwd_ioports[i] != 0; i++) {
-		watchdog_port = mixcomwd_checkcard(mixcomwd_ioports[i]);
-		if (watchdog_port) {
-			found = 1;
-		}
-	}
-
-	/* The FlashCOM card can be set up at 0x300 -> 0x378, in 0x8 jumps */
-	for (i = 0x300; !found && i < 0x380; i+=0x8) {
-		watchdog_port = flashcom_checkcard(i);
-		if (watchdog_port) {
+	for (i = 0; !found && mixcomwd_io_info[i].ioport != 0; i++) {
+		if (checkcard(mixcomwd_io_info[i].ioport,
+			      mixcomwd_io_info[i].id)) {
 			found = 1;
+			watchdog_port = mixcomwd_io_info[i].ioport;
 		}
 	}
 
 	if (!found) {
-		printk("mixcomwd: No card detected, or port not available.\n");
+		printk(KERN_ERR PFX "No card detected, or port not available.\n");
 		return -ENODEV;
 	}
 
 	ret = misc_register(&mixcomwd_miscdev);
 	if (ret)
 	{
-		release_region(watchdog_port, 1);
-		return ret;
+		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
+			WATCHDOG_MINOR, ret);
+		goto error_misc_register_watchdog;
 	}
 
-	printk(KERN_INFO "MixCOM watchdog driver v%s, watchdog port at 0x%3x\n",VERSION,watchdog_port);
+	printk(KERN_INFO "MixCOM watchdog driver v%s, watchdog port at 0x%3x\n",
+		VERSION, watchdog_port);
 
 	return 0;
+
+error_misc_register_watchdog:
+	release_region(watchdog_port, 1);
+	watchdog_port = 0x0000;
+	return ret;
 }
 
 static void __exit mixcomwd_exit(void)
 {
 	if (!nowayout) {
 		if(mixcomwd_timer_alive) {
-			printk(KERN_WARNING "mixcomwd: I quit now, hardware will"
+			printk(KERN_WARNING PFX "I quit now, hardware will"
 			       " probably reboot!\n");
 			del_timer_sync(&mixcomwd_timer);
 			mixcomwd_timer_alive=0;
 		}
 	}
-	release_region(watchdog_port,1);
 	misc_deregister(&mixcomwd_miscdev);
+	release_region(watchdog_port,1);
 }
 
 module_init(mixcomwd_init);
@@ -296,5 +320,6 @@ module_exit(mixcomwd_exit);
 
 MODULE_AUTHOR("Gergely Madarasz <gorgo@itc.hu>");
 MODULE_DESCRIPTION("MixCom Watchdog driver");
+MODULE_VERSION(VERSION);
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/drivers/char/watchdog/pnx4008_wdt.c b/drivers/char/watchdog/pnx4008_wdt.c
index 5991add..22f8873 100644
--- a/drivers/char/watchdog/pnx4008_wdt.c
+++ b/drivers/char/watchdog/pnx4008_wdt.c
@@ -148,10 +148,6 @@ static ssize_t
 pnx4008_wdt_write(struct file *file, const char *data, size_t len,
 		  loff_t * ppos)
 {
-	/*  Can't seek (pwrite) on this device  */
-	if (ppos != &file->f_pos)
-		return -ESPIPE;
-
 	if (len) {
 		if (!nowayout) {
 			size_t i;
diff --git a/drivers/char/watchdog/s3c2410_wdt.c b/drivers/char/watchdog/s3c2410_wdt.c
index 20fa29c..50430bc 100644
--- a/drivers/char/watchdog/s3c2410_wdt.c
+++ b/drivers/char/watchdog/s3c2410_wdt.c
@@ -92,6 +92,7 @@ typedef enum close_state {
 
 static DECLARE_MUTEX(open_lock);
 
+static struct device    *wdt_dev;	/* platform device attached to */
 static struct resource	*wdt_mem;
 static struct resource	*wdt_irq;
 static struct clk	*wdt_clock;
@@ -180,7 +181,7 @@ static int s3c2410wdt_set_heartbeat(int timeout)
 		}
 
 		if ((count / divisor) >= 0x10000) {
-			printk(KERN_ERR PFX "timeout %d too big\n", timeout);
+			dev_err(wdt_dev, "timeout %d too big\n", timeout);
 			return -EINVAL;
 		}
 	}
@@ -233,7 +234,7 @@ static int s3c2410wdt_release(struct inode *inode, struct file *file)
 	if (allow_close == CLOSE_STATE_ALLOW) {
 		s3c2410wdt_stop();
 	} else {
-		printk(KERN_CRIT PFX "Unexpected close, not stopping watchdog!\n");
+		dev_err(wdt_dev, "Unexpected close, not stopping watchdog\n");
 		s3c2410wdt_keepalive();
 	}
 
@@ -338,7 +339,7 @@ static struct miscdevice s3c2410wdt_miscdev = {
 
 static irqreturn_t s3c2410wdt_irq(int irqno, void *param)
 {
-	printk(KERN_INFO PFX "Watchdog timer expired!\n");
+	dev_info(wdt_dev, "watchdog timer expired (irq)\n");
 
 	s3c2410wdt_keepalive();
 	return IRQ_HANDLED;
@@ -348,31 +349,36 @@ static irqreturn_t s3c2410wdt_irq(int irqno, void *param)
 static int s3c2410wdt_probe(struct platform_device *pdev)
 {
 	struct resource *res;
+	struct device *dev;
+	unsigned int wtcon;
 	int started = 0;
 	int ret;
 	int size;
 
 	DBG("%s: probe=%p\n", __FUNCTION__, pdev);
 
+	dev = &pdev->dev;
+	wdt_dev = &pdev->dev;
+
 	/* get the memory region for the watchdog timer */
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (res == NULL) {
-		printk(KERN_INFO PFX "failed to get memory region resouce\n");
+		dev_err(dev, "no memory resource specified\n");
 		return -ENOENT;
 	}
 
 	size = (res->end-res->start)+1;
 	wdt_mem = request_mem_region(res->start, size, pdev->name);
 	if (wdt_mem == NULL) {
-		printk(KERN_INFO PFX "failed to get memory region\n");
+		dev_err(dev, "failed to get memory region\n");
 		ret = -ENOENT;
 		goto err_req;
 	}
 
 	wdt_base = ioremap(res->start, size);
 	if (wdt_base == 0) {
-		printk(KERN_INFO PFX "failed to ioremap() region\n");
+		dev_err(dev, "failed to ioremap() region\n");
 		ret = -EINVAL;
 		goto err_req;
 	}
@@ -381,20 +387,20 @@ static int s3c2410wdt_probe(struct platform_device *pdev)
 
 	wdt_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (wdt_irq == NULL) {
-		printk(KERN_INFO PFX "failed to get irq resource\n");
+		dev_err(dev, "no irq resource specified\n");
 		ret = -ENOENT;
 		goto err_map;
 	}
 
 	ret = request_irq(wdt_irq->start, s3c2410wdt_irq, 0, pdev->name, pdev);
 	if (ret != 0) {
-		printk(KERN_INFO PFX "failed to install irq (%d)\n", ret);
+		dev_err(dev, "failed to install irq (%d)\n", ret);
 		goto err_map;
 	}
 
 	wdt_clock = clk_get(&pdev->dev, "watchdog");
 	if (IS_ERR(wdt_clock)) {
-		printk(KERN_INFO PFX "failed to find watchdog clock source\n");
+		dev_err(dev, "failed to find watchdog clock source\n");
 		ret = PTR_ERR(wdt_clock);
 		goto err_irq;
 	}
@@ -408,22 +414,22 @@ static int s3c2410wdt_probe(struct platform_device *pdev)
 		started = s3c2410wdt_set_heartbeat(CONFIG_S3C2410_WATCHDOG_DEFAULT_TIME);
 
 		if (started == 0) {
-			printk(KERN_INFO PFX "tmr_margin value out of range, default %d used\n",
+			dev_info(dev,"tmr_margin value out of range, default %d used\n",
 			       CONFIG_S3C2410_WATCHDOG_DEFAULT_TIME);
 		} else {
-			printk(KERN_INFO PFX "default timer value is out of range, cannot start\n");
+			dev_info(dev, "default timer value is out of range, cannot start\n");
 		}
 	}
 
 	ret = misc_register(&s3c2410wdt_miscdev);
 	if (ret) {
-		printk (KERN_ERR PFX "cannot register miscdev on minor=%d (%d)\n",
+		dev_err(dev, "cannot register miscdev on minor=%d (%d)\n",
 			WATCHDOG_MINOR, ret);
 		goto err_clk;
 	}
 
 	if (tmr_atboot && started == 0) {
-		printk(KERN_INFO PFX "Starting Watchdog Timer\n");
+		dev_info(dev, "starting watchdog timer\n");
 		s3c2410wdt_start();
 	} else if (!tmr_atboot) {
 		/* if we're not enabling the watchdog, then ensure it is
@@ -433,6 +439,15 @@ static int s3c2410wdt_probe(struct platform_device *pdev)
 		s3c2410wdt_stop();
 	}
 
+	/* print out a statement of readiness */
+
+	wtcon = readl(wdt_base + S3C2410_WTCON);
+
+	dev_info(dev, "watchdog %sactive, reset %sabled, irq %sabled\n",
+		 (wtcon & S3C2410_WTCON_ENABLE) ?  "" : "in",
+		 (wtcon & S3C2410_WTCON_RSTEN) ? "" : "dis",
+		 (wtcon & S3C2410_WTCON_INTEN) ? "" : "en");
+	
 	return 0;
 
  err_clk:
