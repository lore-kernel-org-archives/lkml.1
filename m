Return-Path: <linux-kernel-owner+w=401wt.eu-S1751995AbXE2Xyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbXE2Xyp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 19:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750876AbXE2Xyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 19:54:37 -0400
Received: from omta05ps.mx.bigpond.com ([144.140.83.195]:32649 "EHLO
	omta05ps.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbXE2Xyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 19:54:37 -0400
Message-ID: <465CBD35.2000109@bigpond.net.au>
Date: Wed, 30 May 2007 09:54:29 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, colpatch@us.ibm.com,
       Nick Piggin <nickpiggin@yahoo.com.au>, Con Kolivas <kernel@kolivas.org>,
       Christoph Lameter <clameter@sgi.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] CFS scheduler, -v12
References: <464CE8FD.4070205@bigpond.net.au> <20070518071325.GB28702@elte.hu> <464DA61A.4040406@bigpond.net.au> <b647ffbd0705210825y25331066x8b2a4d50cdb7c266@mail.gmail.com> <46523081.6050007@bigpond.net.au> <465275EF.8060905@bigpond.net.au> <4652DC03.60801@bigpond.net.au> <4655423E.6000202@bigpond.net.au> <20070524164538.GA13301@linux-os.sc.intel.com> <46561E67.3030207@bigpond.net.au> <20070529204557.GB3693@linux-os.sc.intel.com>
In-Reply-To: <20070529204557.GB3693@linux-os.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta05ps.mx.bigpond.com from [60.231.45.148] using ID pwil3058@bigpond.net.au at Tue, 29 May 2007 23:54:34 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Siddha, Suresh B wrote:
> On Thu, May 24, 2007 at 04:23:19PM -0700, Peter Williams wrote:
>> Siddha, Suresh B wrote:
>>> On Thu, May 24, 2007 at 12:43:58AM -0700, Peter Williams wrote:
>>>> Further testing indicates that CONFIG_SCHED_MC is not implicated and
>>>> it's CONFIG_SCHED_SMT that's causing the problem.  This rules out the
>>>> code in find_busiest_group() as it is common to both macros.
>>>>
>>>> I think this makes the scheduling domain parameter values the most
>>>> likely cause of the problem.  I'm not very familiar with this code so
>>>> I've added those who've modified this code in the last year or
>>>> so to the
>>>> address of this e-mail.
>>> What platform is this? I remember you mentioned its a 2 cpu box. Is it
>>> dual core or dual package or one with HT?
>> It's a single CPU HT box i.e. 2 virtual CPUs.  "cat /proc/cpuinfo"
>> produces:
> 
> Peter, I tried on a similar box and couldn't reproduce this problem
> with x86_64

Mine's a 32 bit machine.

> 2.6.22-rc3 kernel

I haven't tried rc3 yet.

> and using defconfig(has SCHED_SMT turned on).
> I am using top and just the spinners.  I don't have gkrellm running, is that
> required to reproduce the issue?

Not necessarily.  But you may need to do a number of trials as sheer 
chance plays a part.

> 
> I tried number of times and also in runlevels 3,5(with top running
> in a xterm incase of runlevel 5).

I've always done it in run level 5 using gnome-terminal.  I use 10 
consecutive trials without seeing the problem as an indication of its 
absence but will cut that short if I see a 3/1 which quickly recovers 
(see below).

> 
> In runlevel 5, occasionally for one refresh screen of top, I see three
> spinners on one cpu and one spinner on other(with X or someother app
> also on the cpu with one spinner). But it balances nicely for the
> immd next refresh of the top screen.

Yes, that (the fact that it recovers quickly) confirms that the problem 
isn't present for your system.  If load balancing occurs when other 
tasks than the spinners are actually running a 1/3 split for the 
spinners is a reasonable outcome so seeing the occasional 1/3 split is 
OK but it should return to 2/2 as soon as the other tasks sleep.

When I'm doing my tests (for the various combinations of macros) I 
always count a case where I see a 3/1 split that quickly recovers as 
proof that this problem isn't present for that case and cease testing.

> 
> I tried with various refresh rates of top too.. Do you see the issue
> at runlevel 3 too?

I haven't tried that.

Do your spinners ever relinquish the CPU voluntarily?

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
