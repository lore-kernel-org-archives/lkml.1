Return-Path: <linux-kernel-owner+w=401wt.eu-S1759262AbYESNUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759262AbYESNUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759540AbYESNRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:17:20 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57970 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759537AbYESNRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:17:19 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 08/57] davinci_wdt: unlocked_ioctl and check locking
To: akpm@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 19 May 2008 14:05:30 +0100
Message-ID: <20080519130530.31722.21981.stgit@core>
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

 drivers/watchdog/davinci_wdt.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)


diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
index 1782c79..926b59c 100644
--- a/drivers/watchdog/davinci_wdt.c
+++ b/drivers/watchdog/davinci_wdt.c
@@ -22,10 +22,10 @@
 #include <linux/bitops.h>
 #include <linux/platform_device.h>
 #include <linux/spinlock.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 
 #include <asm/hardware.h>
-#include <asm/uaccess.h>
-#include <asm/io.h>
 
 #define MODULE_NAME "DAVINCI-WDT: "
 
@@ -143,9 +143,8 @@ static struct watchdog_info ident = {
 	.identity = "DaVinci Watchdog",
 };
 
-static int
-davinci_wdt_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-		  unsigned long arg)
+static long davinci_wdt_ioctl(struct file *file,
+					unsigned int cmd, unsigned long arg)
 {
 	int ret = -ENOTTY;
 
@@ -184,7 +183,7 @@ static const struct file_operations davinci_wdt_fops = {
 	.owner = THIS_MODULE,
 	.llseek = no_llseek,
 	.write = davinci_wdt_write,
-	.ioctl = davinci_wdt_ioctl,
+	.unlocked_ioctl = davinci_wdt_ioctl,
 	.open = davinci_wdt_open,
 	.release = davinci_wdt_release,
 };

