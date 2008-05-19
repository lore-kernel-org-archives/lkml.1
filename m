Return-Path: <linux-kernel-owner+w=401wt.eu-S1753631AbYESGey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631AbYESGey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 02:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756137AbYESGei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 02:34:38 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:46550 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756907AbYESGeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 02:34:31 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: amit.shah@qumranet.com, akpm@linux-foundation.org, muli@il.ibm.com,
       alexisb@us.ibm.com, andi@firstfloor.org,
       kvm-devel@lists.sourceforge.net, avi@qumranet.com,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH v2 -mm 1/2] add the device argument to dma_mapping_error
Date: Mon, 19 May 2008 15:31:28 +0900
Message-Id: <1211178689-3507-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.4.2
In-Reply-To: <1211178689-3507-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1211178689-3507-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma_mapping_error doesn't take a pointer to the device unlike other
DMA operations. So we can't have dma_mapping_ops per device.

Note that POWER already has dma_mapping_ops per device but all the
POWER IOMMUs use the same dma_mapping_error function. x86 IOMMUs use
different dma_mapping_error functions. So dma_mapping_error needs the
device argument.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 Documentation/DMA-API.txt                      |    4 +-
 arch/arm/common/dmabounce.c                    |    2 +-
 arch/ia64/hp/common/hwsw_iommu.c               |    5 ++-
 arch/ia64/hp/common/sba_iommu.c                |    2 +-
 arch/ia64/sn/pci/pci_dma.c                     |    2 +-
 arch/mips/mm/dma-default.c                     |    2 +-
 arch/powerpc/platforms/cell/celleb_scc_pciex.c |    2 +-
 arch/powerpc/platforms/cell/spider-pci.c       |    2 +-
 arch/powerpc/platforms/iseries/mf.c            |    2 +-
 arch/x86/kernel/pci-gart_64.c                  |    1 -
 arch/x86/kernel/pci-nommu.c                    |    2 +-
 drivers/firewire/fw-iso.c                      |    2 +-
 drivers/firewire/fw-ohci.c                     |    2 +-
 drivers/firewire/fw-sbp2.c                     |    8 +++---
 drivers/infiniband/hw/ipath/ipath_sdma.c       |    2 +-
 drivers/infiniband/hw/ipath/ipath_user_sdma.c  |    6 ++--
 drivers/infiniband/hw/mthca/mthca_eq.c         |    2 +-
 drivers/media/dvb/pluto2/pluto2.c              |    2 +-
 drivers/net/arm/ep93xx_eth.c                   |    4 +-
 drivers/net/b44.c                              |   22 +++++++++-------
 drivers/net/bnx2x.c                            |    2 +-
 drivers/net/e100.c                             |    2 +-
 drivers/net/e1000e/ethtool.c                   |    4 +-
 drivers/net/e1000e/netdev.c                    |   11 ++++---
 drivers/net/ibmveth.c                          |   32 ++++++++++++-----------
 drivers/net/iseries_veth.c                     |    4 +-
 drivers/net/mlx4/eq.c                          |    2 +-
 drivers/net/pasemi_mac.c                       |    6 ++--
 drivers/net/qla3xxx.c                          |   12 ++++----
 drivers/net/sfc/rx.c                           |    4 +-
 drivers/net/sfc/tx.c                           |    7 +++--
 drivers/net/spider_net.c                       |    4 +-
 drivers/net/tc35815.c                          |    4 +-
 drivers/net/wireless/ath5k/base.c              |    4 +-
 drivers/net/wireless/b43/dma.c                 |    2 +-
 drivers/net/wireless/b43legacy/dma.c           |    2 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c               |    4 +-
 drivers/scsi/ibmvscsi/ibmvstgt.c               |    2 +-
 drivers/scsi/ibmvscsi/rpa_vscsi.c              |    2 +-
 drivers/spi/atmel_spi.c                        |    4 +-
 drivers/spi/au1550_spi.c                       |    6 ++--
 drivers/spi/omap2_mcspi.c                      |    4 +-
 drivers/spi/pxa2xx_spi.c                       |    4 +-
 drivers/spi/spi_imx.c                          |    6 ++--
 include/asm-alpha/dma-mapping.h                |    6 ++--
 include/asm-alpha/pci.h                        |    2 +-
 include/asm-arm/dma-mapping.h                  |    2 +-
 include/asm-avr32/dma-mapping.h                |    2 +-
 include/asm-cris/dma-mapping.h                 |    2 +-
 include/asm-frv/dma-mapping.h                  |    2 +-
 include/asm-generic/dma-mapping-broken.h       |    2 +-
 include/asm-generic/dma-mapping.h              |    4 +-
 include/asm-generic/pci-dma-compat.h           |    4 +-
 include/asm-ia64/machvec.h                     |    2 +-
 include/asm-m68k/dma-mapping.h                 |    2 +-
 include/asm-mips/dma-mapping.h                 |    2 +-
 include/asm-mn10300/dma-mapping.h              |    2 +-
 include/asm-parisc/dma-mapping.h               |    2 +-
 include/asm-powerpc/dma-mapping.h              |    2 +-
 include/asm-sh/dma-mapping.h                   |    2 +-
 include/asm-sparc/pci.h                        |    3 +-
 include/asm-sparc64/dma-mapping.h              |    2 +-
 include/asm-sparc64/pci.h                      |    5 ++-
 include/asm-x86/dma-mapping.h                  |    7 +++--
 include/asm-x86/swiotlb.h                      |    2 +-
 include/asm-xtensa/dma-mapping.h               |    2 +-
 include/linux/i2o.h                            |    2 +-
 include/rdma/ib_verbs.h                        |    2 +-
 lib/swiotlb.c                                  |    4 +-
 69 files changed, 144 insertions(+), 135 deletions(-)

diff --git a/Documentation/DMA-API.txt b/Documentation/DMA-API.txt
index 80d1504..d8b63d1 100644
--- a/Documentation/DMA-API.txt
+++ b/Documentation/DMA-API.txt
@@ -298,10 +298,10 @@ recommended that you never use these unless you really know what the
 cache width is.
 
 int
-dma_mapping_error(dma_addr_t dma_addr)
+dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 
 int
-pci_dma_mapping_error(dma_addr_t dma_addr)
+pci_dma_mapping_error(struct pci_dev *hwdev, dma_addr_t dma_addr)
 
 In some circumstances dma_map_single and dma_map_page will fail to create
 a mapping. A driver can check for these errors by testing the returned
diff --git a/arch/arm/common/dmabounce.c b/arch/arm/common/dmabounce.c
index 59800a5..f10d348 100644
--- a/arch/arm/common/dmabounce.c
+++ b/arch/arm/common/dmabounce.c
@@ -280,7 +280,7 @@ unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
 	/*
 	 * Trying to unmap an invalid mapping
 	 */
-	if (dma_mapping_error(dma_addr)) {
+	if (dma_mapping_error(dev, dma_addr)) {
 		dev_err(dev, "Trying to unmap invalid mapping\n");
 		return;
 	}
diff --git a/arch/ia64/hp/common/hwsw_iommu.c b/arch/ia64/hp/common/hwsw_iommu.c
index 1c44ec2..88b6e6f 100644
--- a/arch/ia64/hp/common/hwsw_iommu.c
+++ b/arch/ia64/hp/common/hwsw_iommu.c
@@ -186,9 +186,10 @@ hwsw_dma_supported (struct device *dev, u64 mask)
 }
 
 int
-hwsw_dma_mapping_error (dma_addr_t dma_addr)
+hwsw_dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
-	return hwiommu_dma_mapping_error (dma_addr) || swiotlb_dma_mapping_error(dma_addr);
+	return hwiommu_dma_mapping_error(dev, dma_addr) ||
+		swiotlb_dma_mapping_error(dev, dma_addr);
 }
 
 EXPORT_SYMBOL(hwsw_dma_mapping_error);
diff --git a/arch/ia64/hp/common/sba_iommu.c b/arch/ia64/hp/common/sba_iommu.c
index 34421ae..4956be4 100644
--- a/arch/ia64/hp/common/sba_iommu.c
+++ b/arch/ia64/hp/common/sba_iommu.c
@@ -2147,7 +2147,7 @@ sba_dma_supported (struct device *dev, u64 mask)
 }
 
 int
-sba_dma_mapping_error (dma_addr_t dma_addr)
+sba_dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 	return 0;
 }
diff --git a/arch/ia64/sn/pci/pci_dma.c b/arch/ia64/sn/pci/pci_dma.c
index 52175af..53ebb64 100644
--- a/arch/ia64/sn/pci/pci_dma.c
+++ b/arch/ia64/sn/pci/pci_dma.c
@@ -350,7 +350,7 @@ void sn_dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
 }
 EXPORT_SYMBOL(sn_dma_sync_sg_for_device);
 
-int sn_dma_mapping_error(dma_addr_t dma_addr)
+int sn_dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 	return 0;
 }
diff --git a/arch/mips/mm/dma-default.c b/arch/mips/mm/dma-default.c
index ae39dd8..891312f 100644
--- a/arch/mips/mm/dma-default.c
+++ b/arch/mips/mm/dma-default.c
@@ -348,7 +348,7 @@ void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg, int nele
 
 EXPORT_SYMBOL(dma_sync_sg_for_device);
 
-int dma_mapping_error(dma_addr_t dma_addr)
+int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 	return 0;
 }
diff --git a/arch/powerpc/platforms/cell/celleb_scc_pciex.c b/arch/powerpc/platforms/cell/celleb_scc_pciex.c
index 31da84c..d3f1102 100644
--- a/arch/powerpc/platforms/cell/celleb_scc_pciex.c
+++ b/arch/powerpc/platforms/cell/celleb_scc_pciex.c
@@ -280,7 +280,7 @@ static int __init scc_pciex_iowa_init(struct iowa_bus *bus, void *data)
 
 	dummy_page_da = dma_map_single(bus->phb->parent, dummy_page_va,
 				       PAGE_SIZE, DMA_FROM_DEVICE);
