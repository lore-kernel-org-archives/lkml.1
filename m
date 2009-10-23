Return-Path: <linux-kernel-owner+w=401wt.eu-S1751984AbZJWNjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984AbZJWNjE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 09:39:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbZJWNjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 09:39:04 -0400
Received: from gir.skynet.ie ([193.1.99.77]:34560 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647AbZJWNjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 09:39:02 -0400
Date: Fri, 23 Oct 2009 14:39:08 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Tobias Oetiker <tobi@oetiker.ch>
Cc: David Rientjes <rientjes@google.com>, Frans Pop <elendil@planet.nl>,
       Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, David Miller <davem@davemloft.net>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Kalle Valo <kalle.valo@iki.fi>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mohamed Abbas <mohamed.abbas@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 4/5] page allocator: Pre-emptively wake kswapd when
	high-order watermarks are hit
Message-ID: <20091023133908.GX11778@csn.ul.ie>
References: <1256221356-26049-1-git-send-email-mel@csn.ul.ie> <1256221356-26049-5-git-send-email-mel@csn.ul.ie> <alpine.DEB.2.00.0910221227010.21601@chino.kir.corp.google.com> <20091023091334.GV11778@csn.ul.ie> <alpine.DEB.2.00.0910230229010.28109@chino.kir.corp.google.com> <20091023112512.GW11778@csn.ul.ie> <alpine.DEB.2.00.0910231329550.26462@sebohet.brgvxre.pu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0910231329550.26462@sebohet.brgvxre.pu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 23, 2009 at 01:31:10PM +0200, Tobias Oetiker wrote:
> Mel,
> 
> Today Mel Gorman wrote:
> 
> > On Fri, Oct 23, 2009 at 02:36:53AM -0700, David Rientjes wrote:
> > > On Fri, 23 Oct 2009, Mel Gorman wrote:
> > >
> > > > > Hmm, is this really supposed to be added to __alloc_pages_high_priority()?
> > > > > By the patch description I was expecting kswapd to be woken up
> > > > > preemptively whenever the preferred zone is below ALLOC_WMARK_LOW and
> > > > > we're known to have just allocated at a higher order, not just when
> > > > > current was oom killed (when we should already be freeing a _lot_ of
> > > > > memory soon) or is doing a higher order allocation during direct reclaim.
> > > > >
> > > >
> > > > It was a somewhat arbitrary choice to have it trigger in the event high
> > > > priority allocations were happening frequently.
> > > >
> > >
> > > I don't quite understand, users of PF_MEMALLOC shouldn't be doing these
> > > higher order allocations and if ALLOC_NO_WATERMARKS is by way of the oom
> > > killer, we should be freeing a substantial amount of memory imminently
> > > when it exits that waking up kswapd would be irrelevant.
> > >
> >
> > I agree. I think it's highly unlikely this patch will make any
> > difference but I wanted to eliminate it as a possibility. Patch 3 and 4
> > were previously one patch that were tested together.
> 
> hi hi ... I have tested '3 only' this morning, and the allocation
> problems started again ... so for me 3 alone does not work while
> 3+4 does.
> 

Hi,

What was the outcome of 1+2?

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
