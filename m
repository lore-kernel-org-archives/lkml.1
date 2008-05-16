Return-Path: <linux-kernel-owner+w=401wt.eu-S1754636AbYEPIlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbYEPIlf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 04:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbYEPIlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 04:41:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50863 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbYEPIlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 04:41:24 -0400
Date: Fri, 16 May 2008 10:40:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       "S.??a??lar Onur" <caglar@pardus.org.tr>, Valdis.Kletnieks@vt.edu,
       Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org
Subject: Re: [BISECTED] Lots of "rescheduling IPIs" in powertop
Message-ID: <20080516084059.GA31574@elte.hu>
References: <20080513204206.GA17781@damson.getinternet.no> <20080514065605.GB21369@elte.hu> <20080514090923.GC5607@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080514090923.GC5607@alberich.amd.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andreas Herrmann <andreas.herrmann3@amd.com> wrote:

> > > Recap: powertop shows between 200-400 wakeups/second with the 
> > > description "<kernel IPI>: Rescheduling interrupts" when all 
> > > processors have load (e.g. I need to run two busy-loops on my 
> > > 2-CPU system for this to show up).
> > 
> > ok, could you try the fix below? It was a mistake to make mwait use 
> > dependent on power considerations - on a desktop CPU it is unlikely 
> > to use more power than a simple HLT - and the IPIs are extra 
> > scheduling latency and extra power used.
> 
> It depends on the CPU. For AMD CPUs that support MWAIT this is wrong. 
> Family 0x10 and 0x11 CPUs will enter C1 on HLT. Powersavings then 
> depend on a clock divisor and current Pstate of the core.
> 
> If all cores of a processor are in halt state (C1) the processor can 
> enter the C1E (C1 enhanced) state. If mwait is used this will never 
> happen.
> 
> Thus HLT saves more power than MWAIT here.
> 
> It might be best to switch off the mwait flag for these AMD CPU 
> families like it was introduced with commit 
> f039b754714a422959027cb18bb33760eb8153f0 (x86: Don't use MWAIT on AMD 
> Family 10)

agreed, that looks like the cleanest solution. Could you please send a 
patch for that, ontop of my patch?

	Ingo
