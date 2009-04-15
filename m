Return-Path: <linux-kernel-owner+w=401wt.eu-S933285AbZD3Pwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933285AbZD3Pwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 11:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932429AbZD3Pmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 11:42:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55108 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932406AbZD3PmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 11:42:07 -0400
Message-Id: <0c5bea511c95d30d3b18605ff764b7960af8991e.1241105648.git.arnd@arndb.de>
In-Reply-To: <cover.1241105648.git.arnd@arndb.de>
References: <cover.1241105648.git.arnd@arndb.de>
From: Remis Lima Baima <remis.developer@googlemail.com>
Date: Wed, 15 Apr 2009 15:00:08 +0200
Subject: [PATCH 23/27] microblaze: convert all simple headers to use asm-generic
Cc: linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
X-Provags-ID: V01U2FsdGVkX19O7tM3ojeYKadF94i8eOdaq4fxl6rx3zXaHFo
 z7Klbu4GyX/UXXQUsrWeqKjKYW2DS+kCFc8Q/PTnPz3Ni4lkRm
 ne8g+JRMdRXWTt+DkJvoA==
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the simple microblaze header files were adapted to use their
asm-generic implementations. These files are more simple and were quite
straightforward to change.

Signed-off-by: Remis Lima Baima <remis.developer@googlemail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/microblaze/include/asm/atomic.h      |  124 +---------------------------
 arch/microblaze/include/asm/bitops.h      |   28 +------
 arch/microblaze/include/asm/bug.h         |   14 ---
 arch/microblaze/include/asm/bugs.h        |   18 +----
 arch/microblaze/include/asm/checksum.h    |  132 ++++++++---------------------
 arch/microblaze/include/asm/hardirq.h     |   14 +---
 arch/microblaze/include/asm/irq.h         |    6 +-
 arch/microblaze/include/asm/kmap_types.h  |   30 +------
 arch/microblaze/include/asm/mmu.h         |   20 +----
 arch/microblaze/include/asm/mmu_context.h |   22 +-----
 arch/microblaze/include/asm/module.h      |   10 +--
 arch/microblaze/include/asm/pgalloc.h     |   15 +---
 arch/microblaze/include/asm/scatterlist.h |   29 +------
 arch/microblaze/include/asm/serial.h      |   15 +---
 arch/microblaze/include/asm/shmparam.h    |    7 +--
 arch/microblaze/include/asm/system.h      |    3 +
 arch/microblaze/include/asm/timex.h       |   19 +----
 17 files changed, 53 insertions(+), 453 deletions(-)
 rewrite arch/microblaze/include/asm/atomic.h (100%)
 rewrite arch/microblaze/include/asm/bitops.h (95%)
 rewrite arch/microblaze/include/asm/checksum.h (68%)
 rewrite arch/microblaze/include/asm/kmap_types.h (100%)
 rewrite arch/microblaze/include/asm/mmu.h (100%)
 rewrite arch/microblaze/include/asm/mmu_context.h (100%)
 rewrite arch/microblaze/include/asm/scatterlist.h (100%)
 rewrite arch/microblaze/include/asm/timex.h (100%)

