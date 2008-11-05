Return-Path: <linux-kernel-owner+w=401wt.eu-S1755876AbYKEWhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbYKEWhp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 17:37:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbYKEWhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 17:37:19 -0500
Received: from mail.queued.net ([207.210.101.209]:4984 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041AbYKEWhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 17:37:17 -0500
Date: Wed, 5 Nov 2008 17:29:53 -0500
From: Andres Salomon <dilinger@queued.net>
To: jayakumar.alsa@gmail.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 1/4] ALSA: cs5535audio: stick AD1888 bitshift values into a
 header file
Message-ID: <20081105172953.7b963e7d@ephemeral>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We'd like to use the High Pass Filter and V_REFOUT bitshift values elsewhere,
so stick them into a ac97_codec.h.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 include/sound/ac97_codec.h  |    2 ++
 sound/pci/ac97/ac97_patch.c |    5 +++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/sound/ac97_codec.h b/include/sound/ac97_codec.h
index 9c309da..251fc1c 100644
--- a/include/sound/ac97_codec.h
+++ b/include/sound/ac97_codec.h
@@ -281,10 +281,12 @@
 /* specific - Analog Devices */
 #define AC97_AD_TEST		0x5a	/* test register */
 #define AC97_AD_TEST2		0x5c	/* undocumented test register 2 */
+#define AC97_AD_HPFD_SHIFT	12	/* High Pass Filter Disable */
 #define AC97_AD_CODEC_CFG	0x70	/* codec configuration */
 #define AC97_AD_JACK_SPDIF	0x72	/* Jack Sense & S/PDIF */
 #define AC97_AD_SERIAL_CFG	0x74	/* Serial Configuration */
 #define AC97_AD_MISC		0x76	/* Misc Control Bits */
+#define AC97_AD_VREFD_SHIFT	2	/* V_REFOUT Disable (AD1888) */
 
 /* specific - Cirrus Logic */
 #define AC97_CSR_ACMODE		0x5e	/* AC Mode Register */
diff --git a/sound/pci/ac97/ac97_patch.c b/sound/pci/ac97/ac97_patch.c
index 6e831af..7ad25f4 100644
--- a/sound/pci/ac97/ac97_patch.c
+++ b/sound/pci/ac97/ac97_patch.c
@@ -2054,8 +2054,9 @@ static const struct snd_kcontrol_new snd_ac97_ad1888_controls[] = {
 		.get = snd_ac97_ad1888_lohpsel_get,
 		.put = snd_ac97_ad1888_lohpsel_put
 	},
-	AC97_SINGLE("V_REFOUT Enable", AC97_AD_MISC, 2, 1, 1),
-	AC97_SINGLE("High Pass Filter Enable", AC97_AD_TEST2, 12, 1, 1),
+	AC97_SINGLE("V_REFOUT Enable", AC97_AD_MISC, AC97_AD_VREFD_SHIFT, 1, 1),
+	AC97_SINGLE("High Pass Filter Enable", AC97_AD_TEST2,
+			AC97_AD_HPFD_SHIFT, 1, 1),
 	AC97_SINGLE("Spread Front to Surround and Center/LFE", AC97_AD_MISC, 7, 1, 0),
 	{
 		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
-- 
1.5.6.5

