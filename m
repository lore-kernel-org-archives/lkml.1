Return-Path: <linux-kernel-owner+w=401wt.eu-S1753419Ab0ADPbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab0ADPbA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 10:31:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752909Ab0ADPbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 10:31:00 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40460 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751977Ab0ADPa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 10:30:59 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>, stable@kernel.org
Subject: [PATCH 2.6.33] regulator: Specify REGULATOR_CHANGE_STATUS for WM835x LED constraints
Date: Mon,  4 Jan 2010 15:30:54 +0000
Message-Id: <1262619054-26795-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.5.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM8350 LED driver needs to be able to enable and disable the
regulators it is using. Previously the core wasn't properly enforcing
status change constraints so the driver was able to function but this
has always been intended to be required.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: stable@kernel.org
---
 drivers/regulator/wm8350-regulator.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
index 1bbff09..e7b89e7 100644
--- a/drivers/regulator/wm8350-regulator.c
+++ b/drivers/regulator/wm8350-regulator.c
@@ -1504,7 +1504,8 @@ int wm8350_register_led(struct wm8350 *wm8350, int lednum, int dcdc, int isink,
 	led->isink_init.consumer_supplies = &led->isink_consumer;
 	led->isink_init.constraints.min_uA = 0;
 	led->isink_init.constraints.max_uA = pdata->max_uA;
-	led->isink_init.constraints.valid_ops_mask = REGULATOR_CHANGE_CURRENT;
+	led->isink_init.constraints.valid_ops_mask
+		= REGULATOR_CHANGE_CURRENT | REGULATOR_CHANGE_STATUS;
 	led->isink_init.constraints.valid_modes_mask = REGULATOR_MODE_NORMAL;
 	ret = wm8350_register_regulator(wm8350, isink, &led->isink_init);
 	if (ret != 0) {
@@ -1517,6 +1518,7 @@ int wm8350_register_led(struct wm8350 *wm8350, int lednum, int dcdc, int isink,
 	led->dcdc_init.num_consumer_supplies = 1;
 	led->dcdc_init.consumer_supplies = &led->dcdc_consumer;
 	led->dcdc_init.constraints.valid_modes_mask = REGULATOR_MODE_NORMAL;
+	led->dcdc_init.constraints.valid_ops_mask =  REGULATOR_CHANGE_STATUS;
 	ret = wm8350_register_regulator(wm8350, dcdc, &led->dcdc_init);
 	if (ret != 0) {
 		platform_device_put(pdev);
-- 
1.6.5.7

