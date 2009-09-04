Return-Path: <linux-kernel-owner+w=401wt.eu-S1757239AbZIDTRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239AbZIDTRV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 15:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757180AbZIDTRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 15:17:19 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58076 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109AbZIDTRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 15:17:18 -0400
Date: Fri, 4 Sep 2009 21:16:36 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Marek Vasut <marek.vasut@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de, armlinux@phytec.de
Subject: [PATCH] linux-next: fix pxa2xx-ac97.c breakage
Message-ID: <20090904191635.GI29655@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 21:11:38 up 30 days,  6:30,  6 users,  load average: 3.19, 3.28,
	2.86
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's linux-next fails to build with

  sound/arm/pxa2xx-ac97.c: In function 'pxa2xx_ac97_probe':
  sound/arm/pxa2xx-ac97.c:211: error: 'pxa2xx_audio_ops_t' has no member named 'codec_data'
  make[2]: *** [sound/arm/pxa2xx-ac97.o] Error 1

It looks like commit e2365bf313fb21b49b1e4c911033389564428d03 has
introduced this; patch below.

Signed-off-by: Robert Schwebel <r.schwebel@pengutronix.de>
---
 sound/arm/pxa2xx-ac97.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/arm/pxa2xx-ac97.c b/sound/arm/pxa2xx-ac97.c
index 3983aee..b4b48af 100644
--- a/sound/arm/pxa2xx-ac97.c
+++ b/sound/arm/pxa2xx-ac97.c
@@ -208,7 +208,7 @@ static int __devinit pxa2xx_ac97_probe(struct platform_device *dev)
 	snprintf(card->longname, sizeof(card->longname),
 		 "%s (%s)", dev->dev.driver->name, card->mixername);
 
-	if (pdata && pdata->codec_data[0])
+	if (pdata && pdata->codec_pdata[0])
 		snd_ac97_dev_add_pdata(ac97_bus->codec[0], pdata->codec_pdata[0]);
 	snd_card_set_dev(card, &dev->dev);
 	ret = snd_card_register(card);
-- 
1.5.6.5

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
