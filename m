Return-Path: <linux-kernel-owner+w=401wt.eu-S1758235AbXLLUpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235AbXLLUpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 15:45:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbXLLUpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 15:45:05 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:21870 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870AbXLLUpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 15:45:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=KNtDaGZf1JADKZdSE25Jv4qG9lf1P1yokR5dz7SQYNGmDwmeBOC0N47/4dtDs1waKsDEOgCXBmPKm9ig6pVnllv4Wy+J8pskILX+kpGtN94xlrkbOMiV7LdaufcBekPg3NrcmBRCSSXK6KaSm7ey3mWsgx1s4TiRs/+mjTZyiwA=
Subject: [PATCH] x86: remove fastcall from include/asm-x86
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Wed, 12 Dec 2007 12:45:02 -0800
Message-Id: <1197492302.21291.19.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/asm-x86/apic.h         |    6 +++---
 include/asm-x86/hw_irq_32.h    |   14 +++++++-------
 include/asm-x86/mutex_32.h     |    7 +++----
 include/asm-x86/semaphore_32.h |    8 ++++----
 4 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/include/asm-x86/apic.h b/include/asm-x86/apic.h
index 4230227..72bf09c 100644
--- a/include/asm-x86/apic.h
+++ b/include/asm-x86/apic.h
@@ -59,17 +59,17 @@ extern unsigned boot_cpu_id;
 #define setup_secondary_clock setup_secondary_APIC_clock
 #endif
 
-static inline fastcall void native_apic_write(unsigned long reg, u32 v)
+static inline void native_apic_write(unsigned long reg, u32 v)
 {
 	*((volatile u32 *)(APIC_BASE + reg)) = v;
 }
 
-static inline fastcall void native_apic_write_atomic(unsigned long reg, u32 v)
+static inline void native_apic_write_atomic(unsigned long reg, u32 v)
 {
 	(void) xchg((u32*)(APIC_BASE + reg), v);
 }
 
-static inline fastcall u32 native_apic_read(unsigned long reg)
+static inline u32 native_apic_read(unsigned long reg)
 {
 	return *((volatile u32 *)(APIC_BASE + reg));
 }
diff --git a/include/asm-x86/hw_irq_32.h b/include/asm-x86/hw_irq_32.h
index ca6e9fa..5914d45 100644
--- a/include/asm-x86/hw_irq_32.h
+++ b/include/asm-x86/hw_irq_32.h
@@ -29,16 +29,16 @@
 extern void (*interrupt[NR_IRQS])(void);
 
 #ifdef CONFIG_SMP
-fastcall void reschedule_interrupt(void);
-fastcall void invalidate_interrupt(void);
-fastcall void call_function_interrupt(void);
+void reschedule_interrupt(void);
+void invalidate_interrupt(void);
+void call_function_interrupt(void);
 #endif
 
 #ifdef CONFIG_X86_LOCAL_APIC
-fastcall void apic_timer_interrupt(void);
-fastcall void error_interrupt(void);
-fastcall void spurious_interrupt(void);
-fastcall void thermal_interrupt(void);
+void apic_timer_interrupt(void);
+void error_interrupt(void);
+void spurious_interrupt(void);
+void thermal_interrupt(void);
 #define platform_legacy_irq(irq)	((irq) < 16)
 #endif
 
diff --git a/include/asm-x86/mutex_32.h b/include/asm-x86/mutex_32.h
index 7a17d9e..bbeefb9 100644
--- a/include/asm-x86/mutex_32.h
+++ b/include/asm-x86/mutex_32.h
@@ -26,7 +26,7 @@ do {									\
 	unsigned int dummy;						\
 									\
 	typecheck(atomic_t *, count);					\
-	typecheck_fn(fastcall void (*)(atomic_t *), fail_fn);		\
+	typecheck_fn(void (*)(atomic_t *), fail_fn);		\
 									\
 	__asm__ __volatile__(						\
 		LOCK_PREFIX "   decl (%%eax)	\n"			\
@@ -51,8 +51,7 @@ do {									\
  * or anything the slow path function returns
  */
 static inline int
-__mutex_fastpath_lock_retval(atomic_t *count,
-			     int fastcall (*fail_fn)(atomic_t *))
+__mutex_fastpath_lock_retval(atomic_t *count, int (*fail_fn)(atomic_t *))
 {
 	if (unlikely(atomic_dec_return(count) < 0))
 		return fail_fn(count);
@@ -78,7 +77,7 @@ do {									\
 	unsigned int dummy;						\
 									\
 	typecheck(atomic_t *, count);					\
-	typecheck_fn(fastcall void (*)(atomic_t *), fail_fn);		\
+	typecheck_fn(void (*)(atomic_t *), fail_fn);		\
 									\
 	__asm__ __volatile__(						\
 		LOCK_PREFIX "   incl (%%eax)	\n"			\
diff --git a/include/asm-x86/semaphore_32.h b/include/asm-x86/semaphore_32.h
index 835c1d7..cc826e8 100644
--- a/include/asm-x86/semaphore_32.h
+++ b/include/asm-x86/semaphore_32.h
@@ -83,10 +83,10 @@ static inline void init_MUTEX_LOCKED (struct semaphore *sem)
 	sema_init(sem, 0);
 }
 
-fastcall void __down_failed(void /* special register calling convention */);
-fastcall int  __down_failed_interruptible(void  /* params in registers */);
-fastcall int  __down_failed_trylock(void  /* params in registers */);
-fastcall void __up_wakeup(void /* special register calling convention */);
+void __down_failed(void /* special register calling convention */);
+int  __down_failed_interruptible(void  /* params in registers */);
+int  __down_failed_trylock(void  /* params in registers */);
+void __up_wakeup(void /* special register calling convention */);
 
 /*
  * This is ugly, but we want the default case to fall through.
-- 
1.5.3.7.2212.gd092



