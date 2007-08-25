Return-Path: <linux-kernel-owner+w=401wt.eu-S1754980AbXHYDer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbXHYDer (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 23:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbXHYDek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 23:34:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47799 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751733AbXHYDej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 23:34:39 -0400
Date: Fri, 24 Aug 2007 20:34:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Dike <jdike@addtoit.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Rob Landley <rob@landley.net>
Subject: Re: [PATCH] include linux/pagemap.h in asm-generic/tlb.h
Message-Id: <20070824203424.8b47ff73.akpm@linux-foundation.org>
In-Reply-To: <20070825021533.GA12544@c2.user-mode-linux.org>
References: <20070824184616.GA9442@c2.user-mode-linux.org>
	<20070824172027.0ad5d2c0.akpm@linux-foundation.org>
	<20070825021533.GA12544@c2.user-mode-linux.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2007 22:15:33 -0400 Jeff Dike <jdike@addtoit.com> wrote:

> > So I think a better fix would be better, but I'm not able to suggest what,
> > as there is little detail about the failure here and I can find no mention
> > of page_cache_release and release_pages in asm-generic/tlb.h.  Presumably
> > they're getting pulled in via some macro and then instantiated in some
> > inline function or something?
> 
> Yes, it's straightforward - 
> 
> tlb.h:
> 
> static inline void
> tlb_flush_mmu(struct mmu_gather *tlb, unsigned long start, unsigned long end)
> {
> 	...
> 		free_pages_and_swap_cache(tlb->pages, tlb->nr);
> 	...
> }
> 
> swap.h:
> #define free_pages_and_swap_cache(pages, nr) \
> 	release_pages((pages), (nr), 0);

Oh that damn thing again.  It's a regular source of include breakage.

I suppose we could just uninline tlb_flush_mmu().
