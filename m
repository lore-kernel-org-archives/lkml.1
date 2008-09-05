Return-Path: <linux-kernel-owner+w=401wt.eu-S1753373AbYIEKqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbYIEKqJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 06:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbYIEKp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 06:45:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43158 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628AbYIEKp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 06:45:56 -0400
Date: Fri, 5 Sep 2008 12:45:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: mingo@redhat.com, joerg.roedel@amd.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH 0/3] fix alloc_coherent allocation issues
	(tip/x86/iommu)
Message-ID: <20080905104518.GA17776@elte.hu>
References: <1220605129-18359-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <20080905181155W.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080905181155W.fujita.tomonori@lab.ntt.co.jp>
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

> On Fri,  5 Sep 2008 17:58:46 +0900
> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > This patchset restores some of the current alloc_coherent behaviors
> > that Joerg's x86 patchset (in tip/x86/iommu) changes.
> > 
> > The first patch uses __GFP_DMA for NULL device argument (fallback_dev)
> > with pci-nommu. It's a hack for ISA (and some old code) so we need
> > DMA_ZONE.
> > 
> > The second patch uses __GFP_NORETRY in the case of GFP_DMA.
> > 
> > The third patch is a minor cleanup.

I've applied them to tip/x86/iommu:

 52fceb1: x86: gart alloc_coherent doesn't need to check NULL device argument
 150ba17: x86: use __GFP_NORETRY in the case of GFP_DMA with pci-nommu
 3b3d509: x86: fix nommu_alloc_coherent allocation with NULL device argument

and merged them into tip/master. Thanks!

> Oops, I messed up the subjects. They should have been:
> 
> [PATCH 1/3] x86: fix nommu_alloc_coherent allocation with NULL device argument
> [PATCH 2/3] x86: use __GFP_NORETRY in the case of GFP_DMA with pci-nommu
> [PATCH 3/3] x86: gart alloc_coherent doesn't need to check NULL device argument

that's OK - i dont rely on the numbering when picking up patches and 
they get discarded by git-am for the commit log anyway.

The only real use for numbering is when there's some really large set of 
patches (dozens of them) where i'd like to make sure no mail got dropped 
or reordered before i do some more difficult merge or conflict 
resolution run.

	Ingo
