Return-Path: <linux-kernel-owner+w=401wt.eu-S1755143AbXJXCHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143AbXJXCHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 22:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755479AbXJXCE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 22:04:28 -0400
Received: from rex.snapgear.com ([203.143.235.140]:34309 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755412AbXJXCE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 22:04:26 -0400
Date: Wed, 24 Oct 2007 12:04:13 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200710240204.l9O24DuX016693@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: remove unused machdep variable definitions
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove old definitions of the timer function pointers.
Add definitions of the common hardware timer functions.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.23/include/asm-m68knommu/machdep.h linux-2.6.23-uc0/include/asm-m68knommu/machdep.h
--- linux-2.6.23/include/asm-m68knommu/machdep.h	2007-10-19 10:21:31.000000000 +1000
+++ linux-2.6.23-uc0/include/asm-m68knommu/machdep.h	2007-10-19 10:32:28.000000000 +1000
@@ -3,9 +3,13 @@
 
 #include <linux/interrupt.h>
 
-extern void (*mach_sched_init) (irq_handler_t handler);
-/* machine dependent timer functions */
-extern unsigned long (*mach_gettimeoffset)(void);
+/* Hardware clock functions */
+extern void hw_timer_init(void);
+extern unsigned long hw_timer_offset(void);
+
+extern irqreturn_t arch_timer_interrupt(int irq, void *dummy);
+
+/* Machine dependent time handling */
 extern void (*mach_gettod)(int *year, int *mon, int *day, int *hour,
 			   int *min, int *sec);
 extern int (*mach_set_clock_mmss)(unsigned long);
@@ -16,6 +20,5 @@ extern void (*mach_halt)( void );
 extern void (*mach_power_off)( void );
 
 extern void config_BSP(char *command, int len);
-extern void (*mach_tick)(void);
 
 #endif /* _M68KNOMMU_MACHDEP_H */
