Return-Path: <linux-kernel-owner+w=401wt.eu-S1755233AbYLOK2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbYLOK2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 05:28:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbYLOK2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 05:28:15 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:7866 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbYLOK2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 05:28:14 -0500
Date: Mon, 15 Dec 2008 11:28:05 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Mike Rapoport <mike@compulab.co.il>,
       Eric Miao <eric.miao@marvell.com>, Liam Girdwood <lrg@kernel.org>
Subject: [PATCH] da903x: Fix section mismatch
Message-ID: <20081215112805.41b6cf13@hyperion.delvare>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

da903x_remove_subdevs() can be called in case of device initialization
error, so it shouldn't be tagged __devexit.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Mike Rapoport <mike@compulab.co.il>
Cc: Eric Miao <eric.miao@marvell.com>
Cc: Samuel Ortiz <sameo@openedhand.com>
Cc: Liam Girdwood <lrg@kernel.org>
---
 drivers/mfd/da903x.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.28-rc8.orig/drivers/mfd/da903x.c	2008-11-21 10:59:44.000000000 +0100
+++ linux-2.6.28-rc8/drivers/mfd/da903x.c	2008-12-15 11:19:30.000000000 +0100
@@ -435,13 +435,13 @@ static const struct i2c_device_id da903x
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
Jean Delvare
