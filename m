Return-Path: <linux-kernel-owner+w=401wt.eu-S1756176AbXJHMju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbXJHMju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 08:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754775AbXJHMjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 08:39:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51344 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754338AbXJHMjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 08:39:42 -0400
Date: Mon, 8 Oct 2007 14:39:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [3/6] scheduler: Do devirtualization for sched_fair
Message-ID: <20071008123933.GA4582@elte.hu>
References: <200710071059.126674000@suse.de> <20071007205956.5C4E71474B@wotan.suse.de> <20071008114234.GC22199@elte.hu> <200710081432.24776.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710081432.24776.ak@suse.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.1.7-deb
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0117]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@suse.de> wrote:

> > hm, i'm not convinced about this one. It increases the code size a 
> > bit
> 
> Tiny bit (<200 bytes) and the wait_for/sleep_on refactor patch in the 
> series saves over 1K so I should have some room for code size 
> increase. Overall it will be still considerable smaller.

there's no forced dependency between those two patches :-) So for now 
i've applied the one that saves text and skipped the one that bloats it.

> > and it's a sched.c local hack. If then this should be done on a 
> > generic infrastructure level - lots of other code (VFS, networking, 
> > etc.) could benefit from it i suspect - and then should be 
> > .configurable as well.
> 
> Unfortunately not -- for this to work (especially for inlining) 
> requires to
> #include files implementing the sub calls. Except for the scheduler 
> #that
> is pretty uncommon unfortunately. Also the situation regarding which 
> call target is the common one is typically much less clear than with 
> sched_fair / other scheduling classes.

some workloads would call sched_fair uncommon too. To me this seems like 
a workaround for the lack of a particular hardware feature.

> > Then the benefit might become measurable too.
> 
> It might have been measurable if the context switch was measurable at 
> all. Unfortunately the lmbench3 lat_ctx test I tired fluctuated by 
> itself over 50%. Ok I suppose it would be possible to instrument the 
> kernel itself to measure cycles. Would that convince you?

dunno, it would depend on the numbers. But really, in most workloads we 
do a lot more VFS indirect calls than scheduler indirect calls. So if 
this was an issue i'd really suggest to attack it in a generic way.

	Ingo
