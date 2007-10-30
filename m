Return-Path: <linux-kernel-owner+w=401wt.eu-S1754409AbXJ3JE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbXJ3JE2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 05:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbXJ3JES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 05:04:18 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:1255 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbXJ3JER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 05:04:17 -0400
X-IronPort-AV: i="4.21,346,1188792000"; 
   d="scan'208"; a="42688599:sNHT25951163"
From: Bryan Wu <bryan.wu@analog.com>
To: jeff@garzik.org, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 1/1] Blackfin EMAC driver: Fix Ethernet communication bug (dupliated and lost packets)
Date: Tue, 30 Oct 2007 17:04:09 +0800
Message-Id: <1193735049-7070-1-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Fix Ethernet communication bug(dupliated and lost packets)
in RMII PHY mode- dont call mac_disable and mac_enable during
10/100 REFCLK changes - mac_enable screws up the DMA descriptor chain

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 drivers/net/bfin_mac.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bfin_mac.c b/drivers/net/bfin_mac.c
index 53fe7de..084acfd 100644
--- a/drivers/net/bfin_mac.c
+++ b/drivers/net/bfin_mac.c
@@ -371,7 +371,6 @@ static void bf537_adjust_link(struct net_device *dev)
 		if (phydev->speed != lp->old_speed) {
 #if defined(CONFIG_BFIN_MAC_RMII)
 			u32 opmode = bfin_read_EMAC_OPMODE();
-			bf537mac_disable();
 			switch (phydev->speed) {
 			case 10:
 				opmode |= RMII_10;
@@ -386,7 +385,6 @@ static void bf537_adjust_link(struct net_device *dev)
 				break;
 			}
 			bfin_write_EMAC_OPMODE(opmode);
-			bf537mac_enable();
 #endif
 
 			new_state = 1;
-- 
1.5.3.4
