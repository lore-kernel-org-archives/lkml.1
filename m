Return-Path: <linux-kernel-owner+w=401wt.eu-S1758146AbYBRCkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146AbYBRCkp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 21:40:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbYBRCkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 21:40:37 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753556AbYBRCkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 21:40:36 -0500
Message-ID: <47B8F020.7030300@redhat.com>
Date: Sun, 17 Feb 2008 21:40:32 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Adel Gadllah <adel.gadllah@gmail.com>
CC: kernel list <linux-kernel@vger.kernel.org>, tiwai@suse.de
Subject: Re: [PATCH] snd-hda-intel: don't print using snd_printdd on device
 open
References: <47B80CED.3060903@gmail.com>
In-Reply-To: <47B80CED.3060903@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adel Gadllah <adel.gadllah@gmail.com>

snd-hda-intel: don't print using snd_printdd on device open

When CONFIG_SND_DEBUG_DETECT is set the hda-intel driver prints verbose
info like this:

ALSA sound/pci/hda/hda_intel.c:1259: azx_pcm_prepare: bufsize=0x4400,
fragsize=0x1100, format=0x11
ALSA sound/pci/hda/hda_codec.c:682: hda_codec_setup_stream: NID=0x7,
stream=0x5, channel=0, format=0x11
ALSA sound/pci/hda/hda_codec.c:682: hda_codec_setup_stream: NID=0x3,
stream=0x5, channel=0, format=0x11
ALSA sound/pci/hda/hda_codec.c:682: hda_codec_setup_stream: NID=0x3,
stream=0x0, channel=0, format=0x0
ALSA sound/pci/hda/hda_codec.c:682: hda_codec_setup_stream: NID=0x7,
stream=0x0, channel=0, format=0x0
ALSA sound/pci/hda/hda_codec.c:682: hda_codec_setup_stream: NID=0x3,
stream=0x0, channel=0, format=0x0

Don't print anything in functions that get called when the device gets
opened/prepared for output.

Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>
Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
CC: Takashi Iwai <tiwai@suse.de>

---

Orignal patch was mangled by sender's mail software.

diff -upNr linux-2.6.24.2.orign/sound/pci/hda/hda_codec.c linux-2.6.24.2/sound/pci/hda/hda_codec.c
--- linux-2.6.24.2.orign/sound/pci/hda/hda_codec.c    2008-02-11 06:51:11.000000000 +0100
+++ linux-2.6.24.2/sound/pci/hda/hda_codec.c    2008-02-17 11:08:58.000000000 +0100
@@ -677,9 +677,6 @@ void snd_hda_codec_setup_stream(struct h
 	if (!nid)
 		return;

-	snd_printdd("hda_codec_setup_stream: "
-		    "NID=0x%x, stream=0x%x, channel=%d, format=0x%x\n",
-		    nid, stream_tag, channel_id, format);
 	snd_hda_codec_write(codec, nid, 0, AC_VERB_SET_CHANNEL_STREAMID,
 			    (stream_tag << 4) | channel_id);
 	msleep(1);
diff -upNr linux-2.6.24.2.orign/sound/pci/hda/hda_intel.c linux-2.6.24.2/sound/pci/hda/hda_intel.c
--- linux-2.6.24.2.orign/sound/pci/hda/hda_intel.c    2008-02-11 06:51:11.000000000 +0100
+++ linux-2.6.24.2/sound/pci/hda/hda_intel.c    2008-02-17 11:10:16.000000000 +0100
@@ -1249,9 +1249,6 @@ static int azx_pcm_prepare(struct snd_pc
 		return -EINVAL;
 	}

-	snd_printdd("azx_pcm_prepare: bufsize=0x%x, fragsize=0x%x, "
-		    "format=0x%x\n",
-		    azx_dev->bufsize, azx_dev->fragsize, azx_dev->format_val);
 	azx_setup_periods(azx_dev);
 	azx_setup_controller(chip, azx_dev);
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)

