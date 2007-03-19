Return-Path: <linux-kernel-owner+w=401wt.eu-S1753363AbXCSJ0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbXCSJ0I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 05:26:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753307AbXCSJ0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 05:26:08 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:34843 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753363AbXCSJZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 05:25:38 -0400
Date: Mon, 19 Mar 2007 10:25:41 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Ben Dooks <ben-linux@fluff.org>, Vincent Sanders <vince@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/mfd/sm501.c: fix an off-by-one
Message-ID: <20070319092541.GO752@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes an off-by-one spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.21-rc3-mm2/drivers/mfd/sm501.c.old	2007-03-19 09:09:57.000000000 +0100
+++ linux-2.6.21-rc3-mm2/drivers/mfd/sm501.c	2007-03-19 09:15:12.000000000 +0100
@@ -314,17 +314,17 @@ int sm501_unit_power(struct device *dev,
 	mutex_lock(&sm->clock_lock);
 
 	mode = readl(sm->regs + SM501_POWER_MODE_CONTROL);
 	gate = readl(sm->regs + SM501_CURRENT_GATE);
 	clock = readl(sm->regs + SM501_CURRENT_CLOCK);
 
 	mode &= 3;		/* get current power mode */
 
-	if (unit > ARRAY_SIZE(sm->unit_power)) {
+	if (unit >= ARRAY_SIZE(sm->unit_power)) {
 		dev_err(dev, "%s: bad unit %d\n", __FUNCTION__, unit);
 		goto already;
 	}
 
 	dev_dbg(sm->dev, "%s: unit %d, cur %d, to %d\n", __FUNCTION__, unit,
 		sm->unit_power[unit], to);
 
 	if (to == 0 && sm->unit_power[unit] == 0) {

