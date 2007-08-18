Return-Path: <linux-kernel-owner+w=401wt.eu-S1760800AbXHRA3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760800AbXHRA3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 20:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757442AbXHRA2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 20:28:39 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59189 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757462AbXHRA2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 20:28:32 -0400
From: akepner@sgi.com
Date: Fri, 17 Aug 2007 17:27:37 -0700
To: linux-kernel@vger.kernel.org
Cc: rdreier@cisco.com
Subject: [PATCH 1/3] dma: introduce no-op stub "dma_flags_set_dmaflush"
Message-ID: <20070818002737.GT1813@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Introduce a no-op stub function "dma_flags_set_dmaflush". Arches 
can override this if necessary to associate a "dmaflush" attribute
with a DMA-able memory region. In-flight DMA will be flushed to 
host memory when a memory region with the dmaflush attribute is 
written to.

Signed-off-by: Arthur Kepner <akepner@sgi.com>
-- 
 dma-mapping.h |    7 +++++++
 1 files changed, 7 insertions(+)
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 2dc21cb..594a651 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -99,4 +99,11 @@ static inline void dmam_release_declared_memory(struct device *dev)
 }
 #endif /* ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY */
 
+#ifndef ARCH_DOES_POSTED_DMA
+static inline int
+dma_flags_set_dmaflush(int dir) {
+	return (dir);
+}
+#endif /* ARCH_DOES_POSTED_DMA */
+
 #endif
-- 
Arthur

