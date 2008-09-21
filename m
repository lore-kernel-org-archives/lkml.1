Return-Path: <linux-kernel-owner+w=401wt.eu-S1754005AbYIUVwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbYIUVwf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 17:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752958AbYIUVwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 17:52:14 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:58158 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752830AbYIUVwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 17:52:13 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@strlen.de>
To: linux-kernel@vger.kernel.org
Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH] Use platform_driver_probe for pdc platform driver
Date: Sun, 21 Sep 2008 23:52:08 +0200
Message-Id: <1222033928-25062-2-git-send-email-ukleinek@strlen.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1222033928-25062-1-git-send-email-ukleinek@strlen.de>
References: <1222033928-25062-1-git-send-email-ukleinek@strlen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The probe function of the pdc platform driver lives in the init section
and so a pdc device that is created after the init section is discarded
probably results in an oops.  Even if this cannot happen, using
platform_driver_probe is cleaner.  (If this can happen and should be
supported the probe function must live in the devinit section instead.)

Signed-off-by: Uwe Kleine-König <ukleinek@strlen.de>
Cc: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

---
 arch/avr32/mach-at32ap/pdc.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/avr32/mach-at32ap/pdc.c b/arch/avr32/mach-at32ap/pdc.c
index 1040bda..61ab15a 100644
--- a/arch/avr32/mach-at32ap/pdc.c
+++ b/arch/avr32/mach-at32ap/pdc.c
@@ -35,7 +35,6 @@ static int __init pdc_probe(struct platform_device *pdev)
 }
 
 static struct platform_driver pdc_driver = {
-	.probe		= pdc_probe,
 	.driver		= {
 		.name	= "pdc",
 	},
@@ -43,6 +42,6 @@ static struct platform_driver pdc_driver = {
 
 static int __init pdc_init(void)
 {
-	return platform_driver_register(&pdc_driver);
+	return platform_driver_probe(&pdc_driver, pdc_probe);
 }
 arch_initcall(pdc_init);
-- 
tg: (639920b..) t/sectionfixes/pdc (depends on: t/sectionfixes/pio)
