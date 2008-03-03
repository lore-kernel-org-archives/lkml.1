Return-Path: <linux-kernel-owner+w=401wt.eu-S1759673AbYCCRzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759673AbYCCRzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:55:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbYCCRzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:55:25 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:42756 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbYCCRzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:55:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Zp1j6S29RFGNX5S5kmND4XdeNACYsnS3LG/U6F+U381Ey0etooidRvehlVtKjdI7/yIpSy+cLZiDKfvl64qclZIWpQKTbn6Fc9UpXipD1OjSZ0FeKueD2BqET0n3tR6TCG5aXEqGgHgPCh/Ts6mR32nTMacpiVgOGyhHvXPAVI8=
Subject: [PATCH] alpha: remove remaining __FUNCTION__ occurances
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 09:55:19 -0800
Message-Id: <1204566919.3266.18.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

The change in pci-iommu,c should be safe as arena has not been assigned
when we get to this point.

Some were within #if 0 blocks, have changed them and left the blocks
as they appear to be debugging infrastructure.

A #define FN __FUNCTION__ was removed and occurances of FN were replaced
with __func__ as well.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/alpha/kernel/core_marvel.c  |    6 +++---
 arch/alpha/kernel/core_t2.c      |   24 +++++++++---------------
 arch/alpha/kernel/core_titan.c   |   34 +++++++++++++++++-----------------
 arch/alpha/kernel/core_tsunami.c |   28 +++++++++++++---------------
 arch/alpha/kernel/pci.c          |    2 +-
 arch/alpha/kernel/pci_iommu.c    |   34 +++++++++++++++-------------------
 arch/alpha/kernel/smp.c          |    4 ++--
 arch/alpha/kernel/srm_env.c      |    2 +-
 arch/alpha/kernel/sys_alcor.c    |    2 +-
 arch/alpha/kernel/sys_marvel.c   |   12 ++++++------
 arch/alpha/kernel/sys_sable.c    |    6 +++---
 arch/alpha/kernel/sys_sio.c      |    2 +-
 drivers/video/i810/i810_main.c   |   32 +++++++++-----------------------
 13 files changed, 81 insertions(+), 107 deletions(-)

diff --git a/arch/alpha/kernel/core_marvel.c b/arch/alpha/kernel/core_marvel.c
index f10d2ed..b04f1fe 100644
--- a/arch/alpha/kernel/core_marvel.c
+++ b/arch/alpha/kernel/core_marvel.c
@@ -994,7 +994,7 @@ marvel_agp_configure(alpha_agp_info *agp)
 		 * rate, but warn the user.
 		 */
 		printk("%s: unknown PLL setting RNGB=%lx (PLL6_CTL=%016lx)\n",
-		       __FUNCTION__, IO7_PLL_RNGB(agp_pll), agp_pll);
+		       __func__, IO7_PLL_RNGB(agp_pll), agp_pll);
 		break;
 	}
 
@@ -1044,13 +1044,13 @@ marvel_agp_translate(alpha_agp_info *agp, dma_addr_t addr)
 
 	if (addr < agp->aperture.bus_base ||
 	    addr >= agp->aperture.bus_base + agp->aperture.size) {
-		printk("%s: addr out of range\n", __FUNCTION__);
+		printk("%s: addr out of range\n", __func__);
 		return -EINVAL;
 	}
 
 	pte = aper->arena->ptes[baddr >> PAGE_SHIFT];
 	if (!(pte & 1)) {
-		printk("%s: pte not valid\n", __FUNCTION__);
+		printk("%s: pte not valid\n", __func__);
 		return -EINVAL;
 	} 
 	return (pte >> 1) << PAGE_SHIFT;
