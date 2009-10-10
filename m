Return-Path: <linux-kernel-owner+w=401wt.eu-S934402AbZJJPj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934402AbZJJPj3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 11:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761699AbZJJPj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 11:39:27 -0400
Received: from www.tglx.de ([62.245.132.106]:55669 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761644AbZJJPjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 11:39:25 -0400
Message-Id: <20091010153350.086917493@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 10 Oct 2009 15:37:26 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>,
       Kyle McMartin <kyle@parisc-linux.org>
Subject: [patch 25/28] parisc: Remove BKL from eisa_eeprom
References: <20091010153314.827301943@linutronix.de>
Content-Disposition: inline; filename=parisc-eisa-eeprom-remove-bkl.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the empty ioctl and the cycle_kernel_lock() in
eisa_eeprom_open() which got there with the big BKL push down. There
is nothing to wait for and sychronize with after the misc device has
been registered.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Kyle McMartin <kyle@parisc-linux.org>
---
 drivers/parisc/eisa_eeprom.c |   10 ----------
 1 file changed, 10 deletions(-)

Index: linux-2.6-tip/drivers/parisc/eisa_eeprom.c
===================================================================
--- linux-2.6-tip.orig/drivers/parisc/eisa_eeprom.c
+++ linux-2.6-tip/drivers/parisc/eisa_eeprom.c
@@ -75,17 +75,8 @@ static ssize_t eisa_eeprom_read(struct f
 	return ret;
 }
 
-static int eisa_eeprom_ioctl(struct inode *inode, struct file *file, 
-			   unsigned int cmd,
-			   unsigned long arg)
-{
-	return -ENOTTY;
-}
-
 static int eisa_eeprom_open(struct inode *inode, struct file *file)
 {
-	cycle_kernel_lock();
-
 	if (file->f_mode & FMODE_WRITE)
 		return -EINVAL;
    
@@ -104,7 +95,6 @@ static const struct file_operations eisa
 	.owner =	THIS_MODULE,
 	.llseek =	eisa_eeprom_llseek,
 	.read =		eisa_eeprom_read,
-	.ioctl =	eisa_eeprom_ioctl,
 	.open =		eisa_eeprom_open,
 	.release =	eisa_eeprom_release,
 };


