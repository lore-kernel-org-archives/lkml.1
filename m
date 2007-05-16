Return-Path: <linux-kernel-owner+w=401wt.eu-S1763339AbXEPSNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763339AbXEPSNM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 14:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756332AbXEPSM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 14:12:59 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:26930 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170AbXEPSM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 14:12:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=e+bhPB5MKvVi+BJy0ISAAAYlIbVu7uR81sVSN2rb9eBc8YJ45bfaEe8fmE/YxO5UIqLwg25Qjswtvav/25gGBxjrf4x+GfaXoA8nlCro4bmaAVi59WSaq9OL+bqaBOMcd+XWWBJ/lVkJ3NSuAwcuLoe8y/oKq6hyBw0cdNLzA8Q=
Date: Wed, 16 May 2007 22:12:14 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Richard Henderson <rth@twiddle.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: [PATCH] ALPHA: MARVEL - check for allocated memory
Message-ID: <20070516181214.GA16348@cvg>
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

 arch/alpha/kernel/core_marvel.c |  137 ++++++++++++++++++++-------------------
 1 files changed, 71 insertions(+), 66 deletions(-)

diff --git a/arch/alpha/kernel/core_marvel.c b/arch/alpha/kernel/core_marvel.c
index 7f6a984..9f6d1a2 100644
--- a/arch/alpha/kernel/core_marvel.c
+++ b/arch/alpha/kernel/core_marvel.c
@@ -29,7 +29,7 @@
 #include "proto.h"
 #include "pci_impl.h"
 
-
+
 /*
  * Debug helpers
  */
@@ -41,13 +41,13 @@
 # define DBG_CFG(args)
 #endif
 
-
+
 /*
  * Private data
  */
 static struct io7 *io7_head = NULL;
 
-
+
 /*
  * Helper functions
  */