diff --git a/arch/alpha/kernel/core_t2.c b/arch/alpha/kernel/core_t2.c
index f5ca525..20d936f 100644
--- a/arch/alpha/kernel/core_t2.c
+++ b/arch/alpha/kernel/core_t2.c
@@ -336,10 +336,7 @@ t2_direct_map_window1(unsigned long base, unsigned long length)
 
 #if DEBUG_PRINT_FINAL_SETTINGS
 	printk("%s: setting WBASE1=0x%lx WMASK1=0x%lx TBASE1=0x%lx\n",
-	       __FUNCTION__,
-	       *(vulp)T2_WBASE1,
-	       *(vulp)T2_WMASK1,
-	       *(vulp)T2_TBASE1);
+	       __func__, *(vulp)T2_WBASE1, *(vulp)T2_WMASK1, *(vulp)T2_TBASE1);
 #endif
 }
 
@@ -366,10 +363,7 @@ t2_sg_map_window2(struct pci_controller *hose,
 
 #if DEBUG_PRINT_FINAL_SETTINGS
 	printk("%s: setting WBASE2=0x%lx WMASK2=0x%lx TBASE2=0x%lx\n",
-	       __FUNCTION__,
-	       *(vulp)T2_WBASE2,
-	       *(vulp)T2_WMASK2,
-	       *(vulp)T2_TBASE2);
+	       __func__, *(vulp)T2_WBASE2, *(vulp)T2_WMASK2, *(vulp)T2_TBASE2);
 #endif
 }
 
