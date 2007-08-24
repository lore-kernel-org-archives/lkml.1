Return-Path: <linux-kernel-owner+w=401wt.eu-S932650AbXHXSKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650AbXHXSKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 14:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933179AbXHXSJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 14:09:52 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53056 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932853AbXHXSJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 14:09:50 -0400
From: akepner@sgi.com
Date: Fri, 24 Aug 2007 11:08:49 -0700
To: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Cc: gregkh@suse.de, James Bottomley <James.Bottomley@HansenPartnership.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       David Miller <davem@davemloft.net>
Subject: [PATCH 3/3] pci: document pci_dma_flags_set_dmaflush()
Message-ID: <20070824180849.GS5592@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Document pci_dma_flags_set_dmaflush().

Signed-off-by: Arthur Kepner <akepner@sgi.com>
--
 DMA-mapping.txt |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)
 
diff --git a/Documentation/DMA-mapping.txt b/Documentation/DMA-mapping.txt
index e07f253..32f88e5 100644
--- a/Documentation/DMA-mapping.txt
+++ b/Documentation/DMA-mapping.txt
@@ -745,7 +745,30 @@ to "Closing".
    2.5., page+offset is always used, and the "address" field has been
    deleted.
 
-2) More to come...
+2) Platforms that permit DMA reordering
+
+   At least one platform (SGI SN2) allows DMA to be reordered between
+   device and host memory. This reordering can happen in the NUMA
+   interconnect, and it usually results in correct operation and improved
+   performance. In some situations it may be necessary to explicitly
+   synchronize DMA from the device. For example, if the device does a DMA
+   write to indicate that data is ready, the DMA of the "completion
+   indication" can race with DMA of data. In this situation,
+   pci_dma_flags_set_dmaflush() can be used to associate a "dmaflush"
+   attribute with a memory region. The dmaflush attribute will cause in-
+   flight DMA from the device to be flushed to host memory when the
+   associated memory region is written. (On platforms that don't permit
+   DMA reordering, this is a no-op.)
+
+   For example, you might map the memory region used for completion
+   indications as follows:
+
+	int count, flags = pci_dma_flags_set_dmaflush(DMA_BIDIRECTIONAL);
+	.....
+	count = dma_map_sg(dev, sglist, nents, flags);
+
+
+3) More to come...
 
 			Handling Errors
 

-- 
Arthur

