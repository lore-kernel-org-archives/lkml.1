Return-Path: <linux-kernel-owner+w=401wt.eu-S1755869AbYJWOXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbYJWOXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 10:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928AbYJWOXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 10:23:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51565 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772AbYJWOW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 10:22:59 -0400
Date: Thu, 23 Oct 2008 16:22:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, tiwai@suse.de, joerg.roedel@amd.com
Subject: Re: [PATCH] x86: restore the old swiotlb alloc_coherent behavior
Message-ID: <20081023142243.GA22088@elte.hu>
References: <20081023231230V.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023231230V.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> This restores the old swiotlb alloc_coherent behavior (before the
> alloc_coherent rewrite):
> 
> http://lkml.org/lkml/2008/8/12/200
> 
> The old alloc_coherent avoids GFP_DMA allocation first and if the
> allocated address is not fit for the device's coherent_dma_mask, then
> dma_alloc_coherent does GFP_DMA allocation. If it fails,
> alloc_coherent calls swiotlb_alloc_coherent (in short, we rarely used
> swiotlb_alloc_coherent).
> 
> After the alloc_coherent rewrite, dma_alloc_coherent
> (include/asm-x86/dma-mapping.h) directly calls swiotlb_alloc_coherent.
> It means that we possibly can't handle a device having dma_masks >
> 24bit < 32bits since swiotlb_alloc_coherent doesn't have the above
> GFP_DMA retry mechanism.
> 
> This patch fixes x86's swiotlb alloc_coherent to use the GFP_DMA retry
> mechanism, which dma_generic_alloc_coherent() provides now
> (pci-nommu.c and GART IOMMU driver also use
> dma_generic_alloc_coherent).
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  arch/x86/kernel/pci-swiotlb_64.c |   14 +++++++++++++-
>  1 files changed, 13 insertions(+), 1 deletions(-)

applied to tip/core/urgent (to after the two other iommu related 
patches) - thanks Fujita!

	Ingo
