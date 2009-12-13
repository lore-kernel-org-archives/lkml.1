Return-Path: <linux-kernel-owner+w=401wt.eu-S1752850AbZLMLnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbZLMLnY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 06:43:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752745AbZLMLnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 06:43:21 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:51544 "HELO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752700AbZLMLnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 06:43:17 -0500
Date: Sun, 13 Dec 2009 12:43:15 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 9/9] sound/soc/codecs: Correct code taking the size of a
 pointer
Message-ID: <Pine.LNX.4.64.0912131242570.24267@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

sizeof(codec->reg_cache) is just the size of the pointer.  Elsewhere in the
file, codec->reg_cache is used with sizeof(wm8900_reg_defaults), so the
code is changed to do the same here.

A simplified version of the semantic patch that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression *x;
expression f;
type T;
@@

*f(...,(T)x,...)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 sound/soc/codecs/wm8900.c           |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/wm8900.c b/sound/soc/codecs/wm8900.c
index c9438dd..dbc368c 100644
--- a/sound/soc/codecs/wm8900.c
+++ b/sound/soc/codecs/wm8900.c
@@ -199,7 +199,7 @@ static void wm8900_reset(struct snd_soc_codec *codec)
 	snd_soc_write(codec, WM8900_REG_RESET, 0);
 
 	memcpy(codec->reg_cache, wm8900_reg_defaults,
-	       sizeof(codec->reg_cache));
+	       sizeof(wm8900_reg_defaults));
 }
 
 static int wm8900_hp_event(struct snd_soc_dapm_widget *w,
