Return-Path: <linux-kernel-owner+w=401wt.eu-S1758251AbZC2PZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251AbZC2PZx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 11:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbZC2PZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 11:25:40 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:41798 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbZC2PZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 11:25:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=eph7K4VRYbCV4dLGeqU4i9Uchz1Pn62wJYOUK+5xSC0oqXcF66DZONUQUEnYGWlizy
         ZPRctF5fDeOGnu3ux2o0ta4sYbhe2D7bpGzd+FTFgSYuM0MqBwIJ18p8uoxqDV4cFhe/
         wmXinOqzkYe1p3VdSWci2o0Dzwf3ERSV5gScs=
Date: Sun, 29 Mar 2009 19:25:33 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 3/10] Staging: et131x: convert to netdev_ops
Message-ID: <20090329152533.GC11056@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 drivers/staging/et131x/et131x_netdev.c |   23 ++++++++++++++---------
 1 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/et131x/et131x_netdev.c b/drivers/staging/et131x/et131x_netdev.c
index de65972..951c73d 100644
--- a/drivers/staging/et131x/et131x_netdev.c
+++ b/drivers/staging/et131x/et131x_netdev.c
@@ -112,6 +112,19 @@ void et131x_vlan_rx_register(struct net_device *netdev, struct vlan_group *grp);
 void et131x_vlan_rx_add_vid(struct net_device *netdev, uint16_t vid);
 void et131x_vlan_rx_kill_vid(struct net_device *netdev, uint16_t vid);
 
+static const struct net_device_ops et131x_netdev_ops = {
+	.ndo_open		= et131x_open,
+	.ndo_stop		= et131x_close,
+	.ndo_start_xmit		= et131x_tx,
+	.ndo_set_multicast_list	= et131x_multicast,
+	.ndo_tx_timeout		= et131x_tx_timeout,
+	.ndo_change_mtu		= et131x_change_mtu,
+	.ndo_set_mac_address	= et131x_set_mac_addr,
+	.ndo_validate_addr	= eth_validate_addr,
+	.ndo_get_stats		= et131x_stats,
+	.ndo_do_ioctl		= et131x_ioctl,
+};
+
 /**
  * et131x_device_alloc
  *
@@ -142,16 +155,8 @@ struct net_device *et131x_device_alloc(void)
 	 */
 	//netdev->init               = &et131x_init;
 	//netdev->set_config = &et131x_config;
-	netdev->get_stats = &et131x_stats;
-	netdev->open = &et131x_open;
-	netdev->stop = &et131x_close;
-	netdev->do_ioctl = &et131x_ioctl;
-	netdev->set_multicast_list = &et131x_multicast;
-	netdev->hard_start_xmit = &et131x_tx;
-	netdev->tx_timeout = &et131x_tx_timeout;
 	netdev->watchdog_timeo = ET131X_TX_TIMEOUT;
-	netdev->change_mtu = &et131x_change_mtu;
-	netdev->set_mac_address = &et131x_set_mac_addr;
+	netdev->netdev_ops = &et131x_netdev_ops;
 
 	//netdev->ethtool_ops        = &et131x_ethtool_ops;
 
