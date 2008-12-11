Return-Path: <linux-kernel-owner+w=401wt.eu-S1759648AbYLKTd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759648AbYLKTd0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:33:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757738AbYLKTSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:18:48 -0500
Received: from kroah.org ([198.145.64.141]:56274 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757724AbYLKTSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:18:47 -0500
Date: Thu, 11 Dec 2008 11:15:08 -0800
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
Subject: [patch 43/83] ALSA: HDA: hda_proc: Fix printf format specifier
Message-ID: <20081211191508.GQ5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-hda-hda_proc-fix-printf-format-specifier.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Robin H. Johnson <robbat2@gentoo.org>

commit 0481f4534910e644626a3607b2a1a979420a2d05 upstream.

The Pincap output had a typod format specifier, leading to an extraneous "08"
in the output, which is a reserved bit of the Vref field, and was really
confused :-).

Signed-off-by: Robin H. Johnson <robbat2@gentoo.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/hda_proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/hda_proc.c
+++ b/sound/pci/hda/hda_proc.c
@@ -216,7 +216,7 @@ static void print_pin_caps(struct snd_in
 	unsigned int caps, val;
 
 	caps = snd_hda_param_read(codec, nid, AC_PAR_PIN_CAP);
-	snd_iprintf(buffer, "  Pincap 0x08%x:", caps);
+	snd_iprintf(buffer, "  Pincap 0x%08x:", caps);
 	if (caps & AC_PINCAP_IN)
 		snd_iprintf(buffer, " IN");
 	if (caps & AC_PINCAP_OUT)

