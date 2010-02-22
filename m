Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab0BVU0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 15:26:25 -0500
Received: from mail.gmx.net ([213.165.64.20]:48248 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754300Ab0BVU0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 15:26:24 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+ATfh0hg+AKW64Uf0YsWig3fIvWCKUuNdfi8Ul3t
	jh2DiDbPrFJgE4
Date: Mon, 22 Feb 2010 21:26:13 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Steven J. Magnani" <steve@digidescorp.com>
cc: Dan Williams <dan.j.williams@intel.com>, Zhang Wei <zw@zh-kernel.org>,
       Li Yang <leoli@freescale.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [async_tx-next PATCH 2/2] fsldma: Fix cookie issues
In-Reply-To: <1266860439-17352-1-git-send-email-steve@digidescorp.com>
Message-ID: <Pine.LNX.4.64.1002222123350.4120@axis700.grange>
References: <1266860439-17352-1-git-send-email-steve@digidescorp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57999999999999996
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Feb 2010, Steven J. Magnani wrote:

> diff -uprN a/include/linux/dmaengine.h b/include/linux/dmaengine.h
> --- a/include/linux/dmaengine.h	2010-02-22 11:18:11.000000000 -0600
> +++ b/include/linux/dmaengine.h	2010-02-22 11:18:30.000000000 -0600
> @@ -31,6 +31,8 @@
>   * if dma_cookie_t is >0 it's a DMA request cookie, <0 it's an error code
>   */
>  typedef s32 dma_cookie_t;
> +#define DMA_MIN_COOKIE	1
> +#define DMA_MAX_COOKIE	2147483647

Taking into account, that dma_cookie_t is 32 bits:

+#define DMA_MAX_COOKIE		((1 << 31) - 1)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
