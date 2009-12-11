Return-Path: <linux-kernel-owner+w=401wt.eu-S1762419AbZLKLkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762419AbZLKLkz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 06:40:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761013AbZLKLkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 06:40:49 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:34458 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757380AbZLKLks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 06:40:48 -0500
Date: Fri, 11 Dec 2009 12:40:54 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>, linux-net@vger.kernel.org
Cc: wey-yi.w.guy@intel.com
Subject: [PATCH] Fix iwl typo
Message-ID: <20091211114054.GZ8742@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I came across this one:

drivers/net/wireless/iwlwifi/iwl-tx.c: In function ?iwl_tx_agg_stop?:
drivers/net/wireless/iwlwifi/iwl-tx.c:1356: warning: passing argument 1
of ?ieee80211_stop_tx_ba_cb_irqsafe? from incompatible pointer type
include/net/mac80211.h:2128: note: expected ?struct ieee80211_vif *? but
argument is of type ?struct ieee80211_hw *?

which just looks like a simple typo, priv->hw should be priv->vif.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 58b132f..00da5e1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -1353,7 +1353,7 @@ int iwl_tx_agg_stop(struct iwl_priv *priv , const u8 *ra, u16 tid)
 	if (priv->stations[sta_id].tid[tid].agg.state ==
 				IWL_EMPTYING_HW_QUEUE_ADDBA) {
 		IWL_DEBUG_HT(priv, "AGG stop before setup done\n");
-		ieee80211_stop_tx_ba_cb_irqsafe(priv->hw, ra, tid);
+		ieee80211_stop_tx_ba_cb_irqsafe(priv->vif, ra, tid);
 		priv->stations[sta_id].tid[tid].agg.state = IWL_AGG_OFF;
 		return 0;
 	}

-- 
Jens Axboe

