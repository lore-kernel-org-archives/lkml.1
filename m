Return-Path: <linux-kernel-owner+w=401wt.eu-S1757524AbZGMVdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524AbZGMVdN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 17:33:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757463AbZGMVdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 17:33:11 -0400
Received: from server1.wserver.cz ([82.113.45.157]:52901 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757480AbZGMVdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 17:33:07 -0400
X-Greylist: delayed 519 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Jul 2009 17:33:06 EDT
From: Jiri Slaby <jirislaby@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH] wireless: wl12xx, fix lock imbalance
Date: Mon, 13 Jul 2009 23:24:26 +0200
Message-Id: <1247520266-32007-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add omitted mutex_unlock to one of wl12xx_op_start fail paths (when
wl12xx_chip_wakeup fails).

Not sure if the device should be powered off?

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/net/wireless/wl12xx/main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 603d611..d241e4a 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -336,7 +336,7 @@ static int wl12xx_op_start(struct ieee80211_hw *hw)
 
 	ret = wl12xx_chip_wakeup(wl);
 	if (ret < 0)
-		return ret;
+		goto unlock;
 
 	ret = wl->chip.op_boot(wl);
 	if (ret < 0)
@@ -357,7 +357,7 @@ static int wl12xx_op_start(struct ieee80211_hw *hw)
 out:
 	if (ret < 0)
 		wl12xx_power_off(wl);
-
+unlock:
 	mutex_unlock(&wl->mutex);
 
 	return ret;
-- 
1.6.3.2

