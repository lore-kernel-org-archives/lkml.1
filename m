Return-Path: <linux-kernel-owner+w=401wt.eu-S1765042AbZGABBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765042AbZGABBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755044AbZGAAe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:34:57 -0400
Received: from kroah.org ([198.145.64.141]:60400 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761489AbZGAAez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:34:55 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:29 2009
Message-Id: <20090701002429.486907616@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Takashi Iwai <tiwai@suse.de>
Subject: [patch 052/108] ALSA: hda - Get back Input Source for ALC262 toshiba-s06 model
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=alsa-hda-get-back-input-source-for-alc262-toshiba-s06-model.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit ae14ef68e8e67ca5b8b29f0eb640f7c106617f4e upstream.

The commit f9e336f65b666b8f1764d17e9b7c21c90748a37e
    ALSA: hda - Unify capture mixer creation in realtek codes
removed the "Input Source" mixer element creation for toshiba-s06 model
because it contains a digital-mic input.

This patch take the control back.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11122,6 +11122,7 @@ static struct alc_config_preset alc262_p
 		.capsrc_nids = alc262_dmic_capsrc_nids,
 		.dac_nids = alc262_dac_nids,
 		.adc_nids = alc262_dmic_adc_nids, /* ADC0 */
+		.num_adc_nids = 1, /* single ADC */
 		.dig_out_nid = ALC262_DIGOUT_NID,
 		.num_channel_mode = ARRAY_SIZE(alc262_modes),
 		.channel_mode = alc262_modes,


