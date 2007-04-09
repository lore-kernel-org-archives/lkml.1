Return-Path: <linux-kernel-owner+w=401wt.eu-S965815AbXDIVCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965815AbXDIVCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965828AbXDIVCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:02:34 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:12157 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965815AbXDIVC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:02:29 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <david-b@pacbell.net>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Tony Lindgren <tony@atomide.com>
Subject: [PATCH 9/10] ARM: OMAP: fix OMAP1 mpuio suspend/resume oops
Date: Mon,  9 Apr 2007 17:01:11 -0400
Message-Id: <11761525203526-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11761525172279-git-send-email-tony@atomide.com>
References: <11761524713580-git-send-email-tony@atomide.com> <1176152483689-git-send-email-tony@atomide.com> <11761524911912-git-send-email-tony@atomide.com> <1176152494436-git-send-email-tony@atomide.com> <11761525022200-git-send-email-tony@atomide.com> <11761525051719-git-send-email-tony@atomide.com> <11761525101796-git-send-email-tony@atomide.com> <1176152514395-git-send-email-tony@atomide.com> <11761525172279-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <david-b@pacbell.net>

Fix oops in omap16xx mpuio suspend/resume code; field wasn't initialized

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/plat-omap/gpio.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

--- a/arch/arm/plat-omap/gpio.c
+++ b/arch/arm/plat-omap/gpio.c
@@ -1178,6 +1178,8 @@ static struct platform_device omap_mpuio_device = {
 
 static inline void mpuio_init(void)
 {
+	platform_set_drvdata(&omap_mpuio_device, &gpio_bank_1610[0]);
+
 	if (platform_driver_register(&omap_mpuio_driver) == 0)
 		(void) platform_device_register(&omap_mpuio_device);
 }
-- 
1.4.4.2

