Return-Path: <linux-kernel-owner+w=401wt.eu-S1764317AbZBNBSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764317AbZBNBSl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:18:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbZBNBCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:02:18 -0500
Received: from kroah.org ([198.145.64.141]:40020 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761591AbZBNBCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:02:09 -0500
Date: Fri, 13 Feb 2009 16:59:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jianjun Kong <jianjun@zeuux.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 46/47] mac80211: fix a buffer overrun in station debug code
Message-ID: <20090214005933.GU11282@kroah.com>
References: <20090214005130.617401075@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mac80211-fix-a-buffer-overrun-in-station-debug-code.patch"
In-Reply-To: <20090214005726.GA11282@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jianjun Kong <jianjun@zeuux.org>

commit 013cd397532e5803a1625954a884d021653da720 upstream.

net/mac80211/debugfs_sta.c
The trailing zero was written to state[4], it's out of bounds.

Signed-off-by: Jianjun Kong <jianjun@zeuux.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/debugfs_sta.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -200,7 +200,7 @@ static ssize_t sta_agg_status_write(stru
 		/* toggle Rx aggregation command */
 		tid_num = tid_num - 100;
 		if (tid_static_rx[tid_num] == 1) {
-			strcpy(state, "off ");
+			strcpy(state, "off");
 			ieee80211_sta_stop_rx_ba_session(dev, da, tid_num, 0,
 					WLAN_REASON_QSTA_REQUIRE_SETUP);
 			sta->ampdu_mlme.tid_state_rx[tid_num] |=

