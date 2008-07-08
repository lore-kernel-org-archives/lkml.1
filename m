Return-Path: <linux-kernel-owner+w=401wt.eu-S1755241AbYGHMN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbYGHMN1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 08:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932108AbYGHMLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 08:11:03 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:26616 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758438AbYGHMK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 08:10:59 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: monstr@seznam.cz, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, vapier.adi@gmail.com,
       alan@lxorguk.ukuu.org.uk, hpa@zytor.com, lethal@linux-sh.org,
       florian@openwrt.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 29/58] microblaze_v5: memory inicialization, MMU, TLB
Date: Tue,  8 Jul 2008 13:59:29 +0200
Message-Id: <d4c1b3ecfec1bf37ca0ecea6909ad25bbc945630.1215517976.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <04b0b222b84ba9cfe2507a9081f4d715f2323733.1215517976.git.monstr@monstr.eu>
References: <1215518398-5057-1-git-send-email-monstr@monstr.eu>
 <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
 <c03d29cbccaef8aed8a2911c2a259fbd79ad23d9.1215517976.git.monstr@monstr.eu>
 <58f35f498bac29e7105c589c06567e86c5a42dd5.1215517976.git.monstr@monstr.eu>
 <810775b1bb678003923039726a9153ee34fb67b4.1215517976.git.monstr@monstr.eu>
 <2a24e5bc2cfbd349613ef10c716a28f04ce24a9f.1215517976.git.monstr@monstr.eu>
 <3171c5cf21eefc79665165f4a14bc5b68dd03f95.1215517976.git.monstr@monstr.eu>
 <9be4eff2f4d015023c453eaec3b3473a44380491.1215517976.git.monstr@monstr.eu>
 <f8e331ed9432719f3c0555c840cbbb7bbc1a6322.1215517976.git.monstr@monstr.eu>
 <4409daf2ac356e902a8f091bb5908eb8a90218bc.1215517976.git.monstr@monstr.eu>
 <f7458acb0252f72b5620d19c76104408ecc2e451.1215517976.git.monstr@monstr.eu>
 <dbd9df742cdd9eb3355d7bc8e39f9dfef6c545e4.1215517976.git.monstr@monstr.eu>
 <1f9a1f345caa749cb630cf85f95f217366395069.1215517976.git.monstr@monstr.eu>
 <fe3686f0f70d838b33642bcbcd7185fc2180b366.1215517976.git.monstr@monstr.eu>
 <e61f5a8579570cf7cd18a22e4106b7f85518928e.1215517976.git.monstr@monstr.eu>
 <59d7e0a5f38b8d38f01f357a071fc93eed36f3a8.1215517976.git.monstr@monstr.eu>
 <143afcf84af583ab66da7e8acfc9eb03b7f3eaa0.1215517976.git.monstr@monstr.eu>
 <a967ee4e5a60b410e2810ce0475e8fd04f99e3ae.1215517976.git.monstr@monstr.eu>
 <c5f0730287365c845746467a9917dbc07d2fca3c.1215517976.git.monstr@monstr.eu>
 <2aa1ac7891af57959237aae3addf4bbe607f55d7.1215517976.git.monstr@monstr.eu>
 <875ba2708f6cd3c585e4d965142e2feb07c39a0e.1215517976.git.monstr@monstr.eu>
 <eb0e741f891335df37c3cd19f1a3ce2f7ce8652a.1215517976.git.monstr@monstr.eu>
 <b28df2ea2419cbda26f9089ed6edcc175c009688.1215517976.git.monstr@monstr.eu>
 <5da1d8f069f18f14faee8c4bff736791179ef6f1.1215517976.git.monstr@monstr.eu>
 <9a32168fe72b772f301216a7090670474af78e49.1215517976.git.monstr@monstr.eu>
 <7ada4bceefc1806a2c8ef73676b7aabd8ac1cad6.1215517976.git.monstr@monstr.eu>
 <701c1dac442ac09f5010cb5356cc1a12bb0abfe1.1215517976.git.monstr@monstr.eu>
 <9b48e9d85b4a5a6dcffce8eef62b232b6bfac8e8.1215517976.git.monstr@monstr.eu>
 <04b0b222b84ba9cfe2507a9081f4d715f2323733.1215517976.git.monstr@monstr.eu>
In-Reply-To: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
References: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Acked-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/mm/init.c            |  183 ++++++++++++++++++++++++++++++++++
 include/asm-microblaze/mmu.h         |   17 +++
 include/asm-microblaze/mmu_context.h |   22 ++++
 include/asm-microblaze/tlb.h         |   16 +++
 include/asm-microblaze/tlbflush.h    |   20 ++++
 5 files changed, 258 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/mm/init.c
 create mode 100644 include/asm-microblaze/mmu.h
 create mode 100644 include/asm-microblaze/mmu_context.h
 create mode 100644 include/asm-microblaze/tlb.h
 create mode 100644 include/asm-microblaze/tlbflush.h

diff --git a/arch/microblaze/mm/init.c b/arch/microblaze/mm/init.c
new file mode 100644
index 0000000..c4da9da
--- /dev/null
+++ b/arch/microblaze/mm/init.c
@@ -0,0 +1,183 @@
+/*
+ * arch/microblaze/mm/init.c
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2007-2008 Michal Simek <monstr@monstr.eu>
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#undef DEBUG
+
+#include <linux/init.h>
+#include <linux/mm.h>
+//#include "../../../mm/internal.h"
+#include <linux/swap.h>
+#include <linux/bootmem.h>
+#include <linux/pfn.h>
+#include <linux/lmb.h>
+
+#include <asm/sections.h>
+#include <asm/uaccess.h>
+#include <asm/system.h>
+#include <asm/pgtable.h>
+
+char *klimit = _end;
+static unsigned int memory_start;
+unsigned int memory_end; /* due to mm/nommu.c */
+
+unsigned int __page_offset;
+/* EXPORT_SYMBOL(__page_offset); */
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
+	free_bootmem_node(NODE_DATA(0), start_pfn << PAGE_SHIFT,
+			((end_pfn - start_pfn) << PAGE_SHIFT) - 1);
+
+	/* reserve allocate blocks */
+	for (i = 0; i < lmb.reserved.cnt; i++) {
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
index 0000000..e9cd52d
--- /dev/null
+++ b/include/asm-microblaze/mmu.h
@@ -0,0 +1,17 @@
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
+typedef struct {
+	struct vm_list_struct	*vmlist;
+	unsigned long		end_brk;
+} mm_context_t;
+
+#endif /* _ASM_MICROBLAZE_MMU_H */
diff --git a/include/asm-microblaze/mmu_context.h b/include/asm-microblaze/mmu_context.h
new file mode 100644
index 0000000..bd4952a
--- /dev/null
+++ b/include/asm-microblaze/mmu_context.h
@@ -0,0 +1,22 @@
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
index 0000000..d1dfe37
--- /dev/null
+++ b/include/asm-microblaze/tlb.h
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
diff --git a/include/asm-microblaze/tlbflush.h b/include/asm-microblaze/tlbflush.h
new file mode 100644
index 0000000..d7fe762
--- /dev/null
+++ b/include/asm-microblaze/tlbflush.h
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
-- 
1.5.4.GIT

