Return-Path: <linux-kernel-owner+w=401wt.eu-S1764017AbYFNA2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764017AbYFNA2h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762319AbYFNAPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:15:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:34701 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762312AbYFNAPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:15:42 -0400
Date: Fri, 13 Jun 2008 17:12:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Dan Williams <dcbw@redhat.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 47/47] mac80211: send association event on IBSS create
Message-ID: <20080614001223.GU24698@suse.de>
References: <20080613234753.235721454@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mac80211-send-association-event-on-ibss-create.patch"
In-Reply-To: <20080614000840.GA24659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Dan Williams <dcbw@redhat.com>

patch 507b06d0622480f8026d49a94f86068bb0fd6ed6 upstream

Otherwise userspace has no idea the IBSS creation succeeded.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/ieee80211_sta.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -2723,6 +2723,7 @@ static int ieee80211_sta_join_ibss(struc
 	struct rate_selection ratesel;
 	u8 *pos;
 	struct ieee80211_sub_if_data *sdata;
+	union iwreq_data wrqu;
 
 	/* Remove possible STA entries from other IBSS networks. */
 	sta_info_flush(local, NULL);
@@ -2863,6 +2864,10 @@ static int ieee80211_sta_join_ibss(struc
 
 	ieee80211_rx_bss_put(dev, bss);
 
+	memset(&wrqu, 0, sizeof(wrqu));
+	memcpy(wrqu.ap_addr.sa_data, bss->bssid, ETH_ALEN);
+	wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
+
 	return res;
 }
 

-- 
