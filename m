Return-Path: <linux-kernel-owner+w=401wt.eu-S1762355AbZD3Pzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762355AbZD3Pzd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 11:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932469AbZD3PnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 11:43:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:54874 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932323AbZD3PmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 11:42:02 -0400
Message-Id: <265d330107973ffda3b4b8a3c26ec93f31dfdf00.1241105648.git.arnd@arndb.de>
In-Reply-To: <cover.1241105648.git.arnd@arndb.de>
References: <cover.1241105648.git.arnd@arndb.de>
From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 28 Apr 2009 16:15:26 +0200
Subject: [PATCH 08/27] asm-generic: add generic versions of common headers
Cc: linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
X-Provags-ID: V01U2FsdGVkX1+T9CF5xmP2t2q4VgVqElh707b1yIeZSdMScGg
 z0CDMVxrp9yBbP9VnCrYvqt6oyohokJyZ4B9St3Mtg+9gjlcQ+
 mTRiQOdOFisB89AMfXHiw==
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are all kernel internal interfaces that get copied
around a lot. In most cases, architectures can provide
their own optimized versions, but these generic versions
can work as well.

I have tried to use the most common contents of each
header to allow existing architectures to migrate easily.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Remis Lima Baima <remis.developer@googlemail.com>
---
 include/asm-generic/bugs.h        |   10 +++
 include/asm-generic/current.h     |    9 ++
 include/asm-generic/delay.h       |    9 ++
 include/asm-generic/fb.h          |   12 +++
 include/asm-generic/hardirq.h     |   34 ++++++++
 include/asm-generic/irq.h         |   18 ++++
 include/asm-generic/irqflags.h    |   72 ++++++++++++++++
 include/asm-generic/kmap_types.h  |   29 +++++++
 include/asm-generic/linkage.h     |    8 ++
 include/asm-generic/module.h      |   22 +++++
 include/asm-generic/mutex.h       |    9 ++
 include/asm-generic/scatterlist.h |   43 ++++++++++
 include/asm-generic/spinlock.h    |   11 +++
 include/asm-generic/string.h      |   10 +++
 include/asm-generic/system.h      |  161 +++++++++++++++++++++++++++++++++++++
 include/asm-generic/user.h        |    8 ++
 16 files changed, 465 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/bugs.h
 create mode 100644 include/asm-generic/current.h
 create mode 100644 include/asm-generic/delay.h
 create mode 100644 include/asm-generic/fb.h
 create mode 100644 include/asm-generic/hardirq.h
 create mode 100644 include/asm-generic/irq.h
 create mode 100644 include/asm-generic/irqflags.h
 create mode 100644 include/asm-generic/kmap_types.h
 create mode 100644 include/asm-generic/linkage.h
 create mode 100644 include/asm-generic/module.h
 create mode 100644 include/asm-generic/mutex.h
 create mode 100644 include/asm-generic/scatterlist.h
 create mode 100644 include/asm-generic/spinlock.h
 create mode 100644 include/asm-generic/string.h
 create mode 100644 include/asm-generic/system.h
 create mode 100644 include/asm-generic/user.h

