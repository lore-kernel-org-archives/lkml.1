Return-Path: <linux-kernel-owner+w=401wt.eu-S1754419AbXDTEqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbXDTEqz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 00:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754422AbXDTEqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 00:46:55 -0400
Received: from holomorphy.com ([66.93.40.71]:47070 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412AbXDTEqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 00:46:55 -0400
Date: Thu, 19 Apr 2007 21:47:18 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Paul Jackson <pj@sgi.com>,
       Dave Chinner <dgc@sgi.com>, Andi Kleen <ak@suse.de>
Subject: Re: [RFC 0/8] Variable Order Page Cache
Message-ID: <20070420044718.GV2986@holomorphy.com>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2007 at 09:35:04AM -0700, Christoph Lameter wrote:
> This patchset modifies the core VM so that higher order page cache pages
> become possible. The higher order page cache pages are compound pages
> and can be handled in the same way as regular pages.
> The order of the pages is determined by the order set up in the mapping
> (struct address_space). By default the order is set to zero.
> This means that higher order pages are optional. There is no attempt here
> to generally change the page order of the page cache. 4K pages are effective
> for small files.

Oh dear. Per-file pagesizes are foul. Better to fix up the pagecache's
radix tree than to restrict it like this. There are other attacks on the
multiple horizontal internal tree node allocation problem beyond
outright B+ trees that allow radix trees to continue to be used.


On Thu, Apr 19, 2007 at 09:35:04AM -0700, Christoph Lameter wrote:
> However, it would be good if the VM would support I/O to higher order pages
> to enable efficient support for large scale I/O. If one wants to write a
> long file of a few gigabytes then the filesystem should have a choice of
> selecting a larger page size for that file and handle larger chunks of
> memory at once.
> The support here is only for buffered I/O and only for one filesystem (ramfs).
> Modification of other filesystems to support higher order pages may require
> extensive work of other components of the kernel. But I hope this shows that
> there is a relatively easy way to that goal that could be taken in steps..

I've always wanted the awareness to be pervasive, so it's good to hear
there's someone with a common interest. If this effort takes off, I'd be
happy to contribute to it. I do wonder what ever happened with the gelato
codebase, though.


On Thu, Apr 19, 2007 at 09:35:04AM -0700, Christoph Lameter wrote:
> Note that the higher order pages are subject to reclaim. This works in general
> since we are always operating on a single page struct. Reclaim is fooled to
> think that it is touching page sized objects (there are likely issues to be
> fixed there if we want to go down this road).

I'm afraid this may be approaching an underappreciated research topic.
Most sponsors of such research seem to have an active disinterest in
getting page replacement to properly interoperate with all this.


On Thu, Apr 19, 2007 at 09:35:04AM -0700, Christoph Lameter wrote:
> What is currently not supported:
> - Buffer heads for higher order pages (possible with the compound pages in mm
>   that do not use page->private requires upgrade of the buffer cache layers).
> - Higher order pages in the block layer etc.
> - Mmapping higher order pages
> Note that this is proof-of-concept. Lots of functionality is missing and
> various issues have not been dealt with. Use of higher order pages may cause
> memory fragmentation. Mel Gorman's anti-fragmentation work is probably
> essential if we want to do this. We likely need actual defragmentation
> support.
> The main point of this patchset is to demonstrates that it is basically
> possible to have higher order support with straightforward changes to the
> VM.

You don't know how glad I am to see someone actually hammering out code
on this front.


-- wli
