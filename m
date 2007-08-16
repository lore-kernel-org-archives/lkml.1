Return-Path: <linux-kernel-owner+w=401wt.eu-S1765832AbXHPVf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765832AbXHPVf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 17:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754243AbXHPVfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 17:35:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:57217 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753657AbXHPVfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 17:35:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,273,1183359600"; 
   d="scan'208";a="282068667"
Date: Thu, 16 Aug 2007 14:28:25 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lmbench ctxsw regression with CFS
Message-ID: <20070816212825.GL10033@linux-os.sc.intel.com>
References: <20070802024132.GD15595@wotan.suse.de> <20070802071956.GA23300@elte.hu> <20070802073123.GB16744@wotan.suse.de> <20070802154447.GA13725@elte.hu> <20070803001447.GA14775@wotan.suse.de> <20070804065037.GA30816@elte.hu> <20070806032949.GA16401@wotan.suse.de> <20070813123031.GS23758@kernel.dk> <20070813200038.7fc8a9e6.akpm@linux-foundation.org> <20070814032259.GA2908@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070814032259.GA2908@wotan.suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2007 at 05:23:00AM +0200, Nick Piggin wrote:
> On Mon, Aug 13, 2007 at 08:00:38PM -0700, Andrew Morton wrote:
> > Put it this way: if a 50% slowdown in context switch times yields a 5%
> > improvement in, say, balancing decisions then it's probably a net win.
> > 
> > Guys, repeat after me: "context switch is not a fast path".  Take that
> > benchmark and set fire to it.
> 
> It definitely can be. For workloads that are inherently asynchronous, high
> speed networking or disk IO (ie. with event generation significantly outside
> the control of the kernel or app), then it can be. Sure, you may just be
> switching between the main working thread and idle thread, but in that case a
> slowdown in the scheduler will be _more_ pronounced because you don't have to
> do as much work to actually switch contexts.
> 
> If there was a performance tradeoff involved, then we could think about it,
> and you might be right. But this is just a case of "write code to do direct
> calls or do indirect calls".
> 
> Ken Chen's last ia64 database benchmark I could find says schedule takes
> 6.5% of the clock cycles, the second highest consumer. Considering the
> lengths he was going to shave cycles off other paths, I'd call schedule()
> a fastpath. Would be really interesting to rerun that benchmark with CFS.
> Is anyone at Intel still doing those tests?

Yes. schedule() still is in the top 2-3 consumers of kernel time for that
workload. We did some tests when CFS was in initial days (I think V2 or so)
and it didn't show any regression.

We have plans to run that workload with 2.6.23-rc kernels, but other things
were taking priority so far...

thanks,
suresh
