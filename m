Return-Path: <linux-kernel-owner+w=401wt.eu-S932330AbXLMU6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330AbXLMU6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 15:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760817AbXLMU6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 15:58:09 -0500
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:13430 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751628AbXLMU6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 15:58:04 -0500
X-Belgacom-Dynamic: yes
Date: Thu, 13 Dec 2007 21:57:58 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [WATCHDOG] v2.6.24 Watchdog Device Drivers patches - part 4
Message-ID: <20071213205758.GA2666@infomag.infomag.iguana.be>
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

 drivers/char/ipmi/ipmi_watchdog.c |    2 
 drivers/sbus/char/cpwatchdog.c    |    2 
 drivers/watchdog/Kconfig          |   23 ++
 drivers/watchdog/Makefile         |    2 
 drivers/watchdog/at32ap700x_wdt.c |   69 ++++++
 drivers/watchdog/bfin_wdt.c       |    2 
 drivers/watchdog/it8712f_wdt.c    |  400 ++++++++++++++++++++++++++++++++++++++
 drivers/watchdog/sbc7240_wdt.c    |  324 ++++++++++++++++++++++++++++++
 drivers/watchdog/w83697hf_wdt.c   |    4 
 9 files changed, 821 insertions(+), 7 deletions(-)

with these Changes:

Author: Gilles Gigan <gilles.gigan@gmail.com>
Date:   Wed Oct 31 16:31:42 2007 +1000

    [WATCHDOG] add Nano 7240 driver
    
    Adds support for the built-in watchdog on EPIC Nano 7240 boards from IEI.
    
    Tested on Nano-7240RS.
    
    Hardware documentation of the platform (including watchdog) can be found
    on the IEI website: http://www.ieiworld.com
    
    Signed-off-by: Gilles Gigan <gilles.gigan@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Corey Minyard <cminyard@mvista.com>
Date:   Tue Nov 20 12:14:46 2007 -0800

    [WATCHDOG] ipmi: add the standard watchdog timeout ioctls
    
    Add the standard IOCTLs to the IPMI driver for setting and getting
    the pretimeout.  Tested by Benoit Guillon.
    
    Signed off by: Corey Minyard <cminyard@mvista.com>
    Cc: Benoit Guillon <guillon@thalescomputers.fr>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Author: Jorge Boncompte [DTI2] <jorge@dti2.net>
Date:   Mon Nov 19 15:09:21 2007 +0100

    [WATCHDOG] IT8212F watchdog driver
    
    This patch adds support for the ITE Tech Inc. IT8712F EC-LPC Super I/O
    chipset found on many Pentium III and AMD motherboards. Developed using code
    from other watchdog drivers and the datasheet on ITE Tech homepage.
    
    Signed-off-by: Jorge Boncompte <jorge@dti2.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Jiri Slaby <jirislaby@gmail.com>
Date:   Sat Nov 10 04:32:45 2007 +0100

    [WATCHDOG] Sbus: cpwatchdog, remove SPIN_LOCK_UNLOCKED
    
    cpwatchdog, remove SPIN_LOCK_UNLOCKED
    
    SPIN_LOCK_UNLOCKED is deprecated, use __SPIN_LOCK_UNLOCKED with an unique
    name instead
    
    Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
    Cc: "David S. Miller" <davem@davemloft.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Author: Jiri Slaby <jirislaby@gmail.com>
Date:   Sat Nov 10 05:58:44 2007 +0100

    [WATCHDOG] bfin_wdt, remove SPIN_LOCK_UNLOCKED
    
    bfin_wdt, remove SPIN_LOCK_UNLOCKED
    
    SPIN_LOCK_UNLOCKED is deprecated, use DEFINE_SPINLOCK instead
    
    Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
    Acked-by: Mike Frysinger <vapier.adi@gmail.com>
    Cc: Bryan Wu <bryan.wu@analog.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Author: Samuel Tardieu <sam@rfc1149.net>
Date:   Sun Nov 4 20:20:23 2007 +0100

    [WATCHDOG] Stop looking for device as soon as one is found
    
    If no address is given for the W83697HF/HG watchdog IO port, stop looping
    through possible locations when a watchdog device has been found.
    
    Signed-off-by: Samuel Tardieu <sam@rfc1149.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Date:   Tue Oct 30 14:56:20 2007 +0100

    [WATCHDOG] at32ap700x_wdt: add support for boot status and add fix for silicon errata
    
    This patch enables the watchdog to read out the reset cause after a boot and
    provide this to the user.
    
    The driver will now also return -EIO if probed when booting from a watchdog
    reset. This is due to a silicon errata in the AT32AP700x devices.
    
    Detailed description and work-arounds can be found in the errata section of the
    datasheet avilable from
    http://www.atmel.com/dyn/products/datasheets.asp?family_id=682
    
    Signed-off-by: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/char/ipmi/ipmi_watchdog.c b/drivers/char/ipmi/ipmi_watchdog.c
