Return-Path: <linux-kernel-owner+w=401wt.eu-S934100AbZLFSDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934100AbZLFSDB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 13:03:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934125AbZLFSDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 13:03:00 -0500
Received: from www.tglx.de ([62.245.132.106]:33115 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934075AbZLFSCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 13:02:49 -0500
Message-Id: <20091206111957.612636770@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 06 Dec 2009 18:02:30 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux-Arch <linux-arch@vger.kernel.org>
Subject: [patch 08/23] locking: Convert raw_rwlock functions to arch_rwlock
References: <20091206110944.492100233@linutronix.de>
Content-Disposition: inline;
	filename=locking-convert-rwlock-arch-functions.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Name space cleanup for rwlock functions. No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/alpha/include/asm/spinlock.h          |   20 ++++++-------
 arch/arm/include/asm/spinlock.h            |   20 ++++++-------
 arch/blackfin/include/asm/spinlock.h       |   40 +++++++++++++--------------
 arch/cris/include/arch-v32/arch/spinlock.h |   16 +++++------
 arch/ia64/include/asm/spinlock.h           |   32 +++++++++++-----------
 arch/m32r/include/asm/spinlock.h           |   20 ++++++-------
 arch/mips/include/asm/spinlock.h           |   42 ++++++++++++++---------------
 arch/parisc/include/asm/spinlock.h         |   20 ++++++-------
 arch/powerpc/include/asm/spinlock.h        |   32 +++++++++++-----------
 arch/s390/include/asm/spinlock.h           |   20 ++++++-------
 arch/s390/lib/spinlock.c                   |   12 ++++----
 arch/sh/include/asm/spinlock.h             |   32 +++++++++++-----------
 arch/sparc/include/asm/spinlock_32.h       |   32 +++++++++++-----------
 arch/sparc/include/asm/spinlock_64.h       |   20 ++++++-------
 arch/x86/include/asm/spinlock.h            |   20 ++++++-------
 include/linux/rwlock.h                     |   22 +++++++--------
 include/linux/spinlock_up.h                |   16 +++++------
 lib/spinlock_debug.c                       |   16 +++++------
 18 files changed, 216 insertions(+), 216 deletions(-)

Index: linux-2.6-tip/arch/alpha/include/asm/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/alpha/include/asm/spinlock.h
+++ linux-2.6-tip/arch/alpha/include/asm/spinlock.h
@@ -50,17 +50,17 @@ static inline int arch_spin_trylock(arch
 
 /***********************************************************/
 
-static inline int __raw_read_can_lock(arch_rwlock_t *lock)
+static inline int arch_read_can_lock(arch_rwlock_t *lock)
 {
 	return (lock->lock & 1) == 0;
 }
 
-static inline int __raw_write_can_lock(arch_rwlock_t *lock)
+static inline int arch_write_can_lock(arch_rwlock_t *lock)
 {
 	return lock->lock == 0;
 }
 
-static inline void __raw_read_lock(arch_rwlock_t *lock)
+static inline void arch_read_lock(arch_rwlock_t *lock)
 {
 	long regx;
 
@@ -80,7 +80,7 @@ static inline void __raw_read_lock(arch_
 	: "m" (*lock) : "memory");
 }
 
-static inline void __raw_write_lock(arch_rwlock_t *lock)
+static inline void arch_write_lock(arch_rwlock_t *lock)
 {
 	long regx;
 
@@ -100,7 +100,7 @@ static inline void __raw_write_lock(arch
 	: "m" (*lock) : "memory");
 }
 
-static inline int __raw_read_trylock(arch_rwlock_t * lock)
+static inline int arch_read_trylock(arch_rwlock_t * lock)
 {
 	long regx;
 	int success;
@@ -122,7 +122,7 @@ static inline int __raw_read_trylock(arc
 	return success;
 }
 
-static inline int __raw_write_trylock(arch_rwlock_t * lock)
+static inline int arch_write_trylock(arch_rwlock_t * lock)
 {
 	long regx;
 	int success;
@@ -144,7 +144,7 @@ static inline int __raw_write_trylock(ar
 	return success;
 }
 
-static inline void __raw_read_unlock(arch_rwlock_t * lock)
+static inline void arch_read_unlock(arch_rwlock_t * lock)
 {
 	long regx;
 	__asm__ __volatile__(
@@ -160,14 +160,14 @@ static inline void __raw_read_unlock(arc
 	: "m" (*lock) : "memory");
 }
 
-static inline void __raw_write_unlock(arch_rwlock_t * lock)
+static inline void arch_write_unlock(arch_rwlock_t * lock)
 {
 	mb();
 	lock->lock = 0;
 }
 
-#define __raw_read_lock_flags(lock, flags) __raw_read_lock(lock)
-#define __raw_write_lock_flags(lock, flags) __raw_write_lock(lock)
+#define arch_read_lock_flags(lock, flags) arch_read_lock(lock)
+#define arch_write_lock_flags(lock, flags) arch_write_lock(lock)
 
 #define arch_spin_relax(lock)	cpu_relax()
 #define arch_read_relax(lock)	cpu_relax()
Index: linux-2.6-tip/arch/arm/include/asm/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/arm/include/asm/spinlock.h
+++ linux-2.6-tip/arch/arm/include/asm/spinlock.h
@@ -86,7 +86,7 @@ static inline void arch_spin_unlock(arch
  * just write zero since the lock is exclusively held.
  */
 
-static inline void __raw_write_lock(arch_rwlock_t *rw)
+static inline void arch_write_lock(arch_rwlock_t *rw)
 {
 	unsigned long tmp;
 
@@ -106,7 +106,7 @@ static inline void __raw_write_lock(arch
 	smp_mb();
 }
 
-static inline int __raw_write_trylock(arch_rwlock_t *rw)
+static inline int arch_write_trylock(arch_rwlock_t *rw)
 {
 	unsigned long tmp;
 
@@ -126,7 +126,7 @@ static inline int __raw_write_trylock(ar
 	}
 }
 
-static inline void __raw_write_unlock(arch_rwlock_t *rw)
+static inline void arch_write_unlock(arch_rwlock_t *rw)
 {
 	smp_mb();
 
@@ -142,7 +142,7 @@ static inline void __raw_write_unlock(ar
 }
 
 /* write_can_lock - would write_trylock() succeed? */
-#define __raw_write_can_lock(x)		((x)->lock == 0)
+#define arch_write_can_lock(x)		((x)->lock == 0)
 
 /*
  * Read locks are a bit more hairy:
@@ -156,7 +156,7 @@ static inline void __raw_write_unlock(ar
  * currently active.  However, we know we won't have any write
  * locks.
  */
-static inline void __raw_read_lock(arch_rwlock_t *rw)
+static inline void arch_read_lock(arch_rwlock_t *rw)
 {
 	unsigned long tmp, tmp2;
 
@@ -176,7 +176,7 @@ static inline void __raw_read_lock(arch_
 	smp_mb();
 }
 
-static inline void __raw_read_unlock(arch_rwlock_t *rw)
+static inline void arch_read_unlock(arch_rwlock_t *rw)
 {
 	unsigned long tmp, tmp2;
 
@@ -198,7 +198,7 @@ static inline void __raw_read_unlock(arc
 	: "cc");
 }
 
-static inline int __raw_read_trylock(arch_rwlock_t *rw)
+static inline int arch_read_trylock(arch_rwlock_t *rw)
 {
 	unsigned long tmp, tmp2 = 1;
 
@@ -215,10 +215,10 @@ static inline int __raw_read_trylock(arc
 }
 
 /* read_can_lock - would read_trylock() succeed? */
-#define __raw_read_can_lock(x)		((x)->lock < 0x80000000)
+#define arch_read_can_lock(x)		((x)->lock < 0x80000000)
 
-#define __raw_read_lock_flags(lock, flags) __raw_read_lock(lock)
-#define __raw_write_lock_flags(lock, flags) __raw_write_lock(lock)
+#define arch_read_lock_flags(lock, flags) arch_read_lock(lock)
+#define arch_write_lock_flags(lock, flags) arch_write_lock(lock)
 
 #define arch_spin_relax(lock)	cpu_relax()
 #define arch_read_relax(lock)	cpu_relax()
Index: linux-2.6-tip/arch/blackfin/include/asm/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/blackfin/include/asm/spinlock.h
+++ linux-2.6-tip/arch/blackfin/include/asm/spinlock.h
@@ -17,12 +17,12 @@ asmlinkage int __raw_spin_is_locked_asm(
 asmlinkage void __raw_spin_lock_asm(volatile int *ptr);
 asmlinkage int __raw_spin_trylock_asm(volatile int *ptr);
 asmlinkage void __raw_spin_unlock_asm(volatile int *ptr);
-asmlinkage void __raw_read_lock_asm(volatile int *ptr);
-asmlinkage int __raw_read_trylock_asm(volatile int *ptr);
-asmlinkage void __raw_read_unlock_asm(volatile int *ptr);
-asmlinkage void __raw_write_lock_asm(volatile int *ptr);
-asmlinkage int __raw_write_trylock_asm(volatile int *ptr);
-asmlinkage void __raw_write_unlock_asm(volatile int *ptr);
+asmlinkage void arch_read_lock_asm(volatile int *ptr);
+asmlinkage int arch_read_trylock_asm(volatile int *ptr);
+asmlinkage void arch_read_unlock_asm(volatile int *ptr);
+asmlinkage void arch_write_lock_asm(volatile int *ptr);
+asmlinkage int arch_write_trylock_asm(volatile int *ptr);
+asmlinkage void arch_write_unlock_asm(volatile int *ptr);
 
 static inline int arch_spin_is_locked(arch_spinlock_t *lock)
 {
@@ -52,44 +52,44 @@ static inline void arch_spin_unlock_wait
 		cpu_relax();
 }
 
-static inline int __raw_read_can_lock(arch_rwlock_t *rw)
+static inline int arch_read_can_lock(arch_rwlock_t *rw)
 {
 	return __raw_uncached_fetch_asm(&rw->lock) > 0;
 }
 
-static inline int __raw_write_can_lock(arch_rwlock_t *rw)
+static inline int arch_write_can_lock(arch_rwlock_t *rw)
 {
 	return __raw_uncached_fetch_asm(&rw->lock) == RW_LOCK_BIAS;
 }
 
-static inline void __raw_read_lock(arch_rwlock_t *rw)
+static inline void arch_read_lock(arch_rwlock_t *rw)
 {
-	__raw_read_lock_asm(&rw->lock);
+	arch_read_lock_asm(&rw->lock);
 }
 
-static inline int __raw_read_trylock(arch_rwlock_t *rw)
+static inline int arch_read_trylock(arch_rwlock_t *rw)
 {
-	return __raw_read_trylock_asm(&rw->lock);
+	return arch_read_trylock_asm(&rw->lock);
 }
 
-static inline void __raw_read_unlock(arch_rwlock_t *rw)
+static inline void arch_read_unlock(arch_rwlock_t *rw)
 {
-	__raw_read_unlock_asm(&rw->lock);
+	arch_read_unlock_asm(&rw->lock);
 }
 
-static inline void __raw_write_lock(arch_rwlock_t *rw)
+static inline void arch_write_lock(arch_rwlock_t *rw)
 {
-	__raw_write_lock_asm(&rw->lock);
+	arch_write_lock_asm(&rw->lock);
 }
 
-static inline int __raw_write_trylock(arch_rwlock_t *rw)
+static inline int arch_write_trylock(arch_rwlock_t *rw)
 {
-	return __raw_write_trylock_asm(&rw->lock);
+	return arch_write_trylock_asm(&rw->lock);
 }
 
-static inline void __raw_write_unlock(arch_rwlock_t *rw)
+static inline void arch_write_unlock(arch_rwlock_t *rw)
 {
-	__raw_write_unlock_asm(&rw->lock);
+	arch_write_unlock_asm(&rw->lock);
 }
 
 #define arch_spin_relax(lock)  	cpu_relax()
Index: linux-2.6-tip/arch/cris/include/arch-v32/arch/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/cris/include/arch-v32/arch/spinlock.h
+++ linux-2.6-tip/arch/cris/include/arch-v32/arch/spinlock.h
@@ -56,17 +56,17 @@ arch_spin_lock_flags(arch_spinlock_t *lo
  *
  */
 
-static inline int __raw_read_can_lock(arch_rwlock_t *x)
+static inline int arch_read_can_lock(arch_rwlock_t *x)
 {
 	return (int)(x)->lock > 0;
 }
 
-static inline int __raw_write_can_lock(arch_rwlock_t *x)
+static inline int arch_write_can_lock(arch_rwlock_t *x)
 {
 	return (x)->lock == RW_LOCK_BIAS;
 }
 
-static  inline void __raw_read_lock(arch_rwlock_t *rw)
+static  inline void arch_read_lock(arch_rwlock_t *rw)
 {
 	arch_spin_lock(&rw->slock);
 	while (rw->lock == 0);
@@ -74,7 +74,7 @@ static  inline void __raw_read_lock(arch
 	arch_spin_unlock(&rw->slock);
 }
 
-static  inline void __raw_write_lock(arch_rwlock_t *rw)
+static  inline void arch_write_lock(arch_rwlock_t *rw)
 {
 	arch_spin_lock(&rw->slock);
 	while (rw->lock != RW_LOCK_BIAS);
@@ -82,14 +82,14 @@ static  inline void __raw_write_lock(arc
 	arch_spin_unlock(&rw->slock);
 }
 
-static  inline void __raw_read_unlock(arch_rwlock_t *rw)
+static  inline void arch_read_unlock(arch_rwlock_t *rw)
 {
 	arch_spin_lock(&rw->slock);
 	rw->lock++;
 	arch_spin_unlock(&rw->slock);
 }
 
-static  inline void __raw_write_unlock(arch_rwlock_t *rw)
+static  inline void arch_write_unlock(arch_rwlock_t *rw)
 {
 	arch_spin_lock(&rw->slock);
 	while (rw->lock != RW_LOCK_BIAS);
@@ -97,7 +97,7 @@ static  inline void __raw_write_unlock(a
 	arch_spin_unlock(&rw->slock);
 }
 
-static  inline int __raw_read_trylock(arch_rwlock_t *rw)
+static  inline int arch_read_trylock(arch_rwlock_t *rw)
 {
 	int ret = 0;
 	arch_spin_lock(&rw->slock);
@@ -109,7 +109,7 @@ static  inline int __raw_read_trylock(ar
 	return ret;
 }
 
-static  inline int __raw_write_trylock(arch_rwlock_t *rw)
+static  inline int arch_write_trylock(arch_rwlock_t *rw)
 {
 	int ret = 0;
 	arch_spin_lock(&rw->slock);
Index: linux-2.6-tip/arch/ia64/include/asm/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/ia64/include/asm/spinlock.h
+++ linux-2.6-tip/arch/ia64/include/asm/spinlock.h
@@ -140,13 +140,13 @@ static inline void arch_spin_unlock_wait
 	__ticket_spin_unlock_wait(lock);
 }
 
-#define __raw_read_can_lock(rw)		(*(volatile int *)(rw) >= 0)
-#define __raw_write_can_lock(rw)	(*(volatile int *)(rw) == 0)
+#define arch_read_can_lock(rw)		(*(volatile int *)(rw) >= 0)
+#define arch_write_can_lock(rw)	(*(volatile int *)(rw) == 0)
 
 #ifdef ASM_SUPPORTED
 
 static __always_inline void
-__raw_read_lock_flags(arch_rwlock_t *lock, unsigned long flags)
+arch_read_lock_flags(arch_rwlock_t *lock, unsigned long flags)
 {
 	__asm__ __volatile__ (
 		"tbit.nz p6, p0 = %1,%2\n"
@@ -169,13 +169,13 @@ __raw_read_lock_flags(arch_rwlock_t *loc
 		: "p6", "p7", "r2", "memory");
 }
 
-#define __raw_read_lock(lock) __raw_read_lock_flags(lock, 0)
+#define arch_read_lock(lock) arch_read_lock_flags(lock, 0)
 
 #else /* !ASM_SUPPORTED */
 
-#define __raw_read_lock_flags(rw, flags) __raw_read_lock(rw)
+#define arch_read_lock_flags(rw, flags) arch_read_lock(rw)
 
-#define __raw_read_lock(rw)								\
+#define arch_read_lock(rw)								\
 do {											\
 	arch_rwlock_t *__read_lock_ptr = (rw);						\
 											\
@@ -188,7 +188,7 @@ do {											\
 
 #endif /* !ASM_SUPPORTED */
 
-#define __raw_read_unlock(rw)					\
+#define arch_read_unlock(rw)					\
 do {								\
 	arch_rwlock_t *__read_lock_ptr = (rw);			\
 	ia64_fetchadd(-1, (int *) __read_lock_ptr, rel);	\
@@ -197,7 +197,7 @@ do {								\
 #ifdef ASM_SUPPORTED
 
 static __always_inline void
-__raw_write_lock_flags(arch_rwlock_t *lock, unsigned long flags)
+arch_write_lock_flags(arch_rwlock_t *lock, unsigned long flags)
 {
 	__asm__ __volatile__ (
 		"tbit.nz p6, p0 = %1, %2\n"
@@ -221,9 +221,9 @@ __raw_write_lock_flags(arch_rwlock_t *lo
 		: "ar.ccv", "p6", "p7", "r2", "r29", "memory");
 }
 
-#define __raw_write_lock(rw) __raw_write_lock_flags(rw, 0)
+#define arch_write_lock(rw) arch_write_lock_flags(rw, 0)
 
-#define __raw_write_trylock(rw)							\
+#define arch_write_trylock(rw)							\
 ({										\
 	register long result;							\
 										\
@@ -235,7 +235,7 @@ __raw_write_lock_flags(arch_rwlock_t *lo
 	(result == 0);								\
 })
 
-static inline void __raw_write_unlock(arch_rwlock_t *x)
+static inline void arch_write_unlock(arch_rwlock_t *x)
 {
 	u8 *y = (u8 *)x;
 	barrier();
@@ -244,9 +244,9 @@ static inline void __raw_write_unlock(ar
 
 #else /* !ASM_SUPPORTED */
 
-#define __raw_write_lock_flags(l, flags) __raw_write_lock(l)
+#define arch_write_lock_flags(l, flags) arch_write_lock(l)
 
-#define __raw_write_lock(l)								\
+#define arch_write_lock(l)								\
 ({											\
 	__u64 ia64_val, ia64_set_val = ia64_dep_mi(-1, 0, 31, 1);			\
 	__u32 *ia64_write_lock_ptr = (__u32 *) (l);					\
@@ -257,7 +257,7 @@ static inline void __raw_write_unlock(ar
 	} while (ia64_val);								\
 })
 
-#define __raw_write_trylock(rw)						\
+#define arch_write_trylock(rw)						\
 ({									\
 	__u64 ia64_val;							\
 	__u64 ia64_set_val = ia64_dep_mi(-1, 0, 31,1);			\
@@ -265,7 +265,7 @@ static inline void __raw_write_unlock(ar
 	(ia64_val == 0);						\
 })
 
-static inline void __raw_write_unlock(arch_rwlock_t *x)
+static inline void arch_write_unlock(arch_rwlock_t *x)
 {
 	barrier();
 	x->write_lock = 0;
@@ -273,7 +273,7 @@ static inline void __raw_write_unlock(ar
 
 #endif /* !ASM_SUPPORTED */
 
-static inline int __raw_read_trylock(arch_rwlock_t *x)
+static inline int arch_read_trylock(arch_rwlock_t *x)
 {
 	union {
 		arch_rwlock_t lock;
Index: linux-2.6-tip/arch/m32r/include/asm/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/m32r/include/asm/spinlock.h
+++ linux-2.6-tip/arch/m32r/include/asm/spinlock.h
@@ -140,15 +140,15 @@ static inline void arch_spin_unlock(arch
  * read_can_lock - would read_trylock() succeed?
  * @lock: the rwlock in question.
  */
-#define __raw_read_can_lock(x) ((int)(x)->lock > 0)
+#define arch_read_can_lock(x) ((int)(x)->lock > 0)
 
 /**
  * write_can_lock - would write_trylock() succeed?
  * @lock: the rwlock in question.
  */
-#define __raw_write_can_lock(x) ((x)->lock == RW_LOCK_BIAS)
+#define arch_write_can_lock(x) ((x)->lock == RW_LOCK_BIAS)
 
-static inline void __raw_read_lock(arch_rwlock_t *rw)
+static inline void arch_read_lock(arch_rwlock_t *rw)
 {
 	unsigned long tmp0, tmp1;
 
@@ -199,7 +199,7 @@ static inline void __raw_read_lock(arch_
 	);
 }
 
-static inline void __raw_write_lock(arch_rwlock_t *rw)
+static inline void arch_write_lock(arch_rwlock_t *rw)
 {
 	unsigned long tmp0, tmp1, tmp2;
 
@@ -252,7 +252,7 @@ static inline void __raw_write_lock(arch
 	);
 }
 
-static inline void __raw_read_unlock(arch_rwlock_t *rw)
+static inline void arch_read_unlock(arch_rwlock_t *rw)
 {
 	unsigned long tmp0, tmp1;
 
@@ -274,7 +274,7 @@ static inline void __raw_read_unlock(arc
 	);
 }
 
-static inline void __raw_write_unlock(arch_rwlock_t *rw)
+static inline void arch_write_unlock(arch_rwlock_t *rw)
 {
 	unsigned long tmp0, tmp1, tmp2;
 
@@ -298,7 +298,7 @@ static inline void __raw_write_unlock(ar
 	);
 }
 
-static inline int __raw_read_trylock(arch_rwlock_t *lock)
+static inline int arch_read_trylock(arch_rwlock_t *lock)
 {
 	atomic_t *count = (atomic_t*)lock;
 	if (atomic_dec_return(count) >= 0)
@@ -307,7 +307,7 @@ static inline int __raw_read_trylock(arc
 	return 0;
 }
 
-static inline int __raw_write_trylock(arch_rwlock_t *lock)
+static inline int arch_write_trylock(arch_rwlock_t *lock)
 {
 	atomic_t *count = (atomic_t *)lock;
 	if (atomic_sub_and_test(RW_LOCK_BIAS, count))
@@ -316,8 +316,8 @@ static inline int __raw_write_trylock(ar
 	return 0;
 }
 
-#define __raw_read_lock_flags(lock, flags) __raw_read_lock(lock)
-#define __raw_write_lock_flags(lock, flags) __raw_write_lock(lock)
+#define arch_read_lock_flags(lock, flags) arch_read_lock(lock)
+#define arch_write_lock_flags(lock, flags) arch_write_lock(lock)
 
 #define arch_spin_relax(lock)	cpu_relax()
 #define arch_read_relax(lock)	cpu_relax()
Index: linux-2.6-tip/arch/mips/include/asm/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/mips/include/asm/spinlock.h
+++ linux-2.6-tip/arch/mips/include/asm/spinlock.h
@@ -248,21 +248,21 @@ static inline unsigned int arch_spin_try
  * read_can_lock - would read_trylock() succeed?
  * @lock: the rwlock in question.
  */
-#define __raw_read_can_lock(rw)	((rw)->lock >= 0)
+#define arch_read_can_lock(rw)	((rw)->lock >= 0)
 
 /*
  * write_can_lock - would write_trylock() succeed?
  * @lock: the rwlock in question.
  */
-#define __raw_write_can_lock(rw)	(!(rw)->lock)
+#define arch_write_can_lock(rw)	(!(rw)->lock)
 
-static inline void __raw_read_lock(arch_rwlock_t *rw)
+static inline void arch_read_lock(arch_rwlock_t *rw)
 {
 	unsigned int tmp;
 
 	if (R10000_LLSC_WAR) {
 		__asm__ __volatile__(
-		"	.set	noreorder	# __raw_read_lock	\n"
+		"	.set	noreorder	# arch_read_lock	\n"
 		"1:	ll	%1, %2					\n"
 		"	bltz	%1, 1b					\n"
 		"	 addu	%1, 1					\n"
@@ -275,7 +275,7 @@ static inline void __raw_read_lock(arch_
 		: "memory");
 	} else {
 		__asm__ __volatile__(
-		"	.set	noreorder	# __raw_read_lock	\n"
+		"	.set	noreorder	# arch_read_lock	\n"
 		"1:	ll	%1, %2					\n"
 		"	bltz	%1, 2f					\n"
 		"	 addu	%1, 1					\n"
@@ -301,7 +301,7 @@ static inline void __raw_read_lock(arch_
 /* Note the use of sub, not subu which will make the kernel die with an
    overflow exception if we ever try to unlock an rwlock that is already
    unlocked or is being held by a writer.  */
-static inline void __raw_read_unlock(arch_rwlock_t *rw)
+static inline void arch_read_unlock(arch_rwlock_t *rw)
 {
 	unsigned int tmp;
 
@@ -309,7 +309,7 @@ static inline void __raw_read_unlock(arc
 
 	if (R10000_LLSC_WAR) {
 		__asm__ __volatile__(
-		"1:	ll	%1, %2		# __raw_read_unlock	\n"
+		"1:	ll	%1, %2		# arch_read_unlock	\n"
 		"	sub	%1, 1					\n"
 		"	sc	%1, %0					\n"
 		"	beqzl	%1, 1b					\n"
@@ -318,7 +318,7 @@ static inline void __raw_read_unlock(arc
 		: "memory");
 	} else {
 		__asm__ __volatile__(
-		"	.set	noreorder	# __raw_read_unlock	\n"
+		"	.set	noreorder	# arch_read_unlock	\n"
 		"1:	ll	%1, %2					\n"
 		"	sub	%1, 1					\n"
 		"	sc	%1, %0					\n"
@@ -335,13 +335,13 @@ static inline void __raw_read_unlock(arc
 	}
 }
 
-static inline void __raw_write_lock(arch_rwlock_t *rw)
+static inline void arch_write_lock(arch_rwlock_t *rw)
 {
 	unsigned int tmp;
 
 	if (R10000_LLSC_WAR) {
 		__asm__ __volatile__(
-		"	.set	noreorder	# __raw_write_lock	\n"
+		"	.set	noreorder	# arch_write_lock	\n"
 		"1:	ll	%1, %2					\n"
 		"	bnez	%1, 1b					\n"
 		"	 lui	%1, 0x8000				\n"
@@ -354,7 +354,7 @@ static inline void __raw_write_lock(arch
 		: "memory");
 	} else {
 		__asm__ __volatile__(
-		"	.set	noreorder	# __raw_write_lock	\n"
+		"	.set	noreorder	# arch_write_lock	\n"
 		"1:	ll	%1, %2					\n"
 		"	bnez	%1, 2f					\n"
 		"	 lui	%1, 0x8000				\n"
@@ -377,26 +377,26 @@ static inline void __raw_write_lock(arch
 	smp_llsc_mb();
 }
 
-static inline void __raw_write_unlock(arch_rwlock_t *rw)
+static inline void arch_write_unlock(arch_rwlock_t *rw)
 {
 	smp_mb();
 
 	__asm__ __volatile__(
-	"				# __raw_write_unlock	\n"
+	"				# arch_write_unlock	\n"
 	"	sw	$0, %0					\n"
 	: "=m" (rw->lock)
 	: "m" (rw->lock)
 	: "memory");
 }
 
-static inline int __raw_read_trylock(arch_rwlock_t *rw)
+static inline int arch_read_trylock(arch_rwlock_t *rw)
 {
 	unsigned int tmp;
 	int ret;
 
 	if (R10000_LLSC_WAR) {
 		__asm__ __volatile__(
-		"	.set	noreorder	# __raw_read_trylock	\n"
+		"	.set	noreorder	# arch_read_trylock	\n"
 		"	li	%2, 0					\n"
 		"1:	ll	%1, %3					\n"
 		"	bltz	%1, 2f					\n"
@@ -413,7 +413,7 @@ static inline int __raw_read_trylock(arc
 		: "memory");
 	} else {
 		__asm__ __volatile__(
-		"	.set	noreorder	# __raw_read_trylock	\n"
+		"	.set	noreorder	# arch_read_trylock	\n"
 		"	li	%2, 0					\n"
 		"1:	ll	%1, %3					\n"
 		"	bltz	%1, 2f					\n"
@@ -433,14 +433,14 @@ static inline int __raw_read_trylock(arc
 	return ret;
 }
 
-static inline int __raw_write_trylock(arch_rwlock_t *rw)
+static inline int arch_write_trylock(arch_rwlock_t *rw)
 {
 	unsigned int tmp;
 	int ret;
 
 	if (R10000_LLSC_WAR) {
 		__asm__ __volatile__(
-		"	.set	noreorder	# __raw_write_trylock	\n"
+		"	.set	noreorder	# arch_write_trylock	\n"
 		"	li	%2, 0					\n"
 		"1:	ll	%1, %3					\n"
 		"	bnez	%1, 2f					\n"
@@ -457,7 +457,7 @@ static inline int __raw_write_trylock(ar
 		: "memory");
 	} else {
 		__asm__ __volatile__(
-		"	.set	noreorder	# __raw_write_trylock	\n"
+		"	.set	noreorder	# arch_write_trylock	\n"
 		"	li	%2, 0					\n"
 		"1:	ll	%1, %3					\n"
 		"	bnez	%1, 2f					\n"
@@ -480,8 +480,8 @@ static inline int __raw_write_trylock(ar
 	return ret;
 }
 
-#define __raw_read_lock_flags(lock, flags) __raw_read_lock(lock)
-#define __raw_write_lock_flags(lock, flags) __raw_write_lock(lock)
+#define arch_read_lock_flags(lock, flags) arch_read_lock(lock)
+#define arch_write_lock_flags(lock, flags) arch_write_lock(lock)
 
 #define arch_spin_relax(lock)	cpu_relax()
 #define arch_read_relax(lock)	cpu_relax()
Index: linux-2.6-tip/arch/parisc/include/asm/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/parisc/include/asm/spinlock.h
+++ linux-2.6-tip/arch/parisc/include/asm/spinlock.h
@@ -69,7 +69,7 @@ static inline int arch_spin_trylock(arch
 
 /* Note that we have to ensure interrupts are disabled in case we're
  * interrupted by some other code that wants to grab the same read lock */
-static  __inline__ void __raw_read_lock(arch_rwlock_t *rw)
+static  __inline__ void arch_read_lock(arch_rwlock_t *rw)
 {
 	unsigned long flags;
 	local_irq_save(flags);
@@ -81,7 +81,7 @@ static  __inline__ void __raw_read_lock(
 
 /* Note that we have to ensure interrupts are disabled in case we're
  * interrupted by some other code that wants to grab the same read lock */
-static  __inline__ void __raw_read_unlock(arch_rwlock_t *rw)
+static  __inline__ void arch_read_unlock(arch_rwlock_t *rw)
 {
 	unsigned long flags;
 	local_irq_save(flags);
@@ -93,7 +93,7 @@ static  __inline__ void __raw_read_unloc
 
 /* Note that we have to ensure interrupts are disabled in case we're
  * interrupted by some other code that wants to grab the same read lock */
-static __inline__ int __raw_read_trylock(arch_rwlock_t *rw)
+static __inline__ int arch_read_trylock(arch_rwlock_t *rw)
 {
 	unsigned long flags;
  retry:
@@ -119,7 +119,7 @@ static __inline__ int __raw_read_trylock
 
 /* Note that we have to ensure interrupts are disabled in case we're
  * interrupted by some other code that wants to read_trylock() this lock */
-static __inline__ void __raw_write_lock(arch_rwlock_t *rw)
+static __inline__ void arch_write_lock(arch_rwlock_t *rw)
 {
 	unsigned long flags;
 retry:
@@ -141,7 +141,7 @@ retry:
 	local_irq_restore(flags);
 }
 
-static __inline__ void __raw_write_unlock(arch_rwlock_t *rw)
+static __inline__ void arch_write_unlock(arch_rwlock_t *rw)
 {
 	rw->counter = 0;
 	arch_spin_unlock(&rw->lock);
@@ -149,7 +149,7 @@ static __inline__ void __raw_write_unloc
 
 /* Note that we have to ensure interrupts are disabled in case we're
  * interrupted by some other code that wants to read_trylock() this lock */
-static __inline__ int __raw_write_trylock(arch_rwlock_t *rw)
+static __inline__ int arch_write_trylock(arch_rwlock_t *rw)
 {
 	unsigned long flags;
 	int result = 0;
@@ -173,7 +173,7 @@ static __inline__ int __raw_write_tryloc
  * read_can_lock - would read_trylock() succeed?
  * @lock: the rwlock in question.
  */
-static __inline__ int __raw_read_can_lock(arch_rwlock_t *rw)
+static __inline__ int arch_read_can_lock(arch_rwlock_t *rw)
 {
 	return rw->counter >= 0;
 }
@@ -182,13 +182,13 @@ static __inline__ int __raw_read_can_loc
  * write_can_lock - would write_trylock() succeed?
  * @lock: the rwlock in question.
  */
-static __inline__ int __raw_write_can_lock(arch_rwlock_t *rw)
+static __inline__ int arch_write_can_lock(arch_rwlock_t *rw)
 {
 	return !rw->counter;
 }
 
-#define __raw_read_lock_flags(lock, flags) __raw_read_lock(lock)
-#define __raw_write_lock_flags(lock, flags) __raw_write_lock(lock)
+#define arch_read_lock_flags(lock, flags) arch_read_lock(lock)
+#define arch_write_lock_flags(lock, flags) arch_write_lock(lock)
 
 #define arch_spin_relax(lock)	cpu_relax()
 #define arch_read_relax(lock)	cpu_relax()
Index: linux-2.6-tip/arch/powerpc/include/asm/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/include/asm/spinlock.h
+++ linux-2.6-tip/arch/powerpc/include/asm/spinlock.h
@@ -166,8 +166,8 @@ extern void arch_spin_unlock_wait(arch_s
  * read-locks.
  */
 
-#define __raw_read_can_lock(rw)		((rw)->lock >= 0)
-#define __raw_write_can_lock(rw)	(!(rw)->lock)
+#define arch_read_can_lock(rw)		((rw)->lock >= 0)
+#define arch_write_can_lock(rw)	(!(rw)->lock)
 
 #ifdef CONFIG_PPC64
 #define __DO_SIGN_EXTEND	"extsw	%0,%0\n"
@@ -181,7 +181,7 @@ extern void arch_spin_unlock_wait(arch_s
  * This returns the old value in the lock + 1,
  * so we got a read lock if the return value is > 0.
  */
-static inline long arch_read_trylock(arch_rwlock_t *rw)
+static inline long __arch_read_trylock(arch_rwlock_t *rw)
 {
 	long tmp;
 
@@ -205,7 +205,7 @@ static inline long arch_read_trylock(arc
  * This returns the old value in the lock,
  * so we got the write lock if the return value is 0.
  */
-static inline long arch_write_trylock(arch_rwlock_t *rw)
+static inline long __arch_write_trylock(arch_rwlock_t *rw)
 {
 	long tmp, token;
 
@@ -225,10 +225,10 @@ static inline long arch_write_trylock(ar
 	return tmp;
 }
 
-static inline void __raw_read_lock(arch_rwlock_t *rw)
+static inline void arch_read_lock(arch_rwlock_t *rw)
 {
 	while (1) {
-		if (likely(arch_read_trylock(rw) > 0))
+		if (likely(__arch_read_trylock(rw) > 0))
 			break;
 		do {
 			HMT_low();
@@ -239,10 +239,10 @@ static inline void __raw_read_lock(arch_
 	}
 }
 
-static inline void __raw_write_lock(arch_rwlock_t *rw)
+static inline void arch_write_lock(arch_rwlock_t *rw)
 {
 	while (1) {
-		if (likely(arch_write_trylock(rw) == 0))
+		if (likely(__arch_write_trylock(rw) == 0))
 			break;
 		do {
 			HMT_low();
@@ -253,17 +253,17 @@ static inline void __raw_write_lock(arch
 	}
 }
 
-static inline int __raw_read_trylock(arch_rwlock_t *rw)
+static inline int arch_read_trylock(arch_rwlock_t *rw)
 {
-	return arch_read_trylock(rw) > 0;
+	return __arch_read_trylock(rw) > 0;
 }
 
-static inline int __raw_write_trylock(arch_rwlock_t *rw)
+static inline int arch_write_trylock(arch_rwlock_t *rw)
 {
-	return arch_write_trylock(rw) == 0;
+	return __arch_write_trylock(rw) == 0;
 }
 
-static inline void __raw_read_unlock(arch_rwlock_t *rw)
+static inline void arch_read_unlock(arch_rwlock_t *rw)
 {
 	long tmp;
 
@@ -280,15 +280,15 @@ static inline void __raw_read_unlock(arc
 	: "cr0", "xer", "memory");
 }
 
-static inline void __raw_write_unlock(arch_rwlock_t *rw)
+static inline void arch_write_unlock(arch_rwlock_t *rw)
 {
 	__asm__ __volatile__("# write_unlock\n\t"
 				LWSYNC_ON_SMP: : :"memory");
 	rw->lock = 0;
 }
 
-#define __raw_read_lock_flags(lock, flags) __raw_read_lock(lock)
-#define __raw_write_lock_flags(lock, flags) __raw_write_lock(lock)
+#define arch_read_lock_flags(lock, flags) arch_read_lock(lock)
+#define arch_write_lock_flags(lock, flags) arch_write_lock(lock)
 
 #define arch_spin_relax(lock)	__spin_yield(lock)
 #define arch_read_relax(lock)	__rw_yield(lock)
Index: linux-2.6-tip/arch/s390/include/asm/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/s390/include/asm/spinlock.h
+++ linux-2.6-tip/arch/s390/include/asm/spinlock.h
@@ -113,13 +113,13 @@ static inline void arch_spin_unlock(arch
  * read_can_lock - would read_trylock() succeed?
  * @lock: the rwlock in question.
  */
-#define __raw_read_can_lock(x) ((int)(x)->lock >= 0)
+#define arch_read_can_lock(x) ((int)(x)->lock >= 0)
 
 /**
  * write_can_lock - would write_trylock() succeed?
  * @lock: the rwlock in question.
  */
-#define __raw_write_can_lock(x) ((x)->lock == 0)
+#define arch_write_can_lock(x) ((x)->lock == 0)
 
 extern void _raw_read_lock_wait(arch_rwlock_t *lp);
 extern void _raw_read_lock_wait_flags(arch_rwlock_t *lp, unsigned long flags);
@@ -128,7 +128,7 @@ extern void _raw_write_lock_wait(arch_rw
 extern void _raw_write_lock_wait_flags(arch_rwlock_t *lp, unsigned long flags);
 extern int _raw_write_trylock_retry(arch_rwlock_t *lp);
 
-static inline void __raw_read_lock(arch_rwlock_t *rw)
+static inline void arch_read_lock(arch_rwlock_t *rw)
 {
 	unsigned int old;
 	old = rw->lock & 0x7fffffffU;
@@ -136,7 +136,7 @@ static inline void __raw_read_lock(arch_
 		_raw_read_lock_wait(rw);
 }
 
-static inline void __raw_read_lock_flags(arch_rwlock_t *rw, unsigned long flags)
+static inline void arch_read_lock_flags(arch_rwlock_t *rw, unsigned long flags)
 {
 	unsigned int old;
 	old = rw->lock & 0x7fffffffU;
@@ -144,7 +144,7 @@ static inline void __raw_read_lock_flags
 		_raw_read_lock_wait_flags(rw, flags);
 }
 
-static inline void __raw_read_unlock(arch_rwlock_t *rw)
+static inline void arch_read_unlock(arch_rwlock_t *rw)
 {
 	unsigned int old, cmp;
 
@@ -155,24 +155,24 @@ static inline void __raw_read_unlock(arc
 	} while (cmp != old);
 }
 
-static inline void __raw_write_lock(arch_rwlock_t *rw)
+static inline void arch_write_lock(arch_rwlock_t *rw)
 {
 	if (unlikely(_raw_compare_and_swap(&rw->lock, 0, 0x80000000) != 0))
 		_raw_write_lock_wait(rw);
 }
 
-static inline void __raw_write_lock_flags(arch_rwlock_t *rw, unsigned long flags)
+static inline void arch_write_lock_flags(arch_rwlock_t *rw, unsigned long flags)
 {
 	if (unlikely(_raw_compare_and_swap(&rw->lock, 0, 0x80000000) != 0))
 		_raw_write_lock_wait_flags(rw, flags);
 }
 
-static inline void __raw_write_unlock(arch_rwlock_t *rw)
+static inline void arch_write_unlock(arch_rwlock_t *rw)
 {
 	_raw_compare_and_swap(&rw->lock, 0x80000000, 0);
 }
 
-static inline int __raw_read_trylock(arch_rwlock_t *rw)
+static inline int arch_read_trylock(arch_rwlock_t *rw)
 {
 	unsigned int old;
 	old = rw->lock & 0x7fffffffU;
@@ -181,7 +181,7 @@ static inline int __raw_read_trylock(arc
 	return _raw_read_trylock_retry(rw);
 }
 
-static inline int __raw_write_trylock(arch_rwlock_t *rw)
+static inline int arch_write_trylock(arch_rwlock_t *rw)
 {
 	if (likely(_raw_compare_and_swap(&rw->lock, 0, 0x80000000) == 0))
 		return 1;
Index: linux-2.6-tip/arch/s390/lib/spinlock.c
===================================================================
--- linux-2.6-tip.orig/arch/s390/lib/spinlock.c
+++ linux-2.6-tip/arch/s390/lib/spinlock.c
@@ -115,7 +115,7 @@ void _raw_read_lock_wait(arch_rwlock_t *
 			_raw_yield();
 			count = spin_retry;
 		}
-		if (!__raw_read_can_lock(rw))
+		if (!arch_read_can_lock(rw))
 			continue;
 		old = rw->lock & 0x7fffffffU;
 		if (_raw_compare_and_swap(&rw->lock, old, old + 1) == old)
@@ -135,7 +135,7 @@ void _raw_read_lock_wait_flags(arch_rwlo
 			_raw_yield();
 			count = spin_retry;
 		}
-		if (!__raw_read_can_lock(rw))
+		if (!arch_read_can_lock(rw))
 			continue;
 		old = rw->lock & 0x7fffffffU;
 		local_irq_disable();
@@ -151,7 +151,7 @@ int _raw_read_trylock_retry(arch_rwlock_
 	int count = spin_retry;
 
 	while (count-- > 0) {
-		if (!__raw_read_can_lock(rw))
+		if (!arch_read_can_lock(rw))
 			continue;
 		old = rw->lock & 0x7fffffffU;
 		if (_raw_compare_and_swap(&rw->lock, old, old + 1) == old)
@@ -170,7 +170,7 @@ void _raw_write_lock_wait(arch_rwlock_t 
 			_raw_yield();
 			count = spin_retry;
 		}
-		if (!__raw_write_can_lock(rw))
+		if (!arch_write_can_lock(rw))
 			continue;
 		if (_raw_compare_and_swap(&rw->lock, 0, 0x80000000) == 0)
 			return;
@@ -188,7 +188,7 @@ void _raw_write_lock_wait_flags(arch_rwl
 			_raw_yield();
 			count = spin_retry;
 		}
-		if (!__raw_write_can_lock(rw))
+		if (!arch_write_can_lock(rw))
 			continue;
 		local_irq_disable();
 		if (_raw_compare_and_swap(&rw->lock, 0, 0x80000000) == 0)
@@ -202,7 +202,7 @@ int _raw_write_trylock_retry(arch_rwlock
 	int count = spin_retry;
 
 	while (count-- > 0) {
-		if (!__raw_write_can_lock(rw))
+		if (!arch_write_can_lock(rw))
 			continue;
 		if (_raw_compare_and_swap(&rw->lock, 0, 0x80000000) == 0)
 			return 1;
Index: linux-2.6-tip/arch/sh/include/asm/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/sh/include/asm/spinlock.h
+++ linux-2.6-tip/arch/sh/include/asm/spinlock.h
@@ -100,21 +100,21 @@ static inline int arch_spin_trylock(arch
  * read_can_lock - would read_trylock() succeed?
  * @lock: the rwlock in question.
  */
-#define __raw_read_can_lock(x)	((x)->lock > 0)
+#define arch_read_can_lock(x)	((x)->lock > 0)
 
 /**
  * write_can_lock - would write_trylock() succeed?
  * @lock: the rwlock in question.
  */
-#define __raw_write_can_lock(x)	((x)->lock == RW_LOCK_BIAS)
+#define arch_write_can_lock(x)	((x)->lock == RW_LOCK_BIAS)
 
-static inline void __raw_read_lock(arch_rwlock_t *rw)
+static inline void arch_read_lock(arch_rwlock_t *rw)
 {
 	unsigned long tmp;
 
 	__asm__ __volatile__ (
 		"1:						\n\t"
-		"movli.l	@%1, %0	! __raw_read_lock	\n\t"
+		"movli.l	@%1, %0	! arch_read_lock	\n\t"
 		"cmp/pl		%0				\n\t"
 		"bf		1b				\n\t"
 		"add		#-1, %0				\n\t"
@@ -126,13 +126,13 @@ static inline void __raw_read_lock(arch_
 	);
 }
 
-static inline void __raw_read_unlock(arch_rwlock_t *rw)
+static inline void arch_read_unlock(arch_rwlock_t *rw)
 {
 	unsigned long tmp;
 
 	__asm__ __volatile__ (
 		"1:						\n\t"
-		"movli.l	@%1, %0	! __raw_read_unlock	\n\t"
+		"movli.l	@%1, %0	! arch_read_unlock	\n\t"
 		"add		#1, %0				\n\t"
 		"movco.l	%0, @%1				\n\t"
 		"bf		1b				\n\t"
@@ -142,13 +142,13 @@ static inline void __raw_read_unlock(arc
 	);
 }
 
-static inline void __raw_write_lock(arch_rwlock_t *rw)
+static inline void arch_write_lock(arch_rwlock_t *rw)
 {
 	unsigned long tmp;
 
 	__asm__ __volatile__ (
 		"1:						\n\t"
-		"movli.l	@%1, %0	! __raw_write_lock	\n\t"
+		"movli.l	@%1, %0	! arch_write_lock	\n\t"
 		"cmp/hs		%2, %0				\n\t"
 		"bf		1b				\n\t"
 		"sub		%2, %0				\n\t"
@@ -160,23 +160,23 @@ static inline void __raw_write_lock(arch
 	);
 }
 
-static inline void __raw_write_unlock(arch_rwlock_t *rw)
+static inline void arch_write_unlock(arch_rwlock_t *rw)
 {
 	__asm__ __volatile__ (
-		"mov.l		%1, @%0 ! __raw_write_unlock	\n\t"
+		"mov.l		%1, @%0 ! arch_write_unlock	\n\t"
 		:
 		: "r" (&rw->lock), "r" (RW_LOCK_BIAS)
 		: "t", "memory"
 	);
 }
 
-static inline int __raw_read_trylock(arch_rwlock_t *rw)
+static inline int arch_read_trylock(arch_rwlock_t *rw)
 {
 	unsigned long tmp, oldval;
 
 	__asm__ __volatile__ (
 		"1:						\n\t"
-		"movli.l	@%2, %0	! __raw_read_trylock	\n\t"
+		"movli.l	@%2, %0	! arch_read_trylock	\n\t"
 		"mov		%0, %1				\n\t"
 		"cmp/pl		%0				\n\t"
 		"bf		2f				\n\t"
@@ -193,13 +193,13 @@ static inline int __raw_read_trylock(arc
 	return (oldval > 0);
 }
 
-static inline int __raw_write_trylock(arch_rwlock_t *rw)
+static inline int arch_write_trylock(arch_rwlock_t *rw)
 {
 	unsigned long tmp, oldval;
 
 	__asm__ __volatile__ (
 		"1:						\n\t"
-		"movli.l	@%2, %0	! __raw_write_trylock	\n\t"
+		"movli.l	@%2, %0	! arch_write_trylock	\n\t"
 		"mov		%0, %1				\n\t"
 		"cmp/hs		%3, %0				\n\t"
 		"bf		2f				\n\t"
@@ -216,8 +216,8 @@ static inline int __raw_write_trylock(ar
 	return (oldval > (RW_LOCK_BIAS - 1));
 }
 
-#define __raw_read_lock_flags(lock, flags) __raw_read_lock(lock)
-#define __raw_write_lock_flags(lock, flags) __raw_write_lock(lock)
+#define arch_read_lock_flags(lock, flags) arch_read_lock(lock)
+#define arch_write_lock_flags(lock, flags) arch_write_lock(lock)
 
 #define arch_spin_relax(lock)	cpu_relax()
 #define arch_read_relax(lock)	cpu_relax()
Index: linux-2.6-tip/arch/sparc/include/asm/spinlock_32.h
===================================================================
--- linux-2.6-tip.orig/arch/sparc/include/asm/spinlock_32.h
+++ linux-2.6-tip/arch/sparc/include/asm/spinlock_32.h
@@ -76,7 +76,7 @@ static inline void arch_spin_unlock(arch
  *
  * Unfortunately this scheme limits us to ~16,000,000 cpus.
  */
-static inline void arch_read_lock(arch_rwlock_t *rw)
+static inline void __arch_read_lock(arch_rwlock_t *rw)
 {
 	register arch_rwlock_t *lp asm("g1");
 	lp = rw;
@@ -89,14 +89,14 @@ static inline void arch_read_lock(arch_r
 	: "g2", "g4", "memory", "cc");
 }
 
-#define __raw_read_lock(lock) \
+#define arch_read_lock(lock) \
 do {	unsigned long flags; \
 	local_irq_save(flags); \
-	arch_read_lock(lock); \
+	__arch_read_lock(lock); \
 	local_irq_restore(flags); \
 } while(0)
 
-static inline void arch_read_unlock(arch_rwlock_t *rw)
+static inline void __arch_read_unlock(arch_rwlock_t *rw)
 {
 	register arch_rwlock_t *lp asm("g1");
 	lp = rw;
@@ -109,14 +109,14 @@ static inline void arch_read_unlock(arch
 	: "g2", "g4", "memory", "cc");
 }
 
-#define __raw_read_unlock(lock) \
+#define arch_read_unlock(lock) \
 do {	unsigned long flags; \
 	local_irq_save(flags); \
-	arch_read_unlock(lock); \
+	__arch_read_unlock(lock); \
 	local_irq_restore(flags); \
 } while(0)
 
-static inline void __raw_write_lock(arch_rwlock_t *rw)
+static inline void arch_write_lock(arch_rwlock_t *rw)
 {
 	register arch_rwlock_t *lp asm("g1");
 	lp = rw;
@@ -130,7 +130,7 @@ static inline void __raw_write_lock(arch
 	*(volatile __u32 *)&lp->lock = ~0U;
 }
 
-static inline int __raw_write_trylock(arch_rwlock_t *rw)
+static inline int arch_write_trylock(arch_rwlock_t *rw)
 {
 	unsigned int val;
 
@@ -150,7 +150,7 @@ static inline int __raw_write_trylock(ar
 	return (val == 0);
 }
 
-static inline int arch_read_trylock(arch_rwlock_t *rw)
+static inline int __arch_read_trylock(arch_rwlock_t *rw)
 {
 	register arch_rwlock_t *lp asm("g1");
 	register int res asm("o0");
@@ -165,27 +165,27 @@ static inline int arch_read_trylock(arch
 	return res;
 }
 
-#define __raw_read_trylock(lock) \
+#define arch_read_trylock(lock) \
 ({	unsigned long flags; \
 	int res; \
 	local_irq_save(flags); \
-	res = arch_read_trylock(lock); \
+	res = __arch_read_trylock(lock); \
 	local_irq_restore(flags); \
 	res; \
 })
 
-#define __raw_write_unlock(rw)	do { (rw)->lock = 0; } while(0)
+#define arch_write_unlock(rw)	do { (rw)->lock = 0; } while(0)
 
 #define arch_spin_lock_flags(lock, flags) arch_spin_lock(lock)
-#define __raw_read_lock_flags(rw, flags)   __raw_read_lock(rw)
-#define __raw_write_lock_flags(rw, flags)  __raw_write_lock(rw)
+#define arch_read_lock_flags(rw, flags)   arch_read_lock(rw)
+#define arch_write_lock_flags(rw, flags)  arch_write_lock(rw)
 
 #define arch_spin_relax(lock)	cpu_relax()
 #define arch_read_relax(lock)	cpu_relax()
 #define arch_write_relax(lock)	cpu_relax()
 
-#define __raw_read_can_lock(rw) (!((rw)->lock & 0xff))
-#define __raw_write_can_lock(rw) (!(rw)->lock)
+#define arch_read_can_lock(rw) (!((rw)->lock & 0xff))
+#define arch_write_can_lock(rw) (!(rw)->lock)
 
 #endif /* !(__ASSEMBLY__) */
 
Index: linux-2.6-tip/arch/sparc/include/asm/spinlock_64.h
===================================================================
--- linux-2.6-tip.orig/arch/sparc/include/asm/spinlock_64.h
+++ linux-2.6-tip/arch/sparc/include/asm/spinlock_64.h
@@ -210,17 +210,17 @@ static int inline arch_write_trylock(arc
 	return result;
 }
 
-#define __raw_read_lock(p)	arch_read_lock(p)
-#define __raw_read_lock_flags(p, f) arch_read_lock(p)
-#define __raw_read_trylock(p)	arch_read_trylock(p)
-#define __raw_read_unlock(p)	arch_read_unlock(p)
-#define __raw_write_lock(p)	arch_write_lock(p)
-#define __raw_write_lock_flags(p, f) arch_write_lock(p)
-#define __raw_write_unlock(p)	arch_write_unlock(p)
-#define __raw_write_trylock(p)	arch_write_trylock(p)
+#define arch_read_lock(p)	arch_read_lock(p)
+#define arch_read_lock_flags(p, f) arch_read_lock(p)
+#define arch_read_trylock(p)	arch_read_trylock(p)
+#define arch_read_unlock(p)	arch_read_unlock(p)
+#define arch_write_lock(p)	arch_write_lock(p)
+#define arch_write_lock_flags(p, f) arch_write_lock(p)
+#define arch_write_unlock(p)	arch_write_unlock(p)
+#define arch_write_trylock(p)	arch_write_trylock(p)
 
-#define __raw_read_can_lock(rw)		(!((rw)->lock & 0x80000000UL))
-#define __raw_write_can_lock(rw)	(!(rw)->lock)
+#define arch_read_can_lock(rw)		(!((rw)->lock & 0x80000000UL))
+#define arch_write_can_lock(rw)	(!(rw)->lock)
 
 #define arch_spin_relax(lock)	cpu_relax()
 #define arch_read_relax(lock)	cpu_relax()
Index: linux-2.6-tip/arch/x86/include/asm/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/x86/include/asm/spinlock.h
+++ linux-2.6-tip/arch/x86/include/asm/spinlock.h
@@ -232,7 +232,7 @@ static inline void arch_spin_unlock_wait
  * read_can_lock - would read_trylock() succeed?
  * @lock: the rwlock in question.
  */
-static inline int __raw_read_can_lock(arch_rwlock_t *lock)
+static inline int arch_read_can_lock(arch_rwlock_t *lock)
 {
 	return (int)(lock)->lock > 0;
 }
@@ -241,12 +241,12 @@ static inline int __raw_read_can_lock(ar
  * write_can_lock - would write_trylock() succeed?
  * @lock: the rwlock in question.
  */
-static inline int __raw_write_can_lock(arch_rwlock_t *lock)
+static inline int arch_write_can_lock(arch_rwlock_t *lock)
 {
 	return (lock)->lock == RW_LOCK_BIAS;
 }
 
-static inline void __raw_read_lock(arch_rwlock_t *rw)
+static inline void arch_read_lock(arch_rwlock_t *rw)
 {
 	asm volatile(LOCK_PREFIX " subl $1,(%0)\n\t"
 		     "jns 1f\n"
@@ -255,7 +255,7 @@ static inline void __raw_read_lock(arch_
 		     ::LOCK_PTR_REG (rw) : "memory");
 }
 
-static inline void __raw_write_lock(arch_rwlock_t *rw)
+static inline void arch_write_lock(arch_rwlock_t *rw)
 {
 	asm volatile(LOCK_PREFIX " subl %1,(%0)\n\t"
 		     "jz 1f\n"
@@ -264,7 +264,7 @@ static inline void __raw_write_lock(arch
 		     ::LOCK_PTR_REG (rw), "i" (RW_LOCK_BIAS) : "memory");
 }
 
-static inline int __raw_read_trylock(arch_rwlock_t *lock)
+static inline int arch_read_trylock(arch_rwlock_t *lock)
 {
 	atomic_t *count = (atomic_t *)lock;
 
@@ -274,7 +274,7 @@ static inline int __raw_read_trylock(arc
 	return 0;
 }
 
-static inline int __raw_write_trylock(arch_rwlock_t *lock)
+static inline int arch_write_trylock(arch_rwlock_t *lock)
 {
 	atomic_t *count = (atomic_t *)lock;
 
@@ -284,19 +284,19 @@ static inline int __raw_write_trylock(ar
 	return 0;
 }
 
-static inline void __raw_read_unlock(arch_rwlock_t *rw)
+static inline void arch_read_unlock(arch_rwlock_t *rw)
 {
 	asm volatile(LOCK_PREFIX "incl %0" :"+m" (rw->lock) : : "memory");
 }
 
-static inline void __raw_write_unlock(arch_rwlock_t *rw)
+static inline void arch_write_unlock(arch_rwlock_t *rw)
 {
 	asm volatile(LOCK_PREFIX "addl %1, %0"
 		     : "+m" (rw->lock) : "i" (RW_LOCK_BIAS) : "memory");
 }
 
-#define __raw_read_lock_flags(lock, flags) __raw_read_lock(lock)
-#define __raw_write_lock_flags(lock, flags) __raw_write_lock(lock)
+#define arch_read_lock_flags(lock, flags) arch_read_lock(lock)
+#define arch_write_lock_flags(lock, flags) arch_write_lock(lock)
 
 #define arch_spin_relax(lock)	cpu_relax()
 #define arch_read_relax(lock)	cpu_relax()
Index: linux-2.6-tip/include/linux/rwlock.h
===================================================================
--- linux-2.6-tip.orig/include/linux/rwlock.h
+++ linux-2.6-tip/include/linux/rwlock.h
@@ -14,7 +14,7 @@
  * Released under the General Public License (GPL).
  */
 
-extern int __lockfunc generic__raw_read_trylock(arch_rwlock_t *lock);
+extern int __lockfunc genericarch_read_trylock(arch_rwlock_t *lock);
 
 #ifdef CONFIG_DEBUG_SPINLOCK
   extern void __rwlock_init(rwlock_t *lock, const char *name,
@@ -40,20 +40,20 @@ do {								\
  extern int _raw_write_trylock(rwlock_t *lock);
  extern void _raw_write_unlock(rwlock_t *lock);
 #else
-# define _raw_read_lock(rwlock)		__raw_read_lock(&(rwlock)->raw_lock)
+# define _raw_read_lock(rwlock)		arch_read_lock(&(rwlock)->raw_lock)
 # define _raw_read_lock_flags(lock, flags) \
-		__raw_read_lock_flags(&(lock)->raw_lock, *(flags))
-# define _raw_read_trylock(rwlock)	__raw_read_trylock(&(rwlock)->raw_lock)
-# define _raw_read_unlock(rwlock)	__raw_read_unlock(&(rwlock)->raw_lock)
-# define _raw_write_lock(rwlock)	__raw_write_lock(&(rwlock)->raw_lock)
+		arch_read_lock_flags(&(lock)->raw_lock, *(flags))
+# define _raw_read_trylock(rwlock)	arch_read_trylock(&(rwlock)->raw_lock)
+# define _raw_read_unlock(rwlock)	arch_read_unlock(&(rwlock)->raw_lock)
+# define _raw_write_lock(rwlock)	arch_write_lock(&(rwlock)->raw_lock)
 # define _raw_write_lock_flags(lock, flags) \
-		__raw_write_lock_flags(&(lock)->raw_lock, *(flags))
-# define _raw_write_trylock(rwlock)	__raw_write_trylock(&(rwlock)->raw_lock)
-# define _raw_write_unlock(rwlock)	__raw_write_unlock(&(rwlock)->raw_lock)
+		arch_write_lock_flags(&(lock)->raw_lock, *(flags))
+# define _raw_write_trylock(rwlock)	arch_write_trylock(&(rwlock)->raw_lock)
+# define _raw_write_unlock(rwlock)	arch_write_unlock(&(rwlock)->raw_lock)
 #endif
 
-#define read_can_lock(rwlock)		__raw_read_can_lock(&(rwlock)->raw_lock)
-#define write_can_lock(rwlock)		__raw_write_can_lock(&(rwlock)->raw_lock)
+#define read_can_lock(rwlock)		arch_read_can_lock(&(rwlock)->raw_lock)
+#define write_can_lock(rwlock)		arch_write_can_lock(&(rwlock)->raw_lock)
 
 /*
  * Define the various rw_lock methods.  Note we define these
Index: linux-2.6-tip/include/linux/spinlock_up.h
===================================================================
--- linux-2.6-tip.orig/include/linux/spinlock_up.h
+++ linux-2.6-tip/include/linux/spinlock_up.h
@@ -49,12 +49,12 @@ static inline void arch_spin_unlock(arch
 /*
  * Read-write spinlocks. No debug version.
  */
-#define __raw_read_lock(lock)		do { (void)(lock); } while (0)
-#define __raw_write_lock(lock)		do { (void)(lock); } while (0)
-#define __raw_read_trylock(lock)	({ (void)(lock); 1; })
-#define __raw_write_trylock(lock)	({ (void)(lock); 1; })
-#define __raw_read_unlock(lock)		do { (void)(lock); } while (0)
-#define __raw_write_unlock(lock)	do { (void)(lock); } while (0)
+#define arch_read_lock(lock)		do { (void)(lock); } while (0)
+#define arch_write_lock(lock)		do { (void)(lock); } while (0)
+#define arch_read_trylock(lock)	({ (void)(lock); 1; })
+#define arch_write_trylock(lock)	({ (void)(lock); 1; })
+#define arch_read_unlock(lock)		do { (void)(lock); } while (0)
+#define arch_write_unlock(lock)	do { (void)(lock); } while (0)
 
 #else /* DEBUG_SPINLOCK */
 #define arch_spin_is_locked(lock)	((void)(lock), 0)
@@ -67,8 +67,8 @@ static inline void arch_spin_unlock(arch
 
 #define arch_spin_is_contended(lock)	(((void)(lock), 0))
 
-#define __raw_read_can_lock(lock)	(((void)(lock), 1))
-#define __raw_write_can_lock(lock)	(((void)(lock), 1))
+#define arch_read_can_lock(lock)	(((void)(lock), 1))
+#define arch_write_can_lock(lock)	(((void)(lock), 1))
 
 #define arch_spin_unlock_wait(lock) \
 		do { cpu_relax(); } while (arch_spin_is_locked(lock))
Index: linux-2.6-tip/lib/spinlock_debug.c
===================================================================
--- linux-2.6-tip.orig/lib/spinlock_debug.c
+++ linux-2.6-tip/lib/spinlock_debug.c
@@ -176,7 +176,7 @@ static void __read_lock_debug(rwlock_t *
 
 	for (;;) {
 		for (i = 0; i < loops; i++) {
-			if (__raw_read_trylock(&lock->raw_lock))
+			if (arch_read_trylock(&lock->raw_lock))
 				return;
 			__delay(1);
 		}
@@ -196,12 +196,12 @@ static void __read_lock_debug(rwlock_t *
 void _raw_read_lock(rwlock_t *lock)
 {
 	RWLOCK_BUG_ON(lock->magic != RWLOCK_MAGIC, lock, "bad magic");
-	__raw_read_lock(&lock->raw_lock);
+	arch_read_lock(&lock->raw_lock);
 }
 
 int _raw_read_trylock(rwlock_t *lock)
 {
-	int ret = __raw_read_trylock(&lock->raw_lock);
+	int ret = arch_read_trylock(&lock->raw_lock);
 
 #ifndef CONFIG_SMP
 	/*
@@ -215,7 +215,7 @@ int _raw_read_trylock(rwlock_t *lock)
 void _raw_read_unlock(rwlock_t *lock)
 {
 	RWLOCK_BUG_ON(lock->magic != RWLOCK_MAGIC, lock, "bad magic");
-	__raw_read_unlock(&lock->raw_lock);
+	arch_read_unlock(&lock->raw_lock);
 }
 
 static inline void debug_write_lock_before(rwlock_t *lock)
@@ -251,7 +251,7 @@ static void __write_lock_debug(rwlock_t 
 
 	for (;;) {
 		for (i = 0; i < loops; i++) {
-			if (__raw_write_trylock(&lock->raw_lock))
+			if (arch_write_trylock(&lock->raw_lock))
 				return;
 			__delay(1);
 		}
@@ -271,13 +271,13 @@ static void __write_lock_debug(rwlock_t 
 void _raw_write_lock(rwlock_t *lock)
 {
 	debug_write_lock_before(lock);
-	__raw_write_lock(&lock->raw_lock);
+	arch_write_lock(&lock->raw_lock);
 	debug_write_lock_after(lock);
 }
 
 int _raw_write_trylock(rwlock_t *lock)
 {
-	int ret = __raw_write_trylock(&lock->raw_lock);
+	int ret = arch_write_trylock(&lock->raw_lock);
 
 	if (ret)
 		debug_write_lock_after(lock);
@@ -293,5 +293,5 @@ int _raw_write_trylock(rwlock_t *lock)
 void _raw_write_unlock(rwlock_t *lock)
 {
 	debug_write_unlock(lock);
-	__raw_write_unlock(&lock->raw_lock);
+	arch_write_unlock(&lock->raw_lock);
 }


