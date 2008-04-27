Return-Path: <linux-kernel-owner+w=401wt.eu-S1756798AbYD0F1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798AbYD0F1l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 01:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbYD0F1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 01:27:31 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39990 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbYD0F1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 01:27:30 -0400
Date: Sun, 27 Apr 2008 06:27:30 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] result of csum_fold() is already 16bit, no need to cast
Message-ID: <20080427052730.GQ5882@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 net/ipv6/ip6mr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index c8c6e33..2de3c46 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -358,7 +358,7 @@ static int pim6_rcv(struct sk_buff *skb)
 	if (pim->type != ((PIM_VERSION << 4) | PIM_REGISTER) ||
 	    (pim->flags & PIM_NULL_REGISTER) ||
 	    (ip_compute_csum((void *)pim, sizeof(*pim)) != 0 &&
-	     (u16)csum_fold(skb_checksum(skb, 0, skb->len, 0))))
+	     csum_fold(skb_checksum(skb, 0, skb->len, 0))))
 		goto drop;
 
 	/* check if the inner packet is destined to mcast group */
-- 
1.5.3.GIT