index e686fc9..8f45ca9 100644
--- a/drivers/char/ipmi/ipmi_watchdog.c
+++ b/drivers/char/ipmi/ipmi_watchdog.c
@@ -669,6 +669,7 @@ static int ipmi_ioctl(struct inode *inode, struct file *file,
 		return 0;
 
 	case WDIOC_SET_PRETIMEOUT:
+	case WDIOC_SETPRETIMEOUT:
 		i = copy_from_user(&val, argp, sizeof(int));
 		if (i)
 			return -EFAULT;
@@ -676,6 +677,7 @@ static int ipmi_ioctl(struct inode *inode, struct file *file,
 		return ipmi_set_timeout(IPMI_SET_TIMEOUT_HB_IF_NECESSARY);
 
 	case WDIOC_GET_PRETIMEOUT:
+	case WDIOC_GETPRETIMEOUT:
 		i = copy_to_user(argp, &pretimeout, sizeof(pretimeout));
 		if (i)
 			return -EFAULT;
diff --git a/drivers/sbus/char/cpwatchdog.c b/drivers/sbus/char/cpwatchdog.c
index 7b5773d..a4e7581 100644
--- a/drivers/sbus/char/cpwatchdog.c
+++ b/drivers/sbus/char/cpwatchdog.c
@@ -154,7 +154,7 @@ struct wd_device {
 };
 
 static struct wd_device wd_dev = { 
-		0, SPIN_LOCK_UNLOCKED, 0, 0, 0, 0,
+		0, __SPIN_LOCK_UNLOCKED(wd_dev.lock), 0, 0, 0, 0,
 };
 
 static struct timer_list wd_timer;
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 2792bc1..52dff40 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -392,6 +392,16 @@ config ITCO_VENDOR_SUPPORT
 	  devices. At this moment we only have additional support for some
 	  SuperMicro Inc. motherboards.
 
+config IT8712F_WDT
+	tristate "IT8712F (Smart Guardian) Watchdog Timer"
+	depends on X86
+	---help---
+	  This is the driver for the built-in watchdog timer on the IT8712F
+	  Super I/0 chipset used on many motherboards.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called it8712f_wdt.
+
 config SC1200_WDT
 	tristate "National Semiconductor PC87307/PC97307 (ala SC1200) Watchdog"
 	depends on X86
@@ -456,6 +466,19 @@ config SBC8360_WDT
 
 	  Most people will say N.
 
+config SBC7240_WDT
+	tristate "SBC Nano 7240 Watchdog Timer"
+	depends on X86_32
+	---help---
+	  This is the driver for the hardware watchdog found on the IEI
+	  single board computers EPIC Nano 7240 (and likely others). This
+	  watchdog simply watches your kernel to make sure it doesn't freeze,
+	  and if it does, it reboots your computer after a certain amount of
+	  time.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called sbc7240_wdt.
+
 config CPU5_WDT
 	tristate "SMA CPU5 Watchdog"
 	depends on X86
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 7d9e573..87483cc 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -66,11 +66,13 @@ obj-$(CONFIG_IBMASR) += ibmasr.o
 obj-$(CONFIG_WAFER_WDT) += wafer5823wdt.o
 obj-$(CONFIG_I6300ESB_WDT) += i6300esb.o
 obj-$(CONFIG_ITCO_WDT) += iTCO_wdt.o iTCO_vendor_support.o
+obj-$(CONFIG_IT8712F_WDT) += it8712f_wdt.o
 obj-$(CONFIG_SC1200_WDT) += sc1200wdt.o
 obj-$(CONFIG_SCx200_WDT) += scx200_wdt.o
 obj-$(CONFIG_PC87413_WDT) += pc87413_wdt.o
 obj-$(CONFIG_60XX_WDT) += sbc60xxwdt.o
 obj-$(CONFIG_SBC8360_WDT) += sbc8360.o
+obj-$(CONFIG_SBC7240_WDT) += sbc7240_wdt.o
 obj-$(CONFIG_CPU5_WDT) += cpu5wdt.o
 obj-$(CONFIG_SMSC37B787_WDT) += smsc37b787_wdt.o
 obj-$(CONFIG_W83627HF_WDT) += w83627hf_wdt.o
diff --git a/drivers/watchdog/at32ap700x_wdt.c b/drivers/watchdog/at32ap700x_wdt.c
index 54a5161..fb5ed64 100644
--- a/drivers/watchdog/at32ap700x_wdt.c
+++ b/drivers/watchdog/at32ap700x_wdt.c
@@ -6,6 +6,19 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
+ *
+ *
+ * Errata: WDT Clear is blocked after WDT Reset
+ *
+ * A watchdog timer event will, after reset, block writes to the WDT_CLEAR
+ * register, preventing the program to clear the next Watchdog Timer Reset.
+ *
+ * If you still want to use the WDT after a WDT reset a small code can be
+ * insterted at the startup checking the AVR32_PM.rcause register for WDT reset
+ * and use a GPIO pin to reset the system. This method requires that one of the
+ * GPIO pins are available and connected externally to the RESET_N pin. After
+ * the GPIO pin has pulled down the reset line the GPIO will be reset and leave
+ * the pin tristated with pullup.
  */
 
 #include <linux/init.h>
@@ -44,6 +57,13 @@ MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
 
 #define WDT_CLR			0x04
 
+#define WDT_RCAUSE		0x10
+#define WDT_RCAUSE_POR		   0
+#define WDT_RCAUSE_EXT		   2
+#define WDT_RCAUSE_WDT		   3
+#define WDT_RCAUSE_JTAG		   4
+#define WDT_RCAUSE_SERP		   5
+
 #define WDT_BIT(name)		(1 << WDT_##name)
 #define WDT_BF(name, value)	((value) << WDT_##name)
 
@@ -56,6 +76,7 @@ struct wdt_at32ap700x {
 	void __iomem		*regs;
 	spinlock_t		io_lock;
 	int			timeout;
+	int			boot_status;
 	unsigned long		users;
 	struct miscdevice	miscdev;
 };
@@ -126,7 +147,7 @@ static int at32_wdt_close(struct inode *inode, struct file *file)
 		at32_wdt_stop();
 	} else {
 		dev_dbg(wdt->miscdev.parent,
-			"Unexpected close, not stopping watchdog!\n");
+			"unexpected close, not stopping watchdog!\n");
 		at32_wdt_pat();
 	}
 	clear_bit(1, &wdt->users);
