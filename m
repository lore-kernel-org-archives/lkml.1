Return-Path: <linux-kernel-owner+w=401wt.eu-S1763897AbZBNB2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763897AbZBNB2p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:28:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761959AbZBNBQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:16:03 -0500
Received: from kroah.org ([198.145.64.141]:50156 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764096AbZBNBQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:16:01 -0500
Date: Fri, 13 Feb 2009 17:12:25 -0800
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
       alan@lxorguk.ukuu.org.uk, Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 03/48] mac80211: restrict to AP in outgoing interface
	heuristic
Message-ID: <20090214011225.GD17706@kroah.com>
References: <20090214010805.419403436@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mac80211-restrict-to-ap-in-outgoing-interface-heuristic.patch"
In-Reply-To: <20090214011208.GA17706@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johannes Berg <johannes@sipsolutions.net>

commit f1b33cb1c25ac476cbf22783f9ca2016f99648ed upstream.

We try to find the correct outgoing interface for injected frames
based on the TA, but since this is a hack for hostapd 11w, restrict
the heuristic to AP mode interfaces. At some point we'll add the
ability to give an interface index in radiotap or so and just
remove this heuristic again.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/tx.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1335,6 +1335,8 @@ int ieee80211_master_start_xmit(struct s
 						list) {
 				if (!netif_running(sdata->dev))
 					continue;
+				if (sdata->vif.type != NL80211_IFTYPE_AP)
+					continue;
 				if (compare_ether_addr(sdata->dev->dev_addr,
 						       hdr->addr2)) {
 					dev_hold(sdata->dev);

