Return-Path: <linux-kernel-owner+w=401wt.eu-S934128AbZLFSHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934128AbZLFSHT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 13:07:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934092AbZLFSHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 13:07:16 -0500
Received: from www.tglx.de ([62.245.132.106]:33054 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934095AbZLFSC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 13:02:27 -0500
Message-Id: <20091206111957.454670287@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 06 Dec 2009 18:02:05 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux-Arch <linux-arch@vger.kernel.org>
Subject: [patch 04/23] locking: Convert raw_spinlock to arch_spinlock
References: <20091206110944.492100233@linutronix.de>
Content-Disposition: inline;
	filename=locking-convert-raw-to-arch-spinlock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The raw_spin* namespace was taken by lockdep for the architecture
specific implementations. raw_spin_* would be the ideal name space for
the spinlocks which are not converted to sleeping locks in preempt-rt.

Linus suggested to convert the raw_ to arch_ locks and cleanup the
name space instead of using an artifical name like core_spin,
atomic_spin or whatever

No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/alpha/include/asm/spinlock.h          |    6 ++---
 arch/alpha/include/asm/spinlock_types.h    |    2 -
 arch/arm/include/asm/spinlock.h            |    6 ++---
 arch/arm/include/asm/spinlock_types.h      |    2 -
 arch/blackfin/include/asm/spinlock.h       |   10 ++++-----
 arch/blackfin/include/asm/spinlock_types.h |    2 -
 arch/cris/include/arch-v32/arch/spinlock.h |   12 +++++------
 arch/ia64/include/asm/spinlock.h           |   26 ++++++++++++-------------
 arch/ia64/include/asm/spinlock_types.h     |    2 -
 arch/m32r/include/asm/spinlock.h           |    6 ++---
 arch/m32r/include/asm/spinlock_types.h     |    2 -
 arch/mips/include/asm/spinlock.h           |   10 ++++-----
 arch/mips/include/asm/spinlock_types.h     |    2 -
 arch/parisc/include/asm/atomic.h           |    6 ++---
 arch/parisc/include/asm/spinlock.h         |    8 +++----
 arch/parisc/include/asm/spinlock_types.h   |    4 +--
 arch/parisc/lib/bitops.c                   |    2 -
 arch/powerpc/include/asm/rtas.h            |    2 -
 arch/powerpc/include/asm/spinlock.h        |   14 ++++++-------
 arch/powerpc/include/asm/spinlock_types.h  |    2 -
 arch/powerpc/kernel/rtas.c                 |    2 -
 arch/powerpc/lib/locks.c                   |    4 +--
 arch/powerpc/platforms/pasemi/setup.c      |    2 -
 arch/s390/include/asm/spinlock.h           |   16 +++++++--------
 arch/s390/include/asm/spinlock_types.h     |    2 -
 arch/s390/lib/spinlock.c                   |    8 +++----
 arch/sh/include/asm/spinlock.h             |    6 ++---
 arch/sh/include/asm/spinlock_types.h       |    2 -
 arch/sparc/include/asm/spinlock_32.h       |    6 ++---
 arch/sparc/include/asm/spinlock_64.h       |    8 +++----
 arch/sparc/include/asm/spinlock_types.h    |    2 -
 arch/x86/include/asm/paravirt.h            |   12 +++++------
 arch/x86/include/asm/paravirt_types.h      |   14 ++++++-------
 arch/x86/include/asm/spinlock.h            |   30 ++++++++++++++---------------
 arch/x86/include/asm/spinlock_types.h      |    4 +--
 arch/x86/kernel/dumpstack.c                |    2 -
 arch/x86/kernel/paravirt-spinlocks.c       |    2 -
 arch/x86/kernel/tsc_sync.c                 |    2 -
 arch/x86/xen/spinlock.c                    |   16 +++++++--------
 include/asm-generic/bitops/atomic.h        |    6 ++---
 include/linux/spinlock.h                   |    4 +--
 include/linux/spinlock_types.h             |    2 -
 include/linux/spinlock_types_up.h          |    4 +--
 include/linux/spinlock_up.h                |    8 +++----
 kernel/lockdep.c                           |    2 -
 kernel/trace/ring_buffer.c                 |    4 +--
 kernel/trace/trace.c                       |   18 ++++++++---------
 kernel/trace/trace_clock.c                 |    4 +--
 kernel/trace/trace_sched_wakeup.c          |    4 +--
 kernel/trace/trace_stack.c                 |    4 +--
 lib/spinlock_debug.c                       |    2 -
 51 files changed, 164 insertions(+), 164 deletions(-)

Index: linux-2.6-tip/arch/alpha/include/asm/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/alpha/include/asm/spinlock.h
+++ linux-2.6-tip/arch/alpha/include/asm/spinlock.h
@@ -17,13 +17,13 @@
 #define __raw_spin_unlock_wait(x) \
 		do { cpu_relax(); } while ((x)->lock)
 
-static inline void __raw_spin_unlock(raw_spinlock_t * lock)
+static inline void __raw_spin_unlock(arch_spinlock_t * lock)
 {
 	mb();
 	lock->lock = 0;
 }
 
-static inline void __raw_spin_lock(raw_spinlock_t * lock)
+static inline void __raw_spin_lock(arch_spinlock_t * lock)
 {
 	long tmp;
 
@@ -43,7 +43,7 @@ static inline void __raw_spin_lock(raw_s
 	: "m"(lock->lock) : "memory");
 }
 
-static inline int __raw_spin_trylock(raw_spinlock_t *lock)
+static inline int __raw_spin_trylock(arch_spinlock_t *lock)
 {
 	return !test_and_set_bit(0, &lock->lock);
 }
Index: linux-2.6-tip/arch/alpha/include/asm/spinlock_types.h
===================================================================
--- linux-2.6-tip.orig/arch/alpha/include/asm/spinlock_types.h
+++ linux-2.6-tip/arch/alpha/include/asm/spinlock_types.h
@@ -7,7 +7,7 @@
 
 typedef struct {
 	volatile unsigned int lock;
-} raw_spinlock_t;
+} arch_spinlock_t;
 
 #define __RAW_SPIN_LOCK_UNLOCKED	{ 0 }
 
Index: linux-2.6-tip/arch/arm/include/asm/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/arm/include/asm/spinlock.h
+++ linux-2.6-tip/arch/arm/include/asm/spinlock.h
@@ -23,7 +23,7 @@
 
 #define __raw_spin_lock_flags(lock, flags) __raw_spin_lock(lock)
 
