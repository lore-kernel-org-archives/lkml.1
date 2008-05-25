Return-Path: <linux-kernel-owner+w=401wt.eu-S1761504AbYEYKKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761504AbYEYKKG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 06:10:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756091AbYEYKJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 06:09:53 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:38470 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753540AbYEYKJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 06:09:51 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAEbWOEhQyAc0/2dsb2JhbACBVaoz
Date: Sun, 25 May 2008 12:09:44 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Samuel Tardieu <sam@rfc1149.net>,
       Mike Frysinger <vapier.adi@gmail.com>, Mingarelli@infomag.iguana.be,
       Thomas <Thomas.Mingarelli@hp.com>,
       Jordan Crouse <jordan.crouse@amd.com>, Chen Gong <g.chen@freescale.com>,
       Gabriel C <nix.or.die@googlemail.com>
Subject: [WATCHDOG] v2.6.26-rc3 patches
Message-ID: <20080525100944.GA4084@infomag.infomag.iguana.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Sorry for the delay's. Our new house is however a bigger priority.
I compiled the patches/fixes and a new driver that should go in for
the 2.6.26 release.

Note: On the watchdog side we still have 2 drivers from Florian Fainelli
(where I need to check if we have all fixes first) and Alan's Cox
clean-up patches. After that we have the at91sam* driver, the problem
with some ICH9 based motherboards, the new driver for the SCH311X io-chipset
and we should proceed on the uniform watchdog driver.

So please allready pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 drivers/watchdog/Kconfig        |   13 +
 drivers/watchdog/Makefile       |    1 
 drivers/watchdog/bfin_wdt.c     |  111 +++++++++-----
 drivers/watchdog/booke_wdt.c    |   88 +++++------
 drivers/watchdog/geodewdt.c     |  309 ++++++++++++++++++++++++++++++++++++++++
 drivers/watchdog/hpwdt.c        |   27 +--
 drivers/watchdog/iTCO_wdt.c     |   14 +
 drivers/watchdog/w83697hf_wdt.c |   38 +++-
 8 files changed, 485 insertions(+), 116 deletions(-)

with these Changes:

Author: Gabriel C <nix.or.die@googlemail.com>
Date:   Wed Apr 30 16:51:10 2008 +0200

    [WATCHDOG] Add ICH9DO into the iTCO_wdt.c driver
    
    Add the Intel ICH9DO controller ID's for the iTCO_wdt kernel driver and bump
    the driver version.
    
    Tested on an P5E-VM DO ASUS motherboard.
    
    Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Author: Chen Gong <g.chen@freescale.com>
Date:   Tue Apr 29 16:42:05 2008 +0800

    [WATCHDOG] Fix booke_wdt.c on MPC85xx SMP system's
    
    On Book-E SMP systems each core has its own private watchdog.  If only one
    watchdog is enabled, when the core that doesn't enable the watchdog is hung,
    system can't reset because no watchdog is running on it.  That's bad.  It
    means we must enable watchdogs on both cores.
    
    We can use smp_call_function() to send appropriate messages to all the other
    cores to enable and update the watchdog.
    
    Signed-off-by: Chen Gong <g.chen@freescale.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Author: Jordan Crouse <jordan.crouse@amd.com>
Date:   Mon Jan 21 10:07:00 2008 -0700

    [WATCHDOG] Add a watchdog driver based on the CS5535/CS5536 MFGPT timers
    
    Add a watchdog timer based on the MFGPT timers in the CS5535/CS5536
    companion chips to the AMD Geode GX and LX processors.  Only caveat
    is that the BIOS must provide at least a one free timer, and most
    do not.
    
    Signed-off-by: Jordan Crouse <jordan.crouse@amd.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Mingarelli, Thomas <Thomas.Mingarelli@hp.com>
Date:   Tue Mar 25 17:17:30 2008 +0000

    [WATCHDOG] hpwdt: Fix NMI handling.
    
    I need to just return in case it's not my NMI so someone else can take a look
    at it (and reset die_nmi_called to 0 in case I actually do get one that's mine
    to handle).
    
    Signed-off-by: Thomas Mingarelli <thomas.mingarelli@hp.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Mike Frysinger <vapier.adi@gmail.com>
Date:   Thu Mar 27 11:53:32 2008 -0700

    [WATCHDOG] Blackfin Watchdog Driver: split platform device/driver
    
     - split platform device/driver registering from actual watchdog device/driver
       registering so that we can cleanly load/unload
     - fixup __initdata with __initconst and __devinitdata with __devinitconst
    
    Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
    Signed-off-by: Bryan Wu <cooloney@kernel.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Samuel Tardieu <sam@rfc1149.net>
