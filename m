Return-Path: <linux-kernel-owner+w=401wt.eu-S1763973AbXKOG4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763973AbXKOG4H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:56:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932551AbXKOGrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:47:01 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57894 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932468AbXKOGrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:47:00 -0500
Date: Wed, 14 Nov 2007 22:44:26 -0800
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
       Russ Cox <rsc@swtch.com>, Takashi Iwai <tiwai@suse.de>
Subject: [patch 10/40] ALSA: fix selector unit bug affecting some USB
	speakerphones
Message-ID: <20071115064426.GK19218@kroah.com>
References: <20071115062710.885284510@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-fix-selector-unit-bug-affecting-some-usb-speakerphones.patch"
In-Reply-To: <20071115064302.GA19218@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Russ Cox <rsc@swtch.com>

patch 38977e96cb32e658716e11a05ec7f1fc4618e0f3 in mainline.

[ALSA] fix selector unit bug affecting some USB speakerphones

Following the suggestion in this thread:
https://bugs.launchpad.net/ubuntu/+source/alsa-lib/+bug/26683
the correct upper bound on desc[0] is 5 + num_ins not 6 + num_ins,
because the index used later is 5+i, not 6+i.
This change makes my Vosky Chatterbox speakerphone work.
Apparently it also helps with the Minivox MV100.

Signed-off-by: Russ Cox <rsc@swtch.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/usb/usbmixer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/usbmixer.c
+++ b/sound/usb/usbmixer.c
@@ -1483,7 +1483,7 @@ static int parse_audio_selector_unit(str
 	struct snd_kcontrol *kctl;
 	char **namelist;
 
-	if (! num_ins || desc[0] < 6 + num_ins) {
+	if (! num_ins || desc[0] < 5 + num_ins) {
 		snd_printk(KERN_ERR "invalid SELECTOR UNIT descriptor %d\n", unitid);
 		return -EINVAL;
 	}

-- 
