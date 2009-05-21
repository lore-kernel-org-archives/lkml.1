Return-Path: <linux-kernel-owner+w=401wt.eu-S1757157AbZEUQTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157AbZEUQTj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 12:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754334AbZEUQTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 12:19:32 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:34856 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbZEUQTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 12:19:31 -0400
X-IronPort-AV: E=Sophos;i="4.41,228,1241409600"; 
   d="scan'208";a="52101426"
Subject: Re: swiotlb: remove __weak hooks in favour of
	architecture-specific functions
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Becky Bruce <beckyb@kernel.crashing.org>, Olaf Kirch <okir@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
       xen-devel <xen-devel@lists.xensource.com>,
       x86 maintainers <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1242922528-5982-1-git-send-email-ian.campbell@citrix.com>
References: <1242906335.22654.188.camel@zakaz.uk.xensource.com>
	 <1242922528-5982-1-git-send-email-ian.campbell@citrix.com>
Content-Type: text/plain
Organization: Citrix Systems, Inc.
Date: Thu, 21 May 2009 17:19:30 +0100
Message-ID: <1242922770.22654.205.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-21 at 12:15 -0400, Ian Campbell wrote:
> At the end of this series there are no more __weak functions in
> lib/swiotlb.c

Hmm, I was expecting the patches to be numbered in the subject by
default. The correct order is:

swiotlb: make is_buffer_dma_capable architecture-specific
swiotlb: make range_needs_mapping architecture-specific
swiotlb/xen: update xen for swiotlb_arch_force_mapping changes
swiotlb: make swiotlb allocation functions architecture-specific
swiotlb/xen: update xen for changes to swiotlb allocation interface
swiotlb: make swiotlb phys<->bus translations architecture-specific
swiotlb/xen: update xen swiotlb for phys<->bus API changes
xen: remove arch/x86/xen/pci-swiotlb.c

Also xen-devel missed out due to a typo, sorry. See the LKML archives if
you are interested.

Ian.

> 
> The series adds several hook functions to the x86 architecture. Would
> they be preferred as a struct x86_swiotlb_ops or as individual hooks?
> 
> I was unsure what to do about powerpc in most places since the
> existing support seems to in-progress so it wasn't always clear where
> to put the implementation. If there is a tree somewhere with more
> complete support I'll be happy to provide additional patches.
> 
> Boot tested on x86 under xen but not even compiled for ia64 or
> powerpc. If someone can point me to a decent source of cross compilers
> I can sort that out. (http://www.kernel.org/pub/tools/crosstool/ seems
> to be out-of-date and only has ia64 in any case)
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: Becky Bruce <beckyb@kernel.crashing.org>
> Cc: Olaf Kirch <okir@suse.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Greg KH <gregkh@suse.de>
> Cc: xen-devel <xendevel@lists.xensource.com>
> Cc: x86 maintainers <x86@kernel.org>
> Cc: lkml <linux-kernel@vger.kernel.org>
> 
> --- 
>  arch/ia64/include/asm/dma-mapping.h    |   29 ++++++++++++++
>  arch/ia64/kernel/pci-swiotlb.c         |   11 +++++
>  arch/powerpc/include/asm/dma-mapping.h |    5 ++
>  arch/x86/include/asm/agp.h             |    4 +-
>  arch/x86/include/asm/dma-mapping.h     |   34 +++++++++++++++++
>  arch/x86/include/asm/xen/iommu.h       |    4 ++
>  arch/x86/kernel/pci-dma.c              |    6 ++-
>  arch/x86/kernel/pci-gart_64.c          |    4 +-
>  arch/x86/kernel/pci-nommu.c            |    3 +-
>  arch/x86/kernel/pci-swiotlb.c          |   32 ++++++++++++++++
>  arch/x86/xen/Makefile                  |    3 +-
>  arch/x86/xen/pci-swiotlb.c             |   53 --------------------------
>  drivers/pci/xen-iommu.c                |   20 ++++++++--
>  include/linux/dma-mapping.h            |    5 --
>  include/linux/swiotlb.h                |   10 -----
>  include/xen/swiotlb.h                  |    5 --
>  lib/swiotlb.c                          |   64 +++++++-------------------------
>  17 files changed, 156 insertions(+), 136 deletions(-)

