Return-Path: <linux-kernel-owner+w=401wt.eu-S1763215AbYCDDPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763215AbYCDDPH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 22:15:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759172AbYCDDKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 22:10:32 -0500
Received: from ti-out-0910.google.com ([209.85.142.186]:20759 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758179AbYCDDKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 22:10:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TE60R7UxOoryxjVt/5A6JzxjIop9MxiBvp+qdUybgs0yRTewG271C+bl9Eie0aFzU+MPMC+xv+eKgJesq06EbA7zKFBRF3+QC2i45Uerc/aAP1sbWombClMA5Ou8o6utISBG+MPva3CD3bc1VsZuI0rjUrKnrvYs2dz5CgzzZ2E=
Subject: [PATCH 11/14] drivers/parisc: replace remaining __FUNCTION__
	occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Kyle McMartin <kyle@mcmartin.ca>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <ff8fd021606e7a6f03e9c274230cfcf64eade6d2.1204599636.git.harvey.harrison@gmail.com>
References: <ff8fd021606e7a6f03e9c274230cfcf64eade6d2.1204599636.git.harvey.harrison@gmail.com>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 19:09:51 -0800
Message-Id: <1204600191.22933.91.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/parisc/asp.c       |    2 +-
 drivers/parisc/ccio-dma.c  |   36 ++++++++++++++++++------------------
 drivers/parisc/dino.c      |   14 +++++++-------
 drivers/parisc/gsc.c       |    4 ++--
 drivers/parisc/lasi.c      |    2 +-
 drivers/parisc/lba_pci.c   |   22 +++++++++++-----------
 drivers/parisc/led.c       |    2 +-
 drivers/parisc/sba_iommu.c |   42 +++++++++++++++++++++---------------------
 drivers/parisc/wax.c       |    2 +-
 9 files changed, 63 insertions(+), 63 deletions(-)

diff --git a/drivers/parisc/asp.c b/drivers/parisc/asp.c
index 558420b..8213691 100644
--- a/drivers/parisc/asp.c
+++ b/drivers/parisc/asp.c
@@ -88,7 +88,7 @@ asp_init_chip(struct parisc_device *dev)
 	ret = -EBUSY;
 	dev->irq = gsc_claim_irq(&gsc_irq, ASP_GSC_IRQ);
 	if (dev->irq < 0) {
-		printk(KERN_ERR "%s(): cannot get GSC irq\n", __FUNCTION__);
+		printk(KERN_ERR "%s(): cannot get GSC irq\n", __func__);
 		goto out;
 	}
 
diff --git a/drivers/parisc/ccio-dma.c b/drivers/parisc/ccio-dma.c
index d08b284..89105d0 100644
--- a/drivers/parisc/ccio-dma.c
+++ b/drivers/parisc/ccio-dma.c
@@ -353,7 +353,7 @@ ccio_alloc_range(struct ioc *ioc, size_t size)
 	BUG_ON((pages_needed * IOVP_SIZE) > DMA_CHUNK_SIZE);
      
 	DBG_RES("%s() size: %d pages_needed %d\n", 
-		__FUNCTION__, size, pages_needed);
+		__func__, size, pages_needed);
 
 	/*
 	** "seek and ye shall find"...praying never hurts either...
@@ -386,16 +386,16 @@ ccio_alloc_range(struct ioc *ioc, size_t size)
 #endif
 	} else {
 		panic("%s: %s() Too many pages to map. pages_needed: %u\n",
-		       __FILE__,  __FUNCTION__, pages_needed);
+		       __FILE__,  __func__, pages_needed);
 	}
 
 	panic("%s: %s() I/O MMU is out of mapping resources.\n", __FILE__,
-	      __FUNCTION__);
+	      __func__);
 	
 resource_found:
 	
 	DBG_RES("%s() res_idx %d res_hint: %d\n",
-		__FUNCTION__, res_idx, ioc->res_hint);
+		__func__, res_idx, ioc->res_hint);
 
 #ifdef CCIO_SEARCH_TIME
 	{
@@ -441,7 +441,7 @@ ccio_free_range(struct ioc *ioc, dma_addr_t iova, unsigned long pages_mapped)
 	BUG_ON(pages_mapped > BITS_PER_LONG);
 
 	DBG_RES("%s():  res_idx: %d pages_mapped %d\n", 
-		__FUNCTION__, res_idx, pages_mapped);
+		__func__, res_idx, pages_mapped);
 
 #ifdef CCIO_MAP_STATS
 	ioc->used_pages -= pages_mapped;
@@ -465,7 +465,7 @@ ccio_free_range(struct ioc *ioc, dma_addr_t iova, unsigned long pages_mapped)
 #endif
 	} else {
 		panic("%s:%s() Too many pages to unmap.\n", __FILE__,
-		      __FUNCTION__);
+		      __func__);
 	}
 }
 
@@ -766,7 +766,7 @@ ccio_map_single(struct device *dev, void *addr, size_t size,
 	pdir_start = &(ioc->pdir_base[idx]);
 
 	DBG_RUN("%s() 0x%p -> 0x%lx size: %0x%x\n",
-		__FUNCTION__, addr, (long)iovp | offset, size);
+		__func__, addr, (long)iovp | offset, size);
 
 	/* If not cacheline aligned, force SAFE_DMA on the whole mess */
 	if((size % L1_CACHE_BYTES) || ((unsigned long)addr % L1_CACHE_BYTES))
