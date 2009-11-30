Return-Path: <linux-kernel-owner+w=401wt.eu-S1752546AbZK3NYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbZK3NYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 08:24:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752067AbZK3NYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 08:24:17 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45580 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751722AbZK3NYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 08:24:16 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2.6.32] mfd: Correct WM831X_MAX_ISEL_VALUE
Date: Mon, 30 Nov 2009 13:24:18 +0000
Message-Id: <1259587458-1751-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was confusion between the array size and the highest ISEL
value possible.

Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-core.c            |    2 +-
 include/linux/mfd/wm831x/regulator.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
index d063e55..4b2021a 100644
--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -29,7 +29,7 @@
 /* Current settings - values are 2*2^(reg_val/4) microamps.  These are
  * exported since they are used by multiple drivers.
  */
-int wm831x_isinkv_values[WM831X_ISINK_MAX_ISEL] = {
+int wm831x_isinkv_values[WM831X_ISINK_MAX_ISEL + 1] = {
 	2,
 	2,
 	3,
diff --git a/include/linux/mfd/wm831x/regulator.h b/include/linux/mfd/wm831x/regulator.h
index f954663..955d30f 100644
--- a/include/linux/mfd/wm831x/regulator.h
+++ b/include/linux/mfd/wm831x/regulator.h
@@ -1212,7 +1212,7 @@
 #define WM831X_LDO1_OK_SHIFT                         0  /* LDO1_OK */
 #define WM831X_LDO1_OK_WIDTH                         1  /* LDO1_OK */
 
-#define WM831X_ISINK_MAX_ISEL 56
-extern int wm831x_isinkv_values[WM831X_ISINK_MAX_ISEL];
+#define WM831X_ISINK_MAX_ISEL 55
+extern int wm831x_isinkv_values[WM831X_ISINK_MAX_ISEL + 1];
 
 #endif
-- 
1.6.5.3

