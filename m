Return-Path: <linux-kernel-owner+w=401wt.eu-S1755102AbZBZJ4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102AbZBZJ4j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 04:56:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbZBZJ4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 04:56:30 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50487 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbZBZJ4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 04:56:30 -0500
Date: Thu, 26 Feb 2009 09:55:52 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Karl Hiramoto <karl@hiramoto.org>
Cc: Christian Hohnstaedt <chohnstaedt@innominate.com>,
       linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH] ixp4xx_crypto panic with fragmented packets in scatterlist
Message-ID: <20090226095552.GB5811@n2100.arm.linux.org.uk>
References: <49A2E421.5050806@hiramoto.org> <49A3F3FA.1000801@hiramoto.org> <20090225090735.GA6283@elara.bln.innominate.local> <49A5110B.2050803@hiramoto.org> <20090225115407.GB6283@elara.bln.innominate.local> <49A55744.3010702@hiramoto.org> <49A5654C.1080002@hiramoto.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A5654C.1080002@hiramoto.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 04:35:40PM +0100, Karl Hiramoto wrote:
> The attached patch fixes my issue, but am not sure if it is correct or
> will  cause problems else where.

> diff -Naurp linux-2.6.28.7.a/arch/arm/include/asm/scatterlist.h linux-2.6.28.7.b/arch/arm/include/asm/scatterlist.h
> --- linux-2.6.28.7.a/arch/arm/include/asm/scatterlist.h	2009-02-20 23:41:27.000000000 +0100
> +++ linux-2.6.28.7.b/arch/arm/include/asm/scatterlist.h	2009-02-25 16:19:59.000000000 +0100
> @@ -24,4 +24,6 @@ struct scatterlist {
>  #define sg_dma_address(sg)      ((sg)->dma_address)
>  #define sg_dma_len(sg)          ((sg)->length)
>  
> +#define ARCH_HAS_SG_CHAIN
> +

We can't merge this until _all_ of ARM has been fixed for walking
scatterlist chains.
