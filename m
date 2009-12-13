Return-Path: <linux-kernel-owner+w=401wt.eu-S1756087AbZLNATQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087AbZLNATQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:19:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754925AbZLNATL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:19:11 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34729 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754877AbZLMX5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:43 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, benh@kernel.crashing.org,
       paulus@samba.org, sfr@canb.auug.org.au, torvalds@linux-foundation.org
Subject: [PATCH 08/10] Constify struct dma_map_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:59:23 +0100
Message-Id: <a4e3c3e7a702e96786a8364ccc4579a9d80e711d.1260662996.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260662995.git.re.emese@gmail.com>
References: <cover.1260662995.git.re.emese@gmail.com>
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 arch/powerpc/kernel/pci-common.c    |    6 +++---
 arch/powerpc/kernel/vio.c           |    5 ++---
 arch/powerpc/platforms/cell/iommu.c |    2 +-
 arch/sparc/kernel/pci_sun4v.c       |    2 +-
 4 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index e8dfdbd..8583013 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -50,14 +50,14 @@ resource_size_t isa_mem_base;
 unsigned int ppc_pci_flags = 0;
 
 
-static struct dma_map_ops *pci_dma_ops = &dma_direct_ops;
+static const struct dma_map_ops *pci_dma_ops = &dma_direct_ops;
 
-void set_pci_dma_ops(struct dma_map_ops *dma_ops)
+void set_pci_dma_ops(const struct dma_map_ops *dma_ops)
 {
 	pci_dma_ops = dma_ops;
 }
 
-struct dma_map_ops *get_pci_dma_ops(void)
+const struct dma_map_ops *get_pci_dma_ops(void)
 {
 	return pci_dma_ops;
 }
diff --git a/arch/powerpc/kernel/vio.c b/arch/powerpc/kernel/vio.c
index 77f6421..2f68442 100644
--- a/arch/powerpc/kernel/vio.c
+++ b/arch/powerpc/kernel/vio.c
@@ -601,14 +601,14 @@ static void vio_dma_iommu_unmap_sg(struct device *dev,
 	vio_cmo_dealloc(viodev, alloc_size);
 }
 
-struct dma_map_ops vio_dma_mapping_ops = {
+static const struct dma_map_ops vio_dma_mapping_ops = {
 	.alloc_coherent = vio_dma_iommu_alloc_coherent,
 	.free_coherent  = vio_dma_iommu_free_coherent,
 	.map_sg         = vio_dma_iommu_map_sg,
 	.unmap_sg       = vio_dma_iommu_unmap_sg,
+	.dma_supported  = dma_iommu_dma_supported,
 	.map_page       = vio_dma_iommu_map_page,
 	.unmap_page     = vio_dma_iommu_unmap_page,
-
 };
 
 /**
@@ -857,7 +857,6 @@ static void vio_cmo_bus_remove(struct vio_dev *viodev)
 
 static void vio_cmo_set_dma_ops(struct vio_dev *viodev)
 {
-	vio_dma_mapping_ops.dma_supported = dma_iommu_ops.dma_supported;
 	viodev->dev.archdata.dma_ops = &vio_dma_mapping_ops;
 }
 
diff --git a/arch/powerpc/platforms/cell/iommu.c b/arch/powerpc/platforms/cell/iommu.c
index ca5bfdf..1602e09 100644
--- a/arch/powerpc/platforms/cell/iommu.c
+++ b/arch/powerpc/platforms/cell/iommu.c
@@ -642,7 +642,7 @@ static int dma_fixed_dma_supported(struct device *dev, u64 mask)
 
 static int dma_set_mask_and_switch(struct device *dev, u64 dma_mask);
 
-struct dma_map_ops dma_iommu_fixed_ops = {
+const struct dma_map_ops dma_iommu_fixed_ops = {
 	.alloc_coherent = dma_fixed_alloc_coherent,
 	.free_coherent  = dma_fixed_free_coherent,
 	.map_sg         = dma_fixed_map_sg,
diff --git a/arch/sparc/kernel/pci_sun4v.c b/arch/sparc/kernel/pci_sun4v.c
index 23c33ff..d137fbd 100644
--- a/arch/sparc/kernel/pci_sun4v.c
+++ b/arch/sparc/kernel/pci_sun4v.c
@@ -525,7 +525,7 @@ static void dma_4v_unmap_sg(struct device *dev, struct scatterlist *sglist,
 	spin_unlock_irqrestore(&iommu->lock, flags);
 }
 
-static struct dma_map_ops sun4v_dma_ops = {
+static const struct dma_map_ops sun4v_dma_ops = {
 	.alloc_coherent			= dma_4v_alloc_coherent,
 	.free_coherent			= dma_4v_free_coherent,
 	.map_page			= dma_4v_map_page,
-- 
1.6.5.3

