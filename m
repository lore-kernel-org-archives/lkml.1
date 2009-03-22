Return-Path: <linux-kernel-owner+w=401wt.eu-S1755056AbZCVMzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056AbZCVMzc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 08:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbZCVMzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 08:55:22 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:58747 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbZCVMzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 08:55:21 -0400
Date: Sun, 22 Mar 2009 13:55:17 +0100
From: Andreas Mohr <andi@lisas.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Andreas Mohr <andi@lisas.de>, Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [alsa-devel] Bugs on aspire one A150
Message-ID: <20090322125517.GA26498@rhlx01.hs-esslingen.de>
References: <20090317100500.GA16029@rhlx01.hs-esslingen.de> <20090317103845.GA26007@rhlx01.hs-esslingen.de> <20090317104755.GA1446@rhlx01.hs-esslingen.de> <s5h3adcpf1i.wl%tiwai@suse.de> <20090317161828.GA32756@rhlx01.hs-esslingen.de> <s5h3adbhovj.wl%tiwai@suse.de> <20090318090507.GA30453@rhlx01.hs-esslingen.de> <s5hsklbchmu.wl%tiwai@suse.de> <20090320185640.GA17278@rhlx01.hs-esslingen.de> <s5hmybgnddc.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hmybgnddc.wl%tiwai@suse.de>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Mar 20, 2009 at 09:33:19PM +0100, Takashi Iwai wrote:
> At Fri, 20 Mar 2009 19:56:40 +0100,
> Andreas Mohr wrote:
> > 
> > Hi,
> > 
> > On Wed, Mar 18, 2009 at 10:19:53AM +0100, Takashi Iwai wrote:
> > > What is the output with -v option?
> > 
> > Sorry for the delay!
> > 
> > $ arecord -fdat -c1 -v test.wav; aplay test.wav 
> > Recording WAVE 'test.wav' : Signed 16 bit Little Endian, Rate 48000 Hz, Mono
> > ALSA <-> PulseAudio PCM I/O Plugin
> > Its setup is:
> >   stream       : CAPTURE
> >   access       : RW_INTERLEAVED
> >   format       : S16_LE
> >   subformat    : STD
> >   channels     : 1
> >   rate         : 48000
> >   exact rate   : 48000 (48000/1)
> >   msbits       : 16
> >   buffer_size  : 24000
> >   period_size  : 6000
> >   period_time  : 125000
> >   tstamp_mode  : NONE
> >   period_step  : 1
> >   avail_min    : 6000
> >   period_event : 0
> >   start_threshold  : 1
> >   stop_threshold   : 24000
> >   silence_threshold: 0
> >   silence_size : 0
> >   boundary     : 1572864000
> > ^CAborted by signal Interrupt...
> > Playing WAVE 'test.wav' : Signed 16 bit Little Endian, Rate 48000 Hz, Mono
> > andi@andinet:/tmp$ 
> > 
> > 
> > Hmm. Note the pulseaudio stuff above...
> 
> Yes, that's the very reason.  If you don't PA and avoid the
> default configuration override (e.g. defined in /etc/asound.conf)
> my patch should work.

Sorry, but how would I achieve "don't PA"?
I've tried some Ubuntu suggestions
(e.g. http://ubuntuforums.org/showthread.php?t=852518 ; didn't work,
it's Jaunty here),
I tried asoundconf (un)set-pulseaudio (~/.asoundrc contents looked ok
then but didn't really help),
I tried pasuspender -- arecord -fdat -c1 -v test.wav
I always ended up with "ALSA <-> PulseAudio PCM I/O Plugin" mode.
(I didn't even attempt the ultimate solution, removing all traces of
PA packages, since that would be a ridiculous thing to do)
gnome-sound-properties didn't seem overly helpful either...
(Sound capture was already set as "ALSA")

If things are that impractical, then there needs to be another builtin way
to always have the microphone output end up correct, automatically,
instead of having to go through incredible convolutions to try to
access the raw ALSA device (which would probably provide a correct
mic stream) directly, by default.

Or, to put it another way, in many cases the default ALSA device
wouldn't be used (by sound layers or apps or whatever),
thus the patch above wouldn't work there if I'm not mistaken,
thus there needs to be a different way to fix the microphone.

Or, to have it even more condensed, the more you have to fiddle to make
the patch work, the more distance gets between you and the usual Linux
distribution use case.

Any ideas or suggestions?

Thanks,

Andreas
