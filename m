Return-Path: <linux-kernel-owner+w=401wt.eu-S1757340AbXJCCqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340AbXJCCqL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 22:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754600AbXJCCp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 22:45:57 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50882 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754247AbXJCCp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 22:45:57 -0400
From: akepner@sgi.com
Date: Tue, 2 Oct 2007 19:44:57 -0700
To: Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       RolandDreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@steeleye.com>,
       David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] dma: add dma_flags_set_attr() to dma interface
Message-ID: <20071003024457.GF26752@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Introduce the dma_flags_set_attr() interface and give it a default 
no-op implementation.

Signed-off-by: Arthur Kepner <akepner@sgi.com>

---

 dma-mapping.h |    8 ++++++++
 1 files changed, 8 insertions(+)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 2dc21cb..4990aaf 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -99,4 +99,12 @@ static inline void dmam_release_declared_memory(struct device *dev)
 }
 #endif /* ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY */
 
+#define DMA_BARRIER_ATTR	0x1
+#ifndef ARCH_USES_DMA_ATTRS
+static inline int dma_flags_set_attr(u32 attr, enum dma_data_direction dir) 
+{
+	return dir;
+}
+#endif /* ARCH_USES_DMA_ATTRS */
+
 #endif
