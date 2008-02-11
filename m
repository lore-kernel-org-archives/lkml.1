Return-Path: <linux-kernel-owner+w=401wt.eu-S1759117AbYBKS6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759117AbYBKS6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 13:58:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbYBKS6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 13:58:37 -0500
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:24457 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbYBKS6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 13:58:36 -0500
Date: Mon, 11 Feb 2008 13:58:34 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: John David Anglin <dave@hiauly1.hia.nrc.ca>,
       James.Bottomley@HansenPartnership.com, kyle@parisc-linux.org,
       matthew@wil.cx, grundler@parisc-linux.org, linux-parisc@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH?][arch/parisc/kernel/pci-dma.c]
	pcxl_dma_ops.alloc_noncoherent
Message-ID: <20080211185834.GB4516@phobos.i.cabal.ca>
References: <200802111708.m1BH8q3p008073@hiauly1.hia.nrc.ca> <47B09A4A.3030907@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B09A4A.3030907@tiscali.nl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 07:56:10PM +0100, Roel Kluin wrote:
> +/*
> + * dma_alloc_noncoherent is a fallback for boxes PA7200 and below which
> + * cannot allocate coherent memory.
> + */
>  static void *pa11_dma_alloc_noncoherent(struct device *dev, size_t size,
>  					  dma_addr_t *dma_handle, gfp_t flag)
>  {

Why? This is located below pcxl_dma_ops so its obviously only relevant
for pcx.

> @@ -586,6 +590,10 @@ static void pa11_dma_free_noncoherent(struct device *dev, size_t size,
>  	return;
>  }
>  
> +/*
> + * PCXL allocates coherent memory even for dma_alloc_noncoherent() due to the
> + * uncached trick for coherent memory.
> + */

This isn't correct either.

>  struct hppa_dma_ops pcx_dma_ops = {
>  	.dma_supported =	pa11_dma_supported,
>  	.alloc_consistent =	fail_alloc_consistent,
> 
