Return-Path: <linux-kernel-owner+w=401wt.eu-S1758579AbYHGNNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758579AbYHGNNu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 09:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754537AbYHGNN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 09:13:27 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:8975 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250AbYHGNN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 09:13:26 -0400
Message-ID: <489B21CA.7010508@gmail.com>
Date: Thu, 07 Aug 2008 12:24:42 -0400
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: jie.yang@atheros.com, jgarzik@redhat.com
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH?] atl1e: WAKE_MCAST 2x. 1st WAKE_UCAST?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

untested, is it right?
---
WAKE_MCAST bit tested twice, test WAKE_UCAST first.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
diff --git a/drivers/net/atl1e/atl1e_ethtool.c b/drivers/net/atl1e/atl1e_ethtool.c
index cdc3b85..619c658 100644
--- a/drivers/net/atl1e/atl1e_ethtool.c
+++ b/drivers/net/atl1e/atl1e_ethtool.c
@@ -355,7 +355,7 @@ static int atl1e_set_wol(struct net_device *netdev, struct ethtool_wolinfo *wol)
 	struct atl1e_adapter *adapter = netdev_priv(netdev);
 
 	if (wol->wolopts & (WAKE_ARP | WAKE_MAGICSECURE |
-			    WAKE_MCAST | WAKE_BCAST | WAKE_MCAST))
+			    WAKE_UCAST | WAKE_MCAST | WAKE_BCAST))
 		return -EOPNOTSUPP;
 	/* these settings will always override what we currently have */
 	adapter->wol = 0;
