Return-Path: <linux-kernel-owner+w=401wt.eu-S1753636AbYHMAxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636AbYHMAxt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 20:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbYHMAxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 20:53:40 -0400
Received: from sh.osrg.net ([192.16.179.4]:47475 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165AbYHMAxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 20:53:40 -0400
Date: Wed, 13 Aug 2008 09:51:59 +0900
To: joerg.roedel@amd.com
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       muli@il.ibm.com
Subject: Re: [PATCH 0/7] x86 dma_*_coherent rework patchset
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1218554657-16070-1-git-send-email-joerg.roedel@amd.com>
References: <1218554657-16070-1-git-send-email-joerg.roedel@amd.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080813095223R.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Aug 2008 17:24:10 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> Hi,
> 
> this patchset reworks the dma_*_coherent functions in the DMA layer for the x86
> architecture. The patch series extends the existing DMA backends with missing
> *coherent callbacks and simplifies the generic function to basically only call
> the registered backend. This allows future optimizations in hardware specific
> IOMMU implementations.
> The code ist tested on AMD64 with AMD IOMMU and GART as well as on my old 486
> box. It is not yet tested on a Calgary IOMMU system.
> 
> Joerg
> 
> git diff --stat tip/master:
> 
>  arch/x86/kernel/amd_iommu.c      |    2 -
>  arch/x86/kernel/pci-calgary_64.c |   14 +++++
>  arch/x86/kernel/pci-dma.c        |  116 +++----------------------------------
>  arch/x86/kernel/pci-gart_64.c    |   31 ++++++++++
>  arch/x86/kernel/pci-nommu.c      |   45 +++++++++++++++
>  5 files changed, 100 insertions(+), 108 deletions(-)

Really nice. I think that this is how other architectures that support
multiple IOMMUs handle dma operations, and this is the right thing for
x86 too.
