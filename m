Return-Path: <linux-kernel-owner+w=401wt.eu-S1758132AbXHMMdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132AbXHMMdG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:33:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933777AbXHMGzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:55:49 -0400
Received: from dsl081-085-152.lax1.dsl.speakeasy.net ([64.81.85.152]:52148
	"EHLO moonbase.phunq.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S937558AbXHMGzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:55:47 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 02/10] mm: system wide ALLOC_NO_WATERMARK
Date: Sun, 12 Aug 2007 23:55:34 -0700
User-Agent: KMail/1.9.5
Cc: Daniel Phillips <daniel.raymond.phillips@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>
References: <20070806102922.907530000@chello.nl> <4a5909270708100115v4ad10c4es697d216edf29b07d@mail.gmail.com> <Pine.LNX.4.64.0708101041040.12758@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0708101041040.12758@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708122355.34652.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 August 2007 10:46, Christoph Lameter wrote:
> On Fri, 10 Aug 2007, Daniel Phillips wrote:
> > It is quite clear what is in your patch.  Instead of just grabbing
> > a page off the buddy free lists in a critical allocation situation
> > you go invoke shrink_caches.  Why oh why?  All the memory needed to
> > get
>
> Because we get to the code of interest when we have no memory on the
> buddy free lists...

Ah wait, that statement is incorrect and may well be the crux of your 
misunderstanding.  Buddy free lists are not exhausted until the entire 
memalloc reserve has been depleted, which would indicate a kernel bug 
and imminent system death.

> ...and need to reclaim memory to fill them up again. 

That we do, but we satisfy the allocations in the vm writeout path 
first, without waiting for shrink_caches to do its thing.

Regards,

Daniel
