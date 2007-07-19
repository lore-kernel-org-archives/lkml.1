Return-Path: <linux-kernel-owner+w=401wt.eu-S1765894AbXGSKIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765894AbXGSKIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:08:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758133AbXGSJz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:55:28 -0400
Received: from mail.suse.de ([195.135.220.2]:35368 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333AbXGSJzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:55:14 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: chrisw@sous-sol.org, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [23/58] i386: remove pit_interrupt_hook
Message-Id: <20070719095508.70C1C14E06@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:55:08 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Chris Wright <chrisw@sous-sol.org>

Remove pit_interrupt_hook as it adds just an extra layer.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 include/asm-i386/i8253.h                 |   11 -----------
 include/asm-i386/mach-default/do_timer.h |    2 +-
 include/asm-i386/mach-voyager/do_timer.h |    2 +-
 3 files changed, 2 insertions(+), 13 deletions(-)

Index: linux/include/asm-i386/i8253.h
===================================================================
--- linux.orig/include/asm-i386/i8253.h
+++ linux/include/asm-i386/i8253.h
@@ -7,15 +7,4 @@ extern spinlock_t i8253_lock;
 
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
 #endif	/* __ASM_I8253_H__ */
Index: linux/include/asm-i386/mach-default/do_timer.h
===================================================================
--- linux.orig/include/asm-i386/mach-default/do_timer.h
+++ linux/include/asm-i386/mach-default/do_timer.h
@@ -12,5 +12,5 @@
 
 static inline void do_timer_interrupt_hook(void)
 {
-	pit_interrupt_hook();
+	global_clock_event->event_handler(global_clock_event);
 }
Index: linux/include/asm-i386/mach-voyager/do_timer.h
===================================================================
--- linux.orig/include/asm-i386/mach-voyager/do_timer.h
+++ linux/include/asm-i386/mach-voyager/do_timer.h
@@ -12,7 +12,7 @@
  **/
 static inline void do_timer_interrupt_hook(void)
 {
-	pit_interrupt_hook();
+	global_clock_event->event_handler(global_clock_event);
 	voyager_timer_interrupt();
 }
 
