Return-Path: <linux-kernel-owner+w=401wt.eu-S1759432AbZD1LeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759432AbZD1LeN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 07:34:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755037AbZD1Ld5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 07:33:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:14034 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961AbZD1Ld4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 07:33:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=JeLCQ61im7EfQFvfJhsPvKjs8bhvwQeNfSuNCRcm8ZmwNjQJoou0ObEGjP+IiwHkcP
         gwauCxxKVK1RXX/CVtWj1KnwDID/ZdT00hcm3IYXLLysQajE20kd38tD2373ZsCSlD41
         RPBBVgLIXP0UPk3ieu4NawoD9S0a6A8vlieyQ=
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH 1/1] regulator/bq24022: fix bug in is_enabled function
Date: Tue, 28 Apr 2009 13:34:14 +0200
Message-Id: <1240918454-25118-1-git-send-email-philipp.zabel@gmail.com>
X-Mailer: git-send-email 1.6.2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This seems to be fallout from last October's regulator core rework.
It got noticed only because of recent regulator framework changes.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/regulator/bq24022.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/bq24022.c b/drivers/regulator/bq24022.c
index 7ecb820..d08cd9b 100644
--- a/drivers/regulator/bq24022.c
+++ b/drivers/regulator/bq24022.c
@@ -61,8 +61,7 @@ static int bq24022_disable(struct regulator_dev *rdev)
 
 static int bq24022_is_enabled(struct regulator_dev *rdev)
 {
-	struct platform_device *pdev = rdev_get_drvdata(rdev);
-	struct bq24022_mach_info *pdata = pdev->dev.platform_data;
+	struct bq24022_mach_info *pdata = rdev_get_drvdata(rdev);
 
 	return !gpio_get_value(pdata->gpio_nce);
 }
-- 
1.6.2.4

