Return-Path: <linux-kernel-owner+w=401wt.eu-S1758713AbZC2Pac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713AbZC2Pac (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 11:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757382AbZC2PaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 11:30:17 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:46729 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbZC2PaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 11:30:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=J52c6DhjuNfc9k2wJrFVBVID3HPPKiFFqdKuNLkMbqcD/IDnaw9qDJTeFZBtYp8iag
         5yFZesOCLqSXKEhVEjLb4ijlViVDs6ojKknO78RZ+Tp9leONzs7m2q52dVdSPIjwW0cI
         qRJEonXb3nPDaaArpg6Jv1kX9T0I477HzF5t8=
Date: Sun, 29 Mar 2009 19:30:08 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 8/10] Staging: slicoss: convert to netdev_ops
Message-ID: <20090329153008.GH11056@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 drivers/staging/slicoss/slicoss.c |   21 ++++++++++++++-------
 1 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index 953684f..22343fc 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -345,6 +345,19 @@ static void slic_init_adapter(struct net_device *netdev,
 	return;
 }
 
+static const struct net_device_ops slic_netdev_ops = {
+	.ndo_open		= slic_entry_open,
+	.ndo_stop		= slic_entry_halt,
+	.ndo_start_xmit		= slic_xmit_start,
+	.ndo_do_ioctl		= slic_ioctl,
+	.ndo_set_mac_address	= slic_mac_set_address,
+	.ndo_get_stats		= slic_get_stats,
+	.ndo_set_multicast_list	= slic_mcast_set_list,
+	.ndo_validate_addr	= eth_validate_addr,
+	.ndo_set_mac_address	= eth_mac_addr,
+	.ndo_change_mtu		= eth_change_mtu,
+};
+
 static int __devinit slic_entry_probe(struct pci_dev *pcidev,
 			       const struct pci_device_id *pci_tbl_entry)
 {
@@ -442,13 +455,7 @@ static int __devinit slic_entry_probe(struct pci_dev *pcidev,
 
 	netdev->base_addr = (unsigned long)adapter->memorybase;
 	netdev->irq = adapter->irq;
-	netdev->open = slic_entry_open;
-	netdev->stop = slic_entry_halt;
-	netdev->hard_start_xmit = slic_xmit_start;
-	netdev->do_ioctl = slic_ioctl;
-	netdev->set_mac_address = slic_mac_set_address;
-	netdev->get_stats = slic_get_stats;
-	netdev->set_multicast_list = slic_mcast_set_list;
+	netdev->netdev_ops = &slic_netdev_ops;
 
 	slic_debug_adapter_create(adapter);
 
