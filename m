Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab0CKRak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 12:30:40 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59100 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593Ab0CKRai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 12:30:38 -0500
Subject: Re: DMA_ERROR_CODE (was: Re: linux-next: build failure after merge
 of the 	final tree)
From: David Woodhouse <dwmw2@infradead.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: geert@linux-m68k.org, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, maximlevitsky@gmail.com,
       linux-arch@vger.kernel.org
In-Reply-To: <20100311091506J.fujita.tomonori@lab.ntt.co.jp>
References: <10f740e81003100303m5a4ffb45t26c380b4ef3dec37@mail.gmail.com>
	 <20100311091506J.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Mar 2010 09:30:09 -0800
Message-ID: <1268328609.23872.9.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-11 at 09:15 +0900, FUJITA Tomonori wrote:
> On Wed, 10 Mar 2010 12:03:37 +0100
> Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> 
> > On Mon, Mar 1, 2010 at 10:40, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > > After merging the final tree, today's linux-next build (powerpc
> > > allyesconfig) failed like this:
> > >
> > > drivers/mtd/nand/r852.c:22: error: 'enable_dma' redeclared as different kind of symbol
> > > arch/powerpc/include/asm/dma.h:189: note: previous definition of 'enable_dma' was here
> > > drivers/mtd/nand/r852.c: In function 'r852_engine_enable':
> > > drivers/mtd/nand/r852.c:545: error: implicit declaration of function 'msleep'
> > >
> > > Caused by commit 67e054e919248fa1db93de727fb9ad49eb700642 ("mtd: nand:
> > > Add driver for Ricoh xD/SmartMedia reader") from the mtd.
> > >
> > > I applied the following patch for today.
> > >
> > > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > > Date: Mon, 1 Mar 2010 20:21:06 +1100
> > > Subject: [PATCH] mtd: nand: fix name space clash
> > >
> > > and include delay.h for msleep().
> > 
> > Another issue is that this driver uses DMA_ERROR_CODE, which is currently
> > defined on powerpc/sparc/x86 only.
> 
> Why can't use dma_mapping_error()?

http://git.infradead.org/mtd-2.6.git/commitdiff/0c82d3ce

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

