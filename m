Return-Path: <linux-kernel-owner+w=401wt.eu-S1750833AbXDHLdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750833AbXDHLdn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 07:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750898AbXDHLdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 07:33:43 -0400
Received: from vms040pub.verizon.net ([206.46.252.40]:59921 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbXDHLdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 07:33:42 -0400
Date: Sun, 08 Apr 2007 07:33:38 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Ten percent test
In-reply-to: <20070408104125.GB11123@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>,
       Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
Message-id: <200704080733.39303.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200703290237.38777.kernel@kolivas.org>
 <200704071630.25830.gene.heskett@gmail.com> <20070408104125.GB11123@elte.hu>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 April 2007, Ingo Molnar wrote:
>* Gene Heskett <gene.heskett@gmail.com> wrote:
>> That said, I am booted to the patch you sent me now, and this also is
>> a very obvious improvement, one I could easily live with on a long
>> term basis.  I haven't tried a kernel build in the background yet, but
>> I have sat here and played patience for about an hour, looking for the
>> little stutters, but never saw them.  So I could just as easily
>> recommend this one for desktop use, it seems to be working.  tvtime
>> hasn't had any audio or video glitches that I've noted when I was on
>> that screen to check on an interesting story, like the 102 year old
>> lady who finally got her hole in one, on a very short hole, but after
>> 90 years of golfing, she was beginning to wonder if she would ever get
>> one.  Not sure who bought at the 19th hole, HNN didn't cover that
>> traditional part.
>>
>> So this patch also works.  And if it gets into mainline, at least
>> Con's efforts at proding the fixes needed will not have been in vain.
>
>thanks for testing it! (for the record, Gene tested sched-mike-4.patch,
>which is Mike's patch from 4 days ago.)
>
>> My question then, is why did it take a very public cat-fight to get
>> this looked at and the code adjusted?  Its been what, nearly 2 years
>> since Linus himself made a comment that this thing needed fixed.  The
>> fixes then done were of very little actual effectiveness and the
>> situation then has gradually deteriorated since.
>
>this is pretty hard to get right, and the most objective way to change
>it is to do it testcase-driven. FYI, interactivity tweaking has been
>gradual, the last bigger round of interactivity changes were done a year
>ago:
>
> commit 5ce74abe788a26698876e66b9c9ce7e7acc25413
> Author: Mike Galbraith <efault@gmx.de>
> Date:   Mon Apr 10 22:52:44 2006 -0700
>
>     [PATCH] sched: fix interactive task starvation
>
>(and a few smaller tweaks since then too.)
>
>and that change from Mike responded to a testcase. Mike's latest changes
>(the ones you just tested) were mostly driven by actual testcases too,
>which measured long-term timeslice distribution fairness.
>
>It's really hard to judge interactivity subjectively, so we rely on
>things like interbench (written by Con) - in which testsuite the
>upstream scheduler didnt fare all that badly, plus other testcases
>(thud.c, game_sim.c, now massive_inter.c, fiftyp.c and chew.c) and all
>the usual test-workloads. This is admittedly a slow process, but it
>seems to be working too and it also ensures that we dont regress in the
>future. (because testcases stick around and do get re-tested)
>
>your system seems to also be a bit special because you 1) drive it to
>the absolute max on the desktop but you do not overload it in obvious
>ways (i.e. your workloads are pretty fairly structured) 2) it's a bit
>under-powered (single-CPU 800 MHz CPU, right?) but not _too_
>underpowered - so i think you /just/ managed to hit 'the worst' of the
>current interactivity estimator: with important tasks both being just
>above and just below 50%. Believe me, on all ~10 systems i use
>regularly, Linux interactivity of the vanilla scheduler is stellar. (And
>that includes a really old 500 MHz one too with FC6 on it.)

Actually, its an XP2800 Athlon, 333 fsb, gig of memory.  And I was all 
enthusiastic about this until amanda's nightly run started, at which 
point I started losing control for quite long periods, 30+ seconds at a 
time.  Up till then I thought we had it made.  In this regard, Cons 
patches were enough better to notice it right away, lags were 1-2 seconds 
max.

That seems to be the killer loading here, building a kernel (make -j3) 
doesn't seem to lag it all that bad.  One session of gzip -best makes it 
fall plumb over though, which was a disappointment.

But, I could live with this.

Now if I could figure out a way to nail dm_mod down to a fixed LANANA 
approved address, I just got bit again, because enabling pktcdvd caused a 
MAJOR switch, only from 253 to 252 but tar thinks the whole 45GB is all 
new again.  So since it, dm_mod, no longer carries the experimental 
label, lets put that patch back in and be done with this particular 
hassle once and for all.  If I had known that using LVM2 was going to be 
such a pain in the ass just with this item alone, I wouldn't have touched 
it with a 50 foot fiberglass pole.  Or does this SOB effect normal 
partition mountings too?  I don't know, and the suggested fixes from 
David Dillow I put in /etc/modprobe.conf are ignored for dm_mod, and when 
extended to pktcdvd, cause pktcdvd to fail totally.

Mmm??, can I pass an 'option dm_mod major=238' as a kernel argument & make 
it work that way?  This is extremely frustrating as it is now.

>	Ingo

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Real Programmers don't write in PL/I.  PL/I is for programmers who can't
decide whether to write in COBOL or FORTRAN.
