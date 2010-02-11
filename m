Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513Ab0BKRWy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 12:22:54 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52646 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756035Ab0BKRWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 12:22:53 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Assume regulators are enabled if they don't report anything
Date: Thu, 11 Feb 2010 17:22:45 +0000
Message-Id: <1265908965-7726-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a regulator driver does not provide a way to query if the driver is
enabled then assume that it is enabled.  This is very likely to reflect
the actual state is more useful for callers than reporting an error.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 5a3509b..7f9177f 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1466,9 +1466,9 @@ EXPORT_SYMBOL_GPL(regulator_force_disable);
 
 static int _regulator_is_enabled(struct regulator_dev *rdev)
 {
-	/* sanity check */
+	/* If we don't know then assume that the regulator is always on */
 	if (!rdev->desc->ops->is_enabled)
-		return -EINVAL;
+		return 1;
 
 	return rdev->desc->ops->is_enabled(rdev);
 }
-- 
1.6.6.1

