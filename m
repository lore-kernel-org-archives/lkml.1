Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501AbZCPSGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbZCPSGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 14:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbZCPSGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 14:06:41 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:39115 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614AbZCPSGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 14:06:40 -0400
Date: Mon, 16 Mar 2009 19:06:38 +0100
From: Andreas Mohr <andi@lisas.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Andreas Mohr <andi@lisas.de>, Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [alsa-devel] Bugs on aspire one A150
Message-ID: <20090316180638.GB25647@rhlx01.hs-esslingen.de>
References: <s5hab7lr0k1.wl%tiwai@suse.de> <20090316145036.GA26358@rhlx01.hs-esslingen.de> <s5h4oxtqy6q.wl%tiwai@suse.de> <20090316160208.GB4458@rhlx01.hs-esslingen.de> <s5hwsappi44.wl%tiwai@suse.de> <s5hprghphid.wl%tiwai@suse.de> <20090316170015.GA9776@rhlx01.hs-esslingen.de> <s5hljr5pex0.wl%tiwai@suse.de> <20090316173000.GA25647@rhlx01.hs-esslingen.de> <s5hiqm9pe1g.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hiqm9pe1g.wl%tiwai@suse.de>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 06:34:35PM +0100, Takashi Iwai wrote:
> At Mon, 16 Mar 2009 18:30:00 +0100,
> Andreas Mohr wrote:
> > 
> > Hi,
> > 
> > On Mon, Mar 16, 2009 at 06:15:39PM +0100, Takashi Iwai wrote:
> > > At Mon, 16 Mar 2009 18:00:15 +0100,
> > > Andreas Mohr wrote:
> > > > > > And, is the behavior consistent regardless of the value high, i.e.
> > > > > > the key is only whether the values for both channels are identical?
> > > > > 
> > > > > BTW, what if you record with the following definition?
> > > > > Put the below to ~/.asoundrc
> > > > > 
> > > > > pcm.imix {
> > > > > 	type plug
> > > > > 	slave.pcm "hw"
> > > > > 	ttable.0.0 0.5
> > > > > 	ttable.0.1 -0.5
> > > > > }
> > > > > 
> > > > > and record like
> > > > > 
> > > > > 	% aplay -Dimix -c1 foo.wav
> > > > 
> > > > Does NOT exhibit the "equal sliders == no sound" bug (apart from this sliders
> > > > are acting normally, i.e. slider low == no sound), despite being a
> > > > "plug" type definition (this is what you wanted to discern, right? ;).
> > > 
> > > Interesting.  This implies that one channel is inverted indeed.
> > 
> > Oh, you mean "inverted" as in "_hardware_ channel which provides opposite
> > sample values as compared to the other channel"?
> 
> Right.  My guess is that the hardware provides left (or right) channel
> is multiplied by -1  (yep "inverted" is no correct word choice).
> 
> > > As default the alsa-lib plugin downmixes a stereo stream to a mono
> > > stream simply  by left/2 + right/2.  The above changes the routing
> > > policy as left/2 - right/2.
> > 
> > That exactly matches my current stream of thought (while reading
> > "one channel is inverted" above).
> > 
> > > So we need to pass some information to change this kind of thing...
> > 
> > That's something specific to ALC268 codec setup, right?
> > ("ALC268 digital mic == left plus right channel, but inverted setup"?)
> 
> No.  It's specific to the digital-mic side.

I just tried connecting a headset and switching to E-Mic.
What I can say is:
- opposite levels does NOT happen there (E-Mic is "analog micro"-based, right?)
- leaving E-Mic unplugged will actually record from i-Mic (due to properly
  working EAPD mechanism, right?)


BTW, the output (of arecord -Dplughw:0 -c2 -traw -fdat foo.wav) _does_ have
inverted channels:

00000130   2A 02 D2 FD  65 02 A5 FD  10 00 E7 FF  99 FF 72 00 *...e.........r.
00000140   53 FE A7 01  ED FF 12 00  4F FF A6 00  86 00 81 FF S.......O.......
... and so on in the entire file ...


One question still: is this a hardware defect (i.e. could this possibly
be swapped cables of the microphone connector in this model or so?
Not plausible but...), or is this an existing property
of the HDA's dig-mic base? You indicated it's the latter I think...

Andreas
