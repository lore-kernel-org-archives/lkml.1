Return-Path: <linux-kernel-owner+w=401wt.eu-S1751258AbZHSI5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751258AbZHSI5N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 04:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751168AbZHSI5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 04:57:12 -0400
Received: from gir.skynet.ie ([193.1.99.77]:34734 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbZHSI5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 04:57:12 -0400
Date: Wed, 19 Aug 2009 09:57:14 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Vincent Li <macli@brc.ubc.ca>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] page-allocator: Split per-cpu list into
	one-list-per-migrate-type
Message-ID: <20090819085714.GA24809@csn.ul.ie>
References: <1250594162-17322-1-git-send-email-mel@csn.ul.ie> <1250594162-17322-2-git-send-email-mel@csn.ul.ie> <alpine.DEB.1.00.0908181550450.31547@mail.selltech.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0908181550450.31547@mail.selltech.ca>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 03:57:00PM -0700, Vincent Li wrote:
> On Tue, 18 Aug 2009, Mel Gorman wrote:
> 
> > +	/*
> > +	 * We only track unreclaimable, reclaimable and movable on pcp lists.
> 			 ^^^^^^^^^^^^^  
> Is it unmovable? I don't see unreclaimable migrate type on pcp lists. 
> Just ask to make sure I undsterstand the comment right.
> 

It should have said unmovable. Sorry

> > +	 * Free ISOLATE pages back to the allocator because they are being
> > +	 * offlined but treat RESERVE as movable pages so we can get those
> > +	 * areas back if necessary. Otherwise, we may have to free
> > +	 * excessively into the page allocator
> > +	 */
> > +	if (migratetype >= MIGRATE_PCPTYPES) {
> > +		if (unlikely(migratetype == MIGRATE_ISOLATE)) {
> > +			free_one_page(zone, page, 0, migratetype);
> > +			goto out;
> > +		}
> > +		migratetype = MIGRATE_MOVABLE;
> > +	}
> > +
> 
> Vincent Li
> Biomedical Research Center
> University of British Columbia
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
