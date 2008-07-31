Return-Path: <linux-kernel-owner+w=401wt.eu-S1756289AbYGaMlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289AbYGaMlz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 08:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbYGaMkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 08:40:46 -0400
Received: from relay1.sgi.com ([192.48.171.29]:51445 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754739AbYGaMko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 08:40:44 -0400
Date: Thu, 31 Jul 2008 07:40:39 -0500
From: Jack Steiner <steiner@sgi.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Robin Holt <holt@sgi.com>,
       "Torvalds, Linus" <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: GRU driver feedback
Message-ID: <20080731124039.GA27329@sgi.com>
References: <20080723141229.GB13247@wotan.suse.de> <20080729185315.GA14260@sgi.com> <200807301550.34500.nickpiggin@yahoo.com.au> <200807311714.05252.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807311714.05252.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 05:14:04PM +1000, Nick Piggin wrote:
> On Wednesday 30 July 2008 15:50, Nick Piggin wrote:
> > On Wednesday 30 July 2008 04:53, Robin Holt wrote:
> 
> > > In the case where unmap_region is clearing page tables, the caller to
> > > unmap_region is expected to be holding the mmap_sem writably.  Jacks
> > > fault handler will immediately return when it fails on the
> > > down_read_trylock().
> >
> > No, you are right of course. I had in my mind the problems faced by
> > lockless get_user_pages, in which case I was worried about the page table
> > existence, but missed the fact that you're holding mmap_sem to provide
> > existence (which it would, as you note, although one day we may want to
> > reclaim page tables or something that doesn't take mmap_sem, so a big
> > comment would be nice here).
> 
> The other thing is... then GRU should get rid of the local_irq_disable
> in the atomic pte lookup. By definition it is worthless if we can be
> operating on an mm that is not running on current (and if I understand
> correctly, sn2 can avoid sending tlb flush IPIs completely sometimes?)

Done.

I'm collecting the fixes & additional comments to be added & will send
them upstream later.

Thanks for the careful review.


--- jack
