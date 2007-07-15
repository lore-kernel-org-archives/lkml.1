Return-Path: <linux-kernel-owner+w=401wt.eu-S1764074AbXGOQK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764074AbXGOQK5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 12:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762270AbXGOQFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 12:05:12 -0400
Received: from www.osadl.org ([213.239.205.134]:42567 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760706AbXGOQFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 12:05:03 -0400
Message-Id: <20070715155540.773083183@inhelltoy.tec.linutronix.de>
References: <20070715155510.341941668@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sun, 15 Jul 2007 16:10:44 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch-mm 03/33] i386: remove pit_interrupt_hook
Content-Disposition: inline; filename=i386-remove-pit-interrupt-hook.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Wright <chrisw@sous-sol.org>

Remove pit_interrupt_hook as it adds just an extra layer.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---

 include/asm-i386/i8253.h                 |   11 -----------
 include/asm-i386/mach-default/do_timer.h |    2 +-
 include/asm-i386/mach-voyager/do_timer.h |    2 +-
 3 files changed, 2 insertions(+), 13 deletions(-)

Index: linux-2.6.22-rc6-mm/include/asm-i386/i8253.h
===================================================================
--- linux-2.6.22-rc6-mm.orig/include/asm-i386/i8253.h	2007-07-15 09:37:52.000000000 +0200
+++ linux-2.6.22-rc6-mm/include/asm-i386/i8253.h	2007-07-15 17:49:01.000000000 +0200
@@ -12,17 +12,6 @@ extern spinlock_t i8253_lock;
 
 extern struct clock_event_device *global_clock_event;
 
-/**
- * pit_interrupt_hook - hook into timer tick
- * @regs:	standard registers from interrupt
- *
- * Call the global clock event handler.
- **/
-static inline void pit_interrupt_hook(void)
-{
-	global_clock_event->event_handler(global_clock_event);
-}
-
 extern void setup_pit_timer(void);
 
 #endif	/* __ASM_I8253_H__ */
Index: linux-2.6.22-rc6-mm/include/asm-i386/mach-default/do_timer.h
===================================================================
--- linux-2.6.22-rc6-mm.orig/include/asm-i386/mach-default/do_timer.h	2007-04-26 05:08:32.000000000 +0200
+++ linux-2.6.22-rc6-mm/include/asm-i386/mach-default/do_timer.h	2007-07-15 09:44:10.000000000 +0200
@@ -12,5 +12,5 @@
 
 static inline void do_timer_interrupt_hook(void)
 {
-	pit_interrupt_hook();
+	global_clock_event->event_handler(global_clock_event);
 }
Index: linux-2.6.22-rc6-mm/include/asm-i386/mach-voyager/do_timer.h
===================================================================
--- linux-2.6.22-rc6-mm.orig/include/asm-i386/mach-voyager/do_timer.h	2007-04-26 05:08:32.000000000 +0200
+++ linux-2.6.22-rc6-mm/include/asm-i386/mach-voyager/do_timer.h	2007-07-15 09:44:10.000000000 +0200
@@ -12,7 +12,7 @@
  **/
 static inline void do_timer_interrupt_hook(void)
 {
-	pit_interrupt_hook();
+	global_clock_event->event_handler(global_clock_event);
 	voyager_timer_interrupt();
 }
 

-- 

