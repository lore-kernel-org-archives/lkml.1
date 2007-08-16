Return-Path: <linux-kernel-owner+w=401wt.eu-S1762916AbXHPNWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762916AbXHPNWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 09:22:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759546AbXHPNUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 09:20:05 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1288 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762035AbXHPNUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 09:20:03 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@xenotime.net>, Andrew Morton <akpm@osdl.org>,
       Andy Whitcroft <apw@shadowen.org>, Andy Whitcroft <apw@shadowen.org>,
       Samuel Ortiz <samuel@sortiz.org>, irda-users@lists.sourceforge.net
Subject: [PATCH 5/6] irda_nl_get_mode: always results in failure
References: <exportbomb.1187270320@pinky>
InReply-To: <exportbomb.1187270320@pinky>
Message-ID: <133bf74f7af4e972bbd7d32894d9d126@pinky>
Date: Thu, 16 Aug 2007 14:19:06 +0100
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


It seems an extraneous trailing ';' has slipped in to the error
handling for a name registration failure causing the error path to
trigger unconditionally.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: Samuel Ortiz <samuel@sortiz.org>
Cc: irda-users@lists.sourceforge.net
---
 net/irda/irnetlink.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
diff --git a/net/irda/irnetlink.c b/net/irda/irnetlink.c
index 694ea4d..1e429c9 100644
--- a/net/irda/irnetlink.c
+++ b/net/irda/irnetlink.c
@@ -106,7 +106,7 @@ static int irda_nl_get_mode(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	if(nla_put_string(msg, IRDA_NL_ATTR_IFNAME,
-			  dev->name));
+			  dev->name))
 		goto err_out;
 
 	if(nla_put_u32(msg, IRDA_NL_ATTR_MODE, irlap->mode))
