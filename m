Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932994Ab0CKAQY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 19:16:24 -0500
Received: from sh.osrg.net ([192.16.179.4]:42608 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932972Ab0CKAQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 19:16:21 -0500
Date: Thu, 11 Mar 2010 09:15:19 +0900
To: geert@linux-m68k.org
Cc: sfr@canb.auug.org.au, dwmw2@infradead.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, maximlevitsky@gmail.com,
       linux-arch@vger.kernel.org
Subject: Re: DMA_ERROR_CODE (was: Re: linux-next: build failure after merge
 of the 	final tree)
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <10f740e81003100303m5a4ffb45t26c380b4ef3dec37@mail.gmail.com>
References: <10f740e81003100303m5a4ffb45t26c380b4ef3dec37@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100311091506J.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 11 Mar 2010 09:15:21 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Mar 2010 12:03:37 +0100
Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> On Mon, Mar 1, 2010 at 10:40, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > After merging the final tree, today's linux-next build (powerpc
> > allyesconfig) failed like this:
> >
> > drivers/mtd/nand/r852.c:22: error: 'enable_dma' redeclared as different kind of symbol
> > arch/powerpc/include/asm/dma.h:189: note: previous definition of 'enable_dma' was here
> > drivers/mtd/nand/r852.c: In function 'r852_engine_enable':
> > drivers/mtd/nand/r852.c:545: error: implicit declaration of function 'msleep'
> >
> > Caused by commit 67e054e919248fa1db93de727fb9ad49eb700642 ("mtd: nand:
> > Add driver for Ricoh xD/SmartMedia reader") from the mtd.
> >
> > I applied the following patch for today.
> >
> > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > Date: Mon, 1 Mar 2010 20:21:06 +1100
> > Subject: [PATCH] mtd: nand: fix name space clash
> >
> > and include delay.h for msleep().
> 
> Another issue is that this driver uses DMA_ERROR_CODE, which is currently
> defined on powerpc/sparc/x86 only.

Why can't use dma_mapping_error()?
