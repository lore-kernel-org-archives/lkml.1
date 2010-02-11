Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850Ab0BKTUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 14:20:55 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51083 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756706Ab0BKTUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 14:20:54 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>, stable@kernel.org
Subject: [PATCH 2.6.33] regulator: Fix display of null constraints for regulators
Date: Thu, 11 Feb 2010 19:20:48 +0000
Message-Id: <1265916048-9596-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the regulator constraints are empty and there is no voltage
reported then nothing will be added to the text displayed for the
constraints, leading to random stack data being printed. This is
unlikely to happen for practical regulators since most will at
least report a voltage but should still be fixed.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: stable@kernel.org
---

Not super critical for 2.6.33 but at least worth considering.

 drivers/regulator/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 0bbf8e2..ce877e8 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -664,7 +664,7 @@ static int suspend_prepare(struct regulator_dev *rdev, suspend_state_t state)
 static void print_constraints(struct regulator_dev *rdev)
 {
 	struct regulation_constraints *constraints = rdev->constraints;
-	char buf[80];
+	char buf[80] = "";
 	int count = 0;
 	int ret;
 
-- 
1.6.6.1

