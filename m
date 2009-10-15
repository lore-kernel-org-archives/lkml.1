Return-Path: <linux-kernel-owner+w=401wt.eu-S934928AbZJOItG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934928AbZJOItG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 04:49:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932258AbZJOIss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 04:48:48 -0400
Received: from www.tglx.de ([62.245.132.106]:34189 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755699AbZJOIsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 04:48:47 -0400
Message-Id: <20091015083933.997426614@linutronix.de>
User-Agent: quilt/0.47-1
Date: Thu, 15 Oct 2009 08:42:44 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arnd Bergmann <arnd@arndb.de>,
       ALan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jeff Dike <jdike@addtoit.com>
Subject: [patch 6/7] um: Convert mmapper to unlocked_ioctl
References: <20091015083906.716130653@linutronix.de>
Content-Disposition: inline;
	filename=um-convert-mmapper-to-unlocked-ioctl.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ioctl is empty and needs no serialization. We might remove it
completely but that would change the return value from -ENOIOCTLCMD to
-ENOTTY.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jeff Dike <jdike@addtoit.com>
---
 arch/um/drivers/mmapper_kern.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6-tip/arch/um/drivers/mmapper_kern.c
===================================================================
--- linux-2.6-tip.orig/arch/um/drivers/mmapper_kern.c
+++ linux-2.6-tip/arch/um/drivers/mmapper_kern.c
@@ -46,8 +46,8 @@ static ssize_t mmapper_write(struct file
 	return count;
 }
 
-static int mmapper_ioctl(struct inode *inode, struct file *file,
-			 unsigned int cmd, unsigned long arg)
+static long mmapper_ioctl(struct file *file, unsigned int cmd,
+			  unsigned long arg)
 {
 	return -ENOIOCTLCMD;
 }
@@ -91,7 +91,7 @@ static const struct file_operations mmap
 	.owner		= THIS_MODULE,
 	.read		= mmapper_read,
 	.write		= mmapper_write,
-	.ioctl		= mmapper_ioctl,
+	.unlocked_ioctl	= mmapper_ioctl,
 	.mmap		= mmapper_mmap,
 	.open		= mmapper_open,
 	.release	= mmapper_release,


