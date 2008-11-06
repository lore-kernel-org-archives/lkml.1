Return-Path: <linux-kernel-owner+w=401wt.eu-S1754362AbYKFVu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbYKFVu5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 16:50:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754212AbYKFVt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 16:49:59 -0500
Received: from mail.queued.net ([207.210.101.209]:1272 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754174AbYKFVt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 16:49:58 -0500
Date: Thu, 6 Nov 2008 16:49:55 -0500
From: Andres Salomon <dilinger@queued.net>
To: "Jaya Kumar" <jayakumar.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 8/14] ALSA: cs5535audio: check OLPC's Analog Input status
 vis GPIO
Message-ID: <20081106164955.507e05a2@ephemeral>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Checking the HPF register is irrelevant; HPF is secondary to the AI mode.
Instead, check for Analog Input mode via GPIO.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 sound/pci/cs5535audio/cs5535audio_olpc.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/sound/pci/cs5535audio/cs5535audio_olpc.c b/sound/pci/cs5535audio/cs5535audio_olpc.c
index 2c148b9..f59af91 100644
--- a/sound/pci/cs5535audio/cs5535audio_olpc.c
+++ b/sound/pci/cs5535audio/cs5535audio_olpc.c
@@ -43,13 +43,8 @@ static int olpc_dc_info(struct snd_kcontrol *kctl,
 
 static int olpc_dc_get(struct snd_kcontrol *kctl, struct snd_ctl_elem_value *v)
 {
-	struct cs5535audio *cs5535au = snd_kcontrol_chip(kctl);
-	u8 val;
-
-	val = snd_ac97_read(cs5535au->ac97, AC97_AD_TEST2);
-	val >>= AC97_AD_HPFD_SHIFT;
-	v->value.integer.value[0] = val & 0x1;
-
+	v->value.integer.value[0] = geode_gpio_isset(OLPC_GPIO_MIC_AC,
+			GPIO_OUTPUT_VAL);
 	return 0;
 }
 
-- 
1.5.6.5

