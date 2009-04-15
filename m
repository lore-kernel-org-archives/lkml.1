Return-Path: <linux-kernel-owner+w=401wt.eu-S1753328AbZDOQGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbZDOQGF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 12:06:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbZDOQFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 12:05:51 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:63629 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702AbZDOQFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 12:05:50 -0400
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] phylib: Fix delay argument of schedule_delayed_work
Date: Thu, 16 Apr 2009 01:05:51 +0900
Message-Id: <1239811551-6101-1-git-send-email-anemo@mba.ocn.ne.jp>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit a390d1f3 ("phylib: convert state_queue work to
delayed_work") missed converting 'expires' value to 'delay' value.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
 drivers/net/phy/phy.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 3ff1f42..5737b85 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -434,7 +434,7 @@ void phy_start_machine(struct phy_device *phydev,
 	phydev->adjust_state = handler;
 
 	INIT_DELAYED_WORK(&phydev->state_queue, phy_state_machine);
-	schedule_delayed_work(&phydev->state_queue, jiffies + HZ);
+	schedule_delayed_work(&phydev->state_queue, HZ);
 }
 
 /**
@@ -937,6 +937,5 @@ static void phy_state_machine(struct work_struct *work)
 	if (err < 0)
 		phy_error(phydev);
 
-	schedule_delayed_work(&phydev->state_queue,
-				jiffies + PHY_STATE_TIME * HZ);
+	schedule_delayed_work(&phydev->state_queue, PHY_STATE_TIME * HZ);
 }
-- 
1.5.6.3

