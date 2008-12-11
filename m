Return-Path: <linux-kernel-owner+w=401wt.eu-S1757946AbYLKWN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946AbYLKWN7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 17:13:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756919AbYLKWNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 17:13:49 -0500
Received: from mx1.redhat.com ([66.187.233.31]:32828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756789AbYLKWNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 17:13:48 -0500
From: Adam Jackson <ajax@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>, Adam Jackson <ajax@redhat.com>
Subject: [PATCH] net: Remove a noisy printk
Date: Thu, 11 Dec 2008 17:13:42 -0500
Message-Id: <1229033625-30825-1-git-send-email-ajax@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Jones <davej@redhat.com>

These messages are trivial to trigger when running stress tests
like isic, and add no real value.

Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Adam Jackson <ajax@redhat.com>
---
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 4a7c352..0e86d0d 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -147,8 +147,6 @@ static unsigned int ipv4_conntrack_local(unsigned int hooknum,
 	/* root is playing with raw sockets. */
 	if (skb->len < sizeof(struct iphdr) ||
 	    ip_hdrlen(skb) < sizeof(struct iphdr)) {
-		if (net_ratelimit())
-			printk("ipt_hook: happy cracking.\n");
 		return NF_ACCEPT;
 	}
 	return nf_conntrack_in(dev_net(out), PF_INET, hooknum, skb);
-- 
1.6.0.3

