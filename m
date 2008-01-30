Return-Path: <linux-kernel-owner+w=401wt.eu-S1756116AbYA3FvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbYA3FvR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 00:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753799AbYA3FvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 00:51:08 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52492 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753840AbYA3FvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 00:51:07 -0500
From: akepner@sgi.com
Date: Tue, 29 Jan 2008 21:49:38 -0800
To: Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       David Miller <davem@davemloft.net>, Muli Ben-Yehuda <muli@il.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] dma: dma_{un}map_{single|sg}_attrs() interface
Message-ID: <20080130054938.GR30022@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Introduce a new interface for passing architecture-specific 
attributes when memory is mapped and unmapped for DMA. Give 
the interface a default implementation which ignores 
attributes.

Signed-off-by: Arthur Kepner <akepner@sgi.com>

--

 dma-mapping.h |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 101a2d4..bc313e3 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -116,4 +116,37 @@ static inline void dmam_release_declared_memory(struct device *dev)
 }
 #endif /* ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY */
 
+#ifndef ARCH_USES_DMA_ATTRS
+struct dma_attrs;
+
+static inline dma_addr_t dma_map_single_attrs(struct device *dev, 
+					      void *cpu_addr, size_t size, 
+					      int dir, struct dma_attrs* attrs)
+{
+	return dma_map_single(dev, cpu_addr, size, dir);
+}
+
+static inline void dma_unmap_single_attrs(struct device *dev, 
+					  dma_addr_t dma_addr,
+					  size_t size, int dir, 
+					  struct dma_attrs* attrs)
+{
+	return dma_unmap_single(dev, dma_addr, size, dir);
+}
+
+static inline int dma_map_sg_attrs(struct device *dev, struct scatterlist *sgl,
+				   int nents, int dir, struct dma_attrs *attrs)
+{
+	return dma_map_sg(dev, sgl, nents, dir);
+}
+
+static inline void dma_unmap_sg_attrs(struct device *dev, 
+				      struct scatterlist *sgl,
+				      int nents, int dir, 
+				      struct dma_attrs *attrs)
+{
+	return dma_unmap_sg(dev, sgl, nents, dir);
+}
+#endif /* ARCH_USES_DMA_ATTRS */
+
 #endif


