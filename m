Return-Path: <linux-kernel-owner+w=401wt.eu-S1754843AbYIHSQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbYIHSQI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 14:16:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753218AbYIHSP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 14:15:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36325 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107AbYIHSP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 14:15:56 -0400
Date: Mon, 8 Sep 2008 20:15:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: mingo@redhat.com, joerg.roedel@amd.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org
Subject: Re: [PATCH 0/3] fix alloc_coherent allocation issues
	(tip/x86/iommu)
Message-ID: <20080908181529.GA8536@elte.hu>
References: <20080905181155W.fujita.tomonori@lab.ntt.co.jp> <20080905104518.GA17776@elte.hu> <20080908173525.GA23419@elte.hu> <20080909030508F.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080909030508F.fujita.tomonori@lab.ntt.co.jp>
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

> Very sorry, I should have compile this on X86_32...
> 
> Can you replace the fourth patch with this?

some other commits came inbetween already - i applied the delta below.

	Ingo

--------------->
>From 53f79ced9d2c42a52290b460b88a4720a481a3ed Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 8 Sep 2008 20:13:06 +0200
Subject: [PATCH] x86: fix alloc_coherent allocation issues (tip/x86/iommu), warning fixes

fix warnings.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/asm-x86/dma-mapping.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index 0cc022b..5607532 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -253,9 +253,9 @@ static inline unsigned long dma_alloc_coherent_mask(struct device *dev,
 
 static inline gfp_t dma_alloc_coherent_gfp_flags(struct device *dev, gfp_t gfp)
 {
+#ifdef CONFIG_X86_64
 	unsigned long dma_mask = dma_alloc_coherent_mask(dev, gfp);
 
-#ifdef CONFIG_X86_64
 	if (dma_mask <= DMA_32BIT_MASK && !(gfp & GFP_DMA))
 		gfp |= GFP_DMA32;
 #endif
