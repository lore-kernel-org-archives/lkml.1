Return-Path: <linux-kernel-owner+w=401wt.eu-S1760939AbXEUT3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760939AbXEUT3y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757133AbXEUTVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:21:37 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:46359 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765353AbXEUTV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:21:29 -0400
Message-Id: <20070521191742.304404000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:16:56 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Daniel Drake <dsd@gentoo.org>,
       Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@suse.cz>
Subject: [patch 44/69] ALSA: hda-codec - Fix resume of STAC92xx codecs
Content-Disposition: inline; filename=alsa-hda-codec-fix-resume-of-stac92xx-codecs.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Takashi Iwai <tiwai@suse.de>

Added a missing call to resume mixer controls for STAC92xx codecs.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jaroslav Kysela <perex@suse.cz>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

---
 sound/pci/hda/patch_sigmatel.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.21.1.orig/sound/pci/hda/patch_sigmatel.c
+++ linux-2.6.21.1/sound/pci/hda/patch_sigmatel.c
@@ -1751,6 +1751,7 @@ static int stac92xx_resume(struct hda_co
 
 	stac92xx_init(codec);
 	stac92xx_set_config_regs(codec);
+	snd_hda_resume_ctls(codec, spec->mixer);
 	for (i = 0; i < spec->num_mixers; i++)
 		snd_hda_resume_ctls(codec, spec->mixers[i]);
 	if (spec->multiout.dig_out_nid)

-- 
