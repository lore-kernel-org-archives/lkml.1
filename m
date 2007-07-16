Return-Path: <linux-kernel-owner+w=401wt.eu-S1761675AbXGPMrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761675AbXGPMrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 08:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755744AbXGPMrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 08:47:11 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:50842 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbXGPMrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 08:47:09 -0400
Date: Mon, 16 Jul 2007 13:47:06 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: linux-kernel@vger.kernel.org, Molnar Ingo <mingo@elte.hu>
Subject: [PATCH] sched_cacheflush is now unused
Message-ID: <20070716124706.GA14250@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since Ingo's recent scheduler rewrite which was merged as commit
0437e109e1841607f2988891eaa36c531c6aa6ac sched_cacheflush is unused.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

diff --git a/arch/ia64/kernel/setup.c b/arch/ia64/kernel/setup.c
index 188fb73..5914739 100644
--- a/arch/ia64/kernel/setup.c
+++ b/arch/ia64/kernel/setup.c
@@ -984,15 +984,6 @@ cpu_init (void)
 	pm_idle = default_idle;
 }
 
-/*
- * On SMP systems, when the scheduler does migration-cost autodetection,
- * it needs a way to flush as much of the CPU's caches as possible.
- */
-void sched_cacheflush(void)
-{
-	ia64_sal_cache_flush(3);
-}
-
 void __init
 check_bugs (void)
 {
diff --git a/include/asm-alpha/system.h b/include/asm-alpha/system.h
index cf1021a..620c4d8 100644
--- a/include/asm-alpha/system.h
+++ b/include/asm-alpha/system.h
@@ -139,16 +139,6 @@ extern void halt(void) __attribute__((noreturn));
 struct task_struct;
 extern struct task_struct *alpha_switch_to(unsigned long, struct task_struct*);
 
-/*
- * On SMP systems, when the scheduler does migration-cost autodetection,
- * it needs a way to flush as much of the CPU's caches as possible.
- *
- * TODO: fill this in!
- */
-static inline void sched_cacheflush(void)
-{
-}
-
 #define imb() \
 __asm__ __volatile__ ("call_pal %0 #imb" : : "i" (PAL_imb) : "memory")
 
diff --git a/include/asm-arm/system.h b/include/asm-arm/system.h
index 6f8e6a6..94ea8c6 100644
--- a/include/asm-arm/system.h
+++ b/include/asm-arm/system.h
@@ -254,16 +254,6 @@ do {									\
 	last = __switch_to(prev,task_thread_info(prev), task_thread_info(next));	\
 } while (0)
 
-/*
- * On SMP systems, when the scheduler does migration-cost autodetection,
- * it needs a way to flush as much of the CPU's caches as possible.
- *
- * TODO: fill this in!
- */
-static inline void sched_cacheflush(void)
-{
-}
-
 #if defined(CONFIG_CPU_SA1100) || defined(CONFIG_CPU_SA110)
 /*
  * On the StrongARM, "swp" is terminally broken since it bypasses the
diff --git a/include/asm-arm26/system.h b/include/asm-arm26/system.h
index 4703593..e09da5f 100644
--- a/include/asm-arm26/system.h
+++ b/include/asm-arm26/system.h
@@ -110,16 +110,6 @@ do {									\
 } while (0)
 
 /*
- * On SMP systems, when the scheduler does migration-cost autodetection,
- * it needs a way to flush as much of the CPU's caches as possible.
- *
- * TODO: fill this in!
- */
-static inline void sched_cacheflush(void)
-{
-}
-
-/*
  * Save the current interrupt enable state & disable IRQs
  */
 #define local_irq_save(x)                               \
diff --git a/include/asm-i386/system.h b/include/asm-i386/system.h
index 94ed368..609756c 100644
--- a/include/asm-i386/system.h
+++ b/include/asm-i386/system.h
@@ -310,15 +310,6 @@ void enable_hlt(void);
 extern int es7000_plat;
 void cpu_idle_wait(void);
 
-/*
- * On SMP systems, when the scheduler does migration-cost autodetection,
- * it needs a way to flush as much of the CPU's caches as possible:
- */
-static inline void sched_cacheflush(void)
-{
-	wbinvd();
-}
-
 extern unsigned long arch_align_stack(unsigned long sp);
 extern void free_init_pages(char *what, unsigned long begin, unsigned long end);
 
diff --git a/include/asm-ia64/system.h b/include/asm-ia64/system.h
index 384fbf7..91bb8e0 100644
--- a/include/asm-ia64/system.h
+++ b/include/asm-ia64/system.h
@@ -259,7 +259,6 @@ extern void ia64_load_extra (struct task_struct *task);
 #define ia64_platform_is(x) (strcmp(x, platform_name) == 0)
 
 void cpu_idle_wait(void);
-void sched_cacheflush(void);
 
 #define arch_align_stack(x) (x)
 
diff --git a/include/asm-m32r/system.h b/include/asm-m32r/system.h
index 8ee73d3..2365de5 100644
--- a/include/asm-m32r/system.h
+++ b/include/asm-m32r/system.h
@@ -54,16 +54,6 @@
 	); \
 } while(0)
 
