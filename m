Return-Path: <linux-kernel-owner+w=401wt.eu-S932837AbXDFU2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837AbXDFU2P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 16:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932854AbXDFU2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 16:28:15 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56406 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932837AbXDFU2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 16:28:14 -0400
Date: Fri, 6 Apr 2007 13:28:13 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Hugh Dickins <hugh@veritas.com>, Nick Piggin <npiggin@suse.de>,
       dgc@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Make page->private usable in compound pages V1
In-Reply-To: <20070406130401.b380b8da.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704061314400.23939@schroedinger.engr.sgi.com>
References: <20070405223651.21698.77505.sendpatchset@schroedinger.engr.sgi.com>
 <20070405164300.a5d24329.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704060958430.25652@schroedinger.engr.sgi.com>
 <20070406130401.b380b8da.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Apr 2007, Andrew Morton wrote:

> > Both SLAB and SLUB use compound pages.
> 
> Not really.  slab sets the page->lru.prev of each constituent page to point
> at the controlling slab.

Uhh.. More slab inconsistencies. page[1]->lru is used for compound 
pages in the !MMU case.

>From page_alloc.c:

/*
 * Higher-order pages are called "compound pages".  They are structured 
thusly:
 *
 * The first tail page's ->lru.next holds the address of the compound 
page's
 * put_page() function.  Its ->lru.prev holds the order of allocation.
 * This usage means that zero-order pages may not be compound.
 */

> Will slub handle NOMMU anonymous pages appropriately?

I am not sure how anonymous pages relate to the slab allocators.

SLUB consistently uses compound pages for all higher order allocations.
And those are usually fine for mmu and no mmu even without this 
series of patches unless someone pokes around page->private.
