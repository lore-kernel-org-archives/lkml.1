Return-Path: <linux-kernel-owner+w=401wt.eu-S934258AbZAOUxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934258AbZAOUxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:53:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932229AbZAOUDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:03:10 -0500
Received: from kroah.org ([198.145.64.141]:49831 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765852AbZAOUDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:03:03 -0500
Date: Thu, 15 Jan 2009 12:00:35 -0800
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
       alan@lxorguk.ukuu.org.uk, "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 87/94] ath9k: enable RXing of beacons on STA/IBSS
Message-ID: <20090115200035.GI14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ath9k-enable-rxing-of-beacons-on-sta-ibss.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit ffb826767bffda61426d964a8fc24a216a14b0bd upstream.

This enables beacons to come through on STA/IBSS.
It should fix sporadic connection issues. Right now
mac80211 expect beacons so give it beacons.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath9k/recv.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -627,9 +627,8 @@ u32 ath_calcrxfilter(struct ath_softc *s
 		rfilt &= ~ATH9K_RX_FILTER_UCAST;
 	}
 
-	if (((sc->sc_ah->ah_opmode == ATH9K_M_STA) &&
-	     (sc->rx_filter & FIF_BCN_PRBRESP_PROMISC)) ||
-	    (sc->sc_ah->ah_opmode == ATH9K_M_IBSS))
+	if (sc->sc_ah->ah_opmode == ATH9K_M_STA ||
+			sc->sc_ah->ah_opmode == ATH9K_M_IBSS)
 		rfilt |= ATH9K_RX_FILTER_BEACON;
 
 	/* If in HOSTAP mode, want to enable reception of PSPOLL frames

