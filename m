Return-Path: <linux-kernel-owner+w=401wt.eu-S1760902AbYB2ASW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760902AbYB2ASW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 19:18:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754215AbYB2ASN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 19:18:13 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:65360 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694AbYB2ASM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 19:18:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=VPjVYA1k+7PKDtCbdav4y3cd3UsRNgk/kxZYM0LiC59kLFKsxmghP7wXDflwtj3uvDzlL8IurETPBT3p/YienR+Nk8wFeKgBJrIgS0R0GmG9Bl+ZXEPWfgkTvVQ8ouenJxnoVvrtY+tVxoSS/CNX4ocwSf89r/NFO72FNQfVs9g=
Subject: [PATCH 2/3] sound: patch_sigmatel.c fix shadowed variable warning
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 16:18:10 -0800
Message-Id: <1204244290.20280.102.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Temp variable in the loop shadows the second argument (which is otherwise
unused in this function).  Change this to defcfg as it is used to hold
the default config.
sound/pci/hda/patch_sigmatel.c:2759:18: warning: symbol 'cfg' shadows an earlier one
sound/pci/hda/patch_sigmatel.c:2734:26: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 sound/pci/hda/patch_sigmatel.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
index 2912047..6a7f508 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -2757,11 +2757,11 @@ static int stac9200_auto_create_lfe_ctls(struct hda_codec *codec,
 	if (lfe_pin == 0 && spec->autocfg.speaker_outs == 0) {
 		for (i = 0; i < spec->autocfg.line_outs && lfe_pin == 0x0; i++) {
 			hda_nid_t pin = spec->autocfg.line_out_pins[i];
-			unsigned long cfg;
-			cfg = snd_hda_codec_read(codec, pin, 0,
+			unsigned long defcfg;
+			defcfg = snd_hda_codec_read(codec, pin, 0,
 						 AC_VERB_GET_CONFIG_DEFAULT,
 						 0x00);
-			if (get_defcfg_device(cfg) == AC_JACK_SPEAKER) {
+			if (get_defcfg_device(defcfg) == AC_JACK_SPEAKER) {
 				unsigned long wcaps = get_wcaps(codec, pin);
 				wcaps &= (AC_WCAP_STEREO | AC_WCAP_OUT_AMP);
 				if (wcaps == AC_WCAP_OUT_AMP)
-- 
1.5.4.3.342.g99e8


