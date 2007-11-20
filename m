Return-Path: <linux-kernel-owner+w=401wt.eu-S1754934AbXKTBv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbXKTBv4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:51:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757159AbXKTBtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:49:05 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2046 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756104AbXKTBsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:48:55 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Blanchard <anton@samba.org>, Paul Mackerras <paulus@samba.org>,
       anton@au.ibm.com, linuxppc-dev@ozlabs.org, paulus@au.ibm.com
Subject: [PATCH 03/59] arch/powerpc: Add missing "space"
Date: Mon, 19 Nov 2007 17:47:55 -0800
Message-Id: <1195523331-15303-4-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.6.728.gea559
In-Reply-To: <1195523331-15303-3-git-send-email-joe@perches.com>
References: 1234567
 <1195523331-15303-1-git-send-email-joe@perches.com>
 <1195523331-15303-2-git-send-email-joe@perches.com>
 <1195523331-15303-3-git-send-email-joe@perches.com>
Message-Id: <0c0c76b8a44447bbeb8b0b502f5b4f2750bd8cc6.1195454434.git.joe@perches.com>
In-Reply-To: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/powerpc/kernel/isa-bridge.c               |    4 ++--
 arch/powerpc/mm/fault.c                        |    2 +-
 arch/powerpc/platforms/8xx/m8xx_setup.c        |    2 +-
 arch/powerpc/platforms/celleb/io-workarounds.c |    2 +-
 arch/powerpc/platforms/celleb/scc_epci.c       |    2 +-
 arch/powerpc/sysdev/fsl_pci.c                  |    2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/kernel/isa-bridge.c b/arch/powerpc/kernel/isa-bridge.c
index f0f49d1..965bfcc 100644
--- a/arch/powerpc/kernel/isa-bridge.c
+++ b/arch/powerpc/kernel/isa-bridge.c
@@ -108,7 +108,7 @@ static void __devinit pci_process_ISA_OF_ranges(struct device_node *isa_node,
 	if (size > 0x10000)
 		size = 0x10000;
 
-	printk(KERN_ERR "no ISA IO ranges or unexpected isa range,"
+	printk(KERN_ERR "no ISA IO ranges or unexpected isa range, "
 	       "mapping 64k\n");
 
 	__ioremap_at(phb_io_base_phys, (void *)ISA_IO_BASE,
@@ -116,7 +116,7 @@ static void __devinit pci_process_ISA_OF_ranges(struct device_node *isa_node,
 	return;
 
 inval_range:
-	printk(KERN_ERR "no ISA IO ranges or unexpected isa range,"
+	printk(KERN_ERR "no ISA IO ranges or unexpected isa range, "
 	       "mapping 64k\n");
 	__ioremap_at(phb_io_base_phys, (void *)ISA_IO_BASE,
 		     0x10000, _PAGE_NO_CACHE|_PAGE_GUARDED);
diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
index 8135da0..10dda22 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -189,7 +189,7 @@ int __kprobes do_page_fault(struct pt_regs *regs, unsigned long address,
 			return SIGSEGV;
 		/* in_atomic() in user mode is really bad,
 		   as is current->mm == NULL. */
-		printk(KERN_EMERG "Page fault in user mode with"
+		printk(KERN_EMERG "Page fault in user mode with "
 		       "in_atomic() = %d mm = %p\n", in_atomic(), mm);
 		printk(KERN_EMERG "NIP = %lx  MSR = %lx\n",
 		       regs->nip, regs->msr);
diff --git a/arch/powerpc/platforms/8xx/m8xx_setup.c b/arch/powerpc/platforms/8xx/m8xx_setup.c
index d35eda8..ba645c2 100644
--- a/arch/powerpc/platforms/8xx/m8xx_setup.c
+++ b/arch/powerpc/platforms/8xx/m8xx_setup.c
@@ -120,7 +120,7 @@ void __init mpc8xx_calibrate_decr(void)
 	ppc_tb_freq /= 16;
 	ppc_proc_freq = 50000000;
 	if (!get_freq("clock-frequency", &ppc_proc_freq))
-		printk(KERN_ERR "WARNING: Estimating processor frequency"
+		printk(KERN_ERR "WARNING: Estimating processor frequency "
 		                "(not found)\n");
 
 	printk("Decrementer Frequency = 0x%lx\n", ppc_tb_freq);
diff --git a/arch/powerpc/platforms/celleb/io-workarounds.c b/arch/powerpc/platforms/celleb/io-workarounds.c
index 2b91214..32b9cec 100644
--- a/arch/powerpc/platforms/celleb/io-workarounds.c
+++ b/arch/powerpc/platforms/celleb/io-workarounds.c
@@ -256,7 +256,7 @@ int __init celleb_pci_workaround_init(void)
 
 	celleb_dummy_page_va = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!celleb_dummy_page_va) {
-		printk(KERN_ERR "Celleb: dummy read disabled."
+		printk(KERN_ERR "Celleb: dummy read disabled. "
 			"Alloc celleb_dummy_page_va failed\n");
 		return 1;
 	}
diff --git a/arch/powerpc/platforms/celleb/scc_epci.c b/arch/powerpc/platforms/celleb/scc_epci.c
index 9d07642..a3c7cfb 100644
--- a/arch/powerpc/platforms/celleb/scc_epci.c
+++ b/arch/powerpc/platforms/celleb/scc_epci.c
@@ -95,7 +95,7 @@ void __init epci_workaround_init(struct pci_controller *hose)
 	private->dummy_page_da = dma_map_single(hose->parent,
 		celleb_dummy_page_va, PAGE_SIZE, DMA_FROM_DEVICE);
 	if (private->dummy_page_da == DMA_ERROR_CODE) {
-		printk(KERN_ERR "EPCI: dummy read disabled."
+		printk(KERN_ERR "EPCI: dummy read disabled. "
 		       "Map dummy page failed.\n");
 		return;
 	}
diff --git a/arch/powerpc/sysdev/fsl_pci.c b/arch/powerpc/sysdev/fsl_pci.c
index 33df4c3..87e58e0 100644
--- a/arch/powerpc/sysdev/fsl_pci.c
+++ b/arch/powerpc/sysdev/fsl_pci.c
@@ -222,7 +222,7 @@ int __init fsl_add_bridge(struct device_node *dev, int is_primary)
 			hose->indirect_type |= PPC_INDIRECT_TYPE_NO_PCIE_LINK;
 	}
 
-	printk(KERN_INFO "Found FSL PCI host bridge at 0x%016llx."
+	printk(KERN_INFO "Found FSL PCI host bridge at 0x%016llx. "
 		"Firmware bus number: %d->%d\n",
 		(unsigned long long)rsrc.start, hose->first_busno,
 		hose->last_busno);
-- 
1.5.3.5.652.gf192c

