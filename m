Return-Path: <linux-kernel-owner+w=401wt.eu-S1753247Ab0AGQQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab0AGQQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 11:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211Ab0AGQQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 11:16:18 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53177 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753191Ab0AGQQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 11:16:17 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>, stable@kernel.org
Subject: [PATCH] mfd: WM835x GPIO direction register is not locked
Date: Thu,  7 Jan 2010 16:16:14 +0000
Message-Id: <1262880974-20151-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to set the security key when writing to it.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: stable@kernel.org
---

Ideally this'd go into 2.6.33, though it's not so urgent without the
gpiolib driver I just posted it's also very non-invasive.

 drivers/mfd/wm8350-core.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
index 8485a70..9a970bd 100644
--- a/drivers/mfd/wm8350-core.c
+++ b/drivers/mfd/wm8350-core.c
@@ -134,8 +134,7 @@ static inline int is_reg_locked(struct wm8350 *wm8350, u8 reg)
 	    wm8350->reg_cache[WM8350_SECURITY] == WM8350_UNLOCK_KEY)
 		return 0;
 
-	if ((reg == WM8350_GPIO_CONFIGURATION_I_O) ||
-	    (reg >= WM8350_GPIO_FUNCTION_SELECT_1 &&
+	if ((reg >= WM8350_GPIO_FUNCTION_SELECT_1 &&
 	     reg <= WM8350_GPIO_FUNCTION_SELECT_4) ||
 	    (reg >= WM8350_BATTERY_CHARGER_CONTROL_1 &&
 	     reg <= WM8350_BATTERY_CHARGER_CONTROL_3))
-- 
1.6.6

