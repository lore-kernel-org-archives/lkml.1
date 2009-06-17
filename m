Return-Path: <linux-kernel-owner+w=401wt.eu-S1757120AbZFQQxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120AbZFQQxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 12:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbZFQQxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 12:53:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38970 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098AbZFQQxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 12:53:12 -0400
Date: Wed, 17 Jun 2009 18:52:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Catalin Marinas <catalin.marinas@arm.com>, fengguang.wu@intel.com,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: WARNING: at mm/page_alloc.c:1159
	get_page_from_freelist+0x325/0x655()
Message-ID: <20090617165256.GA8143@elte.hu>
References: <200906162232.n5GMWRZe026963@imap1.linux-foundation.org> <20090616223649.719ea378.akpm@linux-foundation.org> <20090617111800.GA15261@elte.hu> <20090617113120.GA5061@elte.hu> <alpine.LFD.2.01.0906170931520.16802@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906170931520.16802@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, 17 Jun 2009, Ingo Molnar wrote:
> > 
> > a new warning started popping up today, in the new page allocator 
> > code. The allocation came from kmemleak:
> 
> We should probably print out the order.
> 
> Right now it warns about any order but 0, and I think that's 
> likely bogus. It's fine to allow small orders (I'd suggest 0-2), 
> since we should always be able to get those, and small kmalloc's 
> generally do want more than one page just to avoid crazy 
> fragmentation issues.
> 
> See, for example, the whole 'slab_break_gfp_order' logic in 
> mm/slab.c: it very much expects to be able to use order-1 
> allocations for kmalloc() if there is enough memory (where 
> "enough" is actually just 32MB). And slub seems to put some limit 
> at PAGE_ALLOC_COSTLY_ORDER (3).
> 
> So apart from anything else (ie this particular case is possibly 
> fixable in kmemleak), I do think that we should likely allow at 
> least order-1 and possible order-2 allocations with __GFP_NOFAIL 
> too.

I saw about half a dozen of different warning patterns during the 
day, so the warning definitely feels a bit over-eager.

	Ingo
