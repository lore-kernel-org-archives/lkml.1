Return-Path: <linux-kernel-owner+w=401wt.eu-S1756583AbYLaMy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583AbYLaMy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 07:54:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756091AbYLaMxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 07:53:04 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:2296 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016AbYLaMxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 07:53:00 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 31 Dec 2008 12:52:43 +0000
Message-Id: <1230727964-9268-4-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1230727964-9268-3-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20081231125114.GC6596@sirena.org.uk>
 <1230727964-9268-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1230727964-9268-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1230727964-9268-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 4/5] regulator: Fix some kerneldoc rendering issues
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some minor textual changes in here as well, mostly to enable()
and disable() but the primary goal of these changes is to fix
misrenderings of the kerneldoc documentation for the regulator API.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index fda4400..7341c97 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1012,10 +1012,12 @@ static int _regulator_enable(struct regulator_dev *rdev)
  * regulator_enable - enable regulator output
  * @regulator: regulator source
  *
- * Enable the regulator output at the predefined voltage or current value.
+ * Request that the regulator be enabled with the regulator output at
+ * the predefined voltage or current value.  Calls to regulator_enable()
+ * must be balanced with calls to regulator_disable().
+ *
  * NOTE: the output value can be set by other drivers, boot loader or may be
- * hardwired in the regulator.  Calls to regulator_enable() must be balanced
- * with calls to regulator_disable().
+ * hardwired in the regulator.
  */
 int regulator_enable(struct regulator *regulator)
 {
@@ -1073,11 +1075,13 @@ static int _regulator_disable(struct regulator_dev *rdev)
  * regulator_disable - disable regulator output
  * @regulator: regulator source
  *
- * Disable the regulator output voltage or current.
+ * Disable the regulator output voltage or current.  Calls to
+ * regulator_enable() must be balanced with calls to
+ * regulator_disable().
  *
  * NOTE: this will only disable the regulator output if no other consumer
- * devices have it enabled.  Calls to regulator_enable() must be balanced with
- * calls to regulator_disable().
+ * devices have it enabled, the regulator device supports disabling and
+ * machine constraints permit this operation.
  */
 int regulator_disable(struct regulator *regulator)
 {
@@ -1936,7 +1940,7 @@ void regulator_unregister(struct regulator_dev *rdev)
 EXPORT_SYMBOL_GPL(regulator_unregister);
 
 /**
- * regulator_suspend_prepare: prepare regulators for system wide suspend
+ * regulator_suspend_prepare - prepare regulators for system wide suspend
  * @state: system suspend state
  *
  * Configure each regulator with it's suspend operating parameters for state.
-- 
1.5.6.3

