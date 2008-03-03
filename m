Return-Path: <linux-kernel-owner+w=401wt.eu-S1759720AbYCCDPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759720AbYCCDPl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 22:15:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756514AbYCCDPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 22:15:31 -0500
Received: from n3b.bullet.mail.ac4.yahoo.com ([76.13.13.73]:31269 "HELO
	n3b.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756186AbYCCDPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 22:15:30 -0500
X-Yahoo-Newman-Id: 772274.23078.bm@omp417.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=O17MldyCAbFpFGebqkNnXMYkpkOWvjEvs69mKnv3iXRfr442STYatWwrO91VzrOIvTO6sGxG+/YEeAOSrfcHvZaYhpN600Q354V+8l6v1IDXi1yOHsEsCqsmd0f+SsO1PXPg5teVE5kCWaQP4wvtshtht6nD8ITz7jh4t9nV0o8=  ;
X-YMail-OSG: LT0VftsVM1mI_8jv1_lshGwrSt8vkTrJBy5zRtwuJXChyXw4zX73P32gap69QXqZhcDjGqj1Cg--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH] alloc_percpu() fails to allocate percpu data
Date: Mon, 3 Mar 2008 14:14:42 +1100
User-Agent: KMail/1.9.5
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Eric Dumazet <dada1@cosmosbay.com>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
References: <47BDBC23.10605@cosmosbay.com> <200802232023.52352.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0802271140470.1790@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0802271140470.1790@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803031414.43076.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 February 2008 06:44, Christoph Lameter wrote:
> On Sat, 23 Feb 2008, Nick Piggin wrote:
> > What I don't understand is why the slab allocators have something like
> > this in it:
> >
> >         if ((flags & SLAB_HWCACHE_ALIGN) &&
> >                         size > cache_line_size() / 2)
> >                 return max_t(unsigned long, align, cache_line_size());
> >
> > If you ask for HWCACHE_ALIGN, then you should get it. I don't
> > understand, why do they think they knows better than the caller?
>
> Tradition.... Its irks me as well.
>
> > Things like this are just going to lead to very difficult to track
> > performance problems. Possibly correctness problems in rare cases.
> >
> > There could be another flag for "maybe align".
>
> SLAB_HWCACHE_ALIGN *is* effectively a maybe align flag given the above
> code.
>
> If we all agree then we could change this to have must have semantics? It
> has the potential of enlarging objects for small caches.
>
> SLAB_HWCACHE_ALIGN has an effect that varies according to the alignment
> requirements of the architecture that the kernel is build on. We may be in
> for some surprises if we change this.

I think so. If we ask for HWCACHE_ALIGN, it must be for a good reason.
If some structures get too bloated for no good reason, then the problem
is not with the slab allocator but with the caller asking for
HWCACHE_ALIGN.


