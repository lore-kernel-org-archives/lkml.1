Return-Path: <linux-kernel-owner+w=401wt.eu-S1762862AbZE1I6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762862AbZE1I6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 04:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756972AbZE1I6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 04:58:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60874 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756340AbZE1I62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 04:58:28 -0400
Date: Thu, 28 May 2009 10:58:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       tony.luck@intel.com, linux-ia64@vger.kernel.org, arnd@arndb.de,
       joerg.roedel@amd.com
Subject: Re: [PATCH -tip v2 0/5] add common functions for struct dma_map_ops
Message-ID: <20090528085810.GA24335@elte.hu>
References: <1242359705-2117-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <20090528002020.8b68f085.akpm@linux-foundation.org> <20090528163853Q.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090528163853Q.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> Thanks for picking up the patchset,
> 
> On Thu, 28 May 2009 00:20:20 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Fri, 15 May 2009 12:55:00 +0900 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > 
> > > We unified x86 and IA64's handling of multiple dma mapping operations
> > > (struct dma_map_ops in linux/dma-mapping.h) so we can remove
> > > duplication in their arch/include/asm/dma-mapping.h.
> > > 
> > > This patchset adds include/asm-generic/dma-mapping-common.h that
> > > provides some generic dma mapping function definitions for the users
> > > of struct dma_map_ops. This enables us to remove about 100 lines. This
> > > also enables us to easily add CONFIG_DMA_API_DEBUG support, which only
> > > x86 supports for now. The 4th patch adds CONFIG_DMA_API_DEBUG support
> > > to IA64 by adding only 8 lines.
> > > 
> > > This is against tip/master since tip has some changes to
> > > arch/x86/include/asm/dma-mapping.h.
> > > 
> > > The changes since the first version are
> > > 
> > > - fixed a bug that dma_attrs is not passed properly (thanks to Arnd
> > > Bergmann).
> > > 
> > > - used a new name, dma-mapping-common.h, instead of dma-mapping.h
> > > (suggested by Arnd Bergmann).
> > > 
> > > - added Joerg's Acked-by
> > > 
> > > =
> > >  arch/ia64/Kconfig                        |    1 +
> > >  arch/ia64/include/asm/dma-mapping.h      |  110 ++----------------
> > >  arch/x86/Kconfig                         |    1 +
> > >  arch/x86/include/asm/dma-mapping.h       |  174 +---------------------------
> > >  include/asm-generic/dma-mapping-common.h |  190 ++++++++++++++++++++++++++++++
> > >  lib/dma-debug.c                          |   82 ++++++++------
> > >  6 files changed, 252 insertions(+), 306 deletions(-)
> > 
> > I'm hoping that a suitable merge scheme here would be for me to merge
> > 1/5 into mainline then to send 2/5 to Ingo and 3/5, 4/5 and 5/5 to Tony
> > for merging.  Will that all compile and work?
> 
> Yes, it works. The X86 patch (2/5) and the IA64 patches (3/5, 4/5, and
> 5/5) can be merged independently. Both depends on the first patch (1/5).
> 
> 
> > Alternatively I can merge the lot, with suitable acking.
> 
> It would be easier, I think.

Yeah, that's certainly fine with me. No sense pulling these apart.

	Ingo
