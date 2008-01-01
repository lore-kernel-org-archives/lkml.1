Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbYAACNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbYAACNx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 21:13:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754401AbYAACIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 21:08:21 -0500
Received: from fmailhost06.isp.att.net ([207.115.11.56]:44793 "EHLO
	fmailhost06.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246AbYAACIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 21:08:17 -0500
X-Originating-IP: [68.222.90.230]
From: jacliburn@bellsouth.net
To: jeff@garzik.org
Cc: csnook@redhat.com, linux-kernel@vger.kernel.org,
       atl1-devel@lists.sourceforge.net, Jay Cliburn <jacliburn@bellsouth.net>
Subject: [PATCH 22/26] atl1: update netpoll
Date: Mon, 31 Dec 2007 20:00:00 -0600
Message-Id: <1199152804-3889-23-git-send-email-jacliburn@bellsouth.net>
X-Mailer: git-send-email 1.5.3.3
In-Reply-To: <1199152804-3889-1-git-send-email-jacliburn@bellsouth.net>
References: <1199152804-3889-1-git-send-email-jacliburn@bellsouth.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jay Cliburn <jacliburn@bellsouth.net>

Rename atl1_poll_controller() to atl1_netpoll() and update to conform with
the current vendor driver version 1.2.40.2.

Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
---
 drivers/net/atlx/atl1.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/atlx/atl1.c b/drivers/net/atlx/atl1.c
index 997c83c..f09928d 100644
--- a/drivers/net/atlx/atl1.c
+++ b/drivers/net/atlx/atl1.c
@@ -2691,11 +2691,14 @@ static int atl1_resume(struct pci_dev *pdev)
 #endif
 
 #ifdef CONFIG_NET_POLL_CONTROLLER
-static void atl1_poll_controller(struct net_device *netdev)
+static void atl1_netpoll(struct net_device *netdev)
 {
-	disable_irq(netdev->irq);
+	struct atl1_adapter *adapter = netdev_priv(netdev);
+
+	disable_irq(adapter->pdev->irq);
 	atl1_intr(netdev->irq, netdev);
-	enable_irq(netdev->irq);
+	atl1_clean_tx_irq(adapter);
+	enable_irq(adapter->pdev->irq);
 }
 #endif
 
@@ -2796,7 +2799,7 @@ static int __devinit atl1_probe(struct pci_dev *pdev,
 	netdev->tx_timeout = &atlx_tx_timeout;
 	netdev->watchdog_timeo = 5 * HZ;
 #ifdef CONFIG_NET_POLL_CONTROLLER
-	netdev->poll_controller = atl1_poll_controller;
+	netdev->poll_controller = atl1_netpoll;
 #endif
 	netdev->vlan_rx_register = atlx_vlan_rx_register;
 
-- 
1.5.3.3

