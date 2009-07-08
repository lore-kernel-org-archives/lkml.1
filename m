Return-Path: <linux-kernel-owner+w=401wt.eu-S1759982AbZGHF60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759982AbZGHF60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 01:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759501AbZGHF6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 01:58:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:39427 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbZGHF6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 01:58:17 -0400
Subject: [PATCH] sound: pci/hda/patch_via.c fix compilation warning
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Takashi Iwai <tiwai@suse.de>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090708141825.da103bc8.sfr@canb.auug.org.au>
References: <20090708141825.da103bc8.sfr@canb.auug.org.au>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 11:27:50 +0530
Message-Id: <1247032670.4065.1.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-08 at 14:18 +1000, Stephen Rothwell wrote:
> Hi Takashi,
> 
> Today's linux-next build (x86_64 allmodconfig) produced these warnings:
> 
> sound/pci/hda/patch_via.c: In function 'via_mux_enum_put':
> sound/pci/hda/patch_via.c:395: warning: unused variable 'vendor_id'
> sound/pci/hda/patch_via.c: In function 'get_mux_nids':
> sound/pci/hda/patch_via.c:1337: warning: unused variable 'type'
> sound/pci/hda/patch_via.c:1354: warning: no return statement in function returning non-void
> 
> Introduced by commit 337b9d02b4873ceac91565272545fb6fd446d939 ("ALSA: hda
> - Fix capture source selection in patch_via.c").
> 

[PATCH] sound: pci/hda/patch_via.c fix compilation warning

sound/pci/hda/patch_via.c: In function 'via_mux_enum_put':
sound/pci/hda/patch_via.c:395: warning: unused variable 'vendor_id'
sound/pci/hda/patch_via.c: In function 'get_mux_nids':
sound/pci/hda/patch_via.c:1337: warning: unused variable 'type'
sound/pci/hda/patch_via.c:1354: warning: no return statement in function returning non-void

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 sound/pci/hda/patch_via.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/sound/pci/hda/patch_via.c b/sound/pci/hda/patch_via.c
index 38db459..d05b718 100644
--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -392,7 +392,6 @@ static int via_mux_enum_put(struct snd_kcontrol *kcontrol,
 	struct hda_codec *codec = snd_kcontrol_chip(kcontrol);
 	struct via_spec *spec = codec->spec;
 	unsigned int adc_idx = snd_ctl_get_ioffidx(kcontrol, &ucontrol->id);
-	unsigned int vendor_id = codec->vendor_id;
 
 	if (!spec->mux_nids[adc_idx])
 		return -EINVAL;
@@ -1330,11 +1329,10 @@ static int via_auto_init(struct hda_codec *codec)
 	return 0;
 }
 
-static int get_mux_nids(struct hda_codec *codec)
+static void get_mux_nids(struct hda_codec *codec)
 {
 	struct via_spec *spec = codec->spec;
 	hda_nid_t nid, conn[8];
-	unsigned int type;
 	int i, n;
 
 	for (i = 0; i < spec->num_adc_nids; i++) {
-- 
1.6.0.6



