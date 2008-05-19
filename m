Return-Path: <linux-kernel-owner+w=401wt.eu-S1762079AbYESN33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762079AbYESN33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760826AbYESNTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:19:45 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45925 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760196AbYESNTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:19:44 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 34/57] rm9k_wdt: clean up
To: akpm@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 19 May 2008 14:07:54 +0100
Message-ID: <20080519130754.31722.58213.stgit@core>
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

 drivers/watchdog/rm9k_wdt.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)


diff --git a/drivers/watchdog/rm9k_wdt.c b/drivers/watchdog/rm9k_wdt.c
index 5c921e4..c172906 100644
--- a/drivers/watchdog/rm9k_wdt.c
+++ b/drivers/watchdog/rm9k_wdt.c
@@ -29,10 +29,10 @@
 #include <linux/notifier.h>
 #include <linux/miscdevice.h>
 #include <linux/watchdog.h>
-#include <asm/io.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 #include <asm/atomic.h>
 #include <asm/processor.h>
-#include <asm/uaccess.h>
 #include <asm/system.h>
 #include <asm/rm9k-ocd.h>
 
@@ -53,10 +53,12 @@ static void wdt_gpi_stop(void);
 static void wdt_gpi_set_timeout(unsigned int);
 static int wdt_gpi_open(struct inode *, struct file *);
 static int wdt_gpi_release(struct inode *, struct file *);
-static ssize_t wdt_gpi_write(struct file *, const char __user *, size_t, loff_t *);
+static ssize_t wdt_gpi_write(struct file *, const char __user *, size_t,
+								loff_t *);
 static long wdt_gpi_ioctl(struct file *, unsigned int, unsigned long);
 static int wdt_gpi_notify(struct notifier_block *, unsigned long, void *);
-static const struct resource *wdt_gpi_get_resource(struct platform_device *, const char *, unsigned int);
+static const struct resource *wdt_gpi_get_resource(struct platform_device *,
+						const char *, unsigned int);
 static int __init wdt_gpi_probe(struct device *);
 static int __exit wdt_gpi_remove(struct device *);
 
@@ -68,7 +70,7 @@ static int locked;
 
 
 /* These are set from device resources */
-static void __iomem * wd_regs;
+static void __iomem *wd_regs;
 static unsigned int wd_irq, wd_ctr;
 
 
@@ -216,7 +218,8 @@ static int wdt_gpi_release(struct inode *inode, struct file *file)
 		if (expect_close) {
 			wdt_gpi_stop();
 			free_irq(wd_irq, &miscdev);
-			printk(KERN_INFO "%s: watchdog stopped\n", wdt_gpi_name);
+			printk(KERN_INFO "%s: watchdog stopped\n",
+							wdt_gpi_name);
 		} else {
 			printk(KERN_CRIT "%s: unexpected close() -"
 				" watchdog left running\n",
@@ -241,8 +244,7 @@ wdt_gpi_write(struct file *f, const char __user *d, size_t s, loff_t *o)
 	return s ? 1 : 0;
 }
 
-static long
-wdt_gpi_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
+static long wdt_gpi_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 {
 	long res = -ENOTTY;
 	const long size = _IOC_SIZE(cmd);
@@ -271,7 +273,8 @@ wdt_gpi_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 	case WDIOC_GETSUPPORT:
 		wdinfo.options = nowayout ?
 			WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING :
-			WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE;
+			WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING |
+			WDIOF_MAGICCLOSE;
 		res = __copy_to_user(argp, &wdinfo, size) ?  -EFAULT : size;
 		break;
 

