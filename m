Return-Path: <linux-kernel-owner+w=401wt.eu-S1756233AbYLIXBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233AbYLIXBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 18:01:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755945AbYLIXAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 18:00:34 -0500
Received: from ozlabs.org ([203.10.76.45]:37852 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755934AbYLIXAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 18:00:32 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18750.63619.54374.976070@cargo.ozlabs.ibm.com>
Date: Wed, 10 Dec 2008 10:00:19 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [patch] Performance Counters for Linux, v2
In-Reply-To: <20081209130045.GA32479@elte.hu>
References: <20081208012211.GA23106@elte.hu>
	<18748.37739.383961.318233@drongo.ozlabs.ibm.com>
	<20081208113318.GA14723@elte.hu>
	<18749.39345.732524.905159@cargo.ozlabs.ibm.com>
	<20081209130045.GA32479@elte.hu>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> * Paul Mackerras <paulus@samba.org> wrote:
> 
> > > Things like: "kerneltop would not be as accurate with: ..., to the 
> > > level of adding 5% of extra noise.". Would that work for you?
> > 
> > OK, here's an example.  I have an application whose execution has 
> > several different phases, and I want to measure the L1 Icache hit rate 
> > and the L1 Dcache hit rate as a function of time and make a graph.  So 
> > I need counters for L1 Icache accesses, L1 Icache misses, L1 Dcache 
> > accesses, and L1 Dcache misses.  I want to sample at 1ms intervals. The 
> > CPU I'm running on has two counters.
> > 
> > With your current proposal, I don't see any way to make sure that the 
> > counter scheduler counts L1 Dcache accesses and L1 Dcache misses at the 
> > same time, then schedules L1 Icache accesses and L1 Icache misses.  I 
> > could end up with L1 Dcache accesses and L1 Icache accesses, then L1 
> > Dcache misses and L1 Icache misses - and get a nonsensical situation 
> > like the misses being greater than the accesses.
> 
> yes, agreed, this is a valid special case of simple counter readout - 
> we'll add support to couple counters like that.

This is an example of a sampling problem, but one where the thing
being sampled is a derived statistic from two counter values.

I don't agree that this is really a "special case".  There are lots of
derived statistics that are interesting for performance analysis,
starting with CPI (cycles per instruction), proportions of various
instructions in the code, cache hit/miss rates for various different
caches, etc., etc.

> Note that this issue does not impact use of multiple counters in 
> profilers. (i.e. anything that is not a pure readout of the counter, 
> along linear time, as your example above suggests).

Well, that's the sampling vs. counting distinction that I made in my
other email.  We need to do both well.

As far as I can see, my "counter set" proposal does everything yours
does (since a counter set can be just a single counter), and also
cleanly accommodates what's needed for counting and for sampling
derived statistics.  No?

Paul.