@@ -811,7 +811,7 @@ ccio_unmap_single(struct device *dev, dma_addr_t iova, size_t size,
 	ioc = GET_IOC(dev);
 
 	DBG_RUN("%s() iovp 0x%lx/%x\n",
-		__FUNCTION__, (long)iova, size);
+		__func__, (long)iova, size);
 
 	iova ^= offset;        /* clear offset bits */
 	size += offset;
@@ -913,7 +913,7 @@ ccio_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
 	BUG_ON(!dev);
 	ioc = GET_IOC(dev);
 	
-	DBG_RUN_SG("%s() START %d entries\n", __FUNCTION__, nents);
+	DBG_RUN_SG("%s() START %d entries\n", __func__, nents);
 
 	/* Fast path single entry scatterlists. */
 	if (nents == 1) {
@@ -957,7 +957,7 @@ ccio_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
 
 	BUG_ON(coalesced != filled);
 
-	DBG_RUN_SG("%s() DONE %d mappings\n", __FUNCTION__, filled);
+	DBG_RUN_SG("%s() DONE %d mappings\n", __func__, filled);
 
 	for (i = 0; i < filled; i++)
 		current_len += sg_dma_len(sglist + i);
@@ -986,7 +986,7 @@ ccio_unmap_sg(struct device *dev, struct scatterlist *sglist, int nents,
 	ioc = GET_IOC(dev);
 
 	DBG_RUN_SG("%s() START %d entries,  %08lx,%x\n",
-		__FUNCTION__, nents, sg_virt_addr(sglist), sglist->length);
+		__func__, nents, sg_virt_addr(sglist), sglist->length);
 
 #ifdef CCIO_MAP_STATS
 	ioc->usg_calls++;
@@ -1002,7 +1002,7 @@ ccio_unmap_sg(struct device *dev, struct scatterlist *sglist, int nents,
 		++sglist;
 	}
 
-	DBG_RUN_SG("%s() DONE (nents %d)\n", __FUNCTION__, nents);
+	DBG_RUN_SG("%s() DONE (nents %d)\n", __func__, nents);
 }
 
 static struct hppa_dma_ops ccio_ops = {
@@ -1216,7 +1216,7 @@ static int
 ccio_get_iotlb_size(struct parisc_device *dev)
 {
 	if (dev->spa_shift == 0) {
-		panic("%s() : Can't determine I/O TLB size.\n", __FUNCTION__);
+		panic("%s() : Can't determine I/O TLB size.\n", __func__);
 	}
 	return (1 << dev->spa_shift);
 }
@@ -1306,7 +1306,7 @@ ccio_ioc_init(struct ioc *ioc)
 	BUG_ON((1 << get_order(ioc->pdir_size)) != (ioc->pdir_size >> PAGE_SHIFT));
 
 	DBG_INIT("%s() hpa 0x%p mem %luMB IOV %dMB (%d bits)\n",
-			__FUNCTION__, ioc->ioc_regs,
+			__func__, ioc->ioc_regs,
 			(unsigned long) num_physpages >> (20 - PAGE_SHIFT),
 			iova_space_size>>20,
 			iov_order + PAGE_SHIFT);
@@ -1314,7 +1314,7 @@ ccio_ioc_init(struct ioc *ioc)
 	ioc->pdir_base = (u64 *)__get_free_pages(GFP_KERNEL, 
 						 get_order(ioc->pdir_size));
 	if(NULL == ioc->pdir_base) {
-		panic("%s() could not allocate I/O Page Table\n", __FUNCTION__);
+		panic("%s() could not allocate I/O Page Table\n", __func__);
 	}
 	memset(ioc->pdir_base, 0, ioc->pdir_size);
 
@@ -1323,12 +1323,12 @@ ccio_ioc_init(struct ioc *ioc)
 
 	/* resource map size dictated by pdir_size */
  	ioc->res_size = (ioc->pdir_size / sizeof(u64)) >> 3;
-	DBG_INIT("%s() res_size 0x%x\n", __FUNCTION__, ioc->res_size);
+	DBG_INIT("%s() res_size 0x%x\n", __func__, ioc->res_size);
 	
 	ioc->res_map = (u8 *)__get_free_pages(GFP_KERNEL, 
 					      get_order(ioc->res_size));
 	if(NULL == ioc->res_map) {
-		panic("%s() could not allocate resource map\n", __FUNCTION__);
+		panic("%s() could not allocate resource map\n", __func__);
 	}
 	memset(ioc->res_map, 0, ioc->res_size);
 
@@ -1400,7 +1400,7 @@ ccio_init_resource(struct resource *res, char *name, void __iomem *ioaddr)
 	result = insert_resource(&iomem_resource, res);
 	if (result < 0) {
 		printk(KERN_ERR "%s() failed to claim CCIO bus address space (%08lx,%08lx)\n", 
-	 		__FUNCTION__, res->start, res->end);
+	 		__func__, res->start, res->end);
 	}
 }
 
