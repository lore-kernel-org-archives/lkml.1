Return-Path: <linux-kernel-owner+w=401wt.eu-S1758789AbZC2PbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758789AbZC2PbN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 11:31:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758332AbZC2Pay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 11:30:54 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:39795 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226AbZC2Paw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 11:30:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=pc7P7VeXj4oKRWPqHCVI4fcjxz4X7e88fAVKcLuC80OrBl8v7jSjIo8mxus/iIh2SB
         DfdIPsZ2Qe9U1gxh2NPtOYoXKCKcCBpYQz3jr2Djv6H+cnZhWzVorgiHMxCOliqU2IBv
         +31vR89ooFQ1kLevMQdziUxGVR9VP4vYDakTo=
Date: Sun, 29 Mar 2009 19:30:46 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 9/10] Staging: sxg: convert to netdev_ops
Message-ID: <20090329153046.GI11056@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 drivers/staging/sxg/sxg.c |   27 +++++++++++++++++----------
 1 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/sxg/sxg.c b/drivers/staging/sxg/sxg.c
index 0050a02..db65f52 100644
--- a/drivers/staging/sxg/sxg.c
+++ b/drivers/staging/sxg/sxg.c
@@ -896,6 +896,22 @@ static inline int sxg_read_config(struct adapter_t *adapter)
 	return status;
 }
 
+static const struct net_device_ops sxg_netdev_ops = {
+	.ndo_open		= sxg_entry_open,
+	.ndo_stop		= sxg_entry_halt,
+	.ndo_start_xmit		= sxg_send_packets,
+	.ndo_do_ioctl		= sxg_ioctl,
+	.ndo_change_mtu		= sxg_change_mtu,
+	.ndo_get_stats		= sxg_get_stats,
+	.ndo_set_multicast_list	= sxg_mcast_set_list,
+	.ndo_validate_addr	= eth_validate_addr,
+#if XXXTODO
+	.ndo_set_mac_address	= sxg_mac_set_address,
+#else
+	.ndo_set_mac_address	= eth_mac_addr,
+#endif
+};
+
 static int sxg_entry_probe(struct pci_dev *pcidev,
 			   const struct pci_device_id *pci_tbl_entry)
 {
@@ -1095,16 +1111,7 @@ static int sxg_entry_probe(struct pci_dev *pcidev,
 
 	netdev->base_addr = (unsigned long)adapter->base_addr;
 	netdev->irq = adapter->irq;
-	netdev->open = sxg_entry_open;
-	netdev->stop = sxg_entry_halt;
-	netdev->hard_start_xmit = sxg_send_packets;
-	netdev->do_ioctl = sxg_ioctl;
-	netdev->change_mtu = sxg_change_mtu;
-#if XXXTODO
-	netdev->set_mac_address = sxg_mac_set_address;
-#endif
-	netdev->get_stats = sxg_get_stats;
-	netdev->set_multicast_list = sxg_mcast_set_list;
+	netdev->netdev_ops = &sxg_netdev_ops;
 	SET_ETHTOOL_OPS(netdev, &sxg_nic_ethtool_ops);
  	netdev->features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
 	err = sxg_set_interrupt_capability(adapter);
