Return-Path: <linux-kernel-owner+w=401wt.eu-S1760603AbXJZJlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760603AbXJZJlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 05:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755592AbXJZJkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 05:40:49 -0400
Received: from havoc.gtf.org ([69.61.125.42]:52411 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754372AbXJZJkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 05:40:43 -0400
To: LKML <linux-kernel@vger.kernel.org>
Message-Id: <74217bef3667bfd60b9cee6d9bcaf4d69617eb38.1193390974.git.jeff@garzik.org>
In-Reply-To: <9799624f63e093aa915947aea8fb1b8a5df959a1.1193390973.git.jeff@garzik.org>
References: <9799624f63e093aa915947aea8fb1b8a5df959a1.1193390973.git.jeff@garzik.org>
From: Jeff Garzik <jeff@garzik.org>
Cc: akpm@linux-foundation.org, rmk@arm.linux.org.uk, kernel@wantstofly.org
Subject: [PATCH] ARM: Misc minor interrupt handler cleanups
Date: Fri, 26 Oct 2007 05:40:25 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

mach-integrator/pci_v3.c: no need to reference 'irq' arg, its constant

mach-omap1/pm.c: remove extra whitespace

arch/arm/mach-sa1100/ssp.c: remove braces around single C stmt

arch/arm/plat-omap/mcbsp.c:
	- remove pointless casts from void*
	- make longer lines more readable

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 arch/arm/mach-integrator/pci_v3.c |    8 +++++---
 arch/arm/mach-omap1/pm.c          |    2 +-
 arch/arm/mach-sa1100/ssp.c        |    3 +--
 arch/arm/plat-omap/mcbsp.c        |   20 ++++++++++++--------
 4 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/arch/arm/mach-integrator/pci_v3.c b/arch/arm/mach-integrator/pci_v3.c
index d4d8134..d55fa4e 100644
--- a/arch/arm/mach-integrator/pci_v3.c
+++ b/arch/arm/mach-integrator/pci_v3.c
@@ -440,7 +440,7 @@ v3_pci_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 	return 1;
 }
 
