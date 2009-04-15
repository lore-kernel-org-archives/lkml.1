Return-Path: <linux-kernel-owner+w=401wt.eu-S1754991AbZDOQmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbZDOQmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 12:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754779AbZDOQmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 12:42:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39835 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754699AbZDOQme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 12:42:34 -0400
Date: Wed, 15 Apr 2009 18:41:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ali Gholami Rudi <ali@rudi.ir>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Dave Jones <davej@redhat.com>
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
Message-ID: <20090415164143.GA9871@elte.hu>
References: <200904140159.n3E1x1K1014705@hera.kernel.org> <20090414020544.GA3738@elte.hu> <20090415054417.GA5272@elte.hu> <alpine.LFD.2.00.0904150755170.4132@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904150755170.4132@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, 15 Apr 2009, Ingo Molnar wrote:
> > 
> > fuller log below. I think this is because 
> > smp_call_function_many() was essentially unused before - an IPI 
> > function should not trigger this warning, it will naturally be 
> > called in preemptible context.
> 
> Yeah, that thing is buggy. It just does "this_cpu = 
> smp_processor_id()".
> 
> But I have to admit that the breakage is documented. Both the 
> "other CPU's" part _and_ the "preemption must be disabled when 
> calling".
> 
> So it's not a bug, it's a "feature".
> 
> Which is obviously not to say that the thing isn't complete crap.
> 
> This patch should fix it - not by fixing smp_call_function_many(), 
> but by just living with the breakage. Andrew already sent out a 
> patch that just avoided the function entirely, but at least some 
> systems are likely to be able to do one single broadcast IPI with 
> this, so it's at least in theory still better to use that 
> smp_call_function_many() function, even though it has braindamaged 
> semantics.

I have no good way to trigger the bug right now: it triggered only 
once (maybe twice) in the past 2 days, and was not repeatable. But 
your patch looks like it should work around the API problem. Should 
Dave or me apply it, or will you?

But the whole code there had a pretty suspicious affinity handling 
to begin with and the cpumask changes just tried to keep the status 
quo (and even had trouble at keeping that ;-) and didnt improve it.

	Ingo
