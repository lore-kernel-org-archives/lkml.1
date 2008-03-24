Return-Path: <linux-kernel-owner+w=401wt.eu-S1756931AbYCXRrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931AbYCXRrh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 13:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757205AbYCXRrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 13:47:22 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:4213 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754647AbYCXRrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 13:47:22 -0400
Subject: [PATCH 1/2] include/linux/icmpv6.h - Remove duplicate include,
	combine #ifdef __KERNEL__ sections
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080323.221815.84933913.davem@davemloft.net>
References: <1205106928.656.102.camel@localhost>
	 <20080323.221815.84933913.davem@davemloft.net>
Content-Type: text/plain
Date: Mon, 24 Mar 2008 10:46:34 -0700
Message-Id: <1206380795.4845.31.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-03-23 at 22:18 -0700, David Miller wrote:
> Does not apply to net-2.6.26, dropped.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/icmpv6.h |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/include/linux/icmpv6.h b/include/linux/icmpv6.h
index 0306744..c1a30c7 100644
--- a/include/linux/icmpv6.h
+++ b/include/linux/icmpv6.h
@@ -75,15 +75,6 @@ struct icmp6hdr {
 #define icmp6_router_pref	icmp6_dataun.u_nd_ra.router_pref
 };
 
-#ifdef __KERNEL__
-#include <linux/skbuff.h>
-
-static inline struct icmp6hdr *icmp6_hdr(const struct sk_buff *skb)
-{
-	return (struct icmp6hdr *)skb_transport_header(skb);
-}
-#endif
-
 #define ICMPV6_ROUTER_PREF_LOW		0x3
 #define ICMPV6_ROUTER_PREF_MEDIUM	0x0
 #define ICMPV6_ROUTER_PREF_HIGH		0x1
@@ -170,6 +161,10 @@ struct icmp6_filter {
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
 
+static inline struct icmp6hdr *icmp6_hdr(const struct sk_buff *skb)
+{
+	return (struct icmp6hdr *)skb_transport_header(skb);
+}
 
 extern void				icmpv6_send(struct sk_buff *skb,
 						    int type, int code,
-- 
1.5.4.rc2



