Return-Path: <linux-kernel-owner+w=401wt.eu-S1758905AbZHRM5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758905AbZHRM5d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 08:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758896AbZHRM5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 08:57:33 -0400
Received: from gir.skynet.ie ([193.1.99.77]:39804 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758894AbZHRM5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 08:57:32 -0400
Date: Tue, 18 Aug 2009 13:57:35 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] page-allocator: Move pcp static fields for high
	and batch off-pcp and onto the zone
Message-ID: <20090818125735.GC31469@csn.ul.ie>
References: <1250594162-17322-1-git-send-email-mel@csn.ul.ie> <1250594162-17322-4-git-send-email-mel@csn.ul.ie> <20090818114752.GP9962@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090818114752.GP9962@wotan.suse.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 01:47:52PM +0200, Nick Piggin wrote:
> On Tue, Aug 18, 2009 at 12:16:02PM +0100, Mel Gorman wrote:
> > Having multiple lists per PCPU increased the size of the per-pcpu
> > structure. Two of the fields, high and batch, do not change within a
> > zone making that information redundant. This patch moves those fields
> > off the PCP and onto the zone to reduce the size of the PCPU.
> 
> Hmm.. I did have some patches a long long time ago that among other
> things made the lists larger for the local node only....
> 

To reduce the remote node lists, one could look at applying some fixed factor
to the high value or basing remote lists on some percentage of high.

> But I guess if something like that is ever shown to be a good idea
> then we can go back to the old scheme. So yeah this seems OK.
> 

Thanks.

> > 
> > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> > ---
> >  include/linux/mmzone.h |    9 +++++----
> >  mm/page_alloc.c        |   47 +++++++++++++++++++++++++----------------------
> >  mm/vmstat.c            |    4 ++--
> >  3 files changed, 32 insertions(+), 28 deletions(-)
> > 
> > <SNIP>

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
