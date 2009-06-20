Return-Path: <linux-kernel-owner+w=401wt.eu-S1756273AbZFTQ64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273AbZFTQ64 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 12:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756341AbZFTQ6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 12:58:42 -0400
Received: from mail-fx0-f214.google.com ([209.85.220.214]:39152 "EHLO
	mail-fx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567AbZFTQ6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 12:58:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=EIMBWZlqg9rShB0p2rUDip0UiXqPaL8b1Kfm8RTH+/n0eASQmvUpZ8VsxFEdabTa8w
         dBF6QU97ArRymG1uEOohCFu14EOqC27+wWHHjMxl+Nb80I2P57rQbwT5My9tPQAuLEya
         sLFZ/3gRr2gACtyzZ4j7gX99Mbs/xBsXXITDI=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Cc: johannes@sipsolutions.net, Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH] Staging: stlc45xx: convert config_interface to bss_info_changed
Date: Sat, 20 Jun 2009 20:58:33 +0400
Message-Id: <1245517113-31717-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See commit 2d0ddec5b2b (mac80211: unify config_interface and
bss_info_changed)

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/staging/stlc45xx/stlc45xx.c |   27 ++++++++-------------------
 1 files changed, 8 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/stlc45xx/stlc45xx.c b/drivers/staging/stlc45xx/stlc45xx.c
index cfdaac9..a137c78 100644
--- a/drivers/staging/stlc45xx/stlc45xx.c
+++ b/drivers/staging/stlc45xx/stlc45xx.c
@@ -2235,24 +2235,6 @@ static void stlc45xx_op_remove_interface(struct ieee80211_hw *hw,
 	stlc45xx_debug(DEBUG_FUNC, "%s", __func__);
 }
 
-static int stlc45xx_op_config_interface(struct ieee80211_hw *hw,
-					struct ieee80211_vif *vif,
-					struct ieee80211_if_conf *conf)
-{
-	struct stlc45xx *stlc = hw->priv;
-
-	stlc45xx_debug(DEBUG_FUNC, "%s", __func__);
-
-	mutex_lock(&stlc->mutex);
-
-	memcpy(stlc->bssid, conf->bssid, ETH_ALEN);
-	stlc45xx_tx_setup(stlc);
-
-	mutex_unlock(&stlc->mutex);
-
-	return 0;
-}
-
 static int stlc45xx_op_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct stlc45xx *stlc = hw->priv;
@@ -2295,6 +2277,14 @@ static void stlc45xx_op_bss_info_changed(struct ieee80211_hw *hw,
 {
 	struct stlc45xx *stlc = hw->priv;
 
+	stlc45xx_debug(DEBUG_FUNC, "%s", __func__);
+	mutex_lock(&stlc->mutex);
+
+	memcpy(stlc->bssid, info->bssid, ETH_ALEN);
+	stlc45xx_tx_setup(stlc);
+
+	mutex_unlock(&stlc->mutex);
+
 	if (changed & BSS_CHANGED_ASSOC) {
 		stlc->associated = info->assoc;
 		if (info->assoc)
@@ -2357,7 +2347,6 @@ static const struct ieee80211_ops stlc45xx_ops = {
 	.add_interface = stlc45xx_op_add_interface,
 	.remove_interface = stlc45xx_op_remove_interface,
 	.config = stlc45xx_op_config,
-	.config_interface = stlc45xx_op_config_interface,
 	.configure_filter = stlc45xx_op_configure_filter,
 	.tx = stlc45xx_op_tx,
 	.bss_info_changed = stlc45xx_op_bss_info_changed,
-- 
1.6.3.1

