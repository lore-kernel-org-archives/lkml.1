Return-Path: <linux-kernel-owner+w=401wt.eu-S1751355AbYCJHOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355AbYCJHOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 03:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750761AbYCJHOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 03:14:03 -0400
Received: from topsns2.toshiba-tops.co.jp ([202.230.225.126]:44791 "EHLO
	topsns2.toshiba-tops.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750735AbYCJHOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 03:14:00 -0400
Date: Mon, 10 Mar 2008 16:13:54 +0900 (JST)
Message-Id: <20080310.161354.42213512.nemoto@toshiba-tops.co.jp>
To: linux-kernel@vger.kernel.org
Cc: Hans-Christian Egtvedt <hcegtvedt@atmel.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Victor <avictor.za@gmail.com>
Subject: [PATCH] at73c213: Remove redundant private_free routine
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

snd_pcm_lib_preallocate_free_for_all() is called from snd_pcm_free()
just after calling the private_free routine.  So there should be no
need to call it in driver's private_free routine.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
diff --git a/sound/spi/at73c213.c b/sound/spi/at73c213.c
index 89d6e9c..024db14 100644
--- a/sound/spi/at73c213.c
+++ b/sound/spi/at73c213.c
@@ -314,15 +314,6 @@ static struct snd_pcm_ops at73c213_playback_ops = {
 	.pointer	= snd_at73c213_pcm_pointer,
 };
 
-static void snd_at73c213_pcm_free(struct snd_pcm *pcm)
-{
-	struct snd_at73c213 *chip = snd_pcm_chip(pcm);
-	if (chip->pcm) {
-		snd_pcm_lib_preallocate_free_for_all(chip->pcm);
-		chip->pcm = NULL;
-	}
-}
-
 static int __devinit snd_at73c213_pcm_new(struct snd_at73c213 *chip, int device)
 {
 	struct snd_pcm *pcm;
@@ -333,8 +324,6 @@ static int __devinit snd_at73c213_pcm_new(struct snd_at73c213 *chip, int device)
 	if (retval < 0)
 		goto out;
 
-	pcm->private_data = chip;
-	pcm->private_free = snd_at73c213_pcm_free;
 	pcm->info_flags = SNDRV_PCM_INFO_BLOCK_TRANSFER;
 	strcpy(pcm->name, "at73c213");
 	chip->pcm = pcm;
