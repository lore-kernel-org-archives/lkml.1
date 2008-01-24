Return-Path: <linux-kernel-owner+w=401wt.eu-S1761488AbYAZQIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761488AbYAZQIn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 11:08:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757656AbYAZP5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 10:57:18 -0500
Received: from 206-47-31-89.wifiinternet.cz ([89.31.47.206]:1177 "EHLO
	monstr.monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757598AbYAZP5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 10:57:14 -0500
From: monstr@monstr.eu
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH 09/52] [microblaze] cache support
Date: Thu, 24 Jan 2008 16:03:34 +0100
Message-Id: <511c50297cee79a1237479ed1c68c923aed8293f.1201107832.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.rc4.14.g6fc74
In-Reply-To: <671df2e842f46f829133f893b5388e29a797494d.1201107832.git.monstr@monstr.eu>
References: <1201187014-3979-1-git-send-email-monstr@monstr.eu>
 <dbff6b883dbcb108db53e5093994c473946e1240.1201107832.git.monstr@monstr.eu>
 <ac0947adfe718fcb4c0dc5f6f7ab64f8155541fb.1201107832.git.monstr@monstr.eu>
 <873c2bf1f67696aa11014886470f6ba46f04e8d2.1201107832.git.monstr@monstr.eu>
 <516d173b1789ea533431e8f5ad05751c6a353c88.1201107832.git.monstr@monstr.eu>
 <068508828aac6298b4cc65b0cd7b2737a61c466c.1201107832.git.monstr@monstr.eu>
 <010fc233f82a8f7a591c9f8315ae03f9951139aa.1201107832.git.monstr@monstr.eu>
 <68faaf69ea03196d4a56a263707355e7e7eb5c6a.1201107832.git.monstr@monstr.eu>
 <4b7d90fc1b9bcb3c0b1b308c6460390f7bdf3824.1201107832.git.monstr@monstr.eu>
 <eb28582e845efb4f2f26054630895f26fa69866e.1201107832.git.monstr@monstr.eu>
 <64e6e541db30cc4f1ee5cd85da4bdea6024f75b8.1201107832.git.monstr@monstr.eu>
 <90badb264d0e4ec49fdaa76842a5e5f259681299.1201107832.git.monstr@monstr.eu>
 <a013a2b7044186c64d55cdafc8c9b29bc73a7fc5.1201107832.git.monstr@monstr.eu>
 <60642f04ebcf9f76da50a1d40191755f258edcc5.1201107832.git.monstr@monstr.eu>
 <240998be1af3774635995fd19248f8b3a9e8a702.1201107832.git.monstr@monstr.eu>
 <3bcb9581bc512fdd0a124ac8322af9e2a8adc975.1201107832.git.monstr@monstr.eu>
 <db7f441df21cfe296a44744747b28f379e75fd49.1201107832.git.monstr@monstr.eu>
 <e6309af7cc6550ef5b399fc0902f1926f9e52e58.1201107832.git.monstr@monstr.eu>
 <2d11eef3abada1f41658a532a483c6121ded8054.1201107832.git.monstr@monstr.eu>
 <48db19662b808ab6f5455dd7f2116e6544c50e95.1201107832.git.monstr@monstr.eu>
 <7b0cfa6ae11749e20c941d0a4f03577141e022f8.1201107832.git.monstr@monstr.eu>
 <2f3db7ba4fe41cb9888adabf0e4e052d4da5c37c.1201107832.git.monstr@monstr.eu>
 <d67010417928d04766e6dd74820b12c249d61814.1201107832.git.monstr@monstr.eu>
 <37627293f081fa40f21234944ddb878d5e711740.1201107832.git.monstr@monstr.eu>
 <105791d33ea12564c70be0dd3fafef386f8e1b55.1201107832.git.monstr@monstr.eu>
 <b501d439bdfabddbdef5935db86b6f64c83d55c4.1201107832.git.monstr@monstr.eu>
 <43f77bd3045d72346eb39d3170de727050c835c1.1201107832.git.monstr@monstr.eu>
 <c09d54c49393bedbe4ca43df0e35cefa5fcc649c.1201107832.git.monstr@monstr.eu>
 <29ee870c02ea5d4c409644d7f0eb09cfbb1ec816.1201107832.git.monstr@monstr.eu>
 <99bfbc3fdb53003c11414681b2c73561d533c3ef.1201107832.git.monstr@monstr.eu>
 <1b21abdff6128297a902060b07a0c7ca6d8db633.1201107832.git.monstr@monstr.eu>
 <e173c10560cdf883ba3c7e639ca930f0627a2260.1201107832.git.monstr@monstr.eu>
 <155ee14d990137f7eb6fa76beee06c880c97e790.1201107832.git.monstr@monstr.eu>
 <34f2199d631406fbdf6b325a164e0d1899a3acb5.1201107832.git.monstr@monstr.eu>
 <14243bf49d44d1dbd6e377813f2635defcb82c4e.1201107832.git.monstr@monstr.eu>
 <01e493efdc1c8cb7ee0d5f8b7c73244e04680e71.1201107832.git.monstr@monstr.eu>
 <739e189a03021d2804f23d0774637a15038098bc.1201107832.git.monstr@monstr.eu>
 <d4eec3db9f6e6e86994444b8035d5e41db3f085b.1201107832.git.monstr@monstr.eu>
 <e445f6b37baf09d6469a0ad4eba189a7ca7ef7c3.1201107832.git.monstr@monstr.eu>
 <807d570db44eeed03e3211b933a207f42cf569f0.1201107832.git.monstr@monstr.eu>
 <990835fa238b139deac273e0573bcf5060e3ee80.1201107832.git.monstr@monstr.eu>
 <993cd20fd7ee4ec891f1354690f93ca62d7871ec.1201107832.git.monstr@monstr.eu>
 <e83ad9fcfb12993d8d20ce6663e563b8b496273e.1201107832.git.monstr@monstr.eu>
 <e22e05ebd297de6f7d5dd0bf2eecf20d6749d571.1201107832.git.monstr@monstr.eu>
 <62a6eb3ffa457cd0c126320a0e46509f06e00511.1201107832.git.monstr@monstr.eu>
 <c4d02deb7e0a9a243a961bfe066e5d05e72a836e.1201107832.git.monstr@monstr.eu>
 <e83ac9f205e3ef0524ded397faf91a7a0750100c.1201107832.git.monstr@monstr.eu>
 <2802c9c0575435ca5c412601eb30a04f3fe4eec6.1201107832.git.monstr@monstr.eu>
 <9e7bb497ba4b4ffbb368d9613a0105529791e6b8.1201107832.git.monstr@monstr.eu>
 <671df2e842f46f829133f893b5388e29a797494d.1201107832.git.monstr@monstr.eu>
