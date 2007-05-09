Return-Path: <linux-kernel-owner+w=401wt.eu-S1033282AbXEIB1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033282AbXEIB1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 21:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031703AbXEIB1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 21:27:35 -0400
Received: from waste.org ([66.93.16.53]:59202 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755653AbXEIB1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 21:27:35 -0400
Date: Tue, 8 May 2007 20:27:25 -0500
From: Matt Mackall <mpm@selenic.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: + fix-spellings-of-slab-allocator-section-in-init-kconfig.patch added to -mm tree
Message-ID: <20070509012725.GZ11115@waste.org>
References: <200705082302.l48N2KrZ004229@shell0.pdx.osdl.net> <20070509002307.GV11115@waste.org> <Pine.LNX.4.64.0705081746500.16914@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705081746500.16914@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 05:51:27PM -0700, Christoph Lameter wrote:
> On Tue, 8 May 2007, Matt Mackall wrote:
> 
> > First, SLOB no longer runs on SMP because SLAB grew some RCU-related
> > hair. So it now effectively has no locks at all! 
> 
> Well it seems that SLOB was not well maintained. RCU has been around for a 
> long time and SLOB has not been updated to cope with it.

RCU's incursion into SLAB that broke SLOB is relatively new. And it
only broke for people using SMP or SPARSEMEM. Intersection with target
audience of SLOB: ~0.
  
> > Third, I don't think it's possible even in theory for a SLAB-like
> > allocator to be as efficient as SLOB simply due to the constraints of
> > putting only objects of the same size on a given page. So consider me
> > skeptical on the density claim.
> 
> SLUB can put 32 objects sized 128 byte each in a 4k page. Can SLOB do 
> the same?

Yes. It can in fact put 512 8-byte objects in a 4k page. More
importantly, it can put 2 1k objects and 16 128-byte objects on the
same page instead of on two pages.

> > It is usually better to use SLUB simply because you're more likely to
> > have 1GB of RAM rather than 4MB.
> 
> SLUB should be perfectly fine for that environment provided you 
> adjust the cacheline alignment and switch off SLUB debugging. 
> define L1_CACHE_BYTES to be 4 or so.

Perhaps. We'll need to look at some numbers.

-- 
Mathematics is the supreme nostalgia of our time.
