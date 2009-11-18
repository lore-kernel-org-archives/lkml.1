Return-Path: <linux-kernel-owner+w=401wt.eu-S1756858AbZKRNG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858AbZKRNG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 08:06:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756638AbZKRNG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 08:06:26 -0500
Received: from mail.atmel.fr ([81.80.104.162]:62731 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753157AbZKRNGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 08:06:25 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: dtor@mail.ru, linux-input@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, avictor.za@gmail.com
Cc: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 1/4] input: atmel_tsadcc: touchscreen rework setting capabilities
Date: Wed, 18 Nov 2009 15:12:12 +0100
Message-Id: <693b9933de6fe9eb7e4401ca56a8f9ab6a966666.1258553002.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tiny patch for setting capabilities using input API function.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/input/touchscreen/atmel_tsadcc.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_tsadcc.c b/drivers/input/touchscreen/atmel_tsadcc.c
index 9c7fce4..5a2af59 100644
--- a/drivers/input/touchscreen/atmel_tsadcc.c
+++ b/drivers/input/touchscreen/atmel_tsadcc.c
@@ -242,12 +242,12 @@ static int __devinit atmel_tsadcc_probe(struct platform_device *pdev)
 	input_dev->phys = ts_dev->phys;
 	input_dev->dev.parent = &pdev->dev;
 
-	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
-	input_dev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
-
+	__set_bit(EV_ABS, input_dev->evbit);
 	input_set_abs_params(input_dev, ABS_X, 0, 0x3FF, 0, 0);
 	input_set_abs_params(input_dev, ABS_Y, 0, 0x3FF, 0, 0);
 
+	input_set_capability(input_dev, EV_KEY, BTN_TOUCH);
+
 	/* clk_enable() always returns 0, no need to check it */
 	clk_enable(ts_dev->clk);
 
-- 
1.5.6.5

