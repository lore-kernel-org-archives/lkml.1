Return-Path: <linux-kernel-owner+w=401wt.eu-S1759468AbZJMMHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759468AbZJMMHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 08:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758015AbZJMMHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 08:07:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38856 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751981AbZJMMH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 08:07:29 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] regulator: Handle missing constraints in _regulator_disable()
Date: Tue, 13 Oct 2009 13:06:50 +0100
Message-Id: <1255435610-9765-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1255435610-9765-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1255435610-9765-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 25e35c7..1ac37f5 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1289,7 +1289,8 @@ static int _regulator_disable(struct regulator_dev *rdev)
 		return -EIO;
 
 	/* are we the last user and permitted to disable ? */
-	if (rdev->use_count == 1 && !rdev->constraints->always_on) {
+	if (rdev->use_count == 1 &&
+	    (rdev->constraints && !rdev->constraints->always_on)) {
 
 		/* we are last user */
 		if (_regulator_can_change_status(rdev) &&
-- 
1.6.4.3

