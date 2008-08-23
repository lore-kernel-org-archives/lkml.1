Return-Path: <linux-kernel-owner+w=401wt.eu-S1753831AbYHWG7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbYHWG7j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 02:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751978AbYHWG7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 02:59:32 -0400
Received: from smtp8-g19.free.fr ([212.27.42.65]:44342 "EHLO smtp8-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbYHWG7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 02:59:31 -0400
From: Jim Meyering <meyering@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Sujith.Manoharan@atheros.com, linville@tuxdriver.com
Subject: [PATCH] ath9k: add harmlessly-omitted braces
Date: Sat, 23 Aug 2008 08:49:09 +0200
Date: Sat, 23 Aug 2008 08:49:52 +0200
Message-ID: <87zln4rzce.fsf@rho.meyering.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


---
Alternatively, you could remove the nowadays-useless
"if-before-kfree" test and leave the sometimes-redundant
assignment as-is: unconditional.

 drivers/net/wireless/ath9k/main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 2888778..21bef29 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1056,9 +1056,10 @@ void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 	if (tx_info->flags & IEEE80211_TX_CTL_NO_ACK ||
 		tx_info->flags & IEEE80211_TX_STAT_TX_FILTERED) {
 		/* free driver's private data area of tx_info */
-		if (tx_info->driver_data[0] != NULL)
+		if (tx_info->driver_data[0] != NULL) {
 			kfree(tx_info->driver_data[0]);
 			tx_info->driver_data[0] = NULL;
+		}
 	}

 	if (tx_status->flags & ATH_TX_BAR) {
--
1.6.0.90.g436ed
