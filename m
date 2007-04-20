Return-Path: <linux-kernel-owner+w=401wt.eu-S1767211AbXDTT1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767211AbXDTT1v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 15:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767212AbXDTT1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 15:27:51 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:52990 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767211AbXDTT1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 15:27:50 -0400
Subject: Re: [RFC 4/8] Enhance fallback functions in libs to support higher
	order pages
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Mel Gorman <mel@skynet.ie>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Paul Jackson <pj@sgi.com>, Dave Chinner <dgc@sgi.com>
In-Reply-To: <Pine.LNX.4.64.0704201207120.21342@schroedinger.engr.sgi.com>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
	 <20070419163525.11948.3482.sendpatchset@schroedinger.engr.sgi.com>
	 <20070420110516.GC12075@skynet.ie>
	 <1177095021.10848.18.camel@kleikamp.austin.ibm.com>
	 <Pine.LNX.4.64.0704201207120.21342@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Fri, 20 Apr 2007 19:27:01 +0000
Message-Id: <1177097221.10848.31.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-20 at 12:10 -0700, Christoph Lameter wrote:
> On Fri, 20 Apr 2007, Dave Kleikamp wrote:
> > Yeah.  I'm working on patches for storing file tails in buffers
> > allocated from the slab cache, and the tail will be represented by a
> > fake struct page.  (This is primarily for kernels with a larger page
> > size).  So my version of page_cache_size(page) may return a different
> > size for different pages belonging to the same mapping.  I'm in the
> > midst of cleaning up the patches and plan to post them to linux-mm by
> > Monday.
> 
> I am not sure what the point of that patchset would be in this context 
> given that this is about support for arbitrary page sizes. If the 
> filesystem wants it then it can reduce the page size for small files.
> 
> Different page sizes for one mapping may introduce high complexity into a 
> filesystem.

I'm trying to keep it from getting too complicated.

> And we can already represent different page size. We have compound pages 
> support in the kernel.

There are advantages to having a larger base page size, such as
increased TLB reach.  I'm specifically targetting kernels built with
CONFIG_PPC_64K_PAGES, but other architectures could benefit.

> page_cache_size(page) in terms of current code in mm is
> 
> PAGE_SIZE << compound_order(page)

I don't see page_cache_size() in linux-2.6.21-rc6-mm1.  Is there
something newer?

Anyway, my patches are at a proof-of-concept stage.  I look forward to
more discussion when I post the patch set.

Thanks,
Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

