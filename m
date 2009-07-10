Return-Path: <linux-kernel-owner+w=401wt.eu-S1753045AbZGJFNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbZGJFNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 01:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750830AbZGJFNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 01:13:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38568 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbZGJFNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 01:13:07 -0400
Date: Fri, 10 Jul 2009 07:12:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       linuxppc-dev@ozlabs.org, benh@kernel.crashing.org, tony.luck@intel.com,
       x86@kernel.org, beckyb@kernel.crashing.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [00/15] swiotlb cleanup
Message-ID: <20090710051236.GA22218@elte.hu>
References: <1247187904-31999-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247187904-31999-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
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

> - removes unused (and unnecessary) hooks in swiotlb.
> 
> - adds dma_capable() and converts swiotlb to use it. It can be used to
> know if a memory area is dma capable or not. I added
> is_buffer_dma_capable() for the same purpose long ago but it turned
> out that the function doesn't work on POWERPC.
> 
> This can be applied cleanly to linux-next, -mm, and mainline. This
> patchset touches multiple architectures (ia64, powerpc, x86) so I
> guess that -mm is appropriate for this patchset (I don't care much
> what tree would merge this though).
> 
> This is tested on x86 but only compile tested on POWERPC and IA64.
> 
> Thanks,
> 
> =
>  arch/ia64/include/asm/dma-mapping.h    |   18 ++++++
>  arch/powerpc/include/asm/dma-mapping.h |   23 +++++++
>  arch/powerpc/kernel/dma-swiotlb.c      |   48 +---------------
>  arch/x86/include/asm/dma-mapping.h     |   18 ++++++
>  arch/x86/kernel/pci-dma.c              |    2 +-
>  arch/x86/kernel/pci-gart_64.c          |    5 +-
>  arch/x86/kernel/pci-nommu.c            |    2 +-
>  arch/x86/kernel/pci-swiotlb.c          |   25 --------
>  include/linux/dma-mapping.h            |    5 --
>  include/linux/swiotlb.h                |   11 ----
>  lib/swiotlb.c                          |  102 +++++++++-----------------------
>  11 files changed, 92 insertions(+), 167 deletions(-)

Hm, the functions and facilities you remove here were added as part 
of preparatory patches for Xen guest support. You were aware of 
them, you were involved in discussions about those aspects with Ian 
and Jeremy but still you chose not to Cc: either of them and you 
failed to address that aspect in the changelogs.

I'd like the Xen code to become cleaner more than anyone else here i 
guess, but patch submission methods like this are not really 
helpful. A far better method is to be open about such disagreements, 
to declare them, to Cc: everyone who disagrees, and to line out the 
arguments in the changelogs as well - instead of just curtly 
declaring those APIs 'unused' and failing to Cc: involved parties.

Alas, on the technical level the cleanups themselves look mostly 
fine to me. Ian, Jeremy, the changes will alter Xen's use of 
swiotlb, but can the Xen side still live with these new methods - in 
particular is dma_capable() sufficient as a mechanism and can the 
Xen side filter out DMA allocations to make them physically 
continuous?

Ben, Tony, Becky, any objections wrt. the PowerPC / IA64 impact? If 
everyone agrees i can apply them to the IOMMU tree, test it and push 
it out to -next, etc.

	Ingo
