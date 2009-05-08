Return-Path: <linux-kernel-owner+w=401wt.eu-S1757526AbZEHLU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526AbZEHLU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 07:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbZEHLUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 07:20:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44584 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299AbZEHLUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 07:20:06 -0400
Date: Fri, 8 May 2009 13:19:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Joerg Roedel <joerg.roedel@amd.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [GIT PULL] xen: swiotlb support for Xen dom0
Message-ID: <20090508111943.GH11596@elte.hu>
References: <1241741842-7966-1-git-send-email-jeremy@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241741842-7966-1-git-send-email-jeremy@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Hi Ingo,
> 
> This branch adds the swiotlb hooks for Xen dom0.  We use swiotlb to handle
> various device drivers which assume that multipage DMA transfers which are
> contigious in kernel memory are also contigious in machine memory (mostly
> lower-performance devices, as high-performance ones already do a good job
> of scatter-gather).
> 
> Following Fujita's suggestion, these changes remove a lot of the
> placeholder stubs in arch/x86/kernel/pci-swiotlb.c and moves them into
> the Xen-specific arch/x86/xen/pci-swiotlb.c.  (It still relies on
> overriding the weak functions defined in lib/swiotlb.c.)
> 
> The following changes since commit 2af252ab26150b4411889c9eaf1af4c5bf03de78:
>   Jeremy Fitzhardinge (1):
>         xen: checkpatch cleanups
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git xen-tip/for-ingo/dom0/swiotlb
> 
> Ian Campbell (4):
>       xen swiotlb: fixup swiotlb is chunks smaller than MAX_CONTIG_ORDER
>       xen: add hooks for mapping phys<->bus addresses in swiotlb
>       xen/swiotlb: add swiotlb_arch_range_needs_mapping hook for xen
>       xen: enable swiotlb for xen domain 0.
> 
> Jeremy Fitzhardinge (5):
>       xen: make sure swiotlb allocation is physically contigious
>       swiotlb: use swiotlb_alloc_boot to allocate emergency pool
>       xen/swiotlb: improve comment on gfp flags in xen_alloc_coherent()
>       xen/swiotlb: add sync functions
>       xen/swiotlb: update to new new dma_ops
> 
>  arch/x86/kernel/pci-swiotlb.c |   30 ++--------
>  arch/x86/xen/Kconfig          |    1 +
>  arch/x86/xen/Makefile         |    1 +
>  arch/x86/xen/pci-swiotlb.c    |   53 ++++++++++++++++++
>  drivers/pci/xen-iommu.c       |  123 +++++++++++++++++++++++++++++------------
>  include/xen/swiotlb.h         |   18 ++++++
>  lib/swiotlb.c                 |    3 +-
>  7 files changed, 168 insertions(+), 61 deletions(-)
>  create mode 100644 arch/x86/xen/pci-swiotlb.c
>  create mode 100644 include/xen/swiotlb.h

Ok, this looks good to me at a quick glance and it makes quite a bit 
of sense - but it would be nice to get the acks (or reviewed-by 
tags) of Fujita-san and Joerg, and address any review feedback and 
if everything is resolved, propagate those tags into the series.

Thanks,

	Ingo
