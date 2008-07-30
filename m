Return-Path: <linux-kernel-owner+w=401wt.eu-S1754523AbYG3XiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbYG3XiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 19:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760501AbYG3Xhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 19:37:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:34153 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760340AbYG3Xhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 19:37:43 -0400
Date: Wed, 30 Jul 2008 16:27:15 -0700
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
       alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>,
       Pierre Ossman <drzeus@drzeus.cx>, Jaroslav Kysela <perex@perex.cz>
Subject: [patch 15/29] ALSA: trident - pause s/pdif output
Message-ID: <20080730232715.GP30670@suse.de>
References: <20080730231003.655833364@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-trident-pause-s-pdif-output.patch"
In-Reply-To: <20080730232451.GA30670@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.25-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: Pierre Ossman <drzeus@drzeus.cx>

Commit 981bcead3f2279a1ec6fb5f2c57aff79ed61a700 upstream.

Stop the S/PDIF DMA engine and output when the device is told to pause.
It will keep on looping the current buffer contents if this isn't done.

Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
Tested-by: Rene Herman <rene.herman@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/trident/trident_main.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/sound/pci/trident/trident_main.c
+++ b/sound/pci/trident/trident_main.c
@@ -1590,7 +1590,10 @@ static int snd_trident_trigger(struct sn
 	if (spdif_flag) {
 		if (trident->device != TRIDENT_DEVICE_ID_SI7018) {
 			outl(trident->spdif_pcm_bits, TRID_REG(trident, NX_SPCSTATUS));
-			outb(trident->spdif_pcm_ctrl, TRID_REG(trident, NX_SPCTRL_SPCSO + 3));
+			val = trident->spdif_pcm_ctrl;
+			if (!go)
+				val &= ~(0x28);
+			outb(val, TRID_REG(trident, NX_SPCTRL_SPCSO + 3));
 		} else {
 			outl(trident->spdif_pcm_bits, TRID_REG(trident, SI_SPDIF_CS));
 			val = inl(TRID_REG(trident, SI_SERIAL_INTF_CTRL)) | SPDIF_EN;

-- 
