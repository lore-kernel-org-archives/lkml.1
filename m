Return-Path: <linux-kernel-owner+w=401wt.eu-S964979AbXG0Ju3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964979AbXG0Ju3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 05:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936449AbXG0Jqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 05:46:46 -0400
Received: from sicnat3.emn.fr ([193.54.76.194]:36110 "EHLO ron.emn.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935952AbXG0Jql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 05:46:41 -0400
Date: Fri, 27 Jul 2007 11:45:16 +0200 (MEST)
Message-Id: <200707270945.LAA17267@ifs.emn.fr>
To: kernel-janitors@vger.kernel.org
Subject: [PATCH 12/68] 0 -> NULL, for arch/powerpc
Cc: paulus@samba.org, linuxppc-dev@ozlabs.org, benh@kernel.crashing.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
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
Cc: linuxppc-dev@ozlabs.org
Cc: benh@kernel.crashing.org
Cc: akpm@linux-foundation.org
---

 boot/prpmc2800.c                |    2 +-
 kernel/btext.c                  |    8 ++++----
 kernel/legacy_serial.c          |    2 +-
 kernel/pci-common.c             |    2 +-
 kernel/pci_32.c                 |    8 ++++----
 kernel/prom.c                   |    4 ++--
 kernel/setup_64.c               |    4 ++--
 kernel/signal_64.c              |    4 ++--
 mm/mmu_decl.h                   |    2 +-
 mm/pgtable_32.c                 |    4 ++--
 mm/ppc_mmu_32.c                 |    2 +-
 mm/tlb_32.c                     |   12 ++++++------
 platforms/52xx/lite5200.c       |    2 +-
 platforms/83xx/mpc832x_mds.c    |    2 +-
 platforms/83xx/mpc836x_mds.c    |    2 +-
 platforms/85xx/mpc85xx_ads.c    |    4 ++--
 platforms/85xx/mpc85xx_cds.c    |    4 ++--
 platforms/86xx/mpc86xx_hpcn.c   |    4 ++--
 platforms/8xx/mpc86xads_setup.c |    4 ++--
 platforms/8xx/mpc885ads_setup.c |    4 ++--
 platforms/maple/pci.c           |    2 +-
 platforms/maple/setup.c         |    2 +-
 platforms/powermac/pci.c        |    2 +-
 platforms/powermac/pfunc_core.c |    2 +-
 platforms/powermac/setup.c      |    6 +++---
 platforms/powermac/time.c       |    6 +++---
 platforms/pseries/setup.c       |    2 +-
 sysdev/qe_lib/qe_io.c           |    2 +-
 xmon/spu-dis.c                  |   18 +++++++++---------
 xmon/xmon.c                     |    4 ++--
 30 files changed, 63 insertions(+), 63 deletions(-)

diff --git a/arch/powerpc/boot/prpmc2800.c b/arch/powerpc/boot/prpmc2800.c
index f428bac..b130e5b 100644
--- a/arch/powerpc/boot/prpmc2800.c
+++ b/arch/powerpc/boot/prpmc2800.c
@@ -480,7 +480,7 @@ static void prpmc2800_reset(void)
 
 	udelay(5000000);
 
-	if (bridge_base != 0) {
+	if (bridge_base != NULL) {
 		temp = in_le32((u32 *)(bridge_base + MV64x60_MPP_CNTL_0));
 		temp &= 0xFFFF0FFF;
 		out_le32((u32 *)(bridge_base + MV64x60_MPP_CNTL_0), temp);
diff --git a/arch/powerpc/kernel/btext.c b/arch/powerpc/kernel/btext.c
index e7b6846..6d9b68b 100644
--- a/arch/powerpc/kernel/btext.c
+++ b/arch/powerpc/kernel/btext.c
@@ -142,14 +142,14 @@ static void map_boot_text(void)
 
 	/* By default, we are no longer mapped */
 	boot_text_mapped = 0;
-	if (dispDeviceBase == 0)
+	if (dispDeviceBase == NULL)
 		return;
 	base = ((unsigned long) dispDeviceBase) & 0xFFFFF000UL;
 	offset = ((unsigned long) dispDeviceBase) - base;
 	size = dispDeviceRowBytes * dispDeviceRect[3] + offset
 		+ dispDeviceRect[0];
 	vbase = __ioremap(base, size, _PAGE_NO_CACHE);
-	if (vbase == 0)
+	if (vbase == NULL)
 		return;
 	logicalDisplayBase = vbase + offset;
 	boot_text_mapped = 1;
@@ -253,7 +253,7 @@ static unsigned char * calc_base(int x, 
 	unsigned char *base;
 
 	base = logicalDisplayBase;
-	if (base == 0)
+	if (base == NULL)
 		base = dispDeviceBase;
 	base += (x + dispDeviceRect[0]) * (dispDeviceDepth >> 3);
 	base += (y + dispDeviceRect[1]) * dispDeviceRowBytes;
@@ -264,7 +264,7 @@ static unsigned char * calc_base(int x, 
 void btext_update_display(unsigned long phys, int width, int height,
 			  int depth, int pitch)
 {
-	if (dispDeviceBase == 0)
+	if (dispDeviceBase == NULL)
 		return;
 
 	/* check it's the same frame buffer (within 256MB) */
diff --git a/arch/powerpc/kernel/legacy_serial.c b/arch/powerpc/kernel/legacy_serial.c
index cea8045..330bd21 100644
--- a/arch/powerpc/kernel/legacy_serial.c
+++ b/arch/powerpc/kernel/legacy_serial.c
@@ -67,7 +67,7 @@ static int __init add_legacy_port(struct
 		legacy_serial_count = index + 1;
 
 	/* Check if there is a port who already claimed our slot */
-	if (legacy_serial_infos[index].np != 0) {
+	if (legacy_serial_infos[index].np != NULL) {
 		/* if we still have some room, move it, else override */
 		if (legacy_serial_count < MAX_LEGACY_SERIAL_PORTS) {
 			printk(KERN_DEBUG "Moved legacy port %d -> %d\n",
diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index fe7d125..5fa0be3 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -256,7 +256,7 @@ static struct resource *__pci_mmap_make_
 	unsigned long io_offset = 0;
 	int i, res_bit;
 
-	if (hose == 0)
+	if (hose == NULL)
 		return NULL;		/* should never happen */
 
 	/* If memory, add on the PCI bridge address offset */
diff --git a/arch/powerpc/kernel/pci_32.c b/arch/powerpc/kernel/pci_32.c
index 721a694..4edefa6 100644
--- a/arch/powerpc/kernel/pci_32.c
+++ b/arch/powerpc/kernel/pci_32.c
@@ -598,7 +598,7 @@ make_one_node_map(struct device_node* no
 	} else
 		pci_to_OF_bus_map[pci_bus] = bus_range[0];
 
-	for (node=node->child; node != 0;node = node->sibling) {
+	for (node=node->child; node != NULL;node = node->sibling) {
 		struct pci_dev* dev;
 		const unsigned int *class_code, *reg;
 	
@@ -671,7 +671,7 @@ scan_OF_pci_childs(struct device_node* n
 {
 	struct device_node* sub_node;
 
-	for (; node != 0;node = node->sibling) {
+	for (; node != NULL;node = node->sibling) {
 		const unsigned int *class_code;
 	
 		if (filter(node, data))
@@ -1449,9 +1449,9 @@ fake_pci_bus(struct pci_controller *hose
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
diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index a38197b..509f1e2 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -1095,7 +1095,7 @@ struct device_node *of_find_node_by_phan
 	struct device_node *np;
 
 	read_lock(&devtree_lock);
-	for (np = allnodes; np != 0; np = np->allnext)
+	for (np = allnodes; np != NULL; np = np->allnext)
 		if (np->linux_phandle == handle)
 			break;
 	of_node_get(np);
@@ -1118,7 +1118,7 @@ struct device_node *of_find_all_nodes(st
 
 	read_lock(&devtree_lock);
 	np = prev ? prev->allnext : allnodes;
-	for (; np != 0; np = np->allnext)
+	for (; np != NULL; np = np->allnext)
 		if (of_node_get(np))
 			break;
 	of_node_put(prev);
diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index 6018178..95119a5 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -310,7 +310,7 @@ static void __init initialize_cache_info
 			lsizep = of_get_property(np, dc, NULL);
 			if (lsizep != NULL)
 				lsize = *lsizep;
-			if (sizep == 0 || lsizep == 0)
+			if (sizep == NULL || lsizep == NULL)
 				DBG("Argh, can't find dcache properties ! "
 				    "sizep: %p, lsizep: %p\n", sizep, lsizep);
 
@@ -327,7 +327,7 @@ static void __init initialize_cache_info
 			lsizep = of_get_property(np, ic, NULL);
 			if (lsizep != NULL)
 				lsize = *lsizep;
-			if (sizep == 0 || lsizep == 0)
+			if (sizep == NULL || lsizep == NULL)
 				DBG("Argh, can't find icache properties ! "
 				    "sizep: %p, lsizep: %p\n", sizep, lsizep);
 
diff --git a/arch/powerpc/kernel/signal_64.c b/arch/powerpc/kernel/signal_64.c
index de895e6..6e02ec6 100644
--- a/arch/powerpc/kernel/signal_64.c
+++ b/arch/powerpc/kernel/signal_64.c
@@ -184,13 +184,13 @@ #ifdef CONFIG_ALTIVEC
 	if (v_regs && !access_ok(VERIFY_READ, v_regs, 34 * sizeof(vector128)))
 		return -EFAULT;
 	/* Copy 33 vec registers (vr0..31 and vscr) from the stack */
-	if (v_regs != 0 && (msr & MSR_VEC) != 0)
+	if (v_regs != NULL && (msr & MSR_VEC) != 0)
 		err |= __copy_from_user(current->thread.vr, v_regs,
 					33 * sizeof(vector128));
 	else if (current->thread.used_vr)
 		memset(current->thread.vr, 0, 33 * sizeof(vector128));
 	/* Always get VRSAVE back */
-	if (v_regs != 0)
+	if (v_regs != NULL)
 		err |= __get_user(current->thread.vrsave, (u32 __user *)&v_regs[33]);
 	else
 		current->thread.vrsave = 0;
diff --git a/arch/powerpc/mm/mmu_decl.h b/arch/powerpc/mm/mmu_decl.h
index c94a64f..b956e8b 100644
--- a/arch/powerpc/mm/mmu_decl.h
+++ b/arch/powerpc/mm/mmu_decl.h
@@ -83,7 +83,7 @@ extern unsigned long mmu_mapin_ram(void)
 static inline void flush_HPTE(unsigned context, unsigned long va,
 			      unsigned long pdval)
 {
-	if ((Hash != 0) &&
+	if ((Hash != NULL) &&
 	    cpu_has_feature(CPU_FTR_HPTE_TABLE))
 		flush_hash_pages(0, va, pdval, 1);
 	else
diff --git a/arch/powerpc/mm/pgtable_32.c b/arch/powerpc/mm/pgtable_32.c
index 6448872..6c5b368 100644
--- a/arch/powerpc/mm/pgtable_32.c
+++ b/arch/powerpc/mm/pgtable_32.c
@@ -209,7 +209,7 @@ __ioremap(phys_addr_t addr, unsigned lon
 	if (mem_init_done) {
 		struct vm_struct *area;
 		area = get_vm_area(size, VM_IOREMAP);
-		if (area == 0)
+		if (area == NULL)
 			return NULL;
 		v = (unsigned long) area->addr;
 	} else {
@@ -262,7 +262,7 @@ int map_page(unsigned long va, phys_addr
 	pd = pmd_offset(pud_offset(pgd_offset_k(va), va), va);
 	/* Use middle 10 bits of VA to index the second-level map */
 	pg = pte_alloc_kernel(pd, va);
-	if (pg != 0) {
+	if (pg != NULL) {
 		err = 0;
 		/* The PTE should never be already set nor present in the
 		 * hash table
diff --git a/arch/powerpc/mm/ppc_mmu_32.c b/arch/powerpc/mm/ppc_mmu_32.c
index 5c45d47..8e95c56 100644
--- a/arch/powerpc/mm/ppc_mmu_32.c
+++ b/arch/powerpc/mm/ppc_mmu_32.c
@@ -182,7 +182,7 @@ void hash_preload(struct mm_struct *mm, 
 {
 	pmd_t *pmd;
 
-	if (Hash == 0)
+	if (Hash == NULL)
 		return;
 	pmd = pmd_offset(pud_offset(pgd_offset(mm, ea), ea), ea);
 	if (!pmd_none(*pmd))
diff --git a/arch/powerpc/mm/tlb_32.c b/arch/powerpc/mm/tlb_32.c
index eb4b512..5db5aff 100644
--- a/arch/powerpc/mm/tlb_32.c
+++ b/arch/powerpc/mm/tlb_32.c
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
@@ -165,7 +165,7 @@ void flush_tlb_page(struct vm_area_struc
 	struct mm_struct *mm;
 	pmd_t *pmd;
 
-	if (Hash == 0) {
+	if (Hash == NULL) {
 		_tlbie(vmaddr);
 		return;
 	}
diff --git a/arch/powerpc/platforms/52xx/lite5200.c b/arch/powerpc/platforms/52xx/lite5200.c
index 5c46e89..9926396 100644
--- a/arch/powerpc/platforms/52xx/lite5200.c
+++ b/arch/powerpc/platforms/52xx/lite5200.c
@@ -118,7 +118,7 @@ static void __init lite5200_setup_arch(v
 	if (np) {
 		const unsigned int *fp =
 			of_get_property(np, "clock-frequency", NULL);
-		if (fp != 0)
+		if (fp != NULL)
 			loops_per_jiffy = *fp / HZ;
 		else
 			loops_per_jiffy = 50000000 / HZ;
diff --git a/arch/powerpc/platforms/83xx/mpc832x_mds.c b/arch/powerpc/platforms/83xx/mpc832x_mds.c
index b39cb52..b2bf27d 100644
--- a/arch/powerpc/platforms/83xx/mpc832x_mds.c
+++ b/arch/powerpc/platforms/83xx/mpc832x_mds.c
@@ -65,7 +65,7 @@ static void __init mpc832x_sys_setup_arc
 
 	/* Map BCSR area */
 	np = of_find_node_by_name(NULL, "bcsr");
-	if (np != 0) {
+	if (np != NULL) {
 		struct resource res;
 
 		of_address_to_resource(np, 0, &res);
diff --git a/arch/powerpc/platforms/83xx/mpc836x_mds.c b/arch/powerpc/platforms/83xx/mpc836x_mds.c
index 0e615fd..b979fcf 100644
--- a/arch/powerpc/platforms/83xx/mpc836x_mds.c
+++ b/arch/powerpc/platforms/83xx/mpc836x_mds.c
@@ -71,7 +71,7 @@ static void __init mpc836x_mds_setup_arc
 
 	/* Map BCSR area */
 	np = of_find_node_by_name(NULL, "bcsr");
-	if (np != 0) {
+	if (np != NULL) {
 		struct resource res;
 
 		of_address_to_resource(np, 0, &res);
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_ads.c b/arch/powerpc/platforms/85xx/mpc85xx_ads.c
index 40a8286..083f915 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_ads.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_ads.c
@@ -201,11 +201,11 @@ #endif
 		ppc_md.progress("mpc85xx_ads_setup_arch()", 0);
 
 	cpu = of_find_node_by_type(NULL, "cpu");
-	if (cpu != 0) {
+	if (cpu != NULL) {
 		const unsigned int *fp;
 
 		fp = of_get_property(cpu, "clock-frequency", NULL);
-		if (fp != 0)
+		if (fp != NULL)
 			loops_per_jiffy = *fp / HZ;
 		else
 			loops_per_jiffy = 50000000 / HZ;
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_cds.c b/arch/powerpc/platforms/85xx/mpc85xx_cds.c
index 6a171e9..bc29eff 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_cds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_cds.c
@@ -275,11 +275,11 @@ #endif
 		ppc_md.progress("mpc85xx_cds_setup_arch()", 0);
 
 	cpu = of_find_node_by_type(NULL, "cpu");
-	if (cpu != 0) {
+	if (cpu != NULL) {
 		const unsigned int *fp;
 
 		fp = of_get_property(cpu, "clock-frequency", NULL);
-		if (fp != 0)
+		if (fp != NULL)
 			loops_per_jiffy = *fp / HZ;
 		else
 			loops_per_jiffy = 500000000 / HZ;
diff --git a/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c b/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c
index e9eaa07..fad9418 100644
--- a/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c
+++ b/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c
@@ -333,11 +333,11 @@ mpc86xx_hpcn_setup_arch(void)
 		ppc_md.progress("mpc86xx_hpcn_setup_arch()", 0);
 
 	np = of_find_node_by_type(NULL, "cpu");
-	if (np != 0) {
+	if (np != NULL) {
 		const unsigned int *fp;
 
 		fp = of_get_property(np, "clock-frequency", NULL);
-		if (fp != 0)
+		if (fp != NULL)
 			loops_per_jiffy = *fp / HZ;
 		else
 			loops_per_jiffy = 50000000 / HZ;
diff --git a/arch/powerpc/platforms/8xx/mpc86xads_setup.c b/arch/powerpc/platforms/8xx/mpc86xads_setup.c
index cf0e7bc..1b02ff1 100644
--- a/arch/powerpc/platforms/8xx/mpc86xads_setup.c
+++ b/arch/powerpc/platforms/8xx/mpc86xads_setup.c
@@ -257,11 +257,11 @@ static void __init mpc86xads_setup_arch(
 	struct device_node *cpu;
 
 	cpu = of_find_node_by_type(NULL, "cpu");
-	if (cpu != 0) {
+	if (cpu != NULL) {
 		const unsigned int *fp;
 
 		fp = of_get_property(cpu, "clock-frequency", NULL);
-		if (fp != 0)
+		if (fp != NULL)
 			loops_per_jiffy = *fp / HZ;
 		else
 			loops_per_jiffy = 50000000 / HZ;
diff --git a/arch/powerpc/platforms/8xx/mpc885ads_setup.c b/arch/powerpc/platforms/8xx/mpc885ads_setup.c
index 5a808d6..cd435f2 100644
--- a/arch/powerpc/platforms/8xx/mpc885ads_setup.c
+++ b/arch/powerpc/platforms/8xx/mpc885ads_setup.c
@@ -409,11 +409,11 @@ static void __init mpc885ads_setup_arch(
 	struct device_node *cpu;
 
 	cpu = of_find_node_by_type(NULL, "cpu");
-	if (cpu != 0) {
+	if (cpu != NULL) {
 		const unsigned int *fp;
 
 		fp = of_get_property(cpu, "clock-frequency", NULL);
-		if (fp != 0)
+		if (fp != NULL)
 			loops_per_jiffy = *fp / HZ;
 		else
 			loops_per_jiffy = 50000000 / HZ;
diff --git a/arch/powerpc/platforms/maple/pci.c b/arch/powerpc/platforms/maple/pci.c
index fceaae4..3e928d6 100644
--- a/arch/powerpc/platforms/maple/pci.c
+++ b/arch/powerpc/platforms/maple/pci.c
@@ -38,7 +38,7 @@ static struct pci_controller *u3_agp, *u
 
 static int __init fixup_one_level_bus_range(struct device_node *node, int higher)
 {
-	for (; node != 0;node = node->sibling) {
+	for (; node != NULL;node = node->sibling) {
 		const int *bus_range;
 		const unsigned int *class_code;
 		int len;
diff --git a/arch/powerpc/platforms/maple/setup.c b/arch/powerpc/platforms/maple/setup.c
index 354c058..b075c15 100644
--- a/arch/powerpc/platforms/maple/setup.c
+++ b/arch/powerpc/platforms/maple/setup.c
@@ -250,7 +250,7 @@ static void __init maple_init_IRQ(void)
 	root = of_find_node_by_path("/");
 	naddr = of_n_addr_cells(root);
 	opprop = of_get_property(root, "platform-open-pic", &opplen);
-	if (opprop != 0) {
+	if (opprop != NULL) {
 		openpic_addr = of_read_number(opprop, naddr);
 		has_isus = (opplen > naddr);
 		printk(KERN_DEBUG "OpenPIC addr: %lx, has ISUs: %d\n",
diff --git a/arch/powerpc/platforms/powermac/pci.c b/arch/powerpc/platforms/powermac/pci.c
index 92586db..0943d69 100644
--- a/arch/powerpc/platforms/powermac/pci.c
+++ b/arch/powerpc/platforms/powermac/pci.c
@@ -62,7 +62,7 @@ #define BANDIT_COHERENT	0x40
 
 static int __init fixup_one_level_bus_range(struct device_node *node, int higher)
 {
-	for (; node != 0;node = node->sibling) {
+	for (; node != NULL;node = node->sibling) {
 		const int * bus_range;
 		const unsigned int *class_code;
 		int len;
diff --git a/arch/powerpc/platforms/powermac/pfunc_core.c b/arch/powerpc/platforms/powermac/pfunc_core.c
index 8543423..aed0c15 100644
--- a/arch/powerpc/platforms/powermac/pfunc_core.c
+++ b/arch/powerpc/platforms/powermac/pfunc_core.c
@@ -685,7 +685,7 @@ #define PP_PREFIX "platform-do-"
 	const int plen = strlen(PP_PREFIX);
 	int count = 0;
 
-	for (pp = dev->node->properties; pp != 0; pp = pp->next) {
+	for (pp = dev->node->properties; pp != NULL; pp = pp->next) {
 		char *name;
 		if (strncmp(pp->name, PP_PREFIX, plen) != 0)
 			continue;
diff --git a/arch/powerpc/platforms/powermac/setup.c b/arch/powerpc/platforms/powermac/setup.c
index 7ccb923..75b600a 100644
--- a/arch/powerpc/platforms/powermac/setup.c
+++ b/arch/powerpc/platforms/powermac/setup.c
@@ -261,12 +261,12 @@ static void __init l2cr_init(void)
 	/* Checks "l2cr-value" property in the registry */
 	if (cpu_has_feature(CPU_FTR_L2CR)) {
 		struct device_node *np = of_find_node_by_name(NULL, "cpus");
-		if (np == 0)
+		if (np == NULL)
 			np = of_find_node_by_type(NULL, "cpu");
-		if (np != 0) {
+		if (np != NULL) {
 			const unsigned int *l2cr =
 				of_get_property(np, "l2cr-value", NULL);
-			if (l2cr != 0) {
+			if (l2cr != NULL) {
 				ppc_override_l2cr = 1;
 				ppc_override_l2cr_value = *l2cr;
 				_set_L2CR(0);
diff --git a/arch/powerpc/platforms/powermac/time.c b/arch/powerpc/platforms/powermac/time.c
index bf9da56..1767b2d 100644
--- a/arch/powerpc/platforms/powermac/time.c
+++ b/arch/powerpc/platforms/powermac/time.c
@@ -260,11 +260,11 @@ int __init via_calibrate_decr(void)
 	struct resource rsrc;
 
 	vias = of_find_node_by_name(NULL, "via-cuda");
-	if (vias == 0)
+	if (vias == NULL)
 		vias = of_find_node_by_name(NULL, "via-pmu");
-	if (vias == 0)
+	if (vias == NULL)
 		vias = of_find_node_by_name(NULL, "via");
-	if (vias == 0 || of_address_to_resource(vias, 0, &rsrc))
+	if (vias == NULL || of_address_to_resource(vias, 0, &rsrc))
 		return 0;
 	via = ioremap(rsrc.start, rsrc.end - rsrc.start + 1);
 	if (via == NULL) {
diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/platforms/pseries/setup.c
index f0b7146..10681c0 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -141,7 +141,7 @@ static void __init pseries_mpic_init_IRQ
 	np = of_find_node_by_path("/");
 	naddr = of_n_addr_cells(np);
 	opprop = of_get_property(np, "platform-open-pic", &opplen);
-	if (opprop != 0) {
+	if (opprop != NULL) {
 		openpic_addr = of_read_number(opprop, naddr);
 		printk(KERN_DEBUG "OpenPIC addr: %lx\n", openpic_addr);
 	}
diff --git a/arch/powerpc/sysdev/qe_lib/qe_io.c b/arch/powerpc/sysdev/qe_lib/qe_io.c
index e32b45b..575ae0a 100644
--- a/arch/powerpc/sysdev/qe_lib/qe_io.c
+++ b/arch/powerpc/sysdev/qe_lib/qe_io.c
@@ -162,7 +162,7 @@ int par_io_of_config(struct device_node 
 	}
 
 	ph = of_get_property(np, "pio-handle", NULL);
-	if (ph == 0) {
+	if (ph == NULL) {
 		printk(KERN_ERR "pio-handle not available \n");
 		return -1;
 	}
diff --git a/arch/powerpc/xmon/spu-dis.c b/arch/powerpc/xmon/spu-dis.c
index e5f8983..d9ef4dc 100644
--- a/arch/powerpc/xmon/spu-dis.c
+++ b/arch/powerpc/xmon/spu-dis.c
@@ -45,7 +45,7 @@ init_spu_disassemble (void)
       int o = spu_opcodes[i].opcode;
       if (o >= SPU_DISASM_TBL_SIZE)
 	continue; /* abort (); */
-      if (spu_disassemble_table[o] == 0)
+      if (spu_disassemble_table[o] == NULL)
 	spu_disassemble_table[o] = &spu_opcodes[i];
     }
 }
@@ -59,30 +59,30 @@ get_index_for_opcode (unsigned int insn)
 
   /* Init the table.  This assumes that element 0/opcode 0 (currently
    * NOP) is always used */
-  if (spu_disassemble_table[0] == 0)
+  if (spu_disassemble_table[0] == NULL)
     init_spu_disassemble ();
 
-  if ((index = spu_disassemble_table[opcode & 0x780]) != 0
+  if ((index = spu_disassemble_table[opcode & 0x780]) != NULL
       && index->insn_type == RRR)
     return index;
 
-  if ((index = spu_disassemble_table[opcode & 0x7f0]) != 0
+  if ((index = spu_disassemble_table[opcode & 0x7f0]) != NULL
       && (index->insn_type == RI18 || index->insn_type == LBT))
     return index;
 
-  if ((index = spu_disassemble_table[opcode & 0x7f8]) != 0
+  if ((index = spu_disassemble_table[opcode & 0x7f8]) != NULL
       && index->insn_type == RI10)
     return index;
 
-  if ((index = spu_disassemble_table[opcode & 0x7fc]) != 0
+  if ((index = spu_disassemble_table[opcode & 0x7fc]) != NULL
       && (index->insn_type == RI16))
     return index;
 
-  if ((index = spu_disassemble_table[opcode & 0x7fe]) != 0
+  if ((index = spu_disassemble_table[opcode & 0x7fe]) != NULL
       && (index->insn_type == RI8))
     return index;
 
-  if ((index = spu_disassemble_table[opcode & 0x7ff]) != 0)
+  if ((index = spu_disassemble_table[opcode & 0x7ff]) != NULL)
     return index;
 
   return NULL;
@@ -100,7 +100,7 @@ print_insn_spu (unsigned long insn, unsi
 
   index = get_index_for_opcode (insn);
 
-  if (index == 0)
+  if (index == NULL)
     {
       printf(".long 0x%x", insn);
     }
diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
index 121b04d..3c37276 100644
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -591,7 +591,7 @@ static int xmon_iabr_match(struct pt_reg
 {
 	if ((regs->msr & (MSR_IR|MSR_PR|MSR_SF)) != (MSR_IR|MSR_SF))
 		return 0;
-	if (iabr == 0)
+	if (iabr == NULL)
 		return 0;
 	xmon_core(regs, 0);
 	return 1;
@@ -1135,7 +1135,7 @@ #endif
 		} else {
 			/* assume a breakpoint address */
 			bp = at_breakpoint(a);
-			if (bp == 0) {
+			if (bp == NULL) {
 				printf("No breakpoint at %x\n", a);
 				break;
 			}

