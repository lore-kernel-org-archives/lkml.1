Return-Path: <linux-kernel-owner+w=401wt.eu-S933575AbXHVUwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933575AbXHVUwo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 16:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932507AbXHVUv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 16:51:59 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:60933 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763839AbXHVUv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 16:51:57 -0400
Message-id: <2698018635706419125@wsc.cz>
Subject: [PATCH 1/2] Net: ath5k, no printk after STA->IBSS switch
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <netdev@vger.kernel.org>
Cc: <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Cc: <jeff@garzik.org>
Date: Wed, 22 Aug 2007 22:53:25 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ath5k, no printk after STA->IBSS switch

If STA->IBSS switch was done, but beacon_update weas not called so far, do
not emit a warning about non-existent skbuf.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit b01c0e9a02b248c3e2f2923da9728ba2c3961dee
tree c3e10a57aed39698f20c346679854aa3a9a54639
parent 8c5f91fb39c6208b23306687343cc5fbf830fa17
author Jiri Slaby <jirislaby@gmail.com> Wed, 22 Aug 2007 22:47:06 +0200
committer Jiri Slaby <jirislaby@gmail.com> Wed, 22 Aug 2007 22:47:06 +0200

 drivers/net/wireless/ath5k_base.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath5k_base.c b/drivers/net/wireless/ath5k_base.c
index 847218b..2ce82ed 100644
--- a/drivers/net/wireless/ath5k_base.c
+++ b/drivers/net/wireless/ath5k_base.c
@@ -655,7 +655,9 @@ static void ath_beacon_config(struct ath_softc *sc)
 	DPRINTF(sc, ATH_DEBUG_BEACON, "%s: intval %u hw tsftu %u\n", __func__,
 			intval, tsftu);
 
-	if (sc->opmode == IEEE80211_IF_TYPE_STA) {
+	if (sc->opmode == IEEE80211_IF_TYPE_STA ||
+			(sc->opmode == IEEE80211_IF_TYPE_IBSS &&
+				!sc->bbuf->skb)) {
 		ath5k_hw_set_intr(ah, 0);
 		sc->imask |= AR5K_INT_BMISS;
 		sc->bmisscount = 0;
