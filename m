Return-Path: <linux-kernel-owner+w=401wt.eu-S1754078AbYE1L6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbYE1L6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 07:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbYE1L6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 07:58:18 -0400
Received: from brick.kernel.dk ([87.55.233.238]:22833 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbYE1L6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 07:58:17 -0400
Date: Wed, 28 May 2008 13:58:15 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Fabio Checconi <fchecconi@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, torvalds@osdl.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.26-rc4: RIP __call_for_each_cic+0x20/0x50
Message-ID: <20080528115814.GT25504@kernel.dk>
References: <20080429090604.GK12774@kernel.dk> <20080430221250.GA10150@martell.zuzino.mipt.ru> <20080504190811.GP12774@kernel.dk> <20080504201542.GA1040@martell.zuzino.mipt.ru> <20080510103719.GA4967@martell.zuzino.mipt.ru> <20080527052740.GB28301@martell.zuzino.mipt.ru> <20080527133510.GV7712@kernel.dk> <20080527151809.GA14296@linux.vnet.ibm.com> <20080528100721.GQ25504@kernel.dk> <20080528115238.GB1283@gandalf.sssup.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080528115238.GB1283@gandalf.sssup.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28 2008, Fabio Checconi wrote:
> > From: Jens Axboe <jens.axboe@oracle.com>
> > Date: Wed, May 28, 2008 12:07:21PM +0200
> >
> > On Tue, May 27 2008, Paul E. McKenney wrote:
> > > o	When calling cfq_slab_kill(), for example from cfq_exit(),
> > > 	what ensures that all previous RCU callbacks have completed?
> > > 	
> > > 	I suspect that you need an rcu_barrier() at the beginning
> > > 	of cfq_slab_kill(), but I could be missing something.
> > 
> > So we have two callers of that, one is from the error path at init time
> > and is obviously ok. The other does need rcu_barrier()! I'll add that.
> > 
> 
> But isn't the ioc_gone completion (notified only when there are no more
> cic allocated) assuring that cfq_slab_kill() is called only after all
> the rcu callbacks are completed?  This should avoid the need for the
> rcu_barrier().

Good point, I was thinking we decremented the mod count on call_rcu(),
but we don't actually do it before the rcu callback has completed. So
that part is actually OK already.

-- 
Jens Axboe

