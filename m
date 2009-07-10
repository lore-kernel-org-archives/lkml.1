Return-Path: <linux-kernel-owner+w=401wt.eu-S1754210AbZGJJTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbZGJJTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 05:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267AbZGJJTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 05:19:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:50015 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540AbZGJJTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 05:19:04 -0400
Date: Fri, 10 Jul 2009 11:19:03 +0200
From: Nick Piggin <npiggin@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Janboe Ye <yuan-bo.ye@motorola.com>, linux-kernel@vger.kernel.org,
       vegard.nossum@gmail.com, graydon@redhat.com, fche@redhat.com
Subject: Re: [RFC][PATCH] Check write to slab memory which freed already using mudflap
Message-ID: <20090710091903.GE14666@wotan.suse.de>
References: <1247156020.27671.40.camel@debian-nb> <84144f020907090944u51f60cbsc0a4ec2c2cbdcc8c@mail.gmail.com> <20090710084745.GA26752@elte.hu> <alpine.DEB.2.00.0907100158090.13880@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0907100158090.13880@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 10, 2009 at 02:04:53AM -0700, David Rientjes wrote:
> On Fri, 10 Jul 2009, Ingo Molnar wrote:
> 
> > > SLAB is (slowly) going away so you might want to port this to SLUB 
> > > as well so we can merge both.
> > 
> > and SLQB which will replace both? :-/
> > 
> 
> I'm not sure what the status of slqb is, although I would have expected it 
> to have been pushed for inclusion in 2.6.31 as a slab allocator 
> alternative.  Nick, any forecast for inclusion?

Just had a hiccup with testing in the last cycle, so we decided
not to merge it this time. I hope next window.


> SLUB has a pretty noticeable performance degradation on benchmarks such as 
> netperf TCP_RR with high numbers of threads (see my post about it: 
> http://marc.info/?l=linux-kernel&m=123839191416472).  CONFIG_SLAB is the 
> optimal configuration for workloads that share similiar slab thrashing 
> patterns (which my patchset dealt with in an indirect way and yet still 
> didn't match slab's performance).  I haven't yet seen data that suggests 
> anything other than CONFIG_SLAB has parity with such a benchmark.

I did do various netperf runs, but I can't remember whether I tried
to reproduce your test case with SLQB.  I'll try ;)

I don't think there are any known performance regressions for SLQB
versus others, but OTOH I don't think it has been widely performance
tested (I don't think many people performance test -next).

