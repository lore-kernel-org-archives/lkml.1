Return-Path: <linux-kernel-owner+w=401wt.eu-S1757873AbXFPK3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873AbXFPK3w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 06:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755288AbXFPKY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 06:24:27 -0400
Received: from www.osadl.org ([213.239.205.134]:37228 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754709AbXFPKYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 06:24:21 -0400
Message-Id: <20070616101637.226868751@inhelltoy.tec.linutronix.de>
References: <20070616101126.296384219@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sat, 16 Jun 2007 10:36:18 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [patch-mm 18/25] i386: move setup_pit_timer to the correct header file
Content-Disposition: inline; filename=i386-move-pit-setup-to-i8253-h.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

setup_pit_timer is declared in asm-i386/timer.h. Move it to the
pit header file, so it can be used by x86_64 as well.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>

---
 include/asm-i386/i8253.h |    2 ++
 include/asm-i386/timer.h |    1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.22-rc4-mm/include/asm-i386/i8253.h
===================================================================
--- linux-2.6.22-rc4-mm.orig/include/asm-i386/i8253.h	2007-06-16 12:10:20.000000000 +0200
+++ linux-2.6.22-rc4-mm/include/asm-i386/i8253.h	2007-06-16 12:10:24.000000000 +0200
@@ -18,4 +18,6 @@ static inline void pit_interrupt_hook(vo
 	global_clock_event->event_handler(global_clock_event);
 }
 
+extern void setup_pit_timer(void);
+
 #endif	/* __ASM_I8253_H__ */
Index: linux-2.6.22-rc4-mm/include/asm-i386/timer.h
===================================================================
--- linux-2.6.22-rc4-mm.orig/include/asm-i386/timer.h	2007-06-16 12:10:24.000000000 +0200
+++ linux-2.6.22-rc4-mm/include/asm-i386/timer.h	2007-06-16 12:10:24.000000000 +0200
@@ -6,7 +6,6 @@
 
 #define TICK_SIZE (tick_nsec / 1000)
 
-void setup_pit_timer(void);
 unsigned long long native_sched_clock(void);
 unsigned long native_calculate_cpu_khz(void);
 

-- 

