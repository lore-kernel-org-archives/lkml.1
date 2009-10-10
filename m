Return-Path: <linux-kernel-owner+w=401wt.eu-S1761907AbZJJPhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761907AbZJJPhi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 11:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932406AbZJJPhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 11:37:36 -0400
Received: from www.tglx.de ([62.245.132.106]:55328 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761710AbZJJPhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 11:37:33 -0400
Message-Id: <20091010153349.277882707@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 10 Oct 2009 15:35:48 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>
Subject: [patch 06/28] drivers: Remove BKL from cs5535_gpio
References: <20091010153314.827301943@linutronix.de>
Content-Disposition: inline; filename=drivers-char-cs5535-gpio-remove-BKL.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The big BKL pushdown added cycle_kernel_lock(). There is nothing to
wait for in this driver. Remove it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/char/cs5535_gpio.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6-tip/drivers/char/cs5535_gpio.c
===================================================================
--- linux-2.6-tip.orig/drivers/char/cs5535_gpio.c
+++ linux-2.6-tip/drivers/char/cs5535_gpio.c
@@ -17,7 +17,7 @@
 #include <linux/cdev.h>
 #include <linux/ioport.h>
 #include <linux/pci.h>
-#include <linux/smp_lock.h>
+
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
@@ -158,7 +158,6 @@ static int cs5535_gpio_open(struct inode
 {
 	u32 m = iminor(inode);
 
-	cycle_kernel_lock();
 	/* the mask says which pins are usable by this driver */
 	if ((mask & (1 << m)) == 0)
 		return -EINVAL;


