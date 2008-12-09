Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbYLINBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbYLINBU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 08:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914AbYLINBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 08:01:08 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36610 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894AbYLINBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 08:01:07 -0500
Date: Tue, 9 Dec 2008 14:00:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
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
Message-ID: <20081209130045.GA32479@elte.hu>
References: <20081208012211.GA23106@elte.hu> <18748.37739.383961.318233@drongo.ozlabs.ibm.com> <20081208113318.GA14723@elte.hu> <18749.39345.732524.905159@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18749.39345.732524.905159@cargo.ozlabs.ibm.com>
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


* Paul Mackerras <paulus@samba.org> wrote:

> > Things like: "kerneltop would not be as accurate with: ..., to the 
> > level of adding 5% of extra noise.". Would that work for you?
> 
> OK, here's an example.  I have an application whose execution has 
> several different phases, and I want to measure the L1 Icache hit rate 
> and the L1 Dcache hit rate as a function of time and make a graph.  So 
> I need counters for L1 Icache accesses, L1 Icache misses, L1 Dcache 
> accesses, and L1 Dcache misses.  I want to sample at 1ms intervals. The 
> CPU I'm running on has two counters.
> 
> With your current proposal, I don't see any way to make sure that the 
> counter scheduler counts L1 Dcache accesses and L1 Dcache misses at the 
> same time, then schedules L1 Icache accesses and L1 Icache misses.  I 
> could end up with L1 Dcache accesses and L1 Icache accesses, then L1 
> Dcache misses and L1 Icache misses - and get a nonsensical situation 
> like the misses being greater than the accesses.

yes, agreed, this is a valid special case of simple counter readout - 
we'll add support to couple counters like that.

Note that this issue does not impact use of multiple counters in 
profilers. (i.e. anything that is not a pure readout of the counter, 
along linear time, as your example above suggests).

Once we start sampling the context, grouping of counters becomes 
irrelevant (and a hindrance) and static frequency sampling becomes an 
inferior method of sampling.

( The highest quality statistical approach is the kind of multi-counter
  sampling model you can see implemented in KernelTop for example, where
  the counters are independently sampled. Can go on in great detail about
  this if you are interested - this is the far more interesting usecase
  in practice. )

	Ingo
