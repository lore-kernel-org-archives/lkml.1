Return-Path: <linux-kernel-owner+w=401wt.eu-S1762686AbXHPNVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762686AbXHPNVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 09:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762058AbXHPNUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 09:20:01 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1284 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762046AbXHPNUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 09:20:00 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@xenotime.net>, Andrew Morton <akpm@osdl.org>,
       Andy Whitcroft <apw@shadowen.org>, Andy Whitcroft <apw@shadowen.org>,
       netfilter-devel@lists.netfilter.org
Subject: [PATCH 6/6] netfilter: xt_u32: fix length checks in u32_match_it
References: <exportbomb.1187270320@pinky>
InReply-To: <exportbomb.1187270320@pinky>
Message-ID: <3a5bf48d1567d7136baaac80dfa4c94f@pinky>
Date: Thu, 16 Aug 2007 14:19:12 +0100
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


It seems an extraneous trailing ';' has slipped into the skb length
checks in u32_match_it() triggering an unconditional missmatch.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: netfilter-devel@lists.netfilter.org
---
 net/netfilter/xt_u32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
diff --git a/net/netfilter/xt_u32.c b/net/netfilter/xt_u32.c
index 74f9b14..bec4279 100644
--- a/net/netfilter/xt_u32.c
+++ b/net/netfilter/xt_u32.c
@@ -36,7 +36,7 @@ static bool u32_match_it(const struct xt_u32 *data,
 		at  = 0;
 		pos = ct->location[0].number;
 
-		if (skb->len < 4 || pos > skb->len - 4);
+		if (skb->len < 4 || pos > skb->len - 4)
 			return false;
 
 		ret   = skb_copy_bits(skb, pos, &n, sizeof(n));
