Return-Path: <linux-kernel-owner+w=401wt.eu-S1754993Ab0AERFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab0AERFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 12:05:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754986Ab0AERDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 12:03:25 -0500
Received: from [206.15.93.42] ([206.15.93.42]:9423 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932088Ab0AERDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 12:03:23 -0500
X-Greylist: delayed 1075 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jan 2010 12:03:20 EST
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/net/atl1c/atl1c_main.c: use %pM to show MAC address
Date: Tue, 5 Jan 2010 09:54:01 -0700
Cc: netdev@vger.kernel.org, davem@davemloft.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001050954.01826.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the %pM kernel extension to display the MAC address.

The only difference in the output is that the MAC address is
shown in the usual colon-separated hex notation.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David S. Miller <davem@davemloft.net>

---

Repost due to merge issues.

diff --git a/drivers/net/atl1c/atl1c_main.c b/drivers/net/atl1c/atl1c_main.c
index 2f4be59..77cde85 100644
--- a/drivers/net/atl1c/atl1c_main.c
+++ b/drivers/net/atl1c/atl1c_main.c
@@ -2596,11 +2596,8 @@ static int __devinit atl1c_probe(struct pci_dev *pdev,
 	memcpy(netdev->dev_addr, adapter->hw.mac_addr, netdev->addr_len);
 	memcpy(netdev->perm_addr, adapter->hw.mac_addr, netdev->addr_len);
 	if (netif_msg_probe(adapter))
-		dev_dbg(&pdev->dev,
-			"mac address : %02x-%02x-%02x-%02x-%02x-%02x\n",
-			adapter->hw.mac_addr[0], adapter->hw.mac_addr[1],
-			adapter->hw.mac_addr[2], adapter->hw.mac_addr[3],
-			adapter->hw.mac_addr[4], adapter->hw.mac_addr[5]);
+		dev_dbg(&pdev->dev, "mac address : %pM\n",
+			adapter->hw.mac_addr);
 
 	atl1c_hw_set_mac_addr(&adapter->hw);
 	INIT_WORK(&adapter->common_task, atl1c_common_task);
