Return-Path: <linux-kernel-owner+w=401wt.eu-S1765355AbYESNid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765355AbYESNid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761679AbYESNWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:22:17 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46033 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761656AbYESNWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:22:15 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 56/57] wdt977: clean up,
	coding style and switch to unlocked_ioctl
To: akpm@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 19 May 2008 14:09:57 +0100
Message-ID: <20080519130956.31722.10207.stgit@core>
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


---

 drivers/watchdog/wdt977.c |  148 +++++++++++++++++++++++----------------------
 1 files changed, 74 insertions(+), 74 deletions(-)


diff --git a/drivers/watchdog/wdt977.c b/drivers/watchdog/wdt977.c
index fb4b876..bdc28e5 100644
--- a/drivers/watchdog/wdt977.c
+++ b/drivers/watchdog/wdt977.c
@@ -19,7 +19,8 @@
  *      07-Jul-2003 Daniele Bellucci: Audit return code of misc_register in
  *                                    nwwatchdog_init.
  *      25-Oct-2005 Woody Suwalski: Convert addresses to #defs, add spinlocks
- *				    remove limitiation to be used on Netwinders only
+ *				    remove limitiation to be used on
+ *				    Netwinders only
  */
 
 #include <linux/module.h>
@@ -33,11 +34,11 @@
 #include <linux/watchdog.h>
 #include <linux/notifier.h>
 #include <linux/reboot.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 
-#include <asm/io.h>
 #include <asm/system.h>
 #include <asm/mach-types.h>
-#include <asm/uaccess.h>
 
 #define WATCHDOG_VERSION  "0.04"
 #define WATCHDOG_NAME     "Wdt977"
@@ -45,7 +46,7 @@
 #define DRIVER_VERSION    WATCHDOG_NAME " driver, v" WATCHDOG_VERSION "\n"
 
 #define IO_INDEX_PORT	0x370		/* on some systems it can be 0x3F0 */
-#define IO_DATA_PORT	(IO_INDEX_PORT+1)
+#define IO_DATA_PORT	(IO_INDEX_PORT + 1)
 
 #define UNLOCK_DATA	0x87
 #define LOCK_DATA	0xAA
@@ -62,13 +63,16 @@ static	char expect_close;
 static	DEFINE_SPINLOCK(spinlock);
 
 module_param(timeout, int, 0);
-MODULE_PARM_DESC(timeout,"Watchdog timeout in seconds (60..15300), default=" __MODULE_STRING(DEFAULT_TIMEOUT) ")");
+MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds (60..15300), default="
+				__MODULE_STRING(DEFAULT_TIMEOUT) ")");
 module_param(testmode, int, 0);
