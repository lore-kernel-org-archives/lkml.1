Return-Path: <linux-kernel-owner+w=401wt.eu-S1762330AbXEJWfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762330AbXEJWfY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 18:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758206AbXEJWfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 18:35:13 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:56069 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954AbXEJWfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 18:35:11 -0400
Date: Thu, 10 May 2007 23:06:57 +0100
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Nicolas.Mailhot@LaPoste.net,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>
Subject: Re: [Bug 8464] New: autoreconf: page allocation failure. order:2, mode:0x84020
Message-ID: <20070510220657.GA14694@skynet.ie>
References: <200705102128.l4ALSI2A017437@fire-2.osdl.org> <20070510144319.48d2841a.akpm@linux-foundation.org> <Pine.LNX.4.64.0705101447120.12874@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705101447120.12874@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (10/05/07 14:49), Christoph Lameter didst pronounce:
> On Thu, 10 May 2007, Andrew Morton wrote:
> 
> > Christoph, can we please take a look at /proc/slabinfo and its slub
> > equivalent (I forget what that is?) and review any and all changes to the
> > underlying allocation size for each cache?
> > 
> > Because this is *not* something we should change lightly.
> 
> It was changed specially for mm in order to stress the antifrag code. If 
> this causes trouble then do not merge the patches against SLUB that 
> exploit the antifrag methods. This failure should help see how effective 
> Mel's antifrag patches are. He needs to get on this dicussion.
> 

The antfrag mechanism depends on the caller being able to sleep and reclaim
pages if necessary to get the contiguous allocation. No attempts are being
currently made to keep pages at a particular order free.

I see the gfpmask was 0x84020. That doesn't look like __GFP_WAIT was set,
right? Does that mean that SLUB is trying to allocate pages atomically? If so,
it would explain why this situation could still occur even though high-order
allocations that could sleep would succeed.

> Upstream has slub_max_order=1.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
