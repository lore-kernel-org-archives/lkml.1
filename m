Return-Path: <linux-kernel-owner+w=401wt.eu-S1755705AbYAACNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705AbYAACNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 21:13:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754561AbYAACIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 21:08:19 -0500
Received: from fmailhost05.isp.att.net ([207.115.11.55]:56544 "EHLO
	fmailhost05.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235AbYAACIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 21:08:16 -0500
X-Originating-IP: [68.222.90.230]
From: jacliburn@bellsouth.net
To: jeff@garzik.org
Cc: csnook@redhat.com, linux-kernel@vger.kernel.org,
       atl1-devel@lists.sourceforge.net, Jay Cliburn <jacliburn@bellsouth.net>
Subject: [PATCH 21/26] atl1: update atl1_close
Date: Mon, 31 Dec 2007 19:59:59 -0600
Message-Id: <1199152804-3889-22-git-send-email-jacliburn@bellsouth.net>
X-Mailer: git-send-email 1.5.3.3
In-Reply-To: <1199152804-3889-1-git-send-email-jacliburn@bellsouth.net>
References: <1199152804-3889-1-git-send-email-jacliburn@bellsouth.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jay Cliburn <jacliburn@bellsouth.net>

Update atl1_close() to conform with current vendor driver version 1.2.40.2.

Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
---
 drivers/net/atlx/atl1.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/net/atlx/atl1.c b/drivers/net/atlx/atl1.c
index 7d84a51..997c83c 100644
--- a/drivers/net/atlx/atl1.c
+++ b/drivers/net/atlx/atl1.c
@@ -2558,6 +2558,18 @@ err_open:
 	return err;
 }
 
+static void atl1_free_irq(struct atl1_adapter *adapter)
+{
+	struct net_device *netdev = adapter->netdev;
+
+	free_irq(adapter->pdev->irq, netdev);
+
+#ifdef CONFIG_PCI_MSI
+	if (adapter->have_msi)
+		pci_disable_msi(adapter->pdev);
+#endif
+}
+
 /*
  * atl1_close - Disables a network interface
  * @netdev: network interface device structure
@@ -2572,7 +2584,9 @@ err_open:
 static int atl1_close(struct net_device *netdev)
 {
 	struct atl1_adapter *adapter = netdev_priv(netdev);
+
 	atl1_down(adapter);
+	atl1_free_irq(adapter);
 	atl1_free_ring_resources(adapter);
 	return 0;
 }
-- 
1.5.3.3

