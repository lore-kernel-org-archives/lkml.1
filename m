Return-Path: <linux-kernel-owner+w=401wt.eu-S1755491AbXD0ILa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbXD0ILa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 04:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755493AbXD0ILa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 04:11:30 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:1037 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755491AbXD0ILZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 04:11:25 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: ck@vds.kolivas.org
Subject: Re: [ck] Re: Best nice level for X with SD
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
References: <200704241552.52552.Martin@lichtvoll.de> <200704242233.45304.Martin@lichtvoll.de> <200704262211.53393.Martin@lichtvoll.de> (sfid-20070426_222044_761818_6E7A6713)
In-Reply-To: <200704262211.53393.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Disposition: inline
Date: Fri, 27 Apr 2007 10:11:21 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200704271011.21340.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Am Freitag 27 April 2007 schrieb Con Kolivas:
> Clearly there are some serious regressions for audio playback with CFS.
> This is incredible effort to go to with CFS.

Hi Con!

Well, at least on my two ThinkPads T42 and T23.

I perceive sd-0.46 as more mature as CFSv6. And if asked to include one of 
them in the kernel *right now* or *soonish*, I would probably choose  
sd-0.46 and give Ingo a bit more time. 

Or I would suggest a plugging interface. For me it seems difficult to make 
large scale testing efforts when I have to build two kernels all the 
time. So at least a boot time configuration parameter, even better a 
parameter to switch schedulers on the fly would be good. This way it 
would be way easier to compare different schedulers. 

Just like with I/O schedulers.  I switched from "anticipatory" to Ingo's 
great "cfq" before it became the new default. I think that a few weeks of 
testing will never be enough. How long did it take till cfq became the 
new default? How much testing did people, including distributors such as 
SUSE / Novell - who switched to cfq eariler - do? Would that torough 
testing have been done when it was a patch outside of mainline all the 
time and there was no easy possibility to switch I/O schedulers?

I think that on process schedulers this would not be any different and any 
quick prefer this or this one will miss needed long time test results. 
But I have no clue whether plugsched, especially with online switching, 
wouldn't be too much overhead.

Well just my subjective opinion. I didn't do any professional benchmarks. 
But actually what I care about most is my usually workloads and whether I 
can click together corner cases to bring schedulers out of the bounds I 
like them to operate it. Cause thats what relevant for me when using a 
Linux machine as a desktop ;-). I didn't do any testing on a server 
tough, my virtual server just uses bog standard Debian etch kernel and I 
see no need to change that.

> > Still sd-0.46 is giving me as default what I have to configure with
> > cfs-v6 ;-). And as a user I want this behavior as default, instead of
> > having to fiddle with the schedular settings. Smooth music playback
> > is a must as Ingo agreed already ;).
>
> Nice to hear that SD does everything CFS strives to achieve. I'm glad I
> continued development on it so that it remains the reference for CFS to
> compare to.

I am happy, too. And Ingo is working really hard on it. I already have the 
next patch to test here. And it becomes better.

> lkml is perfectly suited for that discussion provided everyone follows
> the convention of cc'ing everyone on their replies, and I have taken
> the liberty of cc'ing it on this thread too.

Okay, I am CCing this to kernel list, too!

But my original concern was, whether you want to have these CFSv6 related 
tests on ck-patch-ml at all? Strictly spoken its about ck-patches and 
your stuff, and not other schedulers, but well, no one adhered that much 
to its topic in the last weeks.

Ok, but now to my daily tasks. These still (should) have priority ;-).

Regards,
Martin


Am Donnerstag 26 April 2007 schrieb Martin Steigerwald:

> it was working nice. Subjectively on par with sd-0.46.

Hi!

Well, there are still some audio glitches here and then. Even with

deepdance:/proc/sys/kernel> grep ".*" sched*gran*
sched_granularity_ns:0
sched_wakeup_granularity_ns:0

cfs-v6 has quite high context switch rates when driven with this 
configuration. This is context switch rates while Kaffeine plays music 
and a kernel compiles:

procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id 
wa
 3  0    136  22864    276 484680    0    0   149   102  379 1102 77  7 13  
3
 2  0    136  22864    276 484680    0    0     0    11  357 1849 99  1  0  
0
 1  0    136  22744    276 484808    0    0   128     0  413 2653 97  3  0  
0
 2  0    136  22744    276 484812    0    0     0     0  374 2382 96  4  0  
0
 1  0    136  22564    276 484940    0    0   128     0  411 2819 94  6  0  
0
 1  0    136  22564    276 484940    0    0     0     0  370 1938 98  2  0  
0
 1  0    136  22444    276 485068    0    0   128     0  374 2235 98  2  0  
0
 2  0    136  22444    276 485072    0    0     0     0  393 2329 97  3  0  
0
 1  0    136  22324    276 485200    0    0   128     0  351 1561 100  0  
0  0
 1  0    136  22324    276 485200    0    0     0     0  376 1790 99  1  0  
0

Maybe on desktop a schedular needs such high rates to provide excellent 
desktop responsiveness?

Ingo, I send you strace and vmstat stuff in a seperate mail. Ok, enough of 
it, we can continue this in private mail and I test your new cfs-v7-rc ,)


Back to my original question:

What nice value would do you recommend for X in sd-0.46? Really -10? I 
didn't renice at all... well what have others tried? Hmmm, Mike Mattie 
used -1. Maybe  I should try -5 or so? Well maybe I just try some values. 
I just would like to hear whether there an official recommendation? Like 
the -10 that cfs-v6 sets as default if X renicing is enabled.

And would it make sense to renice kernel threads as well with sd-0.46? I 
have seen these reniced to -10, but maybe thats default?

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
