Return-Path: <linux-kernel-owner+w=401wt.eu-S1758256AbZEKT5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256AbZEKT5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 15:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753807AbZEKT5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 15:57:09 -0400
Received: from mail-ew0-f224.google.com ([209.85.219.224]:40086 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbZEKT5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 15:57:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=CL39xBJ4UAJiUAg+gjynEdQdJjgIxhySiqkGsJCpyTnxQP+NXTo5slsGP0h4wRhYN/
         How/EAsjtqCnoacgrKcMf+O4V52dmCWkOHK/qPjuxppK15DRPDRElYVHw2XEra+Pvqxa
         ilVImk0ZtzsOzBtsWesVYxDaq3jD3q015Ltug=
Message-ID: <4A088314.1000204@gmail.com>
Date: Mon, 11 May 2009 21:57:08 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: lrg@slimlogic.co.uk
CC: alsa-devel@alsa-project.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] soc: remove driver_data direct access of struct device
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/sound/soc/codecs/wm8400.c b/sound/soc/codecs/wm8400.c
index 510efa6..e4547de 100644
--- a/sound/soc/codecs/wm8400.c
+++ b/sound/soc/codecs/wm8400.c
@@ -1473,8 +1473,8 @@ static int wm8400_codec_probe(struct platform_device *dev)
 
 	codec = &priv->codec;
 	codec->private_data = priv;
-	codec->control_data = dev->dev.driver_data;
-	priv->wm8400 = dev->dev.driver_data;
+	codec->control_data = dev_get_drvdata(&dev->dev);
+	priv->wm8400 = dev_get_drvdata(&dev->dev);
 
 	ret = regulator_bulk_get(priv->wm8400->dev,
 				 ARRAY_SIZE(power), &power[0]);
diff --git a/sound/soc/codecs/wm8731.c b/sound/soc/codecs/wm8731.c
index e043e3f..7a20587 100644
--- a/sound/soc/codecs/wm8731.c
+++ b/sound/soc/codecs/wm8731.c
@@ -666,14 +666,14 @@ static int __devinit wm8731_spi_probe(struct spi_device *spi)
 	codec->hw_write = (hw_write_t)wm8731_spi_write;
 	codec->dev = &spi->dev;
 
-	spi->dev.driver_data = wm8731;
+	dev_set_drvdata(&spi->dev, wm8731);
 
 	return wm8731_register(wm8731);
 }
 
 static int __devexit wm8731_spi_remove(struct spi_device *spi)
 {
-	struct wm8731_priv *wm8731 = spi->dev.driver_data;
+	struct wm8731_priv *wm8731 = dev_get_drvdata(&spi->dev);
 
 	wm8731_unregister(wm8731);
 
diff --git a/sound/soc/codecs/wm8753.c b/sound/soc/codecs/wm8753.c
index a6e8f3f..d121e58 100644
--- a/sound/soc/codecs/wm8753.c
+++ b/sound/soc/codecs/wm8753.c
@@ -1822,14 +1822,14 @@ static int __devinit wm8753_spi_probe(struct spi_device *spi)
 	codec->hw_write = (hw_write_t)wm8753_spi_write;
 	codec->dev = &spi->dev;
 
-	spi->dev.driver_data = wm8753;
+	dev_set_drvdata(&spi->dev, wm8753);
 
 	return wm8753_register(wm8753);
 }
 
 static int __devexit wm8753_spi_remove(struct spi_device *spi)
 {
-	struct wm8753_priv *wm8753 = spi->dev.driver_data;
+	struct wm8753_priv *wm8753 = dev_get_drvdata(&spi->dev);
 	wm8753_unregister(wm8753);
 	return 0;
 }