@@ -377,15 +371,15 @@ static void __init
 t2_save_configuration(void)
 {
 #if DEBUG_PRINT_INITIAL_SETTINGS
-	printk("%s: HAE_1 was 0x%lx\n", __FUNCTION__, srm_hae); /* HW is 0 */
-	printk("%s: HAE_2 was 0x%lx\n", __FUNCTION__, *(vulp)T2_HAE_2);
-	printk("%s: HAE_3 was 0x%lx\n", __FUNCTION__, *(vulp)T2_HAE_3);
-	printk("%s: HAE_4 was 0x%lx\n", __FUNCTION__, *(vulp)T2_HAE_4);
-	printk("%s: HBASE was 0x%lx\n", __FUNCTION__, *(vulp)T2_HBASE);
+	printk("%s: HAE_1 was 0x%lx\n", __func__, srm_hae); /* HW is 0 */
+	printk("%s: HAE_2 was 0x%lx\n", __func__, *(vulp)T2_HAE_2);
+	printk("%s: HAE_3 was 0x%lx\n", __func__, *(vulp)T2_HAE_3);
+	printk("%s: HAE_4 was 0x%lx\n", __func__, *(vulp)T2_HAE_4);
+	printk("%s: HBASE was 0x%lx\n", __func__, *(vulp)T2_HBASE);
 
-	printk("%s: WBASE1=0x%lx WMASK1=0x%lx TBASE1=0x%lx\n", __FUNCTION__, 
+	printk("%s: WBASE1=0x%lx WMASK1=0x%lx TBASE1=0x%lx\n", __func__, 
 	       *(vulp)T2_WBASE1, *(vulp)T2_WMASK1, *(vulp)T2_TBASE1);
-	printk("%s: WBASE2=0x%lx WMASK2=0x%lx TBASE2=0x%lx\n", __FUNCTION__, 
+	printk("%s: WBASE2=0x%lx WMASK2=0x%lx TBASE2=0x%lx\n", __func__, 
 	       *(vulp)T2_WBASE2, *(vulp)T2_WMASK2, *(vulp)T2_TBASE2);
 #endif
 
diff --git a/arch/alpha/kernel/core_titan.c b/arch/alpha/kernel/core_titan.c
index 8193266..319fcb7 100644
--- a/arch/alpha/kernel/core_titan.c
+++ b/arch/alpha/kernel/core_titan.c
@@ -365,21 +365,21 @@ void __init
 titan_init_arch(void)
 {
 #if 0
-	printk("%s: titan_init_arch()\n", __FUNCTION__);
-	printk("%s: CChip registers:\n", __FUNCTION__);
-	printk("%s: CSR_CSC 0x%lx\n", __FUNCTION__, TITAN_cchip->csc.csr);
-	printk("%s: CSR_MTR 0x%lx\n", __FUNCTION__, TITAN_cchip->mtr.csr);
-	printk("%s: CSR_MISC 0x%lx\n", __FUNCTION__, TITAN_cchip->misc.csr);
-	printk("%s: CSR_DIM0 0x%lx\n", __FUNCTION__, TITAN_cchip->dim0.csr);
-	printk("%s: CSR_DIM1 0x%lx\n", __FUNCTION__, TITAN_cchip->dim1.csr);
-	printk("%s: CSR_DIR0 0x%lx\n", __FUNCTION__, TITAN_cchip->dir0.csr);
-	printk("%s: CSR_DIR1 0x%lx\n", __FUNCTION__, TITAN_cchip->dir1.csr);
-	printk("%s: CSR_DRIR 0x%lx\n", __FUNCTION__, TITAN_cchip->drir.csr);
-
-	printk("%s: DChip registers:\n", __FUNCTION__);
-	printk("%s: CSR_DSC 0x%lx\n", __FUNCTION__, TITAN_dchip->dsc.csr);
-	printk("%s: CSR_STR 0x%lx\n", __FUNCTION__, TITAN_dchip->str.csr);
-	printk("%s: CSR_DREV 0x%lx\n", __FUNCTION__, TITAN_dchip->drev.csr);
+	printk("%s: titan_init_arch()\n", __func__);
+	printk("%s: CChip registers:\n", __func__);
+	printk("%s: CSR_CSC 0x%lx\n", __func__, TITAN_cchip->csc.csr);
+	printk("%s: CSR_MTR 0x%lx\n", __func__, TITAN_cchip->mtr.csr);
+	printk("%s: CSR_MISC 0x%lx\n", __func__, TITAN_cchip->misc.csr);
+	printk("%s: CSR_DIM0 0x%lx\n", __func__, TITAN_cchip->dim0.csr);
+	printk("%s: CSR_DIM1 0x%lx\n", __func__, TITAN_cchip->dim1.csr);
+	printk("%s: CSR_DIR0 0x%lx\n", __func__, TITAN_cchip->dir0.csr);
+	printk("%s: CSR_DIR1 0x%lx\n", __func__, TITAN_cchip->dir1.csr);
+	printk("%s: CSR_DRIR 0x%lx\n", __func__, TITAN_cchip->drir.csr);
+
+	printk("%s: DChip registers:\n", __func__);
+	printk("%s: CSR_DSC 0x%lx\n", __func__, TITAN_dchip->dsc.csr);
+	printk("%s: CSR_STR 0x%lx\n", __func__, TITAN_dchip->str.csr);
+	printk("%s: CSR_DREV 0x%lx\n", __func__, TITAN_dchip->drev.csr);
 #endif
 
 	boot_cpuid = __hard_smp_processor_id();
@@ -700,13 +700,13 @@ titan_agp_translate(alpha_agp_info *agp, dma_addr_t addr)
 
 	if (addr < agp->aperture.bus_base ||
 	    addr >= agp->aperture.bus_base + agp->aperture.size) {
-		printk("%s: addr out of range\n", __FUNCTION__);
+		printk("%s: addr out of range\n", __func__);
 		return -EINVAL;
 	}
 
 	pte = aper->arena->ptes[baddr >> PAGE_SHIFT];
 	if (!(pte & 1)) {
-		printk("%s: pte not valid\n", __FUNCTION__);
+		printk("%s: pte not valid\n", __func__);
 		return -EINVAL;
 	}
 
diff --git a/arch/alpha/kernel/core_tsunami.c b/arch/alpha/kernel/core_tsunami.c
index ef91e09..5e7c28f 100644
--- a/arch/alpha/kernel/core_tsunami.c
+++ b/arch/alpha/kernel/core_tsunami.c
@@ -241,8 +241,6 @@ tsunami_probe_write(volatile unsigned long *vaddr)
 #define tsunami_probe_read(ADDR) 1
 #endif /* NXM_MACHINE_CHECKS_ON_TSUNAMI */
 
-#define FN __FUNCTION__
-
 static void __init
 tsunami_init_one_pchip(tsunami_pchip *pchip, int index)
 {
@@ -383,27 +381,27 @@ tsunami_init_arch(void)
 	/* NXMs just don't matter to Tsunami--unless they make it
 	   choke completely. */
 	tmp = (unsigned long)(TSUNAMI_cchip - 1);
-	printk("%s: probing bogus address:  0x%016lx\n", FN, bogus_addr);
+	printk("%s: probing bogus address:  0x%016lx\n", __func__, bogus_addr);
 	printk("\tprobe %s\n",
 	       tsunami_probe_write((unsigned long *)bogus_addr)
 	       ? "succeeded" : "failed");
 #endif /* NXM_MACHINE_CHECKS_ON_TSUNAMI */
 
 #if 0
-	printk("%s: CChip registers:\n", FN);
-	printk("%s: CSR_CSC 0x%lx\n", FN, TSUNAMI_cchip->csc.csr);
-	printk("%s: CSR_MTR 0x%lx\n", FN, TSUNAMI_cchip.mtr.csr);
-	printk("%s: CSR_MISC 0x%lx\n", FN, TSUNAMI_cchip->misc.csr);
-	printk("%s: CSR_DIM0 0x%lx\n", FN, TSUNAMI_cchip->dim0.csr);
-	printk("%s: CSR_DIM1 0x%lx\n", FN, TSUNAMI_cchip->dim1.csr);
-	printk("%s: CSR_DIR0 0x%lx\n", FN, TSUNAMI_cchip->dir0.csr);
-	printk("%s: CSR_DIR1 0x%lx\n", FN, TSUNAMI_cchip->dir1.csr);
-	printk("%s: CSR_DRIR 0x%lx\n", FN, TSUNAMI_cchip->drir.csr);
+	printk("%s: CChip registers:\n", __func__);
+	printk("%s: CSR_CSC 0x%lx\n", __func__, TSUNAMI_cchip->csc.csr);
+	printk("%s: CSR_MTR 0x%lx\n", __func__, TSUNAMI_cchip.mtr.csr);
+	printk("%s: CSR_MISC 0x%lx\n", __func__, TSUNAMI_cchip->misc.csr);
+	printk("%s: CSR_DIM0 0x%lx\n", __func__, TSUNAMI_cchip->dim0.csr);
+	printk("%s: CSR_DIM1 0x%lx\n", __func__, TSUNAMI_cchip->dim1.csr);
+	printk("%s: CSR_DIR0 0x%lx\n", __func__, TSUNAMI_cchip->dir0.csr);
+	printk("%s: CSR_DIR1 0x%lx\n", __func__, TSUNAMI_cchip->dir1.csr);
+	printk("%s: CSR_DRIR 0x%lx\n", __func__, TSUNAMI_cchip->drir.csr);
 
 	printk("%s: DChip registers:\n");
-	printk("%s: CSR_DSC 0x%lx\n", FN, TSUNAMI_dchip->dsc.csr);
-	printk("%s: CSR_STR 0x%lx\n", FN, TSUNAMI_dchip->str.csr);
-	printk("%s: CSR_DREV 0x%lx\n", FN, TSUNAMI_dchip->drev.csr);
+	printk("%s: CSR_DSC 0x%lx\n", __func__, TSUNAMI_dchip->dsc.csr);
+	printk("%s: CSR_STR 0x%lx\n", __func__, TSUNAMI_dchip->str.csr);
+	printk("%s: CSR_DREV 0x%lx\n", __func__, TSUNAMI_dchip->drev.csr);
 #endif
 	/* With multiple PCI busses, we play with I/O as physical addrs.  */
 	ioport_resource.end = ~0UL;
diff --git a/arch/alpha/kernel/pci.c b/arch/alpha/kernel/pci.c
index 9dc1cee..a2317cc 100644
--- a/arch/alpha/kernel/pci.c
+++ b/arch/alpha/kernel/pci.c
@@ -220,7 +220,7 @@ pdev_save_srm_config(struct pci_dev *dev)
 
 	tmp = kmalloc(sizeof(*tmp), GFP_KERNEL);
 	if (!tmp) {
-		printk(KERN_ERR "%s: kmalloc() failed!\n", __FUNCTION__);
+		printk(KERN_ERR "%s: kmalloc() failed!\n", __func__);
 		return;
 	}
 	tmp->next = srm_saved_configs;
diff --git a/arch/alpha/kernel/pci_iommu.c b/arch/alpha/kernel/pci_iommu.c
index 26d3789..fac45b1 100644
--- a/arch/alpha/kernel/pci_iommu.c
+++ b/arch/alpha/kernel/pci_iommu.c
@@ -79,25 +79,21 @@ iommu_arena_new_node(int nid, struct pci_controller *hose, dma_addr_t base,
 
 #ifdef CONFIG_DISCONTIGMEM
 
-        if (!NODE_DATA(nid) ||
-            (NULL == (arena = alloc_bootmem_node(NODE_DATA(nid),
-                                                 sizeof(*arena))))) {
-                printk("%s: couldn't allocate arena from node %d\n"
-                       "    falling back to system-wide allocation\n",
-                       __FUNCTION__, nid);
-                arena = alloc_bootmem(sizeof(*arena));
-        }
-
-        if (!NODE_DATA(nid) ||
-            (NULL == (arena->ptes = __alloc_bootmem_node(NODE_DATA(nid),
-                                                         mem_size,
-                                                         align,
-                                                         0)))) {
-                printk("%s: couldn't allocate arena ptes from node %d\n"
-                       "    falling back to system-wide allocation\n",
-                       __FUNCTION__, nid);
-                arena->ptes = __alloc_bootmem(mem_size, align, 0);
-        }
+	arena = alloc_bootmem_node(NODE_DATA(nid), sizeof(*arena));
+	if (!NODE_DATA(nid) || !arena) {
+		printk("%s: couldn't allocate arena from node %d\n"
+		       "    falling back to system-wide allocation\n",
+		       __func__, nid);
+		arena = alloc_bootmem(sizeof(*arena));
+	}
+
+	arena->ptes = __alloc_bootmem_node(NODE_DATA(nid), mem_size, align, 0);
+	if (!NODE_DATA(nid) || !arena->ptes) {
+		printk("%s: couldn't allocate arena ptes from node %d\n"
+		       "    falling back to system-wide allocation\n",
+		       __func__, nid);
+		arena->ptes = __alloc_bootmem(mem_size, align, 0);
+	}
 
 #else /* CONFIG_DISCONTIGMEM */
 
diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index 63c2073..2525692 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -755,7 +755,7 @@ smp_call_function_on_cpu (void (*func) (void *info), void *info, int retry,
 	if (atomic_read(&data.unstarted_count) > 0) {
 		long start_time = jiffies;
 		printk(KERN_ERR "%s: initial timeout -- trying long wait\n",
-		       __FUNCTION__);
+		       __func__);
 		timeout = jiffies + 30 * HZ;
 		while (atomic_read(&data.unstarted_count) > 0
 		       && time_before(jiffies, timeout))
@@ -764,7 +764,7 @@ smp_call_function_on_cpu (void (*func) (void *info), void *info, int retry,
 			long delta = jiffies - start_time;
 			printk(KERN_ERR 
 			       "%s: response %ld.%ld seconds into long wait\n",
-			       __FUNCTION__, delta / HZ,
+			       __func__, delta / HZ,
 			       (100 * (delta - ((delta / HZ) * HZ))) / HZ);
 		}
 	}
diff --git a/arch/alpha/kernel/srm_env.c b/arch/alpha/kernel/srm_env.c
index f7dd081..78ad7cd 100644
--- a/arch/alpha/kernel/srm_env.c
+++ b/arch/alpha/kernel/srm_env.c
@@ -199,7 +199,7 @@ srm_env_init(void)
 		printk(KERN_INFO "%s: This Alpha system doesn't "
 				"know about SRM (or you've booted "
 				"SRM->MILO->Linux, which gets "
-				"misdetected)...\n", __FUNCTION__);
+				"misdetected)...\n", __func__);
 		return -ENODEV;
 	}
 
diff --git a/arch/alpha/kernel/sys_alcor.c b/arch/alpha/kernel/sys_alcor.c
index d187d01..e53a1e1 100644
--- a/arch/alpha/kernel/sys_alcor.c
+++ b/arch/alpha/kernel/sys_alcor.c
@@ -259,7 +259,7 @@ alcor_init_pci(void)
 	if (dev && dev->devfn == PCI_DEVFN(6,0)) {
 		alpha_mv.sys.cia.gru_int_req_bits = XLT_GRU_INT_REQ_BITS; 
 		printk(KERN_INFO "%s: Detected AS500 or XLT motherboard.\n",
-		       __FUNCTION__);
+		       __func__);
 	}
 	pci_dev_put(dev);
 }
diff --git a/arch/alpha/kernel/sys_marvel.c b/arch/alpha/kernel/sys_marvel.c
index 922143e..828449c 100644
--- a/arch/alpha/kernel/sys_marvel.c
+++ b/arch/alpha/kernel/sys_marvel.c
@@ -80,7 +80,7 @@ io7_get_irq_ctl(unsigned int irq, struct io7 **pio7)
 	if (!(io7 = marvel_find_io7(pid))) {
 		printk(KERN_ERR 
 		       "%s for nonexistent io7 -- vec %x, pid %d\n",
-		       __FUNCTION__, irq, pid);
+		       __func__, irq, pid);
 		return NULL;
 	}
 
@@ -90,7 +90,7 @@ io7_get_irq_ctl(unsigned int irq, struct io7 **pio7)
 	if (irq >= 0x180) {
 		printk(KERN_ERR 
 		       "%s for invalid irq -- pid %d adjusted irq %x\n",
-		       __FUNCTION__, pid, irq);
+		       __func__, pid, irq);
 		return NULL;
 	}
 
