Return-Path: <linux-kernel-owner+w=401wt.eu-S1752001AbZGUEgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbZGUEgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 00:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751000AbZGUEgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 00:36:18 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4949 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbZGUEf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 00:35:57 -0400
From: Joe Perches <joe@perches.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org, Mike Rapoport <mike@compulab.co.il>,
       Denis Turischev <denis@compulab.co.il>,
       Andrey Panin <pazke@centrinvest.ru>
Subject: [PATCH 2/3] drivers/watchdog: Convert printk(KERN_<level> to pr_<level>(
Date: Mon, 20 Jul 2009 21:35:01 -0700
Message-Id: <7bd6c8865b0d2104b3f7da32a4555ef8abf8c955.1248148948.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <4A6492EB.1080709@compulab.co.il>
References: <4A6492EB.1080709@compulab.co.il>
In-Reply-To: <cover.1248148947.git.joe@perches.com>
References: <cover.1248148947.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

But did not convert printk(KERN_DEBUG because
pr_debug has different compile time characteristics

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/watchdog/acquirewdt.c          |   15 +++++-----
 drivers/watchdog/advantechwdt.c        |   17 +++++------
 drivers/watchdog/alim1535_wdt.c        |   10 +++---
 drivers/watchdog/alim7101_wdt.c        |   28 +++++++++---------
 drivers/watchdog/ar7_wdt.c             |   18 ++++++------
 drivers/watchdog/at91rm9200_wdt.c      |    2 +-
 drivers/watchdog/at91sam9_wdt.c        |    6 ++--
 drivers/watchdog/bcm47xx_wdt.c         |    8 +++---
 drivers/watchdog/bfin_wdt.c            |    4 +-
 drivers/watchdog/booke_wdt.c           |   10 +++----
 drivers/watchdog/cpu5wdt.c             |   10 +++---
 drivers/watchdog/cpwd.c                |   12 ++++----
 drivers/watchdog/ep93xx_wdt.c          |    6 ++--
 drivers/watchdog/eurotechwdt.c         |   24 +++++++---------
 drivers/watchdog/gef_wdt.c             |    9 +++---
 drivers/watchdog/geodewdt.c            |    4 +-
 drivers/watchdog/hpwdt.c               |   14 +++------
 drivers/watchdog/i6300esb.c            |   20 +++++++-------
 drivers/watchdog/iTCO_vendor_support.c |    4 +-
 drivers/watchdog/iTCO_wdt.c            |   28 +++++++++---------
 drivers/watchdog/ib700wdt.c            |   14 +++++-----
 drivers/watchdog/ibmasr.c              |    8 +++---
 drivers/watchdog/indydog.c             |    8 +++---
 drivers/watchdog/iop_wdt.c             |    6 ++--
 drivers/watchdog/it8712f_wdt.c         |   18 ++++++------
 drivers/watchdog/it87_wdt.c            |   20 +++++++-------
 drivers/watchdog/ixp2000_wdt.c         |    4 +-
 drivers/watchdog/ixp4xx_wdt.c          |    6 ++--
 drivers/watchdog/ks8695_wdt.c          |    2 +-
 drivers/watchdog/machzwd.c             |   20 +++++++-------
 drivers/watchdog/mixcomwd.c            |   13 ++++-----
 drivers/watchdog/mpcore_wdt.c          |    2 +-
 drivers/watchdog/mtx-1_wdt.c           |    4 +-
 drivers/watchdog/mv64x60_wdt.c         |    9 +++---
 drivers/watchdog/omap_wdt.c            |    2 +-
 drivers/watchdog/orion_wdt.c           |    6 ++--
 drivers/watchdog/pc87413_wdt.c         |   40 ++++++++++++++--------------
 drivers/watchdog/pcwd.c                |   46 ++++++++++++++++----------------
 drivers/watchdog/pcwd_pci.c            |   42 ++++++++++++++--------------
 drivers/watchdog/pcwd_usb.c            |   42 ++++++++++++++--------------
 drivers/watchdog/pika_wdt.c            |   14 +++++-----
 drivers/watchdog/pnx4008_wdt.c         |   10 +++---
 drivers/watchdog/pnx833x_wdt.c         |   12 ++++----
 drivers/watchdog/rc32434_wdt.c         |   16 +++++-----
 drivers/watchdog/rdc321x_wdt.c         |    4 +-
 drivers/watchdog/riowd.c               |    6 ++--
 drivers/watchdog/rm9k_wdt.c            |   12 ++++----
 drivers/watchdog/s3c2410_wdt.c         |    4 +-
 drivers/watchdog/sa1100_wdt.c          |    5 +--
 drivers/watchdog/sb_wdog.c             |   15 ++++------
 drivers/watchdog/sbc60xxwdt.c          |   20 +++++++-------
 drivers/watchdog/sbc7240_wdt.c         |   22 +++++++-------
 drivers/watchdog/sbc8360.c             |   14 +++++-----
 drivers/watchdog/sbc_epx_c3.c          |    8 +++---
 drivers/watchdog/sc1200wdt.c           |   20 +++++++-------
 drivers/watchdog/sc520_wdt.c           |   18 ++++++------
 drivers/watchdog/sch311x_wdt.c         |    8 +++---
 drivers/watchdog/scx200_wdt.c          |    8 +++---
 drivers/watchdog/shwdt.c               |   16 +++++-----
 drivers/watchdog/smsc37b787_wdt.c      |   22 +++++++-------
 drivers/watchdog/softdog.c             |   14 +++++-----
 drivers/watchdog/stmp3xxx_wdt.c        |    2 +-
 drivers/watchdog/txx9wdt.c             |    4 +-
 drivers/watchdog/w83627hf_wdt.c        |   16 +++++-----
 drivers/watchdog/w83697hf_wdt.c        |   22 +++++++-------
 drivers/watchdog/w83697ug_wdt.c        |   20 +++++++-------
 drivers/watchdog/w83877f_wdt.c         |   20 +++++++-------
 drivers/watchdog/w83977f_wdt.c         |   18 ++++++------
 drivers/watchdog/wafer5823wdt.c        |   17 +++++------
 drivers/watchdog/wdrtas.c              |   26 +++++++++---------
 drivers/watchdog/wdt.c                 |   40 ++++++++++++---------------
 drivers/watchdog/wdt285.c              |    8 ++---
 drivers/watchdog/wdt977.c              |   18 ++++++------
 drivers/watchdog/wdt_pci.c             |   45 +++++++++++++++----------------
 74 files changed, 530 insertions(+), 555 deletions(-)

diff --git a/drivers/watchdog/acquirewdt.c b/drivers/watchdog/acquirewdt.c
index 4d18c87..69e7db4 100644
--- a/drivers/watchdog/acquirewdt.c
+++ b/drivers/watchdog/acquirewdt.c
@@ -208,7 +208,7 @@ static int acq_close(struct inode *inode, struct file *file)
 	if (expect_close == 42) {
 		acq_stop();
 	} else {
-		printk(KERN_CRIT PFX
+		pr_crit(PFX
 			"Unexpected close, not stopping watchdog!\n");
 		acq_keepalive();
 	}
@@ -246,7 +246,7 @@ static int __devinit acq_probe(struct platform_device *dev)
 
 	if (wdt_stop != wdt_start) {
 		if (!request_region(wdt_stop, 1, WATCHDOG_NAME)) {
-			printk(KERN_ERR PFX
+			pr_err(PFX
 			    "I/O address 0x%04x already in use\n", wdt_stop);
 			ret = -EIO;
 			goto out;
@@ -254,19 +254,19 @@ static int __devinit acq_probe(struct platform_device *dev)
 	}
 
 	if (!request_region(wdt_start, 1, WATCHDOG_NAME)) {
-		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
+		pr_err(PFX "I/O address 0x%04x already in use\n",
 			wdt_start);
 		ret = -EIO;
 		goto unreg_stop;
 	}
 	ret = misc_register(&acq_miscdev);
 	if (ret != 0) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"cannot register miscdev on minor=%d (err=%d)\n",
 							WATCHDOG_MINOR, ret);
 		goto unreg_regions;
 	}
-	printk(KERN_INFO PFX "initialized. (nowayout=%d)\n", nowayout);
+	pr_info(PFX "initialized. (nowayout=%d)\n", nowayout);
 
 	return 0;
 unreg_regions:
@@ -308,8 +308,7 @@ static int __init acq_init(void)
 {
 	int err;
 
-	printk(KERN_INFO
-	      "WDT driver for Acquire single board computer initialising.\n");
+	pr_info("WDT driver for Acquire single board computer initialising.\n");
 
 	err = platform_driver_register(&acquirewdt_driver);
 	if (err)
@@ -332,7 +331,7 @@ static void __exit acq_exit(void)
 {
 	platform_device_unregister(acq_platform_device);
 	platform_driver_unregister(&acquirewdt_driver);
-	printk(KERN_INFO PFX "Watchdog Module Unloaded.\n");
+	pr_info(PFX "Watchdog Module Unloaded.\n");
 }
 
 module_init(acq_init);
diff --git a/drivers/watchdog/advantechwdt.c b/drivers/watchdog/advantechwdt.c
index 824d076..7b2c6e6 100644
--- a/drivers/watchdog/advantechwdt.c
+++ b/drivers/watchdog/advantechwdt.c
@@ -207,7 +207,7 @@ static int advwdt_close(struct inode *inode, struct file *file)
 	if (adv_expect_close == 42) {
 		advwdt_disable();
 	} else {
-		printk(KERN_CRIT PFX
+		pr_crit(PFX
 				"Unexpected close, not stopping watchdog!\n");
 		advwdt_ping();
 	}
@@ -245,7 +245,7 @@ static int __devinit advwdt_probe(struct platform_device *dev)
 
 	if (wdt_stop != wdt_start) {
 		if (!request_region(wdt_stop, 1, WATCHDOG_NAME)) {
-			printk(KERN_ERR PFX
+			pr_err(PFX
 				"I/O address 0x%04x already in use\n",
 								wdt_stop);
 			ret = -EIO;
@@ -254,7 +254,7 @@ static int __devinit advwdt_probe(struct platform_device *dev)
 	}
 
 	if (!request_region(wdt_start, 1, WATCHDOG_NAME)) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 				"I/O address 0x%04x already in use\n",
 								wdt_start);
 		ret = -EIO;
@@ -265,18 +265,18 @@ static int __devinit advwdt_probe(struct platform_device *dev)
 	 * if not reset to the default */
 	if (advwdt_set_heartbeat(timeout)) {
 		advwdt_set_heartbeat(WATCHDOG_TIMEOUT);
-		printk(KERN_INFO PFX
+		pr_info(PFX
 			"timeout value must be 1<=x<=63, using %d\n", timeout);
 	}
 
 	ret = misc_register(&advwdt_miscdev);
 	if (ret != 0) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"cannot register miscdev on minor=%d (err=%d)\n",
 							WATCHDOG_MINOR, ret);
 		goto unreg_regions;
 	}
-	printk(KERN_INFO PFX "initialized. timeout=%d sec (nowayout=%d)\n",
+	pr_info(PFX "initialized. timeout=%d sec (nowayout=%d)\n",
 		timeout, nowayout);
 out:
 	return ret;
@@ -318,8 +318,7 @@ static int __init advwdt_init(void)
 {
 	int err;
 
-	printk(KERN_INFO
-	     "WDT driver for Advantech single board computer initialising.\n");
+	pr_info("WDT driver for Advantech single board computer initialising.\n");
 
 	err = platform_driver_register(&advwdt_driver);
 	if (err)
@@ -343,7 +342,7 @@ static void __exit advwdt_exit(void)
 {
 	platform_device_unregister(advwdt_platform_device);
 	platform_driver_unregister(&advwdt_driver);
-	printk(KERN_INFO PFX "Watchdog Module Unloaded.\n");
+	pr_info(PFX "Watchdog Module Unloaded.\n");
 }
 
 module_init(advwdt_init);
diff --git a/drivers/watchdog/alim1535_wdt.c b/drivers/watchdog/alim1535_wdt.c
index 937a80f..2d68918 100644
--- a/drivers/watchdog/alim1535_wdt.c
+++ b/drivers/watchdog/alim1535_wdt.c
@@ -268,7 +268,7 @@ static int ali_release(struct inode *inode, struct file *file)
 	if (ali_expect_release == 42)
 		ali_stop();
 	else {
-		printk(KERN_CRIT PFX
+		pr_crit(PFX
 				"Unexpected close, not stopping watchdog!\n");
 		ali_keepalive();
 	}
@@ -399,7 +399,7 @@ static int __init watchdog_init(void)
 	   if not reset to the default */
 	if (timeout < 1 || timeout >= 18000) {
 		timeout = WATCHDOG_TIMEOUT;
-		printk(KERN_INFO PFX
+		pr_info(PFX
 		     "timeout value must be 0 < timeout < 18000, using %d\n",
 							timeout);
 	}
@@ -409,20 +409,20 @@ static int __init watchdog_init(void)
 
 	ret = register_reboot_notifier(&ali_notifier);
 	if (ret != 0) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"cannot register reboot notifier (err=%d)\n", ret);
 		goto out;
 	}
 
 	ret = misc_register(&ali_miscdev);
 	if (ret != 0) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"cannot register miscdev on minor=%d (err=%d)\n",
 						WATCHDOG_MINOR, ret);
 		goto unreg_reboot;
 	}
 
-	printk(KERN_INFO PFX "initialized. timeout=%d sec (nowayout=%d)\n",
+	pr_info(PFX "initialized. timeout=%d sec (nowayout=%d)\n",
 		timeout, nowayout);
 
 out:
diff --git a/drivers/watchdog/alim7101_wdt.c b/drivers/watchdog/alim7101_wdt.c
index f90afdb..f2b9548 100644
--- a/drivers/watchdog/alim7101_wdt.c
+++ b/drivers/watchdog/alim7101_wdt.c
@@ -112,7 +112,7 @@ static void wdt_timer_ping(unsigned long data)
 					ALI_7101_GPIO_O, tmp & ~0x20);
 		}
 	} else {
-		printk(KERN_WARNING PFX
+		pr_warning(PFX
 			"Heartbeat lost! Will not ping the watchdog\n");
 	}
 	/* Re-set the timer interval */
@@ -162,7 +162,7 @@ static void wdt_startup(void)
 	/* Start the timer */
 	mod_timer(&timer, jiffies + WDT_INTERVAL);
 
-	printk(KERN_INFO PFX "Watchdog timer is now enabled.\n");
+	pr_info(PFX "Watchdog timer is now enabled.\n");
 }
 
 static void wdt_turnoff(void)
@@ -170,7 +170,7 @@ static void wdt_turnoff(void)
 	/* Stop the timer */
 	del_timer_sync(&timer);
 	wdt_change(WDT_DISABLE);
-	printk(KERN_INFO PFX "Watchdog timer is now disabled...\n");
+	pr_info(PFX "Watchdog timer is now disabled...\n");
 }
 
 static void wdt_keepalive(void)
@@ -226,7 +226,7 @@ static int fop_close(struct inode *inode, struct file *file)
 		wdt_turnoff();
 	else {
 		/* wim: shouldn't there be a: del_timer(&timer); */
-		printk(KERN_CRIT PFX
+		pr_crit(PFX
 		  "device file closed unexpectedly. Will not stop the WDT!\n");
 	}
 	clear_bit(0, &wdt_is_open);
@@ -322,7 +322,7 @@ static int wdt_notify_sys(struct notifier_block *this,
 		 * watchdog on reboot with no heartbeat
 		 */
 		wdt_change(WDT_ENABLE);
-		printk(KERN_INFO PFX "Watchdog timer is now enabled "
+		pr_info(PFX "Watchdog timer is now enabled "
 			"with no heartbeat - should reboot in ~1 second.\n");
 	}
 	return NOTIFY_DONE;
@@ -352,11 +352,11 @@ static int __init alim7101_wdt_init(void)
 	struct pci_dev *ali1543_south;
 	char tmp;
 
-	printk(KERN_INFO PFX "Steve Hill <steve@navaho.co.uk>.\n");
+	pr_info(PFX "Steve Hill <steve@navaho.co.uk>.\n");
 	alim7101_pmu = pci_get_device(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M7101,
 		NULL);
 	if (!alim7101_pmu) {
-		printk(KERN_INFO PFX
+		pr_info(PFX
 			"ALi M7101 PMU not present - WDT not set\n");
 		return -EBUSY;
 	}
@@ -367,7 +367,7 @@ static int __init alim7101_wdt_init(void)
 	ali1543_south = pci_get_device(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M1533,
 		NULL);
 	if (!ali1543_south) {
-		printk(KERN_INFO PFX
+		pr_info(PFX
 			"ALi 1543 South-Bridge not present - WDT not set\n");
 		goto err_out;
 	}
@@ -375,7 +375,7 @@ static int __init alim7101_wdt_init(void)
 	pci_dev_put(ali1543_south);
 	if ((tmp & 0x1e) == 0x00) {
 		if (!use_gpio) {
-			printk(KERN_INFO PFX
+			pr_info(PFX
 				"Detected old alim7101 revision 'a1d'.  "
 				"If this is a cobalt board, set the 'use_gpio' "
 				"module parameter.\n");
@@ -383,7 +383,7 @@ static int __init alim7101_wdt_init(void)
 		}
 		nowayout = 1;
 	} else if ((tmp & 0x1e) != 0x12 && (tmp & 0x1e) != 0x00) {
-		printk(KERN_INFO PFX
+		pr_info(PFX
 			"ALi 1543 South-Bridge does not have the correct "
 			"revision number (???1001?) - WDT not set\n");
 		goto err_out;
@@ -392,21 +392,21 @@ static int __init alim7101_wdt_init(void)
 	if (timeout < 1 || timeout > 3600) {
 		/* arbitrary upper limit */
 		timeout = WATCHDOG_TIMEOUT;
-		printk(KERN_INFO PFX
+		pr_info(PFX
 			"timeout value must be 1 <= x <= 3600, using %d\n",
 								timeout);
 	}
 
 	rc = register_reboot_notifier(&wdt_notifier);
 	if (rc) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"cannot register reboot notifier (err=%d)\n", rc);
 		goto err_out;
 	}
 
 	rc = misc_register(&wdt_miscdev);
 	if (rc) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"cannot register miscdev on minor=%d (err=%d)\n",
 			wdt_miscdev.minor, rc);
 		goto err_out_reboot;
@@ -415,7 +415,7 @@ static int __init alim7101_wdt_init(void)
 	if (nowayout)
 		__module_get(THIS_MODULE);
 
-	printk(KERN_INFO PFX "WDT driver for ALi M7101 initialised. "
+	pr_info(PFX "WDT driver for ALi M7101 initialised. "
 					"timeout=%d sec (nowayout=%d)\n",
 		timeout, nowayout);
 	return 0;
diff --git a/drivers/watchdog/ar7_wdt.c b/drivers/watchdog/ar7_wdt.c
index 3fe9742..9a1390c 100644
--- a/drivers/watchdog/ar7_wdt.c
+++ b/drivers/watchdog/ar7_wdt.c
@@ -105,7 +105,7 @@ static void ar7_wdt_kick(u32 value)
 			return;
 		}
 	}
-	printk(KERN_ERR DRVNAME ": failed to unlock WDT kick reg\n");
+	pr_err(DRVNAME ": failed to unlock WDT kick reg\n");
 }
 
 static void ar7_wdt_prescale(u32 value)
@@ -118,7 +118,7 @@ static void ar7_wdt_prescale(u32 value)
 			return;
 		}
 	}
-	printk(KERN_ERR DRVNAME ": failed to unlock WDT prescale reg\n");
+	pr_err(DRVNAME ": failed to unlock WDT prescale reg\n");
 }
 
 static void ar7_wdt_change(u32 value)
@@ -131,7 +131,7 @@ static void ar7_wdt_change(u32 value)
 			return;
 		}
 	}
-	printk(KERN_ERR DRVNAME ": failed to unlock WDT change reg\n");
+	pr_err(DRVNAME ": failed to unlock WDT change reg\n");
 }
 
 static void ar7_wdt_disable(u32 value)
@@ -147,7 +147,7 @@ static void ar7_wdt_disable(u32 value)
 			}
 		}
 	}
-	printk(KERN_ERR DRVNAME ": failed to unlock WDT disable reg\n");
+	pr_err(DRVNAME ": failed to unlock WDT disable reg\n");
 }
 
 static void ar7_wdt_update_margin(int new_margin)
@@ -161,7 +161,7 @@ static void ar7_wdt_update_margin(int new_margin)
 		change = 0xffff;
 	ar7_wdt_change(change);
 	margin = change * prescale_value / ar7_vbus_freq();
-	printk(KERN_INFO DRVNAME
+	pr_info(DRVNAME
 	       ": timer margin %d seconds (prescale %d, change %d, freq %d)\n",
 	       margin, prescale_value, change, ar7_vbus_freq());
 }
@@ -193,7 +193,7 @@ static int ar7_wdt_open(struct inode *inode, struct file *file)
 static int ar7_wdt_release(struct inode *inode, struct file *file)
 {
 	if (!expect_close)
-		printk(KERN_WARNING DRVNAME
+		pr_warning(DRVNAME
 		": watchdog device closed unexpectedly,"
 		"will not disable the watchdog timer\n");
 	else if (!nowayout)
@@ -309,7 +309,7 @@ static int __init ar7_wdt_init(void)
 
 	if (!request_mem_region(ar7_regs_wdt, sizeof(struct ar7_wdt),
 							LONGNAME)) {
-		printk(KERN_WARNING DRVNAME ": watchdog I/O region busy\n");
+		pr_warning(DRVNAME ": watchdog I/O region busy\n");
 		return -EBUSY;
 	}
 
@@ -322,14 +322,14 @@ static int __init ar7_wdt_init(void)
 
 	rc = register_reboot_notifier(&ar7_wdt_notifier);
 	if (rc) {
-		printk(KERN_ERR DRVNAME
+		pr_err(DRVNAME
 			": unable to register reboot notifier\n");
 		goto out_alloc;
 	}
 
 	rc = misc_register(&ar7_wdt_miscdev);
 	if (rc) {
-		printk(KERN_ERR DRVNAME ": unable to register misc device\n");
+		pr_err(DRVNAME ": unable to register misc device\n");
 		goto out_register;
 	}
 	goto out;
diff --git a/drivers/watchdog/at91rm9200_wdt.c b/drivers/watchdog/at91rm9200_wdt.c
index b185daf..27981eb 100644
--- a/drivers/watchdog/at91rm9200_wdt.c
+++ b/drivers/watchdog/at91rm9200_wdt.c
@@ -209,7 +209,7 @@ static int __devinit at91wdt_probe(struct platform_device *pdev)
 	if (res)
 		return res;
 
-	printk(KERN_INFO "AT91 Watchdog Timer enabled (%d seconds%s)\n",
+	pr_info("AT91 Watchdog Timer enabled (%d seconds%s)\n",
 				wdt_time, nowayout ? ", nowayout" : "");
 	return 0;
 }
diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
index eac2602..3baaf1e 100644
--- a/drivers/watchdog/at91sam9_wdt.c
+++ b/drivers/watchdog/at91sam9_wdt.c
@@ -90,7 +90,7 @@ static void at91_ping(unsigned long data)
 		at91_wdt_reset();
 		mod_timer(&at91wdt_private.timer, jiffies + WDT_TIMEOUT);
 	} else
-		printk(KERN_CRIT DRV_NAME": I will reset your machine !\n");
+		pr_crit(DRV_NAME": I will reset your machine !\n");
 }
 
 /*
@@ -134,7 +134,7 @@ static int at91_wdt_settimeout(unsigned int timeout)
 	/* Check if disabled */
 	mr = at91_sys_read(AT91_WDT_MR);
 	if (mr & AT91_WDT_WDDIS) {
-		printk(KERN_ERR DRV_NAME": sorry, watchdog is disabled\n");
+		pr_err(DRV_NAME": sorry, watchdog is disabled\n");
 		return -EIO;
 	}
 
@@ -267,7 +267,7 @@ static int __init at91wdt_probe(struct platform_device *pdev)
 	setup_timer(&at91wdt_private.timer, at91_ping, 0);
 	mod_timer(&at91wdt_private.timer, jiffies + WDT_TIMEOUT);
 
-	printk(KERN_INFO DRV_NAME " enabled (heartbeat=%d sec, nowayout=%d)\n",
+	pr_info(DRV_NAME " enabled (heartbeat=%d sec, nowayout=%d)\n",
 		heartbeat, nowayout);
 
 	return 0;
diff --git a/drivers/watchdog/bcm47xx_wdt.c b/drivers/watchdog/bcm47xx_wdt.c
index 751c003..eddb117 100644
--- a/drivers/watchdog/bcm47xx_wdt.c
+++ b/drivers/watchdog/bcm47xx_wdt.c
@@ -68,7 +68,7 @@ static void bcm47xx_timer_tick(unsigned long unused)
 		bcm47xx_wdt_hw_start();
 		mod_timer(&wdt_timer, jiffies + HZ);
 	} else {
-		printk(KERN_CRIT DRV_NAME "Watchdog will fire soon!!!\n");
+		pr_crit(DRV_NAME "Watchdog will fire soon!!!\n");
 	}
 }
 
