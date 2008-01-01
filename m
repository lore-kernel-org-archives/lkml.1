Return-Path: <linux-kernel-owner+w=401wt.eu-S1754602AbYAACIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbYAACIe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 21:08:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbYAACFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 21:05:47 -0500
Received: from fmailhost02.isp.att.net ([207.115.11.52]:44509 "EHLO
	fmailhost02.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514AbYAACFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 21:05:32 -0500
X-Originating-IP: [68.222.90.230]
From: jacliburn@bellsouth.net
To: jeff@garzik.org
Cc: csnook@redhat.com, linux-kernel@vger.kernel.org,
       atl1-devel@lists.sourceforge.net, Jay Cliburn <jacliburn@bellsouth.net>
Subject: [PATCH 07/26] atl1: clarify max rx frame size
Date: Mon, 31 Dec 2007 19:59:45 -0600
Message-Id: <1199152804-3889-8-git-send-email-jacliburn@bellsouth.net>
X-Mailer: git-send-email 1.5.3.3
In-Reply-To: <1199152804-3889-1-git-send-email-jacliburn@bellsouth.net>
References: <1199152804-3889-1-git-send-email-jacliburn@bellsouth.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jay Cliburn <jacliburn@bellsouth.net>

When we initially set max rx frame size, we don't explicitly allow room for
the VLAN header; it's done later in a somewhat obscure fashion.  Let's make
it clear from the top that we've allowed enough room for the VLAN header.

Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
---
 drivers/net/atlx/atl1.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/atlx/atl1.c b/drivers/net/atlx/atl1.c
index 695dcbc..c93cf19 100644
--- a/drivers/net/atlx/atl1.c
+++ b/drivers/net/atlx/atl1.c
@@ -113,7 +113,7 @@ static int __devinit atl1_sw_init(struct atl1_adapter *adapter)
 	struct atl1_hw *hw = &adapter->hw;
 	struct net_device *netdev = adapter->netdev;
 
-	hw->max_frame_size = netdev->mtu + ETH_HLEN + ETH_FCS_LEN;
+	hw->max_frame_size = netdev->mtu + ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN;
 	hw->min_frame_size = ETH_ZLEN + ETH_FCS_LEN;
 
 	adapter->wol = 0;
@@ -744,8 +744,8 @@ static u32 atl1_configure(struct atl1_adapter *adapter)
 	/* set Interrupt Clear Timer */
 	iowrite16(adapter->ict, hw->hw_addr + REG_CMBDISDMA_TIMER);
 
-	/* set MTU, 4 : VLAN */
-	iowrite32(hw->max_frame_size + 4, hw->hw_addr + REG_MTU);
+	/* set MTU size */
+	iowrite32(hw->max_frame_size, hw->hw_addr + REG_MTU);
 
 	/* jumbo size & rrd retirement timer */
 	value = (((u32) hw->rx_jumbo_th & RXQ_JMBOSZ_TH_MASK)
-- 
1.5.3.3

