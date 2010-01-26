Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240Ab0AZXqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab0AZXqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:46:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754941Ab0AZXoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:44:23 -0500
Received: from kroah.org ([198.145.64.141]:35496 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754924Ab0AZXoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:44:15 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:31 2010
Message-Id: <20100126233931.752971578@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:49 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [83/98] ASoC: fix a memory-leak in wm8903
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

commit 40aa7030e5213a43e9e0554fd7f95534ea310bf3 upstream.

Remember to free the temporary register-cache.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/wm8903.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/soc/codecs/wm8903.c
+++ b/sound/soc/codecs/wm8903.c
@@ -1506,7 +1506,7 @@ static int wm8903_resume(struct platform
 	struct i2c_client *i2c = codec->control_data;
 	int i;
 	u16 *reg_cache = codec->reg_cache;
-	u16 *tmp_cache = kmemdup(codec->reg_cache, sizeof(wm8903_reg_defaults),
+	u16 *tmp_cache = kmemdup(reg_cache, sizeof(wm8903_reg_defaults),
 				 GFP_KERNEL);
 
 	/* Bring the codec back up to standby first to minimise pop/clicks */
@@ -1518,6 +1518,7 @@ static int wm8903_resume(struct platform
 		for (i = 2; i < ARRAY_SIZE(wm8903_reg_defaults); i++)
 			if (tmp_cache[i] != reg_cache[i])
 				snd_soc_write(codec, i, tmp_cache[i]);
+		kfree(tmp_cache);
 	} else {
 		dev_err(&i2c->dev, "Failed to allocate temporary cache\n");
 	}