diff --git a/include/asm-generic/bugs.h b/include/asm-generic/bugs.h
new file mode 100644
index 0000000..6c4f62e
--- /dev/null
+++ b/include/asm-generic/bugs.h
@@ -0,0 +1,10 @@
+#ifndef __ASM_GENERIC_BUGS_H
+#define __ASM_GENERIC_BUGS_H
+/*
+ * This file is included by 'init/main.c' to check for
+ * architecture-dependent bugs.
+ */
+
+static inline void check_bugs(void) { }
+
+#endif	/* __ASM_GENERIC_BUGS_H */
diff --git a/include/asm-generic/current.h b/include/asm-generic/current.h
new file mode 100644
index 0000000..5e86f6a
--- /dev/null
+++ b/include/asm-generic/current.h
@@ -0,0 +1,9 @@
+#ifndef __ASM_GENERIC_CURRENT_H
+#define __ASM_GENERIC_CURRENT_H
+
+#include <linux/thread_info.h>
+
+#define get_current() (current_thread_info()->task)
+#define current get_current()
+
+#endif /* __ASM_GENERIC_CURRENT_H */
diff --git a/include/asm-generic/delay.h b/include/asm-generic/delay.h
new file mode 100644
index 0000000..4586fec
--- /dev/null
+++ b/include/asm-generic/delay.h
@@ -0,0 +1,9 @@
+#ifndef __ASM_GENERIC_DELAY_H
+#define __ASM_GENERIC_DELAY_H
+
+extern void __udelay(unsigned long usecs);
+extern void __delay(unsigned long loops);
+
+#define udelay(n) __udelay(n)
+
+#endif /* __ASM_GENERIC_DELAY_H */
diff --git a/include/asm-generic/fb.h b/include/asm-generic/fb.h
new file mode 100644
index 0000000..fe8ca7f
--- /dev/null
+++ b/include/asm-generic/fb.h
@@ -0,0 +1,12 @@
+#ifndef __ASM_GENERIC_FB_H_
+#define __ASM_GENERIC_FB_H_
+#include <linux/fb.h>
+
+#define fb_pgprotect(...) do {} while (0)
+
+static inline int fb_is_primary_device(struct fb_info *info)
+{
+	return 0;
+}
+
+#endif /* __ASM_GENERIC_FB_H_ */
diff --git a/include/asm-generic/hardirq.h b/include/asm-generic/hardirq.h
new file mode 100644
index 0000000..3d5d2c9
--- /dev/null
+++ b/include/asm-generic/hardirq.h
@@ -0,0 +1,34 @@
+#ifndef __ASM_GENERIC_HARDIRQ_H
+#define __ASM_GENERIC_HARDIRQ_H
+
+#include <linux/cache.h>
+#include <linux/threads.h>
+#include <linux/irq.h>
+
+typedef struct {
+	unsigned long __softirq_pending;
+} ____cacheline_aligned irq_cpustat_t;
+
+#include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
+
+#ifndef HARDIRQ_BITS
+#define HARDIRQ_BITS	8
+#endif
+
+/*
+ * The hardirq mask has to be large enough to have
+ * space for potentially all IRQ sources in the system
+ * nesting on a single CPU:
+ */
+#if (1 << HARDIRQ_BITS) < NR_IRQS
+# error HARDIRQ_BITS is too low!
+#endif
+
+#ifndef ack_bad_irq
+static inline void ack_bad_irq(unsigned int irq)
+{
+	printk(KERN_CRIT "unexpected IRQ trap at vector %02x\n", irq);
+}
+#endif
+
+#endif /* __ASM_GENERIC_HARDIRQ_H */
diff --git a/include/asm-generic/irq.h b/include/asm-generic/irq.h
new file mode 100644
index 0000000..b90ec0b
--- /dev/null
+++ b/include/asm-generic/irq.h
@@ -0,0 +1,18 @@
+#ifndef __ASM_GENERIC_IRQ_H
+#define __ASM_GENERIC_IRQ_H
+
+/*
+ * NR_IRQS is the upper bound of how many interrupts can be handled
+ * in the platform. It is used to size the static irq_map array,
+ * so don't make it too big.
+ */
+#ifndef NR_IRQS
+#define NR_IRQS 64
+#endif
+
+static inline int irq_canonicalize(int irq)
+{
+	return irq;
+}
+
+#endif /* __ASM_GENERIC_IRQ_H */
diff --git a/include/asm-generic/irqflags.h b/include/asm-generic/irqflags.h
new file mode 100644
index 0000000..9aebf61
--- /dev/null
+++ b/include/asm-generic/irqflags.h
@@ -0,0 +1,72 @@
+#ifndef __ASM_GENERIC_IRQFLAGS_H
+#define __ASM_GENERIC_IRQFLAGS_H
+
+/*
+ * All architectures should implement at least the first two functions,
+ * usually inline assembly will be the best way.
+ */
+#ifndef RAW_IRQ_DISABLED
+#define RAW_IRQ_DISABLED 0
+#define RAW_IRQ_ENABLED 1
+#endif
+
+/* read interrupt enabled status */
+#ifndef __raw_local_save_flags
+unsigned long __raw_local_save_flags(void);
+#endif
+
+/* set interrupt enabled status */
+#ifndef raw_local_irq_restore
+void raw_local_irq_restore(unsigned long flags);
+#endif
+
+/* get status and disable interrupts */
+#ifndef __raw_local_irq_save
+static inline unsigned long __raw_local_irq_save(void)
+{
+	unsigned long flags;
+	flags = __raw_local_save_flags();
+	raw_local_irq_restore(RAW_IRQ_DISABLED);
+	return flags;
+}
+#endif
+
+/* test flags */
+#ifndef raw_irqs_disabled_flags
+static inline int raw_irqs_disabled_flags(unsigned long flags)
+{
+	return flags == RAW_IRQ_DISABLED;
+}
+#endif
+
+/* unconditionally enable interrupts */
+#ifndef raw_local_irq_enable
+static inline void raw_local_irq_enable(void)
+{
+	raw_local_irq_restore(RAW_IRQ_ENABLED);
+}
+#endif
+
+/* unconditionally disable interrupts */
+#ifndef raw_local_irq_disable
+static inline void raw_local_irq_disable(void)
+{
+	raw_local_irq_restore(RAW_IRQ_DISABLED);
+}
+#endif
+
+/* test hardware interrupt enable bit */
+#ifndef raw_irqs_disabled
+static inline int raw_irqs_disabled(void)
+{
+	return raw_irqs_disabled_flags(__raw_local_save_flags());
+}
+#endif
+
+#define raw_local_save_flags(flags) \
+	do { (flags) = __raw_local_save_flags(); } while (0)
+
+#define raw_local_irq_save(flags) \
+	do { (flags) = __raw_local_irq_save(); } while (0)
+
+#endif /* __ASM_GENERIC_IRQFLAGS_H */
diff --git a/include/asm-generic/kmap_types.h b/include/asm-generic/kmap_types.h
new file mode 100644
index 0000000..36996bc
--- /dev/null
+++ b/include/asm-generic/kmap_types.h
@@ -0,0 +1,29 @@
+#ifndef __ASM_GENERIC_KMAP_TYPES_H
+#define __ASM_GENERIC_KMAP_TYPES_H
+
+#ifdef CONFIG_DEBUG_HIGHMEM
+# define D(n) __KM_FENCE_##n ,
+#else
+# define D(n)
+#endif
+
+enum km_type {
+D(0)	KM_BOUNCE_READ,
+D(1)	KM_SKB_SUNRPC_DATA,
+D(2)	KM_SKB_DATA_SOFTIRQ,
+D(3)	KM_USER0,
+D(4)	KM_USER1,
+D(5)	KM_BIO_SRC_IRQ,
+D(6)	KM_BIO_DST_IRQ,
+D(7)	KM_PTE0,
+D(8)	KM_PTE1,
+D(9)	KM_IRQ0,
+D(10)	KM_IRQ1,
+D(11)	KM_SOFTIRQ0,
+D(12)	KM_SOFTIRQ1,
+D(13)	KM_TYPE_NR
+};
+
+#undef D
+
+#endif /* __ASM_GENERIC_KMAP_TYPES_H */
diff --git a/include/asm-generic/linkage.h b/include/asm-generic/linkage.h
new file mode 100644
index 0000000..fef7a01
--- /dev/null
+++ b/include/asm-generic/linkage.h
@@ -0,0 +1,8 @@
+#ifndef __ASM_GENERIC_LINKAGE_H
+#define __ASM_GENERIC_LINKAGE_H
+/*
+ * linux/linkage.h provides reasonable defaults.
+ * an architecture can override them by providing its own version.
+ */
+
+#endif /* __ASM_GENERIC_LINKAGE_H */
diff --git a/include/asm-generic/module.h b/include/asm-generic/module.h
new file mode 100644
index 0000000..ed5b44d
--- /dev/null
+++ b/include/asm-generic/module.h
@@ -0,0 +1,22 @@
+#ifndef __ASM_GENERIC_MODULE_H
+#define __ASM_GENERIC_MODULE_H
+
+/*
+ * Many architectures just need a simple module
+ * loader without arch specific data.
+ */
+struct mod_arch_specific
+{
+};
+
+#ifdef CONFIG_64BIT
+#define Elf_Shdr Elf64_Shdr
+#define Elf_Sym Elf64_Sym
+#define Elf_Ehdr Elf64_Ehdr
+#else
+#define Elf_Shdr Elf32_Shdr
+#define Elf_Sym Elf32_Sym
+#define Elf_Ehdr Elf32_Ehdr
+#endif
+
+#endif /* __ASM_GENERIC_MODULE_H */
diff --git a/include/asm-generic/mutex.h b/include/asm-generic/mutex.h
new file mode 100644
index 0000000..fe91ab5
--- /dev/null
+++ b/include/asm-generic/mutex.h
@@ -0,0 +1,9 @@
+#ifndef __ASM_GENERIC_MUTEX_H
+#define __ASM_GENERIC_MUTEX_H
+/*
+ * Pull in the generic implementation for the mutex fastpath,
+ * which is a reasonable default on many architectures.
+ */
+
+#include <asm-generic/mutex-dec.h>
+#endif /* __ASM_GENERIC_MUTEX_H */
diff --git a/include/asm-generic/scatterlist.h b/include/asm-generic/scatterlist.h
new file mode 100644
index 0000000..8b94544
--- /dev/null
+++ b/include/asm-generic/scatterlist.h
@@ -0,0 +1,43 @@
+#ifndef __ASM_GENERIC_SCATTERLIST_H
+#define __ASM_GENERIC_SCATTERLIST_H
+
+#include <linux/types.h>
+
+struct scatterlist {
+#ifdef CONFIG_DEBUG_SG
+	unsigned long	sg_magic;
+#endif
+	unsigned long	page_link;
+	unsigned int	offset;
+	unsigned int	length;
+	dma_addr_t	dma_address;
+	unsigned int	dma_length;
+};
+
+/*
+ * These macros should be used after a dma_map_sg call has been done
+ * to get bus addresses of each of the SG entries and their lengths.
+ * You should only work with the number of sg entries pci_map_sg
+ * returns, or alternatively stop on the first sg_dma_len(sg) which
+ * is 0.
+ */
+#define sg_dma_address(sg)	((sg)->dma_address)
+#ifndef sg_dma_len
+/*
+ * Normally, you have an iommu on 64 bit machines, but not on 32 bit
+ * machines. Architectures that are differnt should override this.
+ */
+#if __BITS_PER_LONG == 64
+#define sg_dma_len(sg)		((sg)->dma_length)
+#else
+#define sg_dma_len(sg)		((sg)->length)
+#endif /* 64 bit */
+#endif /* sg_dma_len */
+
+#ifndef ISA_DMA_THRESHOLD
+#define ISA_DMA_THRESHOLD	(~0UL)
+#endif
+
+#define ARCH_HAS_SG_CHAIN
+
+#endif /* __ASM_GENERIC_SCATTERLIST_H */
diff --git a/include/asm-generic/spinlock.h b/include/asm-generic/spinlock.h
new file mode 100644
index 0000000..1547a03
--- /dev/null
+++ b/include/asm-generic/spinlock.h
@@ -0,0 +1,11 @@
+#ifndef __ASM_GENERIC_SPINLOCK_H
+#define __ASM_GENERIC_SPINLOCK_H
+/*
+ * You need to implement asm/spinlock.h for SMP support. The generic
+ * version does not handle SMP.
+ */
+#ifdef CONFIG_SMP
+#error need an architecture specific asm/spinlock.h
+#endif
+
+#endif /* __ASM_GENERIC_SPINLOCK_H */
diff --git a/include/asm-generic/string.h b/include/asm-generic/string.h
new file mode 100644
index 0000000..de5e020
--- /dev/null
+++ b/include/asm-generic/string.h
@@ -0,0 +1,10 @@
+#ifndef __ASM_GENERIC_STRING_H
+#define __ASM_GENERIC_STRING_H
+/*
+ * The kernel provides all required functions in lib/string.c
+ *
+ * Architectures probably want to provide at least their own optimized
+ * memcpy and memset functions though.
+ */
+
+#endif /* __ASM_GENERIC_STRING_H */
diff --git a/include/asm-generic/system.h b/include/asm-generic/system.h
new file mode 100644
index 0000000..efa403b
--- /dev/null
+++ b/include/asm-generic/system.h
@@ -0,0 +1,161 @@
+/* Generic system definitions, based on MN10300 definitions.
+ *
+ * It should be possible to use these on really simple architectures,
+ * but it serves more as a starting point for new ports.
+ *
+ * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+#ifndef __ASM_GENERIC_SYSTEM_H
+#define __ASM_GENERIC_SYSTEM_H
+
+#ifdef __KERNEL__
+#ifndef __ASSEMBLY__
+
+#include <linux/types.h>
+#include <linux/irqflags.h>
+
+#include <asm/cmpxchg-local.h>
+
+struct task_struct;
+
+/* context switching is now performed out-of-line in switch_to.S */
+extern struct task_struct *__switch_to(struct task_struct *,
+		struct task_struct *);
+#define switch_to(prev, next, last)					\
+	do {								\
+		((last) = __switch_to((prev), (next)));			\
+	} while (0)
+
+#define arch_align_stack(x) (x)
+
+#define nop() asm volatile ("nop")
+
+#endif /* !__ASSEMBLY__ */
+
+/*
+ * Force strict CPU ordering.
+ * And yes, this is required on UP too when we're talking
+ * to devices.
+ *
+ * This implementation only contains a compiler barrier.
+ */
+
+#define mb()	asm volatile ("": : :"memory")
+#define rmb()	mb()
+#define wmb()	asm volatile ("": : :"memory")
+
+#ifdef CONFIG_SMP
+#define smp_mb()	mb()
+#define smp_rmb()	rmb()
+#define smp_wmb()	wmb()
+#else
+#define smp_mb()	barrier()
+#define smp_rmb()	barrier()
+#define smp_wmb()	barrier()
+#endif
+
+#define set_mb(var, value)  do { var = value;  mb(); } while (0)
+#define set_wmb(var, value) do { var = value; wmb(); } while (0)
+
+#define read_barrier_depends()		do {} while (0)
+#define smp_read_barrier_depends()	do {} while (0)
+
+/*
+ * we make sure local_irq_enable() doesn't cause priority inversion
+ */
+#ifndef __ASSEMBLY__
+
+/* This function doesn't exist, so you'll get a linker error
+ *    if something tries to do an invalid xchg().  */
+extern void __xchg_called_with_bad_pointer(void);
+
+static inline
+unsigned long __xchg(unsigned long x, volatile void *ptr, int size)
+{
+	unsigned long ret, flags;
+
+	switch (size) {
+	case 1:
+#ifdef __xchg_u8
+		return __xchg_u8(x, ptr);
+#else
+		local_irq_save(flags);
+		ret = *(volatile u8 *)ptr;
+		*(volatile u8 *)ptr = x;
+		local_irq_restore(flags);
+		return ret;
+#endif /* __xchg_u8 */
+
+	case 2:
+#ifdef __xchg_u16
+		return __xchg_u16(x, ptr);
+#else
+		local_irq_save(flags);
+		ret = *(volatile u16 *)ptr;
+		*(volatile u16 *)ptr = x;
+		local_irq_restore(flags);
+		return ret;
+#endif /* __xchg_u16 */
+
+	case 4:
+#ifdef __xchg_u32
+		return __xchg_u32(x, ptr);
+#else
+		local_irq_save(flags);
+		ret = *(volatile u32 *)ptr;
+		*(volatile u32 *)ptr = x;
+		local_irq_restore(flags);
+		return ret;
+#endif /* __xchg_u32 */
+
+#ifdef CONFIG_64BIT
+	case 8:
+#ifdef __xchg_u64
+		return __xchg_u64(x, ptr);
+#else
+		local_irq_save(flags);
+		ret = *(volatile u64 *)ptr;
+		*(volatile u64 *)ptr = x;
+		local_irq_restore(flags);
+		return ret;
+#endif /* __xchg_u64 */
+#endif /* CONFIG_64BIT */
+
+	default:
+		__xchg_called_with_bad_pointer();
+		return x;
+	}
+}
+
+#define xchg(ptr, x) \
+	((__typeof__(*(ptr))) __xchg((unsigned long)(x), (ptr), sizeof(*(ptr))))
+
+static inline unsigned long __cmpxchg(volatile unsigned long *m,
+				      unsigned long old, unsigned long new)
+{
+	unsigned long retval;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	retval = *m;
+	if (retval == old)
+		*m = new;
+	local_irq_restore(flags);
+	return retval;
+}
+
+#define cmpxchg(ptr, o, n)					\
+	((__typeof__(*(ptr))) __cmpxchg((unsigned long *)(ptr), \
+					(unsigned long)(o),	\
+					(unsigned long)(n)))
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* __KERNEL__ */
+#endif /* __ASM_GENERIC_SYSTEM_H */
diff --git a/include/asm-generic/user.h b/include/asm-generic/user.h
new file mode 100644
index 0000000..8b9c3c9
--- /dev/null
+++ b/include/asm-generic/user.h
@@ -0,0 +1,8 @@
+#ifndef __ASM_GENERIC_USER_H
+#define __ASM_GENERIC_USER_H
+/*
+ * This file may define a 'struct user' structure. However, it it only
+ * used for a.out file, which are not supported on new architectures.
+ */
+
+#endif	/* __ASM_GENERIC_USER_H */
-- 
1.5.6.3