@@ -117,7 +117,7 @@ static int bcm47xx_wdt_release(struct inode *inode, struct file *file)
 	if (expect_release == 42) {
 		bcm47xx_wdt_stop();
 	} else {
-		printk(KERN_CRIT DRV_NAME
+		pr_crit(DRV_NAME
 			": Unexpected close, not stopping watchdog!\n");
 		bcm47xx_wdt_start();
 	}
@@ -247,7 +247,7 @@ static int __init bcm47xx_wdt_init(void)
 
 	if (bcm47xx_wdt_settimeout(wdt_time)) {
 		bcm47xx_wdt_settimeout(WDT_DEFAULT_TIME);
-		printk(KERN_INFO DRV_NAME ": "
+		pr_info(DRV_NAME ": "
 			"wdt_time value must be 0 < wdt_time < %d, using %d\n",
 			(WDT_MAX_TIME + 1), wdt_time);
 	}
@@ -262,7 +262,7 @@ static int __init bcm47xx_wdt_init(void)
 		return ret;
 	}
 
-	printk(KERN_INFO "BCM47xx Watchdog Timer enabled (%d seconds%s)\n",
+	pr_info("BCM47xx Watchdog Timer enabled (%d seconds%s)\n",
 				wdt_time, nowayout ? ", nowayout" : "");
 	return 0;
 }
diff --git a/drivers/watchdog/bfin_wdt.c b/drivers/watchdog/bfin_wdt.c
index c7b3f9d..298d06b 100644
--- a/drivers/watchdog/bfin_wdt.c
+++ b/drivers/watchdog/bfin_wdt.c
@@ -144,7 +144,7 @@ static int bfin_wdt_set_timeout(unsigned long t)
 
 	cnt = t * get_sclk();
 	if (cnt < get_sclk()) {
-		printk(KERN_WARNING PFX "timeout value is too large\n");
+		pr_warning(PFX "timeout value is too large\n");
 		return -EINVAL;
 	}
 
@@ -200,7 +200,7 @@ static int bfin_wdt_release(struct inode *inode, struct file *file)
 	if (expect_close == 42)
 		bfin_wdt_stop();
 	else {
-		printk(KERN_CRIT PFX
+		pr_crit(PFX
 			"Unexpected close, not stopping watchdog!\n");
 		bfin_wdt_keepalive();
 	}
diff --git a/drivers/watchdog/booke_wdt.c b/drivers/watchdog/booke_wdt.c
index 225398f..e423c96 100644
--- a/drivers/watchdog/booke_wdt.c
+++ b/drivers/watchdog/booke_wdt.c
@@ -135,8 +135,7 @@ static int booke_wdt_open(struct inode *inode, struct file *file)
 	if (booke_wdt_enabled == 0) {
 		booke_wdt_enabled = 1;
 		on_each_cpu(__booke_wdt_enable, NULL, 0);
-		printk(KERN_INFO
-		      "PowerPC Book-E Watchdog Timer Enabled (wdt_period=%d)\n",
+		pr_info("PowerPC Book-E Watchdog Timer Enabled (wdt_period=%d)\n",
 				booke_wdt_period);
 	}
 	spin_unlock(&booke_wdt_lock);
@@ -167,20 +166,19 @@ static int __init booke_wdt_init(void)
 {
 	int ret = 0;
 
-	printk(KERN_INFO "PowerPC Book-E Watchdog Timer Loaded\n");
+	pr_info("PowerPC Book-E Watchdog Timer Loaded\n");
 	ident.firmware_version = cur_cpu_spec->pvr_value;
 
 	ret = misc_register(&booke_wdt_miscdev);
 	if (ret) {
-		printk(KERN_CRIT "Cannot register miscdev on minor=%d: %d\n",
+		pr_crit("Cannot register miscdev on minor=%d: %d\n",
 				WATCHDOG_MINOR, ret);
 		return ret;
 	}
 
 	spin_lock(&booke_wdt_lock);
 	if (booke_wdt_enabled == 1) {
-		printk(KERN_INFO
-		      "PowerPC Book-E Watchdog Timer Enabled (wdt_period=%d)\n",
+		pr_info("PowerPC Book-E Watchdog Timer Enabled (wdt_period=%d)\n",
 				booke_wdt_period);
 		on_each_cpu(__booke_wdt_enable, NULL, 0);
 	}
diff --git a/drivers/watchdog/cpu5wdt.c b/drivers/watchdog/cpu5wdt.c
index 71f6d7e..ff3647e 100644
--- a/drivers/watchdog/cpu5wdt.c
+++ b/drivers/watchdog/cpu5wdt.c
@@ -129,7 +129,7 @@ static int cpu5wdt_stop(void)
 	ticks = cpu5wdt_device.default_ticks;
 	spin_unlock_irqrestore(&cpu5wdt_lock, flags);
 	if (verbose)
-		printk(KERN_CRIT PFX "stop not possible\n");
+		pr_crit(PFX "stop not possible\n");
 	return -EIO;
 }
 
@@ -229,7 +229,7 @@ static int __devinit cpu5wdt_init(void)
 	cpu5wdt_device.default_ticks = ticks;
 
 	if (!request_region(port, CPU5WDT_EXTENT, PFX)) {
-		printk(KERN_ERR PFX "request_region failed\n");
+		pr_err(PFX "request_region failed\n");
 		err = -EBUSY;
 		goto no_port;
 	}
@@ -238,16 +238,16 @@ static int __devinit cpu5wdt_init(void)
 	val = inb(port + CPU5WDT_STATUS_REG);
 	val = (val >> 2) & 1;
 	if (!val)
-		printk(KERN_INFO PFX "sorry, was my fault\n");
+		pr_info(PFX "sorry, was my fault\n");
 
 	err = misc_register(&cpu5wdt_misc);
 	if (err < 0) {
-		printk(KERN_ERR PFX "misc_register failed\n");
+		pr_err(PFX "misc_register failed\n");
 		goto no_misc;
 	}
 
 
-	printk(KERN_INFO PFX "init success\n");
+	pr_info(PFX "init success\n");
 	return 0;
 
 no_misc:
diff --git a/drivers/watchdog/cpwd.c b/drivers/watchdog/cpwd.c
index 081f295..5dc9ba8 100644
--- a/drivers/watchdog/cpwd.c
+++ b/drivers/watchdog/cpwd.c
@@ -383,7 +383,7 @@ static int cpwd_open(struct inode *inode, struct file *f)
 	if (!p->initialized) {
 		if (request_irq(p->irq, &cpwd_interrupt,
 				IRQF_SHARED, DRIVER_NAME, p)) {
-			printk(KERN_ERR PFX "Cannot register IRQ %d\n",
+			pr_err(PFX "Cannot register IRQ %d\n",
 				p->irq);
 			unlock_kernel();
 			return -EBUSY;
@@ -540,7 +540,7 @@ static int __devinit cpwd_probe(struct of_device *op,
 	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	err = -ENOMEM;
 	if (!p) {
-		printk(KERN_ERR PFX "Unable to allocate struct cpwd.\n");
+		pr_err(PFX "Unable to allocate struct cpwd.\n");
 		goto out;
 	}
 
@@ -551,14 +551,14 @@ static int __devinit cpwd_probe(struct of_device *op,
 	p->regs = of_ioremap(&op->resource[0], 0,
 			     4 * WD_TIMER_REGSZ, DRIVER_NAME);
 	if (!p->regs) {
-		printk(KERN_ERR PFX "Unable to map registers.\n");
+		pr_err(PFX "Unable to map registers.\n");
 		goto out_free;
 	}
 
 	options = of_find_node_by_path("/options");
 	err = -ENODEV;
 	if (!options) {
-		printk(KERN_ERR PFX "Unable to find /options node.\n");
+		pr_err(PFX "Unable to find /options node.\n");
 		goto out_iounmap;
 	}
 
@@ -603,7 +603,7 @@ static int __devinit cpwd_probe(struct of_device *op,
 
 		err = misc_register(&p->devs[i].misc);
 		if (err) {
-			printk(KERN_ERR "Could not register misc device for "
+			pr_err("Could not register misc device for "
 			       "dev %d\n", i);
 			goto out_unregister;
 		}
@@ -615,7 +615,7 @@ static int __devinit cpwd_probe(struct of_device *op,
 		cpwd_timer.data		= (unsigned long) p;
 		cpwd_timer.expires	= WD_BTIMEOUT;
 
-		printk(KERN_INFO PFX "PLD defect workaround enabled for "
+		pr_info(PFX "PLD defect workaround enabled for "
 		       "model " WD_BADMODEL ".\n");
 	}
 
diff --git a/drivers/watchdog/ep93xx_wdt.c b/drivers/watchdog/ep93xx_wdt.c
index cdd55e0..f1a9b04 100644
--- a/drivers/watchdog/ep93xx_wdt.c
+++ b/drivers/watchdog/ep93xx_wdt.c
@@ -173,7 +173,7 @@ static int ep93xx_wdt_release(struct inode *inode, struct file *file)
 	if (test_bit(WDT_OK_TO_CLOSE, &wdt_status))
 		wdt_shutdown();
 	else
-		printk(KERN_CRIT PFX
+		pr_crit(PFX
 			"Device closed unexpectedly - timer will not stop\n");
 
 	clear_bit(WDT_IN_USE, &wdt_status);
@@ -213,14 +213,14 @@ static int __init ep93xx_wdt_init(void)
 
 	boot_status = __raw_readl(EP93XX_WDT_WATCHDOG) & 0x01 ? 1 : 0;
 
-	printk(KERN_INFO PFX "EP93XX watchdog, driver version "
+	pr_info(PFX "EP93XX watchdog, driver version "
 		WDT_VERSION "%s\n",
 		(__raw_readl(EP93XX_WDT_WATCHDOG) & 0x08)
 		? " (nCS1 disable detected)" : "");
 
 	if (timeout < 1 || timeout > 3600) {
 		timeout = WDT_TIMEOUT;
-		printk(KERN_INFO PFX
+		pr_info(PFX
 			"timeout value must be 1<=x<=3600, using %d\n",
 			timeout);
 	}
diff --git a/drivers/watchdog/eurotechwdt.c b/drivers/watchdog/eurotechwdt.c
index 9add354..bcffe6c 100644
--- a/drivers/watchdog/eurotechwdt.c
+++ b/drivers/watchdog/eurotechwdt.c
@@ -145,11 +145,11 @@ static void eurwdt_activate_timer(void)
 
 	/* Setting interrupt line */
 	if (irq == 2 || irq > 15 || irq < 0) {
-		printk(KERN_ERR ": invalid irq number\n");
+		pr_err(": invalid irq number\n");
 		irq = 0;	/* if invalid we disable interrupt */
 	}
 	if (irq == 0)
-		printk(KERN_INFO ": interrupt disabled\n");
+		pr_info(": interrupt disabled\n");
 
 	eurwdt_write_reg(WDT_TIMER_CFG, irq << 4);
 
@@ -164,12 +164,12 @@ static void eurwdt_activate_timer(void)
 
 static irqreturn_t eurwdt_interrupt(int irq, void *dev_id)
 {
-	printk(KERN_CRIT "timeout WDT timeout\n");
+	pr_crit("timeout WDT timeout\n");
 
 #ifdef ONLY_TESTING
-	printk(KERN_CRIT "Would Reboot.\n");
+	pr_crit("Would Reboot.\n");
 #else
-	printk(KERN_CRIT "Initiating system reboot.\n");
+	pr_crit("Initiating system reboot.\n");
 	emergency_restart();
 #endif
 	return IRQ_HANDLED;
@@ -336,8 +336,7 @@ static int eurwdt_release(struct inode *inode, struct file *file)
 	if (eur_expect_close == 42)
 		eurwdt_disable_timer();
 	else {
-		printk(KERN_CRIT
-			"eurwdt: Unexpected close, not stopping watchdog!\n");
+		pr_crit("eurwdt: Unexpected close, not stopping watchdog!\n");
 		eurwdt_ping();
 	}
 	clear_bit(0, &eurwdt_is_open);
@@ -430,20 +429,19 @@ static int __init eurwdt_init(void)
 
 	ret = request_irq(irq, eurwdt_interrupt, IRQF_DISABLED, "eurwdt", NULL);
 	if (ret) {
-		printk(KERN_ERR "eurwdt: IRQ %d is not free.\n", irq);
+		pr_err("eurwdt: IRQ %d is not free.\n", irq);
 		goto out;
 	}
 
 	if (!request_region(io, 2, "eurwdt")) {
-		printk(KERN_ERR "eurwdt: IO %X is not free.\n", io);
+		pr_err("eurwdt: IO %X is not free.\n", io);
 		ret = -EBUSY;
 		goto outirq;
 	}
 
 	ret = register_reboot_notifier(&eurwdt_notifier);
 	if (ret) {
-		printk(KERN_ERR
-		    "eurwdt: can't register reboot notifier (err=%d)\n", ret);
+		pr_err("eurwdt: can't register reboot notifier (err=%d)\n", ret);
 		goto outreg;
 	}
 
@@ -451,7 +449,7 @@ static int __init eurwdt_init(void)
 
 	ret = misc_register(&eurwdt_miscdev);
 	if (ret) {
-		printk(KERN_ERR "eurwdt: can't misc_register on minor=%d\n",
+		pr_err("eurwdt: can't misc_register on minor=%d\n",
 		WATCHDOG_MINOR);
 		goto outreboot;
 	}
@@ -459,7 +457,7 @@ static int __init eurwdt_init(void)
 	eurwdt_unlock_chip();
 
 	ret = 0;
-	printk(KERN_INFO "Eurotech WDT driver 0.01 at %X (Interrupt %d)"
+	pr_info("Eurotech WDT driver 0.01 at %X (Interrupt %d)"
 		" - timeout event: %s\n",
 		io, irq, (!strcmp("int", ev) ? "int" : "reboot"));
 
diff --git a/drivers/watchdog/gef_wdt.c b/drivers/watchdog/gef_wdt.c
index 734d980..b1ce0df 100644
--- a/drivers/watchdog/gef_wdt.c
+++ b/drivers/watchdog/gef_wdt.c
@@ -109,7 +109,7 @@ static void gef_wdt_handler_enable(void)
 	if (gef_wdt_toggle_wdc(GEF_WDC_ENABLED_FALSE,
 				   GEF_WDC_ENABLE_SHIFT)) {
 		gef_wdt_service();
-		printk(KERN_NOTICE "gef_wdt: watchdog activated\n");
+		pr_notice("gef_wdt: watchdog activated\n");
 	}
 }
 
@@ -117,7 +117,7 @@ static void gef_wdt_handler_disable(void)
 {
 	if (gef_wdt_toggle_wdc(GEF_WDC_ENABLED_TRUE,
 				   GEF_WDC_ENABLE_SHIFT))
-		printk(KERN_NOTICE "gef_wdt: watchdog deactivated\n");
+		pr_notice("gef_wdt: watchdog deactivated\n");
 }
 
 static void gef_wdt_set_timeout(unsigned int timeout)
@@ -233,8 +233,7 @@ static int gef_wdt_release(struct inode *inode, struct file *file)
 	if (expect_close == 42)
 		gef_wdt_handler_disable();
 	else {
-		printk(KERN_CRIT
-		       "gef_wdt: unexpected close, not stopping timer!\n");
+		pr_crit("gef_wdt: unexpected close, not stopping timer!\n");
 		gef_wdt_service();
 	}
 	expect_close = 0;
@@ -311,7 +310,7 @@ static struct of_platform_driver gef_wdt_driver = {
 
 static int __init gef_wdt_init(void)
 {
-	printk(KERN_INFO "GE Fanuc watchdog driver\n");
+	pr_info("GE Fanuc watchdog driver\n");
 	return of_register_platform_driver(&gef_wdt_driver);
 }
 
diff --git a/drivers/watchdog/geodewdt.c b/drivers/watchdog/geodewdt.c
index 9acf001..b1ebb9e 100644
--- a/drivers/watchdog/geodewdt.c
+++ b/drivers/watchdog/geodewdt.c
@@ -99,7 +99,7 @@ static int geodewdt_release(struct inode *inode, struct file *file)
 		geodewdt_disable();
 		module_put(THIS_MODULE);
 	} else {
-		printk(KERN_CRIT "Unexpected close - watchdog is not stopping.\n");
+		pr_crit("Unexpected close - watchdog is not stopping.\n");
 		geodewdt_ping();
 
 		set_bit(WDT_FLAGS_ORPHAN, &wdt_flags);
@@ -220,7 +220,7 @@ static int __devinit geodewdt_probe(struct platform_device *dev)
 	timer = geode_mfgpt_alloc_timer(MFGPT_TIMER_ANY, MFGPT_DOMAIN_WORKING);
 
 	if (timer == -1) {
-		printk(KERN_ERR "geodewdt:  No timers were available\n");
+		pr_err("geodewdt:  No timers were available\n");
 		return -ENODEV;
 	}
 
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index a6c5674..82fac35 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -223,8 +223,7 @@ static int __devinit cru_detect(unsigned long map_entry,
 	asminline_call(&cmn_regs, bios32_entrypoint);
 
 	if (cmn_regs.u1.ral != 0) {
-		printk(KERN_WARNING
-			"hpwdt: Call succeeded but with an error: 0x%x\n",
+		pr_warning("hpwdt: Call succeeded but with an error: 0x%x\n",
 			cmn_regs.u1.ral);
 	} else {
 		physical_bios_base = cmn_regs.u2.rebx;
@@ -444,8 +443,7 @@ static int hpwdt_change_timer(int new_margin)
 {
 	/* Arbitrary, can't find the card's limits */
 	if (new_margin < 30 || new_margin > 600) {
-		printk(KERN_WARNING
-			"hpwdt: New value passed in is invalid: %d seconds.\n",
+		pr_warning("hpwdt: New value passed in is invalid: %d seconds.\n",
 			new_margin);
 		return -EINVAL;
 	}
@@ -478,7 +476,7 @@ static int hpwdt_pretimeout(struct notifier_block *nb, unsigned long ulReason,
 		die_nmi_called = 1;
 		spin_unlock_irqrestore(&rom_lock, rom_pl);
 		if (cmn_regs.u1.ral == 0) {
-			printk(KERN_WARNING "hpwdt: An NMI occurred, "
+			pr_warning("hpwdt: An NMI occurred, "
 				"but unable to determine source.\n");
 		} else {
 			if (allow_kdump)
@@ -512,8 +510,7 @@ static int hpwdt_release(struct inode *inode, struct file *file)
 	if (expect_release == 42) {
 		hpwdt_stop();
 	} else {
-		printk(KERN_CRIT
-			"hpwdt: Unexpected close, not stopping watchdog!\n");
+		pr_crit("hpwdt: Unexpected close, not stopping watchdog!\n");
 		hpwdt_ping();
 	}
 
@@ -740,8 +737,7 @@ static int __devinit hpwdt_init_one(struct pci_dev *dev,
 		goto error_misc_register;
 	}
 
-	printk(KERN_INFO
-		"hp Watchdog Timer Driver: %s"
+	pr_info("hp Watchdog Timer Driver: %s"
 		", timer margin: %d seconds (nowayout=%d)"
 		", allow kernel dump: %s (default = 0/OFF)"
 		", priority: %s (default = 0/LAST).\n",
diff --git a/drivers/watchdog/i6300esb.c b/drivers/watchdog/i6300esb.c
index 7ba0b11..26d6535 100644
--- a/drivers/watchdog/i6300esb.c
+++ b/drivers/watchdog/i6300esb.c
@@ -212,7 +212,7 @@ static int esb_release(struct inode *inode, struct file *file)
 	if (esb_expect_close == 42)
 		esb_timer_stop();
 	else {
-		printk(KERN_CRIT PFX
+		pr_crit(PFX
 				"Unexpected close, not stopping watchdog!\n");
 		esb_timer_keepalive();
 	}
@@ -361,19 +361,19 @@ static unsigned char __devinit esb_getdevice(void)
 		return 0;
 
 	if (pci_enable_device(esb_pci)) {
-		printk(KERN_ERR PFX "failed to enable device\n");
+		pr_err(PFX "failed to enable device\n");
 		goto err_devput;
 	}
 
 	if (pci_request_region(esb_pci, 0, ESB_MODULE_NAME)) {
-		printk(KERN_ERR PFX "failed to request region\n");
+		pr_err(PFX "failed to request region\n");
 		goto err_disable;
 	}
 
 	BASEADDR = pci_ioremap_bar(esb_pci, 0);
 	if (BASEADDR == NULL) {
 		/* Something's wrong here, BASEADDR has to be set */
-		printk(KERN_ERR PFX "failed to get BASEADDR\n");
+		pr_err(PFX "failed to get BASEADDR\n");
 		goto err_release;
 	}
 
@@ -411,7 +411,7 @@ static void __devinit esb_initdevice(void)
 	/* Check that the WDT isn't already locked */
 	pci_read_config_byte(esb_pci, ESB_LOCK_REG, &val1);
 	if (val1 & ESB_WDT_LOCK)
-		printk(KERN_WARNING PFX "nowayout already set\n");
+		pr_warning(PFX "nowayout already set\n");
 
 	/* Set the timer to watchdog mode and disable it for now */
 	pci_write_config_byte(esb_pci, ESB_LOCK_REG, 0x00);
@@ -442,7 +442,7 @@ static int __devinit esb_probe(struct platform_device *dev)
 	   if not reset to the default */
 	if (heartbeat < 0x1 || heartbeat > 2 * 0x03ff) {
 		heartbeat = WATCHDOG_HEARTBEAT;
-		printk(KERN_INFO PFX
+		pr_info(PFX
 			"heartbeat value must be 1<heartbeat<2046, using %d\n",
 								heartbeat);
 	}
@@ -453,12 +453,12 @@ static int __devinit esb_probe(struct platform_device *dev)
 	/* Register the watchdog so that userspace has access to it */
 	ret = misc_register(&esb_miscdev);
 	if (ret != 0) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"cannot register miscdev on minor=%d (err=%d)\n",
 							WATCHDOG_MINOR, ret);
 		goto err_unmap;
 	}
-	printk(KERN_INFO PFX
+	pr_info(PFX
 		"initialized (0x%p). heartbeat=%d sec (nowayout=%d)\n",
 						BASEADDR, heartbeat, nowayout);
 	return 0;
@@ -505,7 +505,7 @@ static int __init watchdog_init(void)
 {
 	int err;
 
-	printk(KERN_INFO PFX "Intel 6300ESB WatchDog Timer Driver v%s\n",
+	pr_info(PFX "Intel 6300ESB WatchDog Timer Driver v%s\n",
 		ESB_VERSION);
 
 	err = platform_driver_register(&esb_platform_driver);
@@ -530,7 +530,7 @@ static void __exit watchdog_cleanup(void)
 {
 	platform_device_unregister(esb_platform_device);
 	platform_driver_unregister(&esb_platform_driver);
-	printk(KERN_INFO PFX "Watchdog Module Unloaded.\n");
+	pr_info(PFX "Watchdog Module Unloaded.\n");
 }
 
 module_init(watchdog_init);
diff --git a/drivers/watchdog/iTCO_vendor_support.c b/drivers/watchdog/iTCO_vendor_support.c
index 5133bca..c54b872 100644
--- a/drivers/watchdog/iTCO_vendor_support.c
+++ b/drivers/watchdog/iTCO_vendor_support.c
@@ -364,13 +364,13 @@ EXPORT_SYMBOL(iTCO_vendor_check_noreboot_on);
 
 static int __init iTCO_vendor_init_module(void)
 {
-	printk(KERN_INFO PFX "vendor-support=%d\n", vendorsupport);
+	pr_info(PFX "vendor-support=%d\n", vendorsupport);
 	return 0;
 }
 
 static void __exit iTCO_vendor_exit_module(void)
 {
-	printk(KERN_INFO PFX "Module Unloaded\n");
+	pr_info(PFX "Module Unloaded\n");
 }
 
 module_init(iTCO_vendor_init_module);
diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index 6a51edd..5b4df5f 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -348,7 +348,7 @@ static int iTCO_wdt_start(void)
 	/* disable chipset's NO_REBOOT bit */
 	if (iTCO_wdt_unset_NO_REBOOT_bit()) {
 		spin_unlock(&iTCO_wdt_private.io_lock);
-		printk(KERN_ERR PFX "failed to reset NO_REBOOT flag, "
+		pr_err(PFX "failed to reset NO_REBOOT flag, "
 					"reboot disabled by hardware\n");
 		return -EIO;
 	}
@@ -508,7 +508,7 @@ static int iTCO_wdt_release(struct inode *inode, struct file *file)
 	if (expect_release == 42) {
 		iTCO_wdt_stop();
 	} else {
-		printk(KERN_CRIT PFX
+		pr_crit(PFX
 			"Unexpected close, not stopping watchdog!\n");
 		iTCO_wdt_keepalive();
 	}
@@ -651,7 +651,7 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 	base_address &= 0x0000ff80;
 	if (base_address == 0x00000000) {
 		/* Something's wrong here, ACPIBASE has to be set */
-		printk(KERN_ERR PFX "failed to get TCOBASE address\n");
+		pr_err(PFX "failed to get TCOBASE address\n");
 		pci_dev_put(pdev);
 		return -ENODEV;
 	}
@@ -667,7 +667,7 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 	if (iTCO_wdt_private.iTCO_version == 2) {
 		pci_read_config_dword(pdev, 0xf0, &base_address);
 		if ((base_address & 1) == 0) {
-			printk(KERN_ERR PFX "RCBA is disabled by harddware\n");
+			pr_err(PFX "RCBA is disabled by harddware\n");
 			ret = -ENODEV;
 			goto out;
 		}
@@ -677,7 +677,7 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 
 	/* Check chipset's NO_REBOOT bit */
 	if (iTCO_wdt_unset_NO_REBOOT_bit() && iTCO_vendor_check_noreboot_on()) {
-		printk(KERN_ERR PFX "failed to reset NO_REBOOT flag, "
+		pr_err(PFX "failed to reset NO_REBOOT flag, "
 					"reboot disabled by hardware\n");
 		ret = -ENODEV;	/* Cannot reset NO_REBOOT bit */
 		goto out_unmap;
@@ -688,7 +688,7 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 
 	/* The TCO logic uses the TCO_EN bit in the SMI_EN register */
 	if (!request_region(SMI_EN, 4, "iTCO_wdt")) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"I/O address 0x%04lx already in use\n", SMI_EN);
 		ret = -EIO;
 		goto out_unmap;
@@ -701,13 +701,13 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 	/* The TCO I/O registers reside in a 32-byte range pointed to
 	   by the TCOBASE value */
 	if (!request_region(TCOBASE, 0x20, "iTCO_wdt")) {
-		printk(KERN_ERR PFX "I/O address 0x%04lx already in use\n",
+		pr_err(PFX "I/O address 0x%04lx already in use\n",
 			TCOBASE);
 		ret = -EIO;
 		goto unreg_smi_en;
 	}
 
-	printk(KERN_INFO PFX
+	pr_info(PFX
 		"Found a %s TCO device (Version=%d, TCOBASE=0x%04lx)\n",
 			iTCO_chipset_info[ent->driver_data].name,
 			iTCO_chipset_info[ent->driver_data].iTCO_version,
@@ -725,20 +725,20 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 	   if not reset to the default */
 	if (iTCO_wdt_set_heartbeat(heartbeat)) {
 		iTCO_wdt_set_heartbeat(WATCHDOG_HEARTBEAT);
-		printk(KERN_INFO PFX
+		pr_info(PFX
 			"heartbeat value must be 2 < heartbeat < 39 (TCO v1) "
 				"or 613 (TCO v2), using %d\n", heartbeat);
 	}
 
 	ret = misc_register(&iTCO_wdt_miscdev);
 	if (ret != 0) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"cannot register miscdev on minor=%d (err=%d)\n",
 							WATCHDOG_MINOR, ret);
 		goto unreg_region;
 	}
 
-	printk(KERN_INFO PFX "initialized. heartbeat=%d sec (nowayout=%d)\n",
+	pr_info(PFX "initialized. heartbeat=%d sec (nowayout=%d)\n",
 							heartbeat, nowayout);
 
 	return 0;
@@ -791,7 +791,7 @@ static int __devinit iTCO_wdt_probe(struct platform_device *dev)
 	}
 
 	if (!found) {
-		printk(KERN_INFO PFX "No card detected\n");
+		pr_info(PFX "No card detected\n");
 		return -ENODEV;
 	}
 
@@ -830,7 +830,7 @@ static int __init iTCO_wdt_init_module(void)
 {
 	int err;
 
-	printk(KERN_INFO PFX "Intel TCO WatchDog Timer Driver v%s\n",
+	pr_info(PFX "Intel TCO WatchDog Timer Driver v%s\n",
 		DRV_VERSION);
 
 	err = platform_driver_register(&iTCO_wdt_driver);
@@ -855,7 +855,7 @@ static void __exit iTCO_wdt_cleanup_module(void)
 {
 	platform_device_unregister(iTCO_wdt_platform_device);
 	platform_driver_unregister(&iTCO_wdt_driver);
-	printk(KERN_INFO PFX "Watchdog Module Unloaded.\n");
+	pr_info(PFX "Watchdog Module Unloaded.\n");
 }
 
 module_init(iTCO_wdt_init_module);
diff --git a/drivers/watchdog/ib700wdt.c b/drivers/watchdog/ib700wdt.c
index 4bef3dd..bd374c7 100644
--- a/drivers/watchdog/ib700wdt.c
+++ b/drivers/watchdog/ib700wdt.c
@@ -246,7 +246,7 @@ static int ibwdt_close(struct inode *inode, struct file *file)
 	if (expect_close == 42) {
 		ibwdt_disable();
 	} else {
-		printk(KERN_CRIT PFX
+		pr_crit(PFX
 		     "WDT device closed unexpectedly.  WDT will not stop!\n");
 		ibwdt_ping();
 	}
@@ -284,7 +284,7 @@ static int __devinit ibwdt_probe(struct platform_device *dev)
 
 #if WDT_START != WDT_STOP
 	if (!request_region(WDT_STOP, 1, "IB700 WDT")) {
-		printk(KERN_ERR PFX "STOP method I/O %X is not available.\n",
+		pr_err(PFX "STOP method I/O %X is not available.\n",
 								WDT_STOP);
 		res = -EIO;
 		goto out_nostopreg;
@@ -292,7 +292,7 @@ static int __devinit ibwdt_probe(struct platform_device *dev)
 #endif
 
 	if (!request_region(WDT_START, 1, "IB700 WDT")) {
-		printk(KERN_ERR PFX "START method I/O %X is not available.\n",
+		pr_err(PFX "START method I/O %X is not available.\n",
 								WDT_START);
 		res = -EIO;
 		goto out_nostartreg;
@@ -302,13 +302,13 @@ static int __devinit ibwdt_probe(struct platform_device *dev)
 	 * if not reset to the default */
 	if (ibwdt_set_heartbeat(timeout)) {
 		ibwdt_set_heartbeat(WATCHDOG_TIMEOUT);
-		printk(KERN_INFO PFX
+		pr_info(PFX
 			"timeout value must be 0<=x<=30, using %d\n", timeout);
 	}
 
 	res = misc_register(&ibwdt_miscdev);
 	if (res) {
-		printk(KERN_ERR PFX "failed to register misc device\n");
+		pr_err(PFX "failed to register misc device\n");
 		goto out_nomisc;
 	}
 	return 0;
@@ -353,7 +353,7 @@ static int __init ibwdt_init(void)
 {
 	int err;
 
-	printk(KERN_INFO PFX
+	pr_info(PFX
 		"WDT driver for IB700 single board computer initialising.\n");
 
 	err = platform_driver_register(&ibwdt_driver);
@@ -378,7 +378,7 @@ static void __exit ibwdt_exit(void)
 {
 	platform_device_unregister(ibwdt_platform_device);
 	platform_driver_unregister(&ibwdt_driver);
-	printk(KERN_INFO PFX "Watchdog Module Unloaded.\n");
+	pr_info(PFX "Watchdog Module Unloaded.\n");
 }
 
 module_init(ibwdt_init);
diff --git a/drivers/watchdog/ibmasr.c b/drivers/watchdog/ibmasr.c
index 89fcefc..a4a8bef 100644
--- a/drivers/watchdog/ibmasr.c
+++ b/drivers/watchdog/ibmasr.c
@@ -235,12 +235,12 @@ static int __init asr_get_base_address(void)
 	}
 
 	if (!request_region(asr_base, asr_length, "ibmasr")) {
-		printk(KERN_ERR PFX "address %#x already in use\n",
+		pr_err(PFX "address %#x already in use\n",
 			asr_base);
 		return -EBUSY;
 	}
 
-	printk(KERN_INFO PFX "found %sASR @ addr %#x\n", type, asr_base);
+	pr_info(PFX "found %sASR @ addr %#x\n", type, asr_base);
 
 	return 0;
 }
@@ -333,7 +333,7 @@ static int asr_release(struct inode *inode, struct file *file)
 	if (asr_expect_close == 42)
 		asr_disable();
 	else {
-		printk(KERN_CRIT PFX
+		pr_crit(PFX
 				"unexpected close, not stopping watchdog!\n");
 		asr_toggle();
 	}
@@ -396,7 +396,7 @@ static int __init ibmasr_init(void)
 	rc = misc_register(&asr_miscdev);
 	if (rc < 0) {
 		release_region(asr_base, asr_length);
-		printk(KERN_ERR PFX "failed to register misc device\n");
+		pr_err(PFX "failed to register misc device\n");
 		return rc;
 	}
 
diff --git a/drivers/watchdog/indydog.c b/drivers/watchdog/indydog.c
index bea8a12..570baa0 100644
--- a/drivers/watchdog/indydog.c
+++ b/drivers/watchdog/indydog.c
@@ -60,7 +60,7 @@ static void indydog_stop(void)
 	sgimc->cpuctrl0 = mc_ctrl0;
 	spin_unlock(&indydog_lock);
 
-	printk(KERN_INFO PFX "Stopped watchdog timer.\n");
+	pr_info(PFX "Stopped watchdog timer.\n");
 }
 
 static void indydog_ping(void)
@@ -83,7 +83,7 @@ static int indydog_open(struct inode *inode, struct file *file)
 	indydog_start();
 	indydog_ping();
 
-	printk(KERN_INFO "Started watchdog timer.\n");
+	pr_info("Started watchdog timer.\n");
 
 	return nonseekable_open(inode, file);
 }
@@ -189,14 +189,14 @@ static int __init watchdog_init(void)
 
 	ret = register_reboot_notifier(&indydog_notifier);
 	if (ret) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"cannot register reboot notifier (err=%d)\n", ret);
 		return ret;
 	}
 
 	ret = misc_register(&indydog_miscdev);
 	if (ret) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"cannot register miscdev on minor=%d (err=%d)\n",
 							WATCHDOG_MINOR, ret);
 		unregister_reboot_notifier(&indydog_notifier);
diff --git a/drivers/watchdog/iop_wdt.c b/drivers/watchdog/iop_wdt.c
index 0c90596..dedc5c0 100644
--- a/drivers/watchdog/iop_wdt.c
+++ b/drivers/watchdog/iop_wdt.c
@@ -85,7 +85,7 @@ static int wdt_disable(void)
 		write_wdtcr(IOP_WDTCR_DIS);
 		clear_bit(WDT_ENABLED, &wdt_status);
 		spin_unlock(&wdt_lock);
-		printk(KERN_INFO "WATCHDOG: Disabled\n");
+		pr_info("WATCHDOG: Disabled\n");
 		return 0;
 	} else
 		return 1;
@@ -197,7 +197,7 @@ static int iop_wdt_release(struct inode *inode, struct file *file)
 	 */
 	if (state != 0) {
 		wdt_enable();
-		printk(KERN_CRIT "WATCHDOG: Device closed unexpectedly - "
+		pr_crit("WATCHDOG: Device closed unexpectedly - "
 		       "reset in %lu seconds\n", iop_watchdog_timeout());
 	}
 
@@ -241,7 +241,7 @@ static int __init iop_wdt_init(void)
 	   with an open */
 	ret = misc_register(&iop_wdt_miscdev);
 	if (ret == 0)
-		printk(KERN_INFO "iop watchdog timer: timeout %lu sec\n",
+		pr_info("iop watchdog timer: timeout %lu sec\n",
 		       iop_watchdog_timeout());
 
 	return ret;
diff --git a/drivers/watchdog/it8712f_wdt.c b/drivers/watchdog/it8712f_wdt.c
index daed48d..c1846e8 100644
--- a/drivers/watchdog/it8712f_wdt.c
+++ b/drivers/watchdog/it8712f_wdt.c
@@ -144,10 +144,10 @@ static void it8712f_wdt_update_margin(void)
 	 */
 	if (units <= max_units) {
 		config |= WDT_UNIT_SEC; /* else UNIT is MINUTES */
-		printk(KERN_INFO NAME ": timer margin %d seconds\n", units);
+		pr_info(NAME ": timer margin %d seconds\n", units);
 	} else {
 		units /= 60;
-		printk(KERN_INFO NAME ": timer margin %d minutes\n", units);
+		pr_info(NAME ": timer margin %d minutes\n", units);
 	}
 	superio_outb(config, WDT_CONFIG);
 
@@ -300,7 +300,7 @@ static int it8712f_wdt_open(struct inode *inode, struct file *file)
 static int it8712f_wdt_release(struct inode *inode, struct file *file)
 {
 	if (expect_close != 42) {
-		printk(KERN_WARNING NAME
+		pr_warning(NAME
 			": watchdog device closed unexpectedly, will not"
 			" disable the watchdog timer\n");
 	} else if (!nowayout) {
@@ -340,13 +340,13 @@ static int __init it8712f_wdt_find(unsigned short *address)
 	superio_select(LDN_GAME);
 	superio_outb(1, ACT_REG);
 	if (!(superio_inb(ACT_REG) & 0x01)) {
-		printk(KERN_ERR NAME ": Device not activated, skipping\n");
+		pr_err(NAME ": Device not activated, skipping\n");
 		goto exit;
 	}
 
 	*address = superio_inw(BASE_REG);
 	if (*address == 0) {
-		printk(KERN_ERR NAME ": Base address not set, skipping\n");
+		pr_err(NAME ": Base address not set, skipping\n");
 		goto exit;
 	}
 
@@ -360,7 +360,7 @@ static int __init it8712f_wdt_find(unsigned short *address)
 	if (margin > (max_units * 60))
 		margin = (max_units * 60);
 
-	printk(KERN_INFO NAME ": Found IT%04xF chip revision %d - "
+	pr_info(NAME ": Found IT%04xF chip revision %d - "
 		"using DogFood address 0x%x\n",
 		chip_type, revision, *address);
 
@@ -379,7 +379,7 @@ static int __init it8712f_wdt_init(void)
 		return -ENODEV;
 
 	if (!request_region(address, 1, "IT8712F Watchdog")) {
-		printk(KERN_WARNING NAME ": watchdog I/O region busy\n");
+		pr_warning(NAME ": watchdog I/O region busy\n");
 		return -EBUSY;
 	}
 
@@ -387,13 +387,13 @@ static int __init it8712f_wdt_init(void)
 
 	err = register_reboot_notifier(&it8712f_wdt_notifier);
 	if (err) {
-		printk(KERN_ERR NAME ": unable to register reboot notifier\n");
+		pr_err(NAME ": unable to register reboot notifier\n");
 		goto out;
 	}
 
 	err = misc_register(&it8712f_wdt_miscdev);
 	if (err) {
-		printk(KERN_ERR NAME
+		pr_err(NAME
 			": cannot register miscdev on minor=%d (err=%d)\n",
 			WATCHDOG_MINOR, err);
 		goto reboot_out;
diff --git a/drivers/watchdog/it87_wdt.c b/drivers/watchdog/it87_wdt.c
index cc133c5..57dbcb4 100644
--- a/drivers/watchdog/it87_wdt.c
+++ b/drivers/watchdog/it87_wdt.c
@@ -378,7 +378,7 @@ static int wdt_release(struct inode *inode, struct file *file)
 			clear_bit(WDTS_TIMER_RUN, &wdt_status);
 		} else {
 			wdt_keepalive();
-			printk(KERN_CRIT PFX
+			pr_crit(PFX
 			       "unexpected close, not stopping watchdog!\n");
 		}
 	}
@@ -549,15 +549,15 @@ static int __init it87_wdt_init(void)
 		if (chip_rev > 7)
 			break;
 	case IT8705_ID:
-		printk(KERN_ERR PFX
+		pr_err(PFX
 		       "Unsupported Chip found, Chip %04x Revision %02x\n",
 		       chip_type, chip_rev);
 		return -ENODEV;
 	case NO_DEV_ID:
-		printk(KERN_ERR PFX "no device\n");
+		pr_err(PFX "no device\n");
 		return -ENODEV;
 	default:
-		printk(KERN_ERR PFX
+		pr_err(PFX
 		       "Unknown Chip found, Chip %04x Revision %04x\n",
 		       chip_type, chip_rev);
 		return -ENODEV;
@@ -595,11 +595,11 @@ static int __init it87_wdt_init(void)
 	if (!test_bit(WDTS_USE_GP, &wdt_status)) {
 		if (!request_region(CIR_BASE, 8, WATCHDOG_NAME)) {
 			if (rc == -EIO)
-				printk(KERN_ERR PFX
+				pr_err(PFX
 					"I/O Address 0x%04x and 0x%04x"
 					" already in use\n", base, CIR_BASE);
 			else
-				printk(KERN_ERR PFX
+				pr_err(PFX
 					"I/O Address 0x%04x already in use\n",
 					CIR_BASE);
 			rc = -EIO;
@@ -625,21 +625,21 @@ static int __init it87_wdt_init(void)
 
 	if (timeout < 1 || timeout > 65535) {
 		timeout = DEFAULT_TIMEOUT;
-		printk(KERN_WARNING PFX
+		pr_warning(PFX
 		       "Timeout value out of range, use default %d sec\n",
 		       DEFAULT_TIMEOUT);
 	}
 
 	rc = register_reboot_notifier(&wdt_notifier);
 	if (rc) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 		       "Cannot register reboot notifier (err=%d)\n", rc);
 		goto err_out_region;
 	}
 
 	rc = misc_register(&wdt_miscdev);
 	if (rc) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 		       "Cannot register miscdev on minor=%d (err=%d)\n",
 			wdt_miscdev.minor, rc);
 		goto err_out_reboot;
@@ -656,7 +656,7 @@ static int __init it87_wdt_init(void)
 		outb(0x09, CIR_IER(base));
 	}
 
-	printk(KERN_INFO PFX "Chip it%04x revision %d initialized. "
+	pr_info(PFX "Chip it%04x revision %d initialized. "
 		"timeout=%d sec (nowayout=%d testmode=%d exclusive=%d "
 		"nogameport=%d)\n", chip_type, chip_rev, timeout,
 		nowayout, testmode, exclusive, nogameport);
diff --git a/drivers/watchdog/ixp2000_wdt.c b/drivers/watchdog/ixp2000_wdt.c
index 4f4b35a..136fd18 100644
--- a/drivers/watchdog/ixp2000_wdt.c
+++ b/drivers/watchdog/ixp2000_wdt.c
@@ -157,7 +157,7 @@ static int ixp2000_wdt_release(struct inode *inode, struct file *file)
 	if (test_bit(WDT_OK_TO_CLOSE, &wdt_status))
 		wdt_disable();
 	else
-		printk(KERN_CRIT "WATCHDOG: Device closed unexpectedly - "
+		pr_crit("WATCHDOG: Device closed unexpectedly - "
 					"timer will not stop\n");
 	clear_bit(WDT_IN_USE, &wdt_status);
 	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
@@ -184,7 +184,7 @@ static struct miscdevice ixp2000_wdt_miscdev = {
 static int __init ixp2000_wdt_init(void)
 {
 	if ((*IXP2000_PRODUCT_ID & 0x001ffef0) == 0x00000000) {
-		printk(KERN_INFO "Unable to use IXP2000 watchdog due to IXP2800 erratum #25.\n");
+		pr_info("Unable to use IXP2000 watchdog due to IXP2800 erratum #25.\n");
 		return -EIO;
 	}
 	wdt_tick_rate = (*IXP2000_T1_CLD * HZ) / 256;
diff --git a/drivers/watchdog/ixp4xx_wdt.c b/drivers/watchdog/ixp4xx_wdt.c
index 147b4d5..83cc249 100644
--- a/drivers/watchdog/ixp4xx_wdt.c
+++ b/drivers/watchdog/ixp4xx_wdt.c
@@ -147,7 +147,7 @@ static int ixp4xx_wdt_release(struct inode *inode, struct file *file)
 	if (test_bit(WDT_OK_TO_CLOSE, &wdt_status))
 		wdt_disable();
 	else
-		printk(KERN_CRIT "WATCHDOG: Device closed unexpectedly - "
+		pr_crit("WATCHDOG: Device closed unexpectedly - "
 					"timer will not stop\n");
 	clear_bit(WDT_IN_USE, &wdt_status);
 	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
@@ -176,7 +176,7 @@ static int __init ixp4xx_wdt_init(void)
 	int ret;
 
 	if (!(read_cpuid_id() & 0xf) && !cpu_is_ixp46x()) {
-		printk(KERN_ERR "IXP4XXX Watchdog: Rev. A0 IXP42x CPU detected"
+		pr_err("IXP4XXX Watchdog: Rev. A0 IXP42x CPU detected"
 			" - watchdog disabled\n");
 
 		return -ENODEV;
@@ -186,7 +186,7 @@ static int __init ixp4xx_wdt_init(void)
 			WDIOF_CARDRESET : 0;
 	ret = misc_register(&ixp4xx_wdt_miscdev);
 	if (ret == 0)
-		printk(KERN_INFO "IXP4xx Watchdog Timer: heartbeat %d sec\n",
+		pr_info("IXP4xx Watchdog Timer: heartbeat %d sec\n",
 			heartbeat);
 	return ret;
 }
diff --git a/drivers/watchdog/ks8695_wdt.c b/drivers/watchdog/ks8695_wdt.c
index 00b03eb..a956500 100644
--- a/drivers/watchdog/ks8695_wdt.c
+++ b/drivers/watchdog/ks8695_wdt.c
@@ -233,7 +233,7 @@ static int __devinit ks8695wdt_probe(struct platform_device *pdev)
 	if (res)
 		return res;
 
-	printk(KERN_INFO "KS8695 Watchdog Timer enabled (%d seconds%s)\n",
+	pr_info("KS8695 Watchdog Timer enabled (%d seconds%s)\n",
 				wdt_time, nowayout ? ", nowayout" : "");
 	return 0;
 }
diff --git a/drivers/watchdog/machzwd.c b/drivers/watchdog/machzwd.c
index b6b3f59..4c39d24 100644
--- a/drivers/watchdog/machzwd.c
+++ b/drivers/watchdog/machzwd.c
@@ -203,7 +203,7 @@ static void zf_timer_off(void)
 	zf_set_control(ctrl_reg);
 	spin_unlock_irqrestore(&zf_port_lock, flags);
 
-	printk(KERN_INFO PFX ": Watchdog timer is now disabled\n");
+	pr_info(PFX ": Watchdog timer is now disabled\n");
 }
 
 
@@ -233,7 +233,7 @@ static void zf_timer_on(void)
 	zf_set_control(ctrl_reg);
 	spin_unlock_irqrestore(&zf_port_lock, flags);
 
-	printk(KERN_INFO PFX ": Watchdog timer is now enabled\n");
+	pr_info(PFX ": Watchdog timer is now enabled\n");
 }
 
 
@@ -263,7 +263,7 @@ static void zf_ping(unsigned long data)
 
 		mod_timer(&zf_timer, jiffies + ZF_HW_TIMEO);
 	} else
-		printk(KERN_CRIT PFX ": I will reset your machine\n");
+		pr_crit(PFX ": I will reset your machine\n");
 }
 
 static ssize_t zf_write(struct file *file, const char __user *buf, size_t count,
@@ -342,7 +342,7 @@ static int zf_close(struct inode *inode, struct file *file)
 		zf_timer_off();
 	else {
 		del_timer(&zf_timer);
-		printk(KERN_ERR PFX ": device file closed unexpectedly. "
+		pr_err(PFX ": device file closed unexpectedly. "
 						"Will not stop the WDT!\n");
 	}
 	clear_bit(0, &zf_is_open);
@@ -390,19 +390,19 @@ static void __init zf_show_action(int act)
 {
 	char *str[] = { "RESET", "SMI", "NMI", "SCI" };
 
-	printk(KERN_INFO PFX ": Watchdog using action = %s\n", str[act]);
+	pr_info(PFX ": Watchdog using action = %s\n", str[act]);
 }
 
 static int __init zf_init(void)
 {
 	int ret;
 
-	printk(KERN_INFO PFX
+	pr_info(PFX
 		": MachZ ZF-Logic Watchdog driver initializing.\n");
 
 	ret = zf_get_ZFL_version();
 	if (!ret || ret == 0xffff) {
-		printk(KERN_WARNING PFX ": no ZF-Logic found\n");
+		pr_warning(PFX ": no ZF-Logic found\n");
 		return -ENODEV;
 	}
 
@@ -414,7 +414,7 @@ static int __init zf_init(void)
 	zf_show_action(action);
 
 	if (!request_region(ZF_IOBASE, 3, "MachZ ZFL WDT")) {
-		printk(KERN_ERR "cannot reserve I/O ports at %d\n",
+		pr_err("cannot reserve I/O ports at %d\n",
 							ZF_IOBASE);
 		ret = -EBUSY;
 		goto no_region;
@@ -422,14 +422,14 @@ static int __init zf_init(void)
 
 	ret = register_reboot_notifier(&zf_notifier);
 	if (ret) {
-		printk(KERN_ERR "can't register reboot notifier (err=%d)\n",
+		pr_err("can't register reboot notifier (err=%d)\n",
 									ret);
 		goto no_reboot;
 	}
 
 	ret = misc_register(&zf_miscdev);
 	if (ret) {
-		printk(KERN_ERR "can't misc_register on minor=%d\n",
+		pr_err("can't misc_register on minor=%d\n",
 							WATCHDOG_MINOR);
 		goto no_misc;
 	}
diff --git a/drivers/watchdog/mixcomwd.c b/drivers/watchdog/mixcomwd.c
index 407b025..1f5d04c 100644
--- a/drivers/watchdog/mixcomwd.c
+++ b/drivers/watchdog/mixcomwd.c
@@ -156,14 +156,14 @@ static int mixcomwd_release(struct inode *inode, struct file *file)
 {
 	if (expect_close == 42) {
 		if (mixcomwd_timer_alive) {
-			printk(KERN_ERR PFX
+			pr_err(PFX
 				"release called while internal timer alive");
 			return -EBUSY;
 		}
 		mixcomwd_timer_alive = 1;
 		mod_timer(&mixcomwd_timer, jiffies + 5 * HZ);
 	} else
-		printk(KERN_CRIT PFX
+		pr_crit(PFX
 		    "WDT device closed unexpectedly.  WDT will not stop!\n");
 
 	clear_bit(0, &mixcomwd_opened);
@@ -274,21 +274,20 @@ static int __init mixcomwd_init(void)
 	}
 
 	if (!found) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"No card detected, or port not available.\n");
 		return -ENODEV;
 	}
 
 	ret = misc_register(&mixcomwd_miscdev);
 	if (ret) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"cannot register miscdev on minor=%d (err=%d)\n",
 					WATCHDOG_MINOR, ret);
 		goto error_misc_register_watchdog;
 	}
 
-	printk(KERN_INFO
-		"MixCOM watchdog driver v%s, watchdog port at 0x%3x\n",
+	pr_info("MixCOM watchdog driver v%s, watchdog port at 0x%3x\n",
 					VERSION, watchdog_port);
 
 	return 0;
@@ -303,7 +302,7 @@ static void __exit mixcomwd_exit(void)
 {
 	if (!nowayout) {
 		if (mixcomwd_timer_alive) {
-			printk(KERN_WARNING PFX "I quit now, hardware will"
+			pr_warning(PFX "I quit now, hardware will"
 			       " probably reboot!\n");
 			del_timer_sync(&mixcomwd_timer);
 			mixcomwd_timer_alive = 0;
diff --git a/drivers/watchdog/mpcore_wdt.c b/drivers/watchdog/mpcore_wdt.c
index 83fa34b..b523694 100644
--- a/drivers/watchdog/mpcore_wdt.c
+++ b/drivers/watchdog/mpcore_wdt.c
@@ -429,7 +429,7 @@ static int __init mpcore_wdt_init(void)
 	 */
 	if (mpcore_wdt_set_heartbeat(mpcore_margin)) {
 		mpcore_wdt_set_heartbeat(TIMER_MARGIN);
-		printk(KERN_INFO "mpcore_margin value must be 0 < mpcore_margin < 65536, using %d\n",
+		pr_info("mpcore_margin value must be 0 < mpcore_margin < 65536, using %d\n",
 			TIMER_MARGIN);
 	}
 
diff --git a/drivers/watchdog/mtx-1_wdt.c b/drivers/watchdog/mtx-1_wdt.c
index 08e8a6a..7c02ded 100644
--- a/drivers/watchdog/mtx-1_wdt.c
+++ b/drivers/watchdog/mtx-1_wdt.c
@@ -221,11 +221,11 @@ static int __devinit mtx1_wdt_probe(struct platform_device *pdev)
 
 	ret = misc_register(&mtx1_wdt_misc);
 	if (ret < 0) {
-		printk(KERN_ERR " mtx-1_wdt : failed to register\n");
+		pr_err(" mtx-1_wdt : failed to register\n");
 		return ret;
 	}
 	mtx1_wdt_start();
-	printk(KERN_INFO "MTX-1 Watchdog driver\n");
+	pr_info("MTX-1 Watchdog driver\n");
 	return 0;
 }
 
diff --git a/drivers/watchdog/mv64x60_wdt.c b/drivers/watchdog/mv64x60_wdt.c
index acf589d..2aa0ed3 100644
--- a/drivers/watchdog/mv64x60_wdt.c
+++ b/drivers/watchdog/mv64x60_wdt.c
@@ -100,7 +100,7 @@ static void mv64x60_wdt_handler_enable(void)
 	if (mv64x60_wdt_toggle_wdc(MV64x60_WDC_ENABLED_FALSE,
 				   MV64x60_WDC_ENABLE_SHIFT)) {
 		mv64x60_wdt_service();
-		printk(KERN_NOTICE "mv64x60_wdt: watchdog activated\n");
+		pr_notice("mv64x60_wdt: watchdog activated\n");
 	}
 }
 
@@ -108,7 +108,7 @@ static void mv64x60_wdt_handler_disable(void)
 {
 	if (mv64x60_wdt_toggle_wdc(MV64x60_WDC_ENABLED_TRUE,
 				   MV64x60_WDC_ENABLE_SHIFT))
-		printk(KERN_NOTICE "mv64x60_wdt: watchdog deactivated\n");
+		pr_notice("mv64x60_wdt: watchdog deactivated\n");
 }
 
 static void mv64x60_wdt_set_timeout(unsigned int timeout)
@@ -139,8 +139,7 @@ static int mv64x60_wdt_release(struct inode *inode, struct file *file)
 	if (expect_close == 42)
 		mv64x60_wdt_handler_disable();
 	else {
-		printk(KERN_CRIT
-		       "mv64x60_wdt: unexpected close, not stopping timer!\n");
+		pr_crit("mv64x60_wdt: unexpected close, not stopping timer!\n");
 		mv64x60_wdt_service();
 	}
 	expect_close = 0;
@@ -308,7 +307,7 @@ static struct platform_driver mv64x60_wdt_driver = {
 
 static int __init mv64x60_wdt_init(void)
 {
-	printk(KERN_INFO "MV64x60 watchdog driver\n");
+	pr_info("MV64x60 watchdog driver\n");
 
 	return platform_driver_register(&mv64x60_wdt_driver);
 }
diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index 3ed571a..5b98c19 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -179,7 +179,7 @@ static int omap_wdt_release(struct inode *inode, struct file *file)
 	clk_disable(wdev->ick);
 	clk_disable(wdev->fck);
 #else
-	printk(KERN_CRIT "omap_wdt: Unexpected close, not stopping!\n");
+	pr_crit("omap_wdt: Unexpected close, not stopping!\n");
 #endif
 	wdev->omap_wdt_users = 0;
 
diff --git a/drivers/watchdog/orion_wdt.c b/drivers/watchdog/orion_wdt.c
index 2d9fb96..ebacb53 100644
--- a/drivers/watchdog/orion_wdt.c
+++ b/drivers/watchdog/orion_wdt.c
@@ -209,7 +209,7 @@ static int orion_wdt_release(struct inode *inode, struct file *file)
 	if (test_bit(WDT_OK_TO_CLOSE, &wdt_status))
 		orion_wdt_disable();
 	else
-		printk(KERN_CRIT "WATCHDOG: Device closed unexpectedly - "
+		pr_crit("WATCHDOG: Device closed unexpectedly - "
 					"timer will not stop\n");
 	clear_bit(WDT_IN_USE, &wdt_status);
 	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
@@ -241,7 +241,7 @@ static int __devinit orion_wdt_probe(struct platform_device *pdev)
 	if (pdata) {
 		wdt_tclk = pdata->tclk;
 	} else {
-		printk(KERN_ERR "Orion Watchdog misses platform data\n");
+		pr_err("Orion Watchdog misses platform data\n");
 		return -ENODEV;
 	}
 
@@ -257,7 +257,7 @@ static int __devinit orion_wdt_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	printk(KERN_INFO "Orion Watchdog Timer: Initial timeout %d sec%s\n",
+	pr_info("Orion Watchdog Timer: Initial timeout %d sec%s\n",
 				heartbeat, nowayout ? ", nowayout" : "");
 	return 0;
 }
diff --git a/drivers/watchdog/pc87413_wdt.c b/drivers/watchdog/pc87413_wdt.c
index 1a2b916..de04e97 100644
--- a/drivers/watchdog/pc87413_wdt.c
+++ b/drivers/watchdog/pc87413_wdt.c
@@ -84,7 +84,7 @@ static inline void pc87413_select_wdt_out(void)
 	outb_p(cr_data, WDT_DATA_IO_PORT);
 
 #ifdef DEBUG
-	printk(KERN_INFO DPFX
+	pr_info(DPFX
 		"Select multiple pin,pin55,as WDT output: Bit7 to 1: %d\n",
 								cr_data);
 #endif
@@ -108,7 +108,7 @@ static inline void pc87413_enable_swc(void)
 	outb_p(cr_data, WDT_DATA_IO_PORT);	/* Index0x30_bit0P1 */
 
 #ifdef DEBUG
-	printk(KERN_INFO DPFX "pc87413 - Enable SWC functions\n");
+	pr_info(DPFX "pc87413 - Enable SWC functions\n");
 #endif
 }
 
@@ -130,7 +130,7 @@ static inline unsigned int pc87413_get_swc_base(void)
 
 	swc_base_addr = (addr_h << 8) + addr_l;
 #ifdef DEBUG
-	printk(KERN_INFO DPFX
+	pr_info(DPFX
 		"Read SWC I/O Base Address: low %d, high %d, res %d\n",
 						addr_l, addr_h, swc_base_addr);
 #endif
@@ -144,7 +144,7 @@ static inline void pc87413_swc_bank3(unsigned int swc_base_addr)
 	/* Step 4: Select Bank3 of SWC */
 	outb_p(inb(swc_base_addr + 0x0f) | 0x03, swc_base_addr + 0x0f);
 #ifdef DEBUG
-	printk(KERN_INFO DPFX "Select Bank3 of SWC\n");
+	pr_info(DPFX "Select Bank3 of SWC\n");
 #endif
 }
 
@@ -156,7 +156,7 @@ static inline void pc87413_programm_wdto(unsigned int swc_base_addr,
 	/* Step 5: Programm WDTO, Twd. */
 	outb_p(pc87413_time, swc_base_addr + WDTO);
 #ifdef DEBUG
-	printk(KERN_INFO DPFX "Set WDTO to %d minutes\n", pc87413_time);
+	pr_info(DPFX "Set WDTO to %d minutes\n", pc87413_time);
 #endif
 }
 
@@ -167,7 +167,7 @@ static inline void pc87413_enable_wden(unsigned int swc_base_addr)
 	/* Step 6: Enable WDEN */
 	outb_p(inb(swc_base_addr + WDCTL) | 0x01, swc_base_addr + WDCTL);
 #ifdef DEBUG
-	printk(KERN_INFO DPFX "Enable WDEN\n");
+	pr_info(DPFX "Enable WDEN\n");
 #endif
 }
 
@@ -177,7 +177,7 @@ static inline void pc87413_enable_sw_wd_tren(unsigned int swc_base_addr)
 	/* Enable SW_WD_TREN */
 	outb_p(inb(swc_base_addr + WDCFG) | 0x80, swc_base_addr + WDCFG);
 #ifdef DEBUG
-	printk(KERN_INFO DPFX "Enable SW_WD_TREN\n");
+	pr_info(DPFX "Enable SW_WD_TREN\n");
 #endif
 }
 
@@ -188,7 +188,7 @@ static inline void pc87413_disable_sw_wd_tren(unsigned int swc_base_addr)
 	/* Disable SW_WD_TREN */
 	outb_p(inb(swc_base_addr + WDCFG) & 0x7f, swc_base_addr + WDCFG);
 #ifdef DEBUG
-	printk(KERN_INFO DPFX "pc87413 - Disable SW_WD_TREN\n");
+	pr_info(DPFX "pc87413 - Disable SW_WD_TREN\n");
 #endif
 }
 
@@ -199,7 +199,7 @@ static inline void pc87413_enable_sw_wd_trg(unsigned int swc_base_addr)
 	/* Enable SW_WD_TRG */
 	outb_p(inb(swc_base_addr + WDCTL) | 0x80, swc_base_addr + WDCTL);
 #ifdef DEBUG
-	printk(KERN_INFO DPFX "pc87413 - Enable SW_WD_TRG\n");
+	pr_info(DPFX "pc87413 - Enable SW_WD_TRG\n");
 #endif
 }
 
@@ -210,7 +210,7 @@ static inline void pc87413_disable_sw_wd_trg(unsigned int swc_base_addr)
 	/* Disable SW_WD_TRG */
 	outb_p(inb(swc_base_addr + WDCTL) & 0x7f, swc_base_addr + WDCTL);
 #ifdef DEBUG
-	printk(KERN_INFO DPFX "Disable SW_WD_TRG\n");
+	pr_info(DPFX "Disable SW_WD_TRG\n");
 #endif
 }
 
@@ -299,7 +299,7 @@ static int pc87413_open(struct inode *inode, struct file *file)
 	/* Reload and activate timer */
 	pc87413_refresh();
 
-	printk(KERN_INFO MODNAME
+	pr_info(MODNAME
 		"Watchdog enabled. Timeout set to %d minute(s).\n", timeout);
 
 	return nonseekable_open(inode, file);
@@ -323,10 +323,10 @@ static int pc87413_release(struct inode *inode, struct file *file)
 
 	if (expect_close == 42) {
 		pc87413_disable();
-		printk(KERN_INFO MODNAME
+		pr_info(MODNAME
 				"Watchdog disabled, sleeping again...\n");
 	} else {
-		printk(KERN_CRIT MODNAME
+		pr_crit(MODNAME
 				"Unexpected close, not stopping watchdog!\n");
 		pc87413_refresh();
 	}
@@ -443,7 +443,7 @@ static long pc87413_ioctl(struct file *file, unsigned int cmd,
 	case WDIOC_KEEPALIVE:
 		pc87413_refresh();
 #ifdef DEBUG
-		printk(KERN_INFO DPFX "keepalive\n");
+		pr_info(DPFX "keepalive\n");
 #endif
 		return 0;
 	case WDIOC_SETTIMEOUT:
@@ -523,26 +523,26 @@ static int __init pc87413_init(void)
 {
 	int ret;
 
-	printk(KERN_INFO PFX "Version " VERSION " at io 0x%X\n",
+	pr_info(PFX "Version " VERSION " at io 0x%X\n",
 							WDT_INDEX_IO_PORT);
 
 	/* request_region(io, 2, "pc87413"); */
 
 	ret = register_reboot_notifier(&pc87413_notifier);
 	if (ret != 0) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"cannot register reboot notifier (err=%d)\n", ret);
 	}
 
 	ret = misc_register(&pc87413_miscdev);
 	if (ret != 0) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"cannot register miscdev on minor=%d (err=%d)\n",
 			WATCHDOG_MINOR, ret);
 		unregister_reboot_notifier(&pc87413_notifier);
 		return ret;
 	}
-	printk(KERN_INFO PFX "initialized. timeout=%d min \n", timeout);
+	pr_info(PFX "initialized. timeout=%d min \n", timeout);
 	pc87413_enable();
 	return 0;
 }
@@ -562,14 +562,14 @@ static void __exit pc87413_exit(void)
 	/* Stop the timer before we leave */
 	if (!nowayout) {
 		pc87413_disable();
-		printk(KERN_INFO MODNAME "Watchdog disabled.\n");
+		pr_info(MODNAME "Watchdog disabled.\n");
 	}
 
 	misc_deregister(&pc87413_miscdev);
 	unregister_reboot_notifier(&pc87413_notifier);
 	/* release_region(io, 2); */
 
-	printk(KERN_INFO MODNAME " watchdog component driver removed.\n");
+	pr_info(MODNAME " watchdog component driver removed.\n");
 }
 
 module_init(pc87413_init);
diff --git a/drivers/watchdog/pcwd.c b/drivers/watchdog/pcwd.c
index aa95123..6392d38 100644
--- a/drivers/watchdog/pcwd.c
+++ b/drivers/watchdog/pcwd.c
@@ -336,16 +336,16 @@ static void pcwd_show_card_info(void)
 
 	/* Get some extra info from the hardware (in command/debug/diag mode) */
 	if (pcwd_private.revision == PCWD_REVISION_A)
-		printk(KERN_INFO PFX
+		pr_info(PFX
 			"ISA-PC Watchdog (REV.A) detected at port 0x%04x\n",
 							pcwd_private.io_addr);
 	else if (pcwd_private.revision == PCWD_REVISION_C) {
 		pcwd_get_firmware();
-		printk(KERN_INFO PFX "ISA-PC Watchdog (REV.C) detected at port "
+		pr_info(PFX "ISA-PC Watchdog (REV.C) detected at port "
 			"0x%04x (Firmware version: %s)\n",
 			pcwd_private.io_addr, pcwd_private.fw_ver_str);
 		option_switches = pcwd_get_option_switches();
-		printk(KERN_INFO PFX "Option switches (0x%02x): "
+		pr_info(PFX "Option switches (0x%02x): "
 			"Temperature Reset Enable=%s, Power On Delay=%s\n",
 			option_switches,
 			((option_switches & 0x10) ? "ON" : "OFF"),
@@ -359,10 +359,10 @@ static void pcwd_show_card_info(void)
 	}
 
 	if (pcwd_private.supports_temp)
-		printk(KERN_INFO PFX "Temperature Option Detected\n");
+		pr_info(PFX "Temperature Option Detected\n");
 
 	if (pcwd_private.boot_status & WDIOF_CARDRESET)
-		printk(KERN_INFO PFX
+		pr_info(PFX
 			"Previous reboot was caused by the card\n");
 
 	if (pcwd_private.boot_status & WDIOF_OVERHEAT) {
@@ -373,7 +373,7 @@ static void pcwd_show_card_info(void)
 	}
 
 	if (pcwd_private.boot_status == 0)
-		printk(KERN_INFO PFX
+		pr_info(PFX
 			"No previous trip detected - Cold boot or reset\n");
 }
 
@@ -404,7 +404,7 @@ static void pcwd_timer_ping(unsigned long data)
 
 		spin_unlock(&pcwd_private.io_lock);
 	} else {
-		printk(KERN_WARNING PFX
+		pr_warning(PFX
 			"Heartbeat lost! Will not ping the watchdog\n");
 	}
 }
@@ -426,7 +426,7 @@ static int pcwd_start(void)
 		stat_reg = inb_p(pcwd_private.io_addr + 2);
 		spin_unlock(&pcwd_private.io_lock);
 		if (stat_reg & WD_WDIS) {
-			printk(KERN_INFO PFX "Could not start watchdog\n");
+			pr_info(PFX "Could not start watchdog\n");
 			return -EIO;
 		}
 	}
@@ -454,7 +454,7 @@ static int pcwd_stop(void)
 		stat_reg = inb_p(pcwd_private.io_addr + 2);
 		spin_unlock(&pcwd_private.io_lock);
 		if ((stat_reg & WD_WDIS) == 0) {
-			printk(KERN_INFO PFX "Could not stop watchdog\n");
+			pr_info(PFX "Could not stop watchdog\n");
 			return -EIO;
 		}
 	}
@@ -518,7 +518,7 @@ static int pcwd_get_status(int *status)
 		if (control_status & WD_T110) {
 			*status |= WDIOF_OVERHEAT;
 			if (temp_panic) {
-				printk(KERN_INFO PFX
+				pr_info(PFX
 					"Temperature overheat trip!\n");
 				kernel_power_off();
 			}
@@ -530,7 +530,7 @@ static int pcwd_get_status(int *status)
 		if (control_status & WD_REVC_TTRP) {
 			*status |= WDIOF_OVERHEAT;
 			if (temp_panic) {
-				printk(KERN_INFO PFX
+				pr_info(PFX
 					"Temperature overheat trip!\n");
 				kernel_power_off();
 			}
@@ -548,7 +548,7 @@ static int pcwd_clear_status(void)
 		spin_lock(&pcwd_private.io_lock);
 
 		if (debug >= VERBOSE)
-			printk(KERN_INFO PFX
+			pr_info(PFX
 					"clearing watchdog trip status\n");
 
 		control_status = inb_p(pcwd_private.io_addr + 1);
@@ -720,7 +720,7 @@ static int pcwd_close(struct inode *inode, struct file *file)
 	if (expect_close == 42)
 		pcwd_stop();
 	else {
-		printk(KERN_CRIT PFX
+		pr_crit(PFX
 			"Unexpected close, not stopping watchdog!\n");
 		pcwd_keepalive();
 	}
@@ -832,7 +832,7 @@ static int __devinit pcwd_isa_match(struct device *dev, unsigned int id)
 			id);
 
 	if (!request_region(base_addr, 4, "PCWD")) {
-		printk(KERN_INFO PFX "Port 0x%04x unavailable\n", base_addr);
+		pr_info(PFX "Port 0x%04x unavailable\n", base_addr);
 		return 0;
 	}
 
@@ -875,16 +875,16 @@ static int __devinit pcwd_isa_probe(struct device *dev, unsigned int id)
 
 	cards_found++;
 	if (cards_found == 1)
-		printk(KERN_INFO PFX "v%s Ken Hollis (kenji@bitgate.com)\n",
+		pr_info(PFX "v%s Ken Hollis (kenji@bitgate.com)\n",
 							WATCHDOG_VERSION);
 
 	if (cards_found > 1) {
-		printk(KERN_ERR PFX "This driver only supports 1 device\n");
+		pr_err(PFX "This driver only supports 1 device\n");
 		return -ENODEV;
 	}
 
 	if (pcwd_ioports[id] == 0x0000) {
-		printk(KERN_ERR PFX "No I/O-Address for card detected\n");
+		pr_err(PFX "No I/O-Address for card detected\n");
 		return -ENODEV;
 	}
 	pcwd_private.io_addr = pcwd_ioports[id];
@@ -896,7 +896,7 @@ static int __devinit pcwd_isa_probe(struct device *dev, unsigned int id)
 
 	if (!request_region(pcwd_private.io_addr,
 		(pcwd_private.revision == PCWD_REVISION_A) ? 2 : 4, "PCWD")) {
-		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
+		pr_err(PFX "I/O address 0x%04x already in use\n",
 			pcwd_private.io_addr);
 		ret = -EIO;
 		goto error_request_region;
@@ -932,7 +932,7 @@ static int __devinit pcwd_isa_probe(struct device *dev, unsigned int id)
 	   if not reset to the default */
 	if (pcwd_set_heartbeat(heartbeat)) {
 		pcwd_set_heartbeat(WATCHDOG_HEARTBEAT);
-		printk(KERN_INFO PFX
+		pr_info(PFX
 		  "heartbeat value must be 2 <= heartbeat <= 7200, using %d\n",
 							WATCHDOG_HEARTBEAT);
 	}
@@ -940,7 +940,7 @@ static int __devinit pcwd_isa_probe(struct device *dev, unsigned int id)
 	if (pcwd_private.supports_temp) {
 		ret = misc_register(&temp_miscdev);
 		if (ret) {
-			printk(KERN_ERR PFX
+			pr_err(PFX
 			    "cannot register miscdev on minor=%d (err=%d)\n",
 							TEMP_MINOR, ret);
 			goto error_misc_register_temp;
@@ -949,13 +949,13 @@ static int __devinit pcwd_isa_probe(struct device *dev, unsigned int id)
 
 	ret = misc_register(&pcwd_miscdev);
 	if (ret) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"cannot register miscdev on minor=%d (err=%d)\n",
 					WATCHDOG_MINOR, ret);
 		goto error_misc_register_watchdog;
 	}
 
-	printk(KERN_INFO PFX "initialized. heartbeat=%d sec (nowayout=%d)\n",
+	pr_info(PFX "initialized. heartbeat=%d sec (nowayout=%d)\n",
 		heartbeat, nowayout);
 
 	return 0;
@@ -1025,7 +1025,7 @@ static int __init pcwd_init_module(void)
 static void __exit pcwd_cleanup_module(void)
 {
 	isa_unregister_driver(&pcwd_isa_driver);
-	printk(KERN_INFO PFX "Watchdog Module Unloaded.\n");
+	pr_info(PFX "Watchdog Module Unloaded.\n");
 }
 
 module_init(pcwd_init_module);
diff --git a/drivers/watchdog/pcwd_pci.c b/drivers/watchdog/pcwd_pci.c
index 698f51b..3f51f37 100644
--- a/drivers/watchdog/pcwd_pci.c
+++ b/drivers/watchdog/pcwd_pci.c
@@ -243,26 +243,26 @@ static void pcipcwd_show_card_info(void)
 	/* Get switch settings */
 	option_switches = pcipcwd_get_option_switches();
 
-	printk(KERN_INFO PFX "Found card at port "
+	pr_info(PFX "Found card at port "
 		"0x%04x (Firmware: %s) %s temp option\n",
 		(int) pcipcwd_private.io_addr, fw_ver_str,
 		(pcipcwd_private.supports_temp ? "with" : "without"));
 
-	printk(KERN_INFO PFX "Option switches (0x%02x): "
+	pr_info(PFX "Option switches (0x%02x): "
 		"Temperature Reset Enable=%s, Power On Delay=%s\n",
 		option_switches,
 		((option_switches & 0x10) ? "ON" : "OFF"),
 		((option_switches & 0x08) ? "ON" : "OFF"));
 
 	if (pcipcwd_private.boot_status & WDIOF_CARDRESET)
-		printk(KERN_INFO PFX
+		pr_info(PFX
 			"Previous reset was caused by the Watchdog card\n");
 
 	if (pcipcwd_private.boot_status & WDIOF_OVERHEAT)
-		printk(KERN_INFO PFX "Card sensed a CPU Overheat\n");
+		pr_info(PFX "Card sensed a CPU Overheat\n");
 
 	if (pcipcwd_private.boot_status == 0)
-		printk(KERN_INFO PFX
+		pr_info(PFX
 			"No previous trip detected - Cold boot or reset\n");
 }
 
@@ -278,7 +278,7 @@ static int pcipcwd_start(void)
 	spin_unlock(&pcipcwd_private.io_lock);
 
 	if (stat_reg & WD_PCI_WDIS) {
-		printk(KERN_ERR PFX "Card timer not enabled\n");
+		pr_err(PFX "Card timer not enabled\n");
 		return -1;
 	}
 
@@ -303,7 +303,7 @@ static int pcipcwd_stop(void)
 	spin_unlock(&pcipcwd_private.io_lock);
 
 	if (!(stat_reg & WD_PCI_WDIS)) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"Card did not acknowledge disable attempt\n");
 		return -1;
 	}
@@ -374,7 +374,7 @@ static int pcipcwd_clear_status(void)
 	int reset_counter;
 
 	if (debug >= VERBOSE)
-		printk(KERN_INFO PFX "clearing watchdog trip status & LED\n");
+		pr_info(PFX "clearing watchdog trip status & LED\n");
 
 	control_status = inb_p(pcipcwd_private.io_addr + 1);
 
@@ -583,7 +583,7 @@ static int pcipcwd_open(struct inode *inode, struct file *file)
 	/* /dev/watchdog can only be opened once */
 	if (test_and_set_bit(0, &is_active)) {
 		if (debug >= VERBOSE)
-			printk(KERN_ERR PFX
+			pr_err(PFX
 				"Attempt to open already opened device.\n");
 		return -EBUSY;
 	}
@@ -602,7 +602,7 @@ static int pcipcwd_release(struct inode *inode, struct file *file)
 	if (expect_release == 42) {
 		pcipcwd_stop();
 	} else {
-		printk(KERN_CRIT PFX
+		pr_crit(PFX
 			"Unexpected close, not stopping watchdog!\n");
 		pcipcwd_keepalive();
 	}
@@ -703,20 +703,20 @@ static int __devinit pcipcwd_card_init(struct pci_dev *pdev,
 
 	cards_found++;
 	if (cards_found == 1)
-		printk(KERN_INFO PFX DRIVER_VERSION);
+		pr_info(PFX DRIVER_VERSION);
 
 	if (cards_found > 1) {
-		printk(KERN_ERR PFX "This driver only supports 1 device\n");
+		pr_err(PFX "This driver only supports 1 device\n");
 		return -ENODEV;
 	}
 
 	if (pci_enable_device(pdev)) {
-		printk(KERN_ERR PFX "Not possible to enable PCI Device\n");
+		pr_err(PFX "Not possible to enable PCI Device\n");
 		return -ENODEV;
 	}
 
 	if (pci_resource_start(pdev, 0) == 0x0000) {
-		printk(KERN_ERR PFX "No I/O-Address for card detected\n");
+		pr_err(PFX "No I/O-Address for card detected\n");
 		ret = -ENODEV;
 		goto err_out_disable_device;
 	}
@@ -725,7 +725,7 @@ static int __devinit pcipcwd_card_init(struct pci_dev *pdev,
 	pcipcwd_private.io_addr = pci_resource_start(pdev, 0);
 
 	if (pci_request_regions(pdev, WATCHDOG_NAME)) {
-		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
+		pr_err(PFX "I/O address 0x%04x already in use\n",
 			(int) pcipcwd_private.io_addr);
 		ret = -EIO;
 		goto err_out_disable_device;
@@ -755,14 +755,14 @@ static int __devinit pcipcwd_card_init(struct pci_dev *pdev,
 	 * if not reset to the default */
 	if (pcipcwd_set_heartbeat(heartbeat)) {
 		pcipcwd_set_heartbeat(WATCHDOG_HEARTBEAT);
-		printk(KERN_INFO PFX
+		pr_info(PFX
 			"heartbeat value must be 0<heartbeat<65536, using %d\n",
 			WATCHDOG_HEARTBEAT);
 	}
 
 	ret = register_reboot_notifier(&pcipcwd_notifier);
 	if (ret != 0) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"cannot register reboot notifier (err=%d)\n", ret);
 		goto err_out_release_region;
 	}
@@ -770,7 +770,7 @@ static int __devinit pcipcwd_card_init(struct pci_dev *pdev,
 	if (pcipcwd_private.supports_temp) {
 		ret = misc_register(&pcipcwd_temp_miscdev);
 		if (ret != 0) {
-			printk(KERN_ERR PFX "cannot register miscdev on "
+			pr_err(PFX "cannot register miscdev on "
 				"minor=%d (err=%d)\n", TEMP_MINOR, ret);
 			goto err_out_unregister_reboot;
 		}
@@ -778,13 +778,13 @@ static int __devinit pcipcwd_card_init(struct pci_dev *pdev,
 
 	ret = misc_register(&pcipcwd_miscdev);
 	if (ret != 0) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"cannot register miscdev on minor=%d (err=%d)\n",
 			WATCHDOG_MINOR, ret);
 		goto err_out_misc_deregister;
 	}
 
-	printk(KERN_INFO PFX "initialized. heartbeat=%d sec (nowayout=%d)\n",
+	pr_info(PFX "initialized. heartbeat=%d sec (nowayout=%d)\n",
 		heartbeat, nowayout);
 
 	return 0;
@@ -842,7 +842,7 @@ static void __exit pcipcwd_cleanup_module(void)
 {
 	pci_unregister_driver(&pcipcwd_driver);
 
-	printk(KERN_INFO PFX "Watchdog Module Unloaded.\n");
+	pr_info(PFX "Watchdog Module Unloaded.\n");
 }
 
 module_init(pcipcwd_init_module);
diff --git a/drivers/watchdog/pcwd_usb.c b/drivers/watchdog/pcwd_usb.c
index 052fe45..430dbed 100644
--- a/drivers/watchdog/pcwd_usb.c
+++ b/drivers/watchdog/pcwd_usb.c
@@ -220,7 +220,7 @@ static void usb_pcwd_intr_done(struct urb *urb)
 resubmit:
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
 	if (retval)
-		printk(KERN_ERR PFX "can't resubmit intr, "
+		pr_err(PFX "can't resubmit intr, "
 			"usb_submit_urb failed with result %d\n", retval);
 }
 
@@ -284,7 +284,7 @@ static int usb_pcwd_start(struct usb_pcwd_private *usb_pcwd)
 								&msb, &lsb);
 
 	if ((retval == 0) || (lsb == 0)) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 				"Card did not acknowledge enable attempt\n");
 		return -1;
 	}
@@ -303,7 +303,7 @@ static int usb_pcwd_stop(struct usb_pcwd_private *usb_pcwd)
 								&msb, &lsb);
 
 	if ((retval == 0) || (lsb != 0)) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"Card did not acknowledge disable attempt\n");
 		return -1;
 	}
@@ -506,7 +506,7 @@ static int usb_pcwd_release(struct inode *inode, struct file *file)
 	if (expect_release == 42) {
 		usb_pcwd_stop(usb_pcwd_device);
 	} else {
-		printk(KERN_CRIT PFX
+		pr_crit(PFX
 			"Unexpected close, not stopping watchdog!\n");
 		usb_pcwd_keepalive(usb_pcwd_device);
 	}
@@ -627,7 +627,7 @@ static int usb_pcwd_probe(struct usb_interface *interface,
 
 	cards_found++;
 	if (cards_found > 1) {
-		printk(KERN_ERR PFX "This driver only supports 1 device\n");
+		pr_err(PFX "This driver only supports 1 device\n");
 		return -ENODEV;
 	}
 
@@ -636,7 +636,7 @@ static int usb_pcwd_probe(struct usb_interface *interface,
 
 	/* check out that we have a HID device */
 	if (!(iface_desc->desc.bInterfaceClass == USB_CLASS_HID)) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"The device isn't a Human Interface Device\n");
 		return -ENODEV;
 	}
@@ -646,7 +646,7 @@ static int usb_pcwd_probe(struct usb_interface *interface,
 
 	if (!usb_endpoint_is_int_in(endpoint)) {
 		/* we didn't find a Interrupt endpoint with direction IN */
-		printk(KERN_ERR PFX "Couldn't find an INTR & IN endpoint\n");
+		pr_err(PFX "Couldn't find an INTR & IN endpoint\n");
 		return -ENODEV;
 	}
 
@@ -657,7 +657,7 @@ static int usb_pcwd_probe(struct usb_interface *interface,
 	/* allocate memory for our device and initialize it */
 	usb_pcwd = kzalloc(sizeof(struct usb_pcwd_private), GFP_KERNEL);
 	if (usb_pcwd == NULL) {
-		printk(KERN_ERR PFX "Out of memory\n");
+		pr_err(PFX "Out of memory\n");
 		goto error;
 	}
 
@@ -674,14 +674,14 @@ static int usb_pcwd_probe(struct usb_interface *interface,
 	usb_pcwd->intr_buffer = usb_buffer_alloc(udev, usb_pcwd->intr_size,
 					GFP_ATOMIC, &usb_pcwd->intr_dma);
 	if (!usb_pcwd->intr_buffer) {
-		printk(KERN_ERR PFX "Out of memory\n");
+		pr_err(PFX "Out of memory\n");
 		goto error;
 	}
 
 	/* allocate the urb's */
 	usb_pcwd->intr_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!usb_pcwd->intr_urb) {
-		printk(KERN_ERR PFX "Out of memory\n");
+		pr_err(PFX "Out of memory\n");
 		goto error;
 	}
 
@@ -694,7 +694,7 @@ static int usb_pcwd_probe(struct usb_interface *interface,
 
 	/* register our interrupt URB with the USB system */
 	if (usb_submit_urb(usb_pcwd->intr_urb, GFP_KERNEL)) {
-		printk(KERN_ERR PFX "Problem registering interrupt URB\n");
+		pr_err(PFX "Problem registering interrupt URB\n");
 		retval = -EIO; /* failure */
 		goto error;
 	}
@@ -713,14 +713,14 @@ static int usb_pcwd_probe(struct usb_interface *interface,
 	else
 		sprintf(fw_ver_str, "<card no answer>");
 
-	printk(KERN_INFO PFX "Found card (Firmware: %s) with temp option\n",
+	pr_info(PFX "Found card (Firmware: %s) with temp option\n",
 		fw_ver_str);
 
 	/* Get switch settings */
 	usb_pcwd_send_command(usb_pcwd, CMD_GET_DIP_SWITCH_SETTINGS, &dummy,
 							&option_switches);
 
-	printk(KERN_INFO PFX "Option switches (0x%02x): "
+	pr_info(PFX "Option switches (0x%02x): "
 		"Temperature Reset Enable=%s, Power On Delay=%s\n",
 		option_switches,
 		((option_switches & 0x10) ? "ON" : "OFF"),
@@ -734,14 +734,14 @@ static int usb_pcwd_probe(struct usb_interface *interface,
 	 * if not reset to the default */
 	if (usb_pcwd_set_heartbeat(usb_pcwd, heartbeat)) {
 		usb_pcwd_set_heartbeat(usb_pcwd, WATCHDOG_HEARTBEAT);
-		printk(KERN_INFO PFX
+		pr_info(PFX
 			"heartbeat value must be 0<heartbeat<65536, using %d\n",
 			WATCHDOG_HEARTBEAT);
 	}
 
 	retval = register_reboot_notifier(&usb_pcwd_notifier);
 	if (retval != 0) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"cannot register reboot notifier (err=%d)\n",
 			retval);
 		goto error;
@@ -749,7 +749,7 @@ static int usb_pcwd_probe(struct usb_interface *interface,
 
 	retval = misc_register(&usb_pcwd_temperature_miscdev);
 	if (retval != 0) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"cannot register miscdev on minor=%d (err=%d)\n",
 			TEMP_MINOR, retval);
 		goto err_out_unregister_reboot;
@@ -757,7 +757,7 @@ static int usb_pcwd_probe(struct usb_interface *interface,
 
 	retval = misc_register(&usb_pcwd_miscdev);
 	if (retval != 0) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"cannot register miscdev on minor=%d (err=%d)\n",
 			WATCHDOG_MINOR, retval);
 		goto err_out_misc_deregister;
@@ -766,7 +766,7 @@ static int usb_pcwd_probe(struct usb_interface *interface,
 	/* we can register the device now, as it is ready */
 	usb_set_intfdata(interface, usb_pcwd);
 
-	printk(KERN_INFO PFX "initialized. heartbeat=%d sec (nowayout=%d)\n",
+	pr_info(PFX "initialized. heartbeat=%d sec (nowayout=%d)\n",
 		heartbeat, nowayout);
 
 	return 0;
@@ -824,7 +824,7 @@ static void usb_pcwd_disconnect(struct usb_interface *interface)
 
 	mutex_unlock(&disconnect_mutex);
 
-	printk(KERN_INFO PFX "USB PC Watchdog disconnected\n");
+	pr_info(PFX "USB PC Watchdog disconnected\n");
 }
 
 
@@ -839,12 +839,12 @@ static int __init usb_pcwd_init(void)
 	/* register this driver with the USB subsystem */
 	result = usb_register(&usb_pcwd_driver);
 	if (result) {
-		printk(KERN_ERR PFX "usb_register failed. Error number %d\n",
+		pr_err(PFX "usb_register failed. Error number %d\n",
 		    result);
 		return result;
 	}
 
-	printk(KERN_INFO PFX DRIVER_DESC " v" DRIVER_VERSION "\n");
+	pr_info(PFX DRIVER_DESC " v" DRIVER_VERSION "\n");
 	return 0;
 }
 
diff --git a/drivers/watchdog/pika_wdt.c b/drivers/watchdog/pika_wdt.c
index 2d22e99..29f651b 100644
--- a/drivers/watchdog/pika_wdt.c
+++ b/drivers/watchdog/pika_wdt.c
@@ -90,7 +90,7 @@ static void pikawdt_ping(unsigned long data)
 		pikawdt_reset();
 		mod_timer(&pikawdt_private.timer, jiffies + WDT_TIMEOUT);
 	} else
-		printk(KERN_CRIT PFX "I will reset your machine !\n");
+		pr_crit(PFX "I will reset your machine !\n");
 }
 
 
@@ -228,14 +228,14 @@ static int __init pikawdt_init(void)
 
 	np = of_find_compatible_node(NULL, NULL, "pika,fpga");
 	if (np == NULL) {
-		printk(KERN_ERR PFX "Unable to find fpga.\n");
+		pr_err(PFX "Unable to find fpga.\n");
 		return -ENOENT;
 	}
 
 	pikawdt_private.fpga = of_iomap(np, 0);
 	of_node_put(np);
 	if (pikawdt_private.fpga == NULL) {
-		printk(KERN_ERR PFX "Unable to map fpga.\n");
+		pr_err(PFX "Unable to map fpga.\n");
 		return -ENOMEM;
 	}
 
@@ -244,7 +244,7 @@ static int __init pikawdt_init(void)
 	/* POST information is in the sd area. */
 	np = of_find_compatible_node(NULL, NULL, "pika,fpga-sd");
 	if (np == NULL) {
-		printk(KERN_ERR PFX "Unable to find fpga-sd.\n");
+		pr_err(PFX "Unable to find fpga-sd.\n");
 		ret = -ENOENT;
 		goto out;
 	}
@@ -252,7 +252,7 @@ static int __init pikawdt_init(void)
 	fpga = of_iomap(np, 0);
 	of_node_put(np);
 	if (fpga == NULL) {
-		printk(KERN_ERR PFX "Unable to map fpga-sd.\n");
+		pr_err(PFX "Unable to map fpga-sd.\n");
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -271,11 +271,11 @@ static int __init pikawdt_init(void)
 
 	ret = misc_register(&pikawdt_miscdev);
 	if (ret) {
-		printk(KERN_ERR PFX "Unable to register miscdev.\n");
+		pr_err(PFX "Unable to register miscdev.\n");
 		goto out;
 	}
 
-	printk(KERN_INFO PFX "initialized. heartbeat=%d sec (nowayout=%d)\n",
+	pr_info(PFX "initialized. heartbeat=%d sec (nowayout=%d)\n",
 							heartbeat, nowayout);
 	return 0;
 
diff --git a/drivers/watchdog/pnx4008_wdt.c b/drivers/watchdog/pnx4008_wdt.c
index f24d041..1eda79e 100644
--- a/drivers/watchdog/pnx4008_wdt.c
+++ b/drivers/watchdog/pnx4008_wdt.c
@@ -222,7 +222,7 @@ static long pnx4008_wdt_ioctl(struct file *file, unsigned int cmd,
 static int pnx4008_wdt_release(struct inode *inode, struct file *file)
 {
 	if (!test_bit(WDT_OK_TO_CLOSE, &wdt_status))
-		printk(KERN_WARNING "WATCHDOG: Device closed unexpectdly\n");
+		pr_warning("WATCHDOG: Device closed unexpectdly\n");
 
 	wdt_disable();
 	clear_bit(WDT_IN_USE, &wdt_status);
@@ -254,12 +254,12 @@ static int __devinit pnx4008_wdt_probe(struct platform_device *pdev)
 	if (heartbeat < 1 || heartbeat > MAX_HEARTBEAT)
 		heartbeat = DEFAULT_HEARTBEAT;
 
-	printk(KERN_INFO MODULE_NAME
+	pr_info(MODULE_NAME
 		"PNX4008 Watchdog Timer: heartbeat %d sec\n", heartbeat);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (res == NULL) {
-		printk(KERN_INFO MODULE_NAME
+		pr_info(MODULE_NAME
 			"failed to get memory region resouce\n");
 		return -ENOENT;
 	}
@@ -268,7 +268,7 @@ static int __devinit pnx4008_wdt_probe(struct platform_device *pdev)
 	wdt_mem = request_mem_region(res->start, size, pdev->name);
 
 	if (wdt_mem == NULL) {
-		printk(KERN_INFO MODULE_NAME "failed to get memory region\n");
+		pr_info(MODULE_NAME "failed to get memory region\n");
 		return -ENOENT;
 	}
 	wdt_base = (void __iomem *)IO_ADDRESS(res->start);
@@ -284,7 +284,7 @@ static int __devinit pnx4008_wdt_probe(struct platform_device *pdev)
 
 	ret = misc_register(&pnx4008_wdt_miscdev);
 	if (ret < 0) {
-		printk(KERN_ERR MODULE_NAME "cannot register misc device\n");
+		pr_err(MODULE_NAME "cannot register misc device\n");
 		release_resource(wdt_mem);
 		kfree(wdt_mem);
 		clk_set_rate(wdt_clk, 0);
diff --git a/drivers/watchdog/pnx833x_wdt.c b/drivers/watchdog/pnx833x_wdt.c
index 538ec2c..deef790 100644
--- a/drivers/watchdog/pnx833x_wdt.c
+++ b/drivers/watchdog/pnx833x_wdt.c
@@ -73,7 +73,7 @@ static void pnx833x_wdt_start(void)
 	PNX833X_REG(PNX833X_CONFIG +
 				PNX833X_CONFIG_CPU_COUNTERS_CONTROL) |= 0x1;
 
-	printk(KERN_INFO PFX "Started watchdog timer.\n");
+	pr_info(PFX "Started watchdog timer.\n");
 }
 
 static void pnx833x_wdt_stop(void)
@@ -84,7 +84,7 @@ static void pnx833x_wdt_stop(void)
 	PNX833X_REG(PNX833X_CONFIG +
 			PNX833X_CONFIG_CPU_COUNTERS_CONTROL) &= 0xFFFFFFFE;
 
-	printk(KERN_INFO PFX "Stopped watchdog timer.\n");
+	pr_info(PFX "Stopped watchdog timer.\n");
 }
 
 static void pnx833x_wdt_ping(void)
@@ -110,7 +110,7 @@ static int pnx833x_wdt_open(struct inode *inode, struct file *file)
 
 	pnx833x_wdt_ping();
 
-	printk(KERN_INFO "Started watchdog timer.\n");
+	pr_info("Started watchdog timer.\n");
 
 	return nonseekable_open(inode, file);
 }
@@ -240,20 +240,20 @@ static int __init watchdog_init(void)
 	cause = PNX833X_REG(PNX833X_RESET);
 	/*If bit 31 is set then watchdog was cause of reset.*/
 	if (cause & 0x80000000) {
-		printk(KERN_INFO PFX "The system was previously reset due to "
+		pr_info(PFX "The system was previously reset due to "
 			"the watchdog firing - please investigate...\n");
 	}
 
 	ret = register_reboot_notifier(&pnx833x_wdt_notifier);
 	if (ret) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"cannot register reboot notifier (err=%d)\n", ret);
 		return ret;
 	}
 
 	ret = misc_register(&pnx833x_wdt_miscdev);
 	if (ret) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"cannot register miscdev on minor=%d (err=%d)\n",
 			WATCHDOG_MINOR, ret);
 		unregister_reboot_notifier(&pnx833x_wdt_notifier);
diff --git a/drivers/watchdog/rc32434_wdt.c b/drivers/watchdog/rc32434_wdt.c
index f6cccc9..5ecfff9 100644
--- a/drivers/watchdog/rc32434_wdt.c
+++ b/drivers/watchdog/rc32434_wdt.c
@@ -78,7 +78,7 @@ static int rc32434_wdt_set(int new_timeout)
 	int max_to = WTCOMP2SEC((u32)-1);
 
 	if (new_timeout < 0 || new_timeout > max_to) {
-		printk(KERN_ERR PFX "timeout value must be between 0 and %d",
+		pr_err(PFX "timeout value must be between 0 and %d",
 			max_to);
 		return -EINVAL;
 	}
@@ -119,7 +119,7 @@ static void rc32434_wdt_start(void)
 	SET_BITS(wdt_reg->wtc, or, nand);
 
 	spin_unlock(&rc32434_wdt_device.io_lock);
-	printk(KERN_INFO PFX "Started watchdog timer.\n");
+	pr_info(PFX "Started watchdog timer.\n");
 }
 
 static void rc32434_wdt_stop(void)
@@ -130,7 +130,7 @@ static void rc32434_wdt_stop(void)
 	SET_BITS(wdt_reg->wtc, 0, 1 << RC32434_WTC_EN);
 
 	spin_unlock(&rc32434_wdt_device.io_lock);
-	printk(KERN_INFO PFX "Stopped watchdog timer.\n");
+	pr_info(PFX "Stopped watchdog timer.\n");
 }
 
 static void rc32434_wdt_ping(void)
@@ -160,7 +160,7 @@ static int rc32434_wdt_release(struct inode *inode, struct file *file)
 		rc32434_wdt_stop();
 		module_put(THIS_MODULE);
 	} else {
-		printk(KERN_CRIT PFX
+		pr_crit(PFX
 			"device closed unexpectedly. WDT will not stop!\n");
 		rc32434_wdt_ping();
 	}
@@ -272,13 +272,13 @@ static int __devinit rc32434_wdt_probe(struct platform_device *pdev)
 
 	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "rb532_wdt_res");
 	if (!r) {
-		printk(KERN_ERR PFX "failed to retrieve resources\n");
+		pr_err(PFX "failed to retrieve resources\n");
 		return -ENODEV;
 	}
 
 	wdt_reg = ioremap_nocache(r->start, r->end - r->start);
 	if (!wdt_reg) {
-		printk(KERN_ERR PFX "failed to remap I/O resources\n");
+		pr_err(PFX "failed to remap I/O resources\n");
 		return -ENXIO;
 	}
 
@@ -291,14 +291,14 @@ static int __devinit rc32434_wdt_probe(struct platform_device *pdev)
 	 * if not reset to the default */
 	if (rc32434_wdt_set(timeout)) {
 		rc32434_wdt_set(WATCHDOG_TIMEOUT);
-		printk(KERN_INFO PFX
+		pr_info(PFX
 			"timeout value must be between 0 and %d\n",
 			WTCOMP2SEC((u32)-1));
 	}
 
 	ret = misc_register(&rc32434_wdt_miscdev);
 	if (ret < 0) {
-		printk(KERN_ERR PFX "failed to register watchdog device\n");
+		pr_err(PFX "failed to register watchdog device\n");
 		goto unmap;
 	}
 
diff --git a/drivers/watchdog/rdc321x_wdt.c b/drivers/watchdog/rdc321x_wdt.c
index 4976bfd..7c39d47 100644
--- a/drivers/watchdog/rdc321x_wdt.c
+++ b/drivers/watchdog/rdc321x_wdt.c
@@ -222,7 +222,7 @@ static int __devinit rdc321x_wdt_probe(struct platform_device *pdev)
 
 	err = misc_register(&rdc321x_wdt_misc);
 	if (err < 0) {
-		printk(KERN_ERR PFX "watchdog misc_register failed\n");
+		pr_err(PFX "watchdog misc_register failed\n");
 		return err;
 	}
 
@@ -240,7 +240,7 @@ static int __devinit rdc321x_wdt_probe(struct platform_device *pdev)
 
 	rdc321x_wdt_device.default_ticks = ticks;
 
-	printk(KERN_INFO PFX "watchdog init success\n");
+	pr_info(PFX "watchdog init success\n");
 
 	return 0;
 }
diff --git a/drivers/watchdog/riowd.c b/drivers/watchdog/riowd.c
index 1e8f02f..04bd27d 100644
--- a/drivers/watchdog/riowd.c
+++ b/drivers/watchdog/riowd.c
@@ -191,17 +191,17 @@ static int __devinit riowd_probe(struct of_device *op,
 
 	p->regs = of_ioremap(&op->resource[0], 0, 2, DRIVER_NAME);
 	if (!p->regs) {
-		printk(KERN_ERR PFX "Cannot map registers.\n");
+		pr_err(PFX "Cannot map registers.\n");
 		goto out_free;
 	}
 
 	err = misc_register(&riowd_miscdev);
 	if (err) {
-		printk(KERN_ERR PFX "Cannot register watchdog misc device.\n");
+		pr_err(PFX "Cannot register watchdog misc device.\n");
 		goto out_iounmap;
 	}
 
-	printk(KERN_INFO PFX "Hardware watchdog [%i minutes], "
+	pr_info(PFX "Hardware watchdog [%i minutes], "
 	       "regs at %p\n", riowd_timeout, p->regs);
 
 	dev_set_drvdata(&op->dev, p);
diff --git a/drivers/watchdog/rm9k_wdt.c b/drivers/watchdog/rm9k_wdt.c
index 2e44426..c4110c5 100644
--- a/drivers/watchdog/rm9k_wdt.c
+++ b/drivers/watchdog/rm9k_wdt.c
@@ -124,7 +124,7 @@ static irqreturn_t wdt_gpi_irqhdl(int irq, void *ctxt)
 	__raw_writel(0x1, wd_regs + 0x0008);
 
 
-	printk(KERN_CRIT "%s: watchdog expired - resetting system\n",
+	pr_crit("%s: watchdog expired - resetting system\n",
 		wdt_gpi_name);
 
 	*(volatile char *) flagaddr |= 0x01;
@@ -202,7 +202,7 @@ static int wdt_gpi_open(struct inode *inode, struct file *file)
 	wdt_gpi_set_timeout(timeout);
 	wdt_gpi_start();
 
-	printk(KERN_INFO "%s: watchdog started, timeout = %u seconds\n",
+	pr_info("%s: watchdog started, timeout = %u seconds\n",
 		wdt_gpi_name, timeout);
 	return nonseekable_open(inode, file);
 }
@@ -210,7 +210,7 @@ static int wdt_gpi_open(struct inode *inode, struct file *file)
 static int wdt_gpi_release(struct inode *inode, struct file *file)
 {
 	if (nowayout) {
-		printk(KERN_INFO "%s: no way out - watchdog left running\n",
+		pr_info("%s: no way out - watchdog left running\n",
 			wdt_gpi_name);
 		__module_get(THIS_MODULE);
 		locked = 1;
@@ -218,10 +218,10 @@ static int wdt_gpi_release(struct inode *inode, struct file *file)
 		if (expect_close) {
 			wdt_gpi_stop();
 			free_irq(wd_irq, &miscdev);
-			printk(KERN_INFO "%s: watchdog stopped\n",
+			pr_info("%s: watchdog stopped\n",
 							wdt_gpi_name);
 		} else {
-			printk(KERN_CRIT "%s: unexpected close() -"
+			pr_crit("%s: unexpected close() -"
 				" watchdog left running\n",
 				wdt_gpi_name);
 			wdt_gpi_set_timeout(timeout);
@@ -309,7 +309,7 @@ static long wdt_gpi_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 			timeout = val;
 			wdt_gpi_set_timeout(val);
 			res = size;
-			printk(KERN_INFO "%s: timeout set to %u seconds\n",
+			pr_info("%s: timeout set to %u seconds\n",
 				wdt_gpi_name, timeout);
 		}
 		break;
diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index b57ac6b..27515fc 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -86,7 +86,7 @@ static DEFINE_SPINLOCK(wdt_lock);
 
 #define DBG(msg...) do { \
 	if (debug) \
-		printk(KERN_INFO msg); \
+		pr_info(msg); \
 	} while (0)
 
 /* functions */
@@ -497,7 +497,7 @@ static int s3c2410wdt_resume(struct platform_device *dev)
 	writel(wtdat_save, wdt_base + S3C2410_WTCNT); /* Reset count */
 	writel(wtcon_save, wdt_base + S3C2410_WTCON);
 
-	printk(KERN_INFO PFX "watchdog %sabled\n",
+	pr_info(PFX "watchdog %sabled\n",
 	       (wtcon_save & S3C2410_WTCON_ENABLE) ? "en" : "dis");
 
 	return 0;
diff --git a/drivers/watchdog/sa1100_wdt.c b/drivers/watchdog/sa1100_wdt.c
index 0162454..1fb2ac9 100644
--- a/drivers/watchdog/sa1100_wdt.c
+++ b/drivers/watchdog/sa1100_wdt.c
@@ -66,7 +66,7 @@ static int sa1100dog_open(struct inode *inode, struct file *file)
  */
 static int sa1100dog_release(struct inode *inode, struct file *file)
 {
-	printk(KERN_CRIT "WATCHDOG: Device closed - timer will not stop\n");
+	pr_crit("WATCHDOG: Device closed - timer will not stop\n");
 	clear_bit(1, &sa1100wdt_users);
 	return 0;
 }
@@ -169,8 +169,7 @@ static int __init sa1100dog_init(void)
 
 	ret = misc_register(&sa1100dog_miscdev);
 	if (ret == 0)
-		printk(KERN_INFO
-			"SA1100/PXA2xx Watchdog Timer: timer margin %d sec\n",
+		pr_info("SA1100/PXA2xx Watchdog Timer: timer margin %d sec\n",
 						margin);
 	return ret;
 }
diff --git a/drivers/watchdog/sb_wdog.c b/drivers/watchdog/sb_wdog.c
index 9748eed..5b82eeb 100644
--- a/drivers/watchdog/sb_wdog.c
+++ b/drivers/watchdog/sb_wdog.c
@@ -125,8 +125,7 @@ static int sbwdog_release(struct inode *inode, struct file *file)
 		__raw_writeb(0, user_dog);
 		module_put(THIS_MODULE);
 	} else {
-		printk(KERN_CRIT
-			"%s: Unexpected close, not stopping watchdog!\n",
+		pr_crit("%s: Unexpected close, not stopping watchdog!\n",
 						ident.identity);
 		sbwdog_pet(user_dog);
 	}
@@ -269,7 +268,7 @@ irqreturn_t sbwdog_interrupt(int irq, void *addr)
 	 * if it's the second watchdog timer, it's for those users
 	 */
 	if (wd_cfg_reg == user_dog)
-		printk(KERN_CRIT "%s in danger of initiating system reset "
+		pr_crit("%s in danger of initiating system reset "
 			"in %ld.%01ld seconds\n",
 			ident.identity,
 			wd_init / 1000000, (wd_init / 100000) % 10);
@@ -290,8 +289,7 @@ static int __init sbwdog_init(void)
 	 */
 	ret = register_reboot_notifier(&sbwdog_notifier);
 	if (ret) {
-		printk(KERN_ERR
-			"%s: cannot register reboot notifier (err=%d)\n",
+		pr_err("%s: cannot register reboot notifier (err=%d)\n",
 						ident.identity, ret);
 		return ret;
 	}
@@ -303,14 +301,14 @@ static int __init sbwdog_init(void)
 	ret = request_irq(1, sbwdog_interrupt, IRQF_DISABLED | IRQF_SHARED,
 		ident.identity, (void *)user_dog);
 	if (ret) {
-		printk(KERN_ERR "%s: failed to request irq 1 - %d\n",
+		pr_err("%s: failed to request irq 1 - %d\n",
 						ident.identity, ret);
 		return ret;
 	}
 
 	ret = misc_register(&sbwdog_miscdev);
 	if (ret == 0) {
-		printk(KERN_INFO "%s: timeout is %ld.%ld secs\n",
+		pr_info("%s: timeout is %ld.%ld secs\n",
 				ident.identity,
 				timeout / 1000000, (timeout / 100000) % 10);
 	} else
@@ -347,8 +345,7 @@ void platform_wd_setup(void)
 	ret = request_irq(1, sbwdog_interrupt, IRQF_DISABLED | IRQF_SHARED,
 		"Kernel Watchdog", IOADDR(A_SCD_WDOG_CFG_0));
 	if (ret) {
-		printk(KERN_CRIT
-		  "Watchdog IRQ zero(0) failed to be requested - %d\n", ret);
+		pr_crit("Watchdog IRQ zero(0) failed to be requested - %d\n", ret);
 	}
 }
 
diff --git a/drivers/watchdog/sbc60xxwdt.c b/drivers/watchdog/sbc60xxwdt.c
index 626d0e8..d51a15c 100644
--- a/drivers/watchdog/sbc60xxwdt.c
+++ b/drivers/watchdog/sbc60xxwdt.c
@@ -132,7 +132,7 @@ static void wdt_timer_ping(unsigned long data)
 		/* Re-set the timer interval */
 		mod_timer(&timer, jiffies + WDT_INTERVAL);
 	} else
-		printk(KERN_WARNING PFX
+		pr_warning(PFX
 			"Heartbeat lost! Will not ping the watchdog\n");
 }
 
@@ -146,7 +146,7 @@ static void wdt_startup(void)
 
 	/* Start the timer */
 	mod_timer(&timer, jiffies + WDT_INTERVAL);
-	printk(KERN_INFO PFX "Watchdog timer is now enabled.\n");
+	pr_info(PFX "Watchdog timer is now enabled.\n");
 }
 
 static void wdt_turnoff(void)
@@ -154,7 +154,7 @@ static void wdt_turnoff(void)
 	/* Stop the timer */
 	del_timer(&timer);
 	inb_p(wdt_stop);
-	printk(KERN_INFO PFX "Watchdog timer is now disabled...\n");
+	pr_info(PFX "Watchdog timer is now disabled...\n");
 }
 
 static void wdt_keepalive(void)
@@ -217,7 +217,7 @@ static int fop_close(struct inode *inode, struct file *file)
 		wdt_turnoff();
 	else {
 		del_timer(&timer);
-		printk(KERN_CRIT PFX
+		pr_crit(PFX
 		  "device file closed unexpectedly. Will not stop the WDT!\n");
 	}
 	clear_bit(0, &wdt_is_open);
@@ -335,13 +335,13 @@ static int __init sbc60xxwdt_init(void)
 
 	if (timeout < 1 || timeout > 3600) { /* arbitrary upper limit */
 		timeout = WATCHDOG_TIMEOUT;
-		printk(KERN_INFO PFX
+		pr_info(PFX
 			"timeout value must be 1 <= x <= 3600, using %d\n",
 								timeout);
 	}
 
 	if (!request_region(wdt_start, 1, "SBC 60XX WDT")) {
-		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
+		pr_err(PFX "I/O address 0x%04x already in use\n",
 			wdt_start);
 		rc = -EIO;
 		goto err_out;
@@ -350,7 +350,7 @@ static int __init sbc60xxwdt_init(void)
 	/* We cannot reserve 0x45 - the kernel already has! */
 	if (wdt_stop != 0x45 && wdt_stop != wdt_start) {
 		if (!request_region(wdt_stop, 1, "SBC 60XX WDT")) {
-			printk(KERN_ERR PFX
+			pr_err(PFX
 				"I/O address 0x%04x already in use\n",
 							wdt_stop);
 			rc = -EIO;
@@ -360,19 +360,19 @@ static int __init sbc60xxwdt_init(void)
 
 	rc = register_reboot_notifier(&wdt_notifier);
 	if (rc) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"cannot register reboot notifier (err=%d)\n", rc);
 		goto err_out_region2;
 	}
 
 	rc = misc_register(&wdt_miscdev);
 	if (rc) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"cannot register miscdev on minor=%d (err=%d)\n",
 						wdt_miscdev.minor, rc);
 		goto err_out_reboot;
 	}
-	printk(KERN_INFO PFX
+	pr_info(PFX
 		"WDT driver for 60XX single board computer initialised. "
 		"timeout=%d sec (nowayout=%d)\n", timeout, nowayout);
 
diff --git a/drivers/watchdog/sbc7240_wdt.c b/drivers/watchdog/sbc7240_wdt.c
index 67ddeb1..241a091 100644
--- a/drivers/watchdog/sbc7240_wdt.c
+++ b/drivers/watchdog/sbc7240_wdt.c
@@ -65,7 +65,7 @@ static void wdt_disable(void)
 	/* disable the watchdog */
 	if (test_and_clear_bit(SBC7240_ENABLED_STATUS_BIT, &wdt_status)) {
 		inb_p(SBC7240_DISABLE_PORT);
-		printk(KERN_INFO SBC7240_PREFIX
+		pr_info(SBC7240_PREFIX
 		       "Watchdog timer is now disabled.\n");
 	}
 }
@@ -75,7 +75,7 @@ static void wdt_enable(void)
 	/* enable the watchdog */
 	if (!test_and_set_bit(SBC7240_ENABLED_STATUS_BIT, &wdt_status)) {
 		inb_p(SBC7240_ENABLE_PORT);
-		printk(KERN_INFO SBC7240_PREFIX
+		pr_info(SBC7240_PREFIX
 		       "Watchdog timer is now enabled.\n");
 	}
 }
@@ -83,7 +83,7 @@ static void wdt_enable(void)
 static int wdt_set_timeout(int t)
 {
 	if (t < 1 || t > SBC7240_MAX_TIMEOUT) {
-		printk(KERN_ERR SBC7240_PREFIX
+		pr_err(SBC7240_PREFIX
 		       "timeout value must be 1<=x<=%d\n",
 		       SBC7240_MAX_TIMEOUT);
 		return -1;
@@ -91,7 +91,7 @@ static int wdt_set_timeout(int t)
 	/* set the timeout */
 	outb_p((unsigned)t, SBC7240_SET_TIMEOUT_PORT);
 	timeout = t;
-	printk(KERN_INFO SBC7240_PREFIX "timeout set to %d seconds\n", t);
+	pr_info(SBC7240_PREFIX "timeout set to %d seconds\n", t);
 	return 0;
 }
 
@@ -150,7 +150,7 @@ static int fop_close(struct inode *inode, struct file *file)
 	    || !nowayout) {
 		wdt_disable();
 	} else {
-		printk(KERN_CRIT SBC7240_PREFIX
+		pr_crit(SBC7240_PREFIX
 		       "Unexpected close, not stopping watchdog!\n");
 		wdt_keepalive();
 	}
@@ -252,7 +252,7 @@ static struct notifier_block wdt_notifier = {
 
 static void __exit sbc7240_wdt_unload(void)
 {
-	printk(KERN_INFO SBC7240_PREFIX "Removing watchdog\n");
+	pr_info(SBC7240_PREFIX "Removing watchdog\n");
 	misc_deregister(&wdt_miscdev);
 
 	unregister_reboot_notifier(&wdt_notifier);
@@ -264,7 +264,7 @@ static int __init sbc7240_wdt_init(void)
 	int rc = -EBUSY;
 
 	if (!request_region(SBC7240_ENABLE_PORT, 1, "SBC7240 WDT")) {
-		printk(KERN_ERR SBC7240_PREFIX
+		pr_err(SBC7240_PREFIX
 		       "I/O address 0x%04x already in use\n",
 		       SBC7240_ENABLE_PORT);
 		rc = -EIO;
@@ -277,7 +277,7 @@ static int __init sbc7240_wdt_init(void)
 
 	if (timeout < 1 || timeout > SBC7240_MAX_TIMEOUT) {
 		timeout = SBC7240_TIMEOUT;
-		printk(KERN_INFO SBC7240_PREFIX
+		pr_info(SBC7240_PREFIX
 		       "timeout value must be 1<=x<=%d, using %d\n",
 		       SBC7240_MAX_TIMEOUT, timeout);
 	}
@@ -286,20 +286,20 @@ static int __init sbc7240_wdt_init(void)
 
 	rc = register_reboot_notifier(&wdt_notifier);
 	if (rc) {
-		printk(KERN_ERR SBC7240_PREFIX
+		pr_err(SBC7240_PREFIX
 		       "cannot register reboot notifier (err=%d)\n", rc);
 		goto err_out_region;
 	}
 
 	rc = misc_register(&wdt_miscdev);
 	if (rc) {
-		printk(KERN_ERR SBC7240_PREFIX
+		pr_err(SBC7240_PREFIX
 		       "cannot register miscdev on minor=%d (err=%d)\n",
 		       wdt_miscdev.minor, rc);
 		goto err_out_reboot_notifier;
 	}
 
-	printk(KERN_INFO SBC7240_PREFIX
+	pr_info(SBC7240_PREFIX
 	       "Watchdog driver for SBC7240 initialised (nowayout=%d)\n",
 	       nowayout);
 
diff --git a/drivers/watchdog/sbc8360.c b/drivers/watchdog/sbc8360.c
index 68e2e2d..5fc2ee1 100644
--- a/drivers/watchdog/sbc8360.c
+++ b/drivers/watchdog/sbc8360.c
@@ -280,7 +280,7 @@ static int sbc8360_close(struct inode *inode, struct file *file)
 	if (expect_close == 42)
 		sbc8360_stop();
 	else
-		printk(KERN_CRIT PFX "SBC8360 device closed unexpectedly.  "
+		pr_crit(PFX "SBC8360 device closed unexpectedly.  "
 						"SBC8360 will not stop!\n");
 
 	clear_bit(0, &sbc8360_is_open);
@@ -334,19 +334,19 @@ static int __init sbc8360_init(void)
 	unsigned long int mseconds = 60000;
 
 	if (timeout < 0 || timeout > 63) {
-		printk(KERN_ERR PFX "Invalid timeout index (must be 0-63).\n");
+		pr_err(PFX "Invalid timeout index (must be 0-63).\n");
 		res = -EINVAL;
 		goto out;
 	}
 
 	if (!request_region(SBC8360_ENABLE, 1, "SBC8360")) {
-		printk(KERN_ERR PFX "ENABLE method I/O %X is not available.\n",
+		pr_err(PFX "ENABLE method I/O %X is not available.\n",
 		       SBC8360_ENABLE);
 		res = -EIO;
 		goto out;
 	}
 	if (!request_region(SBC8360_BASETIME, 1, "SBC8360")) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 		       "BASETIME method I/O %X is not available.\n",
 		       SBC8360_BASETIME);
 		res = -EIO;
@@ -355,13 +355,13 @@ static int __init sbc8360_init(void)
 
 	res = register_reboot_notifier(&sbc8360_notifier);
 	if (res) {
-		printk(KERN_ERR PFX "Failed to register reboot notifier.\n");
+		pr_err(PFX "Failed to register reboot notifier.\n");
 		goto out_noreboot;
 	}
 
 	res = misc_register(&sbc8360_miscdev);
 	if (res) {
-		printk(KERN_ERR PFX "failed to register misc device\n");
+		pr_err(PFX "failed to register misc device\n");
 		goto out_nomisc;
 	}
 
@@ -378,7 +378,7 @@ static int __init sbc8360_init(void)
 		mseconds = (wd_margin + 1) * 100000;
 
 	/* My kingdom for the ability to print "0.5 seconds" in the kernel! */
-	printk(KERN_INFO PFX "Timeout set at %ld ms.\n", mseconds);
+	pr_info(PFX "Timeout set at %ld ms.\n", mseconds);
 
 	return 0;
 
diff --git a/drivers/watchdog/sbc_epx_c3.c b/drivers/watchdog/sbc_epx_c3.c
index 28f1214..9cc207f 100644
--- a/drivers/watchdog/sbc_epx_c3.c
+++ b/drivers/watchdog/sbc_epx_c3.c
@@ -51,7 +51,7 @@ static void epx_c3_stop(void)
 
 	outb(0, EPXC3_WATCHDOG_CTL_REG);
 
-	printk(KERN_INFO PFX "Stopped watchdog timer.\n");
+	pr_info(PFX "Stopped watchdog timer.\n");
 }
 
 static void epx_c3_pet(void)
@@ -75,7 +75,7 @@ static int epx_c3_open(struct inode *inode, struct file *file)
 	epx_c3_pet();
 
 	epx_c3_alive = 1;
-	printk(KERN_INFO "Started watchdog timer.\n");
+	pr_info("Started watchdog timer.\n");
 
 	return nonseekable_open(inode, file);
 }
@@ -185,14 +185,14 @@ static int __init watchdog_init(void)
 
 	ret = register_reboot_notifier(&epx_c3_notifier);
 	if (ret) {
-		printk(KERN_ERR PFX "cannot register reboot notifier "
+		pr_err(PFX "cannot register reboot notifier "
 			"(err=%d)\n", ret);
 		goto out;
 	}
 
 	ret = misc_register(&epx_c3_miscdev);
 	if (ret) {
-		printk(KERN_ERR PFX "cannot register miscdev on minor=%d "
+		pr_err(PFX "cannot register miscdev on minor=%d "
 			"(err=%d)\n", WATCHDOG_MINOR, ret);
 		unregister_reboot_notifier(&epx_c3_notifier);
 		goto out;
diff --git a/drivers/watchdog/sc1200wdt.c b/drivers/watchdog/sc1200wdt.c
index b5e19c1..637c707 100644
--- a/drivers/watchdog/sc1200wdt.c
+++ b/drivers/watchdog/sc1200wdt.c
@@ -176,7 +176,7 @@ static int sc1200wdt_open(struct inode *inode, struct file *file)
 		timeout = MAX_TIMEOUT;
 
 	sc1200wdt_start();
-	printk(KERN_INFO PFX "Watchdog enabled, timeout = %d min(s)", timeout);
+	pr_info(PFX "Watchdog enabled, timeout = %d min(s)", timeout);
 
 	return nonseekable_open(inode, file);
 }
@@ -254,10 +254,10 @@ static int sc1200wdt_release(struct inode *inode, struct file *file)
 {
 	if (expect_close == 42) {
 		sc1200wdt_stop();
-		printk(KERN_INFO PFX "Watchdog disabled\n");
+		pr_info(PFX "Watchdog disabled\n");
 	} else {
 		sc1200wdt_write_data(WDTO, timeout);
-		printk(KERN_CRIT PFX
+		pr_crit(PFX
 			"Unexpected close!, timeout = %d min(s)\n", timeout);
 	}
 	clear_bit(0, &open_flag);
@@ -361,11 +361,11 @@ static int scl200wdt_pnp_probe(struct pnp_dev *dev,
 	io_len = pnp_port_len(wdt_dev, 0);
 
 	if (!request_region(io, io_len, SC1200_MODULE_NAME)) {
-		printk(KERN_ERR PFX "Unable to register IO port %#x\n", io);
+		pr_err(PFX "Unable to register IO port %#x\n", io);
 		return -EBUSY;
 	}
 
-	printk(KERN_INFO "scl200wdt: PnP device found at io port %#x/%d\n",
+	pr_info("scl200wdt: PnP device found at io port %#x/%d\n",
 								io, io_len);
 	return 0;
 }
@@ -392,7 +392,7 @@ static int __init sc1200wdt_init(void)
 {
 	int ret;
 
-	printk(KERN_INFO "%s\n", banner);
+	pr_info("%s\n", banner);
 
 #if defined CONFIG_PNP
 	if (isapnp) {
@@ -403,7 +403,7 @@ static int __init sc1200wdt_init(void)
 #endif
 
 	if (io == -1) {
-		printk(KERN_ERR PFX "io parameter must be specified\n");
+		pr_err(PFX "io parameter must be specified\n");
 		ret = -EINVAL;
 		goto out_pnp;
 	}
@@ -416,7 +416,7 @@ static int __init sc1200wdt_init(void)
 #endif
 
 	if (!request_region(io, io_len, SC1200_MODULE_NAME)) {
-		printk(KERN_ERR PFX "Unable to register IO port %#x\n", io);
+		pr_err(PFX "Unable to register IO port %#x\n", io);
 		ret = -EBUSY;
 		goto out_pnp;
 	}
@@ -427,14 +427,14 @@ static int __init sc1200wdt_init(void)
 
 	ret = register_reboot_notifier(&sc1200wdt_notifier);
 	if (ret) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"Unable to register reboot notifier err = %d\n", ret);
 		goto out_io;
 	}
 
 	ret = misc_register(&sc1200wdt_miscdev);
 	if (ret) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"Unable to register miscdev on minor %d\n",
 							WATCHDOG_MINOR);
 		goto out_rbt;
diff --git a/drivers/watchdog/sc520_wdt.c b/drivers/watchdog/sc520_wdt.c
index 52b63f2..ab50e9e 100644
--- a/drivers/watchdog/sc520_wdt.c
+++ b/drivers/watchdog/sc520_wdt.c
@@ -151,7 +151,7 @@ static void wdt_timer_ping(unsigned long data)
 		/* Re-set the timer interval */
 		mod_timer(&timer, jiffies + WDT_INTERVAL);
 	} else
-		printk(KERN_WARNING PFX
+		pr_warning(PFX
 			"Heartbeat lost! Will not ping the watchdog\n");
 }
 
@@ -187,7 +187,7 @@ static int wdt_startup(void)
 	/* Start the watchdog */
 	wdt_config(WDT_ENB | WDT_WRST_ENB | WDT_EXP_SEL_04);
 
-	printk(KERN_INFO PFX "Watchdog timer is now enabled.\n");
+	pr_info(PFX "Watchdog timer is now enabled.\n");
 	return 0;
 }
 
@@ -199,7 +199,7 @@ static int wdt_turnoff(void)
 	/* Stop the watchdog */
 	wdt_config(0);
 
-	printk(KERN_INFO PFX "Watchdog timer is now disabled...\n");
+	pr_info(PFX "Watchdog timer is now disabled...\n");
 	return 0;
 }
 
@@ -270,7 +270,7 @@ static int fop_close(struct inode *inode, struct file *file)
 	if (wdt_expect_close == 42)
 		wdt_turnoff();
 	else {
-		printk(KERN_CRIT PFX
+		pr_crit(PFX
 			"Unexpected close, not stopping watchdog!\n");
 		wdt_keepalive();
 	}
@@ -393,34 +393,34 @@ static int __init sc520_wdt_init(void)
 	   if not reset to the default */
 	if (wdt_set_heartbeat(timeout)) {
 		wdt_set_heartbeat(WATCHDOG_TIMEOUT);
-		printk(KERN_INFO PFX
+		pr_info(PFX
 		    "timeout value must be 1 <= timeout <= 3600, using %d\n",
 							WATCHDOG_TIMEOUT);
 	}
 
 	wdtmrctl = ioremap((unsigned long)(MMCR_BASE + OFFS_WDTMRCTL), 2);
 	if (!wdtmrctl) {
-		printk(KERN_ERR PFX "Unable to remap memory\n");
+		pr_err(PFX "Unable to remap memory\n");
 		rc = -ENOMEM;
 		goto err_out_region2;
 	}
 
 	rc = register_reboot_notifier(&wdt_notifier);
 	if (rc) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"cannot register reboot notifier (err=%d)\n", rc);
 		goto err_out_ioremap;
 	}
 
 	rc = misc_register(&wdt_miscdev);
 	if (rc) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"cannot register miscdev on minor=%d (err=%d)\n",
 							WATCHDOG_MINOR, rc);
 		goto err_out_notifier;
 	}
 
-	printk(KERN_INFO PFX
+	pr_info(PFX
 	   "WDT driver for SC520 initialised. timeout=%d sec (nowayout=%d)\n",
 							timeout, nowayout);
 
diff --git a/drivers/watchdog/sch311x_wdt.c b/drivers/watchdog/sch311x_wdt.c
index 569eb29..3a15d36 100644
--- a/drivers/watchdog/sch311x_wdt.c
+++ b/drivers/watchdog/sch311x_wdt.c
@@ -323,7 +323,7 @@ static int sch311x_wdt_close(struct inode *inode, struct file *file)
 	if (sch311x_wdt_expect_close == 42) {
 		sch311x_wdt_stop();
 	} else {
-		printk(KERN_CRIT PFX
+		pr_crit(PFX
 				"Unexpected close, not stopping watchdog!\n");
 		sch311x_wdt_keepalive();
 	}
@@ -509,19 +509,19 @@ static int __init sch311x_detect(int sio_config_port, unsigned short *addr)
 
 	/* Check if Logical Device Register is currently active */
 	if (sch311x_sio_inb(sio_config_port, 0x30) && 0x01 == 0)
-		printk(KERN_INFO PFX "Seems that LDN 0x0a is not active...\n");
+		pr_info(PFX "Seems that LDN 0x0a is not active...\n");
 
 	/* Get the base address of the runtime registers */
 	base_addr = (sch311x_sio_inb(sio_config_port, 0x60) << 8) |
 			   sch311x_sio_inb(sio_config_port, 0x61);
 	if (!base_addr) {
-		printk(KERN_ERR PFX "Base address not set.\n");
+		pr_err(PFX "Base address not set.\n");
 		err = -ENODEV;
 		goto exit;
 	}
 	*addr = base_addr;
 
-	printk(KERN_INFO PFX "Found an SMSC SCH311%d chip at 0x%04x\n",
+	pr_info(PFX "Found an SMSC SCH311%d chip at 0x%04x\n",
 		dev_id, base_addr);
 
 exit:
diff --git a/drivers/watchdog/scx200_wdt.c b/drivers/watchdog/scx200_wdt.c
index e67b76c..aa7d002 100644
--- a/drivers/watchdog/scx200_wdt.c
+++ b/drivers/watchdog/scx200_wdt.c
@@ -66,7 +66,7 @@ static void scx200_wdt_ping(void)
 
 static void scx200_wdt_update_margin(void)
 {
-	printk(KERN_INFO NAME ": timer margin %d seconds\n", margin);
+	pr_info(NAME ": timer margin %d seconds\n", margin);
 	wdto_restart = margin * W_SCALE;
 }
 
@@ -108,7 +108,7 @@ static int scx200_wdt_open(struct inode *inode, struct file *file)
 static int scx200_wdt_release(struct inode *inode, struct file *file)
 {
 	if (expect_close != 42)
-		printk(KERN_WARNING NAME
+		pr_warning(NAME
 			": watchdog device closed unexpectedly, "
 			"will not disable the watchdog timer\n");
 	else if (!nowayout)
@@ -228,7 +228,7 @@ static int __init scx200_wdt_init(void)
 	if (!request_region(scx200_cb_base + SCx200_WDT_OFFSET,
 			    SCx200_WDT_SIZE,
 			    "NatSemi SCx200 Watchdog")) {
-		printk(KERN_WARNING NAME ": watchdog I/O region busy\n");
+		pr_warning(NAME ": watchdog I/O region busy\n");
 		return -EBUSY;
 	}
 
@@ -237,7 +237,7 @@ static int __init scx200_wdt_init(void)
 
 	r = register_reboot_notifier(&scx200_wdt_notifier);
 	if (r) {
-		printk(KERN_ERR NAME ": unable to register reboot notifier");
+		pr_err(NAME ": unable to register reboot notifier");
 		release_region(scx200_cb_base + SCx200_WDT_OFFSET,
 				SCx200_WDT_SIZE);
 		return r;
diff --git a/drivers/watchdog/shwdt.c b/drivers/watchdog/shwdt.c
index a03f84e..0203950 100644
--- a/drivers/watchdog/shwdt.c
+++ b/drivers/watchdog/shwdt.c
@@ -201,7 +201,7 @@ static void sh_wdt_ping(unsigned long data)
 
 		mod_timer(&timer, next_ping_period(clock_division_ratio));
 	} else
-		printk(KERN_WARNING PFX "Heartbeat lost! Will not ping "
+		pr_warning(PFX "Heartbeat lost! Will not ping "
 		       "the watchdog\n");
 	spin_unlock_irqrestore(&shwdt_lock, flags);
 }
@@ -237,7 +237,7 @@ static int sh_wdt_close(struct inode *inode, struct file *file)
 	if (shwdt_expect_close == 42) {
 		sh_wdt_stop();
 	} else {
-		printk(KERN_CRIT PFX "Unexpected close, not "
+		pr_crit(PFX "Unexpected close, not "
 		       "stopping watchdog!\n");
 		sh_wdt_keepalive();
 	}
@@ -318,7 +318,7 @@ static int sh_wdt_mmap(struct file *file, struct vm_area_struct *vma)
 
 	if (io_remap_pfn_range(vma, vma->vm_start, addr >> PAGE_SHIFT,
 			       PAGE_SIZE, vma->vm_page_prot)) {
-		printk(KERN_ERR PFX "%s: io_remap_pfn_range failed\n",
+		pr_err(PFX "%s: io_remap_pfn_range failed\n",
 		       __func__);
 		return -EAGAIN;
 	}
@@ -442,7 +442,7 @@ static int __init sh_wdt_init(void)
 
 	if (clock_division_ratio < 0x5 || clock_division_ratio > 0x7) {
 		clock_division_ratio = WTCSR_CKS_4096;
-		printk(KERN_INFO PFX
+		pr_info(PFX
 		  "clock_division_ratio value must be 0x5<=x<=0x7, using %d\n",
 				clock_division_ratio);
 	}
@@ -450,28 +450,28 @@ static int __init sh_wdt_init(void)
 	rc = sh_wdt_set_heartbeat(heartbeat);
 	if (unlikely(rc)) {
 		heartbeat = WATCHDOG_HEARTBEAT;
-		printk(KERN_INFO PFX
+		pr_info(PFX
 			"heartbeat value must be 1<=x<=3600, using %d\n",
 								heartbeat);
 	}
 
 	rc = register_reboot_notifier(&sh_wdt_notifier);
 	if (unlikely(rc)) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"Can't register reboot notifier (err=%d)\n", rc);
 		return rc;
 	}
 
 	rc = misc_register(&sh_wdt_miscdev);
 	if (unlikely(rc)) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"Can't register miscdev on minor=%d (err=%d)\n",
 						sh_wdt_miscdev.minor, rc);
 		unregister_reboot_notifier(&sh_wdt_notifier);
 		return rc;
 	}
 
-	printk(KERN_INFO PFX "initialized. heartbeat=%d sec (nowayout=%d)\n",
+	pr_info(PFX "initialized. heartbeat=%d sec (nowayout=%d)\n",
 		heartbeat, nowayout);
 
 	return 0;
diff --git a/drivers/watchdog/smsc37b787_wdt.c b/drivers/watchdog/smsc37b787_wdt.c
index 8a1f0bc..7d2171e 100644
--- a/drivers/watchdog/smsc37b787_wdt.c
+++ b/drivers/watchdog/smsc37b787_wdt.c
@@ -363,7 +363,7 @@ static int wb_smsc_wdt_open(struct inode *inode, struct file *file)
 	/* Reload and activate timer */
 	wb_smsc_wdt_enable();
 
-	printk(KERN_INFO MODNAME
+	pr_info(MODNAME
 		"Watchdog enabled. Timeout set to %d %s.\n",
 		timeout, (unit == UNIT_SECOND) ? "second(s)" : "minute(s)");
 
@@ -378,10 +378,10 @@ static int wb_smsc_wdt_release(struct inode *inode, struct file *file)
 
 	if (expect_close == 42) {
 		wb_smsc_wdt_disable();
-		printk(KERN_INFO MODNAME
+		pr_info(MODNAME
 				"Watchdog disabled, sleeping again...\n");
 	} else {
-		printk(KERN_CRIT MODNAME
+		pr_crit(MODNAME
 				"Unexpected close, not stopping watchdog!\n");
 		wb_smsc_wdt_reset_timer();
 	}
@@ -534,11 +534,11 @@ static int __init wb_smsc_wdt_init(void)
 {
 	int ret;
 
-	printk(KERN_INFO "SMsC 37B787 watchdog component driver "
+	pr_info("SMsC 37B787 watchdog component driver "
 					VERSION " initialising...\n");
 
 	if (!request_region(IOPORT, IOPORT_SIZE, "SMsC 37B787 watchdog")) {
-		printk(KERN_ERR MODNAME "Unable to register IO port %#x\n",
+		pr_err(MODNAME "Unable to register IO port %#x\n",
 								IOPORT);
 		ret = -EBUSY;
 		goto out_pnp;
@@ -553,23 +553,23 @@ static int __init wb_smsc_wdt_init(void)
 
 	ret = register_reboot_notifier(&wb_smsc_wdt_notifier);
 	if (ret) {
-		printk(KERN_ERR MODNAME
+		pr_err(MODNAME
 			"Unable to register reboot notifier err = %d\n", ret);
 		goto out_io;
 	}
 
 	ret = misc_register(&wb_smsc_wdt_miscdev);
 	if (ret) {
-		printk(KERN_ERR MODNAME
+		pr_err(MODNAME
 			"Unable to register miscdev on minor %d\n",
 							WATCHDOG_MINOR);
 		goto out_rbt;
 	}
 
 	/* output info */
-	printk(KERN_INFO MODNAME "Timeout set to %d %s.\n",
+	pr_info(MODNAME "Timeout set to %d %s.\n",
 		timeout, (unit == UNIT_SECOND) ? "second(s)" : "minute(s)");
-	printk(KERN_INFO MODNAME
+	pr_info(MODNAME
 		"Watchdog initialized and sleeping (nowayout=%d)...\n",
 								nowayout);
 out_clean:
@@ -592,14 +592,14 @@ static void __exit wb_smsc_wdt_exit(void)
 	/* Stop the timer before we leave */
 	if (!nowayout) {
 		wb_smsc_wdt_shutdown();
-		printk(KERN_INFO MODNAME "Watchdog disabled.\n");
+		pr_info(MODNAME "Watchdog disabled.\n");
 	}
 
 	misc_deregister(&wb_smsc_wdt_miscdev);
 	unregister_reboot_notifier(&wb_smsc_wdt_notifier);
 	release_region(IOPORT, IOPORT_SIZE);
 
-	printk(KERN_INFO "SMsC 37B787 watchdog component driver removed.\n");
+	pr_info("SMsC 37B787 watchdog component driver removed.\n");
 }
 
 module_init(wb_smsc_wdt_init);
diff --git a/drivers/watchdog/softdog.c b/drivers/watchdog/softdog.c
index 833f49f..d6688cd 100644
--- a/drivers/watchdog/softdog.c
+++ b/drivers/watchdog/softdog.c
@@ -97,11 +97,11 @@ static void watchdog_fire(unsigned long data)
 		module_put(THIS_MODULE);
 
 	if (soft_noboot)
-		printk(KERN_CRIT PFX "Triggered - Reboot ignored.\n");
+		pr_crit(PFX "Triggered - Reboot ignored.\n");
 	else {
-		printk(KERN_CRIT PFX "Initiating system reboot.\n");
+		pr_crit(PFX "Initiating system reboot.\n");
 		emergency_restart();
-		printk(KERN_CRIT PFX "Reboot didn't ?????\n");
+		pr_crit(PFX "Reboot didn't ?????\n");
 	}
 }
 
@@ -157,7 +157,7 @@ static int softdog_release(struct inode *inode, struct file *file)
 		softdog_stop();
 		module_put(THIS_MODULE);
 	} else {
-		printk(KERN_CRIT PFX
+		pr_crit(PFX
 			"Unexpected close, not stopping watchdog!\n");
 		set_bit(0, &orphan_timer);
 		softdog_keepalive();
@@ -277,21 +277,21 @@ static int __init watchdog_init(void)
 	   if not reset to the default */
 	if (softdog_set_heartbeat(soft_margin)) {
 		softdog_set_heartbeat(TIMER_MARGIN);
-		printk(KERN_INFO PFX
+		pr_info(PFX
 		    "soft_margin must be 0 < soft_margin < 65536, using %d\n",
 			TIMER_MARGIN);
 	}
 
 	ret = register_reboot_notifier(&softdog_notifier);
 	if (ret) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"cannot register reboot notifier (err=%d)\n", ret);
 		return ret;
 	}
 
 	ret = misc_register(&softdog_miscdev);
 	if (ret) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"cannot register miscdev on minor=%d (err=%d)\n",
 						WATCHDOG_MINOR, ret);
 		unregister_reboot_notifier(&softdog_notifier);
diff --git a/drivers/watchdog/stmp3xxx_wdt.c b/drivers/watchdog/stmp3xxx_wdt.c
index 5dd9526..b53b1fd 100644
--- a/drivers/watchdog/stmp3xxx_wdt.c
+++ b/drivers/watchdog/stmp3xxx_wdt.c
@@ -220,7 +220,7 @@ static int __devinit stmp3xxx_wdt_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	printk(KERN_INFO "stmp3xxx watchdog: initialized, heartbeat %d sec\n",
+	pr_info("stmp3xxx watchdog: initialized, heartbeat %d sec\n",
 		heartbeat);
 
 	return ret;
diff --git a/drivers/watchdog/txx9wdt.c b/drivers/watchdog/txx9wdt.c
index 6adab77..0a3cbed 100644
--- a/drivers/watchdog/txx9wdt.c
+++ b/drivers/watchdog/txx9wdt.c
@@ -97,7 +97,7 @@ static int txx9wdt_release(struct inode *inode, struct file *file)
 	if (expect_close)
 		txx9wdt_stop();
 	else {
-		printk(KERN_CRIT "txx9wdt: "
+		pr_crit("txx9wdt: "
 		       "Unexpected close, not stopping watchdog!\n");
 		txx9wdt_ping();
 	}
@@ -233,7 +233,7 @@ static int __init txx9wdt_probe(struct platform_device *dev)
 		goto exit;
 	}
 
-	printk(KERN_INFO "Hardware Watchdog Timer for TXx9: "
+	pr_info("Hardware Watchdog Timer for TXx9: "
 	       "timeout=%d sec (max %ld) (nowayout= %d)\n",
 	       timeout, WD_MAX_TIMEOUT, nowayout);
 
diff --git a/drivers/watchdog/w83627hf_wdt.c b/drivers/watchdog/w83627hf_wdt.c
index f201acc..8f134e4 100644
--- a/drivers/watchdog/w83627hf_wdt.c
+++ b/drivers/watchdog/w83627hf_wdt.c
@@ -119,7 +119,7 @@ static void w83627hf_init(void)
 	outb_p(0xF6, WDT_EFER); /* Select CRF6 */
 	t = inb_p(WDT_EFDR);      /* read CRF6 */
 	if (t != 0) {
-		printk(KERN_INFO PFX
+		pr_info(PFX
 		     "Watchdog already running. Resetting timeout to %d sec\n",
 								timeout);
 		outb_p(timeout, WDT_EFDR);    /* Write back to CRF6 */
@@ -267,7 +267,7 @@ static int wdt_close(struct inode *inode, struct file *file)
 	if (expect_close == 42)
 		wdt_disable();
 	else {
-		printk(KERN_CRIT PFX
+		pr_crit(PFX
 			"Unexpected close, not stopping watchdog!\n");
 		wdt_ping();
 	}
@@ -321,17 +321,17 @@ static int __init wdt_init(void)
 {
 	int ret;
 
-	printk(KERN_INFO "WDT driver for the Winbond(TM) W83627HF/THF/HG Super I/O chip initialising.\n");
+	pr_info("WDT driver for the Winbond(TM) W83627HF/THF/HG Super I/O chip initialising.\n");
 
 	if (wdt_set_heartbeat(timeout)) {
 		wdt_set_heartbeat(WATCHDOG_TIMEOUT);
-		printk(KERN_INFO PFX
+		pr_info(PFX
 		     "timeout value must be 1 <= timeout <= 255, using %d\n",
 				WATCHDOG_TIMEOUT);
 	}
 
 	if (!request_region(wdt_io, 1, WATCHDOG_NAME)) {
-		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
+		pr_err(PFX "I/O address 0x%04x already in use\n",
 			wdt_io);
 		ret = -EIO;
 		goto out;
@@ -341,20 +341,20 @@ static int __init wdt_init(void)
 
 	ret = register_reboot_notifier(&wdt_notifier);
 	if (ret != 0) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"cannot register reboot notifier (err=%d)\n", ret);
 		goto unreg_regions;
 	}
 
 	ret = misc_register(&wdt_miscdev);
 	if (ret != 0) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"cannot register miscdev on minor=%d (err=%d)\n",
 							WATCHDOG_MINOR, ret);
 		goto unreg_reboot;
 	}
 
-	printk(KERN_INFO PFX
+	pr_info(PFX
 			"initialized. timeout=%d sec (nowayout=%d)\n",
 							timeout, nowayout);
 
diff --git a/drivers/watchdog/w83697hf_wdt.c b/drivers/watchdog/w83697hf_wdt.c
index af08972..b77a88d 100644
--- a/drivers/watchdog/w83697hf_wdt.c
+++ b/drivers/watchdog/w83697hf_wdt.c
@@ -309,7 +309,7 @@ static int wdt_close(struct inode *inode, struct file *file)
 	if (expect_close == 42)
 		wdt_disable();
 	else {
-		printk(KERN_CRIT PFX
+		pr_crit(PFX
 			"Unexpected close, not stopping watchdog!\n");
 		wdt_ping();
 	}
@@ -362,7 +362,7 @@ static struct notifier_block wdt_notifier = {
 static int w83697hf_check_wdt(void)
 {
 	if (!request_region(wdt_io, 2, WATCHDOG_NAME)) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"I/O address 0x%x already in use\n", wdt_io);
 		return -EIO;
 	}
@@ -371,7 +371,7 @@ static int w83697hf_check_wdt(void)
 			"Looking for watchdog at address 0x%x\n", wdt_io);
 	w83697hf_unlock();
 	if (w83697hf_get_reg(0x20) == 0x60) {
-		printk(KERN_INFO PFX
+		pr_info(PFX
 			"watchdog found at address 0x%x\n", wdt_io);
 		w83697hf_lock();
 		return 0;
@@ -379,7 +379,7 @@ static int w83697hf_check_wdt(void)
 	/* Reprotect in case it was a compatible device */
 	w83697hf_lock();
 
-	printk(KERN_INFO PFX "watchdog not found at address 0x%x\n", wdt_io);
+	pr_info(PFX "watchdog not found at address 0x%x\n", wdt_io);
 	release_region(wdt_io, 2);
 	return -EIO;
 }
@@ -390,7 +390,7 @@ static int __init wdt_init(void)
 {
 	int ret, i, found = 0;
 
-	printk(KERN_INFO PFX "WDT driver for W83697HF/HG initializing\n");
+	pr_info(PFX "WDT driver for W83697HF/HG initializing\n");
 
 	if (wdt_io == 0) {
 		/* we will autodetect the W83697HF/HG watchdog */
@@ -405,7 +405,7 @@ static int __init wdt_init(void)
 	}
 
 	if (!found) {
-		printk(KERN_ERR PFX "No W83697HF/HG could be found\n");
+		pr_err(PFX "No W83697HF/HG could be found\n");
 		ret = -EIO;
 		goto out;
 	}
@@ -413,34 +413,34 @@ static int __init wdt_init(void)
 	w83697hf_init();
 	if (early_disable) {
 		if (wdt_running())
-			printk(KERN_WARNING PFX "Stopping previously enabled "
+			pr_warning(PFX "Stopping previously enabled "
 					"watchdog until userland kicks in\n");
 		wdt_disable();
 	}
 
 	if (wdt_set_heartbeat(timeout)) {
 		wdt_set_heartbeat(WATCHDOG_TIMEOUT);
-		printk(KERN_INFO PFX
+		pr_info(PFX
 		     "timeout value must be 1 <= timeout <= 255, using %d\n",
 							WATCHDOG_TIMEOUT);
 	}
 
 	ret = register_reboot_notifier(&wdt_notifier);
 	if (ret != 0) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"cannot register reboot notifier (err=%d)\n", ret);
 		goto unreg_regions;
 	}
 
 	ret = misc_register(&wdt_miscdev);
 	if (ret != 0) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"cannot register miscdev on minor=%d (err=%d)\n",
 						WATCHDOG_MINOR, ret);
 		goto unreg_reboot;
 	}
 
-	printk(KERN_INFO PFX "initialized. timeout=%d sec (nowayout=%d)\n",
+	pr_info(PFX "initialized. timeout=%d sec (nowayout=%d)\n",
 		timeout, nowayout);
 
 out:
diff --git a/drivers/watchdog/w83697ug_wdt.c b/drivers/watchdog/w83697ug_wdt.c
index a6c12de..f091103 100644
--- a/drivers/watchdog/w83697ug_wdt.c
+++ b/drivers/watchdog/w83697ug_wdt.c
@@ -91,7 +91,7 @@ static int w83697ug_select_wd_register(void)
 	version = inb(WDT_EFDR);
 
 	if (version == 0x68) {	/* W83697UG 		*/
-		printk(KERN_INFO PFX "Watchdog chip version 0x%02x = "
+		pr_info(PFX "Watchdog chip version 0x%02x = "
 			"W83697UG/UF found at 0x%04x\n", version, wdt_io);
 
 		outb_p(0x2b, WDT_EFER);
@@ -101,7 +101,7 @@ static int w83697ug_select_wd_register(void)
 		outb_p(c, WDT_EFDR);	/* set pin118 to WDT0 */
 
 	} else {
-		printk(KERN_ERR PFX "No W83697UG/UF could be found\n");
+		pr_err(PFX "No W83697UG/UF could be found\n");
 		return -ENODEV;
 	}
 
@@ -131,7 +131,7 @@ static int w83697ug_init(void)
 	outb_p(0xF6, WDT_EFER); /* Select CRF6 */
 	t = inb_p(WDT_EFDR);    /* read CRF6 */
 	if (t != 0) {
-		printk(KERN_INFO PFX "Watchdog already running."
+		pr_info(PFX "Watchdog already running."
 			" Resetting timeout to %d sec\n", timeout);
 		outb_p(timeout, WDT_EFDR);    /* Write back to CRF6 */
 	}
@@ -286,7 +286,7 @@ static int wdt_close(struct inode *inode, struct file *file)
 	if (expect_close == 42)
 		wdt_disable();
 	else {
-		printk(KERN_CRIT PFX
+		pr_crit(PFX
 			"Unexpected close, not stopping watchdog!\n");
 		wdt_ping();
 	}
@@ -340,17 +340,17 @@ static int __init wdt_init(void)
 {
 	int ret;
 
-	printk(KERN_INFO "WDT driver for the Winbond(TM) W83697UG/UF Super I/O chip initialising.\n");
+	pr_info("WDT driver for the Winbond(TM) W83697UG/UF Super I/O chip initialising.\n");
 
 	if (wdt_set_heartbeat(timeout)) {
 		wdt_set_heartbeat(WATCHDOG_TIMEOUT);
-		printk(KERN_INFO PFX
+		pr_info(PFX
 			"timeout value must be 1<=timeout<=255, using %d\n",
 			WATCHDOG_TIMEOUT);
 	}
 
 	if (!request_region(wdt_io, 1, WATCHDOG_NAME)) {
-		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
+		pr_err(PFX "I/O address 0x%04x already in use\n",
 			wdt_io);
 		ret = -EIO;
 		goto out;
@@ -362,20 +362,20 @@ static int __init wdt_init(void)
 
 	ret = register_reboot_notifier(&wdt_notifier);
 	if (ret != 0) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"cannot register reboot notifier (err=%d)\n", ret);
 		goto unreg_regions;
 	}
 
 	ret = misc_register(&wdt_miscdev);
 	if (ret != 0) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"cannot register miscdev on minor=%d (err=%d)\n",
 			WATCHDOG_MINOR, ret);
 		goto unreg_reboot;
 	}
 
-	printk(KERN_INFO PFX "initialized. timeout=%d sec (nowayout=%d)\n",
+	pr_info(PFX "initialized. timeout=%d sec (nowayout=%d)\n",
 		timeout, nowayout);
 
 out:
diff --git a/drivers/watchdog/w83877f_wdt.c b/drivers/watchdog/w83877f_wdt.c
index 24587d2..0bc34b7 100644
--- a/drivers/watchdog/w83877f_wdt.c
+++ b/drivers/watchdog/w83877f_wdt.c
@@ -126,7 +126,7 @@ static void wdt_timer_ping(unsigned long data)
 		spin_unlock(&wdt_spinlock);
 
 	} else
-		printk(KERN_WARNING PFX
+		pr_warning(PFX
 			"Heartbeat lost! Will not ping the watchdog\n");
 }
 
@@ -165,7 +165,7 @@ static void wdt_startup(void)
 
 	wdt_change(WDT_ENABLE);
 
-	printk(KERN_INFO PFX "Watchdog timer is now enabled.\n");
+	pr_info(PFX "Watchdog timer is now enabled.\n");
 }
 
 static void wdt_turnoff(void)
@@ -175,7 +175,7 @@ static void wdt_turnoff(void)
 
 	wdt_change(WDT_DISABLE);
 
-	printk(KERN_INFO PFX "Watchdog timer is now disabled...\n");
+	pr_info(PFX "Watchdog timer is now disabled...\n");
 }
 
 static void wdt_keepalive(void)
@@ -234,7 +234,7 @@ static int fop_close(struct inode *inode, struct file *file)
 		wdt_turnoff();
 	else {
 		del_timer(&timer);
-		printk(KERN_CRIT PFX
+		pr_crit(PFX
 		  "device file closed unexpectedly. Will not stop the WDT!\n");
 	}
 	clear_bit(0, &wdt_is_open);
@@ -357,20 +357,20 @@ static int __init w83877f_wdt_init(void)
 
 	if (timeout < 1 || timeout > 3600) { /* arbitrary upper limit */
 		timeout = WATCHDOG_TIMEOUT;
-		printk(KERN_INFO PFX
+		pr_info(PFX
 			"timeout value must be 1 <= x <= 3600, using %d\n",
 							timeout);
 	}
 
 	if (!request_region(ENABLE_W83877F_PORT, 2, "W83877F WDT")) {
-		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
+		pr_err(PFX "I/O address 0x%04x already in use\n",
 			ENABLE_W83877F_PORT);
 		rc = -EIO;
 		goto err_out;
 	}
 
 	if (!request_region(WDT_PING, 1, "W8387FF WDT")) {
-		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
+		pr_err(PFX "I/O address 0x%04x already in use\n",
 			WDT_PING);
 		rc = -EIO;
 		goto err_out_region1;
@@ -378,20 +378,20 @@ static int __init w83877f_wdt_init(void)
 
 	rc = register_reboot_notifier(&wdt_notifier);
 	if (rc) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"cannot register reboot notifier (err=%d)\n", rc);
 		goto err_out_region2;
 	}
 
 	rc = misc_register(&wdt_miscdev);
 	if (rc) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"cannot register miscdev on minor=%d (err=%d)\n",
 							wdt_miscdev.minor, rc);
 		goto err_out_reboot;
 	}
 
-	printk(KERN_INFO PFX
+	pr_info(PFX
 	  "WDT driver for W83877F initialised. timeout=%d sec (nowayout=%d)\n",
 		timeout, nowayout);
 
diff --git a/drivers/watchdog/w83977f_wdt.c b/drivers/watchdog/w83977f_wdt.c
index 0560182..59ce385 100644
--- a/drivers/watchdog/w83977f_wdt.c
+++ b/drivers/watchdog/w83977f_wdt.c
@@ -131,7 +131,7 @@ static int wdt_start(void)
 
 	spin_unlock_irqrestore(&spinlock, flags);
 
-	printk(KERN_INFO PFX "activated.\n");
+	pr_info(PFX "activated.\n");
 
 	return 0;
 }
@@ -185,7 +185,7 @@ static int wdt_stop(void)
 
 	spin_unlock_irqrestore(&spinlock, flags);
 
-	printk(KERN_INFO PFX "shutdown.\n");
+	pr_info(PFX "shutdown.\n");
 
 	return 0;
 }
@@ -313,7 +313,7 @@ static int wdt_release(struct inode *inode, struct file *file)
 		clear_bit(0, &timer_alive);
 	} else {
 		wdt_keepalive();
-		printk(KERN_CRIT PFX
+		pr_crit(PFX
 			"unexpected close, not stopping watchdog!\n");
 	}
 	expect_close = 0;
@@ -471,7 +471,7 @@ static int __init w83977f_wdt_init(void)
 {
 	int rc;
 
-	printk(KERN_INFO PFX DRIVER_VERSION);
+	pr_info(PFX DRIVER_VERSION);
 
 	/*
 	 * Check that the timeout value is within it's range;
@@ -479,13 +479,13 @@ static int __init w83977f_wdt_init(void)
 	 */
 	if (wdt_set_timeout(timeout)) {
 		wdt_set_timeout(DEFAULT_TIMEOUT);
-		printk(KERN_INFO PFX
+		pr_info(PFX
 		    "timeout value must be 15 <= timeout <= 7635, using %d\n",
 							DEFAULT_TIMEOUT);
 	}
 
 	if (!request_region(IO_INDEX_PORT, 2, WATCHDOG_NAME)) {
-		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
+		pr_err(PFX "I/O address 0x%04x already in use\n",
 			IO_INDEX_PORT);
 		rc = -EIO;
 		goto err_out;
@@ -493,20 +493,20 @@ static int __init w83977f_wdt_init(void)
 
 	rc = register_reboot_notifier(&wdt_notifier);
 	if (rc) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"cannot register reboot notifier (err=%d)\n", rc);
 		goto err_out_region;
 	}
 
 	rc = misc_register(&wdt_miscdev);
 	if (rc) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"cannot register miscdev on minor=%d (err=%d)\n",
 						wdt_miscdev.minor, rc);
 		goto err_out_reboot;
 	}
 
-	printk(KERN_INFO PFX
+	pr_info(PFX
 		"initialized. timeout=%d sec (nowayout=%d testmode=%d)\n",
 					timeout, nowayout, testmode);
 
diff --git a/drivers/watchdog/wafer5823wdt.c b/drivers/watchdog/wafer5823wdt.c
index 42e940c..8ab2038 100644
--- a/drivers/watchdog/wafer5823wdt.c
+++ b/drivers/watchdog/wafer5823wdt.c
@@ -203,7 +203,7 @@ static int wafwdt_close(struct inode *inode, struct file *file)
 	if (expect_close == 42)
 		wafwdt_stop();
 	else {
-		printk(KERN_CRIT PFX
+		pr_crit(PFX
 		    "WDT device closed unexpectedly.  WDT will not stop!\n");
 		wafwdt_ping();
 	}
@@ -256,19 +256,18 @@ static int __init wafwdt_init(void)
 {
 	int ret;
 
-	printk(KERN_INFO
-	  "WDT driver for Wafer 5823 single board computer initialising.\n");
+	pr_info("WDT driver for Wafer 5823 single board computer initialising.\n");
 
 	if (timeout < 1 || timeout > 255) {
 		timeout = WD_TIMO;
-		printk(KERN_INFO PFX
+		pr_info(PFX
 			"timeout value must be 1 <= x <= 255, using %d\n",
 								timeout);
 	}
 
 	if (wdt_stop != wdt_start) {
 		if (!request_region(wdt_stop, 1, "Wafer 5823 WDT")) {
-			printk(KERN_ERR PFX
+			pr_err(PFX
 				"I/O address 0x%04x already in use\n",
 								wdt_stop);
 			ret = -EIO;
@@ -277,7 +276,7 @@ static int __init wafwdt_init(void)
 	}
 
 	if (!request_region(wdt_start, 1, "Wafer 5823 WDT")) {
-		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
+		pr_err(PFX "I/O address 0x%04x already in use\n",
 			wdt_start);
 		ret = -EIO;
 		goto error2;
@@ -285,20 +284,20 @@ static int __init wafwdt_init(void)
 
 	ret = register_reboot_notifier(&wafwdt_notifier);
 	if (ret != 0) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"cannot register reboot notifier (err=%d)\n", ret);
 		goto error3;
 	}
 
 	ret = misc_register(&wafwdt_miscdev);
 	if (ret != 0) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"cannot register miscdev on minor=%d (err=%d)\n",
 						WATCHDOG_MINOR, ret);
 		goto error4;
 	}
 
-	printk(KERN_INFO PFX "initialized. timeout=%d sec (nowayout=%d)\n",
+	pr_info(PFX "initialized. timeout=%d sec (nowayout=%d)\n",
 		timeout, nowayout);
 
 	return ret;
diff --git a/drivers/watchdog/wdrtas.c b/drivers/watchdog/wdrtas.c
index 3bde56b..6220837 100644
--- a/drivers/watchdog/wdrtas.c
+++ b/drivers/watchdog/wdrtas.c
@@ -93,7 +93,7 @@ static int wdrtas_set_interval(int interval)
 	result = rtas_call(wdrtas_token_set_indicator, 3, 1, NULL,
 			   WDRTAS_SURVEILLANCE_IND, 0, interval);
 	if (result < 0 && print_msg) {
-		printk(KERN_ERR "wdrtas: setting the watchdog to %i "
+		pr_err("wdrtas: setting the watchdog to %i "
 		       "timeout failed: %li\n", interval, result);
 		print_msg--;
 	}
@@ -128,7 +128,7 @@ static int wdrtas_get_interval(int fallback_value)
 	spin_unlock(&rtas_data_buf_lock);
 
 	if (value[0] != 0 || value[1] != 2 || value[3] != 0 || result < 0) {
-		printk(KERN_WARNING "wdrtas: could not get sp_spi watchdog "
+		pr_warning("wdrtas: could not get sp_spi watchdog "
 		       "timeout (%li). Continuing\n", result);
 		return fallback_value;
 	}
@@ -170,7 +170,7 @@ static void wdrtas_log_scanned_event(void)
 	int i;
 
 	for (i = 0; i < WDRTAS_LOGBUFFER_LEN; i += 16)
-		printk(KERN_INFO "wdrtas: dumping event (line %i/%i), data = "
+		pr_info("wdrtas: dumping event (line %i/%i), data = "
 		       "%02x %02x %02x %02x  %02x %02x %02x %02x   "
 		       "%02x %02x %02x %02x  %02x %02x %02x %02x\n",
 		       (i / 16) + 1, (WDRTAS_LOGBUFFER_LEN / 16),
@@ -201,7 +201,7 @@ static void wdrtas_timer_keepalive(void)
 				   (void *)__pa(wdrtas_logbuffer),
 				   WDRTAS_LOGBUFFER_LEN);
 		if (result < 0)
-			printk(KERN_ERR "wdrtas: event-scan failed: %li\n",
+			pr_err("wdrtas: event-scan failed: %li\n",
 			       result);
 		if (result == 0)
 			wdrtas_log_scanned_event();
@@ -224,7 +224,7 @@ static int wdrtas_get_temperature(void)
 	result = rtas_get_sensor(WDRTAS_THERMAL_SENSOR, 0, &temperature);
 
 	if (result < 0)
-		printk(KERN_WARNING "wdrtas: reading the thermal sensor "
+		pr_warning("wdrtas: reading the thermal sensor "
 		       "failed: %i\n", result);
 	else
 		temperature = ((temperature * 9) / 5) + 32; /* fahrenheit */
@@ -419,7 +419,7 @@ static int wdrtas_close(struct inode *inode, struct file *file)
 	if (wdrtas_expect_close == WDRTAS_MAGIC_CHAR)
 		wdrtas_timer_stop();
 	else {
-		printk(KERN_WARNING "wdrtas: got unexpected close. Watchdog "
+		pr_warning("wdrtas: got unexpected close. Watchdog "
 		       "not stopped.\n");
 		wdrtas_timer_keepalive();
 	}
@@ -552,14 +552,14 @@ static int wdrtas_get_tokens(void)
 {
 	wdrtas_token_get_sensor_state = rtas_token("get-sensor-state");
 	if (wdrtas_token_get_sensor_state == RTAS_UNKNOWN_SERVICE) {
-		printk(KERN_WARNING "wdrtas: couldn't get token for "
+		pr_warning("wdrtas: couldn't get token for "
 		       "get-sensor-state. Trying to continue without "
 		       "temperature support.\n");
 	}
 
 	wdrtas_token_get_sp = rtas_token("ibm,get-system-parameter");
 	if (wdrtas_token_get_sp == RTAS_UNKNOWN_SERVICE) {
-		printk(KERN_WARNING "wdrtas: couldn't get token for "
+		pr_warning("wdrtas: couldn't get token for "
 		       "ibm,get-system-parameter. Trying to continue with "
 		       "a default timeout value of %i seconds.\n",
 		       WDRTAS_DEFAULT_INTERVAL);
@@ -567,14 +567,14 @@ static int wdrtas_get_tokens(void)
 
 	wdrtas_token_set_indicator = rtas_token("set-indicator");
 	if (wdrtas_token_set_indicator == RTAS_UNKNOWN_SERVICE) {
-		printk(KERN_ERR "wdrtas: couldn't get token for "
+		pr_err("wdrtas: couldn't get token for "
 		       "set-indicator. Terminating watchdog code.\n");
 		return -EIO;
 	}
 
 	wdrtas_token_event_scan = rtas_token("event-scan");
 	if (wdrtas_token_event_scan == RTAS_UNKNOWN_SERVICE) {
-		printk(KERN_ERR "wdrtas: couldn't get token for event-scan. "
+		pr_err("wdrtas: couldn't get token for event-scan. "
 		       "Terminating watchdog code.\n");
 		return -EIO;
 	}
@@ -609,7 +609,7 @@ static int wdrtas_register_devs(void)
 
 	result = misc_register(&wdrtas_miscdev);
 	if (result) {
-		printk(KERN_ERR "wdrtas: couldn't register watchdog misc "
+		pr_err("wdrtas: couldn't register watchdog misc "
 		       "device. Terminating watchdog code.\n");
 		return result;
 	}
@@ -617,7 +617,7 @@ static int wdrtas_register_devs(void)
 	if (wdrtas_token_get_sensor_state != RTAS_UNKNOWN_SERVICE) {
 		result = misc_register(&wdrtas_tempdev);
 		if (result) {
-			printk(KERN_WARNING "wdrtas: couldn't register "
+			pr_warning("wdrtas: couldn't register "
 			       "watchdog temperature misc device. Continuing "
 			       "without temperature support.\n");
 			wdrtas_token_get_sensor_state = RTAS_UNKNOWN_SERVICE;
@@ -643,7 +643,7 @@ static int __init wdrtas_init(void)
 		return -ENODEV;
 
 	if (register_reboot_notifier(&wdrtas_notifier)) {
-		printk(KERN_ERR "wdrtas: could not register reboot notifier. "
+		pr_err("wdrtas: could not register reboot notifier. "
 		       "Terminating watchdog code.\n");
 		wdrtas_unregister_devs();
 		return -ENODEV;
diff --git a/drivers/watchdog/wdt.c b/drivers/watchdog/wdt.c
index 3bbefe9..f623015 100644
--- a/drivers/watchdog/wdt.c
+++ b/drivers/watchdog/wdt.c
@@ -252,11 +252,11 @@ static int wdt_get_temperature(void)
 static void wdt_decode_501(int status)
 {
 	if (!(status & WDC_SR_TGOOD))
-		printk(KERN_CRIT "Overheat alarm.(%d)\n", inb_p(WDT_RT));
+		pr_crit("Overheat alarm.(%d)\n", inb_p(WDT_RT));
 	if (!(status & WDC_SR_PSUOVER))
-		printk(KERN_CRIT "PSU over voltage.\n");
+		pr_crit("PSU over voltage.\n");
 	if (!(status & WDC_SR_PSUUNDR))
-		printk(KERN_CRIT "PSU under voltage.\n");
+		pr_crit("PSU under voltage.\n");
 }
 
 /**
@@ -280,25 +280,25 @@ static irqreturn_t wdt_interrupt(int irq, void *dev_id)
 	spin_lock(&wdt_lock);
 	status = inb_p(WDT_SR);
 
-	printk(KERN_CRIT "WDT status %d\n", status);
+	pr_crit("WDT status %d\n", status);
 
 	if (type == 501) {
 		wdt_decode_501(status);
 		if (tachometer) {
 			if (!(status & WDC_SR_FANGOOD))
-				printk(KERN_CRIT "Possible fan fault.\n");
+				pr_crit("Possible fan fault.\n");
 		}
 	}
 	if (!(status & WDC_SR_WCCR)) {
 #ifdef SOFTWARE_REBOOT
 #ifdef ONLY_TESTING
-		printk(KERN_CRIT "Would Reboot.\n");
+		pr_crit("Would Reboot.\n");
 #else
-		printk(KERN_CRIT "Initiating system reboot.\n");
+		pr_crit("Initiating system reboot.\n");
 		emergency_restart();
 #endif
 #else
-		printk(KERN_CRIT "Reset in 5ms.\n");
+		pr_crit("Reset in 5ms.\n");
 #endif
 	}
 	spin_unlock(&wdt_lock);
@@ -441,8 +441,7 @@ static int wdt_release(struct inode *inode, struct file *file)
 		wdt_stop();
 		clear_bit(0, &wdt_is_open);
 	} else {
-		printk(KERN_CRIT
-		 "wdt: WDT device closed unexpectedly.  WDT will not stop!\n");
+		pr_crit("wdt: WDT device closed unexpectedly.  WDT will not stop!\n");
 		wdt_ping();
 	}
 	expect_close = 0;
@@ -593,7 +592,7 @@ static int __init wdt_init(void)
 	int ret;
 
 	if (type != 500 && type != 501) {
-		printk(KERN_ERR "wdt: unknown card type '%d'.\n", type);
+		pr_err("wdt: unknown card type '%d'.\n", type);
 		return -ENODEV;
 	}
 
@@ -601,34 +600,32 @@ static int __init wdt_init(void)
 	   if not reset to the default */
 	if (wdt_set_heartbeat(heartbeat)) {
 		wdt_set_heartbeat(WD_TIMO);
-		printk(KERN_INFO "wdt: heartbeat value must be "
+		pr_info("wdt: heartbeat value must be "
 			"0 < heartbeat < 65536, using %d\n", WD_TIMO);
 	}
 
 	if (!request_region(io, 8, "wdt501p")) {
-		printk(KERN_ERR
-			"wdt: I/O address 0x%04x already in use\n", io);
+		pr_err("wdt: I/O address 0x%04x already in use\n", io);
 		ret = -EBUSY;
 		goto out;
 	}
 
 	ret = request_irq(irq, wdt_interrupt, IRQF_DISABLED, "wdt501p", NULL);
 	if (ret) {
-		printk(KERN_ERR "wdt: IRQ %d is not free.\n", irq);
+		pr_err("wdt: IRQ %d is not free.\n", irq);
 		goto outreg;
 	}
 
 	ret = register_reboot_notifier(&wdt_notifier);
 	if (ret) {
-		printk(KERN_ERR
-		      "wdt: cannot register reboot notifier (err=%d)\n", ret);
+		pr_err("wdt: cannot register reboot notifier (err=%d)\n", ret);
 		goto outirq;
 	}
 
 	if (type == 501) {
 		ret = misc_register(&temp_miscdev);
 		if (ret) {
-			printk(KERN_ERR "wdt: cannot register miscdev "
+			pr_err("wdt: cannot register miscdev "
 				"on minor=%d (err=%d)\n", TEMP_MINOR, ret);
 			goto outrbt;
 		}
@@ -636,17 +633,16 @@ static int __init wdt_init(void)
 
 	ret = misc_register(&wdt_miscdev);
 	if (ret) {
-		printk(KERN_ERR
-			"wdt: cannot register miscdev on minor=%d (err=%d)\n",
+		pr_err("wdt: cannot register miscdev on minor=%d (err=%d)\n",
 							WATCHDOG_MINOR, ret);
 		goto outmisc;
 	}
 
-	printk(KERN_INFO "WDT500/501-P driver 0.10 "
+	pr_info("WDT500/501-P driver 0.10 "
 		"at 0x%04x (Interrupt %d). heartbeat=%d sec (nowayout=%d)\n",
 		io, irq, heartbeat, nowayout);
 	if (type == 501)
-		printk(KERN_INFO "wdt: Fan Tachometer is %s\n",
+		pr_info("wdt: Fan Tachometer is %s\n",
 				(tachometer ? "Enabled" : "Disabled"));
 	return 0;
 
diff --git a/drivers/watchdog/wdt285.c b/drivers/watchdog/wdt285.c
index f551356..37b88e2 100644
--- a/drivers/watchdog/wdt285.c
+++ b/drivers/watchdog/wdt285.c
@@ -49,7 +49,7 @@ static unsigned long timer_alive;
  */
 static void watchdog_fire(int irq, void *dev_id)
 {
-	printk(KERN_CRIT "Watchdog: Would Reboot.\n");
+	pr_crit("Watchdog: Would Reboot.\n");
 	*CSR_TIMER4_CNTL = 0;
 	*CSR_TIMER4_CLR = 0;
 }
@@ -205,13 +205,11 @@ static int __init footbridge_watchdog_init(void)
 	if (retval < 0)
 		return retval;
 
-	printk(KERN_INFO
-		"Footbridge Watchdog Timer: 0.01, timer margin: %d sec\n",
+	pr_info("Footbridge Watchdog Timer: 0.01, timer margin: %d sec\n",
 								soft_margin);
 
 	if (machine_is_cats())
-		printk(KERN_WARNING
-		  "Warning: Watchdog reset may not work on this machine.\n");
+		pr_warning("Warning: Watchdog reset may not work on this machine.\n");
 	return 0;
 }
 
diff --git a/drivers/watchdog/wdt977.c b/drivers/watchdog/wdt977.c
index 90ef70e..f316a26 100644
--- a/drivers/watchdog/wdt977.c
+++ b/drivers/watchdog/wdt977.c
@@ -119,7 +119,7 @@ static int wdt977_start(void)
 	outb_p(LOCK_DATA, IO_INDEX_PORT);
 
 	spin_unlock_irqrestore(&spinlock, flags);
-	printk(KERN_INFO PFX "activated.\n");
+	pr_info(PFX "activated.\n");
 
 	return 0;
 }
@@ -164,7 +164,7 @@ static int wdt977_stop(void)
 	outb_p(LOCK_DATA, IO_INDEX_PORT);
 
 	spin_unlock_irqrestore(&spinlock, flags);
-	printk(KERN_INFO PFX "shutdown.\n");
+	pr_info(PFX "shutdown.\n");
 
 	return 0;
 }
@@ -288,7 +288,7 @@ static int wdt977_release(struct inode *inode, struct file *file)
 		clear_bit(0, &timer_alive);
 	} else {
 		wdt977_keepalive();
-		printk(KERN_CRIT PFX
+		pr_crit(PFX
 			"Unexpected close, not stopping watchdog!\n");
 	}
 	expect_close = 0;
@@ -446,13 +446,13 @@ static int __init wd977_init(void)
 {
 	int rc;
 
-	printk(KERN_INFO PFX DRIVER_VERSION);
+	pr_info(PFX DRIVER_VERSION);
 
 	/* Check that the timeout value is within its range;
 	   if not reset to the default */
 	if (wdt977_set_timeout(timeout)) {
 		wdt977_set_timeout(DEFAULT_TIMEOUT);
-		printk(KERN_INFO PFX
+		pr_info(PFX
 		      "timeout value must be 60 < timeout < 15300, using %d\n",
 							DEFAULT_TIMEOUT);
 	}
@@ -462,7 +462,7 @@ static int __init wd977_init(void)
 	 */
 	if (!machine_is_netwinder()) {
 		if (!request_region(IO_INDEX_PORT, 2, WATCHDOG_NAME)) {
-			printk(KERN_ERR PFX
+			pr_err(PFX
 				"I/O address 0x%04x already in use\n",
 								IO_INDEX_PORT);
 			rc = -EIO;
@@ -472,20 +472,20 @@ static int __init wd977_init(void)
 
 	rc = register_reboot_notifier(&wdt977_notifier);
 	if (rc) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"cannot register reboot notifier (err=%d)\n", rc);
 		goto err_out_region;
 	}
 
 	rc = misc_register(&wdt977_miscdev);
 	if (rc) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"cannot register miscdev on minor=%d (err=%d)\n",
 						wdt977_miscdev.minor, rc);
 		goto err_out_reboot;
 	}
 
-	printk(KERN_INFO PFX
+	pr_info(PFX
 		"initialized. timeout=%d sec (nowayout=%d, testmode=%i)\n",
 						timeout, nowayout, testmode);
 
diff --git a/drivers/watchdog/wdt_pci.c b/drivers/watchdog/wdt_pci.c
index 7a1bdc7..cb7c89f 100644
--- a/drivers/watchdog/wdt_pci.c
+++ b/drivers/watchdog/wdt_pci.c
@@ -325,33 +325,33 @@ static irqreturn_t wdtpci_interrupt(int irq, void *dev_id)
 	status = inb(WDT_SR);
 	udelay(8);
 
-	printk(KERN_CRIT PFX "status %d\n", status);
+	pr_crit(PFX "status %d\n", status);
 
 	if (type == 501) {
 		if (!(status & WDC_SR_TGOOD)) {
-			printk(KERN_CRIT PFX "Overheat alarm.(%d)\n",
+			pr_crit(PFX "Overheat alarm.(%d)\n",
 								inb(WDT_RT));
 			udelay(8);
 		}
 		if (!(status & WDC_SR_PSUOVER))
-			printk(KERN_CRIT PFX "PSU over voltage.\n");
+			pr_crit(PFX "PSU over voltage.\n");
 		if (!(status & WDC_SR_PSUUNDR))
-			printk(KERN_CRIT PFX "PSU under voltage.\n");
+			pr_crit(PFX "PSU under voltage.\n");
 		if (tachometer) {
 			if (!(status & WDC_SR_FANGOOD))
-				printk(KERN_CRIT PFX "Possible fan fault.\n");
+				pr_crit(PFX "Possible fan fault.\n");
 		}
 	}
 	if (!(status & WDC_SR_WCCR)) {
 #ifdef SOFTWARE_REBOOT
 #ifdef ONLY_TESTING
-		printk(KERN_CRIT PFX "Would Reboot.\n");
+		pr_crit(PFX "Would Reboot.\n");
 #else
-		printk(KERN_CRIT PFX "Initiating system reboot.\n");
+		pr_crit(PFX "Initiating system reboot.\n");
 		emergency_restart(NULL);
 #endif
 #else
-		printk(KERN_CRIT PFX "Reset in 5ms.\n");
+		pr_crit(PFX "Reset in 5ms.\n");
 #endif
 	}
 	spin_unlock(&wdtpci_lock);
@@ -497,7 +497,7 @@ static int wdtpci_release(struct inode *inode, struct file *file)
 	if (expect_close == 42) {
 		wdtpci_stop();
 	} else {
-		printk(KERN_CRIT PFX "Unexpected close, not stopping timer!");
+		pr_crit(PFX "Unexpected close, not stopping timer!");
 		wdtpci_ping();
 	}
 	expect_close = 0;
@@ -627,22 +627,22 @@ static int __devinit wdtpci_init_one(struct pci_dev *dev,
 
 	dev_count++;
 	if (dev_count > 1) {
-		printk(KERN_ERR PFX "This driver only supports one device\n");
+		pr_err(PFX "This driver only supports one device\n");
 		return -ENODEV;
 	}
 
 	if (type != 500 && type != 501) {
-		printk(KERN_ERR PFX "unknown card type '%d'.\n", type);
+		pr_err(PFX "unknown card type '%d'.\n", type);
 		return -ENODEV;
 	}
 
 	if (pci_enable_device(dev)) {
-		printk(KERN_ERR PFX "Not possible to enable PCI Device\n");
+		pr_err(PFX "Not possible to enable PCI Device\n");
 		return -ENODEV;
 	}
 
 	if (pci_resource_start(dev, 2) == 0x0000) {
-		printk(KERN_ERR PFX "No I/O-Address for card detected\n");
+		pr_err(PFX "No I/O-Address for card detected\n");
 		ret = -ENODEV;
 		goto out_pci;
 	}
@@ -651,32 +651,31 @@ static int __devinit wdtpci_init_one(struct pci_dev *dev,
 	io = pci_resource_start(dev, 2);
 
 	if (request_region(io, 16, "wdt_pci") == NULL) {
-		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n", io);
+		pr_err(PFX "I/O address 0x%04x already in use\n", io);
 		goto out_pci;
 	}
 
 	if (request_irq(irq, wdtpci_interrupt, IRQF_DISABLED | IRQF_SHARED,
 			 "wdt_pci", &wdtpci_miscdev)) {
-		printk(KERN_ERR PFX "IRQ %d is not free\n", irq);
+		pr_err(PFX "IRQ %d is not free\n", irq);
 		goto out_reg;
 	}
 
-	printk(KERN_INFO
-	 "PCI-WDT500/501 (PCI-WDG-CSM) driver 0.10 at 0x%04x (Interrupt %d)\n",
+	pr_info("PCI-WDT500/501 (PCI-WDG-CSM) driver 0.10 at 0x%04x (Interrupt %d)\n",
 								io, irq);
 
 	/* Check that the heartbeat value is within its range;
 	   if not reset to the default */
 	if (wdtpci_set_heartbeat(heartbeat)) {
 		wdtpci_set_heartbeat(WD_TIMO);
-		printk(KERN_INFO PFX
+		pr_info(PFX
 		  "heartbeat value must be 0 < heartbeat < 65536, using %d\n",
 								WD_TIMO);
 	}
 
 	ret = register_reboot_notifier(&wdtpci_notifier);
 	if (ret) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"cannot register reboot notifier (err=%d)\n", ret);
 		goto out_irq;
 	}
@@ -684,7 +683,7 @@ static int __devinit wdtpci_init_one(struct pci_dev *dev,
 	if (type == 501) {
 		ret = misc_register(&temp_miscdev);
 		if (ret) {
-			printk(KERN_ERR PFX
+			pr_err(PFX
 			"cannot register miscdev on minor=%d (err=%d)\n",
 							TEMP_MINOR, ret);
 			goto out_rbt;
@@ -693,16 +692,16 @@ static int __devinit wdtpci_init_one(struct pci_dev *dev,
 
 	ret = misc_register(&wdtpci_miscdev);
 	if (ret) {
-		printk(KERN_ERR PFX
+		pr_err(PFX
 			"cannot register miscdev on minor=%d (err=%d)\n",
 						WATCHDOG_MINOR, ret);
 		goto out_misc;
 	}
 
-	printk(KERN_INFO PFX "initialized. heartbeat=%d sec (nowayout=%d)\n",
+	pr_info(PFX "initialized. heartbeat=%d sec (nowayout=%d)\n",
 		heartbeat, nowayout);
 	if (type == 501)
-		printk(KERN_INFO "wdt: Fan Tachometer is %s\n",
+		pr_info("wdt: Fan Tachometer is %s\n",
 				(tachometer ? "Enabled" : "Disabled"));
 
 	ret = 0;
-- 
1.6.3.1.10.g659a0.dirty

