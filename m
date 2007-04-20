Return-Path: <linux-kernel-owner+w=401wt.eu-S1030302AbXDTQad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030302AbXDTQad (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 12:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030924AbXDTQad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 12:30:33 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58922 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030302AbXDTQac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 12:30:32 -0400
Date: Fri, 20 Apr 2007 09:30:30 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: William Lee Irwin III <wli@holomorphy.com>
cc: Mel Gorman <mel@skynet.ie>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Paul Jackson <pj@sgi.com>, Dave Chinner <dgc@sgi.com>
Subject: Re: [RFC 7/8] Enhance ramfs to support higher order pages
In-Reply-To: <20070420144726.GI31925@holomorphy.com>
Message-ID: <Pine.LNX.4.64.0704200925160.20232@schroedinger.engr.sgi.com>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
 <20070419163540.11948.51549.sendpatchset@schroedinger.engr.sgi.com>
 <20070420134226.GA16878@skynet.ie> <20070420144726.GI31925@holomorphy.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007, William Lee Irwin III wrote:

> On Fri, Apr 20, 2007 at 02:42:27PM +0100, Mel Gorman wrote:
> > That's fair enough for the moment but relaxing would make ramfs
> > potentially usable as a replacement for hugetlbfs so there would be just
> > one ram-based filesystem instead of two.
> 
> Careful there. mmap() needs more than this.
> 
> (1) mapping->order is variable within an fs, so the architectural code
> 	would need some vague awareness of the underlying page size
> 	being variable unless the fs restricts it properly.

We can map arbitrary 4k chunks of larger pages.

> The hugetlbfs fs stub has by and large been a huge embarrassment to me,
> so I'd welcome the opportunity to foist off the vfs lifting onto ramfs.
> I'd be happier with real superpages, but it's not my kernel.

We are not doing superpages in any form. The filesystem determines it page 
cache size thereby managing pages of arbitrary order. The usual VM 
mmap will work using PAGE_SIZEd mappings as now (once that is working 
right). There is no need to tie the page cache order to the page sizes 
used by mmap or the sizes used by the fault handling of the VM.

