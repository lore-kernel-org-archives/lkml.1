Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933395Ab0BDRWh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:22:37 -0500
Received: from kroah.org ([198.145.64.141]:34776 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933286Ab0BDRWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:22:03 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:15:10 2010
Message-Id: <20100204171510.412866368@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:12:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [39/74] regulator: Specify REGULATOR_CHANGE_STATUS for WM835x LED constraints
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit a2fad9bf26a1d44a8d31a5c4528108a2b9f468ab upstream.

The WM8350 LED driver needs to be able to enable and disable the
regulators it is using. Previously the core wasn't properly enforcing
status change constraints so the driver was able to function but this
has always been intended to be required.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/regulator/wm8350-regulator.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/regulator/wm8350-regulator.c
+++ b/drivers/regulator/wm8350-regulator.c
@@ -1504,7 +1504,8 @@ int wm8350_register_led(struct wm8350 *w
 	led->isink_init.consumer_supplies = &led->isink_consumer;
 	led->isink_init.constraints.min_uA = 0;
 	led->isink_init.constraints.max_uA = pdata->max_uA;
-	led->isink_init.constraints.valid_ops_mask = REGULATOR_CHANGE_CURRENT;
+	led->isink_init.constraints.valid_ops_mask
+		= REGULATOR_CHANGE_CURRENT | REGULATOR_CHANGE_STATUS;
 	led->isink_init.constraints.valid_modes_mask = REGULATOR_MODE_NORMAL;
 	ret = wm8350_register_regulator(wm8350, isink, &led->isink_init);
 	if (ret != 0) {
@@ -1517,6 +1518,7 @@ int wm8350_register_led(struct wm8350 *w
 	led->dcdc_init.num_consumer_supplies = 1;
 	led->dcdc_init.consumer_supplies = &led->dcdc_consumer;
 	led->dcdc_init.constraints.valid_modes_mask = REGULATOR_MODE_NORMAL;
+	led->dcdc_init.constraints.valid_ops_mask =  REGULATOR_CHANGE_STATUS;
 	ret = wm8350_register_regulator(wm8350, dcdc, &led->dcdc_init);
 	if (ret != 0) {
 		platform_device_put(pdev);


