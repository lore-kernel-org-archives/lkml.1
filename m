Return-Path: <linux-kernel-owner+w=401wt.eu-S1753084AbZHCRuD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084AbZHCRuD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 13:50:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752883AbZHCRuC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 13:50:02 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37453 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752873AbZHCRt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 13:49:59 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/5] regulator: Check for constraints in regulator_init_complete()
Date: Mon,  3 Aug 2009 18:49:55 +0100
Message-Id: <1249321797-4582-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249321797-4582-2-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1249321797-4582-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1249321797-4582-2-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 6e0c723..dfbf431 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2409,14 +2409,14 @@ static int __init regulator_init_complete(void)
 		ops = rdev->desc->ops;
 		c = rdev->constraints;
 
-		if (c->name)
+		if (c && c->name)
 			name = c->name;
 		else if (rdev->desc->name)
 			name = rdev->desc->name;
 		else
 			name = "regulator";
 
-		if (!ops->disable || c->always_on)
+		if (!ops->disable || (c && c->always_on))
 			continue;
 
 		mutex_lock(&rdev->mutex);
-- 
1.6.3.3

