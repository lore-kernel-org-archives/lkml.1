Return-Path: <linux-kernel-owner+w=401wt.eu-S1758703AbYFBRkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758703AbYFBRkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 13:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758119AbYFBRir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 13:38:47 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:14460 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758043AbYFBRip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 13:38:45 -0400
Date: Mon, 2 Jun 2008 21:38:44 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Kumar Gala <galak@kernel.crashing.org>, Wim Van Sebroeck <wim@iguana.be>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jochen Friedrich <jochen@scram.de>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       Scott Wood <scottwood@freescale.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] [WATCHDOG] mpc8xxx_wdt: various renames, mostly
	s/mpc83xx/mpc8xxx/g
Message-ID: <20080602173844.GE30705@polina.dev.rtsoft.ru>
References: <20080602173726.GA24556@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080602173726.GA24556@polina.dev.rtsoft.ru>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mpc83xx_wdt.c renamed to mpc8xxx_wdt.c, now we can do various renames
in the file itself.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/watchdog/mpc8xxx_wdt.c |  104 ++++++++++++++++++++--------------------
 1 files changed, 52 insertions(+), 52 deletions(-)

diff --git a/drivers/watchdog/mpc8xxx_wdt.c b/drivers/watchdog/mpc8xxx_wdt.c
index 19e3082..2f0681f 100644
--- a/drivers/watchdog/mpc8xxx_wdt.c
+++ b/drivers/watchdog/mpc8xxx_wdt.c
@@ -1,5 +1,5 @@
 /*
- * mpc83xx_wdt.c - MPC83xx/MPC86xx watchdog userspace interface
+ * mpc8xxx_wdt.c - MPC83xx/MPC86xx watchdog userspace interface
  *
  * Authors: Dave Updegraff <dave@cray.org>
  * 	    Kumar Gala <galak@kernel.crashing.org>
@@ -29,7 +29,7 @@
 #include <linux/uaccess.h>
 #include <sysdev/fsl_soc.h>
 
-struct mpc83xx_wdt {
+struct mpc8xxx_wdt {
 	__be32 res0;
 	__be32 swcrr; /* System watchdog control register */
 #define SWCRR_SWTC 0xFFFF0000 /* Software Watchdog Time Count. */
@@ -42,12 +42,12 @@ struct mpc83xx_wdt {
 	u8 res2[0xF0];
 };
 
