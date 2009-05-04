Return-Path: <linux-kernel-owner+w=401wt.eu-S1757910AbZEDQFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910AbZEDQFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 12:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757254AbZEDQFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 12:05:14 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:58673 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756855AbZEDQFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 12:05:13 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH 1/2] mac80211: minstrel, fix memory corruption
Date: Mon,  4 May 2009 18:04:55 +0200
Message-Id: <1241453096-8517-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

minstrel doesn't count max rate count in fact, since it doesn't use
a loop variable `i' and hence allocs space only for bitrates found in
the first band.

Fix it by involving the `i' as an index so that it traverses all the
bands now and finds the real max bitrate count.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/rc80211_minstrel.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index 3824990..70df3dc 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -476,7 +476,7 @@ minstrel_alloc_sta(void *priv, struct ieee80211_sta *sta, gfp_t gfp)
 		return NULL;
 
 	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
-		sband = hw->wiphy->bands[hw->conf.channel->band];
+		sband = hw->wiphy->bands[i];
 		if (sband->n_bitrates > max_rates)
 			max_rates = sband->n_bitrates;
 	}
-- 
1.6.2.4

