Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736AbYESNRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbYESNRE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755338AbYESNQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:16:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57943 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750904AbYESNQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:16:35 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 01/57] Clean acquirewdt and check for BKL dependancies
To: akpm@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 19 May 2008 14:04:46 +0100
Message-ID: <20080519130445.31722.14241.stgit@core>
In-Reply-To: <20080519124659.31722.51847.stgit@core>
References: <20080519124659.31722.51847.stgit@core>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>

This brings the file into line with coding style.
---

 drivers/watchdog/acquirewdt.c |  119 ++++++++++++++++++++---------------------
 1 files changed, 58 insertions(+), 61 deletions(-)


diff --git a/drivers/watchdog/acquirewdt.c b/drivers/watchdog/acquirewdt.c
index 85269c3..269ada2 100644
--- a/drivers/watchdog/acquirewdt.c
+++ b/drivers/watchdog/acquirewdt.c
@@ -58,39 +58,46 @@
 #include <linux/types.h>		/* For standard types (like size_t) */
 #include <linux/errno.h>		/* For the -ENODEV/... values */
 #include <linux/kernel.h>		/* For printk/panic/... */
-#include <linux/miscdevice.h>		/* For MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR) */
+#include <linux/miscdevice.h>		/* For MODULE_ALIAS_MISCDEV
+							(WATCHDOG_MINOR) */
 #include <linux/watchdog.h>		/* For the watchdog specific items */
 #include <linux/fs.h>			/* For file operations */
 #include <linux/ioport.h>		/* For io-port access */
 #include <linux/platform_device.h>	/* For platform_driver framework */
 #include <linux/init.h>			/* For __init/__exit/... */
 
-#include <asm/uaccess.h>		/* For copy_to_user/put_user/... */
-#include <asm/io.h>			/* For inb/outb/... */
+#include <linux/uaccess.h>		/* For copy_to_user/put_user/... */
+#include <linux/io.h>			/* For inb/outb/... */
 
 /* Module information */
 #define DRV_NAME "acquirewdt"
 #define PFX DRV_NAME ": "
 #define WATCHDOG_NAME "Acquire WDT"
-#define WATCHDOG_HEARTBEAT 0	/* There is no way to see what the correct time-out period is */
+/* There is no way to see what the correct time-out period is */
+#define WATCHDOG_HEARTBEAT 0
 
 /* internal variables */
-static struct platform_device *acq_platform_device;	/* the watchdog platform device */
+/* the watchdog platform device */
+static struct platform_device *acq_platform_device;
 static unsigned long acq_is_open;
 static char expect_close;
 
 /* module parameters */
-static int wdt_stop = 0x43;	/* You must set this - there is no sane way to probe for this board. */
+/* You must set this - there is no sane way to probe for this board. */
+static int wdt_stop = 0x43;
 module_param(wdt_stop, int, 0);
 MODULE_PARM_DESC(wdt_stop, "Acquire WDT 'stop' io port (default 0x43)");
 
-static int wdt_start = 0x443;	/* You must set this - there is no sane way to probe for this board. */
+/* You must set this - there is no sane way to probe for this board. */
+static int wdt_start = 0x443;
 module_param(wdt_start, int, 0);
 MODULE_PARM_DESC(wdt_start, "Acquire WDT 'start' io port (default 0x443)");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+	"Watchdog cannot be stopped once started (default="
+	__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  *	Watchdog Operations
@@ -112,18 +119,18 @@ static void acq_stop(void)
  *	/dev/watchdog handling
  */
 
