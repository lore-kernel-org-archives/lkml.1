Return-Path: <linux-kernel-owner+w=401wt.eu-S1762903AbZBYQYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762903AbZBYQYB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 11:24:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755475AbZBYQXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 11:23:39 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43057 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752960AbZBYQXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 11:23:38 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] mfd: Use the value of the final spin when reading the AUXADC
Date: Wed, 25 Feb 2009 16:23:35 +0000
Message-Id: <1235579015-16193-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1235579015-16193-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1235579015-16193-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8350-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
index a285cc0..c2be308 100644
--- a/drivers/mfd/wm8350-core.c
+++ b/drivers/mfd/wm8350-core.c
@@ -1111,7 +1111,7 @@ int wm8350_read_auxadc(struct wm8350 *wm8350, int channel, int scale, int vref)
 	do {
 		schedule_timeout_interruptible(1);
 		reg = wm8350_reg_read(wm8350, WM8350_DIGITISER_CONTROL_1);
-	} while (--tries && (reg & WM8350_AUXADC_POLL));
+	} while ((reg & WM8350_AUXADC_POLL) && --tries);
 
 	if (!tries)
 		dev_err(wm8350->dev, "adc chn %d read timeout\n", channel);
-- 
1.6.1.3

