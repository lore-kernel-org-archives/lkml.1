Return-Path: <linux-kernel-owner+w=401wt.eu-S1763704AbXEYR3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763704AbXEYR3Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 13:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbXEYR3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 13:29:01 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:47336 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752049AbXEYR3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 13:29:01 -0400
Date: Fri, 25 May 2007 10:28:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: "Uwe Bugla" <uwe.bugla@gmx.de>, linux-kernel@vger.kernel.org,
       Jaroslav Kysela <perex@suse.cz>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: BUG in 2.6.22-rc2-mm1: Parts of Alsa sound architecture broken
Message-Id: <20070525102806.77ee9c0c.akpm@linux-foundation.org>
In-Reply-To: <s5hiragopsx.wl%tiwai@suse.de>
References: <20070524200052.234330@gmx.net>
	<20070524130921.8dbd3777.akpm@linux-foundation.org>
	<s5hiragopsx.wl%tiwai@suse.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2007 18:01:34 +0200 Takashi Iwai <tiwai@suse.de> wrote:

> At Thu, 24 May 2007 13:09:21 -0700,
> Andrew Morton wrote:
> > 
> > On Thu, 24 May 2007 22:00:52 +0200
> > "Uwe Bugla" <uwe.bugla@gmx.de> wrote:
> > 
> > > Hi everybody,
> > > 
> > > with 2.6.22-rc2-mm1 I do get sound out of my machine using snd-intel8x0 module, BUT:
> > > 
> > > At least parts of that Alsa sound architecture do seem to be broken:
> > 
> > I assume you're referring to this stuff?
> > 
> > > snd_seq_device: Unknown symbol snd_iprintf
> > > snd_seq_device: Unknown symbol snd_device_new
> > > snd_rawmidi: Unknown symbol snd_info_register
> > > snd_rawmidi: Unknown symbol snd_seq_device_new
> > > snd_rawmidi: Unknown symbol snd_info_free_entry
> > 
> > Probably some silly missing dependency.  Please send the .config, thanks.
> 
> The culprit appears more ealier.  It implies the missing
> soundcore.ko (or its dependency).
> 
> > snd: Unknown symbol unregister_sound_special
> > snd: Unknown symbol register_sound_special_device
> > snd: Unknown symbol sound_class
> 
> Uwe, could you try to revert this patch?
> use-menuconfig-objects-ii-sound.patch
> 

I think that patch has rotted.  Too many underlying changes and the
handling of HAS_IOMEM (at least) appears to have been broken (by my
fixups).

I'll drop it.

If/when Jan resends it, pleeeeeeeeeze consider it promptly and don't leave
me trying to maintain the thing while you guys are madly changing other
stuff underneath it?

Thanks.
