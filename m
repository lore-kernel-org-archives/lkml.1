Return-Path: <linux-kernel-owner+w=401wt.eu-S1754534AbYDWVdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbYDWVdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 17:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbYDWVc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 17:32:57 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:41299 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbYDWVc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 17:32:56 -0400
Message-ID: <480FAB05.1040107@tiscali.nl>
Date: Wed, 23 Apr 2008 23:32:53 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: pb@handhelds.org, sameo@openedhand.com,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] asic3: platform_get_irq() may return signed unnoticed
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

asic->irq_nr is unsigned. platform_get_irq() may return signed unnoticed

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index f6f2d96..95f7b0c 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -302,7 +302,7 @@ static int asic3_irq_probe(struct platform_device *pdev)
 	unsigned int irq, irq_base;
 
 	asic->irq_nr = platform_get_irq(pdev, 0);
-	if (asic->irq_nr < 0)
+	if (asic->irq_nr == -ENXIO)
 		return asic->irq_nr;
 
 	/* turn on clock to IRQ controller */