@@ -154,6 +175,33 @@ static int at32_wdt_settimeout(int time)
 	return 0;
 }
 
+/*
+ * Get the watchdog status.
+ */
+static int at32_wdt_get_status(void)
+{
+	int rcause;
+	int status = 0;
+
+	rcause = wdt_readl(wdt, RCAUSE);
+
+	switch (rcause) {
+	case WDT_BIT(RCAUSE_EXT):
+		status = WDIOF_EXTERN1;
+		break;
+	case WDT_BIT(RCAUSE_WDT):
+		status = WDIOF_CARDRESET;
+		break;
+	case WDT_BIT(RCAUSE_POR):  /* fall through */
+	case WDT_BIT(RCAUSE_JTAG): /* fall through */
+	case WDT_BIT(RCAUSE_SERP): /* fall through */
+	default:
+		break;
+	}
+
+	return status;
+}
+
 static struct watchdog_info at32_wdt_info = {
 	.identity	= "at32ap700x watchdog",
 	.options	= WDIOF_SETTIMEOUT |
@@ -194,10 +242,12 @@ static int at32_wdt_ioctl(struct inode *inode, struct file *file,
 	case WDIOC_GETTIMEOUT:
 		ret = put_user(wdt->timeout, p);
 		break;
-	case WDIOC_GETSTATUS: /* fall through */
-	case WDIOC_GETBOOTSTATUS:
+	case WDIOC_GETSTATUS:
 		ret = put_user(0, p);
 		break;
+	case WDIOC_GETBOOTSTATUS:
+		ret = put_user(wdt->boot_status, p);
+		break;
 	case WDIOC_SETOPTIONS:
 		ret = get_user(time, p);
 		if (ret)
@@ -282,8 +332,19 @@ static int __init at32_wdt_probe(struct platform_device *pdev)
 		dev_dbg(&pdev->dev, "could not map I/O memory\n");
 		goto err_free;
 	}
+
 	spin_lock_init(&wdt->io_lock);
-	wdt->users = 0;
+	wdt->boot_status = at32_wdt_get_status();
+
+	/* Work-around for watchdog silicon errata. */
+	if (wdt->boot_status & WDIOF_CARDRESET) {
+		dev_info(&pdev->dev, "CPU must be reset with external "
+				"reset or POR due to silicon errata.\n");
+		ret = -EIO;
+		goto err_iounmap;
+	} else {
+		wdt->users = 0;
+	}
 	wdt->miscdev.minor = WATCHDOG_MINOR;
 	wdt->miscdev.name = "watchdog";
 	wdt->miscdev.fops = &at32_wdt_fops;
diff --git a/drivers/watchdog/bfin_wdt.c b/drivers/watchdog/bfin_wdt.c
index 309d279..31dc7a6 100644
--- a/drivers/watchdog/bfin_wdt.c
+++ b/drivers/watchdog/bfin_wdt.c
@@ -71,7 +71,7 @@ static int nowayout = WATCHDOG_NOWAYOUT;
 static struct watchdog_info bfin_wdt_info;
 static unsigned long open_check;
 static char expect_close;
-static spinlock_t bfin_wdt_spinlock = SPIN_LOCK_UNLOCKED;
+static DEFINE_SPINLOCK(bfin_wdt_spinlock);
 
 /**
  *	bfin_wdt_keepalive - Keep the Userspace Watchdog Alive
diff --git a/drivers/watchdog/it8712f_wdt.c b/drivers/watchdog/it8712f_wdt.c
new file mode 100644
index 0000000..6330fc0
--- /dev/null
+++ b/drivers/watchdog/it8712f_wdt.c
@@ -0,0 +1,400 @@
+/*
+ *	IT8712F "Smart Guardian" Watchdog support
+ *
+ *	Copyright (c) 2006-2007 Jorge Boncompte - DTI2 <jorge@dti2.net>
+ *
+ *	Based on info and code taken from:
+ *
+ *	drivers/char/watchdog/scx200_wdt.c
+ *	drivers/hwmon/it87.c
+ *	IT8712F EC-LPC I/O Preliminary Specification 0.9.2.pdf
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License as
+ *	published by the Free Software Foundation; either version 2 of the
+ *	License, or (at your option) any later version.
+ *
+ *	The author(s) of this software shall not be held liable for damages
+ *	of any nature resulting due to the use of this software. This
+ *	software is provided AS-IS with no warranties.
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
+#include <linux/miscdevice.h>
+#include <linux/watchdog.h>
+#include <linux/notifier.h>
+#include <linux/reboot.h>
+#include <linux/fs.h>
+#include <linux/pci.h>
+#include <linux/spinlock.h>
+
+#include <asm/uaccess.h>
+#include <asm/io.h>
+
+#define NAME "it8712f_wdt"
+
+MODULE_AUTHOR("Jorge Boncompte - DTI2 <jorge@dti2.net>");
+MODULE_DESCRIPTION("IT8712F Watchdog Driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+
+static int margin = 60;		/* in seconds */
+module_param(margin, int, 0);
+MODULE_PARM_DESC(margin, "Watchdog margin in seconds");
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Disable watchdog shutdown on close");
+
+static struct semaphore it8712f_wdt_sem;
+static unsigned expect_close;
+static spinlock_t io_lock;
+
+/* Dog Food address - We use the game port address */
+static unsigned short address;
+
+#define	REG		0x2e	/* The register to read/write */
+#define	VAL		0x2f	/* The value to read/write */
+
+#define	LDN		0x07	/* Register: Logical device select */
+#define	DEVID		0x20	/* Register: Device ID */
+#define	DEVREV		0x22	/* Register: Device Revision */
+#define ACT_REG		0x30	/* LDN Register: Activation */
+#define BASE_REG	0x60	/* LDN Register: Base address */
+
+#define IT8712F_DEVID	0x8712
+
+#define LDN_GPIO	0x07	/* GPIO and Watch Dog Timer */
+#define LDN_GAME 	0x09	/* Game Port */
+
+#define WDT_CONTROL	0x71	/* WDT Register: Control */
+#define WDT_CONFIG	0x72	/* WDT Register: Configuration */
+#define WDT_TIMEOUT	0x73	/* WDT Register: Timeout Value */
+
+#define WDT_RESET_GAME	0x10
+#define WDT_RESET_KBD	0x20
+#define WDT_RESET_MOUSE	0x40
+#define WDT_RESET_CIR	0x80
+
+#define WDT_UNIT_SEC	0x80	/* If 0 in MINUTES */
+
+#define WDT_OUT_PWROK	0x10
+#define WDT_OUT_KRST	0x40
+
+static int
+superio_inb(int reg)
+{
+	outb(reg, REG);
+	return inb(VAL);
+}
+
+static void
+superio_outb(int val, int reg)
+{
+	outb(reg, REG);
+	outb(val, VAL);
+}
+
+static int
+superio_inw(int reg)
+{
+	int val;
+	outb(reg++, REG);
+	val = inb(VAL) << 8;
+	outb(reg, REG);
+	val |= inb(VAL);
+	return val;
+}
+
+static inline void
+superio_select(int ldn)
+{
+	outb(LDN, REG);
+	outb(ldn, VAL);
+}
+
+static inline void
+superio_enter(void)
+{
+	spin_lock(&io_lock);
+	outb(0x87, REG);
+	outb(0x01, REG);
+	outb(0x55, REG);
+	outb(0x55, REG);
+}
+
+static inline void
+superio_exit(void)
+{
+	outb(0x02, REG);
+	outb(0x02, VAL);
+	spin_unlock(&io_lock);
+}
+
+static inline void
+it8712f_wdt_ping(void)
+{
+	inb(address);
+}
+
+static void
+it8712f_wdt_update_margin(void)
+{
+	int config = WDT_OUT_KRST | WDT_OUT_PWROK;
+
+	printk(KERN_INFO NAME ": timer margin %d seconds\n", margin);
+
+	/* The timeout register only has 8bits wide */
+	if (margin < 256)
+		config |= WDT_UNIT_SEC;	/* else UNIT are MINUTES */
+	superio_outb(config, WDT_CONFIG);
+
+	superio_outb((margin > 255) ? (margin / 60) : margin, WDT_TIMEOUT);
+}
+
+static void
+it8712f_wdt_enable(void)
+{
+	printk(KERN_DEBUG NAME ": enabling watchdog timer\n");
+	superio_enter();
+	superio_select(LDN_GPIO);
+
+	superio_outb(WDT_RESET_GAME, WDT_CONTROL);
+
+	it8712f_wdt_update_margin();
+
+	superio_exit();
+
+	it8712f_wdt_ping();
+}
+
+static void
+it8712f_wdt_disable(void)
+{
+	printk(KERN_DEBUG NAME ": disabling watchdog timer\n");
+
+	superio_enter();
+	superio_select(LDN_GPIO);
+
+	superio_outb(0, WDT_CONFIG);
+	superio_outb(0, WDT_CONTROL);
+	superio_outb(0, WDT_TIMEOUT);
+
+	superio_exit();
+}
+
+static int
+it8712f_wdt_notify(struct notifier_block *this,
+		    unsigned long code, void *unused)
+{
+	if (code == SYS_HALT || code == SYS_POWER_OFF)
+		if (!nowayout)
+			it8712f_wdt_disable();
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block it8712f_wdt_notifier = {
+	.notifier_call = it8712f_wdt_notify,
+};
+
+static ssize_t
+it8712f_wdt_write(struct file *file, const char __user *data,
+	size_t len, loff_t *ppos)
+{
+	/* check for a magic close character */
+	if (len) {
+		size_t i;
+
+		it8712f_wdt_ping();
+
+		expect_close = 0;
+		for (i = 0; i < len; ++i) {
+			char c;
+			if (get_user(c, data+i))
+				return -EFAULT;
+			if (c == 'V')
+				expect_close = 42;
+		}
+	}
+
+	return len;
+}
+
+static int
+it8712f_wdt_ioctl(struct inode *inode, struct file *file,
+	unsigned int cmd, unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
+	static struct watchdog_info ident = {
+		.identity = "IT8712F Watchdog",
+		.firmware_version = 1,
+		.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
+	};
+	int new_margin;
+
+	switch (cmd) {
+	default:
+		return -ENOTTY;
+	case WDIOC_GETSUPPORT:
+		if (copy_to_user(argp, &ident, sizeof(ident)))
+			return -EFAULT;
+		return 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+	case WDIOC_KEEPALIVE:
+		it8712f_wdt_ping();
+		return 0;
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_margin, p))
+			return -EFAULT;
+		if (new_margin < 1)
+			return -EINVAL;
+		margin = new_margin;
+		superio_enter();
+		superio_select(LDN_GPIO);
+
+		it8712f_wdt_update_margin();
+
+		superio_exit();
+		it8712f_wdt_ping();
+	case WDIOC_GETTIMEOUT:
+		if (put_user(margin, p))
+			return -EFAULT;
+		return 0;
+	}
+}
+
+static int
+it8712f_wdt_open(struct inode *inode, struct file *file)
+{
+	/* only allow one at a time */
+	if (down_trylock(&it8712f_wdt_sem))
+		return -EBUSY;
+	it8712f_wdt_enable();
+
+	return nonseekable_open(inode, file);
+}
+
+static int
+it8712f_wdt_release(struct inode *inode, struct file *file)
+{
+	if (expect_close != 42) {
+		printk(KERN_WARNING NAME
+			": watchdog device closed unexpectedly, will not"
+			" disable the watchdog timer\n");
+	} else if (!nowayout) {
+		it8712f_wdt_disable();
+	}
+	expect_close = 0;
+	up(&it8712f_wdt_sem);
+
+	return 0;
+}
+
+static struct file_operations it8712f_wdt_fops = {
+	.owner = THIS_MODULE,
+	.llseek = no_llseek,
+	.write = it8712f_wdt_write,
+	.ioctl = it8712f_wdt_ioctl,
+	.open = it8712f_wdt_open,
+	.release = it8712f_wdt_release,
+};
+
+static struct miscdevice it8712f_wdt_miscdev = {
+	.minor = WATCHDOG_MINOR,
+	.name = "watchdog",
+	.fops = &it8712f_wdt_fops,
+};
+
+static int __init
+it8712f_wdt_find(unsigned short *address)
+{
+	int err = -ENODEV;
+	int chip_type;
+
+	superio_enter();
+	chip_type = superio_inw(DEVID);
+	if (chip_type != IT8712F_DEVID)
+		goto exit;
+
+	superio_select(LDN_GAME);
+	superio_outb(1, ACT_REG);
+	if (!(superio_inb(ACT_REG) & 0x01)) {
+		printk(KERN_ERR NAME ": Device not activated, skipping\n");
+		goto exit;
+	}
+
+	*address = superio_inw(BASE_REG);
+	if (*address == 0) {
+		printk(KERN_ERR NAME ": Base address not set, skipping\n");
+		goto exit;
+	}
+
+	err = 0;
+	printk(KERN_DEBUG NAME ": Found IT%04xF chip revision %d - "
+		"using DogFood address 0x%x\n",
+		chip_type, superio_inb(DEVREV) & 0x0f, *address);
+
+exit:
+	superio_exit();
+	return err;
+}
+
+static int __init
+it8712f_wdt_init(void)
+{
+	int err = 0;
+
+	spin_lock_init(&io_lock);
+
+	if (it8712f_wdt_find(&address))
+		return -ENODEV;
+
+	if (!request_region(address, 1, "IT8712F Watchdog")) {
+		printk(KERN_WARNING NAME ": watchdog I/O region busy\n");
+		return -EBUSY;
+	}
+
+	it8712f_wdt_disable();
+
+	sema_init(&it8712f_wdt_sem, 1);
+
+	err = register_reboot_notifier(&it8712f_wdt_notifier);
+	if (err) {
+		printk(KERN_ERR NAME ": unable to register reboot notifier\n");
+		goto out;
+	}
+
+	err = misc_register(&it8712f_wdt_miscdev);
+	if (err) {
+		printk(KERN_ERR NAME
+			": cannot register miscdev on minor=%d (err=%d)\n",
+			WATCHDOG_MINOR, err);
+		goto reboot_out;
+	}
+
+	return 0;
+
+
+reboot_out:
+	unregister_reboot_notifier(&it8712f_wdt_notifier);
+out:
+	release_region(address, 1);
+	return err;
+}
+
+static void __exit
+it8712f_wdt_exit(void)
+{
+	misc_deregister(&it8712f_wdt_miscdev);
+	unregister_reboot_notifier(&it8712f_wdt_notifier);
+	release_region(address, 1);
+}
+
+module_init(it8712f_wdt_init);
+module_exit(it8712f_wdt_exit);
diff --git a/drivers/watchdog/sbc7240_wdt.c b/drivers/watchdog/sbc7240_wdt.c
new file mode 100644
index 0000000..4c8cefb
--- /dev/null
+++ b/drivers/watchdog/sbc7240_wdt.c
@@ -0,0 +1,324 @@
+/*
+ *	NANO7240 SBC Watchdog device driver
+ *
+ *	Based on w83877f.c by Scott Jennings,
+ *
+ *	This program is free software; you can redistribute it and/or modify
+ *	it under the terms of the GNU General Public License version 2 as
+ *	published by the Free Software Foundation;
+ *
+ *	Software distributed under the License is distributed on an "AS IS"
+ *	basis, WITHOUT WARRANTY OF ANY KIND, either express or
+ *	implied. See the License for the specific language governing
+ *	rights and limitations under the License.
+ *
+ *	(c) Copyright 2007  Gilles GIGAN <gilles.gigan@jcu.edu.au>
+ *
+ */
+
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/ioport.h>
+#include <linux/jiffies.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/miscdevice.h>
+#include <linux/notifier.h>
+#include <linux/reboot.h>
+#include <linux/types.h>
+#include <linux/watchdog.h>
+#include <asm/atomic.h>
+#include <asm/io.h>
+#include <asm/system.h>
+#include <asm/uaccess.h>
+
+#define SBC7240_PREFIX "sbc7240_wdt: "
+
+#define SBC7240_ENABLE_PORT		0x443
+#define SBC7240_DISABLE_PORT		0x043
+#define SBC7240_SET_TIMEOUT_PORT	SBC7240_ENABLE_PORT
+#define SBC7240_MAGIC_CHAR		'V'
+
+#define SBC7240_TIMEOUT		30
+#define SBC7240_MAX_TIMEOUT		255
+static int timeout = SBC7240_TIMEOUT;	/* in seconds */
+module_param(timeout, int, 0);
+MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. (1<=timeout<="
+		 __MODULE_STRING(SBC7240_MAX_TIMEOUT) ", default="
+		 __MODULE_STRING(SBC7240_TIMEOUT) ")");
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Disable watchdog when closing device file");
+
+#define SBC7240_OPEN_STATUS_BIT		0
+#define SBC7240_ENABLED_STATUS_BIT	1
+#define SBC7240_EXPECT_CLOSE_STATUS_BIT	2
+static unsigned long wdt_status;
+
+/*
+ * Utility routines
+ */
+
+static void wdt_disable(void)
+{
+	/* disable the watchdog */
+	if (test_and_clear_bit(SBC7240_ENABLED_STATUS_BIT, &wdt_status)) {
+		inb_p(SBC7240_DISABLE_PORT);
+		printk(KERN_INFO SBC7240_PREFIX
+		       "Watchdog timer is now disabled.\n");
+	}
+}
+
+static void wdt_enable(void)
+{
+	/* enable the watchdog */
+	if (!test_and_set_bit(SBC7240_ENABLED_STATUS_BIT, &wdt_status)) {
+		inb_p(SBC7240_ENABLE_PORT);
+		printk(KERN_INFO SBC7240_PREFIX
+		       "Watchdog timer is now enabled.\n");
+	}
+}
+
+static int wdt_set_timeout(int t)
+{
+	if (t < 1 || t > SBC7240_MAX_TIMEOUT) {
+		printk(KERN_ERR SBC7240_PREFIX
+		       "timeout value must be 1<=x<=%d\n",
+		       SBC7240_MAX_TIMEOUT);
+		return -1;
+	}
+	/* set the timeout */
+	outb_p((unsigned)t, SBC7240_SET_TIMEOUT_PORT);
+	timeout = t;
+	printk(KERN_INFO SBC7240_PREFIX "timeout set to %d seconds\n", t);
+	return 0;
+}
+
+/* Whack the dog */
+static inline void wdt_keepalive(void)
+{
+	if (test_bit(SBC7240_ENABLED_STATUS_BIT, &wdt_status))
+		inb_p(SBC7240_ENABLE_PORT);
+}
+
+/*
+ * /dev/watchdog handling
+ */
+static ssize_t fop_write(struct file *file, const char __user *buf,
+			 size_t count, loff_t *ppos)
+{
+	size_t i;
+	char c;
+
+	if (count) {
+		if (!nowayout) {
+			clear_bit(SBC7240_EXPECT_CLOSE_STATUS_BIT,
+				&wdt_status);
+
+			/* is there a magic char ? */
+			for (i = 0; i != count; i++) {
+				if (get_user(c, buf + i))
+					return -EFAULT;
+				if (c == SBC7240_MAGIC_CHAR) {
+					set_bit(SBC7240_EXPECT_CLOSE_STATUS_BIT,
+						&wdt_status);
+					break;
+				}
+			}
+		}
+
+		wdt_keepalive();
+	}
+
+	return count;
+}
+
+static int fop_open(struct inode *inode, struct file *file)
+{
+	if (test_and_set_bit(SBC7240_OPEN_STATUS_BIT, &wdt_status))
+		return -EBUSY;
+
+	wdt_enable();
+
+	return nonseekable_open(inode, file);
+}
+
+static int fop_close(struct inode *inode, struct file *file)
+{
+	if (test_and_clear_bit(SBC7240_EXPECT_CLOSE_STATUS_BIT, &wdt_status)
+	    || !nowayout) {
+		wdt_disable();
+	} else {
+		printk(KERN_CRIT SBC7240_PREFIX
+		       "Unexpected close, not stopping watchdog!\n");
+		wdt_keepalive();
+	}
+
+	clear_bit(SBC7240_OPEN_STATUS_BIT, &wdt_status);
+	return 0;
+}
+
+static struct watchdog_info ident = {
+	.options = WDIOF_KEEPALIVEPING|
+		   WDIOF_SETTIMEOUT|
+		   WDIOF_MAGICCLOSE,
+	.firmware_version = 1,
+	.identity = "SBC7240",
+};
+
+
+static int fop_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
+		     unsigned long arg)
+{
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user
+			((void __user *)arg, &ident, sizeof(ident))
+			 ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, (int __user *)arg);
+	case WDIOC_KEEPALIVE:
+		wdt_keepalive();
+		return 0;
+	case WDIOC_SETOPTIONS:{
+			int options;
+			int retval = -EINVAL;
+
+			if (get_user(options, (int __user *)arg))
+				return -EFAULT;
+
+			if (options & WDIOS_DISABLECARD) {
+				wdt_disable();
+				retval = 0;
+			}
+
+			if (options & WDIOS_ENABLECARD) {
+				wdt_enable();
+				retval = 0;
+			}
+
+			return retval;
+		}
+	case WDIOC_SETTIMEOUT:{
+			int new_timeout;
+
+			if (get_user(new_timeout, (int __user *)arg))
+				return -EFAULT;
+
+			if (wdt_set_timeout(new_timeout))
+				return -EINVAL;
+
+			/* Fall through */
+		}
+	case WDIOC_GETTIMEOUT:
+		return put_user(timeout, (int __user *)arg);
+	default:
+		return -ENOTTY;
+	}
+}
+
+static const struct file_operations wdt_fops = {
+	.owner = THIS_MODULE,
+	.llseek = no_llseek,
+	.write = fop_write,
+	.open = fop_open,
+	.release = fop_close,
+	.ioctl = fop_ioctl,
+};
+
+static struct miscdevice wdt_miscdev = {
+	.minor = WATCHDOG_MINOR,
+	.name = "watchdog",
+	.fops = &wdt_fops,
+};
+
+/*
+ *	Notifier for system down
+ */
+
+static int wdt_notify_sys(struct notifier_block *this, unsigned long code,
+			  void *unused)
+{
+	if (code == SYS_DOWN || code == SYS_HALT)
+		wdt_disable();
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block wdt_notifier = {
+	.notifier_call = wdt_notify_sys,
+};
+
+static void __exit sbc7240_wdt_unload(void)
+{
+	printk(KERN_INFO SBC7240_PREFIX "Removing watchdog\n");
+	misc_deregister(&wdt_miscdev);
+
+	unregister_reboot_notifier(&wdt_notifier);
+	release_region(SBC7240_ENABLE_PORT, 1);
+}
+
+static int __init sbc7240_wdt_init(void)
+{
+	int rc = -EBUSY;
+
+	if (!request_region(SBC7240_ENABLE_PORT, 1, "SBC7240 WDT")) {
+		printk(KERN_ERR SBC7240_PREFIX
+		       "I/O address 0x%04x already in use\n",
+		       SBC7240_ENABLE_PORT);
+		rc = -EIO;
+		goto err_out;
+	}
+
+	/* The IO port 0x043 used to disable the watchdog
+	 * is already claimed by the system timer, so we
+	 * cant request_region() it ...*/
+
+	if (timeout < 1 || timeout > SBC7240_MAX_TIMEOUT) {
+		timeout = SBC7240_TIMEOUT;
+		printk(KERN_INFO SBC7240_PREFIX
+		       "timeout value must be 1<=x<=%d, using %d\n",
+		       SBC7240_MAX_TIMEOUT, timeout);
+	}
+	wdt_set_timeout(timeout);
+	wdt_disable();
+
+	rc = register_reboot_notifier(&wdt_notifier);
+	if (rc) {
+		printk(KERN_ERR SBC7240_PREFIX
+		       "cannot register reboot notifier (err=%d)\n", rc);
+		goto err_out_region;
+	}
+
+	rc = misc_register(&wdt_miscdev);
+	if (rc) {
+		printk(KERN_ERR SBC7240_PREFIX
+		       "cannot register miscdev on minor=%d (err=%d)\n",
+		       wdt_miscdev.minor, rc);
+		goto err_out_reboot_notifier;
+	}
+
+	printk(KERN_INFO SBC7240_PREFIX
+	       "Watchdog driver for SBC7240 initialised (nowayout=%d)\n",
+	       nowayout);
+
+	return 0;
+
+err_out_reboot_notifier:
+	unregister_reboot_notifier(&wdt_notifier);
+err_out_region:
+	release_region(SBC7240_ENABLE_PORT, 1);
+err_out:
+	return rc;
+}
+
+module_init(sbc7240_wdt_init);
+module_exit(sbc7240_wdt_unload);
+
+MODULE_AUTHOR("Gilles Gigan");
+MODULE_DESCRIPTION("Watchdog device driver for single board"
+		   " computers EPIC Nano 7240 from iEi");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+
diff --git a/drivers/watchdog/w83697hf_wdt.c b/drivers/watchdog/w83697hf_wdt.c
index c622a0e..6ea125e 100644
--- a/drivers/watchdog/w83697hf_wdt.c
+++ b/drivers/watchdog/w83697hf_wdt.c
@@ -382,8 +382,10 @@ wdt_init(void)
 		/* we will autodetect the W83697HF/HG watchdog */
 		for (i = 0; ((!found) && (w83697hf_ioports[i] != 0)); i++) {
 			wdt_io = w83697hf_ioports[i];
-			if (!w83697hf_check_wdt())
+			if (!w83697hf_check_wdt()) {
 				found++;
+				break;
+			}
 		}
 	} else {
 		if (!w83697hf_check_wdt())
