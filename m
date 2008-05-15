Return-Path: <linux-kernel-owner+w=401wt.eu-S1759200AbYEOXLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759200AbYEOXLb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 19:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbYEOXLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 19:11:18 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40311 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750860AbYEOXLR (ORCPT
	<rfc822;@sgi.com:linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 19:11:17 -0400
Date: Fri, 16 May 2008 09:10:45 +1000
From: David Chinner <dgc@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: David Chinner <dgc@sgi.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, andi@firstfloor.org,
       Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       mpm@selenic.com
Subject: Re: [patch 10/21] buffer heads: Support slab defrag
Message-ID: <20080515231045.GY155679365@sgi.com>
References: <20080510030831.796641881@sgi.com> <20080510030916.935905242@sgi.com> <20080512002403.GP103491721@sgi.com> <Pine.LNX.4.64.0805151041230.18708@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805151041230.18708@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 10:42:15AM -0700, Christoph Lameter wrote:
> On Mon, 12 May 2008, David Chinner wrote:
> 
> > If you are going to clean bufferheads (or pages), please clean entire
> > mappings via ->writepages as it leads to far superior I/O patterns
> > and a far higher aggregate rate of page cleaning.....
> 
> That brings up another issue: Lets say I use writepages on a large file 
> (couple of gig). How much do you want to write back?

We're out of memory. I'd suggest write backing as much as you can
without blocking.  e.g. treat it like pdflush and say 1024 pages, or
like balance_dirty_pages() and write a 'write_chunk' back from the
mapping (i.e.  sync_writeback_pages()).

Any of these are better from an I/O perspective than single page
writeback....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
