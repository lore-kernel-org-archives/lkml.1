Return-Path: <linux-kernel-owner+w=401wt.eu-S1758467AbZFRR4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758467AbZFRR4q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 13:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754470AbZFRRz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 13:55:58 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52495 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014AbZFRRzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 13:55:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Simek <monstr@monstr.eu>
Cc: microblaze-uclinux@itee.uq.edu.au, LKML <linux-kernel@vger.kernel.org>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 09/11] microblaze: convert all simple headers to use asm-generic
Date: Thu, 18 Jun 2009 19:55:33 +0200
Message-Id: <7a3b8affe04e005ba148507ed6408203b4014a34.1245347640.git.arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <cover.1245345894.git.arnd@arndb.de>
References: <cover.1245345894.git.arnd@arndb.de>
In-Reply-To: <24d10c58e2739bacec05d641ab2a2c95ce6d69a9.1245347640.git.arnd@arndb.de>
References: <24d10c58e2739bacec05d641ab2a2c95ce6d69a9.1245347640.git.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/BnKXcsYShKHWx7CimSwp29IzecQy+VNsQZMU
 74omZUgXpUrkKn6hnDmK9iW64oamMPgKNFHhDeGeFeq0plmL+K
 /WuKtsosWe+rU78qAd6vQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Remis Lima Baima <remis.developer@googlemail.com>

All the simple microblaze header files were adapted to use their
asm-generic implementations. These files are more simple and were quite
straightforward to change.

fb.h, vga.h and parport.h previously did not exist, using
the generic version makes it possible to build more drivers
successfully in allyesonfig.

Signed-off-by: Remis Lima Baima <remis.developer@googlemail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/microblaze/include/asm/atomic.h         |  147 ++++---------------------
 arch/microblaze/include/asm/bitops.h         |   28 +-----
 arch/microblaze/include/asm/bug.h            |   14 ---
 arch/microblaze/include/asm/bugs.h           |   18 +---
 arch/microblaze/include/asm/fb.h             |    1 +
 arch/microblaze/include/asm/hardirq.h        |   14 +--
 arch/microblaze/include/asm/irq.h            |    6 +-
 arch/microblaze/include/asm/mmu.h            |    7 +-
 arch/microblaze/include/asm/mmu_context.h    |    2 +-
 arch/microblaze/include/asm/mmu_context_no.h |   23 ----
 arch/microblaze/include/asm/module.h         |   10 +--
 arch/microblaze/include/asm/parport.h        |    1 +
 arch/microblaze/include/asm/pci.h            |    2 +-
 arch/microblaze/include/asm/scatterlist.h    |   29 +-----
 arch/microblaze/include/asm/serial.h         |   15 +---
 arch/microblaze/include/asm/shmparam.h       |    7 +-
 arch/microblaze/include/asm/system.h         |    3 +
 arch/microblaze/include/asm/timex.h          |    6 +-
 arch/microblaze/include/asm/vga.h            |    2 +-
 19 files changed, 45 insertions(+), 290 deletions(-)
 rewrite arch/microblaze/include/asm/atomic.h (84%)
 rewrite arch/microblaze/include/asm/bitops.h (95%)
 create mode 100644 arch/microblaze/include/asm/fb.h
 delete mode 100644 arch/microblaze/include/asm/mmu_context_no.h
 create mode 100644 arch/microblaze/include/asm/parport.h
 rewrite arch/microblaze/include/asm/scatterlist.h (100%)

diff --git a/arch/microblaze/include/asm/atomic.h b/arch/microblaze/include/asm/atomic.h
dissimilarity index 84%
index 0de612a..6d2e1d4 100644
--- a/arch/microblaze/include/asm/atomic.h
+++ b/arch/microblaze/include/asm/atomic.h
@@ -1,123 +1,24 @@
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
+#ifndef _ASM_MICROBLAZE_ATOMIC_H
+#define _ASM_MICROBLAZE_ATOMIC_H
+
+#include <asm-generic/atomic.h>
+
+/*
+ * Atomically test *v and decrement if it is greater than 0.
+ * The function returns the old value of *v minus 1.
+ */
+static inline int atomic_dec_if_positive(atomic_t *v)
+{
+	unsigned long flags;
+	int res;
+
+	local_irq_save(flags);
+	res = v->counter - 1;
+	if (res >= 0)
+		v->counter = res;
+	local_irq_restore(flags);
+
+	return res;
+}
+
+#endif /* _ASM_MICROBLAZE_ATOMIC_H */
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
diff --git a/arch/microblaze/include/asm/fb.h b/arch/microblaze/include/asm/fb.h
new file mode 100644
index 0000000..3a4988e
--- /dev/null
+++ b/arch/microblaze/include/asm/fb.h
@@ -0,0 +1 @@
+#include <asm-generic/fb.h>
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
 
