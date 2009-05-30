Return-Path: <linux-kernel-owner+w=401wt.eu-S1757247AbZE3FvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247AbZE3FvV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 01:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbZE3FvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 01:51:13 -0400
Received: from oblivion.subreption.com ([66.240.236.22]:34280 "EHLO
	mail.subreption.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbZE3FvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 01:51:12 -0400
Date: Fri, 29 May 2009 22:48:56 -0700
From: "Larry H." <research@subreption.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ingo Molnar <mingo@elte.hu>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>,
       pageexec@freemail.hu
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page
	allocator
Message-ID: <20090530054856.GG29711@oblivion.subreption.com>
References: <20090522073436.GA3612@elte.hu> <20090522113809.GB13971@oblivion.subreption.com> <20090522143914.2019dd47@lxorguk.ukuu.org.uk> <20090522180351.GC13971@oblivion.subreption.com> <20090522192158.28fe412e@lxorguk.ukuu.org.uk> <20090522234031.GH13971@oblivion.subreption.com> <20090523090910.3d6c2e85@lxorguk.ukuu.org.uk> <20090523085653.0ad217f8@infradead.org> <1243539361.6645.80.camel@laptop> <20090529073217.08eb20e1@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090529073217.08eb20e1@infradead.org>
Organization: Subreption LLC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07:32 Fri 29 May     , Arjan van de Ven wrote:
> On Thu, 28 May 2009 21:36:01 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > > ... and if we zero on free, we don't need to zero on allocate.
> > > While this is a little controversial, it does mean that at least
> > > part of the cost is just time-shifted, which means it'll not be TOO
> > > bad hopefully...
> > 
> > zero on allocate has the advantage of cache hotness, we're going to
> > use the memory, why else allocate it.

Because zero on allocate kills the very purpose of this patch and it has
obvious security implications. Like races (in information leak
scenarios, that is). What happens in-between the release of the page and
the new allocation that yields the same page? What happens if no further
allocations happen in a while (that can return the old page again)?
That's the idea.

> that is why I said it's controversial.
> 
> BUT if you zero on free anyway...
> 
> And I don't think it's as big a deal as you make it.
> Why?
> 
> We recycle pages in LIFO order. And L2 caches are big.
> 
> So if you zero on free, the next allocation will reuse the zeroed page.
> And due to LIFO that is not too far out "often", which makes it likely
> the page is still in L2 cache.

Thanks for pointing this out clearly, Arjan.

> The other thing is that zero-on-allocate puts the WHOLE page in L1,
> while you can study how much of that page is actually used on average,
> and it'll be a percentage lower than 100%.
> In fact, if it IS 100%, you shouldn't have put it in L1 because the app
> does that anyway. If it is not 100% you just blew a chunk of your L1
> for no value.
> 
> Don't get me wrong, I'm not arguing that zero-on-free is better, I'm
> just trying to point out that the "advantage" of zero-on-allocate isn't
> nearly as big as people sometimes think it is...

Performance-wise, I agree with you here. Security-wise, I assure
you that clearing on allocation time is most certainly hopeless.

If there's further room for improvement in the patch, and something can
be optimized, I will do my best with it. I won't be able to provide any
updates until Sunday, likely. I'll do a kernbench, if someone has
further benchmarks to suggest, please let me know.

	Larry

