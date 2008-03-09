Return-Path: <linux-kernel-owner+w=401wt.eu-S1756020AbYCIX53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbYCIX53 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 19:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755566AbYCIX4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 19:56:48 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:4373 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755004AbYCIX4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 19:56:46 -0400
Subject: [PATCH] include/linux/icmpv6.h - remove duplicate include
From: Joe Perches <joe@perches.com>
To: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
       netdev <netdev@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 09 Mar 2008 16:55:28 -0700
Message-Id: <1205106928.656.102.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicate #include <linux/skbuff.h>
Combine #ifdef __KERNEL__ blocks
Neaten function prototypes

Signed-off-by: Joe Perches <joe@perches.com>

 include/linux/icmpv6.h |   32 +++++++++++---------------------
 1 files changed, 11 insertions(+), 21 deletions(-)

diff --git a/include/linux/icmpv6.h b/include/linux/icmpv6.h
index 7c5e981..5185ffa 100644
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
@@ -166,22 +157,21 @@ struct icmp6_filter {
 #define MLD2_ALL_MCR_INIT { { { 0xff,0x02,0,0,0,0,0,0,0,0,0,0,0,0,0,0x16 } } }
 
 #ifdef __KERNEL__
-
-#include <linux/netdevice.h>
 #include <linux/skbuff.h>
+#include <linux/netdevice.h>
 
+static inline struct icmp6hdr *icmp6_hdr(const struct sk_buff *skb)
+{
+	return (struct icmp6hdr *)skb_transport_header(skb);
+}
 
-extern void				icmpv6_send(struct sk_buff *skb,
-						    int type, int code,
-						    __u32 info, 
-						    struct net_device *dev);
+extern void icmpv6_send(struct sk_buff *skb, int type, int code, __u32 info,
+			struct net_device *dev);
 
-extern int				icmpv6_init(struct net_proto_family *ops);
-extern int				icmpv6_err_convert(int type, int code,
-							   int *err);
-extern void				icmpv6_cleanup(void);
-extern void				icmpv6_param_prob(struct sk_buff *skb,
-							  int code, int pos);
+extern int icmpv6_init(struct net_proto_family *ops);
+extern int icmpv6_err_convert(int type, int code, int *err);
+extern void icmpv6_cleanup(void);
+extern void icmpv6_param_prob(struct sk_buff *skb, int code, int pos);
 #endif
 
 #endif


