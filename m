Return-Path: <linux-kernel-owner+w=401wt.eu-S933088AbXKOG44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933088AbXKOG44 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:56:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765778AbXKOGrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:47:08 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57917 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510AbXKOGrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:47:05 -0500
Date: Wed, 14 Nov 2007 22:44:32 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Takashi Iwai <tiwai@suse.de>
Subject: [patch 12/40] ALSA: emu10k1 - Fix memory corruption
Message-ID: <20071115064432.GM19218@kroah.com>
References: <20071115062710.885284510@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-emu10k1-fix-memory-corruption.patch"
In-Reply-To: <20071115064302.GA19218@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Takashi Iwai <tiwai@suse.de>

patch 7583cb51a1e276591f57a2fae05489c878f8ef54 from mainline.

[ALSA] emu10k1 - Fix memory corruption

The number of mixer elements for SPDIF control don't match with the
actual array size (3).  This may result in a memory corruption that
overwrites the i2c_capture_source field (ALSA bug#3095).

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/emu10k1/emumixer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/pci/emu10k1/emumixer.c
+++ b/sound/pci/emu10k1/emumixer.c
@@ -871,7 +871,7 @@ static struct snd_kcontrol_new snd_emu10
 	.access =	SNDRV_CTL_ELEM_ACCESS_READ,
 	.iface =        SNDRV_CTL_ELEM_IFACE_PCM,
 	.name =         SNDRV_CTL_NAME_IEC958("",PLAYBACK,MASK),
-	.count =	4,
+	.count =	3,
 	.info =         snd_emu10k1_spdif_info,
 	.get =          snd_emu10k1_spdif_get_mask
 };
@@ -880,7 +880,7 @@ static struct snd_kcontrol_new snd_emu10
 {
 	.iface =	SNDRV_CTL_ELEM_IFACE_PCM,
 	.name =         SNDRV_CTL_NAME_IEC958("",PLAYBACK,DEFAULT),
-	.count =	4,
+	.count =	3,
 	.info =         snd_emu10k1_spdif_info,
 	.get =          snd_emu10k1_spdif_get,
 	.put =          snd_emu10k1_spdif_put

-- 
