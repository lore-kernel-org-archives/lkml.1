Return-Path: <linux-kernel-owner+w=401wt.eu-S1754476AbYHTJro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbYHTJro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 05:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbYHTJrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 05:47:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60158 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889AbYHTJrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 05:47:17 -0400
Date: Wed, 20 Aug 2008 11:46:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       muli@il.ibm.com
Subject: Re: [PATCH 0/8] x86 dma_*_coherent rework patchset v2
Message-ID: <20080820094612.GA28492@elte.hu>
References: <1219156366-32498-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219156366-32498-1-git-send-email-joerg.roedel@amd.com>
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


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> Hi,
> 
> this patchset reworks the dma_*_coherent functions in the DMA layer 
> for the x86 architecture. The patch series extends the existing DMA 
> backends with missing *coherent callbacks and simplifies the generic 
> function to basically only call the registered backend. This allows 
> future optimizations in hardware specific IOMMU implementations. The 
> code ist tested on AMD64 with AMD IOMMU, GART, SWIOTLB and NOMMU as 
> well as on my old 486 box. Muli tested the Calgary specific patch.
> 
> Joerg
> 
> Changes since v1:
> 
> - fixed wrong logic in the pci-nommu alloc_coherent code
> - moved dma_*_coherent to include/asm-x86/dma-mapping.h
> 
> git diff --stat tip/master.. :
> 
>  arch/x86/kernel/amd_iommu.c      |    2 -
>  arch/x86/kernel/pci-calgary_64.c |   14 ++++
>  arch/x86/kernel/pci-dma.c        |  146 +-------------------------------------
>  arch/x86/kernel/pci-gart_64.c    |   35 +++++++++-
>  arch/x86/kernel/pci-nommu.c      |   62 ++++++++++++++++
>  include/asm-x86/dma-mapping.h    |   47 ++++++++++---
>  6 files changed, 149 insertions(+), 157 deletions(-)

applied to tip/x86/iommu - thanks Joerg!

Jesse, Fujita-san, do these changes look fine to you?

	Ingo
