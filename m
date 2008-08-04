Return-Path: <linux-kernel-owner+w=401wt.eu-S1762874AbYHDT4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762874AbYHDT4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 15:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759760AbYHDTzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 15:55:46 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:37172 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbYHDTzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 15:55:45 -0400
Date: Mon, 4 Aug 2008 20:55:44 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Keith Packard <keithp@keithp.com>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Hellwig <hch@infradead.org>, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Export shmem_file_setup and shmem_getpage for DRM-GEM
In-Reply-To: <1217877645.24714.87.camel@koto.keithp.com>
Message-ID: <Pine.LNX.4.64.0808042055240.17041@blonde.site>
References: <1217573919-7496-1-git-send-email-eric@anholt.net> 
 <200808041902.23970.nickpiggin@yahoo.com.au>  <1217845590.24714.45.camel@koto.keithp.com>
  <200808042043.46710.nickpiggin@yahoo.com.au>  <1217850352.24714.66.camel@koto.keithp.com>
  <Pine.LNX.4.64.0808041720500.25617@blonde.site>  <1217870748.24714.79.camel@koto.keithp.com>
  <Pine.LNX.4.64.0808041855050.5717@blonde.site> <1217877645.24714.87.camel@koto.keithp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Aug 2008, Keith Packard wrote:
> On Mon, 2008-08-04 at 19:39 +0100, Hugh Dickins wrote:
> > For how long are these objects' pages pinned in memory like this?
> 
> Forever? The only reason an object would get unpinned would be on
> eviction from the GTT, and objects will only be evicted if we fill the
> aperture with other stuff. When we add a register_shrinker callback,
> we'll also unpin pages at that point.
> 
> A busy system should have the GTT entirely full, and that will be
> somewhere between 256MB and 1GB.

Okay, thanks for the warning.  It sounds like the shrinker will be
important, but we'll also need to mark those pages as unevictable
while they're unshrunk.  (Usually when drivers grab a large number
of pages, they're not on any LRU to begin with: you're being nice
by choosing swappable LRU pages - in the tmpfs case - but enough
to upset the balance while they're not swappable.)  Offhand I can't
say what will be the appropriate way to do that, it's something we
need to revisit later (from your point of view it should amount to
one function call or flag set somewhere, not any grand redesign).

Hugh
