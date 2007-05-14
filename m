Return-Path: <linux-kernel-owner+w=401wt.eu-S1758569AbXENVsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569AbXENVsm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 17:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754605AbXENVsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 17:48:36 -0400
Received: from mail.screens.ru ([213.234.233.54]:56658 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754588AbXENVsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 17:48:35 -0400
Date: Tue, 15 May 2007 01:48:33 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Alex Dubov <oakad@yahoo.com>, Pierre Ossman <drzeus@drzeus.cx>,
       Pavel Machek <pavel@ucw.cz>, Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: Freezeable workqueues [Was: 2.6.22-rc1: Broken suspend on SMP with tifm]
Message-ID: <20070514214833.GA249@tv-sign.ru>
References: <200705132132.08546.rjw@sisk.pl> <200705140757.33746.rjw@sisk.pl> <20070514165429.GA83@tv-sign.ru> <200705142327.37021.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705142327.37021.rjw@sisk.pl>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14, Rafael J. Wysocki wrote:
>
> On Monday, 14 May 2007 18:55, Oleg Nesterov wrote:
> > 
> > Rafael, I am afraid we are making too much noise, and this may confuse Alex
> > and Andrew.
> > 
> > First, we should decide how to fix the bug we have in 2.6.22. I prefer a simple
> > "make freezeable workqueues singlethread" I sent. It was acked by Alex, it is
> > simple, and it is also good because tifm doesn't need multithreaded wq anyway.
> 
> Yes, I've already agreed with that.

Ah, OK, I misunderstood your message as if you propose this fix for 2.6.22.

> > 	- Do we need freezeable workqueues ?
> 
> Well, we have at least one case in which they appear to be useful.

So, in the long term, should we change this only user, or we think we better fix
freezeable wqs again?

> > WORK2->func() completes.
> > 
> > freezer comes. cwq->thread notices TIF_FREEZE and goes to refrigerator before
> > executing that barrier.

This is not possible. cwq->thread _must_ notice the barrier before it goes to
refrigerator.

So, given that we have cpu_populated_map we can re-introduce take_over_work()
along with migrate_sequence and thus we can fix freezeable multithreaded wqs.

> > If we have take_over_work() we should use it for any workqueue,
> > freezeable or not. Otherwise this is just a mess, imho.

Still, this is imho true. So we'd better do some other changes to be consistent.

-------------------------------------------------------------------------------
> Yeah, I need to learn more.

No. I should read the patches more carefully before complain.

> Sorry for the confusion I made.

Rafael, it is me who have to apologize.
-------------------------------------------------------------------------------

Oleg.

