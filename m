Return-Path: <linux-kernel-owner+w=401wt.eu-S932106AbZJVPcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106AbZJVPcW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 11:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756625AbZJVPcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 11:32:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41216 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756093AbZJVPbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 11:31:35 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 6/6] regulator: Ensure val is initialised in 88pm8607 choose_voltage()
Date: Thu, 22 Oct 2009 16:31:35 +0100
Message-Id: <1256225495-15379-6-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1256225495-15379-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1256225495-15379-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we fall through it means that we hit an unknown regulator/chip
combination so set -ENOENT as an explicit flag (the return code
is only used internally).

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/88pm8607.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/88pm8607.c b/drivers/regulator/88pm8607.c
index e1aabda..0471955 100644
--- a/drivers/regulator/88pm8607.c
+++ b/drivers/regulator/88pm8607.c
@@ -170,7 +170,8 @@ static int choose_voltage(struct regulator_dev *rdev, int min_uV, int max_uV)
 {
 	struct pm8607_regulator_info *info = rdev_get_drvdata(rdev);
 	uint8_t chip_id = info->chip->chip_id;
-	int val, ret;
+	int val = -ENOENT;
+	int ret;
 
 	switch (info->desc.id) {
 	case PM8607_ID_BUCK1:
-- 
1.6.5

