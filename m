Return-Path: <linux-kernel-owner+w=401wt.eu-S1751922AbZHRUut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922AbZHRUut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 16:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbZHRUut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 16:50:49 -0400
Received: from gir.skynet.ie ([193.1.99.77]:33144 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbZHRUus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 16:50:48 -0400
Date: Tue, 18 Aug 2009 21:50:50 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] page-allocator: Move pcp static fields for high
	and batch off-pcp and onto the zone
Message-ID: <20090818205050.GA756@csn.ul.ie>
References: <1250594162-17322-1-git-send-email-mel@csn.ul.ie> <1250594162-17322-4-git-send-email-mel@csn.ul.ie> <alpine.DEB.1.10.0908181015420.32284@gentwo.org> <20090818164216.GA13435@csn.ul.ie> <alpine.DEB.1.10.0908181355490.3840@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0908181355490.3840@gentwo.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 01:56:22PM -0400, Christoph Lameter wrote:
> On Tue, 18 Aug 2009, Mel Gorman wrote:
> 
> > On Tue, Aug 18, 2009 at 10:18:48AM -0400, Christoph Lameter wrote:
> > >
> > > This will increase the cache footprint for the hot code path. Could these
> > > new variable be moved next to zone fields that are already in use there?
> > > The pageset array is used f.e.
> > >
> >
> > pageset is ____cacheline_aligned_in_smp so putting pcp->high/batch near
> > it won't help in terms of cache footprint. This is why I located it near
> > watermarks because it's known they'll be needed at roughly the same time
> > pcp->high/batch would be normally accessed.
> 
> watermarks are not accessed from the hot code path in free_hot_cold page.
> 

They are used in a commonly-used path for allocation so there is some
advantage. Put beside pageset, there is no advantage as that structure
is already aligned to a cache-line.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
