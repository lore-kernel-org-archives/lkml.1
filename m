Return-Path: <linux-kernel-owner+w=401wt.eu-S1758525AbZKYKFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758525AbZKYKFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 05:05:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758122AbZKYKFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 05:05:31 -0500
Received: from smtp.nokia.com ([192.100.105.134]:17408 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758464AbZKYKFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 05:05:30 -0500
From: Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>
To: lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com,
       dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org
Cc: peter.de-schrijver@nokia.com, eduardo.valentin@nokia.com,
       ext-juha.1.keski-saari@nokia.com
Subject: [PATCHv2 3/3] Define critical regulators as always_on
Date: Wed, 25 Nov 2009 12:04:55 +0200
Message-Id: <1259143495-9480-4-git-send-email-ext-juha.1.keski-saari@nokia.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1259143495-9480-1-git-send-email-ext-juha.1.keski-saari@nokia.com>
References: <1259143495-9480-1-git-send-email-ext-juha.1.keski-saari@nokia.com>
X-OriginalArrivalTime: 25 Nov 2009 10:05:08.0339 (UTC) FILETIME=[C49A1C30:01CA6DB6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Defines VIO, VDD1, VDD2, VPLL1 and VINT* regulators as always_on by default
since they are critical to TWL and its master's functionality and should
be on in all cases where RegFW is used

Signed-off-by: Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>
---
 drivers/regulator/twl4030-regulator.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/twl4030-regulator.c b/drivers/regulator/twl4030-regulator.c
index 7029fb9..af53f35 100644
--- a/drivers/regulator/twl4030-regulator.c
+++ b/drivers/regulator/twl4030-regulator.c
@@ -456,6 +456,14 @@ static int twl4030reg_probe(struct platform_device *pdev)
 	c->valid_ops_mask &= REGULATOR_CHANGE_VOLTAGE
 				| REGULATOR_CHANGE_MODE
 				| REGULATOR_CHANGE_STATUS;
+	if (pdev->id == TWL4030_REG_VIO ||
+		pdev->id == TWL4030_REG_VDD1 ||
+		pdev->id == TWL4030_REG_VDD2 ||
+		pdev->id == TWL4030_REG_VPLL1 ||
+		pdev->id == TWL4030_REG_VINTANA1 ||
+		pdev->id == TWL4030_REG_VINTANA2 ||
+		pdev->id == TWL4030_REG_VINTDIG)
+		c->always_on = true;
 
 	rdev = regulator_register(&info->desc, &pdev->dev, initdata, info);
 	if (IS_ERR(rdev)) {
-- 
1.6.3.3