Date:   Wed Mar 12 14:28:03 2008 +0100

    [WATCHDOG] Add w83697h_wdt early_disable option
    
    Pádraig Brady requested the possibility of not disabling the watchdog
    at module load time or kernel boot time if it had been previously enabled
    in the bios. It may help rebooting the machine if it freezes before the
    userland daemon kicks in.
    
    Signed-off-by: Samuel Tardieu <sam@rfc1149.net>
    Cc: Pádraig Brady <P@draigBrady.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Samuel Tardieu <sam@rfc1149.net>
Date:   Wed Mar 12 14:28:02 2008 +0100

    [WATCHDOG] Make w83697h_wdt timeout option string similar to others
    
    Signed-off-by: Samuel Tardieu <sam@rfc1149.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Samuel Tardieu <sam@rfc1149.net>
Date:   Wed Mar 12 14:28:01 2008 +0100

    [WATCHDOG] Make w83697h_wdt void-like functions void
    
    Some non-exported functions always returned 0. Mark them void instead.
    
    Signed-off-by: Samuel Tardieu <sam@rfc1149.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 254d115..ccb78f6 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -295,6 +295,19 @@ config ALIM7101_WDT
 
 	  Most people will say N.
 
+config GEODE_WDT
+	tristate "AMD Geode CS5535/CS5536 Watchdog"
+	depends on MGEODE_LX
+	help
+	  This driver enables a watchdog capability built into the
+	  CS5535/CS5536 companion chips for the AMD Geode GX and LX
+	  processors.  This watchdog watches your kernel to make sure
+	  it doesn't freeze, and if it does, it reboots your computer after
+	  a certain amount of time.
+
+	  You can compile this driver directly into the kernel, or use
+	  it as a module.  The module will be called geodewdt.
+
 config SC520_WDT
 	tristate "AMD Elan SC520 processor Watchdog"
 	depends on X86
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index f3fb170..25b352b 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -59,6 +59,7 @@ obj-$(CONFIG_ACQUIRE_WDT) += acquirewdt.o
 obj-$(CONFIG_ADVANTECH_WDT) += advantechwdt.o
 obj-$(CONFIG_ALIM1535_WDT) += alim1535_wdt.o
 obj-$(CONFIG_ALIM7101_WDT) += alim7101_wdt.o
+obj-$(CONFIG_GEODE_WDT) += geodewdt.o
 obj-$(CONFIG_SC520_WDT) += sc520_wdt.o
 obj-$(CONFIG_EUROTECH_WDT) += eurotechwdt.o
 obj-$(CONFIG_IB700_WDT) += ib700wdt.o
diff --git a/drivers/watchdog/bfin_wdt.c b/drivers/watchdog/bfin_wdt.c
index 1237113..03b3e3d 100644
--- a/drivers/watchdog/bfin_wdt.c
+++ b/drivers/watchdog/bfin_wdt.c
@@ -29,7 +29,8 @@
 
 #define stamp(fmt, args...) pr_debug("%s:%i: " fmt "\n", __func__, __LINE__, ## args)
 #define stampit() stamp("here i am")
-#define pr_init(fmt, args...) ({ static const __initdata char __fmt[] = fmt; printk(__fmt, ## args); })
+#define pr_devinit(fmt, args...) ({ static const __devinitconst char __fmt[] = fmt; printk(__fmt, ## args); })
+#define pr_init(fmt, args...) ({ static const __initconst char __fmt[] = fmt; printk(__fmt, ## args); })
 
 #define WATCHDOG_NAME "bfin-wdt"
 #define PFX WATCHDOG_NAME ": "
@@ -377,20 +378,6 @@ static int bfin_wdt_resume(struct platform_device *pdev)
 # define bfin_wdt_resume NULL
 #endif
 
