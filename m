Return-Path: <linux-kernel-owner+w=401wt.eu-S1758805AbZBFQDC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758805AbZBFQDC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 11:03:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752376AbZBFQCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 11:02:53 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:65309 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbZBFQCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 11:02:52 -0500
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH] net_dma: call dmaengine_get only if NET_DMA enabled
Date: Sat,  7 Feb 2009 01:02:49 +0900
Message-Id: <1233936169-5243-1-git-send-email-anemo@mba.ocn.ne.jp>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 649274d993212e7c23c0cb734572c2311c200872 ("net_dma:
acquire/release dma channels on ifup/ifdown") added unconditional call
of dmaengine_get() to net_dma.  The API should be called only if
NET_DMA was enabled.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
 net/core/dev.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 5379b0c..3d510d4 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1087,10 +1087,12 @@ int dev_open(struct net_device *dev)
 		 */
 		dev->flags |= IFF_UP;
 
+#ifdef CONFIG_NET_DMA
 		/*
 		 *	Enable NET_DMA
 		 */
 		dmaengine_get();
+#endif
 
 		/*
 		 *	Initialize multicasting status
@@ -1169,10 +1171,12 @@ int dev_close(struct net_device *dev)
 	 */
 	call_netdevice_notifiers(NETDEV_DOWN, dev);
 
+#ifdef CONFIG_NET_DMA
 	/*
 	 *	Shutdown NET_DMA
 	 */
 	dmaengine_put();
+#endif
 
 	return 0;
 }
-- 
1.5.6.3

