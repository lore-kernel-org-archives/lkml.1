Return-Path: <linux-kernel-owner+w=401wt.eu-S1753632AbXCZSOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632AbXCZSOx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 14:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753654AbXCZSOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 14:14:53 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:44347 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753632AbXCZSOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 14:14:52 -0400
Date: Mon, 26 Mar 2007 11:14:55 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [QUICKLIST 1/5] Quicklists for page table pages V4
In-Reply-To: <Pine.LNX.4.64.0703260938520.3297@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0703261112110.13105@schroedinger.engr.sgi.com>
References: <20070323062843.19502.19827.sendpatchset@schroedinger.engr.sgi.com>
 <20070322223927.bb4caf43.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0703222339560.19630@schroedinger.engr.sgi.com>
 <20070322234848.100abb3d.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0703230804120.21857@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0703231026490.23132@schroedinger.engr.sgi.com>
 <20070323222133.f17090cf.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0703260938520.3297@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2007, Christoph Lameter wrote:

> > After your patches, x86_64 is using a common quicklist allocator for puds,
> > pmds and pgds and continues to use get_zeroed_page() for ptes.
> 
> x86_64 should be using quicklists for all ptes after this patch. I did not 
> convert pte_free() since it is only used for freeing ptes during races 
> (see __pte_alloc). Since pte_free gets passed a page struct it would require 
> virt_to_page before being put onto the freelist. Not worth doing.
> 
> Hmmm... Then how does x86_64 free the ptes? Seems that we do 
> free_page_and_swap_cache() in tlb_remove_pages. Yup so ptes are not 
> handled which limits the speed improvements that we see.

And if we would try to put the ptes onto quicklists then we would get into 
more difficulties with the tlb shootdown code. Sigh. We cannot easily 
deal with ptes. Quicklists on i386 and x86_64 only work for pgds,puds and 
pmds. And as was pointed out elsewhere in this thread: The performance 
gains are therefore limited on these platforms.
