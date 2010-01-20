Return-Path: <linux-kernel-owner+w=401wt.eu-S1753773Ab0ATTVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773Ab0ATTVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 14:21:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547Ab0ATTVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 14:21:11 -0500
Received: from mail.gmx.net ([213.165.64.20]:43318 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751695Ab0ATTVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 14:21:10 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19Ha6h4K6lH18T6ID9QFU1VMm/hWUL6+n+jQ9VlTj
	fRmqAXREAs3M/b
Date: Wed, 20 Jan 2010 20:21:00 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Roel Kluin <roel.kluin@gmail.com>
cc: Dan Williams <dan.j.williams@intel.com>,
       Maciej Sosnowski <maciej.sosnowski@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dma: cases IPU_PIX_FMT_BGRA32, BGR32 and ABGR32 are the
 same in ipu_ch_param_set_size()
In-Reply-To: <4B564D94.3080804@gmail.com>
Message-ID: <Pine.LNX.4.64.1001202020320.4151@axis700.grange>
References: <4B564D94.3080804@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jan 2010, Roel Kluin wrote:

> In these cases the same statements are executed.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi

> ---
> But was this intended? if not, what should differ? bpp?
> 
> diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
> index 9a5bc1a..1c518f1 100644
> --- a/drivers/dma/ipu/ipu_idmac.c
> +++ b/drivers/dma/ipu/ipu_idmac.c
> @@ -348,6 +348,7 @@ static void ipu_ch_param_set_size(union chan_param_mem *params,
>  		break;
>  	case IPU_PIX_FMT_BGRA32:
>  	case IPU_PIX_FMT_BGR32:
> +	case IPU_PIX_FMT_ABGR32:
>  		params->ip.bpp	= 0;
>  		params->ip.pfs	= 4;
>  		params->ip.npb	= 7;
> @@ -376,20 +377,6 @@ static void ipu_ch_param_set_size(union chan_param_mem *params,
>  		params->ip.wid2	= 7;		/* Blue bit width - 1 */
>  		params->ip.wid3	= 7;		/* Alpha bit width - 1 */
>  		break;
> -	case IPU_PIX_FMT_ABGR32:
> -		params->ip.bpp	= 0;
> -		params->ip.pfs	= 4;
> -		params->ip.npb	= 7;
> -		params->ip.sat	= 2;		/* SAT = 32-bit access */
> -		params->ip.ofs0	= 8;		/* Red bit offset */
> -		params->ip.ofs1	= 16;		/* Green bit offset */
> -		params->ip.ofs2	= 24;		/* Blue bit offset */
> -		params->ip.ofs3	= 0;		/* Alpha bit offset */
> -		params->ip.wid0	= 7;		/* Red bit width - 1 */
> -		params->ip.wid1	= 7;		/* Green bit width - 1 */
> -		params->ip.wid2	= 7;		/* Blue bit width - 1 */
> -		params->ip.wid3	= 7;		/* Alpha bit width - 1 */
> -		break;
>  	case IPU_PIX_FMT_UYVY:
>  		params->ip.bpp	= 2;
>  		params->ip.pfs	= 6;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