-MODULE_PARM_DESC(testmode,"Watchdog testmode (1 = no reboot), default=0");
+MODULE_PARM_DESC(testmode, "Watchdog testmode (1 = no reboot), default=0");
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+MODULE_PARM_DESC(nowayout,
+		"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  * Start the watchdog
@@ -95,14 +99,16 @@ static int wdt977_start(void)
 	outb_p(0xF2, IO_INDEX_PORT);
 	outb_p(timeoutM, IO_DATA_PORT);
 	outb_p(0xF3, IO_INDEX_PORT);
-	outb_p(0x00, IO_DATA_PORT);	/* another setting is 0E for kbd/mouse/LED */
+	outb_p(0x00, IO_DATA_PORT);	/* another setting is 0E for
+					   kbd/mouse/LED */
 	outb_p(0xF4, IO_INDEX_PORT);
 	outb_p(0x00, IO_DATA_PORT);
 
-	/* at last select device Aux1 (dev=7) and set GP16 as a watchdog output */
-	/* in test mode watch the bit 1 on F4 to indicate "triggered" */
-	if (!testmode)
-	{
+	/* At last select device Aux1 (dev=7) and set GP16 as a
+	 * watchdog output. In test mode watch the bit 1 on F4 to
+	 * indicate "triggered"
+	 */
+	if (!testmode) {
 		outb_p(DEVICE_REGISTER, IO_INDEX_PORT);
 		outb_p(0x07, IO_DATA_PORT);
 		outb_p(0xE6, IO_INDEX_PORT);
@@ -147,7 +153,8 @@ static int wdt977_stop(void)
 	outb_p(0xF2, IO_INDEX_PORT);
 	outb_p(0x00, IO_DATA_PORT);
 
-	/* at last select device Aux1 (dev=7) and set GP16 as a watchdog output */
+	/* at last select device Aux1 (dev=7) and set
+	   GP16 as a watchdog output */
 	outb_p(DEVICE_REGISTER, IO_INDEX_PORT);
 	outb_p(0x07, IO_DATA_PORT);
 	outb_p(0xE6, IO_INDEX_PORT);
@@ -202,16 +209,18 @@ static int wdt977_set_timeout(int t)
 	tmrval = (t + 59) / 60;
 
 	if (machine_is_netwinder()) {
-		/* we have a hw bug somewhere, so each 977 minute is actually only 30sec
-		 *  this limits the max timeout to half of device max of 255 minutes...
+		/* we have a hw bug somewhere, so each 977 minute is actually
+		 * only 30sec. This limits the max timeout to half of device
+		 * max of 255 minutes...
 		 */
 		tmrval += tmrval;
 	}
 
-	if ((tmrval < 1) || (tmrval > 255))
+	if (tmrval < 1 || tmrval > 255)
 		return -EINVAL;
 
-	/* timeout is the timeout in seconds, timeoutM is the timeout in minutes) */
+	/* timeout is the timeout in seconds, timeoutM is
+	   the timeout in minutes) */
 	timeout = t;
 	timeoutM = tmrval;
 	return 0;
@@ -243,7 +252,7 @@ static int wdt977_get_status(int *status)
 
 	spin_unlock_irqrestore(&spinlock, flags);
 
-	*status=0;
+	*status = 0;
 	if (new_status & 1)
 		*status |= WDIOF_CARDRESET;
 
@@ -258,7 +267,7 @@ static int wdt977_get_status(int *status)
 static int wdt977_open(struct inode *inode, struct file *file)
 {
 	/* If the watchdog is alive we don't need to start it again */
-	if( test_and_set_bit(0,&timer_alive) )
+	if (test_and_set_bit(0, &timer_alive))
 		return -EBUSY;
 
 	if (nowayout)
@@ -274,13 +283,13 @@ static int wdt977_release(struct inode *inode, struct file *file)
 	 *	Shut off the timer.
 	 * 	Lock it in if it's a module and we set nowayout
 	 */
-	if (expect_close == 42)
-	{
+	if (expect_close == 42) {
 		wdt977_stop();
-		clear_bit(0,&timer_alive);
+		clear_bit(0, &timer_alive);
 	} else {
 		wdt977_keepalive();
-		printk(KERN_CRIT PFX "Unexpected close, not stopping watchdog!\n");
+		printk(KERN_CRIT PFX
+			"Unexpected close, not stopping watchdog!\n");
 	}
 	expect_close = 0;
 	return 0;
@@ -301,17 +310,14 @@ static int wdt977_release(struct inode *inode, struct file *file)
 static ssize_t wdt977_write(struct file *file, const char __user *buf,
 			    size_t count, loff_t *ppos)
 {
-	if (count)
-	{
-		if (!nowayout)
-		{
+	if (count) {
+		if (!nowayout) {
 			size_t i;
 
 			/* In case it was set long ago */
 			expect_close = 0;
 
-			for (i = 0; i != count; i++)
-			{
+			for (i = 0; i != count; i++) {
 				char c;
 				if (get_user(c, buf + i))
 					return -EFAULT;
@@ -326,6 +332,14 @@ static ssize_t wdt977_write(struct file *file, const char __user *buf,
 	return count;
 }
 
+static const struct watchdog_info ident = {
+	.options =		WDIOF_SETTIMEOUT |
+				WDIOF_MAGICCLOSE |
+				WDIOF_KEEPALIVEPING,
+	.firmware_version =	1,
+	.identity =		WATCHDOG_NAME,
+};
+
 /*
  *      wdt977_ioctl:
  *      @inode: inode of the device
@@ -337,16 +351,8 @@ static ssize_t wdt977_write(struct file *file, const char __user *buf,
  *      according to their available features.
  */
 
-static struct watchdog_info ident = {
-	.options =		WDIOF_SETTIMEOUT |
-				WDIOF_MAGICCLOSE |
-				WDIOF_KEEPALIVEPING,
-	.firmware_version =	1,
-	.identity =		WATCHDOG_NAME,
-};
-
-static int wdt977_ioctl(struct inode *inode, struct file *file,
-	unsigned int cmd, unsigned long arg)
+static long wdt977_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	int status;
 	int new_options, retval = -EINVAL;
@@ -358,8 +364,7 @@ static int wdt977_ioctl(struct inode *inode, struct file *file,
 
 	uarg.i = (int __user *)arg;
 
-	switch(cmd)
-	{
+	switch (cmd) {
 	default:
 		return -ENOTTY;
 
@@ -379,7 +384,7 @@ static int wdt977_ioctl(struct inode *inode, struct file *file,
 		return 0;
 
 	case WDIOC_SETOPTIONS:
-		if (get_user (new_options, uarg.i))
+		if (get_user(new_options, uarg.i))
 			return -EFAULT;
 
 		if (new_options & WDIOS_DISABLECARD) {
@@ -413,23 +418,21 @@ static int wdt977_ioctl(struct inode *inode, struct file *file,
 static int wdt977_notify_sys(struct notifier_block *this, unsigned long code,
 	void *unused)
 {
-	if(code==SYS_DOWN || code==SYS_HALT)
+	if (code == SYS_DOWN || code == SYS_HALT)
 		wdt977_stop();
 	return NOTIFY_DONE;
 }
 
-static const struct file_operations wdt977_fops=
-{
+static const struct file_operations wdt977_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= wdt977_write,
-	.ioctl		= wdt977_ioctl,
+	.unlocked_ioctl	= wdt977_ioctl,
 	.open		= wdt977_open,
 	.release	= wdt977_release,
 };
 
-static struct miscdevice wdt977_miscdev=
-{
+static struct miscdevice wdt977_miscdev = {
 	.minor		= WATCHDOG_MINOR,
 	.name		= "watchdog",
 	.fops		= &wdt977_fops,
@@ -443,51 +446,48 @@ static int __init wd977_init(void)
 {
 	int rc;
 
-	//if (!machine_is_netwinder())
-	//	return -ENODEV;
-
 	printk(KERN_INFO PFX DRIVER_VERSION);
 
-	/* Check that the timeout value is within it's range ; if not reset to the default */
-	if (wdt977_set_timeout(timeout))
-	{
+	/* Check that the timeout value is within its range;
+	   if not reset to the default */
+	if (wdt977_set_timeout(timeout)) {
 		wdt977_set_timeout(DEFAULT_TIMEOUT);
-		printk(KERN_INFO PFX "timeout value must be 60<timeout<15300, using %d\n",
-			DEFAULT_TIMEOUT);
+		printk(KERN_INFO PFX
+		      "timeout value must be 60 < timeout < 15300, using %d\n",
+							DEFAULT_TIMEOUT);
 	}
 
 	/* on Netwinder the IOports are already reserved by
 	 * arch/arm/mach-footbridge/netwinder-hw.c
 	 */
-	if (!machine_is_netwinder())
-	{
-		if (!request_region(IO_INDEX_PORT, 2, WATCHDOG_NAME))
-		{
-			printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
-				IO_INDEX_PORT);
+	if (!machine_is_netwinder()) {
+		if (!request_region(IO_INDEX_PORT, 2, WATCHDOG_NAME)) {
+			printk(KERN_ERR PFX
+				"I/O address 0x%04x already in use\n",
+								IO_INDEX_PORT);
 			rc = -EIO;
 			goto err_out;
 		}
 	}
 
 	rc = register_reboot_notifier(&wdt977_notifier);
-	if (rc)
-	{
-		printk(KERN_ERR PFX "cannot register reboot notifier (err=%d)\n",
-			rc);
+	if (rc) {
+		printk(KERN_ERR PFX
+			"cannot register reboot notifier (err=%d)\n", rc);
 		goto err_out_region;
 	}
 
 	rc = misc_register(&wdt977_miscdev);
-	if (rc)
-	{
-		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			wdt977_miscdev.minor, rc);
+	if (rc) {
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+						wdt977_miscdev.minor, rc);
 		goto err_out_reboot;
 	}
 
-	printk(KERN_INFO PFX "initialized. timeout=%d sec (nowayout=%d, testmode=%i)\n",
-		timeout, nowayout, testmode);
+	printk(KERN_INFO PFX
+		"initialized. timeout=%d sec (nowayout=%d, testmode=%i)\n",
+						timeout, nowayout, testmode);
 
 	return 0;
 
@@ -495,7 +495,7 @@ err_out_reboot:
 	unregister_reboot_notifier(&wdt977_notifier);
 err_out_region:
 	if (!machine_is_netwinder())
-	        release_region(IO_INDEX_PORT,2);
+		release_region(IO_INDEX_PORT, 2);
 err_out:
 	return rc;
 }
@@ -505,7 +505,7 @@ static void __exit wd977_exit(void)
 	wdt977_stop();
 	misc_deregister(&wdt977_miscdev);
 	unregister_reboot_notifier(&wdt977_notifier);
-	release_region(IO_INDEX_PORT,2);
+	release_region(IO_INDEX_PORT, 2);
 }
 
 module_init(wd977_init);

