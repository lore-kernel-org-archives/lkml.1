Return-Path: <linux-kernel-owner+w=401wt.eu-S1753408AbYC2OCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbYC2OCS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 10:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbYC2OCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 10:02:11 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:63665 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbYC2OCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 10:02:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=h8YoO95kszV5L4cd15Km5QLZ9f6BkGAFsGSbVgXRXHihC3rUym5XXcxECHxbMWlFUz/mEFGNW8bA/5RaWza4MjUQW57Ous0BD1jNB9IcwKcCzvMkyMbAYWKVfc6soaC4LwOOn0qVR+qu/YECXHNbJD6OyNVyD6A/KiVTW7Fg27k=
Subject: Re: [PATCH] fix the broken annotations in fsldma
From: Josh Boyer <jwboyer@gmail.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: torvalds@linux-foundation.org, wei.zhang@freescale.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <E1JfRSU-0002xg-LA@ZenIV.linux.org.uk>
References: <E1JfRSU-0002xg-LA@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Sat, 29 Mar 2008 09:02:02 -0500
Message-Id: <1206799322.12155.10.camel@vader.jdub.homelinux.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 (2.22.0-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-03-29 at 03:10 +0000, Al Viro wrote:
> a) every bitwise declaration will give a unique type; use typedefs.
> b) no need to bother with the stuff pointed to by iomem pointers, unless
> it's accessed directly.  noderef will force us to use helpers anyway.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  drivers/dma/fsldma.h |   47 +++++++++++++++++++++++++++--------------------
>  1 files changed, 27 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/dma/fsldma.h b/drivers/dma/fsldma.h
> index fddd6ae..6faf07b 100644
> --- a/drivers/dma/fsldma.h
> +++ b/drivers/dma/fsldma.h
> @@ -75,12 +75,15 @@
>  #define FSL_DMA_DGSR_EOSI	0x02
>  #define FSL_DMA_DGSR_EOLSI	0x01
>  
> +typedef u64 __bitwise v64;
> +typedef u32 __bitwise v32;
> +
>  struct fsl_dma_ld_hw {
> -	u64 __bitwise	src_addr;
> -	u64 __bitwise	dst_addr;
> -	u64 __bitwise	next_ln_addr;
> -	u32 __bitwise	count;
> -	u32 __bitwise	reserve;
> +	v64 src_addr;
> +	v64 dst_addr;
> +	v64 next_ln_addr;
> +	v32 count;
> +	v32 reserve;
>  } __attribute__((aligned(32)));
>  
>  struct fsl_desc_sw {
> @@ -92,13 +95,13 @@ struct fsl_desc_sw {
>  } __attribute__((aligned(32)));
>  
>  struct fsl_dma_chan_regs {
> -	u32 __bitwise	mr;	/* 0x00 - Mode Register */
> -	u32 __bitwise	sr;	/* 0x04 - Status Register */
> -	u64 __bitwise	cdar;	/* 0x08 - Current descriptor address register */
> -	u64 __bitwise	sar;	/* 0x10 - Source Address Register */
> -	u64 __bitwise	dar;	/* 0x18 - Destination Address Register */
> -	u32 __bitwise	bcr;	/* 0x20 - Byte Count Register */
> -	u64 __bitwise	ndar;	/* 0x24 - Next Descriptor Address Register */
> +	u32 mr;	/* 0x00 - Mode Register */
> +	u32 sr;	/* 0x04 - Status Register */
> +	u64 cdar;	/* 0x08 - Current descriptor address register */
> +	u64 sar;	/* 0x10 - Source Address Register */
> +	u64 dar;	/* 0x18 - Destination Address Register */
> +	u32 bcr;	/* 0x20 - Byte Count Register */
> +	u64 ndar;	/* 0x24 - Next Descriptor Address Register */
>  };

Did you forget to do the s/u{32,64}/v{32,64}/ conversion for this
struct, or am I just a moron?

josh

