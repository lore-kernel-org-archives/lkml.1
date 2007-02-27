Return-Path: <linux-kernel-owner+w=401wt.eu-S1161453AbXB0AHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161453AbXB0AHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 19:07:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161457AbXB0AHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 19:07:10 -0500
Received: from mail.kroah.org ([69.55.234.183]:44807 "EHLO perch.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161453AbXB0AHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 19:07:08 -0500
Date: Mon, 26 Feb 2007 16:06:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>,
       Jaroslav Kysela <perex@suse.cz>
Subject: [patch 8/9] hda-codec - Dont return error at initialization of modem codec
Message-ID: <20070227000643.GI6283@kroah.com>
References: <20070226235248.438556696@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hda-codec-don-t-return-error-at-initialization-of-modem-codec.patch"
In-Reply-To: <20070227000538.GA6283@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ALSA] hda-codec - Don't return error at initialization of modem codec

Some modem codec seem to fail in the initialization, and this
stopped loading of the whole module although the audio is OK.
Since it's usually a non-fatal issue, the driver tries to proceed
to initialize now.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jaroslav Kysela <perex@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_si3054.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.19.5.orig/sound/pci/hda/patch_si3054.c
+++ linux-2.6.19.5/sound/pci/hda/patch_si3054.c
@@ -243,7 +243,8 @@ static int si3054_init(struct hda_codec 
 
 	if((val&SI3054_MEI_READY) != SI3054_MEI_READY) {
 		snd_printk(KERN_ERR "si3054: cannot initialize. EXT MID = %04x\n", val);
-		return -EACCES;
+		/* let's pray that this is no fatal error */
+		/* return -EACCES; */
 	}
 
 	SET_REG(codec, SI3054_GPIO_POLARITY, 0xffff);

--
