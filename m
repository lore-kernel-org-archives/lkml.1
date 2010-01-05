Return-Path: <linux-kernel-owner+w=401wt.eu-S1754400Ab0AEN7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab0AEN7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 08:59:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754355Ab0AEN7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 08:59:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60536 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754358Ab0AEN7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 08:59:33 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Dan Carpenter <error27@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/4] mfd: WM8350 off by one bug
Date: Tue,  5 Jan 2010 13:59:06 +0000
Message-Id: <1262699949-3079-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.5.7
In-Reply-To: <20100105135756.GA2993@rakim.wolfsonmicro.main>
References: <20100105135756.GA2993@rakim.wolfsonmicro.main>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

If irq == WM8350_NUM_IRQ that would put us past the end of the array.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8350-irq.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/wm8350-irq.c b/drivers/mfd/wm8350-irq.c
index c8df547..9025f29 100644
--- a/drivers/mfd/wm8350-irq.c
+++ b/drivers/mfd/wm8350-irq.c
@@ -434,7 +434,7 @@ int wm8350_register_irq(struct wm8350 *wm8350, int irq,
 			irq_handler_t handler, unsigned long flags,
 			const char *name, void *data)
 {
-	if (irq < 0 || irq > WM8350_NUM_IRQ || !handler)
+	if (irq < 0 || irq >= WM8350_NUM_IRQ || !handler)
 		return -EINVAL;
 
 	if (wm8350->irq[irq].handler)
@@ -453,7 +453,7 @@ EXPORT_SYMBOL_GPL(wm8350_register_irq);
 
 int wm8350_free_irq(struct wm8350 *wm8350, int irq)
 {
-	if (irq < 0 || irq > WM8350_NUM_IRQ)
+	if (irq < 0 || irq >= WM8350_NUM_IRQ)
 		return -EINVAL;
 
 	wm8350_mask_irq(wm8350, irq);
-- 
1.6.5.7

