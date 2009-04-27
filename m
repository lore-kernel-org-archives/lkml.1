Return-Path: <linux-kernel-owner+w=401wt.eu-S1757185AbZD0RVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185AbZD0RVa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 13:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753731AbZD0RVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 13:21:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45765 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752802AbZD0RVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 13:21:20 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Move regulator drivers to subsys_initcall()
Date: Mon, 27 Apr 2009 18:21:18 +0100
Message-Id: <1240852878-8276-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regulators need to be available early in init in order to allow them
to be available for consumers when requested. This is generally done
by registering them at subsys_initcall() time but not all regulator
drivers have done that. Convert these drivers to do so in order to
mimimise future support.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/da903x.c             |    2 +-
 drivers/regulator/fixed.c              |    2 +-
 drivers/regulator/pcf50633-regulator.c |    2 +-
 drivers/regulator/wm8400-regulator.c   |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/da903x.c b/drivers/regulator/da903x.c
index 72b1549..2a491bf 100644
--- a/drivers/regulator/da903x.c
+++ b/drivers/regulator/da903x.c
@@ -504,7 +504,7 @@ static int __init da903x_regulator_init(void)
 {
 	return platform_driver_register(&da903x_regulator_driver);
 }
-module_init(da903x_regulator_init);
+subsys_initcall(da903x_regulator_init);
 
 static void __exit da903x_regulator_exit(void)
 {
diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 23d5546..6e0bede 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -117,7 +117,7 @@ static int __init regulator_fixed_voltage_init(void)
 {
 	return platform_driver_register(&regulator_fixed_voltage_driver);
 }
-module_init(regulator_fixed_voltage_init);
+subsys_initcall(regulator_fixed_voltage_init);
 
 static void __exit regulator_fixed_voltage_exit(void)
 {
diff --git a/drivers/regulator/pcf50633-regulator.c b/drivers/regulator/pcf50633-regulator.c
index cd761d8..8e14900 100644
--- a/drivers/regulator/pcf50633-regulator.c
+++ b/drivers/regulator/pcf50633-regulator.c
@@ -316,7 +316,7 @@ static int __init pcf50633_regulator_init(void)
 {
 	return platform_driver_register(&pcf50633_regulator_driver);
 }
-module_init(pcf50633_regulator_init);
+subsys_initcall(pcf50633_regulator_init);
 
 static void __exit pcf50633_regulator_exit(void)
 {
diff --git a/drivers/regulator/wm8400-regulator.c b/drivers/regulator/wm8400-regulator.c
index 1574260..01a6c95 100644
--- a/drivers/regulator/wm8400-regulator.c
+++ b/drivers/regulator/wm8400-regulator.c
@@ -380,7 +380,7 @@ static int __init wm8400_regulator_init(void)
 {
 	return platform_driver_register(&wm8400_regulator_driver);
 }
-module_init(wm8400_regulator_init);
+subsys_initcall(wm8400_regulator_init);
 
 static void __exit wm8400_regulator_exit(void)
 {
-- 
1.6.2.4

