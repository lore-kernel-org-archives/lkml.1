Return-Path: <linux-kernel-owner+w=401wt.eu-S1762648AbYB1A4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762648AbYB1A4v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 19:56:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753482AbYB1A4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 19:56:13 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:51661 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744AbYB1A4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 19:56:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Onj1j5p1kZQblmbZb3kCt6brnujtm2xRieEt6Hls2cME1xEo7YqwZUznc0KH6fNPqX/jNFK5JIkCaajdl2fDETC7U4kDz3YautfoEj2QhiN/pnRM0PATcqZusxwbS3YmXDPQaoEC3ij16nMEYu13Bm8hMKtGK1OvC1hm/Cf3pJw=
Subject: [PATCH 03/12] sound: es1968.c fox shadowed variable warning
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 27 Feb 2008 16:56:05 -0800
Message-Id: <1204160165.20280.51.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

id is used when initializing the mixer elements, use elem_id here
instead.
sound/pci/es1968.c:1963:25: warning: symbol 'id' shadows an earlier one
sound/pci/es1968.c:129:13: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 sound/pci/es1968.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/sound/pci/es1968.c b/sound/pci/es1968.c
index 25ccfce..db02d40 100644
--- a/sound/pci/es1968.c
+++ b/sound/pci/es1968.c
@@ -1960,7 +1960,7 @@ snd_es1968_mixer(struct es1968 *chip)
 {
 	struct snd_ac97_bus *pbus;
 	struct snd_ac97_template ac97;
-	struct snd_ctl_elem_id id;
+	struct snd_ctl_elem_id elem_id;
 	int err;
 	static struct snd_ac97_bus_ops ops = {
 		.write = snd_es1968_ac97_write,
@@ -1977,14 +1977,14 @@ snd_es1968_mixer(struct es1968 *chip)
 		return err;
 
 	/* attach master switch / volumes for h/w volume control */
-	memset(&id, 0, sizeof(id));
-	id.iface = SNDRV_CTL_ELEM_IFACE_MIXER;
-	strcpy(id.name, "Master Playback Switch");
-	chip->master_switch = snd_ctl_find_id(chip->card, &id);
-	memset(&id, 0, sizeof(id));
-	id.iface = SNDRV_CTL_ELEM_IFACE_MIXER;
-	strcpy(id.name, "Master Playback Volume");
-	chip->master_volume = snd_ctl_find_id(chip->card, &id);
+	memset(&elem_id, 0, sizeof(elem_id));
+	elem_id.iface = SNDRV_CTL_ELEM_IFACE_MIXER;
+	strcpy(elem_id.name, "Master Playback Switch");
+	chip->master_switch = snd_ctl_find_id(chip->card, &elem_id);
+	memset(&elem_id, 0, sizeof(elem_id));
+	elem_id.iface = SNDRV_CTL_ELEM_IFACE_MIXER;
+	strcpy(elem_id.name, "Master Playback Volume");
+	chip->master_volume = snd_ctl_find_id(chip->card, &elem_id);
 
 	return 0;
 }
-- 
1.5.4.3.342.g99e8


