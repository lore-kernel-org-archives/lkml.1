Return-Path: <linux-kernel-owner+w=401wt.eu-S937381AbZFPGHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937381AbZFPGHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 02:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935919AbZFPFvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:51:35 -0400
Received: from kroah.org ([198.145.64.141]:48425 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935901AbZFPFva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:30 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 44/64] mfd: remove driver_data direct access of struct device
Date: Mon, 15 Jun 2009 22:46:33 -0700
Message-Id: <1245131213-24168-44-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the near future, the driver core is going to not allow direct access
to the driver_data pointer in struct device.  Instead, the functions
dev_get_drvdata() and dev_set_drvdata() should be used.  These functions
have been around since the beginning, so are backwards compatible with
all older kernel versions.

Cc: Samuel Ortiz <sameo@linux.intel.com>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/mfd/htc-pasic3.c    |    4 ++--
 drivers/mfd/pcf50633-core.c |    2 +-
 drivers/mfd/wm8400-core.c   |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/htc-pasic3.c b/drivers/mfd/htc-pasic3.c
index 386da15..cb73051 100644
--- a/drivers/mfd/htc-pasic3.c
+++ b/drivers/mfd/htc-pasic3.c
@@ -35,7 +35,7 @@ struct pasic3_data {
  */
 void pasic3_write_register(struct device *dev, u32 reg, u8 val)
 {
-	struct pasic3_data *asic = dev->driver_data;
+	struct pasic3_data *asic = dev_get_drvdata(dev);
 	int bus_shift = asic->bus_shift;
 	void __iomem *addr = asic->mapping + (REG_ADDR << bus_shift);
 	void __iomem *data = asic->mapping + (REG_DATA << bus_shift);
@@ -50,7 +50,7 @@ EXPORT_SYMBOL(pasic3_write_register); /* for leds-pasic3 */
  */
 u8 pasic3_read_register(struct device *dev, u32 reg)
 {
-	struct pasic3_data *asic = dev->driver_data;
+	struct pasic3_data *asic = dev_get_drvdata(dev);
 	int bus_shift = asic->bus_shift;
 	void __iomem *addr = asic->mapping + (REG_ADDR << bus_shift);
 	void __iomem *data = asic->mapping + (REG_DATA << bus_shift);
diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
index 11a6248..082c197 100644
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -618,7 +618,7 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 
 		pdev->dev.parent = pcf->dev;
 		pdev->dev.platform_data = &pdata->reg_init_data[i];
-		pdev->dev.driver_data = pcf;
+		dev_set_drvdata(&pdev->dev, pcf);
 		pcf->regulator_pdev[i] = pdev;
 
 		platform_device_add(pdev);
diff --git a/drivers/mfd/wm8400-core.c b/drivers/mfd/wm8400-core.c
index cf30d06..7c21bf7 100644
--- a/drivers/mfd/wm8400-core.c
+++ b/drivers/mfd/wm8400-core.c
@@ -265,7 +265,7 @@ static int wm8400_init(struct wm8400 *wm8400,
 
 	mutex_init(&wm8400->io_lock);
 
-	wm8400->dev->driver_data = wm8400;
+	dev_set_drvdata(wm8400->dev, wm8400);
 
 	/* Check that this is actually a WM8400 */
 	ret = wm8400->read_dev(wm8400->io_data, WM8400_RESET_ID, 1, &reg);
-- 
1.6.3.2

