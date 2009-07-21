Return-Path: <linux-kernel-owner+w=401wt.eu-S1755175AbZGUPBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbZGUPBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 11:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754375AbZGUPAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 11:00:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42573 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753823AbZGUPAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 11:00:33 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/6] regulator: Warn when unregistering an in-use regulator
Date: Tue, 21 Jul 2009 16:00:25 +0100
Message-Id: <1248188428-11277-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248188428-11277-2-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1248188428-11277-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1248188428-11277-2-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're probably going to start oopsing fairly soon after this happens.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 33a8c3c..e5ccc9f 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2229,6 +2229,7 @@ void regulator_unregister(struct regulator_dev *rdev)
 		return;
 
 	mutex_lock(&regulator_list_mutex);
+	WARN_ON(rdev->open_count)
 	unset_regulator_supplies(rdev);
 	list_del(&rdev->list);
 	if (rdev->supply)
-- 
1.6.3.3

