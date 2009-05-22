Return-Path: <linux-kernel-owner+w=401wt.eu-S1757227AbZEVJ4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227AbZEVJ4r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 05:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753924AbZEVJ4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 05:56:25 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:33101 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066AbZEVJ4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 05:56:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18966.30400.611789.434936@cargo.ozlabs.ibm.com>
Date: Fri, 22 May 2009 19:56:16 +1000
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] perf_counter: optimize context switch between
 identical inherited contexts
In-Reply-To: <1242980169.26820.617.camel@twins>
References: <18966.10075.781053.231153@cargo.ozlabs.ibm.com>
	<18966.10666.517218.332164@cargo.ozlabs.ibm.com>
	<1242980169.26820.617.camel@twins>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> On Fri, 2009-05-22 at 14:27 +1000, Paul Mackerras wrote:
> > Since we don't have individual fds for the counters in a cloned
> > context, the only thing that can make two clones of a given parent
> > different after they have been cloned is enabling or disabling all
> > counters with prctl.  To account for this, we keep a count of the
> > number of enabled counters in each context.  Two contexts must have
> > the same number of enabled counters to be considered equivalent.
> 
> Curious point that.. so prctl() can disable counters it doesn't own.
> 
> Shouldn't we instead fix that?

Well, prctl enables/disables the counters that are counting on the
current process, regardless of who or what created them.  I always
thought that was a little strange; maybe it is useful to be able to
disable all the counters that any other process might have put on to
you, but I can't think of a scenario where you'd really need to do
that, particularly since the disable is a one-shot operation, and
doesn't prevent new (enabled) counters being attached to you.

On the other hand, what does "all the counters I own" mean?  Does it
mean all the ones that I have fds open for?  Or does it mean all the
ones that I created?  Either way we don't have a good way to enumerate
them.

Paul.
