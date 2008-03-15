Return-Path: <linux-kernel-owner+w=401wt.eu-S1754783AbYCOQEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbYCOQEQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 12:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754687AbYCOQD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 12:03:56 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:42298 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753867AbYCOQDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 12:03:54 -0400
Date: Sat, 15 Mar 2008 17:03:51 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: sailer@ife.ee.ethz.ch, linux-sound@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 4/7] sound/pci: remove unused variable
Message-ID: <Pine.LNX.4.64.0803151703210.24178@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The variables change and is_capture are initialized but never used otherwise.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T;
identifier i;
constant C;
@@

(
extern T i;
|
- T i;
  <+... when != i
- i = C;
  ...+>
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---
 sound/pci/ice1712/pontis.c |    2 --
 sound/pci/pcxhr/pcxhr.c    |    3 ---
 2 files changed, 5 deletions(-)

diff -u -p a/sound/pci/ice1712/pontis.c b/sound/pci/ice1712/pontis.c
--- a/sound/pci/ice1712/pontis.c 2008-03-12 14:13:15.000000000 +0100
+++ b/sound/pci/ice1712/pontis.c 2008-03-15 07:32:24.000000000 +0100
@@ -440,14 +440,12 @@ static int cs_source_put(struct snd_kcon
 {
 	struct snd_ice1712 *ice = snd_kcontrol_chip(kcontrol);
 	unsigned char val;
-	int change = 0;
 
 	mutex_lock(&ice->gpio_mutex);
 	if (ucontrol->value.enumerated.item[0] != ice->gpio.saved[0]) {
 		ice->gpio.saved[0] = ucontrol->value.enumerated.item[0] & 3;
 		val = 0x80 | (ice->gpio.saved[0] << 3);
 		spi_write(ice, CS_DEV, 0x04, val);
-		change = 1;
 	}
 	mutex_unlock(&ice->gpio_mutex);
 	return 0;
diff -u -p a/sound/pci/pcxhr/pcxhr.c b/sound/pci/pcxhr/pcxhr.c
--- a/sound/pci/pcxhr/pcxhr.c 2008-03-12 14:13:15.000000000 +0100
+++ b/sound/pci/pcxhr/pcxhr.c 2008-03-15 07:36:12.000000000 +0100
@@ -846,7 +846,6 @@ static int pcxhr_open(struct snd_pcm_sub
 	struct pcxhr_mgr       *mgr = chip->mgr;
 	struct snd_pcm_runtime *runtime = subs->runtime;
 	struct pcxhr_stream    *stream;
-	int                 is_capture;
 
 	mutex_lock(&mgr->setup_mutex);
 
@@ -856,12 +855,10 @@ static int pcxhr_open(struct snd_pcm_sub
 	if( subs->stream == SNDRV_PCM_STREAM_PLAYBACK ) {
 		snd_printdd("pcxhr_open playback chip%d subs%d\n",
 			    chip->chip_idx, subs->number);
-		is_capture = 0;
 		stream = &chip->playback_stream[subs->number];
 	} else {
 		snd_printdd("pcxhr_open capture chip%d subs%d\n",
 			    chip->chip_idx, subs->number);
-		is_capture = 1;
 		if (mgr->mono_capture)
 			runtime->hw.channels_max = 1;
 		else
