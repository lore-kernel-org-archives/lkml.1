Return-Path: <linux-kernel-owner+w=401wt.eu-S1760084AbYB1SHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760084AbYB1SHM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 13:07:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbYB1SHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 13:07:00 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:64201 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbYB1SG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 13:06:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=anQ0gXq0FRMZTXh5ze3H1RZiDHXHa71MscoEgLnylSUyacYNOmQkKD9D/KIzd6YCIOz3vJSXvWx/SOioRT+XB84d7rLkxzHcZ9ZIQcvfWaGpG/mLHJQ+euTxNl55sspdZ9XgPsfrkQpNqkJ6c18mdB2H6PIH19p/dije9HRJk4o=
Subject: [PATCH 10/12v2] sound: au88x0_pcm.c fix integer as NULL
	pointer	warning
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <s5hir09s5he.wl%tiwai@suse.de>
References: <1204160169.20280.58.camel@brick> <s5hir09s5he.wl%tiwai@suse.de>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 10:06:49 -0800
Message-Id: <1204222012.20280.64.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sound/pci/au88x0/au88x0_pcm.c:508:15: warning: Using plain integer as NULL pointer

Also some small codingstyle fixes.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 sound/pci/au88x0/au88x0_pcm.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/pci/au88x0/au88x0_pcm.c b/sound/pci/au88x0/au88x0_pcm.c
index 526c6c5..f9a58b4 100644
--- a/sound/pci/au88x0/au88x0_pcm.c
+++ b/sound/pci/au88x0/au88x0_pcm.c
@@ -498,14 +498,14 @@ static struct snd_kcontrol_new snd_vortex_mixer_spdif[] __devinitdata = {
 };
 
 /* create a pcm device */
-static int __devinit snd_vortex_new_pcm(vortex_t * chip, int idx, int nr)
+static int __devinit snd_vortex_new_pcm(vortex_t *chip, int idx, int nr)
 {
 	struct snd_pcm *pcm;
 	struct snd_kcontrol *kctl;
 	int i;
 	int err, nr_capt;
 
-	if ((chip == 0) || (idx < 0) || (idx >= VORTEX_PCM_LAST))
+	if (!chip || idx < 0 || idx >= VORTEX_PCM_LAST)
 		return -ENODEV;
 
 	/* idx indicates which kind of PCM device. ADB, SPDIF, I2S and A3D share the 
@@ -514,9 +514,9 @@ static int __devinit snd_vortex_new_pcm(vortex_t * chip, int idx, int nr)
 		nr_capt = nr;
 	else
 		nr_capt = 0;
-	if ((err =
-	     snd_pcm_new(chip->card, vortex_pcm_prettyname[idx], idx, nr,
-			 nr_capt, &pcm)) < 0)
+	err = snd_pcm_new(chip->card, vortex_pcm_prettyname[idx], idx, nr,
+			  nr_capt, &pcm);
+	if (err < 0)
 		return err;
 	strcpy(pcm->name, vortex_pcm_name[idx]);
 	chip->pcm[idx] = pcm;
-- 
1.5.4.3.342.g99e8



