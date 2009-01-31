Return-Path: <linux-kernel-owner+w=401wt.eu-S1760009AbZAaDLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760009AbZAaDLK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 22:11:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408AbZAaCrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:47:49 -0500
Received: from kroah.org ([198.145.64.141]:55572 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756905AbZAaCrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:47:40 -0500
Date: Fri, 30 Jan 2009 18:44:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [patch 33/43] ALSA: hda - Fix PCM reference NID for STAC/IDT
	analog outputs
Message-ID: <20090131024441.GH12368@kroah.com>
References: <20090131022548.656772939@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-hda-fix-pcm-reference-nid-for-stac-idt-analog-outputs.patch"
In-Reply-To: <20090131024158.GA12368@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 00a602db1ce9d61319d6f769dee206ec85f19bda upstream.

The reference NID for the analog outputs of STAC/IDT codecs is set
to a fixed number 0x02.  But this isn't always correct and in many
codecs it points to a non-existing NID.

This patch fixes the initialization of the PCM reference NID taken
from the actually probed DAC list.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_sigmatel.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -2428,6 +2428,8 @@ static int stac92xx_build_pcms(struct hd
 
 	info->name = "STAC92xx Analog";
 	info->stream[SNDRV_PCM_STREAM_PLAYBACK] = stac92xx_pcm_analog_playback;
+	info->stream[SNDRV_PCM_STREAM_PLAYBACK].nid =
+		spec->multiout.dac_nids[0];
 	info->stream[SNDRV_PCM_STREAM_CAPTURE] = stac92xx_pcm_analog_capture;
 	info->stream[SNDRV_PCM_STREAM_CAPTURE].nid = spec->adc_nids[0];
 	info->stream[SNDRV_PCM_STREAM_CAPTURE].substreams = spec->num_adcs;

