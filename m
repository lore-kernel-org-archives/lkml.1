Return-Path: <linux-kernel-owner+w=401wt.eu-S1754635AbYDWW6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbYDWW6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 18:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605AbYDWW6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 18:58:07 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:43365 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbYDWW6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 18:58:06 -0400
Message-ID: <480FBEFA.3030903@tiscali.nl>
Date: Thu, 24 Apr 2008 00:58:02 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: pb@handhelds.org, sameo@openedhand.com,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] asic3: platform_get_irq() may return signed unnoticed
References: <480FAB05.1040107@tiscali.nl> <480FBA51.8020403@tiscali.nl>
In-Reply-To: <480FBA51.8020403@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to Joe Perches for catching an error in my previous
---
asic->irq_nr is unsigned. platform_get_irq() may return signed unnoticed

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index f6f2d96..abd7ffc 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -300,10 +300,13 @@ static int asic3_irq_probe(struct platform_device *pdev)
 	struct asic3 *asic = platform_get_drvdata(pdev);
 	unsigned long clksel = 0;
 	unsigned int irq, irq_base;
+	int ret;
+
+	ret = platform_get_irq(pdev, 0);
+	if (ret < 0)
+		return ret;
 
-	asic->irq_nr = platform_get_irq(pdev, 0);
-	if (asic->irq_nr < 0)
-		return asic->irq_nr;
+	asic->irq_nr = ret;
 
 	/* turn on clock to IRQ controller */
 	clksel |= CLOCK_SEL_CX;

