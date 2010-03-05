Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab0CEPeg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 10:34:36 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:36753 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab0CEPef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 10:34:35 -0500
Date: Fri, 5 Mar 2010 16:34:31 +0100
From: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
To: tiwai@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [patch] ALSA hda: uninitialized variable fix
Message-ID: <20100305153431.GA17493@gambetta>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Takashi,

Commit eaa9b3a748539651f50e3a234c8854e1b42a839a introduced the following
uninitialized warning:

	sound/pci/hda/patch_realtek.c: In function 'set_capture_mixer':
	sound/pci/hda/patch_realtek.c:4928: warning: 'pin' is used uninitialized in this function
	sound/pci/hda/patch_realtek.c:4918: note: 'pin' was declared here

It appears indeed that 'pin' needs to be initialized to 0.

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index e8cbe21..5c89242 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4915,7 +4915,7 @@ static void fixup_automic_adc(struct hda_codec *codec)
 static void fixup_single_adc(struct hda_codec *codec)
 {
 	struct alc_spec *spec = codec->spec;
-	hda_nid_t pin;
+	hda_nid_t pin = 0;
 	int i;
 
 	/* search for the input pin; there must be only one */
