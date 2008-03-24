Return-Path: <linux-kernel-owner+w=401wt.eu-S1753331AbYCXTxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbYCXTxX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 15:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751509AbYCXTxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 15:53:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530AbYCXTxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 15:53:14 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, yhlu.kernel@gmail.com
Subject: [PATCH 1/2] move ipi definitions to mach_ipi.h
Date: Mon, 24 Mar 2008 16:52:40 -0300
Message-Id: <1206388361-17265-1-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.2.2532.gdeda
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

take them out of the x86_64-only asm/mach_apic.h

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/apic_64.c               |    2 ++
 arch/x86/kernel/crash.c                 |    4 ----
 arch/x86/kernel/io_apic_64.c            |    2 ++
 arch/x86/kernel/smp.c                   |    6 +-----
 arch/x86/kernel/tlb_64.c                |    3 ++-
 include/asm-x86/mach-default/mach_ipi.h |   17 +++++++++++++----
 include/asm-x86/mach_apic.h             |    3 ---
 7 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 5362cfd..206278f 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -41,6 +41,8 @@ #include <asm/proto.h>
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
@@ -26,11 +26,7 @@ #include <asm/hpet.h>
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
@@ -50,6 +50,8 @@ #include <asm/nmi.h>
 #include <asm/msidef.h>
 #include <asm/hypertransport.h>
 
+#include <mach_ipi.h>
+
 struct irq_cfg {
 	cpumask_t domain;
 	cpumask_t old_domain;
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 16c52aa..8f75893 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -26,12 +26,8 @@ #include <asm/mtrr.h>
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
@@ -11,11 +11,12 @@ #include <linux/interrupt.h>
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
index 0dba244..f00467b 100644
--- a/include/asm-x86/mach-default/mach_ipi.h
+++ b/include/asm-x86/mach-default/mach_ipi.h
@@ -9,10 +9,7 @@ void __send_IPI_shortcut(unsigned int sh
 
 extern int no_broadcast;
 
-static inline void send_IPI_mask(cpumask_t mask, int vector)
-{
-	send_IPI_mask_bitmask(mask, vector);
-}
+void send_IPI_mask(cpumask_t mask, int vector);
 
 static inline void __local_send_IPI_allbutself(int vector)
 {
@@ -33,6 +30,17 @@ static inline void __local_send_IPI_all(
 		__send_IPI_shortcut(APIC_DEST_ALLINC, vector);
 }
 
+#ifdef CONFIG_X86_64
+#include <asm/genapic.h>
+#define send_IPI_mask (genapic->send_IPI_mask)
+#define send_IPI_allbutself (genapic->send_IPI_allbutself)
+#define send_IPI_all (genapic->send_IPI_all)
+#else
+static inline void send_IPI_mask(cpumask_t mask, int vector);
+{
+	send_IPI_mask_bitmask(mask, vector);
+}
+
 static inline void send_IPI_allbutself(int vector)
 {
 	/*
@@ -50,5 +58,6 @@ static inline void send_IPI_all(int vect
 {
 	__local_send_IPI_all(vector);
 }
+#endif
 
 #endif /* __ASM_MACH_IPI_H */
diff --git a/include/asm-x86/mach_apic.h b/include/asm-x86/mach_apic.h
index 7b7115a..1bc68c0 100644
--- a/include/asm-x86/mach_apic.h
+++ b/include/asm-x86/mach_apic.h
@@ -20,9 +20,6 @@ #define TARGET_CPUS	  (genapic->target_c
 #define vector_allocation_domain	(genapic->vector_allocation_domain)
 #define apic_id_registered (genapic->apic_id_registered)
 #define init_apic_ldr (genapic->init_apic_ldr)
-#define send_IPI_mask (genapic->send_IPI_mask)
-#define send_IPI_allbutself (genapic->send_IPI_allbutself)
-#define send_IPI_all (genapic->send_IPI_all)
 #define cpu_mask_to_apicid (genapic->cpu_mask_to_apicid)
 #define phys_pkg_id	(genapic->phys_pkg_id)
 
-- 
1.4.2

