Return-Path: <linux-kernel-owner+w=401wt.eu-S1766002AbYEIRBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766002AbYEIRBX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 13:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757683AbYEIRBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 13:01:16 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:12790 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757499AbYEIRBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 13:01:14 -0400
Date: Fri, 9 May 2008 19:01:11 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>,
       Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] sparsemem vmemmap: initialize memmap.
Message-ID: <20080509170111.GA7248@osiris.boeblingen.de.ibm.com>
References: <20080509063856.GC9840@osiris.boeblingen.de.ibm.com> <Pine.LNX.4.64.0805090923550.18195@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805090923550.18195@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2008 at 09:25:41AM -0700, Christoph Lameter wrote:
> Nack. vmemmap_alloc_block does 
> 
> void * __meminit vmemmap_alloc_block(unsigned long size, int node)
> {
>         /* If the main allocator is up use that, fallback to bootmem. */
>         if (slab_is_available()) {
>                 struct page *page = alloc_pages_node(node,
>                                 GFP_KERNEL | __GFP_ZERO, get_order(size));
>                 if (page)
>                         return page_address(page);
>                 return NULL;
>         } else
>                 return __earlyonly_bootmem_alloc(node, size, size,
>                                 __pa(MAX_DMA_ADDRESS));
> }
> 
> memory is always zeroed. Maybe you use an alternate implementation that is 
> broken?

Yes, I missed the __GFP_ZERO. Already figured out and fixed in arch code.

Thanks ;)