In-Reply-To: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
References: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/cpu/cache.c  |  256 +++++++++++++++++++++++++++++++++++
 include/asm-microblaze/cache.h      |   47 +++++++
 include/asm-microblaze/cacheflush.h |   72 ++++++++++
 3 files changed, 375 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/cpu/cache.c
 create mode 100644 include/asm-microblaze/cache.h
 create mode 100644 include/asm-microblaze/cacheflush.h

diff --git a/arch/microblaze/kernel/cpu/cache.c b/arch/microblaze/kernel/cpu/cache.c
new file mode 100644
index 0000000..43fff59
--- /dev/null
+++ b/arch/microblaze/kernel/cpu/cache.c
@@ -0,0 +1,256 @@
+/*
+ * arch/microblaze/kernel/cpu/cache.c
+ * Cache control for MicroBlaze cache memories
+ *
+ * Copyright (C) 2007 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2007 PetaLogix
+ * Copyright (C) 2007 John Williams <john.williams@petalogix.com>
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License. See the file COPYING in the main directory of this
+ * archive for more details.
+ *
+ */
+
+#include <asm/cacheflush.h>
+#include <asm/cache.h>
+#include <asm/cpuinfo.h>
+
+/* Exported functions */
+
+void _enable_icache(void)
+{
+	if (cpuinfo->use_icache) {
+#if CONFIG_XILINX_MICROBLAZE0_USE_MSR_INSTR
+		__asm__ __volatile__ ("					\
+				msrset	r0, %0;				\
+				nop; "					\
+				:					\
+				: "i" (MSR_ICE)				\
+				: "memory");
+#else
+		__asm__ __volatile__ ("					\
+				mfs	r12, rmsr;			\
+				ori	r12, r12, %0;			\
+				mts	rmsr, r12;			\
+				nop; "					\
+				:					\
+				: "i" (MSR_ICE)				\
+				: "memory", "r12");
+#endif
+	}
+}
+
+void _disable_icache(void)
+{
+	if (cpuinfo->use_icache) {
+#if CONFIG_XILINX_MICROBLAZE0_USE_MSR_INSTR
+		__asm__ __volatile__ ("					\
+				msrclr r0, %0;				\
+				nop; "					\
+				:					\
+				: "i" (MSR_ICE)				\
+				: "memory");
+#else
+		__asm__ __volatile__ ("					\
+				mfs	r12, rmsr;			\
+				andi	r12, r12, ~%0;			\
+				mts	rmsr, r12;			\
+				nop; "					\
+				:					\
+				: "i" (MSR_ICE)				\
+				: "memory", "r12");
+#endif
+	}
+}
+
+void _invalidate_icache(unsigned int addr)
+{
+	if (cpuinfo->use_icache) {
+		__asm__ __volatile__ ("					\
+				wic	%0, r0"				\
+				:					\
+				: "r" (addr));
+	}
+}
+
+void _enable_dcache(void)
+{
+	if (cpuinfo->use_dcache) {
+#if CONFIG_XILINX_MICROBLAZE0_USE_MSR_INSTR
+		__asm__ __volatile__ ("					\
+				msrset	r0, %0;				\
+				nop; "					\
+				:					\
+				: "i" (MSR_DCE)				\
+				: "memory");
+#else
+		__asm__ __volatile__ ("					\
+				mfs	r12, rmsr;			\
+				ori	r12, r12, %0;			\
+				mts	rmsr, r12;			\
+				nop; "					\
+				:					\
+				: "i" (MSR_DCE)			\
+				: "memory", "r12");
+#endif
+	}
+}
+
+void _disable_dcache(void)
+{
+	if (cpuinfo->use_dcache) {
+#if CONFIG_XILINX_MICROBLAZE0_USE_MSR_INSTR
+		__asm__ __volatile__ ("					\
+				msrclr	r0, %0;				\
+				nop; "					\
+				:					\
+				: "i" (MSR_DCE)			\
+				: "memory");
+#else
+		__asm__ __volatile__ ("					\
+				mfs	r12, rmsr;			\
+				andi	r12, r12, ~%0;			\
+				mts	rmsr, r12;			\
+				nop; "					\
+				:					\
+				: "i" (MSR_DCE)			\
+				: "memory", "r12");
+#endif
+	}
+}
+
+void _invalidate_dcache(unsigned int addr)
+{
+	if (cpuinfo->use_dcache)
+		__asm__ __volatile__ ("					\
+				wdc	%0, r0"				\
+				:					\
+				: "r" (addr));
+}
+
+void __flush_icache_all(void)
+{
+	unsigned int i;
+	unsigned flags;
+
+	if (cpuinfo->use_icache) {
+		local_irq_save(flags);
+		__disable_icache();
+
+		/* Just loop through cache size and invalidate, no need to add
+			CACHE_BASE address */
+		for (i = 0; i < cpuinfo->icache_size;
+			i += cpuinfo->icache_line)
+				__invalidate_icache(i);
+
+		__enable_icache();
+		local_irq_restore(flags);
+	}
+}
+
+void __flush_icache_range(unsigned long start, unsigned long end)
+{
+	unsigned int i;
+	unsigned flags;
+	unsigned int align;
+
+	if (cpuinfo->use_icache) {
+		/*
+		 * No need to cover entire cache range,
+		 * just cover cache footprint
+		 */
+		end = min(start + cpuinfo->icache_size, end);
+		align = ~(cpuinfo->icache_line - 1);
+		start &= align; /* Make sure we are aligned */
+		/* Push end up to the next cache line */
+		end = ((end & align) + cpuinfo->icache_line);
+
+		local_irq_save(flags);
+		__disable_icache();
+
+		for (i = start; i < end; i += cpuinfo->icache_line)
+			__invalidate_icache(i);
+
+		__enable_icache();
+		local_irq_restore(flags);
+	}
+}
+
+void __flush_icache_page(struct vm_area_struct *vma, struct page *page)
+{
+	__flush_icache_all();
+}
+
+void __flush_icache_user_range(struct vm_area_struct *vma,
+				struct page *page, unsigned long adr,
+				int len)
+{
+	__flush_icache_all();
+}
+
+void __flush_cache_sigtramp(unsigned long addr)
+{
+	__flush_icache_range(addr, addr + 8);
+}
+
+void __flush_dcache_all(void)
+{
+	unsigned int i;
+	unsigned flags;
+
+	if (cpuinfo->use_dcache) {
+		local_irq_save(flags);
+		__disable_dcache();
+
+		/*
+		 * Just loop through cache size and invalidate,
+		 * no need to add CACHE_BASE address
+		 */
+		for (i = 0; i < cpuinfo->dcache_size;
+			i += cpuinfo->dcache_line)
+				__invalidate_dcache(i);
+
+		__enable_dcache();
+		local_irq_restore(flags);
+	}
+}
+
+void __flush_dcache_range(unsigned long start, unsigned long end)
+{
+	unsigned int i;
+	unsigned flags;
+	unsigned int align;
+
+	if (cpuinfo->use_dcache) {
+		/*
+		 * No need to cover entire cache range,
+		 * just cover cache footprint
+		 */
+		end = min(start + cpuinfo->dcache_size, end);
+		align = ~(cpuinfo->dcache_line - 1);
+		start &= align; /* Make sure we are aligned */
+		/* Push end up to the next cache line */
+		end = ((end & align) + cpuinfo->dcache_line);
+		local_irq_save(flags);
+		__disable_dcache();
+
+		for (i = start; i < end; i += cpuinfo->dcache_line)
+			__invalidate_dcache(i);
+
+		__enable_dcache();
+		local_irq_restore(flags);
+	}
+}
+
+void __flush_dcache_page(struct vm_area_struct *vma, struct page *page)
+{
+	__flush_dcache_all();
+}
+
+void __flush_dcache_user_range(struct vm_area_struct *vma,
+				struct page *page, unsigned long adr,
+				int len)
+{
+	__flush_dcache_all();
+}
diff --git a/include/asm-microblaze/cache.h b/include/asm-microblaze/cache.h
new file mode 100644
index 0000000..e988152
--- /dev/null
+++ b/include/asm-microblaze/cache.h
@@ -0,0 +1,47 @@
+/*
+ * include/asm-microblaze/cache.h
+ *
+ * Cache operations
+ *
+ * Copyright (C) 2007 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2003 John Williams <jwilliams@itee.uq.edu.au>
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License. See the file COPYING in the main directory of this
+ * archive for more details.
+ *
+ */
+
+#ifndef _MICROBLAZE_CACHE_H
+#define _MICROBLAZE_CACHE_H
+
+#include <asm/registers.h>
+#include <linux/autoconf.h>
+
+#ifndef L1_CACHE_BYTES
+/* word-granular cache in microblaze */
+#define L1_CACHE_BYTES		4
+#endif
+
+void _enable_icache(void);
+void _disable_icache(void);
+void _invalidate_icache(unsigned int addr);
+
+#define __enable_icache()		_enable_icache()
+#define __disable_icache()		_disable_icache()
+#define __invalidate_icache(addr)	_invalidate_icache(addr)
+
+void _enable_dcache(void);
+void _disable_dcache(void);
+void _invalidate_dcache(unsigned int addr);
+
+#define __enable_dcache()		_enable_dcache()
+#define __disable_dcache()		_disable_dcache()
+#define __invalidate_dcache(addr)	_invalidate_dcache(addr)
+
+/* FIXME - I don't think this is right */
+#ifdef CONFIG_XILINX_UNCACHED_SHADOW
+#define UNCACHED_SHADOW_MASK (CONFIG_XILINX_ERAM_SIZE)
+#endif
+
+#endif /* _MICROBLAZE_CACHE_H */
diff --git a/include/asm-microblaze/cacheflush.h b/include/asm-microblaze/cacheflush.h
new file mode 100644
index 0000000..3051690
--- /dev/null
+++ b/include/asm-microblaze/cacheflush.h
@@ -0,0 +1,72 @@
+/*
+ * include/asm-microblaze/cacheflush.h
+ *
+ * Copyright (C) 2007 PetaLogix
+ * Copyright (C) 2007 John Williams <john.williams@petalogix.com>
+ * based on v850 version which was
+ * Copyright (C) 2001,02,03 NEC Electronics Corporation
+ * Copyright (C) 2001,02,03 Miles Bader <miles@gnu.org>
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License. See the file COPYING in the main directory of this
+ * archive for more details.
+ *
+ */
+
+#ifndef _MICROBLAZE_CACHEFLUSH_H
+#define _MICROBLAZE_CACHEFLUSH_H
+
+/* Somebody depends on this; sigh... */
+#include <linux/mm.h>
+
+#define flush_cache_all()			__flush_cache_all()
+#define flush_cache_mm(mm)			do { } while (0)
+#define flush_cache_range(vma, start, end)	__flush_cache_all()
+#define flush_cache_page(vma, vmaddr, pfn)	do { } while (0)
+
+#define flush_dcache_range(start, end)	__flush_dcache_range(start, end)
+#define flush_dcache_page(page)		do { } while (0)
+#define flush_dcache_mmap_lock(mapping)		do { } while (0)
+#define flush_dcache_mmap_unlock(mapping)	do { } while (0)
+
+#define flush_icache_range(start, len)	__flush_icache_range(start, len)
+#define flush_icache_page(vma, pg)		do { } while (0)
+#define flush_icache_user_range(start, len)	do { } while (0)
+
+#define flush_cache_vmap(start, end)		do { } while (0)
+#define flush_cache_vunmap(start, end)		do { } while (0)
+
+struct page;
+struct mm_struct;
+struct vm_area_struct;
+
+/* see arch/microblaze/kernel/cache.c */
+extern void __flush_icache_all(void);
+extern void __flush_icache_range(unsigned long start, unsigned long end);
+extern void __flush_icache_page(struct vm_area_struct *vma, struct page *page);
+extern void __flush_icache_user_range(struct vm_area_struct *vma,
+				struct page *page,
+				unsigned long adr, int len);
+extern void __flush_cache_sigtramp(unsigned long addr);
+
+extern void __flush_dcache_all(void);
+extern void __flush_dcache_range(unsigned long start, unsigned long end);
+extern void __flush_dcache_page(struct vm_area_struct *vma, struct page *page);
+extern void __flush_dcache_user_range(struct vm_area_struct *vma,
+				struct page *page,
+				unsigned long adr, int len);
+
+extern inline void __flush_cache_all(void)
+{
+	__flush_icache_all();
+	__flush_dcache_all();
+}
+
+#define copy_to_user_page(vma, page, vaddr, dst, src, len) \
+do { memcpy(dst, src, len); \
+	flush_icache_user_range(vma, page, vaddr, len); \
+} while (0)
+#define copy_from_user_page(vma, page, vaddr, dst, src, len) \
+	memcpy(dst, src, len)
+
+#endif /* _MICROBLAZE_CACHEFLUSH_H */
-- 
1.5.4.rc4.14.g6fc74

