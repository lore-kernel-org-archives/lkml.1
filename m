Return-Path: <linux-kernel-owner+w=401wt.eu-S1753669AbZGAWqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbZGAWqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 18:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbZGAWqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 18:46:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33831 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206AbZGAWqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 18:46:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: Problems with snd-hda-intel on hp 6930p (2.6.30)
Date: Thu, 2 Jul 2009 00:46:54 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc1-rjw; KDE/4.2.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, alsa-devel@alsa-project.org
References: <200906292037.09597.rjw@sisk.pl> <200907011800.28687.rjw@sisk.pl> <s5h3a9g75a0.wl%tiwai@suse.de>
In-Reply-To: <s5h3a9g75a0.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907020046.54521.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 July 2009, Takashi Iwai wrote:
> At Wed, 1 Jul 2009 18:00:28 +0200,
> Rafael J. Wysocki wrote:
> > 
> > On Tuesday 30 June 2009, Takashi Iwai wrote:
> > > At Tue, 30 Jun 2009 16:15:37 +0200,
> > > Rafael J. Wysocki wrote:
> > > > 
> > > > On Tuesday 30 June 2009, Rafael J. Wysocki wrote:
> > > > > On Tuesday 30 June 2009, Takashi Iwai wrote:
> > > > > > At Mon, 29 Jun 2009 20:37:09 +0200,
> > > > > > Rafael J. Wysocki wrote:
> > > > > > > 
> > > > > > > Hi Takashi,
> > > > > > > 
> > > > > > > I have a problem with snd-hda-intel from 2.6.30 on an hp EliteBook 6930p, which
> > > > > > > is that the sound is not audible, although everything appears to work just
> > > > > > > fine.  Except maybe that when the box is rebooted and KDE (3.5) is started,
> > > > > > > the master control is "muted" and the led indicator next to the keyboard shows
> > > > > > > "no sound".  Then, changing the "muted" status of the master control doesn't
> > > > > > > change the state of the led indicator and vice versa (the two things appear to
> > > > > > > be totally independent of each other).
> > > > > > > 
> > > > > > > Can you please tell me what I can do to debug this issue?
> > > > > > 
> > > > > > Could you run alsa-info.sh with --no-upload option on both "muted"
> > > > > > and "not muted" states, and attach the generated files?
> > > > > 
> > > > > Sure.  In the meantime it turned out that after a power off and cold boot the
> > > > > status of the master control is 'on', but the led indicator shows 'no sound', so
> > > > > there are 5 outputs:
> > > > > * alsa-info-postboot.txt - after power off and cold boot
> > > > > * alsa-info-led.txt - led indicator switched to 'on' when it was in the
> > > > >   alsa-info-postboot.txt state
> > > > > Now I switched to AC power and rebooted the box without powering off:
> > > > > * alsa-info-muted.txt - initial state with the 'muted' master control
> > > > > * alsa-info-on.txt - master control switched to 'on' when it was in the
> > > > >   alsa-info-muted.txt state
> > > > > * alsa-info.txt - led indicator switched to 'on' when it was in the
> > > > >   alsa-info-on.txt state
> > > > > 
> > > > > > If it's a regression (heh :), please give alsa-info.sh output on
> > > > > > older kernels.
> > > > > 
> > > > > No, it's not a regression.  At least not from 2.6.27.
> > > > > 
> > > > > Please let me know if you need more information.
> > > > 
> > > > One more thing.  The headphones output actually works regardless of the
> > > > led indicator status, so only the built-in speakers output seems to be
> > > > affected.
> > > 
> > > How can you turn on/off LED?  From your explanation, it seems not
> > > directly bound with the audio mute.
> > > 
> > > Anyway, try model=mobile or model=laptop for snd-hda-intel module
> > > option.  Does the speaker work?
> > 
> > Yes, it works with both model=laptop and model=mobile.
> 
> OK, I added the following patch to sound git tree.

Thanks!

I had to give the box back to the owner.  I'll verify the patch if I can get
access to it once again. :-)

Best,
Rafael


> ===
> From ff84847171508a3c76eb7e483204d1be7738729b Mon Sep 17 00:00:00 2001
> From: Takashi Iwai <tiwai@suse.de>
> Date: Wed, 1 Jul 2009 18:08:01 +0200
> Subject: [PATCH] ALSA: hda - Add quirk for HP 6930p
> 
> Added a quirk model=laptop for HP 6930p (103c:30dc) with AD1984A codec.
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  sound/pci/hda/patch_analog.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/sound/pci/hda/patch_analog.c b/sound/pci/hda/patch_analog.c
> index 84cc49c..85e8618 100644
> --- a/sound/pci/hda/patch_analog.c
> +++ b/sound/pci/hda/patch_analog.c
> @@ -3966,6 +3966,7 @@ static struct snd_pci_quirk ad1884a_cfg_tbl[] = {
>  	SND_PCI_QUIRK(0x103c, 0x3037, "HP 2230s", AD1884A_LAPTOP),
>  	SND_PCI_QUIRK(0x103c, 0x3056, "HP", AD1884A_MOBILE),
>  	SND_PCI_QUIRK_MASK(0x103c, 0xfff0, 0x3070, "HP", AD1884A_MOBILE),
> +	SND_PCI_QUIRK_MASK(0x103c, 0xfff0, 0x30d0, "HP laptop", AD1884A_LAPTOP),
>  	SND_PCI_QUIRK_MASK(0x103c, 0xfff0, 0x30e0, "HP laptop", AD1884A_LAPTOP),
>  	SND_PCI_QUIRK_MASK(0x103c, 0xff00, 0x3600, "HP laptop", AD1884A_LAPTOP),
>  	SND_PCI_QUIRK(0x17aa, 0x20ac, "Thinkpad X300", AD1884A_THINKPAD),
