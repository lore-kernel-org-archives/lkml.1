Return-Path: <linux-kernel-owner+w=401wt.eu-S932769AbZJJPiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932769AbZJJPiJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 11:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761971AbZJJPiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 11:38:08 -0400
Received: from www.tglx.de ([62.245.132.106]:55464 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761972AbZJJPiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 11:38:06 -0400
Message-Id: <20091010153349.601625576@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 10 Oct 2009 15:36:25 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 13/28] s390: Remove BKL from prng
References: <20091010153314.827301943@linutronix.de>
Content-Disposition: inline; filename=s390-remove-bkl-from-prng.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cycle_kernel_lock() was added during the big BKL pushdown. It should
ensure the serializiation against driver init code. In this case there
is nothing to serialize. Remove it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 arch/s390/crypto/prng.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-2.6-tip/arch/s390/crypto/prng.c
===================================================================
--- linux-2.6-tip.orig/arch/s390/crypto/prng.c
+++ linux-2.6-tip/arch/s390/crypto/prng.c
@@ -6,7 +6,6 @@
 #include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/smp_lock.h>
 #include <linux/miscdevice.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
@@ -49,7 +48,6 @@ static unsigned char parm_block[32] = {
 
 static int prng_open(struct inode *inode, struct file *file)
 {
-	cycle_kernel_lock();
 	return nonseekable_open(inode, file);
 }
 


