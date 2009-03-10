Return-Path: <linux-kernel-owner+w=401wt.eu-S1754580AbZCJFNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbZCJFNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 01:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752717AbZCJFLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 01:11:39 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:53984 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbZCJFLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 01:11:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=K6M9MB8/naRKNmaRISQQNPoNto9Yk7k4tU7aZSKtilIfPET/uA/X1C3g3dve+EZQ6n
         L07FD3bfaKRYY+Tklav80UwBiE+uo7Q2PI6fCH6wmHgx7WD8ENZEufKMK2Ev4U7JlJyf
         Z2xEzCYVXUP/sG+LdxJauoTWaMst/FE59Mov8=
From: Stoyan Gaydarov <stoyboyker@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Stoyan Gaydarov <stoyboyker@gmail.com>
Subject: [PATCH 04/25] [arm] BUG to BUG_ON changes
Date: Tue, 10 Mar 2009 00:10:29 -0500
Message-Id: <1236661850-8237-5-git-send-email-stoyboyker@gmail.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1236661850-8237-4-git-send-email-stoyboyker@gmail.com>
References: <1236661850-8237-1-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-2-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-3-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-4-git-send-email-stoyboyker@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
---
 arch/arm/common/gic.c             |    9 +++------
 arch/arm/mach-ebsa110/io.c        |   24 ++++++++----------------
 arch/arm/mach-integrator/pci_v3.c |    9 +++------
 arch/arm/mach-rpc/dma.c           |    3 +--
 arch/arm/mach-versatile/pci.c     |    9 +++------
 arch/arm/mm/init.c                |    3 +--
 6 files changed, 19 insertions(+), 38 deletions(-)

diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index c6884ba..3b230a7 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -166,8 +166,7 @@ static struct irq_chip gic_chip = {
 
 void __init gic_cascade_irq(unsigned int gic_nr, unsigned int irq)
 {
-	if (gic_nr >= MAX_GIC_NR)
-		BUG();
+	BUG_ON(gic_nr >= MAX_GIC_NR);
 	if (set_irq_data(irq, &gic_data[gic_nr]) != 0)
 		BUG();
 	set_irq_chained_handler(irq, gic_handle_cascade_irq);
@@ -179,8 +178,7 @@ void __init gic_dist_init(unsigned int gic_nr, void __iomem *base,
 	unsigned int max_irq, i;
 	u32 cpumask = 1 << smp_processor_id();
 
-	if (gic_nr >= MAX_GIC_NR)
-		BUG();
+	BUG_ON(gic_nr >= MAX_GIC_NR);
 
 	cpumask |= cpumask << 8;
 	cpumask |= cpumask << 16;
@@ -243,8 +241,7 @@ void __init gic_dist_init(unsigned int gic_nr, void __iomem *base,
 
 void __cpuinit gic_cpu_init(unsigned int gic_nr, void __iomem *base)
 {
-	if (gic_nr >= MAX_GIC_NR)
-		BUG();
+	BUG_ON(gic_nr >= MAX_GIC_NR);
 
 	gic_data[gic_nr].cpu_base = base;
 
diff --git a/arch/arm/mach-ebsa110/io.c b/arch/arm/mach-ebsa110/io.c
index c52e304..0a6ec5b 100644
--- a/arch/arm/mach-ebsa110/io.c
+++ b/arch/arm/mach-ebsa110/io.c
@@ -79,8 +79,7 @@ u16 __readw(const volatile void __iomem *addr)
 {
 	void __iomem *a = __isamem_convert_addr(addr);
 
-	if ((unsigned long)addr & 1)
-		BUG();
+	BUG_ON((unsigned long)addr & 1);
 
 	return __raw_readw(a);
 }
@@ -90,8 +89,7 @@ u32 __readl(const volatile void __iomem *addr)
 	void __iomem *a = __isamem_convert_addr(addr);
 	u32 ret;
 
-	if ((unsigned long)addr & 3)
-		BUG();
+	BUG_ON((unsigned long)addr & 3);
 
 	ret = __raw_readw(a);
 	ret |= __raw_readw(a + 4) << 16;
@@ -136,8 +134,7 @@ void __writew(u16 val, void __iomem *addr)
 {
 	void __iomem *a = __isamem_convert_addr(addr);
 
-	if ((unsigned long)addr & 1)
-		BUG();
+	BUG_ON((unsigned long)addr & 1);
 
 	__raw_writew(val, a);
 }
@@ -146,8 +143,7 @@ void __writel(u32 val, void __iomem *addr)
 {
 	void __iomem *a = __isamem_convert_addr(addr);
 
-	if ((unsigned long)addr & 3)
-		BUG();
+	BUG_ON((unsigned long)addr & 3);
 
 	__raw_writew(val, a);
 	__raw_writew(val >> 16, a + 4);
@@ -333,8 +329,7 @@ void outsb(unsigned int port, const void *from, int len)
 		off = port << 2;
 	else {
 		off = (port & ~1) << 1;
-		if (port & 1)
-			BUG();
+		BUG_ON(port & 1);
 	}
 
 	__raw_writesb((void __iomem *)ISAIO_BASE + off, from, len);
@@ -348,8 +343,7 @@ void insb(unsigned int port, void *from, int len)
 		off = port << 2;
 	else {
 		off = (port & ~1) << 1;
-		if (port & 1)
-			BUG();
+		BUG_ON(port & 1);
 	}
 
 	__raw_readsb((void __iomem *)ISAIO_BASE + off, from, len);
@@ -366,8 +360,7 @@ void outsw(unsigned int port, const void *from, int len)
 		off = port << 2;
 	else {
 		off = (port & ~1) << 1;
-		if (port & 1)
-			BUG();
+		BUG_ON(port & 1);
 	}
 
 	__raw_writesw((void __iomem *)ISAIO_BASE + off, from, len);
@@ -381,8 +374,7 @@ void insw(unsigned int port, void *from, int len)
 		off = port << 2;
 	else {
 		off = (port & ~1) << 1;
-		if (port & 1)
-			BUG();
+		BUG_ON(port & 1);
 	}
 
 	__raw_readsw((void __iomem *)ISAIO_BASE + off, from, len);
diff --git a/arch/arm/mach-integrator/pci_v3.c b/arch/arm/mach-integrator/pci_v3.c
index f1d72b2..f8514fb 100644
--- a/arch/arm/mach-integrator/pci_v3.c
+++ b/arch/arm/mach-integrator/pci_v3.c
@@ -190,12 +190,9 @@ static unsigned long v3_open_config_window(struct pci_bus *bus,
 	/*
 	 * Trap out illegal values
 	 */
-	if (offset > 255)
-		BUG();
-	if (busnr > 255)
-		BUG();
-	if (devfn > 255)
-		BUG();
+	BUG_ON(offset > 255);
+	BUG_ON(busnr > 255);
+	BUG_ON(devfn > 255);
 
 	if (busnr == 0) {
 		int slot = PCI_SLOT(devfn);
diff --git a/arch/arm/mach-rpc/dma.c b/arch/arm/mach-rpc/dma.c
index 7958a30..3fc0232 100644
--- a/arch/arm/mach-rpc/dma.c
+++ b/arch/arm/mach-rpc/dma.c
@@ -242,8 +242,7 @@ static void floppy_enable_dma(dmach_t channel, dma_t *dma)
 	unsigned int fiqhandler_length;
 	struct pt_regs regs;
 
-	if (dma->sg)
-		BUG();
+	BUG_ON(dma->sg);
 
 	if (dma->dma_mode == DMA_MODE_READ) {
 		extern unsigned char floppy_fiqin_start, floppy_fiqin_end;
diff --git a/arch/arm/mach-versatile/pci.c b/arch/arm/mach-versatile/pci.c
index 7161ba2..ba910ab 100644
--- a/arch/arm/mach-versatile/pci.c
+++ b/arch/arm/mach-versatile/pci.c
@@ -84,12 +84,9 @@ static void __iomem *__pci_addr(struct pci_bus *bus,
 	/*
 	 * Trap out illegal values
 	 */
-	if (offset > 255)
-		BUG();
-	if (busnr > 255)
-		BUG();
-	if (devfn > 255)
-		BUG();
+	BUG_ON(offset > 255);
+	BUG_ON(busnr > 255);
+	BUG_ON(devfn > 255);
 
 	return VERSATILE_PCI_CFG_VIRT_BASE + ((busnr << 16) |
 		(PCI_SLOT(devfn) << 11) | (PCI_FUNC(devfn) << 8) | offset);
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 34df4d9..67eba64 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -155,8 +155,7 @@ find_bootmap_pfn(int node, struct meminfo *mi, unsigned int bootmap_pages)
 		}
 	}
 
-	if (bootmap_pfn == 0)
-		BUG();
+	BUG_ON(bootmap_pfn == 0);
 
 	return bootmap_pfn;
 }
-- 
1.6.1.3

