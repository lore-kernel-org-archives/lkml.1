Return-Path: <linux-kernel-owner+w=401wt.eu-S1753216AbZA1RjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbZA1RjF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 12:39:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbZA1Riz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 12:38:55 -0500
Received: from liberdade.minaslivre.org ([72.232.18.203]:49183 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbZA1Riy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 12:38:54 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: tiwai@suse.de
Cc: linux-kernel@vger.kernel.org,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH] AC97: Print AC97 flags in proc file to make debug it easier
Date: Wed, 28 Jan 2009 15:39:22 -0200
Message-Id: <1233164362-12635-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While debugging some code paths in AC97 codec patches and its suspend
and resume functions, getting to know the flags has proved useful to
follow those code paths.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 sound/pci/ac97/ac97_proc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/sound/pci/ac97/ac97_proc.c b/sound/pci/ac97/ac97_proc.c
index 060ea59..73b17d5 100644
--- a/sound/pci/ac97/ac97_proc.c
+++ b/sound/pci/ac97/ac97_proc.c
@@ -125,6 +125,8 @@ static void snd_ac97_proc_read_main(struct snd_ac97 *ac97, struct snd_info_buffe
         snd_iprintf(buffer, "PCI Subsys Device: 0x%04x\n\n",
                     ac97->subsystem_device);
 
+	snd_iprintf(buffer, "Flags: %x\n", ac97->flags);
+
 	if ((ac97->ext_id & AC97_EI_REV_MASK) >= AC97_EI_REV_23) {
 		val = snd_ac97_read(ac97, AC97_INT_PAGING);
 		snd_ac97_update_bits(ac97, AC97_INT_PAGING,
-- 
1.6.0.6

