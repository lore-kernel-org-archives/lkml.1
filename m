Return-Path: <linux-kernel-owner+w=401wt.eu-S1757541AbXLLVpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541AbXLLVpg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 16:45:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbXLLVp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 16:45:28 -0500
Received: from ro-out-1112.google.com ([72.14.202.180]:14661 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbXLLVp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 16:45:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Go0fGUoe2Um2zxmM0B+6NnLyTud1qDGGg1JtcKhwgayplGHoPhZ5krKJfNoGRtUNRyo2ExQG9oCTgkO+8PbyA95mtB8hNhNqpu0T0720Z+Fp/lXEVn0Bs1blmXHMRe0rSPv36bt6cki5txJZHGCltSBm1gDHvfpu9pQkg/fJNuM=
Subject: [PATCH] Remove fastcall from linux/include
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 12 Dec 2007 13:45:25 -0800
Message-Id: <1197495925.21291.35.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] Remove fastcall from linux/include

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/linux/irq.h      |   16 ++++++++--------
 include/linux/kernel.h   |    2 +-
 include/linux/mutex.h    |   10 +++++-----
 include/linux/preempt.h  |    4 ++--
 include/linux/spinlock.h |    2 +-
 include/linux/timer.h    |    4 ++--
 6 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index efc8853..2147d4a 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -25,7 +25,7 @@
 #include <asm/irq_regs.h>
 
 struct irq_desc;
-typedef	void fastcall (*irq_flow_handler_t)(unsigned int irq,
+typedef	void (*irq_flow_handler_t)(unsigned int irq,
 					    struct irq_desc *desc);
 
 
@@ -276,19 +276,19 @@ extern int handle_IRQ_event(unsigned int irq, struct irqaction *action);
  * Built-in IRQ handlers for various IRQ types,
  * callable via desc->chip->handle_irq()
  */
-extern void fastcall handle_level_irq(unsigned int irq, struct irq_desc *desc);
-extern void fastcall handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc);
-extern void fastcall handle_edge_irq(unsigned int irq, struct irq_desc *desc);
-extern void fastcall handle_simple_irq(unsigned int irq, struct irq_desc *desc);
-extern void fastcall handle_percpu_irq(unsigned int irq, struct irq_desc *desc);
-extern void fastcall handle_bad_irq(unsigned int irq, struct irq_desc *desc);
+extern void handle_level_irq(unsigned int irq, struct irq_desc *desc);
+extern void handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc);
+extern void handle_edge_irq(unsigned int irq, struct irq_desc *desc);
+extern void handle_simple_irq(unsigned int irq, struct irq_desc *desc);
+extern void handle_percpu_irq(unsigned int irq, struct irq_desc *desc);
+extern void handle_bad_irq(unsigned int irq, struct irq_desc *desc);
 
 /*
  * Monolithic do_IRQ implementation.
  * (is an explicit fastcall, because i386 4KSTACKS calls it from assembly)
  */
 #ifndef CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ
-extern fastcall unsigned int __do_IRQ(unsigned int irq);
+extern unsigned int __do_IRQ(unsigned int irq);
 #endif
 
 /*
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 94bc996..9372a11 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -133,7 +133,7 @@ NORET_TYPE void panic(const char * fmt, ...)
 extern void oops_enter(void);
 extern void oops_exit(void);
 extern int oops_may_print(void);
-fastcall NORET_TYPE void do_exit(long error_code)
+NORET_TYPE void do_exit(long error_code)
 	ATTRIB_NORET;
 NORET_TYPE void complete_and_exit(struct completion *, long)
 	ATTRIB_NORET;
diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 6014797..16c7414 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -112,7 +112,7 @@ extern void __mutex_init(struct mutex *lock, const char *name,
  *
  * Returns 1 if the mutex is locked, 0 if unlocked.
  */
-static inline int fastcall mutex_is_locked(struct mutex *lock)
+static inline int mutex_is_locked(struct mutex *lock)
 {
 	return atomic_read(&lock->count) != 1;
 }
@@ -129,8 +129,8 @@ extern int __must_check mutex_lock_interruptible_nested(struct mutex *lock,
 #define mutex_lock(lock) mutex_lock_nested(lock, 0)
 #define mutex_lock_interruptible(lock) mutex_lock_interruptible_nested(lock, 0)
 #else
-extern void fastcall mutex_lock(struct mutex *lock);
-extern int __must_check fastcall mutex_lock_interruptible(struct mutex *lock);
+extern void mutex_lock(struct mutex *lock);
+extern int __must_check mutex_lock_interruptible(struct mutex *lock);
 
 # define mutex_lock_nested(lock, subclass) mutex_lock(lock)
 # define mutex_lock_interruptible_nested(lock, subclass) mutex_lock_interruptible(lock)
@@ -140,7 +140,7 @@ extern int __must_check fastcall mutex_lock_interruptible(struct mutex *lock);
  * NOTE: mutex_trylock() follows the spin_trylock() convention,
  *       not the down_trylock() convention!
  */
-extern int fastcall mutex_trylock(struct mutex *lock);
-extern void fastcall mutex_unlock(struct mutex *lock);
+extern int mutex_trylock(struct mutex *lock);
+extern void mutex_unlock(struct mutex *lock);
 
 #endif
diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index 484988e..23f0c54 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -11,8 +11,8 @@
 #include <linux/list.h>
 
 #ifdef CONFIG_DEBUG_PREEMPT
-  extern void fastcall add_preempt_count(int val);
-  extern void fastcall sub_preempt_count(int val);
+  extern void add_preempt_count(int val);
+  extern void sub_preempt_count(int val);
 #else
 # define add_preempt_count(val)	do { preempt_count() += (val); } while (0)
 # define sub_preempt_count(val)	do { preempt_count() -= (val); } while (0)
diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index c376f3b..f80efca 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -71,7 +71,7 @@
 #define LOCK_SECTION_END                        \
         ".previous\n\t"
 
-#define __lockfunc fastcall __attribute__((section(".spinlock.text")))
+#define __lockfunc __attribute__((section(".spinlock.text")))
 
 /*
  * Pull the raw_spinlock_t and raw_rwlock_t definitions:
diff --git a/include/linux/timer.h b/include/linux/timer.h
index de0e713..7ccfb2c 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -35,8 +35,8 @@ extern struct tvec_base boot_tvec_bases;
 	struct timer_list _name =				\
 		TIMER_INITIALIZER(_function, _expires, _data)
 
-void fastcall init_timer(struct timer_list * timer);
-void fastcall init_timer_deferrable(struct timer_list *timer);
+void init_timer(struct timer_list * timer);
+void init_timer_deferrable(struct timer_list *timer);
 
 static inline void setup_timer(struct timer_list * timer,
 				void (*function)(unsigned long),
-- 
1.5.3.7.2212.gd092



