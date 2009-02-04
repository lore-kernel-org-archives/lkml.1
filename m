Return-Path: <linux-kernel-owner+w=401wt.eu-S1755041AbZBDBvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041AbZBDBvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 20:51:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752736AbZBDBv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 20:51:29 -0500
Received: from gate.crashing.org ([63.228.1.57]:54438 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773AbZBDBv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 20:51:28 -0500
Subject: Re: FW: [PATCH] powerpc/mm: Export HPAGE_SHIFT
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: Eli Cohen <eli@mellanox.co.il>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
In-Reply-To: <ada8wonnh3t.fsf@cisco.com>
References: <20090203164930.GA10101@mtls03>  <ada8wonnh3t.fsf@cisco.com>
Content-Type: text/plain
Date: Wed, 04 Feb 2009 12:50:48 +1100
Message-Id: <1233712248.16867.131.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-03 at 17:08 -0800, Roland Dreier wrote:
> Forwarding Eli's patch below, since PowerPC guys may have missed it.  I
> guess the question for Ben et al is whether there is any issue with
> exporting HPAGE_SHIFT for modules (can be EXPORT_SYMBOL_GPL if you feel
> it's an internal detail).  It would probably make sense to roll this
> change into the mlx4 change that Eli alludes to below and merge through
> my tree (with ppc maintainer acks of course), rather than splitting this
> patch out and introducing cross-tree dependencies (and also separating
> the rationale for the change from the change itself).
> 
> Thanks,
>   Roland
> 
> 
> Drivers may want to take advantage of the large pages used for memory obtained
> from hugetlbfs. One example is mlx4_ib which can use much less MTT entries (in
> the order of HPAGE_SIZE / PAGE_SIZE) when registering such memory, thus scale
> significantly better when registering larger memory regions. Other drivers
> could also benefit from this.

Except that we support multiple large page sizes nowadays ... I think
the size can be specified per mountpoint of hugetlbfs no ? Thus things
like mellanox would have to query the page size used for a given
mapping.

Do the generic hugetlbfs code provides such an API ? If not, we may need
to add one.

Cheers,
Ben.

> Signed-off-by: Eli Cohen <eli@mellanox.co.il>
> ---
>  arch/powerpc/mm/hash_utils_64.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/powerpc/mm/hash_utils_64.c b/arch/powerpc/mm/hash_utils_64.c
> index 8d5b475..6cff8c7 100644
> --- a/arch/powerpc/mm/hash_utils_64.c
> +++ b/arch/powerpc/mm/hash_utils_64.c
> @@ -104,6 +104,7 @@ int mmu_highuser_ssize = MMU_SEGSIZE_256M;
>  u16 mmu_slb_size = 64;
>  #ifdef CONFIG_HUGETLB_PAGE
>  unsigned int HPAGE_SHIFT;
> +EXPORT_SYMBOL(HPAGE_SHIFT);
>  #endif
>  #ifdef CONFIG_PPC_64K_PAGES
>  int mmu_ci_restrictions;

