Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934401Ab0CLSKx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 13:10:53 -0500
Received: from smtp.nokia.com ([192.100.122.233]:51581 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934101Ab0CLSKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 13:10:51 -0500
From: Ameya Palande <ameya.palande@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com,
       dbrownell@users.sourceforge.net
Subject: [PATCHv2] regulator: Get rid of lockdep warning
Date: Fri, 12 Mar 2010 20:09:01 +0200
Message-Id: <c9b72e72ecf154ff6bf96bd956bef7d4c5aca2d4.1268417170.git.ameya.palande@nokia.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20100312172156.GB22822@rakim.wolfsonmicro.main>
References: <20100312172156.GB22822@rakim.wolfsonmicro.main>
X-OriginalArrivalTime: 12 Mar 2010 18:10:15.0243 (UTC) FILETIME=[43DE71B0:01CAC20F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ameya Palande <ameya.palande@nokia.com>

WARNING: at kernel/lockdep.c:2706 sysfs_add_file_mode+0x4c/0xa8()

Difference between v1 and v2:
Moved sysfs_attr_init() call as first one to access the structure.

Signed-off-by: Ameya Palande <ameya.palande@nokia.com>
CC: Liam Girdwood <lrg@slimlogic.co.uk>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/regulator/core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index c7bbe30..5af16c2 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1038,6 +1038,7 @@ static struct regulator *create_regulator(struct regulator_dev *rdev,
 			goto overflow_err;
 
 		regulator->dev = dev;
+		sysfs_attr_init(&regulator->dev_attr.attr);
 		regulator->dev_attr.attr.name = kstrdup(buf, GFP_KERNEL);
 		if (regulator->dev_attr.attr.name == NULL)
 			goto attr_name_err;
-- 
1.6.3.3

