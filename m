Return-Path: <linux-kernel-owner+w=401wt.eu-S1757846AbXESBa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846AbXESBa1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 21:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754303AbXESBaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 21:30:19 -0400
Received: from cantor.suse.de ([195.135.220.2]:40989 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170AbXESBaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 21:30:18 -0400
Date: Sat, 19 May 2007 03:30:13 +0200
From: Nick Piggin <npiggin@suse.de>
To: David Howells <dhowells@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-arch@vger.kernel.org
Subject: Re: [rfc] increase struct page size?!
Message-ID: <20070519013013.GC15569@wotan.suse.de>
References: <20070518040854.GA15654@wotan.suse.de> <7554.1179481350@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7554.1179481350@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2007 at 10:42:30AM +0100, David Howells wrote:
> Nick Piggin <npiggin@suse.de> wrote:
> 
> > I'd like to be the first to propose an increase to the size of struct page
> > just for the sake of increasing it!
> 
> Heh.  I'm surprised you haven't got more adverse reactions.
> 
> > If we add 8 bytes to struct page on 64-bit machines, it becomes 64 bytes,
> > which is quite a nice number for cache purposes.
> 
> Whilst that's true, if you have to deal with a run of contiguous page structs
> (eg: the page allocator, perhaps) it's actually less efficient because it
> takes more cache to do it.  But, hey, it's a compromise whatever.
> 
> In the scheme of things, if we're mostly dealing with individual page structs
> (as I think we are), then yes, I think it's probably a good thing to do -
> especially with larger page sizes.

Yeah, we would end up eating about 12.5% more cachelines for contiguous
runs of pages... but that only kicks in after we've touched 8 of them I
think, and by that point the accesses should be very prefetchable.

I think the average of 75% more cachelines touched for random accesses
is going to outweigh the contiguous batch savings, but that's just a
guess at this point.
