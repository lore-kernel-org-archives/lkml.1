Return-Path: <linux-kernel-owner+w=401wt.eu-S934894AbZJNQKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934894AbZJNQKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 12:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934845AbZJNQJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 12:09:57 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:47100 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761962AbZJNQJr (ORCPT
	<rfc822;groupwise-GHaskins@novell.com;0:0>);
	Wed, 14 Oct 2009 12:09:47 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [NET PATCH 4/9] venet: report actual used descriptor size
To: alacrityvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date: Wed, 14 Oct 2009 11:59:07 -0400
Message-ID: <20091014155906.18864.23409.stgit@dev.haskins.net>
In-Reply-To: <20091014154457.18864.28382.stgit@dev.haskins.net>
References: <20091014154457.18864.28382.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should reduce wasted effort copying parts of the descriptor
which are not in use, since the descriptors are typically pre-allocated
to their maximum size.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 drivers/net/vbus-enet.c |    2 ++
 include/linux/venet.h   |    3 +++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/vbus-enet.c b/drivers/net/vbus-enet.c
index b3e9695..63237f3 100644
--- a/drivers/net/vbus-enet.c
+++ b/drivers/net/vbus-enet.c
@@ -582,6 +582,8 @@ vbus_enet_tx_start(struct sk_buff *skb, struct net_device *dev)
 			iov->ptr = (u64)sg_phys(sg);
 		}
 
+		iter.desc->len = (u64)VSG_DESC_SIZE(vsg->count);
+
 	} else {
 		/*
 		 * non scatter-gather mode: simply put the skb right onto the
diff --git a/include/linux/venet.h b/include/linux/venet.h
index 57aeddd..53b6958 100644
--- a/include/linux/venet.h
+++ b/include/linux/venet.h
@@ -76,6 +76,9 @@ struct venet_sg {
 	struct venet_iov iov[1];
 };
 
+#define VSG_DESC_SIZE(count) (sizeof(struct venet_sg) + \
+			      sizeof(struct venet_iov) * ((count) - 1))
+
 #define VENET_FUNC_LINKUP    0
 #define VENET_FUNC_LINKDOWN  1
 #define VENET_FUNC_MACQUERY  2