diff --git a/arch/microblaze/include/asm/atomic.h b/arch/microblaze/include/asm/atomic.h
dissimilarity index 100%
index 0de612a..f0cc1f8 100644
--- a/arch/microblaze/include/asm/atomic.h
+++ b/arch/microblaze/include/asm/atomic.h
@@ -1,123 +1 @@
-/*
- * Copyright (C) 2006 Atmark Techno, Inc.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License. See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#ifndef _ASM_MICROBLAZE_ATOMIC_H
-#define _ASM_MICROBLAZE_ATOMIC_H
-
-#include <linux/types.h>
-#include <linux/compiler.h> /* likely */
-#include <asm/system.h> /* local_irq_XXX and friends */
-
-#define ATOMIC_INIT(i)		{ (i) }
-#define atomic_read(v)		((v)->counter)
-#define atomic_set(v, i)	(((v)->counter) = (i))
-
-#define atomic_inc(v)		(atomic_add_return(1, (v)))
-#define atomic_dec(v)		(atomic_sub_return(1, (v)))
-
-#define atomic_add(i, v)	(atomic_add_return(i, (v)))
-#define atomic_sub(i, v)	(atomic_sub_return(i, (v)))
-
-#define atomic_inc_return(v)	(atomic_add_return(1, (v)))
-#define atomic_dec_return(v)	(atomic_sub_return(1, (v)))
-
-#define atomic_inc_and_test(v)	(atomic_add_return(1, (v)) == 0)
-#define atomic_dec_and_test(v)	(atomic_sub_return(1, (v)) == 0)
-
-#define atomic_inc_not_zero(v)	(atomic_add_unless((v), 1, 0))
-
-#define atomic_sub_and_test(i, v) (atomic_sub_return((i), (v)) == 0)
-
-static inline int atomic_cmpxchg(atomic_t *v, int old, int new)
-{
-	int ret;
-	unsigned long flags;
-
-	local_irq_save(flags);
-	ret = v->counter;
-	if (likely(ret == old))
-		v->counter = new;
-	local_irq_restore(flags);
-
-	return ret;
-}
-
-static inline int atomic_add_unless(atomic_t *v, int a, int u)
-{
-	int c, old;
-
-	c = atomic_read(v);
-	while (c != u && (old = atomic_cmpxchg((v), c, c + a)) != c)
-		c = old;
-	return c != u;
-}
-
-static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	*addr &= ~mask;
-	local_irq_restore(flags);
-}
-
-/**
- * atomic_add_return - add and return
- * @i: integer value to add
- * @v: pointer of type atomic_t
- *
- * Atomically adds @i to @v and returns @i + @v
- */
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	unsigned long flags;
-	int val;
-
-	local_irq_save(flags);
-	val = v->counter;
-	v->counter = val += i;
-	local_irq_restore(flags);
-
-	return val;
-}
-
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	return atomic_add_return(-i, v);
-}
-
-/*
- * Atomically test *v and decrement if it is greater than 0.
- * The function returns the old value of *v minus 1.
- */
-static inline int atomic_dec_if_positive(atomic_t *v)
-{
-	unsigned long flags;
-	int res;
-
-	local_irq_save(flags);
-	res = v->counter - 1;
-	if (res >= 0)
-		v->counter = res;
-	local_irq_restore(flags);
-
-	return res;
-}
-
-#define atomic_add_negative(a, v)	(atomic_add_return((a), (v)) < 0)
-#define atomic_xchg(v, new) (xchg(&((v)->counter), new))
-
-/* Atomic operations are already serializing */
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
-
-#include <asm-generic/atomic-long.h>
-
-#endif /* _ASM_MICROBLAZE_ATOMIC_H */
+#include <asm-generic/atomic.h>
diff --git a/arch/microblaze/include/asm/bitops.h b/arch/microblaze/include/asm/bitops.h
dissimilarity index 95%
index d6df1fd..a72468f 100644
--- a/arch/microblaze/include/asm/bitops.h
+++ b/arch/microblaze/include/asm/bitops.h
@@ -1,27 +1 @@
-/*
- * Copyright (C) 2006 Atmark Techno, Inc.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License. See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#ifndef _ASM_MICROBLAZE_BITOPS_H
-#define _ASM_MICROBLAZE_BITOPS_H
-
-/*
- * Copyright 1992, Linus Torvalds.
- */
-
-#include <asm/byteorder.h> /* swab32 */
-#include <asm/system.h> /* save_flags */
-
-/*
- * clear_bit() doesn't provide any barrier for the compiler.
- */
-#define smp_mb__before_clear_bit()	barrier()
-#define smp_mb__after_clear_bit()	barrier()
-#include <asm-generic/bitops.h>
-#include <asm-generic/bitops/__fls.h>
-
-#endif /* _ASM_MICROBLAZE_BITOPS_H */
+#include <asm-generic/bitops.h>
diff --git a/arch/microblaze/include/asm/bug.h b/arch/microblaze/include/asm/bug.h
index 8eb2cdd..b12fd89 100644
--- a/arch/microblaze/include/asm/bug.h
+++ b/arch/microblaze/include/asm/bug.h
@@ -1,15 +1 @@
-/*
- * Copyright (C) 2006 Atmark Techno, Inc.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License. See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#ifndef _ASM_MICROBLAZE_BUG_H
-#define _ASM_MICROBLAZE_BUG_H
-
-#include <linux/kernel.h>
 #include <asm-generic/bug.h>
-
-#endif /* _ASM_MICROBLAZE_BUG_H */
diff --git a/arch/microblaze/include/asm/bugs.h b/arch/microblaze/include/asm/bugs.h
index f2c6593..61791e1 100644
--- a/arch/microblaze/include/asm/bugs.h
+++ b/arch/microblaze/include/asm/bugs.h
@@ -1,17 +1 @@
-/*
- * Copyright (C) 2006 Atmark Techno, Inc.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License. See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#ifndef _ASM_MICROBLAZE_BUGS_H
-#define _ASM_MICROBLAZE_BUGS_H
-
-static inline void check_bugs(void)
-{
-	/* nothing to do */
-}
-
-#endif /* _ASM_MICROBLAZE_BUGS_H */
+#include <asm-generic/bugs.h>
diff --git a/arch/microblaze/include/asm/checksum.h b/arch/microblaze/include/asm/checksum.h
dissimilarity index 68%
index 92b3076..f0e5225 100644
--- a/arch/microblaze/include/asm/checksum.h
+++ b/arch/microblaze/include/asm/checksum.h
@@ -1,98 +1,34 @@
-/*
- * Copyright (C) 2008 Michal Simek <monstr@monstr.eu>
- * Copyright (C) 2006 Atmark Techno, Inc.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License. See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#ifndef _ASM_MICROBLAZE_CHECKSUM_H
-#define _ASM_MICROBLAZE_CHECKSUM_H
-
-#include <linux/in6.h>
-
-/*
- * computes the checksum of the TCP/UDP pseudo-header
- * returns a 16-bit checksum, already complemented
- */
-static inline __wsum
-csum_tcpudp_nofold(__be32 saddr, __be32 daddr, unsigned short len,
-		   unsigned short proto, __wsum sum)
-{
-	__asm__("add %0, %0, %1\n\t"
-		"addc %0, %0, %2\n\t"
-		"addc %0, %0, %3\n\t"
-		"addc %0, %0, r0\n\t"
-		: "+&d" (sum)
-		: "d" (saddr), "d" (daddr), "d" (len + proto));
-
-	return sum;
-}
-
-/*
- * computes the checksum of a memory block at buff, length len,
- * and adds in "sum" (32-bit)
- *
- * returns a 32-bit number suitable for feeding into itself
- * or csum_tcpudp_magic
- *
- * this function must be called with even lengths, except
- * for the last fragment, which may be odd
- *
- * it's best to have buff aligned on a 32-bit boundary
- */
-extern __wsum csum_partial(const void *buff, int len, __wsum sum);
-
-/*
- * the same as csum_partial, but copies from src while it
- * checksums
- *
- * here even more important to align src and dst on a 32-bit (or even
- * better 64-bit) boundary
- */
-extern __wsum csum_partial_copy(const char *src, char *dst, int len, int sum);
-
-/*
- * the same as csum_partial_copy, but copies from user space.
- *
- * here even more important to align src and dst on a 32-bit (or even
- * better 64-bit) boundary
- */
-extern __wsum csum_partial_copy_from_user(const char *src, char *dst,
-					int len, int sum, int *csum_err);
-
-#define csum_partial_copy_nocheck(src, dst, len, sum)	\
-	csum_partial_copy((src), (dst), (len), (sum))
-
-/*
- *	This is a version of ip_compute_csum() optimized for IP headers,
- *	which always checksum on 4 octet boundaries.
- *
- */
-extern __sum16 ip_fast_csum(const void *iph, unsigned int ihl);
-
-/*
- *	Fold a partial checksum
- */
-static inline __sum16 csum_fold(unsigned int sum)
-{
-	sum = (sum & 0xffff) + (sum >> 16);
-	sum = (sum & 0xffff) + (sum >> 16);
-	return ~sum;
-}
-
-static inline __sum16
-csum_tcpudp_magic(__be32 saddr, __be32 daddr, unsigned short len,
-		  unsigned short proto, __wsum sum)
-{
-	return csum_fold(csum_tcpudp_nofold(saddr, daddr, len, proto, sum));
-}
-
-/*
- * this routine is used for miscellaneous IP-like checksums, mainly
- * in icmp.c
- */
-extern __sum16 ip_compute_csum(const unsigned char *buff, int len);
-
-#endif /* _ASM_MICROBLAZE_CHECKSUM_H */
+/*
+ * Copyright (C) 2008 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_CHECKSUM_H
+#define _ASM_MICROBLAZE_CHECKSUM_H
+
+/*
+ * computes the checksum of the TCP/UDP pseudo-header
+ * returns a 16-bit checksum, already complemented
+ */
+#define csum_tcpudp_nofold 	csum_tcpudp_nofold
+static inline __wsum
+csum_tcpudp_nofold(__be32 saddr, __be32 daddr, unsigned short len,
+		   unsigned short proto, __wsum sum)
+{
+	__asm__("add %0, %0, %1\n\t"
+		"addc %0, %0, %2\n\t"
+		"addc %0, %0, %3\n\t"
+		"addc %0, %0, r0\n\t"
+		: "+&d" (sum)
+		: "d" (saddr), "d" (daddr), "d" (len + proto));
+
+	return sum;
+}
+
+#include <asm-generic/checksum.h>
+
+#endif /* _ASM_MICROBLAZE_CHECKSUM_H */
diff --git a/arch/microblaze/include/asm/hardirq.h b/arch/microblaze/include/asm/hardirq.h
index 0f2d6b0..41e1e1a 100644
--- a/arch/microblaze/include/asm/hardirq.h
+++ b/arch/microblaze/include/asm/hardirq.h
@@ -9,21 +9,11 @@
 #ifndef _ASM_MICROBLAZE_HARDIRQ_H
 #define _ASM_MICROBLAZE_HARDIRQ_H
 
