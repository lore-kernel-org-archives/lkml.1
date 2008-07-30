Return-Path: <linux-kernel-owner+w=401wt.eu-S1761249AbYG3Xhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761249AbYG3Xhx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 19:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761229AbYG3XhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 19:37:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:34117 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761204AbYG3XhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 19:37:20 -0400
Date: Wed, 30 Jul 2008 16:27:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, tiwai@suse.de
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
       alan@lxorguk.ukuu.org.uk, Akio Idehara <zbe64533@gmail.com>
Subject: [patch 14/29] ALSA: hda - Fix "alc262_sony_unsol" hda_verb array
Message-ID: <20080730232712.GO30670@suse.de>
References: <20080730231003.655833364@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-hda-fix-alc262_sony_unsol-hda_verb-array.patch"
In-Reply-To: <20080730232451.GA30670@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: Akio Idehara <zbe64533@gmail.com>

[ALSA] hda - Fix "alc262_sony_unsol[]" hda_verb array

commit 7b1e8795ebfe1705153d1001f2a899119f4d9012 upstream

I think that hda_verb array must have "terminator (empty array)".
But alc262_sony_unsol[] does not have it.
And it causes gcc-4.3's buggy behavior
with snd_hda_sequence_write().

Signed-off-by: Akio Idehara <zbe64533@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8517,6 +8517,7 @@ static struct hda_verb alc262_sony_unsol
 
 	{0x15, AC_VERB_SET_UNSOLICITED_ENABLE, AC_USRSP_EN | ALC880_HP_EVENT},
 	{0x15, AC_VERB_SET_PIN_WIDGET_CONTROL, PIN_HP},
+	{}
 };
 
 /* mute/unmute internal speaker according to the hp jack and mute state */

-- 
