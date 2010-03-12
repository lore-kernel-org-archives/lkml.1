Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933488Ab0CLRSL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 12:18:11 -0500
Received: from smtp.nokia.com ([192.100.122.230]:45440 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933238Ab0CLRSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 12:18:09 -0500
From: Ameya Palande <ameya.palande@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com,
       dbrownell@users.sourceforge.net
Subject: [PATCH] regulator: Get rid of lockdep warning
Date: Fri, 12 Mar 2010 19:16:36 +0200
Message-Id: <37adb5f9cc7986b51b7b560cf7644ac5177a6e34.1268411141.git.ameya.palande@nokia.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 12 Mar 2010 17:17:48.0197 (UTC) FILETIME=[F0155550:01CAC207]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ameya Palande <ameya.palande@nokia.com>

WARNING: at kernel/lockdep.c:2706 sysfs_add_file_mode+0x4c/0xa8()

Signed-off-by: Ameya Palande <ameya.palande@nokia.com>
CC: Liam Girdwood <lrg@slimlogic.co.uk>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/regulator/core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index c7bbe30..2ad3272 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1045,6 +1045,7 @@ static struct regulator *create_regulator(struct regulator_dev *rdev,
 		regulator->dev_attr.attr.owner = THIS_MODULE;
 		regulator->dev_attr.attr.mode = 0444;
 		regulator->dev_attr.show = device_requested_uA_show;
+		sysfs_attr_init(&regulator->dev_attr.attr);
 		err = device_create_file(dev, &regulator->dev_attr);
 		if (err < 0) {
 			printk(KERN_WARNING "%s: could not add regulator_dev"
-- 
1.6.3.3

