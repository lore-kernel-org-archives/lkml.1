Return-Path: <linux-kernel-owner+w=401wt.eu-S1761035AbZAWBRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761035AbZAWBRt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 20:17:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760082AbZAWBOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 20:14:49 -0500
Received: from kroah.org ([198.145.64.141]:50443 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760054AbZAWBOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 20:14:48 -0500
Date: Thu, 22 Jan 2009 17:11:48 -0800
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
       alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [patch 11/46] ALSA: hda - Fix HP dv5 mic input
Message-ID: <20090123011148.GL19756@kroah.com>
References: <20090123010651.683741823@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-hda-fix-hp-dv5-mic-input.patch"
In-Reply-To: <20090123011110.GA19756@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 1b0652eb588e57c3ab230e0291e7da99c7e665e0 upstream.

Fix HP dv5 (103c:3603) built-in mic input.

Reference: kernel bug 12440
	http://bugzilla.kernel.org/show_bug.cgi?id=12440

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_sigmatel.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -89,6 +89,7 @@ enum {
 	STAC_DELL_M4_2,
 	STAC_DELL_M4_3,
 	STAC_HP_M4,
+	STAC_HP_DV5,
 	STAC_92HD71BXX_MODELS
 };
 
@@ -1702,6 +1703,7 @@ static unsigned int *stac92hd71bxx_brd_t
 	[STAC_DELL_M4_2]	= dell_m4_2_pin_configs,
 	[STAC_DELL_M4_3]	= dell_m4_3_pin_configs,
 	[STAC_HP_M4]		= NULL,
+	[STAC_HP_DV5]		= NULL,
 };
 
 static const char *stac92hd71bxx_models[STAC_92HD71BXX_MODELS] = {
@@ -1710,6 +1712,7 @@ static const char *stac92hd71bxx_models[
 	[STAC_DELL_M4_2] = "dell-m4-2",
 	[STAC_DELL_M4_3] = "dell-m4-3",
 	[STAC_HP_M4] = "hp-m4",
+	[STAC_HP_DV5] = "hp-dv5",
 };
 
 static struct snd_pci_quirk stac92hd71bxx_cfg_tbl[] = {
@@ -1723,7 +1726,7 @@ static struct snd_pci_quirk stac92hd71bx
 	SND_PCI_QUIRK(PCI_VENDOR_ID_HP, 0x30fc,
 		      "HP dv7", STAC_HP_M4),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_HP, 0x3603,
-		      "HP dv5", STAC_HP_M4),
+		      "HP dv5", STAC_HP_DV5),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_HP, 0x361a,
 				"unknown HP", STAC_HP_M4),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x0233,

