Return-Path: <linux-kernel-owner+w=401wt.eu-S1753324AbYAWFmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbYAWFmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 00:42:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbYAWFmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 00:42:09 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:23285 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798AbYAWFmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 00:42:07 -0500
Date: Tue, 22 Jan 2008 21:39:47 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: perex@perex.cz, akpm <akpm@linux-foundation.org>, samr <sam@ravnborg.org>
Subject: [PATCH] sound: fix opti9xx/miro section mismatch
Message-Id: <20080122213947.f044c040.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

snd_opti93x_mixer() is only called by __devinit snd_opti93x_probe(),
so the former can also be __devinit.

snd_miro_mixer() is only called by __devinit snd_miro_probe(),
so the former can also be __devinit.

sound/isa/opti9xx/opti92x-ad1848.c:
WARNING: vmlinux.o(.text+0xf91cd7): Section mismatch: reference to .init.data:snd_opti93x_controls (between 'snd_opti93x_mixer' and 'snd_card_opti9xx_free')
WARNING: vmlinux.o(.text+0xf91d66): Section mismatch: reference to .init.data:snd_miro_controls (between 'snd_opti93x_mixer' and 'snd_card_opti9xx_free')

opti9xx/miro.c:
WARNING: vmlinux.o(.text+0xf926c2): Section mismatch: reference to .init.data:snd_miro_controls (between 'snd_miro_mixer' and 'snd_legacy_find_free_ioport')
WARNING: vmlinux.o(.text+0xf926e5): Section mismatch: reference to .init.data:snd_miro_eq_controls (between 'snd_miro_mixer' and 'snd_legacy_find_free_ioport')
WARNING: vmlinux.o(.text+0xf926f9): Section mismatch: reference to .init.data:snd_miro_line_control (between 'snd_miro_mixer' and 'snd_legacy_find_free_ioport')
WARNING: vmlinux.o(.text+0xf92716): Section mismatch: reference to .init.data:snd_miro_amp_control (between 'snd_miro_mixer' and 'snd_legacy_find_free_ioport')
WARNING: vmlinux.o(.text+0xf9273e): Section mismatch: reference to .init.data:snd_miro_preamp_control (between 'snd_miro_mixer' and 'snd_legacy_find_free_ioport')
WARNING: vmlinux.o(.text+0xf92764): Section mismatch: reference to .init.data:snd_miro_capture_control (between 'snd_miro_mixer' and 'snd_legacy_find_free_ioport')
WARNING: vmlinux.o(.text+0xf92783): Section mismatch: reference to .init.data:snd_miro_radio_control (between 'snd_miro_mixer' and 'snd_legacy_find_free_ioport')
WARNING: vmlinux.o(.text+0xf9279a): Section mismatch: reference to .init.data:snd_miro_eq_controls (between 'snd_miro_mixer' and 'snd_legacy_find_free_ioport')
WARNING: vmlinux.o(.text+0xf927b9): Section mismatch: reference to .init.data:snd_miro_radio_control (between 'snd_miro_mixer' and 'snd_legacy_find_free_ioport')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 sound/isa/opti9xx/miro.c           |    2 +-
 sound/isa/opti9xx/opti92x-ad1848.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.24-rc8-git5.orig/sound/isa/opti9xx/miro.c
+++ linux-2.6.24-rc8-git5/sound/isa/opti9xx/miro.c
@@ -662,7 +662,7 @@ static int __devinit snd_set_aci_init_va
 	return 0;
 }
 
-static int snd_miro_mixer(struct snd_miro *miro)
+static int __devinit snd_miro_mixer(struct snd_miro *miro)
 {
 	struct snd_card *card;
 	unsigned int idx;
--- linux-2.6.24-rc8-git5.orig/sound/isa/opti9xx/opti92x-ad1848.c
+++ linux-2.6.24-rc8-git5/sound/isa/opti9xx/opti92x-ad1848.c
@@ -1595,7 +1595,7 @@ OPTi93X_DOUBLE("Capture Volume", 0, OPTi
 }
 };
                                         
-static int snd_opti93x_mixer(struct snd_opti93x *chip)
+static int __devinit snd_opti93x_mixer(struct snd_opti93x *chip)
 {
 	struct snd_card *card;
 	struct snd_kcontrol_new knew;
