Return-Path: <linux-kernel-owner+w=401wt.eu-S1760845AbZCRVz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760845AbZCRVz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 17:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758513AbZCRVoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 17:44:06 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:54475 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758132AbZCRVoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 17:44:04 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 29/57] microblaze_v7: memory inicialization, MMU, TLB
Date: Wed, 18 Mar 2009 21:30:56 +0100
Message-Id: <aa044d06327435cee76599fb6220630007f38ba7.1237407249.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <72b06b8fa7b051005ebfa5c23c53a40d6a27f94a.1237407249.git.monstr@monstr.eu>
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu>
 <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
 <c1bdfabf85ce10babc3aa38d3bb7558a093bc49e.1237407249.git.monstr@monstr.eu>
 <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu>
 <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu>
 <5f8b2a60496983f572ef6d3b4e2f986c167a8336.1237407249.git.monstr@monstr.eu>
 <fbef554ff1d05fa50312d91e61a0d63d3207076c.1237407249.git.monstr@monstr.eu>
 <dad2353f129217470f0595eeed98412b4c84ed6b.1237407249.git.monstr@monstr.eu>
 <20fd42a1e8837c7352d35d157aa3393e88152c32.1237407249.git.monstr@monstr.eu>
 <f7c1685bd3f387be8633db5fb3dd4cb5e7c2d792.1237407249.git.monstr@monstr.eu>
 <2f48efc353c11dfdfc7b052bdfe052b71c09ab23.1237407249.git.monstr@monstr.eu>
 <f7f2d17e21a3df9931c75976c37a003d11190cc9.1237407249.git.monstr@monstr.eu>
 <58cf06c85e07477170677b72ce3437af10476bec.1237407249.git.monstr@monstr.eu>
 <eaa0169a360a328883ab0eabd2a189c21bad4c30.1237407249.git.monstr@monstr.eu>
 <20227d6f2615060d6560785090513e251cbe2654.1237407249.git.monstr@monstr.eu>
 <69ef4f976d86c870a97fbe4974c242c74acc477d.1237407249.git.monstr@monstr.eu>
 <eb4ccc67cf39abc816c8d7653fdc7561d14c1da2.1237407249.git.monstr@monstr.eu>
 <1477ec41e7ba0ec847a064e1f8e422dc2a5dcc9f.1237407249.git.monstr@monstr.eu>
 <75127eae09c978220d452d92f95763dde24f1d52.1237407249.git.monstr@monstr.eu>
 <b726b7b271cf303c36af54c4e155140541a6769b.1237407249.git.monstr@monstr.eu>
 <644f08d7f8cd338e606ed703e221914f75588fb5.1237407249.git.monstr@monstr.eu>
 <6d19f608a4ba3e7718aa55794c2845f19b5ed5e2.1237407249.git.monstr@monstr.eu>
 <039bc2fea33d23a3e7d2d85ac6fb275b8d21b5ed.1237407249.git.monstr@monstr.eu>
 <513d4067a84be1ecb47577e1edf131d2b3572808.1237407249.git.monstr@monstr.eu>
 <c6a6fbe7b56db27d9b74ee593cf068963f86ee58.1237407249.git.monstr@monstr.eu>
 <e9d4d452140c50451741dd6024ab89efd24ac8e6.1237407249.git.monstr@monstr.eu>
 <f8494212852d4cec890ae5e152353c91153c7c0d.1237407249.git.monstr@monstr.eu>
 <5c66d0329884feb553ae745584f6db589a892eb1.1237407249.git.monstr@monstr.eu>
 <72b06b8fa7b051005ebfa5c23c53a40d6a27f94a.1237407249.git.monstr@monstr.eu>
In-Reply-To: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
References: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/mmu.h         |   19 +++
 arch/microblaze/include/asm/mmu_context.h |   21 +++
 arch/microblaze/include/asm/tlb.h         |   16 +++
 arch/microblaze/include/asm/tlbflush.h    |   20 +++
 arch/microblaze/mm/init.c                 |  197 +++++++++++++++++++++++++++++
 5 files changed, 273 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/include/asm/mmu.h
 create mode 100644 arch/microblaze/include/asm/mmu_context.h
 create mode 100644 arch/microblaze/include/asm/tlb.h
 create mode 100644 arch/microblaze/include/asm/tlbflush.h
 create mode 100644 arch/microblaze/mm/init.c

