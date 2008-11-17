Return-Path: <linux-kernel-owner+w=401wt.eu-S1755121AbYKQJeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121AbYKQJeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 04:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbYKQJeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 04:34:05 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:33364 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbYKQJeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 04:34:04 -0500
From: "Denis V. Lunev" <den@openvz.org>
To: ben@simtec.co.uk
Cc: linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>
Subject: [PATCH] backlight: value of ILI9320_RGB_IF2 register should not be hardcoded
Date: Mon, 17 Nov 2008 12:33:43 +0300
Message-Id: <1226914423-9613-1-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.5.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is stored in the board specific file
  ./arch/arm/mach-s3c2412/mach-jive.c
as .rgb_if2.

Actually, the value is correct, only semantic is wrong.

Signed-off-by: Denis V. Lunev <den@openvz.org>
---
 drivers/video/backlight/vgg2432a4.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/vgg2432a4.c b/drivers/video/backlight/vgg2432a4.c
index 593c768..8e653b8 100644
--- a/drivers/video/backlight/vgg2432a4.c
+++ b/drivers/video/backlight/vgg2432a4.c
@@ -137,7 +137,7 @@ static int vgg2432a4_lcd_init(struct ili9320 *lcd,
 
 	ili9320_write(lcd, ILI9320_RGB_IF1, cfg->rgb_if1);
 	ili9320_write(lcd, ILI9320_FRAMEMAKER, 0x0);
-	ili9320_write(lcd, ILI9320_RGB_IF2, ILI9320_RGBIF2_DPL);
+	ili9320_write(lcd, ILI9320_RGB_IF2, cfg->rgb_if2);
 
 	ret = ili9320_write_regs(lcd, vgg_init1, ARRAY_SIZE(vgg_init1));
 	if (ret != 0)
-- 
1.5.6.4

