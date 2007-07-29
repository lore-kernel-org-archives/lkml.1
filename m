Return-Path: <linux-kernel-owner+w=401wt.eu-S932455AbXG2PHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932455AbXG2PHs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764731AbXG2O7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 10:59:12 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47837 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763786AbXG2O7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 10:59:09 -0400
Date: Sun, 29 Jul 2007 16:58:46 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>,
       Patrick McHardy <kaber@trash.net>
Cc: netfilter-devel@lists.netfilter.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [2.6 patch] make nf_ct_ipv6_skip_exthdr() static
Message-ID: <20070729145846.GZ16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

nf_ct_ipv6_skip_exthdr() can now become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 include/net/netfilter/ipv6/nf_conntrack_ipv6.h |    3 ---
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    4 ++--
 2 files changed, 2 insertions(+), 5 deletions(-)

--- linux-2.6.23-rc1-mm1/include/net/netfilter/ipv6/nf_conntrack_ipv6.h.old	2007-07-26 20:17:47.000000000 +0200
+++ linux-2.6.23-rc1-mm1/include/net/netfilter/ipv6/nf_conntrack_ipv6.h	2007-07-26 20:17:53.000000000 +0200
@@ -7,9 +7,6 @@
 extern struct nf_conntrack_l4proto nf_conntrack_l4proto_udp6;
 extern struct nf_conntrack_l4proto nf_conntrack_l4proto_icmpv6;
 
-extern int nf_ct_ipv6_skip_exthdr(const struct sk_buff *skb, int start,
-				  u8 *nexthdrp, int len);
-
 extern int nf_ct_frag6_init(void);
 extern void nf_ct_frag6_cleanup(void);
 extern struct sk_buff *nf_ct_frag6_gather(struct sk_buff *skb);
--- linux-2.6.23-rc1-mm1/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c.old	2007-07-26 20:18:03.000000000 +0200
+++ linux-2.6.23-rc1-mm1/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c	2007-07-26 20:18:27.000000000 +0200
@@ -86,8 +86,8 @@
  *        - Note also special handling of AUTH header. Thanks to IPsec wizards.
  */
 
-int nf_ct_ipv6_skip_exthdr(const struct sk_buff *skb, int start, u8 *nexthdrp,
-			   int len)
+static int nf_ct_ipv6_skip_exthdr(const struct sk_buff *skb, int start,
+				  u8 *nexthdrp, int len)
 {
 	u8 nexthdr = *nexthdrp;
 

