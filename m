Return-Path: <linux-kernel-owner+w=401wt.eu-S1755753AbXIZACL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753AbXIZACL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 20:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbXIZAB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 20:01:58 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:60615 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751089AbXIZAB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 20:01:57 -0400
From: akepner@sgi.com
Date: Tue, 25 Sep 2007 17:00:57 -0700
To: Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       David Miller <davem@davemloft.net>, Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] dma: add dma_flags_set_dmaflush() to dma interface
Message-ID: <20070926000057.GL30013@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Introduce the dma_flags_set_dmaflush() interface and give it
a default no-op implementation.

Signed-off-by: Arthur Kepner <akepner@sgi.com>
-- 

 dma-mapping.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 2dc21cb..a0f27b9 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -99,4 +99,11 @@ static inline void dmam_release_declared_memory(struct device *dev)
 }
 #endif /* ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY */
 
+#ifndef ARCH_CAN_REORDER_DMA
+static inline int
+dma_flags_set_dmaflush(int dir) {
+	return (dir);
+}
+#endif /* ARCH_CAN_REORDER_DMA */
+
 #endif