-/*
- * On SMP systems, when the scheduler does migration-cost autodetection,
- * it needs a way to flush as much of the CPU's caches as possible.
- *
- * TODO: fill this in!
- */
-static inline void sched_cacheflush(void)
-{
-}
-
 /* Interrupt Control */
 #if !defined(CONFIG_CHIP_M32102) && !defined(CONFIG_CHIP_M32104)
 #define local_irq_enable() \
diff --git a/include/asm-mips/system.h b/include/asm-mips/system.h
index 14ea6fd..eba2e3d 100644
--- a/include/asm-mips/system.h
+++ b/include/asm-mips/system.h
@@ -71,16 +71,6 @@ do {									\
 		write_c0_userlocal(task_thread_info(current)->tp_value);\
 } while(0)
 
-/*
- * On SMP systems, when the scheduler does migration-cost autodetection,
- * it needs a way to flush as much of the CPU's caches as possible.
- *
- * TODO: fill this in!
- */
-static inline void sched_cacheflush(void)
-{
-}
-
 static inline unsigned long __xchg_u32(volatile int * m, unsigned int val)
 {
 	__u32 retval;
diff --git a/include/asm-parisc/system.h b/include/asm-parisc/system.h
index 21fbfc5..ee80c92 100644
--- a/include/asm-parisc/system.h
+++ b/include/asm-parisc/system.h
@@ -48,17 +48,6 @@ extern struct task_struct *_switch_to(struct task_struct *, struct task_struct *
 	(last) = _switch_to(prev, next);			\
 } while(0)
 
-/*
- * On SMP systems, when the scheduler does migration-cost autodetection,
- * it needs a way to flush as much of the CPU's caches as possible.
- *
- * TODO: fill this in!
- */
-static inline void sched_cacheflush(void)
-{
-}
-
-
 /* interrupt control */
 #define local_save_flags(x)	__asm__ __volatile__("ssm 0, %0" : "=r" (x) : : "memory")
 #define local_irq_disable()	__asm__ __volatile__("rsm %0,%%r0\n" : : "i" (PSW_I) : "memory" )
diff --git a/include/asm-powerpc/system.h b/include/asm-powerpc/system.h
index 09621f6..6b3e4b7 100644
--- a/include/asm-powerpc/system.h
+++ b/include/asm-powerpc/system.h
@@ -184,16 +184,6 @@ struct thread_struct;
 extern struct task_struct *_switch(struct thread_struct *prev,
 				   struct thread_struct *next);
 
-/*
- * On SMP systems, when the scheduler does migration-cost autodetection,
- * it needs a way to flush as much of the CPU's caches as possible.
- *
- * TODO: fill this in!
- */
-static inline void sched_cacheflush(void)
-{
-}
-
 extern unsigned int rtas_data;
 extern int mem_init_done;	/* set on boot once kmalloc can be called */
 extern unsigned long memory_limit;
diff --git a/include/asm-ppc/system.h b/include/asm-ppc/system.h
index d84a3cf..f1311a8 100644
--- a/include/asm-ppc/system.h
+++ b/include/asm-ppc/system.h
@@ -129,16 +129,6 @@ extern struct task_struct *__switch_to(struct task_struct *,
 	struct task_struct *);
 #define switch_to(prev, next, last)	((last) = __switch_to((prev), (next)))
 
-/*
- * On SMP systems, when the scheduler does migration-cost autodetection,
- * it needs a way to flush as much of the CPU's caches as possible.
- *
- * TODO: fill this in!
- */
-static inline void sched_cacheflush(void)
-{
-}
-
 struct thread_struct;
 extern struct task_struct *_switch(struct thread_struct *prev,
 				   struct thread_struct *next);
diff --git a/include/asm-s390/system.h b/include/asm-s390/system.h
index bbe137c..64a3cd0 100644
--- a/include/asm-s390/system.h
+++ b/include/asm-s390/system.h
@@ -97,16 +97,6 @@ static inline void restore_access_regs(unsigned int *acrs)
 	prev = __switch_to(prev,next);					     \
 } while (0)
 
