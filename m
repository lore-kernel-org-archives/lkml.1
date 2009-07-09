Return-Path: <linux-kernel-owner+w=401wt.eu-S1761243AbZGIOot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761243AbZGIOot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 10:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761251AbZGIOof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 10:44:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45756 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761182AbZGIOoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 10:44:34 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>, linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Define full constraints function with REGULATOR disabled
Date: Thu,  9 Jul 2009 15:44:31 +0100
Message-Id: <1247150671-23365-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows machine drivers to build without ifdefs if they have
full constraints. Suggested by machine drivers contributed by
Haojian Zhuang <haojian.zhuang@gmail.com>.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/regulator/machine.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/regulator/machine.h b/include/linux/regulator/machine.h
index 9328090..73a88f6 100644
--- a/include/linux/regulator/machine.h
+++ b/include/linux/regulator/machine.h
@@ -171,6 +171,12 @@ struct regulator_init_data {
 
 int regulator_suspend_prepare(suspend_state_t state);
 
+#ifdef CONFIG_REGULATOR
 void regulator_has_full_constraints(void);
+#else
+static inline void regulator_has_full_constraints(void)
+{
+}
+#endif
 
 #endif
-- 
1.6.3.3

