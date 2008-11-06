Return-Path: <linux-kernel-owner+w=401wt.eu-S1753152AbYKFVyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbYKFVyg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:54:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754579AbYKFVxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:53:31 -0500
Received: from mail.queued.net ([207.210.101.209]:2020 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754548AbYKFVxa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:53:30 -0500
Date: Thu, 6 Nov 2008 16:53:26 -0500
From: Andres Salomon <dilinger@queued.net>
To: "Jaya Kumar" <jayakumar.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 13/14] ALSA: cs5535audio: clean up OLPC code
Message-ID: <20081106165326.14994c8e@ephemeral>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 - add copyright info to _olpc.c
 - minor layout fixes
 - make Makefile more concise
 - silence a warning

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 sound/pci/cs5535audio/Makefile           |    5 +----
 sound/pci/cs5535audio/cs5535audio.c      |    4 ++--
 sound/pci/cs5535audio/cs5535audio_olpc.c |   15 ++++++++++++---
 3 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/sound/pci/cs5535audio/Makefile b/sound/pci/cs5535audio/Makefile
index 3e41fd3..ccc6422 100644
--- a/sound/pci/cs5535audio/Makefile
+++ b/sound/pci/cs5535audio/Makefile
@@ -4,10 +4,7 @@
 
 snd-cs5535audio-y := cs5535audio.o cs5535audio_pcm.o
 snd-cs5535audio-$(CONFIG_PM) += cs5535audio_pm.o
-
-ifdef CONFIG_OLPC
-snd-cs5535audio-objs += cs5535audio_olpc.o
-endif
+snd-cs5535audio-$(CONFIG_OLPC) += cs5535audio_olpc.o
 
 # Toplevel Module Dependency
 obj-$(CONFIG_SND_CS5535AUDIO) += snd-cs5535audio.o
diff --git a/sound/pci/cs5535audio/cs5535audio.c b/sound/pci/cs5535audio/cs5535audio.c
index 0f5ce36..826e6de 100644
--- a/sound/pci/cs5535audio/cs5535audio.c
+++ b/sound/pci/cs5535audio/cs5535audio.c
@@ -174,8 +174,8 @@ static int __devinit snd_cs5535audio_mixer(struct cs5535audio *cs5535au)
 
 	snd_ac97_tune_hardware(cs5535au->ac97, ac97_quirks, ac97_quirk);
 
-	/* olpc_quirks is dummied out if not olpc */
-	if (( err = olpc_quirks(card, cs5535au->ac97)) < 0) {
+	err = olpc_quirks(card, cs5535au->ac97);
+	if (err < 0) {
 		snd_printk(KERN_ERR "olpc quirks failed\n");
 		return err;
 	}
diff --git a/sound/pci/cs5535audio/cs5535audio_olpc.c b/sound/pci/cs5535audio/cs5535audio_olpc.c
index 45b24f7..164f6bd 100644
--- a/sound/pci/cs5535audio/cs5535audio_olpc.c
+++ b/sound/pci/cs5535audio/cs5535audio_olpc.c
@@ -1,4 +1,14 @@
-#include <sound/driver.h>
+/*
+ * OLPC XO-1 additional sound features
+ *
+ * Copyright © 2006  Jaya Kumar <jayakumar.lkml@gmail.com>
+ * Copyright © 2007-2008  Andres Salomon <dilinger@debian.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
 #include <sound/core.h>
 #include <sound/info.h>
 #include <sound/control.h>
@@ -106,7 +116,7 @@ static struct snd_kcontrol_new olpc_cs5535audio_ctls[] __devinitdata = {
 	.info = olpc_dc_info,
 	.get = olpc_dc_get,
 	.put = olpc_dc_put,
-	.private_value = 0
+	.private_value = 0,
 },
 {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
@@ -161,4 +171,3 @@ int __devinit olpc_quirks(struct snd_card *card, struct snd_ac97 *ac97)
 	olpc_mic_bias(ac97, 0);
 	return 0;
 }
-
-- 
1.5.6.5