-static struct platform_device bfin_wdt_device = {
-	.name          = WATCHDOG_NAME,
-	.id            = -1,
-};
-
-static struct platform_driver bfin_wdt_driver = {
-	.driver    = {
-		.name  = WATCHDOG_NAME,
-		.owner = THIS_MODULE,
-	},
-	.suspend   = bfin_wdt_suspend,
-	.resume    = bfin_wdt_resume,
-};
-
 static const struct file_operations bfin_wdt_fops = {
 	.owner    = THIS_MODULE,
 	.llseek   = no_llseek,
@@ -418,11 +405,67 @@ static struct notifier_block bfin_wdt_notifier = {
 };
 
 /**
- *	bfin_wdt_init - Initialize module
+ *	bfin_wdt_probe - Initialize module
  *
- *	Registers the device and notifier handler. Actual device
+ *	Registers the misc device and notifier handler.  Actual device
  *	initialization is handled by bfin_wdt_open().
  */
+static int __devinit bfin_wdt_probe(struct platform_device *pdev)
+{
+	int ret;
+
+	ret = register_reboot_notifier(&bfin_wdt_notifier);
+	if (ret) {
+		pr_devinit(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n", ret);
+		return ret;
+	}
+
+	ret = misc_register(&bfin_wdt_miscdev);
+	if (ret) {
+		pr_devinit(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
+		       WATCHDOG_MINOR, ret);
+		unregister_reboot_notifier(&bfin_wdt_notifier);
+		return ret;
+	}
+
+	pr_devinit(KERN_INFO PFX "initialized: timeout=%d sec (nowayout=%d)\n",
+	       timeout, nowayout);
+
+	return 0;
+}
+
+/**
+ *	bfin_wdt_remove - Initialize module
+ *
+ *	Unregisters the misc device and notifier handler.  Actual device
+ *	deinitialization is handled by bfin_wdt_close().
+ */
+static int __devexit bfin_wdt_remove(struct platform_device *pdev)
+{
+	misc_deregister(&bfin_wdt_miscdev);
+	unregister_reboot_notifier(&bfin_wdt_notifier);
+	return 0;
+}
+
+static struct platform_device *bfin_wdt_device;
+
+static struct platform_driver bfin_wdt_driver = {
+	.probe     = bfin_wdt_probe,
+	.remove    = __devexit_p(bfin_wdt_remove),
+	.suspend   = bfin_wdt_suspend,
+	.resume    = bfin_wdt_resume,
+	.driver    = {
+		.name  = WATCHDOG_NAME,
+		.owner = THIS_MODULE,
+	},
+};
+
+/**
+ *	bfin_wdt_init - Initialize module
+ *
+ *	Checks the module params and registers the platform device & driver.
+ *	Real work is in the platform probe function.
+ */
 static int __init bfin_wdt_init(void)
 {
 	int ret;
@@ -436,44 +479,32 @@ static int __init bfin_wdt_init(void)
 	/* Since this is an on-chip device and needs no board-specific
 	 * resources, we'll handle all the platform device stuff here.
 	 */
-	ret = platform_device_register(&bfin_wdt_device);
-	if (ret)
-		return ret;
-
-	ret = platform_driver_probe(&bfin_wdt_driver, NULL);
-	if (ret)
-		return ret;
-
-	ret = register_reboot_notifier(&bfin_wdt_notifier);
+	ret = platform_driver_register(&bfin_wdt_driver);
 	if (ret) {
-		pr_init(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n", ret);
+		pr_init(KERN_ERR PFX "unable to register driver\n");
 		return ret;
 	}
 
-	ret = misc_register(&bfin_wdt_miscdev);
-	if (ret) {
-		pr_init(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-		       WATCHDOG_MINOR, ret);
-		unregister_reboot_notifier(&bfin_wdt_notifier);
-		return ret;
+	bfin_wdt_device = platform_device_register_simple(WATCHDOG_NAME, -1, NULL, 0);
+	if (IS_ERR(bfin_wdt_device)) {
+		pr_init(KERN_ERR PFX "unable to register device\n");
+		platform_driver_unregister(&bfin_wdt_driver);
+		return PTR_ERR(bfin_wdt_device);
 	}
 
-	pr_init(KERN_INFO PFX "initialized: timeout=%d sec (nowayout=%d)\n",
-	       timeout, nowayout);
-
 	return 0;
 }
 
 /**
  *	bfin_wdt_exit - Deinitialize module
  *
- *	Unregisters the device and notifier handler. Actual device
- *	deinitialization is handled by bfin_wdt_close().
+ *	Back out the platform device & driver steps.  Real work is in the
+ *	platform remove function.
  */
 static void __exit bfin_wdt_exit(void)
 {
-	misc_deregister(&bfin_wdt_miscdev);
-	unregister_reboot_notifier(&bfin_wdt_notifier);
+	platform_device_unregister(bfin_wdt_device);
+	platform_driver_unregister(&bfin_wdt_driver);
 }
 
 module_init(bfin_wdt_init);
diff --git a/drivers/watchdog/booke_wdt.c b/drivers/watchdog/booke_wdt.c
index d362f5b..c1ba0db 100644
--- a/drivers/watchdog/booke_wdt.c
+++ b/drivers/watchdog/booke_wdt.c
@@ -1,12 +1,10 @@
 /*
- * drivers/char/watchdog/booke_wdt.c
- *
  * Watchdog timer for PowerPC Book-E systems
  *
  * Author: Matthew McClintock
  * Maintainer: Kumar Gala <galak@kernel.crashing.org>
  *
- * Copyright 2005 Freescale Semiconductor Inc.
+ * Copyright 2005, 2008 Freescale Semiconductor Inc.
  *
  * This program is free software; you can redistribute  it and/or modify it
  * under  the terms of  the GNU General  Public License as published by the
@@ -16,6 +14,7 @@
 
 #include <linux/module.h>
 #include <linux/fs.h>
+#include <linux/smp.h>
 #include <linux/miscdevice.h>
 #include <linux/notifier.h>
 #include <linux/watchdog.h>
@@ -38,7 +37,7 @@
 #define WDT_PERIOD_DEFAULT 3	/* Refer to the PPC40x and PPC4xx manuals */
 #endif				/* for timing information */
 
-u32 booke_wdt_enabled = 0;
+u32 booke_wdt_enabled;
 u32 booke_wdt_period = WDT_PERIOD_DEFAULT;
 
 #ifdef	CONFIG_FSL_BOOKE
@@ -47,33 +46,31 @@ u32 booke_wdt_period = WDT_PERIOD_DEFAULT;
 #define WDTP(x)		(TCR_WP(x))
 #endif
 
-/*
- * booke_wdt_ping:
- */
-static __inline__ void booke_wdt_ping(void)
+static DEFINE_SPINLOCK(booke_wdt_lock);
+
+static void __booke_wdt_ping(void *data)
 {
 	mtspr(SPRN_TSR, TSR_ENW|TSR_WIS);
 }
 
-/*
- * booke_wdt_enable:
- */
-static __inline__ void booke_wdt_enable(void)
+static void booke_wdt_ping(void)
+{
+	on_each_cpu(__booke_wdt_ping, NULL, 0, 0);
+}
+
+static void __booke_wdt_enable(void *data)
 {
 	u32 val;
 
 	/* clear status before enabling watchdog */
-	booke_wdt_ping();
+	__booke_wdt_ping(NULL);
 	val = mfspr(SPRN_TCR);
 	val |= (TCR_WIE|TCR_WRC(WRC_CHIP)|WDTP(booke_wdt_period));
 
 	mtspr(SPRN_TCR, val);
 }
 
-/*
- * booke_wdt_write:
- */
-static ssize_t booke_wdt_write (struct file *file, const char __user *buf,
+static ssize_t booke_wdt_write(struct file *file, const char __user *buf,
 				size_t count, loff_t *ppos)
 {
 	booke_wdt_ping();
@@ -81,15 +78,11 @@ static ssize_t booke_wdt_write (struct file *file, const char __user *buf,
 }
 
 static struct watchdog_info ident = {
-  .options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
-  .firmware_version = 0,
-  .identity = "PowerPC Book-E Watchdog",
+	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING,
+	.identity = "PowerPC Book-E Watchdog",
 };
 
-/*
- * booke_wdt_ioctl:
- */
-static int booke_wdt_ioctl (struct inode *inode, struct file *file,
+static int booke_wdt_ioctl(struct inode *inode, struct file *file,
 			    unsigned int cmd, unsigned long arg)
 {
 	u32 tmp = 0;
@@ -97,7 +90,7 @@ static int booke_wdt_ioctl (struct inode *inode, struct file *file,
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
-		if (copy_to_user ((struct watchdog_info __user *) arg, &ident,
+		if (copy_to_user((struct watchdog_info __user *)arg, &ident,
 				sizeof(struct watchdog_info)))
 			return -EFAULT;
 	case WDIOC_GETSTATUS:
@@ -132,33 +125,33 @@ static int booke_wdt_ioctl (struct inode *inode, struct file *file,
 
 	return 0;
 }
-/*
- * booke_wdt_open:
- */
-static int booke_wdt_open (struct inode *inode, struct file *file)
+
+static int booke_wdt_open(struct inode *inode, struct file *file)
 {
+	spin_lock(&booke_wdt_lock);
 	if (booke_wdt_enabled == 0) {
 		booke_wdt_enabled = 1;
-		booke_wdt_enable();
-		printk (KERN_INFO "PowerPC Book-E Watchdog Timer Enabled (wdt_period=%d)\n",
-				booke_wdt_period);
+		on_each_cpu(__booke_wdt_enable, NULL, 0, 0);
+		printk(KERN_INFO "PowerPC Book-E Watchdog Timer Enabled "
+				"(wdt_period=%d)\n", booke_wdt_period);
 	}
+	spin_unlock(&booke_wdt_lock);
 
 	return nonseekable_open(inode, file);
 }
 
 static const struct file_operations booke_wdt_fops = {
-  .owner = THIS_MODULE,
-  .llseek = no_llseek,
-  .write = booke_wdt_write,
-  .ioctl = booke_wdt_ioctl,
-  .open = booke_wdt_open,
+	.owner = THIS_MODULE,
+	.llseek = no_llseek,
+	.write = booke_wdt_write,
+	.ioctl = booke_wdt_ioctl,
+	.open = booke_wdt_open,
 };
 
 static struct miscdevice booke_wdt_miscdev = {
-  .minor = WATCHDOG_MINOR,
-  .name = "watchdog",
-  .fops = &booke_wdt_fops,
+	.minor = WATCHDOG_MINOR,
+	.name = "watchdog",
+	.fops = &booke_wdt_fops,
 };
 
 static void __exit booke_wdt_exit(void)
@@ -166,28 +159,27 @@ static void __exit booke_wdt_exit(void)
 	misc_deregister(&booke_wdt_miscdev);
 }
 
-/*
- * booke_wdt_init:
- */
 static int __init booke_wdt_init(void)
 {
 	int ret = 0;
 
-	printk (KERN_INFO "PowerPC Book-E Watchdog Timer Loaded\n");
+	printk(KERN_INFO "PowerPC Book-E Watchdog Timer Loaded\n");
 	ident.firmware_version = cur_cpu_spec->pvr_value;
 
 	ret = misc_register(&booke_wdt_miscdev);
 	if (ret) {
-		printk (KERN_CRIT "Cannot register miscdev on minor=%d (err=%d)\n",
+		printk(KERN_CRIT "Cannot register miscdev on minor=%d: %d\n",
 				WATCHDOG_MINOR, ret);
 		return ret;
 	}
 
+	spin_lock(&booke_wdt_lock);
 	if (booke_wdt_enabled == 1) {
-		printk (KERN_INFO "PowerPC Book-E Watchdog Timer Enabled (wdt_period=%d)\n",
-				booke_wdt_period);
-		booke_wdt_enable();
+		printk(KERN_INFO "PowerPC Book-E Watchdog Timer Enabled "
+				"(wdt_period=%d)\n", booke_wdt_period);
+		on_each_cpu(__booke_wdt_enable, NULL, 0, 0);
 	}
+	spin_unlock(&booke_wdt_lock);
 
 	return ret;
 }
diff --git a/drivers/watchdog/geodewdt.c b/drivers/watchdog/geodewdt.c
new file mode 100644
index 0000000..f85b196
--- /dev/null
+++ b/drivers/watchdog/geodewdt.c
@@ -0,0 +1,309 @@
+/* Watchdog timer for the Geode GX/LX with the CS5535/CS5536 companion chip
+ *
+ * Copyright (C) 2006-2007, Advanced Micro Devices, Inc.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/types.h>
+#include <linux/miscdevice.h>
+#include <linux/watchdog.h>
+#include <linux/fs.h>
+#include <linux/platform_device.h>
+#include <linux/reboot.h>
+
+#include <asm/uaccess.h>
+#include <asm/geode.h>
+
+#define GEODEWDT_HZ 500
+#define GEODEWDT_SCALE 6
+#define GEODEWDT_MAX_SECONDS 131
+
+#define WDT_FLAGS_OPEN 1
+#define WDT_FLAGS_ORPHAN 2
+
+#define DRV_NAME "geodewdt"
+#define WATCHDOG_NAME "Geode GX/LX WDT"
+#define WATCHDOG_TIMEOUT 60
+
+static int timeout = WATCHDOG_TIMEOUT;
+module_param(timeout, int, 0);
+MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. 1<= timeout <=131, default=" __MODULE_STRING(WATCHDOG_TIMEOUT) ".");
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+static struct platform_device *geodewdt_platform_device;
+static unsigned long wdt_flags;
+static int wdt_timer;
+static int safe_close;
+
+static void geodewdt_ping(void)
+{
+	/* Stop the counter */
+	geode_mfgpt_write(wdt_timer, MFGPT_REG_SETUP, 0);
+
+	/* Reset the counter */
+	geode_mfgpt_write(wdt_timer, MFGPT_REG_COUNTER, 0);
+
+	/* Enable the counter */
+	geode_mfgpt_write(wdt_timer, MFGPT_REG_SETUP, MFGPT_SETUP_CNTEN);
+}
+
+static void geodewdt_disable(void)
+{
+	geode_mfgpt_write(wdt_timer, MFGPT_REG_SETUP, 0);
+	geode_mfgpt_write(wdt_timer, MFGPT_REG_COUNTER, 0);
+}
+
+static int geodewdt_set_heartbeat(int val)
+{
+	if (val < 1 || val > GEODEWDT_MAX_SECONDS)
+		return -EINVAL;
+
+	geode_mfgpt_write(wdt_timer, MFGPT_REG_SETUP, 0);
+	geode_mfgpt_write(wdt_timer, MFGPT_REG_CMP2, val * GEODEWDT_HZ);
+	geode_mfgpt_write(wdt_timer, MFGPT_REG_COUNTER, 0);
+	geode_mfgpt_write(wdt_timer, MFGPT_REG_SETUP, MFGPT_SETUP_CNTEN);
+
+	timeout = val;
+	return 0;
+}
+
+static int
+geodewdt_open(struct inode *inode, struct file *file)
+{
+        if (test_and_set_bit(WDT_FLAGS_OPEN, &wdt_flags))
+                return -EBUSY;
+
+        if (!test_and_clear_bit(WDT_FLAGS_ORPHAN, &wdt_flags))
+                __module_get(THIS_MODULE);
+
+	geodewdt_ping();
+        return nonseekable_open(inode, file);
+}
+
+static int
+geodewdt_release(struct inode *inode, struct file *file)
+{
+	if (safe_close) {
+		geodewdt_disable();
+		module_put(THIS_MODULE);
+	}
+	else {
+		printk(KERN_CRIT "Unexpected close - watchdog is not stopping.\n");
+		geodewdt_ping();
+
+		set_bit(WDT_FLAGS_ORPHAN, &wdt_flags);
+	}
+
+	clear_bit(WDT_FLAGS_OPEN, &wdt_flags);
+	safe_close = 0;
+	return 0;
+}
+
+static ssize_t
+geodewdt_write(struct file *file, const char __user *data, size_t len,
+	       loff_t *ppos)
+{
+        if(len) {
+		if (!nowayout) {
+			size_t i;
+			safe_close = 0;
+
+			for (i = 0; i != len; i++) {
+				char c;
+
+				if (get_user(c, data + i))
+					return -EFAULT;
+
+				if (c == 'V')
+					safe_close = 1;
+			}
+		}
+
+		geodewdt_ping();
+	}
+	return len;
+}
+
+static int
+geodewdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
+	       unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
+	int interval;
+
+	static struct watchdog_info ident = {
+		.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING
+		| WDIOF_MAGICCLOSE,
+		.firmware_version =     1,
+		.identity =             WATCHDOG_NAME,
+        };
+
+	switch(cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &ident,
+				    sizeof(ident)) ? -EFAULT : 0;
+		break;
+
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+
+	case WDIOC_KEEPALIVE:
+		geodewdt_ping();
+		return 0;
+
+	case WDIOC_SETTIMEOUT:
+		if (get_user(interval, p))
+			return -EFAULT;
+
+		if (geodewdt_set_heartbeat(interval))
+			return -EINVAL;
+
+/* Fall through */
+
+	case WDIOC_GETTIMEOUT:
+		return put_user(timeout, p);
+
+	case WDIOC_SETOPTIONS:
+	{
+		int options, ret = -EINVAL;
+
+		if (get_user(options, p))
+			return -EFAULT;
+
+		if (options & WDIOS_DISABLECARD) {
+			geodewdt_disable();
+			ret = 0;
+		}
+
+		if (options & WDIOS_ENABLECARD) {
+			geodewdt_ping();
+			ret = 0;
+		}
+
+		return ret;
+	}
+	default:
+		return -ENOTTY;
+	}
+
+	return 0;
+}
+
+static const struct file_operations geodewdt_fops = {
+        .owner          = THIS_MODULE,
+        .llseek         = no_llseek,
+        .write          = geodewdt_write,
+        .ioctl          = geodewdt_ioctl,
+        .open           = geodewdt_open,
+        .release        = geodewdt_release,
+};
+
+static struct miscdevice geodewdt_miscdev = {
+	.minor = WATCHDOG_MINOR,
+	.name = "watchdog",
+	.fops = &geodewdt_fops
+};
+
+static int __devinit
+geodewdt_probe(struct platform_device *dev)
+{
+	int ret, timer;
+
+	timer = geode_mfgpt_alloc_timer(MFGPT_TIMER_ANY,
+					MFGPT_DOMAIN_WORKING, THIS_MODULE);
+
+	if (timer == -1) {
+		printk(KERN_ERR "geodewdt:  No timers were available\n");
+		return -ENODEV;
+	}
+
+	wdt_timer = timer;
+
+	/* Set up the timer */
+
+	geode_mfgpt_write(wdt_timer, MFGPT_REG_SETUP,
+			  GEODEWDT_SCALE | (3 << 8));
+
+	/* Set up comparator 2 to reset when the event fires */
+	geode_mfgpt_toggle_event(wdt_timer, MFGPT_CMP2, MFGPT_EVENT_RESET, 1);
+
+	/* Set up the initial timeout */
+
+	geode_mfgpt_write(wdt_timer, MFGPT_REG_CMP2,
+		timeout * GEODEWDT_HZ);
+
+	ret = misc_register(&geodewdt_miscdev);
+
+	return ret;
+}
+
+static int __devexit
+geodewdt_remove(struct platform_device *dev)
+{
+	misc_deregister(&geodewdt_miscdev);
+	return 0;
+}
+
+static void
+geodewdt_shutdown(struct platform_device *dev)
+{
+	geodewdt_disable();
+}
+
+static struct platform_driver geodewdt_driver = {
+	.probe		= geodewdt_probe,
+	.remove		= __devexit_p(geodewdt_remove),
+	.shutdown	= geodewdt_shutdown,
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= DRV_NAME,
+	},
+};
+
+static int __init
+geodewdt_init(void)
+{
+	int ret;
+
+	ret = platform_driver_register(&geodewdt_driver);
+	if (ret)
+		return ret;
+
+	geodewdt_platform_device = platform_device_register_simple(DRV_NAME, -1, NULL, 0);
+	if (IS_ERR(geodewdt_platform_device)) {
+		ret = PTR_ERR(geodewdt_platform_device);
+		goto err;
+	}
+
+	return 0;
+err:
+	platform_driver_unregister(&geodewdt_driver);
+	return ret;
+}
+
+static void __exit
+geodewdt_exit(void)
+{
+	platform_device_unregister(geodewdt_platform_device);
+	platform_driver_unregister(&geodewdt_driver);
+}
+
+module_init(geodewdt_init);
+module_exit(geodewdt_exit);
+
+MODULE_AUTHOR("Advanced Micro Devices, Inc");
+MODULE_DESCRIPTION("Geode GX/LX Watchdog Driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 6483d10..6a63535 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -418,23 +418,20 @@ static int hpwdt_pretimeout(struct notifier_block *nb, unsigned long ulReason,
 	static unsigned long rom_pl;
 	static int die_nmi_called;
 
-	if (ulReason != DIE_NMI && ulReason != DIE_NMI_IPI)
-		return NOTIFY_OK;
-
-	spin_lock_irqsave(&rom_lock, rom_pl);
-	if (!die_nmi_called)
-		asminline_call(&cmn_regs, cru_rom_addr);
-	die_nmi_called = 1;
-	spin_unlock_irqrestore(&rom_lock, rom_pl);
-	if (cmn_regs.u1.ral == 0) {
-		printk(KERN_WARNING "hpwdt: An NMI occurred, "
-		       "but unable to determine source.\n");
-	} else {
-		panic("An NMI occurred, please see the Integrated "
-			"Management Log for details.\n");
+	if (ulReason == DIE_NMI || ulReason == DIE_NMI_IPI) {
+		spin_lock_irqsave(&rom_lock, rom_pl);
+		if (!die_nmi_called)
+			asminline_call(&cmn_regs, cru_rom_addr);
+		die_nmi_called = 1;
+		spin_unlock_irqrestore(&rom_lock, rom_pl);
+		if (cmn_regs.u1.ral != 0) {
+			panic("An NMI occurred, please see the Integrated "
+			      "Management Log for details.\n");
+		}
 	}
 
-	return NOTIFY_STOP;
+	die_nmi_called = 0;
+	return NOTIFY_DONE;
 }
 
 /*
diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index a0e6809..95ba985 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -41,9 +41,10 @@
  *	82801HH  (ICH8DH)    : document number 313056-003, 313057-009,
  *	82801HO  (ICH8DO)    : document number 313056-003, 313057-009,
  *	82801HEM (ICH8M-E)   : document number 313056-003, 313057-009,
- *	82801IB  (ICH9)      : document number 316972-001, 316973-001,
- *	82801IR  (ICH9R)     : document number 316972-001, 316973-001,
- *	82801IH  (ICH9DH)    : document number 316972-001, 316973-001,
+ *	82801IB  (ICH9)      : document number 316972-001, 316973-006,
+ *	82801IR  (ICH9R)     : document number 316972-001, 316973-006,
+ *	82801IH  (ICH9DH)    : document number 316972-001, 316973-006,
+ *	82801IO  (ICH9DO)    : document number 316972-001, 316973-006,
  *	6300ESB  (6300ESB)   : document number 300641-003, 300884-010,
  *	631xESB  (631xESB)   : document number 313082-001, 313075-005,
  *	632xESB  (632xESB)   : document number 313082-001, 313075-005
@@ -55,8 +56,8 @@
 
 /* Module and version information */
 #define DRV_NAME        "iTCO_wdt"
-#define DRV_VERSION     "1.02"
-#define DRV_RELDATE     "26-Jul-2007"
+#define DRV_VERSION     "1.03"
+#define DRV_RELDATE     "30-Apr-2008"
 #define PFX		DRV_NAME ": "
 
 /* Includes */
@@ -104,6 +105,7 @@ enum iTCO_chipsets {
 	TCO_ICH9,	/* ICH9 */
 	TCO_ICH9R,	/* ICH9R */
 	TCO_ICH9DH,	/* ICH9DH */
+	TCO_ICH9DO,     /* ICH9DO */
 	TCO_631XESB,	/* 631xESB/632xESB */
 };
 
@@ -136,6 +138,7 @@ static struct {
 	{"ICH9", 2},
 	{"ICH9R", 2},
 	{"ICH9DH", 2},
+	{"ICH9DO", 2},
 	{"631xESB/632xESB", 2},
 	{NULL,0}
 };
@@ -181,6 +184,7 @@ static struct pci_device_id iTCO_wdt_pci_tbl[] = {
 	{ ITCO_PCI_DEVICE(0x2918,				TCO_ICH9   )},
 	{ ITCO_PCI_DEVICE(0x2916,				TCO_ICH9R  )},
 	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH9_2,		TCO_ICH9DH )},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH9_4,           TCO_ICH9DO )},
 	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ESB2_0,		TCO_631XESB)},
 	{ ITCO_PCI_DEVICE(0x2671,				TCO_631XESB)},
 	{ ITCO_PCI_DEVICE(0x2672,				TCO_631XESB)},
diff --git a/drivers/watchdog/w83697hf_wdt.c b/drivers/watchdog/w83697hf_wdt.c
index c622a0e..528b882 100644
--- a/drivers/watchdog/w83697hf_wdt.c
+++ b/drivers/watchdog/w83697hf_wdt.c
@@ -44,6 +44,7 @@
 #define WATCHDOG_NAME "w83697hf/hg WDT"
 #define PFX WATCHDOG_NAME ": "
 #define WATCHDOG_TIMEOUT 60		/* 60 sec default timeout */
+#define WATCHDOG_EARLY_DISABLE 1	/* Disable until userland kicks in */
 
 static unsigned long wdt_is_open;
 static char expect_close;
@@ -56,12 +57,16 @@ MODULE_PARM_DESC(wdt_io, "w83697hf/hg WDT io port (default 0x2e, 0 = autodetect)
 
 static int timeout = WATCHDOG_TIMEOUT;	/* in seconds */
 module_param(timeout, int, 0);
-MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. 1<= timeout <=255, default=" __MODULE_STRING(WATCHDOG_TIMEOUT) ".");
+MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. 1<= timeout <=255 (default=" __MODULE_STRING(WATCHDOG_TIMEOUT) ")");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
+static int early_disable = WATCHDOG_EARLY_DISABLE;
+module_param(early_disable, int, 0);
+MODULE_PARM_DESC(early_disable, "Watchdog gets disabled at boot time (default=" __MODULE_STRING(WATCHDOG_EARLY_DISABLE) ")");
+
 /*
  *	Kernel methods.
  */
@@ -140,7 +145,7 @@ w83697hf_init(void)
 	w83697hf_deselect_wdt();
 }
 
-static int
+static void
 wdt_ping(void)
 {
 	spin_lock(&io_lock);
@@ -150,10 +155,9 @@ wdt_ping(void)
 
 	w83697hf_deselect_wdt();
 	spin_unlock(&io_lock);
-	return 0;
 }
 
-static int
+static void
 wdt_enable(void)
 {
 	spin_lock(&io_lock);
@@ -164,10 +168,9 @@ wdt_enable(void)
 
 	w83697hf_deselect_wdt();
 	spin_unlock(&io_lock);
-	return 0;
 }
 
-static int
+static void
 wdt_disable(void)
 {
 	spin_lock(&io_lock);
@@ -178,7 +181,22 @@ wdt_disable(void)
 
 	w83697hf_deselect_wdt();
 	spin_unlock(&io_lock);
-	return 0;
+}
+
+static unsigned char
+wdt_running(void)
+{
+	unsigned char t;
+
+	spin_lock(&io_lock);
+	w83697hf_select_wdt();
+
+	t = w83697hf_get_reg(0xF4);	/* Read timer */
+
+	w83697hf_deselect_wdt();
+	spin_unlock(&io_lock);
+
+	return t;
 }
 
 static int
@@ -397,7 +415,11 @@ wdt_init(void)
 	}
 
 	w83697hf_init();
-	wdt_disable();	/* Disable watchdog until first use */
+	if (early_disable) {
+		if (wdt_running())
+			printk (KERN_WARNING PFX "Stopping previously enabled watchdog until userland kicks in\n");
+		wdt_disable();
+	}
 
 	if (wdt_set_heartbeat(timeout)) {
 		wdt_set_heartbeat(WATCHDOG_TIMEOUT);
