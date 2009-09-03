Return-Path: <linux-kernel-owner+w=401wt.eu-S1754862AbZICJu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbZICJu4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 05:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754841AbZICJuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 05:50:55 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:56104 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811AbZICJuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 05:50:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=cC84lhnkhsiT0PbCao5yfbIy6SG/zzfj4tmsonNMZwo5NJfPbVcQUaGcev3cyPznQT
         yUu5/EAUzCba8e04iX4PlVnvRQxzs3pwkMr9vpZ66OhYuwPldUy9yZVOavsdoA9d4oxm
         ynF8BBYXNrmCfkgT2i2vTXN/aShVAEUSI1bM0=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: lrodriguez@atheros.com, linville@tuxdriver.com,
       linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH] Staging: stlc45xx: fix usage of mac80211 workqueue
Date: Thu,  3 Sep 2009 13:50:44 +0400
Message-Id: <1251971444-28690-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See commit 42935ecaf(mac80211: redefine usage of the mac80211
workqueue).
Fix build error.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/staging/stlc45xx/stlc45xx.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/stlc45xx/stlc45xx.c b/drivers/staging/stlc45xx/stlc45xx.c
index 12d414d..9ec8bd1 100644
--- a/drivers/staging/stlc45xx/stlc45xx.c
+++ b/drivers/staging/stlc45xx/stlc45xx.c
@@ -1058,7 +1058,7 @@ static void stlc45xx_reset(struct stlc45xx *stlc)
 	stlc45xx_warning("resetting firmware");
 	stlc->fw_state = FW_STATE_RESET;
 	ieee80211_stop_queues(stlc->hw);
-	queue_work(stlc->hw->workqueue, &stlc->work_reset);
+	ieee80211_queue_work(stlc->hw, &stlc->work_reset);
 }
 
 static void stlc45xx_work_tx_timeout(struct work_struct *work)
@@ -1489,7 +1489,7 @@ static irqreturn_t stlc45xx_interrupt(int irq, void *config)
 
 	stlc45xx_debug(DEBUG_IRQ, "IRQ");
 
-	queue_work(stlc->hw->workqueue, &stlc->work);
+	ieee80211_queue_work(stlc->hw, &stlc->work);
 
 	return IRQ_HANDLED;
 }
@@ -1568,7 +1568,7 @@ static int stlc45xx_wq_tx(struct stlc45xx *stlc)
 		}
 
 		list_add(&entry->tx_list, &stlc->tx_sent);
-		queue_delayed_work(stlc->hw->workqueue,
+		ieee80211_queue_delayed_work(stlc->hw,
 				   &stlc->work_tx_timeout,
 				   msecs_to_jiffies(TX_TIMEOUT));
 	}
@@ -2132,7 +2132,7 @@ static int stlc45xx_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		ieee80211_stop_queues(stlc->hw);
 	}
 
-	queue_work(stlc->hw->workqueue, &stlc->work);
+	ieee80211_queue_work(stlc->hw, &stlc->work);
 
 	spin_unlock_bh(&stlc->tx_lock);
 
-- 
1.6.4.1

