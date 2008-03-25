Return-Path: <linux-kernel-owner+w=401wt.eu-S1758765AbYCYQam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765AbYCYQam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 12:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757204AbYCYQ3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 12:29:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757007AbYCYQ3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 12:29:54 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, yhlu.kernel@gmail.com
Subject: [PATCH 1/2] [PATCH] move ipi definitions to mach_ipi.h
Date: Tue, 25 Mar 2008 13:28:56 -0300
Message-Id: <1206462537-8427-2-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.2.2532.gdeda
In-Reply-To: <1206462537-8427-1-git-send-email-gcosta@redhat.com>
References: <20080325150630.GA13828@elte.hu>
 <1206462537-8427-1-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

take them out of the x86_64-only asm/mach_apic.h

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/apic_64.c               |    2 ++
 arch/x86/kernel/crash.c                 |    4 ----
 arch/x86/kernel/io_apic_64.c            |    2 ++
 arch/x86/kernel/kgdb.c                  |    6 +-----
 arch/x86/kernel/smp.c                   |    6 +-----
 arch/x86/kernel/tlb_64.c                |    3 ++-
 include/asm-x86/mach-default/mach_ipi.h |   10 ++++++++++
 include/asm-x86/mach_apic.h             |    3 ---
 8 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 5362cfd..206278f 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -41,6 +41,8 @@
 #include <asm/timex.h>
 #include <asm/apic.h>
 
+#include <mach_ipi.h>
+
 int disable_apic_timer __cpuinitdata;
 static int apic_calibrate_pmtmr __initdata;
 int disable_apic;
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index 9a5fa0a..2251d0a 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -26,11 +26,7 @@
 #include <linux/kdebug.h>
 #include <asm/smp.h>
 
-#ifdef CONFIG_X86_32
 #include <mach_ipi.h>
-#else
-#include <asm/mach_apic.h>
-#endif
 
 /* This keeps a track of which one is crashing cpu. */
 static int crashing_cpu;
diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index 1627c0d..7d5cdf3 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -50,6 +50,8 @@
 #include <asm/msidef.h>
 #include <asm/hypertransport.h>
 
+#include <mach_ipi.h>
+
 struct irq_cfg {
 	cpumask_t domain;
 	cpumask_t old_domain;
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 8c7e555..0acc610 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -46,11 +46,7 @@
 #include <asm/apicdef.h>
 #include <asm/system.h>
 
-#ifdef CONFIG_X86_32
-# include <mach_ipi.h>
-#else
-# include <asm/mach_apic.h>
-#endif
+#include <mach_ipi.h>
 
 /*
  * Put the error code here just in case the user cares:
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 16c52aa..8f75893 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -26,12 +26,8 @@
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
 #include <asm/proto.h>
-#ifdef CONFIG_X86_32
-#include <mach_apic.h>
 #include <mach_ipi.h>
-#else
-#include <asm/mach_apic.h>
-#endif
+#include <mach_apic.h>
 /*
  *	Some notes on x86 processor bugs affecting SMP operation:
  *
diff --git a/arch/x86/kernel/tlb_64.c b/arch/x86/kernel/tlb_64.c
index 615d848..1558e51 100644
--- a/arch/x86/kernel/tlb_64.c
+++ b/arch/x86/kernel/tlb_64.c
@@ -11,11 +11,12 @@
 #include <asm/mtrr.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
-#include <asm/mach_apic.h>
 #include <asm/mmu_context.h>
 #include <asm/proto.h>
 #include <asm/apicdef.h>
 #include <asm/idle.h>
+
+#include <mach_ipi.h>
 /*
  *	Smarter SMP flushing macros.
  *		c/o Linus Torvalds.
diff --git a/include/asm-x86/mach-default/mach_ipi.h b/include/asm-x86/mach-default/mach_ipi.h
index 0dba244..be32336 100644
--- a/include/asm-x86/mach-default/mach_ipi.h
+++ b/include/asm-x86/mach-default/mach_ipi.h
@@ -9,10 +9,15 @@ void __send_IPI_shortcut(unsigned int shortcut, int vector);
 
 extern int no_broadcast;
 
+#ifdef CONFIG_X86_64
+#include <asm/genapic.h>
+#define send_IPI_mask (genapic->send_IPI_mask)
+#else
 static inline void send_IPI_mask(cpumask_t mask, int vector)
 {
 	send_IPI_mask_bitmask(mask, vector);
 }
+#endif
 
 static inline void __local_send_IPI_allbutself(int vector)
 {
@@ -33,6 +38,10 @@ static inline void __local_send_IPI_all(int vector)
 		__send_IPI_shortcut(APIC_DEST_ALLINC, vector);
 }
 
+#ifdef CONFIG_X86_64
+#define send_IPI_allbutself (genapic->send_IPI_allbutself)
+#define send_IPI_all (genapic->send_IPI_all)
+#else
 static inline void send_IPI_allbutself(int vector)
 {
 	/*
@@ -50,5 +59,6 @@ static inline void send_IPI_all(int vector)
 {
 	__local_send_IPI_all(vector);
 }
+#endif
 
 #endif /* __ASM_MACH_IPI_H */
diff --git a/include/asm-x86/mach_apic.h b/include/asm-x86/mach_apic.h
index 7b7115a..1bc68c0 100644
--- a/include/asm-x86/mach_apic.h
+++ b/include/asm-x86/mach_apic.h
@@ -20,9 +20,6 @@
 #define vector_allocation_domain	(genapic->vector_allocation_domain)
 #define apic_id_registered (genapic->apic_id_registered)
 #define init_apic_ldr (genapic->init_apic_ldr)
-#define send_IPI_mask (genapic->send_IPI_mask)
-#define send_IPI_allbutself (genapic->send_IPI_allbutself)
-#define send_IPI_all (genapic->send_IPI_all)
 #define cpu_mask_to_apicid (genapic->cpu_mask_to_apicid)
 #define phys_pkg_id	(genapic->phys_pkg_id)
 
-- 
1.5.0.6