-#include <linux/cache.h>
-#include <linux/irq.h>
-#include <asm/irq.h>
-#include <asm/current.h>
-#include <linux/ptrace.h>
-
 /* should be defined in each interrupt controller driver */
 extern unsigned int get_irq(struct pt_regs *regs);
 
-typedef struct {
-	unsigned int __softirq_pending;
-} ____cacheline_aligned irq_cpustat_t;
-
+#define ack_bad_irq ack_bad_irq
 void ack_bad_irq(unsigned int irq);
-
-#include <linux/irq_cpustat.h> /* Standard mappings for irq_cpustat_t above */
+#include <asm-generic/hardirq.h>
 
 #endif /* _ASM_MICROBLAZE_HARDIRQ_H */
diff --git a/arch/microblaze/include/asm/irq.h b/arch/microblaze/include/asm/irq.h
index db515de..90f0505 100644
--- a/arch/microblaze/include/asm/irq.h
+++ b/arch/microblaze/include/asm/irq.h
@@ -10,6 +10,7 @@
 #define _ASM_MICROBLAZE_IRQ_H
 
 #define NR_IRQS 32
+#include <asm-generic/irq.h>
 
 #include <linux/interrupt.h>
 
@@ -17,11 +18,6 @@ extern unsigned int nr_irq;
 
 #define NO_IRQ (-1)
 
