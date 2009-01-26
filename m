Return-Path: <linux-kernel-owner+w=401wt.eu-S1752847AbZAZQaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbZAZQaN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 11:30:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbZAZQaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 11:30:00 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58647 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbZAZQ37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 11:29:59 -0500
Date: Mon, 26 Jan 2009 17:29:54 +0100
From: Jiri Pirko <jpirko@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, herbert@gondor.apana.org.au, nhorman@redhat.com
Subject: [PATCH] net: fix xfrm reverse flow lookup for icmp6
Message-ID: <20090126162953.GA17952@psychotron.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the xfrm reverse flow lookup for icmp6 so that icmp6 packets
don't get lost over ipsec tunnels. Similar patch is in RHEL5 kernel for a quite
long time and I do not see why it isn't in mainline.

Please correct me if I'm missing something.

Jirka


Signed-off-by: Jiri Pirko <jpirko@redhat.com>
---
 net/ipv6/icmp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index 4f43384..36dff88 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -443,10 +443,10 @@ void icmpv6_send(struct sk_buff *skb, int type, int code, __u32 info,
 	if (xfrm_decode_session_reverse(skb, &fl2, AF_INET6))
 		goto relookup_failed;
 
-	if (ip6_dst_lookup(sk, &dst2, &fl))
+	if (ip6_dst_lookup(sk, &dst2, &fl2))
 		goto relookup_failed;
 
-	err = xfrm_lookup(net, &dst2, &fl, sk, XFRM_LOOKUP_ICMP);
+	err = xfrm_lookup(net, &dst2, &fl2, sk, XFRM_LOOKUP_ICMP);
 	switch (err) {
 	case 0:
 		dst_release(dst);
-- 
1.6.0.6


