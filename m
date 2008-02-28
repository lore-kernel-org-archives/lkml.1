Return-Path: <linux-kernel-owner+w=401wt.eu-S1762021AbYB1A4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762021AbYB1A4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 19:56:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbYB1A4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 19:56:12 -0500
Received: from el-out-1112.google.com ([209.85.162.177]:41507 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbYB1A4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 19:56:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=fX6FiP0FRxdrjGJRLM80T4R/UurnxC0sbL5IPo8eStZpbF1BAsTnjLIlMbZ+p3cbY8bFBg8lPokpY/rU8XEM9SdZi9Ohja7Za2sqITXzA5q5/VwK1jzE0AXk0yP2ZisOo1JHHPMKOP4cp0O7rNzsQqtfyEVDqSgQv0l0IRF4Bwk=
Subject: [PATCH 02/12] sound: ens1370.c fix shadowed variable warning
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 27 Feb 2008 16:56:04 -0800
Message-Id: <1204160165.20280.50.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

index is incremented only when AC97_EI_SPDIF and then assigned to
the index field.  Change the temporary name to is_spdif.

sound/pci/ens1370.c:1638:10: warning: symbol 'index' shadows an earlier one
sound/pci/ens1370.c:84:12: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 sound/pci/ens1370.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/pci/ens1370.c b/sound/pci/ens1370.c
index 72d85a5..52fae4a 100644
--- a/sound/pci/ens1370.c
+++ b/sound/pci/ens1370.c
@@ -1635,20 +1635,20 @@ static int __devinit snd_ensoniq_1371_mixer(struct ensoniq *ensoniq,
 	if (has_spdif > 0 ||
 	    (!has_spdif && es1371_quirk_lookup(ensoniq, es1371_spdif_present))) {
 		struct snd_kcontrol *kctl;
-		int i, index = 0;
+		int i, is_spdif = 0;
 
 		ensoniq->spdif_default = ensoniq->spdif_stream =
 			SNDRV_PCM_DEFAULT_CON_SPDIF;
 		outl(ensoniq->spdif_default, ES_REG(ensoniq, CHANNEL_STATUS));
 
 		if (ensoniq->u.es1371.ac97->ext_id & AC97_EI_SPDIF)
-			index++;
+			is_spdif++;
 
 		for (i = 0; i < ARRAY_SIZE(snd_es1371_mixer_spdif); i++) {
 			kctl = snd_ctl_new1(&snd_es1371_mixer_spdif[i], ensoniq);
 			if (!kctl)
 				return -ENOMEM;
-			kctl->id.index = index;
+			kctl->id.index = is_spdif;
 			err = snd_ctl_add(card, kctl);
 			if (err < 0)
 				return err;
-- 
1.5.4.3.342.g99e8


