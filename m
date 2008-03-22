Return-Path: <linux-kernel-owner+w=401wt.eu-S1756753AbYCVOWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753AbYCVOWV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 10:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754557AbYCVOWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 10:22:11 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36005 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523AbYCVOWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 10:22:10 -0400
Date: Sat, 22 Mar 2008 15:25:02 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Gabriel C <crazy@frugalware.org>, Gabriel C <nix.or.die@googlemail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, andi-bz@firstfloor.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc5-git6: Reported regressions from 2.6.24
Message-ID: <20080322142502.GA10687@one.firstfloor.org>
References: <alpine.LFD.1.00.0803211720340.3781@apollo.tec.linutronix.de> <47E3E66F.9040006@frugalware.org> <47E3FA4F.9060509@frugalware.org> <alpine.LFD.1.00.0803211944250.3781@apollo.tec.linutronix.de> <47E40B1C.30407@frugalware.org> <47E420C5.1050407@frugalware.org> <alpine.LFD.1.00.0803212208300.3781@apollo.tec.linutronix.de> <47E42FAB.6000906@frugalware.org> <alpine.LFD.1.00.0803212302390.3781@apollo.tec.linutronix.de> <alpine.LFD.1.00.0803220847020.3781@apollo.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803220847020.3781@apollo.tec.linutronix.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> CPU0 runs the watchdog timer and schedules it on CPU1.
> 
> With NO_HZ enabled CPU1 is in a long idle sleep. At this point of the
> boot process there is probably no timer pending on CPU1, which means
> the idle sleep is infinite.
> 
> Now some time later CPU1 gets woken by an interrupt/IPI and runs the
> timer wheel. At this point the pm_timer which is the reference clock
> has already wrapped around, so the watchdog thinks that there is a

In my old original own noidletick code I simply limited all sleeps 
to below the wrap around of the primary timer.  Wouldn't something 
like that work?

In the case of the watchdog i guess it would need to be limited
to the wrap around of multiple timers, at least all that 
are used by the watchdog.

I'm not sure just doing this for add_timer_on() only is correct.
After all it could affect any other code not run by add_timer_on()
couldn't it?

-Andi