@@ -110,8 +110,8 @@ io7_enable_irq(unsigned int irq)
 
 	ctl = io7_get_irq_ctl(irq, &io7);
 	if (!ctl || !io7) {
-		printk(KERN_ERR "%s: get_ctl failed for irq %x\n", 
-		       __FUNCTION__, irq);
+		printk(KERN_ERR "%s: get_ctl failed for irq %x\n",
+		       __func__, irq);
 		return;
 	}
 		
@@ -130,8 +130,8 @@ io7_disable_irq(unsigned int irq)
 
 	ctl = io7_get_irq_ctl(irq, &io7);
 	if (!ctl || !io7) {
-		printk(KERN_ERR "%s: get_ctl failed for irq %x\n", 
-		       __FUNCTION__, irq);
+		printk(KERN_ERR "%s: get_ctl failed for irq %x\n",
+		       __func__, irq);
 		return;
 	}
 		
diff --git a/arch/alpha/kernel/sys_sable.c b/arch/alpha/kernel/sys_sable.c
index 906019c..99a7f19 100644
--- a/arch/alpha/kernel/sys_sable.c
+++ b/arch/alpha/kernel/sys_sable.c
@@ -454,7 +454,7 @@ sable_lynx_enable_irq(unsigned int irq)
 	spin_unlock(&sable_lynx_irq_lock);
 #if 0
 	printk("%s: mask 0x%lx bit 0x%x irq 0x%x\n",
-	       __FUNCTION__, mask, bit, irq);
+	       __func__, mask, bit, irq);
 #endif
 }
 
