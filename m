Return-Path: <linux-kernel-owner+w=401wt.eu-S1764272AbXHARu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764272AbXHARu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 13:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758868AbXHARuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 13:50:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59280 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756346AbXHARuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 13:50:20 -0400
Date: Wed, 1 Aug 2007 19:50:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Roman Zippel <zippel@linux-m68k.org>,
       Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
Message-ID: <20070801175004.GA17936@elte.hu>
References: <Pine.LNX.4.64.0707130415520.1818@scrub.home> <1184302024.6709.11.camel@Homer.simpson.net> <Pine.LNX.4.64.0707131728070.1817@scrub.home> <1184389456.6632.13.camel@Homer.simpson.net> <Pine.LNX.4.64.0708010439050.1817@scrub.home> <20070801071230.GA16375@elte.hu> <Pine.LNX.4.64.0708011511530.1817@scrub.home> <20070801150742.GA23670@elte.hu> <p73ps27npu0.fsf@bingen.suse.de> <alpine.LFD.0.999.0708010924490.3582@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0708010924490.3582@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, 1 Aug 2007, Andi Kleen wrote:
> 
> > Ingo Molnar <mingo@elte.hu> writes:
> > 
> > > thanks. Just to make sure, while you said that your TSC was off on that 
> > > laptop, the bootup log of yours suggests a working TSC:
> > > 
> > >   Time: tsc clocksource has been installed.
> > 
> > Standard kernels often disable the TSC later after running a bit 
> > with it (e.g. on any cpufreq change without p state invariant TSC) 
> 
> I assume that what Roman hit was that he had explicitly disabled the 
> TSC because of TSC instability with the "notsc" kernel command line. 
> Which disabled is *entirely*.

but that does not appear to be the case, the debug info i got from Roman 
includes the following boot options:

  Kernel command line: auto BOOT_IMAGE=2.6.23-rc1-git9 ro root=306

there's no "notsc" option there.

Andi's theory cannot be true either, Roman's debug info also shows this 
/proc/<PID>/sched data:

  clock-delta              :                  95

that means that sched_clock() is in high-res mode, the TSC is alive and 
kicking and a sched_clock() call took 95 nanoseconds.

Roman, could you please help us with this mystery?

	Ingo
