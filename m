Return-Path: <linux-kernel-owner+w=401wt.eu-S965717AbXCMMLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965717AbXCMMLW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 08:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965714AbXCMMLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 08:11:22 -0400
Received: from smtp.osdl.org ([65.172.181.24]:43759 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965702AbXCMMLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 08:11:21 -0400
Date: Tue, 13 Mar 2007 05:11:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: clameter@sgi.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [QUICKLIST 0/4] Arch independent quicklists V2
Message-Id: <20070313051109.3215104b.akpm@linux-foundation.org>
In-Reply-To: <45F69287.8040509@yahoo.com.au>
References: <20070313071325.4920.82870.sendpatchset@schroedinger.engr.sgi.com>
	<20070313005334.853559ca.akpm@linux-foundation.org>
	<45F65ADA.9010501@yahoo.com.au>
	<20070313035250.f908a50e.akpm@linux-foundation.org>
	<45F685C6.8070806@yahoo.com.au>
	<20070313041551.565891b5.akpm@linux-foundation.org>
	<45F68B4B.9020200@yahoo.com.au>
	<20070313044756.b45649ac.akpm@linux-foundation.org>
	<45F69287.8040509@yahoo.com.au>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 13 Mar 2007 23:01:11 +1100 Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> Andrew Morton wrote:
> >>On Tue, 13 Mar 2007 22:30:19 +1100 Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> >>We don't actually have to zap_pte_range the entire page table in
> >>order to free it (IIRC we used to have to, before the 4lpt patches).
> > 
> > 
> > I'm trying to remember why we ever would have needed to zero out the pagetable
> > pages if we're taking down the whole mm?  Maybe it's because "oh, the
> > arch wants to put this page into a quicklist to recycle it", which is
> > all rather circular.
> > 
> > It would be interesting to look at a) leave the page full of random garbage
> > if we're releasing the whole mm and b) return it straight to the page allocator.
> 
> Well we have the 'fullmm' case, which avoids all the locked pte operations
> (for those architectures where hardware pt walking requires atomicity).

I suspect there are some tlb operations which could be skipped in that case
too.

> However we still have to visit those to-be-unmapped parts of the page table
> to find the pages and free them. So we still at least need to bring it into
> cache for the read... at which point, the store probably isn't a big burden.

It means all that data has to be written back.  Yes, I expect it'll prove
to be less costly than the initial load.
