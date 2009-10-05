Return-Path: <linux-kernel-owner+w=401wt.eu-S1758644AbZJEIUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758644AbZJEIUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 04:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758292AbZJEIUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 04:20:44 -0400
Received: from msr14.hinet.net ([168.95.4.114]:35226 "EHLO msr14.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394AbZJEIUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 04:20:43 -0400
X-Greylist: delayed 2254 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Oct 2009 04:20:43 EDT
From: Thomas Chou <thomas@wytron.com.tw>
To: thierry.reding@avionic-design.de
Cc: Nios2 development list <nios2-dev@sopc.et.ntust.edu.tw>,
       linux-kernel@vger.kernel.org, Thomas Chou <thomas@wytron.com.tw>
Subject: [PATCH 1/4] ethoc: fix typo to compute number of tx descriptors
Date: Mon,  5 Oct 2009 15:43:02 +0800
Message-Id: <1254728585-31964-1-git-send-email-thomas@wytron.com.tw>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It should be max() instead of min(). Use 1/4 of available
descriptors for tx, and there should be at least 2 tx
descriptors.

Signed-off-by: Thomas Chou <thomas@wytron.com.tw>
---
 drivers/net/ethoc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethoc.c b/drivers/net/ethoc.c
index b7311bc..7475620 100644
--- a/drivers/net/ethoc.c
+++ b/drivers/net/ethoc.c
@@ -655,7 +655,7 @@ static int ethoc_open(struct net_device *dev)
 
 	/* calculate the number of TX/RX buffers */
 	num_bd = (dev->mem_end - dev->mem_start + 1) / ETHOC_BUFSIZ;
-	priv->num_tx = min(min_tx, num_bd / 4);
+	priv->num_tx = max(min_tx, num_bd / 4);
 	priv->num_rx = num_bd - priv->num_tx;
 	ethoc_write(priv, TX_BD_NUM, priv->num_tx);
 
-- 
1.6.2.5

