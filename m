Return-Path: <linux-kernel-owner+w=401wt.eu-S1767046AbXDEPSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767046AbXDEPSJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 11:18:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767048AbXDEPSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 11:18:09 -0400
Received: from nlpi043.sbcis.sbc.com ([207.115.36.72]:26589 "EHLO
	nlpi043.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767046AbXDEPSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 11:18:07 -0400
X-ORBL: [67.117.73.34]
Date: Thu, 5 Apr 2007 11:17:05 -0400
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 55/90] ARM: OMAP: H3 workqueue fixes
Message-ID: <20070405151703.GK24297@atomide.com>
References: <1175710093864-git-send-email-tony@atomide.com> <11757100952384-git-send-email-tony@atomide.com> <11757100982726-git-send-email-tony@atomide.com> <11757101012787-git-send-email-tony@atomide.com> <1175710103340-git-send-email-tony@atomide.com> <11757101072553-git-send-email-tony@atomide.com> <11757101101180-git-send-email-tony@atomide.com> <11757101123620-git-send-email-tony@atomide.com> <11757101141643-git-send-email-tony@atomide.com> <11757101164151-git-send-email-tony@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Cgrdyab2wu3Akvjd"
Content-Disposition: inline
In-Reply-To: <11757101164151-git-send-email-tony@atomide.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--Cgrdyab2wu3Akvjd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

* Tony Lindgren <tony@atomide.com> [070404 14:11]:
> From: Dirk Behme <dirk.behme_at_gmail.com>
> 
> Signed-off-by: Dirk Behme <dirk.behme_at_gmail.com>
> Signed-off-by: Tony Lindgren <tony@atomide.com>

Here's a version with fixed email address.

Tony


--Cgrdyab2wu3Akvjd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0055-ARM-OMAP-H3-workqueue-fixes.txt"

>From 455670d5c9a7b5a81a78c82a5cb0f3081ffdb01c Mon Sep 17 00:00:00 2001
From: Dirk Behme <dirk.behme@gmail.com>
Date: Thu, 25 Jan 2007 16:26:46 -0800
Subject: [PATCH 55/90] ARM: OMAP: H3 workqueue fixes

Signed-off-by: Dirk Behme <dirk.behme@gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/board-h3.c   |   12 +++++++-----
 include/asm-arm/arch-omap/irda.h |    1 +
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-omap1/board-h3.c b/arch/arm/mach-omap1/board-h3.c
index 1ce0ec3..4167f34 100644
--- a/arch/arm/mach-omap1/board-h3.c
+++ b/arch/arm/mach-omap1/board-h3.c
@@ -296,9 +296,11 @@ static int h3_select_irda(struct device *dev, int state)
 	return err;
 }
 
-static void set_trans_mode(void *data)
+static void set_trans_mode(struct work_struct *work)
 {
-	int *mode = data;
+	struct omap_irda_config *irda_config =
+		container_of(work, struct omap_irda_config, gpio_expa.work);
+	int mode = irda_config->mode;
 	unsigned char expa;
 	int err = 0;
 
@@ -308,7 +310,7 @@ static void set_trans_mode(void *data)
 
 	expa &= ~0x03;
 
-	if (*mode & IR_SIRMODE) {
+	if (mode & IR_SIRMODE) {
 		expa |= 0x01;
 	} else { /* MIR/FIR */
 		expa |= 0x03;
@@ -323,9 +325,9 @@ static int h3_transceiver_mode(struct device *dev, int mode)
 {
 	struct omap_irda_config *irda_config = dev->platform_data;
 
+	irda_config->mode = mode;
 	cancel_delayed_work(&irda_config->gpio_expa);
-	PREPARE_WORK(&irda_config->gpio_expa, set_trans_mode, &mode);
-#error this is not permitted - mode is an argument variable
+	PREPARE_DELAYED_WORK(&irda_config->gpio_expa, set_trans_mode);
 	schedule_delayed_work(&irda_config->gpio_expa, 0);
 
 	return 0;
diff --git a/include/asm-arm/arch-omap/irda.h b/include/asm-arm/arch-omap/irda.h
index 345a649..96bb12f 100644
--- a/include/asm-arm/arch-omap/irda.h
+++ b/include/asm-arm/arch-omap/irda.h
@@ -31,6 +31,7 @@ struct omap_irda_config {
 	unsigned long src_start;
 	int tx_trigger;
 	int rx_trigger;
+	int mode;
 };
 
 #endif
-- 
1.4.4.2


--Cgrdyab2wu3Akvjd--
