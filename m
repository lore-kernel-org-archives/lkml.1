Return-Path: <linux-kernel-owner+w=401wt.eu-S1759469AbZFBGzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759469AbZFBGzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 02:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758662AbZFBGzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 02:55:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52752 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758499AbZFBGzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 02:55:42 -0400
Date: Tue, 2 Jun 2009 08:55:34 +0200
From: Nick Piggin <npiggin@suse.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: mingo@elte.hu, cl@linux-foundation.com, torvalds@linux-foundation.org,
       mpm@selenic.com, yinghai@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] init: call vfs_caches_init_early() later in the boot sequence
Message-ID: <20090602065534.GC31556@wotan.suse.de>
References: <1243517365.11533.65.camel@penberg-laptop> <20090601130825.GA1422@wotan.suse.de> <84144f020906012348r749f7cfbk3cf7112e6263299b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020906012348r749f7cfbk3cf7112e6263299b@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 09:48:32AM +0300, Pekka Enberg wrote:
> Hi Nick,
> 
> [ I see I typo'd Linus' email address in the original patch submission... ]
> 
> On Thu, May 28, 2009 at 04:29:25PM +0300, Pekka Enberg wrote:
> >> From: Pekka Enberg <penberg@cs.helsinki.fi>
> >>
> >> There's no need to call vfs_caches_init_early() before kmem_cache_init(). All
> >> we have to do is make sure we don't attempt to use the bootmem allocator after
> >> we've called mem_init().
> 
> On Mon, Jun 1, 2009 at 4:08 PM, Nick Piggin <npiggin@suse.de> wrote:
> > Hmm, but you'd want to be able to allocate > MAX_ORDER areas in the linear
> > KVA, which the page allocator cannot do. So this is just going to silently
> > truncate hash table size. Nack on this one.
> 
> OK, makes sense. IIRC, Linus suggested doing this but I think I'll
> just revert the patch.

What might be interesting to do is to be able to switch the bootmem
allocator to be able to run after the page allocator comes up (it
would have to have a few hooks to put pages on and off the buddy
lists, but should be possible). Then you could do these kinds of
large allocations later (or set up allocators earlier).

But that might not be worth the complexity and churn just for these
couple of cases...
