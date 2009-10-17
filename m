Return-Path: <linux-kernel-owner+w=401wt.eu-S1751343AbZJQGc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751343AbZJQGc4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 02:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751084AbZJQGcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 02:32:55 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:59094 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbZJQGcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 02:32:55 -0400
Date: Sat, 17 Oct 2009 08:32:56 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 1/14] sound/soc: Move dereference after NULL test
Message-ID: <Pine.LNX.4.64.0910170832300.9213@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

If the NULL test on jack is needed, then the derefernce should be after the
NULL test.

A simplified version of the semantic match that detects this problem is as
follows (http://coccinelle.lip6.fr/):

// <smpl>
@match exists@
expression x, E;
identifier fld;
@@

* x->fld
  ... when != \(x = E\|&x\)
* x == NULL
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 sound/soc/soc-jack.c                |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/sound/soc/soc-jack.c b/sound/soc/soc-jack.c
index 1d455ab..1212414 100644
--- a/sound/soc/soc-jack.c
+++ b/sound/soc/soc-jack.c
@@ -58,7 +58,7 @@ EXPORT_SYMBOL_GPL(snd_soc_jack_new);
  */
 void snd_soc_jack_report(struct snd_soc_jack *jack, int status, int mask)
 {
-	struct snd_soc_codec *codec = jack->card->codec;
+	struct snd_soc_codec *codec;
 	struct snd_soc_jack_pin *pin;
 	int enable;
 	int oldstatus;
@@ -67,6 +67,7 @@ void snd_soc_jack_report(struct snd_soc_jack *jack, int status, int mask)
 		WARN_ON_ONCE(!jack);
 		return;
 	}
+	codec = jack->card->codec;
 
 	mutex_lock(&codec->mutex);
 
