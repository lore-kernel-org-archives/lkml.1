Return-Path: <linux-kernel-owner+w=401wt.eu-S1757808AbZCPRaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808AbZCPRaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 13:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753911AbZCPRaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 13:30:06 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:35005 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbZCPRaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 13:30:05 -0400
Date: Mon, 16 Mar 2009 18:30:00 +0100
From: Andreas Mohr <andi@lisas.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Andreas Mohr <andi@lisas.de>, Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [alsa-devel] Bugs on aspire one A150
Message-ID: <20090316173000.GA25647@rhlx01.hs-esslingen.de>
References: <s5hfxhdr1oz.wl%tiwai@suse.de> <20090316143158.GA12725@rhlx01.hs-esslingen.de> <s5hab7lr0k1.wl%tiwai@suse.de> <20090316145036.GA26358@rhlx01.hs-esslingen.de> <s5h4oxtqy6q.wl%tiwai@suse.de> <20090316160208.GB4458@rhlx01.hs-esslingen.de> <s5hwsappi44.wl%tiwai@suse.de> <s5hprghphid.wl%tiwai@suse.de> <20090316170015.GA9776@rhlx01.hs-esslingen.de> <s5hljr5pex0.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <s5hljr5pex0.wl%tiwai@suse.de>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Mar 16, 2009 at 06:15:39PM +0100, Takashi Iwai wrote:
> At Mon, 16 Mar 2009 18:00:15 +0100,
> Andreas Mohr wrote:
> > 
> > Hi,
> > 
> > On Mon, Mar 16, 2009 at 05:19:38PM +0100, Takashi Iwai wrote:
> > > At Mon, 16 Mar 2009 17:06:35 +0100,
> > > 私 wrote:
> > > > 
> > > > > > What are "sliders"?
> > > > > 
> > > > > Umm, volume level controls.
> > > > 
> > > > Yes but there are many of such :)
> > > > 
> > > > More exactly, from the driver perspective, there are no volume
> > > > controls but only there are control elements with integer values.
> > > > Do you mean "Capture Volume" control or which one?
> > 
> > Hmm, ok, this needs to be more precise:
> > In gamix (codec "HDA Intel : Realtek ALC268"), the Capture Volume control.
> 
> Yeah, that's more understandable :)
> 
> BTW, does "Capture Volume" influence on the recording level even for
> the built-in mic, right?  I'm asking this because the digital mic on
> STAC/IDT codecs isn't controlled via "Capture Volume" control that is
> bound to an ADC widget.  (That's why "Digital Capture Volume" control
> exists.  It's a value used by alsa-lib softvol plugin for "default"
> PCM.)

Yes, Capture Volume does influence i-Mic level.
The Digital Capture control, however, doesn't influence level.
As doesn't the Mic Boost Capture control (probably about e-Mic only?).

> > > > And, is the behavior consistent regardless of the value high, i.e.
> > > > the key is only whether the values for both channels are identical?
> > > 
> > > BTW, what if you record with the following definition?
> > > Put the below to ~/.asoundrc
> > > 
> > > pcm.imix {
> > > 	type plug
> > > 	slave.pcm "hw"
> > > 	ttable.0.0 0.5
> > > 	ttable.0.1 -0.5
> > > }
> > > 
> > > and record like
> > > 
> > > 	% aplay -Dimix -c1 foo.wav
> > 
> > Does NOT exhibit the "equal sliders == no sound" bug (apart from this sliders
> > are acting normally, i.e. slider low == no sound), despite being a
> > "plug" type definition (this is what you wanted to discern, right? ;).
> 
> Interesting.  This implies that one channel is inverted indeed.

Oh, you mean "inverted" as in "_hardware_ channel which provides opposite
sample values as compared to the other channel"?

> As default the alsa-lib plugin downmixes a stereo stream to a mono
> stream simply  by left/2 + right/2.  The above changes the routing
> policy as left/2 - right/2.

That exactly matches my current stream of thought (while reading
"one channel is inverted" above).

> So we need to pass some information to change this kind of thing...

That's something specific to ALC268 codec setup, right?
("ALC268 digital mic == left plus right channel, but inverted setup"?)

> But a question still remains; why conversion with sox worked.
> Maybe it didn't mix?  Or, the code alsa-lib could be buggy...
> 
> A simple test would be to just sum all 16bit samples in a stereo
> stream file externally.  That is, first record a RAW file via
> 
> 	% arecord -Dhw -traw -fdat foo.dat
> 
> Then create a mono stream just do 16bit left/2 + right/2 calculation
> by any way (a good homework for kids :).  Is it also problematic?

OK, I know what you're up to, I'll do this external proof ASAP,
will take a couple more minutes.

Andreas
