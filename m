Return-Path: <linux-kernel-owner+w=401wt.eu-S1761589AbZC0Dnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761589AbZC0Dnp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 23:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756650AbZC0Dng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 23:43:36 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:10292 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbZC0Dnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 23:43:35 -0400
From: Steven Noonan <steven@uplinklabs.net>
To: linux-kernel@vger.kernel.org
Cc: Steven Noonan <steven@uplinklabs.net>,
       Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] iptables: "cluster" match uses IPv6-specific code without ifdef
Date: Thu, 26 Mar 2009 13:43:23 -0700
Message-Id: <1238100203-23454-1-git-send-email-steven@uplinklabs.net>
X-Mailer: git-send-email 1.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol __ipv6_addr_type is only available with CONFIG_IPV6 or
CONFIG_IPV6_MODULE.

Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Steven Noonan <steven@uplinklabs.net>
---
 net/netfilter/xt_cluster.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/xt_cluster.c b/net/netfilter/xt_cluster.c
index ad5bd89..38091f3 100644
--- a/net/netfilter/xt_cluster.c
+++ b/net/netfilter/xt_cluster.c
@@ -66,10 +66,12 @@ xt_cluster_is_multicast_addr(const struct sk_buff *skb, u_int8_t family)
 	case NFPROTO_IPV4:
 		is_multicast = ipv4_is_multicast(ip_hdr(skb)->daddr);
 		break;
+#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
 	case NFPROTO_IPV6:
 		is_multicast = ipv6_addr_type(&ipv6_hdr(skb)->daddr) &
 						IPV6_ADDR_MULTICAST;
 		break;
+#endif
 	default:
 		WARN_ON(1);
 		break;
-- 
1.6.2

