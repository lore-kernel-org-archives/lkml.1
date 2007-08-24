Return-Path: <linux-kernel-owner+w=401wt.eu-S933060AbXHXSHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933060AbXHXSHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 14:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932829AbXHXSHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 14:07:04 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:52834 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932794AbXHXSHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 14:07:01 -0400
From: akepner@sgi.com
Date: Fri, 24 Aug 2007 11:05:59 -0700
To: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Cc: gregkh@suse.de, James Bottomley <James.Bottomley@HansenPartnership.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       David Miller <davem@davemloft.net>
Subject: [PATCH 1/3] pci: add pci_dma_flags_set_dmaflush() to pci interface
Message-ID: <20070824180559.GQ5592@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Introduce the pci_dma_flags_set_dmaflush() interface and give it 
a default no-op implementation.

Signed-off-by: Arthur Kepner <akepner@sgi.com>
--
 pci.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index e7d8d4e..cee5709 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -825,6 +825,13 @@ static inline void pci_resource_to_user(const struct pci_dev *dev, int bar,
 }
 #endif /* HAVE_ARCH_PCI_RESOURCE_TO_USER */
 
+#ifdef ARCH_CAN_REORDER_DMA
+extern int pci_dma_flags_set_dmaflush(int dir);
+#else /* ARCH_CAN_REORDER_DMA */
+static inline int pci_dma_flags_set_dmaflush(int dir) {
+	return (dir);
+}
+#endif /* ARCH_CAN_REORDER_DMA */
 
 /*
  *  The world is not perfect and supplies us with broken PCI devices.
-- 
Arthur

