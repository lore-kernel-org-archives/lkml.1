Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab0CAGFz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 01:05:55 -0500
Received: from sh.osrg.net ([192.16.179.4]:36275 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139Ab0CAGFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 01:05:53 -0500
Date: Mon, 1 Mar 2010 15:05:48 +0900
To: davem@davemloft.net
Cc: fujita.tomonori@lab.ntt.co.jp, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc: use asm-generic/scatterlist.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100226.043536.63730567.davem@davemloft.net>
References: <20100226093941C.fujita.tomonori@lab.ntt.co.jp>
	<20100226.043536.63730567.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100301150532R.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 01 Mar 2010 15:05:48 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Feb 2010 04:35:36 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Date: Fri, 26 Feb 2010 09:43:51 +0900
> 
> > sparc's scatterlist structure is identical to the generic one.
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> 
> Applied, thank you.

Thanks,

> BTW, the conditional sg_dma_len() definition cpp games done
> in asm-generic/scatterlist.h might be superfluous these days.

You are referring to the following code (I guess that this hack came
from x86)?

#if __BITS_PER_LONG == 64
#define sg_dma_len(sg)		((sg)->dma_length)
#else
#define sg_dma_len(sg)		((sg)->length)
#endif /* 64 bit */

if so, seems that you are right. we could simply have:

#define sg_dma_len(sg)		((sg)->dma_length)

The current users of asm-generic/scatterlist.h are microblaze, s390,
score, sh, and x86.

The first three users don't support DMA so sg_dma_len doesn't matter
for them.

sh and x86_32 use sg->length, x86_64 uses sg->dma_length. However, sh
and x86_32 sets dma_length in dma_map_sg() so they can use
sg->dma_length.

I'll clean up this in the next merge window.
