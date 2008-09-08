Return-Path: <linux-kernel-owner+w=401wt.eu-S1753900AbYIHMOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbYIHMOA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 08:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbYIHMNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 08:13:52 -0400
Received: from atlas.informatik.uni-freiburg.de ([132.230.150.3]:51074 "EHLO
	atlas.informatik.uni-freiburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752411AbYIHMNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 08:13:52 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<ukleinek@informatik.uni-freiburg.de>
To: linux-kernel@vger.kernel.org
Cc: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<ukleinek@informatik.uni-freiburg.de>
Subject: [PATCH] Fix section for sa11xx-uda1341 platform driver
Date: Mon,  8 Sep 2008 14:13:24 +0200
Message-Id: <1220876004-5784-1-git-send-email-ukleinek@informatik.uni-freiburg.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20080902210501.GA4306@informatik.uni-freiburg.de>
References: <20080902210501.GA4306@informatik.uni-freiburg.de>
Organization: Universitaet Freiburg, Institut f. Informatik
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use __init but __devinit to define probe function.  A pointer to
sa11xx_uda1341_probe is passed to the core via platform_driver_register and
so the function must not disappear after the module is loaded.  Using __init
and having HOTPLUG=y and SND_SA11XX_UDA1341=m the following probably oopses:

	echo -n sa11xx_uda1341.1 > /sys/bus/platform/driver/sa11xx_uda1341/unbind
	echo -n sa11xx_uda1341.1 > /sys/bus/platform/driver/sa11xx_uda1341/bind

Signed-off-by: Uwe Kleine-König <ukleinek@informatik.uni-freiburg.de>

---
 sound/arm/sa11xx-uda1341.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/arm/sa11xx-uda1341.c b/sound/arm/sa11xx-uda1341.c
index b9c51bf..da25b41 100644
--- a/sound/arm/sa11xx-uda1341.c
+++ b/sound/arm/sa11xx-uda1341.c
@@ -879,7 +879,7 @@ void snd_sa11xx_uda1341_free(struct snd_card *card)
 	audio_dma_free(&chip->s[SNDRV_PCM_STREAM_CAPTURE]);
 }
 
-static int __init sa11xx_uda1341_probe(struct platform_device *devptr)
+static int __devinit sa11xx_uda1341_probe(struct platform_device *devptr)
 {
 	int err;
 	struct snd_card *card;
-- 
tg: (7686ad5..) t/sectionfixes/sa11xx_uda1341 (depends on: t/sectionfixes/sa11xx_uda1341)