-static irqreturn_t v3_irq(int irq, void *devid)
+static irqreturn_t v3_irq(int dummy, void *devid)
 {
 #ifdef CONFIG_DEBUG_LL
 	struct pt_regs *regs = get_irq_regs();
@@ -448,8 +448,10 @@ static irqreturn_t v3_irq(int irq, void *devid)
 	unsigned long instr = *(unsigned long *)pc;
 	char buf[128];
 
-	sprintf(buf, "V3 int %d: pc=0x%08lx [%08lx] LBFADDR=%08x LBFCODE=%02x ISTAT=%02x\n", irq,
-		pc, instr, __raw_readl(SC_LBFADDR), __raw_readl(SC_LBFCODE) & 255,
+	sprintf(buf, "V3 int %d: pc=0x%08lx [%08lx] LBFADDR=%08x LBFCODE=%02x "
+		"ISTAT=%02x\n", IRQ_AP_V3INT, pc, instr,
+		__raw_readl(SC_LBFADDR),
+		__raw_readl(SC_LBFCODE) & 255,
 		v3_readb(V3_LB_ISTAT));
 	printascii(buf);
 #endif
diff --git a/arch/arm/mach-omap1/pm.c b/arch/arm/mach-omap1/pm.c
index 3bf01e2..94c299b 100644
--- a/arch/arm/mach-omap1/pm.c
+++ b/arch/arm/mach-omap1/pm.c
@@ -646,7 +646,7 @@ static void omap_pm_finish(void)
 }
 
 
-static irqreturn_t  omap_wakeup_interrupt(int irq, void *dev)
+static irqreturn_t omap_wakeup_interrupt(int irq, void *dev)
 {
 	return IRQ_HANDLED;
 }
diff --git a/arch/arm/mach-sa1100/ssp.c b/arch/arm/mach-sa1100/ssp.c
index 59703c6..06206ce 100644
--- a/arch/arm/mach-sa1100/ssp.c
+++ b/arch/arm/mach-sa1100/ssp.c
@@ -29,9 +29,8 @@ static irqreturn_t ssp_interrupt(int irq, void *dev_id)
 {
 	unsigned int status = Ser4SSSR;
 
-	if (status & SSSR_ROR) {
+	if (status & SSSR_ROR)
 		printk(KERN_WARNING "SSP: receiver overrun\n");
-	}
 
 	Ser4SSSR = SSSR_ROR;
 
diff --git a/arch/arm/plat-omap/mcbsp.c b/arch/arm/plat-omap/mcbsp.c
index f7b9ccd..2af5bd5 100644
--- a/arch/arm/plat-omap/mcbsp.c
+++ b/arch/arm/plat-omap/mcbsp.c
@@ -98,9 +98,10 @@ static void omap_mcbsp_dump_reg(u8 id)
 
 static irqreturn_t omap_mcbsp_tx_irq_handler(int irq, void *dev_id)
 {
-	struct omap_mcbsp * mcbsp_tx = (struct omap_mcbsp *)(dev_id);
+	struct omap_mcbsp *mcbsp_tx = dev_id;
 
-	DBG("TX IRQ callback : 0x%x\n", OMAP_MCBSP_READ(mcbsp_tx->io_base, SPCR2));
+	DBG("TX IRQ callback : 0x%x\n",
+	    OMAP_MCBSP_READ(mcbsp_tx->io_base, SPCR2));
 
 	complete(&mcbsp_tx->tx_irq_completion);
 	return IRQ_HANDLED;
@@ -108,9 +109,10 @@ static irqreturn_t omap_mcbsp_tx_irq_handler(int irq, void *dev_id)
 
 static irqreturn_t omap_mcbsp_rx_irq_handler(int irq, void *dev_id)
 {
-	struct omap_mcbsp * mcbsp_rx = (struct omap_mcbsp *)(dev_id);
+	struct omap_mcbsp *mcbsp_rx = dev_id;
 
-	DBG("RX IRQ callback : 0x%x\n", OMAP_MCBSP_READ(mcbsp_rx->io_base, SPCR2));
+	DBG("RX IRQ callback : 0x%x\n",
+	    OMAP_MCBSP_READ(mcbsp_rx->io_base, SPCR2));
 
 	complete(&mcbsp_rx->rx_irq_completion);
 	return IRQ_HANDLED;
@@ -118,9 +120,10 @@ static irqreturn_t omap_mcbsp_rx_irq_handler(int irq, void *dev_id)
 
 static void omap_mcbsp_tx_dma_callback(int lch, u16 ch_status, void *data)
 {
-	struct omap_mcbsp * mcbsp_dma_tx = (struct omap_mcbsp *)(data);
+	struct omap_mcbsp *mcbsp_dma_tx = data;
 
-	DBG("TX DMA callback : 0x%x\n", OMAP_MCBSP_READ(mcbsp_dma_tx->io_base, SPCR2));
+	DBG("TX DMA callback : 0x%x\n",
+	    OMAP_MCBSP_READ(mcbsp_dma_tx->io_base, SPCR2));
 
 	/* We can free the channels */
 	omap_free_dma(mcbsp_dma_tx->dma_tx_lch);
@@ -131,9 +134,10 @@ static void omap_mcbsp_tx_dma_callback(int lch, u16 ch_status, void *data)
 
 static void omap_mcbsp_rx_dma_callback(int lch, u16 ch_status, void *data)
 {
-	struct omap_mcbsp * mcbsp_dma_rx = (struct omap_mcbsp *)(data);
+	struct omap_mcbsp *mcbsp_dma_rx = data;
 
-	DBG("RX DMA callback : 0x%x\n", OMAP_MCBSP_READ(mcbsp_dma_rx->io_base, SPCR2));
+	DBG("RX DMA callback : 0x%x\n",
+	    OMAP_MCBSP_READ(mcbsp_dma_rx->io_base, SPCR2));
 
 	/* We can free the channels */
 	omap_free_dma(mcbsp_dma_rx->dma_rx_lch);
-- 
1.5.2.4

