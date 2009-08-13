Return-Path: <linux-kernel-owner+w=401wt.eu-S1754004AbZHMJuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbZHMJuK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 05:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753760AbZHMJuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 05:50:09 -0400
Received: from mail.df.lth.se ([194.47.250.12]:55443 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753781AbZHMJuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 05:50:06 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 4/5] MFD AB3100 disable irq nosync
Date: Thu, 13 Aug 2009 11:50:01 +0200
Message-Id: <1250157001-9645-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will make the worker fire interrupt disable the AB3100 IRQ
without sync which resolves a race since the interrupt obviously
cannot wait for itself to complete while being handled.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/mfd/ab3100-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/ab3100-core.c b/drivers/mfd/ab3100-core.c
index 630c925..16675f7 100644
--- a/drivers/mfd/ab3100-core.c
+++ b/drivers/mfd/ab3100-core.c
@@ -422,7 +422,7 @@ static irqreturn_t ab3100_irq_handler(int irq, void *data)
 	 * stuff and we will re-enable the interrupts once th
 	 * worker has finished.
 	 */
-	disable_irq(ab3100->i2c_client->irq);
+	disable_irq_nosync(irq);
 	schedule_work(&ab3100->work);
 	return IRQ_HANDLED;
 }
-- 
1.6.2.1

