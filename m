Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab0BMCtb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 21:49:31 -0500
Received: from sh.osrg.net ([192.16.179.4]:37880 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382Ab0BMCt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 21:49:29 -0500
Date: Sat, 13 Feb 2010 11:49:09 +0900
To: akpm@linux-foundation.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       James.Bottomley@suse.de, davem@davemloft.net, jbarnes@virtuousgeek.org,
       arnd@arndb.de
Subject: Re: [PATCH -mm] dma-mapping.h: add the dma_unmap state API
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100212115157.02124608.akpm@linux-foundation.org>
References: <20100212145601W.fujita.tomonori@lab.ntt.co.jp>
	<20100212115157.02124608.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100213114842D.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sat, 13 Feb 2010 11:49:11 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Feb 2010 11:51:57 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> > -#ifdef CONFIG_NEED_DMA_MAP_STATE
> > -#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)        dma_addr_t ADDR_NAME;
> > -#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)          __u32 LEN_NAME;
> 
> But we already screwed up the semicolon thing.  If you grep the tree you'll
> see that about half of the users of this macro added their own semicolon:

Yeah, I know. PCI-DMA-mapping.txt says:

NOTE: DO NOT put a semicolon at the end of the DECLARE_*() macro.


But there are some other DECLARE_ macros that don't have the
semicolons so users could be easily confused.

#define DEFINE_DMA_MAP_ADDR(ADDR_NAME) dma_addr_t ADDR_NAME

looks better?


> ./drivers/net/cxgb3/sge.c:              DECLARE_PCI_UNMAP_ADDR(addr);
> ./drivers/net/skge.h:   DECLARE_PCI_UNMAP_ADDR(mapaddr);
> ./drivers/net/qla3xxx.h:         DECLARE_PCI_UNMAP_ADDR(mapaddr);
> ./drivers/net/qla3xxx.h:         DECLARE_PCI_UNMAP_ADDR(mapaddr);
> ./drivers/net/tg3.h:    DECLARE_PCI_UNMAP_ADDR(mapping)
> 
> 
> Perhaps someone will clean all that up sometime.

I plan to replace these PCI API with the new generic API so I can take
care of them together.