diff --git a/drivers/parisc/dino.c b/drivers/parisc/dino.c
index 03c763c..6e2db86 100644
--- a/drivers/parisc/dino.c
+++ b/drivers/parisc/dino.c
@@ -180,7 +180,7 @@ static int dino_cfg_read(struct pci_bus *bus, unsigned int devfn, int where,
 	void __iomem *base_addr = d->hba.base_addr;
 	unsigned long flags;
 
-	DBG("%s: %p, %d, %d, %d\n", __FUNCTION__, base_addr, devfn, where,
+	DBG("%s: %p, %d, %d, %d\n", __func__, base_addr, devfn, where,
 									size);
 	spin_lock_irqsave(&d->dinosaur_pen, flags);
 
@@ -215,7 +215,7 @@ static int dino_cfg_write(struct pci_bus *bus, unsigned int devfn, int where,
 	void __iomem *base_addr = d->hba.base_addr;
 	unsigned long flags;
 
-	DBG("%s: %p, %d, %d, %d\n", __FUNCTION__, base_addr, devfn, where,
+	DBG("%s: %p, %d, %d, %d\n", __func__, base_addr, devfn, where,
 									size);
 	spin_lock_irqsave(&d->dinosaur_pen, flags);
 
@@ -301,7 +301,7 @@ static void dino_disable_irq(unsigned int irq)
 	struct dino_device *dino_dev = irq_desc[irq].chip_data;
 	int local_irq = gsc_find_local_irq(irq, dino_dev->global_irq, DINO_LOCAL_IRQS);
 
-	DBG(KERN_WARNING "%s(0x%p, %d)\n", __FUNCTION__, dino_dev, irq);
+	DBG(KERN_WARNING "%s(0x%p, %d)\n", __func__, dino_dev, irq);
 
 	/* Clear the matching bit in the IMR register */
 	dino_dev->imr &= ~(DINO_MASK_IRQ(local_irq));
@@ -314,7 +314,7 @@ static void dino_enable_irq(unsigned int irq)
 	int local_irq = gsc_find_local_irq(irq, dino_dev->global_irq, DINO_LOCAL_IRQS);
 	u32 tmp;
 
-	DBG(KERN_WARNING "%s(0x%p, %d)\n", __FUNCTION__, dino_dev, irq);
+	DBG(KERN_WARNING "%s(0x%p, %d)\n", __func__, dino_dev, irq);
 
 	/*
 	** clear pending IRQ bits
@@ -340,7 +340,7 @@ static void dino_enable_irq(unsigned int irq)
 	tmp = __raw_readl(dino_dev->hba.base_addr+DINO_ILR);
 	if (tmp & DINO_MASK_IRQ(local_irq)) {
 		DBG(KERN_WARNING "%s(): IRQ asserted! (ILR 0x%x)\n",
-				__FUNCTION__, tmp);
+				__func__, tmp);
 		gsc_writel(dino_dev->txn_data, dino_dev->txn_addr);
 	}
 }
@@ -388,7 +388,7 @@ ilr_again:
 		int local_irq = __ffs(mask);
 		int irq = dino_dev->global_irq[local_irq];
 		DBG(KERN_DEBUG "%s(%d, %p) mask 0x%x\n",
-			__FUNCTION__, irq, intr_dev, mask);
+			__func__, irq, intr_dev, mask);
 		__do_IRQ(irq);
 		mask &= ~(1 << local_irq);
 	} while (mask);
@@ -567,7 +567,7 @@ dino_fixup_bus(struct pci_bus *bus)
 	int port_base = HBA_PORT_BASE(dino_dev->hba.hba_num);
 
 	DBG(KERN_WARNING "%s(0x%p) bus %d platform_data 0x%p\n",
-	    __FUNCTION__, bus, bus->secondary, 
+	    __func__, bus, bus->secondary, 
 	    bus->bridge->platform_data);
 
 	/* Firmware doesn't set up card-mode dino, so we have to */
diff --git a/drivers/parisc/gsc.c b/drivers/parisc/gsc.c
index 1b3e3fd..f7d088b 100644
--- a/drivers/parisc/gsc.c
+++ b/drivers/parisc/gsc.c
@@ -112,7 +112,7 @@ static void gsc_asic_disable_irq(unsigned int irq)
 	int local_irq = gsc_find_local_irq(irq, irq_dev->global_irq, 32);
 	u32 imr;
 
-	DEBPRINTK(KERN_DEBUG "%s(%d) %s: IMR 0x%x\n", __FUNCTION__, irq,
+	DEBPRINTK(KERN_DEBUG "%s(%d) %s: IMR 0x%x\n", __func__, irq,
 			irq_dev->name, imr);
 
 	/* Disable the IRQ line by clearing the bit in the IMR */
@@ -127,7 +127,7 @@ static void gsc_asic_enable_irq(unsigned int irq)
 	int local_irq = gsc_find_local_irq(irq, irq_dev->global_irq, 32);
 	u32 imr;
 
-	DEBPRINTK(KERN_DEBUG "%s(%d) %s: IMR 0x%x\n", __FUNCTION__, irq,
+	DEBPRINTK(KERN_DEBUG "%s(%d) %s: IMR 0x%x\n", __func__, irq,
 			irq_dev->name, imr);
 
 	/* Enable the IRQ line by setting the bit in the IMR */
diff --git a/drivers/parisc/lasi.c b/drivers/parisc/lasi.c
index cb3d281..bee5100 100644
--- a/drivers/parisc/lasi.c
+++ b/drivers/parisc/lasi.c
@@ -193,7 +193,7 @@ lasi_init_chip(struct parisc_device *dev)
 	dev->irq = gsc_alloc_irq(&gsc_irq);
 	if (dev->irq < 0) {
 		printk(KERN_ERR "%s(): cannot get GSC irq\n",
-				__FUNCTION__);
+				__func__);
 		kfree(lasi);
 		return -EBUSY;
 	}
diff --git a/drivers/parisc/lba_pci.c b/drivers/parisc/lba_pci.c
index 66ce610..a28c894 100644
--- a/drivers/parisc/lba_pci.c
+++ b/drivers/parisc/lba_pci.c
@@ -377,12 +377,12 @@ static int elroy_cfg_read(struct pci_bus *bus, unsigned int devfn, int pos, int
 		/* original - Generate config cycle on broken elroy
 		  with risk we will miss PCI bus errors. */
 		*data = lba_rd_cfg(d, tok, pos, size);
-		DBG_CFG("%s(%x+%2x) -> 0x%x (a)\n", __FUNCTION__, tok, pos, *data);
+		DBG_CFG("%s(%x+%2x) -> 0x%x (a)\n", __func__, tok, pos, *data);
 		return 0;
 	}
 
 	if (LBA_SKIP_PROBE(d) && !lba_device_present(bus->secondary, devfn, d)) {
-		DBG_CFG("%s(%x+%2x) -> -1 (b)\n", __FUNCTION__, tok, pos);
+		DBG_CFG("%s(%x+%2x) -> -1 (b)\n", __func__, tok, pos);
 		/* either don't want to look or know device isn't present. */
 		*data = ~0U;
 		return(0);
@@ -398,7 +398,7 @@ static int elroy_cfg_read(struct pci_bus *bus, unsigned int devfn, int pos, int
 	case 2: *data = READ_REG16(data_reg + (pos & 2)); break;
 	case 4: *data = READ_REG32(data_reg); break;
 	}
-	DBG_CFG("%s(%x+%2x) -> 0x%x (c)\n", __FUNCTION__, tok, pos, *data);
+	DBG_CFG("%s(%x+%2x) -> 0x%x (c)\n", __func__, tok, pos, *data);
 	return 0;
 }
 
@@ -441,16 +441,16 @@ static int elroy_cfg_write(struct pci_bus *bus, unsigned int devfn, int pos, int
 	if (!LBA_SKIP_PROBE(d)) {
 		/* Original Workaround */
 		lba_wr_cfg(d, tok, pos, (u32) data, size);
-		DBG_CFG("%s(%x+%2x) = 0x%x (a)\n", __FUNCTION__, tok, pos,data);
+		DBG_CFG("%s(%x+%2x) = 0x%x (a)\n", __func__, tok, pos,data);
 		return 0;
 	}
 
 	if (LBA_SKIP_PROBE(d) && (!lba_device_present(bus->secondary, devfn, d))) {
-		DBG_CFG("%s(%x+%2x) = 0x%x (b)\n", __FUNCTION__, tok, pos,data);
+		DBG_CFG("%s(%x+%2x) = 0x%x (b)\n", __func__, tok, pos,data);
 		return 1; /* New Workaround */
 	}
 
-	DBG_CFG("%s(%x+%2x) = 0x%x (c)\n", __FUNCTION__, tok, pos, data);
+	DBG_CFG("%s(%x+%2x) = 0x%x (c)\n", __func__, tok, pos, data);
 
 	/* Basic Algorithm */
 	LBA_CFG_ADDR_SETUP(d, tok | pos);
@@ -521,7 +521,7 @@ static int mercury_cfg_write(struct pci_bus *bus, unsigned int devfn, int pos, i
 	if ((pos > 255) || (devfn > 255))
 		return -EINVAL;
 
-	DBG_CFG("%s(%x+%2x) <- 0x%x (c)\n", __FUNCTION__, tok, pos, data);
+	DBG_CFG("%s(%x+%2x) <- 0x%x (c)\n", __func__, tok, pos, data);
 
 	LBA_CFG_TR4_ADDR_SETUP(d, tok | pos);
 	switch(size) {
@@ -890,7 +890,7 @@ LBA_PORT_IN(32, 0)
 #define LBA_PORT_OUT(size, mask) \
 static void lba_astro_out##size (struct pci_hba_data *d, u16 addr, u##size val) \
 { \
-	DBG_PORT("%s(0x%p, 0x%x, 0x%x)\n", __FUNCTION__, d, addr, val); \
+	DBG_PORT("%s(0x%p, 0x%x, 0x%x)\n", __func__, d, addr, val); \
 	WRITE_REG##size(val, astro_iop_base + addr); \
 	if (LBA_DEV(d)->hw_rev < 3) \
 		lba_t32 = READ_U32(d->base_addr + LBA_FUNC_ID); \
@@ -932,7 +932,7 @@ static struct pci_port_ops lba_astro_port_ops = {
 static u##size lba_pat_in##size (struct pci_hba_data *l, u16 addr) \
 { \
 	u##size t; \
-	DBG_PORT("%s(0x%p, 0x%x) ->", __FUNCTION__, l, addr); \
+	DBG_PORT("%s(0x%p, 0x%x) ->", __func__, l, addr); \
 	t = READ_REG##size(PIOP_TO_GMMIO(LBA_DEV(l), addr)); \
 	DBG_PORT(" 0x%x\n", t); \
 	return (t); \
@@ -948,7 +948,7 @@ LBA_PORT_IN(32, 0)
 static void lba_pat_out##size (struct pci_hba_data *l, u16 addr, u##size val) \
 { \
 	void __iomem *where = PIOP_TO_GMMIO(LBA_DEV(l), addr); \
-	DBG_PORT("%s(0x%p, 0x%x, 0x%x)\n", __FUNCTION__, l, addr, val); \
+	DBG_PORT("%s(0x%p, 0x%x, 0x%x)\n", __func__, l, addr, val); \
 	WRITE_REG##size(val, where); \
 	/* flush the I/O down to the elroy at least */ \
 	lba_t32 = READ_U32(l->base_addr + LBA_FUNC_ID); \
@@ -1584,7 +1584,7 @@ void lba_set_iregs(struct parisc_device *lba, u32 ibase, u32 imask)
 	WARN_ON((ibase & 0x001fffff) != 0);
 	WARN_ON((imask & 0x001fffff) != 0);
 	
-	DBG("%s() ibase 0x%x imask 0x%x\n", __FUNCTION__, ibase, imask);
+	DBG("%s() ibase 0x%x imask 0x%x\n", __func__, ibase, imask);
 	WRITE_REG32( imask, base_addr + LBA_IMASK);
 	WRITE_REG32( ibase, base_addr + LBA_IBASE);
 	iounmap(base_addr);
diff --git a/drivers/parisc/led.c b/drivers/parisc/led.c
index 703b85e..f9b1266 100644
--- a/drivers/parisc/led.c
+++ b/drivers/parisc/led.c
@@ -569,7 +569,7 @@ int __init register_led_driver(int model, unsigned long cmd_reg, unsigned long d
 
 	default:
 		printk(KERN_ERR "%s: Wrong LCD/LED model %d !\n",
-		       __FUNCTION__, lcd_info.model);
+		       __func__, lcd_info.model);
 		return 1;
 	}
 	
diff --git a/drivers/parisc/sba_iommu.c b/drivers/parisc/sba_iommu.c
index d06627c..520589c 100644
--- a/drivers/parisc/sba_iommu.c
+++ b/drivers/parisc/sba_iommu.c
@@ -360,7 +360,7 @@ sba_search_bitmap(struct ioc *ioc, unsigned long bits_wanted)
 		}
 		mask = RESMAP_MASK(bits_wanted) >> bitshiftcnt;
 
-		DBG_RES("%s() o %ld %p", __FUNCTION__, o, res_ptr);
+		DBG_RES("%s() o %ld %p", __func__, o, res_ptr);
 		while(res_ptr < res_end)
 		{ 
 			DBG_RES("    %p %lx %lx\n", res_ptr, mask, *res_ptr);
@@ -428,7 +428,7 @@ sba_alloc_range(struct ioc *ioc, size_t size)
 #endif
 
 	DBG_RES("%s(%x) %d -> %lx hint %x/%x\n",
-		__FUNCTION__, size, pages_needed, pide,
+		__func__, size, pages_needed, pide,
 		(uint) ((unsigned long) ioc->res_hint - (unsigned long) ioc->res_map),
 		ioc->res_bitshift );
 
@@ -471,7 +471,7 @@ sba_free_range(struct ioc *ioc, dma_addr_t iova, size_t size)
 	unsigned long m = RESMAP_MASK(bits_not_wanted) >> (pide & (BITS_PER_LONG - 1));
 
 	DBG_RES("%s( ,%x,%x) %x/%lx %x %p %lx\n",
-		__FUNCTION__, (uint) iova, size,
+		__func__, (uint) iova, size,
 		bits_not_wanted, m, pide, res_ptr, *res_ptr);
 
 #ifdef SBA_COLLECT_STATS
@@ -714,7 +714,7 @@ sba_map_single(struct device *dev, void *addr, size_t size,
 	iovp = (dma_addr_t) pide << IOVP_SHIFT;
 
 	DBG_RUN("%s() 0x%p -> 0x%lx\n",
-		__FUNCTION__, addr, (long) iovp | offset);
+		__func__, addr, (long) iovp | offset);
 
 	pdir_start = &(ioc->pdir_base[pide]);
 
@@ -772,7 +772,7 @@ sba_unmap_single(struct device *dev, dma_addr_t iova, size_t size,
 	unsigned long flags; 
 	dma_addr_t offset;
 
-	DBG_RUN("%s() iovp 0x%lx/%x\n", __FUNCTION__, (long) iova, size);
+	DBG_RUN("%s() iovp 0x%lx/%x\n", __func__, (long) iova, size);
 
 	ioc = GET_IOC(dev);
 	offset = iova & ~IOVP_MASK;
@@ -911,7 +911,7 @@ sba_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
 	int coalesced, filled = 0;
 	unsigned long flags;
 
-	DBG_RUN_SG("%s() START %d entries\n", __FUNCTION__, nents);
+	DBG_RUN_SG("%s() START %d entries\n", __func__, nents);
 
 	ioc = GET_IOC(dev);
 
@@ -972,7 +972,7 @@ sba_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
 
 	spin_unlock_irqrestore(&ioc->res_lock, flags);
 
-	DBG_RUN_SG("%s() DONE %d mappings\n", __FUNCTION__, filled);
+	DBG_RUN_SG("%s() DONE %d mappings\n", __func__, filled);
 
 	return filled;
 }
@@ -997,7 +997,7 @@ sba_unmap_sg(struct device *dev, struct scatterlist *sglist, int nents,
 #endif
 
 	DBG_RUN_SG("%s() START %d entries,  %p,%x\n",
-		__FUNCTION__, nents, sg_virt_addr(sglist), sglist->length);
+		__func__, nents, sg_virt_addr(sglist), sglist->length);
 
 	ioc = GET_IOC(dev);
 
@@ -1021,7 +1021,7 @@ sba_unmap_sg(struct device *dev, struct scatterlist *sglist, int nents,
 		++sglist;
 	}
 
-	DBG_RUN_SG("%s() DONE (nents %d)\n", __FUNCTION__,  nents);
+	DBG_RUN_SG("%s() DONE (nents %d)\n", __func__,  nents);
 
 #ifdef ASSERT_PDIR_SANITY
 	spin_lock_irqsave(&ioc->res_lock, flags);
@@ -1092,7 +1092,7 @@ sba_alloc_pdir(unsigned int pdir_size)
 	pdir_base = __get_free_pages(GFP_KERNEL, pdir_order);
 	if (NULL == (void *) pdir_base)	{
 		panic("%s() could not allocate I/O Page Table\n",
-			__FUNCTION__);
+			__func__);
 	}
 
 	/* If this is not PA8700 (PCX-W2)
@@ -1235,7 +1235,7 @@ sba_ioc_init_pluto(struct parisc_device *sba, struct ioc *ioc, int ioc_num)
 	ioc->pdir_size = (iova_space_size / IOVP_SIZE) * sizeof(u64);
 
 	DBG_INIT("%s() hpa 0x%p IOV %dMB (%d bits)\n",
-		__FUNCTION__, ioc->ioc_hpa, iova_space_size >> 20,
+		__func__, ioc->ioc_hpa, iova_space_size >> 20,
 		iov_order + PAGE_SHIFT);
 
 	ioc->pdir_base = (void *) __get_free_pages(GFP_KERNEL,
@@ -1246,7 +1246,7 @@ sba_ioc_init_pluto(struct parisc_device *sba, struct ioc *ioc, int ioc_num)
 	memset(ioc->pdir_base, 0, ioc->pdir_size);
 
 	DBG_INIT("%s() pdir %p size %x\n",
-			__FUNCTION__, ioc->pdir_base, ioc->pdir_size);
+			__func__, ioc->pdir_base, ioc->pdir_size);
 
 #ifdef SBA_HINT_SUPPORT
 	ioc->hint_shift_pdir = iov_order + PAGE_SHIFT;
@@ -1328,7 +1328,7 @@ sba_ioc_init_pluto(struct parisc_device *sba, struct ioc *ioc, int ioc_num)
 
 	if (agp_found && sba_reserve_agpgart) {
 		printk(KERN_INFO "%s: reserving %dMb of IOVA space for agpgart\n",
-		       __FUNCTION__, (iova_space_size/2) >> 20);
+		       __func__, (iova_space_size/2) >> 20);
 		ioc->pdir_size /= 2;
 		ioc->pdir_base[PDIR_INDEX(iova_space_size/2)] = SBA_AGPGART_COOKIE;
 	}
@@ -1380,7 +1380,7 @@ sba_ioc_init(struct parisc_device *sba, struct ioc *ioc, int ioc_num)
 	ioc->pdir_size = pdir_size = (iova_space_size/IOVP_SIZE) * sizeof(u64);
 
 	DBG_INIT("%s() hpa 0x%lx mem %ldMB IOV %dMB (%d bits)\n",
-			__FUNCTION__,
+			__func__,
 			ioc->ioc_hpa,
 			(unsigned long) num_physpages >> (20 - PAGE_SHIFT),
 			iova_space_size>>20,
@@ -1389,7 +1389,7 @@ sba_ioc_init(struct parisc_device *sba, struct ioc *ioc, int ioc_num)
 	ioc->pdir_base = sba_alloc_pdir(pdir_size);
 
 	DBG_INIT("%s() pdir %p size %x\n",
-			__FUNCTION__, ioc->pdir_base, pdir_size);
+			__func__, ioc->pdir_base, pdir_size);
 
 #ifdef SBA_HINT_SUPPORT
 	/* FIXME : DMA HINTs not used */
@@ -1417,7 +1417,7 @@ sba_ioc_init(struct parisc_device *sba, struct ioc *ioc, int ioc_num)
 #endif
 
 	DBG_INIT("%s() IOV base 0x%lx mask 0x%0lx\n",
-		__FUNCTION__, ioc->ibase, ioc->imask);
+		__func__, ioc->ibase, ioc->imask);
 
 	/*
 	** FIXME: Hint registers are programmed with default hint
@@ -1444,7 +1444,7 @@ sba_ioc_init(struct parisc_device *sba, struct ioc *ioc, int ioc_num)
 
 	ioc->ibase = 0; /* used by SBA_IOVA and related macros */	
 
-	DBG_INIT("%s() DONE\n", __FUNCTION__);
+	DBG_INIT("%s() DONE\n", __func__);
 }
 

@@ -1518,7 +1518,7 @@ printk("sba_hw_init(): mem_boot 0x%x 0x%x 0x%x 0x%x\n", PAGE0->mem_boot.hpa,
 	if (!IS_PLUTO(sba_dev->dev)) {
 		ioc_ctl = READ_REG(sba_dev->sba_hpa+IOC_CTRL);
 		DBG_INIT("%s() hpa 0x%lx ioc_ctl 0x%Lx ->",
-			__FUNCTION__, sba_dev->sba_hpa, ioc_ctl);
+			__func__, sba_dev->sba_hpa, ioc_ctl);
 		ioc_ctl &= ~(IOC_CTRL_RM | IOC_CTRL_NC | IOC_CTRL_CE);
 		ioc_ctl |= IOC_CTRL_DD | IOC_CTRL_D4 | IOC_CTRL_TC;
 			/* j6700 v1.6 firmware sets 0x294f */
@@ -1649,7 +1649,7 @@ sba_common_init(struct sba_device *sba_dev)
 
 		res_size >>= 3;  /* convert bit count to byte count */
 		DBG_INIT("%s() res_size 0x%x\n",
-			__FUNCTION__, res_size);
+			__func__, res_size);
 
 		sba_dev->ioc[i].res_size = res_size;
 		sba_dev->ioc[i].res_map = (char *) __get_free_pages(GFP_KERNEL, get_order(res_size));
@@ -1662,7 +1662,7 @@ sba_common_init(struct sba_device *sba_dev)
 		if (NULL == sba_dev->ioc[i].res_map)
 		{
 			panic("%s:%s() could not allocate resource map\n",
-			      __FILE__, __FUNCTION__ );
+			      __FILE__, __func__ );
 		}
 
 		memset(sba_dev->ioc[i].res_map, 0, res_size);
@@ -1699,7 +1699,7 @@ sba_common_init(struct sba_device *sba_dev)
 #endif
 
 		DBG_INIT("%s() %d res_map %x %p\n",
-			__FUNCTION__, i, res_size, sba_dev->ioc[i].res_map);
+			__func__, i, res_size, sba_dev->ioc[i].res_map);
 	}
 
 	spin_lock_init(&sba_dev->sba_lock);
diff --git a/drivers/parisc/wax.c b/drivers/parisc/wax.c
index 813c2c2..892a83b 100644
--- a/drivers/parisc/wax.c
+++ b/drivers/parisc/wax.c
@@ -93,7 +93,7 @@ wax_init_chip(struct parisc_device *dev)
 	dev->irq = gsc_claim_irq(&gsc_irq, WAX_GSC_IRQ);
 	if (dev->irq < 0) {
 		printk(KERN_ERR "%s(): cannot get GSC irq\n",
-				__FUNCTION__);
+				__func__);
 		kfree(wax);
 		return -EBUSY;
 	}
-- 
1.5.4.3.500.g83a2c


