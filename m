Return-Path: <linux-kernel-owner+w=401wt.eu-S1751532AbZISSBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532AbZISSBa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 14:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbZISSB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 14:01:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36430 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbZISSB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 14:01:29 -0400
Date: Sat, 19 Sep 2009 20:01:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Michael Buesch <mb@bu3sch.de>, Con Kolivas <kernel@kolivas.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090919180124.GK5366@elte.hu>
References: <20090906205952.GA6516@elte.hu> <20090907182629.GA3484@elte.hu> <20090908074825.GA11413@elte.hu> <200909081645.18505.mb@bu3sch.de> <20090918112454.GE9930@elte.hu> <4AB39D3A.3000204@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB39D3A.3000204@openwrt.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Felix Fietkau <nbd@openwrt.org> wrote:

> Ingo Molnar wrote:
> > * Michael Buesch <mb@bu3sch.de> wrote:
> > 
> >> On Tuesday 08 September 2009 09:48:25 Ingo Molnar wrote:
> >> > Mind poking on this one to figure out whether it's all repeatable 
> >> > and why that slowdown happens?
> >> 
> >> I repeated the test several times, because I couldn't really believe 
> >> that there's such a big difference for me, but the results were the 
> >> same. I don't really know what's going on nor how to find out what's 
> >> going on.
> > 
> > Well that's a really memory constrained MIPS device with like 16 MB of 
> > RAM or so? So having effects from small things like changing details in 
> > a kernel image is entirely plausible.
>
> Normally changing small details doesn't have much of an effect. While 
> 16 MB is indeed not that much, we do usually have around 8 MB free 
> with a full user space running. Changes to other subsystems normally 
> produce consistent and repeatable differences that seem entirely 
> unrelated to memory use, so any measurable difference related to 
> scheduler changes is unlikely to be related to the low amount of RAM. 
> By the way, we do frequently also test the same software with devices 
> that have more RAM, e.g. 32 or 64 MB and it usually behaves in a very 
> similar way.

Well, Michael Buesch posted vmstat results, and they show what i have 
found with my x86 simulated reproducer as well (these are Michael's 
numbers):

procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 1  0	   0  15892   1684   5868    0    0     0     0  268    6 31 69  0  0
 1  0	   0  15892   1684   5868    0    0     0     0  266    2 34 66  0  0
 1  0	   0  15892   1684   5868    0    0     0     0  266    6 33 67  0  0
 1  0	   0  15892   1684   5868    0    0     0     0  267    4 37 63  0  0
 1  0	   0  15892   1684   5868    0    0     0     0  267    6 34 66  0  0

on average 4 context switches _per second_. The scheduler is not a 
factor on this box.

Furthermore:

 | I'm currently unable to test BFS, because the device throws strange 
 | flash errors. Maybe the flash is broken :(

So maybe those flash errors somehow impacted the measurements as well?

	Ingo
