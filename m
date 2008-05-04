Return-Path: <linux-kernel-owner+w=401wt.eu-S1758012AbYEEIMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758012AbYEEIMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 04:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbYEEIMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 04:12:38 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:33574 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753874AbYEEIMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 04:12:35 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH 28/56] microblaze_v2: memory inicialization, MMU, TLB
Date: Sun,  4 May 2008 13:41:17 +0200
Message-Id: <41c1f410eaafd875246362d10ef9866d8cc2a934.1209897266.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <598221ce2159046614d7b158ea62d5af51907af3.1209897266.git.monstr@monstr.eu>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>
 <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
 <c805caeb1dd7f6d1349c4a463cb88a5342a170d2.1209897266.git.monstr@monstr.eu>
 <f120ababf2bade9aab7199bffb3014aa606e5a1c.1209897266.git.monstr@monstr.eu>
 <684c36e5ad3f598e5079e88ec195545c4a7150c2.1209897266.git.monstr@monstr.eu>
 <ed3695121faf485d491cecdd96d5d4dcc498411d.1209897266.git.monstr@monstr.eu>
 <0674b1f7abb9a3d564b68c95bc28adc2c2fe9551.1209897266.git.monstr@monstr.eu>
 <9a7c6646e5dd9724c1cf34767adec181481fa3ef.1209897266.git.monstr@monstr.eu>
 <932956128c9c655a218a940eaf02017a5dd0bdf9.1209897266.git.monstr@monstr.eu>
 <2f801c33caee22e112af51ae927c264ce99ead01.1209897266.git.monstr@monstr.eu>
 <2391e49379fb6639f57d9d6e5811f3d49a4c6fda.1209897266.git.monstr@monstr.eu>
 <0873f3a1f3b72591735c6461b51964693cac52e5.1209897266.git.monstr@monstr.eu>
 <0ba1f259d3c17eba54e334622493577493f5065f.1209897266.git.monstr@monstr.eu>
 <694451053534fea7b78fb9d618b53a2b5ebeb602.1209897266.git.monstr@monstr.eu>
 <f0c837df4106a31c1a81917596603918f722ea7b.1209897266.git.monstr@monstr.eu>
 <d883a8d8da812d77fefd47730d28d0bdb7b504e0.1209897266.git.monstr@monstr.eu>
 <625ef466cf121d655539eedc919dd39166087e0c.1209897266.git.monstr@monstr.eu>
 <b5067a1846075ddd1035966ea1edc908579e2e88.1209897266.git.monstr@monstr.eu>
 <378157891bac535dbc55e658d5f03fdd332e85cf.1209897266.git.monstr@monstr.eu>
 <eadcc6f4754df78b69d6d54c404624d0390c8558.1209897266.git.monstr@monstr.eu>
 <4df4022e06b9056202cc2fdf0b99deb01563a0fa.1209897266.git.monstr@monstr.eu>
 <6b0c9864dc80776ae48d6488a6892e5d698751b7.1209897266.git.monstr@monstr.eu>
 <ea5cbbca49c38c506960fddba29cbd8cb24e1a8d.1209897266.git.monstr@monstr.eu>
 <4f4d6ed3fce9b21cdd6dcacb2d72fff7e9830628.1209897266.git.monstr@monstr.eu>
 <35e662a81eb86c7ffb2aaa6141ca38a07789f382.1209897266.git.monstr@monstr.eu>
 <b41fcf3dd830f4ba82692a9bec2406ed0c290e7e.1209897266.git.monstr@monstr.eu>
 <14acb31da2794d2d5916da3db3d75fe2285ac055.1209897266.git.monstr@monstr.eu>
 <598221ce2159046614d7b158ea62d5af51907af3.1209897266.git.monstr@monstr.eu>
