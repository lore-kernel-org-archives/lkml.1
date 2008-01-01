Return-Path: <linux-kernel-owner+w=401wt.eu-S1753818AbYAACFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbYAACFf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 21:05:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbYAACFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 21:05:23 -0500
Received: from fmailhost01.isp.att.net ([204.127.217.101]:39013 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbYAACFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 21:05:22 -0500
X-Greylist: delayed 311 seconds by postgrey-1.27 at vger.kernel.org; Mon, 31 Dec 2007 21:05:22 EST
X-Originating-IP: [68.222.90.230]
From: jacliburn@bellsouth.net
To: jeff@garzik.org
Cc: csnook@redhat.com, linux-kernel@vger.kernel.org,
       atl1-devel@lists.sourceforge.net, Jay Cliburn <jacliburn@bellsouth.net>
Subject: [PATCH 06/26] atl1: update initialization parameters
Date: Mon, 31 Dec 2007 19:59:44 -0600
Message-Id: <1199152804-3889-7-git-send-email-jacliburn@bellsouth.net>
X-Mailer: git-send-email 1.5.3.3
In-Reply-To: <1199152804-3889-1-git-send-email-jacliburn@bellsouth.net>
References: <1199152804-3889-1-git-send-email-jacliburn@bellsouth.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jay Cliburn <jacliburn@bellsouth.net>

Update initialization parameters to match the current vendor driver
version 1.2.40.2.

Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
---
 drivers/net/atlx/atl1.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/atlx/atl1.c b/drivers/net/atlx/atl1.c
index 262d3ca..695dcbc 100644
--- a/drivers/net/atlx/atl1.c
+++ b/drivers/net/atlx/atl1.c
@@ -136,20 +136,20 @@ static int __devinit atl1_sw_init(struct atl1_adapter *adapter)
 	hw->rfd_fetch_gap = 1;
 	hw->rx_jumbo_th = adapter->rx_buffer_len / 8;
 	hw->rx_jumbo_lkah = 1;
-	hw->rrd_ret_timer = 16;
-	hw->tpd_burst = 4;
+	hw->rrd_ret_timer = 4;	/* 8 us */
+	hw->tpd_burst = 8;
 	hw->tpd_fetch_th = 16;
-	hw->txf_burst = 0x100;
+	hw->txf_burst = 0x200;
 	hw->tx_jumbo_task_th = (hw->max_frame_size + 7) >> 3;
 	hw->tpd_fetch_gap = 1;
 	hw->rcb_value = atl1_rcb_64;
 	hw->dma_ord = atl1_dma_ord_enh;
-	hw->dmar_block = atl1_dma_req_256;
-	hw->dmaw_block = atl1_dma_req_256;
+	hw->dmar_block = atl1_dma_req_1024;
+	hw->dmaw_block = atl1_dma_req_1024;
 	hw->cmb_rrd = 4;
 	hw->cmb_tpd = 4;
-	hw->cmb_rx_timer = 1;	/* about 2us */
-	hw->cmb_tx_timer = 1;	/* about 2us */
+	hw->cmb_rx_timer = 2;	/* about 4us */
+	hw->cmb_tx_timer = 256;	/* about 512us */
 	hw->smb_timer = 100000;	/* about 200ms */
 
 	spin_lock_init(&adapter->lock);
-- 
1.5.3.3

