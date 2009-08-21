Return-Path: <linux-kernel-owner+w=401wt.eu-S933033AbZHUVdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933033AbZHUVdW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933020AbZHUVdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:33:17 -0400
Received: from www.tglx.de ([62.245.132.106]:51902 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932950AbZHUVdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:33:14 -0400
Message-Id: <20090821205602.876328774@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 21 Aug 2009 21:31:25 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: x86 team <x86@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: [RFC patch 22/32] x86: Remove do_timer hook
References: <20090821205008.518392436@linutronix.de>
Content-Disposition: inline; filename=x86-remove-do-timer-hook.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a left over of the old x86 sub arch support. Remove it and
open code it like we do in time_64.c

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/do_timer.h |   16 ----------------
 arch/x86/kernel/time_32.c       |    7 ++++---
 2 files changed, 4 insertions(+), 19 deletions(-)

Index: linux-2.6/arch/x86/include/asm/do_timer.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/do_timer.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/* defines for inline arch setup functions */
-#include <linux/clockchips.h>
-
-#include <asm/i8259.h>
-#include <asm/i8253.h>
-
-/**
- * do_timer_interrupt_hook - hook into timer tick
- *
- * Call the pit clock event handler. see asm/i8253.h
- **/
-
-static inline void do_timer_interrupt_hook(void)
-{
-	global_clock_event->event_handler(global_clock_event);
-}
Index: linux-2.6/arch/x86/kernel/time_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/time_32.c
+++ linux-2.6/arch/x86/kernel/time_32.c
@@ -28,6 +28,7 @@
  *	serialize accesses to xtime/lost_ticks).
  */
 
+#include <linux/clockchips.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/time.h>
@@ -37,8 +38,8 @@
 #include <asm/hpet.h>
 #include <asm/time.h>
 #include <asm/timer.h>
-
-#include <asm/do_timer.h>
+#include <asm/i8259.h>
+#include <asm/i8253.h>
 
 int timer_ack;
 
@@ -92,7 +93,7 @@ static irqreturn_t timer_interrupt(int i
 	}
 #endif
 
-	do_timer_interrupt_hook();
+	global_clock_event->event_handler(global_clock_event);
 
 #ifdef CONFIG_MCA
 	if (MCA_bus) {


