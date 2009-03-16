Return-Path: <linux-kernel-owner+w=401wt.eu-S1759148AbZCPQvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759148AbZCPQvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 12:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755473AbZCPQvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 12:51:07 -0400
Received: from gir.skynet.ie ([193.1.99.77]:50688 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754325AbZCPQvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 12:51:06 -0400
Date: Mon, 16 Mar 2009 16:51:03 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 30/35] Skip the PCP list search by counting the order
	and type of pages on list
Message-ID: <20090316165103.GN24293@csn.ul.ie>
References: <1237196790-7268-1-git-send-email-mel@csn.ul.ie> <1237196790-7268-31-git-send-email-mel@csn.ul.ie> <alpine.DEB.1.10.0903161231040.32577@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0903161231040.32577@qirst.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 12:31:44PM -0400, Christoph Lameter wrote:
> On Mon, 16 Mar 2009, Mel Gorman wrote:
> 
> >
> >  struct per_cpu_pages {
> > -	int count;		/* number of pages in the list */
> > +	/* The total number of pages on the PCP lists */
> > +	int count;
> > +
> > +	/* Count of each migratetype and order */
> > +	u8 mocount[MIGRATE_PCPTYPES][PAGE_ALLOC_COSTLY_ORDER+1];
> 
> What about overflow? You could have more than 255 pages of a given type in
> a pcp.
> 

Are you sure? The maximum size I would expect is pcp->high which is
6 * pcp->batch which is limited in size. I might have missed something
though.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
