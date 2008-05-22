Return-Path: <linux-kernel-owner+w=401wt.eu-S1762291AbYEVVGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762291AbYEVVGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755651AbYEVVGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:06:23 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40487 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755391AbYEVVGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:06:22 -0400
Date: Thu, 22 May 2008 21:53:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, malattia@linux.it
Subject: [PATCH] sonypi: Eliminate BKL in ioctls
Message-ID: <20080522215352.649309cf@core>
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

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/misc/sony-laptop.c b/drivers/misc/sony-laptop.c
index 00e48e2..7f97783 100644
--- a/drivers/misc/sony-laptop.c
+++ b/drivers/misc/sony-laptop.c
@@ -1981,8 +1981,8 @@ static int ec_read16(u8 addr, u16 *value)
 	return 0;
 }
 
-static int sonypi_misc_ioctl(struct inode *ip, struct file *fp,
-			     unsigned int cmd, unsigned long arg)
+static long sonypi_misc_ioctl(struct file *fp, unsigned int cmd, 
+							unsigned long arg)
 {
 	int ret = 0;
 	void __user *argp = (void __user *)arg;
@@ -2116,7 +2116,7 @@ static const struct file_operations sonypi_misc_fops = {
 	.open		= sonypi_misc_open,
 	.release	= sonypi_misc_release,
 	.fasync		= sonypi_misc_fasync,
-	.ioctl		= sonypi_misc_ioctl,
+	.unlocked_ioctl	= sonypi_misc_ioctl,
 };
 
 static struct miscdevice sonypi_misc_device = {
