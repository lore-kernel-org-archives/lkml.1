Return-Path: <linux-kernel-owner+w=401wt.eu-S934307AbZGQJ23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934307AbZGQJ23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 05:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934293AbZGQJ22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 05:28:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41469 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934280AbZGQJ21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 05:28:27 -0400
Date: Fri, 17 Jul 2009 10:28:25 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Takashi Iwai <tiwai@suse.de>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Barry Song <21cnbao@gmail.com>,
       Greg KH <greg@kroah.com>
Subject: Re: linux-next: sound tree build failure
Message-ID: <20090717092825.GC3439@rakim.wolfsonmicro.main>
References: <20090717112935.2e831eee.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090717112935.2e831eee.sfr@canb.auug.org.au>
X-Cookie: QED.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 17, 2009 at 11:29:35AM +1000, Stephen Rothwell wrote:

> Caused by commit 1274738d85d0e25c4f82d83f50a6bcbe2397e9ea ("ASoC: new
> ad1938 codec driver based on asoc") interacting with commit
> 2e34003ff6237e2216396d61dc8b32ea5959de80 ("Driver core: move
> dev_get/set_drvdata to drivers/base/dd.c") from the driver-core.current
> tree (which will, I assume, be sent to Linus shortly - right, Greg?).

I've fixed this.

> New drivers need to use the (existing) API's dev_{set,get}_drvdata().

Incidentally, is there any great reason not to have the equivalent thing
for platform data?  I can supply a patch.

>From 91a0351b2d1e86f421ee9c95d07136f648d2da06 Mon Sep 17 00:00:00 2001
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Fri, 17 Jul 2009 10:18:14 +0100
Subject: [PATCH] ASoC: Use driverdata accessors in ad1938

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 sound/soc/codecs/ad1938.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/ad1938.c b/sound/soc/codecs/ad1938.c
index 3dc8091..5a7d00c 100644
--- a/sound/soc/codecs/ad1938.c
+++ b/sound/soc/codecs/ad1938.c
@@ -420,14 +420,14 @@ static int __devinit ad1938_spi_probe(struct spi_device *spi)
 	codec->control_data = spi;
 	codec->dev = &spi->dev;
 
-	spi->dev.driver_data = ad1938;
+	dev_set_drvdata(&spi->dev, ad1938);
 
 	return ad1938_register(ad1938);
 }
 
 static int __devexit ad1938_spi_remove(struct spi_device *spi)
 {
-	struct ad1938_priv *ad1938 = spi->dev.driver_data;
+	struct ad1938_priv *ad1938 = dev_get_drvdata(&spi->dev);
 
 	ad1938_unregister(ad1938);
 	return 0;
-- 
1.6.3.3

