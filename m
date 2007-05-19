Return-Path: <linux-kernel-owner+w=401wt.eu-S1764718AbXESVQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764718AbXESVQ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 17:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758472AbXESVQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 17:16:47 -0400
Received: from d0618453.dreamhost.com ([208.97.132.83]:50651 "EHLO
	spaceymail-a4.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755568AbXESVQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 17:16:46 -0400
From: Anant Nitya <kernel@prachanda.info>
Organization: Prachanda Hub
To: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v13
Date: Sun, 20 May 2007 02:46:19 +0530
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20070517174533.GA538@elte.hu> <200705180317.06014.kernel@prachanda.hub> <20070518102607.GA23151@elte.hu>
In-Reply-To: <20070518102607.GA23151@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705200246.22444.kernel@prachanda.hub>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 May 2007 15:56:07 Ingo Molnar wrote:
> * Anant Nitya <kernel@prachanda.info> wrote:
> > Hi
> >
> > Been testing this version of CFS from last an hour or so and still
> > facing same lag problems while browsing sites with heavy JS and or
> > flash usage. Mouse movement is pathetic and audio starts to skip. I
> > haven't face this behavior with CFS till v11.
>
> i have just tried 5 different versions of the Flash plugin and i cannot
> reproduce this (flash games are still smooth and acceptable even with
> the system significantly overloaded with 5 infite loops or with a kernel
> build), so it would be nice if you could help me debug this problem.
>
> The last version that worked for you was v11, correct? The biggest v11
> -> v12 change was the yield workaround, and while testing your workload
> i also noticed that all Flash versions except the latest one (9.0 r31)
> use sys_sched_yield() quite frequently. So it would be nice to know
> which plugin version you are using (and which Firefox version): you can
> check that by typing about:plugins into firefox. Furthermore, could you
> also try the following tune:
>
>    echo 0 > /proc/sys/kernel/sched_yield_bug_workaround
>
> and this:
>
>    echo 2 > /proc/sys/kernel/sched_yield_bug_workaround
>
> if none of this changes behavior then please send me the output of the
> following:
>
>   strace -ttt -TTT -o strace.txt -f -p `pidof firefox-bin`
>   < reproduce the lag in firefox >
>   < Ctrl-C the strace >
>
> and send me the strace.txt file (off-line, it's going to be large).
> Thanks,
Hi Ingo,

Please ignore my last report about lag problem while using CFS-v13, it is 
working perfectly fine with 2.6.21.1 and the lag I used to see in v12 is not 
there with v13 anymore. After digging in a bit I found that problem is only 
occurring in 2.6.22-rc1 and it get fired by network usage while transmitting 
data upstream. I don't have any evidence that CFS is involved in lag problem 
since 2.6.22-rc1 with stock scheduler is also having same lag problem and it 
seems directly proportional with upstream speed while downstream doesn't 
shows any misbehavior { at lower upstream speed lag is less but with higher 
upstream speed system starts crawling and system load hitting to 70/75}. Lets 
see how 2.6.22-rc2 is doing.

Regards
Ananitya

>
> 	Ingo



-- 
Out of many thousands, one may endeavor for perfection, and of
those who have achieved perfection, hardly one knows Me in truth.
				-- Gita Sutra Of Mysticism
