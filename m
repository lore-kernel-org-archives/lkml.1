Return-Path: <linux-kernel-owner+w=401wt.eu-S1754303AbYKFVyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbYKFVyy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:54:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbYKFVxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:53:38 -0500
Received: from mail.queued.net ([207.210.101.209]:2025 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648AbYKFVxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:53:37 -0500
Date: Thu, 6 Nov 2008 16:53:34 -0500
From: Andres Salomon <dilinger@queued.net>
To: "Jaya Kumar" <jayakumar.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 14/14] ALSA: cs5535audio: ensure MIC Bias/Analog Input bail
 if not on an OLPC machine
Message-ID: <20081106165334.7897c989@ephemeral>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 sound/pci/cs5535audio/cs5535audio_olpc.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/sound/pci/cs5535audio/cs5535audio_olpc.c b/sound/pci/cs5535audio/cs5535audio_olpc.c
index 164f6bd..5c68143 100644
--- a/sound/pci/cs5535audio/cs5535audio_olpc.c
+++ b/sound/pci/cs5535audio/cs5535audio_olpc.c
@@ -26,6 +26,9 @@ void olpc_analog_input(struct snd_ac97 *ac97, int on)
 {
 	int err;
 
+	if (!machine_is_olpc())
+		return;
+
 	/* update the High Pass Filter (via AC97_AD_TEST2) */
 	err = snd_ac97_update_bits(ac97, AC97_AD_TEST2,
 			1 << AC97_AD_HPFD_SHIFT, on << AC97_AD_HPFD_SHIFT);
@@ -48,6 +51,9 @@ void olpc_mic_bias(struct snd_ac97 *ac97, int on)
 {
 	int err;
 
+	if (!machine_is_olpc())
+		return;
+
 	on = on ? 0 : 1;
 	err = snd_ac97_update_bits(ac97, AC97_AD_MISC,
 			1 << AC97_AD_VREFD_SHIFT, on << AC97_AD_VREFD_SHIFT);
-- 
1.5.6.5

