Return-Path: <linux-kernel-owner+w=401wt.eu-S1756310AbZJSONx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310AbZJSONx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 10:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756223AbZJSONx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 10:13:53 -0400
Received: from gir.skynet.ie ([193.1.99.77]:60110 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756195AbZJSONw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 10:13:52 -0400
Date: Mon, 19 Oct 2009 15:13:59 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Karol Lewandowski <karol.k.lewandowski@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, stable <stable@kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, David Miller <davem@davemloft.net>,
       Frans Pop <elendil@planet.nl>,
       reinette chatre <reinette.chatre@intel.com>,
       Kalle Valo <kalle.valo@iki.fi>,
       "John W. Linville" <linville@tuxdriver.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 0/2] Reduce number of GFP_ATOMIC allocation failures
Message-ID: <20091019141359.GF9036@csn.ul.ie>
References: <1255689446-3858-1-git-send-email-mel@csn.ul.ie> <20091017183421.GA3370@bizet.domek.prywatny>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20091017183421.GA3370@bizet.domek.prywatny>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 17, 2009 at 08:34:21PM +0200, Karol Lewandowski wrote:
> On Fri, Oct 16, 2009 at 11:37:24AM +0100, Mel Gorman wrote:
> > The following two patches against 2.6.32-rc4 should reduce allocation
> > failure reports for GFP_ATOMIC allocations that have being cropping up
> > since 2.6.31-rc1.
> ...
> > The patches should also help the following bugs as well and testing there
> > would be appreciated.
> > 
> > [Bug #14265] ifconfig: page allocation failure. order:5, mode:0x8020 w/ e100
> > 
> > It might also have helped the following bug
> 
> These patches actually made situation kind-of "worse" for this
> particular issue.
> 
> I've tried patches with post 2.6.32-rc4 kernel and after second
> suspend-resume cycle I got typical "order:5" failure.  However, this
> time when I manually tried to bring interface up ("ifup eth0") it
> failed for 4 consecutive times with "Can't allocate memory".  Before
> applying these patches this never occured -- kernel sometimes failed
> to allocate memory during resume, but it *never* failed afterwards.
> 

I'm hoping the patch + the revert which I asked for in another mail will
help. It's been clear for a while that more than one thing went wrong
during this cycle.

> I'll go now for another round of bisecting... and hopefully this time
> I'll be able to trigger this problem on different/faster computer with
> e100-based card.
> 
> 
> > although that driver has already been fixed by not making high-order
> > atomic allocations.
> 
> Driver has been fixed?  The one patch that I saw (by davem[1]) didn't
> fix this issue.  As of 2.6.32-rc5 I see no fixes to e100.c in
> mainline, has there been another than this[1] fix posted somewhere?
> 
> [1] http://lkml.org/lkml/2009/10/12/169
> 

The driver that was fixed was for the ipw2200, not the e100.

Thanks

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