-	if (dma_mapping_error(dummy_page_da)) {
+	if (dma_mapping_error(bus->phb->parent, dummy_page_da)) {
 		pr_err("PCIEX:Map dummy page failed.\n");
 		kfree(dummy_page_va);
 		return -1;
diff --git a/arch/powerpc/platforms/cell/spider-pci.c b/arch/powerpc/platforms/cell/spider-pci.c
index 418b605..5122ec1 100644
--- a/arch/powerpc/platforms/cell/spider-pci.c
+++ b/arch/powerpc/platforms/cell/spider-pci.c
@@ -111,7 +111,7 @@ static int __init spiderpci_pci_setup_chip(struct pci_controller *phb,
 
 	dummy_page_da = dma_map_single(phb->parent, dummy_page_va,
 				       PAGE_SIZE, DMA_FROM_DEVICE);
-	if (dma_mapping_error(dummy_page_da)) {
+	if (dma_mapping_error(phb->parent, dummy_page_da)) {
 		pr_err("SPIDER-IOWA:Map dummy page filed.\n");
 		kfree(dummy_page_va);
 		return -1;
diff --git a/arch/powerpc/platforms/iseries/mf.c b/arch/powerpc/platforms/iseries/mf.c
index 1dc7295..731d7b1 100644
--- a/arch/powerpc/platforms/iseries/mf.c
+++ b/arch/powerpc/platforms/iseries/mf.c
@@ -871,7 +871,7 @@ static int proc_mf_dump_cmdline(char *page, char **start, off_t off,
 		count = 256 - off;
 
 	dma_addr = iseries_hv_map(page, off + count, DMA_FROM_DEVICE);
-	if (dma_mapping_error(dma_addr))
+	if (dma_mapping_error(NULL, dma_addr))
 		return -ENOMEM;
 	memset(page, 0, off + count);
 	memset(&vsp_cmd, 0, sizeof(vsp_cmd));
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 6371898..020cadd 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -620,7 +620,6 @@ static __init int init_k8_gatt(struct agp_kern_info *info)
 extern int agp_amd64_init(void);
 
 static const struct dma_mapping_ops gart_dma_ops = {
-	.mapping_error			= NULL,
 	.map_single			= gart_map_single,
 	.map_simple			= gart_map_simple,
 	.unmap_single			= gart_unmap_single,
diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
index aec43d5..05d70b8 100644
--- a/arch/x86/kernel/pci-nommu.c
+++ b/arch/x86/kernel/pci-nommu.c
@@ -73,7 +73,7 @@ static int nommu_map_sg(struct device *hwdev, struct scatterlist *sg,
 }
 
 /* Make sure we keep the same behaviour */
-static int nommu_mapping_error(dma_addr_t dma_addr)
+static int nommu_mapping_error(struct device *hwdev, dma_addr_t dma_addr)
 {
 #ifdef CONFIG_X86_32
 	return 0;
diff --git a/drivers/firewire/fw-iso.c b/drivers/firewire/fw-iso.c
index bcbe794..e14c03d 100644
--- a/drivers/firewire/fw-iso.c
+++ b/drivers/firewire/fw-iso.c
@@ -50,7 +50,7 @@ fw_iso_buffer_init(struct fw_iso_buffer *buffer, struct fw_card *card,
 
 		address = dma_map_page(card->device, buffer->pages[i],
 				       0, PAGE_SIZE, direction);
-		if (dma_mapping_error(address)) {
+		if (dma_mapping_error(card->device, address)) {
 			__free_page(buffer->pages[i]);
 			goto out_pages;
 		}
diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c
index 4f02c55..b63f380 100644
--- a/drivers/firewire/fw-ohci.c
+++ b/drivers/firewire/fw-ohci.c
@@ -953,7 +953,7 @@ at_context_queue_packet(struct context *ctx, struct fw_packet *packet)
 		payload_bus =
 			dma_map_single(ohci->card.device, packet->payload,
 				       packet->payload_length, DMA_TO_DEVICE);
-		if (dma_mapping_error(payload_bus)) {
+		if (dma_mapping_error(ohci->card.device, payload_bus)) {
 			packet->ack = RCODE_SEND_ERROR;
 			return -1;
 		}
diff --git a/drivers/firewire/fw-sbp2.c b/drivers/firewire/fw-sbp2.c
index b2458bb..1abc567 100644
--- a/drivers/firewire/fw-sbp2.c
+++ b/drivers/firewire/fw-sbp2.c
@@ -528,7 +528,7 @@ sbp2_send_management_orb(struct sbp2_logical_unit *lu, int node_id,
 	orb->response_bus =
 		dma_map_single(device->card->device, &orb->response,
 			       sizeof(orb->response), DMA_FROM_DEVICE);
-	if (dma_mapping_error(orb->response_bus))
+	if (dma_mapping_error(device->card->device, orb->response_bus))
 		goto fail_mapping_response;
 
 	orb->request.response.high = 0;
@@ -562,7 +562,7 @@ sbp2_send_management_orb(struct sbp2_logical_unit *lu, int node_id,
 	orb->base.request_bus =
 		dma_map_single(device->card->device, &orb->request,
 			       sizeof(orb->request), DMA_TO_DEVICE);
-	if (dma_mapping_error(orb->base.request_bus))
+	if (dma_mapping_error(device->card->device, orb->base.request_bus))
 		goto fail_mapping_request;
 
 	sbp2_send_orb(&orb->base, lu, node_id, generation,
@@ -1408,7 +1408,7 @@ sbp2_map_scatterlist(struct sbp2_command_orb *orb, struct fw_device *device,
 	orb->page_table_bus =
 		dma_map_single(device->card->device, orb->page_table,
 			       sizeof(orb->page_table), DMA_TO_DEVICE);
-	if (dma_mapping_error(orb->page_table_bus))
+	if (dma_mapping_error(device->card->device, orb->page_table_bus))
 		goto fail_page_table;
 
 	/*
@@ -1493,7 +1493,7 @@ static int sbp2_scsi_queuecommand(struct scsi_cmnd *cmd, scsi_done_fn_t done)
 	orb->base.request_bus =
 		dma_map_single(device->card->device, &orb->request,
 			       sizeof(orb->request), DMA_TO_DEVICE);
-	if (dma_mapping_error(orb->base.request_bus))
+	if (dma_mapping_error(device->card->device, orb->base.request_bus))
 		goto out;
 
 	sbp2_send_orb(&orb->base, lu, lu->tgt->node_id, lu->generation,
diff --git a/drivers/infiniband/hw/ipath/ipath_sdma.c b/drivers/infiniband/hw/ipath/ipath_sdma.c
index 3697449..1ab6258 100644
--- a/drivers/infiniband/hw/ipath/ipath_sdma.c
+++ b/drivers/infiniband/hw/ipath/ipath_sdma.c
@@ -702,7 +702,7 @@ retry:
 
 	addr = dma_map_single(&dd->pcidev->dev, tx->txreq.map_addr,
 			      tx->map_len, DMA_TO_DEVICE);
-	if (dma_mapping_error(addr)) {
+	if (dma_mapping_error(&dd->pcidev->dev, addr)) {
 		ret = -EIO;
 		goto unlock;
 	}
diff --git a/drivers/infiniband/hw/ipath/ipath_user_sdma.c b/drivers/infiniband/hw/ipath/ipath_user_sdma.c
index 86e0169..82d9a0b 100644
--- a/drivers/infiniband/hw/ipath/ipath_user_sdma.c
+++ b/drivers/infiniband/hw/ipath/ipath_user_sdma.c
@@ -206,7 +206,7 @@ static int ipath_user_sdma_coalesce(const struct ipath_devdata *dd,
 
 	dma_addr = dma_map_page(&dd->pcidev->dev, page, 0, len,
 				DMA_TO_DEVICE);
-	if (dma_mapping_error(dma_addr)) {
+	if (dma_mapping_error(&dd->pcidev->dev, dma_addr)) {
 		ret = -ENOMEM;
 		goto free_unmap;
 	}
@@ -301,7 +301,7 @@ static int ipath_user_sdma_pin_pages(const struct ipath_devdata *dd,
 				     pages[j], 0, flen, DMA_TO_DEVICE);
 		unsigned long fofs = addr & ~PAGE_MASK;
 
-		if (dma_mapping_error(dma_addr)) {
+		if (dma_mapping_error(&dd->pcidev->dev, dma_addr)) {
 			ret = -ENOMEM;
 			goto done;
 		}
@@ -508,7 +508,7 @@ static int ipath_user_sdma_queue_pkts(const struct ipath_devdata *dd,
 		if (page) {
 			dma_addr = dma_map_page(&dd->pcidev->dev,
 						page, 0, len, DMA_TO_DEVICE);
-			if (dma_mapping_error(dma_addr)) {
+			if (dma_mapping_error(&dd->pcidev->dev, dma_addr)) {
 				ret = -ENOMEM;
 				goto free_pbc;
 			}
diff --git a/drivers/infiniband/hw/mthca/mthca_eq.c b/drivers/infiniband/hw/mthca/mthca_eq.c
index 8bde7f9..b757c53 100644
--- a/drivers/infiniband/hw/mthca/mthca_eq.c
+++ b/drivers/infiniband/hw/mthca/mthca_eq.c
@@ -782,7 +782,7 @@ int mthca_map_eq_icm(struct mthca_dev *dev, u64 icm_virt)
 		return -ENOMEM;
 	dev->eq_table.icm_dma  = pci_map_page(dev->pdev, dev->eq_table.icm_page, 0,
 					      PAGE_SIZE, PCI_DMA_BIDIRECTIONAL);
-	if (pci_dma_mapping_error(dev->eq_table.icm_dma)) {
+	if (pci_dma_mapping_error(dev->pdev, dev->eq_table.icm_dma)) {
 		__free_page(dev->eq_table.icm_page);
 		return -ENOMEM;
 	}
diff --git a/drivers/media/dvb/pluto2/pluto2.c b/drivers/media/dvb/pluto2/pluto2.c
index 960ed57..36df2b0 100644
--- a/drivers/media/dvb/pluto2/pluto2.c
+++ b/drivers/media/dvb/pluto2/pluto2.c
@@ -242,7 +242,7 @@ static int __devinit pluto_dma_map(struct pluto *pluto)
 	pluto->dma_addr = pci_map_single(pluto->pdev, pluto->dma_buf,
 			TS_DMA_BYTES, PCI_DMA_FROMDEVICE);
 
-	return pci_dma_mapping_error(pluto->dma_addr);
+	return pci_dma_mapping_error(pluto->pdev, pluto->dma_addr);
 }
 
 static void pluto_dma_unmap(struct pluto *pluto)
diff --git a/drivers/net/arm/ep93xx_eth.c b/drivers/net/arm/ep93xx_eth.c
index ecd8fc6..09a7c7b 100644
--- a/drivers/net/arm/ep93xx_eth.c
+++ b/drivers/net/arm/ep93xx_eth.c
@@ -482,7 +482,7 @@ static int ep93xx_alloc_buffers(struct ep93xx_priv *ep)
 			goto err;
 
 		d = dma_map_single(NULL, page, PAGE_SIZE, DMA_FROM_DEVICE);
-		if (dma_mapping_error(d)) {
+		if (dma_mapping_error(NULL, d)) {
 			free_page((unsigned long)page);
 			goto err;
 		}
@@ -505,7 +505,7 @@ static int ep93xx_alloc_buffers(struct ep93xx_priv *ep)
 			goto err;
 
 		d = dma_map_single(NULL, page, PAGE_SIZE, DMA_TO_DEVICE);
-		if (dma_mapping_error(d)) {
+		if (dma_mapping_error(NULL, d)) {
 			free_page((unsigned long)page);
 			goto err;
 		}
diff --git a/drivers/net/b44.c b/drivers/net/b44.c
index 59dce6a..2b51034 100644
--- a/drivers/net/b44.c
+++ b/drivers/net/b44.c
@@ -659,10 +659,10 @@ static int b44_alloc_rx_skb(struct b44 *bp, int src_idx, u32 dest_idx_unmasked)
 
 	/* Hardware bug work-around, the chip is unable to do PCI DMA
 	   to/from anything above 1GB :-( */
-	if (dma_mapping_error(mapping) ||
+	if (dma_mapping_error(bp->sdev->dma_dev, mapping) ||
 		mapping + RX_PKT_BUF_SZ > DMA_30BIT_MASK) {
 		/* Sigh... */
-		if (!dma_mapping_error(mapping))
+		if (!dma_mapping_error(bp->sdev->dma_dev, mapping))
 			dma_unmap_single(bp->sdev->dma_dev, mapping,
 					RX_PKT_BUF_SZ, DMA_FROM_DEVICE);
 		dev_kfree_skb_any(skb);
@@ -672,9 +672,9 @@ static int b44_alloc_rx_skb(struct b44 *bp, int src_idx, u32 dest_idx_unmasked)
 		mapping = dma_map_single(bp->sdev->dma_dev, skb->data,
 					 RX_PKT_BUF_SZ,
 					 DMA_FROM_DEVICE);
-		if (dma_mapping_error(mapping) ||
+		if (dma_mapping_error(bp->sdev->dma_dev, mapping) ||
 			mapping + RX_PKT_BUF_SZ > DMA_30BIT_MASK) {
-			if (!dma_mapping_error(mapping))
+			if (!dma_mapping_error(bp->sdev->dma_dev, mapping))
 				dma_unmap_single(bp->sdev->dma_dev, mapping, RX_PKT_BUF_SZ,DMA_FROM_DEVICE);
 			dev_kfree_skb_any(skb);
 			return -ENOMEM;
@@ -967,11 +967,12 @@ static int b44_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	mapping = dma_map_single(bp->sdev->dma_dev, skb->data, len, DMA_TO_DEVICE);
-	if (dma_mapping_error(mapping) || mapping + len > DMA_30BIT_MASK) {
+	if (dma_mapping_error(bp->sdev->dma_dev, mapping) ||
+	    mapping + len > DMA_30BIT_MASK) {
 		struct sk_buff *bounce_skb;
 
 		/* Chip can't handle DMA to/from >1GB, use bounce buffer */
-		if (!dma_mapping_error(mapping))
+		if (!dma_mapping_error(bp->sdev->dma_dev, mapping))
 			dma_unmap_single(bp->sdev->dma_dev, mapping, len,
 					DMA_TO_DEVICE);
 
@@ -981,8 +982,9 @@ static int b44_start_xmit(struct sk_buff *skb, struct net_device *dev)
 
 		mapping = dma_map_single(bp->sdev->dma_dev, bounce_skb->data,
 					 len, DMA_TO_DEVICE);
-		if (dma_mapping_error(mapping) || mapping + len > DMA_30BIT_MASK) {
-			if (!dma_mapping_error(mapping))
+		if (dma_mapping_error(bp->sdev->dma_dev, mapping) ||
+		    mapping + len > DMA_30BIT_MASK) {
+			if (!dma_mapping_error(bp->sdev->dma_dev, mapping))
 				dma_unmap_single(bp->sdev->dma_dev, mapping,
 					 len, DMA_TO_DEVICE);
 			dev_kfree_skb_any(bounce_skb);
@@ -1203,7 +1205,7 @@ static int b44_alloc_consistent(struct b44 *bp, gfp_t gfp)
 			                    DMA_TABLE_BYTES,
 			                    DMA_BIDIRECTIONAL);
 
-		if (dma_mapping_error(rx_ring_dma) ||
+		if (dma_mapping_error(bp->sdev->dma_dev, rx_ring_dma) ||
 			rx_ring_dma + size > DMA_30BIT_MASK) {
 			kfree(rx_ring);
 			goto out_err;
@@ -1230,7 +1232,7 @@ static int b44_alloc_consistent(struct b44 *bp, gfp_t gfp)
 			                    DMA_TABLE_BYTES,
 			                    DMA_TO_DEVICE);
 
-		if (dma_mapping_error(tx_ring_dma) ||
+		if (dma_mapping_error(bp->sdev->dma_dev, tx_ring_dma) ||
 			tx_ring_dma + size > DMA_30BIT_MASK) {
 			kfree(tx_ring);
 			goto out_err;
diff --git a/drivers/net/bnx2x.c b/drivers/net/bnx2x.c
index 7bdb5af..f92eb9d 100644
--- a/drivers/net/bnx2x.c
+++ b/drivers/net/bnx2x.c
@@ -833,7 +833,7 @@ static inline int bnx2x_alloc_rx_skb(struct bnx2x *bp,
 
 	mapping = pci_map_single(bp->pdev, skb->data, bp->rx_buf_use_size,
 				 PCI_DMA_FROMDEVICE);
-	if (unlikely(dma_mapping_error(mapping))) {
+	if (unlikely(dma_mapping_error(bp->pdev, mapping))) {
 
 		dev_kfree_skb(skb);
 		return -ENOMEM;
diff --git a/drivers/net/e100.c b/drivers/net/e100.c
index f3cba5e..7f38cb3 100644
--- a/drivers/net/e100.c
+++ b/drivers/net/e100.c
@@ -1790,7 +1790,7 @@ static int e100_rx_alloc_skb(struct nic *nic, struct rx *rx)
 	rx->dma_addr = pci_map_single(nic->pdev, rx->skb->data,
 		RFD_BUF_LEN, PCI_DMA_BIDIRECTIONAL);
 
-	if (pci_dma_mapping_error(rx->dma_addr)) {
+	if (pci_dma_mapping_error(nic->pdev, rx->dma_addr)) {
 		dev_kfree_skb_any(rx->skb);
 		rx->skb = NULL;
 		rx->dma_addr = 0;
diff --git a/drivers/net/e1000e/ethtool.c b/drivers/net/e1000e/ethtool.c
index a14561f..9350564 100644
--- a/drivers/net/e1000e/ethtool.c
+++ b/drivers/net/e1000e/ethtool.c
@@ -1090,7 +1090,7 @@ static int e1000_setup_desc_rings(struct e1000_adapter *adapter)
 		tx_ring->buffer_info[i].dma =
 			pci_map_single(pdev, skb->data, skb->len,
 				       PCI_DMA_TODEVICE);
-		if (pci_dma_mapping_error(tx_ring->buffer_info[i].dma)) {
+		if (pci_dma_mapping_error(pdev, tx_ring->buffer_info[i].dma)) {
 			ret_val = 4;
 			goto err_nomem;
 		}
@@ -1153,7 +1153,7 @@ static int e1000_setup_desc_rings(struct e1000_adapter *adapter)
 		rx_ring->buffer_info[i].dma =
 			pci_map_single(pdev, skb->data, 2048,
 				       PCI_DMA_FROMDEVICE);
-		if (pci_dma_mapping_error(rx_ring->buffer_info[i].dma)) {
+		if (pci_dma_mapping_error(pdev, rx_ring->buffer_info[i].dma)) {
 			ret_val = 8;
 			goto err_nomem;
 		}
diff --git a/drivers/net/e1000e/netdev.c b/drivers/net/e1000e/netdev.c
index 8cbb40f..41cf3fb 100644
--- a/drivers/net/e1000e/netdev.c
+++ b/drivers/net/e1000e/netdev.c
@@ -196,7 +196,7 @@ map_skb:
 		buffer_info->dma = pci_map_single(pdev, skb->data,
 						  adapter->rx_buffer_len,
 						  PCI_DMA_FROMDEVICE);
-		if (pci_dma_mapping_error(buffer_info->dma)) {
+		if (pci_dma_mapping_error(pdev, buffer_info->dma)) {
 			dev_err(&pdev->dev, "RX DMA map failed\n");
 			adapter->rx_dma_failed++;
 			break;
@@ -266,7 +266,7 @@ static void e1000_alloc_rx_buffers_ps(struct e1000_adapter *adapter,
 						   ps_page->page,
 						   0, PAGE_SIZE,
 						   PCI_DMA_FROMDEVICE);
-				if (pci_dma_mapping_error(ps_page->dma)) {
+				if (pci_dma_mapping_error(pdev, ps_page->dma)) {
 					dev_err(&adapter->pdev->dev,
 					  "RX DMA page map failed\n");
 					adapter->rx_dma_failed++;
@@ -301,7 +301,7 @@ static void e1000_alloc_rx_buffers_ps(struct e1000_adapter *adapter,
 		buffer_info->dma = pci_map_single(pdev, skb->data,
 						  adapter->rx_ps_bsize0,
 						  PCI_DMA_FROMDEVICE);
-		if (pci_dma_mapping_error(buffer_info->dma)) {
+		if (pci_dma_mapping_error(pdev, buffer_info->dma)) {
 			dev_err(&pdev->dev, "RX DMA map failed\n");
 			adapter->rx_dma_failed++;
 			/* cleanup skb */
@@ -3342,7 +3342,7 @@ static int e1000_tx_map(struct e1000_adapter *adapter,
 				skb->data + offset,
 				size,
 				PCI_DMA_TODEVICE);
-		if (pci_dma_mapping_error(buffer_info->dma)) {
+		if (pci_dma_mapping_error(adapter->pdev, buffer_info->dma)) {
 			dev_err(&adapter->pdev->dev, "TX DMA map failed\n");
 			adapter->tx_dma_failed++;
 			return -1;
@@ -3380,7 +3380,8 @@ static int e1000_tx_map(struct e1000_adapter *adapter,
 					offset,
 					size,
 					PCI_DMA_TODEVICE);
-			if (pci_dma_mapping_error(buffer_info->dma)) {
+			if (pci_dma_mapping_error(adapter->pdev,
+						  buffer_info->dma)) {
 				dev_err(&adapter->pdev->dev,
 					"TX DMA page map failed\n");
 				adapter->tx_dma_failed++;
diff --git a/drivers/net/ibmveth.c b/drivers/net/ibmveth.c
index 0052780..e43d325 100644
--- a/drivers/net/ibmveth.c
+++ b/drivers/net/ibmveth.c
@@ -433,11 +433,11 @@ static void ibmveth_rxq_harvest_buffer(struct ibmveth_adapter *adapter)
 static void ibmveth_cleanup(struct ibmveth_adapter *adapter)
 {
 	int i;
+	struct device *dev = &adapter->vdev->dev;
 
 	if(adapter->buffer_list_addr != NULL) {
-		if(!dma_mapping_error(adapter->buffer_list_dma)) {
-			dma_unmap_single(&adapter->vdev->dev,
-					adapter->buffer_list_dma, 4096,
+		if (!dma_mapping_error(dev, adapter->buffer_list_dma)) {
+			dma_unmap_single(dev, adapter->buffer_list_dma, 4096,
 					DMA_BIDIRECTIONAL);
 			adapter->buffer_list_dma = DMA_ERROR_CODE;
 		}
@@ -446,9 +446,8 @@ static void ibmveth_cleanup(struct ibmveth_adapter *adapter)
 	}
 
 	if(adapter->filter_list_addr != NULL) {
-		if(!dma_mapping_error(adapter->filter_list_dma)) {
-			dma_unmap_single(&adapter->vdev->dev,
-					adapter->filter_list_dma, 4096,
+		if (!dma_mapping_error(dev, adapter->filter_list_dma)) {
+			dma_unmap_single(dev, adapter->filter_list_dma, 4096,
 					DMA_BIDIRECTIONAL);
 			adapter->filter_list_dma = DMA_ERROR_CODE;
 		}
@@ -457,8 +456,8 @@ static void ibmveth_cleanup(struct ibmveth_adapter *adapter)
 	}
 
 	if(adapter->rx_queue.queue_addr != NULL) {
-		if(!dma_mapping_error(adapter->rx_queue.queue_dma)) {
-			dma_unmap_single(&adapter->vdev->dev,
+		if (!dma_mapping_error(dev, adapter->rx_queue.queue_dma)) {
+			dma_unmap_single(dev,
 					adapter->rx_queue.queue_dma,
 					adapter->rx_queue.queue_len,
 					DMA_BIDIRECTIONAL);
@@ -508,6 +507,7 @@ static int ibmveth_open(struct net_device *netdev)
 	int rc;
 	union ibmveth_buf_desc rxq_desc;
 	int i;
+	struct device *dev;
 
 	ibmveth_debug_printk("open starting\n");
 
@@ -536,17 +536,19 @@ static int ibmveth_open(struct net_device *netdev)
 		return -ENOMEM;
 	}
 
-	adapter->buffer_list_dma = dma_map_single(&adapter->vdev->dev,
+	dev = &adapter->vdev->dev;
+
+	adapter->buffer_list_dma = dma_map_single(dev,
 			adapter->buffer_list_addr, 4096, DMA_BIDIRECTIONAL);
-	adapter->filter_list_dma = dma_map_single(&adapter->vdev->dev,
+	adapter->filter_list_dma = dma_map_single(dev,
 			adapter->filter_list_addr, 4096, DMA_BIDIRECTIONAL);
-	adapter->rx_queue.queue_dma = dma_map_single(&adapter->vdev->dev,
+	adapter->rx_queue.queue_dma = dma_map_single(dev,
 			adapter->rx_queue.queue_addr,
 			adapter->rx_queue.queue_len, DMA_BIDIRECTIONAL);
 
-	if((dma_mapping_error(adapter->buffer_list_dma) ) ||
-	   (dma_mapping_error(adapter->filter_list_dma)) ||
-	   (dma_mapping_error(adapter->rx_queue.queue_dma))) {
+	if ((dma_mapping_error(dev, adapter->buffer_list_dma)) ||
+	    (dma_mapping_error(dev, adapter->filter_list_dma)) ||
+	    (dma_mapping_error(dev, adapter->rx_queue.queue_dma))) {
 		ibmveth_error_printk("unable to map filter or buffer list pages\n");
 		ibmveth_cleanup(adapter);
 		napi_disable(&adapter->napi);
@@ -875,7 +877,7 @@ static int ibmveth_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 		buf[1] = 0;
 	}
 
-	if (dma_mapping_error(desc.fields.address)) {
+	if (dma_mapping_error(&adapter->vdev->dev, desc.fields.address)) {
 		ibmveth_error_printk("tx: unable to map xmit buffer\n");
 		tx_map_failed++;
 		tx_dropped++;
diff --git a/drivers/net/iseries_veth.c b/drivers/net/iseries_veth.c
index b8d0639..c46864d 100644
--- a/drivers/net/iseries_veth.c
+++ b/drivers/net/iseries_veth.c
@@ -1128,7 +1128,7 @@ static int veth_transmit_to_one(struct sk_buff *skb, HvLpIndex rlp,
 	msg->data.addr[0] = dma_map_single(port->dev, skb->data,
 				skb->len, DMA_TO_DEVICE);
 
-	if (dma_mapping_error(msg->data.addr[0]))
+	if (dma_mapping_error(port->dev, msg->data.addr[0]))
 		goto recycle_and_drop;
 
 	msg->dev = port->dev;
@@ -1226,7 +1226,7 @@ static void veth_recycle_msg(struct veth_lpar_connection *cnx,
 		dma_address = msg->data.addr[0];
 		dma_length = msg->data.len[0];
 
-		if (!dma_mapping_error(dma_address))
+		if (!dma_mapping_error(msg->dev, dma_address))
 			dma_unmap_single(msg->dev, dma_address, dma_length,
 					DMA_TO_DEVICE);
 
diff --git a/drivers/net/mlx4/eq.c b/drivers/net/mlx4/eq.c
index e141a15..4ca78aa 100644
--- a/drivers/net/mlx4/eq.c
+++ b/drivers/net/mlx4/eq.c
@@ -525,7 +525,7 @@ int mlx4_map_eq_icm(struct mlx4_dev *dev, u64 icm_virt)
 		return -ENOMEM;
 	priv->eq_table.icm_dma  = pci_map_page(dev->pdev, priv->eq_table.icm_page, 0,
 					       PAGE_SIZE, PCI_DMA_BIDIRECTIONAL);
-	if (pci_dma_mapping_error(priv->eq_table.icm_dma)) {
+	if (pci_dma_mapping_error(dev->pdev, priv->eq_table.icm_dma)) {
 		__free_page(priv->eq_table.icm_page);
 		return -ENOMEM;
 	}
diff --git a/drivers/net/pasemi_mac.c b/drivers/net/pasemi_mac.c
index 3b2a6c5..9e40f23 100644
--- a/drivers/net/pasemi_mac.c
+++ b/drivers/net/pasemi_mac.c
@@ -650,7 +650,7 @@ static void pasemi_mac_replenish_rx_ring(const struct net_device *dev,
 				     mac->bufsz - LOCAL_SKB_ALIGN,
 				     PCI_DMA_FROMDEVICE);
 
-		if (unlikely(dma_mapping_error(dma))) {
+		if (unlikely(mac->dma_pdev, dma_mapping_error(dma))) {
 			dev_kfree_skb_irq(info->skb);
 			break;
 		}
@@ -1519,7 +1519,7 @@ static int pasemi_mac_start_tx(struct sk_buff *skb, struct net_device *dev)
 	map[0] = pci_map_single(mac->dma_pdev, skb->data, skb_headlen(skb),
 				PCI_DMA_TODEVICE);
 	map_size[0] = skb_headlen(skb);
-	if (dma_mapping_error(map[0]))
+	if (dma_mapping_error(mac->dma_pdev, map[0]))
 		goto out_err_nolock;
 
 	for (i = 0; i < nfrags; i++) {
@@ -1529,7 +1529,7 @@ static int pasemi_mac_start_tx(struct sk_buff *skb, struct net_device *dev)
 					frag->page_offset, frag->size,
 					PCI_DMA_TODEVICE);
 		map_size[i+1] = frag->size;
-		if (dma_mapping_error(map[i+1])) {
+		if (dma_mapping_error(mac->dma_pdev, map[i+1])) {
 			nfrags = i;
 			goto out_err_nolock;
 		}
diff --git a/drivers/net/qla3xxx.c b/drivers/net/qla3xxx.c
index b7f7b22..d585753 100644
--- a/drivers/net/qla3xxx.c
+++ b/drivers/net/qla3xxx.c
@@ -328,7 +328,7 @@ static void ql_release_to_lrg_buf_free_list(struct ql3_adapter *qdev,
 					     qdev->lrg_buffer_len -
 					     QL_HEADER_SPACE,
 					     PCI_DMA_FROMDEVICE);
-			err = pci_dma_mapping_error(map);
+			err = pci_dma_mapping_error(qdev->pdev, map);
 			if(err) {
 				printk(KERN_ERR "%s: PCI mapping failed with error: %d\n",
 				       qdev->ndev->name, err);
@@ -1919,7 +1919,7 @@ static int ql_populate_free_queue(struct ql3_adapter *qdev)
 						     QL_HEADER_SPACE,
 						     PCI_DMA_FROMDEVICE);
 
-				err = pci_dma_mapping_error(map);
+				err = pci_dma_mapping_error(qdev->pdev, map);
 				if(err) {
 					printk(KERN_ERR "%s: PCI mapping failed with error: %d\n",
 					       qdev->ndev->name, err);
@@ -2454,7 +2454,7 @@ static int ql_send_map(struct ql3_adapter *qdev,
 	 */
 	map = pci_map_single(qdev->pdev, skb->data, len, PCI_DMA_TODEVICE);
 
-	err = pci_dma_mapping_error(map);
+	err = pci_dma_mapping_error(qdev->pdev, map);
 	if(err) {
 		printk(KERN_ERR "%s: PCI mapping failed with error: %d\n",
 		       qdev->ndev->name, err);
@@ -2487,7 +2487,7 @@ static int ql_send_map(struct ql3_adapter *qdev,
 						     sizeof(struct oal),
 						     PCI_DMA_TODEVICE);
 
-				err = pci_dma_mapping_error(map);
+				err = pci_dma_mapping_error(qdev->pdev, map);
 				if(err) {
 
 					printk(KERN_ERR "%s: PCI mapping outbound address list with error: %d\n",
@@ -2514,7 +2514,7 @@ static int ql_send_map(struct ql3_adapter *qdev,
 					 frag->page_offset, frag->size,
 					 PCI_DMA_TODEVICE);
 
-			err = pci_dma_mapping_error(map);
+			err = pci_dma_mapping_error(qdev->pdev, map);
 			if(err) {
 				printk(KERN_ERR "%s: PCI mapping frags failed with error: %d\n",
 				       qdev->ndev->name, err);
@@ -2916,7 +2916,7 @@ static int ql_alloc_large_buffers(struct ql3_adapter *qdev)
 					     QL_HEADER_SPACE,
 					     PCI_DMA_FROMDEVICE);
 
-			err = pci_dma_mapping_error(map);
+			err = pci_dma_mapping_error(qdev->pdev, map);
 			if(err) {
 				printk(KERN_ERR "%s: PCI mapping failed with error: %d\n",
 				       qdev->ndev->name, err);
diff --git a/drivers/net/sfc/rx.c b/drivers/net/sfc/rx.c
index 6706223..a1bc380 100644
--- a/drivers/net/sfc/rx.c
+++ b/drivers/net/sfc/rx.c
@@ -230,7 +230,7 @@ static inline int efx_init_rx_buffer_skb(struct efx_rx_queue *rx_queue,
 					  rx_buf->data, rx_buf->len,
 					  PCI_DMA_FROMDEVICE);
 
-	if (unlikely(pci_dma_mapping_error(rx_buf->dma_addr))) {
+	if (unlikely(pci_dma_mapping_error(efx->pci_dev, rx_buf->dma_addr))) {
 		dev_kfree_skb_any(rx_buf->skb);
 		rx_buf->skb = NULL;
 		return -EIO;
@@ -272,7 +272,7 @@ static inline int efx_init_rx_buffer_page(struct efx_rx_queue *rx_queue,
 					0, RX_PAGE_SIZE(efx),
 					PCI_DMA_FROMDEVICE);
 
-		if (unlikely(pci_dma_mapping_error(dma_addr))) {
+		if (unlikely(pci_dma_mapping_error(efx->pci_dev, dma_addr))) {
 			__free_pages(rx_buf->page, efx->rx_buffer_order);
 			rx_buf->page = NULL;
 			return -EIO;
diff --git a/drivers/net/sfc/tx.c b/drivers/net/sfc/tx.c
index 9b436f5..16c2d6d 100644
--- a/drivers/net/sfc/tx.c
+++ b/drivers/net/sfc/tx.c
@@ -172,7 +172,7 @@ static inline int efx_enqueue_skb(struct efx_tx_queue *tx_queue,
 
 	/* Process all fragments */
 	while (1) {
-		if (unlikely(pci_dma_mapping_error(dma_addr)))
+		if (unlikely(pci_dma_mapping_error(pci_dev, dma_addr)))
 			goto pci_err;
 
 		/* Store fields for marking in the per-fragment final
@@ -660,7 +660,8 @@ efx_tsoh_heap_alloc(struct efx_tx_queue *tx_queue, size_t header_len)
 	tsoh->dma_addr = pci_map_single(tx_queue->efx->pci_dev,
 					TSOH_BUFFER(tsoh), header_len,
 					PCI_DMA_TODEVICE);
-	if (unlikely(pci_dma_mapping_error(tsoh->dma_addr))) {
+	if (unlikely(pci_dma_mapping_error(tx_queue->efx->pci_dev,
+					   tsoh->dma_addr))) {
 		kfree(tsoh);
 		return NULL;
 	}
@@ -862,7 +863,7 @@ static inline int tso_get_fragment(struct tso_state *st, struct efx_nic *efx,
 
 	st->ifc.unmap_addr = pci_map_page(efx->pci_dev, page, page_off,
 					  len, PCI_DMA_TODEVICE);
-	if (likely(!pci_dma_mapping_error(st->ifc.unmap_addr))) {
+	if (likely(!pci_dma_mapping_error(efx->pci_dev, st->ifc.unmap_addr))) {
 		st->ifc.unmap_len = len;
 		st->ifc.len = len;
 		st->ifc.dma_addr = st->ifc.unmap_addr;
diff --git a/drivers/net/spider_net.c b/drivers/net/spider_net.c
index 4776716..fdcc4ab 100644
--- a/drivers/net/spider_net.c
+++ b/drivers/net/spider_net.c
@@ -452,7 +452,7 @@ spider_net_prepare_rx_descr(struct spider_net_card *card,
 	/* iommu-map the skb */
 	buf = pci_map_single(card->pdev, descr->skb->data,
 			SPIDER_NET_MAX_FRAME, PCI_DMA_FROMDEVICE);
-	if (pci_dma_mapping_error(buf)) {
+	if (pci_dma_mapping_error(card->pdev, buf)) {
 		dev_kfree_skb_any(descr->skb);
 		descr->skb = NULL;
 		if (netif_msg_rx_err(card) && net_ratelimit())
@@ -691,7 +691,7 @@ spider_net_prepare_tx_descr(struct spider_net_card *card,
 	unsigned long flags;
 
 	buf = pci_map_single(card->pdev, skb->data, skb->len, PCI_DMA_TODEVICE);
-	if (pci_dma_mapping_error(buf)) {
+	if (pci_dma_mapping_error(card->pdev, buf)) {
 		if (netif_msg_tx_err(card) && net_ratelimit())
 			dev_err(&card->netdev->dev, "could not iommu-map packet (%p, %i). "
 				  "Dropping packet\n", skb->data, skb->len);
diff --git a/drivers/net/tc35815.c b/drivers/net/tc35815.c
index 10e4e85..1fc9c78 100644
--- a/drivers/net/tc35815.c
+++ b/drivers/net/tc35815.c
@@ -506,7 +506,7 @@ static void *alloc_rxbuf_page(struct pci_dev *hwdev, dma_addr_t *dma_handle)
 		return NULL;
 	*dma_handle = pci_map_single(hwdev, buf, PAGE_SIZE,
 				     PCI_DMA_FROMDEVICE);
-	if (pci_dma_mapping_error(*dma_handle)) {
+	if (pci_dma_mapping_error(hwdev, *dma_handle)) {
 		free_page((unsigned long)buf);
 		return NULL;
 	}
@@ -536,7 +536,7 @@ static struct sk_buff *alloc_rxbuf_skb(struct net_device *dev,
 		return NULL;
 	*dma_handle = pci_map_single(hwdev, skb->data, RX_BUF_SIZE,
 				     PCI_DMA_FROMDEVICE);
-	if (pci_dma_mapping_error(*dma_handle)) {
+	if (pci_dma_mapping_error(hwdev, *dma_handle)) {
 		dev_kfree_skb_any(skb);
 		return NULL;
 	}
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 3201c16..daa2e57 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1260,7 +1260,7 @@ ath5k_rxbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 		bf->skb = skb;
 		bf->skbaddr = pci_map_single(sc->pdev,
 			skb->data, sc->rxbufsize, PCI_DMA_FROMDEVICE);
-		if (unlikely(pci_dma_mapping_error(bf->skbaddr))) {
+		if (unlikely(pci_dma_mapping_error(sc->pdev, bf->skbaddr))) {
 			ATH5K_ERR(sc, "%s: DMA mapping failed\n", __func__);
 			dev_kfree_skb(skb);
 			bf->skb = NULL;
@@ -2029,7 +2029,7 @@ ath5k_beacon_setup(struct ath5k_softc *sc, struct ath5k_buf *bf,
 	ATH5K_DBG(sc, ATH5K_DEBUG_BEACON, "skb %p [data %p len %u] "
 			"skbaddr %llx\n", skb, skb->data, skb->len,
 			(unsigned long long)bf->skbaddr);
-	if (pci_dma_mapping_error(bf->skbaddr)) {
+	if (pci_dma_mapping_error(sc->pdev, bf->skbaddr)) {
 		ATH5K_ERR(sc, "beacon DMA mapping failed\n");
 		return -EIO;
 	}
diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
index f50e201..364840b 100644
--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -518,7 +518,7 @@ static bool b43_dma_mapping_error(struct b43_dmaring *ring,
 				  dma_addr_t addr,
 				  size_t buffersize, bool dma_to_device)
 {
-	if (unlikely(dma_mapping_error(addr)))
+	if (unlikely(dma_mapping_error(ring->dev->dev->dma_dev, addr)))
 		return 1;
 
 	switch (ring->type) {
diff --git a/drivers/net/wireless/b43legacy/dma.c b/drivers/net/wireless/b43legacy/dma.c
index d6686f7..7ccc149 100644
--- a/drivers/net/wireless/b43legacy/dma.c
+++ b/drivers/net/wireless/b43legacy/dma.c
@@ -589,7 +589,7 @@ static bool b43legacy_dma_mapping_error(struct b43legacy_dmaring *ring,
 					 size_t buffersize,
 					 bool dma_to_device)
 {
-	if (unlikely(dma_mapping_error(addr)))
+	if (unlikely(dma_mapping_error(ring->dev->dev->dma_dev, addr)))
 		return 1;
 
 	switch (ring->type) {
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index ccfd8ac..b68423e 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -854,7 +854,7 @@ static void send_mad_adapter_info(struct ibmvscsi_host_data *hostdata)
 					    sizeof(hostdata->madapter_info),
 					    DMA_BIDIRECTIONAL);
 
-	if (dma_mapping_error(req->buffer)) {
+	if (dma_mapping_error(hostdata->dev, req->buffer)) {
 		dev_err(hostdata->dev, "Unable to map request_buffer for adapter_info!\n");
 		free_event_struct(&hostdata->pool, evt_struct);
 		return;
@@ -1399,7 +1399,7 @@ static int ibmvscsi_do_host_config(struct ibmvscsi_host_data *hostdata,
 						    length,
 						    DMA_BIDIRECTIONAL);
 
-	if (dma_mapping_error(host_config->buffer)) {
+	if (dma_mapping_error(hostdata->dev, host_config->buffer)) {
 		dev_err(hostdata->dev, "dma_mapping error getting host config\n");
 		free_event_struct(&hostdata->pool, evt_struct);
 		return -1;
diff --git a/drivers/scsi/ibmvscsi/ibmvstgt.c b/drivers/scsi/ibmvscsi/ibmvstgt.c
index d6f68f2..2a5b29d 100644
--- a/drivers/scsi/ibmvscsi/ibmvstgt.c
+++ b/drivers/scsi/ibmvscsi/ibmvstgt.c
@@ -564,7 +564,7 @@ static int crq_queue_create(struct crq_queue *queue, struct srp_target *target)
 					  queue->size * sizeof(*queue->msgs),
 					  DMA_BIDIRECTIONAL);
 
-	if (dma_mapping_error(queue->msg_token))
+	if (dma_mapping_error(target->dev, queue->msg_token))
 		goto map_failed;
 
 	err = h_reg_crq(vport->dma_dev->unit_address, queue->msg_token,
diff --git a/drivers/scsi/ibmvscsi/rpa_vscsi.c b/drivers/scsi/ibmvscsi/rpa_vscsi.c
index 1821461..462a857 100644
--- a/drivers/scsi/ibmvscsi/rpa_vscsi.c
+++ b/drivers/scsi/ibmvscsi/rpa_vscsi.c
@@ -253,7 +253,7 @@ static int rpavscsi_init_crq_queue(struct crq_queue *queue,
 					  queue->size * sizeof(*queue->msgs),
 					  DMA_BIDIRECTIONAL);
 
-	if (dma_mapping_error(queue->msg_token))
+	if (dma_mapping_error(hostdata->dev, queue->msg_token))
 		goto map_failed;
 
 	gather_partition_info();
diff --git a/drivers/spi/atmel_spi.c b/drivers/spi/atmel_spi.c
index e81d59d..0c71656 100644
--- a/drivers/spi/atmel_spi.c
+++ b/drivers/spi/atmel_spi.c
@@ -313,14 +313,14 @@ atmel_spi_dma_map_xfer(struct atmel_spi *as, struct spi_transfer *xfer)
 		xfer->tx_dma = dma_map_single(dev,
 				(void *) xfer->tx_buf, xfer->len,
 				DMA_TO_DEVICE);
-		if (dma_mapping_error(xfer->tx_dma))
+		if (dma_mapping_error(dev, xfer->tx_dma))
 			return -ENOMEM;
 	}
 	if (xfer->rx_buf) {
 		xfer->rx_dma = dma_map_single(dev,
 				xfer->rx_buf, xfer->len,
 				DMA_FROM_DEVICE);
-		if (dma_mapping_error(xfer->rx_dma)) {
+		if (dma_mapping_error(dev, xfer->rx_dma)) {
 			if (xfer->tx_buf)
 				dma_unmap_single(dev,
 						xfer->tx_dma, xfer->len,
diff --git a/drivers/spi/au1550_spi.c b/drivers/spi/au1550_spi.c
index 072c4a5..183e0f3 100644
--- a/drivers/spi/au1550_spi.c
+++ b/drivers/spi/au1550_spi.c
@@ -330,7 +330,7 @@ static int au1550_spi_dma_rxtmp_alloc(struct au1550_spi *hw, unsigned size)
 	hw->dma_rx_tmpbuf_size = size;
 	hw->dma_rx_tmpbuf_addr = dma_map_single(hw->dev, hw->dma_rx_tmpbuf,
 			size, DMA_FROM_DEVICE);
-	if (dma_mapping_error(hw->dma_rx_tmpbuf_addr)) {
+	if (dma_mapping_error(hw->dev, hw->dma_rx_tmpbuf_addr)) {
 		kfree(hw->dma_rx_tmpbuf);
 		hw->dma_rx_tmpbuf = 0;
 		hw->dma_rx_tmpbuf_size = 0;
@@ -374,7 +374,7 @@ static int au1550_spi_dma_txrxb(struct spi_device *spi, struct spi_transfer *t)
 			dma_rx_addr = dma_map_single(hw->dev,
 					(void *)t->rx_buf,
 					t->len, DMA_FROM_DEVICE);
-			if (dma_mapping_error(dma_rx_addr))
+			if (dma_mapping_error(hw->dev, dma_rx_addr))
 				dev_err(hw->dev, "rx dma map error\n");
 		}
 	} else {
@@ -397,7 +397,7 @@ static int au1550_spi_dma_txrxb(struct spi_device *spi, struct spi_transfer *t)
 			dma_tx_addr = dma_map_single(hw->dev,
 					(void *)t->tx_buf,
 					t->len, DMA_TO_DEVICE);
-			if (dma_mapping_error(dma_tx_addr))
+			if (dma_mapping_error(hw->dev, dma_tx_addr))
 				dev_err(hw->dev, "tx dma map error\n");
 		}
 	} else {
diff --git a/drivers/spi/omap2_mcspi.c b/drivers/spi/omap2_mcspi.c
index b1cc148..f6f987b 100644
--- a/drivers/spi/omap2_mcspi.c
+++ b/drivers/spi/omap2_mcspi.c
@@ -836,7 +836,7 @@ static int omap2_mcspi_transfer(struct spi_device *spi, struct spi_message *m)
 		if (tx_buf != NULL) {
 			t->tx_dma = dma_map_single(&spi->dev, (void *) tx_buf,
 					len, DMA_TO_DEVICE);
-			if (dma_mapping_error(t->tx_dma)) {
+			if (dma_mapping_error(&spi->dev, t->tx_dma)) {
 				dev_dbg(&spi->dev, "dma %cX %d bytes error\n",
 						'T', len);
 				return -EINVAL;
@@ -845,7 +845,7 @@ static int omap2_mcspi_transfer(struct spi_device *spi, struct spi_message *m)
 		if (rx_buf != NULL) {
 			t->rx_dma = dma_map_single(&spi->dev, rx_buf, t->len,
 					DMA_FROM_DEVICE);
-			if (dma_mapping_error(t->rx_dma)) {
+			if (dma_mapping_error(&spi->dev, t->rx_dma)) {
 				dev_dbg(&spi->dev, "dma %cX %d bytes error\n",
 						'R', len);
 				if (tx_buf != NULL)
diff --git a/drivers/spi/pxa2xx_spi.c b/drivers/spi/pxa2xx_spi.c
index 0c452c4..067299d 100644
--- a/drivers/spi/pxa2xx_spi.c
+++ b/drivers/spi/pxa2xx_spi.c
@@ -353,7 +353,7 @@ static int map_dma_buffers(struct driver_data *drv_data)
 	drv_data->rx_dma = dma_map_single(dev, drv_data->rx,
 						drv_data->rx_map_len,
 						DMA_FROM_DEVICE);
-	if (dma_mapping_error(drv_data->rx_dma))
+	if (dma_mapping_error(dev, drv_data->rx_dma))
 		return 0;
 
 	/* Stream map the tx buffer */
@@ -361,7 +361,7 @@ static int map_dma_buffers(struct driver_data *drv_data)
 						drv_data->tx_map_len,
 						DMA_TO_DEVICE);
 
-	if (dma_mapping_error(drv_data->tx_dma)) {
+	if (dma_mapping_error(dev, drv_data->tx_dma)) {
 		dma_unmap_single(dev, drv_data->rx_dma,
 					drv_data->rx_map_len, DMA_FROM_DEVICE);
 		return 0;
diff --git a/drivers/spi/spi_imx.c b/drivers/spi/spi_imx.c
index c730d05..0712e37 100644
--- a/drivers/spi/spi_imx.c
+++ b/drivers/spi/spi_imx.c
@@ -488,7 +488,7 @@ static int map_dma_buffers(struct driver_data *drv_data)
 							buf,
 							drv_data->tx_map_len,
 							DMA_TO_DEVICE);
-			if (dma_mapping_error(drv_data->tx_dma))
+			if (dma_mapping_error(dev, drv_data->tx_dma))
 				return -1;
 
 			drv_data->tx_dma_needs_unmap = 1;
@@ -513,7 +513,7 @@ static int map_dma_buffers(struct driver_data *drv_data)
 					buf,
 					drv_data->len,
 					DMA_FROM_DEVICE);
-		if (dma_mapping_error(drv_data->rx_dma))
+		if (dma_mapping_error(dev, drv_data->rx_dma))
 			return -1;
 		drv_data->rx_dma_needs_unmap = 1;
 	}
@@ -531,7 +531,7 @@ static int map_dma_buffers(struct driver_data *drv_data)
 					buf,
 					drv_data->tx_map_len,
 					DMA_TO_DEVICE);
-	if (dma_mapping_error(drv_data->tx_dma)) {
+	if (dma_mapping_error(dev, drv_data->tx_dma)) {
 		if (drv_data->rx_dma) {
 			dma_unmap_single(dev,
 					drv_data->rx_dma,
diff --git a/include/asm-alpha/dma-mapping.h b/include/asm-alpha/dma-mapping.h
index db351d1..a5801ae 100644
--- a/include/asm-alpha/dma-mapping.h
+++ b/include/asm-alpha/dma-mapping.h
@@ -24,8 +24,8 @@
 		pci_unmap_sg(alpha_gendev_to_pci(dev), sg, nents, dir)
 #define dma_supported(dev, mask)			\
 		pci_dma_supported(alpha_gendev_to_pci(dev), mask)
-#define dma_mapping_error(addr)				\
-		pci_dma_mapping_error(addr)
+#define dma_mapping_error(dev, addr)				\
+		pci_dma_mapping_error(alpha_gendev_to_pci(dev), addr)
 
 #else	/* no PCI - no IOMMU. */
 
@@ -45,7 +45,7 @@ int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 #define dma_unmap_page(dev, addr, size, dir)	((void)0)
 #define dma_unmap_sg(dev, sg, nents, dir)	((void)0)
 
-#define dma_mapping_error(addr)  (0)
+#define dma_mapping_error(dev, addr)  (0)
 
 #endif	/* !CONFIG_PCI */
 
diff --git a/include/asm-alpha/pci.h b/include/asm-alpha/pci.h
index d31fd49..2a14302 100644
--- a/include/asm-alpha/pci.h
+++ b/include/asm-alpha/pci.h
@@ -106,7 +106,7 @@ extern dma_addr_t pci_map_page(struct pci_dev *, struct page *,
 /* Test for pci_map_single or pci_map_page having generated an error.  */
 
 static inline int
-pci_dma_mapping_error(dma_addr_t dma_addr)
+pci_dma_mapping_error(struct pci_dev *pdev, dma_addr_t dma_addr)
 {
 	return dma_addr == 0;
 }
diff --git a/include/asm-arm/dma-mapping.h b/include/asm-arm/dma-mapping.h
index e99406a..f41335b 100644
--- a/include/asm-arm/dma-mapping.h
+++ b/include/asm-arm/dma-mapping.h
@@ -56,7 +56,7 @@ static inline int dma_is_consistent(struct device *dev, dma_addr_t handle)
 /*
  * DMA errors are defined by all-bits-set in the DMA address.
  */
-static inline int dma_mapping_error(dma_addr_t dma_addr)
+static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 	return dma_addr == ~0;
 }
diff --git a/include/asm-avr32/dma-mapping.h b/include/asm-avr32/dma-mapping.h
index 57dc672..0399359 100644
--- a/include/asm-avr32/dma-mapping.h
+++ b/include/asm-avr32/dma-mapping.h
@@ -35,7 +35,7 @@ static inline int dma_set_mask(struct device *dev, u64 dma_mask)
 /*
  * dma_map_single can't fail as it is implemented now.
  */
-static inline int dma_mapping_error(dma_addr_t addr)
+static inline int dma_mapping_error(struct device *dev, dma_addr_t addr)
 {
 	return 0;
 }
diff --git a/include/asm-cris/dma-mapping.h b/include/asm-cris/dma-mapping.h
index edc8d1b..cb2fb25 100644
--- a/include/asm-cris/dma-mapping.h
+++ b/include/asm-cris/dma-mapping.h
@@ -120,7 +120,7 @@ dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg, int nelems,
 }
 
 static inline int
-dma_mapping_error(dma_addr_t dma_addr)
+dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 	return 0;
 }
diff --git a/include/asm-frv/dma-mapping.h b/include/asm-frv/dma-mapping.h
index 2e8966c..b289887 100644
--- a/include/asm-frv/dma-mapping.h
+++ b/include/asm-frv/dma-mapping.h
@@ -126,7 +126,7 @@ void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg, int nele
 }
 
 static inline
-int dma_mapping_error(dma_addr_t dma_addr)
+int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 	return 0;
 }
diff --git a/include/asm-generic/dma-mapping-broken.h b/include/asm-generic/dma-mapping-broken.h
index e2468f8..82cd0cb 100644
--- a/include/asm-generic/dma-mapping-broken.h
+++ b/include/asm-generic/dma-mapping-broken.h
@@ -61,7 +61,7 @@ dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
 #define dma_sync_sg_for_device dma_sync_sg_for_cpu
 
 extern int
-dma_mapping_error(dma_addr_t dma_addr);
+dma_mapping_error(struct device *dev, dma_addr_t dma_addr);
 
 extern int
 dma_supported(struct device *dev, u64 mask);
diff --git a/include/asm-generic/dma-mapping.h b/include/asm-generic/dma-mapping.h
index 783ab99..189486c 100644
--- a/include/asm-generic/dma-mapping.h
+++ b/include/asm-generic/dma-mapping.h
@@ -144,9 +144,9 @@ dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg, int nelems,
 }
 
 static inline int
-dma_mapping_error(dma_addr_t dma_addr)
+dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
-	return pci_dma_mapping_error(dma_addr);
+	return pci_dma_mapping_error(to_pci_dev(dev), dma_addr);
 }
 
 
diff --git a/include/asm-generic/pci-dma-compat.h b/include/asm-generic/pci-dma-compat.h
index 25c10e9..37b3706 100644
--- a/include/asm-generic/pci-dma-compat.h
+++ b/include/asm-generic/pci-dma-compat.h
@@ -99,9 +99,9 @@ pci_dma_sync_sg_for_device(struct pci_dev *hwdev, struct scatterlist *sg,
 }
 
 static inline int
-pci_dma_mapping_error(dma_addr_t dma_addr)
+pci_dma_mapping_error(struct pci_dev *pdev, dma_addr_t dma_addr)
 {
-	return dma_mapping_error(dma_addr);
+	return dma_mapping_error(&pdev->dev, dma_addr);
 }
 
 #endif
diff --git a/include/asm-ia64/machvec.h b/include/asm-ia64/machvec.h
index 9f020eb..50055a3 100644
--- a/include/asm-ia64/machvec.h
+++ b/include/asm-ia64/machvec.h
@@ -54,7 +54,7 @@ typedef void ia64_mv_dma_sync_single_for_cpu (struct device *, dma_addr_t, size_
 typedef void ia64_mv_dma_sync_sg_for_cpu (struct device *, struct scatterlist *, int, int);
 typedef void ia64_mv_dma_sync_single_for_device (struct device *, dma_addr_t, size_t, int);
 typedef void ia64_mv_dma_sync_sg_for_device (struct device *, struct scatterlist *, int, int);
-typedef int ia64_mv_dma_mapping_error (dma_addr_t dma_addr);
+typedef int ia64_mv_dma_mapping_error(struct device *, dma_addr_t dma_addr);
 typedef int ia64_mv_dma_supported (struct device *, u64);
 
 typedef dma_addr_t ia64_mv_dma_map_single_attrs (struct device *, void *, size_t, int, struct dma_attrs *);
diff --git a/include/asm-m68k/dma-mapping.h b/include/asm-m68k/dma-mapping.h
index a26cdeb..91f7944 100644
--- a/include/asm-m68k/dma-mapping.h
+++ b/include/asm-m68k/dma-mapping.h
@@ -84,7 +84,7 @@ static inline void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *s
 {
 }
 
-static inline int dma_mapping_error(dma_addr_t handle)
+static inline int dma_mapping_error(struct device *dev, dma_addr_t handle)
 {
 	return 0;
 }
diff --git a/include/asm-mips/dma-mapping.h b/include/asm-mips/dma-mapping.h
index 230b3f1..c64afb4 100644
--- a/include/asm-mips/dma-mapping.h
+++ b/include/asm-mips/dma-mapping.h
@@ -42,7 +42,7 @@ extern void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
 	int nelems, enum dma_data_direction direction);
 extern void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
 	int nelems, enum dma_data_direction direction);
-extern int dma_mapping_error(dma_addr_t dma_addr);
+extern int dma_mapping_error(struct device *dev, dma_addr_t dma_addr);
 extern int dma_supported(struct device *dev, u64 mask);
 
 static inline int
diff --git a/include/asm-mn10300/dma-mapping.h b/include/asm-mn10300/dma-mapping.h
index 7c882fc..ccae8f6 100644
--- a/include/asm-mn10300/dma-mapping.h
+++ b/include/asm-mn10300/dma-mapping.h
@@ -182,7 +182,7 @@ void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
 }
 
 static inline
-int dma_mapping_error(dma_addr_t dma_addr)
+int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 	return 0;
 }
diff --git a/include/asm-parisc/dma-mapping.h b/include/asm-parisc/dma-mapping.h
index c6c0e9f..53af696 100644
--- a/include/asm-parisc/dma-mapping.h
+++ b/include/asm-parisc/dma-mapping.h
@@ -248,6 +248,6 @@ void * sba_get_iommu(struct parisc_device *dev);
 #endif
 
 /* At the moment, we panic on error for IOMMU resource exaustion */
-#define dma_mapping_error(x)	0
+#define dma_mapping_error(dev, x)	0
 
 #endif
diff --git a/include/asm-powerpc/dma-mapping.h b/include/asm-powerpc/dma-mapping.h
index bbefb69..14a93a1 100644
--- a/include/asm-powerpc/dma-mapping.h
+++ b/include/asm-powerpc/dma-mapping.h
@@ -350,7 +350,7 @@ static inline void dma_sync_sg_for_device(struct device *dev,
 		__dma_sync_page(sg_page(sg), sg->offset, sg->length, direction);
 }
 
-static inline int dma_mapping_error(dma_addr_t dma_addr)
+static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 #ifdef CONFIG_PPC64
 	return (dma_addr == DMA_ERROR_CODE);
diff --git a/include/asm-sh/dma-mapping.h b/include/asm-sh/dma-mapping.h
index 22cc419..6c0b8a2 100644
--- a/include/asm-sh/dma-mapping.h
+++ b/include/asm-sh/dma-mapping.h
@@ -171,7 +171,7 @@ static inline int dma_get_cache_alignment(void)
 	return L1_CACHE_BYTES;
 }
 
-static inline int dma_mapping_error(dma_addr_t dma_addr)
+static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 	return dma_addr == 0;
 }
diff --git a/include/asm-sparc/pci.h b/include/asm-sparc/pci.h
index b93b6c7..03e9381 100644
--- a/include/asm-sparc/pci.h
+++ b/include/asm-sparc/pci.h
@@ -154,7 +154,8 @@ static inline void pci_dma_burst_advice(struct pci_dev *pdev,
 
 #define PCI_DMA_ERROR_CODE      (~(dma_addr_t)0x0)
 
-static inline int pci_dma_mapping_error(dma_addr_t dma_addr)
+static inline int pci_dma_mapping_error(struct pci_device *pdev,
+					dma_addr_t dma_addr)
 {
         return (dma_addr == PCI_DMA_ERROR_CODE);
 }
diff --git a/include/asm-sparc64/dma-mapping.h b/include/asm-sparc64/dma-mapping.h
index 38cbec7..bfa64f9 100644
--- a/include/asm-sparc64/dma-mapping.h
+++ b/include/asm-sparc64/dma-mapping.h
@@ -135,7 +135,7 @@ static inline void dma_sync_sg_for_device(struct device *dev,
 	/* No flushing needed to sync cpu writes to the device.  */
 }
 
-static inline int dma_mapping_error(dma_addr_t dma_addr)
+static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 	return (dma_addr == DMA_ERROR_CODE);
 }
diff --git a/include/asm-sparc64/pci.h b/include/asm-sparc64/pci.h
index f59f257..4f79a54 100644
--- a/include/asm-sparc64/pci.h
+++ b/include/asm-sparc64/pci.h
@@ -140,9 +140,10 @@ extern int pci_dma_supported(struct pci_dev *hwdev, u64 mask);
 #define PCI64_REQUIRED_MASK	(~(dma64_addr_t)0)
 #define PCI64_ADDR_BASE		0xfffc000000000000UL
 
-static inline int pci_dma_mapping_error(dma_addr_t dma_addr)
+static inline int pci_dma_mapping_error(struct pci_dev *pdev,
+					dma_addr_t dma_addr)
 {
-	return dma_mapping_error(dma_addr);
+	return dma_mapping_error(&pdev->dev, dma_addr);
 }
 
 #ifdef CONFIG_PCI
diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index a1a4dc7..69626b6 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -18,7 +18,8 @@ extern int forbid_dac;
 extern int force_iommu;
 
 struct dma_mapping_ops {
-	int             (*mapping_error)(dma_addr_t dma_addr);
+	int             (*mapping_error)(struct device *dev,
+					 dma_addr_t dma_addr);
 	void*           (*alloc_coherent)(struct device *dev, size_t size,
 				dma_addr_t *dma_handle, gfp_t gfp);
 	void            (*free_coherent)(struct device *dev, size_t size,
@@ -59,10 +60,10 @@ struct dma_mapping_ops {
 
 extern const struct dma_mapping_ops *dma_ops;
 
-static inline int dma_mapping_error(dma_addr_t dma_addr)
+static inline int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 	if (dma_ops->mapping_error)
-		return dma_ops->mapping_error(dma_addr);
+		return dma_ops->mapping_error(dev, dma_addr);
 
 	return (dma_addr == bad_dma_address);
 }
diff --git a/include/asm-x86/swiotlb.h b/include/asm-x86/swiotlb.h
index f5d9e74..746eeab 100644
--- a/include/asm-x86/swiotlb.h
+++ b/include/asm-x86/swiotlb.h
@@ -35,7 +35,7 @@ extern int swiotlb_map_sg(struct device *hwdev, struct scatterlist *sg,
 			  int nents, int direction);
 extern void swiotlb_unmap_sg(struct device *hwdev, struct scatterlist *sg,
 			     int nents, int direction);
-extern int swiotlb_dma_mapping_error(dma_addr_t dma_addr);
+extern int swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr);
 extern void swiotlb_free_coherent(struct device *hwdev, size_t size,
 				  void *vaddr, dma_addr_t dma_handle);
 extern int swiotlb_dma_supported(struct device *hwdev, u64 mask);
diff --git a/include/asm-xtensa/dma-mapping.h b/include/asm-xtensa/dma-mapping.h
index 3c7d537..51882ae 100644
--- a/include/asm-xtensa/dma-mapping.h
+++ b/include/asm-xtensa/dma-mapping.h
@@ -139,7 +139,7 @@ dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg, int nelems,
 		consistent_sync(sg_virt(sg), sg->length, dir);
 }
 static inline int
-dma_mapping_error(dma_addr_t dma_addr)
+dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
 {
 	return 0;
 }
diff --git a/include/linux/i2o.h b/include/linux/i2o.h
index 7d51cbc..75ae6d8 100644
--- a/include/linux/i2o.h
+++ b/include/linux/i2o.h
@@ -758,7 +758,7 @@ static inline dma_addr_t i2o_dma_map_single(struct i2o_controller *c, void *ptr,
 	}
 
 	dma_addr = dma_map_single(&c->pdev->dev, ptr, size, direction);
-	if (!dma_mapping_error(dma_addr)) {
+	if (!dma_mapping_error(&c->pdev->dev, dma_addr)) {
 #ifdef CONFIG_I2O_EXT_ADAPTEC_DMA64
 		if ((sizeof(dma_addr_t) > 4) && c->pae_support) {
 			*mptr++ = cpu_to_le32(0x7C020002);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 911a661..972657e 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1506,7 +1506,7 @@ static inline int ib_dma_mapping_error(struct ib_device *dev, u64 dma_addr)
 {
 	if (dev->dma_ops)
 		return dev->dma_ops->mapping_error(dev, dma_addr);
-	return dma_mapping_error(dma_addr);
+	return dma_mapping_error(dev->dma_device, dma_addr);
 }
 
 /**
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index d568894..977edbd 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -492,7 +492,7 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 		 */
 		dma_addr_t handle;
 		handle = swiotlb_map_single(NULL, NULL, size, DMA_FROM_DEVICE);
-		if (swiotlb_dma_mapping_error(handle))
+		if (swiotlb_dma_mapping_error(hwdev, handle))
 			return NULL;
 
 		ret = bus_to_virt(handle);
@@ -824,7 +824,7 @@ swiotlb_sync_sg_for_device(struct device *hwdev, struct scatterlist *sg,
 }
 
 int
-swiotlb_dma_mapping_error(dma_addr_t dma_addr)
+swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr)
 {
 	return (dma_addr == virt_to_bus(io_tlb_overflow_buffer));
 }
-- 
1.5.4.2