@@ -470,7 +470,7 @@ sable_lynx_disable_irq(unsigned int irq)
 	spin_unlock(&sable_lynx_irq_lock);
 #if 0
 	printk("%s: mask 0x%lx bit 0x%x irq 0x%x\n",
-	       __FUNCTION__, mask, bit, irq);
+	       __func__, mask, bit, irq);
 #endif
 }
 
@@ -524,7 +524,7 @@ sable_lynx_srm_device_interrupt(unsigned long vector)
 	irq = sable_lynx_irq_swizzle->mask_to_irq[bit];
 #if 0
 	printk("%s: vector 0x%lx bit 0x%x irq 0x%x\n",
-	       __FUNCTION__, vector, bit, irq);
+	       __func__, vector, bit, irq);
 #endif
 	handle_irq(irq);
 }
diff --git a/arch/alpha/kernel/sys_sio.c b/arch/alpha/kernel/sys_sio.c
index ee7b900..d4327e4 100644
--- a/arch/alpha/kernel/sys_sio.c
+++ b/arch/alpha/kernel/sys_sio.c
@@ -89,7 +89,7 @@ sio_pci_route(void)
 	/* First, ALWAYS read and print the original setting. */
 	pci_bus_read_config_dword(pci_isa_hose->bus, PCI_DEVFN(7, 0), 0x60,
 				  &orig_route_tab);
