Return-Path: <linux-kernel-owner+w=401wt.eu-S934178AbZLFSDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934178AbZLFSDo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 13:03:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934139AbZLFSDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 13:03:40 -0500
Received: from www.tglx.de ([62.245.132.106]:33159 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934125AbZLFSDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 13:03:04 -0500
Message-Id: <20091206111957.768090168@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 06 Dec 2009 18:02:53 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux-Arch <linux-arch@vger.kernel.org>
Subject: [patch 12/23] bkl: Fixup core_lock fallout
References: <20091206110944.492100233@linutronix.de>
Content-Disposition: inline; filename=bkl-core-lock-fixup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel_lock.c emits a warning because a raw spinlock function is used
with a spinlock. Convert BKL to raw_spinlock.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 lib/kernel_lock.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6-tip/lib/kernel_lock.c
===================================================================
--- linux-2.6-tip.orig/lib/kernel_lock.c
+++ linux-2.6-tip/lib/kernel_lock.c
@@ -23,7 +23,7 @@
  *
  * Don't use in new code.
  */
-static  __cacheline_aligned_in_smp DEFINE_SPINLOCK(kernel_flag);
+static  __cacheline_aligned_in_smp DEFINE_RAW_SPINLOCK(kernel_flag);
 
 
 /*
@@ -82,7 +82,7 @@ static inline void __lock_kernel(void)
 		 */
 		do {
 			preempt_enable();
-			while (spin_is_locked(&kernel_flag))
+			while (raw_spin_is_locked(&kernel_flag))
 				cpu_relax();
 			preempt_disable();
 		} while (!_raw_spin_trylock(&kernel_flag));


