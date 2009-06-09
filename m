Return-Path: <linux-kernel-owner+w=401wt.eu-S1760301AbZFIK2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760301AbZFIK2n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760706AbZFIKUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:20:14 -0400
Received: from kroah.org ([198.145.64.141]:55066 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760775AbZFIKUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:20:12 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:41:03 2009
Message-Id: <20090609094103.545752040@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:37 -0700
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
       alan@lxorguk.ukuu.org.uk, Jiri Slaby <jirislaby@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 49/87] mac80211: minstrel, fix memory corruption
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=mac80211-minstrel-fix-memory-corruption.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Slaby <jirislaby@gmail.com>

commit 8e532175277d9a5eae49768ed086555081f741a7 upstream.

minstrel doesn't count max rate count in fact, since it doesn't use
a loop variable `i' and hence allocs space only for bitrates found in
the first band.

Fix it by involving the `i' as an index so that it traverses all the
bands now and finds the real max bitrate count.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/rc80211_minstrel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -476,7 +476,7 @@ minstrel_alloc_sta(void *priv, struct ie
 		return NULL;
 
 	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
-		sband = hw->wiphy->bands[hw->conf.channel->band];
+		sband = hw->wiphy->bands[i];
 		if (sband->n_bitrates > max_rates)
 			max_rates = sband->n_bitrates;
 	}


