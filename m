Return-Path: <linux-kernel-owner+w=401wt.eu-S1754483AbXENMHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbXENMHu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 08:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbXENMHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 08:07:43 -0400
Received: from mail.suse.de ([195.135.220.2]:43957 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbXENMHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 08:07:43 -0400
Date: Mon, 14 May 2007 14:07:37 +0200
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Ingo Molnar <mingo@elte.hu>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/2] convert mmap_sem to a scalable rw_mutex
Message-ID: <20070514120737.GE31234@wotan.suse.de>
References: <20070511131541.992688403@chello.nl> <20070511155621.GA13150@elte.hu> <46449F61.2060004@cosmosbay.com> <1178903913.2781.20.camel@lappy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178903913.2781.20.camel@lappy>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2007 at 07:18:33PM +0200, Peter Zijlstra wrote:
> On Fri, 2007-05-11 at 18:52 +0200, Eric Dumazet wrote:
> > 
> > But I personally find this new rw_mutex not scalable at all if you have some 
> > writers around.
> > 
> > percpu_counter_sum is just a L1 cache eater, and O(NR_CPUS)
> 
> Yeah, that is true; there are two occurences, the one in
> rw_mutex_read_unlock() is not strictly needed for correctness.
> 
> Write locks are indeed quite expensive. But given the ratio of
> reader:writer locks on mmap_sem (I'm not all that familiar with other
> rwsem users) this trade-off seems workable.

I guess the problem with that logic is assuming the mmap_sem read side
always needs to be scalable. Given the ratio of threaded:unthreaded
apps, maybe the trade-off swings away from favour?

