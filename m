Return-Path: <linux-kernel-owner+w=401wt.eu-S1765044AbXEYSez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765044AbXEYSez (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 14:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764893AbXEYSen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 14:34:43 -0400
Received: from mail.gmx.net ([213.165.64.20]:35938 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1764852AbXEYSel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 14:34:41 -0400
X-Authenticated: #8359428
X-Provags-ID: V01U2FsdGVkX1/nZTAlarTngQ5yl1R0ij0h39nptG7n+qjW6gX8iu
	BwYaktoqTc15cs
From: Uwe Bugla <uwe.bugla@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: BUG in 2.6.22-rc2-mm1: Parts of Alsa sound architecture broken
Date: Fri, 25 May 2007 20:29:20 +0200
User-Agent: KMail/1.9.5
References: <20070524200052.234330@gmx.net> <s5hiragopsx.wl%tiwai@suse.de> <20070525102806.77ee9c0c.akpm@linux-foundation.org>
In-Reply-To: <20070525102806.77ee9c0c.akpm@linux-foundation.org>
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
       Jaroslav Kysela <perex@suse.cz>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705252029.21094.uwe.bugla@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 25. Mai 2007 19:28 schrieben Sie:
> On Fri, 25 May 2007 18:01:34 +0200 Takashi Iwai <tiwai@suse.de> wrote:
> > At Thu, 24 May 2007 13:09:21 -0700,
> >
> > Andrew Morton wrote:
> > > On Thu, 24 May 2007 22:00:52 +0200
> > >
> > > "Uwe Bugla" <uwe.bugla@gmx.de> wrote:
> > > > Hi everybody,
> > > >
> > > > with 2.6.22-rc2-mm1 I do get sound out of my machine using
> > > > snd-intel8x0 module, BUT:
> > > >
> > > > At least parts of that Alsa sound architecture do seem to be broken:
> > >
> > > I assume you're referring to this stuff?
> > >
> > > > snd_seq_device: Unknown symbol snd_iprintf
> > > > snd_seq_device: Unknown symbol snd_device_new
> > > > snd_rawmidi: Unknown symbol snd_info_register
> > > > snd_rawmidi: Unknown symbol snd_seq_device_new
> > > > snd_rawmidi: Unknown symbol snd_info_free_entry
> > >
> > > Probably some silly missing dependency.  Please send the .config,
> > > thanks.
> >
> > The culprit appears more ealier.  It implies the missing
> > soundcore.ko (or its dependency).
> >
> > > snd: Unknown symbol unregister_sound_special
> > > snd: Unknown symbol register_sound_special_device
> > > snd: Unknown symbol sound_class
> >
> > Uwe, could you try to revert this patch?
> > use-menuconfig-objects-ii-sound.patch
>
> I think that patch has rotted.  Too many underlying changes and the
> handling of HAS_IOMEM (at least) appears to have been broken (by my
> fixups).
>
> I'll drop it.
>
> If/when Jan resends it, pleeeeeeeeeze consider it promptly and don't leave
> me trying to maintain the thing while you guys are madly changing other
> stuff underneath it?
>
> Thanks.

Hi everybody,

I had some trouble to find out which patch is meant by

"use-menuconfig-objects-ii-sound.patch"

Just could not identify it.

So I reverted the following patches of 2.6.22-rc2-mm1:

--- linux-2.6.22-rc2/sound/Kconfig	2007-05-19 02:24:08.000000000 -0700
+++ devel/sound/Kconfig	2007-05-22 21:03:24.000000000 -0700

AND:

--- linux-2.6.22-rc2/sound/drivers/Kconfig	2007-04-25 23:42:23.000000000 -0700
+++ devel/sound/drivers/Kconfig	2007-05-22 21:03:24.000000000 -0700

Result:

The Alsa architecture is performing excellently!

Cheers

Uwe

So at least one of them should be ripeed out for being buggy.
