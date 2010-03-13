Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936538Ab0CMBf1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:35:27 -0500
Received: from kroah.org ([198.145.64.141]:60545 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934811Ab0CMATh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:19:37 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:06 2010
Message-Id: <20100313001505.974972719@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:11:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Zhu Yi <yi.zhu@intel.com>, Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 009/123] mac80211: quit addba_resp_timer if Tx BA session is torn down
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Zhu Yi <yi.zhu@intel.com>

commit 3dc1de0bf23816ed557ac8addf680cd5ee57e805 upstream.

Make addba_resp_timer aware the HT_AGG_STATE_REQ_STOP_BA_MSK mask
so that when ___ieee80211_stop_tx_ba_session() is issued the timer
will quit. Otherwise when suspend happens before the timer expired,
the timer handler will be called immediately after resume and
messes up driver status.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/agg-tx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -179,7 +179,8 @@ static void sta_addba_resp_timer_expired
 
 	/* check if the TID waits for addBA response */
 	spin_lock_bh(&sta->lock);
-	if ((*state & (HT_ADDBA_REQUESTED_MSK | HT_ADDBA_RECEIVED_MSK)) !=
+	if ((*state & (HT_ADDBA_REQUESTED_MSK | HT_ADDBA_RECEIVED_MSK |
+		       HT_AGG_STATE_REQ_STOP_BA_MSK)) !=
 						HT_ADDBA_REQUESTED_MSK) {
 		spin_unlock_bh(&sta->lock);
 		*state = HT_AGG_STATE_IDLE;


