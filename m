Return-Path: <linux-kernel-owner+w=401wt.eu-S1756102AbZLNAT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbZLNAT5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:19:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756092AbZLNATt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:19:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34087 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754857AbZLMX5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:41 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, davem@davemloft.net, sam@ravnborg.org,
       mingo@elte.hu, torvalds@linux-foundation.org
Subject: [PATCH 06/10] Constify struct dma_map_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:59:21 +0100
Message-Id: <93e97c5ea1563907ac4cb1751758c2bc1905b4b0.1260662996.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260662995.git.re.emese@gmail.com>
References: <cover.1260662995.git.re.emese@gmail.com>
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 arch/sparc/include/asm/dma-mapping.h |    8 ++++----
 arch/sparc/kernel/iommu.c            |    4 ++--
 arch/sparc/kernel/ioport.c           |    6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/sparc/include/asm/dma-mapping.h b/arch/sparc/include/asm/dma-mapping.h
index 5a8c308..fb7c253 100644
--- a/arch/sparc/include/asm/dma-mapping.h
+++ b/arch/sparc/include/asm/dma-mapping.h
@@ -14,10 +14,10 @@ extern int dma_set_mask(struct device *dev, u64 dma_mask);
 #define dma_free_noncoherent(d, s, v, h) dma_free_coherent(d, s, v, h)
 #define dma_is_consistent(d, h)	(1)
 
-extern struct dma_map_ops *dma_ops, pci32_dma_ops;
+extern struct const dma_map_ops *dma_ops, pci32_dma_ops;
 extern struct bus_type pci_bus_type;
 
-static inline struct dma_map_ops *get_dma_ops(struct device *dev)
+static inline const struct dma_map_ops *get_dma_ops(struct device *dev)
 {
 #if defined(CONFIG_SPARC32) && defined(CONFIG_PCI)
 	if (dev->bus == &pci_bus_type)
@@ -31,7 +31,7 @@ static inline struct dma_map_ops *get_dma_ops(struct device *dev)
 static inline void *dma_alloc_coherent(struct device *dev, size_t size,
 				       dma_addr_t *dma_handle, gfp_t flag)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 	void *cpu_addr;
 
 	cpu_addr = ops->alloc_coherent(dev, size, dma_handle, flag);
@@ -42,7 +42,7 @@ static inline void *dma_alloc_coherent(struct device *dev, size_t size,
 static inline void dma_free_coherent(struct device *dev, size_t size,
 				     void *cpu_addr, dma_addr_t dma_handle)
 {
-	struct dma_map_ops *ops = get_dma_ops(dev);
+	const struct dma_map_ops *ops = get_dma_ops(dev);
 
 	debug_dma_free_coherent(dev, size, cpu_addr, dma_handle);
 	ops->free_coherent(dev, size, cpu_addr, dma_handle);
diff --git a/arch/sparc/kernel/iommu.c b/arch/sparc/kernel/iommu.c
index 7690cc2..ece64c9 100644
--- a/arch/sparc/kernel/iommu.c
+++ b/arch/sparc/kernel/iommu.c
@@ -826,7 +826,7 @@ static void dma_4u_sync_sg_for_cpu(struct device *dev,
 	spin_unlock_irqrestore(&iommu->lock, flags);
 }
 
-static struct dma_map_ops sun4u_dma_ops = {
+static const struct dma_map_ops sun4u_dma_ops = {
 	.alloc_coherent		= dma_4u_alloc_coherent,
 	.free_coherent		= dma_4u_free_coherent,
 	.map_page		= dma_4u_map_page,
@@ -837,7 +837,7 @@ static struct dma_map_ops sun4u_dma_ops = {
 	.sync_sg_for_cpu	= dma_4u_sync_sg_for_cpu,
 };
 
-struct dma_map_ops *dma_ops = &sun4u_dma_ops;
+const struct dma_map_ops *dma_ops = &sun4u_dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
 extern int pci64_dma_supported(struct pci_dev *pdev, u64 device_mask);
diff --git a/arch/sparc/kernel/ioport.c b/arch/sparc/kernel/ioport.c
index 3c8c44f..3ea3025 100644
--- a/arch/sparc/kernel/ioport.c
+++ b/arch/sparc/kernel/ioport.c
@@ -397,7 +397,7 @@ static void sbus_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
 	BUG();
 }
 
-struct dma_map_ops sbus_dma_ops = {
+const struct dma_map_ops sbus_dma_ops = {
 	.alloc_coherent		= sbus_alloc_coherent,
 	.free_coherent		= sbus_free_coherent,
 	.map_page		= sbus_map_page,
@@ -408,7 +408,7 @@ struct dma_map_ops sbus_dma_ops = {
 	.sync_sg_for_device	= sbus_sync_sg_for_device,
 };
 
-struct dma_map_ops *dma_ops = &sbus_dma_ops;
+const struct dma_map_ops *dma_ops = &sbus_dma_ops;
 EXPORT_SYMBOL(dma_ops);
 
 static int __init sparc_register_ioport(void)
@@ -645,7 +645,7 @@ static void pci32_sync_sg_for_device(struct device *device, struct scatterlist *
 	}
 }
 
-struct dma_map_ops pci32_dma_ops = {
+const struct dma_map_ops pci32_dma_ops = {
 	.alloc_coherent		= pci32_alloc_coherent,
 	.free_coherent		= pci32_free_coherent,
 	.map_page		= pci32_map_page,
-- 
1.6.5.3

