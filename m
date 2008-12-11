Return-Path: <linux-kernel-owner+w=401wt.eu-S1757171AbYLKTfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171AbYLKTfk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:35:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757828AbYLKTS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:18:56 -0500
Received: from kroah.org ([198.145.64.141]:56303 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757808AbYLKTSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:18:53 -0500
Date: Thu, 11 Dec 2008 11:15:21 -0800
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
       alan@lxorguk.ukuu.org.uk, "Robin H. Johnson" <robbat2@gentoo.org>,
       Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>
Subject: [patch 49/83] ALSA: HDA: patch_analog: Fix SPDIF output on AD1989B
Message-ID: <20081211191521.GW5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-hda-patch_analog-fix-spdif-output-on-ad1989b.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Robin H. Johnson <robbat2@gentoo.org>

commit e8bfc6c1d22395ab706784cb1bcd60f6f9569ed6 upstream

The SPDIF pins for AD1989 are not enabled by default. Set OUT bit so that they
actually work. Also initialize the HDMI SPDIF at the same time.

Signed-off-by: Robin H. Johnson <robbat2@gentoo.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 sound/pci/hda/patch_analog.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -2247,8 +2247,12 @@ static struct hda_verb ad1988_spdif_init
 
 /* AD1989 has no ADC -> SPDIF route */
 static struct hda_verb ad1989_spdif_init_verbs[] = {
-	/* SPDIF out pin */
+	/* SPDIF-1 out pin */
+	{0x1b, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_OUT },
 	{0x1b, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_UNMUTE | 0x27}, /* 0dB */
+	/* SPDIF-2/HDMI out pin */
+	{0x1d, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_OUT },
+	{0x1d, AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_UNMUTE | 0x27}, /* 0dB */
 	{ }
 };
 

