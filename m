Return-Path: <linux-kernel-owner+w=401wt.eu-S1752742AbZHCRut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbZHCRut (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 13:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbZHCRuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 13:50:00 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37454 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752362AbZHCRt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 13:49:59 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/5] regulator: Check for constraints before using them for name
Date: Mon,  3 Aug 2009 18:49:54 +0100
Message-Id: <1249321797-4582-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249321797-4582-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1249321797-4582-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index e38db55..6e0c723 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -232,7 +232,7 @@ static ssize_t regulator_name_show(struct device *dev,
 	struct regulator_dev *rdev = dev_get_drvdata(dev);
 	const char *name;
 
-	if (rdev->constraints->name)
+	if (rdev->constraints && rdev->constraints->name)
 		name = rdev->constraints->name;
 	else if (rdev->desc->name)
 		name = rdev->desc->name;
-- 
1.6.3.3

