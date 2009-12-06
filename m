Return-Path: <linux-kernel-owner+w=401wt.eu-S1758067AbZLFXmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067AbZLFXmd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 18:42:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757893AbZLFXmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 18:42:32 -0500
Received: from kroah.org ([198.145.64.141]:33759 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757850AbZLFXih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 18:38:37 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 15:32:08 2009
Message-Id: <20091206233208.269420973@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 15:30:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Takashi Iwai <tiwai@suse.de>
Subject: [02/20] ALSA: AACI: fix recording bug
References: <20091206233032.387950574@mini.kroah.org>
Content-Disposition: inline; filename=alsa-aaci-fix-recording-bug.patch
In-Reply-To: <20091206233711.GA11609@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Russell King <rmk+kernel@arm.linux.org.uk>

commit 8ee763b9c82c6ca0a59a7271ce4fa29d7baf5c09 upstream.

pcm->r[1].slots is the double rate slot information, not the
capture information.  For capture, 'pcm' will already be the
capture ac97 pcm structure.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/arm/aaci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/arm/aaci.c
+++ b/sound/arm/aaci.c
@@ -521,7 +521,7 @@ static int aaci_pcm_hw_params(struct snd
 	else
 		err = snd_ac97_pcm_open(aacirun->pcm, params_rate(params),
 					params_channels(params),
-					aacirun->pcm->r[1].slots);
+					aacirun->pcm->r[0].slots);
 
 	if (err)
 		goto out;


