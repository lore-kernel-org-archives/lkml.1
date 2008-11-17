Return-Path: <linux-kernel-owner+w=401wt.eu-S1754796AbYKQSl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbYKQSl7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 13:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754498AbYKQSle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 13:41:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:36137 "EHLO mga02.intel.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754469AbYKQSld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 13:41:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,619,1220252400"; 
   d="scan'208";a="464100177"
From: Yi Zou <yi.zou@intel.com>
Subject: [PATCH 3/3] net: define feature flags for FCoE offloads
To: davem@davemloft.net
Cc: jeff@garzik.org, linux-netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Mon, 17 Nov 2008 10:30:51 -0800
Message-ID: <20081117183049.15776.84674.stgit@zychongqing.jf.intel.com>
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

 include/linux/netdevice.h |    3 +++
 include/linux/skbuff.h    |    2 ++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 423c7bc..9347464 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -523,6 +523,8 @@ struct net_device
 #define NETIF_F_NETNS_LOCAL	8192	/* Does not change network namespaces */
 #define NETIF_F_LRO		32768	/* large receive offload */
 
+#define NETIF_F_FCOE_CRC	(1 << 24) /* FCoE CRC32 */
+
 	/* Segmentation offload features */
 #define NETIF_F_GSO_SHIFT	16
 #define NETIF_F_GSO_MASK	0x00ff0000
@@ -531,6 +533,7 @@ struct net_device
 #define NETIF_F_GSO_ROBUST	(SKB_GSO_DODGY << NETIF_F_GSO_SHIFT)
 #define NETIF_F_TSO_ECN		(SKB_GSO_TCP_ECN << NETIF_F_GSO_SHIFT)
 #define NETIF_F_TSO6		(SKB_GSO_TCPV6 << NETIF_F_GSO_SHIFT)
+#define NETIF_F_GSO_FCOE	(SKB_GSO_FCOE << NETIF_F_GSO_SHIFT)
 
 	/* List of features with software fallbacks. */
 #define NETIF_F_GSO_SOFTWARE	(NETIF_F_TSO | NETIF_F_TSO_ECN | NETIF_F_TSO6)
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index a01b6f8..81c3f7c 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -188,6 +188,8 @@ enum {
 	SKB_GSO_TCP_ECN = 1 << 3,
 
 	SKB_GSO_TCPV6 = 1 << 4,
+
+	SKB_GSO_FCOE = 1 << 5,
 };
 
 #if BITS_PER_LONG > 32

