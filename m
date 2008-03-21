Return-Path: <linux-kernel-owner+w=401wt.eu-S1761810AbYCUVQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761810AbYCUVQ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 17:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755121AbYCUVQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 17:16:21 -0400
Received: from www.tglx.de ([62.245.132.106]:41348 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754926AbYCUVQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 17:16:20 -0400
Date: Fri, 21 Mar 2008 22:15:28 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Gabriel C <crazy@frugalware.org>
cc: Gabriel C <nix.or.die@googlemail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, andi-bz@firstfloor.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc5-git6: Reported regressions from 2.6.24
In-Reply-To: <47E420C5.1050407@frugalware.org>
Message-ID: <alpine.LFD.1.00.0803212208300.3781@apollo.tec.linutronix.de>
References: <200803170018.52663.rjw@sisk.pl> <47DDB969.1060200@googlemail.com> <alpine.LFD.1.00.0803171716130.3781@apollo.tec.linutronix.de> <47DEB65A.9080907@googlemail.com> <47DF3E8B.6040502@googlemail.com> <47E3D322.1090902@googlemail.com>
 <alpine.LFD.1.00.0803211720340.3781@apollo.tec.linutronix.de> <47E3E66F.9040006@frugalware.org> <47E3FA4F.9060509@frugalware.org> <alpine.LFD.1.00.0803211944250.3781@apollo.tec.linutronix.de> <47E40B1C.30407@frugalware.org>
 <47E420C5.1050407@frugalware.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008, Gabriel C wrote:
> >>> Does that make any sense ?
> >> Not really. Can you please revert the reverted revert again and run
> >>
> >> http://people.redhat.com/mingo/time-warp-test/time-warp-test.c
> >>
> >> on your machine with all CPUs and HT enabled ?
> > 
> > Sure , doing so now.
> > 
> 
> Here the result on 2.6.25-rc6-00243-g028011e ( it was running 30++
> minutes the time I was away for food =) )
> ...
> 
>  4 CPUs, running 4 parallel test-tasks.
> checking for time-warps via:
> - read time stamp counter (RDTSC) instruction (cycle resolution)
> - gettimeofday (TOD) syscall (usec resolution)
> - clock_gettime(CLOCK_MONOTONIC) syscall (nsec resolution)
> 
> | 1.46 us, TSC-warps:0 | 16.01 us, TOD-warps:0 | 16.10 us, CLOCK-warps:0

Amazing. I never found a multi socket box where the TSC's were in sync.

So the rotating watchdog triggers for a yet to figure out reason.

Oh, now that the pm timer seems to work again, can you try the following:

apply the reverted patch again and let the box boot. At some point the
TSC is marked unstable and is replaced by acpi_pm clocksource.

What result does timewarp.c show in that situation ?

Thanks,
	tglx
