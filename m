Return-Path: <linux-kernel-owner+w=401wt.eu-S1757516AbYGZTux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516AbYGZTux (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 15:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754330AbYGZTup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 15:50:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43572 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753864AbYGZTuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 15:50:44 -0400
Date: Sat, 26 Jul 2008 12:50:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Adrian Bunk <bunk@kernel.org>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] linux/swap.h must #include <linux/pagemap.h>
Message-Id: <20080726125025.465d524b.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0807261852050.582@blonde.site>
References: <1217092685-15267-1-git-send-email-haavard.skinnemoen@atmel.com>
	<20080726173832.GE9301@cs181140183.pp.htv.fi>
	<Pine.LNX.4.64.0807261852050.582@blonde.site>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jul 2008 19:13:43 +0100 (BST) Hugh Dickins <hugh@veritas.com> wrote:

> > /home/bunk/linux/kernel-2.6/git/linux-2.6/include/asm-generic/tlb.h: In function 'tlb_flush_mmu':
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/include/asm-generic/tlb.h:76: error: implicit declaration of function 'release_pages'
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/include/asm-generic/tlb.h: In function 'tlb_remove_page':
> > /home/bunk/linux/kernel-2.6/git/linux-2.6/include/asm-generic/tlb.h:105: error: implicit declaration of function 'page_cache_release'

tlb_finish_mmu() inlines tlb_flush_mmu() and ends up being quite large.

tlb_finish_mmu() has five callsites in core kernel.

The above error is God's way of telling us that it's all too large to
be inlined.

uninlining these things would be a bit of a pita because of the various
arch overrides.  But it really is the right thing to do.

