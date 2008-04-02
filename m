Return-Path: <linux-kernel-owner+w=401wt.eu-S1757295AbYDBQb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295AbYDBQb3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 12:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758132AbYDBQbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 12:31:21 -0400
Received: from brick.kernel.dk ([87.55.233.238]:2462 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757144AbYDBQbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 12:31:20 -0400
Date: Wed, 2 Apr 2008 18:31:14 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kmemcheck caught read from freed memory (cfq_free_io_context)
Message-ID: <20080402163113.GF12774@kernel.dk>
References: <1207133961.8514.768.camel@twins> <20080402113327.GC41073@gandalf.sssup.it> <20080402114338.GA12774@kernel.dk> <20080402123620.GH12774@kernel.dk> <20080402123639.GI12774@kernel.dk> <20080402125530.GF41073@gandalf.sssup.it> <20080402125819.GO12774@kernel.dk> <20080402133715.GA5327@linux.vnet.ibm.com> <20080402134123.GA12774@kernel.dk> <20080402153335.GA9333@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080402153335.GA9333@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02 2008, Paul E. McKenney wrote:
> On Wed, Apr 02, 2008 at 03:41:23PM +0200, Jens Axboe wrote:
> > On Wed, Apr 02 2008, Paul E. McKenney wrote:
> > > On Wed, Apr 02, 2008 at 02:58:19PM +0200, Jens Axboe wrote:
> > > > On Wed, Apr 02 2008, Fabio Checconi wrote:
> > > > > > From: Jens Axboe <jens.axboe@oracle.com>
> > > > > > Date: Wed, Apr 02, 2008 02:36:39PM +0200
> > > > > >
> > > > > > > Looks good and tests fine as well. I've applied it, on top of the
> > > > > > > hlist_for_each_entry_safe_rcu() fix.
> > > > > > > 
> > > > > > > http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=436151ad32b4a59e0d36165a7d6312545f126661
> > > > > > > 
> > > > > 
> > > > > ok, thanks.  anyway I don't think the hlist_for_each_entry_safe_rcu()
> > > > > is needed at this point, since the pos->next pointer is still valid
> > > > > (at least) until the next rcu_read_unlock().  am I wrong?
> > > > 
> > > > it isn't, but it's still clearer. so either that or a nice comment, I
> > > > just stuck with what I had already committed.
> > > 
> > > Given Peter's comment, would you be willing to drop the
> > > hlist_for_each_entry_safe_rcu()?  People tend to read too much into
> > > the "safe" sometimes.  ;-)
> > 
> > Sure, let me rebase it... I already sent a pull request to Linus, and he
> > just loves when I rebase and change the diffstats behind his back :)
> 
> Would it help if I submitted the patch to you to back it out later?  ;-)

Hehe, I already wrote to Linus and explained why it changed, so what is
done is done :)

-- 
Jens Axboe

