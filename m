Return-Path: <linux-kernel-owner+w=401wt.eu-S1757976AbXKTBVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976AbXKTBVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:21:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756616AbXKTBN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:13:58 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36876 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755310AbXKTBNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:13:38 -0500
Message-Id: <20071120011337.630766318@sgi.com>
References: <20071120011132.143632442@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 19 Nov 2007 17:11:57 -0800
From: clameter@sgi.com
From: Christoph Lameter <clameter@sgi.com>
To: ak@suse.de
Cc: akpm@linux-foundation.org
Cc: travis@sgi.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [rfc 25/45] cpu alloc: veth conversion
Content-Disposition: inline; filename=0033-cpu-alloc-veth-conversion.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 drivers/net/veth.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/net/veth.c
===================================================================
--- linux-2.6.orig/drivers/net/veth.c	2007-11-15 21:17:24.010404318 -0800
+++ linux-2.6/drivers/net/veth.c	2007-11-15 21:25:36.483154219 -0800
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
