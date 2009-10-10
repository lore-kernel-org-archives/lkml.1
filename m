Return-Path: <linux-kernel-owner+w=401wt.eu-S1761829AbZJJPhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761829AbZJJPhX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 11:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761757AbZJJPhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 11:37:20 -0400
Received: from www.tglx.de ([62.245.132.106]:55275 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761738AbZJJPhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 11:37:18 -0400
Message-Id: <20091010153349.196074920@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 10 Oct 2009 15:35:39 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>
Subject: [patch 04/28] x86: Remove BKL from microcode
References: <20091010153314.827301943@linutronix.de>
Content-Disposition: inline; filename=x86-remove-bkl-from-micro-code.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cycle_lock_kernel() in microcode_open() is a worthless exercise as
there is nothing to wait for. Remove it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/microcode_core.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-2.6-tip/arch/x86/kernel/microcode_core.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/microcode_core.c
+++ linux-2.6-tip/arch/x86/kernel/microcode_core.c
@@ -73,7 +73,6 @@
 #include <linux/platform_device.h>
 #include <linux/miscdevice.h>
 #include <linux/capability.h>
-#include <linux/smp_lock.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
@@ -201,7 +200,6 @@ static int do_microcode_update(const voi
 
 static int microcode_open(struct inode *unused1, struct file *unused2)
 {
-	cycle_kernel_lock();
 	return capable(CAP_SYS_RAWIO) ? 0 : -EPERM;
 }
 


