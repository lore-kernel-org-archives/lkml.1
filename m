Return-Path: <linux-kernel-owner+w=401wt.eu-S1760198AbXK3JOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760198AbXK3JOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 04:14:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbXK3JOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 04:14:06 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:48653 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbXK3JOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 04:14:04 -0500
Date: Fri, 30 Nov 2007 11:14:01 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] Fix kmem_cache_free performance regression in slab
In-Reply-To: <20071129184539.ba6342b8.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0711301110540.28494@sbz-30.cs.Helsinki.FI>
References: <20071129190513.GD2584@parisc-linux.org>
 <20071129184539.ba6342b8.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 29 Nov 2007 12:05:13 -0700 Matthew Wilcox <matthew@wil.cx> wrote:
> > The database performance group have found that half the cycles spent
> > in kmem_cache_free are spent in this one call to BUG_ON.  Moving it
> > into the CONFIG_SLAB_DEBUG-only function cache_free_debugcheck() is a
> > performance win of almost 0.5% on their particular benchmark.
> > 
> > The call was added as part of commit ddc2e812d592457747c4367fb73edcaa8e1e49ff
> > with the comment that "overhead should be minimal".  It may have been
> > minimal at the time, but it isn't now.
> > 

On Thu, 29 Nov 2007, Andrew Morton wrote:
> It is worth noting that the offending commit hit mainline in June 2006.
> 
> It takes a very long time for some performance regressions to be
> discovered.  By which time it is effectively too late to fix it.

What architecture is this? x86_64? I don't think the BUG_ON per se caused 
the performance regression but rather the virt_to_head_page() changes to 
virt_to_cache() that were added later. But reverting the BUG_ON is fine by 
me.

Thanks Matthew and others for tracking this down!

				Pekka
