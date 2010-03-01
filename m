Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751263Ab0CALaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 06:30:00 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:60988 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab0CAL36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 06:29:58 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] sparc: use asm-generic/scatterlist.h
Date: Mon, 1 Mar 2010 12:29:51 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: davem@davemloft.net, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20100226093941C.fujita.tomonori@lab.ntt.co.jp> <20100226.043536.63730567.davem@davemloft.net> <20100301150532R.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100301150532R.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003011229.51399.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19CbHM7xCmBi6BHmRu/rax8D9t6MgTuCcpaakw
 DvRo9ULvLGrFEKV6eUBJ6mn1HtMBAHGBazHuxGlz73tIbXsOgY
 6gmdWISfihnkvDiilmB3w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 March 2010, FUJITA Tomonori wrote:
> On Fri, 26 Feb 2010 04:35:36 -0800 (PST)
> David Miller <davem@davemloft.net> wrote:
>
> You are referring to the following code (I guess that this hack came
> from x86)?
> 
> #if __BITS_PER_LONG == 64
> #define sg_dma_len(sg)          ((sg)->dma_length)
> #else
> #define sg_dma_len(sg)          ((sg)->length)
> #endif /* 64 bit */
> 
> if so, seems that you are right. we could simply have:
> 
> #define sg_dma_len(sg)          ((sg)->dma_length)

I did it the above way so it would work for any architecture that
wants it. IIRC, similar constructs were used in multiple architectures
before, using the __BITS_PER_LONG macro made this portable.
 
> The current users of asm-generic/scatterlist.h are microblaze, s390,
> score, sh, and x86.
> 
> The first three users don't support DMA so sg_dma_len doesn't matter
> for them.
> 
> sh and x86_32 use sg->length, x86_64 uses sg->dma_length. However, sh
> and x86_32 sets dma_length in dma_map_sg() so they can use
> sg->dma_length.
> 
> I'll clean up this in the next merge window.

Ok, great. I think a good way to clean this up would be to convert
all architectures to use asm-generic/scatterlist.h first, and then
move it to linux/scatterlist once it is architecture intedepent.

	Arnd
