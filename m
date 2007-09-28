Return-Path: <linux-kernel-owner+w=401wt.eu-S1760687AbXI1BMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760687AbXI1BMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 21:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757630AbXI1BMC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 21:12:02 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57291 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756596AbXI1BMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 21:12:00 -0400
From: akepner@sgi.com
Date: Thu, 27 Sep 2007 18:10:59 -0700
To: Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       RolandDreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-kernel@vger.kernel.org
Subject: [1/4] dma: add dma_flags_set_dmabarrier() to dma interface
Message-ID: <20070928011059.GN30013@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Introduce the dma_flags_set_dmabarrier() interface and give it
a default no-op implementation.

Signed-off-by: Arthur Kepner <akepner@sgi.com>

--- 

 dma-mapping.h |    6 ++++++
 1 files changed, 6 insertions(+)
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h

index 2dc21cb..4d1d199 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -99,4 +99,10 @@ static inline void dmam_release_declared_memory(struct device *dev)
 }
 #endif /* ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY */
 
+#ifndef ARCH_CAN_REORDER_DMA
+static inline int dma_flags_set_dmabarrier(int dir) {
+	return dir;
+}
+#endif /* ARCH_CAN_REORDER_DMA */
+
 #endif
