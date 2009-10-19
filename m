Return-Path: <linux-kernel-owner+w=401wt.eu-S1754570AbZJSKHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbZJSKHQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 06:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbZJSKHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 06:07:15 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36925 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750758AbZJSKHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 06:07:14 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2.6.32] mfd: Always initialise WM831x IRQ mutex
Date: Mon, 19 Oct 2009 11:07:05 +0100
Message-Id: <1255946825-9569-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This avoids crashes when running without interrupt support.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-irq.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/wm831x-irq.c b/drivers/mfd/wm831x-irq.c
index d3015df..ac056ea 100644
--- a/drivers/mfd/wm831x-irq.c
+++ b/drivers/mfd/wm831x-irq.c
@@ -507,6 +507,8 @@ int wm831x_irq_init(struct wm831x *wm831x, int irq)
 {
 	int i, ret;
 
+	mutex_init(&wm831x->irq_lock);
+
 	if (!irq) {
 		dev_warn(wm831x->dev,
 			 "No interrupt specified - functionality limited\n");
@@ -521,7 +523,6 @@ int wm831x_irq_init(struct wm831x *wm831x, int irq)
 	}
 
 	wm831x->irq = irq;
-	mutex_init(&wm831x->irq_lock);
 	INIT_WORK(&wm831x->irq_work, wm831x_irq_worker);
 
 	/* Mask the individual interrupt sources */
-- 
1.6.5

