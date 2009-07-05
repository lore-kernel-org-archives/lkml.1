Return-Path: <linux-kernel-owner+w=401wt.eu-S1756154AbZGELbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbZGELbR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 07:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbZGELbC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 07:31:02 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46163 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbZGELbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 07:31:01 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 2/5] add buffer cache information to show_free_areas()
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>
In-Reply-To: <20090705112159.GB1898@localhost>
References: <20090705182337.08F9.A69D9226@jp.fujitsu.com> <20090705112159.GB1898@localhost>
Message-Id: <20090705202503.0914.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sun,  5 Jul 2009 20:31:02 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, Jul 05, 2009 at 05:24:07PM +0800, KOSAKI Motohiro wrote:
> > Subject: [PATCH] add buffer cache information to show_free_areas()
> > 
> > When administrator analysis memory shortage reason from OOM log, They
> > often need to know rest number of cache like pages.
> 
> nr_blockdev_pages() pages are also accounted in NR_FILE_PAGES.

Yes, I know.

> > Then, show_free_areas() shouldn't only display page cache, but also it
> > should display buffer cache.
> 
> So if we are to add this, I'd suggest to put it close to the total
> pagecache line:
> 
>         printk("%ld total pagecache pages\n", global_page_state(NR_FILE_PAGES));
> +       printk("%ld blkdev pagecache pages\n", nr_blockdev_pages());

but this is intensional. May I explain why I choose non verbose area?
In typical workload, buffer-pages doesn't consume so many pages. then
I feel that your idea is too verbose output. In addition, if buffer-pages are much,
Administrator want to know other I/O related vmstat at the same time.

Then, I choose current position.


Thanks.



> 
> Thanks,
> Fengguang
> 
> > 
> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > ---
> >  mm/page_alloc.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > Index: b/mm/page_alloc.c
> > ===================================================================
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -2118,7 +2118,7 @@ void show_free_areas(void)
> >  	printk("Active_anon:%lu active_file:%lu inactive_anon:%lu\n"
> >  		" inactive_file:%lu"
> >  		" unevictable:%lu"
> > -		" dirty:%lu writeback:%lu unstable:%lu\n"
> > +		" dirty:%lu writeback:%lu buffer:%lu unstable:%lu\n"
> >  		" free:%lu slab_reclaimable:%lu slab_unreclaimable:%lu\n"
> >  		" mapped:%lu pagetables:%lu bounce:%lu\n",
> >  		global_page_state(NR_ACTIVE_ANON),
> > @@ -2128,6 +2128,7 @@ void show_free_areas(void)
> >  		global_page_state(NR_UNEVICTABLE),
> >  		global_page_state(NR_FILE_DIRTY),
> >  		global_page_state(NR_WRITEBACK),
> > +		K(nr_blockdev_pages()),
> >  		global_page_state(NR_UNSTABLE_NFS),
> >  		global_page_state(NR_FREE_PAGES),
> >  		global_page_state(NR_SLAB_RECLAIMABLE),
> > 



