Return-Path: <linux-kernel-owner+w=401wt.eu-S1753999AbZJVQDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbZJVQDG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 12:03:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbZJVQDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 12:03:05 -0400
Received: from gir.skynet.ie ([193.1.99.77]:54152 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074AbZJVQDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 12:03:03 -0400
Date: Thu, 22 Oct 2009 17:03:10 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       David Miller <davem@davemloft.net>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Kalle Valo <kalle.valo@iki.fi>, David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mohamed Abbas <mohamed.abbas@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, akpm@linux-foundation.org,
       cl@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [PATCH 0/5] Candidate fix for increased number of GFP_ATOMIC
	failures V2
Message-ID: <20091022160310.GS11778@csn.ul.ie>
References: <1256221356-26049-1-git-send-email-mel@csn.ul.ie> <84144f020910220747nba30d8bkc83c2569da79bd7c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <84144f020910220747nba30d8bkc83c2569da79bd7c@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 22, 2009 at 05:47:10PM +0300, Pekka Enberg wrote:
> On Thu, Oct 22, 2009 at 5:22 PM, Mel Gorman <mel@csn.ul.ie> wrote:
> > Test 1: Verify your problem occurs on 2.6.32-rc5 if you can
> >
> > Test 2: Apply the following two patches and test again
> >
> >  1/5 page allocator: Always wake kswapd when restarting an allocation attempt after direct reclaim failed
> >  2/5 page allocator: Do not allow interrupts to use ALLOC_HARDER
> 
> These are pretty obvious bug fixes and should go to linux-next ASAP IMHO.
> 

Agreed, but I wanted to pin down where exactly we stand with this
problem before sending patches any direction for merging.

> > Test 5: If things are still screwed, apply the following
> >  5/5 Revert 373c0a7e, 8aa7e847: Fix congestion_wait() sync/async vs read/write confusion
> >
> >        Frans Pop reports that the bulk of his problems go away when this
> >        patch is reverted on 2.6.31. There has been some confusion on why
> >        exactly this patch was wrong but apparently the conversion was not
> >        complete and further work was required. It's unknown if all the
> >        necessary work exists in 2.6.31-rc5 or not. If there are still
> >        allocation failures and applying this patch fixes the problem,
> >        there are still snags that need to be ironed out.
> 
> As explained by Jens Axboe, this changes timing but is not the source
> of the OOMs so the revert is bogus even if it "helps" on some
> workloads. IIRC the person who reported the revert to help things did
> report that the OOMs did not go away, they were simply harder to
> trigger with the revert.
> 

IIRC, there were mixed reports as to how much the revert helped.  I'm hoping
that patches 1+2 cover the bases hence why I asked them to be tested on
their own. Patch 2 in particular might be responsible for watermarks being
impacted enough to cause timing problems. I left reverting with patch 5 as
a standalone test to see how much of a factor the timing changes introduced
are if there are still allocation problems.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
