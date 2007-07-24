Return-Path: <linux-kernel-owner+w=401wt.eu-S1761502AbXGXXN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761502AbXGXXN0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 19:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754757AbXGXXNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 19:13:19 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37491 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754441AbXGXXNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 19:13:18 -0400
Date: Tue, 24 Jul 2007 16:12:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mel@skynet.ie>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Daniel Phillips <phillips@google.com>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] add __GFP_ZERO to GFP_LEVEL_MASK
Message-Id: <20070724161247.ee1a2546.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0707241541310.7288@schroedinger.engr.sgi.com>
References: <1185185020.8197.11.camel@twins>
	<20070723112143.GB19437@skynet.ie>
	<1185190711.8197.15.camel@twins>
	<Pine.LNX.4.64.0707231615310.427@schroedinger.engr.sgi.com>
	<1185256869.8197.27.camel@twins>
	<Pine.LNX.4.64.0707240007100.3128@schroedinger.engr.sgi.com>
	<1185261894.8197.33.camel@twins>
	<Pine.LNX.4.64.0707240030110.3295@schroedinger.engr.sgi.com>
	<20070724120751.401bcbcb@schroedinger.engr.sgi.com>
	<20070724122542.d4ac734a.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0707241234460.13653@schroedinger.engr.sgi.com>
	<20070724151046.d8fbb7da.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0707241541310.7288@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2007 16:00:32 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> On Tue, 24 Jul 2007, Andrew Morton wrote:
> 
> > I think I'll duck this for now.  Otherwise I have a suspicion that I'll
> > be the first person to run it and I'm too old for such excitement.
> 
> I always had the suspicion that you have some magical script 
> which will immediately tell you that a patch is not working ;-)

sort of a defensive crouch.

> Works fine on x86_64 (on top of the ctor cleanup patchset) and passes the 
> kernel build test but then there may be creatively designed drivers and 
> such that pass these flags to the slab allocators which will now BUG.

__GFP_COLD looks OK.

__GFP_COMP I'm not so sure about. 
drivers/char/drm/drm_pci.c:drm_pci_alloc() (and other places like infiniband)
pass it into dma_alloc_coherent() which some architectures implement via slab.  umm,
arch/arm/mm/consistent.c is one such.

__GFP_MOVABLE looks OK.

