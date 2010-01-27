Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537Ab0A0Un0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab0A0Un0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 15:43:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754013Ab0A0UnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 15:43:25 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47214 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752620Ab0A0UnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 15:43:25 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Marek Vasut <marek.vasut@gmail.com>, linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2.6.33] power_supply: Handle missing platform data gracefully
Date: Wed, 27 Jan 2010 20:43:21 +0000
Message-Id: <1264625001-3963-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't unconditionally dereference the WM97xx core platform data since
it may not be present, causing an oops.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/power/wm97xx_battery.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/power/wm97xx_battery.c b/drivers/power/wm97xx_battery.c
index fa39e75..6ea3cb5 100644
--- a/drivers/power/wm97xx_battery.c
+++ b/drivers/power/wm97xx_battery.c
@@ -175,8 +175,14 @@ static int __devinit wm97xx_bat_probe(struct platform_device *dev)
 		dev_err(&dev->dev, "Do not pass platform_data through "
 			"wm97xx_bat_set_pdata!\n");
 		return -EINVAL;
-	} else
-		pdata = wmdata->batt_pdata;
+	}
+
+	if (!wmdata) {
+		dev_err(&dev->dev, "No platform data supplied\n");
+		return -EINVAL;
+	}
+
+	pdata = wmdata->batt_pdata;
 
 	if (dev->id != -1)
 		return -EINVAL;
-- 
1.6.6

