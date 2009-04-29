Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbZD2NC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbZD2NC5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbZD2NCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:02:49 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:60947 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199AbZD2NCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:02:48 -0400
Date: Wed, 29 Apr 2009 09:02:41 -0400
From: Andres Salomon <dilinger@queued.net>
To: Takashi Iwai <tiwai@suse.de>
Cc: Kailang Yang <kailang@realtek.com>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org
Subject: Re: realtek ALC272 support
Message-ID: <20090429090241.1c29817f@dev.queued.net>
In-Reply-To: <s5heivcq893.wl%tiwai@suse.de>
References: <20090424152415.10fcebff@dev.queued.net>
	<s5hljpp3z2w.wl%tiwai@suse.de>
	<20090425101753.1983e6ae@dev.queued.net>
	<s5hocujwuhb.wl%tiwai@suse.de>
	<20090427100151.01a46965@dev.queued.net>
	<s5hprey3yc5.wl%tiwai@suse.de>
	<20090427120230.74d70f88@dev.queued.net>
	<s5hbpqi3wqy.wl%tiwai@suse.de>
	<20090428154108.6ed3136d@dev.queued.net>
	<20090428182155.3f6eae50@dev.queued.net>
	<s5heivcq893.wl%tiwai@suse.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Apr 2009 08:33:28 +0200
Takashi Iwai <tiwai@suse.de> wrote:

> At Tue, 28 Apr 2009 18:21:55 -0400,
> Andres Salomon wrote:
> > 
> > On Tue, 28 Apr 2009 15:41:08 -0400
> > Andres Salomon <dilinger@queued.net> wrote:
> > 
> > > On Mon, 27 Apr 2009 18:08:21 +0200
> > > Takashi Iwai <tiwai@suse.de> wrote:
> > > 
> > [...]
> > > > > > > > > > At Fri, 24 Apr 2009 15:24:15 -0400,
> > > > > > > > > > Andres Salomon wrote:
> > > > > > > > > > > 
> > > > > > > > > > > Hi Kailang,
> > > > > > > > > > > 
> > > > > > > > > > > I noticed that your name was on the ALC272 support
> > > > > > > > > > > patch for ALSA intel-hda.  This patch basically
> > > > > > > > > > > sets ALC272 to use (mostly) the same code as
> > > > > > > > > > > ALC662.  I have two machines that have ALC272,
> > > > > > > > > > > and both of them need verb tables in order to
> > > > > > > > > > > function.  I'm wondering if ALC662 should really
> > > > > > > > > > > be used..
> > > > > > > > > > > 
> > > > > > > > > > > Here's one -
> > > > > > > > > > > 
> > > > > > > > > > > http://kernel.ubuntu.com/git?p=ubuntu/ubuntu-hardy-lum.git;a=commitdiff;h=7662834bb9a78d244c6d7ee43358c14c94d249c9
> > > > > > > > > > > 
> > > > > > > > > > > This isn't the final version of the patch (there
> > > > > > > > > > > are further commits I made in order to support
> > > > > > > > > > > headphone mic stuff), but it gives you an idea of
> > > > > > > > > > > the codec values. The other is:
> > > > > > > > > > > 
> > > > > > > > > > > http://kernel.ubuntu.com/git?p=ubuntu/ubuntu-hardy-lum.git;a=commitdiff;h=72ff85641a30dc7ac502e2ea01bf14a04efb4cf1
> > > > > > > > > > > 
> > > > > > > > > > > All of these leave me wonder if there's a specific
> > > > > > > > > > > patch_alc272 function that could be written to rid
> > > > > > > > > > > ourselves of these specific quirks.  Are there
> > > > > > > > > > > machines with ALC272 that are functional with the
> > > > > > > > > > > current ALSA code?
> > > > > > > > > > 
> > [...]
> > > > 
> > > > Could you try sound-unstable tree a bit later again?
> > > > I found a bug in my patch, and fixed and updated GIT tree now.
> > > > At least, the headphone plugging should work now.
> > > > 
> > > > The mic auto-detection still doesn't work with model=auto,
> > > > though. So, I'm going to take your patch anyway later.  But I
> > > > just wanted to be sure that the current tree could work somehow
> > > > better...
> > > > 
> > > 
> > > Hi,
> > > 
> > > I just updated and tried the current tree; still no
> > > sound/headphone output.  :(
> > 
> > 
> > Ok, I believe I've made some progress on this.  The problem appears
> > to be related to the autoconfig handling of the line out nids.  The
> > current code ends up with something like the following:
> > 
> > ALSA sound/pci/hda/hda_codec.c:3833: autoconfig: line_outs=1
> > (0x17/0x0/0x0/0x0/0x0)
> > ALSA sound/pci/hda/hda_codec.c:3837:    speaker_outs=0
> > (0x0/0x0/0x0/0x0/0x0)
> > ALSA sound/pci/hda/hda_codec.c:3841:    hp_outs=1
> > (0x21/0x0/0x0/0x0/0x0) ALSA sound/pci/hda/hda_codec.c:3842:
> > mono: mono_out=0x0 ALSA sound/pci/hda/hda_codec.c:3853: inputs:
> > mic=0x18, fmic=0x19, line=0x0, fline=0x0, cd=0x0, aux=0x0
> > 
> > However, NID 0x17 is actually a speaker_out.  The code that checks
> > for line_outs in snd_hda_parse_pin_def_config() unsets the
> > speaker_out and uses that NID for a line_out.  For whatever reason,
> > this breaks things (no sound output, no headphone out).
> 
> That's intentional, and the driver checks that case, too.
> Please check the latest sound git tree and see the kernel message.
> You should have messages like "realtek: ..."
> 
> 
> Takashi


The realtek: lines don't appear to affect NID 0x17 at all.  Instead,
they say:

ALSA sound/pci/hda/patch_realtek.c:1154: realtek: No valid SSID, checking pincfg 0x40178e2d for NID 0x1d
ALSA sound/pci/hda/patch_realtek.c:1170: realtek: Enabling init ASM_ID=0x8e2d CODEC_ID=10ec0272
ALSA sound/pci/hda/patch_realtek.c:1111: realtek: Enable HP auto-muting on NID 0x21

And, as I said, I get no sound output with this..
