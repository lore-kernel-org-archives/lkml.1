Return-Path: <linux-kernel-owner+w=401wt.eu-S1752343AbZCNMZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbZCNMZZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 08:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751224AbZCNMZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 08:25:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48715 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028AbZCNMZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 08:25:08 -0400
Date: Sat, 14 Mar 2009 13:24:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>, Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 02/11] x86 architecture implementation of Hardware
	Breakpoint interfaces
Message-ID: <20090314122434.GA14521@elte.hu>
References: <20090313190113.GA15614@in.ibm.com> <Pine.LNX.4.44L0.0903131702280.5149-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0903131702280.5149-100000@iolanthe.rowland.org>
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

> On Sat, 14 Mar 2009, K.Prasad wrote:
> 
> > Here's a summary of the intended changes to the patchset, which I hope
> > to post early the following week. It tears down many features in the
> > present submission (The write-up below is done without the benefit of
> > actually having run into limitations while trying to chisel out code).
> > 
> > - Adopt a static allocation method for registers, say FCFS (and perhaps
> >   botton-up for user-space allocations and the reverse for
> >   kernel-space), although individual counters to do book-keeping should also
> >   suffice.
> 
> You can't enforce bottom-up allocation for userspace breakpoint
> requests. [...]

That's not the point.

The point is to offer a reasonable and simple static allocator 
that will work fine with usual gdb usage. If something takes 
away db4 that's as if user-space took away all registers - tough 
luck.

You are trying to put complexity into a situation that is not 
schedulable hence not resolvable _anyway_. There's just 4 debug 
registers, not more. If the combined usage goes above four 
someone will lose anyway - even with your allocator.

With my proposal the 'loss' can indeed come sooner if user-space 
took db4 and there's nothing left for the kernel anymore - but 
that's just an uninteresting special case that wont occur with 
typical debug-register usage.

If it ever causes problems seriously _then_ will be the time to 
consider "is it worth adding a more complex, dynamic allocator 
for debug registers". Not now. This stuff is currently 
over-designed and not acceptable to me in its current form.

	Ingo
