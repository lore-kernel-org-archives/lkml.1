Return-Path: <linux-kernel-owner+w=401wt.eu-S1753071AbYHRTvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbYHRTvo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763155AbYHRTqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:46:08 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:43697 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760635AbYHRTqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:46:04 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       ath5k-devel@venema.h4ckr.net, Jiri Slaby <jirislaby@gmail.com>,
       Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: [PATCH 2/2] Ath5k: fix bintval setup
Date: Mon, 18 Aug 2008 21:45:28 +0200
Message-Id: <1219088728-10363-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1219088728-10363-1-git-send-email-jirislaby@gmail.com>
References: <1219088728-10363-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bintval is set to the initial value at .config_interface which is too
late, since it overwrites previously set value from .config. Move the
initialization to the .add_interface.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Cc: Luis R. Rodriguez <mcgrof@gmail.com>
---
 drivers/net/wireless/ath5k/base.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index b8178c7..227fa4b 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -2716,6 +2716,11 @@ static int ath5k_add_interface(struct ieee80211_hw *hw,
 		ret = -EOPNOTSUPP;
 		goto end;
 	}
+
+	/* Set to a reasonable value. Note that this will
+	 * be set to mac80211's value at ath5k_config(). */
+	sc->bintval = 1000;
+
 	ret = 0;
 end:
 	mutex_unlock(&sc->lock);
@@ -2760,9 +2765,6 @@ ath5k_config_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	struct ath5k_hw *ah = sc->ah;
 	int ret;
 
-	/* Set to a reasonable value. Note that this will
-	 * be set to mac80211's value at ath5k_config(). */
-	sc->bintval = 1000;
 	mutex_lock(&sc->lock);
 	if (sc->vif != vif) {
 		ret = -EIO;
-- 
1.5.6.5

