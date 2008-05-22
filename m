Return-Path: <linux-kernel-owner+w=401wt.eu-S1763325AbYEVVWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763325AbYEVVWs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761498AbYEVVVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:21:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44088 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759789AbYEVVVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:21:49 -0400
Date: Thu, 22 May 2008 22:09:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] pcwd: A couple of watchdogs escaped conversion
Message-ID: <20080522220917.04b5870d@core>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix them up. Once we know the long term plan the watchdogs can all get
shrunk massively anyway

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/watchdog/pcwd_pci.c b/drivers/watchdog/pcwd_pci.c
index 61a89e9..a5aa0ec 100644
--- a/drivers/watchdog/pcwd_pci.c
+++ b/drivers/watchdog/pcwd_pci.c
@@ -455,8 +455,8 @@ static ssize_t pcipcwd_write(struct file *file, const char __user *data,
 	return len;
 }
 
-static int pcipcwd_ioctl(struct inode *inode, struct file *file,
-			  unsigned int cmd, unsigned long arg)
+static long pcipcwd_ioctl(struct file *file, unsigned int cmd,
+						unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
@@ -478,9 +478,7 @@ static int pcipcwd_ioctl(struct inode *inode, struct file *file,
 		case WDIOC_GETSTATUS:
 		{
 			int status;
-
 			pcipcwd_get_status(&status);
-
 			return put_user(status, p);
 		}
 
@@ -644,7 +642,7 @@ static const struct file_operations pcipcwd_fops = {
 	.owner =	THIS_MODULE,
 	.llseek =	no_llseek,
 	.write =	pcipcwd_write,
-	.ioctl =	pcipcwd_ioctl,
+	.unlocked_ioctl = pcipcwd_ioctl,
 	.open =		pcipcwd_open,
 	.release =	pcipcwd_release,
 };
diff --git a/drivers/watchdog/pcwd_usb.c b/drivers/watchdog/pcwd_usb.c
index bf443d0..5421573 100644
--- a/drivers/watchdog/pcwd_usb.c
+++ b/drivers/watchdog/pcwd_usb.c
@@ -369,8 +369,8 @@ static ssize_t usb_pcwd_write(struct file *file, const char __user *data,
 	return len;
 }
 
-static int usb_pcwd_ioctl(struct inode *inode, struct file *file,
-			  unsigned int cmd, unsigned long arg)
+static long usb_pcwd_ioctl(struct file *file, unsigned int cmd,
+						unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
@@ -535,7 +535,7 @@ static const struct file_operations usb_pcwd_fops = {
 	.owner =	THIS_MODULE,
 	.llseek =	no_llseek,
 	.write =	usb_pcwd_write,
-	.ioctl =	usb_pcwd_ioctl,
+	.unlocked_ioctl = usb_pcwd_ioctl,
 	.open =		usb_pcwd_open,
 	.release =	usb_pcwd_release,
 };
