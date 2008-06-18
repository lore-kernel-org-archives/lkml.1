Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbYFRRcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbYFRRcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 13:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752290AbYFRRci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 13:32:38 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:47976 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbYFRRch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 13:32:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=m+N59OGw/2msojQvwcMmIYZ93CE6KzPAsMPz9wox7GTJOItV8Imr2XvuUOEuutQ9xs
         OVAdEWHaXto1ieBW8SKhnnnMdQiFOcxpQKK+WZFpYISG/DSCIJOnZKpgwWK4DQmfiten
         noLNmZxV+FimU2gLpFX+/SkX+2G+ukXJ/BqAA=
Subject: [PATCH] asic3: move probe functions into __init section
From: Philipp Zabel <philipp.zabel@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@openedhand.com>
Content-Type: text/plain
Date: Wed, 18 Jun 2008 19:32:29 +0200
Message-Id: <1213810349.8144.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Potentially free some memory by moving the _probe functions into __init.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/mfd/asic3.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index ef8a492..7d3488d 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -295,7 +295,7 @@ static struct irq_chip asic3_irq_chip = {
 	.unmask		= asic3_unmask_irq,
 };
 
-static int asic3_irq_probe(struct platform_device *pdev)
+static int __init asic3_irq_probe(struct platform_device *pdev)
 {
 	struct asic3 *asic = platform_get_drvdata(pdev);
 	unsigned long clksel = 0;
@@ -443,7 +443,7 @@ void asic3_gpio_set_value(struct asic3 *asic, unsigned gpio, int val)
 }
 EXPORT_SYMBOL(asic3_gpio_set_value);
 
-static int asic3_gpio_probe(struct platform_device *pdev)
+static int __init asic3_gpio_probe(struct platform_device *pdev)
 {
 	struct asic3_platform_data *pdata = pdev->dev.platform_data;
 	struct asic3 *asic = platform_get_drvdata(pdev);
@@ -482,7 +482,7 @@ static void asic3_gpio_remove(struct platform_device *pdev)
 
 
 /* Core */
-static int asic3_probe(struct platform_device *pdev)
+static int __init asic3_probe(struct platform_device *pdev)
 {
 	struct asic3_platform_data *pdata = pdev->dev.platform_data;
 	struct asic3 *asic;
@@ -573,7 +573,6 @@ static struct platform_driver asic3_device_driver = {
 	.driver		= {
 		.name	= "asic3",
 	},
-	.probe		= asic3_probe,
 	.remove		= __devexit_p(asic3_remove),
 	.shutdown	= asic3_shutdown,
 };
@@ -581,7 +580,7 @@ static struct platform_driver asic3_device_driver = {
 static int __init asic3_init(void)
 {
 	int retval = 0;
-	retval = platform_driver_register(&asic3_device_driver);
+	retval = platform_driver_probe(&asic3_device_driver, asic3_probe);
 	return retval;
 }
 
-- 
1.5.5.4


