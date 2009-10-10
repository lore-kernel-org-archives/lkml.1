Return-Path: <linux-kernel-owner+w=401wt.eu-S1761761AbZJJPiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761761AbZJJPiu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 11:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761976AbZJJPim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 11:38:42 -0400
Received: from www.tglx.de ([62.245.132.106]:55576 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761944AbZJJPik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 11:38:40 -0400
Message-Id: <20091010153349.641118498@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 10 Oct 2009 15:36:30 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>,
       Jeff Dike <jdike@addtoit.com>
Subject: [patch 14/28] um: Remove BKL from random
References: <20091010153314.827301943@linutronix.de>
Content-Disposition: inline; filename=um-remove-BKL-from-random.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cycle_kernel_lock() was added during the big BKL pushdown. It should
ensure the serializiation against driver init code. In this case there
is nothing to serialize. Remove it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jeff Dike <jdike@addtoit.com>
---
 arch/um/drivers/random.c |    3 ---
 1 file changed, 3 deletions(-)

Index: linux-2.6-tip/arch/um/drivers/random.c
===================================================================
--- linux-2.6-tip.orig/arch/um/drivers/random.c
+++ linux-2.6-tip/arch/um/drivers/random.c
@@ -7,7 +7,6 @@
  * of the GNU General Public License, incorporated herein by reference.
  */
 #include <linux/sched.h>
-#include <linux/smp_lock.h>
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/interrupt.h>
@@ -34,8 +33,6 @@ static DECLARE_WAIT_QUEUE_HEAD(host_read
 
 static int rng_dev_open (struct inode *inode, struct file *filp)
 {
-	cycle_kernel_lock();
-
 	/* enforce read-only access to this chrdev */
 	if ((filp->f_mode & FMODE_READ) == 0)
 		return -EINVAL;


