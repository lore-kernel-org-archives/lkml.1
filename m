Return-Path: <linux-kernel-owner+w=401wt.eu-S965710AbXCLLiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965710AbXCLLiz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 07:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965706AbXCLLiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 07:38:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49653 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965663AbXCLLiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 07:38:54 -0400
Date: Mon, 12 Mar 2007 12:38:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Roland McGrath <roland@redhat.com>, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, drepper@redhat.com, oleg@tv-sign.ru,
       sebastien.dugue@bull.net, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] change futex_wait() to hrtimers
Message-ID: <20070312113829.GA18759@elte.hu>
References: <200703110814.l2B8EaI1007615@shell0.pdx.osdl.net> <20070312011259.3834A1801C4@magilla.sf.frob.com> <20070312091006.GF21024@elte.hu> <20070312091628.GE28546@wotan.suse.de> <20070312110204.GD2231@elte.hu> <20070312111331.GF28546@wotan.suse.de> <20070312111958.GA14573@elte.hu> <20070312112955.GH28546@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070312112955.GH28546@wotan.suse.de>
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

> > the issue is this: your fix reduces the effects of the bug but it is 
> > still fundamentally incomplete because of the use of timer_list. So
> 
> But using schedule_timeout is not a bug. Userspace timeouts are always 
> defined to be "at least".

but what you are adding isnt a plain schedule_timeout(), it is a restart 
block handling loop. And for those restart blocks that relate to 
timeouts, we only use hrtimers. I am not making this up to annoy you: 
take a look at all the current restart block handlers - they are hrtimer 
based, for exactly this reason.

> > instead of trying to fix the bug the wrong way, please try to fix it 
> > the right way, ontop of an already existing and tested patch, ok? 
> > That also enables the other neat stuff Thomas talked about.
> 
> Well that's nice, but I have a bugfix here which probably needs to get 
> backported to stable kernels and distro kernels.

yes but your patch already exists for them which they can pick up.

really, this is a common Linux principle: fix it completely and fix it 
the right way. You are applying it yourself on a daily basis when having 
the maintainer hat on =B-)

> It should be just as easy to rebase the hrtimer patch on top of my 
> fix. Considering that you've had it for a year, I don't think it needs 
> to be added right before my fix.

your latest patch looks quite kludgy, exactly due to the issues that 
were mentioned.

> > hm. I'm wondering how this wasnt noticed sooner - this futex_wait 
> > behavior has been there for like forever.
> 
> People ignore LTP test failures, and programs probably try to avoid 
> exercising the nuances of the unix signal API, I guess.

then there's no rush and lets do this the right way, ok?

	Ingo
