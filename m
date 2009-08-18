Return-Path: <linux-kernel-owner+w=401wt.eu-S1758723AbZHRNKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723AbZHRNKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 09:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbZHRNKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 09:10:22 -0400
Received: from gir.skynet.ie ([193.1.99.77]:56850 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358AbZHRNKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 09:10:22 -0400
Date: Tue, 18 Aug 2009 14:10:24 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] page-allocator: Split per-cpu list into
	one-list-per-migrate-type
Message-ID: <20090818131024.GD31469@csn.ul.ie>
References: <1250594162-17322-1-git-send-email-mel@csn.ul.ie> <1250594162-17322-2-git-send-email-mel@csn.ul.ie> <20090818114335.GO9962@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090818114335.GO9962@wotan.suse.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 01:43:35PM +0200, Nick Piggin wrote:
> On Tue, Aug 18, 2009 at 12:16:00PM +0100, Mel Gorman wrote:
> > Currently the per-cpu page allocator searches the PCP list for pages of the
> > correct migrate-type to reduce the possibility of pages being inappropriate
> > placed from a fragmentation perspective. This search is potentially expensive
> > in a fast-path and undesirable. Splitting the per-cpu list into multiple
> > lists increases the size of a per-cpu structure and this was potentially
> > a major problem at the time the search was introduced. These problem has
> > been mitigated as now only the necessary number of structures is allocated
> > for the running system.
> > 
> > This patch replaces a list search in the per-cpu allocator with one list per
> > migrate type. The potential snag with this approach is when bulk freeing
> > pages. We round-robin free pages based on migrate type which has little
> > bearing on the cache hotness of the page and potentially checks empty lists
> > repeatedly in the event the majority of PCP pages are of one type.
> 
> Seems OK I guess. Trading off icache and branches for dcache and
> algorithmic gains. Too bad everything is always a tradeoff ;)
> 

Tell me about it. The dcache overhead of this is a problem although I
tried to limit the damage using pahole to see how much padding I had to
play with and staying within it where possible.

> But no I think this is a good idea.
> 

Thanks. Is that an Ack?

> > <SNIP>

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
