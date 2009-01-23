Return-Path: <linux-kernel-owner+w=401wt.eu-S1760854AbZAWBTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760854AbZAWBTW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 20:19:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760170AbZAWBO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 20:14:56 -0500
Received: from kroah.org ([198.145.64.141]:50467 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760109AbZAWBOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 20:14:50 -0500
Date: Thu, 22 Jan 2009 17:11:53 -0800
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
Subject: [patch 13/46] ALSA: hda - Dont reset HP pinctl in patch_sigmatel.c
Message-ID: <20090123011153.GN19756@kroah.com>
References: <20090123010651.683741823@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-hda-don-t-reset-hp-pinctl-in-patch_sigmatel.c.patch"
In-Reply-To: <20090123011110.GA19756@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 8317e0b0c2234f5f1f5d54804e4093d11bc0dffa upstream.

Resetting HP pinctl at the unplugged state may cause a sort of regression
on some devices because of their wrong pin configuration.

A simple workaround is to disable the pin reset.  This is ugly and may be
not good from the power-saving POV (if any), but damn simple.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/patch_sigmatel.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -3985,8 +3985,19 @@ static void stac92xx_hp_detect(struct hd
 			continue;
 		if (presence)
 			stac92xx_set_pinctl(codec, cfg->hp_pins[i], val);
+#if 0 /* FIXME */
+/* Resetting the pinctl like below may lead to (a sort of) regressions
+ * on some devices since they use the HP pin actually for line/speaker
+ * outs although the default pin config shows a different pin (that is
+ * wrong and useless).
+ *
+ * So, it's basically a problem of default pin configs, likely a BIOS issue.
+ * But, disabling the code below just works around it, and I'm too tired of
+ * bug reports with such devices...
+ */
 		else
 			stac92xx_reset_pinctl(codec, cfg->hp_pins[i], val);
+#endif /* FIXME */
 	}
 } 
 

