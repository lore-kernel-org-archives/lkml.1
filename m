Return-Path: <linux-kernel-owner+w=401wt.eu-S1763996AbXF0XQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763996AbXF0XQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 19:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758839AbXF0XQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 19:16:13 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:54455 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbXF0XQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 19:16:11 -0400
Message-ID: <4682EEDD.4020501@gmail.com>
Date: Thu, 28 Jun 2007 01:12:29 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Andreas Hartmetz <ahartmetz@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
References: <200706271825.17459.ahartmetz@gmail.com> <46829E82.6080804@gmail.com> <200706272110.50744.ahartmetz@gmail.com>
In-Reply-To: <200706272110.50744.ahartmetz@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2007 09:10 PM, Andreas Hartmetz wrote:

>>> I don't like random applications blocking my sound card.
>> 
>> So don't use random applications.
>> 
> I imitated the style of the mail I replied to. Besides, choosing apps
> based on sound system is retarded if you wanted to indicate that this
> should be done more often or something.

What I indicated was that if someone wants to use multiple applications that 
work together bringing you The One Integrated Sound Experience it might make 
sense to use applications... that work together. Don't go blame ALSA for 
either the fact that aRTs isn't actually useful nor KDE's decision to stick 
with it for way too long. See -- the problem is again not ALSA (or OSS for 
that matter) but userspace not getting its act together.

KDE has finally dropped aRts from KDE4 and, again, ALSA has been mixing by 
default for some time now so we're talking history anyway. You want mixing 
on your card? You got it.

Many don't -- they might not care about desktop sounds period and/or they 
might use a clumsy chip/card for that and use a nice one for music without 
any need for mixing on it (such as I do). Admittedly, mixing Abba's Dancing 
Queen with Slayer's Angel of Death is great fun for quite a while but at 
some point you do actually grow weary of it...

> Exactly! And the config file is hostile if you want to change it.

It could be a bit nicer yes. Since software mixing is enabled by default now 
no configuration is generally needed though and it seems not a particularly 
huge priority. Now that it's an advanced feature, maybe the flexibility pays 
off in fact -- not sure, I don't use any configuration myself other than for 
some testing and playing around every once in a while.

> KDE 2 *was* released in 2000. Why would you care, I already admitted that
> sound daemons were there before ALSA.

Because blaming ALSA for bad decisions made by others seems a little off and 
you did exactly that a few messages back. Not nice!

>> You give up reporting small hardware problems that bother you because the
>> application developer documentation for something is not in great shape?
> 
> Yep, because I was frustrated with the whole thing. Having huge bad APIs
> with no documentation is telling your fellow developers to piss off and
> do something else. I did.

You weren't having a developer problem but a user problem. Your problem was 
not with the API documentation but with what would appear to be a simple 
glitch in one particular driver. Mixing that in with a "ALSA sucks because 
its documentation isn't upto par" is a little disingenious.

Sure the (library) documentation blows donkeys. So wat else's is new in the 
land of Linux? I recently did a block-ish driver. Documentation? Whahahaha!

So that leaves that "bad" that you prefixed API with but keep in mind that 
ALSA is designed as an audio system suitable for advanced/professional use 
while also still filling the needs of consumer users and that it does in 
fact do so is obvious from the fact that everyone's using it. A complex API 
is the downside of flexibility. Perhaps it would've been better if alsa-lib 
had also made a very simple API available to non-demanding users from the 
start but other software can do that as well.

For my current purposes libao does, but I hope in the future something like 
Phonon does. The ideal situation is that anyone in userspace is using a 
single API _such_ as Phonon since userspace has to synchronise things itself 
as well -- it might for example want to provide you with the option to 
automatically mute your music when you get an incoming call and this is not 
something which alsa-lib can do by itself.

If it looks like I'm shifting blame -- you bet I am. It's userspace which 
has for years failed to get its multimedia act together, with KDE and GNOME 
going out of their way to pick other infrastructure than the other one. The 
kernel is not a guilty party and improvements should be sought where the 
problems lie.

As said earlier, KDE4 might just be such an improvement. Personally I'm 
hoping I'll even manage to start running it this time because damnit, I miss 
solitaire...

>>> hacking (i.e. more features faster). Latency is an issue? - Well you
>>> can't play sound without userspace creating it so you're not adding any
>>> new problems.
>> 
>> Capture.
>> 
> If you are not doing DMA from the sound card to kernel memory and then 
> directly to disk blocks, you are using user space apps period. So what's 
> different with capture?

The latency in this case is defined as the time between data arriving at the 
machine from the outside and it being available for further processing by an 
application. Think looping stuff out again in realtime after doing something 
to it to see why you want it to be low. If you'll grant that all those users 
who were dissatisfied with early 2.6 weren't just blowing smoke, I assume 
you'll grant that latency matters and that putting it all in userspace is 
not an obvious step in minimising it -- even interrupt latency matters.

Note also it's certainly not (just) PCM but also very much MIDI. A musician 
hitting a key on a keyboard needs to hear the sound he's making, processed, 
recorded, stretched, whatever the computer does to it, with _very_ minimal 
latency. Yes, this means that the userspace application(s) have to be fast 
themselves but if they aren't getting their data delivered to them in time 
to begin with they're SOL. Perhaps it's possible to get okay results with a 
top-priority, realtime scheduled full stack in userspace which bangs I/O 
ports and does all those pesky driver thingies but why do we have a kernel 
again?

As to going the other way and putting it _all_ in the kernel; why? Why would 
you care about the split from an API standpoint? The alsa-lib API is the 
API, period. At which point it crosses over into the kernel is something an 
application gets to see as an implementation detail. Rejoice -- you now 
don't have to worry about floating point for example in the context of 
resampling and/or soft-volume, or ...

Rene.
