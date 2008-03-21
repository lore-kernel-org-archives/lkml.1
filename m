Return-Path: <linux-kernel-owner+w=401wt.eu-S1756860AbYCUWK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860AbYCUWK2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 18:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbYCUWKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:10:18 -0400
Received: from www.tglx.de ([62.245.132.106]:41198 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412AbYCUWKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:10:17 -0400
Date: Fri, 21 Mar 2008 23:09:32 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Gabriel C <crazy@frugalware.org>
cc: Gabriel C <nix.or.die@googlemail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, andi-bz@firstfloor.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc5-git6: Reported regressions from 2.6.24
In-Reply-To: <47E42FAB.6000906@frugalware.org>
Message-ID: <alpine.LFD.1.00.0803212302390.3781@apollo.tec.linutronix.de>
References: <200803170018.52663.rjw@sisk.pl> <47DDB969.1060200@googlemail.com> <alpine.LFD.1.00.0803171716130.3781@apollo.tec.linutronix.de> <47DEB65A.9080907@googlemail.com> <47DF3E8B.6040502@googlemail.com> <47E3D322.1090902@googlemail.com>
 <alpine.LFD.1.00.0803211720340.3781@apollo.tec.linutronix.de> <47E3E66F.9040006@frugalware.org> <47E3FA4F.9060509@frugalware.org> <alpine.LFD.1.00.0803211944250.3781@apollo.tec.linutronix.de> <47E40B1C.30407@frugalware.org> <47E420C5.1050407@frugalware.org>
 <alpine.LFD.1.00.0803212208300.3781@apollo.tec.linutronix.de> <47E42FAB.6000906@frugalware.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2008, Gabriel C wrote:
> > So the rotating watchdog triggers for a yet to figure out reason.
> > 
> > Oh, now that the pm timer seems to work again, can you try the following:
> > 
> > apply the reverted patch again and let the box boot. At some point the
> > TSC is marked unstable and is replaced by acpi_pm clocksource.
> > 
> > What result does timewarp.c show in that situation ?
> 
> Here it is , same kernel + Andi's patch :
> 
> ./time-warp-test
> 4 CPUs, running 4 parallel test-tasks.
> checking for time-warps via:
> - read time stamp counter (RDTSC) instruction (cycle resolution)
> - gettimeofday (TOD) syscall (usec resolution)
> - clock_gettime(CLOCK_MONOTONIC) syscall (nsec resolution)
> 
> | 1.78 us, TSC-warps:0 | 19.27 us, TOD-warps:0 | 19.37 us, CLOCK-warps:0

Ok. So the watchdog trigger is a false positive. 

Thinking more about it, it looks like Andi's change triggers some
hidden bug in the combination of NO_HZ and add_timer_on(), where the
CPU on which the timer is added is likely in a long idle sleep. I look
into this tomorrow.

Thanks for testing

       tglx
