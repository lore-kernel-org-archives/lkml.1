Return-Path: <linux-kernel-owner+w=401wt.eu-S934606AbXK3Cqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934606AbXK3Cqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 21:46:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759161AbXK3CqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 21:46:20 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50443 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758190AbXK3CqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 21:46:20 -0500
Date: Thu, 29 Nov 2007 18:45:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] Fix kmem_cache_free performance regression in slab
Message-Id: <20071129184539.ba6342b8.akpm@linux-foundation.org>
In-Reply-To: <20071129190513.GD2584@parisc-linux.org>
References: <20071129190513.GD2584@parisc-linux.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007 12:05:13 -0700 Matthew Wilcox <matthew@wil.cx> wrote:

> The database performance group have found that half the cycles spent
> in kmem_cache_free are spent in this one call to BUG_ON.  Moving it
> into the CONFIG_SLAB_DEBUG-only function cache_free_debugcheck() is a
> performance win of almost 0.5% on their particular benchmark.
> 
> The call was added as part of commit ddc2e812d592457747c4367fb73edcaa8e1e49ff
> with the comment that "overhead should be minimal".  It may have been
> minimal at the time, but it isn't now.
> 

It is worth noting that the offending commit hit mainline in June 2006.

It takes a very long time for some performance regressions to be
discovered.  By which time it is effectively too late to fix it.

