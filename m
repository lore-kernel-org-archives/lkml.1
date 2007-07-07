Return-Path: <linux-kernel-owner+w=401wt.eu-S1754326AbXGGECs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbXGGECs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 00:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751009AbXGGECi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 00:02:38 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:53234 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750962AbXGGECh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 00:02:37 -0400
Date: Sat, 7 Jul 2007 06:03:07 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Chuck Ebbert <cebbert@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       mbligh@google.com
Subject: Re: [patch 10/10] Scheduler profiling - Use immediate values
Message-ID: <20070707040307.GD3492@stusta.de>
References: <20070703164516.377240547@polymtl.ca> <20070703181151.GB5800@martell.zuzino.mipt.ru> <20070703185748.GA4047@Krystal> <20070705132120.8edbc1f3.akpm@linux-foundation.org> <p73vecx21um.fsf@bingen.suse.de> <468EBEB2.4070605@redhat.com> <20070706232843.GT3492@stusta.de> <20070706234315.GA19804@Krystal> <20070707022526.GC3492@stusta.de> <20070707023511.GA25778@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070707023511.GA25778@Krystal>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2007 at 10:35:11PM -0400, Mathieu Desnoyers wrote:
> * Adrian Bunk (bunk@stusta.de) wrote:
> > On Fri, Jul 06, 2007 at 07:43:15PM -0400, Mathieu Desnoyers wrote:
> > > * Adrian Bunk (bunk@stusta.de) wrote:
> > > > On Fri, Jul 06, 2007 at 06:14:10PM -0400, Chuck Ebbert wrote:
> > > > > On 07/06/2007 07:44 AM, Andi Kleen wrote:
> > > > > > I think the optimization is a good idea, although i dislike it
> > > > > > that it is complicated for the dynamic markers. If it was just
> > > > > > static it would be much simpler.
> > > > > 
> > > > > Another thing to consider is that there might be hundreds of these
> > > > > probes/tracepoints active in an instrumented kernel. The overhead
> > > > > adds up fast, so the gain may be worth all the pain.
> > > > 
> > > > Only if you want to squeeze the last bit of performance out of
> > > > _debugging_ functionality.
> > > > 
> > > > You avoid all the pain if you simply don't use debugging functionality 
> > > > on production systems.
> > > > 
> > > 
> > > Adrian,
> > > 
> > > Please have a look at my markers posts, especially:
> > > 
> > > http://www.ussg.iu.edu/hypermail/linux/kernel/0707.0/0669.html
> > > 
> > > And also look into OLS 2007 proceedings for Martin Bligh's paper on
> > > Debugging Google sized clusters. It basically makes the case for adding
> > > functionnality to debug _user space_ problems on production systems that
> > > can be turned on dynamically.
> > 
> > Using a different kernel for tracing still fulfills all the requirements 
> > listed in section 5 of your paper...
> > 
> 
> Not exactly. I assume you understand that rebooting 1000 live production
> servers to find the source of a rare bug or the cause of a performance
> issue is out of question.
> 
> Moreover, strategies like enabling flight recorder traces on a few nodes
> on demand to detect performance problems can only be deployed in
> production environment if they are part of the standard production
> kernel.
> 
> Also, managing two different kernels is often out of question. Not only
> is it a maintainance burden, but just switching to the "debug" kernel
> can impact the system's behavior so badly that it could make the problem
> disappear.

As can turning tracing on at runtime.

And you can always define requirements in a way that your solution is 
the only one...

Let's go to a different point:

Your paper says "When not running, must have zero effective impact."

How big is the measured impact of your markers when not used without any 
immediate voodoo?

You have sent many numbers about micro-benchmarks and theoretical 
numbers, but if you have sent the interesting numbers comparing
1. MARKERS=n
2. MARKERS=y, IMMEDIATE=n
3. MARKERS=y, IMMEDIATE=y
in actual benchmark testing I must have missed it.

Does 3. have a measurable and effective advantage over 2. or are you 
optimizing for some 0.01% or 1% performance difference without any
effective impact and therefore not requred for the goals outlined in 
your paper?

> Mathieu

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

