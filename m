Return-Path: <linux-kernel-owner+w=401wt.eu-S933479AbXBEVkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933479AbXBEVkp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 16:40:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933478AbXBEVkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 16:40:45 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35052
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933484AbXBEVko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 16:40:44 -0500
Date: Mon, 05 Feb 2007 13:40:43 -0800 (PST)
Message-Id: <20070205.134043.115908090.davem@davemloft.net>
To: mathieu.desnoyers@polymtl.ca
Cc: linux-kernel@vger.kernel.org, torvalds@osdl.org, akpm@osdl.org
Subject: Re: [PATCH] Include missing header in include/asm-sparc64/tlb.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070205.133137.126764360.davem@davemloft.net>
References: <20070205175714.GA8341@Krystal>
	<20070205.133137.126764360.davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Mon, 05 Feb 2007 13:31:37 -0800 (PST)

> From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Date: Mon, 5 Feb 2007 12:57:14 -0500
> 
> > Include missing header in include/asm-sparc64/tlb.h
> > 
> > sparc64 does not compile without this. It applies on 2.6.20.
> > 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> 
> It builds perfectly fine for me with several different config variants
> without adding this include.
> 
> Please provide the build failure messages and your kernel config so
> this can be properly analyzed, thank you.

BTW, I did an analysis of asm-sparc64/tlb.h and it needs two
MM layer structure definitions or forward declarations related
to pages:

1) struct page.  But it just declares pointers, it never
   dereferences a struct page.

2) free_pages_and_swap_cache().

Both should be handled by the linux/swap.h include, linux/swap.h
makes use of "struct page" pointers in declarations and it provides
the extern for free_pages_and_swap_cache().

So why does include/asm-sparc64/tlb.h need to include linux/pagemap.h?

This would be easy to figure out if you had provided the build error
messages that prompted this change from the beginning.

Perhaps you have a local change of some kind that creates this
requirement?  Or did you see "free_pages_and_swap_cache()" and
think that function is declared in linux/pagemap.h instead of
it's true location which is linux/swap.h?

Thank you.
