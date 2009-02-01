Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbZBAKEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbZBAKEg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 05:04:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbZBAKE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 05:04:27 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39595 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752618AbZBAKE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 05:04:26 -0500
Date: Sun, 1 Feb 2009 11:04:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lin Ming <ming.m.lin@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: hackbench [pthread mode] regression with 2.6.29-rc3
Message-ID: <20090201100410.GA22903@elte.hu>
References: <1233473426.2604.13.camel@ymzhang> <d3f22a0902010026q1db36381j36cb1c9803d48431@mail.gmail.com> <1233476961.13659.12.camel@minggr.sh.intel.com> <1233479836.4787.63.camel@laptop> <1233482239.4787.65.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233482239.4787.65.camel@laptop>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Sun, 2009-02-01 at 10:17 +0100, Peter Zijlstra wrote:
> > On Sun, 2009-02-01 at 16:29 +0800, Lin Ming wrote:
> > > > Bisect located below patch.
> > > > commit 490dea45d00f01847ebebd007685d564aaf2cd98
> > > > Author: Peter Zijlstra <peterz@infradead.org>
> > > > Date:   Mon Nov 24 17:06:57 2008 +0100
> > > > 
> > > >    itimers: remove the per-cpu-ish-ness
> > > > 
> > > >    Either we bounce once cacheline per cpu per tick, yielding n^2 bounces
> > > >    or we just bounce a single..
> > > > 
> > > >    Also, using per-cpu allocations for the thread-groups complicates the
> > > >    per-cpu allocator in that its currently aimed to be a fixed sized
> > > >    allocator and the only possible extention to that would be vmap based,
> > > >    which is seriously constrained on 32 bit archs.
> > > > 
> > > > 
> > > > After above patch is reverted, hackbench result is restored.
> > > 
> > > oltp has ~3% regression with 2.6.29-rc3 on 4core*2p stokley machine.
> > > After above patch reverted, the regression disappeared.
> > 
> > *sigh*, did they gain anything with introduction of the per-cpu crap?
> 
> No it wouldn't have, I just missed something obvious,.. :-(
> 
> I wish we never merged that crap...

oh, it certainly had its use: it highlighted that we have crappy 
threading+timers code (on hackbench_pth) since the beginning of the Linux 
SMP times.

	Ingo
