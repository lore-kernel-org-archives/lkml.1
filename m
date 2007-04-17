Return-Path: <linux-kernel-owner+w=401wt.eu-S1753182AbXDQJwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbXDQJwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 05:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbXDQJwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 05:52:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57085 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753182AbXDQJwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 05:52:07 -0400
Date: Tue, 17 Apr 2007 11:51:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Mike Galbraith <efault@gmx.de>, Peter Williams <pwil3058@bigpond.net.au>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070417095140.GB22626@elte.hu>
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <1176619384.6222.70.camel@Homer.simpson.net> <46240F98.3020800@bigpond.net.au> <1176776941.6222.21.camel@Homer.simpson.net> <20070417034050.GD25513@wotan.suse.de> <1176782489.13059.15.camel@Homer.simpson.net> <20070417041420.GF25513@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070417041420.GF25513@wotan.suse.de>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <npiggin@suse.de> wrote:

> > > Maybe the progress is that more key people are becoming open to 
> > > the idea of changing the scheduler.
> > 
> > Could be.  All was quiet for quite a while, but when RSDL showed up, 
> > it aroused enough interest to show that scheduling woes is on folks 
> > radar.
> 
> Well I know people have had woes with the scheduler for ever (I guess 
> that isn't going to change :P). [...]

yes, that part isnt going to change, because the CPU is a _scarce 
resource_ that is perhaps the most frequently overcommitted physical 
computer resource in existence, and because the kernel does not (yet) 
track eye movements of humans to figure out which tasks are more 
important them. So critical human constraints are unknown to the 
scheduler and thus complaints will always come.

The upstream scheduler thought it had enough information: the sleep 
average. So now the attempt is to go back and _simplify_ the scheduler 
and remove that information, and concentrate on getting fairness 
precisely right. The magic thing about 'fairness' is that it's a pretty 
good default policy if we decide that we simply have not enough 
information to do an intelligent choice.

( Lets be cautious though: the jury is still out whether people actually 
  like this more than the current approach. While CFS feedback looks 
  promising after a whopping 3 days of it being released [ ;-) ], the 
  test coverage of all 'fairness centric' schedulers, even considering 
  years of availability is less than 1% i'm afraid, and that < 1% was 
  mostly self-selecting. )

	Ingo
