Return-Path: <linux-kernel-owner+w=401wt.eu-S1753690AbXF0EDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690AbXF0EDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 00:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750844AbXF0EDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 00:03:14 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:56759 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbXF0EDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 00:03:13 -0400
Message-ID: <4681E0A5.9070904@gmail.com>
Date: Wed, 27 Jun 2007 05:59:33 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Andreas Hartmetz <ahartmetz@gmail.com>
CC: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
References: <200706262239.05070.ahartmetz@gmail.com>
In-Reply-To: <200706262239.05070.ahartmetz@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2007 10:39 PM, Andreas Hartmetz wrote:

> Okay, here's a rant.
> 
> As an interested kernel outsider and KDE developer(*), it looks to me
> like most kernel people are too focused on the history and feature lists
> of the particular technologies here.
> 
> The real matter with ALSA is that you get a strong "ALSA hates me"
> feeling when dealing with it. There is bad documentation, bad API, and a
> config file syntax that is much harder to understand than necessary.

I'll agree to the documentation bit; the funny thing is that it's partly 
caused by documentation actually being, or once having been, _better_ than 
it is for the average subsystem. ALSA for example has the useful "Writing an 
ALSA Driver" document from Takashi Iwai:

http://www.alsa-project.org/~iwai/writing-an-alsa-driver/index.html

Documentation becomes obsolete as code progresses though and yes, especially 
on the userside of things the documentation is slow to follow. And then the 
usual problem of noone ever removing obsolete junk from the web exacerbates 
matters. Google will find you tons of useless, outdated crap but if you need 
the information in the first place, you don't know that it _is_ obsolete.

And yes, this unfortunately includes www.alsa-project.org. For the longest 
time it was advocating writing ~/.asoundrc files for example through generic 
driver boilerplate texts while that was actually at that point mostly 
counter productive in getting ALSA functional.

As to the config file -- well, sure. The best thing about is that normally 
you don't need it...

The "bad API" I find interesting since you are a KDE developer. I'm not an 
audio application developer myself so I don't have (m)any well thought out 
opinions on it, but isn't the only thing in KDE4 that talks to ALSA the 
Phonon ALSA backend? If you are talking in that context, I'm quite sure the 
alsa-user and/or alsa-devel lists (@alsa-project.org) would like to hear 
about any specific comments/problems. Getting the Phonon backend right from 
the start is something that seems important.

> Then there is the kernel/library split that seems to have no convincing
> reason at all in its current form. Why not put the whole sound system in
> userland? It has been done before. Sound is just not performance critical
> at all and it's almost never mission critical

Heh. Sound may not be, but audio is. For the longest time, audio users stuck 
with 2.4 kernels and the low-latency patches that were availabe for it due 
to latency issues. Large parts of ALSA already are in userland in the form 
of libasound and I expect moving over everything would not so much help.

[ ... ]

> The track record of ALSA for me goes like this:
> 
> - dmix finally started working automatically (at least on my Kubuntu
> system) about one year ago, about five years after everybody could see
> that this was badly needed. I couldn't get it to work before. The howtos
> somehow didn't work and ALSA's documentation isn't all that helpful.

dmix was really only implemented (or at least, made default) for casual 
users. Hope it'll not come across as elitist but people who are serious 
about music or audio don't actually need or want it. It's a consumer thing. 
To have software mixing work you have to resample to a common rate and this 
an absolute unthinkable horror to a serious user. It's a good thing it's now 
default, but only because a majority of sound users is not serious (simply 
because it's mostly all computer users).

> - Different desktop environments have different sound daemons to paper
> over the weaknesses of ALSA (no dmix by default / unfriendly API), which
> creates new problems. Yes there are other reasons for sound daemons, but
> I doubt anybody would have come up with the idea if it wasn't for ALSA.

Given that they existed before ALSA did this seems to be a somewhat odd doubt.

> - I have an Envy24HT based soundcard in my desktop PC, which also goes to show 
> that I'm really interested in sound issues.

Nice chip. I don't have one, and am not too sure about its native supported 
rates but if you are mostly playing 44100 through it (ie, CD source audio) 
I'd consider doing without dmix. A nice sounding chip like that shouldn't be 
subjected to resampling really. Someone recently informed me on the ALSA 
list that Envy24 indeed doesn't do hardware mixing though, so I guess you 
may need it if you really do want the also have the card available for 
desktop sounds.

> I have to run alsamixer after every bootup to unmute the left channel
> because restoring volume only works for the right channel. The left
> channel starts working after changing its volume.

Sounds like a rather debugable problem. I'm (almost) sure someone will try 
to get you a useful answer if you post to the alsa-devel@alsa-project.org 
list :)

> - On my IBM/Lenovo R50e notebook with Intel chipset sound didn't work
> before I "muted" the "headphone jack sense" control in alsamixer. That
> took two hours or so. When both the master volume and the PCM volume
> control are set to 100% I get really bad clipping problems.

First problem I don't know about but is no doubt related to alsa developers 
not having proper documentation. On lots of hardware, there's many bits to 
flip, with no information from the manufacturer forthcoming. You can't hold 
that against ALSA so much.

As to the second bit -- most cards mame any audio that passes through them 
when you set a volume to above 0 dB. dB scales were recently implemented for 
many drivers. If also for yours, I expect 100% is more than 0 dB?

> - Some time ago ALSA reported that my soundcard supports sampling rates
> it doesn't in fact support. This was fixed by Takashi Iwai after a week
> and two mails or so. Thumbs up.

Yes, Takashi Iwai is very responsive.

> (*) I am not representing KDE in an official way at all, but I can say
> that KDE developers generally put *much* effort into making APIs as
> logical and friendly as they possibly can.

Not so much that I'm likely to be of great help myself, not being an audio 
application developer, but if there's any problem's with the new KDE4 stuff 
in relation to ALSA, I hope you or someone else will bring them up on the 
alsa list(s)...

Rene.

