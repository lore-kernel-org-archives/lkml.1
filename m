Return-Path: <linux-kernel-owner+w=401wt.eu-S1757620AbZBKWtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757620AbZBKWtp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 17:49:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754892AbZBKWtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 17:49:36 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:3253 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbZBKWtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 17:49:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=l9W25qr1r4Lz2QLeRoXYWWxlYAeMK/CjY2HIA8FzqR9/q4we3SvD3+M2Vx+/H62QTl
         OdUdmWg/pcyyCSv+O4J8XyIQ62wWm+L/kQ/bLh1q4F9qDqcQ4EU/2yTa/vK/TIpukcp4
         amIQI7Z3OW85Ijsn9JIByxEwk68fz85XfUqF8=
Subject: [PATCH] sound: replace uses of __constant_{endian}
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 11 Feb 2009 14:49:30 -0800
Message-Id: <1234392570.5566.17.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The base versions handle constant folding now.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 sound/pci/echoaudio/echo3g_dsp.c    |    2 +-
 sound/pci/echoaudio/echoaudio_3g.c  |    3 +--
 sound/pci/echoaudio/echoaudio_dsp.c |    6 +++---
 sound/pci/echoaudio/gina20_dsp.c    |    4 ++--
 sound/pci/echoaudio/layla20_dsp.c   |    4 ++--
 sound/pci/echoaudio/mia_dsp.c       |    4 ++--
 sound/pci/echoaudio/midi.c          |    4 ++--
 7 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/sound/pci/echoaudio/echo3g_dsp.c b/sound/pci/echoaudio/echo3g_dsp.c
index 417e25a..57967e5 100644
--- a/sound/pci/echoaudio/echo3g_dsp.c
+++ b/sound/pci/echoaudio/echo3g_dsp.c
@@ -56,7 +56,7 @@ static int init_hw(struct echoaudio *chip, u16 device_id, u16 subdevice_id)
 	}
 
 	chip->comm_page->e3g_frq_register =
-		__constant_cpu_to_le32((E3G_MAGIC_NUMBER / 48000) - 2);
+		cpu_to_le32((E3G_MAGIC_NUMBER / 48000) - 2);
 	chip->device_id = device_id;
 	chip->subdevice_id = subdevice_id;
 	chip->bad_board = TRUE;
diff --git a/sound/pci/echoaudio/echoaudio_3g.c b/sound/pci/echoaudio/echoaudio_3g.c
index c3736bb..e32a748 100644
--- a/sound/pci/echoaudio/echoaudio_3g.c
+++ b/sound/pci/echoaudio/echoaudio_3g.c
@@ -40,8 +40,7 @@ static int check_asic_status(struct echoaudio *chip)
 	if (wait_handshake(chip))
 		return -EIO;
 
-	chip->comm_page->ext_box_status =
-		__constant_cpu_to_le32(E3G_ASIC_NOT_LOADED);
+	chip->comm_page->ext_box_status = cpu_to_le32(E3G_ASIC_NOT_LOADED);
 	chip->asic_loaded = FALSE;
 	clear_handshake(chip);
 	send_vector(chip, DSP_VC_TEST_ASIC);
diff --git a/sound/pci/echoaudio/echoaudio_dsp.c b/sound/pci/echoaudio/echoaudio_dsp.c
index be0e181..4df51ef 100644
--- a/sound/pci/echoaudio/echoaudio_dsp.c
+++ b/sound/pci/echoaudio/echoaudio_dsp.c
@@ -926,11 +926,11 @@ static int init_dsp_comm_page(struct echoaudio *chip)
 
 	/* Init the comm page */
 	chip->comm_page->comm_size =
-		__constant_cpu_to_le32(sizeof(struct comm_page));
+		cpu_to_le32(sizeof(struct comm_page));
 	chip->comm_page->handshake = 0xffffffff;
 	chip->comm_page->midi_out_free_count =
-		__constant_cpu_to_le32(DSP_MIDI_OUT_FIFO_SIZE);
-	chip->comm_page->sample_rate = __constant_cpu_to_le32(44100);
+		cpu_to_le32(DSP_MIDI_OUT_FIFO_SIZE);
+	chip->comm_page->sample_rate = cpu_to_le32(44100);
 	chip->sample_rate = 44100;
 
 	/* Set line levels so we don't blast any inputs on startup */
