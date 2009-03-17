Return-Path: <linux-kernel-owner+w=401wt.eu-S1763005AbZCQJYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763005AbZCQJYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 05:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753860AbZCQJYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 05:24:44 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:52963 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965AbZCQJYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 05:24:43 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18879.27734.627571.687251@cargo.ozlabs.ibm.com>
Date: Tue, 17 Mar 2009 20:24:38 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH/RFC 2/2] perfcounters: add an mmap method to allow
 userspace to read hardware counters
In-Reply-To: <1237279317.5189.150.camel@laptop>
References: <18879.14431.733358.248755@drongo.ozlabs.ibm.com>
	<1237275515.5189.71.camel@laptop>
	<18879.24309.827081.959346@cargo.ozlabs.ibm.com>
	<1237279317.5189.150.camel@laptop>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> Ah, right. I think some of the intel chips can do similar things with
> rdpmc instructions.

Ah OK, I didn't know that.  Cool.

> > Ingo has talked about reusing some of the tracing infrastructure for
> > reporting perf_counter events to userspace.  That sounds like an
> > excellent idea to me, and that is why I didn't bother with putting the
> > event queue into the mmapped page at this stage.  If it makes sense to
> > add it, it can be added later.
> 
> Yeah, I've been looking into that, but so far I'm a bit at a loss, all
> that tracing stuff is per-cpu, and that's massive overkill for us, since
> we're dealing with single cpu streams.

I almost certainly know less about the tracing infrastructure than
you. :)  Per-cpu buffers does indeed sound like overkill for what we
want - though we might actually want per-cpu buffers if we have
inherited sampling counters and a deep process hierarchy.

> One worry though, supposedly we want to mmap() such buffers too at some
> point, how would that interact with that you proposed?

I think we just have separate pages for the event ring buffer and the
info for reading the counter in userspace, and then there isn't any
interaction.  We can do that either by having two fds and mmapping on
each, or by using the file offset argument to mmap.

Paul.
