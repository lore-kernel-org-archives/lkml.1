Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbYKFVyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbYKFVyR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754183AbYKFVxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:53:24 -0500
Received: from mail.queued.net ([207.210.101.209]:2016 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754137AbYKFVxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:53:22 -0500
Date: Thu, 6 Nov 2008 16:53:19 -0500
From: Andres Salomon <dilinger@queued.net>
To: "Jaya Kumar" <jayakumar.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 12/14] ALSA: cs5535audio: turn off mic bias on OLPCs by
 default
Message-ID: <20081106165319.111b9756@ephemeral>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Always turn off mic bias; the MIC LED should never come on when the
driver is first loaded.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 sound/pci/cs5535audio/cs5535audio_olpc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/sound/pci/cs5535audio/cs5535audio_olpc.c b/sound/pci/cs5535audio/cs5535audio_olpc.c
index 73811e0..45b24f7 100644
--- a/sound/pci/cs5535audio/cs5535audio_olpc.c
+++ b/sound/pci/cs5535audio/cs5535audio_olpc.c
@@ -157,6 +157,8 @@ int __devinit olpc_quirks(struct snd_card *card, struct snd_ac97 *ac97)
 			return err;
 	}
 
+	/* turn off the mic by default */
+	olpc_mic_bias(ac97, 0);
 	return 0;
 }
 
-- 
1.5.6.5

