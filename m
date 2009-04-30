Return-Path: <linux-kernel-owner+w=401wt.eu-S1762654AbZD3W3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762654AbZD3W3s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 18:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbZD3W3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 18:29:36 -0400
Received: from kroah.org ([198.145.64.141]:55443 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbZD3W3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 18:29:35 -0400
Date: Thu, 30 Apr 2009 15:18:50 -0700
From: Greg Kroah-Hartman <gregkh@suse.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: [PATCH] mfd: remove driver_data direct access of struct device
Message-ID: <20090430221850.GA18541@kroah.com>
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

Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mfd/htc-pasic3.c    |    4 ++--
 drivers/mfd/pcf50633-core.c |    2 +-
 drivers/mfd/wm8400-core.c   |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

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
@@ -50,7 +50,7 @@ EXPORT_SYMBOL(pasic3_write_register); /*
  */
 u8 pasic3_read_register(struct device *dev, u32 reg)
 {
-	struct pasic3_data *asic = dev->driver_data;
+	struct pasic3_data *asic = dev_get_drvdata(dev);
 	int bus_shift = asic->bus_shift;
 	void __iomem *addr = asic->mapping + (REG_ADDR << bus_shift);
 	void __iomem *data = asic->mapping + (REG_DATA << bus_shift);
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -618,7 +618,7 @@ static int __devinit pcf50633_probe(stru
 
 		pdev->dev.parent = pcf->dev;
 		pdev->dev.platform_data = &pdata->reg_init_data[i];
-		pdev->dev.driver_data = pcf;
+		dev_set_drvdata(&pdev->dev, pcf);
 		pcf->regulator_pdev[i] = pdev;
 
 		platform_device_add(pdev);
--- a/drivers/mfd/wm8400-core.c
+++ b/drivers/mfd/wm8400-core.c
@@ -265,7 +265,7 @@ static int wm8400_init(struct wm8400 *wm
 
 	mutex_init(&wm8400->io_lock);
 
-	wm8400->dev->driver_data = wm8400;
+	dev_set_drvdata(wm8400->dev, wm8400);
 
 	/* Check that this is actually a WM8400 */
 	ret = wm8400->read_dev(wm8400->io_data, WM8400_RESET_ID, 1, &reg);
