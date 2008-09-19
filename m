Return-Path: <linux-kernel-owner+w=401wt.eu-S1754748AbYISQvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbYISQvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 12:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbYISQvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 12:51:08 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:36951 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbYISQvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 12:51:07 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: liam.girdwood@wolfsonmicro.com, broonie@opensource.wolfsonmicro.com
Cc: linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH] ASoC: Fix at32-pcm build breakage with PM enabled
Date: Fri, 19 Sep 2008 18:50:45 +0200
Message-Id: <1221843045-18093-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.6.5
X-OriginalArrivalTime: 19 Sep 2008 16:50:35.0674 (UTC) FILETIME=[D65ED7A0:01C91A77]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s/PDC_PTCR/ATMEL_PDC_PTCR/

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 sound/soc/at32/at32-pcm.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/at32/at32-pcm.c b/sound/soc/at32/at32-pcm.c
index 435f1da..c83584f 100644
--- a/sound/soc/at32/at32-pcm.c
+++ b/sound/soc/at32/at32-pcm.c
@@ -434,7 +434,8 @@ static int at32_pcm_suspend(struct platform_device *pdev,
 	params = prtd->params;
 
 	/* Disable the PDC and save the PDC registers */
-	ssc_writex(params->ssc->regs, PDC_PTCR, params->mask->pdc_disable);
+	ssc_writex(params->ssc->regs, ATMEL_PDC_PTCR,
+		   params->mask->pdc_disable);
 
 	prtd->pdc_xpr_save = ssc_readx(params->ssc->regs, params->pdc->xpr);
 	prtd->pdc_xcr_save = ssc_readx(params->ssc->regs, params->pdc->xcr);
@@ -464,7 +465,7 @@ static int at32_pcm_resume(struct platform_device *pdev,
 	ssc_writex(params->ssc->regs, params->pdc->xnpr, prtd->pdc_xnpr_save);
 	ssc_writex(params->ssc->regs, params->pdc->xncr, prtd->pdc_xncr_save);
 
-	ssc_writex(params->ssc->regs, PDC_PTCR, params->mask->pdc_enable);
+	ssc_writex(params->ssc->regs, ATMEL_PDC_PTCR, params->mask->pdc_enable);
 	return 0;
 }
 #else /* CONFIG_PM */
-- 
1.5.6.5

