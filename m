Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab0BMEoX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 23:44:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51648 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753413Ab0BMEoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 23:44:21 -0500
Date: Fri, 12 Feb 2010 20:44:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, James.Bottomley@suse.de, davem@davemloft.net,
       jbarnes@virtuousgeek.org, arnd@arndb.de
Subject: Re: [PATCH -mm] dma-mapping.h: add the dma_unmap state API
Message-Id: <20100212204405.a7f45db3.akpm@linux-foundation.org>
In-Reply-To: <20100213114842D.fujita.tomonori@lab.ntt.co.jp>
References: <20100212145601W.fujita.tomonori@lab.ntt.co.jp>
	<20100212115157.02124608.akpm@linux-foundation.org>
	<20100213114842D.fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Feb 2010 11:49:09 +0900 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Fri, 12 Feb 2010 11:51:57 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > -#ifdef CONFIG_NEED_DMA_MAP_STATE
> > > -#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)        dma_addr_t ADDR_NAME;
> > > -#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)          __u32 LEN_NAME;
> > 
> > But we already screwed up the semicolon thing.  If you grep the tree you'll
> > see that about half of the users of this macro added their own semicolon:
> 
> Yeah, I know. PCI-DMA-mapping.txt says:
> 
> NOTE: DO NOT put a semicolon at the end of the DECLARE_*() macro.
> 
> 
> But there are some other DECLARE_ macros that don't have the
> semicolons so users could be easily confused.

yup.  Users already got confused.

> #define DEFINE_DMA_MAP_ADDR(ADDR_NAME) dma_addr_t ADDR_NAME
> 
> looks better?

yes.  People expect to have to put the semicolon in there, so they do.

> 
> > ./drivers/net/cxgb3/sge.c:              DECLARE_PCI_UNMAP_ADDR(addr);
> > ./drivers/net/skge.h:   DECLARE_PCI_UNMAP_ADDR(mapaddr);
> > ./drivers/net/qla3xxx.h:         DECLARE_PCI_UNMAP_ADDR(mapaddr);
> > ./drivers/net/qla3xxx.h:         DECLARE_PCI_UNMAP_ADDR(mapaddr);
> > ./drivers/net/tg3.h:    DECLARE_PCI_UNMAP_ADDR(mapping)
> > 
> > 
> > Perhaps someone will clean all that up sometime.
> 
> I plan to replace these PCI API with the new generic API so I can take
> care of them together.

cool.
