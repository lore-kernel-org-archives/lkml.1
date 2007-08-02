Return-Path: <linux-kernel-owner+w=401wt.eu-S1758791AbXHBQSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758791AbXHBQSj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 12:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757058AbXHBQSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 12:18:32 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:55864 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757030AbXHBQSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 12:18:32 -0400
Date: Thu, 2 Aug 2007 17:18:29 +0100
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH] 2.6.23-rc1-mm1 - fix missing numa_zonelist_order sysctl
Message-ID: <20070802161829.GB22493@skynet.ie>
References: <1185994972.5059.91.camel@localhost> <20070802094445.6495e25d.kamezawa.hiroyu@jp.fujitsu.com> <20070802161437.GA22493@skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070802161437.GA22493@skynet.ie>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (02/08/07 17:14), Mel Gorman didst pronounce:
> On (02/08/07 09:44), KAMEZAWA Hiroyuki didst pronounce:
> > On Wed, 01 Aug 2007 15:02:51 -0400
> > Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:
> > > [But, maybe reordering the zonelists is not such a good idea
> > > when ZONE_MOVABLE is populated?]
> > > 
> > 
> > It's case-by-case I think. In zone order with ZONE_MOVABLE case,
> > user's page cache will not use ZONE_NORMAL until ZONE_MOVABLE in all node
> > is exhausted. This is an expected behavior, I think.
> > 
> 
> This is expected behaviour. I see no reason for lower zones to be used
> for allocations that use memory from a higher zone with free memory.
> 

Bah. I should have thought of this better.

If you are using ZONE_MOVABLE and the zonelist is in zone order, one would
use memory from remote nodes when suitable local memory was available. I don't
have a quick answer on how this should be handled. The answer may be
something like;

o When ordering zonelists by nodes, order them so that the movable zone
  is paired with the next highest zones in a zonelist before moving to the
  next node

> > I think the real problem is the scheme for "How to set zone movable size to
> > appropriate value for the system". This needs more study and documentation.
> > (but maybe depends on system configuration to some extent.)
> > 
> 
> It depends on the system configuration and the workload requirements.
> Right now, there isn't exact information available on what size the zone
> should be. It'll need to be studied over a period of time.
> 
> -- 
> Mel Gorman
> Part-time Phd Student                          Linux Technology Center
> University of Limerick                         IBM Dublin Software Lab
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