-static inline int irq_canonicalize(int irq)
-{
-	return irq;
-}
-
 struct pt_regs;
 extern void do_IRQ(struct pt_regs *regs);
 
diff --git a/arch/microblaze/include/asm/kmap_types.h b/arch/microblaze/include/asm/kmap_types.h
dissimilarity index 100%
index 4d7e222..3575c64 100644
--- a/arch/microblaze/include/asm/kmap_types.h
+++ b/arch/microblaze/include/asm/kmap_types.h
@@ -1,29 +1 @@
-/*
- * Copyright (C) 2006 Atmark Techno, Inc.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License. See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#ifndef _ASM_MICROBLAZE_KMAP_TYPES_H
-#define _ASM_MICROBLAZE_KMAP_TYPES_H
-
-enum km_type {
-	KM_BOUNCE_READ,
-	KM_SKB_SUNRPC_DATA,
-	KM_SKB_DATA_SOFTIRQ,
-	KM_USER0,
-	KM_USER1,
-	KM_BIO_SRC_IRQ,
-	KM_BIO_DST_IRQ,
-	KM_PTE0,
-	KM_PTE1,
-	KM_IRQ0,
-	KM_IRQ1,
-	KM_SOFTIRQ0,
-	KM_SOFTIRQ1,
-	KM_TYPE_NR,
-};
-
-#endif /* _ASM_MICROBLAZE_KMAP_TYPES_H */
+#include <asm-generic/kmap_types.h>
diff --git a/arch/microblaze/include/asm/mmu.h b/arch/microblaze/include/asm/mmu.h
dissimilarity index 100%
index 0e0431d..2caa6ed 100644
--- a/arch/microblaze/include/asm/mmu.h
+++ b/arch/microblaze/include/asm/mmu.h
@@ -1,19 +1 @@
-/*
- * Copyright (C) 2006 Atmark Techno, Inc.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License. See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#ifndef _ASM_MICROBLAZE_MMU_H
-#define _ASM_MICROBLAZE_MMU_H
-
-#ifndef __ASSEMBLY__
-typedef struct {
-	struct vm_list_struct	*vmlist;
-	unsigned long		end_brk;
-} mm_context_t;
-#endif /* __ASSEMBLY__ */
-
-#endif /* _ASM_MICROBLAZE_MMU_H */
+#include <asm-generic/mmu.h>
diff --git a/arch/microblaze/include/asm/mmu_context.h b/arch/microblaze/include/asm/mmu_context.h
dissimilarity index 100%
index 150ca01..7739fe1 100644
--- a/arch/microblaze/include/asm/mmu_context.h
+++ b/arch/microblaze/include/asm/mmu_context.h
@@ -1,21 +1 @@
-/*
- * Copyright (C) 2006 Atmark Techno, Inc.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License. See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#ifndef _ASM_MICROBLAZE_MMU_CONTEXT_H
-#define _ASM_MICROBLAZE_MMU_CONTEXT_H
-
-# define init_new_context(tsk, mm)		({ 0; })
-
-# define enter_lazy_tlb(mm, tsk)		do {} while (0)
-# define change_mm_context(old, ctx, _pml4)	do {} while (0)
-# define destroy_context(mm)			do {} while (0)
-# define deactivate_mm(tsk, mm)			do {} while (0)
-# define switch_mm(prev, next, tsk)		do {} while (0)
-# define activate_mm(prev, next)		do {} while (0)
-
-#endif /* _ASM_MICROBLAZE_MMU_CONTEXT_H */
+#include <asm-generic/mmu_context.h>
diff --git a/arch/microblaze/include/asm/module.h b/arch/microblaze/include/asm/module.h
index 914565a..7be1347 100644
--- a/arch/microblaze/include/asm/module.h
+++ b/arch/microblaze/include/asm/module.h
@@ -9,6 +9,8 @@
 #ifndef _ASM_MICROBLAZE_MODULE_H
 #define _ASM_MICROBLAZE_MODULE_H
 
