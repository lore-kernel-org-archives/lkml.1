Return-Path: <linux-kernel-owner+w=401wt.eu-S933695AbZFOTBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933695AbZFOTBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 15:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765481AbZFOTBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 15:01:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50343 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759727AbZFOTBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 15:01:03 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Report regulator_get() failure in virtual consumer
Date: Mon, 15 Jun 2009 20:01:01 +0100
Message-Id: <1245092461-8813-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The core will no longer complain so we should log an error here.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/virtual.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/virtual.c b/drivers/regulator/virtual.c
index e7db566..e953c18 100644
--- a/drivers/regulator/virtual.c
+++ b/drivers/regulator/virtual.c
@@ -285,6 +285,8 @@ static int regulator_virtual_consumer_probe(struct platform_device *pdev)
 	drvdata->regulator = regulator_get(&pdev->dev, reg_id);
 	if (IS_ERR(drvdata->regulator)) {
 		ret = PTR_ERR(drvdata->regulator);
+		dev_err(&pdev->dev, "Failed to obtain supply '%s': %d\n",
+			reg_id, ret);
 		goto err;
 	}
 
-- 
1.6.3.1

