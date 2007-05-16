Return-Path: <linux-kernel-owner+w=401wt.eu-S1762542AbXEPSO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762542AbXEPSO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 14:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757264AbXEPSOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 14:14:19 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:52293 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759681AbXEPSOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 14:14:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=ense+Pqk6GDDI6O5sm1c46WyqtQ+5RBK6Ia0d7O+Xn6MeggBZaWReFdJ0SNzOfKBS+Mb6aCBqja1Hc5U7XkgnO8b8Jvh9VEk3H2XWNzZx5VQjPK+FcvYM5R9iD/nElD8fxVDPo5QKRXxq7AbpmPQn5Y5MVKhHkY+7uf3Z9jXaXc=
Date: Wed, 16 May 2007 22:13:32 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Richard Henderson <rth@twiddle.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: [PATCH] ALPHA: TITAN - check for allocated memory
Message-ID: <20070516181332.GB16348@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds checking for allocated memory
which is used to hold AGP info. Also some whitespace
cleanup.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>

---

 arch/alpha/kernel/core_titan.c |   99 +++++++++++++++++++++-------------------
 1 files changed, 52 insertions(+), 47 deletions(-)

diff --git a/arch/alpha/kernel/core_titan.c b/arch/alpha/kernel/core_titan.c
index 3662fef..419dbc8 100644
--- a/arch/alpha/kernel/core_titan.c
+++ b/arch/alpha/kernel/core_titan.c
@@ -46,7 +46,7 @@ struct
 # define DBG_CFG(args)
 #endif
 
-
+
 /*
  * Routines to access TIG registers.
  */
@@ -56,21 +56,21 @@ mk_tig_addr(int offset)
 	return (volatile unsigned long *)(TITAN_TIG_SPACE + (offset << 6));
 }
 
-static inline u8 
+static inline u8
 titan_read_tig(int offset, u8 value)
 {
 	volatile unsigned long *tig_addr = mk_tig_addr(offset);
 	return (u8)(*tig_addr & 0xff);
 }
 
-static inline void 
+static inline void
 titan_write_tig(int offset, u8 value)
 {
 	volatile unsigned long *tig_addr = mk_tig_addr(offset);
 	*tig_addr = (unsigned long)value;
 }
 
-
+
 /*
  * Given a bus, device, and function number, compute resulting
  * configuration space address
@@ -84,7 +84,7 @@ titan_write_tig(int offset, u8 value)
  *
  * Type 1:
  *
- *  3 3|3 3 2 2|2 2 2 2|2 2 2 2|1 1 1 1|1 1 1 1|1 1 
+ *  3 3|3 3 2 2|2 2 2 2|2 2 2 2|1 1 1 1|1 1 1 1|1 1
  *  3 2|1 0 9 8|7 6 5 4|3 2 1 0|9 8 7 6|5 4 3 2|1 0 9 8|7 6 5 4|3 2 1 0
  * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  * | | | | | | | | | | |B|B|B|B|B|B|B|B|D|D|D|D|D|F|F|F|R|R|R|R|R|R|0|1|
@@ -95,11 +95,11 @@ titan_write_tig(int offset, u8 value)
  *	15:11	Device number (5 bits)
  *	10:8	function number
  *	 7:2	register number
- *  
+ *
  * Notes:
- *	The function number selects which function of a multi-function device 
+ *	The function number selects which function of a multi-function device
  *	(e.g., SCSI and Ethernet).
- * 
+ *
  *	The register selects a DWORD (32 bit) register offset.  Hence it
  *	doesn't get shifted by 2 bits as we want to "drop" the bottom two
  *	bits.
@@ -123,7 +123,7 @@ mk_conf_addr(struct pci_bus *pbus, unsigned int device_fn, int where,
 
         addr = (bus << 16) | (device_fn << 8) | where;
 	addr |= hose->config_space_base;
-		
+
 	*pci_addr = addr;
 	DBG_CFG(("mk_conf_addr: returning pci_addr 0x%lx\n", addr));
 	return 0;
@@ -154,7 +154,7 @@ titan_read_config(struct pci_bus *bus, unsigned int devfn, int where,
 	return PCIBIOS_SUCCESSFUL;
 }
 
-static int 
+static int
 titan_write_config(struct pci_bus *bus, unsigned int devfn, int where,
 		   int size, u32 value)
 {
@@ -185,17 +185,17 @@ titan_write_config(struct pci_bus *bus, unsigned int devfn, int where,
 	return PCIBIOS_SUCCESSFUL;
 }
 
-struct pci_ops titan_pci_ops = 
+struct pci_ops titan_pci_ops =
 {
 	.read =		titan_read_config,
 	.write =	titan_write_config,
 };
 
-
+
 void
 titan_pci_tbi(struct pci_controller *hose, dma_addr_t start, dma_addr_t end)
 {
-	titan_pachip *pachip = 
+	titan_pachip *pachip =
 	  (hose->index & 1) ? TITAN_pachip1 : TITAN_pachip0;
 	titan_pachip_port *port;
 	volatile unsigned long *csr;
@@ -203,11 +203,11 @@ titan_pci_tbi(struct pci_controller *hose, dma_addr_t start, dma_addr_t end)
 
 	/* Get the right hose.  */
 	port = &pachip->g_port;
