Return-Path: <linux-kernel-owner+w=401wt.eu-S1753713Ab0AUE15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab0AUE15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 23:27:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169Ab0AUE1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 23:27:50 -0500
Received: from kroah.org ([198.145.64.141]:60103 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754159Ab0AUEWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 23:22:55 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Jan 20 20:18:34 2010
Message-Id: <20100121041834.427475673@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Jan 2010 20:15:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Takashi Iwai <tiwai@suse.de>
Subject: [15/30] ALSA: hda - Fix missing capture mixer for ALC861/660 codecs
In-Reply-To: <20100121041852.GA9656@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit c7a8eb103248a110cdbe0530d8c5ce987f099eee upstream.

The capture-related mixer elements are missing with ALC861/ALC660 codecs
when quirks are present, due to missing call of set_capture_mixer().

Reference: Novell bnc#567340
	http://bugzilla.novell.com/show_bug.cgi?id=567340

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -14685,6 +14685,8 @@ static int patch_alc861(struct hda_codec
 	spec->stream_digital_playback = &alc861_pcm_digital_playback;
 	spec->stream_digital_capture = &alc861_pcm_digital_capture;
 
+	if (!spec->cap_mixer)
+		set_capture_mixer(codec);
 	set_beep_amp(spec, 0x23, 0, HDA_OUTPUT);
 
 	spec->vmaster_nid = 0x03;


