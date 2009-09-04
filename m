Return-Path: <linux-kernel-owner+w=401wt.eu-S934164AbZIDUQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934164AbZIDUQL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:16:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934136AbZIDUQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:16:08 -0400
Received: from kroah.org ([198.145.64.141]:36316 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934116AbZIDUOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:14:48 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 13:08:56 2009
Message-Id: <20090904200856.656372719@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 13:07:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Takashi Iwai <tiwai@suse.de>
Subject: [patch 43/48] ALSA: hda - Add missing vmaster initialization for ALC269
References: <20090904200712.724048145@mini.kroah.org>
Content-Disposition: inline; filename=alsa-hda-add-missing-vmaster-initialization-for-alc269.patch
In-Reply-To: <20090904201112.GA8274@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Takashi Iwai <tiwai@suse.de>

commit 100d5eb36ba20dc0b99a17ea2b9800c567bfc3d1 upstream.

Without the initialization of vmaster NID, the dB information got
confused for ALC269 codec.

Reference: Novell bnc#527361
	https://bugzilla.novell.com/show_bug.cgi?id=527361

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11640,6 +11640,8 @@ static int patch_alc269(struct hda_codec
 	spec->num_adc_nids = ARRAY_SIZE(alc269_adc_nids);
 	spec->capsrc_nids = alc269_capsrc_nids;
 
+	spec->vmaster_nid = 0x02;
+
 	codec->patch_ops = alc_patch_ops;
 	if (board_config == ALC269_AUTO)
 		spec->init_hook = alc269_auto_init;


