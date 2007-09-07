Return-Path: <linux-kernel-owner+w=401wt.eu-S965158AbXIGJDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965158AbXIGJDQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 05:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757409AbXIGJDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 05:03:03 -0400
Received: from antispam.upcomillas.es ([130.206.70.245]:34440 "EHLO
	antispam.upcomillas.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757377AbXIGJDA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 05:03:00 -0400
X-Greylist: delayed 1620 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Sep 2007 05:03:00 EDT
Subject: Re: hda_intel : Patch + Regression in 2.6.18 -> 2.6.22
From: Romano Giannetti <romano@dea.icai.upcomillas.es>
To: Takashi Iwai <tiwai@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, roger@computer-surgery.co.uk,
       linux-kernel@vger.kernel.org, perex@suse.cz
In-Reply-To: <1189115313.7275.5.camel@rukbat>
References: <20070822222902.GA28563@computer-surgery.co.uk> 
	<20070905083844.6637da1e.akpm@linux-foundation.org> 
	<s5hlkbl6qsn.wl%tiwai@suse.de> 
	<20070905091633.87cfaa81.akpm@linux-foundation.org> 
	<s5hhcm96oza.wl%tiwai@suse.de> <1189091390.3212.3.camel@rukbat> 
	<s5hir6n6ck6.wl%tiwai@suse.de>  <1189115313.7275.5.camel@rukbat>
Content-Type: text/plain;
	charset=utf-8
Date: Fri, 07 Sep 2007 10:22:27 +0200
Message-Id: <1189153347.15955.5.camel@rukbat>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi: good news!

On Thu, 2007-09-06 at 23:48 +0200, Romano Giannetti wrote:
> On Thu, 2007-09-06 at 17:25 +0200, Takashi Iwai wrote:
> > At Thu, 06 Sep 2007 17:09:50 +0200,
> > Romano Giannetti wrote:
> > >
> > >
> > > Just one hand up: I haven't tested the patch pointed to by Andrew, will
> > > do asap, but it seems that contains the changes from
> > >
> > > https://bugtrack.alsa-project.org/alsa-bug/view.php?id=3104
> > >
> > > which are needed to have sound at all on my toshiba (although with some
> > > remaining problems).
> >
> > No, it's a different one.  This Toshiba model is still not supported
> > well.  The patch in mm tree is basically equivalent with the latest
> > ALSA HG tree, so if you tested ALSA HG version (or daily snapshot),
> > it should be same.
>
> Unfortunately you're right. The patch I posted to the alsa bugtrack,
> extracted from the pshou files, works for me. The alsa-git patch gives
> me a system without sound.

I stand corrected: by loading snd-hda-intel with model=toshiba sound
works (output and input) with my toshiba A305. So, I think that the only
patch needed to make it works out of the box on top of current alsa-git
is:

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 3557865..496d119 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9044,6 +9044,7 @@ static const char *alc268_models[ALC268_MODEL_LAST] = {
 static struct snd_pci_quirk alc268_cfg_tbl[] = {
        SND_PCI_QUIRK(0x1043, 0x1205, "ASUS W7J", ALC268_3ST),
        SND_PCI_QUIRK(0x1179, 0xff10, "TOSHIBA A205", ALC268_TOSHIBA),
+       SND_PCI_QUIRK(0x1179, 0xff50, "TOSHIBA A305", ALC268_TOSHIBA),
        SND_PCI_QUIRK(0x103c, 0x30cc, "TOSHIBA", ALC268_TOSHIBA),
        SND_PCI_QUIRK(0x1025, 0x0126, "Acer", ALC268_ACER),
        SND_PCI_QUIRK(0x1025, 0x0130, "Acer Extensa 5210", ALC268_ACER),






--
La presente comunicación tiene carácter confidencial y es para el exclusivo uso del destinatario indicado en la misma. Si Ud. no es el destinatario indicado, le informamos que cualquier forma de distribución, reproducción o uso de esta comunicación y/o de la información contenida en la misma están estrictamente prohibidos por la ley. Si Ud. ha recibido esta comunicación por error, por favor, notifíquelo inmediatamente al remitente contestando a este mensaje y proceda a continuación a destruirlo. Gracias por su colaboración.

This communication contains confidential information. It is for the exclusive use of the intended addressee. If you are not the intended addressee, please note that any form of distribution, copying or use of this communication or the information in it is strictly prohibited by law. If you have received this communication in error, please immediately notify the sender by reply e-mail and destroy this message. Thank you for your cooperation.

