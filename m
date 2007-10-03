Return-Path: <linux-kernel-owner+w=401wt.eu-S1757451AbXJCCs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451AbXJCCs7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 22:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755113AbXJCCsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 22:48:52 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:38465 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754600AbXJCCsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 22:48:52 -0400
From: akepner@sgi.com
Date: Tue, 2 Oct 2007 19:47:52 -0700
To: Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       RolandDreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@steeleye.com>,
       David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] dma: document dma_flags_set_attr()
Message-ID: <20071003024752.GH26752@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Document dma_flags_set_attr().

Signed-off-by: Arthur Kepner <akepner@sgi.com>

---

 DMA-API.txt |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+)

diff --git a/Documentation/DMA-API.txt b/Documentation/DMA-API.txt
index cc7a8c3..16e15c0 100644
--- a/Documentation/DMA-API.txt
+++ b/Documentation/DMA-API.txt
@@ -544,3 +544,30 @@ size is the size (and should be a page-sized multiple).
 The return value will be either a pointer to the processor virtual
 address of the memory, or an error (via PTR_ERR()) if any part of the
 region is occupied.
+
+int 
+dma_flags_set_attr(u32 attr, enum dma_data_direction dir)
+
+Amend dir with a platform-specific "dma attribute".
+
+The only attribute currently defined is DMA_BARRIER_ATTR, which causes 
+in-flight DMA to be flushed when the associated memory region is written 
+to (see example below).  Setting DMA_BARRIER_ATTR provides a mechanism 
+to enforce ordering of DMA on platforms that permit DMA to be reordered 
+between device and host memory (within a NUMA interconnect).  On other 
+platforms this is a nop.
+
+DMA_BARRIER_ATTR would be set when the memory region is mapped for DMA, 
+e.g.:
+
+	int count;
+	int flags = dma_flags_set_attr(DMA_BARRIER_ATTR, DMA_BIDIRECTIONAL);
+	....
+	count = dma_map_sg(dev, sglist, nents, flags);
+
+As an example of a situation where this would be useful, suppose that 
+the device does a DMA write to indicate that data is ready and 
+available in memory.  The DMA of the "completion indication" could 
+race with data DMA.  Using DMA_BARRIER_ATTR on the memory used for 
+completion indications would prevent the race.
+
