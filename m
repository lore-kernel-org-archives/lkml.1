Return-Path: <linux-kernel-owner+w=401wt.eu-S1755838AbZKJLTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbZKJLTZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 06:19:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750977AbZKJLTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 06:19:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35615 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903AbZKJLTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 06:19:24 -0500
Date: Tue, 10 Nov 2009 12:19:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, chrisw@sous-sol.org, wmw2@infradead.org,
       joerg.roedel@amd.com, muli@il.ibm.com
Subject: Re: [PATCH v2 0/9] x86: handle HW IOMMU initialization failure
 gracefully
Message-ID: <20091110111919.GA20353@elte.hu>
References: <1257849980-22640-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257849980-22640-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
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

> This patchset is against tip/master.
> 
> The first version is:
> 
> http://marc.info/?l=linux-kernel&m=125671300920411&w=2
> 
> The changes since v1 are:
> 
> - replaced Chris' bootmem patches with the 6/9 patch to implement
>   free_bootmem_late in a simple way (thanks to Pekka).
> 
> - fixed the bug to break 'iommu=soft' boot opiton (found by Joerg).
> 
> - moved iommu_init_noop() to x86_init.c
> 
> - added Muli's Acked-by to Calgary patch.
> 
> 
> ==
>  arch/ia64/kernel/pci-swiotlb.c   |    4 +-
>  arch/powerpc/kernel/setup_32.c   |    2 +-
>  arch/powerpc/kernel/setup_64.c   |    2 +-
>  arch/x86/include/asm/amd_iommu.h |    2 -
>  arch/x86/include/asm/calgary.h   |    2 -
>  arch/x86/include/asm/gart.h      |    5 +---
>  arch/x86/include/asm/iommu.h     |    1 -
>  arch/x86/include/asm/x86_init.h  |    9 +++++++
>  arch/x86/kernel/amd_iommu.c      |    2 +-
>  arch/x86/kernel/amd_iommu_init.c |   19 +++-----------
>  arch/x86/kernel/aperture_64.c    |    4 ++-
>  arch/x86/kernel/pci-calgary_64.c |   19 ++++-----------
>  arch/x86/kernel/pci-dma.c        |   27 ++++++++++-----------
>  arch/x86/kernel/pci-gart_64.c    |   16 ++++-------
>  arch/x86/kernel/pci-nommu.c      |    9 -------
>  arch/x86/kernel/pci-swiotlb.c    |   10 +++----
>  arch/x86/kernel/x86_init.c       |    5 ++++
>  drivers/pci/dmar.c               |    7 ++++-
>  drivers/pci/intel-iommu.c        |    4 +-
>  include/linux/bootmem.h          |    1 +
>  include/linux/dmar.h             |   10 -------
>  include/linux/swiotlb.h          |    5 ++-
>  lib/swiotlb.c                    |   49 +++++++++++++++++++++++++++++++------
>  mm/bootmem.c                     |   24 ++++++++++++++++++
>  24 files changed, 131 insertions(+), 107 deletions(-)

Nice changes! I've applied them to tip:core/iommu (with the small build 
fix i mentioned in the previous mail) and will push them out later 
today.

Thanks,

	Ingo
