Return-Path: <linux-kernel-owner+w=401wt.eu-S1752702AbZLSHSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbZLSHSR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 02:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbZLSHSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 02:18:10 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:34293 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426AbZLSHSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 02:18:06 -0500
Date: Sat, 19 Dec 2009 08:18:03 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 7/7] sound: Use kzalloc for allocating only one thing
Message-ID: <Pine.LNX.4.64.0912190817460.30546@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use kzalloc rather than kcalloc(1,...)

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
@@

- kcalloc(1,
+ kzalloc(
          ...)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 sound/isa/msnd/msnd_midi.c    |    2 +-
 sound/pci/hda/patch_realtek.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -u -p a/sound/isa/msnd/msnd_midi.c b/sound/isa/msnd/msnd_midi.c
--- a/sound/isa/msnd/msnd_midi.c 2009-03-28 23:34:55.000000000 +0100
+++ b/sound/isa/msnd/msnd_midi.c 2009-12-19 07:52:27.000000000 +0100
@@ -162,7 +162,7 @@ int snd_msndmidi_new(struct snd_card *ca
 	err = snd_rawmidi_new(card, "MSND-MIDI", device, 1, 1, &rmidi);
 	if (err < 0)
 		return err;
-	mpu = kcalloc(1, sizeof(*mpu), GFP_KERNEL);
+	mpu = kzalloc(sizeof(*mpu), GFP_KERNEL);
 	if (mpu == NULL) {
 		snd_device_free(card, rmidi);
 		return -ENOMEM;
diff -u -p a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
--- a/sound/pci/hda/patch_realtek.c 2009-12-17 08:30:15.000000000 +0100
+++ b/sound/pci/hda/patch_realtek.c 2009-12-19 07:52:50.000000000 +0100
@@ -12857,7 +12857,7 @@ static int patch_alc268(struct hda_codec
 	int board_config;
 	int i, has_beep, err;
 
-	spec = kcalloc(1, sizeof(*spec), GFP_KERNEL);
+	spec = kzalloc(sizeof(*spec), GFP_KERNEL);
 	if (spec == NULL)
 		return -ENOMEM;
 
