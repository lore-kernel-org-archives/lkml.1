Return-Path: <linux-kernel-owner+w=401wt.eu-S932385AbYLKTkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385AbYLKTkj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:40:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756395AbYLKTTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:19:12 -0500
Received: from kroah.org ([198.145.64.141]:56584 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756767AbYLKTTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:19:10 -0500
Date: Thu, 11 Dec 2008 11:16:06 -0800
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
Subject: [patch 62/83] ALSA: hda - No Headphone as Line-out swich without
	line-outs
Message-ID: <20081211191606.GJ5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-hda-no-headphone-as-line-out-swich-without-line-outs.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 95026623da32848bc93fbfb472dc8737487df450 upstream

STAC/IDT driver creates "Headphone as Line-Out" switch even if there
is no line-out pins on the machine.  For devices only with headpohnes
and speaker-outs, this switch shouldn't be created.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 sound/pci/hda/patch_sigmatel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -2505,7 +2505,7 @@ static int stac92xx_auto_create_multi_ou
 		}
 	}
 
-	if (cfg->hp_outs > 1) {
+	if (cfg->hp_outs > 1 && cfg->line_out_type == AUTO_PIN_LINE_OUT) {
 		err = stac92xx_add_control(spec,
 			STAC_CTL_WIDGET_HP_SWITCH,
 			"Headphone as Line Out Switch", 0);

