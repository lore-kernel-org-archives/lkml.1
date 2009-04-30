Return-Path: <linux-kernel-owner+w=401wt.eu-S1755653AbZD3WaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653AbZD3WaN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 18:30:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759933AbZD3W3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 18:29:40 -0400
Received: from kroah.org ([198.145.64.141]:55454 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758182AbZD3W3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 18:29:39 -0400
Date: Thu, 30 Apr 2009 15:21:37 -0700
From: Greg Kroah-Hartman <gregkh@suse.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] regulator: remove driver_data direct access of struct
	device
Message-ID: <20090430222137.GA18614@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@suse.de>

In the near future, the driver core is going to not allow direct access
to the driver_data pointer in struct device.  Instead, the functions
dev_get_drvdata() and dev_set_drvdata() should be used.  These functions
have been around since the beginning, so are backwards compatible with
all older kernel versions.


Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/regulator/wm8400-regulator.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/regulator/wm8400-regulator.c
+++ b/drivers/regulator/wm8400-regulator.c
@@ -320,7 +320,7 @@ static int __devinit wm8400_regulator_pr
 	struct regulator_dev *rdev;
 
 	rdev = regulator_register(&regulators[pdev->id], &pdev->dev,
-		pdev->dev.platform_data, pdev->dev.driver_data);
+		pdev->dev.platform_data, dev_get_drvdata(&pdev->dev));
 
 	if (IS_ERR(rdev))
 		return PTR_ERR(rdev);
@@ -359,7 +359,7 @@ static struct platform_driver wm8400_reg
 int wm8400_register_regulator(struct device *dev, int reg,
 			      struct regulator_init_data *initdata)
 {
-	struct wm8400 *wm8400 = dev->driver_data;
+	struct wm8400 *wm8400 = dev_get_drvdata(dev);
 
 	if (wm8400->regulators[reg].name)
 		return -EBUSY;
@@ -369,8 +369,8 @@ int wm8400_register_regulator(struct dev
 	wm8400->regulators[reg].name = "wm8400-regulator";
 	wm8400->regulators[reg].id = reg;
 	wm8400->regulators[reg].dev.parent = dev;
-	wm8400->regulators[reg].dev.driver_data = wm8400;
 	wm8400->regulators[reg].dev.platform_data = initdata;
+	dev_set_drvdata(&wm8400->regulators[reg].dev, wm8400);
 
 	return platform_device_register(&wm8400->regulators[reg]);
 }
