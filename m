Return-Path: <linux-kernel-owner+w=401wt.eu-S1754837AbZGEMHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbZGEMHX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 08:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753979AbZGEMHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 08:07:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:22479 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753749AbZGEMHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 08:07:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,351,1243839600"; 
   d="scan'208";a="161644024"
Date: Sun, 5 Jul 2009 20:07:00 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 2/5] add buffer cache information to show_free_areas()
Message-ID: <20090705120659.GA5252@localhost>
References: <20090705182337.08F9.A69D9226@jp.fujitsu.com> <20090705112159.GB1898@localhost> <20090705202503.0914.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090705202503.0914.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 05, 2009 at 07:31:02PM +0800, KOSAKI Motohiro wrote:
> > On Sun, Jul 05, 2009 at 05:24:07PM +0800, KOSAKI Motohiro wrote:
> > > Subject: [PATCH] add buffer cache information to show_free_areas()
> > > 
> > > When administrator analysis memory shortage reason from OOM log, They
> > > often need to know rest number of cache like pages.
> > 
> > nr_blockdev_pages() pages are also accounted in NR_FILE_PAGES.
> 
> Yes, I know.
> 
> > > Then, show_free_areas() shouldn't only display page cache, but also it
> > > should display buffer cache.
> > 
> > So if we are to add this, I'd suggest to put it close to the total
> > pagecache line:
> > 
> >         printk("%ld total pagecache pages\n", global_page_state(NR_FILE_PAGES));
> > +       printk("%ld blkdev pagecache pages\n", nr_blockdev_pages());
> 
> but this is intensional. May I explain why I choose non verbose area?
> In typical workload, buffer-pages doesn't consume so many pages. then
> I feel that your idea is too verbose output. In addition, if buffer-pages are much,
> Administrator want to know other I/O related vmstat at the same time.
 
> > > +		" dirty:%lu writeback:%lu buffer:%lu unstable:%lu\n"

Now I see your point. It makes sense to put typically small numbers together.

Acked-by: Wu Fengguang <fengguang.wu@intel.com>

Thanks,
Fengguang

> > > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > > ---
> > >  mm/page_alloc.c |    3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > 
> > > Index: b/mm/page_alloc.c
> > > ===================================================================
> > > --- a/mm/page_alloc.c
> > > +++ b/mm/page_alloc.c
> > > @@ -2118,7 +2118,7 @@ void show_free_areas(void)
> > >  	printk("Active_anon:%lu active_file:%lu inactive_anon:%lu\n"
> > >  		" inactive_file:%lu"
> > >  		" unevictable:%lu"
> > > -		" dirty:%lu writeback:%lu unstable:%lu\n"
> > > +		" dirty:%lu writeback:%lu buffer:%lu unstable:%lu\n"
> > >  		" free:%lu slab_reclaimable:%lu slab_unreclaimable:%lu\n"
> > >  		" mapped:%lu pagetables:%lu bounce:%lu\n",
> > >  		global_page_state(NR_ACTIVE_ANON),
> > > @@ -2128,6 +2128,7 @@ void show_free_areas(void)
> > >  		global_page_state(NR_UNEVICTABLE),
> > >  		global_page_state(NR_FILE_DIRTY),
> > >  		global_page_state(NR_WRITEBACK),
> > > +		K(nr_blockdev_pages()),
> > >  		global_page_state(NR_UNSTABLE_NFS),
> > >  		global_page_state(NR_FREE_PAGES),
> > >  		global_page_state(NR_SLAB_RECLAIMABLE),
> > > 
> 
> 