diff --git a/arch/microblaze/include/asm/mmu.h b/arch/microblaze/include/asm/mmu.h
new file mode 100644
index 0000000..0e0431d
--- /dev/null
+++ b/arch/microblaze/include/asm/mmu.h
@@ -0,0 +1,19 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_MMU_H
+#define _ASM_MICROBLAZE_MMU_H
+
+#ifndef __ASSEMBLY__
+typedef struct {
+	struct vm_list_struct	*vmlist;
+	unsigned long		end_brk;
+} mm_context_t;
+#endif /* __ASSEMBLY__ */
+
+#endif /* _ASM_MICROBLAZE_MMU_H */
diff --git a/arch/microblaze/include/asm/mmu_context.h b/arch/microblaze/include/asm/mmu_context.h
new file mode 100644
index 0000000..150ca01
--- /dev/null
+++ b/arch/microblaze/include/asm/mmu_context.h
@@ -0,0 +1,21 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_MMU_CONTEXT_H
+#define _ASM_MICROBLAZE_MMU_CONTEXT_H
+
+# define init_new_context(tsk, mm)		({ 0; })
+
+# define enter_lazy_tlb(mm, tsk)		do {} while (0)
+# define change_mm_context(old, ctx, _pml4)	do {} while (0)
+# define destroy_context(mm)			do {} while (0)
+# define deactivate_mm(tsk, mm)			do {} while (0)
+# define switch_mm(prev, next, tsk)		do {} while (0)
+# define activate_mm(prev, next)		do {} while (0)
+
+#endif /* _ASM_MICROBLAZE_MMU_CONTEXT_H */
diff --git a/arch/microblaze/include/asm/tlb.h b/arch/microblaze/include/asm/tlb.h
new file mode 100644
index 0000000..d1dfe37
--- /dev/null
+++ b/arch/microblaze/include/asm/tlb.h
@@ -0,0 +1,16 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_TLB_H
+#define _ASM_MICROBLAZE_TLB_H
+
+#define tlb_flush(tlb)	do {} while (0)
+
+#include <asm-generic/tlb.h>
+
+#endif /* _ASM_MICROBLAZE_TLB_H */
diff --git a/arch/microblaze/include/asm/tlbflush.h b/arch/microblaze/include/asm/tlbflush.h
new file mode 100644
index 0000000..d7fe762
--- /dev/null
+++ b/arch/microblaze/include/asm/tlbflush.h
@@ -0,0 +1,20 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_TLBFLUSH_H
+#define _ASM_MICROBLAZE_TLBFLUSH_H
+
+#define flush_tlb()				BUG()
+#define flush_tlb_all()				BUG()
+#define flush_tlb_mm(mm)			BUG()
+#define flush_tlb_page(vma, addr)		BUG()
+#define flush_tlb_range(mm, start, end)		BUG()
+#define flush_tlb_pgtables(mm, start, end)	BUG()
+#define flush_tlb_kernel_range(start, end)	BUG()
+
+#endif /* _ASM_MICROBLAZE_TLBFLUSH_H */
diff --git a/arch/microblaze/mm/init.c b/arch/microblaze/mm/init.c
new file mode 100644
index 0000000..430d85e
--- /dev/null
+++ b/arch/microblaze/mm/init.c
@@ -0,0 +1,197 @@
+/*
+ * Copyright (C) 2007-2008 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/bootmem.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/lmb.h>
+#include <linux/mm.h> /* mem_init */
+#include <linux/initrd.h>
+#include <linux/pagemap.h>
+#include <linux/pfn.h>
+#include <linux/swap.h>
+
+#include <asm/page.h>
+#include <asm/mmu_context.h>
+#include <asm/pgalloc.h>
+#include <asm/sections.h>
+#include <asm/tlb.h>
+
+unsigned int __page_offset;
+/* EXPORT_SYMBOL(__page_offset); */
+
+char *klimit = _end;
+
+/*
+ * Initialize the bootmem system and give it all the memory we
+ * have available.
+ */
+unsigned int memory_start;
+unsigned int memory_end; /* due to mm/nommu.c */
+unsigned int memory_size;
+
+/*
+ * paging_init() sets up the page tables - in fact we've already done this.
+ */
+static void __init paging_init(void)
+{
+	int i;
+	unsigned long zones_size[MAX_NR_ZONES];
+
+	/*
+	 * old: we can DMA to/from any address.put all page into ZONE_DMA
+	 * We use only ZONE_NORMAL
+	 */
+	zones_size[ZONE_NORMAL] = max_mapnr;
+
+	/* every other zones are empty */
+	for (i = 1; i < MAX_NR_ZONES; i++)
+		zones_size[i] = 0;
+
+	free_area_init(zones_size);
+}
+
+void __init setup_memory(void)
+{
+	int i;
+	unsigned long map_size;
+	u32 kernel_align_start, kernel_align_size;
+
+	/* Find main memory where is the kernel */
+	for (i = 0; i < lmb.memory.cnt; i++) {
+		memory_start = (u32) lmb.memory.region[i].base;
+		memory_end = (u32) lmb.memory.region[i].base + (u32) lmb.memory.region[i].size;
+		if ((memory_start <= (u32)_text) && ((u32)_text <= memory_end)) {
+			memory_size = memory_end - memory_start;
+			PAGE_OFFSET = memory_start;
+			printk("%s: Main mem: 0x%x-0x%x, size 0x%08x\n", __func__,
+				memory_start, memory_end, memory_size);
+			break;
+		}
+	}
+
+	if (!memory_start || !memory_end) {
+		panic("%s: Missing memory setting 0x%08x-0x%08x\n",
+			__func__, memory_start, memory_end);
+	}
+
+	/* reservation of region where is the kernel */
+	kernel_align_start = PAGE_DOWN((u32)_text);
+	/* ALIGN can be remove because _end in vmlinux.lds.S is align */
+	kernel_align_size = PAGE_UP((u32)klimit) - kernel_align_start;
+	lmb_reserve(kernel_align_start, kernel_align_size);
+	printk("%s: kernel addr=0x%08x-0x%08x size=0x%08x\n", __func__,
+		kernel_align_start, kernel_align_start + kernel_align_size,
+							kernel_align_size);
+
+	/*
+	 * Kernel:
+	 * start: base phys address of kernel - page align
+	 * end: base phys address of kernel - page align
+	 *
+	 * min_low_pfn - the first page (mm/bootmem.c - node_boot_start)
+	 * max_low_pfn
+	 * max_mapnr - the first unused page (mm/bootmem.c - node_low_pfn)
+	 * num_physpages - number of all pages
+	 */
+
+	/* memory start is from the kernel end of memory aligned to higher addr */
+	min_low_pfn = memory_start >> PAGE_SHIFT; /* minimum for allocation */
+	num_physpages = max_mapnr = memory_size >> PAGE_SHIFT; /* RAM is assumed contiguous */
+	max_pfn = max_low_pfn = memory_end >> PAGE_SHIFT;
+
+	printk(KERN_INFO "%s: max_mapnr: %#lx\n", __func__, max_mapnr);
+	printk(KERN_INFO "%s: min_low_pfn: %#lx\n", __func__, min_low_pfn);
+	printk(KERN_INFO "%s: max_low_pfn: %#lx\n", __func__, max_low_pfn);
+
+	/*
+	 * Find an area to use for the bootmem bitmap.
+	 * We look for the first area which is at least
+	 * 128kB in length (128kB is enough for a bitmap
+	 * for 4GB of memory, using 4kB pages), plus 1 page
+	 * (in case the address isn't page-aligned).
+	 */
+	map_size = init_bootmem_node(NODE_DATA(0), PFN_UP(TOPHYS((u32)_end)),
+					min_low_pfn, max_low_pfn);
+
+	lmb_reserve(PFN_UP(TOPHYS((u32)_end)) << PAGE_SHIFT, map_size);
+
+	/* free bootmem is whole main memory */
+	free_bootmem(memory_start, memory_size);
+
+	/* reserve allocate blocks */
+	for (i = 0; i < lmb.reserved.cnt; i++) {
+		pr_debug("reserved %d - 0x%08x-0x%08x\n", i,
+			(u32) lmb.reserved.region[i].base,
+			(u32) lmb_size_bytes(&lmb.reserved, i));
+		reserve_bootmem(lmb.reserved.region[i].base,
+			lmb_size_bytes(&lmb.reserved, i) - 1, BOOTMEM_DEFAULT);
+	}
+	paging_init();
+}
+
+void free_init_pages(char *what, unsigned long begin, unsigned long end)
+{
+	unsigned long addr;
+
+	for (addr = begin; addr < end; addr += PAGE_SIZE) {
+		ClearPageReserved(virt_to_page(addr));
+		init_page_count(virt_to_page(addr));
+		memset((void *)addr, 0xcc, PAGE_SIZE);
+		free_page(addr);
+		totalram_pages++;
+	}
+	printk(KERN_INFO "Freeing %s: %ldk freed\n", what, (end - begin) >> 10);
+}
+
+#ifdef CONFIG_BLK_DEV_INITRD
+void free_initrd_mem(unsigned long start, unsigned long end)
+{
+	int pages = 0;
+	for (; start < end; start += PAGE_SIZE) {
+		ClearPageReserved(virt_to_page(start));
+		init_page_count(virt_to_page(start));
+		free_page(start);
+		totalram_pages++;
+		pages++;
+	}
+	printk(KERN_NOTICE "Freeing initrd memory: %dk freed\n", pages);
+}
+#endif
+
+void free_initmem(void)
+{
+	free_init_pages("unused kernel memory",
+			(unsigned long)(&__init_begin),
+			(unsigned long)(&__init_end));
+}
+
+/* FIXME from arch/powerpc/mm/mem.c*/
+void show_mem(void)
+{
+	printk(KERN_NOTICE "%s\n", __func__);
+}
+
+void __init mem_init(void)
+{
+	high_memory = (void *)__va(memory_end);
+	/* this will put all memory onto the freelists */
+	totalram_pages += free_all_bootmem();
+
+	printk(KERN_INFO "Memory: %luk/%luk available\n",
+	       (unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
+	       num_physpages << (PAGE_SHIFT-10));
+}
+
+/* Check against bounds of physical memory */
+int ___range_ok(unsigned long addr, unsigned long size)
+{
+	return ((addr < memory_start) ||
+		((addr + size) > memory_end));
+}
-- 
1.5.5.1

