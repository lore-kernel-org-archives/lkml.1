Return-Path: <linux-kernel-owner+w=401wt.eu-S933668AbXCEVvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933668AbXCEVvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 16:51:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933667AbXCEVvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 16:51:23 -0500
Received: from mail09.syd.optusnet.com.au ([211.29.132.190]:39594 "EHLO
	mail09.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933669AbXCEVvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 16:51:21 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Simon Arlott <simon@fire.lp0.eu>
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu   scheduler
Date: Tue, 6 Mar 2007 08:36:26 +1100
User-Agent: KMail/1.9.5
Cc: ck list <ck@vds.kolivas.org>, linux-kernel@vger.kernel.org
References: <200703042335.26785.a1426z@gawab.com> <200703050927.52563.kernel@kolivas.org> <45EC616F.6090809@simon.arlott.org.uk>
In-Reply-To: <45EC616F.6090809@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703060836.27683.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 March 2007 05:29, Simon Arlott wrote:
> On 04/03/07 22:27, Con Kolivas wrote:
> > On Monday 05 March 2007 09:19, Simon Arlott wrote:
> >> If I run glxgears, thunderbird/firefox become really slow to
> >> respond/display and cpu usage isn't even at 100%. I had thunderbird
> >> lagging on keyboard character repeat earlier but can't reproduce that
> >> now even with glxgears - however firefox lags really badly on keyboard
> >> input with glxgears running.
> >
> > Hi Simon
> >
> > You're hitting a nasty udev bug here that is unrelated to the cpu
> > scheduler
>
> Yes, I've already reported this.
>
> > and almost certainly responsible for your bad behaviour.
>
> What? How do you make the leap from lockdep output on boot to my experience
> of slow interactive response?

In general I've found once the kernel did something funny on boot that not 
much beyond that could be trusted. However a very small period of alarm with 
lockdep, _assuming it was transient and did not happen later_ as you say, 
would not cause problems.

> > Also this patch was actually for 2.6.20 and you seem to have applied it
> > to 2.6.21-rc2. I haven't even checked that it cleanly applies to that
> > kernel.
>
> It doesn't, a one line fix from Ingo conflicts (and a comment that was
> changed). 7355690ead6d61f6344072ae61060f985060da29 [PATCH] sched: fix SMT
> scheduler bug 72fd4a35a824331d7a0f4168d7576502d95d34b3 [PATCH] Numerous
> fixes to kernel-doc info in source files.

Ok, but I was very reluctant to release this code as a patch to -rc2 because 
the potential for all sorts of weird and wonderful fireworks and explosions 
from the -pre release makes it a lousy testing ground for something else. 
It's often hard to differentiate breakage in behaviour in the unstable kernel 
or the patch you're applying. I was even somewhat reluctant to be releasing 
this patch for 2.6.20 since people are mumbling (offlist) that they're 
getting weird stalls on that kernel - however they're afraid to report them 
to lkml since their issues are fuzzy and they know they'll be ask to do git 
bisect on an intermittent problem; git bisect as we know is rocket science 
(or brain surgery if you happen to be a rocket scientist).

> I have reverted your patch and the laggy behaviour remains when running
> glxgears (in fact it seems a bit worse), I don't know about the thunderbird
> lag while typing since I can't easily reproduce it but I don't recall it
> ever happening before. So, your patch isn't the cause of a serious slowdown
> when running glxgears in the background (although it doesn't improve the
> situation much). It looks like it just slows down X in general rather than
> using much CPU.

Which goes back to my original comment about glxgears, only I should have made 
my advice stronger; glxgears should not be used as a benchmarking or test 
tool of any sort period. It displays pretty gears and that's all. On your 
machine, for example, it is not cpu bound from the looks of your description, 
and either loads up the bus or drowns the gpu in ways that delays other gpu 
activity. On other hardware combinations, it does something completely 
different. Given that, it's easy to see how it is impossible to use it as a 
cpu scheduling test of any sort.

-- 
-ck
