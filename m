Return-Path: <linux-kernel-owner+w=401wt.eu-S1755675AbZCMONy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675AbZCMONy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 10:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbZCMONp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 10:13:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53692 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852AbZCMONo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 10:13:44 -0400
Date: Fri, 13 Mar 2009 15:13:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Roland McGrath <roland@redhat.com>, prasad@linux.vnet.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 02/11] x86 architecture implementation of Hardware
	Breakpoint interfaces
Message-ID: <20090313141304.GB12591@elte.hu>
References: <20090313034301.GE11355@elte.hu> <Pine.LNX.4.44L0.0903130959400.2898-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0903130959400.2898-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Alan Stern <stern@rowland.harvard.edu> wrote:

> On Fri, 13 Mar 2009, Ingo Molnar wrote:
> 
> > The core issue being discussed is the debug register 
> > allocation and scheduling model though, and you have not 
> > directly commented on that.
> > 
> > My argument in a nutshell is that a bottom-up for user + 
> > top-down for kernel use static allocator with no dynamic 
> > scheduling will get us most of the benefits with a tenth of 
> > the complexity.
> 
> Take this even farther: We shouldn't restrict userspace to 
> bottom-up register allocation.  With very little additional 
> effort we can virtualize the debug registers; then userspace 
> can allocate them in whatever order it wants and still end up 
> using the physical registers in bottom-up order (or top-down, 
> which is the order used by the current patches).
> 
> After all, there's nothing to prevent programs other than gdb 
> from using ptrace, and there's no guarantee that gdb will 
> continue to allocate registers in increasing order.

If in ~10 years of its existence no such usage arose so i dont 
think it will magically appear now.

The thing is, kernel-side use of debug registers is a borderline 
item whose impact we should minimalize as much as possible. 
Linus in the past expressed that it is fine to not have _any_ 
management of user versus kernel debug registers. So we want to 
approach this from the minimalistic side. I offered such a very 
minimal design that is trivial in terms of correctness and 
impact.

We can still get this simple allocation model into .30 if we 
dont waste time arguing about unnecessarily. If someone runs 
into limitations the model can be extended.

	Ingo
