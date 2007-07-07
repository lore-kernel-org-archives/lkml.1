Return-Path: <linux-kernel-owner+w=401wt.eu-S1755728AbXGGDA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728AbXGGDA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 23:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754145AbXGGDAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 23:00:19 -0400
Received: from osiris.atheme.org ([69.60.119.211]:42037 "EHLO
	osiris.atheme.org" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753737AbXGGDAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 23:00:18 -0400
X-Greylist: delayed 1150 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Jul 2007 23:00:18 EDT
Date: Sat, 7 Jul 2007 02:41:05 +0000 (GMT)
From: William Pitcock <nenolod@atheme-project.org>
X-X-Sender: nenolod@osiris.atheme.org
To: Adrian Bunk <bunk@stusta.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
Message-ID: <Pine.LNX.4.64.0707070220440.20167@osiris.atheme.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jul 2007 19:32:29 +0200, Adrian Bunk wrote:
> On Wed, Jul 04, 2007 at 02:35:39AM -0400, Darren wrote:
>>
>> I know this may sound kind of stupid, but how about not deprecating either,
>> and fully supporting both sound systems? Maybe we can get them to work
>> together, and the distro or user can choose whether they would like to use
>> alsa or oss for that particular card (or have the distro choose the sound
>> drivers that are best supported for that particular card). As it is now,
>> most apps already support oss and alsa.
>
> It does not sound stupid and sounds good at first sight.
>
> But there are problems we've already seen with similar situations in
> different parts of the kernel:
> They would have different hardware support, features and bugs.
>
> And then a user user whose sound card is only supported by sound system A
> needs a feature only available in sound system B.
>
> And the quality decreases since people will often not report bugs in
> sound system A if sound system B works for them.
>
> OTOH, for a user it shouldn't matter whether there's OSS or ALSA, that's
> mostly a difference for application developers. And since (as you say)
> most applications already support both, there's no compelling reason for
> providing more than one of them.
> 
> cu
> Adrian
>

If the developers of ALSA made a nuclear reactor, it would have five 
different control panels for controlling the rods in the reactor core, and 
each would do something different and not what the documentation said.

Actually, I lied about that. It wouldn't have any usable documentation. 
But, there would be a hidden feature that you could sound the overload 
alarm by pulling out the stapler in the control office. Useful feature, 
that.

As an audio developer on Linux, I must say that developing with ALSA is 
absolute fucking hell. If there was a way where both APIs could natively 
be supported, more people would be happy with the current state of affairs 
in the kernel.

The most fucked up thing that I can think of about the current state of 
affairs in ALSA is dmix. Every other UNIX sound system like ALSA does it's 
software mixing in kernel space. The applications never even know about 
it. It's not only until recently (2005-2006 or so) that ALSA came close to 
this, but there are still problems. Many cards need workarounds to make 
dmix work because of the way it works, and the way that ALSA buffers data 
around.

For the non-technically inclined, ALSA only keeps two fragments for 
input/output data each. This is horribly unusable because most soundcard 
fragments are only 1KB, so applications have to adopt ringbuffers to pass 
data to ALSA. If you're doing video, this leads to possible timing issues 
unless you sit down and well design your abstraction layer for audio I/O.

So people switch to things like JACK and PulseAudio because it's the only 
way they can get workable Audio I/O on ALSA.

What's even worse for the ALSA API is that it's designed around lowlatency 
programming, but only a few drivers properly support it. Why do you need 
lowlatency access to play a beep or a ding or whatever? The simple answer 
is you don't.

ALSA could and can be done correctly, but OSS4 is already here and 
provides an API which solves all of ALSA's current problems. So why waste 
time with that, when OSS4 is already here and more friendly to the 
developers of the software most Linux users use?

If OSS4 and ALSA apis could run on the same base driver, then a lot more 
people will be happier, as there will be choice available in which API to 
use, e.g. OSS4 or the libasound self-abuse method.

Hannu has ideas on how that could work. I suggest all of the kernel 
developers listen, and listen well, or this mess will never be fixed in a 
way that is truly usable.

   -nenolod
