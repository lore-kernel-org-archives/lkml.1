Return-Path: <linux-kernel-owner+w=401wt.eu-S1761527AbYBLHHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761527AbYBLHHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 02:07:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759785AbYBLHHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 02:07:33 -0500
Received: from pip23.gyao.ne.jp ([125.63.38.249]:51414 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757402AbYBLHHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 02:07:32 -0500
Date: Tue, 12 Feb 2008 16:06:16 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] sound: opl3: Fix up opl3_synth build.
Message-ID: <20080212070616.GA18373@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
	alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

opl3 breaks allmodconfig in current git:

sound/drivers/opl3/opl3_synth.c: In function `snd_opl3_find_patch':
sound/drivers/opl3/opl3_synth.c:308: error: `OPL3_PATCH_HASH_SIZE' undeclared (first use in this function)
sound/drivers/opl3/opl3_synth.c:308: error: (Each undeclared identifier is reported only once
sound/drivers/opl3/opl3_synth.c:308: error: for each function it appears in.)
sound/drivers/opl3/opl3_synth.c:311: error: structure has no member named `patch_table'
sound/drivers/opl3/opl3_synth.c:323: error: structure has no member named `patch_table'
sound/drivers/opl3/opl3_synth.c:324: error: structure has no member named `patch_table'
sound/drivers/opl3/opl3_synth.c: In function `snd_opl3_clear_patches':
sound/drivers/opl3/opl3_synth.c:335: error: `OPL3_PATCH_HASH_SIZE' undeclared (first use in this function)
sound/drivers/opl3/opl3_synth.c:337: error: structure has no member named `patch_table'
sound/drivers/opl3/opl3_synth.c:342: error: structure has no member named `patch_table'
sound/drivers/opl3/opl3_synth.c:342: error: structure has no member named `patch_table'
make[3]: *** [sound/drivers/opl3/opl3_synth.o] Error 1
make[2]: *** [sound/drivers/opl3] Error 2
make[1]: *** [sound/drivers] Error 2

Relevant .config options:

CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
# CONFIG_SND_SEQUENCER is not set
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
# CONFIG_SND_DYNAMIC_MINORS is not set
CONFIG_SND_MPU401_UART=m
CONFIG_SND_OPL3_LIB=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_YMFPCI=m
CONFIG_SND_YMFPCI_FIRMWARE_IN_KERNEL=y

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 include/sound/opl3.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/sound/opl3.h b/include/sound/opl3.h
index a0c5feb..17b93d2 100644
--- a/include/sound/opl3.h
+++ b/include/sound/opl3.h
@@ -334,9 +334,6 @@ struct snd_opl3 {
 	struct snd_seq_device *oss_seq_dev;	/* OSS sequencer device */
 	struct snd_midi_channel_set * oss_chset;
 #endif
- 
-#define OPL3_PATCH_HASH_SIZE	32
-	struct fm_patch *patch_table[OPL3_PATCH_HASH_SIZE];
 
 	struct snd_opl3_voice voices[MAX_OPL3_VOICES]; /* Voices (OPL3 'channel') */
 	int use_time;			/* allocation counter */
@@ -350,6 +347,9 @@ struct snd_opl3 {
 	int sys_timer_status;		/* system timer run status */
 	spinlock_t sys_timer_lock;	/* Lock for system timer access */
 #endif
+
+#define OPL3_PATCH_HASH_SIZE	32
+	struct fm_patch *patch_table[OPL3_PATCH_HASH_SIZE];
 };
 
 /* opl3.c */
