Return-Path: <linux-kernel-owner+w=401wt.eu-S1758422AbZGCSyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758422AbZGCSyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 14:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756264AbZGCSyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 14:54:12 -0400
Received: from brick.kernel.dk ([93.163.65.50]:47301 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755842AbZGCSyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 14:54:11 -0400
Date: Fri, 3 Jul 2009 20:54:14 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       "Styner, Douglas W" <douglas.w.styner@intel.com>,
       Chinang Ma <chinang.ma@intel.com>,
       "Prickett, Terry O" <terry.o.prickett@intel.com>,
       Matthew Wilcox <matthew.r.wilcox@intel.com>, Eric.Moore@lsi.com,
       DL-MPTFusionLinux@lsi.com
Subject: Re: >10% performance degradation since 2.6.18
Message-ID: <20090703185414.GP23611@kernel.dk>
References: <20090703025607.GK5480@parisc-linux.org> <87skhdaaub.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87skhdaaub.fsf@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 03 2009, Andi Kleen wrote:
> 
> Matthew Wilcox <matthew@wil.cx> writes:
> >
> > ======oprofile CPU_CLK_UNHALTED for top 30 functions
> > Cycles% 2.6.18-92.el5-op           Cycles% 2.6.30
> > 70.1409 <database>                 67.0207 <database>
> > 1.3556 mpt_interrupt               1.7029 mpt_interrupt
> 
> It's strange that mpt_interrupt is that more costly in 2.6.30
> than in 2.6.18. I diffed 2.6.30's drivers/message/fusion/mptbase.c
> to a rhel 5.3s and they seem to be about the same. 
> 
> So why does it cost 0.5% more in 2.6.30?
> 
> [adding MPT maintainers]

Look at the irqs/sec rate, it's higher by about the same percentage. So
it's likely not a more costly irq handler, it's likely just called that
much more. It could be IO pattern, causing more commands to be issued
(which leads to more interrupts, etc).

> > 1.1622 __blockdev_direct_IO        1.1443 kmem_cache_alloc
> 
> It would be interesting to find out why kmem_cache_alloc
> is that more expensive. Either it is called more or the allocator
> is slower. Any chance of a callgraph profile run so we
> can see the callers?

Could be more IO as well, that hits the allocate often.

I agree with some callgraph data, that would at least eliminate the
guessing here. And some detailed IO statistics, amount of data
transferred as well as iostat info to see if the pattern is
significantly worse.

-- 
Jens Axboe

