Return-Path: <linux-kernel-owner+w=401wt.eu-S1757744AbXKFUAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757744AbXKFUAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 15:00:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756867AbXKFTwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 14:52:35 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:52147 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756053AbXKFTwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 14:52:03 -0500
Message-Id: <20071106195202.681229592@sgi.com>
References: <20071106195144.983665861@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 06 Nov 2007 11:52:06 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-mm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 22/28] cpu alloc: veth conversion
Content-Disposition: inline; filename=cpu_alloc_veth
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 drivers/net/veth.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/net/veth.c
===================================================================
--- linux-2.6.orig/drivers/net/veth.c	2007-11-04 19:17:22.000000000 -0800
+++ linux-2.6/drivers/net/veth.c	2007-11-04 19:19:11.000000000 -0800
@@ -162,7 +162,7 @@ static int veth_xmit(struct sk_buff *skb
 	rcv_priv = netdev_priv(rcv);
 
 	cpu = smp_processor_id();
-	stats = per_cpu_ptr(priv->stats, cpu);
+	stats = CPU_PTR(priv->stats, cpu);
 
 	if (!(rcv->flags & IFF_UP))
 		goto outf;
@@ -183,7 +183,7 @@ static int veth_xmit(struct sk_buff *skb
 	stats->tx_bytes += length;
 	stats->tx_packets++;
 
-	stats = per_cpu_ptr(rcv_priv->stats, cpu);
+	stats = CPU_PTR(rcv_priv->stats, cpu);
 	stats->rx_bytes += length;
 	stats->rx_packets++;
 
@@ -217,7 +217,7 @@ static struct net_device_stats *veth_get
 	dev_stats->tx_dropped = 0;
 
 	for_each_online_cpu(cpu) {
-		stats = per_cpu_ptr(priv->stats, cpu);
+		stats = CPU_PTR(priv->stats, cpu);
 
 		dev_stats->rx_packets += stats->rx_packets;
 		dev_stats->tx_packets += stats->tx_packets;
@@ -261,7 +261,7 @@ static int veth_dev_init(struct net_devi
 	struct veth_net_stats *stats;
 	struct veth_priv *priv;
 
-	stats = alloc_percpu(struct veth_net_stats);
+	stats = CPU_ALLOC(struct veth_net_stats, GFP_KERNEL | __GFP_ZER);
 	if (stats == NULL)
 		return -ENOMEM;
 
@@ -275,7 +275,7 @@ static void veth_dev_free(struct net_dev
 	struct veth_priv *priv;
 
 	priv = netdev_priv(dev);
-	free_percpu(priv->stats);
+	CPU_FREE(priv->stats);
 	free_netdev(dev);
 }
 

-- 
