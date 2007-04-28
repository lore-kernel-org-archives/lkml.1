Return-Path: <linux-kernel-owner+w=401wt.eu-S1163279AbXD1SPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163279AbXD1SPx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 14:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161175AbXD1SOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 14:14:50 -0400
Received: from mx1.suse.de ([195.135.220.2]:34425 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163296AbXD1Rwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:52:41 -0400
From: Andi Kleen <ak@suse.de>
References: <20070428752.712152000@suse.de>
In-Reply-To: <20070428752.712152000@suse.de>
To: takada <takada@mbf.nifty.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, patches@x86-64.org
Subject: [PATCH] [15/35] i386: pit_latch_buggy has no effect
Message-Id: <20070428175239.D48B9151CA@wotan.suse.de>
Date: Sat, 28 Apr 2007 19:52:39 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: takada <takada@mbf.nifty.com>

Eliminated the arch/i386/kernel/timers in 2.6.18, use clocksoures instead. 
pit_latch_buggy was referred in timers/timer_tsc.c, and currently removed. 
Therefore nobody refer it.

Until 2.6.17, MediaGX's TSC works correctly.  after 2.6.18, warned "TSC
appears to be running slowly.  Marking it as unstable".  So marked unstable
TSC when CS55x0.

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/i386/kernel/cpu/cyrix.c |    2 +-
 arch/i386/kernel/time.c      |    2 --
 include/asm-i386/timer.h     |    2 --
 3 files changed, 1 insertion(+), 5 deletions(-)

Index: linux/arch/i386/kernel/cpu/cyrix.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/cyrix.c
+++ linux/arch/i386/kernel/cpu/cyrix.c
@@ -279,7 +279,7 @@ static void __cpuinit init_cyrix(struct 
 		 */  
 		if (vendor == PCI_VENDOR_ID_CYRIX &&
 	 (device == PCI_DEVICE_ID_CYRIX_5510 || device == PCI_DEVICE_ID_CYRIX_5520))
-			pit_latch_buggy = 1;
+			mark_tsc_unstable();
 	}
 #endif
 		c->x86_cache_size=16;	/* Yep 16K integrated cache thats it */
Index: linux/arch/i386/kernel/time.c
===================================================================
--- linux.orig/arch/i386/kernel/time.c
+++ linux/arch/i386/kernel/time.c
@@ -70,8 +70,6 @@
 
 #include <asm/i8259.h>
 
-int pit_latch_buggy;              /* extern */
-
 #include "do_timer.h"
 
 unsigned int cpu_khz;	/* Detected as we calibrate the TSC */
Index: linux/include/asm-i386/timer.h
===================================================================
--- linux.orig/include/asm-i386/timer.h
+++ linux/include/asm-i386/timer.h
@@ -9,8 +9,6 @@ void setup_pit_timer(void);
 unsigned long long native_sched_clock(void);
 unsigned long native_calculate_cpu_khz(void);
 
-/* Modifiers for buggy PIT handling */
-extern int pit_latch_buggy;
 extern int timer_ack;
 extern int no_timer_check;
 extern int no_sync_cmos_clock;
