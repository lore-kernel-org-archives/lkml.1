Return-Path: <linux-kernel-owner+w=401wt.eu-S1946581AbXBISNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946581AbXBISNj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 13:13:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946769AbXBISNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 13:13:39 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:54128 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946581AbXBISNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 13:13:38 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] FRA_{DST,SRC} are le16 for decnet
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org
Message-Id: <E1HFaFd-0004NK-22@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Fri, 09 Feb 2007 18:13:37 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 net/decnet/dn_rules.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/decnet/dn_rules.c b/net/decnet/dn_rules.c
index e32d0c3..b6c98ac 100644
--- a/net/decnet/dn_rules.c
+++ b/net/decnet/dn_rules.c
@@ -151,10 +151,10 @@ static int dn_fib_rule_configure(struct fib_rule *rule, struct sk_buff *skb,
 	}
 
 	if (tb[FRA_SRC])
-		r->src = nla_get_u16(tb[FRA_SRC]);
+		r->src = nla_get_le16(tb[FRA_SRC]);
 
 	if (tb[FRA_DST])
-		r->dst = nla_get_u16(tb[FRA_DST]);
+		r->dst = nla_get_le16(tb[FRA_DST]);
 
 	r->src_len = frh->src_len;
 	r->srcmask = dnet_make_mask(r->src_len);
@@ -176,10 +176,10 @@ static int dn_fib_rule_compare(struct fib_rule *rule, struct fib_rule_hdr *frh,
 	if (frh->dst_len && (r->dst_len != frh->dst_len))
 		return 0;
 
-	if (tb[FRA_SRC] && (r->src != nla_get_u16(tb[FRA_SRC])))
+	if (tb[FRA_SRC] && (r->src != nla_get_le16(tb[FRA_SRC])))
 		return 0;
 
-	if (tb[FRA_DST] && (r->dst != nla_get_u16(tb[FRA_DST])))
+	if (tb[FRA_DST] && (r->dst != nla_get_le16(tb[FRA_DST])))
 		return 0;
 
 	return 1;
@@ -214,9 +214,9 @@ static int dn_fib_rule_fill(struct fib_rule *rule, struct sk_buff *skb,
 	frh->tos = 0;
 
 	if (r->dst_len)
-		NLA_PUT_U16(skb, FRA_DST, r->dst);
+		NLA_PUT_LE16(skb, FRA_DST, r->dst);
 	if (r->src_len)
-		NLA_PUT_U16(skb, FRA_SRC, r->src);
+		NLA_PUT_LE16(skb, FRA_SRC, r->src);
 
 	return 0;
 
-- 
1.5.0-rc2.GIT


