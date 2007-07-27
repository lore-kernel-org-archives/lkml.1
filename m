Return-Path: <linux-kernel-owner+w=401wt.eu-S936982AbXG0Juz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936982AbXG0Juz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 05:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936463AbXG0Jqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 05:46:48 -0400
Received: from sicnat3.emn.fr ([193.54.76.194]:36128 "EHLO ron.emn.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935649AbXG0Jqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 05:46:45 -0400
Date: Fri, 27 Jul 2007 11:45:22 +0200 (MEST)
Message-Id: <200707270945.LAA17278@ifs.emn.fr>
To: kernel-janitors@vger.kernel.org
Subject: [PATCH 13/68] 0 -> NULL, for arch/ppc
Cc: paulus@samba.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
From: Yoann Padioleau <padator@wanadoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When comparing a pointer, it's clearer to compare it to NULL than to 0.

Here is an excerpt of the semantic patch: 

@@
expression *E;
@@

  E ==
- 0
+ NULL

@@
expression *E;
@@

  E !=
- 0
+ NULL

Signed-off-by: Yoann Padioleau <padator@wanadoo.fr>
Cc: paulus@samba.org
Cc: akpm@linux-foundation.org
---

 8xx_io/commproc.c  |    2 +-
 kernel/pci.c       |    6 +++---
 mm/init.c          |    4 ++--
 mm/mmu_decl.h      |    2 +-
 mm/pgtable.c       |    4 ++--
 mm/tlb.c           |   12 ++++++------
 syslib/btext.c     |    4 ++--
 syslib/open_pic.c  |   14 +++++++-------
 syslib/open_pic2.c |   14 +++++++-------
 xmon/xmon.c        |    4 ++--
 10 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/arch/ppc/8xx_io/commproc.c b/arch/ppc/8xx_io/commproc.c
index 7088428..e1e0084 100644
--- a/arch/ppc/8xx_io/commproc.c
+++ b/arch/ppc/8xx_io/commproc.c
@@ -293,7 +293,7 @@ cpm_install_handler(int cpm_vec, void (*
 		return;
 	}
 
-	if (cpm_vecs[cpm_vec].handler != 0)
+	if (cpm_vecs[cpm_vec].handler != NULL)
 		printk(KERN_INFO "CPM interrupt %x replacing %x\n",
 			(uint)handler, (uint)cpm_vecs[cpm_vec].handler);
 	cpm_vecs[cpm_vec].handler = handler;
diff --git a/arch/ppc/kernel/pci.c b/arch/ppc/kernel/pci.c
index c2ec13b..124b0a2 100644
--- a/arch/ppc/kernel/pci.c
+++ b/arch/ppc/kernel/pci.c
@@ -880,7 +880,7 @@ static struct resource *__pci_mmap_make_
 	unsigned long io_offset = 0;
 	int i, res_bit;
 
-	if (hose == 0)
+	if (hose == NULL)
 		return NULL;		/* should never happen */
 
 	/* If memory, add on the PCI bridge address offset */
@@ -1261,9 +1261,9 @@ fake_pci_bus(struct pci_controller *hose
 {
 	static struct pci_bus bus;
 
-	if (hose == 0) {
+	if (hose == NULL) {
 		hose = pci_bus_to_hose(busnr);
-		if (hose == 0)
+		if (hose == NULL)
 			printk(KERN_ERR "Can't find hose for PCI bus %d!\n", busnr);
 	}
 	bus.number = busnr;
diff --git a/arch/ppc/mm/init.c b/arch/ppc/mm/init.c
index 390dd19..a805f94 100644
--- a/arch/ppc/mm/init.c
+++ b/arch/ppc/mm/init.c
@@ -197,7 +197,7 @@ void MMU_setup(void)
 		char *p, *q;
 		unsigned long maxmem = 0;
 
-		for (q = cmd_line; (p = strstr(q, "mem=")) != 0; ) {
+		for (q = cmd_line; (p = strstr(q, "mem=")) != NULL; ) {
 			q = p + 4;
 			if (p > cmd_line && p[-1] != ' ')
 				continue;
@@ -575,7 +575,7 @@ #endif
 
 #ifdef CONFIG_PPC_STD_MMU
 	/* We only want HPTEs for linux PTEs that have _PAGE_ACCESSED set */
-	if (Hash != 0 && pte_young(pte)) {
+	if (Hash != NULL && pte_young(pte)) {
 		struct mm_struct *mm;
 		pmd_t *pmd;
 
diff --git a/arch/ppc/mm/mmu_decl.h b/arch/ppc/mm/mmu_decl.h
index 540f329..0ff8967 100644
--- a/arch/ppc/mm/mmu_decl.h
+++ b/arch/ppc/mm/mmu_decl.h
@@ -76,7 +76,7 @@ extern unsigned long mmu_mapin_ram(void)
 static inline void flush_HPTE(unsigned context, unsigned long va,
 			      unsigned long pdval)
 {
-	if ((Hash != 0) &&
+	if ((Hash != NULL) &&
 	    cpu_has_feature(CPU_FTR_HPTE_TABLE))
 		flush_hash_pages(0, va, pdval, 1);
 	else
diff --git a/arch/ppc/mm/pgtable.c b/arch/ppc/mm/pgtable.c
index 35ebb63..1ce8c56 100644
--- a/arch/ppc/mm/pgtable.c
+++ b/arch/ppc/mm/pgtable.c
@@ -219,7 +219,7 @@ __ioremap(phys_addr_t addr, unsigned lon
 	if (mem_init_done) {
 		struct vm_struct *area;
 		area = get_vm_area(size, VM_IOREMAP);
-		if (area == 0)
+		if (area == NULL)
 			return NULL;
 		v = (unsigned long) area->addr;
 	} else {
@@ -283,7 +283,7 @@ map_page(unsigned long va, phys_addr_t p
 	pd = pmd_offset(pgd_offset_k(va), va);
 	/* Use middle 10 bits of VA to index the second-level map */
 	pg = pte_alloc_kernel(pd, va);
-	if (pg != 0) {
+	if (pg != NULL) {
 		err = 0;
 		set_pte_at(&init_mm, va, pg, pfn_pte(pa >> PAGE_SHIFT, __pgprot(flags)));
 		if (mem_init_done)
diff --git a/arch/ppc/mm/tlb.c b/arch/ppc/mm/tlb.c
index 4ff260b..d4b68bd 100644
--- a/arch/ppc/mm/tlb.c
+++ b/arch/ppc/mm/tlb.c
@@ -40,7 +40,7 @@ void flush_hash_entry(struct mm_struct *
 {
 	unsigned long ptephys;
 
-	if (Hash != 0) {
+	if (Hash != NULL) {
 		ptephys = __pa(ptep) & PAGE_MASK;
 		flush_hash_pages(mm->context.id, addr, ptephys, 1);
 	}
@@ -52,7 +52,7 @@ void flush_hash_entry(struct mm_struct *
  */
 void flush_tlb_page_nohash(struct vm_area_struct *vma, unsigned long addr)
 {
-	if (Hash != 0)
+	if (Hash != NULL)
 		return;
 	_tlbie(addr);
 }
@@ -63,7 +63,7 @@ void flush_tlb_page_nohash(struct vm_are
  */
 void tlb_flush(struct mmu_gather *tlb)
 {
-	if (Hash == 0) {
+	if (Hash == NULL) {
 		/*
 		 * 603 needs to flush the whole TLB here since
 		 * it doesn't use a hash table.
@@ -104,7 +104,7 @@ static void flush_range(struct mm_struct
 	int count;
 	unsigned int ctx = mm->context.id;
 
-	if (Hash == 0) {
+	if (Hash == NULL) {
 		_tlbia();
 		return;
 	}
@@ -144,7 +144,7 @@ void flush_tlb_mm(struct mm_struct *mm)
 {
 	struct vm_area_struct *mp;
 
-	if (Hash == 0) {
+	if (Hash == NULL) {
 		_tlbia();
 		return;
 	}
@@ -159,7 +159,7 @@ void flush_tlb_page(struct vm_area_struc
 	struct mm_struct *mm;
 	pmd_t *pmd;
 
-	if (Hash == 0) {
+	if (Hash == NULL) {
 		_tlbie(vmaddr);
 		return;
 	}
diff --git a/arch/ppc/syslib/btext.c b/arch/ppc/syslib/btext.c
index d116670..6ce05f8 100644
--- a/arch/ppc/syslib/btext.c
+++ b/arch/ppc/syslib/btext.c
@@ -202,7 +202,7 @@ map_boot_text(void)
 	size = bi->dispDeviceRowBytes * bi->dispDeviceRect[3] + offset
 		+ bi->dispDeviceRect[0];
 	vbase = ioremap(base, size);
-	if (vbase == 0)
+	if (vbase == NULL)
 		return;
 	bi->logicalDisplayBase = vbase + offset;
 	boot_text_mapped = 1;
@@ -215,7 +215,7 @@ calc_base(boot_infos_t *bi, int x, int y
 	unsigned char *base;
 
 	base = bi->logicalDisplayBase;
-	if (base == 0)
+	if (base == NULL)
 		base = bi->dispDeviceBase;
 	base += (x + bi->dispDeviceRect[0]) * (bi->dispDeviceDepth >> 3);
 	base += (y + bi->dispDeviceRect[1]) * bi->dispDeviceRowBytes;
diff --git a/arch/ppc/syslib/open_pic.c b/arch/ppc/syslib/open_pic.c
index 18ec947..f9bf2d6 100644
--- a/arch/ppc/syslib/open_pic.c
+++ b/arch/ppc/syslib/open_pic.c
@@ -142,7 +142,7 @@ #define check_arg_pri(pri) \
  */
 #define check_arg_irq(irq) \
     if (irq < open_pic_irq_offset || irq >= NumSources+open_pic_irq_offset \
-	|| ISR[irq - open_pic_irq_offset] == 0) { \
+	|| ISR[irq - open_pic_irq_offset] == NULL) { \
       printk("open_pic.c:%d: invalid irq %d\n", __LINE__, irq); \
       dump_stack(); }
 #define check_arg_cpu(cpu) \
@@ -290,7 +290,7 @@ void __init openpic_set_sources(int firs
 	last_irq = first_irq + num_irqs;
 	if (last_irq > NumSources)
 		NumSources = last_irq;
-	if (src == 0)
+	if (src == NULL)
 		src = &((struct OpenPIC __iomem *)OpenPIC_Addr)->Source[first_irq];
 	for (i = first_irq; i < last_irq; ++i, ++src)
 		ISR[i] = src;
@@ -385,7 +385,7 @@ #endif
 	for (i = 0; i < NumSources; i++) {
 		int sense;
 
-		if (ISR[i] == 0)
+		if (ISR[i] == NULL)
 			continue;
 
 		/* the bootloader may have left it enabled (bad !) */
@@ -791,7 +791,7 @@ openpic_initirq(u_int irq, u_int pri, u_
  */
 static void openpic_mapirq(u_int irq, cpumask_t physmask, cpumask_t keepmask)
 {
-	if (ISR[irq] == 0)
+	if (ISR[irq] == NULL)
 		return;
 	if (!cpus_empty(keepmask)) {
 		cpumask_t irqdest = { .bits[0] = openpic_read(&ISR[irq]->Destination) };
@@ -809,7 +809,7 @@ #ifdef notused
  */
 static void openpic_set_sense(u_int irq, int sense)
 {
-	if (ISR[irq] != 0)
+	if (ISR[irq] != NULL)
 		openpic_safe_writefield(&ISR[irq]->Vector_Priority,
 					OPENPIC_SENSE_LEVEL,
 					(sense ? OPENPIC_SENSE_LEVEL : 0));
@@ -974,7 +974,7 @@ int openpic_suspend(struct sys_device *s
 	for (i=0; i<OPENPIC_NUM_IPI; i++)
 		save_ipi_vp[i] = openpic_read(&OpenPIC->Global.IPI_Vector_Priority(i));
 	for (i=0; i<NumSources; i++) {
-		if (ISR[i] == 0)
+		if (ISR[i] == NULL)
 			continue;
 		save_irq_src_vp[i] = openpic_read(&ISR[i]->Vector_Priority) & ~OPENPIC_ACTIVITY;
 		save_irq_src_dest[i] = openpic_read(&ISR[i]->Destination);
@@ -1016,7 +1016,7 @@ int openpic_resume(struct sys_device *sy
 		openpic_write(&OpenPIC->Global.IPI_Vector_Priority(i),
 			      save_ipi_vp[i]);
 	for (i=0; i<NumSources; i++) {
-		if (ISR[i] == 0)
+		if (ISR[i] == NULL)
 			continue;
 		openpic_write(&ISR[i]->Destination, save_irq_src_dest[i]);
 		openpic_write(&ISR[i]->Vector_Priority, save_irq_src_vp[i]);
diff --git a/arch/ppc/syslib/open_pic2.c b/arch/ppc/syslib/open_pic2.c
index d585207..4028c78 100644
--- a/arch/ppc/syslib/open_pic2.c
+++ b/arch/ppc/syslib/open_pic2.c
@@ -115,7 +115,7 @@ #define check_arg_pri(pri) \
 extern unsigned long* _get_SP(void);
 #define check_arg_irq(irq) \
     if (irq < open_pic2_irq_offset || irq >= NumSources+open_pic2_irq_offset \
-	|| ISR[irq - open_pic2_irq_offset] == 0) { \
+	|| ISR[irq - open_pic2_irq_offset] == NULL) { \
       printk("open_pic.c:%d: illegal irq %d\n", __LINE__, irq); \
       /*print_backtrace(_get_SP());*/ }
 #define check_arg_cpu(cpu) \
@@ -192,7 +192,7 @@ void __init openpic2_set_sources(int fir
 	last_irq = first_irq + num_irqs;
 	if (last_irq > NumSources)
 		NumSources = last_irq;
-	if (src == 0)
+	if (src == NULL)
 		src = &((struct OpenPIC *)OpenPIC2_Addr)->Source[first_irq];
 	for (i = first_irq; i < last_irq; ++i, ++src)
 		ISR[i] = src;
@@ -268,7 +268,7 @@ void __init openpic2_init(int offset)
 	for (i = 0; i < NumSources; i++) {
 		int sense;
 
-		if (ISR[i] == 0)
+		if (ISR[i] == NULL)
 			continue;
 
 		/* the bootloader may have left it enabled (bad !) */
@@ -491,7 +491,7 @@ openpic2_initirq(u_int irq, u_int pri, u
  */
 static void openpic2_mapirq(u_int irq, u_int physmask, u_int keepmask)
 {
-	if (ISR[irq] == 0)
+	if (ISR[irq] == NULL)
 		return;
 	if (keepmask != 0)
 		physmask |= openpic2_read(&ISR[irq]->Destination) & keepmask;
@@ -506,7 +506,7 @@ #ifdef notused
  */
 static void openpic2_set_sense(u_int irq, int sense)
 {
-	if (ISR[irq] != 0)
+	if (ISR[irq] != NULL)
 		openpic2_safe_writefield(&ISR[irq]->Vector_Priority,
 					OPENPIC_SENSE_LEVEL,
 					(sense ? OPENPIC_SENSE_LEVEL : 0));
@@ -596,7 +596,7 @@ int openpic2_suspend(struct sys_device *
 	for (i=0; i<OPENPIC_NUM_IPI; i++)
 		save_ipi_vp[i] = openpic2_read(&OpenPIC2->Global.IPI_Vector_Priority(i));
 	for (i=0; i<NumSources; i++) {
-		if (ISR[i] == 0)
+		if (ISR[i] == NULL)
 			continue;
 		save_irq_src_vp[i] = openpic2_read(&ISR[i]->Vector_Priority) & ~OPENPIC_ACTIVITY;
 		save_irq_src_dest[i] = openpic2_read(&ISR[i]->Destination);
@@ -640,7 +640,7 @@ int openpic2_resume(struct sys_device *s
 		openpic2_write(&OpenPIC2->Global.IPI_Vector_Priority(i),
 			      save_ipi_vp[i]);
 	for (i=0; i<NumSources; i++) {
-		if (ISR[i] == 0)
+		if (ISR[i] == NULL)
 			continue;
 		openpic2_write(&ISR[i]->Destination, save_irq_src_dest[i]);
 		openpic2_write(&ISR[i]->Vector_Priority, save_irq_src_vp[i]);
diff --git a/arch/ppc/xmon/xmon.c b/arch/ppc/xmon/xmon.c
index b1a9174..068c064 100644
--- a/arch/ppc/xmon/xmon.c
+++ b/arch/ppc/xmon/xmon.c
@@ -737,7 +737,7 @@ #endif
 			printf("All breakpoints cleared\n");
 		} else {
 			bp = at_breakpoint(a);
-			if (bp == 0) {
+			if (bp == NULL) {
 				printf("No breakpoint at %x\n", a);
 			} else {
 				bp->enabled = 0;
@@ -770,7 +770,7 @@ #endif
 			break;
 		}
 		bp = at_breakpoint(a);
-		if (bp == 0) {
+		if (bp == NULL) {
 			for (bp = bpts; bp < &bpts[NBPTS]; ++bp)
 				if (!bp->enabled)
 					break;

