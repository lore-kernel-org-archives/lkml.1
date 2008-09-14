Return-Path: <linux-kernel-owner+w=401wt.eu-S1755297AbYINPcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbYINPcT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 11:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753628AbYINPcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 11:32:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43916 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623AbYINPcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 11:32:03 -0400
Date: Sun, 14 Sep 2008 17:31:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: daniel.blueman@gmail.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jbeulich@novell.com,
       jens.axboe@oracle.com, tony.luck@intel.com, akpm@linux-foundation.org
Subject: Re: [2.6.27-rc6, patch] fix SWIOTLB oops...
Message-ID: <20080914153104.GI29290@elte.hu>
References: <6278d2220809101307h798bb921m3b471f29ce8150ad@mail.gmail.com> <20080911222838V.fujita.tomonori@lab.ntt.co.jp> <6278d2220809131053p303e839dy5521d5975523fea8@mail.gmail.com> <20080914034719Y.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080914034719Y.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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

> On Sat, 13 Sep 2008 18:53:13 +0100
> "Daniel J Blueman" <daniel.blueman@gmail.com> wrote:
> 
> > >> Fix back-off path when memory allocation fails
> > >> Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
> > >>
> > >> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> > >> index 977edbd..8826fdf 100644
> > >> --- a/lib/swiotlb.c
> > >> +++ b/lib/swiotlb.c
> > >> @@ -491,7 +491,7 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
> > >>                * the lowest available address range.
> > >>                */
> > >>               dma_addr_t handle;
> > >> -             handle = swiotlb_map_single(NULL, NULL, size, DMA_FROM_DEVICE);
> > >> +             handle = swiotlb_map_single(hwdev, NULL, size, DMA_FROM_DEVICE);
> > >
> > > I think that it's better to use map_single instead of
> > > swiotlb_map_single since we always need swiotlb memory here.
> > >
> > > http://www.uwsg.iu.edu/hypermail/linux/kernel/0809.1/0043.html
> > 
> > Thanks Fujita; this looks a better way of doing this. I've tested the
> > three patches you posted and they address the original issue I bumped
> > into, so seem an appropriate fix for -rc7. Not sure if preceding
> > comments need tweaking though.
> > 
> > Our work isn't done yet though, since we see unexpected page state [5]
> > on the release path. Calling the appropriate IOMMU/SWIOTLB release
> > function [6] corrects this. Verified on x86-64 Intel system with
> > SWIOTLB in use due to large memory; without this, processes end up
> > hosed, so I'd say it's -rc7 material.
> 
> Are you sure your patch doesn't break other x86 IOMMU implementations
> (note that this patch affects all the IOMMUs)?
> 
> x86 IOMMU coherent code has been broken for a long time. The coherent
> code was completely rewritten for 2.6.28 to fix all the issues.
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-tip.git
> 
> I think it's too late to try to fix v2.6.27.

definitely - but if there are minimal fixes possible for regressions, 
those are still fine.

	Ingo
