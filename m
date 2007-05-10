Return-Path: <linux-kernel-owner+w=401wt.eu-S1762912AbXEJWQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762912AbXEJWQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 18:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760752AbXEJWQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 18:16:11 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:49112 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760004AbXEJWQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 18:16:10 -0400
X-Greylist: delayed 549 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 May 2007 18:16:10 EDT
Date: Thu, 10 May 2007 23:16:07 +0100
To: Christoph Lameter <clameter@sgi.com>
Cc: Mel Gorman <mel@skynet.skynet.ie>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Nicolas.Mailhot@LaPoste.net,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>
Subject: Re: [Bug 8464] New: autoreconf: page allocation failure. order:2, mode:0x84020
Message-ID: <20070510221607.GA15084@skynet.ie>
References: <200705102128.l4ALSI2A017437@fire-2.osdl.org> <20070510144319.48d2841a.akpm@linux-foundation.org> <Pine.LNX.4.64.0705101447120.12874@schroedinger.engr.sgi.com> <20070510220657.GA14694@skynet.ie> <Pine.LNX.4.64.0705101510500.13404@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705101510500.13404@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (10/05/07 15:11), Christoph Lameter didst pronounce:
> On Thu, 10 May 2007, Mel Gorman wrote:
> 
> > I see the gfpmask was 0x84020. That doesn't look like __GFP_WAIT was set,
> > right? Does that mean that SLUB is trying to allocate pages atomically? If so,
> > it would explain why this situation could still occur even though high-order
> > allocations that could sleep would succeed.
> 
> SLUB is following the gfp mask of the caller like all well behaved slab 
> allocators do. If the caller does not set __GFP_WAIT then the page 
> allocator also cannot wait.

Then SLUB should not use the higher orders for slab allocations that cannot
sleep during allocations. What could be done in the longer term is decide
how to tell kswapd to keep pages free at an order other than 0 when it is
known there are a large number of high-order long-lived allocations like this.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
