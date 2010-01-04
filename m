Return-Path: <linux-kernel-owner+w=401wt.eu-S1753663Ab0ADRjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab0ADRjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 12:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753214Ab0ADRjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 12:39:16 -0500
Received: from exprod6ob117.obsmtp.com ([64.18.1.38]:49565 "HELO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752218Ab0ADRjQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 12:39:16 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH] amso1100/c2_provider.c: use %pM to shown MAC address
Date: Mon, 4 Jan 2010 12:39:12 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200F824@mi8nycmail19.Mi8.com>
In-Reply-To: <20100103.222406.219629437.davem@davemloft.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] amso1100/c2_provider.c: use %pM to shown MAC address
Thread-Index: AcqNBoMF5mX/x6ZZQbWNmlzB9BgFbQAXe5qw
References: <BD79186B4FD85F4B8E60E381CAEE19090200F533@mi8nycmail19.Mi8.com><20091230.215926.226788191.davem@davemloft.net><BD79186B4FD85F4B8E60E381CAEE19090200F6BA@mi8nycmail19.Mi8.com> <20100103.222406.219629437.davem@davemloft.net>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "David Miller" <davem@davemloft.net>
Cc: <linux-kernel@vger.kernel.org>, <tom@opengridcomputing.com>
X-OriginalArrivalTime: 04 Jan 2010 17:39:14.0374 (UTC) FILETIME=[D5071E60:01CA8D64]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the %pM kernel extension to display the MAC address.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Tom Tucker <tom@opengridcomputing.com>

---

David,

Can you please try the following patch to see if the 'fuzz' issue
is still present.  I think my email client was stripping the last
empty line from the patch.  Thanks.

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
