Return-Path: <linux-kernel-owner+w=401wt.eu-S1753426AbZHMHll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbZHMHll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 03:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbZHMHlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 03:41:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50602 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbZHMHlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 03:41:39 -0400
Date: Thu, 13 Aug 2009 09:41:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
       galak@kernel.crashing.orga, beckyb@kernel.crashing.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v2 0/7] powerpc: use asm-generic/dma-mapping-common.h
Message-ID: <20090813074131.GH12143@elte.hu>
References: <1249448908-18985-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1250142522.3587.110.camel@pasglop> <20090813160625B.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090813160625B.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Thu, 13 Aug 2009 15:48:42 +1000
> Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> 
> > On Wed, 2009-08-05 at 14:08 +0900, FUJITA Tomonori wrote:
> > 
> > > The above swiotlb patchset was merged in -tip so I think that merging
> > > this patchset via -tip too is the easiest way to handle this patchset.
> > > 
> > > The patchset also is available via a git tree:
> > > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git powerpc
> > 
> > Hi !
> > 
> > While I generally agree here with the patches, I'm not sure it should be
> > merged via -tip since it mostly touches arch/powerpc files (and I need
> > to review it a bit more carefully, hopefully you'll have Ack's hitting
> > your mailbox later today).
> 
> Thanks!
> 
> This patchset depends on my swiotlb cleanup patchset:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git swiotlb
> 
> http://marc.info/?l=linux-ia64&m=124718816520156&w=2
> 
> My swiotlb cleanup patchset has been in -tip. It might be easier 
> to merge both the swiotlb patchset and this patchset in powerpc 
> tree?

Ben, what's your preference? I waited for your reaction with these 
bits, i.e. they are not in tip:core/iommu yet.

One variant would be what Fujita suggested: you could pull 
core/iommu as a basis (it's a well-tested, problem-free tree at the 
moment, with no big risky items), and then pull/apply the powerpc 
specific bits from Fujita.

A second variant would be that we could pull these bits into 
core/iommu ... albeit you are right that the PowerPC tree is much 
better at testing PowerPC patches.

A third variant would be to wait with these bits until the swiotlb 
bits in core/iommu hit upstream. This would increase patch latency.

Any of these variants is good to me. What Fujita suggests seems to 
be the best to me: #1 gets us the most testing and the lowest 
latency - at the cost of tree dependency. We wont rebase core/iommu.

[ We've got three good tree properties: "tree independence",
  "good testing", "low patch latency", but we cannot have all
  three at once, we must pick two of them ;-) ]

	Ingo
