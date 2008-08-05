Return-Path: <linux-kernel-owner+w=401wt.eu-S1761716AbYHERfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761716AbYHERfB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 13:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760266AbYHERew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 13:34:52 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:58249 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759507AbYHERev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 13:34:51 -0400
Date: Tue, 5 Aug 2008 10:34:47 -0700
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@elte.hu, tony.luck@intel.com, linux-ia64@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Bill Gatliff <bgat@billgatliff.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [BISECTION RESULT] sched: revert cpu_clock to
	pre-27ec4407790d075c325e1f4da0a19c56953cce23 state
Message-ID: <20080805173447.GD7812@us.ibm.com>
References: <20080804194646.GA17390@us.ibm.com> <1217926585.3589.113.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217926585.3589.113.camel@twins>
X-Operating-System: Linux 2.6.26-rc9-00132-g9df2fe9 (x86_64)
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.08.2008 [10:56:25 +0200], Peter Zijlstra wrote:
> On Mon, 2008-08-04 at 12:46 -0700, Nishanth Aravamudan wrote:
> > Bisection on an x455 (2-node IA64) showed that commit
> > 27ec4407790d075c325e1f4da0a19c56953cce23 (sched: make cpu_clock()
> > globally synchronous) broke booting. I see the uncompressing initramfs
> > message and then nothing on the console. I wait about 5 minutes (which
> > is way longer than it takes for the first console messages to get
> > printed normally). The commit immediately before it works fine.
> > 
> > The commit no longer cleanly reverts, but I tried to manually put things
> > back to the way they were before in cpu_clock(). The resulting kernel
> > boots fine. I could figure out a clean way to leave cpu_clock() in
> > sched_clock.c because of all the rq dependencies from sched.c. The
> > attempt I tested is below [1]. This patch is *NOT* for inclusion, just
> > to demonstrate what I tested.
> > 
> > I'm happy to test any better patches.
> 
> Does this work for you?
> 
> ---
> Subject: sched_clock: delay using sched_clock()
> 
> Some arch's can't handle sched_clock() being called too early - delay
> this until sched_clock_init() has been called.
> 
> Reported-by: Bill Gatliff <bgat@billgatliff.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> CC: Russell King - ARM Linux <linux@arm.linux.org.uk>

Yep, this fixes things on the box, as well.

Tested-by: Nishanth Aravamudan <nacc@us.ibm.com>

Thanks,
Nish

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center
