Return-Path: <linux-kernel-owner+w=401wt.eu-S1754850AbXFVMgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbXFVMgB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 08:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbXFVMfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 08:35:53 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:55603 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbXFVMfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 08:35:52 -0400
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, kuznet@ms2.inr.ac.ru
In-Reply-To: <20070622070948.GA21291@infradead.org>
References: <20070622040014.234651401@goodmis.org>
	 <20070622070948.GA21291@infradead.org>
Content-Type: text/plain
Date: Fri, 22 Jun 2007 08:32:22 -0400
Message-Id: <1182515542.5493.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph,

Thanks for taking the time to look at my patches!


On Fri, 2007-06-22 at 08:09 +0100, Christoph Hellwig wrote:
> > I've developed this way to replace all tasklets with work queues without
> > having to change all the drivers that use them.  I created an API that
> > uses the tasklet API as a wrapper to a work queue.  This API doesn't need
> > to be permanent. It shows 1) that work queues can replace tasklets, and
> > 2) we can remove a duplicate functionality from the kernel.  This API
> > only needs to be around until we removed all uses of tasklets from
> > all drivers.
> 
> I don't like this wrapping at all.  What you're doing is a tradeoff to
> do less work today in exchange for more maintaince overhead and more crufty
> code in the future.  So while I sympathize a lot with trying to get rid
> of tasklets I'd rather prefer to convert individual drivers over until
> all users are gone.  It's not exactly a very complicated conversion either.
> 
> > 6) This is the magic to make tasklets into work queues. It allows for
> > the kernel to be configured either with the normal tasklets, as it is
> > today, or with the tasklets-as-work-queues.
> 
> And this is something that might be fine for benchmarking, but not something
> we should put in.  Keeping two wildly different implementation of core
> functionality with very different behaviour around is quite bad.  Better
> kill tasklets once for all.

Honestly, I highly doubted that this would make it up to Linus's tree.
My aim was to get this into -mm, and perhaps even turn on the
tasklets-as-workqueues as default.

The objective of these patches was more of a proof-of-concept, showing
that the tasklets are indeed obsolete today.  By putting this patch set
into -mm, we can get a good idea of the regressions that this conversion
would cause, hopefully before we did the real change of converting a
driver's tasklet into a work queue.

I only have a limited amount of hardware to test on. I believe this is a
good candidate as a permanent resident into -mm and can display the
effects of using work queues instead of tasklets in a wider arena.

This patch is too much of a kludge to put into Linus's tree, and if it
were in that tree, it would probably cause laziness and make it even
less likely that driver authors would get rid of their tasklets.  But I
argue it is perfect for the -mm tree, because it allows users to easily
(with a config option) turn it on and off and run benchmarks to see its
effect.


-- Steve

