Return-Path: <linux-kernel-owner+w=401wt.eu-S1753586AbYJXGNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbYJXGNx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 02:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750854AbYJXGNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 02:13:44 -0400
Received: from sh.osrg.net ([192.16.179.4]:43596 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695AbYJXGNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 02:13:43 -0400
Date: Fri, 24 Oct 2008 15:13:23 +0900
To: mchehab@redhat.com
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] dm1105: fix the misuse of pci_dma_mapping_error
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081024151326F.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci_dma_mapping_error can't be used for pci_alloc_consistent
(pci_dma_mapping_error is for dma_map_single and dma_map_page).
pci_alloc_consistent returns NULL if the allocation fails.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/media/dvb/dm1105/dm1105.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dm1105/dm1105.c b/drivers/media/dvb/dm1105/dm1105.c
index 14e627e..ab9282e 100644
--- a/drivers/media/dvb/dm1105/dm1105.c
+++ b/drivers/media/dvb/dm1105/dm1105.c
@@ -368,7 +368,7 @@ static int __devinit dm1105dvb_dma_map(struct dm1105dvb *dm1105dvb)
 {
 	dm1105dvb->ts_buf = pci_alloc_consistent(dm1105dvb->pdev, 6*DM1105_DMA_BYTES, &dm1105dvb->dma_addr);
 
-	return pci_dma_mapping_error(dm1105dvb->pdev, dm1105dvb->dma_addr);
+	return !dm1105dvb->ts_buf;
 }
 
 static void dm1105dvb_dma_unmap(struct dm1105dvb *dm1105dvb)
-- 
1.5.5.GIT

