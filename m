Return-Path: <linux-kernel-owner+w=401wt.eu-S1763057AbZCXQ1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763057AbZCXQ1a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 12:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932085AbZCXQZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 12:25:36 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56014 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762949AbZCXQZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 12:25:32 -0400
From: Luotao Fu <l.fu@pengutronix.de>
To: alsa-devel@alsa-project.org
Cc: dbaryshkov@gmail.com, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com,
       Luotao Fu <l.fu@pengutronix.de>
Subject: [RESEND] [PATCH] pxa2xx-ac97: fix displaying GSR after reset timeout
Date: Tue, 24 Mar 2009 17:25:28 +0100
Message-Id: <1237911929-29895-1-git-send-email-l.fu@pengutronix.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <gq8unj$6og$1@ger.gmane.org>
References: <gq8unj$6og$1@ger.gmane.org>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the variable gsr_bit is set in isr. It is however set to 0 and interrupts are
disabled prior to reset on pxa27x and pxa3xx. Hence it doesn't make a lot of
sense to show the content of gsr_bit in case of a reset timeout.

Signed-off-by: Luotao Fu <l.fu@pengutronix.de>
---
 sound/arm/pxa2xx-ac97-lib.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/arm/pxa2xx-ac97-lib.c b/sound/arm/pxa2xx-ac97-lib.c
index 35afd0c..25933ba 100644
--- a/sound/arm/pxa2xx-ac97-lib.c
+++ b/sound/arm/pxa2xx-ac97-lib.c
@@ -218,7 +218,7 @@ bool pxa2xx_ac97_try_warm_reset(struct snd_ac97 *ac97)
 
 	if (!((GSR | gsr_bits) & (GSR_PCR | GSR_SCR))) {
 		printk(KERN_INFO "%s: warm reset timeout (GSR=%#lx)\n",
-				 __func__, gsr_bits);
+				 __func__, GSR | gsr_bits);
 
 		return false;
 	}
@@ -248,7 +248,7 @@ bool pxa2xx_ac97_try_cold_reset(struct snd_ac97 *ac97)
 
 	if (!((GSR | gsr_bits) & (GSR_PCR | GSR_SCR))) {
 		printk(KERN_INFO "%s: cold reset timeout (GSR=%#lx)\n",
-				 __func__, gsr_bits);
+				 __func__, GSR | gsr_bits);
 
 		return false;
 	}
-- 
1.5.6.5