-static inline void __raw_spin_lock(raw_spinlock_t *lock)
+static inline void __raw_spin_lock(arch_spinlock_t *lock)
 {
 	unsigned long tmp;
 
@@ -43,7 +43,7 @@ static inline void __raw_spin_lock(raw_s
 	smp_mb();
 }
 
-static inline int __raw_spin_trylock(raw_spinlock_t *lock)
+static inline int __raw_spin_trylock(arch_spinlock_t *lock)
 {
 	unsigned long tmp;
 
@@ -63,7 +63,7 @@ static inline int __raw_spin_trylock(raw
 	}
 }
 
-static inline void __raw_spin_unlock(raw_spinlock_t *lock)
+static inline void __raw_spin_unlock(arch_spinlock_t *lock)
 {
 	smp_mb();
 
Index: linux-2.6-tip/arch/arm/include/asm/spinlock_types.h
===================================================================
--- linux-2.6-tip.orig/arch/arm/include/asm/spinlock_types.h
+++ linux-2.6-tip/arch/arm/include/asm/spinlock_types.h
@@ -7,7 +7,7 @@
 
 typedef struct {
 	volatile unsigned int lock;
-} raw_spinlock_t;
+} arch_spinlock_t;
 
 #define __RAW_SPIN_LOCK_UNLOCKED	{ 0 }
 
Index: linux-2.6-tip/arch/blackfin/include/asm/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/blackfin/include/asm/spinlock.h
+++ linux-2.6-tip/arch/blackfin/include/asm/spinlock.h
@@ -24,29 +24,29 @@ asmlinkage void __raw_write_lock_asm(vol
 asmlinkage int __raw_write_trylock_asm(volatile int *ptr);
 asmlinkage void __raw_write_unlock_asm(volatile int *ptr);
 
-static inline int __raw_spin_is_locked(raw_spinlock_t *lock)
+static inline int __raw_spin_is_locked(arch_spinlock_t *lock)
 {
 	return __raw_spin_is_locked_asm(&lock->lock);
 }
 
-static inline void __raw_spin_lock(raw_spinlock_t *lock)
+static inline void __raw_spin_lock(arch_spinlock_t *lock)
 {
 	__raw_spin_lock_asm(&lock->lock);
 }
 
 #define __raw_spin_lock_flags(lock, flags) __raw_spin_lock(lock)
 
-static inline int __raw_spin_trylock(raw_spinlock_t *lock)
+static inline int __raw_spin_trylock(arch_spinlock_t *lock)
 {
 	return __raw_spin_trylock_asm(&lock->lock);
 }
 
-static inline void __raw_spin_unlock(raw_spinlock_t *lock)
+static inline void __raw_spin_unlock(arch_spinlock_t *lock)
 {
 	__raw_spin_unlock_asm(&lock->lock);
 }
 
-static inline void __raw_spin_unlock_wait(raw_spinlock_t *lock)
+static inline void __raw_spin_unlock_wait(arch_spinlock_t *lock)
 {
 	while (__raw_spin_is_locked(lock))
 		cpu_relax();
Index: linux-2.6-tip/arch/blackfin/include/asm/spinlock_types.h
===================================================================
--- linux-2.6-tip.orig/arch/blackfin/include/asm/spinlock_types.h
+++ linux-2.6-tip/arch/blackfin/include/asm/spinlock_types.h
@@ -15,7 +15,7 @@
 
 typedef struct {
 	volatile unsigned int lock;
-} raw_spinlock_t;
+} arch_spinlock_t;
 
 #define __RAW_SPIN_LOCK_UNLOCKED	{ 0 }
 
Index: linux-2.6-tip/arch/cris/include/arch-v32/arch/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/cris/include/arch-v32/arch/spinlock.h
+++ linux-2.6-tip/arch/cris/include/arch-v32/arch/spinlock.h
@@ -9,12 +9,12 @@ extern void cris_spin_unlock(void *l, in
 extern void cris_spin_lock(void *l);
 extern int cris_spin_trylock(void *l);
 
-static inline int __raw_spin_is_locked(raw_spinlock_t *x)
+static inline int __raw_spin_is_locked(arch_spinlock_t *x)
 {
 	return *(volatile signed char *)(&(x)->slock) <= 0;
 }
 
-static inline void __raw_spin_unlock(raw_spinlock_t *lock)
+static inline void __raw_spin_unlock(arch_spinlock_t *lock)
 {
 	__asm__ volatile ("move.d %1,%0" \
 			  : "=m" (lock->slock) \
@@ -22,24 +22,24 @@ static inline void __raw_spin_unlock(raw
 			  : "memory");
 }
 
-static inline void __raw_spin_unlock_wait(raw_spinlock_t *lock)
+static inline void __raw_spin_unlock_wait(arch_spinlock_t *lock)
 {
 	while (__raw_spin_is_locked(lock))
 		cpu_relax();
 }
 
-static inline int __raw_spin_trylock(raw_spinlock_t *lock)
+static inline int __raw_spin_trylock(arch_spinlock_t *lock)
 {
 	return cris_spin_trylock((void *)&lock->slock);
 }
 
-static inline void __raw_spin_lock(raw_spinlock_t *lock)
+static inline void __raw_spin_lock(arch_spinlock_t *lock)
 {
 	cris_spin_lock((void *)&lock->slock);
 }
 
 static inline void
-__raw_spin_lock_flags(raw_spinlock_t *lock, unsigned long flags)
+__raw_spin_lock_flags(arch_spinlock_t *lock, unsigned long flags)
 {
 	__raw_spin_lock(lock);
 }
Index: linux-2.6-tip/arch/ia64/include/asm/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/ia64/include/asm/spinlock.h
+++ linux-2.6-tip/arch/ia64/include/asm/spinlock.h
@@ -38,7 +38,7 @@
 #define TICKET_BITS	15
 #define	TICKET_MASK	((1 << TICKET_BITS) - 1)
 
-static __always_inline void __ticket_spin_lock(raw_spinlock_t *lock)
+static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
 {
 	int	*p = (int *)&lock->lock, ticket, serve;
 
@@ -58,7 +58,7 @@ static __always_inline void __ticket_spi
 	}
 }
 
-static __always_inline int __ticket_spin_trylock(raw_spinlock_t *lock)
+static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
 {
 	int tmp = ACCESS_ONCE(lock->lock);
 
@@ -67,7 +67,7 @@ static __always_inline int __ticket_spin
 	return 0;
 }
 
-static __always_inline void __ticket_spin_unlock(raw_spinlock_t *lock)
+static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
 {
 	unsigned short	*p = (unsigned short *)&lock->lock + 1, tmp;
 
@@ -75,7 +75,7 @@ static __always_inline void __ticket_spi
 	ACCESS_ONCE(*p) = (tmp + 2) & ~1;
 }
 
-static __always_inline void __ticket_spin_unlock_wait(raw_spinlock_t *lock)
+static __always_inline void __ticket_spin_unlock_wait(arch_spinlock_t *lock)
 {
 	int	*p = (int *)&lock->lock, ticket;
 
@@ -89,53 +89,53 @@ static __always_inline void __ticket_spi
 	}
 }
 
-static inline int __ticket_spin_is_locked(raw_spinlock_t *lock)
+static inline int __ticket_spin_is_locked(arch_spinlock_t *lock)
 {
 	long tmp = ACCESS_ONCE(lock->lock);
 
 	return !!(((tmp >> TICKET_SHIFT) ^ tmp) & TICKET_MASK);
 }
 
-static inline int __ticket_spin_is_contended(raw_spinlock_t *lock)
+static inline int __ticket_spin_is_contended(arch_spinlock_t *lock)
 {
 	long tmp = ACCESS_ONCE(lock->lock);
 
 	return ((tmp - (tmp >> TICKET_SHIFT)) & TICKET_MASK) > 1;
 }
 
-static inline int __raw_spin_is_locked(raw_spinlock_t *lock)
+static inline int __raw_spin_is_locked(arch_spinlock_t *lock)
 {
 	return __ticket_spin_is_locked(lock);
 }
 
-static inline int __raw_spin_is_contended(raw_spinlock_t *lock)
+static inline int __raw_spin_is_contended(arch_spinlock_t *lock)
 {
 	return __ticket_spin_is_contended(lock);
 }
 #define __raw_spin_is_contended	__raw_spin_is_contended
 
-static __always_inline void __raw_spin_lock(raw_spinlock_t *lock)
+static __always_inline void __raw_spin_lock(arch_spinlock_t *lock)
 {
 	__ticket_spin_lock(lock);
 }
 
-static __always_inline int __raw_spin_trylock(raw_spinlock_t *lock)
+static __always_inline int __raw_spin_trylock(arch_spinlock_t *lock)
 {
 	return __ticket_spin_trylock(lock);
 }
 
-static __always_inline void __raw_spin_unlock(raw_spinlock_t *lock)
+static __always_inline void __raw_spin_unlock(arch_spinlock_t *lock)
 {
 	__ticket_spin_unlock(lock);
 }
 
-static __always_inline void __raw_spin_lock_flags(raw_spinlock_t *lock,
+static __always_inline void __raw_spin_lock_flags(arch_spinlock_t *lock,
 						  unsigned long flags)
 {
 	__raw_spin_lock(lock);
 }
 
-static inline void __raw_spin_unlock_wait(raw_spinlock_t *lock)
+static inline void __raw_spin_unlock_wait(arch_spinlock_t *lock)
 {
 	__ticket_spin_unlock_wait(lock);
 }
Index: linux-2.6-tip/arch/ia64/include/asm/spinlock_types.h
===================================================================
--- linux-2.6-tip.orig/arch/ia64/include/asm/spinlock_types.h
+++ linux-2.6-tip/arch/ia64/include/asm/spinlock_types.h
@@ -7,7 +7,7 @@
 
 typedef struct {
 	volatile unsigned int lock;
-} raw_spinlock_t;
+} arch_spinlock_t;
 
 #define __RAW_SPIN_LOCK_UNLOCKED	{ 0 }
 
Index: linux-2.6-tip/arch/m32r/include/asm/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/m32r/include/asm/spinlock.h
+++ linux-2.6-tip/arch/m32r/include/asm/spinlock.h
@@ -36,7 +36,7 @@
  * __raw_spin_trylock() tries to get the lock and returns a result.
  * On the m32r, the result value is 1 (= Success) or 0 (= Failure).
  */
-static inline int __raw_spin_trylock(raw_spinlock_t *lock)
+static inline int __raw_spin_trylock(arch_spinlock_t *lock)
 {
 	int oldval;
 	unsigned long tmp1, tmp2;
@@ -69,7 +69,7 @@ static inline int __raw_spin_trylock(raw
 	return (oldval > 0);
 }
 
-static inline void __raw_spin_lock(raw_spinlock_t *lock)
+static inline void __raw_spin_lock(arch_spinlock_t *lock)
 {
 	unsigned long tmp0, tmp1;
 
@@ -111,7 +111,7 @@ static inline void __raw_spin_lock(raw_s
 	);
 }
 
-static inline void __raw_spin_unlock(raw_spinlock_t *lock)
+static inline void __raw_spin_unlock(arch_spinlock_t *lock)
 {
 	mb();
 	lock->slock = 1;
Index: linux-2.6-tip/arch/m32r/include/asm/spinlock_types.h
===================================================================
--- linux-2.6-tip.orig/arch/m32r/include/asm/spinlock_types.h
+++ linux-2.6-tip/arch/m32r/include/asm/spinlock_types.h
@@ -7,7 +7,7 @@
 
 typedef struct {
 	volatile int slock;
-} raw_spinlock_t;
+} arch_spinlock_t;
 
 #define __RAW_SPIN_LOCK_UNLOCKED	{ 1 }
 
Index: linux-2.6-tip/arch/mips/include/asm/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/mips/include/asm/spinlock.h
+++ linux-2.6-tip/arch/mips/include/asm/spinlock.h
@@ -34,7 +34,7 @@
  * becomes equal to the the initial value of the tail.
  */
 
-static inline int __raw_spin_is_locked(raw_spinlock_t *lock)
+static inline int __raw_spin_is_locked(arch_spinlock_t *lock)
 {
 	unsigned int counters = ACCESS_ONCE(lock->lock);
 
@@ -45,7 +45,7 @@ static inline int __raw_spin_is_locked(r
 #define __raw_spin_unlock_wait(x) \
 	while (__raw_spin_is_locked(x)) { cpu_relax(); }
 
-static inline int __raw_spin_is_contended(raw_spinlock_t *lock)
+static inline int __raw_spin_is_contended(arch_spinlock_t *lock)
 {
 	unsigned int counters = ACCESS_ONCE(lock->lock);
 
@@ -53,7 +53,7 @@ static inline int __raw_spin_is_contende
 }
 #define __raw_spin_is_contended	__raw_spin_is_contended
 
-static inline void __raw_spin_lock(raw_spinlock_t *lock)
+static inline void __raw_spin_lock(arch_spinlock_t *lock)
 {
 	int my_ticket;
 	int tmp;
@@ -134,7 +134,7 @@ static inline void __raw_spin_lock(raw_s
 	smp_llsc_mb();
 }
 
-static inline void __raw_spin_unlock(raw_spinlock_t *lock)
+static inline void __raw_spin_unlock(arch_spinlock_t *lock)
 {
 	int tmp;
 
@@ -174,7 +174,7 @@ static inline void __raw_spin_unlock(raw
 	}
 }
 
-static inline unsigned int __raw_spin_trylock(raw_spinlock_t *lock)
+static inline unsigned int __raw_spin_trylock(arch_spinlock_t *lock)
 {
 	int tmp, tmp2, tmp3;
 
Index: linux-2.6-tip/arch/mips/include/asm/spinlock_types.h
===================================================================
--- linux-2.6-tip.orig/arch/mips/include/asm/spinlock_types.h
+++ linux-2.6-tip/arch/mips/include/asm/spinlock_types.h
@@ -12,7 +12,7 @@ typedef struct {
 	 * bits 15..28: ticket
 	 */
 	unsigned int lock;
-} raw_spinlock_t;
+} arch_spinlock_t;
 
 #define __RAW_SPIN_LOCK_UNLOCKED	{ 0 }
 
Index: linux-2.6-tip/arch/parisc/include/asm/atomic.h
===================================================================
--- linux-2.6-tip.orig/arch/parisc/include/asm/atomic.h
+++ linux-2.6-tip/arch/parisc/include/asm/atomic.h
@@ -27,18 +27,18 @@
 #  define ATOMIC_HASH_SIZE 4
 #  define ATOMIC_HASH(a) (&(__atomic_hash[ (((unsigned long) (a))/L1_CACHE_BYTES) & (ATOMIC_HASH_SIZE-1) ]))
 
-extern raw_spinlock_t __atomic_hash[ATOMIC_HASH_SIZE] __lock_aligned;
+extern arch_spinlock_t __atomic_hash[ATOMIC_HASH_SIZE] __lock_aligned;
 
 /* Can't use raw_spin_lock_irq because of #include problems, so
  * this is the substitute */
 #define _atomic_spin_lock_irqsave(l,f) do {	\
-	raw_spinlock_t *s = ATOMIC_HASH(l);		\
+	arch_spinlock_t *s = ATOMIC_HASH(l);		\
 	local_irq_save(f);			\
 	__raw_spin_lock(s);			\
 } while(0)
 
 #define _atomic_spin_unlock_irqrestore(l,f) do {	\
-	raw_spinlock_t *s = ATOMIC_HASH(l);			\
+	arch_spinlock_t *s = ATOMIC_HASH(l);			\
 	__raw_spin_unlock(s);				\
 	local_irq_restore(f);				\
 } while(0)
Index: linux-2.6-tip/arch/parisc/include/asm/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/parisc/include/asm/spinlock.h
+++ linux-2.6-tip/arch/parisc/include/asm/spinlock.h
@@ -5,7 +5,7 @@
 #include <asm/processor.h>
 #include <asm/spinlock_types.h>
 
-static inline int __raw_spin_is_locked(raw_spinlock_t *x)
+static inline int __raw_spin_is_locked(arch_spinlock_t *x)
 {
 	volatile unsigned int *a = __ldcw_align(x);
 	return *a == 0;
@@ -15,7 +15,7 @@ static inline int __raw_spin_is_locked(r
 #define __raw_spin_unlock_wait(x) \
 		do { cpu_relax(); } while (__raw_spin_is_locked(x))
 
-static inline void __raw_spin_lock_flags(raw_spinlock_t *x,
+static inline void __raw_spin_lock_flags(arch_spinlock_t *x,
 					 unsigned long flags)
 {
 	volatile unsigned int *a;
@@ -33,7 +33,7 @@ static inline void __raw_spin_lock_flags
 	mb();
 }
 
-static inline void __raw_spin_unlock(raw_spinlock_t *x)
+static inline void __raw_spin_unlock(arch_spinlock_t *x)
 {
 	volatile unsigned int *a;
 	mb();
@@ -42,7 +42,7 @@ static inline void __raw_spin_unlock(raw
 	mb();
 }
 
-static inline int __raw_spin_trylock(raw_spinlock_t *x)
+static inline int __raw_spin_trylock(arch_spinlock_t *x)
 {
 	volatile unsigned int *a;
 	int ret;
Index: linux-2.6-tip/arch/parisc/include/asm/spinlock_types.h
===================================================================
--- linux-2.6-tip.orig/arch/parisc/include/asm/spinlock_types.h
+++ linux-2.6-tip/arch/parisc/include/asm/spinlock_types.h
@@ -9,10 +9,10 @@ typedef struct {
 	volatile unsigned int lock[4];
 # define __RAW_SPIN_LOCK_UNLOCKED	{ { 1, 1, 1, 1 } }
 #endif
-} raw_spinlock_t;
+} arch_spinlock_t;
 
 typedef struct {
-	raw_spinlock_t lock;
+	arch_spinlock_t lock;
 	volatile int counter;
 } raw_rwlock_t;
 
Index: linux-2.6-tip/arch/parisc/lib/bitops.c
===================================================================
--- linux-2.6-tip.orig/arch/parisc/lib/bitops.c
+++ linux-2.6-tip/arch/parisc/lib/bitops.c
@@ -12,7 +12,7 @@
 #include <asm/atomic.h>
 
 #ifdef CONFIG_SMP
-raw_spinlock_t __atomic_hash[ATOMIC_HASH_SIZE] __lock_aligned = {
+arch_spinlock_t __atomic_hash[ATOMIC_HASH_SIZE] __lock_aligned = {
 	[0 ... (ATOMIC_HASH_SIZE-1)]  = __RAW_SPIN_LOCK_UNLOCKED
 };
 #endif
Index: linux-2.6-tip/arch/powerpc/include/asm/rtas.h
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/include/asm/rtas.h
+++ linux-2.6-tip/arch/powerpc/include/asm/rtas.h
@@ -58,7 +58,7 @@ struct rtas_t {
 	unsigned long entry;		/* physical address pointer */
 	unsigned long base;		/* physical address pointer */
 	unsigned long size;
-	raw_spinlock_t lock;
+	arch_spinlock_t lock;
 	struct rtas_args args;
 	struct device_node *dev;	/* virtual address pointer */
 };
Index: linux-2.6-tip/arch/powerpc/include/asm/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/include/asm/spinlock.h
+++ linux-2.6-tip/arch/powerpc/include/asm/spinlock.h
@@ -54,7 +54,7 @@
  * This returns the old value in the lock, so we succeeded
  * in getting the lock if the return value is 0.
  */
-static inline unsigned long arch_spin_trylock(raw_spinlock_t *lock)
+static inline unsigned long arch_spin_trylock(arch_spinlock_t *lock)
 {
 	unsigned long tmp, token;
 
@@ -73,7 +73,7 @@ static inline unsigned long arch_spin_tr
 	return tmp;
 }
 
-static inline int __raw_spin_trylock(raw_spinlock_t *lock)
+static inline int __raw_spin_trylock(arch_spinlock_t *lock)
 {
 	CLEAR_IO_SYNC;
 	return arch_spin_trylock(lock) == 0;
@@ -96,7 +96,7 @@ static inline int __raw_spin_trylock(raw
 #if defined(CONFIG_PPC_SPLPAR) || defined(CONFIG_PPC_ISERIES)
 /* We only yield to the hypervisor if we are in shared processor mode */
 #define SHARED_PROCESSOR (get_lppaca()->shared_proc)
-extern void __spin_yield(raw_spinlock_t *lock);
+extern void __spin_yield(arch_spinlock_t *lock);
 extern void __rw_yield(raw_rwlock_t *lock);
 #else /* SPLPAR || ISERIES */
 #define __spin_yield(x)	barrier()
@@ -104,7 +104,7 @@ extern void __rw_yield(raw_rwlock_t *loc
 #define SHARED_PROCESSOR	0
 #endif
 
-static inline void __raw_spin_lock(raw_spinlock_t *lock)
+static inline void __raw_spin_lock(arch_spinlock_t *lock)
 {
 	CLEAR_IO_SYNC;
 	while (1) {
@@ -120,7 +120,7 @@ static inline void __raw_spin_lock(raw_s
 }
 
 static inline
-void __raw_spin_lock_flags(raw_spinlock_t *lock, unsigned long flags)
+void __raw_spin_lock_flags(arch_spinlock_t *lock, unsigned long flags)
 {
 	unsigned long flags_dis;
 
@@ -140,7 +140,7 @@ void __raw_spin_lock_flags(raw_spinlock_
 	}
 }
 
-static inline void __raw_spin_unlock(raw_spinlock_t *lock)
+static inline void __raw_spin_unlock(arch_spinlock_t *lock)
 {
 	SYNC_IO;
 	__asm__ __volatile__("# __raw_spin_unlock\n\t"
@@ -149,7 +149,7 @@ static inline void __raw_spin_unlock(raw
 }
 
 #ifdef CONFIG_PPC64
-extern void __raw_spin_unlock_wait(raw_spinlock_t *lock);
+extern void __raw_spin_unlock_wait(arch_spinlock_t *lock);
 #else
 #define __raw_spin_unlock_wait(lock) \
 	do { while (__raw_spin_is_locked(lock)) cpu_relax(); } while (0)
Index: linux-2.6-tip/arch/powerpc/include/asm/spinlock_types.h
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/include/asm/spinlock_types.h
+++ linux-2.6-tip/arch/powerpc/include/asm/spinlock_types.h
@@ -7,7 +7,7 @@
 
 typedef struct {
 	volatile unsigned int slock;
-} raw_spinlock_t;
+} arch_spinlock_t;
 
 #define __RAW_SPIN_LOCK_UNLOCKED	{ 0 }
 
Index: linux-2.6-tip/arch/powerpc/kernel/rtas.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/kernel/rtas.c
+++ linux-2.6-tip/arch/powerpc/kernel/rtas.c
@@ -978,7 +978,7 @@ int __init early_init_dt_scan_rtas(unsig
 	return 1;
 }
 
-static raw_spinlock_t timebase_lock;
+static arch_spinlock_t timebase_lock;
 static u64 timebase = 0;
 
 void __cpuinit rtas_give_timebase(void)
Index: linux-2.6-tip/arch/powerpc/lib/locks.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/lib/locks.c
+++ linux-2.6-tip/arch/powerpc/lib/locks.c
@@ -25,7 +25,7 @@
 #include <asm/smp.h>
 #include <asm/firmware.h>
 
-void __spin_yield(raw_spinlock_t *lock)
+void __spin_yield(arch_spinlock_t *lock)
 {
 	unsigned int lock_value, holder_cpu, yield_count;
 
@@ -82,7 +82,7 @@ void __rw_yield(raw_rwlock_t *rw)
 }
 #endif
 
-void __raw_spin_unlock_wait(raw_spinlock_t *lock)
+void __raw_spin_unlock_wait(arch_spinlock_t *lock)
 {
 	while (lock->slock) {
 		HMT_low();
Index: linux-2.6-tip/arch/powerpc/platforms/pasemi/setup.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/platforms/pasemi/setup.c
+++ linux-2.6-tip/arch/powerpc/platforms/pasemi/setup.c
@@ -71,7 +71,7 @@ static void pas_restart(char *cmd)
 }
 
 #ifdef CONFIG_SMP
-static raw_spinlock_t timebase_lock;
+static arch_spinlock_t timebase_lock;
 static unsigned long timebase;
 
 static void __devinit pas_give_timebase(void)
Index: linux-2.6-tip/arch/s390/include/asm/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/s390/include/asm/spinlock.h
+++ linux-2.6-tip/arch/s390/include/asm/spinlock.h
@@ -57,12 +57,12 @@ _raw_compare_and_swap(volatile unsigned 
 	do { while (__raw_spin_is_locked(lock)) \
 		 _raw_spin_relax(lock); } while (0)
 
-extern void _raw_spin_lock_wait(raw_spinlock_t *);
-extern void _raw_spin_lock_wait_flags(raw_spinlock_t *, unsigned long flags);
-extern int _raw_spin_trylock_retry(raw_spinlock_t *);
-extern void _raw_spin_relax(raw_spinlock_t *lock);
+extern void _raw_spin_lock_wait(arch_spinlock_t *);
+extern void _raw_spin_lock_wait_flags(arch_spinlock_t *, unsigned long flags);
+extern int _raw_spin_trylock_retry(arch_spinlock_t *);
+extern void _raw_spin_relax(arch_spinlock_t *lock);
 
-static inline void __raw_spin_lock(raw_spinlock_t *lp)
+static inline void __raw_spin_lock(arch_spinlock_t *lp)
 {
 	int old;
 
@@ -72,7 +72,7 @@ static inline void __raw_spin_lock(raw_s
 	_raw_spin_lock_wait(lp);
 }
 
-static inline void __raw_spin_lock_flags(raw_spinlock_t *lp,
+static inline void __raw_spin_lock_flags(arch_spinlock_t *lp,
 					 unsigned long flags)
 {
 	int old;
@@ -83,7 +83,7 @@ static inline void __raw_spin_lock_flags
 	_raw_spin_lock_wait_flags(lp, flags);
 }
 
-static inline int __raw_spin_trylock(raw_spinlock_t *lp)
+static inline int __raw_spin_trylock(arch_spinlock_t *lp)
 {
 	int old;
 
@@ -93,7 +93,7 @@ static inline int __raw_spin_trylock(raw
 	return _raw_spin_trylock_retry(lp);
 }
 
-static inline void __raw_spin_unlock(raw_spinlock_t *lp)
+static inline void __raw_spin_unlock(arch_spinlock_t *lp)
 {
 	_raw_compare_and_swap(&lp->owner_cpu, lp->owner_cpu, 0);
 }
Index: linux-2.6-tip/arch/s390/include/asm/spinlock_types.h
===================================================================
--- linux-2.6-tip.orig/arch/s390/include/asm/spinlock_types.h
+++ linux-2.6-tip/arch/s390/include/asm/spinlock_types.h
@@ -7,7 +7,7 @@
 
 typedef struct {
 	volatile unsigned int owner_cpu;
-} __attribute__ ((aligned (4))) raw_spinlock_t;
+} __attribute__ ((aligned (4))) arch_spinlock_t;
 
 #define __RAW_SPIN_LOCK_UNLOCKED	{ 0 }
 
Index: linux-2.6-tip/arch/s390/lib/spinlock.c
===================================================================
--- linux-2.6-tip.orig/arch/s390/lib/spinlock.c
+++ linux-2.6-tip/arch/s390/lib/spinlock.c
@@ -39,7 +39,7 @@ static inline void _raw_yield_cpu(int cp
 		_raw_yield();
 }
 
-void _raw_spin_lock_wait(raw_spinlock_t *lp)
+void _raw_spin_lock_wait(arch_spinlock_t *lp)
 {
 	int count = spin_retry;
 	unsigned int cpu = ~smp_processor_id();
@@ -59,7 +59,7 @@ void _raw_spin_lock_wait(raw_spinlock_t 
 }
 EXPORT_SYMBOL(_raw_spin_lock_wait);
 
-void _raw_spin_lock_wait_flags(raw_spinlock_t *lp, unsigned long flags)
+void _raw_spin_lock_wait_flags(arch_spinlock_t *lp, unsigned long flags)
 {
 	int count = spin_retry;
 	unsigned int cpu = ~smp_processor_id();
@@ -82,7 +82,7 @@ void _raw_spin_lock_wait_flags(raw_spinl
 }
 EXPORT_SYMBOL(_raw_spin_lock_wait_flags);
 
-int _raw_spin_trylock_retry(raw_spinlock_t *lp)
+int _raw_spin_trylock_retry(arch_spinlock_t *lp)
 {
 	unsigned int cpu = ~smp_processor_id();
 	int count;
@@ -97,7 +97,7 @@ int _raw_spin_trylock_retry(raw_spinlock
 }
 EXPORT_SYMBOL(_raw_spin_trylock_retry);
 
-void _raw_spin_relax(raw_spinlock_t *lock)
+void _raw_spin_relax(arch_spinlock_t *lock)
 {
 	unsigned int cpu = lock->owner_cpu;
 	if (cpu != 0)
Index: linux-2.6-tip/arch/sh/include/asm/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/sh/include/asm/spinlock.h
+++ linux-2.6-tip/arch/sh/include/asm/spinlock.h
@@ -34,7 +34,7 @@
  *
  * We make no fairness assumptions.  They have a cost.
  */
-static inline void __raw_spin_lock(raw_spinlock_t *lock)
+static inline void __raw_spin_lock(arch_spinlock_t *lock)
 {
 	unsigned long tmp;
 	unsigned long oldval;
@@ -54,7 +54,7 @@ static inline void __raw_spin_lock(raw_s
 	);
 }
 
-static inline void __raw_spin_unlock(raw_spinlock_t *lock)
+static inline void __raw_spin_unlock(arch_spinlock_t *lock)
 {
 	unsigned long tmp;
 
@@ -67,7 +67,7 @@ static inline void __raw_spin_unlock(raw
 	);
 }
 
-static inline int __raw_spin_trylock(raw_spinlock_t *lock)
+static inline int __raw_spin_trylock(arch_spinlock_t *lock)
 {
 	unsigned long tmp, oldval;
 
Index: linux-2.6-tip/arch/sh/include/asm/spinlock_types.h
===================================================================
--- linux-2.6-tip.orig/arch/sh/include/asm/spinlock_types.h
+++ linux-2.6-tip/arch/sh/include/asm/spinlock_types.h
@@ -7,7 +7,7 @@
 
 typedef struct {
 	volatile unsigned int lock;
-} raw_spinlock_t;
+} arch_spinlock_t;
 
 #define __RAW_SPIN_LOCK_UNLOCKED		{ 1 }
 
Index: linux-2.6-tip/arch/sparc/include/asm/spinlock_32.h
===================================================================
--- linux-2.6-tip.orig/arch/sparc/include/asm/spinlock_32.h
+++ linux-2.6-tip/arch/sparc/include/asm/spinlock_32.h
@@ -15,7 +15,7 @@
 #define __raw_spin_unlock_wait(lock) \
 	do { while (__raw_spin_is_locked(lock)) cpu_relax(); } while (0)
 
-static inline void __raw_spin_lock(raw_spinlock_t *lock)
+static inline void __raw_spin_lock(arch_spinlock_t *lock)
 {
 	__asm__ __volatile__(
 	"\n1:\n\t"
@@ -35,7 +35,7 @@ static inline void __raw_spin_lock(raw_s
 	: "g2", "memory", "cc");
 }
 
-static inline int __raw_spin_trylock(raw_spinlock_t *lock)
+static inline int __raw_spin_trylock(arch_spinlock_t *lock)
 {
 	unsigned int result;
 	__asm__ __volatile__("ldstub [%1], %0"
@@ -45,7 +45,7 @@ static inline int __raw_spin_trylock(raw
 	return (result == 0);
 }
 
-static inline void __raw_spin_unlock(raw_spinlock_t *lock)
+static inline void __raw_spin_unlock(arch_spinlock_t *lock)
 {
 	__asm__ __volatile__("stb %%g0, [%0]" : : "r" (lock) : "memory");
 }
Index: linux-2.6-tip/arch/sparc/include/asm/spinlock_64.h
===================================================================
--- linux-2.6-tip.orig/arch/sparc/include/asm/spinlock_64.h
+++ linux-2.6-tip/arch/sparc/include/asm/spinlock_64.h
@@ -27,7 +27,7 @@
 	do {	rmb();			\
 	} while((lp)->lock)
 
-static inline void __raw_spin_lock(raw_spinlock_t *lock)
+static inline void __raw_spin_lock(arch_spinlock_t *lock)
 {
 	unsigned long tmp;
 
@@ -46,7 +46,7 @@ static inline void __raw_spin_lock(raw_s
 	: "memory");
 }
 
-static inline int __raw_spin_trylock(raw_spinlock_t *lock)
+static inline int __raw_spin_trylock(arch_spinlock_t *lock)
 {
 	unsigned long result;
 
@@ -59,7 +59,7 @@ static inline int __raw_spin_trylock(raw
 	return (result == 0UL);
 }
 
-static inline void __raw_spin_unlock(raw_spinlock_t *lock)
+static inline void __raw_spin_unlock(arch_spinlock_t *lock)
 {
 	__asm__ __volatile__(
 "	stb		%%g0, [%0]"
@@ -68,7 +68,7 @@ static inline void __raw_spin_unlock(raw
 	: "memory");
 }
 
-static inline void __raw_spin_lock_flags(raw_spinlock_t *lock, unsigned long flags)
+static inline void __raw_spin_lock_flags(arch_spinlock_t *lock, unsigned long flags)
 {
 	unsigned long tmp1, tmp2;
 
Index: linux-2.6-tip/arch/sparc/include/asm/spinlock_types.h
===================================================================
--- linux-2.6-tip.orig/arch/sparc/include/asm/spinlock_types.h
+++ linux-2.6-tip/arch/sparc/include/asm/spinlock_types.h
@@ -7,7 +7,7 @@
 
 typedef struct {
 	volatile unsigned char lock;
-} raw_spinlock_t;
+} arch_spinlock_t;
 
 #define __RAW_SPIN_LOCK_UNLOCKED	{ 0 }
 
Index: linux-2.6-tip/arch/x86/include/asm/paravirt.h
===================================================================
--- linux-2.6-tip.orig/arch/x86/include/asm/paravirt.h
+++ linux-2.6-tip/arch/x86/include/asm/paravirt.h
@@ -731,34 +731,34 @@ static inline void __set_fixmap(unsigned
 
 #if defined(CONFIG_SMP) && defined(CONFIG_PARAVIRT_SPINLOCKS)
 
-static inline int __raw_spin_is_locked(struct raw_spinlock *lock)
+static inline int __raw_spin_is_locked(struct arch_spinlock *lock)
 {
 	return PVOP_CALL1(int, pv_lock_ops.spin_is_locked, lock);
 }
 
-static inline int __raw_spin_is_contended(struct raw_spinlock *lock)
+static inline int __raw_spin_is_contended(struct arch_spinlock *lock)
 {
 	return PVOP_CALL1(int, pv_lock_ops.spin_is_contended, lock);
 }
 #define __raw_spin_is_contended	__raw_spin_is_contended
 
-static __always_inline void __raw_spin_lock(struct raw_spinlock *lock)
+static __always_inline void __raw_spin_lock(struct arch_spinlock *lock)
 {
 	PVOP_VCALL1(pv_lock_ops.spin_lock, lock);
 }
 
-static __always_inline void __raw_spin_lock_flags(struct raw_spinlock *lock,
+static __always_inline void __raw_spin_lock_flags(struct arch_spinlock *lock,
 						  unsigned long flags)
 {
 	PVOP_VCALL2(pv_lock_ops.spin_lock_flags, lock, flags);
 }
 
-static __always_inline int __raw_spin_trylock(struct raw_spinlock *lock)
+static __always_inline int __raw_spin_trylock(struct arch_spinlock *lock)
 {
 	return PVOP_CALL1(int, pv_lock_ops.spin_trylock, lock);
 }
 
-static __always_inline void __raw_spin_unlock(struct raw_spinlock *lock)
+static __always_inline void __raw_spin_unlock(struct arch_spinlock *lock)
 {
 	PVOP_VCALL1(pv_lock_ops.spin_unlock, lock);
 }
Index: linux-2.6-tip/arch/x86/include/asm/paravirt_types.h
===================================================================
--- linux-2.6-tip.orig/arch/x86/include/asm/paravirt_types.h
+++ linux-2.6-tip/arch/x86/include/asm/paravirt_types.h
@@ -318,14 +318,14 @@ struct pv_mmu_ops {
 			   phys_addr_t phys, pgprot_t flags);
 };
 
-struct raw_spinlock;
+struct arch_spinlock;
 struct pv_lock_ops {
-	int (*spin_is_locked)(struct raw_spinlock *lock);
-	int (*spin_is_contended)(struct raw_spinlock *lock);
-	void (*spin_lock)(struct raw_spinlock *lock);
-	void (*spin_lock_flags)(struct raw_spinlock *lock, unsigned long flags);
-	int (*spin_trylock)(struct raw_spinlock *lock);
-	void (*spin_unlock)(struct raw_spinlock *lock);
+	int (*spin_is_locked)(struct arch_spinlock *lock);
+	int (*spin_is_contended)(struct arch_spinlock *lock);
+	void (*spin_lock)(struct arch_spinlock *lock);
+	void (*spin_lock_flags)(struct arch_spinlock *lock, unsigned long flags);
+	int (*spin_trylock)(struct arch_spinlock *lock);
+	void (*spin_unlock)(struct arch_spinlock *lock);
 };
 
 /* This contains all the paravirt structures: we get a convenient
Index: linux-2.6-tip/arch/x86/include/asm/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/x86/include/asm/spinlock.h
+++ linux-2.6-tip/arch/x86/include/asm/spinlock.h
@@ -58,7 +58,7 @@
 #if (NR_CPUS < 256)
 #define TICKET_SHIFT 8
 
-static __always_inline void __ticket_spin_lock(raw_spinlock_t *lock)
+static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
 {
 	short inc = 0x0100;
 
@@ -77,7 +77,7 @@ static __always_inline void __ticket_spi
 		: "memory", "cc");
 }
 
-static __always_inline int __ticket_spin_trylock(raw_spinlock_t *lock)
+static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
 {
 	int tmp, new;
 
@@ -96,7 +96,7 @@ static __always_inline int __ticket_spin
 	return tmp;
 }
 
-static __always_inline void __ticket_spin_unlock(raw_spinlock_t *lock)
+static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
 {
 	asm volatile(UNLOCK_LOCK_PREFIX "incb %0"
 		     : "+m" (lock->slock)
@@ -106,7 +106,7 @@ static __always_inline void __ticket_spi
 #else
 #define TICKET_SHIFT 16
 
-static __always_inline void __ticket_spin_lock(raw_spinlock_t *lock)
+static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
 {
 	int inc = 0x00010000;
 	int tmp;
@@ -127,7 +127,7 @@ static __always_inline void __ticket_spi
 		     : "memory", "cc");
 }
 
-static __always_inline int __ticket_spin_trylock(raw_spinlock_t *lock)
+static __always_inline int __ticket_spin_trylock(arch_spinlock_t *lock)
 {
 	int tmp;
 	int new;
@@ -149,7 +149,7 @@ static __always_inline int __ticket_spin
 	return tmp;
 }
 
-static __always_inline void __ticket_spin_unlock(raw_spinlock_t *lock)
+static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
 {
 	asm volatile(UNLOCK_LOCK_PREFIX "incw %0"
 		     : "+m" (lock->slock)
@@ -158,14 +158,14 @@ static __always_inline void __ticket_spi
 }
 #endif
 
-static inline int __ticket_spin_is_locked(raw_spinlock_t *lock)
+static inline int __ticket_spin_is_locked(arch_spinlock_t *lock)
 {
 	int tmp = ACCESS_ONCE(lock->slock);
 
 	return !!(((tmp >> TICKET_SHIFT) ^ tmp) & ((1 << TICKET_SHIFT) - 1));
 }
 
-static inline int __ticket_spin_is_contended(raw_spinlock_t *lock)
+static inline int __ticket_spin_is_contended(arch_spinlock_t *lock)
 {
 	int tmp = ACCESS_ONCE(lock->slock);
 
@@ -174,33 +174,33 @@ static inline int __ticket_spin_is_conte
 
 #ifndef CONFIG_PARAVIRT_SPINLOCKS
 
-static inline int __raw_spin_is_locked(raw_spinlock_t *lock)
+static inline int __raw_spin_is_locked(arch_spinlock_t *lock)
 {
 	return __ticket_spin_is_locked(lock);
 }
 
-static inline int __raw_spin_is_contended(raw_spinlock_t *lock)
+static inline int __raw_spin_is_contended(arch_spinlock_t *lock)
 {
 	return __ticket_spin_is_contended(lock);
 }
 #define __raw_spin_is_contended	__raw_spin_is_contended
 
-static __always_inline void __raw_spin_lock(raw_spinlock_t *lock)
+static __always_inline void __raw_spin_lock(arch_spinlock_t *lock)
 {
 	__ticket_spin_lock(lock);
 }
 
-static __always_inline int __raw_spin_trylock(raw_spinlock_t *lock)
+static __always_inline int __raw_spin_trylock(arch_spinlock_t *lock)
 {
 	return __ticket_spin_trylock(lock);
 }
 
-static __always_inline void __raw_spin_unlock(raw_spinlock_t *lock)
+static __always_inline void __raw_spin_unlock(arch_spinlock_t *lock)
 {
 	__ticket_spin_unlock(lock);
 }
 
-static __always_inline void __raw_spin_lock_flags(raw_spinlock_t *lock,
+static __always_inline void __raw_spin_lock_flags(arch_spinlock_t *lock,
 						  unsigned long flags)
 {
 	__raw_spin_lock(lock);
@@ -208,7 +208,7 @@ static __always_inline void __raw_spin_l
 
 #endif	/* CONFIG_PARAVIRT_SPINLOCKS */
 
-static inline void __raw_spin_unlock_wait(raw_spinlock_t *lock)
+static inline void __raw_spin_unlock_wait(arch_spinlock_t *lock)
 {
 	while (__raw_spin_is_locked(lock))
 		cpu_relax();
Index: linux-2.6-tip/arch/x86/include/asm/spinlock_types.h
===================================================================
--- linux-2.6-tip.orig/arch/x86/include/asm/spinlock_types.h
+++ linux-2.6-tip/arch/x86/include/asm/spinlock_types.h
@@ -5,9 +5,9 @@
 # error "please don't include this file directly"
 #endif
 
-typedef struct raw_spinlock {
+typedef struct arch_spinlock {
 	unsigned int slock;
-} raw_spinlock_t;
+} arch_spinlock_t;
 
 #define __RAW_SPIN_LOCK_UNLOCKED	{ 0 }
 
Index: linux-2.6-tip/arch/x86/kernel/dumpstack.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/dumpstack.c
+++ linux-2.6-tip/arch/x86/kernel/dumpstack.c
@@ -188,7 +188,7 @@ void dump_stack(void)
 }
 EXPORT_SYMBOL(dump_stack);
 
-static raw_spinlock_t die_lock = __RAW_SPIN_LOCK_UNLOCKED;
+static arch_spinlock_t die_lock = __RAW_SPIN_LOCK_UNLOCKED;
 static int die_owner = -1;
 static unsigned int die_nest_count;
 
Index: linux-2.6-tip/arch/x86/kernel/paravirt-spinlocks.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/paravirt-spinlocks.c
+++ linux-2.6-tip/arch/x86/kernel/paravirt-spinlocks.c
@@ -8,7 +8,7 @@
 #include <asm/paravirt.h>
 
 static inline void
-default_spin_lock_flags(raw_spinlock_t *lock, unsigned long flags)
+default_spin_lock_flags(arch_spinlock_t *lock, unsigned long flags)
 {
 	__raw_spin_lock(lock);
 }
Index: linux-2.6-tip/arch/x86/kernel/tsc_sync.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/tsc_sync.c
+++ linux-2.6-tip/arch/x86/kernel/tsc_sync.c
@@ -33,7 +33,7 @@ static __cpuinitdata atomic_t stop_count
  * we want to have the fastest, inlined, non-debug version
  * of a critical section, to be able to prove TSC time-warps:
  */
-static __cpuinitdata raw_spinlock_t sync_lock = __RAW_SPIN_LOCK_UNLOCKED;
+static __cpuinitdata arch_spinlock_t sync_lock = __RAW_SPIN_LOCK_UNLOCKED;
 
 static __cpuinitdata cycles_t last_tsc;
 static __cpuinitdata cycles_t max_warp;
Index: linux-2.6-tip/arch/x86/xen/spinlock.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/xen/spinlock.c
+++ linux-2.6-tip/arch/x86/xen/spinlock.c
@@ -120,14 +120,14 @@ struct xen_spinlock {
 	unsigned short spinners;	/* count of waiting cpus */
 };
 
-static int xen_spin_is_locked(struct raw_spinlock *lock)
+static int xen_spin_is_locked(struct arch_spinlock *lock)
 {
 	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
 
 	return xl->lock != 0;
 }
 
-static int xen_spin_is_contended(struct raw_spinlock *lock)
+static int xen_spin_is_contended(struct arch_spinlock *lock)
 {
 	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
 
@@ -136,7 +136,7 @@ static int xen_spin_is_contended(struct 
 	return xl->spinners != 0;
 }
 
-static int xen_spin_trylock(struct raw_spinlock *lock)
+static int xen_spin_trylock(struct arch_spinlock *lock)
 {
 	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
 	u8 old = 1;
@@ -181,7 +181,7 @@ static inline void unspinning_lock(struc
 	__get_cpu_var(lock_spinners) = prev;
 }
 
-static noinline int xen_spin_lock_slow(struct raw_spinlock *lock, bool irq_enable)
+static noinline int xen_spin_lock_slow(struct arch_spinlock *lock, bool irq_enable)
 {
 	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
 	struct xen_spinlock *prev;
@@ -254,7 +254,7 @@ out:
 	return ret;
 }
 
-static inline void __xen_spin_lock(struct raw_spinlock *lock, bool irq_enable)
+static inline void __xen_spin_lock(struct arch_spinlock *lock, bool irq_enable)
 {
 	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
 	unsigned timeout;
@@ -291,12 +291,12 @@ static inline void __xen_spin_lock(struc
 	spin_time_accum_total(start_spin);
 }
 
-static void xen_spin_lock(struct raw_spinlock *lock)
+static void xen_spin_lock(struct arch_spinlock *lock)
 {
 	__xen_spin_lock(lock, false);
 }
 
-static void xen_spin_lock_flags(struct raw_spinlock *lock, unsigned long flags)
+static void xen_spin_lock_flags(struct arch_spinlock *lock, unsigned long flags)
 {
 	__xen_spin_lock(lock, !raw_irqs_disabled_flags(flags));
 }
@@ -317,7 +317,7 @@ static noinline void xen_spin_unlock_slo
 	}
 }
 
-static void xen_spin_unlock(struct raw_spinlock *lock)
+static void xen_spin_unlock(struct arch_spinlock *lock)
 {
 	struct xen_spinlock *xl = (struct xen_spinlock *)lock;
 
Index: linux-2.6-tip/include/asm-generic/bitops/atomic.h
===================================================================
--- linux-2.6-tip.orig/include/asm-generic/bitops/atomic.h
+++ linux-2.6-tip/include/asm-generic/bitops/atomic.h
@@ -15,18 +15,18 @@
 #  define ATOMIC_HASH_SIZE 4
 #  define ATOMIC_HASH(a) (&(__atomic_hash[ (((unsigned long) a)/L1_CACHE_BYTES) & (ATOMIC_HASH_SIZE-1) ]))
 
-extern raw_spinlock_t __atomic_hash[ATOMIC_HASH_SIZE] __lock_aligned;
+extern arch_spinlock_t __atomic_hash[ATOMIC_HASH_SIZE] __lock_aligned;
 
 /* Can't use raw_spin_lock_irq because of #include problems, so
  * this is the substitute */
 #define _atomic_spin_lock_irqsave(l,f) do {	\
-	raw_spinlock_t *s = ATOMIC_HASH(l);	\
+	arch_spinlock_t *s = ATOMIC_HASH(l);	\
 	local_irq_save(f);			\
 	__raw_spin_lock(s);			\
 } while(0)
 
 #define _atomic_spin_unlock_irqrestore(l,f) do {	\
-	raw_spinlock_t *s = ATOMIC_HASH(l);		\
+	arch_spinlock_t *s = ATOMIC_HASH(l);		\
 	__raw_spin_unlock(s);				\
 	local_irq_restore(f);				\
 } while(0)
Index: linux-2.6-tip/include/linux/spinlock.h
===================================================================
--- linux-2.6-tip.orig/include/linux/spinlock.h
+++ linux-2.6-tip/include/linux/spinlock.h
@@ -8,7 +8,7 @@
  *
  * on SMP builds:
  *
- *  asm/spinlock_types.h: contains the raw_spinlock_t/raw_rwlock_t and the
+ *  asm/spinlock_types.h: contains the arch_spinlock_t/raw_rwlock_t and the
  *                        initializers
  *
  *  linux/spinlock_types.h:
@@ -75,7 +75,7 @@
 #define __lockfunc __attribute__((section(".spinlock.text")))
 
 /*
- * Pull the raw_spinlock_t and raw_rwlock_t definitions:
+ * Pull the arch_spinlock_t and raw_rwlock_t definitions:
  */
 #include <linux/spinlock_types.h>
 
Index: linux-2.6-tip/include/linux/spinlock_types.h
===================================================================
--- linux-2.6-tip.orig/include/linux/spinlock_types.h
+++ linux-2.6-tip/include/linux/spinlock_types.h
@@ -18,7 +18,7 @@
 #include <linux/lockdep.h>
 
 typedef struct {
-	raw_spinlock_t raw_lock;
+	arch_spinlock_t raw_lock;
 #ifdef CONFIG_GENERIC_LOCKBREAK
 	unsigned int break_lock;
 #endif
Index: linux-2.6-tip/include/linux/spinlock_types_up.h
===================================================================
--- linux-2.6-tip.orig/include/linux/spinlock_types_up.h
+++ linux-2.6-tip/include/linux/spinlock_types_up.h
@@ -16,13 +16,13 @@
 
 typedef struct {
 	volatile unsigned int slock;
-} raw_spinlock_t;
+} arch_spinlock_t;
 
 #define __RAW_SPIN_LOCK_UNLOCKED { 1 }
 
 #else
 
-typedef struct { } raw_spinlock_t;
+typedef struct { } arch_spinlock_t;
 
 #define __RAW_SPIN_LOCK_UNLOCKED { }
 
Index: linux-2.6-tip/include/linux/spinlock_up.h
===================================================================
--- linux-2.6-tip.orig/include/linux/spinlock_up.h
+++ linux-2.6-tip/include/linux/spinlock_up.h
@@ -20,19 +20,19 @@
 #ifdef CONFIG_DEBUG_SPINLOCK
 #define __raw_spin_is_locked(x)		((x)->slock == 0)
 
-static inline void __raw_spin_lock(raw_spinlock_t *lock)
+static inline void __raw_spin_lock(arch_spinlock_t *lock)
 {
 	lock->slock = 0;
 }
 
 static inline void
-__raw_spin_lock_flags(raw_spinlock_t *lock, unsigned long flags)
+__raw_spin_lock_flags(arch_spinlock_t *lock, unsigned long flags)
 {
 	local_irq_save(flags);
 	lock->slock = 0;
 }
 
-static inline int __raw_spin_trylock(raw_spinlock_t *lock)
+static inline int __raw_spin_trylock(arch_spinlock_t *lock)
 {
 	char oldval = lock->slock;
 
@@ -41,7 +41,7 @@ static inline int __raw_spin_trylock(raw
 	return oldval > 0;
 }
 
-static inline void __raw_spin_unlock(raw_spinlock_t *lock)
+static inline void __raw_spin_unlock(arch_spinlock_t *lock)
 {
 	lock->slock = 1;
 }
Index: linux-2.6-tip/kernel/lockdep.c
===================================================================
--- linux-2.6-tip.orig/kernel/lockdep.c
+++ linux-2.6-tip/kernel/lockdep.c
@@ -73,7 +73,7 @@ module_param(lock_stat, int, 0644);
  * to use a raw spinlock - we really dont want the spinlock
  * code to recurse back into the lockdep code...
  */
-static raw_spinlock_t lockdep_lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
+static arch_spinlock_t lockdep_lock = (arch_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
 
 static int graph_lock(void)
 {
Index: linux-2.6-tip/kernel/trace/ring_buffer.c
===================================================================
--- linux-2.6-tip.orig/kernel/trace/ring_buffer.c
+++ linux-2.6-tip/kernel/trace/ring_buffer.c
@@ -423,7 +423,7 @@ struct ring_buffer_per_cpu {
 	int				cpu;
 	struct ring_buffer		*buffer;
 	spinlock_t			reader_lock;	/* serialize readers */
-	raw_spinlock_t			lock;
+	arch_spinlock_t			lock;
 	struct lock_class_key		lock_key;
 	struct list_head		*pages;
 	struct buffer_page		*head_page;	/* read from head */
@@ -998,7 +998,7 @@ rb_allocate_cpu_buffer(struct ring_buffe
 	cpu_buffer->buffer = buffer;
 	spin_lock_init(&cpu_buffer->reader_lock);
 	lockdep_set_class(&cpu_buffer->reader_lock, buffer->reader_lock_key);
-	cpu_buffer->lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
+	cpu_buffer->lock = (arch_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
 
 	bpage = kzalloc_node(ALIGN(sizeof(*bpage), cache_line_size()),
 			    GFP_KERNEL, cpu_to_node(cpu));
Index: linux-2.6-tip/kernel/trace/trace.c
===================================================================
--- linux-2.6-tip.orig/kernel/trace/trace.c
+++ linux-2.6-tip/kernel/trace/trace.c
@@ -493,15 +493,15 @@ static ssize_t trace_seq_to_buffer(struc
  * protected by per_cpu spinlocks. But the action of the swap
  * needs its own lock.
  *
- * This is defined as a raw_spinlock_t in order to help
+ * This is defined as a arch_spinlock_t in order to help
  * with performance when lockdep debugging is enabled.
  *
  * It is also used in other places outside the update_max_tr
  * so it needs to be defined outside of the
  * CONFIG_TRACER_MAX_TRACE.
  */
-static raw_spinlock_t ftrace_max_lock =
-	(raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
+static arch_spinlock_t ftrace_max_lock =
+	(arch_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
 
 #ifdef CONFIG_TRACER_MAX_TRACE
 unsigned long __read_mostly	tracing_max_latency;
@@ -802,7 +802,7 @@ static unsigned map_pid_to_cmdline[PID_M
 static unsigned map_cmdline_to_pid[SAVED_CMDLINES];
 static char saved_cmdlines[SAVED_CMDLINES][TASK_COMM_LEN];
 static int cmdline_idx;
-static raw_spinlock_t trace_cmdline_lock = __RAW_SPIN_LOCK_UNLOCKED;
+static arch_spinlock_t trace_cmdline_lock = __RAW_SPIN_LOCK_UNLOCKED;
 
 /* temporary disable recording */
 static atomic_t trace_record_cmdline_disabled __read_mostly;
@@ -1251,8 +1251,8 @@ ftrace_special(unsigned long arg1, unsig
  */
 int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
 {
-	static raw_spinlock_t trace_buf_lock =
-		(raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
+	static arch_spinlock_t trace_buf_lock =
+		(arch_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
 	static u32 trace_buf[TRACE_BUF_SIZE];
 
 	struct ftrace_event_call *call = &event_bprint;
@@ -1334,7 +1334,7 @@ int trace_array_printk(struct trace_arra
 int trace_array_vprintk(struct trace_array *tr,
 			unsigned long ip, const char *fmt, va_list args)
 {
-	static raw_spinlock_t trace_buf_lock = __RAW_SPIN_LOCK_UNLOCKED;
+	static arch_spinlock_t trace_buf_lock = __RAW_SPIN_LOCK_UNLOCKED;
 	static char trace_buf[TRACE_BUF_SIZE];
 
 	struct ftrace_event_call *call = &event_print;
@@ -4268,8 +4268,8 @@ trace_printk_seq(struct trace_seq *s)
 
 static void __ftrace_dump(bool disable_tracing)
 {
-	static raw_spinlock_t ftrace_dump_lock =
-		(raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
+	static arch_spinlock_t ftrace_dump_lock =
+		(arch_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
 	/* use static because iter can be a bit big for the stack */
 	static struct trace_iterator iter;
 	unsigned int old_userobj;
Index: linux-2.6-tip/kernel/trace/trace_clock.c
===================================================================
--- linux-2.6-tip.orig/kernel/trace/trace_clock.c
+++ linux-2.6-tip/kernel/trace/trace_clock.c
@@ -71,10 +71,10 @@ u64 notrace trace_clock(void)
 /* keep prev_time and lock in the same cacheline. */
 static struct {
 	u64 prev_time;
-	raw_spinlock_t lock;
+	arch_spinlock_t lock;
 } trace_clock_struct ____cacheline_aligned_in_smp =
 	{
-		.lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED,
+		.lock = (arch_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED,
 	};
 
 u64 notrace trace_clock_global(void)
Index: linux-2.6-tip/kernel/trace/trace_sched_wakeup.c
===================================================================
--- linux-2.6-tip.orig/kernel/trace/trace_sched_wakeup.c
+++ linux-2.6-tip/kernel/trace/trace_sched_wakeup.c
@@ -28,8 +28,8 @@ static int			wakeup_current_cpu;
 static unsigned			wakeup_prio = -1;
 static int			wakeup_rt;
 
-static raw_spinlock_t wakeup_lock =
-	(raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
+static arch_spinlock_t wakeup_lock =
+	(arch_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
 
 static void __wakeup_reset(struct trace_array *tr);
 
Index: linux-2.6-tip/kernel/trace/trace_stack.c
===================================================================
--- linux-2.6-tip.orig/kernel/trace/trace_stack.c
+++ linux-2.6-tip/kernel/trace/trace_stack.c
@@ -27,8 +27,8 @@ static struct stack_trace max_stack_trac
 };
 
 static unsigned long max_stack_size;
-static raw_spinlock_t max_stack_lock =
-	(raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
+static arch_spinlock_t max_stack_lock =
+	(arch_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
 
 static int stack_trace_disabled __read_mostly;
 static DEFINE_PER_CPU(int, trace_active);
Index: linux-2.6-tip/lib/spinlock_debug.c
===================================================================
--- linux-2.6-tip.orig/lib/spinlock_debug.c
+++ linux-2.6-tip/lib/spinlock_debug.c
@@ -23,7 +23,7 @@ void __spin_lock_init(spinlock_t *lock, 
 	debug_check_no_locks_freed((void *)lock, sizeof(*lock));
 	lockdep_init_map(&lock->dep_map, name, key, 0);
 #endif
-	lock->raw_lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
+	lock->raw_lock = (arch_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
 	lock->magic = SPINLOCK_MAGIC;
 	lock->owner = SPINLOCK_OWNER_INIT;
 	lock->owner_cpu = -1;


