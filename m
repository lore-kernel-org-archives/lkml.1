Return-Path: <linux-kernel-owner+w=401wt.eu-S1757535AbXFSQ6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbXFSQ6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 12:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759736AbXFSQ6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 12:58:44 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:57136 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759722AbXFSQ6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 12:58:43 -0400
Date: Tue, 19 Jun 2007 17:58:41 +0100
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 0/7] Memory Compaction v2
Message-ID: <20070619165841.GG17109@skynet.ie>
References: <20070618092821.7790.52015.sendpatchset@skynet.skynet.ie> <Pine.LNX.4.64.0706181022530.4751@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706181022530.4751@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (18/06/07 10:24), Christoph Lameter didst pronounce:
> On Mon, 18 Jun 2007, Mel Gorman wrote:
> 
> > The patchset implements memory compaction for the page allocator reducing
> > external fragmentation so that free memory exists as fewer, but larger
> > contiguous blocks. Instead of being a full defragmentation solution,
> > this focuses exclusively on pages that are movable via the page migration
> > mechanism.
> 
> We need an additional facility at some point that allows the moving of 
> pages that are not on the LRU. Such support seems to be possible
> for page table pages and slab pages.

Agreed. When I put this together first, I felt I would be able to isolate
pages of different types on migratelist but that is not the case as migration
would not be able to tell the difference between a LRU page and a pagetable
page. I'll rename cc->migratelist to cc->migratelist_lru with the view to
potentially adding cc->migratelist_pagetable or cc->migratelist_slab later.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
