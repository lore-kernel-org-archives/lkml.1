Return-Path: <linux-kernel-owner+w=401wt.eu-S1751535AbZGZHyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535AbZGZHyK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 03:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751210AbZGZHyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 03:54:09 -0400
Received: from compulab.co.il ([67.18.134.219]:49591 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbZGZHyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 03:54:09 -0400
From: Mike Rapoport <mike@compulab.co.il>
To: broonie@opensource.wolfsonmicro.com
Cc: lrg@slimlogic.co.uk, eric.y.miao@gmail.com, linux-kernel@vger.kernel.org,
       Mike Rapoport <mike@compulab.co.il>
Subject: [PATCH] regulator: da903x: add support for DA9030 BUCK2 with DVM
Date: Sun, 26 Jul 2009 10:54:02 +0300
Message-Id: <1248594842-23456-1-git-send-email-mike@compulab.co.il>
X-Mailer: git-send-email 1.6.0.6
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
---
 drivers/regulator/da903x.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/da903x.c b/drivers/regulator/da903x.c
index b8b89ef..fab755d 100644
--- a/drivers/regulator/da903x.c
+++ b/drivers/regulator/da903x.c
@@ -367,24 +367,24 @@ static struct regulator_ops da9034_regulator_ldo12_ops = {
 	.enable_bit	= (ebit),					\
 }
 
-#define DA9034_DVC(_id, min, max, step, vreg, nbits, ureg, ubit, ereg, ebit) \
+#define DA903x_DVC(_pmic, _id, min, max, step, vreg, nbits, ureg, ubit, ereg, ebit) \
 {									\
 	.desc	= {							\
 		.name	= #_id,						\
 		.ops	= &da9034_regulator_dvc_ops,			\
 		.type	= REGULATOR_VOLTAGE,				\
-		.id	= DA9034_ID_##_id,				\
+		.id	= _pmic##_ID_##_id,				\
 		.owner	= THIS_MODULE,					\
 	},								\
 	.min_uV		= (min) * 1000,					\
 	.max_uV		= (max) * 1000,					\
 	.step_uV	= (step) * 1000,				\
-	.vol_reg	= DA9034_##vreg,				\
+	.vol_reg	= _pmic##_##vreg,				\
 	.vol_shift	= (0),						\
 	.vol_nbits	= (nbits),					\
-	.update_reg	= DA9034_##ureg,				\
+	.update_reg	= _pmic##_##ureg,				\
 	.update_bit	= (ubit),					\
-	.enable_reg	= DA9034_##ereg,				\
+	.enable_reg	= _pmic##_##ereg,				\
 	.enable_bit	= (ebit),					\
 }
 
@@ -394,6 +394,12 @@ static struct regulator_ops da9034_regulator_ldo12_ops = {
 #define DA9030_LDO(_id, min, max, step, vreg, shift, nbits, ereg, ebit)	\
 	DA903x_LDO(DA9030, _id, min, max, step, vreg, shift, nbits, ereg, ebit)
 
+#define DA9030_DVC(_id, min, max, step, vreg, nbits, ureg, ubit, ereg, ebit) \
+	DA903x_DVC(DA9030, _id, min, max, step, vreg, nbits, ureg, ubit, ereg, ebit)
+
+#define DA9034_DVC(_id, min, max, step, vreg, nbits, ureg, ubit, ereg, ebit) \
+	DA903x_DVC(DA9034, _id, min, max, step, vreg, nbits, ureg, ubit, ereg, ebit)
+
 static struct da903x_regulator_info da903x_regulator_info[] = {
 	/* DA9030 */
 	DA9030_LDO( 1, 1200, 3200, 100,    LDO1, 0, 5, RCTL12, 1),
@@ -415,6 +421,7 @@ static struct da903x_regulator_info da903x_regulator_info[] = {
 	DA9030_LDO(18, 1800, 3200, 100, LDO1819, 0, 4, RCTL21, 2),
 	DA9030_LDO(19, 1800, 3200, 100, LDO1819, 4, 4, RCTL21, 1),
 	DA9030_LDO(13, 2100, 2100, 0, INVAL, 0, 0, RCTL11, 3), /* fixed @2.1V */
+	DA9030_DVC(BUCK2, 850, 1650, 25, BUCK2DVM1, 5, BUCK2DVM1, 7, RCTL11, 0),
 
 	/* DA9034 */
 	DA9034_DVC(BUCK1, 725, 1500, 25, ADTV1, 5, VCC1, 0, OVER1, 0),
-- 
1.6.0.6

