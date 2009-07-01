Return-Path: <linux-kernel-owner+w=401wt.eu-S1762144AbZGAA75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762144AbZGAA75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759530AbZGAAey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:34:54 -0400
Received: from kroah.org ([198.145.64.141]:60389 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761494AbZGAAex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:34:53 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:29 2009
Message-Id: <20090701002429.036408184@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Takashi Iwai <tiwai@suse.de>
Subject: [patch 050/108] ALSA: ca0106 - Add missing registrations of vmaster controls
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=alsa-ca0106-add-missing-registrations-of-vmaster-controls.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 601e1cc5df940b59e71c947726640811897d30df upstream.

Although the vmaster controls are created, they aren't registered thus
they don't appear in the real world.  Added the missing snd_ctl_add()
calls.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/ca0106/ca0106_mixer.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/pci/ca0106/ca0106_mixer.c
+++ b/sound/pci/ca0106/ca0106_mixer.c
@@ -841,6 +841,9 @@ int __devinit snd_ca0106_mixer(struct sn
 					      snd_ca0106_master_db_scale);
 	if (!vmaster)
 		return -ENOMEM;
+	err = snd_ctl_add(card, vmaster);
+	if (err < 0)
+		return err;
 	add_slaves(card, vmaster, slave_vols);
 
 	if (emu->details->spi_dac == 1) {
@@ -848,6 +851,9 @@ int __devinit snd_ca0106_mixer(struct sn
 						      NULL);
 		if (!vmaster)
 			return -ENOMEM;
+		err = snd_ctl_add(card, vmaster);
+		if (err < 0)
+			return err;
 		add_slaves(card, vmaster, slave_sws);
 	}
         return 0;


