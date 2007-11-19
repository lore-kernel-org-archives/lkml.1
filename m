Return-Path: <linux-kernel-owner+w=401wt.eu-S1752663AbXKSS0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbXKSS0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 13:26:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbXKSSWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 13:22:17 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49261 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbXKSSWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 13:22:15 -0500
Date: Mon, 19 Nov 2007 10:19:07 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Takashi Iwai <tiwai@suse.de>
Subject: [patch 14/26] ALSA: hda-codec - Add array terminator for dmic in
	STAC codec
Message-ID: <20071119181907.GO15425@kroah.com>
References: <20071119181438.617190424@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-hda-codec-add-array-terminator-for-dmic-in-stac-codec.patch"
In-Reply-To: <20071119181746.GA15425@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Takashi Iwai <tiwai@suse.de>

patch f6e9852ad05fa28301c83d4e2b082620de010358 in mainline.

[ALSA] hda-codec - Add array terminator for dmic in STAC codec

Reported by Jan-Marek Glogowski.

The dmic array is passed to snd_hda_parse_pin_def_config() and
should be zero-terminated.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_sigmatel.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -153,8 +153,9 @@ static hda_nid_t stac925x_dac_nids[1] = 
         0x02,
 };
 
-static hda_nid_t stac925x_dmic_nids[1] = {
-	0x15, 
+#define STAC925X_NUM_DMICS	1
+static hda_nid_t stac925x_dmic_nids[STAC925X_NUM_DMICS + 1] = {
+	0x15, 0
 };
 
 static hda_nid_t stac922x_adc_nids[2] = {
@@ -181,8 +182,9 @@ static hda_nid_t stac9205_mux_nids[2] = 
         0x19, 0x1a
 };
 
-static hda_nid_t stac9205_dmic_nids[2] = {
-        0x17, 0x18,
+#define STAC9205_NUM_DMICS	2
+static hda_nid_t stac9205_dmic_nids[STAC9205_NUM_DMICS + 1] = {
+        0x17, 0x18, 0
 };
 
 static hda_nid_t stac9200_pin_nids[8] = {
@@ -1972,7 +1974,7 @@ static int patch_stac925x(struct hda_cod
 	case 0x83847633: /* STAC9202D */
 	case 0x83847636: /* STAC9251  */
 	case 0x83847637: /* STAC9251D */
-		spec->num_dmics = 1;
+		spec->num_dmics = STAC925X_NUM_DMICS;
 		spec->dmic_nids = stac925x_dmic_nids;
 		break;
 	default:
@@ -2202,7 +2204,7 @@ static int patch_stac9205(struct hda_cod
 	spec->mux_nids = stac9205_mux_nids;
 	spec->num_muxes = ARRAY_SIZE(stac9205_mux_nids);
 	spec->dmic_nids = stac9205_dmic_nids;
-	spec->num_dmics = ARRAY_SIZE(stac9205_dmic_nids);
+	spec->num_dmics = STAC9205_NUM_DMICS;
 	spec->dmux_nid = 0x1d;
 
 	spec->init = stac9205_core_init;

-- 