@@ -79,7 +79,7 @@ mk_resource_name(int pe, int port, char *str)
 {
 	char tmp[80];
 	char *name;
-	
+
 	sprintf(tmp, "PCI %s PE %d PORT %d", str, pe, port);
 	name = alloc_bootmem(strlen(tmp) + 1);
 	strcpy(name, tmp);
@@ -130,19 +130,19 @@ alloc_io7(unsigned int pe)
 	 * Insert in pe sorted order.
 	 */
 	if (NULL == io7_head)			/* empty list */
-		io7_head = io7;	
+		io7_head = io7;
 	else if (io7_head->pe > io7->pe) {	/* insert at head */
 		io7->next = io7_head;
 		io7_head = io7;
 	} else {				/* insert at position */
 		for (insp = io7_head; insp; insp = insp->next) {
 			if (insp->pe == io7->pe) {
-				printk(KERN_ERR "Too many IO7s at PE %d\n", 
+				printk(KERN_ERR "Too many IO7s at PE %d\n",
 				       io7->pe);
 				return NULL;
 			}
 
-			if (NULL == insp->next || 
+			if (NULL == insp->next ||
 			    insp->next->pe > io7->pe) { /* insert here */
 				io7->next = insp->next;
 				insp->next = io7;
@@ -157,7 +157,7 @@ alloc_io7(unsigned int pe)
 			io7_head = io7;
 		}
 	}
-	
+
 	return io7;
 }
 
@@ -191,7 +191,7 @@ io7_clear_errors(struct io7 *io7)
 	p7csrs->PO7_CRRCT_SYM.csr = -1UL;
 }
 
-
+
 /*
  * IO7 PCI, PCI/X, AGP configuration.
  */
@@ -206,11 +206,11 @@ io7_init_hose(struct io7 *io7, int port)
 	int i;
 
 	hose->index = hose_index++;	/* arbitrary */
-	
+
 	/*
 	 * We don't have an isa or legacy hose, but glibc expects to be
 	 * able to use the bus == 0 / dev == 0 form of the iobase syscall
-	 * to determine information about the i/o system. Since XFree86 
+	 * to determine information about the i/o system. Since XFree86
 	 * relies on glibc's determination to tell whether or not to use
 	 * sparse access, we need to point the pci_isa_hose at a real hose
 	 * so at least that determination is correct.
@@ -249,10 +249,10 @@ io7_init_hose(struct io7 *io7, int port)
 	hose->mem_space->flags = IORESOURCE_MEM;
 
 	if (request_resource(&ioport_resource, hose->io_space) < 0)
-		printk(KERN_ERR "Failed to request IO on hose %d\n", 
+		printk(KERN_ERR "Failed to request IO on hose %d\n",
 		       hose->index);
 	if (request_resource(&iomem_resource, hose->mem_space) < 0)
-		printk(KERN_ERR "Failed to request MEM on hose %d\n", 
+		printk(KERN_ERR "Failed to request MEM on hose %d\n",
 		       hose->index);
 
 	/*
@@ -284,7 +284,7 @@ io7_init_hose(struct io7 *io7, int port)
 	hose->sg_isa = iommu_arena_new_node(marvel_cpuid_to_nid(io7->pe),
 					    hose, 0x00800000, 0x00800000, 0);
 	hose->sg_isa->align_entry = 8;	/* cache line boundary */
-	csrs->POx_WBASE[0].csr = 
+	csrs->POx_WBASE[0].csr =
 		hose->sg_isa->dma_base | wbase_m_ena | wbase_m_sg;
 	csrs->POx_WMASK[0].csr = (hose->sg_isa->size - 1) & wbase_m_addr;
 	csrs->POx_TBASE[0].csr = virt_to_phys(hose->sg_isa->ptes);
@@ -302,7 +302,7 @@ io7_init_hose(struct io7 *io7, int port)
 	hose->sg_pci = iommu_arena_new_node(marvel_cpuid_to_nid(io7->pe),
 					    hose, 0xc0000000, 0x40000000, 0);
 	hose->sg_pci->align_entry = 8;	/* cache line boundary */
-	csrs->POx_WBASE[2].csr = 
+	csrs->POx_WBASE[2].csr =
 		hose->sg_pci->dma_base | wbase_m_ena | wbase_m_sg;
 	csrs->POx_WMASK[2].csr = (hose->sg_pci->size - 1) & wbase_m_addr;
 	csrs->POx_TBASE[2].csr = virt_to_phys(hose->sg_pci->ptes);
@@ -357,7 +357,7 @@ marvel_io7_present(gct6_node *node)
 	int pe;
 
 	if (node->type != GCT_TYPE_HOSE ||
-	    node->subtype != GCT_SUBTYPE_IO_PORT_MODULE) 
+	    node->subtype != GCT_SUBTYPE_IO_PORT_MODULE)
 		return;
 
 	pe = (node->id >> 8) & 0xff;
@@ -380,7 +380,7 @@ marvel_init_vga_hose(void)
 
 		/* FIXME - encoding is going to have to change for Marvel
 		 *         since hose will be able to overflow a byte...
-		 *         need to fix this decode when the console 
+		 *         need to fix this decode when the console
 		 *         changes its encoding
 		 */
 		printk("console graphics is on hose %d (console)\n", h);
@@ -455,7 +455,7 @@ marvel_init_arch(void)
 	gct6_find_nodes(GCT_NODE_PTR(0), gct_wanted_node_list);
 
 	/* Init the io7s.  */
-	for (io7 = NULL; NULL != (io7 = marvel_next_io7(io7)); ) 
+	for (io7 = NULL; NULL != (io7 = marvel_next_io7(io7)); )
 		marvel_init_io7(io7);
 
 	/* Check for graphic console location (if any).  */
@@ -467,13 +467,13 @@ marvel_kill_arch(int mode)
 {
 }
 
-
+
 /*
  * PCI Configuration Space access functions
  *
  * Configuration space addresses have the following format:
  *
- * 	|2 2 2 2|1 1 1 1|1 1 1 1|1 1 
+ * 	|2 2 2 2|1 1 1 1|1 1 1 1|1 1
  * 	|3 2 1 0|9 8 7 6|5 4 3 2|1 0 9 8|7 6 5 4|3 2 1 0
  * 	+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  * 	|B|B|B|B|B|B|B|B|D|D|D|D|D|F|F|F|R|R|R|R|R|R|R|R|
@@ -484,19 +484,19 @@ marvel_kill_arch(int mode)
  *	15:11	Device number (5 bits)
  *	10:8	function number
  *	 7:2	register number
- *  
+ *
  * Notes:
  *	IO7 determines whether to use a type 0 or type 1 config cycle
- *	based on the bus number. Therefore the bus number must be set 
+ *	based on the bus number. Therefore the bus number must be set
  *	to 0 for the root bus on any hose.
- *	
- *	The function number selects which function of a multi-function device 
+ *
+ *	The function number selects which function of a multi-function device
  *	(e.g., SCSI and Ethernet).
- * 
+ *
  */
 
 static inline unsigned long
-build_conf_addr(struct pci_controller *hose, u8 bus, 
+build_conf_addr(struct pci_controller *hose, u8 bus,
 		unsigned int devfn, int where)
 {
 	return (hose->config_space_base | (bus << 16) | (devfn << 8) | where);
@@ -536,18 +536,18 @@ marvel_read_config(struct pci_bus *bus, unsigned int devfn, int where,
 		   int size, u32 *value)
 {
 	unsigned long addr;
-	
+
 	if (0 == (addr = mk_conf_addr(bus, devfn, where)))
 		return PCIBIOS_DEVICE_NOT_FOUND;
 
 	switch(size) {
-	case 1:	
+	case 1:
 		*value = __kernel_ldbu(*(vucp)addr);
 		break;
-	case 2:	
+	case 2:
 		*value = __kernel_ldwu(*(vusp)addr);
 		break;
-	case 4:	
+	case 4:
 		*value = *(vuip)addr;
 		break;
 	default:
@@ -562,7 +562,7 @@ marvel_write_config(struct pci_bus *bus, unsigned int devfn, int where,
 		    int size, u32 value)
 {
 	unsigned long addr;
-	
+
 	if (0 == (addr = mk_conf_addr(bus, devfn, where)))
 		return PCIBIOS_DEVICE_NOT_FOUND;
 
@@ -595,7 +595,7 @@ struct pci_ops marvel_pci_ops =
 	.write = 	marvel_write_config,
 };
 
-
+
 /*
  * Other PCI helper functions.
  */
@@ -610,8 +610,8 @@ marvel_pci_tbi(struct pci_controller *hose, dma_addr_t start, dma_addr_t end)
 	csrs->POx_SG_TBIA.csr;
 }
 
-
-
+
+
 /*
  * RTC Support
  */
@@ -630,7 +630,7 @@ __marvel_access_rtc(void *info)
 	register unsigned long __r16 __asm__("$16") = rtc_access->function;
 	register unsigned long __r17 __asm__("$17") = rtc_access->index;
 	register unsigned long __r18 __asm__("$18") = rtc_access->data;
-	
+
 	__asm__ __volatile__(
 		"call_pal %4 # cserve rtc"
 		: "=r"(__r16), "=r"(__r17), "=r"(__r18), "=r"(__r0)
@@ -680,7 +680,7 @@ __marvel_rtc_io(u8 b, unsigned long addr, int write)
 	return ret;
 }
 
-
+
 /*
  * IO map support.
  */
@@ -699,7 +699,7 @@ marvel_ioremap(unsigned long addr, unsigned long size)
 
 	/*
 	 * Adjust the addr.
-	 */ 
+	 */
 #ifdef CONFIG_VGA_HOSE
 	if (pci_vga_hose && __marvel_is_mem_vga(addr)) {
 		addr += pci_vga_hose->mem_space->start;
@@ -711,7 +711,7 @@ marvel_ioremap(unsigned long addr, unsigned long size)
 	 */
 	for (hose = hose_head; hose; hose = hose->next) {
 		if ((addr >> 32) == (hose->mem_space->start >> 32))
-			break; 
+			break;
 	}
 	if (!hose)
 		return NULL;
@@ -725,13 +725,13 @@ marvel_ioremap(unsigned long addr, unsigned long size)
 	/*
 	 * Is it direct-mapped?
 	 */
-	if ((baddr >= __direct_map_base) && 
+	if ((baddr >= __direct_map_base) &&
 	    ((baddr + size - 1) < __direct_map_base + __direct_map_size)) {
 		addr = IDENT_ADDR | (baddr - __direct_map_base);
 		return (void __iomem *) addr;
 	}
 
-	/* 
+	/*
 	 * Check the scatter-gather arena.
 	 */
 	if (hose->sg_pci &&
@@ -754,8 +754,8 @@ marvel_ioremap(unsigned long addr, unsigned long size)
 			return NULL;
 
 		ptes = hose->sg_pci->ptes;
-		for (vaddr = (unsigned long)area->addr; 
-		    baddr <= last; 
+		for (vaddr = (unsigned long)area->addr;
+		    baddr <= last;
 		    baddr += PAGE_SIZE, vaddr += PAGE_SIZE) {
 			pfn = ptes[baddr >> PAGE_SHIFT];
 			if (!(pfn & 1)) {
@@ -764,9 +764,9 @@ marvel_ioremap(unsigned long addr, unsigned long size)
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
@@ -789,7 +789,7 @@ marvel_iounmap(volatile void __iomem *xaddr)
 {
 	unsigned long addr = (unsigned long) xaddr;
 	if (addr >= VMALLOC_START)
-		vfree((void *)(PAGE_MASK & addr)); 
+		vfree((void *)(PAGE_MASK & addr));
 }
 
 int
@@ -839,7 +839,7 @@ marvel_iowrite8(u8 b, void __iomem *xaddr)
 	unsigned long addr = (unsigned long) xaddr;
 	if (__marvel_is_port_kbd(addr))
 		return;
-	else if (__marvel_is_port_rtc(addr)) 
+	else if (__marvel_is_port_rtc(addr))
 		__marvel_rtc_io(b, addr, 1);
 	else
 		__kernel_stb(b, *(vucp)addr);
@@ -853,13 +853,13 @@ EXPORT_SYMBOL(marvel_ioportmap);
 EXPORT_SYMBOL(marvel_ioread8);
 EXPORT_SYMBOL(marvel_iowrite8);
 #endif
-
+
 /*
  * NUMA Support
  */
 /**********
- * FIXME - for now each cpu is a node by itself 
- *              -- no real support for striped mode 
+ * FIXME - for now each cpu is a node by itself
+ *              -- no real support for striped mode
  **********
  */
 int
@@ -867,7 +867,7 @@ marvel_pa_to_nid(unsigned long pa)
 {
 	int cpuid;
 
-	if ((pa >> 43) & 1) 	/* I/O */ 
+	if ((pa >> 43) & 1) 	/* I/O */
 		cpuid = (~(pa >> 35) & 0xff);
 	else			/* mem */
 		cpuid = ((pa >> 34) & 0x3) | ((pa >> (37 - 2)) & (0x1f << 2));
@@ -898,8 +898,8 @@ marvel_node_mem_size(int nid)
 	return 16UL * 1024 * 1024 * 1024; /* 16GB */
 }
 
-
-/* 
+
+/*
  * AGP GART Support.
  */
 #include <linux/agp_backend.h>
@@ -935,7 +935,7 @@ marvel_agp_setup(alpha_agp_info *agp)
 		return -ENOMEM;
 	}
 
-	agp->aperture.bus_base = 
+	agp->aperture.bus_base =
 		aper->arena->dma_base + aper->pg_start * PAGE_SIZE;
 	agp->aperture.size = aper->pg_count * PAGE_SIZE;
 	agp->aperture.sysdata = aper;
@@ -954,7 +954,7 @@ marvel_agp_cleanup(alpha_agp_info *agp)
 		printk(KERN_WARNING
 		       "Attempted to release bound AGP memory - unbinding\n");
 		iommu_unbind(aper->arena, aper->pg_start, aper->pg_count);
-		status = iommu_release(aper->arena, aper->pg_start, 
+		status = iommu_release(aper->arena, aper->pg_start,
 				       aper->pg_count);
 	}
 	if (status < 0)
@@ -980,11 +980,11 @@ marvel_agp_configure(alpha_agp_info *agp)
 	agp_pll = io7->csrs->POx_RST[IO7_AGP_PORT].csr;
 	switch(IO7_PLL_RNGB(agp_pll)) {
 	case 0x4:				/* 2x only */
-		/* 
+		/*
 		 * The PLL is only programmed for 2x, so adjust the
 		 * rate to 2x, if necessary.
 		 */
-		if (agp->mode.bits.rate != 2) 
+		if (agp->mode.bits.rate != 2)
 			new_rate = 2;
 		break;
 
@@ -993,7 +993,7 @@ marvel_agp_configure(alpha_agp_info *agp)
 		 * The PLL is programmed for 1x or 4x.  Don't go faster
 		 * than requested, so if the requested rate is 2x, use 1x.
 		 */
-		if (agp->mode.bits.rate == 2) 
+		if (agp->mode.bits.rate == 2)
 			new_rate = 1;
 		break;
 
@@ -1018,9 +1018,9 @@ marvel_agp_configure(alpha_agp_info *agp)
 
 		agp->mode.bits.rate = new_rate;
 	}
-		
-	printk("Enabling AGP on hose %d: %dX%s RQ %d\n", 
-	       agp->hose->index, agp->mode.bits.rate, 
+
+	printk("Enabling AGP on hose %d: %dX%s RQ %d\n",
+	       agp->hose->index, agp->mode.bits.rate,
 	       agp->mode.bits.sba ? " - SBA" : "", agp->mode.bits.rq);
 
 	csrs->AGP_CMD.csr = agp->mode.lw;
@@ -1028,15 +1028,15 @@ marvel_agp_configure(alpha_agp_info *agp)
 	return 0;
 }
 
-static int 
+static int
 marvel_agp_bind_memory(alpha_agp_info *agp, off_t pg_start, struct agp_memory *mem)
 {
 	struct marvel_agp_aperture *aper = agp->aperture.sysdata;
-	return iommu_bind(aper->arena, aper->pg_start + pg_start, 
+	return iommu_bind(aper->arena, aper->pg_start + pg_start,
 			  mem->page_count, mem->memory);
 }
 
-static int 
+static int
 marvel_agp_unbind_memory(alpha_agp_info *agp, off_t pg_start, struct agp_memory *mem)
 {
 	struct marvel_agp_aperture *aper = agp->aperture.sysdata;
@@ -1061,7 +1061,7 @@ marvel_agp_translate(alpha_agp_info *agp, dma_addr_t addr)
 	if (!(pte & 1)) {
 		printk("%s: pte not valid\n", __FUNCTION__);
 		return -EINVAL;
-	} 
+	}
 	return (pte >> 1) << PAGE_SHIFT;
 }
 
@@ -1111,7 +1111,7 @@ marvel_agp_info(void)
 
 	printk("MARVEL - using hose %d as AGP\n", hose->index);
 
-	/* 
+	/*
 	 * Get the csrs from the hose.
 	 */
 	csrs = ((struct io7_port *)hose->sysdata)->csrs;
@@ -1120,6 +1120,11 @@ marvel_agp_info(void)
 	 * Allocate the info structure.
 	 */
 	agp = kmalloc(sizeof(*agp), GFP_KERNEL);
+	if (agp == NULL) {
+		printk(KERN_ERR "MARVEL - cannot allocate struct of size %d bytes\n",
+		       sizeof(*agp));
+		return NULL;
+	}
 
 	/*
 	 * Fill it in.
@@ -1144,7 +1149,7 @@ marvel_agp_info(void)
 	 */
 	agp->capability.lw = csrs->AGP_STAT.csr;
 	agp->capability.bits.rq = 0xf;
-	
+
 	/*
 	 * Mode.
 	 */
