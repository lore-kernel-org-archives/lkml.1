Return-Path: <linux-kernel-owner+w=401wt.eu-S932162AbXF1W0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162AbXF1W0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 18:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759911AbXF1W0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 18:26:35 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:55173 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759668AbXF1W0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 18:26:34 -0400
To: Adrian Bunk <bunk@stusta.de>
Cc: Olivier Galibert <galibert@pobox.com>, Takashi Iwai <tiwai@suse.de>,
       Tomasz K?oczko <kloczek@rudy.mif.pg.gda.pl>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
References: <20070624200837.16e11305@the-village.bc.nu>
	<Pine.BSO.4.63.0706242113530.25800@rudy.mif.pg.gda.pl>
	<20070624215724.025a5de5@the-village.bc.nu>
	<Pine.BSO.4.63.0706251052380.25800@rudy.mif.pg.gda.pl>
	<s5h3b0gi9mp.wl%tiwai@suse.de>
	<Pine.BSO.4.63.0706251308020.25800@rudy.mif.pg.gda.pl>
	<s5hzm2ogqr7.wl%tiwai@suse.de>
	<20070625124442.GA44019@dspnet.fr.eu.org>
	<20070625132107.GD1094@stusta.de> <87tzssextf.fsf@hades.wkstn.nix>
	<20070628210614.GC6087@stusta.de>
From: Nix <nix@esperi.org.uk>
Emacs: Lovecraft was an optimist.
Date: Thu, 28 Jun 2007 23:24:15 +0100
In-Reply-To: <20070628210614.GC6087@stusta.de> (Adrian Bunk's message of "Thu, 28 Jun 2007 23:06:14 +0200")
Message-ID: <87lke3g1kg.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.5-b27 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-CTc-dcc2-Metrics: hades 1031; Body=6 Fuz1=6 Fuz2=6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 Jun 2007, Adrian Bunk outgrape:
> Linux software not supporting ALSA has becoming quite esoteric.

Indeed. This is why I haven't moaned much (or at all): aoss is ugly,
sure, but you only need it for those rare apps which run for a long time
or while other sounds are playing, on non-mixing-capable hardware, for
which the in-kernel emulation won't suit... and most non-sound-
specialist apps are using esd, arts or pulseaudio anyway, so that does
the mixing for you (and pulseaudio also does it for every ALSA app if
the pulseaudio plugin is installed). And the sound-specialist apps
are the ones that actually *benefit* from ALSA's ludicrous degree of
low-levelness, so they're using it, or something even more flexible
like JACK.

I use quite a lot of sound apps, and I can count the number of times
I've had to use aoss in the last year on the fingers of one hand.


But still it's conceptually ugly. Doing stuff in userspace, yes: but the
kernel should be calling *back* to userspace to do it, not depending on
things being done in the client's address space by a client library for
proper function. (See also others' rants regarding the nasty
quasi-unstable nature of the ALSA ioctl() kernel interface...)

Isn't this sort of big user-to-and-from-kernelspace data-transfer job
what we have relayfs for? (Or is it unidirectional?)

> common. And that's exactly the case where users run into the results of 
> the "internal implementation detail" that their application used the 
> in-kernel OSS emulation instead of ALSA resulting in exactly these 
> problems.
>
> There is also a userspace OSS emulation for ALSA not suffering from 
> these problems.

The problem is that the user has to *know* to run `aoss'. The in-kernel
OSS emulation is actually nicer than thr userspace one because it works
automatically without the user having to do a damned thing. If only it
(and ALSA as a whole) called out to userspace again to mix, we could
presumably ditch aoss, and the user would never need to care which API
the author chose to use. (There are still complexities involving reading
the user's .asoundrc to consider, but most users don't use that so
wouldn't need aoss for anything anymore.)

And then all these damn silly ALSA/OSS flamewars could go away.

> It's not my decision whether or not to remove the in-kernel OSS emulation, 
> all I'm saying is that removing it might actually result in less users 
> having problems.

I think it would lead to *more* problems. The in-kernel emulation
*almost* Just Works, and surely the ideal we should aim for is an
emulation that Just Works.

-- 
`... in the sense that dragons logically follow evolution so they would
 be able to wield metal.' --- Kenneth Eng's colourless green ideas sleep
 furiously
