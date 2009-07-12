Return-Path: <linux-kernel-owner+w=401wt.eu-S1754998AbZGLWrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998AbZGLWrz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 18:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662AbZGLWqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 18:46:36 -0400
Received: from kroah.org ([198.145.64.141]:33512 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754563AbZGLWqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 18:46:35 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Takashi Iwai <tiwai@suse.de>,
       Jaroslav Kysela <perex@perex.cz>, Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [PATCH 7/9] Sound: remove direct access of driver_data
Date: Sun, 12 Jul 2009 15:46:04 -0700
Message-Id: <1247438766-17266-7-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090712223717.GB16600@kroah.com>
References: <20090712223717.GB16600@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the last in-kernel direct usage of driver_data, replace it with
the proper dev_get/set_drvdata() calls.

Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 sound/soc/codecs/wm8988.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wm8988.c b/sound/soc/codecs/wm8988.c
index c05f718..8c0fdf8 100644
--- a/sound/soc/codecs/wm8988.c
+++ b/sound/soc/codecs/wm8988.c
@@ -1037,14 +1037,14 @@ static int __devinit wm8988_spi_probe(struct spi_device *spi)
 	codec->control_data = spi;
 	codec->dev = &spi->dev;
 
-	spi->dev.driver_data = wm8988;
+	dev_set_drvdata(&spi->dev, wm8988);
 
 	return wm8988_register(wm8988);
 }
 
 static int __devexit wm8988_spi_remove(struct spi_device *spi)
 {
-	struct wm8988_priv *wm8988 = spi->dev.driver_data;
+	struct wm8988_priv *wm8988 = dev_get_drvdata(&spi->dev);
 
 	wm8988_unregister(wm8988);
 
-- 
1.6.3.2