+#include <asm-generic/module.h>
+
 /* Microblaze Relocations */
 #define R_MICROBLAZE_NONE 0
 #define R_MICROBLAZE_32 1
@@ -24,14 +26,6 @@
 /* Keep this the last entry. */
 #define R_MICROBLAZE_NUM 11
 
-struct mod_arch_specific {
-	int foo;
-};
-
-#define Elf_Shdr	Elf32_Shdr
-#define Elf_Sym		Elf32_Sym
-#define Elf_Ehdr	Elf32_Ehdr
-
 typedef struct { volatile int counter; } module_t;
 
 #endif /* _ASM_MICROBLAZE_MODULE_H */
diff --git a/arch/microblaze/include/asm/pgalloc.h b/arch/microblaze/include/asm/pgalloc.h
index 2a4b354..f261cb7 100644
--- a/arch/microblaze/include/asm/pgalloc.h
+++ b/arch/microblaze/include/asm/pgalloc.h
@@ -1,14 +1 @@
-/*
- * Copyright (C) 2006 Atmark Techno, Inc.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License. See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#ifndef _ASM_MICROBLAZE_PGALLOC_H
-#define _ASM_MICROBLAZE_PGALLOC_H
-
-#define check_pgt_cache()	do {} while (0)
-
-#endif /* _ASM_MICROBLAZE_PGALLOC_H */
+#include <asm-generic/pgalloc.h>
diff --git a/arch/microblaze/include/asm/scatterlist.h b/arch/microblaze/include/asm/scatterlist.h
dissimilarity index 100%
index 08ff1d0..35d786f 100644
--- a/arch/microblaze/include/asm/scatterlist.h
+++ b/arch/microblaze/include/asm/scatterlist.h
@@ -1,28 +1 @@
-/*
- * Copyright (C) 2008 Michal Simek <monstr@monstr.eu>
- * Copyright (C) 2006 Atmark Techno, Inc.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License. See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#ifndef _ASM_MICROBLAZE_SCATTERLIST_H
-#define _ASM_MICROBLAZE_SCATTERLIST_H
-
-struct scatterlist {
-#ifdef CONFIG_DEBUG_SG
-	unsigned long	sg_magic;
-#endif
-	unsigned long	page_link;
-	dma_addr_t	dma_address;
-	unsigned int	offset;
-	unsigned int	length;
-};
-
-#define sg_dma_address(sg)      ((sg)->dma_address)
-#define sg_dma_len(sg)          ((sg)->length)
-
-#define ISA_DMA_THRESHOLD (~0UL)
-
-#endif /* _ASM_MICROBLAZE_SCATTERLIST_H */
+#include <asm-generic/scatterlist.h>
diff --git a/arch/microblaze/include/asm/serial.h b/arch/microblaze/include/asm/serial.h
index 39bfc8c..a0cb0ca 100644
--- a/arch/microblaze/include/asm/serial.h
+++ b/arch/microblaze/include/asm/serial.h
@@ -1,14 +1 @@
-/*
- * Copyright (C) 2009 Michal Simek <monstr@monstr.eu>
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License. See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#ifndef _ASM_MICROBLAZE_SERIAL_H
-#define _ASM_MICROBLAZE_SERIAL_H
-
-# define BASE_BAUD (1843200 / 16)
-
-#endif /* _ASM_MICROBLAZE_SERIAL_H */
+#include <asm-generic/serial.h>
diff --git a/arch/microblaze/include/asm/shmparam.h b/arch/microblaze/include/asm/shmparam.h
index 9f5fc2b..93f30de 100644
--- a/arch/microblaze/include/asm/shmparam.h
+++ b/arch/microblaze/include/asm/shmparam.h
@@ -1,6 +1 @@
-#ifndef _ASM_MICROBLAZE_SHMPARAM_H
-#define _ASM_MICROBLAZE_SHMPARAM_H
-
-#define SHMLBA	PAGE_SIZE /* attach addr a multiple of this */
-
-#endif /* _ASM_MICROBLAZE_SHMPARAM_H */
+#include <asm-generic/shmparam.h>
diff --git a/arch/microblaze/include/asm/system.h b/arch/microblaze/include/asm/system.h
index c4e3088..b1ed615 100644
--- a/arch/microblaze/include/asm/system.h
+++ b/arch/microblaze/include/asm/system.h
@@ -13,6 +13,9 @@
 #include <asm/setup.h>
 #include <asm/irqflags.h>
 
+#include <asm-generic/cmpxchg.h>
+#include <asm-generic/cmpxchg-local.h>
+
 struct task_struct;
 struct thread_info;
 
diff --git a/arch/microblaze/include/asm/timex.h b/arch/microblaze/include/asm/timex.h
dissimilarity index 100%
index 678525d..8cdefa7 100644
--- a/arch/microblaze/include/asm/timex.h
+++ b/arch/microblaze/include/asm/timex.h
@@ -1,18 +1 @@
-/*
- * Copyright (C) 2006 Atmark Techno, Inc.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License. See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#ifndef _ASM_MICROBLAZE_TIMEX_H
-#define _ASM_MICROBLAZE_TIMEX_H
-
-#define CLOCK_TICK_RATE 1000 /* Timer input freq. */
-
-typedef unsigned long cycles_t;
-
-#define get_cycles()	(0)
-
-#endif /* _ASM_TIMEX_H */
+#include <asm-generic/timex.h>
-- 
1.5.6.3


