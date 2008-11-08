Return-Path: <linux-kernel-owner+w=401wt.eu-S1753958AbYKHCg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbYKHCg0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 21:36:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbYKHCfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 21:35:54 -0500
Received: from smtp.zeuux.org ([210.51.160.52]:60823 "EHLO z.billxu.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780AbYKHCfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 21:35:52 -0500
Date: Sat, 8 Nov 2008 10:35:58 +0800
From: Jianjun Kong <jianjun@zeuux.org>
To: linville@tuxdriver.com
Cc: Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
Subject: [PATCH] nets: fix a buffer overrun
Message-ID: <20081108023558.GB6384@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


net/mac80211/debugfs_sta.c
The trailing zero was written to state[4], it's out of bounds.

Signed-off-by: Jianjun Kong <jianjun@zeuux.org>
---
 net/mac80211/debugfs_sta.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 189d0ba..b85c4f2 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -199,7 +199,7 @@ static ssize_t sta_agg_status_write(struct file *file,
 		/* toggle Rx aggregation command */
 		tid_num = tid_num - 100;
 		if (tid_static_rx[tid_num] == 1) {
-			strcpy(state, "off ");
+			strcpy(state, "off");
 			ieee80211_sta_stop_rx_ba_session(sta->sdata, da, tid_num, 0,
 					WLAN_REASON_QSTA_REQUIRE_SETUP);
 			sta->ampdu_mlme.tid_state_rx[tid_num] |=
-- 
1.5.6.3
