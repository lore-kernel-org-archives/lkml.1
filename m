Return-Path: <linux-kernel-owner+w=401wt.eu-S1756615AbYGNKpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615AbYGNKpt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 06:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757171AbYGNKpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 06:45:36 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:34319 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756986AbYGNKpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 06:45:35 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH] mac80211: tx, use dev_kfree_skb_any for beacon_get
Date: Mon, 14 Jul 2008 12:43:23 +0200
Message-Id: <1216032203-26375-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev_kfree_skb_any(); instead of dev_kfree_skb();, since
ieee80211_beacon_get function might be called from atomic.
(It's in a fail path.)

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Wu <flamingice@sourmilk.net>
---
 net/mac80211/tx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 9bd9faa..81a4176 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1903,7 +1903,7 @@ struct sk_buff *ieee80211_beacon_get(struct ieee80211_hw *hw,
 			       "no rate found\n",
 			       wiphy_name(local->hw.wiphy));
 		}
-		dev_kfree_skb(skb);
+		dev_kfree_skb_any(skb);
 		skb = NULL;
 		goto out;
 	}
-- 
1.5.6.2

