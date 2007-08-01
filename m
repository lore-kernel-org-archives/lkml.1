Return-Path: <linux-kernel-owner+w=401wt.eu-S1759168AbXHAGGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759168AbXHAGGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 02:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbXHAGGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 02:06:07 -0400
Received: from smtp3.hushmail.com ([65.39.178.135]:54318 "EHLO
	smtp3.hushmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbXHAGGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 02:06:06 -0400
Date: Wed, 01 Aug 2007 02:06:06 -0400
To: <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <linux-sound@vger.kernel.org>
Subject: [PATCH 3/3] sound/soc ioremap/iounmap balancing
Reply-to: postfail@hushmail.com
From: "Scott Thompson" <postfail@hushmail.com>
Content-type: text/plain; charset="UTF-8"
Message-Id: <20070801060606.BB9C3DA82E@mailserver8.hushmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ioremap / iounmap balancing in sound/soc tree

Signed-off-by: Scott Thompson <postfail <at> hushmail.com>
---
diff --git a/sound/soc/s3c24xx/s3c24xx-i2s.c 
b/sound/soc/s3c24xx/s3c24xx-i2s.c
index 39f0246..cd89c41 100644
--- a/sound/soc/s3c24xx/s3c24xx-i2s.c
+++ b/sound/soc/s3c24xx/s3c24xx-i2s.c
@@ -385,6 +385,7 @@ static int s3c24xx_i2s_probe(struct 
platform_device *pdev)
 	s3c24xx_i2s.iis_clk=clk_get(&pdev->dev, "iis");
 	if (s3c24xx_i2s.iis_clk == NULL) {
 		DBG("failed to get iis_clock\n");
+		iounmap(s3c24xx_i2s.regs);
 		return -ENODEV;
 	}
 	clk_enable(s3c24xx_i2s.iis_clk);

--
Start providing for your family by becoming a paralegal. Click Now.
http://tagline.hushmail.com/fc/Ioyw6h4ek5ocrsblBGe95tDruAMchCwVmpqjJUiDSVabB25GwhAcU8/


