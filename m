Return-Path: <linux-kernel-owner+w=401wt.eu-S1756756AbXESBWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756AbXESBWu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 21:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754645AbXESBWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 21:22:43 -0400
Received: from cantor.suse.de ([195.135.220.2]:40635 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754305AbXESBWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 21:22:42 -0400
Date: Sat, 19 May 2007 03:22:35 +0200
From: Nick Piggin <npiggin@suse.de>
To: Hugh Dickins <hugh@veritas.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-arch@vger.kernel.org
Subject: Re: [rfc] increase struct page size?!
Message-ID: <20070519012235.GA15569@wotan.suse.de>
References: <20070518040854.GA15654@wotan.suse.de> <Pine.LNX.4.64.0705181633240.24071@blonde.wat.veritas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705181633240.24071@blonde.wat.veritas.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2007 at 04:42:10PM +0100, Hugh Dickins wrote:
> On Fri, 18 May 2007, Nick Piggin wrote:
> > 
> > If we add 8 bytes to struct page on 64-bit machines, it becomes 64 bytes,
> > which is quite a nice number for cache purposes.
> > 
> > However we don't have to let those 8 bytes go to waste: we can use them
> > to store the virtual address of the page, which kind of makes sense for
> > 64-bit, because they can likely to use complicated memory models.
> 
> Sooner rather than later, don't we need those 8 bytes to expand from
> atomic_t to atomic64_t _count and _mapcount?  Not that we really need
> all 64 bits of both, but I don't know how to work atomically with less.

Yeah, that would be a very good use of it.

 
> (Why do I have this sneaking feeling that you're actually wanting
> to stick something into the lower bits of page->virtual?)

No, I just thought I would get even more flamed if I was just adding
padding that wasn't even doing _anything_ :) I remembered Ken had a
benchmark where page_address was slow, and the rest is history...
