Return-Path: <linux-kernel-owner+w=401wt.eu-S932112AbYLKTgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112AbYLKTgo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:36:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757814AbYLKTS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:18:58 -0500
Received: from kroah.org ([198.145.64.141]:56446 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756296AbYLKTS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:18:57 -0500
Date: Thu, 11 Dec 2008 11:15:29 -0800
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
       alan@lxorguk.ukuu.org.uk, Clive Messer <clive@vacuumtube.org.uk>,
       Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>
Subject: [patch 52/83] ALSA: hda - Fix another ALC889A (rev 0x100101)
Message-ID: <20081211191529.GZ5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-hda-fix-another-alc889a.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Clive Messer <clive@vacuumtube.org.uk>

commit 669faba27f2f7b04b9228d20e30e7f584f0becd5 upstream

ALC889A hardware (id 0x10ec0885 rev 0x100101) to use patch_alc883

Signed-off-by: Clive Messer <clive@vacuumtube.org.uk>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 sound/pci/hda/patch_realtek.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6565,7 +6565,8 @@ static int patch_alc882(struct hda_codec
 			break;
 		default:
 			/* ALC889A is handled better as ALC888-compatible */
-			if (codec->revision_id == 0x100103) {
+			if (codec->revision_id == 0x100101 ||
+			    codec->revision_id == 0x100103) {
 				alc_free(codec);
 				return patch_alc883(codec);
 			}
@@ -14959,6 +14960,8 @@ struct hda_codec_preset snd_hda_preset_r
 	{ .id = 0x10ec0880, .name = "ALC880", .patch = patch_alc880 },
 	{ .id = 0x10ec0882, .name = "ALC882", .patch = patch_alc882 },
 	{ .id = 0x10ec0883, .name = "ALC883", .patch = patch_alc883 },
+	{ .id = 0x10ec0885, .rev = 0x100101, .name = "ALC889A",
+	  .patch = patch_alc882 }, /* should be patch_alc883() in future */
 	{ .id = 0x10ec0885, .rev = 0x100103, .name = "ALC889A",
 	  .patch = patch_alc882 }, /* should be patch_alc883() in future */
 	{ .id = 0x10ec0885, .name = "ALC885", .patch = patch_alc882 },

