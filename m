Return-Path: <linux-kernel-owner+w=401wt.eu-S1758315AbZFLMMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758315AbZFLMMV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 08:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbZFLMMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:12:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54665 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708AbZFLMMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:12:13 -0400
Date: Fri, 12 Jun 2009 14:12:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] perf_counter: powerpc: Implement generalized cache
	events for POWER processors
Message-ID: <20090612121206.GB31845@elte.hu>
References: <18992.36329.189378.17992@drongo.ozlabs.ibm.com> <18992.36430.933526.742969@drongo.ozlabs.ibm.com> <20090611100720.GC12703@elte.hu> <18993.58058.194954.997480@drongo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18993.58058.194954.997480@drongo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Paul Mackerras <paulus@samba.org> wrote:

> > I dont know whether we should do such combo counters in the 
> > kernel itself - i'm slightly against that notion. (seems 
> > complex)
> 
> Yeah.
> 
> When thinking about having "composite" events, i.e. a counter 
> whose value is computed from two or more hardware counters, I 
> couldn't see how to do sampling in the general case.  It's easy if 
> we're just adding multiple counters, but sampling when subtracting 
> counters is hard.  For example, if you want to sample every N 
> cache hits, and you're computing hits as accesses - misses, I 
> couldn't see a decent way to know when to take the sample, not 
> without having to take an interrupt on every access in some 
> circumstances.

We now have a period field - and that could be negative and be 
subtracted by the profiler automatically.

It's still statistical and a given instruction can go 'negative' 
sporadically, but in terms of total function averages and for any 
high-traffic place it's still pretty expressive IMO.

	Ingo
