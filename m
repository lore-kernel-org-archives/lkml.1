Return-Path: <linux-kernel-owner+w=401wt.eu-S1760516AbXHATGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760516AbXHATGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 15:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764664AbXHATGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 15:06:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34534 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764378AbXHATGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 15:06:18 -0400
Date: Wed, 1 Aug 2007 21:05:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
Message-ID: <20070801190556.GA1199@elte.hu>
References: <Pine.LNX.4.64.0707131728070.1817@scrub.home> <1184389456.6632.13.camel@Homer.simpson.net> <Pine.LNX.4.64.0708010439050.1817@scrub.home> <20070801071230.GA16375@elte.hu> <Pine.LNX.4.64.0708011511530.1817@scrub.home> <20070801150742.GA23670@elte.hu> <p73ps27npu0.fsf@bingen.suse.de> <alpine.LFD.0.999.0708010924490.3582@woody.linux-foundation.org> <20070801175004.GA17936@elte.hu> <Pine.LNX.4.64.0708011955430.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708011955430.1817@scrub.home>
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


* Roman Zippel <zippel@linux-m68k.org> wrote:

> Hi,
> 
> On Wed, 1 Aug 2007, Ingo Molnar wrote:
> 
> > Andi's theory cannot be true either, Roman's debug info also shows this 
> > /proc/<PID>/sched data:
> > 
> >   clock-delta              :                  95
> > 
> > that means that sched_clock() is in high-res mode, the TSC is alive and 
> > kicking and a sched_clock() call took 95 nanoseconds.
> > 
> > Roman, could you please help us with this mystery?
> 
> Actually, Andi is right. What I sent you was generated directly after 
> boot, as I had to reboot for the right kernel, so a little later 
> appeared this:
> 
> Aug  1 14:54:30 spit kernel: eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
> Aug  1 15:09:56 spit kernel: Clocksource tsc unstable (delta = 656747233 ns)
> Aug  1 15:09:56 spit kernel: Time: pit clocksource has been installed.

just to make sure, how does 'top' output of the l + "lt 3" testcase look 
like now on your laptop? Yesterday it was this:

 4544 roman     20   0  1796  520  432 S 32.1  0.4   0:21.08 lt
 4545 roman     20   0  1796  344  256 R 32.1  0.3   0:21.07 lt
 4546 roman     20   0  1796  344  256 R 31.7  0.3   0:21.07 lt
 4547 roman     20   0  1532  272  216 R  3.3  0.2   0:01.94 l

and i'm still wondering how that output was possible.

	Ingo
