Return-Path: <linux-kernel-owner+w=401wt.eu-S1754899AbZCRTqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbZCRTqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 15:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbZCRTqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 15:46:09 -0400
Received: from gir.skynet.ie ([193.1.99.77]:33379 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbZCRTqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 15:46:08 -0400
Date: Wed, 18 Mar 2009 19:46:04 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 24/27] Convert gfp_zone() to use a table of
	precalculated values
Message-ID: <20090318194604.GD24462@csn.ul.ie>
References: <1237226020-14057-1-git-send-email-mel@csn.ul.ie> <1237226020-14057-25-git-send-email-mel@csn.ul.ie> <alpine.DEB.1.10.0903161500280.20024@qirst.com> <20090318135222.GA4629@csn.ul.ie> <alpine.DEB.1.10.0903181011210.7901@qirst.com> <20090318153508.GA24462@csn.ul.ie> <alpine.DEB.1.10.0903181300540.15570@qirst.com> <20090318181717.GC24462@csn.ul.ie> <alpine.DEB.1.10.0903181507120.10154@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0903181507120.10154@qirst.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 18, 2009 at 03:07:48PM -0400, Christoph Lameter wrote:
> On Wed, 18 Mar 2009, Mel Gorman wrote:
> 
> > Thanks.At a quick glance, it looks ok but I haven't tested it. As the intention
> > was to get one pass of patches that are not controversial and are "obvious",
> > I have dropped my version of the gfp_zone patch and the subsequent flag
> > cleanup and will revisit it after the first lot of patches has been dealt
> > with. I'm testing again with the remaining patches.
> 
> This fixes buggy behavior of gfp_zone so it would deserve a higher
> priority.
> 

It is buggy behaviour in response to a flag combination that makes no sense
which arguably is a buggy caller. Now that I get to think about it a bit more,
you can't define a const table in a header. If it's declared extern, then
the compiler doesn't know what the constant value is so it can't generate
better code.  At best, you end up with equivalent code to what my patch did
in the first place except __GFP_DMA32|__GFP_HIGHMEM will return ZONE_NORMAL.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
