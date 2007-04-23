Return-Path: <linux-kernel-owner+w=401wt.eu-S1754272AbXDWVhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbXDWVhH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 17:37:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754267AbXDWVhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 17:37:07 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:38554 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754272AbXDWVhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 17:37:06 -0400
Date: Mon, 23 Apr 2007 14:37:03 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org, pj@sgi.com,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: Pagecache: find_or_create_page does not call a proper page
 allocator function
In-Reply-To: <20070423142919.5809e03f.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704231436070.832@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0704231408530.691@schroedinger.engr.sgi.com>
 <20070423142919.5809e03f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2007, Andrew Morton wrote:

> > +static inline struct page *page_cache_alloc_mask(struct address_space *x,
> > +			gfp_t gfp)
> > +{
> > +	return __page_cache_alloc(mapping_gfp_mask(x) | gfp);
> > +}
> 
> Usually we use the term "mask" to imply an AND function, not an OR
> function.

Well but you pass an allocation mask.... Maybe call this 
page_cache_alloc_gfp?

> There are few calls to page_cache_alloc().  Would it not be simpler to just
> add the additional argument to page_cache_alloc() (called "extra_gfp",
> please) and to update all callers?  And to remove page_cache_alloc_cold()
> and replace all it callers with page_cache_alloc(mapping, __GFP_COLD)?
> 
> The way we actually get rid of an API call instead of adding another one.

Ok. Give me an hour or so.
 