-	printk("%s: PIRQ original 0x%x new 0x%x\n", __FUNCTION__,
+	printk("%s: PIRQ original 0x%x new 0x%x\n", __func__,
 	       orig_route_tab, alpha_mv.sys.sio.route_tab);
 
 #if defined(ALPHA_RESTORE_SRM_SETUP)
diff --git a/drivers/video/i810/i810_main.c b/drivers/video/i810/i810_main.c
index 1d13dd0..7ea22ac 100644
--- a/drivers/video/i810/i810_main.c
+++ b/drivers/video/i810/i810_main.c
@@ -859,7 +859,7 @@ static void i810_init_cursor(struct i810fb_par *par)
  *                    Framebuffer hook helpers                       *
  *********************************************************************/
 /**
- * i810_round_off -  Round off values to capability of hardware
+ * i810_clamp_res -  Clamp values to capability of hardware
  * @var: pointer to fb_var_screeninfo structure
  *
  * DESCRIPTION:
@@ -867,42 +867,28 @@ static void i810_init_cursor(struct i810fb_par *par)
  * This will try modify those values to ones nearest the
  * capability of the hardware
  */
-static void i810_round_off(struct fb_var_screeninfo *var)
+static void i810_clamp_res(struct fb_var_screeninfo *var)
 {
 	u32 xres, yres, vxres, vyres;
 
-	/*
-	 *  Presently supports only these configurations 
-	 */
-
 	xres = var->xres;
 	yres = var->yres;
 	vxres = var->xres_virtual;
 	vyres = var->yres_virtual;
 
-	var->bits_per_pixel += 7;
-	var->bits_per_pixel &= ~7;
-	
-	if (var->bits_per_pixel < 8)
-		var->bits_per_pixel = 8;
-	if (var->bits_per_pixel > 32) 
-		var->bits_per_pixel = 32;
+	var->bits_per_pixel = (var->bits_per_pixel + 7) & ~7;
+	var->bits_per_pixel = clamp(var->bits_per_pixel, 8, 32);
 
 	round_off_xres(&xres);
-	if (xres < 40)
-		xres = 40;
-	if (xres > 2048) 
-		xres = 2048;
 	xres = (xres + 7) & ~7;
+	xres = clamp(xres, 40, 2048);
+
 
 	if (vxres < xres) 
 		vxres = xres;
 
 	round_off_yres(&xres, &yres);
-	if (yres < 1)
-		yres = 1;
-	if (yres >= 2048)
-		yres = 2048;
+	yres = clamp(yres, 1, 2048);
 
 	if (vyres < yres) 
 		vyres = yres;
@@ -920,12 +906,12 @@ static void i810_round_off(struct fb_var_screeninfo *var)
 		       var->lower_margin) & 1))
 			var->upper_margin++;
 	}
-	
+
 	var->xres = xres;
 	var->yres = yres;
 	var->xres_virtual = vxres;
 	var->yres_virtual = vyres;
-}	
+}
 
 /**
  * set_color_bitfields - sets rgba fields
-- 
1.5.4.3.500.g83a2c



