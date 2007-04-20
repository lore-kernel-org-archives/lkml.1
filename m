Return-Path: <linux-kernel-owner+w=401wt.eu-S1753306AbXDTTKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbXDTTKr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 15:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754485AbXDTTKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 15:10:46 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40854 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753306AbXDTTKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 15:10:46 -0400
Date: Fri, 20 Apr 2007 12:10:43 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
cc: Mel Gorman <mel@skynet.ie>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Paul Jackson <pj@sgi.com>, Dave Chinner <dgc@sgi.com>
Subject: Re: [RFC 4/8] Enhance fallback functions in libs to support higher
 order pages
In-Reply-To: <1177095021.10848.18.camel@kleikamp.austin.ibm.com>
Message-ID: <Pine.LNX.4.64.0704201207120.21342@schroedinger.engr.sgi.com>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
  <20070419163525.11948.3482.sendpatchset@schroedinger.engr.sgi.com> 
 <20070420110516.GC12075@skynet.ie> <1177095021.10848.18.camel@kleikamp.austin.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007, Dave Kleikamp wrote:

> On Fri, 2007-04-20 at 12:05 +0100, Mel Gorman wrote:
> 
> > comments about missing page_cache_size() covered elsewhere. However, I
> > note that Dave Kleikamp might be interested in this changing of
> > page_cache_size() from the perspective of page cache tails. I've added
> > him to the cc so he can take a quick look.
> 
> Yeah.  I'm working on patches for storing file tails in buffers
> allocated from the slab cache, and the tail will be represented by a
> fake struct page.  (This is primarily for kernels with a larger page
> size).  So my version of page_cache_size(page) may return a different
> size for different pages belonging to the same mapping.  I'm in the
> midst of cleaning up the patches and plan to post them to linux-mm by
> Monday.

I am not sure what the point of that patchset would be in this context 
given that this is about support for arbitrary page sizes. If the 
filesystem wants it then it can reduce the page size for small files.

Different page sizes for one mapping may introduce high complexity into a 
filesystem.

And we can already represent different page size. We have compound pages 
support in the kernel.

page_cache_size(page) in terms of current code in mm is

PAGE_SIZE << compound_order(page)
