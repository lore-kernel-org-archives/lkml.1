Return-Path: <linux-kernel-owner+w=401wt.eu-S932213AbXGKAg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213AbXGKAg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 20:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758324AbXGKAgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 20:36:50 -0400
Received: from waste.org ([66.93.16.53]:46791 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607AbXGKAgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 20:36:49 -0400
Date: Tue, 10 Jul 2007 19:36:12 -0500
From: Matt Mackall <mpm@selenic.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Thread Migration Preemption
Message-ID: <20070711003611.GY11115@waste.org>
References: <20070705215152.GA4865@Krystal> <468DDD3A.6010308@yahoo.com.au> <20070710233938.GT11166@waste.org> <46941E0F.3040209@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46941E0F.3040209@yahoo.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2007 at 10:02:23AM +1000, Nick Piggin wrote:
> >I like this patch a lot. Even if we don't add the underlying mechanism
> >right now, adding migration_disable as an alias for preempt_disable
> >will much better document quite a number of the users.
> 
> I'd have no problem with that, and it might make it easier in future to
> justify a more complex scheme.

What do you think, Mathieu?

Also, small nit: it ought to be migrate_disable to match the form of
preempt_disable.
 
> >>The task struct is not something we should just be carefree putting crap
> >>into because it is seemingly free :(
> >
> >Sadly, it is free at the moment. We can only fit 3 task_structs in an 
> >order-1 SLAB,
> >with lots of slop.
> 
> Well apart from more cacheline access, that's why I say seemingly free. But
> actually it uses up space we may like for something else in future and/or
> makes it harder to shrink down if any effort ever goes into that.

Yes, I'm just trying to draw the sad state of task_struct to people's
attention.

-- 
Mathematics is the supreme nostalgia of our time.
