Return-Path: <linux-kernel-owner+w=401wt.eu-S938142AbXGSOBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938142AbXGSOBx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 10:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937468AbXGSNtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:49:01 -0400
Received: from ns2.suse.de ([195.135.220.15]:48644 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764856AbXGSNs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:48:58 -0400
From: Andi Kleen <ak@suse.de>
References: <20070719348.540885000@suse.de>
In-Reply-To: <20070719348.540885000@suse.de>
To: tglx@linutronix.de, ak@suse.de, mingo@elte.hu, johnstul@us.ibm.com,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: [PATCH for review] [27/48] i386: move PIT function declarations and constants to correct header file
Message-Id: <20070719134857.476F914E6E@wotan.suse.de>
Date: Thu, 19 Jul 2007 15:48:57 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Thomas Gleixner <tglx@linutronix.de>

setup_pit_timer is declared in asm-i386/timer.h.  Move it to the pit header
file, so it can be used by x86_64 as well.

Move also the PIT constants.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/i8253.c                 |    2 --
 arch/i386/kernel/vmiclock.c              |    1 +
 include/asm-i386/i8253.h                 |    7 +++++++
 include/asm-i386/mach-default/io_ports.h |    5 -----
 include/asm-i386/timer.h                 |    1 -
 5 files changed, 8 insertions(+), 8 deletions(-)

Index: linux/arch/i386/kernel/i8253.c
===================================================================
--- linux.orig/arch/i386/kernel/i8253.c
+++ linux/arch/i386/kernel/i8253.c
@@ -15,8 +15,6 @@
 #include <asm/io.h>
 #include <asm/timer.h>
 
-#include "io_ports.h"
-
 DEFINE_SPINLOCK(i8253_lock);
 EXPORT_SYMBOL(i8253_lock);
 
Index: linux/arch/i386/kernel/vmiclock.c
===================================================================
--- linux.orig/arch/i386/kernel/vmiclock.c
+++ linux/arch/i386/kernel/vmiclock.c
@@ -32,6 +32,7 @@
 #include <asm/apicdef.h>
 #include <asm/apic.h>
 #include <asm/timer.h>
+#include <asm/i8253.h>
 
 #include <irq_vectors.h>
 #include "io_ports.h"
Index: linux/include/asm-i386/i8253.h
===================================================================
--- linux.orig/include/asm-i386/i8253.h
+++ linux/include/asm-i386/i8253.h
@@ -3,8 +3,15 @@
 
 #include <linux/clockchips.h>
 
+/* i8253A PIT registers */
+#define PIT_MODE		0x43
+#define PIT_CH0			0x40
+#define PIT_CH2			0x42
+
 extern spinlock_t i8253_lock;
 
 extern struct clock_event_device *global_clock_event;
 
+extern void setup_pit_timer(void);
+
 #endif	/* __ASM_I8253_H__ */
Index: linux/include/asm-i386/mach-default/io_ports.h
===================================================================
--- linux.orig/include/asm-i386/mach-default/io_ports.h
+++ linux/include/asm-i386/mach-default/io_ports.h
@@ -7,11 +7,6 @@
 #ifndef _MACH_IO_PORTS_H
 #define _MACH_IO_PORTS_H
 
-/* i8253A PIT registers */
-#define PIT_MODE		0x43
-#define PIT_CH0			0x40
-#define PIT_CH2			0x42
-
 /* i8259A PIC registers */
 #define PIC_MASTER_CMD		0x20
 #define PIC_MASTER_IMR		0x21
Index: linux/include/asm-i386/timer.h
===================================================================
--- linux.orig/include/asm-i386/timer.h
+++ linux/include/asm-i386/timer.h
@@ -5,7 +5,6 @@
 
 #define TICK_SIZE (tick_nsec / 1000)
 
-void setup_pit_timer(void);
 unsigned long native_calculate_cpu_khz(void);
 
 extern int timer_ack;