diff --git a/sound/pci/echoaudio/gina20_dsp.c b/sound/pci/echoaudio/gina20_dsp.c
index db6c952..3f1e747 100644
--- a/sound/pci/echoaudio/gina20_dsp.c
+++ b/sound/pci/echoaudio/gina20_dsp.c
@@ -208,10 +208,10 @@ static int set_professional_spdif(struct echoaudio *chip, char prof)
 	DE_ACT(("set_professional_spdif %d\n", prof));
 	if (prof)
 		chip->comm_page->flags |=
-			__constant_cpu_to_le32(DSP_FLAG_PROFESSIONAL_SPDIF);
+			cpu_to_le32(DSP_FLAG_PROFESSIONAL_SPDIF);
 	else
 		chip->comm_page->flags &=
-			~__constant_cpu_to_le32(DSP_FLAG_PROFESSIONAL_SPDIF);
+			~cpu_to_le32(DSP_FLAG_PROFESSIONAL_SPDIF);
 	chip->professional_spdif = prof;
 	return update_flags(chip);
 }
diff --git a/sound/pci/echoaudio/layla20_dsp.c b/sound/pci/echoaudio/layla20_dsp.c
index ede75c6..83750e9 100644
--- a/sound/pci/echoaudio/layla20_dsp.c
+++ b/sound/pci/echoaudio/layla20_dsp.c
@@ -284,10 +284,10 @@ static int set_professional_spdif(struct echoaudio *chip, char prof)
 	DE_ACT(("set_professional_spdif %d\n", prof));
 	if (prof)
 		chip->comm_page->flags |=
-			__constant_cpu_to_le32(DSP_FLAG_PROFESSIONAL_SPDIF);
+			cpu_to_le32(DSP_FLAG_PROFESSIONAL_SPDIF);
 	else
 		chip->comm_page->flags &=
-			~__constant_cpu_to_le32(DSP_FLAG_PROFESSIONAL_SPDIF);
+			~cpu_to_le32(DSP_FLAG_PROFESSIONAL_SPDIF);
 	chip->professional_spdif = prof;
 	return update_flags(chip);
 }
diff --git a/sound/pci/echoaudio/mia_dsp.c b/sound/pci/echoaudio/mia_dsp.c
index 2273866..3eca16c 100644
--- a/sound/pci/echoaudio/mia_dsp.c
+++ b/sound/pci/echoaudio/mia_dsp.c
@@ -222,10 +222,10 @@ static int set_professional_spdif(struct echoaudio *chip, char prof)
 	DE_ACT(("set_professional_spdif %d\n", prof));
 	if (prof)
 		chip->comm_page->flags |=
-			__constant_cpu_to_le32(DSP_FLAG_PROFESSIONAL_SPDIF);
+			cpu_to_le32(DSP_FLAG_PROFESSIONAL_SPDIF);
 	else
 		chip->comm_page->flags &=
-			~__constant_cpu_to_le32(DSP_FLAG_PROFESSIONAL_SPDIF);
+			~cpu_to_le32(DSP_FLAG_PROFESSIONAL_SPDIF);
 	chip->professional_spdif = prof;
 	return update_flags(chip);
 }
diff --git a/sound/pci/echoaudio/midi.c b/sound/pci/echoaudio/midi.c
index 77bf2a8..a953d14 100644
--- a/sound/pci/echoaudio/midi.c
+++ b/sound/pci/echoaudio/midi.c
@@ -44,10 +44,10 @@ static int enable_midi_input(struct echoaudio *chip, char enable)
 	if (enable) {
 		chip->mtc_state = MIDI_IN_STATE_NORMAL;
 		chip->comm_page->flags |=
-			__constant_cpu_to_le32(DSP_FLAG_MIDI_INPUT);
+			cpu_to_le32(DSP_FLAG_MIDI_INPUT);
 	} else
 		chip->comm_page->flags &=
-			~__constant_cpu_to_le32(DSP_FLAG_MIDI_INPUT);
+			~cpu_to_le32(DSP_FLAG_MIDI_INPUT);
 
 	clear_handshake(chip);
 	return send_vector(chip, DSP_VC_UPDATE_FLAGS);
-- 
1.6.2.rc0.218.gde7c



