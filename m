Return-Path: <linux-kernel-owner+w=401wt.eu-S934144AbZLFSDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934144AbZLFSDN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 13:03:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934133AbZLFSDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 13:03:10 -0500
Received: from www.tglx.de ([62.245.132.106]:33113 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934077AbZLFSCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 13:02:49 -0500
Message-Id: <20091206111957.572654912@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 06 Dec 2009 18:02:24 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux-Arch <linux-arch@vger.kernel.org>
Subject: [patch 07/23] locking: Convert raw_rwlock to arch_rwlock
References: <20091206110944.492100233@linutronix.de>
Content-Disposition: inline; filename=locking-convert-rwlock-arch.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not strictly necessary for -rt as -rt does not have non sleeping
rwlocks, but it's odd to not have a consistent naming convention.

No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/alpha/include/asm/spinlock.h          |   16 ++++++++--------
 arch/alpha/include/asm/spinlock_types.h    |    4 ++--
 arch/arm/include/asm/spinlock.h            |   12 ++++++------
 arch/arm/include/asm/spinlock_types.h      |    4 ++--
 arch/blackfin/include/asm/spinlock.h       |   16 ++++++++--------
 arch/blackfin/include/asm/spinlock_types.h |    4 ++--
 arch/cris/include/arch-v32/arch/spinlock.h |   16 ++++++++--------
 arch/ia64/include/asm/spinlock.h           |   16 ++++++++--------
 arch/ia64/include/asm/spinlock_types.h     |    4 ++--
 arch/m32r/include/asm/spinlock.h           |   12 ++++++------
 arch/m32r/include/asm/spinlock_types.h     |    4 ++--
 arch/mips/include/asm/spinlock.h           |   12 ++++++------
 arch/mips/include/asm/spinlock_types.h     |    4 ++--
 arch/parisc/include/asm/spinlock.h         |   16 ++++++++--------
 arch/parisc/include/asm/spinlock_types.h   |    4 ++--
 arch/powerpc/include/asm/spinlock.h        |   18 +++++++++---------
 arch/powerpc/include/asm/spinlock_types.h  |    4 ++--
 arch/powerpc/lib/locks.c                   |    2 +-
 arch/s390/include/asm/spinlock.h           |   28 ++++++++++++++--------------
 arch/s390/include/asm/spinlock_types.h     |    4 ++--
 arch/s390/lib/spinlock.c                   |   12 ++++++------
 arch/sh/include/asm/spinlock.h             |   12 ++++++------
 arch/sh/include/asm/spinlock_types.h       |    4 ++--
 arch/sparc/include/asm/spinlock_32.h       |   20 ++++++++++----------
 arch/sparc/include/asm/spinlock_64.h       |   12 ++++++------
 arch/sparc/include/asm/spinlock_types.h    |    4 ++--
 arch/x86/include/asm/spinlock.h            |   16 ++++++++--------
 arch/x86/include/asm/spinlock_types.h      |    4 ++--
 include/linux/rwlock.h                     |    2 +-
 include/linux/rwlock_types.h               |    6 +++---
 include/linux/spinlock.h                   |    4 ++--
 include/linux/spinlock_types_up.h          |    4 ++--
 lib/spinlock_debug.c                       |    2 +-
 33 files changed, 151 insertions(+), 151 deletions(-)

Index: linux-2.6-tip/arch/alpha/include/asm/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/alpha/include/asm/spinlock.h
+++ linux-2.6-tip/arch/alpha/include/asm/spinlock.h
@@ -50,17 +50,17 @@ static inline int arch_spin_trylock(arch
 
 /***********************************************************/
 
-static inline int __raw_read_can_lock(raw_rwlock_t *lock)
+static inline int __raw_read_can_lock(arch_rwlock_t *lock)
 {
 	return (lock->lock & 1) == 0;
 }
 
-static inline int __raw_write_can_lock(raw_rwlock_t *lock)
+static inline int __raw_write_can_lock(arch_rwlock_t *lock)
 {
 	return lock->lock == 0;
 }
 
-static inline void __raw_read_lock(raw_rwlock_t *lock)
+static inline void __raw_read_lock(arch_rwlock_t *lock)
 {
 	long regx;
 
@@ -80,7 +80,7 @@ static inline void __raw_read_lock(raw_r
 	: "m" (*lock) : "memory");
 }
 
-static inline void __raw_write_lock(raw_rwlock_t *lock)
+static inline void __raw_write_lock(arch_rwlock_t *lock)
 {
 	long regx;
 
@@ -100,7 +100,7 @@ static inline void __raw_write_lock(raw_
 	: "m" (*lock) : "memory");
 }
 
-static inline int __raw_read_trylock(raw_rwlock_t * lock)
+static inline int __raw_read_trylock(arch_rwlock_t * lock)
 {
 	long regx;
 	int success;
@@ -122,7 +122,7 @@ static inline int __raw_read_trylock(raw
 	return success;
 }
 
-static inline int __raw_write_trylock(raw_rwlock_t * lock)
+static inline int __raw_write_trylock(arch_rwlock_t * lock)
 {
 	long regx;
 	int success;
@@ -144,7 +144,7 @@ static inline int __raw_write_trylock(ra
 	return success;
 }
 
-static inline void __raw_read_unlock(raw_rwlock_t * lock)
+static inline void __raw_read_unlock(arch_rwlock_t * lock)
 {
 	long regx;
 	__asm__ __volatile__(
@@ -160,7 +160,7 @@ static inline void __raw_read_unlock(raw
 	: "m" (*lock) : "memory");
 }
 
-static inline void __raw_write_unlock(raw_rwlock_t * lock)
+static inline void __raw_write_unlock(arch_rwlock_t * lock)
 {
 	mb();
 	lock->lock = 0;
Index: linux-2.6-tip/arch/alpha/include/asm/spinlock_types.h
===================================================================
--- linux-2.6-tip.orig/arch/alpha/include/asm/spinlock_types.h
+++ linux-2.6-tip/arch/alpha/include/asm/spinlock_types.h
@@ -13,8 +13,8 @@ typedef struct {
 
 typedef struct {
 	volatile unsigned int lock;
-} raw_rwlock_t;
+} arch_rwlock_t;
 
-#define __RAW_RW_LOCK_UNLOCKED		{ 0 }
+#define __ARCH_RW_LOCK_UNLOCKED		{ 0 }
 
 #endif
Index: linux-2.6-tip/arch/arm/include/asm/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/arm/include/asm/spinlock.h
+++ linux-2.6-tip/arch/arm/include/asm/spinlock.h
@@ -86,7 +86,7 @@ static inline void arch_spin_unlock(arch
  * just write zero since the lock is exclusively held.
  */
 
-static inline void __raw_write_lock(raw_rwlock_t *rw)
+static inline void __raw_write_lock(arch_rwlock_t *rw)
 {
 	unsigned long tmp;
 
@@ -106,7 +106,7 @@ static inline void __raw_write_lock(raw_
 	smp_mb();
 }
 
-static inline int __raw_write_trylock(raw_rwlock_t *rw)
+static inline int __raw_write_trylock(arch_rwlock_t *rw)
 {
 	unsigned long tmp;
 
@@ -126,7 +126,7 @@ static inline int __raw_write_trylock(ra
 	}
 }
 
-static inline void __raw_write_unlock(raw_rwlock_t *rw)
+static inline void __raw_write_unlock(arch_rwlock_t *rw)
 {
 	smp_mb();
 
@@ -156,7 +156,7 @@ static inline void __raw_write_unlock(ra
  * currently active.  However, we know we won't have any write
  * locks.
  */
-static inline void __raw_read_lock(raw_rwlock_t *rw)
+static inline void __raw_read_lock(arch_rwlock_t *rw)
 {
 	unsigned long tmp, tmp2;
 
@@ -176,7 +176,7 @@ static inline void __raw_read_lock(raw_r
 	smp_mb();
 }
 
-static inline void __raw_read_unlock(raw_rwlock_t *rw)
+static inline void __raw_read_unlock(arch_rwlock_t *rw)
 {
 	unsigned long tmp, tmp2;
 
@@ -198,7 +198,7 @@ static inline void __raw_read_unlock(raw
 	: "cc");
 }
 
-static inline int __raw_read_trylock(raw_rwlock_t *rw)
+static inline int __raw_read_trylock(arch_rwlock_t *rw)
 {
 	unsigned long tmp, tmp2 = 1;
 
Index: linux-2.6-tip/arch/arm/include/asm/spinlock_types.h
===================================================================
--- linux-2.6-tip.orig/arch/arm/include/asm/spinlock_types.h
+++ linux-2.6-tip/arch/arm/include/asm/spinlock_types.h
@@ -13,8 +13,8 @@ typedef struct {
 
 typedef struct {
 	volatile unsigned int lock;
-} raw_rwlock_t;
+} arch_rwlock_t;
 
-#define __RAW_RW_LOCK_UNLOCKED		{ 0 }
+#define __ARCH_RW_LOCK_UNLOCKED		{ 0 }
 
 #endif
Index: linux-2.6-tip/arch/blackfin/include/asm/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/blackfin/include/asm/spinlock.h
+++ linux-2.6-tip/arch/blackfin/include/asm/spinlock.h
@@ -52,42 +52,42 @@ static inline void arch_spin_unlock_wait
 		cpu_relax();
 }
 
-static inline int __raw_read_can_lock(raw_rwlock_t *rw)
+static inline int __raw_read_can_lock(arch_rwlock_t *rw)
 {
 	return __raw_uncached_fetch_asm(&rw->lock) > 0;
 }
 
-static inline int __raw_write_can_lock(raw_rwlock_t *rw)
+static inline int __raw_write_can_lock(arch_rwlock_t *rw)
 {
 	return __raw_uncached_fetch_asm(&rw->lock) == RW_LOCK_BIAS;
 }
 
-static inline void __raw_read_lock(raw_rwlock_t *rw)
+static inline void __raw_read_lock(arch_rwlock_t *rw)
 {
 	__raw_read_lock_asm(&rw->lock);
 }
 
-static inline int __raw_read_trylock(raw_rwlock_t *rw)
+static inline int __raw_read_trylock(arch_rwlock_t *rw)
 {
 	return __raw_read_trylock_asm(&rw->lock);
 }
 
-static inline void __raw_read_unlock(raw_rwlock_t *rw)
+static inline void __raw_read_unlock(arch_rwlock_t *rw)
 {
 	__raw_read_unlock_asm(&rw->lock);
 }
 
-static inline void __raw_write_lock(raw_rwlock_t *rw)
+static inline void __raw_write_lock(arch_rwlock_t *rw)
 {
 	__raw_write_lock_asm(&rw->lock);
 }
 
-static inline int __raw_write_trylock(raw_rwlock_t *rw)
+static inline int __raw_write_trylock(arch_rwlock_t *rw)
 {
 	return __raw_write_trylock_asm(&rw->lock);
 }
 
-static inline void __raw_write_unlock(raw_rwlock_t *rw)
+static inline void __raw_write_unlock(arch_rwlock_t *rw)
 {
 	__raw_write_unlock_asm(&rw->lock);
 }
Index: linux-2.6-tip/arch/blackfin/include/asm/spinlock_types.h
===================================================================
--- linux-2.6-tip.orig/arch/blackfin/include/asm/spinlock_types.h
+++ linux-2.6-tip/arch/blackfin/include/asm/spinlock_types.h
@@ -21,8 +21,8 @@ typedef struct {
 
 typedef struct {
 	volatile unsigned int lock;
-} raw_rwlock_t;
+} arch_rwlock_t;
 
-#define __RAW_RW_LOCK_UNLOCKED		{ RW_LOCK_BIAS }
+#define __ARCH_RW_LOCK_UNLOCKED		{ RW_LOCK_BIAS }
 
 #endif
Index: linux-2.6-tip/arch/cris/include/arch-v32/arch/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/cris/include/arch-v32/arch/spinlock.h
+++ linux-2.6-tip/arch/cris/include/arch-v32/arch/spinlock.h
@@ -56,17 +56,17 @@ arch_spin_lock_flags(arch_spinlock_t *lo
  *
  */
 
-static inline int __raw_read_can_lock(raw_rwlock_t *x)
+static inline int __raw_read_can_lock(arch_rwlock_t *x)
 {
 	return (int)(x)->lock > 0;
 }
 
-static inline int __raw_write_can_lock(raw_rwlock_t *x)
+static inline int __raw_write_can_lock(arch_rwlock_t *x)
 {
 	return (x)->lock == RW_LOCK_BIAS;
 }
 
-static  inline void __raw_read_lock(raw_rwlock_t *rw)
+static  inline void __raw_read_lock(arch_rwlock_t *rw)
 {
 	arch_spin_lock(&rw->slock);
 	while (rw->lock == 0);
@@ -74,7 +74,7 @@ static  inline void __raw_read_lock(raw_
 	arch_spin_unlock(&rw->slock);
 }
 
-static  inline void __raw_write_lock(raw_rwlock_t *rw)
+static  inline void __raw_write_lock(arch_rwlock_t *rw)
 {
 	arch_spin_lock(&rw->slock);
 	while (rw->lock != RW_LOCK_BIAS);
@@ -82,14 +82,14 @@ static  inline void __raw_write_lock(raw
 	arch_spin_unlock(&rw->slock);
 }
 
-static  inline void __raw_read_unlock(raw_rwlock_t *rw)
+static  inline void __raw_read_unlock(arch_rwlock_t *rw)
 {
 	arch_spin_lock(&rw->slock);
 	rw->lock++;
 	arch_spin_unlock(&rw->slock);
 }
 
-static  inline void __raw_write_unlock(raw_rwlock_t *rw)
+static  inline void __raw_write_unlock(arch_rwlock_t *rw)
 {
 	arch_spin_lock(&rw->slock);
 	while (rw->lock != RW_LOCK_BIAS);
@@ -97,7 +97,7 @@ static  inline void __raw_write_unlock(r
 	arch_spin_unlock(&rw->slock);
 }
 
-static  inline int __raw_read_trylock(raw_rwlock_t *rw)
+static  inline int __raw_read_trylock(arch_rwlock_t *rw)
 {
 	int ret = 0;
 	arch_spin_lock(&rw->slock);
@@ -109,7 +109,7 @@ static  inline int __raw_read_trylock(ra
 	return ret;
 }
 
-static  inline int __raw_write_trylock(raw_rwlock_t *rw)
+static  inline int __raw_write_trylock(arch_rwlock_t *rw)
 {
 	int ret = 0;
 	arch_spin_lock(&rw->slock);
Index: linux-2.6-tip/arch/ia64/include/asm/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/ia64/include/asm/spinlock.h
+++ linux-2.6-tip/arch/ia64/include/asm/spinlock.h
@@ -146,7 +146,7 @@ static inline void arch_spin_unlock_wait
 #ifdef ASM_SUPPORTED
 
 static __always_inline void
-__raw_read_lock_flags(raw_rwlock_t *lock, unsigned long flags)
+__raw_read_lock_flags(arch_rwlock_t *lock, unsigned long flags)
 {
 	__asm__ __volatile__ (
 		"tbit.nz p6, p0 = %1,%2\n"
@@ -177,7 +177,7 @@ __raw_read_lock_flags(raw_rwlock_t *lock
 
 #define __raw_read_lock(rw)								\
 do {											\
-	raw_rwlock_t *__read_lock_ptr = (rw);						\
+	arch_rwlock_t *__read_lock_ptr = (rw);						\
 											\
 	while (unlikely(ia64_fetchadd(1, (int *) __read_lock_ptr, acq) < 0)) {		\
 		ia64_fetchadd(-1, (int *) __read_lock_ptr, rel);			\
@@ -190,14 +190,14 @@ do {											\
 
 #define __raw_read_unlock(rw)					\
 do {								\
-	raw_rwlock_t *__read_lock_ptr = (rw);			\
+	arch_rwlock_t *__read_lock_ptr = (rw);			\
 	ia64_fetchadd(-1, (int *) __read_lock_ptr, rel);	\
 } while (0)
 
 #ifdef ASM_SUPPORTED
 
 static __always_inline void
-__raw_write_lock_flags(raw_rwlock_t *lock, unsigned long flags)
+__raw_write_lock_flags(arch_rwlock_t *lock, unsigned long flags)
 {
 	__asm__ __volatile__ (
 		"tbit.nz p6, p0 = %1, %2\n"
@@ -235,7 +235,7 @@ __raw_write_lock_flags(raw_rwlock_t *loc
 	(result == 0);								\
 })
 
-static inline void __raw_write_unlock(raw_rwlock_t *x)
+static inline void __raw_write_unlock(arch_rwlock_t *x)
 {
 	u8 *y = (u8 *)x;
 	barrier();
@@ -265,7 +265,7 @@ static inline void __raw_write_unlock(ra
 	(ia64_val == 0);						\
 })
 
-static inline void __raw_write_unlock(raw_rwlock_t *x)
+static inline void __raw_write_unlock(arch_rwlock_t *x)
 {
 	barrier();
 	x->write_lock = 0;
@@ -273,10 +273,10 @@ static inline void __raw_write_unlock(ra
 
 #endif /* !ASM_SUPPORTED */
 
-static inline int __raw_read_trylock(raw_rwlock_t *x)
+static inline int __raw_read_trylock(arch_rwlock_t *x)
 {
 	union {
-		raw_rwlock_t lock;
+		arch_rwlock_t lock;
 		__u32 word;
 	} old, new;
 	old.lock = new.lock = *x;
Index: linux-2.6-tip/arch/ia64/include/asm/spinlock_types.h
===================================================================
--- linux-2.6-tip.orig/arch/ia64/include/asm/spinlock_types.h
+++ linux-2.6-tip/arch/ia64/include/asm/spinlock_types.h
@@ -14,8 +14,8 @@ typedef struct {
 typedef struct {
 	volatile unsigned int read_counter	: 31;
 	volatile unsigned int write_lock	:  1;
-} raw_rwlock_t;
+} arch_rwlock_t;
 
-#define __RAW_RW_LOCK_UNLOCKED		{ 0, 0 }
+#define __ARCH_RW_LOCK_UNLOCKED		{ 0, 0 }
 
 #endif
Index: linux-2.6-tip/arch/m32r/include/asm/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/m32r/include/asm/spinlock.h
+++ linux-2.6-tip/arch/m32r/include/asm/spinlock.h
@@ -148,7 +148,7 @@ static inline void arch_spin_unlock(arch
  */
 #define __raw_write_can_lock(x) ((x)->lock == RW_LOCK_BIAS)
 
-static inline void __raw_read_lock(raw_rwlock_t *rw)
+static inline void __raw_read_lock(arch_rwlock_t *rw)
 {
 	unsigned long tmp0, tmp1;
 
@@ -199,7 +199,7 @@ static inline void __raw_read_lock(raw_r
 	);
 }
 
-static inline void __raw_write_lock(raw_rwlock_t *rw)
+static inline void __raw_write_lock(arch_rwlock_t *rw)
 {
 	unsigned long tmp0, tmp1, tmp2;
 
@@ -252,7 +252,7 @@ static inline void __raw_write_lock(raw_
 	);
 }
 
-static inline void __raw_read_unlock(raw_rwlock_t *rw)
+static inline void __raw_read_unlock(arch_rwlock_t *rw)
 {
 	unsigned long tmp0, tmp1;
 
@@ -274,7 +274,7 @@ static inline void __raw_read_unlock(raw
 	);
 }
 
-static inline void __raw_write_unlock(raw_rwlock_t *rw)
+static inline void __raw_write_unlock(arch_rwlock_t *rw)
 {
 	unsigned long tmp0, tmp1, tmp2;
 
@@ -298,7 +298,7 @@ static inline void __raw_write_unlock(ra
 	);
 }
 
-static inline int __raw_read_trylock(raw_rwlock_t *lock)
+static inline int __raw_read_trylock(arch_rwlock_t *lock)
 {
 	atomic_t *count = (atomic_t*)lock;
 	if (atomic_dec_return(count) >= 0)
@@ -307,7 +307,7 @@ static inline int __raw_read_trylock(raw
 	return 0;
 }
 
-static inline int __raw_write_trylock(raw_rwlock_t *lock)
+static inline int __raw_write_trylock(arch_rwlock_t *lock)
 {
 	atomic_t *count = (atomic_t *)lock;
 	if (atomic_sub_and_test(RW_LOCK_BIAS, count))
Index: linux-2.6-tip/arch/m32r/include/asm/spinlock_types.h
===================================================================
--- linux-2.6-tip.orig/arch/m32r/include/asm/spinlock_types.h
+++ linux-2.6-tip/arch/m32r/include/asm/spinlock_types.h
@@ -13,11 +13,11 @@ typedef struct {
 
 typedef struct {
 	volatile int lock;
-} raw_rwlock_t;
+} arch_rwlock_t;
 
 #define RW_LOCK_BIAS			0x01000000
 #define RW_LOCK_BIAS_STR		"0x01000000"
 
-#define __RAW_RW_LOCK_UNLOCKED		{ RW_LOCK_BIAS }
+#define __ARCH_RW_LOCK_UNLOCKED		{ RW_LOCK_BIAS }
 
 #endif /* _ASM_M32R_SPINLOCK_TYPES_H */
Index: linux-2.6-tip/arch/mips/include/asm/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/mips/include/asm/spinlock.h
+++ linux-2.6-tip/arch/mips/include/asm/spinlock.h
@@ -256,7 +256,7 @@ static inline unsigned int arch_spin_try
  */
 #define __raw_write_can_lock(rw)	(!(rw)->lock)
 
-static inline void __raw_read_lock(raw_rwlock_t *rw)
+static inline void __raw_read_lock(arch_rwlock_t *rw)
 {
 	unsigned int tmp;
 
@@ -301,7 +301,7 @@ static inline void __raw_read_lock(raw_r
 /* Note the use of sub, not subu which will make the kernel die with an
    overflow exception if we ever try to unlock an rwlock that is already
    unlocked or is being held by a writer.  */
-static inline void __raw_read_unlock(raw_rwlock_t *rw)
+static inline void __raw_read_unlock(arch_rwlock_t *rw)
 {
 	unsigned int tmp;
 
@@ -335,7 +335,7 @@ static inline void __raw_read_unlock(raw
 	}
 }
 
-static inline void __raw_write_lock(raw_rwlock_t *rw)
+static inline void __raw_write_lock(arch_rwlock_t *rw)
 {
 	unsigned int tmp;
 
@@ -377,7 +377,7 @@ static inline void __raw_write_lock(raw_
 	smp_llsc_mb();
 }
 
-static inline void __raw_write_unlock(raw_rwlock_t *rw)
+static inline void __raw_write_unlock(arch_rwlock_t *rw)
 {
 	smp_mb();
 
@@ -389,7 +389,7 @@ static inline void __raw_write_unlock(ra
 	: "memory");
 }
 
-static inline int __raw_read_trylock(raw_rwlock_t *rw)
+static inline int __raw_read_trylock(arch_rwlock_t *rw)
 {
 	unsigned int tmp;
 	int ret;
@@ -433,7 +433,7 @@ static inline int __raw_read_trylock(raw
 	return ret;
 }
 
-static inline int __raw_write_trylock(raw_rwlock_t *rw)
+static inline int __raw_write_trylock(arch_rwlock_t *rw)
 {
 	unsigned int tmp;
 	int ret;
Index: linux-2.6-tip/arch/mips/include/asm/spinlock_types.h
===================================================================
--- linux-2.6-tip.orig/arch/mips/include/asm/spinlock_types.h
+++ linux-2.6-tip/arch/mips/include/asm/spinlock_types.h
@@ -18,8 +18,8 @@ typedef struct {
 
 typedef struct {
 	volatile unsigned int lock;
-} raw_rwlock_t;
+} arch_rwlock_t;
 
-#define __RAW_RW_LOCK_UNLOCKED		{ 0 }
+#define __ARCH_RW_LOCK_UNLOCKED		{ 0 }
 
 #endif
Index: linux-2.6-tip/arch/parisc/include/asm/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/parisc/include/asm/spinlock.h
+++ linux-2.6-tip/arch/parisc/include/asm/spinlock.h
@@ -69,7 +69,7 @@ static inline int arch_spin_trylock(arch
 
 /* Note that we have to ensure interrupts are disabled in case we're
  * interrupted by some other code that wants to grab the same read lock */
-static  __inline__ void __raw_read_lock(raw_rwlock_t *rw)
+static  __inline__ void __raw_read_lock(arch_rwlock_t *rw)
 {
 	unsigned long flags;
 	local_irq_save(flags);
@@ -81,7 +81,7 @@ static  __inline__ void __raw_read_lock(
 
 /* Note that we have to ensure interrupts are disabled in case we're
  * interrupted by some other code that wants to grab the same read lock */
-static  __inline__ void __raw_read_unlock(raw_rwlock_t *rw)
+static  __inline__ void __raw_read_unlock(arch_rwlock_t *rw)
 {
 	unsigned long flags;
 	local_irq_save(flags);
@@ -93,7 +93,7 @@ static  __inline__ void __raw_read_unloc
 
 /* Note that we have to ensure interrupts are disabled in case we're
  * interrupted by some other code that wants to grab the same read lock */
-static __inline__ int __raw_read_trylock(raw_rwlock_t *rw)
+static __inline__ int __raw_read_trylock(arch_rwlock_t *rw)
 {
 	unsigned long flags;
  retry:
@@ -119,7 +119,7 @@ static __inline__ int __raw_read_trylock
 
 /* Note that we have to ensure interrupts are disabled in case we're
  * interrupted by some other code that wants to read_trylock() this lock */
-static __inline__ void __raw_write_lock(raw_rwlock_t *rw)
+static __inline__ void __raw_write_lock(arch_rwlock_t *rw)
 {
 	unsigned long flags;
 retry:
@@ -141,7 +141,7 @@ retry:
 	local_irq_restore(flags);
 }
 
-static __inline__ void __raw_write_unlock(raw_rwlock_t *rw)
+static __inline__ void __raw_write_unlock(arch_rwlock_t *rw)
 {
 	rw->counter = 0;
 	arch_spin_unlock(&rw->lock);
@@ -149,7 +149,7 @@ static __inline__ void __raw_write_unloc
 
 /* Note that we have to ensure interrupts are disabled in case we're
  * interrupted by some other code that wants to read_trylock() this lock */
-static __inline__ int __raw_write_trylock(raw_rwlock_t *rw)
+static __inline__ int __raw_write_trylock(arch_rwlock_t *rw)
 {
 	unsigned long flags;
 	int result = 0;
@@ -173,7 +173,7 @@ static __inline__ int __raw_write_tryloc
  * read_can_lock - would read_trylock() succeed?
  * @lock: the rwlock in question.
  */
-static __inline__ int __raw_read_can_lock(raw_rwlock_t *rw)
+static __inline__ int __raw_read_can_lock(arch_rwlock_t *rw)
 {
 	return rw->counter >= 0;
 }
@@ -182,7 +182,7 @@ static __inline__ int __raw_read_can_loc
  * write_can_lock - would write_trylock() succeed?
  * @lock: the rwlock in question.
  */
-static __inline__ int __raw_write_can_lock(raw_rwlock_t *rw)
+static __inline__ int __raw_write_can_lock(arch_rwlock_t *rw)
 {
 	return !rw->counter;
 }
Index: linux-2.6-tip/arch/parisc/include/asm/spinlock_types.h
===================================================================
--- linux-2.6-tip.orig/arch/parisc/include/asm/spinlock_types.h
+++ linux-2.6-tip/arch/parisc/include/asm/spinlock_types.h
@@ -14,8 +14,8 @@ typedef struct {
 typedef struct {
 	arch_spinlock_t lock;
 	volatile int counter;
-} raw_rwlock_t;
+} arch_rwlock_t;
 
-#define __RAW_RW_LOCK_UNLOCKED		{ __ARCH_SPIN_LOCK_UNLOCKED, 0 }
+#define __ARCH_RW_LOCK_UNLOCKED		{ __ARCH_SPIN_LOCK_UNLOCKED, 0 }
 
 #endif
Index: linux-2.6-tip/arch/powerpc/include/asm/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/include/asm/spinlock.h
+++ linux-2.6-tip/arch/powerpc/include/asm/spinlock.h
@@ -97,7 +97,7 @@ static inline int arch_spin_trylock(arch
 /* We only yield to the hypervisor if we are in shared processor mode */
 #define SHARED_PROCESSOR (get_lppaca()->shared_proc)
 extern void __spin_yield(arch_spinlock_t *lock);
-extern void __rw_yield(raw_rwlock_t *lock);
+extern void __rw_yield(arch_rwlock_t *lock);
 #else /* SPLPAR || ISERIES */
 #define __spin_yield(x)	barrier()
 #define __rw_yield(x)	barrier()
@@ -181,7 +181,7 @@ extern void arch_spin_unlock_wait(arch_s
  * This returns the old value in the lock + 1,
  * so we got a read lock if the return value is > 0.
  */
-static inline long arch_read_trylock(raw_rwlock_t *rw)
+static inline long arch_read_trylock(arch_rwlock_t *rw)
 {
 	long tmp;
 
@@ -205,7 +205,7 @@ static inline long arch_read_trylock(raw
  * This returns the old value in the lock,
  * so we got the write lock if the return value is 0.
  */
-static inline long arch_write_trylock(raw_rwlock_t *rw)
+static inline long arch_write_trylock(arch_rwlock_t *rw)
 {
 	long tmp, token;
 
@@ -225,7 +225,7 @@ static inline long arch_write_trylock(ra
 	return tmp;
 }
 
-static inline void __raw_read_lock(raw_rwlock_t *rw)
+static inline void __raw_read_lock(arch_rwlock_t *rw)
 {
 	while (1) {
 		if (likely(arch_read_trylock(rw) > 0))
@@ -239,7 +239,7 @@ static inline void __raw_read_lock(raw_r
 	}
 }
 
-static inline void __raw_write_lock(raw_rwlock_t *rw)
+static inline void __raw_write_lock(arch_rwlock_t *rw)
 {
 	while (1) {
 		if (likely(arch_write_trylock(rw) == 0))
@@ -253,17 +253,17 @@ static inline void __raw_write_lock(raw_
 	}
 }
 
-static inline int __raw_read_trylock(raw_rwlock_t *rw)
+static inline int __raw_read_trylock(arch_rwlock_t *rw)
 {
 	return arch_read_trylock(rw) > 0;
 }
 
-static inline int __raw_write_trylock(raw_rwlock_t *rw)
+static inline int __raw_write_trylock(arch_rwlock_t *rw)
 {
 	return arch_write_trylock(rw) == 0;
 }
 
-static inline void __raw_read_unlock(raw_rwlock_t *rw)
+static inline void __raw_read_unlock(arch_rwlock_t *rw)
 {
 	long tmp;
 
@@ -280,7 +280,7 @@ static inline void __raw_read_unlock(raw
 	: "cr0", "xer", "memory");
 }
 
-static inline void __raw_write_unlock(raw_rwlock_t *rw)
+static inline void __raw_write_unlock(arch_rwlock_t *rw)
 {
 	__asm__ __volatile__("# write_unlock\n\t"
 				LWSYNC_ON_SMP: : :"memory");
Index: linux-2.6-tip/arch/powerpc/include/asm/spinlock_types.h
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/include/asm/spinlock_types.h
+++ linux-2.6-tip/arch/powerpc/include/asm/spinlock_types.h
@@ -13,8 +13,8 @@ typedef struct {
 
 typedef struct {
 	volatile signed int lock;
-} raw_rwlock_t;
+} arch_rwlock_t;
 
-#define __RAW_RW_LOCK_UNLOCKED		{ 0 }
+#define __ARCH_RW_LOCK_UNLOCKED		{ 0 }
 
 #endif
Index: linux-2.6-tip/arch/powerpc/lib/locks.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/lib/locks.c
+++ linux-2.6-tip/arch/powerpc/lib/locks.c
@@ -55,7 +55,7 @@ void __spin_yield(arch_spinlock_t *lock)
  * This turns out to be the same for read and write locks, since
  * we only know the holder if it is write-locked.
  */
-void __rw_yield(raw_rwlock_t *rw)
+void __rw_yield(arch_rwlock_t *rw)
 {
 	int lock_value;
 	unsigned int holder_cpu, yield_count;
Index: linux-2.6-tip/arch/s390/include/asm/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/s390/include/asm/spinlock.h
+++ linux-2.6-tip/arch/s390/include/asm/spinlock.h
@@ -121,14 +121,14 @@ static inline void arch_spin_unlock(arch
  */
 #define __raw_write_can_lock(x) ((x)->lock == 0)
 
-extern void _raw_read_lock_wait(raw_rwlock_t *lp);
-extern void _raw_read_lock_wait_flags(raw_rwlock_t *lp, unsigned long flags);
-extern int _raw_read_trylock_retry(raw_rwlock_t *lp);
-extern void _raw_write_lock_wait(raw_rwlock_t *lp);
-extern void _raw_write_lock_wait_flags(raw_rwlock_t *lp, unsigned long flags);
-extern int _raw_write_trylock_retry(raw_rwlock_t *lp);
+extern void _raw_read_lock_wait(arch_rwlock_t *lp);
+extern void _raw_read_lock_wait_flags(arch_rwlock_t *lp, unsigned long flags);
+extern int _raw_read_trylock_retry(arch_rwlock_t *lp);
+extern void _raw_write_lock_wait(arch_rwlock_t *lp);
+extern void _raw_write_lock_wait_flags(arch_rwlock_t *lp, unsigned long flags);
+extern int _raw_write_trylock_retry(arch_rwlock_t *lp);
 
-static inline void __raw_read_lock(raw_rwlock_t *rw)
+static inline void __raw_read_lock(arch_rwlock_t *rw)
 {
 	unsigned int old;
 	old = rw->lock & 0x7fffffffU;
@@ -136,7 +136,7 @@ static inline void __raw_read_lock(raw_r
 		_raw_read_lock_wait(rw);
 }
 
-static inline void __raw_read_lock_flags(raw_rwlock_t *rw, unsigned long flags)
+static inline void __raw_read_lock_flags(arch_rwlock_t *rw, unsigned long flags)
 {
 	unsigned int old;
 	old = rw->lock & 0x7fffffffU;
@@ -144,7 +144,7 @@ static inline void __raw_read_lock_flags
 		_raw_read_lock_wait_flags(rw, flags);
 }
 
-static inline void __raw_read_unlock(raw_rwlock_t *rw)
+static inline void __raw_read_unlock(arch_rwlock_t *rw)
 {
 	unsigned int old, cmp;
 
@@ -155,24 +155,24 @@ static inline void __raw_read_unlock(raw
 	} while (cmp != old);
 }
 
-static inline void __raw_write_lock(raw_rwlock_t *rw)
+static inline void __raw_write_lock(arch_rwlock_t *rw)
 {
 	if (unlikely(_raw_compare_and_swap(&rw->lock, 0, 0x80000000) != 0))
 		_raw_write_lock_wait(rw);
 }
 
-static inline void __raw_write_lock_flags(raw_rwlock_t *rw, unsigned long flags)
+static inline void __raw_write_lock_flags(arch_rwlock_t *rw, unsigned long flags)
 {
 	if (unlikely(_raw_compare_and_swap(&rw->lock, 0, 0x80000000) != 0))
 		_raw_write_lock_wait_flags(rw, flags);
 }
 
-static inline void __raw_write_unlock(raw_rwlock_t *rw)
+static inline void __raw_write_unlock(arch_rwlock_t *rw)
 {
 	_raw_compare_and_swap(&rw->lock, 0x80000000, 0);
 }
 
-static inline int __raw_read_trylock(raw_rwlock_t *rw)
+static inline int __raw_read_trylock(arch_rwlock_t *rw)
 {
 	unsigned int old;
 	old = rw->lock & 0x7fffffffU;
@@ -181,7 +181,7 @@ static inline int __raw_read_trylock(raw
 	return _raw_read_trylock_retry(rw);
 }
 
-static inline int __raw_write_trylock(raw_rwlock_t *rw)
+static inline int __raw_write_trylock(arch_rwlock_t *rw)
 {
 	if (likely(_raw_compare_and_swap(&rw->lock, 0, 0x80000000) == 0))
 		return 1;
Index: linux-2.6-tip/arch/s390/include/asm/spinlock_types.h
===================================================================
--- linux-2.6-tip.orig/arch/s390/include/asm/spinlock_types.h
+++ linux-2.6-tip/arch/s390/include/asm/spinlock_types.h
@@ -13,8 +13,8 @@ typedef struct {
 
 typedef struct {
 	volatile unsigned int lock;
-} raw_rwlock_t;
+} arch_rwlock_t;
 
-#define __RAW_RW_LOCK_UNLOCKED		{ 0 }
+#define __ARCH_RW_LOCK_UNLOCKED		{ 0 }
 
 #endif
Index: linux-2.6-tip/arch/s390/lib/spinlock.c
===================================================================
--- linux-2.6-tip.orig/arch/s390/lib/spinlock.c
+++ linux-2.6-tip/arch/s390/lib/spinlock.c
@@ -105,7 +105,7 @@ void arch_spin_relax(arch_spinlock_t *lo
 }
 EXPORT_SYMBOL(arch_spin_relax);
 
-void _raw_read_lock_wait(raw_rwlock_t *rw)
+void _raw_read_lock_wait(arch_rwlock_t *rw)
 {
 	unsigned int old;
 	int count = spin_retry;
@@ -124,7 +124,7 @@ void _raw_read_lock_wait(raw_rwlock_t *r
 }
 EXPORT_SYMBOL(_raw_read_lock_wait);
 
-void _raw_read_lock_wait_flags(raw_rwlock_t *rw, unsigned long flags)
+void _raw_read_lock_wait_flags(arch_rwlock_t *rw, unsigned long flags)
 {
 	unsigned int old;
 	int count = spin_retry;
@@ -145,7 +145,7 @@ void _raw_read_lock_wait_flags(raw_rwloc
 }
 EXPORT_SYMBOL(_raw_read_lock_wait_flags);
 
-int _raw_read_trylock_retry(raw_rwlock_t *rw)
+int _raw_read_trylock_retry(arch_rwlock_t *rw)
 {
 	unsigned int old;
 	int count = spin_retry;
@@ -161,7 +161,7 @@ int _raw_read_trylock_retry(raw_rwlock_t
 }
 EXPORT_SYMBOL(_raw_read_trylock_retry);
 
-void _raw_write_lock_wait(raw_rwlock_t *rw)
+void _raw_write_lock_wait(arch_rwlock_t *rw)
 {
 	int count = spin_retry;
 
@@ -178,7 +178,7 @@ void _raw_write_lock_wait(raw_rwlock_t *
 }
 EXPORT_SYMBOL(_raw_write_lock_wait);
 
-void _raw_write_lock_wait_flags(raw_rwlock_t *rw, unsigned long flags)
+void _raw_write_lock_wait_flags(arch_rwlock_t *rw, unsigned long flags)
 {
 	int count = spin_retry;
 
@@ -197,7 +197,7 @@ void _raw_write_lock_wait_flags(raw_rwlo
 }
 EXPORT_SYMBOL(_raw_write_lock_wait_flags);
 
-int _raw_write_trylock_retry(raw_rwlock_t *rw)
+int _raw_write_trylock_retry(arch_rwlock_t *rw)
 {
 	int count = spin_retry;
 
Index: linux-2.6-tip/arch/sh/include/asm/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/sh/include/asm/spinlock.h
+++ linux-2.6-tip/arch/sh/include/asm/spinlock.h
@@ -108,7 +108,7 @@ static inline int arch_spin_trylock(arch
  */
 #define __raw_write_can_lock(x)	((x)->lock == RW_LOCK_BIAS)
 
-static inline void __raw_read_lock(raw_rwlock_t *rw)
+static inline void __raw_read_lock(arch_rwlock_t *rw)
 {
 	unsigned long tmp;
 
@@ -126,7 +126,7 @@ static inline void __raw_read_lock(raw_r
 	);
 }
 
-static inline void __raw_read_unlock(raw_rwlock_t *rw)
+static inline void __raw_read_unlock(arch_rwlock_t *rw)
 {
 	unsigned long tmp;
 
@@ -142,7 +142,7 @@ static inline void __raw_read_unlock(raw
 	);
 }
 
-static inline void __raw_write_lock(raw_rwlock_t *rw)
+static inline void __raw_write_lock(arch_rwlock_t *rw)
 {
 	unsigned long tmp;
 
@@ -160,7 +160,7 @@ static inline void __raw_write_lock(raw_
 	);
 }
 
-static inline void __raw_write_unlock(raw_rwlock_t *rw)
+static inline void __raw_write_unlock(arch_rwlock_t *rw)
 {
 	__asm__ __volatile__ (
 		"mov.l		%1, @%0 ! __raw_write_unlock	\n\t"
@@ -170,7 +170,7 @@ static inline void __raw_write_unlock(ra
 	);
 }
 
-static inline int __raw_read_trylock(raw_rwlock_t *rw)
+static inline int __raw_read_trylock(arch_rwlock_t *rw)
 {
 	unsigned long tmp, oldval;
 
@@ -193,7 +193,7 @@ static inline int __raw_read_trylock(raw
 	return (oldval > 0);
 }
 
-static inline int __raw_write_trylock(raw_rwlock_t *rw)
+static inline int __raw_write_trylock(arch_rwlock_t *rw)
 {
 	unsigned long tmp, oldval;
 
Index: linux-2.6-tip/arch/sh/include/asm/spinlock_types.h
===================================================================
--- linux-2.6-tip.orig/arch/sh/include/asm/spinlock_types.h
+++ linux-2.6-tip/arch/sh/include/asm/spinlock_types.h
@@ -13,9 +13,9 @@ typedef struct {
 
 typedef struct {
 	volatile unsigned int lock;
-} raw_rwlock_t;
+} arch_rwlock_t;
 
 #define RW_LOCK_BIAS			0x01000000
-#define __RAW_RW_LOCK_UNLOCKED		{ RW_LOCK_BIAS }
+#define __ARCH_RW_LOCK_UNLOCKED		{ RW_LOCK_BIAS }
 
 #endif
Index: linux-2.6-tip/arch/sparc/include/asm/spinlock_32.h
===================================================================
--- linux-2.6-tip.orig/arch/sparc/include/asm/spinlock_32.h
+++ linux-2.6-tip/arch/sparc/include/asm/spinlock_32.h
@@ -65,7 +65,7 @@ static inline void arch_spin_unlock(arch
  * Sort of like atomic_t's on Sparc, but even more clever.
  *
  *	------------------------------------
- *	| 24-bit counter           | wlock |  raw_rwlock_t
+ *	| 24-bit counter           | wlock |  arch_rwlock_t
  *	------------------------------------
  *	 31                       8 7     0
  *
@@ -76,9 +76,9 @@ static inline void arch_spin_unlock(arch
  *
  * Unfortunately this scheme limits us to ~16,000,000 cpus.
  */
-static inline void arch_read_lock(raw_rwlock_t *rw)
+static inline void arch_read_lock(arch_rwlock_t *rw)
 {
-	register raw_rwlock_t *lp asm("g1");
+	register arch_rwlock_t *lp asm("g1");
 	lp = rw;
 	__asm__ __volatile__(
 	"mov	%%o7, %%g4\n\t"
@@ -96,9 +96,9 @@ do {	unsigned long flags; \
 	local_irq_restore(flags); \
 } while(0)
 
-static inline void arch_read_unlock(raw_rwlock_t *rw)
+static inline void arch_read_unlock(arch_rwlock_t *rw)
 {
-	register raw_rwlock_t *lp asm("g1");
+	register arch_rwlock_t *lp asm("g1");
 	lp = rw;
 	__asm__ __volatile__(
 	"mov	%%o7, %%g4\n\t"
@@ -116,9 +116,9 @@ do {	unsigned long flags; \
 	local_irq_restore(flags); \
 } while(0)
 
-static inline void __raw_write_lock(raw_rwlock_t *rw)
+static inline void __raw_write_lock(arch_rwlock_t *rw)
 {
-	register raw_rwlock_t *lp asm("g1");
+	register arch_rwlock_t *lp asm("g1");
 	lp = rw;
 	__asm__ __volatile__(
 	"mov	%%o7, %%g4\n\t"
@@ -130,7 +130,7 @@ static inline void __raw_write_lock(raw_
 	*(volatile __u32 *)&lp->lock = ~0U;
 }
 
-static inline int __raw_write_trylock(raw_rwlock_t *rw)
+static inline int __raw_write_trylock(arch_rwlock_t *rw)
 {
 	unsigned int val;
 
@@ -150,9 +150,9 @@ static inline int __raw_write_trylock(ra
 	return (val == 0);
 }
 
-static inline int arch_read_trylock(raw_rwlock_t *rw)
+static inline int arch_read_trylock(arch_rwlock_t *rw)
 {
-	register raw_rwlock_t *lp asm("g1");
+	register arch_rwlock_t *lp asm("g1");
 	register int res asm("o0");
 	lp = rw;
 	__asm__ __volatile__(
Index: linux-2.6-tip/arch/sparc/include/asm/spinlock_64.h
===================================================================
--- linux-2.6-tip.orig/arch/sparc/include/asm/spinlock_64.h
+++ linux-2.6-tip/arch/sparc/include/asm/spinlock_64.h
@@ -92,7 +92,7 @@ static inline void arch_spin_lock_flags(
 
 /* Multi-reader locks, these are much saner than the 32-bit Sparc ones... */
 
-static void inline arch_read_lock(raw_rwlock_t *lock)
+static void inline arch_read_lock(arch_rwlock_t *lock)
 {
 	unsigned long tmp1, tmp2;
 
@@ -115,7 +115,7 @@ static void inline arch_read_lock(raw_rw
 	: "memory");
 }
 
-static int inline arch_read_trylock(raw_rwlock_t *lock)
+static int inline arch_read_trylock(arch_rwlock_t *lock)
 {
 	int tmp1, tmp2;
 
@@ -136,7 +136,7 @@ static int inline arch_read_trylock(raw_
 	return tmp1;
 }
 
-static void inline arch_read_unlock(raw_rwlock_t *lock)
+static void inline arch_read_unlock(arch_rwlock_t *lock)
 {
 	unsigned long tmp1, tmp2;
 
@@ -152,7 +152,7 @@ static void inline arch_read_unlock(raw_
 	: "memory");
 }
 
-static void inline arch_write_lock(raw_rwlock_t *lock)
+static void inline arch_write_lock(arch_rwlock_t *lock)
 {
 	unsigned long mask, tmp1, tmp2;
 
@@ -177,7 +177,7 @@ static void inline arch_write_lock(raw_r
 	: "memory");
 }
 
-static void inline arch_write_unlock(raw_rwlock_t *lock)
+static void inline arch_write_unlock(arch_rwlock_t *lock)
 {
 	__asm__ __volatile__(
 "	stw		%%g0, [%0]"
@@ -186,7 +186,7 @@ static void inline arch_write_unlock(raw
 	: "memory");
 }
 
-static int inline arch_write_trylock(raw_rwlock_t *lock)
+static int inline arch_write_trylock(arch_rwlock_t *lock)
 {
 	unsigned long mask, tmp1, tmp2, result;
 
Index: linux-2.6-tip/arch/sparc/include/asm/spinlock_types.h
===================================================================
--- linux-2.6-tip.orig/arch/sparc/include/asm/spinlock_types.h
+++ linux-2.6-tip/arch/sparc/include/asm/spinlock_types.h
@@ -13,8 +13,8 @@ typedef struct {
 
 typedef struct {
 	volatile unsigned int lock;
-} raw_rwlock_t;
+} arch_rwlock_t;
 
-#define __RAW_RW_LOCK_UNLOCKED		{ 0 }
+#define __ARCH_RW_LOCK_UNLOCKED		{ 0 }
 
 #endif
Index: linux-2.6-tip/arch/x86/include/asm/spinlock.h
===================================================================
--- linux-2.6-tip.orig/arch/x86/include/asm/spinlock.h
+++ linux-2.6-tip/arch/x86/include/asm/spinlock.h
@@ -232,7 +232,7 @@ static inline void arch_spin_unlock_wait
  * read_can_lock - would read_trylock() succeed?
  * @lock: the rwlock in question.
  */
-static inline int __raw_read_can_lock(raw_rwlock_t *lock)
+static inline int __raw_read_can_lock(arch_rwlock_t *lock)
 {
 	return (int)(lock)->lock > 0;
 }
@@ -241,12 +241,12 @@ static inline int __raw_read_can_lock(ra
  * write_can_lock - would write_trylock() succeed?
  * @lock: the rwlock in question.
  */
-static inline int __raw_write_can_lock(raw_rwlock_t *lock)
+static inline int __raw_write_can_lock(arch_rwlock_t *lock)
 {
 	return (lock)->lock == RW_LOCK_BIAS;
 }
 
-static inline void __raw_read_lock(raw_rwlock_t *rw)
+static inline void __raw_read_lock(arch_rwlock_t *rw)
 {
 	asm volatile(LOCK_PREFIX " subl $1,(%0)\n\t"
 		     "jns 1f\n"
@@ -255,7 +255,7 @@ static inline void __raw_read_lock(raw_r
 		     ::LOCK_PTR_REG (rw) : "memory");
 }
 
-static inline void __raw_write_lock(raw_rwlock_t *rw)
+static inline void __raw_write_lock(arch_rwlock_t *rw)
 {
 	asm volatile(LOCK_PREFIX " subl %1,(%0)\n\t"
 		     "jz 1f\n"
@@ -264,7 +264,7 @@ static inline void __raw_write_lock(raw_
 		     ::LOCK_PTR_REG (rw), "i" (RW_LOCK_BIAS) : "memory");
 }
 
-static inline int __raw_read_trylock(raw_rwlock_t *lock)
+static inline int __raw_read_trylock(arch_rwlock_t *lock)
 {
 	atomic_t *count = (atomic_t *)lock;
 
@@ -274,7 +274,7 @@ static inline int __raw_read_trylock(raw
 	return 0;
 }
 
-static inline int __raw_write_trylock(raw_rwlock_t *lock)
+static inline int __raw_write_trylock(arch_rwlock_t *lock)
 {
 	atomic_t *count = (atomic_t *)lock;
 
@@ -284,12 +284,12 @@ static inline int __raw_write_trylock(ra
 	return 0;
 }
 
-static inline void __raw_read_unlock(raw_rwlock_t *rw)
+static inline void __raw_read_unlock(arch_rwlock_t *rw)
 {
 	asm volatile(LOCK_PREFIX "incl %0" :"+m" (rw->lock) : : "memory");
 }
 
-static inline void __raw_write_unlock(raw_rwlock_t *rw)
+static inline void __raw_write_unlock(arch_rwlock_t *rw)
 {
 	asm volatile(LOCK_PREFIX "addl %1, %0"
 		     : "+m" (rw->lock) : "i" (RW_LOCK_BIAS) : "memory");
Index: linux-2.6-tip/arch/x86/include/asm/spinlock_types.h
===================================================================
--- linux-2.6-tip.orig/arch/x86/include/asm/spinlock_types.h
+++ linux-2.6-tip/arch/x86/include/asm/spinlock_types.h
@@ -13,8 +13,8 @@ typedef struct arch_spinlock {
 
 typedef struct {
 	unsigned int lock;
-} raw_rwlock_t;
+} arch_rwlock_t;
 
-#define __RAW_RW_LOCK_UNLOCKED		{ RW_LOCK_BIAS }
+#define __ARCH_RW_LOCK_UNLOCKED		{ RW_LOCK_BIAS }
 
 #endif /* _ASM_X86_SPINLOCK_TYPES_H */
Index: linux-2.6-tip/include/linux/rwlock.h
===================================================================
--- linux-2.6-tip.orig/include/linux/rwlock.h
+++ linux-2.6-tip/include/linux/rwlock.h
@@ -14,7 +14,7 @@
  * Released under the General Public License (GPL).
  */
 
-extern int __lockfunc generic__raw_read_trylock(raw_rwlock_t *lock);
+extern int __lockfunc generic__raw_read_trylock(arch_rwlock_t *lock);
 
 #ifdef CONFIG_DEBUG_SPINLOCK
   extern void __rwlock_init(rwlock_t *lock, const char *name,
Index: linux-2.6-tip/include/linux/rwlock_types.h
===================================================================
--- linux-2.6-tip.orig/include/linux/rwlock_types.h
+++ linux-2.6-tip/include/linux/rwlock_types.h
@@ -9,7 +9,7 @@
  * Released under the General Public License (GPL).
  */
 typedef struct {
-	raw_rwlock_t raw_lock;
+	arch_rwlock_t raw_lock;
 #ifdef CONFIG_GENERIC_LOCKBREAK
 	unsigned int break_lock;
 #endif
@@ -32,14 +32,14 @@ typedef struct {
 
 #ifdef CONFIG_DEBUG_SPINLOCK
 #define __RW_LOCK_UNLOCKED(lockname)					\
-	(rwlock_t)	{	.raw_lock = __RAW_RW_LOCK_UNLOCKED,	\
+	(rwlock_t)	{	.raw_lock = __ARCH_RW_LOCK_UNLOCKED,	\
 				.magic = RWLOCK_MAGIC,			\
 				.owner = SPINLOCK_OWNER_INIT,		\
 				.owner_cpu = -1,			\
 				RW_DEP_MAP_INIT(lockname) }
 #else
 #define __RW_LOCK_UNLOCKED(lockname) \
-	(rwlock_t)	{	.raw_lock = __RAW_RW_LOCK_UNLOCKED,	\
+	(rwlock_t)	{	.raw_lock = __ARCH_RW_LOCK_UNLOCKED,	\
 				RW_DEP_MAP_INIT(lockname) }
 #endif
 
Index: linux-2.6-tip/include/linux/spinlock.h
===================================================================
--- linux-2.6-tip.orig/include/linux/spinlock.h
+++ linux-2.6-tip/include/linux/spinlock.h
@@ -8,7 +8,7 @@
  *
  * on SMP builds:
  *
- *  asm/spinlock_types.h: contains the arch_spinlock_t/raw_rwlock_t and the
+ *  asm/spinlock_types.h: contains the arch_spinlock_t/arch_rwlock_t and the
  *                        initializers
  *
  *  linux/spinlock_types.h:
@@ -75,7 +75,7 @@
 #define __lockfunc __attribute__((section(".spinlock.text")))
 
 /*
- * Pull the arch_spinlock_t and raw_rwlock_t definitions:
+ * Pull the arch_spinlock_t and arch_rwlock_t definitions:
  */
 #include <linux/spinlock_types.h>
 
Index: linux-2.6-tip/include/linux/spinlock_types_up.h
===================================================================
--- linux-2.6-tip.orig/include/linux/spinlock_types_up.h
+++ linux-2.6-tip/include/linux/spinlock_types_up.h
@@ -30,8 +30,8 @@ typedef struct { } arch_spinlock_t;
 
 typedef struct {
 	/* no debug version on UP */
-} raw_rwlock_t;
+} arch_rwlock_t;
 
-#define __RAW_RW_LOCK_UNLOCKED { }
+#define __ARCH_RW_LOCK_UNLOCKED { }
 
 #endif /* __LINUX_SPINLOCK_TYPES_UP_H */
Index: linux-2.6-tip/lib/spinlock_debug.c
===================================================================
--- linux-2.6-tip.orig/lib/spinlock_debug.c
+++ linux-2.6-tip/lib/spinlock_debug.c
@@ -41,7 +41,7 @@ void __rwlock_init(rwlock_t *lock, const
 	debug_check_no_locks_freed((void *)lock, sizeof(*lock));
 	lockdep_init_map(&lock->dep_map, name, key, 0);
 #endif
-	lock->raw_lock = (raw_rwlock_t) __RAW_RW_LOCK_UNLOCKED;
+	lock->raw_lock = (arch_rwlock_t) __ARCH_RW_LOCK_UNLOCKED;
 	lock->magic = RWLOCK_MAGIC;
 	lock->owner = SPINLOCK_OWNER_INIT;
 	lock->owner_cpu = -1;


