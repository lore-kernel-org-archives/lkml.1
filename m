Return-Path: <linux-kernel-owner+w=401wt.eu-S1755601AbZGENCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601AbZGENCS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 09:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753478AbZGENCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 09:02:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:41500 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753462AbZGENCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 09:02:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,351,1243839600"; 
   d="scan'208";a="161651572"
Date: Sun, 5 Jul 2009 21:02:00 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 5/5] add NR_ANON_PAGES to OOM log
Message-ID: <20090705130200.GA6585@localhost>
References: <20090705182533.0902.A69D9226@jp.fujitsu.com> <20090705121308.GC5252@localhost> <20090705211739.091D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090705211739.091D.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 05, 2009 at 08:21:20PM +0800, KOSAKI Motohiro wrote:
> > On Sun, Jul 05, 2009 at 05:26:18PM +0800, KOSAKI Motohiro wrote:
> > > Subject: [PATCH] add NR_ANON_PAGES to OOM log
> > > 
> > > show_free_areas can display NR_FILE_PAGES, but it can't display
> > > NR_ANON_PAGES.
> > > 
> > > this patch fix its inconsistency.
> > > 
> > > 
> > > Reported-by: Wu Fengguang <fengguang.wu@gmail.com>
> > > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > > ---
> > >  mm/page_alloc.c |    1 +
> > >  1 file changed, 1 insertion(+)
> > > 
> > > Index: b/mm/page_alloc.c
> > > ===================================================================
> > > --- a/mm/page_alloc.c
> > > +++ b/mm/page_alloc.c
> > > @@ -2216,6 +2216,7 @@ void show_free_areas(void)
> > >  		printk("= %lukB\n", K(total));
> > >  	}
> > >  
> > > +	printk("%ld total anon pages\n", global_page_state(NR_ANON_PAGES));
> > >  	printk("%ld total pagecache pages\n", global_page_state(NR_FILE_PAGES));
> > 
> > Can we put related items together, ie. this looks more friendly:
> > 
> >         Anon:XXX active_anon:XXX inactive_anon:XXX
> >         File:XXX active_file:XXX inactive_file:XXX
> 
> hmmm. Actually NR_ACTIVE_ANON + NR_INACTIVE_ANON != NR_ANON_PAGES.
> tmpfs pages are accounted as FILE, but it is stay in anon lru.

Right, that's exactly the reason I propose to put them together: to
make the number of tmpfs pages obvious.

> I think your proposed format easily makes confusion. this format cause to
> imazine Anon = active_anon + inactive_anon.

Yes it may confuse normal users :(

> At least, we need to use another name, I think.

Hmm I find it hard to work out a good name.

But instead, it may be a good idea to explicitly compute the tmpfs
pages, because the excessive use of tmpfs pages could be a common
reason of OOM.

Thanks,
Fengguang
