Return-Path: <linux-kernel-owner+w=401wt.eu-S1757208AbYAXQyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208AbYAXQyy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 11:54:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754307AbYAXQxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:53:11 -0500
Received: from smtp06.mtu.ru ([62.5.255.53]:64217 "EHLO smtp06.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164AbYAXQxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:53:04 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 05/17] [MIPS] Malta: use tabs not spaces
Date: Thu, 24 Jan 2008 19:52:45 +0300
Message-Id: <1201193577-4261-6-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1201193577-4261-1-git-send-email-dmitri.vorobiev@gmail.com>
References: <1201193577-4261-1-git-send-email-dmitri.vorobiev@gmail.com>
X-DCC-STREAM-Metrics: smtp06.mtu.ru 10001; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes all "use tabs not spaces" warnings reported by
the checkpatch.pl script on the board-specific files.

No functional changes introduced.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 arch/mips/mips-boards/malta/malta_int.c  |   64 +++++++++++++++---------------
 arch/mips/mips-boards/malta/malta_smtc.c |    4 +-
 2 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/arch/mips/mips-boards/malta/malta_int.c b/arch/mips/mips-boards/malta/malta_int.c
index 2483b40..6d371f4 100644
--- a/arch/mips/mips-boards/malta/malta_int.c
+++ b/arch/mips/mips-boards/malta/malta_int.c
@@ -47,7 +47,7 @@ static DEFINE_SPINLOCK(mips_irq_lock);
 static inline int mips_pcibios_iack(void)
 {
 	int irq;
-        u32 dummy;
+	u32 dummy;
 
 	/*
 	 * Determine highest priority pending interrupt by performing
@@ -58,7 +58,7 @@ static inline int mips_pcibios_iack(void)
 	case MIPS_REVISION_SCON_ROCIT:
 	case MIPS_REVISION_SCON_SOCITSC:
 	case MIPS_REVISION_SCON_SOCITSCP:
-	        MSC_READ(MSC01_PCI_IACK, irq);
+		MSC_READ(MSC01_PCI_IACK, irq);
 		irq &= 0xff;
 		break;
 	case MIPS_REVISION_SCON_GT64120:
@@ -123,15 +123,15 @@ static void malta_hw0_irqdispatch(void)
 static void corehi_irqdispatch(void)
 {
 	unsigned int intedge, intsteer, pcicmd, pcibadaddr;
-        unsigned int pcimstat, intisr, inten, intpol;
+	unsigned int pcimstat, intisr, inten, intpol;
 	unsigned int intrcause, datalo, datahi;
 	struct pt_regs *regs = get_irq_regs();
 
 	printk(KERN_EMERG "CoreHI interrupt, shouldn't happen, we die here!\n");
 	printk(KERN_EMERG "epc   : %08lx\nStatus: %08lx\n"
-	       "Cause : %08lx\nbadVaddr : %08lx\n",
-	       regs->cp0_epc, regs->cp0_status,
-	       regs->cp0_cause, regs->cp0_badvaddr);
+			"Cause : %08lx\nbadVaddr : %08lx\n",
+			regs->cp0_epc, regs->cp0_status,
+			regs->cp0_cause, regs->cp0_badvaddr);
 
 	/* Read all the registers and then print them as there is a
 	   problem with interspersed printk's upsetting the Bonito controller.
@@ -139,29 +139,29 @@ static void corehi_irqdispatch(void)
 	*/
 
 	switch (mips_revision_sconid) {
-        case MIPS_REVISION_SCON_SOCIT:
+	case MIPS_REVISION_SCON_SOCIT:
 	case MIPS_REVISION_SCON_ROCIT:
 	case MIPS_REVISION_SCON_SOCITSC:
 	case MIPS_REVISION_SCON_SOCITSCP:
-                ll_msc_irq();
-                break;
-        case MIPS_REVISION_SCON_GT64120:
-                intrcause = GT_READ(GT_INTRCAUSE_OFS);
-                datalo = GT_READ(GT_CPUERR_ADDRLO_OFS);
-                datahi = GT_READ(GT_CPUERR_ADDRHI_OFS);
+		ll_msc_irq();
+		break;
+	case MIPS_REVISION_SCON_GT64120:
+		intrcause = GT_READ(GT_INTRCAUSE_OFS);
+		datalo = GT_READ(GT_CPUERR_ADDRLO_OFS);
+		datahi = GT_READ(GT_CPUERR_ADDRHI_OFS);
 		printk(KERN_EMERG "GT_INTRCAUSE = %08x\n", intrcause);
 		printk(KERN_EMERG "GT_CPUERR_ADDR = %02x%08x\n",
 				datahi, datalo);
-                break;
-        case MIPS_REVISION_SCON_BONITO:
-                pcibadaddr = BONITO_PCIBADADDR;
-                pcimstat = BONITO_PCIMSTAT;
-                intisr = BONITO_INTISR;
-                inten = BONITO_INTEN;
-                intpol = BONITO_INTPOL;
-                intedge = BONITO_INTEDGE;
-                intsteer = BONITO_INTSTEER;
-                pcicmd = BONITO_PCICMD;
+		break;
+	case MIPS_REVISION_SCON_BONITO:
+		pcibadaddr = BONITO_PCIBADADDR;
+		pcimstat = BONITO_PCIMSTAT;
+		intisr = BONITO_INTISR;
+		inten = BONITO_INTEN;
+		intpol = BONITO_INTPOL;
+		intedge = BONITO_INTEDGE;
+		intsteer = BONITO_INTSTEER;
+		pcicmd = BONITO_PCICMD;
 		printk(KERN_EMERG "BONITO_INTISR = %08x\n", intisr);
 		printk(KERN_EMERG "BONITO_INTEN = %08x\n", inten);
 		printk(KERN_EMERG "BONITO_INTPOL = %08x\n", intpol);
@@ -170,11 +170,11 @@ static void corehi_irqdispatch(void)
 		printk(KERN_EMERG "BONITO_PCICMD = %08x\n", pcicmd);
 		printk(KERN_EMERG "BONITO_PCIBADADDR = %08x\n", pcibadaddr);
 		printk(KERN_EMERG "BONITO_PCIMSTAT = %08x\n", pcimstat);
-                break;
-        }
+		break;
+	}
 
-        /* We die here*/
-        die("CoreHi interrupt", regs);
+	/* We die here*/
+	die("CoreHi interrupt", regs);
 }
 
 static inline int clz(unsigned long x)
