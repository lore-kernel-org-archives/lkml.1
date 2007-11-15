Return-Path: <linux-kernel-owner+w=401wt.eu-S932969AbXKOGzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932969AbXKOGzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:55:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932545AbXKOGq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:46:57 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57876 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932532AbXKOGq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:46:56 -0500
Date: Wed, 14 Nov 2007 22:44:21 -0800
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
Subject: [patch 09/40] ALSA: hda-codec - Avoid zero NID in line_out_pinsof
	STAC codecs
Message-ID: <20071115064421.GJ19218@kroah.com>
References: <20071115062710.885284510@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-hda-codec-avoid-zero-nid-in-line_out_pins-of-stac-codecs.patch"
In-Reply-To: <20071115064302.GA19218@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Takashi Iwai <tiwai@suse.de>

patch c480f79bdca58923e605ff5e4698cfe1779bae70 in mainline

[ALSA] hda-codec - Avoid zero NID in line_out_pins[] of STAC codecs

The STAC codes adds line_out_pins[] for shared mic/line-inputs accordingly.
But, the current code may give a hole with NID=0 in some setting, which
results in an error at probe.  This patch fixes the problem.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_sigmatel.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -1182,7 +1182,8 @@ static int stac92xx_add_dyn_out_pins(str
 	case 3:
 		/* add line-in as side */
 		if (cfg->input_pins[AUTO_PIN_LINE] && num_dacs > 3) {
-			cfg->line_out_pins[3] = cfg->input_pins[AUTO_PIN_LINE];
+			cfg->line_out_pins[cfg->line_outs] =
+				cfg->input_pins[AUTO_PIN_LINE];
 			spec->line_switch = 1;
 			cfg->line_outs++;
 		}
@@ -1190,12 +1191,14 @@ static int stac92xx_add_dyn_out_pins(str
 	case 2:
 		/* add line-in as clfe and mic as side */
 		if (cfg->input_pins[AUTO_PIN_LINE] && num_dacs > 2) {
-			cfg->line_out_pins[2] = cfg->input_pins[AUTO_PIN_LINE];
+			cfg->line_out_pins[cfg->line_outs] =
+				cfg->input_pins[AUTO_PIN_LINE];
 			spec->line_switch = 1;
 			cfg->line_outs++;
 		}
 		if (cfg->input_pins[AUTO_PIN_MIC] && num_dacs > 3) {
-			cfg->line_out_pins[3] = cfg->input_pins[AUTO_PIN_MIC];
+			cfg->line_out_pins[cfg->line_outs] =
+				cfg->input_pins[AUTO_PIN_MIC];
 			spec->mic_switch = 1;
 			cfg->line_outs++;
 		}
@@ -1203,12 +1206,14 @@ static int stac92xx_add_dyn_out_pins(str
 	case 1:
 		/* add line-in as surr and mic as clfe */
 		if (cfg->input_pins[AUTO_PIN_LINE] && num_dacs > 1) {
-			cfg->line_out_pins[1] = cfg->input_pins[AUTO_PIN_LINE];
+			cfg->line_out_pins[cfg->line_outs] =
+				cfg->input_pins[AUTO_PIN_LINE];
 			spec->line_switch = 1;
 			cfg->line_outs++;
 		}
 		if (cfg->input_pins[AUTO_PIN_MIC] && num_dacs > 2) {
-			cfg->line_out_pins[2] = cfg->input_pins[AUTO_PIN_MIC];
+			cfg->line_out_pins[cfg->line_outs] =
+				cfg->input_pins[AUTO_PIN_MIC];
 			spec->mic_switch = 1;
 			cfg->line_outs++;
 		}

-- 