diff --git a/arch/microblaze/include/asm/mmu.h b/arch/microblaze/include/asm/mmu.h
index 66cad6a..8d6a654 100644
--- a/arch/microblaze/include/asm/mmu.h
+++ b/arch/microblaze/include/asm/mmu.h
@@ -12,12 +12,7 @@
 #define _ASM_MICROBLAZE_MMU_H
 
 # ifndef CONFIG_MMU
-#  ifndef __ASSEMBLY__
-typedef struct {
-	struct vm_list_struct	*vmlist;
-	unsigned long		end_brk;
-} mm_context_t;
-#  endif /* __ASSEMBLY__ */
+#  include <asm-generic/mmu.h>
 # else /* CONFIG_MMU */
 #  ifdef __KERNEL__
 #   ifndef __ASSEMBLY__
diff --git a/arch/microblaze/include/asm/mmu_context.h b/arch/microblaze/include/asm/mmu_context.h
index 385fed1..24eab16 100644
--- a/arch/microblaze/include/asm/mmu_context.h
+++ b/arch/microblaze/include/asm/mmu_context.h
@@ -1,5 +1,5 @@
 #ifdef CONFIG_MMU
 # include "mmu_context_mm.h"
 #else
-# include "mmu_context_no.h"
+# include <asm-generic/mmu_context.h>
 #endif
diff --git a/arch/microblaze/include/asm/mmu_context_no.h b/arch/microblaze/include/asm/mmu_context_no.h
deleted file mode 100644
index ba55671..0000000
--- a/arch/microblaze/include/asm/mmu_context_no.h
+++ /dev/null
@@ -1,23 +0,0 @@
-/*
- * Copyright (C) 2008-2009 Michal Simek <monstr@monstr.eu>
- * Copyright (C) 2008-2009 PetaLogix
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
diff --git a/arch/microblaze/include/asm/parport.h b/arch/microblaze/include/asm/parport.h
new file mode 100644
index 0000000..cf252af
--- /dev/null
+++ b/arch/microblaze/include/asm/parport.h
@@ -0,0 +1 @@
+#include <asm-generic/parport.h>
diff --git a/arch/microblaze/include/asm/pci.h b/arch/microblaze/include/asm/pci.h
index ca03794..9f0df5f 100644
--- a/arch/microblaze/include/asm/pci.h
+++ b/arch/microblaze/include/asm/pci.h
@@ -1 +1 @@
-#include <linux/io.h>
+#include <asm-generic/pci.h>
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
index 678525d..befcf3d 100644
--- a/arch/microblaze/include/asm/timex.h
+++ b/arch/microblaze/include/asm/timex.h
@@ -9,10 +9,8 @@
 #ifndef _ASM_MICROBLAZE_TIMEX_H
 #define _ASM_MICROBLAZE_TIMEX_H
 
-#define CLOCK_TICK_RATE 1000 /* Timer input freq. */
-
-typedef unsigned long cycles_t;
+#include <asm-generic/timex.h>
 
-#define get_cycles()	(0)
+#define CLOCK_TICK_RATE 1000 /* Timer input freq. */
 
 #endif /* _ASM_TIMEX_H */
diff --git a/arch/microblaze/include/asm/vga.h b/arch/microblaze/include/asm/vga.h
index 8b13789..89d82fd 100644
--- a/arch/microblaze/include/asm/vga.h
+++ b/arch/microblaze/include/asm/vga.h
@@ -1 +1 @@
-
+#include <asm-generic/vga.h>
-- 
1.6.3.1

