Return-Path: <linux-kernel-owner+w=401wt.eu-S1761433AbYBLP17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761433AbYBLP17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 10:27:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756569AbYBLP1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 10:27:51 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:10483 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675AbYBLP1u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 10:27:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=c6grqx43xu4/shgvUjPDItURe58HkrMtgImx7ptB8xKiBWcL/JWL+SwaWBOufUn24LCeMb7ggBTPJQq9uuCCtppN/RbPrTpNQipeRUpX2n35NoGliw0XdvX6Ta7wG/O6M0v7/2kxG5TuVJESyZ/miJjrOzxNjxzDWd0hZROnagE=
From: Matej Laitl <strohel@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: [ALSA] HDA: no sound in headphone-out caused by commit f889fa91ad47e (2.6.25-rc1 regression)
Date: Tue, 12 Feb 2008 16:27:44 +0100
User-Agent: KMail/1.9.7
Cc: alsa-devel <alsa-devel@alsa-project.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200802112158.41989.strohel@gmail.com> <s5hwspatgri.wl%tiwai@suse.de> <s5htzketg7v.wl%tiwai@suse.de>
In-Reply-To: <s5htzketg7v.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802121627.44422.strohel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> Takashi Iwai wrote:
> > Matej Laitl wrote:
> > > With your patch, the sound in headphone-out is working again, but
> > > surprisingly the integrated loudspeakers stopped working! ;)
> > >
> > > Also, new on/of control appeared in alsamixer - "Speaker", but unmuting
> > > it (and unmuting all playback controls, plugging-out headphones) didn't
> > > have an effect on non-working integrated loudspeakers.
> > >
> > > Some kernel mesgs with your patch:
> > > hda_codec: Unknown model for ALC262, trying auto-probe from BIOS...
> > > autoconfig: line_outs=1 (0x1b/0x0/0x0/0x0/0x0)
> > >    speaker_outs=1 (0x14/0x0/0x0/0x0/0x0)
> > >    hp_outs=1 (0x15/0x1b/0x0/0x0/0x0)
> > >    mono: mono_out=0x0
> > >    inputs: mic=0x18, fmic=0x19, line=0x0, fline=0x0, cd=0x0, aux=0x0
> > >
> > > alsa-info.sh output:
> > > http://pastebin.ca/901089
> >
> > Thanks.  There seems a couple of bugs in this auto-configuration
> > code.  Try the additional patch below.  This will unmute the
> > speaker-pin.
>
> This version might be slightly better...

Yes, this "slightly better" patch applied on top of your first patch against 
hda_codec.c did the trick, but with some side-effects:
* the "Speaker" switch now mutes/unmutes speakers
* muting/unmuting "Front" channel now has zero effect (in 2.6.24 it had the 
same effect as the "Speaker" switch now has)
* changing volume on "Front" channel now affects volume in headphones (was not 
so in 2.6.24)

So there are now 3 vol controls that affect both speakers and headphones:
* Master (which appeared somewhere between 2.6.24 and .25-rc1), when set to 
zero, the sound is still audible in speakers and headphones
* PCM, working as expected (0 volume = no sound)
* Front (0 volume = still audible sound)

So it is usable now (and those Speaker and Headphones on/off switches make 
sense), but kinda suboptimal. (is it my BIOS who is to blame?)

Thanks, Matej
