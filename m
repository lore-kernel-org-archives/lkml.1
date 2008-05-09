Return-Path: <linux-kernel-owner+w=401wt.eu-S932201AbYEIQZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201AbYEIQZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 12:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752480AbYEIQZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 12:25:44 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40797 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751072AbYEIQZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 12:25:43 -0400
Date: Fri, 9 May 2008 09:25:41 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Heiko Carstens <heiko.carstens@de.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>,
       Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] sparsemem vmemmap: initialize memmap.
In-Reply-To: <20080509063856.GC9840@osiris.boeblingen.de.ibm.com>
Message-ID: <Pine.LNX.4.64.0805090923550.18195@schroedinger.engr.sgi.com>
References: <20080509063856.GC9840@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nack. vmemmap_alloc_block does 

void * __meminit vmemmap_alloc_block(unsigned long size, int node)
{
        /* If the main allocator is up use that, fallback to bootmem. */
        if (slab_is_available()) {
                struct page *page = alloc_pages_node(node,
                                GFP_KERNEL | __GFP_ZERO, get_order(size));
                if (page)
                        return page_address(page);
                return NULL;
        } else
                return __earlyonly_bootmem_alloc(node, size, size,
                                __pa(MAX_DMA_ADDRESS));
}

memory is always zeroed. Maybe you use an alternate implementation that is 
broken?


