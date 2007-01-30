Return-Path: <linux-kernel-owner+w=401wt.eu-S965371AbXA3NYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965371AbXA3NYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 08:24:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965372AbXA3NYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 08:24:04 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41155 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965371AbXA3NXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 08:23:54 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] b44: src_desc->addr is little-endian
Cc: davem@davemloft.net, jgarzik@pobox.com, linux-kernel@vger.kernel.org
Message-Id: <E1HBsxi-0002Nz-VA@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Tue, 30 Jan 2007 13:23:50 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/net/b44.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/b44.c b/drivers/net/b44.c
index 5eb2ec6..cfc89bc 100644
--- a/drivers/net/b44.c
+++ b/drivers/net/b44.c
@@ -752,7 +752,7 @@ static void b44_recycle_rx(struct b44 *bp, int src_idx, u32 dest_idx_unmasked)
 		                             dest_idx * sizeof(dest_desc),
 		                             DMA_BIDIRECTIONAL);
 
-	pci_dma_sync_single_for_device(bp->pdev, src_desc->addr,
+	pci_dma_sync_single_for_device(bp->pdev, le32_to_cpu(src_desc->addr),
 				       RX_PKT_BUF_SZ,
 				       PCI_DMA_FROMDEVICE);
 }
-- 
1.5.0-rc2.GIT