-	if (hose->index & 2) 
+	if (hose->index & 2)
 		port = &pachip->a_port;
 
 	/* We can invalidate up to 8 tlb entries in a go.  The flush
-	   matches against <31:16> in the pci address.  
+	   matches against <31:16> in the pci address.
 	   Note that gtlbi* and atlbi* are in the same place in the g_port
 	   and a_port, respectively, so the g_port offset can be used
 	   even if hose is an a_port */
@@ -215,7 +215,7 @@ titan_pci_tbi(struct pci_controller *hose, dma_addr_t start, dma_addr_t end)
 	if (((start ^ end) & 0xffff0000) == 0)
 		csr = &port->port_specific.g.gtlbiv.csr;
 
-	/* For TBIA, it doesn't matter what value we write.  For TBI, 
+	/* For TBIA, it doesn't matter what value we write.  For TBI,
 	   it's the shifted tag bits.  */
 	value = (start & 0xffff0000) >> 12;
 
@@ -249,11 +249,11 @@ titan_init_one_pachip_port(titan_pachip_port *port, int index)
 	hose->mem_space = alloc_resource();
 
 	/*
-	 * This is for userland consumption.  The 40-bit PIO bias that we 
-	 * use in the kernel through KSEG doesn't work in the page table 
+	 * This is for userland consumption.  The 40-bit PIO bias that we
+	 * use in the kernel through KSEG doesn't work in the page table
 	 * based user mappings. (43-bit KSEG sign extends the physical
 	 * address from bit 40 to hit the I/O bit - mapped addresses don't).
-	 * So make sure we get the 43-bit PIO bias.  
+	 * So make sure we get the 43-bit PIO bias.
 	 */
 	hose->sparse_mem_base = 0;
 	hose->sparse_io_base = 0;
@@ -281,7 +281,7 @@ titan_init_one_pachip_port(titan_pachip_port *port, int index)
 		printk(KERN_ERR "Failed to request MEM on hose %d\n", index);
 
 	/*
-	 * Save the existing PCI window translations.  SRM will 
+	 * Save the existing PCI window translations.  SRM will
 	 * need them when we go to reboot.
 	 */
 	saved_config[index].wsba[0] = port->wsba[0].csr;
@@ -335,7 +335,7 @@ titan_init_one_pachip_port(titan_pachip_port *port, int index)
 	/*
 	 * If it's an AGP port, initialize agplastwr.
 	 */
