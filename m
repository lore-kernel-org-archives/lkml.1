Return-Path: <linux-kernel-owner+w=401wt.eu-S1758098AbZC2PXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098AbZC2PXx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 11:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346AbZC2PXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 11:23:42 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:42083 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbZC2PXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 11:23:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=QYfnp5e0P1jBEZtIuC1btJE/bMzCdz9CJ6EvNjPnzL24efWXaswRO9svPUUx4kY19z
         t4OUtkBfkE8+4ZCCUNc67zTRRdosa3ulyIe7E03GHNhInRizNPMzGaK28Lt6xizDZrB8
         sB7pKexph1a4p5ll42yfL9TJPU054lnDiCqBk=
Date: Sun, 29 Mar 2009 19:23:34 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 1/10] Staging: at76: convert to netdev_ops
Message-ID: <20090329152334.GA11056@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 drivers/staging/at76_usb/at76_usb.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/at76_usb/at76_usb.c b/drivers/staging/at76_usb/at76_usb.c
index 6f6e36a..c8af9a8 100644
--- a/drivers/staging/at76_usb/at76_usb.c
+++ b/drivers/staging/at76_usb/at76_usb.c
@@ -5259,6 +5259,18 @@ static int at76_alloc_urbs(struct at76_priv *priv,
 	return 0;
 }
 
+static const struct net_device_ops at76_netdev_ops = {
+	.ndo_open		= at76_open,
+	.ndo_stop		= at76_stop,
+	.ndo_get_stats		= at76_get_stats,
+	.ndo_start_xmit		= at76_tx,
+	.ndo_tx_timeout		= at76_tx_timeout,
+	.ndo_set_multicast_list	= at76_set_multicast,
+	.ndo_set_mac_address	= at76_set_mac_address,
+	.ndo_validate_addr	= eth_validate_addr,
+	.ndo_change_mtu		= eth_change_mtu,
+};
+
 /* Register network device and initialize the hardware */
 static int at76_init_new_device(struct at76_priv *priv,
 				struct usb_interface *interface)
@@ -5303,21 +5315,15 @@ static int at76_init_new_device(struct at76_priv *priv,
 	priv->scan_mode = SCAN_TYPE_ACTIVE;
 
 	netdev->flags &= ~IFF_MULTICAST;	/* not yet or never */
-	netdev->open = at76_open;
-	netdev->stop = at76_stop;
-	netdev->get_stats = at76_get_stats;
+	netdev->netdev_ops = &at76_netdev_ops;
 	netdev->ethtool_ops = &at76_ethtool_ops;
 
 	/* Add pointers to enable iwspy support. */
 	priv->wireless_data.spy_data = &priv->spy_data;
 	netdev->wireless_data = &priv->wireless_data;
 
-	netdev->hard_start_xmit = at76_tx;
-	netdev->tx_timeout = at76_tx_timeout;
 	netdev->watchdog_timeo = 2 * HZ;
 	netdev->wireless_handlers = &at76_handler_def;
-	netdev->set_multicast_list = at76_set_multicast;
-	netdev->set_mac_address = at76_set_mac_address;
 	dev_alloc_name(netdev, "wlan%d");
 
 	ret = register_netdev(priv->netdev);
