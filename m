Return-Path: <linux-kernel-owner+w=401wt.eu-S1754869AbZAZTX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbZAZTX5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 14:23:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbZAZTXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 14:23:23 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57457 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753288AbZAZTXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 14:23:22 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] mfd: Ensure all WM8350 IRQs are masked at startup
Date: Mon, 26 Jan 2009 19:23:19 +0000
Message-Id: <1232997799-18943-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1232997799-18943-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1232997799-18943-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IRQs might have been left enabled in hardware, generating spurious
IRQs before the drivers have registered.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8350-core.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
index 908284c..3024aa2 100644
--- a/drivers/mfd/wm8350-core.c
+++ b/drivers/mfd/wm8350-core.c
@@ -1419,6 +1419,13 @@ int wm8350_device_init(struct wm8350 *wm8350, int irq,
 		return ret;
 	}
 
+	wm8350_reg_write(wm8350, WM8350_SYSTEM_INTERRUPTS_MASK, 0xFFFF);
+	wm8350_reg_write(wm8350, WM8350_INT_STATUS_1_MASK, 0xFFFF);
+	wm8350_reg_write(wm8350, WM8350_INT_STATUS_2_MASK, 0xFFFF);
+	wm8350_reg_write(wm8350, WM8350_UNDER_VOLTAGE_INT_STATUS_MASK, 0xFFFF);
+	wm8350_reg_write(wm8350, WM8350_GPIO_INT_STATUS_MASK, 0xFFFF);
+	wm8350_reg_write(wm8350, WM8350_COMPARATOR_INT_STATUS_MASK, 0xFFFF);
+
 	mutex_init(&wm8350->auxadc_mutex);
 	mutex_init(&wm8350->irq_mutex);
 	INIT_WORK(&wm8350->irq_work, wm8350_irq_worker);
-- 
1.5.6.5

