Return-Path: <linux-kernel-owner+w=401wt.eu-S1758174AbYDWJ45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174AbYDWJ45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 05:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755888AbYDWJwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 05:52:09 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:36898 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152AbYDWJwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 05:52:07 -0400
Date: Wed, 23 Apr 2008 12:51:28 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [2.6 patch] net/mac80211/rx.c: fix off-by-one
Message-ID: <20080423095128.GY28933@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes an off-by-one in net/mac80211/rx.c introduced by
commit 8318d78a44d49ac1edf2bdec7299de3617c4232e
(cfg80211 API for channels/bitrates, mac80211 and driver conversion)
and spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
--- linux-2.6/net/mac80211/rx.c.old	2008-04-22 02:23:40.000000000 +0300
+++ linux-2.6/net/mac80211/rx.c	2008-04-22 02:24:23.000000000 +0300
@@ -2168,11 +2168,11 @@ void __ieee80211_rx(struct ieee80211_hw 
 	u32 pkt_load;
 	struct ieee80211_rate *rate = NULL;
 	struct ieee80211_supported_band *sband;
 
 	if (status->band < 0 ||
-	    status->band > IEEE80211_NUM_BANDS) {
+	    status->band >= IEEE80211_NUM_BANDS) {
 		WARN_ON(1);
 		return;
 	}
 
 	sband = local->hw.wiphy->bands[status->band];

