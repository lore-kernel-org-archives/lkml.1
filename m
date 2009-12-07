Return-Path: <linux-kernel-owner+w=401wt.eu-S1758486AbZLGANU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758486AbZLGANU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758502AbZLGANP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:13:15 -0500
Received: from kroah.org ([198.145.64.141]:34437 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758405AbZLGANM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:12 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:49 2009
Message-Id: <20091207000649.746924502@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Anuj Aggarwal <anuj.aggarwal@ti.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [054/119] ASoC: AIC23: Fixing infinite loop in resume path
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=asoc-aic23-fixing-infinite-loop-in-resume-path.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Anuj Aggarwal <anuj.aggarwal@ti.com>

commit e9ff5eb2ae018fe2298c68746c873bf828c6b10e upstream.

This patch fixes two issues:
a) Infinite loop in resume function
b) Writes to non-existing registers in resume function

Signed-off-by: Anuj Aggarwal <anuj.aggarwal@ti.com>
Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/codecs/tlv320aic23.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/sound/soc/codecs/tlv320aic23.c
+++ b/sound/soc/codecs/tlv320aic23.c
@@ -625,11 +625,10 @@ static int tlv320aic23_resume(struct pla
 {
 	struct snd_soc_device *socdev = platform_get_drvdata(pdev);
 	struct snd_soc_codec *codec = socdev->card->codec;
-	int i;
 	u16 reg;
 
 	/* Sync reg_cache with the hardware */
-	for (reg = 0; reg < ARRAY_SIZE(tlv320aic23_reg); i++) {
+	for (reg = 0; reg < TLV320AIC23_RESET; reg++) {
 		u16 val = tlv320aic23_read_reg_cache(codec, reg);
 		tlv320aic23_write(codec, reg, val);
 	}


