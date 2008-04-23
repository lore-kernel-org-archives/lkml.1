Return-Path: <linux-kernel-owner+w=401wt.eu-S1755255AbYDWVtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbYDWVtY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 17:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751434AbYDWVtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 17:49:16 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:44486 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbYDWVtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 17:49:15 -0400
Message-ID: <480FAED6.7080407@tiscali.nl>
Date: Wed, 23 Apr 2008 23:49:10 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: rmk@arm.linux.org.uk, Linux-arm <linux-arm-kernel@lists.arm.linux.org.uk>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] ARM: ax88796: platform_get_irq() may return signed unnoticed
References: <480FADA3.7030708@tiscali.nl>
In-Reply-To: <480FADA3.7030708@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

similarly,
---
dev->irq is unsigned, platform_get_irq() may return signed unnoticed

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/net/ax88796.c b/drivers/net/ax88796.c
index 194949a..26a735a 100644
--- a/drivers/net/ax88796.c
+++ b/drivers/net/ax88796.c
@@ -838,10 +838,10 @@ static int ax_probe(struct platform_device *pdev)
 
 	/* find the platform resources */
 
-	dev->irq  = platform_get_irq(pdev, 0);
-	if (dev->irq < 0) {
+	ret  = platform_get_irq(pdev, 0);
+	dev->irq = ret;
+	if (ret < 0) {
 		dev_err(&pdev->dev, "no IRQ specified\n");
-		ret = -ENXIO;
 		goto exit_mem;
 	}
 

