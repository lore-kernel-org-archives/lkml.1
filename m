Return-Path: <linux-kernel-owner+w=401wt.eu-S1761928AbZJNP74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761928AbZJNP74 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934796AbZJNP7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:59:55 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:56922 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934701AbZJNP7o (ORCPT
	<rfc822;groupwise-GHaskins@novell.com;0:0>);
	Wed, 14 Oct 2009 11:59:44 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [NET PATCH 2/9] venet: fix gso.hdr_len to report correct length
To: alacrityvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date: Wed, 14 Oct 2009 11:58:56 -0400
Message-ID: <20091014155856.18864.83305.stgit@dev.haskins.net>
In-Reply-To: <20091014154457.18864.28382.stgit@dev.haskins.net>
References: <20091014154457.18864.28382.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This seemed to have worked for TSO4/6 frames, but breaks for UFO.  In
either case, its just plain wrong, so lets get the header set properly.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 drivers/net/vbus-enet.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/vbus-enet.c b/drivers/net/vbus-enet.c
index 91c47a9..3d61444 100644
--- a/drivers/net/vbus-enet.c
+++ b/drivers/net/vbus-enet.c
@@ -512,7 +512,7 @@ vbus_enet_tx_start(struct sk_buff *skb, struct net_device *dev)
 
 			vsg->flags |= VENET_SG_FLAG_GSO;
 
-			vsg->gso.hdrlen = skb_transport_header(skb) - skb->data;
+			vsg->gso.hdrlen = skb_headlen(skb);
 			vsg->gso.size = sinfo->gso_size;
 			if (sinfo->gso_type & SKB_GSO_TCPV4)
 				vsg->gso.type = VENET_GSO_TYPE_TCPV4;

