Return-Path: <linux-kernel-owner+w=401wt.eu-S1755587Ab0ATAWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab0ATAWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 19:22:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755088Ab0ATAWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 19:22:53 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:52593 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464Ab0ATAWw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 19:22:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=VOhTPgwkOdST9/g6LYiebbzzvWs6soluwmkrWf+ArduKEv2lxGcxIMu0+Wlm00CfIU
         SvAoJ84pUOr310i6dFLAFQffSvkwWYiLszrWJMZzanWvgzB0jyaGi4UJbQZE0csZnJlk
         B7+FL3tQzxDK0/bD/Thoydk2a+n4WFJbJP7n0=
MIME-Version: 1.0
In-Reply-To: <4B564D94.3080804@gmail.com>
References: <4B564D94.3080804@gmail.com>
Date: Tue, 19 Jan 2010 17:22:51 -0700
X-Google-Sender-Auth: 2b678ca1b551e24e
Message-ID: <e9c3a7c21001191622q528974c3hfd357ff1c4f05aca@mail.gmail.com>
Subject: Re: [PATCH] dma: cases IPU_PIX_FMT_BGRA32, BGR32 and ABGR32 are the 
	same in ipu_ch_param_set_size()
From: Dan Williams <dan.j.williams@intel.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ added Guennadi ]

On Tue, Jan 19, 2010 at 5:25 PM, Roel Kluin <roel.kluin@gmail.com> wrote:
> In these cases the same statements are executed.
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> But was this intended? if not, what should differ? bpp?
>
> diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
> index 9a5bc1a..1c518f1 100644
> --- a/drivers/dma/ipu/ipu_idmac.c
> +++ b/drivers/dma/ipu/ipu_idmac.c
> @@ -348,6 +348,7 @@ static void ipu_ch_param_set_size(union chan_param_mem *params,
>                break;
>        case IPU_PIX_FMT_BGRA32:
>        case IPU_PIX_FMT_BGR32:
> +       case IPU_PIX_FMT_ABGR32:
>                params->ip.bpp  = 0;
>                params->ip.pfs  = 4;
>                params->ip.npb  = 7;
> @@ -376,20 +377,6 @@ static void ipu_ch_param_set_size(union chan_param_mem *params,
>                params->ip.wid2 = 7;            /* Blue bit width - 1 */
>                params->ip.wid3 = 7;            /* Alpha bit width - 1 */
>                break;
> -       case IPU_PIX_FMT_ABGR32:
> -               params->ip.bpp  = 0;
> -               params->ip.pfs  = 4;
> -               params->ip.npb  = 7;
> -               params->ip.sat  = 2;            /* SAT = 32-bit access */
> -               params->ip.ofs0 = 8;            /* Red bit offset */
> -               params->ip.ofs1 = 16;           /* Green bit offset */
> -               params->ip.ofs2 = 24;           /* Blue bit offset */
> -               params->ip.ofs3 = 0;            /* Alpha bit offset */
> -               params->ip.wid0 = 7;            /* Red bit width - 1 */
> -               params->ip.wid1 = 7;            /* Green bit width - 1 */
> -               params->ip.wid2 = 7;            /* Blue bit width - 1 */
> -               params->ip.wid3 = 7;            /* Alpha bit width - 1 */
> -               break;
>        case IPU_PIX_FMT_UYVY:
>                params->ip.bpp  = 2;
>                params->ip.pfs  = 6;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
