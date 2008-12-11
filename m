Return-Path: <linux-kernel-owner+w=401wt.eu-S1759604AbYLKTeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759604AbYLKTeF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:34:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757764AbYLKTSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:18:51 -0500
Received: from kroah.org ([198.145.64.141]:56303 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757325AbYLKTSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:18:49 -0500
Date: Thu, 11 Dec 2008 11:15:13 -0800
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
       alan@lxorguk.ukuu.org.uk, Gilberto <gilberto@sistemafenix.com.br>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>
Subject: [patch 45/83] ALSA: hda: Add support for ECS/PC Chips boards with
	Sigmatel codecs
Message-ID: <20081211191513.GS5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-hda-add-support-for-ecs-pc-chips-boards-with-sigmatel-codecs.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mauro Carvalho Chehab <mchehab@infradead.org>

commit 8c650087992f1d7a3a7be2e632f4e85a52d20619 upstream

Thanks to Sistema Fenix (http://www.sistemafenix.com.br/) and CDI Brasil
(www.cdibrasil.com.br/) for sponsoring this development.

Signed-off-by: Gilberto <gilberto@sistemafenix.com.br>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 sound/pci/hda/patch_sigmatel.c |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -105,6 +105,7 @@ enum {
 	STAC_MACBOOK_PRO_V2,
 	STAC_IMAC_INTEL,
 	STAC_IMAC_INTEL_20,
+	STAC_ECS_202,
 	STAC_922X_DELL_D81,
 	STAC_922X_DELL_D82,
 	STAC_922X_DELL_M81,
@@ -1478,6 +1479,11 @@ static unsigned int intel_mac_v5_pin_con
 	0x400000fc, 0x400000fb,
 };
 
+static unsigned int ecs202_pin_configs[10] = {
+	0x0221401f, 0x02a19020, 0x01a19020, 0x01114010,
+	0x408000f0, 0x01813022, 0x074510a0, 0x40c400f1,
+	0x9037012e, 0x40e000f2,
+};
 
 static unsigned int *stac922x_brd_tbl[STAC_922X_MODELS] = {
 	[STAC_D945_REF] = ref922x_pin_configs,
@@ -1496,6 +1502,7 @@ static unsigned int *stac922x_brd_tbl[ST
 	[STAC_MACBOOK_PRO_V2] = intel_mac_v3_pin_configs,
 	[STAC_IMAC_INTEL] = intel_mac_v2_pin_configs,
 	[STAC_IMAC_INTEL_20] = intel_mac_v3_pin_configs,
+	[STAC_ECS_202] = ecs202_pin_configs,
 	[STAC_922X_DELL_D81] = dell_922x_d81_pin_configs,
 	[STAC_922X_DELL_D82] = dell_922x_d82_pin_configs,	
 	[STAC_922X_DELL_M81] = dell_922x_m81_pin_configs,
@@ -1519,6 +1526,7 @@ static const char *stac922x_models[STAC_
 	[STAC_MACBOOK_PRO_V2]	= "macbook-pro",
 	[STAC_IMAC_INTEL] = "imac-intel",
 	[STAC_IMAC_INTEL_20] = "imac-intel-20",
+	[STAC_ECS_202] = "ecs202",
 	[STAC_922X_DELL_D81] = "dell-d81",
 	[STAC_922X_DELL_D82] = "dell-d82",
 	[STAC_922X_DELL_M81] = "dell-m81",
@@ -1605,6 +1613,33 @@ static struct snd_pci_quirk stac922x_cfg
 		      "unknown Dell", STAC_922X_DELL_D81),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x01d7,
 		      "Dell XPS M1210", STAC_922X_DELL_M82),
+	/* ECS/PC Chips boards */
+	SND_PCI_QUIRK(0x1019, 0x2144,
+		      "ECS/PC chips", STAC_ECS_202),
+	SND_PCI_QUIRK(0x1019, 0x2608,
+		      "ECS/PC chips", STAC_ECS_202),
+	SND_PCI_QUIRK(0x1019, 0x2633,
+		      "ECS/PC chips P17G/1333", STAC_ECS_202),
+	SND_PCI_QUIRK(0x1019, 0x2811,
+		      "ECS/PC chips", STAC_ECS_202),
+	SND_PCI_QUIRK(0x1019, 0x2812,
+		      "ECS/PC chips", STAC_ECS_202),
+	SND_PCI_QUIRK(0x1019, 0x2813,
+		      "ECS/PC chips", STAC_ECS_202),
+	SND_PCI_QUIRK(0x1019, 0x2814,
+		      "ECS/PC chips", STAC_ECS_202),
+	SND_PCI_QUIRK(0x1019, 0x2815,
+		      "ECS/PC chips", STAC_ECS_202),
+	SND_PCI_QUIRK(0x1019, 0x2816,
+		      "ECS/PC chips", STAC_ECS_202),
+	SND_PCI_QUIRK(0x1019, 0x2817,
+		      "ECS/PC chips", STAC_ECS_202),
+	SND_PCI_QUIRK(0x1019, 0x2818,
+		      "ECS/PC chips", STAC_ECS_202),
+	SND_PCI_QUIRK(0x1019, 0x2819,
+		      "ECS/PC chips", STAC_ECS_202),
+	SND_PCI_QUIRK(0x1019, 0x2820,
+		      "ECS/PC chips", STAC_ECS_202),
 	{} /* terminator */
 };
 

