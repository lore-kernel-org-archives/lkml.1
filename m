Return-Path: <linux-kernel-owner+w=401wt.eu-S1757924AbYGZUQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924AbYGZUQU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 16:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757580AbYGZUQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 16:16:12 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:46372 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757524AbYGZUQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 16:16:11 -0400
Date: Sat, 26 Jul 2008 21:15:47 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andrew Morton <akpm@linux-foundation.org>
cc: Adrian Bunk <bunk@kernel.org>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       Ben Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] linux/swap.h must #include <linux/pagemap.h>
In-Reply-To: <20080726125025.465d524b.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0807262104060.13201@blonde.site>
References: <1217092685-15267-1-git-send-email-haavard.skinnemoen@atmel.com>
 <20080726173832.GE9301@cs181140183.pp.htv.fi> <Pine.LNX.4.64.0807261852050.582@blonde.site>
 <20080726125025.465d524b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jul 2008, Andrew Morton wrote:
> On Sat, 26 Jul 2008 19:13:43 +0100 (BST) Hugh Dickins <hugh@veritas.com> wrote:
> 
> > > /home/bunk/linux/kernel-2.6/git/linux-2.6/include/asm-generic/tlb.h: In function 'tlb_flush_mmu':
> > > /home/bunk/linux/kernel-2.6/git/linux-2.6/include/asm-generic/tlb.h:76: error: implicit declaration of function 'release_pages'
> > > /home/bunk/linux/kernel-2.6/git/linux-2.6/include/asm-generic/tlb.h: In function 'tlb_remove_page':
> > > /home/bunk/linux/kernel-2.6/git/linux-2.6/include/asm-generic/tlb.h:105: error: implicit declaration of function 'page_cache_release'
> 
> tlb_finish_mmu() inlines tlb_flush_mmu() and ends up being quite large.
> 
> tlb_finish_mmu() has five callsites in core kernel.
> 
> The above error is God's way of telling us that it's all too large to
> be inlined.
> 
> uninlining these things would be a bit of a pita because of the various
> arch overrides.  But it really is the right thing to do.

Yes, that's a good point too.  They could be put in arch/*/mm/somewhere.c.

But I'd rather put that off even further into the future, because there's
quite a bit of rationalization to be done (more arch differences than
necessary), and Ben's the one currently holding our reorganize-mmu_gather
ball.  (I keep pointing to you, Ben, please don't think I'm accusing at
all: I'm the guilty one who held it and did nothing with it before.)

I'm still in favour the quick fs/exec.c build fixup for now.

Hugh
