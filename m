Return-Path: <linux-kernel-owner+w=401wt.eu-S1756064AbXFZE45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbXFZE45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 00:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbXFZE4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 00:56:49 -0400
Received: from waste.org ([66.93.16.53]:55350 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbXFZE4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 00:56:48 -0400
Date: Mon, 25 Jun 2007 23:56:35 -0500
From: Matt Mackall <mpm@selenic.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SLOB allocator imcompatible SLAB
Message-ID: <20070626045635.GC11115@waste.org>
References: <m2tzt01kew.wl%ysato@users.sourceforge.jp> <20070622145635.GX11115@waste.org> <m2ejk05y7c.wl%ysato@users.sourceforge.jp> <468090B7.2080200@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <468090B7.2080200@yahoo.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 02:06:15PM +1000, Nick Piggin wrote:
> Yoshinori Sato wrote:
> >At Fri, 22 Jun 2007 09:56:35 -0500,
> >Matt Mackall wrote:
> >
> >>On Fri, Jun 22, 2007 at 05:08:07PM +0900, Yoshinori Sato wrote:
> >>
> >>>Because the page which SLOB allocator got does not have PG_slab,
> >>
> >>This is for a NOMMU system?
> >
> >
> >Yes.
> > 
> >
> >>You're using an old kernel with an old version of SLOB. SLOB in newer
> >>kernels actually sets per-page flags. Nick, can you see any reason not
> >>to s/PG_active/PG_slab/ in the current code?
> 
> The problem with this is that PG_private is used only for the SLOB
> part of the allocator and not the bigblock part.

That's fine, at least for the purposes of kobjsize. We only mark
actual SLOB-managed pages, kobjsize assumes the rest are alloc_pages
and that's indeed what they are.

> We _could_ just bite the bullet and have SLOB set PG_slab, however
> that would encouarage more users of this flag which we should hope
> to get rid of one day.
> 
> The real problem is that nommu wants to get the size of either
> kmalloc or alloc_pages objects and it needs to differentiate
> between them. So I would rather nommu to take its own page flag
> (could overload PG_swapcache, perhaps?), and set that flag on
> pages it allocates directly, then uses that to determine whether
> to call ksize or not.

I think we already established on the last go-round that the kobjsize
scheme was rather hopelessly broken anyway. 

-- 
Mathematics is the supreme nostalgia of our time.
