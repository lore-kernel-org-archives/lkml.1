Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbXJBJBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbXJBJBY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 05:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbXJBJBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 05:01:16 -0400
Received: from mx2.go2.pl ([193.17.41.42]:53717 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752243AbXJBJBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 05:01:16 -0400
Date: Tue, 2 Oct 2007 11:03:46 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       David Schwartz <davids@webmaster.com>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Martin Michlmayr <tbm@cyrius.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: Network slowdown due to CFS
Message-ID: <20071002090346.GA1738@ff.dom.local>
References: <20070926133138.GA23187@elte.hu> <20070927133123.GA6901@elte.hu> <20070927144228.GC2431@ff.dom.local> <200709281610.00682.nickpiggin@yahoo.com.au> <20071001084356.GA1866@ff.dom.local> <20071001162507.GA22791@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071001162507.GA22791@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2007 at 06:25:07PM +0200, Ingo Molnar wrote:
> 
> * Jarek Poplawski <jarkao2@o2.pl> wrote:
> 
> > BTW, it looks like risky to criticise sched_yield too much: some 
> > people can misinterpret such discussions and stop using this at all, 
> > even where it's right.
> 
> Really, i have never seen a _single_ mainstream app where the use of 
> sched_yield() was the right choice.
> 
> Fortunately, the sched_yield() API is already one of the most rarely 
> used scheduler functionalities, so it does not really matter. [ In my 
> experience a Linux scheduler is stabilizing pretty well when the 
> discussion shifts to yield behavior, because that shows that everything 
> else is pretty much fine ;-) ]
> 
> But, because you assert it that it's risky to "criticise sched_yield() 
> too much", you sure must know at least one real example where it's right 
> to use it (and cite the line and code where it's used, with 
> specificity)?

Very clever move! And I see some people have catched this...

Since sched_yeld() is a very general purpose tool, it can be easily
replaced by others, of course, just like probably half of all
system calls. And such things are done often in a code during
optimization. But, IMHO, the main value of sched_yield() is it's
easy to use and very readable way to mark some place. Sometimes
even test if such idea is reasonable at all... Otherwise, many such
possibilities could easily stay forgotten forever.

But you are right, the value of this call shouldn't be exaggerated,
and my proposal was an overkill. Anyway, it seems, there could be
imagined something better than current ways of doing this. They look
like two extremes and something in between and not too complicated
should suffice. Currently, I wonder if simply charging (with a key
recalculated) such a task for all the time it could've used isn't one
of such methods. It seems, it's functionally analogous with going to
the end of que of tasks with the same priority according to the old
sched.

Regards,
Jarek P.