-/*
- * On SMP systems, when the scheduler does migration-cost autodetection,
- * it needs a way to flush as much of the CPU's caches as possible.
- *
- * TODO: fill this in!
- */
-static inline void sched_cacheflush(void)
-{
-}
-
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING
 extern void account_vtime(struct task_struct *);
 extern void account_tick_vtime(struct task_struct *);
diff --git a/include/asm-sh/system.h b/include/asm-sh/system.h
index 82f3e22..56a9247 100644
--- a/include/asm-sh/system.h
+++ b/include/asm-sh/system.h
@@ -60,16 +60,6 @@
 	last = __last;							\
 } while (0)
 
-/*
- * On SMP systems, when the scheduler does migration-cost autodetection,
- * it needs a way to flush as much of the CPU's caches as possible.
- *
- * TODO: fill this in!
- */
-static inline void sched_cacheflush(void)
-{
-}
-
 #ifdef CONFIG_CPU_SH4A
 #define __icbi()			\
 {					\
diff --git a/include/asm-sparc/system.h b/include/asm-sparc/system.h
index 8b4e23b..d1a2572 100644
--- a/include/asm-sparc/system.h
+++ b/include/asm-sparc/system.h
@@ -165,16 +165,6 @@ extern void fpsave(unsigned long *fpregs, unsigned long *fsr,
 	} while(0)
 
 /*
- * On SMP systems, when the scheduler does migration-cost autodetection,
- * it needs a way to flush as much of the CPU's caches as possible.
- *
- * TODO: fill this in!
- */
-static inline void sched_cacheflush(void)
-{
-}
-
-/*
  * Changing the IRQ level on the Sparc.
  */
 extern void local_irq_restore(unsigned long);
diff --git a/include/asm-sparc64/system.h b/include/asm-sparc64/system.h
index 8ba380e..4090674 100644
--- a/include/asm-sparc64/system.h
+++ b/include/asm-sparc64/system.h
@@ -204,16 +204,6 @@ do {	if (test_thread_flag(TIF_PERFCTR)) {				\
 	}								\
 } while(0)
 
-/*
- * On SMP systems, when the scheduler does migration-cost autodetection,
- * it needs a way to flush as much of the CPU's caches as possible.
- *
- * TODO: fill this in!
- */
-static inline void sched_cacheflush(void)
-{
-}
-
 static inline unsigned long xchg32(__volatile__ unsigned int *m, unsigned int val)
 {
 	unsigned long tmp1, tmp2;
diff --git a/include/asm-x86_64/system.h b/include/asm-x86_64/system.h
index ead9f9a..e4f246d 100644
--- a/include/asm-x86_64/system.h
+++ b/include/asm-x86_64/system.h
@@ -111,15 +111,6 @@ static inline void write_cr4(unsigned long val)
 #define wbinvd() \
 	__asm__ __volatile__ ("wbinvd": : :"memory");
 
-/*
- * On SMP systems, when the scheduler does migration-cost autodetection,
- * it needs a way to flush as much of the CPU's caches as possible.
- */
-static inline void sched_cacheflush(void)
-{
-	wbinvd();
-}
-
 #endif	/* __KERNEL__ */
 
 #define nop() __asm__ __volatile__ ("nop")
