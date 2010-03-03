Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab0CCLzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 06:55:19 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:19266 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab0CCLzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 06:55:17 -0500
MIME-Version: 1.0
X-Originating-IP: [87.194.181.195]
Date: Wed, 3 Mar 2010 11:55:15 +0000
Message-ID: <6a4b170b1003030355p44dd277fpedae0da7a76ed739@mail.gmail.com>
Subject: [PATCH] rtc-coh901331: Fix braces in resume code.
From: James Hogan <james@albanarts.com>
To: Alessandro Zummo <a.zummo@towertech.it>,
       Paul Gortmaker <p_gortmaker@yahoo.com>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>, rtc-linux@googlegroups.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The else part of the if statement is indented but does not have braces
around it. It clearly should since it uses clk_enable and clk_disable
which are supposed to balance.

Signed-off-by: James Hogan <james@albanarts.com>
---
 drivers/rtc/rtc-coh901331.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-coh901331.c b/drivers/rtc/rtc-coh901331.c
index 03ea530..44c4399 100644
--- a/drivers/rtc/rtc-coh901331.c
+++ b/drivers/rtc/rtc-coh901331.c
@@ -271,12 +271,13 @@ static int coh901331_resume(struct platform_device *pdev)
 {
 	struct coh901331_port *rtap = dev_get_drvdata(&pdev->dev);

-	if (device_may_wakeup(&pdev->dev))
+	if (device_may_wakeup(&pdev->dev)) {
 		disable_irq_wake(rtap->irq);
-	else
+	} else {
 		clk_enable(rtap->clk);
 		writel(rtap->irqmaskstore, rtap->virtbase + COH901331_IRQ_MASK);
 		clk_disable(rtap->clk);
+	}
 	return 0;
 }
 #else
-- 
1.5.5.6
