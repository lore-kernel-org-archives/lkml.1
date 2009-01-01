Return-Path: <linux-kernel-owner+w=401wt.eu-S1756681AbZAAMxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbZAAMxG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 07:53:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756035AbZAAMwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 07:52:54 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4756 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756022AbZAAMwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 07:52:54 -0500
From: Mark Brown <broonie@sirena.org.uk>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: Eric Miao <eric.miao@marvell.com>, linux-kernel@vger.kernel.org,
       Mark Brown <broonie@sirena.org.uk>
Date: Thu,  1 Jan 2009 12:52:31 +0000
Message-Id: <1230814351-29527-1-git-send-email-broonie@sirena.org.uk>
X-Mailer: git-send-email 1.5.6.3
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] mfd: Fix section mismatch in da903x
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subdevice removal functions are marked __devexit but are referenced
from the error handling path when probing so are needed even when
__devexit functions are removed.

Signed-off-by: Mark Brown <broonie@sirena.org.uk>
---
 drivers/mfd/da903x.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/da903x.c b/drivers/mfd/da903x.c
index 0b5bd85..248756f 100644
--- a/drivers/mfd/da903x.c
+++ b/drivers/mfd/da903x.c
@@ -435,13 +435,13 @@ static const struct i2c_device_id da903x_id_table[] = {
 };
 MODULE_DEVICE_TABLE(i2c, da903x_id_table);
 
-static int __devexit __remove_subdev(struct device *dev, void *unused)
+static int __remove_subdev(struct device *dev, void *unused)
 {
 	platform_device_unregister(to_platform_device(dev));
 	return 0;
 }
 
-static int __devexit da903x_remove_subdevs(struct da903x_chip *chip)
+static int da903x_remove_subdevs(struct da903x_chip *chip)
 {
 	return device_for_each_child(chip->dev, NULL, __remove_subdev);
 }
-- 
1.5.6.3