-static ssize_t acq_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
+static ssize_t acq_write(struct file *file, const char __user *buf,
+						size_t count, loff_t *ppos)
 {
 	/* See if we got the magic character 'V' and reload the timer */
-	if(count) {
+	if (count) {
 		if (!nowayout) {
 			size_t i;
-
 			/* note: just in case someone wrote the magic character
 			 * five months ago... */
 			expect_close = 0;
-
-			/* scan to see whether or not we got the magic character */
+			/* scan to see whether or not we got the
+			   magic character */
 			for (i = 0; i != count; i++) {
 				char c;
 				if (get_user(c, buf + i))
@@ -132,64 +139,55 @@ static ssize_t acq_write(struct file *file, const char __user *buf, size_t count
 					expect_close = 42;
 			}
 		}
-
-		/* Well, anyhow someone wrote to us, we should return that favour */
+		/* Well, anyhow someone wrote to us, we should
+				return that favour */
 		acq_keepalive();
 	}
 	return count;
 }
 
-static int acq_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-	unsigned long arg)
+static long acq_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int options, retval = -EINVAL;
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	static struct watchdog_info ident =
-	{
+	static struct watchdog_info ident = {
 		.options = WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
 		.firmware_version = 1,
 		.identity = WATCHDOG_NAME,
 	};
 
-	switch(cmd)
-	{
+	switch (cmd) {
 	case WDIOC_GETSUPPORT:
-	  return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
+		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
 
 	case WDIOC_GETSTATUS:
 	case WDIOC_GETBOOTSTATUS:
-	  return put_user(0, p);
+		return put_user(0, p);
 
 	case WDIOC_KEEPALIVE:
-	  acq_keepalive();
-	  return 0;
+		acq_keepalive();
+		return 0;
 
 	case WDIOC_GETTIMEOUT:
 	  return put_user(WATCHDOG_HEARTBEAT, p);
 
 	case WDIOC_SETOPTIONS:
 	{
-	    if (get_user(options, p))
-	      return -EFAULT;
-
-	    if (options & WDIOS_DISABLECARD)
-	    {
-	      acq_stop();
-	      retval = 0;
-	    }
-
-	    if (options & WDIOS_ENABLECARD)
-	    {
-	      acq_keepalive();
-	      retval = 0;
-	    }
-
-	    return retval;
+		if (get_user(options, p))
+			return -EFAULT;
+		if (options & WDIOS_DISABLECARD) {
+			acq_stop();
+			retval = 0;
+		}
+		if (options & WDIOS_ENABLECARD) {
+			acq_keepalive();
+			retval = 0;
+		}
+		return retval;
 	}
-
 	default:
-	  return -ENOTTY;
+		return -ENOTTY;
 	}
 }
 
@@ -211,7 +209,8 @@ static int acq_close(struct inode *inode, struct file *file)
 	if (expect_close == 42) {
 		acq_stop();
 	} else {
-		printk(KERN_CRIT PFX "Unexpected close, not stopping watchdog!\n");
+		printk(KERN_CRIT PFX
+			"Unexpected close, not stopping watchdog!\n");
 		acq_keepalive();
 	}
 	clear_bit(0, &acq_is_open);
@@ -227,7 +226,7 @@ static const struct file_operations acq_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= acq_write,
-	.ioctl		= acq_ioctl,
+	.unlocked_ioctl	= acq_ioctl,
 	.open		= acq_open,
 	.release	= acq_close,
 };
@@ -248,32 +247,29 @@ static int __devinit acq_probe(struct platform_device *dev)
 
 	if (wdt_stop != wdt_start) {
 		if (!request_region(wdt_stop, 1, WATCHDOG_NAME)) {
-			printk (KERN_ERR PFX "I/O address 0x%04x already in use\n",
-				wdt_stop);
+			printk(KERN_ERR PFX
+			    "I/O address 0x%04x already in use\n", wdt_stop);
 			ret = -EIO;
 			goto out;
 		}
 	}
 
 	if (!request_region(wdt_start, 1, WATCHDOG_NAME)) {
-		printk (KERN_ERR PFX "I/O address 0x%04x already in use\n",
+		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
 			wdt_start);
 		ret = -EIO;
 		goto unreg_stop;
 	}
-
 	ret = misc_register(&acq_miscdev);
 	if (ret != 0) {
-		printk (KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+							WATCHDOG_MINOR, ret);
 		goto unreg_regions;
 	}
-
-	printk (KERN_INFO PFX "initialized. (nowayout=%d)\n",
-		nowayout);
+	printk(KERN_INFO PFX "initialized. (nowayout=%d)\n", nowayout);
 
 	return 0;
-
 unreg_regions:
 	release_region(wdt_start, 1);
 unreg_stop:
@@ -286,9 +282,9 @@ out:
 static int __devexit acq_remove(struct platform_device *dev)
 {
 	misc_deregister(&acq_miscdev);
-	release_region(wdt_start,1);
-	if(wdt_stop != wdt_start)
-		release_region(wdt_stop,1);
+	release_region(wdt_start, 1);
+	if (wdt_stop != wdt_start)
+		release_region(wdt_stop, 1);
 
 	return 0;
 }
@@ -313,18 +309,19 @@ static int __init acq_init(void)
 {
 	int err;
 
-	printk(KERN_INFO "WDT driver for Acquire single board computer initialising.\n");
+	printk(KERN_INFO
+	      "WDT driver for Acquire single board computer initialising.\n");
 
 	err = platform_driver_register(&acquirewdt_driver);
 	if (err)
 		return err;
 
-	acq_platform_device = platform_device_register_simple(DRV_NAME, -1, NULL, 0);
+	acq_platform_device = platform_device_register_simple(DRV_NAME,
+								-1, NULL, 0);
 	if (IS_ERR(acq_platform_device)) {
 		err = PTR_ERR(acq_platform_device);
 		goto unreg_platform_driver;
 	}
-
 	return 0;
 
 unreg_platform_driver:

