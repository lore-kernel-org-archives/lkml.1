Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbYISRkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbYISRkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 13:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755221AbYISRjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 13:39:48 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:45766 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755207AbYISRjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 13:39:47 -0400
Subject: [PATCH 3/6] regulator: check for init_data on registration
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Fri, 19 Sep 2008 18:39:47 +0100
Message-Id: <1221845987.6892.137.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since it is now mandatory to supply constraints via init_data on device
registration check for that when registering, saving us from oopsing
later on.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Liam Girdwood <lrg@slimlogic.co.uk>
---
 drivers/regulator/core.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index cec9c73..f5fcdf7 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1691,6 +1691,9 @@ struct regulator_dev *regulator_register(struct device *dev,
 	    !regulator_desc->type == REGULATOR_CURRENT)
 		return ERR_PTR(-EINVAL);
 
+	if (!init_data)
+		return ERR_PTR(-EINVAL);
+
 	rdev = kzalloc(sizeof(struct regulator_dev), GFP_KERNEL);
 	if (rdev == NULL)
 		return ERR_PTR(-ENOMEM);
-- 
1.5.4.3


