Return-Path: <linux-kernel-owner+w=401wt.eu-S934384AbZJJPj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934384AbZJJPj6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 11:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761795AbZJJPj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 11:39:28 -0400
Received: from www.tglx.de ([62.245.132.106]:55664 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934353AbZJJPjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 11:39:22 -0400
Message-Id: <20091010153350.167321547@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 10 Oct 2009 15:37:36 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>,
       Jim Cromie <jim.cromie@gmail.com>
Subject: [patch 27/28] drivers: Remove BKL from scx200_gpio
References: <20091010153314.827301943@linutronix.de>
Content-Disposition: inline; filename=scx200_gpio-remove-bkl.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cycle_kernel_lock() was added during the big BKL pushdown. It should
ensure the serializiation against driver init code. In this case there
is nothing to serialize. Remove it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jim Cromie <jim.cromie@gmail.com>
---
 drivers/char/scx200_gpio.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-2.6-tip/drivers/char/scx200_gpio.c
===================================================================
--- linux-2.6-tip.orig/drivers/char/scx200_gpio.c
+++ linux-2.6-tip/drivers/char/scx200_gpio.c
@@ -12,7 +12,6 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
-#include <linux/smp_lock.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
@@ -52,7 +51,6 @@ static int scx200_gpio_open(struct inode
 	unsigned m = iminor(inode);
 	file->private_data = &scx200_gpio_ops;
 
-	cycle_kernel_lock();
 	if (m >= MAX_PINS)
 		return -EINVAL;
 	return nonseekable_open(inode, file);