@@ -300,17 +300,17 @@ void __init arch_init_irq(void)
 	if (!cpu_has_veic)
 		mips_cpu_irq_init();
 
-        switch(mips_revision_sconid) {
-        case MIPS_REVISION_SCON_SOCIT:
-        case MIPS_REVISION_SCON_ROCIT:
+	switch (mips_revision_sconid) {
+	case MIPS_REVISION_SCON_SOCIT:
+	case MIPS_REVISION_SCON_ROCIT:
 		if (cpu_has_veic)
 			init_msc_irqs(MIPS_MSC01_IC_REG_BASE, MSC01E_INT_BASE, msc_eicirqmap, msc_nr_eicirqs);
 		else
 			init_msc_irqs(MIPS_MSC01_IC_REG_BASE, MSC01C_INT_BASE, msc_irqmap, msc_nr_irqs);
 		break;
 
-        case MIPS_REVISION_SCON_SOCITSC:
-        case MIPS_REVISION_SCON_SOCITSCP:
+	case MIPS_REVISION_SCON_SOCITSC:
+	case MIPS_REVISION_SCON_SOCITSCP:
 		if (cpu_has_veic)
 			init_msc_irqs(MIPS_SOCITSC_IC_REG_BASE, MSC01E_INT_BASE, msc_eicirqmap, msc_nr_eicirqs);
 		else
diff --git a/arch/mips/mips-boards/malta/malta_smtc.c b/arch/mips/mips-boards/malta/malta_smtc.c
index 5c980f4..0a1a40a 100644
--- a/arch/mips/mips-boards/malta/malta_smtc.c
+++ b/arch/mips/mips-boards/malta/malta_smtc.c
@@ -36,7 +36,7 @@ void __cpuinit prom_boot_secondary(int cpu, struct task_struct *idle)
 
 void __cpuinit prom_init_secondary(void)
 {
-        void smtc_init_secondary(void);
+	void smtc_init_secondary(void);
 	int myvpe;
 
 	/* Don't enable Malta I/O interrupts (IP2) for secondary VPEs */
@@ -50,7 +50,7 @@ void __cpuinit prom_init_secondary(void)
 			set_c0_status(0x100 << cp0_perfcount_irq);
 	}
 
-        smtc_init_secondary();
+	smtc_init_secondary();
 }
 
 /*
-- 
1.5.3

