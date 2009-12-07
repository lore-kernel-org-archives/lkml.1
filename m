Return-Path: <linux-kernel-owner+w=401wt.eu-S965041AbZLGVJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965041AbZLGVJk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 16:09:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935590AbZLGVJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 16:09:39 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:35461 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935561AbZLGVJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 16:09:38 -0500
Date: Mon, 7 Dec 2009 22:09:43 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Steven Rostedt <rostedt@goodmis.org>, werner <w.landgraf@ru.ru>,
       linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "David S. Miller" <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: kernel problem
Message-ID: <20091207210943.GH8742@kernel.dk>
References: <web-100877149@zbackend1.aha.ru> <20091204154109.GB1716@goodmis.org> <20091207145011.GA14743@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091207145011.GA14743@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07 2009, Mel Gorman wrote:
> On Fri, Dec 04, 2009 at 10:41:09AM -0500, Steven Rostedt wrote:
> > [ Added Cc's of people that may be interested in this ]
> > > <SNIP>
> > > ------------[ cut here ]------------
> > > WARNING: at mm/page_alloc.c:1805
> > > __alloc_pages_nodemask+0x127/0x48f()
> > > Hardware name: System Product Name
> > > Modules linked in:
> > > Pid: 1, comm: swapper Not tainted 2.6.32-rc8-git5 #1
> > > Call Trace:
> > >  [<c103d94b>] warn_slowpath_common+0x65/0x95
> > >  [<c103d98d>] warn_slowpath_null+0x12/0x15
> > >  [<c109550c>] __alloc_pages_nodemask+0x127/0x48f
> > >  [<c10be964>] ? get_slab+0x8/0x50
> > >  [<c10b8979>] alloc_page_interleave+0x2e/0x6e
> > >  [<c10b8a10>] alloc_pages_current+0x57/0x99
> > >  [<c2083a4a>] ? xd_init+0x0/0x482
> > >  [<c1094c38>] __get_free_pages+0xd/0x1e
> > >  [<c2083a94>] xd_init+0x4a/0x482
> > >  [<c2082df0>] ? loop_init+0x104/0x16a
> > >  [<c169162d>] ? loop_probe+0x0/0xaf
> > >  [<c2083a4a>] ? xd_init+0x0/0x482
> > >  [<c1001143>] do_one_initcall+0x51/0x13f
> > >  [<c204a307>] kernel_init+0x10b/0x15f
> > >  [<c204a1fc>] ? kernel_init+0x0/0x15f
> > >  [<c1004347>] kernel_thread_helper+0x7/0x10
> > > ---[ end trace 686db6333ade6e7a ]---
> > > xd: Out of memory.
> 
> First off, it would appear that every block driver under the sun is
> being loaded. I seriously doubt this controller really exists in the
> machine.
> 
> Second, it's a real warning as the driver is trying to allocate a buffer of
> size 0 which get_order() chokes on. For bonus points, it tries to allocate
> a buffer before it knows what size it should be. This patch should resolve
> the problem but because I don't have the hardware to test it on, it could
> do with a second set of eyes just to be sure the rejigged logic makes sense.
> 
> If this is ok, what is the appropriate submission path for unmaintained
> block drivers? Is it the block maintainer or someone else?

Thanks Mel, I'll add this to the next pull queue.

-- 
Jens Axboe

