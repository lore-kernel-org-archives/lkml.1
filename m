Return-Path: <linux-kernel-owner+w=401wt.eu-S1754986Ab0AEAqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab0AEAqd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:46:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754362Ab0AEAfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:35:31 -0500
Received: from kroah.org ([198.145.64.141]:34362 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754355Ab0AEAf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:35:28 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Sujith <Sujith.Manoharan@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 47/97] ath9k: Fix TX queue draining
Date: Mon,  4 Jan 2010 16:33:00 -0800
Message-Id: <1262651630-7354-47-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sujith <Sujith.Manoharan@atheros.com>

commit e8009e9850d59000d518296af372888911a129bd upstream.

When TX DMA termination has failed, the HW has to be reset
completely. Doing a fast channel change in this case is insufficient.
Also, change the debug level of a couple of messages to FATAL.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/wireless/ath/ath9k/mac.c  |    2 +-
 drivers/net/wireless/ath/ath9k/xmit.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index d4d9d82..110c16d 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -155,7 +155,7 @@ bool ath9k_hw_stoptxdma(struct ath_hw *ah, u32 q)
 		wait = wait_time;
 		while (ath9k_hw_numtxpending(ah, q)) {
 			if ((--wait) == 0) {
-				DPRINTF(ah->ah_sc, ATH_DBG_QUEUE,
+				DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
 					"Failed to stop TX DMA in 100 "
 					"msec after killing last frame\n");
 				break;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 4753909..2e0b86b 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1076,10 +1076,10 @@ void ath_drain_all_txq(struct ath_softc *sc, bool retry_tx)
 	if (npend) {
 		int r;
 
-		DPRINTF(sc, ATH_DBG_XMIT, "Unable to stop TxDMA. Reset HAL!\n");
+		DPRINTF(sc, ATH_DBG_FATAL, "Unable to stop TxDMA. Reset HAL!\n");
 
 		spin_lock_bh(&sc->sc_resetlock);
-		r = ath9k_hw_reset(ah, sc->sc_ah->curchan, true);
+		r = ath9k_hw_reset(ah, sc->sc_ah->curchan, false);
 		if (r)
 			DPRINTF(sc, ATH_DBG_FATAL,
 				"Unable to reset hardware; reset status %d\n",
-- 
1.6.6

