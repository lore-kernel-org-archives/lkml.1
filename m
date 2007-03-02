Return-Path: <linux-kernel-owner+w=401wt.eu-S1422857AbXCBEWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422857AbXCBEWs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 23:22:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422854AbXCBEWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 23:22:48 -0500
Received: from smtp.ocgnet.org ([64.20.243.3]:34697 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422856AbXCBEWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 23:22:46 -0500
Date: Fri, 2 Mar 2007 13:20:13 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Christoph Lameter <clameter@engr.sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@skynet.ie>,
       mingo@elte.hu, jschopp@austin.ibm.com, arjan@infradead.org,
       torvalds@linux-foundation.org, mbligh@mbligh.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: The performance and behaviour of the anti-fragmentation related patches
Message-ID: <20070302042013.GA12669@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Nick Piggin <npiggin@suse.de>,
	Christoph Lameter <clameter@engr.sgi.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mel Gorman <mel@skynet.ie>, mingo@elte.hu, jschopp@austin.ibm.com,
	arjan@infradead.org, torvalds@linux-foundation.org,
	mbligh@mbligh.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20070301101249.GA29351@skynet.ie> <20070301160915.6da876c5.akpm@linux-foundation.org> <Pine.LNX.4.64.0703011854540.5530@schroedinger.engr.sgi.com> <20070302035751.GA15867@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070302035751.GA15867@wotan.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2007 at 04:57:51AM +0100, Nick Piggin wrote:
> On Thu, Mar 01, 2007 at 07:05:48PM -0800, Christoph Lameter wrote:
> > On Thu, 1 Mar 2007, Andrew Morton wrote:
> > > For prioritisation purposes I'd judge that memory hot-unplug is of similar
> > > value to the antifrag work (because memory hot-unplug permits DIMM
> > > poweroff).
> > 
> > I would say that anti-frag / defrag enables memory unplug.
> 
> Well that really depends. If you want to have any sort of guaranteed
> amount of unplugging or shrinking (or hugepage allocating), then antifrag
> doesn't work because it is a heuristic.
> 
> One thing that worries me about anti-fragmentation is that people might
> actually start _using_ higher order pages in the kernel. Then fragmentation
> comes back, and it's worse because now it is not just the fringe hugepage or
> unplug users (who can anyway work around the fragmentation by allocating
> from reserve zones).
> 
There's two sides to that, the ability to use higher order pages in the
kernel also means that it's possible to use larger TLB entries while
keeping the base page size small, too. There are already many places in
the kernel that attempt to use the largest possible size when setting up
the entries, and this is something that those of us with tiny
software-managed TLBs are a huge fan of -- some platforms have even opted
to do perverse things such as scanning for contiguous PTEs and bumping to
the next order automatically at set_pte() time.

Unplug is also interesting from a power management point of view.
Powering off is still more attractive than self-refresh, for example, but
could also be used at run-time depending on the workload.
