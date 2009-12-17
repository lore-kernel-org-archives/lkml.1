Return-Path: <linux-kernel-owner+w=401wt.eu-S935664AbZLQEb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935664AbZLQEb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:31:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935631AbZLQEEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:04:38 -0500
Received: from kroah.org ([198.145.64.141]:55593 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935641AbZLQEEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:31 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:51 2009
Message-Id: <20091217035651.697075324@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [068/151] wireless: correctly report signal value for IEEE80211_HW_SIGNAL_UNSPEC
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: John W. Linville <linville@tuxdriver.com>

commit 19deffbeba930030cfaf000b920333c6ba99ad52 upstream.

This part was missed in "cfg80211: implement get_wireless_stats",
probably because sta_set_sinfo already existed and was only handling
dBm signals.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/cfg.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -338,7 +338,8 @@ static void sta_set_sinfo(struct sta_inf
 	sinfo->rx_packets = sta->rx_packets;
 	sinfo->tx_packets = sta->tx_packets;
 
-	if (sta->local->hw.flags & IEEE80211_HW_SIGNAL_DBM) {
+	if ((sta->local->hw.flags & IEEE80211_HW_SIGNAL_DBM) ||
+	    (sta->local->hw.flags & IEEE80211_HW_SIGNAL_UNSPEC)) {
 		sinfo->filled |= STATION_INFO_SIGNAL;
 		sinfo->signal = (s8)sta->last_signal;
 	}


