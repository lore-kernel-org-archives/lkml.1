Return-Path: <linux-kernel-owner+w=401wt.eu-S1754669AbYKQSll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbYKQSll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 13:41:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753668AbYKQSlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 13:41:16 -0500
Received: from mga02.intel.com ([134.134.136.20]:4513 "EHLO mga02.intel.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752657AbYKQSlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 13:41:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,619,1220252400"; 
   d="scan'208";a="464100134"
From: Yi Zou <yi.zou@intel.com>
Subject: [PATCH 2/3] net: reclaim 8 upper bits of the netdev->features from GSO
To: davem@davemloft.net
Cc: jeff@garzik.org, linux-netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Mon, 17 Nov 2008 10:30:39 -0800
Message-ID: <20081117183039.15776.61222.stgit@zychongqing.jf.intel.com>
In-Reply-To: <20081117182659.15776.58181.stgit@zychongqing.jf.intel.com>
References: <20081117182659.15776.58181.stgit@zychongqing.jf.intel.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Leech <christopher.leech@intel.com>

Signed-off-by: Chris Leech <christopher.leech@intel.com>
Signed-off-by: Yi Zou <yi.zou@intel.com>
---

 drivers/net/xen-netfront.c |    2 +-
 include/linux/netdevice.h  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 4b21bcf..a2bbdaa 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1504,7 +1504,7 @@ static int xennet_set_tso(struct net_device *dev, u32 data)
 static void xennet_set_features(struct net_device *dev)
 {
 	/* Turn off all GSO bits except ROBUST. */
-	dev->features &= (1 << NETIF_F_GSO_SHIFT) - 1;
+	dev->features &= ~NETIF_F_GSO_MASK;
 	dev->features |= NETIF_F_GSO_ROBUST;
 	xennet_set_sg(dev, 0);
 
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 12d7f44..423c7bc 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -525,7 +525,7 @@ struct net_device
 
 	/* Segmentation offload features */
 #define NETIF_F_GSO_SHIFT	16
-#define NETIF_F_GSO_MASK	0xffff0000
+#define NETIF_F_GSO_MASK	0x00ff0000
 #define NETIF_F_TSO		(SKB_GSO_TCPV4 << NETIF_F_GSO_SHIFT)
 #define NETIF_F_UFO		(SKB_GSO_UDP << NETIF_F_GSO_SHIFT)
 #define NETIF_F_GSO_ROBUST	(SKB_GSO_DODGY << NETIF_F_GSO_SHIFT)

