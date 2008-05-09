Return-Path: <linux-kernel-owner+w=401wt.eu-S1759158AbYEILfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759158AbYEILfT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 07:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbYEILfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 07:35:05 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:9820 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbYEILfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 07:35:04 -0400
Date: Fri, 9 May 2008 13:34:34 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] sparsemem vmemmap: initialize memmap.
Message-ID: <20080509113434.GG9840@osiris.boeblingen.de.ibm.com>
References: <20080509063856.GC9840@osiris.boeblingen.de.ibm.com> <20080509103132.GB10210@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080509103132.GB10210@shadowen.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Index: linux-2.6/mm/sparse-vmemmap.c
> > ===================================================================
> > --- linux-2.6.orig/mm/sparse-vmemmap.c
> > +++ linux-2.6/mm/sparse-vmemmap.c
> > @@ -154,6 +154,6 @@ struct page * __meminit sparse_mem_map_p
> >  	int error = vmemmap_populate(map, PAGES_PER_SECTION, nid);
> >  	if (error)
> >  		return NULL;
> > -
> > +	memset(map, 0, PAGES_PER_SECTION * sizeof(struct page));
> >  	return map;
> >  }
> 
> The normal expectation is that all allocations are made using
> vmemmap_alloc_block() which allocates from the appropriate place.  Once
> the buddy is up and available it uses:
> 
> 	struct page *page = alloc_pages_node(node,
> 			GFP_KERNEL | __GFP_ZERO, get_order(size));
> 
> to get the memory so it should all be zero'd.  So I would expect all
> existing users to be covered by that?  Can you not simply use __GFP_ZERO
> for your allocations or use vmemmap_alloc_block() ?

Ah, I didn't notice the __GFP_ZERO. So it's just an s390 bug. Will
move the memset to our code instead.
Thanks!
