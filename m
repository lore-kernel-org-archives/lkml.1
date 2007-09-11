Return-Path: <linux-kernel-owner+w=401wt.eu-S934118AbXIKVMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934118AbXIKVMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 17:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762543AbXIKVMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 17:12:34 -0400
Received: from 251.4.221.87.dynamic.jazztel.es ([87.221.4.251]:58208 "EHLO
	traven.no-ip.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758996AbXIKVMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 17:12:33 -0400
Date: Tue, 11 Sep 2007 23:12:36 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: perex@suse.cz, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 4/4] Routines for effect processor FX8010: Use
	list_for_each_entry
Message-ID: <20070911211236.GJ8592@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	perex@suse.cz, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20070911205632.GF8592@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070911205632.GF8592@traven>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Routines for effect processor FX8010: Use list_for_each_entry instead
of list_for_each

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/include/sound/emu10k1.h b/include/sound/emu10k1.h
index 529d0a5..24399a0 100644
--- a/include/sound/emu10k1.h
+++ b/include/sound/emu10k1.h
@@ -1408,8 +1408,6 @@ struct snd_emu10k1_fx8010 {
 	struct snd_emu10k1_fx8010_irq *irq_handlers;
 };
 
-#define emu10k1_gpr_ctl(n) list_entry(n, struct snd_emu10k1_fx8010_ctl, list)
-
 struct snd_emu10k1_midi {
 	struct snd_emu10k1 *emu;
 	struct snd_rawmidi *rmidi;
diff --git a/sound/pci/emu10k1/emufx.c b/sound/pci/emu10k1/emufx.c
index 7206c0f..bf23c3a 100644
--- a/sound/pci/emu10k1/emufx.c
+++ b/sound/pci/emu10k1/emufx.c
@@ -642,10 +642,8 @@ snd_emu10k1_look_for_ctl(struct snd_emu10k1 *emu, struct snd_ctl_elem_id *id)
 {
 	struct snd_emu10k1_fx8010_ctl *ctl;
 	struct snd_kcontrol *kcontrol;
-	struct list_head *list;
-	
-	list_for_each(list, &emu->fx8010.gpr_ctl) {
-		ctl = emu10k1_gpr_ctl(list);
+
+	list_for_each_entry(ctl, &emu->fx8010.gpr_ctl, list) {
 		kcontrol = ctl->kcontrol;
 		if (kcontrol->id.iface == id->iface &&
 		    !strcmp(kcontrol->id.name, id->name) &&
@@ -895,14 +893,12 @@ static int snd_emu10k1_list_controls(struct snd_emu10k1 *emu,
 	struct snd_emu10k1_fx8010_control_gpr *gctl;
 	struct snd_emu10k1_fx8010_ctl *ctl;
 	struct snd_ctl_elem_id *id;
-	struct list_head *list;
 
 	gctl = kmalloc(sizeof(*gctl), GFP_KERNEL);
 	if (! gctl)
 		return -ENOMEM;
 
-	list_for_each(list, &emu->fx8010.gpr_ctl) {
-		ctl = emu10k1_gpr_ctl(list);
+	list_for_each_entry(ctl, &emu->fx8010.gpr_ctl, list) {
 		total++;
 		if (icode->gpr_list_controls &&
 		    i < icode->gpr_list_control_count) {


-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

      El trabajo es el refugio de los que no tienen nada que hacer
                            (Oscar Wilde)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
