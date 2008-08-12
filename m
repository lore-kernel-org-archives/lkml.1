Return-Path: <linux-kernel-owner+w=401wt.eu-S1753269AbYHLSZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbYHLSZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 14:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbYHLSZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 14:25:00 -0400
Received: from 8bytes.org ([88.198.83.132]:56188 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbYHLSY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 14:24:59 -0400
Date: Tue, 12 Aug 2008 20:24:56 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       muli@il.ibm.com
Subject: Re: [PATCH 4/7] x86: add alloc_coherent dma_ops callback to NOMMU driver
Message-ID: <20080812182455.GD4342@8bytes.org>
References: <1218554657-16070-1-git-send-email-joerg.roedel@amd.com> <1218554657-16070-5-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218554657-16070-5-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2008 at 05:24:14PM +0200, Joerg Roedel wrote:
> +static void *
> +nommu_alloc_coherent(struct device *hwdev, size_t size,
> +		     dma_addr_t *dma_addr, gfp_t gfp)
> +{
> +	unsigned long dma_mask;
> +	int node;
> +	struct page *page;
> +
> +	if (hwdev->dma_mask == NULL)
> +		return NULL;
> +
> +	gfp &= ~(__GFP_DMA | __GFP_HIGHMEM | __GFP_DMA32);
> +	gfp |= __GFP_ZERO;
> +
> +	dma_mask = hwdev->coherent_dma_mask;
> +	if (!dma_mask)
> +		dma_mask = *(hwdev->dma_mask);
> +
> +	if (dma_mask <= DMA_24BIT_MASK)
> +		gfp |= GFP_DMA;
> +	else if (dma_mask <= DMA_32BIT_MASK)
> +		gfp |= GFP_DMA32;

Argh. But there is a bug in this logic :-(
I fix it and resend.

Joerg

