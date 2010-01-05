Return-Path: <linux-kernel-owner+w=401wt.eu-S932069Ab0AEQkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069Ab0AEQkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 11:40:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755059Ab0AEQkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 11:40:40 -0500
Received: from [206.15.93.42] ([206.15.93.42]:6958 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754615Ab0AEQki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 11:40:38 -0500
X-Greylist: delayed 1092 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jan 2010 11:40:34 EST
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] amso1100/c2_provider.c: use %pM to show MAC address
Date: Tue, 5 Jan 2010 09:39:42 -0700
Cc: tom@opengridcomputing.com, davem@davemloft.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001050939.42939.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the %pM kernel extension to display the MAC address.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Tom Tucker <tom@opengridcomputing.com>
Cc: David S. Miller <davem@davemloft.net>

---

Repost due to merge issues.

diff --git a/drivers/infiniband/hw/amso1100/c2_provider.c b/drivers/infiniband/hw/amso1100/c2_provider.c
index ad723bd..712314a 100644
--- a/drivers/infiniband/hw/amso1100/c2_provider.c
+++ b/drivers/infiniband/hw/amso1100/c2_provider.c
@@ -760,10 +760,7 @@ static struct net_device *c2_pseudo_netdev_init(struct c2_dev *c2dev)
 	memcpy_fromio(netdev->dev_addr, c2dev->kva + C2_REGS_RDMA_ENADDR, 6);
 
 	/* Print out the MAC address */
-	pr_debug("%s: MAC %02X:%02X:%02X:%02X:%02X:%02X\n",
-		netdev->name,
-		netdev->dev_addr[0], netdev->dev_addr[1], netdev->dev_addr[2],
-		netdev->dev_addr[3], netdev->dev_addr[4], netdev->dev_addr[5]);
+	pr_debug("%s: MAC %pM\n", netdev->name, netdev->dev_addr);
 
 #if 0
 	/* Disable network packets */
