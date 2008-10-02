Return-Path: <linux-kernel-owner+w=401wt.eu-S1754847AbYJBN2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbYJBN2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 09:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755031AbYJBNVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 09:21:03 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53628 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992AbYJBNSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 09:18:47 -0400
Message-Id: <20081002131607.801664200@chello.nl>
References: <20081002130504.927878499@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 02 Oct 2008 15:05:08 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Neil Brown <neilb@suse.de>,
       David Miller <davem@davemloft.net>
Subject: [PATCH 04/32] net: ipv6: initialize ip6_route sysctl vars in ip6_route_net_init()
Content-Disposition: inline; filename=net-ipv6-route-cleanup-sysctl.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes that ip6_route_net_init() does all of the route init code.
There used to be a race between ip6_route_net_init() and ip6_net_init()
and someone relying on the combined result was left out cold.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 net/ipv6/af_inet6.c |    8 --------
 net/ipv6/route.c    |    9 +++++++++
 2 files changed, 9 insertions(+), 8 deletions(-)

Index: linux-2.6/net/ipv6/af_inet6.c
===================================================================
--- linux-2.6.orig/net/ipv6/af_inet6.c
+++ linux-2.6/net/ipv6/af_inet6.c
@@ -839,14 +839,6 @@ static int inet6_net_init(struct net *ne
 	int err = 0;
 
 	net->ipv6.sysctl.bindv6only = 0;
-	net->ipv6.sysctl.flush_delay = 0;
-	net->ipv6.sysctl.ip6_rt_max_size = 4096;
-	net->ipv6.sysctl.ip6_rt_gc_min_interval = HZ / 2;
-	net->ipv6.sysctl.ip6_rt_gc_timeout = 60*HZ;
-	net->ipv6.sysctl.ip6_rt_gc_interval = 30*HZ;
-	net->ipv6.sysctl.ip6_rt_gc_elasticity = 9;
-	net->ipv6.sysctl.ip6_rt_mtu_expires = 10*60*HZ;
-	net->ipv6.sysctl.ip6_rt_min_advmss = IPV6_MIN_MTU - 20 - 40;
 	net->ipv6.sysctl.icmpv6_time = 1*HZ;
 
 #ifdef CONFIG_PROC_FS
Index: linux-2.6/net/ipv6/route.c
===================================================================
--- linux-2.6.orig/net/ipv6/route.c
+++ linux-2.6/net/ipv6/route.c
@@ -2627,6 +2627,15 @@ static int ip6_route_net_init(struct net
 	net->ipv6.ip6_blk_hole_entry->u.dst.ops = net->ipv6.ip6_dst_ops;
 #endif
 
+	net->ipv6.sysctl.flush_delay = 0;
+	net->ipv6.sysctl.ip6_rt_max_size = 4096;
+	net->ipv6.sysctl.ip6_rt_gc_min_interval = HZ / 2;
+	net->ipv6.sysctl.ip6_rt_gc_timeout = 60*HZ;
+	net->ipv6.sysctl.ip6_rt_gc_interval = 30*HZ;
+	net->ipv6.sysctl.ip6_rt_gc_elasticity = 9;
+	net->ipv6.sysctl.ip6_rt_mtu_expires = 10*60*HZ;
+	net->ipv6.sysctl.ip6_rt_min_advmss = IPV6_MIN_MTU - 20 - 40;
+
 #ifdef CONFIG_PROC_FS
 	proc_net_fops_create(net, "ipv6_route", 0, &ipv6_route_proc_fops);
 	proc_net_fops_create(net, "rt6_stats", S_IRUGO, &rt6_stats_seq_fops);

-- 

