Return-Path: <linux-kernel-owner+w=401wt.eu-S1756048AbZBESOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048AbZBESOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 13:14:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760047AbZBESNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 13:13:51 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:2665 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760012AbZBESNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 13:13:50 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu,  5 Feb 2009 18:13:41 +0000
Message-Id: <1233857621-5050-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1233857621-5050-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20090205181235.GA4851@sirena.org.uk>
 <1233857621-5050-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 2/2] mfd: Ensure all WM8350 IRQs are masked at startup
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
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
index d784b3e..c384cd2 100644
--- a/drivers/mfd/wm8350-core.c
+++ b/drivers/mfd/wm8350-core.c
@@ -1422,6 +1422,13 @@ int wm8350_device_init(struct wm8350 *wm8350, int irq,
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