-	if (titan_query_agp(port)) 
+	if (titan_query_agp(port))
 		port->port_specific.a.agplastwr.csr = __direct_map_base;
 
 	titan_pci_tbi(hose, 0, -1);
@@ -457,7 +457,7 @@ titan_kill_arch(int mode)
 	titan_kill_pachips(TITAN_pachip0, TITAN_pachip1);
 }
 
-
+
 /*
  * IO map support.
  */
@@ -468,7 +468,7 @@ titan_ioremap(unsigned long addr, unsigned long size)
 	int h = (addr & TITAN_HOSE_MASK) >> TITAN_HOSE_SHIFT;
 	unsigned long baddr = addr & ~TITAN_HOSE_MASK;
 	unsigned long last = baddr + size - 1;
-	struct pci_controller *hose;	
+	struct pci_controller *hose;
 	struct vm_struct *area;
 	unsigned long vaddr;
 	unsigned long *ptes;
@@ -476,7 +476,7 @@ titan_ioremap(unsigned long addr, unsigned long size)
 
 	/*
 	 * Adjust the addr.
-	 */ 
+	 */
 #ifdef CONFIG_VGA_HOSE
 	if (pci_vga_hose && __titan_is_mem_vga(addr)) {
 		h = pci_vga_hose->index;
@@ -496,13 +496,13 @@ titan_ioremap(unsigned long addr, unsigned long size)
 	/*
 	 * Is it direct-mapped?
 	 */
-	if ((baddr >= __direct_map_base) && 
+	if ((baddr >= __direct_map_base) &&
 	    ((baddr + size - 1) < __direct_map_base + __direct_map_size)) {
 		vaddr = addr - __direct_map_base + TITAN_MEM_BIAS;
 		return (void __iomem *) vaddr;
 	}
 
-	/* 
+	/*
 	 * Check the scatter-gather arena.
 	 */
 	if (hose->sg_pci &&
@@ -525,8 +525,8 @@ titan_ioremap(unsigned long addr, unsigned long size)
 			return NULL;
 
 		ptes = hose->sg_pci->ptes;
-		for (vaddr = (unsigned long)area->addr; 
-		    baddr <= last; 
+		for (vaddr = (unsigned long)area->addr;
+		    baddr <= last;
 		    baddr += PAGE_SIZE, vaddr += PAGE_SIZE) {
 			pfn = ptes[baddr >> PAGE_SHIFT];
 			if (!(pfn & 1)) {
@@ -535,9 +535,9 @@ titan_ioremap(unsigned long addr, unsigned long size)
 				return NULL;
 			}
 			pfn >>= 1;	/* make it a true pfn */
-			
+
 			if (__alpha_remap_area_pages(vaddr,
-						     pfn << PAGE_SHIFT, 
+						     pfn << PAGE_SHIFT,
 						     PAGE_SIZE, 0)) {
 				printk("FAILED to map...\n");
 				vfree(area->addr);
@@ -559,7 +559,7 @@ titan_iounmap(volatile void __iomem *xaddr)
 {
 	unsigned long addr = (unsigned long) xaddr;
 	if (addr >= VMALLOC_START)
-		vfree((void *)(PAGE_MASK & addr)); 
+		vfree((void *)(PAGE_MASK & addr));
 }
 
 int
@@ -578,7 +578,7 @@ EXPORT_SYMBOL(titan_ioremap);
 EXPORT_SYMBOL(titan_iounmap);
 EXPORT_SYMBOL(titan_is_mmio);
 #endif
-
+
 /*
  * AGP GART Support.
  */
@@ -615,7 +615,7 @@ titan_agp_setup(alpha_agp_info *agp)
 		return -ENOMEM;
 	}
 
-	agp->aperture.bus_base = 
+	agp->aperture.bus_base =
 		aper->arena->dma_base + aper->pg_start * PAGE_SIZE;
 	agp->aperture.size = aper->pg_count * PAGE_SIZE;
 	agp->aperture.sysdata = aper;
@@ -631,10 +631,10 @@ titan_agp_cleanup(alpha_agp_info *agp)
 
 	status = iommu_release(aper->arena, aper->pg_start, aper->pg_count);
 	if (status == -EBUSY) {
-		printk(KERN_WARNING 
+		printk(KERN_WARNING
 		       "Attempted to release bound AGP memory - unbinding\n");
 		iommu_unbind(aper->arena, aper->pg_start, aper->pg_count);
-		status = iommu_release(aper->arena, aper->pg_start, 
+		status = iommu_release(aper->arena, aper->pg_start,
 				       aper->pg_count);
 	}
 	if (status < 0)
@@ -656,13 +656,13 @@ titan_agp_configure(alpha_agp_info *agp)
 
 	/* AGP Rate? */
 	pctl.pctl_r_bits.apctl_v_agp_rate = 0;		/* 1x */
-	if (agp->mode.bits.rate & 2) 
+	if (agp->mode.bits.rate & 2)
 		pctl.pctl_r_bits.apctl_v_agp_rate = 1;	/* 2x */
 #if 0
-	if (agp->mode.bits.rate & 4) 
+	if (agp->mode.bits.rate & 4)
 		pctl.pctl_r_bits.apctl_v_agp_rate = 2;	/* 4x */
 #endif
-	
+
 	/* RQ Depth? */
 	pctl.pctl_r_bits.apctl_v_agp_hp_rd = 2;
 	pctl.pctl_r_bits.apctl_v_agp_lp_rd = 7;
@@ -673,28 +673,28 @@ titan_agp_configure(alpha_agp_info *agp)
 	pctl.pctl_r_bits.apctl_v_agp_en = agp->mode.bits.enable;
 
 	/* Tell the user.  */
-	printk("Enabling AGP: %dX%s\n", 
+	printk("Enabling AGP: %dX%s\n",
 	       1 << pctl.pctl_r_bits.apctl_v_agp_rate,
 	       pctl.pctl_r_bits.apctl_v_agp_sba_en ? " - SBA" : "");
-	       
+
 	/* Write it.  */
 	port->pctl.csr = pctl.pctl_q_whole;
-	
+
 	/* And wait at least 5000 66MHz cycles (per Titan spec).  */
 	udelay(100);
 
 	return 0;
 }
 
-static int 
+static int
 titan_agp_bind_memory(alpha_agp_info *agp, off_t pg_start, struct agp_memory *mem)
 {
 	struct titan_agp_aperture *aper = agp->aperture.sysdata;
-	return iommu_bind(aper->arena, aper->pg_start + pg_start, 
+	return iommu_bind(aper->arena, aper->pg_start + pg_start,
 			  mem->page_count, mem->memory);
 }
 
-static int 
+static int
 titan_agp_unbind_memory(alpha_agp_info *agp, off_t pg_start, struct agp_memory *mem)
 {
 	struct titan_agp_aperture *aper = agp->aperture.sysdata;
@@ -749,10 +749,10 @@ titan_agp_info(void)
 	port = &TITAN_pachip0->a_port;
 	if (titan_query_agp(port))
 		hosenum = 2;
-	if (hosenum < 0 && 
-	    titan_query_agp(port = &TITAN_pachip1->a_port)) 
+	if (hosenum < 0 &&
+	    titan_query_agp(port = &TITAN_pachip1->a_port))
 		hosenum = 3;
-	
+
 	/*
 	 * Find the hose the port is on.
 	 */
@@ -767,6 +767,11 @@ titan_agp_info(void)
 	 * Allocate the info structure.
 	 */
 	agp = kmalloc(sizeof(*agp), GFP_KERNEL);
+	if (agp == NULL) {
+		printk(KERN_ERR "TITAN - cannot allocate struct of size %d bytes\n",
+		       sizeof(*agp));
+		return NULL;
+	}
 
 	/*
 	 * Fill it in.
