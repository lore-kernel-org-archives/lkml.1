Return-Path: <linux-kernel-owner+w=401wt.eu-S1754393Ab0AEAfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab0AEAfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:35:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754354Ab0AEAf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:35:29 -0500
Received: from kroah.org ([198.145.64.141]:34353 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754345Ab0AEAfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:35:25 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 46/97] ath9k: wake hardware for interface IBSS/AP/Mesh removal
Date: Mon,  4 Jan 2010 16:32:59 -0800
Message-Id: <1262651630-7354-46-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit 5f70a88f631c3480107853cae12925185eb4c598 upstream.

When we remove a IBSS/AP/Mesh interface we stop DMA
but to do this we should ensure hardware is on. Awaken
the device prior to these calls. This should ensure
DMA is stopped upon suspend and plain device removal.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/wireless/ath/ath9k/main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 59359e3..909e839 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2277,8 +2277,10 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 	if ((sc->sc_ah->opmode == NL80211_IFTYPE_AP) ||
 	    (sc->sc_ah->opmode == NL80211_IFTYPE_ADHOC) ||
 	    (sc->sc_ah->opmode == NL80211_IFTYPE_MESH_POINT)) {
+		ath9k_ps_wakeup(sc);
 		ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
 		ath_beacon_return(sc, avp);
+		ath9k_ps_restore(sc);
 	}
 
 	sc->sc_flags &= ~SC_OP_BEACONS;
-- 
1.6.6

