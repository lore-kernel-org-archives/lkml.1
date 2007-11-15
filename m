Return-Path: <linux-kernel-owner+w=401wt.eu-S1765187AbXKOGYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765187AbXKOGYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:24:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764835AbXKOGVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:21:44 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45861 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764811AbXKOGVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:21:42 -0500
Date: Wed, 14 Nov 2007 22:20:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "John W. Linville" <linville@tuxdriver.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Michael Wu <flamingice@sourmilk.net>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 01/23] mac80211: filter locally-originated multicast frames
Message-ID: <20071115062004.GB8282@kroah.com>
References: <20071115055238.692814352@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mac80211-filter-locally-originated-multicast-frames.patch"
In-Reply-To: <20071115061806.GA8282@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------


From: John W. Linville <linville@tuxdriver.com>

patch b331615722779b078822988843ddffd4eaec9f83 in mainline.

In STA mode, the AP will echo our traffic.  This includes multicast
traffic.

Receiving these frames confuses some protocols and applications,
notably IPv6 Duplicate Address Detection.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Acked-by: Michael Wu <flamingice@sourmilk.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/ieee80211.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -2836,9 +2836,10 @@ ieee80211_rx_h_data(struct ieee80211_txr
 		memcpy(dst, hdr->addr1, ETH_ALEN);
 		memcpy(src, hdr->addr3, ETH_ALEN);
 
-		if (sdata->type != IEEE80211_IF_TYPE_STA) {
+		if (sdata->type != IEEE80211_IF_TYPE_STA ||
+		    (is_multicast_ether_addr(dst) &&
+		     !compare_ether_addr(src, dev->dev_addr)))
 			return TXRX_DROP;
-		}
 		break;
 	case 0:
 		/* DA SA BSSID */

-- 