-struct mpc83xx_wdt_type {
+struct mpc8xxx_wdt_type {
 	int prescaler;
 	bool hw_enabled;
 };
 
-static struct mpc83xx_wdt __iomem *wd_base;
+static struct mpc8xxx_wdt __iomem *wd_base;
 
 static u16 timeout = 0xffff;
 module_param(timeout, ushort, 0);
@@ -74,7 +74,7 @@ static unsigned int timeout_sec;
 static unsigned long wdt_is_open;
 static DEFINE_SPINLOCK(wdt_spinlock);
 
-static void mpc83xx_wdt_keepalive(void)
+static void mpc8xxx_wdt_keepalive(void)
 {
 	/* Ping the WDT */
 	spin_lock(&wdt_spinlock);
@@ -83,31 +83,31 @@ static void mpc83xx_wdt_keepalive(void)
 	spin_unlock(&wdt_spinlock);
 }
 
-static void mpc83xx_wdt_timer_ping(unsigned long arg);
-static DEFINE_TIMER(wdt_timer, mpc83xx_wdt_timer_ping, 0, 0);
+static void mpc8xxx_wdt_timer_ping(unsigned long arg);
+static DEFINE_TIMER(wdt_timer, mpc8xxx_wdt_timer_ping, 0, 0);
 
-static void mpc83xx_wdt_timer_ping(unsigned long arg)
+static void mpc8xxx_wdt_timer_ping(unsigned long arg)
 {
-	mpc83xx_wdt_keepalive();
+	mpc8xxx_wdt_keepalive();
 	/* We're pinging it twice faster than needed, just to be sure. */
 	mod_timer(&wdt_timer, jiffies + HZ * timeout_sec / 2);
 }
 
-static void mpc83xx_wdt_pr_warn(const char *msg)
+static void mpc8xxx_wdt_pr_warn(const char *msg)
 {
-	pr_crit("mpc83xx_wdt: %s, expect the %s soon!\n", msg,
+	pr_crit("mpc8xxx_wdt: %s, expect the %s soon!\n", msg,
 		reset ? "reset" : "machine check exception");
 }
 
-static ssize_t mpc83xx_wdt_write(struct file *file, const char __user *buf,
+static ssize_t mpc8xxx_wdt_write(struct file *file, const char __user *buf,
 				 size_t count, loff_t *ppos)
 {
 	if (count)
-		mpc83xx_wdt_keepalive();
+		mpc8xxx_wdt_keepalive();
 	return count;
 }
 
-static int mpc83xx_wdt_open(struct inode *inode, struct file *file)
+static int mpc8xxx_wdt_open(struct inode *inode, struct file *file)
 {
 	u32 tmp = SWCRR_SWEN;
 	if (test_and_set_bit(0, &wdt_is_open))
@@ -132,17 +132,17 @@ static int mpc83xx_wdt_open(struct inode *inode, struct file *file)
 	return nonseekable_open(inode, file);
 }
 
-static int mpc83xx_wdt_release(struct inode *inode, struct file *file)
+static int mpc8xxx_wdt_release(struct inode *inode, struct file *file)
 {
 	if (!nowayout)
-		mpc83xx_wdt_timer_ping(0);
+		mpc8xxx_wdt_timer_ping(0);
 	else
-		mpc83xx_wdt_pr_warn("watchdog closed");
+		mpc8xxx_wdt_pr_warn("watchdog closed");
 	clear_bit(0, &wdt_is_open);
 	return 0;
 }
 
-static int mpc83xx_wdt_ioctl(struct inode *inode, struct file *file,
+static int mpc8xxx_wdt_ioctl(struct inode *inode, struct file *file,
 				unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
@@ -150,7 +150,7 @@ static int mpc83xx_wdt_ioctl(struct inode *inode, struct file *file,
 	static struct watchdog_info ident = {
 		.options = WDIOF_KEEPALIVEPING,
 		.firmware_version = 1,
-		.identity = "MPC83xx",
+		.identity = "MPC8xxx",
 	};
 
 	switch (cmd) {
@@ -160,7 +160,7 @@ static int mpc83xx_wdt_ioctl(struct inode *inode, struct file *file,
 	case WDIOC_GETBOOTSTATUS:
 		return put_user(0, p);
 	case WDIOC_KEEPALIVE:
-		mpc83xx_wdt_keepalive();
+		mpc8xxx_wdt_keepalive();
 		return 0;
 	case WDIOC_GETTIMEOUT:
 		return put_user(timeout_sec, p);
@@ -169,27 +169,27 @@ static int mpc83xx_wdt_ioctl(struct inode *inode, struct file *file,
 	}
 }
 
-static const struct file_operations mpc83xx_wdt_fops = {
+static const struct file_operations mpc8xxx_wdt_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
-	.write		= mpc83xx_wdt_write,
-	.ioctl		= mpc83xx_wdt_ioctl,
-	.open		= mpc83xx_wdt_open,
-	.release	= mpc83xx_wdt_release,
+	.write		= mpc8xxx_wdt_write,
+	.ioctl		= mpc8xxx_wdt_ioctl,
+	.open		= mpc8xxx_wdt_open,
+	.release	= mpc8xxx_wdt_release,
 };
 
-static struct miscdevice mpc83xx_wdt_miscdev = {
+static struct miscdevice mpc8xxx_wdt_miscdev = {
 	.minor	= WATCHDOG_MINOR,
 	.name	= "watchdog",
-	.fops	= &mpc83xx_wdt_fops,
+	.fops	= &mpc8xxx_wdt_fops,
 };
 
-static int __devinit mpc83xx_wdt_probe(struct of_device *ofdev,
+static int __devinit mpc8xxx_wdt_probe(struct of_device *ofdev,
 				       const struct of_device_id *match)
 {
 	int ret;
 	struct device_node *np = ofdev->node;
-	struct mpc83xx_wdt_type *wdt_type = match->data;
+	struct mpc8xxx_wdt_type *wdt_type = match->data;
 	u32 freq = fsl_get_sys_freq();
 	bool enabled;
 
@@ -202,12 +202,12 @@ static int __devinit mpc83xx_wdt_probe(struct of_device *ofdev,
 
 	enabled = in_be32(&wd_base->swcrr) & SWCRR_SWEN;
 	if (!enabled && wdt_type->hw_enabled) {
-		pr_info("mpc83xx_wdt: could not be enabled in software\n");
+		pr_info("mpc8xxx_wdt: could not be enabled in software\n");
 		ret = -ENOSYS;
 		goto err_unmap;
 	}
 
-	ret = misc_register(&mpc83xx_wdt_miscdev);
+	ret = misc_register(&mpc8xxx_wdt_miscdev);
 	if (ret) {
 		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
 			WATCHDOG_MINOR, ret);
@@ -220,73 +220,73 @@ static int __devinit mpc83xx_wdt_probe(struct of_device *ofdev,
 	else
 		timeout_sec = timeout / freq;
 
-	pr_info("WDT driver for MPC83xx initialized. mode:%s timeout=%d "
+	pr_info("WDT driver for MPC8xxx initialized. mode:%s timeout=%d "
 		"(%d seconds)\n", reset ? "reset" : "interrupt", timeout,
 		timeout_sec);
 
 	/*
 	 * If the watchdog was previously enabled or we're running on
-	 * MPC86xx, we should ping the wdt from the kernel until the
+	 * MPC8xxx, we should ping the wdt from the kernel until the
 	 * userspace handles it.
 	 */
 	if (enabled)
-		mpc83xx_wdt_timer_ping(0);
+		mpc8xxx_wdt_timer_ping(0);
 	return 0;
 err_unmap:
 	iounmap(wd_base);
 	return ret;
 }
 
-static int __devexit mpc83xx_wdt_remove(struct of_device *ofdev)
+static int __devexit mpc8xxx_wdt_remove(struct of_device *ofdev)
 {
-	mpc83xx_wdt_pr_warn("watchdog removed");
+	mpc8xxx_wdt_pr_warn("watchdog removed");
 	del_timer_sync(&wdt_timer);
-	misc_deregister(&mpc83xx_wdt_miscdev);
+	misc_deregister(&mpc8xxx_wdt_miscdev);
 	iounmap(wd_base);
 
 	return 0;
 }
 
-static const struct of_device_id mpc83xx_wdt_match[] = {
+static const struct of_device_id mpc8xxx_wdt_match[] = {
 	{
 		.compatible = "mpc83xx_wdt",
-		.data = &(struct mpc83xx_wdt_type) {
+		.data = &(struct mpc8xxx_wdt_type) {
 			.prescaler = 0x10000,
 		},
 	},
 	{
 		.compatible = "fsl,mpc8610-wdt",
-		.data = &(struct mpc83xx_wdt_type) {
+		.data = &(struct mpc8xxx_wdt_type) {
 			.prescaler = 0x10000,
 			.hw_enabled = true,
 		},
 	},
 	{},
 };
-MODULE_DEVICE_TABLE(of, mpc83xx_wdt_match);
+MODULE_DEVICE_TABLE(of, mpc8xxx_wdt_match);
 
-static struct of_platform_driver mpc83xx_wdt_driver = {
-	.match_table	= mpc83xx_wdt_match,
-	.probe		= mpc83xx_wdt_probe,
-	.remove		= __devexit_p(mpc83xx_wdt_remove),
+static struct of_platform_driver mpc8xxx_wdt_driver = {
+	.match_table	= mpc8xxx_wdt_match,
+	.probe		= mpc8xxx_wdt_probe,
+	.remove		= __devexit_p(mpc8xxx_wdt_remove),
 	.driver		= {
-		.name	= "mpc83xx_wdt",
+		.name	= "mpc8xxx_wdt",
 		.owner	= THIS_MODULE,
 	},
 };
 
-static int __init mpc83xx_wdt_init(void)
+static int __init mpc8xxx_wdt_init(void)
 {
-	return of_register_platform_driver(&mpc83xx_wdt_driver);
+	return of_register_platform_driver(&mpc8xxx_wdt_driver);
 }
 
-static void __exit mpc83xx_wdt_exit(void)
+static void __exit mpc8xxx_wdt_exit(void)
 {
-	of_unregister_platform_driver(&mpc83xx_wdt_driver);
+	of_unregister_platform_driver(&mpc8xxx_wdt_driver);
 }
 
-subsys_initcall(mpc83xx_wdt_init);
-module_exit(mpc83xx_wdt_exit);
+subsys_initcall(mpc8xxx_wdt_init);
+module_exit(mpc8xxx_wdt_exit);
 
 MODULE_AUTHOR("Dave Updegraff, Kumar Gala");
 MODULE_DESCRIPTION("Driver for watchdog timer in MPC83xx/MPC86xx uProcessors");
-- 
1.5.5.1

