Return-Path: <linux-kernel-owner+w=401wt.eu-S1753948AbYJVD2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbYJVD2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 23:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbYJVD2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 23:28:09 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:9284 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbYJVD2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 23:28:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=jYHVHvhBmGJYVO+Ju0r4Gzsdg6ldENdRP3/2lLTQ5aIsOxemdeIoF5kS8VWCSc4ZtE
         no0YDEFZ44UNo7uNBuaAmsb7Hs1s++4WFZIDrFF1Z4q8nTZ94degBS+9AwwCYkm69/dF
         tH23nRFZXjW2r7bMDbzYk7P/1PwszAN5Q/eng=
Subject: [PATCH] sound: correct bracketing in spdif test
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Matthew Ranostay <mranostay@embeddedalley.com>,
       Takashi Iwai <tiwai@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 20:28:04 -0700
Message-Id: <1224646084.5768.9.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Noticed by sparse:
sound/pci/hda/patch_sigmatel.c:1285:43: warning: dubious: !x & y

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 sound/pci/hda/patch_sigmatel.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
index a2ac720..788fdc6 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -1282,7 +1282,7 @@ static int stac92xx_build_controls(struct hda_codec *codec)
 			return err;
 		spec->multiout.share_spdif = 1;
 	}
-	if (spec->dig_in_nid && (!spec->gpio_dir & 0x01)) {
+	if (spec->dig_in_nid && !(spec->gpio_dir & 0x01)) {
 		err = snd_hda_create_spdif_in_ctls(codec, spec->dig_in_nid);
 		if (err < 0)
 			return err;
-- 
1.6.0.2.824.geb4d2

