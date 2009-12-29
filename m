Return-Path: <linux-kernel-owner+w=401wt.eu-S1752823AbZL2QWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbZL2QWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 11:22:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbZL2QWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 11:22:45 -0500
Received: from exprod6og116.obsmtp.com ([64.18.1.37]:40925 "HELO
	exprod6og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752453AbZL2QWp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 11:22:45 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] amso1100/c2_provider.c: use %pM to shown MAC address
Date: Tue, 29 Dec 2009 11:22:42 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200F533@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] amso1100/c2_provider.c: use %pM to shown MAC address
Thread-Index: AcqIoyVKTRnd1CzwQe2AAzLPmF8lNQ==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
Cc: "David Miller" <davem@davemloft.net>, <tom@opengridcomputing.com>
X-OriginalArrivalTime: 29 Dec 2009 16:22:42.0785 (UTC) FILETIME=[25BFBD10:01CA88A3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the %pM kernel extension to display the MAC address.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Tom Tucker <tom@opengridcomputing.com>

---

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
