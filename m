Return-Path: <linux-kernel-owner+w=401wt.eu-S1753551AbYIUVwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbYIUVwW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 17:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbYIUVwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 17:52:14 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:58156 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752724AbYIUVwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 17:52:13 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@strlen.de>
To: linux-kernel@vger.kernel.org
Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH] Use platform_driver_probe for pio platform driver
Date: Sun, 21 Sep 2008 23:52:07 +0200
Message-Id: <1222033928-25062-1-git-send-email-ukleinek@strlen.de>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The probe function of the pio platform driver lives in the init section
and so a pio device that is created after the init section is discarded
probably results in an oops.  Even if this cannot happen, using
platform_driver_probe is cleaner.  (If this can happen and should be
supported the probe function must live in the devinit section instead.)

Signed-off-by: Uwe Kleine-König <ukleinek@strlen.de>
Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

---
 arch/avr32/mach-at32ap/pio.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/avr32/mach-at32ap/pio.c b/arch/avr32/mach-at32ap/pio.c
index 405ee6b..96a6d5d 100644
--- a/arch/avr32/mach-at32ap/pio.c
+++ b/arch/avr32/mach-at32ap/pio.c
@@ -382,7 +382,6 @@ static int __init pio_probe(struct platform_device *pdev)
 }
 
 static struct platform_driver pio_driver = {
-	.probe		= pio_probe,
 	.driver		= {
 		.name		= "pio",
 	},
@@ -390,7 +389,7 @@ static struct platform_driver pio_driver = {
 
 static int __init pio_init(void)
 {
-	return platform_driver_register(&pio_driver);
+	return platform_driver_probe(&pio_driver, pio_probe);
 }
 postcore_initcall(pio_init);
 
-- 
tg: (852b98c..) t/sectionfixes/pio (depends on: t/sectionfixes/h1940bt)