In-Reply-To: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/mm/init.c            |  184 ++++++++++++++++++++++++++++++++++
 include/asm-microblaze/mmu.h         |   19 ++++
 include/asm-microblaze/mmu_context.h |   24 +++++
 include/asm-microblaze/tlb.h         |   18 ++++
 include/asm-microblaze/tlbflush.h    |   22 ++++
 5 files changed, 267 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/mm/init.c
 create mode 100644 include/asm-microblaze/mmu.h
 create mode 100644 include/asm-microblaze/mmu_context.h
 create mode 100644 include/asm-microblaze/tlb.h
 create mode 100644 include/asm-microblaze/tlbflush.h

diff --git a/arch/microblaze/mm/init.c b/arch/microblaze/mm/init.c
new file mode 100644
index 0000000..d3c042a
--- /dev/null
+++ b/arch/microblaze/mm/init.c
@@ -0,0 +1,184 @@
+/*
+ * arch/microblaze/mm/init.c
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2007 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#include <linux/autoconf.h>
+#include <linux/init.h>
+#include <linux/mm.h>
+#include "../../../mm/internal.h"
+#include <linux/swap.h>
+#include <linux/bootmem.h>
+#include <linux/pfn.h>
+#include <asm/sections.h>
+
+#include <asm/lmb.h>
+#include <asm/uaccess.h>
+#include <asm/system.h>
+#include <asm/pgtable.h>
+
+#undef DEBUG
+
+char *klimit = _end;
+static unsigned int memory_start;
+static unsigned int memory_end;
+
+unsigned int __page_offset;
+EXPORT_SYMBOL(__page_offset);
+
+void __init setup_memory(void)
+{
+	int i;
+	unsigned int start, end;
+	unsigned long map_size;
+	unsigned long start_pfn = 0;
+	unsigned long end_pfn = 0;
+
+	/* Find main memory where is the kernel */
+	for (i = 0; i < lmb.memory.cnt; i++) {
+		start_pfn = lmb.memory.region[i].base >> PAGE_SHIFT;
+		end_pfn = start_pfn + lmb_size_pages(&lmb.memory, i);
+		if ((start_pfn <= (((int)_text) >> PAGE_SHIFT)) &&
+			(((int)_text >> PAGE_SHIFT) <= end_pfn)) {
+			memory_end = (end_pfn << PAGE_SHIFT) - 1;
+			PAGE_OFFSET = memory_start = start_pfn << PAGE_SHIFT;
+			pr_debug("%s: Main mem: 0x%x-0x%x\n", __func__,
+				memory_start, memory_end);
+			break;
+		}
+	}
+	/*
+	 * start_pfn - start page - starting point
+	 * end_pfn - first unused page
+	 * memory_start - base physical address of main memory
+	 * memory_end - end physical address of main memory
+	 * PAGE_OFFSET - moving of first page
+	 *
+	 * Kernel:
+	 * start: base phys address of kernel - page align
+	 * end: base phys address of kernel - page align
+	 *
+	 * min_low_pfn - the first page (mm/bootmem.c - node_boot_start)
+	 * max_low_pfn
+	 * max_mapnr - the first unused page (mm/bootmem.c - node_low_pfn)
+	 * num_physpages - number of all pages
+	 *
+	 */
+
+	/* reservation of region where is the kernel */
+	start = PFN_DOWN((int)_text) << PAGE_SHIFT;
+	end = PAGE_ALIGN((unsigned long)klimit);
+	lmb_reserve(start, end - start);
+	pr_debug("%s: kernel addr 0x%08x-0x%08x\n", __func__, start, end);
+
+	/* calculate free pages, etc. */
+	min_low_pfn = PFN_UP(start_pfn << PAGE_SHIFT);
+	max_mapnr = PFN_DOWN((end_pfn << PAGE_SHIFT));
+	max_low_pfn = max_mapnr - min_low_pfn;
+	num_physpages = max_mapnr - min_low_pfn + 1;
+	printk(KERN_INFO "%s: max_mapnr: %#lx\n", __func__, max_mapnr);
+	printk(KERN_INFO "%s: min_low_pfn: %#lx\n", __func__, min_low_pfn);
+	printk(KERN_INFO "%s: max_low_pfn: %#lx\n", __func__, max_low_pfn);
+
+	/* add place for data pages */
+	map_size = init_bootmem_node(NODE_DATA(0), PFN_UP(end),
+			min_low_pfn, max_mapnr);
+	lmb_reserve(PFN_UP(end) << PAGE_SHIFT, map_size);
+
+	/* free bootmem is whole main memory */
+	free_bootmem(start_pfn << PAGE_SHIFT,
+			((end_pfn - start_pfn) << PAGE_SHIFT) - 1);
+
+	/* reserve allocate blocks */
+	for (i = 1; i < lmb.reserved.cnt; i++) {
+		pr_debug("reserved %d - 0x%08x-0x%08x\n", i,
+			(u32) lmb.reserved.region[i].base,
+			(u32) lmb_size_bytes(&lmb.reserved, i));
+		reserve_bootmem(lmb.reserved.region[i].base,
+			lmb_size_bytes(&lmb.reserved, i) - 1, BOOTMEM_DEFAULT);
+	}
+}
+
+void __init paging_init(void)
+{
+	int i;
+	unsigned long zones_size[MAX_NR_ZONES];
+
+	/* we can DMA to/from any address.  put all page into
+	 * ZONE_DMA. */
+	zones_size[ZONE_NORMAL] = max_low_pfn;
+
+	/* every other zones are empty */
+	for (i = 1; i < MAX_NR_ZONES; i++)
+		zones_size[i] = 0;
+
+	free_area_init_node(0, NODE_DATA(0), zones_size,
+		NODE_DATA(0)->bdata->node_boot_start >> PAGE_SHIFT, NULL);
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
+		set_page_count(virt_to_page(start), 1);
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
+	high_memory = (void *)(memory_end);
+
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
+		((addr + size) >= memory_end));
+}
diff --git a/include/asm-microblaze/mmu.h b/include/asm-microblaze/mmu.h
new file mode 100644
index 0000000..f1e158f
--- /dev/null
+++ b/include/asm-microblaze/mmu.h
@@ -0,0 +1,19 @@
+/*
+ * include/asm-microblaze/mmu.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_MICROBLAZE_MMU_H
+#define _ASM_MICROBLAZE_MMU_H
+
+typedef struct {
+	struct vm_list_struct	*vmlist;
+	unsigned long		end_brk;
+} mm_context_t;
+
+#endif /* _ASM_MICROBLAZE_MMU_H */
diff --git a/include/asm-microblaze/mmu_context.h b/include/asm-microblaze/mmu_context.h
new file mode 100644
index 0000000..f5433c7
--- /dev/null
+++ b/include/asm-microblaze/mmu_context.h
@@ -0,0 +1,24 @@
+/*
+ * include/asm-microblaze/mmu_context.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_MICROBLAZE_MMU_CONTEXT_H
+#define _ASM_MICROBLAZE_MMU_CONTEXT_H
+
+#define init_new_context(tsk, mm)		({ 0; })
+
+#define enter_lazy_tlb(mm, tsk)			do {} while (0)
+#define change_mm_context(old, ctx, _pml4)	do {} while (0)
+#define destroy_context(mm)			do {} while (0)
+#define deactivate_mm(tsk, mm)			do {} while (0)
+#define switch_mm(prev, next, tsk)		do {} while (0)
+#define activate_mm(prev, next)			do {} while (0)
+
+
+#endif /* _ASM_MICROBLAZE_MMU_CONTEXT_H */
diff --git a/include/asm-microblaze/tlb.h b/include/asm-microblaze/tlb.h
new file mode 100644
index 0000000..60c4df6
--- /dev/null
+++ b/include/asm-microblaze/tlb.h
@@ -0,0 +1,18 @@
+/*
+ * include/asm-microblaze/tlb.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
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
diff --git a/include/asm-microblaze/tlbflush.h b/include/asm-microblaze/tlbflush.h
new file mode 100644
index 0000000..e1b4f6b
--- /dev/null
+++ b/include/asm-microblaze/tlbflush.h
@@ -0,0 +1,22 @@
+/*
+ * include/asm-microblaze/tlbflush.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
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
-- 
1.5.4.GIT

