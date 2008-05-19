Return-Path: <linux-kernel-owner+w=401wt.eu-S1764311AbYESNbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764311AbYESNbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760931AbYESNU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:20:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45957 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760923AbYESNU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:20:27 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 40/57] sbc_epx_c3_wdt: switch to unlocked_ioctl
To: akpm@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 19 May 2008 14:08:27 +0100
Message-ID: <20080519130827.31722.73712.stgit@core>
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

 drivers/watchdog/sbc_epx_c3.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)


diff --git a/drivers/watchdog/sbc_epx_c3.c b/drivers/watchdog/sbc_epx_c3.c
index 82cbd88..70ff9cb 100644
--- a/drivers/watchdog/sbc_epx_c3.c
+++ b/drivers/watchdog/sbc_epx_c3.c
@@ -25,8 +25,8 @@
 #include <linux/reboot.h>
 #include <linux/init.h>
 #include <linux/ioport.h>
-#include <asm/uaccess.h>
-#include <asm/io.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 
 #define PFX "epx_c3: "
 static int epx_c3_alive;
@@ -100,12 +100,12 @@ static ssize_t epx_c3_write(struct file *file, const char __user *data,
 	return len;
 }
 
-static int epx_c3_ioctl(struct inode *inode, struct file *file,
-			unsigned int cmd, unsigned long arg)
+static long epx_c3_ioctl(struct file *file, unsigned int cmd,
+						unsigned long arg)
 {
 	int options, retval = -EINVAL;
 	int __user *argp = (void __user *)arg;
-	static struct watchdog_info ident = {
+	static const struct watchdog_info ident = {
 		.options		= WDIOF_KEEPALIVEPING |
 					  WDIOF_MAGICCLOSE,
 		.firmware_version	= 0,
@@ -158,7 +158,7 @@ static const struct file_operations epx_c3_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= epx_c3_write,
-	.ioctl		= epx_c3_ioctl,
+	.unlocked_ioctl	= epx_c3_ioctl,
 	.open		= epx_c3_open,
 	.release	= epx_c3_release,
 };

