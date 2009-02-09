Return-Path: <linux-kernel-owner+w=401wt.eu-S1755208AbZBIWXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbZBIWXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 17:23:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755696AbZBIWXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 17:23:08 -0500
Received: from ns2.gothnet.se ([82.193.160.251]:55004 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755453AbZBIWXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 17:23:06 -0500
Message-ID: <4990ACA7.2080100@shipmail.org>
Date: Mon, 09 Feb 2009 23:22:31 +0100
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@shipmail.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: airlied@linux.ie, dri-devel@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drm: count reaches -1, tested 0
References: <498EEB42.1050509@gmail.com>
In-Reply-To: <498EEB42.1050509@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-BitDefender-Scanner: Mail not scanned due to license constraints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Roel Kluin wrote:
> With a postfix decrement count will reach -1 rather than 0,
> subsequent tests fail.
>   
This code is about to be abandoned, but if we're going to fix it, 
instead of pushing the problem to then next while loop, what about

while (count && condition)
    count--;

Can you redo the patch based on that?


Thanks,
Thomas

> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/drivers/gpu/drm/via/via_dma.c b/drivers/gpu/drm/via/via_dma.c
> index 7a339db..600315c 100644
> --- a/drivers/gpu/drm/via/via_dma.c
> +++ b/drivers/gpu/drm/via/via_dma.c
> @@ -481,9 +481,9 @@ static int via_wait_idle(drm_via_private_t * dev_priv)
>  {
>  	int count = 10000000;
>  
> -	while (!(VIA_READ(VIA_REG_STATUS) & VIA_VR_QUEUE_BUSY) && count--);
> +	while (!(VIA_READ(VIA_REG_STATUS) & VIA_VR_QUEUE_BUSY) && --count);
>  
> -	while (count-- && (VIA_READ(VIA_REG_STATUS) &
> +	while (--count && (VIA_READ(VIA_REG_STATUS) &
>  			   (VIA_CMD_RGTR_BUSY | VIA_2D_ENG_BUSY |
>  			    VIA_3D_ENG_BUSY))) ;
>  	return count;
> @@ -705,7 +705,7 @@ static int via_cmdbuf_size(struct drm_device *dev, void *data, struct drm_file *
>  	switch (d_siz->func) {
>  	case VIA_CMDBUF_SPACE:
>  		while (((tmp_size = via_cmdbuf_space(dev_priv)) < d_siz->size)
> -		       && count--) {
> +		       && --count) {
>  			if (!d_siz->wait) {
>  				break;
>  			}
> @@ -717,7 +717,7 @@ static int via_cmdbuf_size(struct drm_device *dev, void *data, struct drm_file *
>  		break;
>  	case VIA_CMDBUF_LAG:
>  		while (((tmp_size = via_cmdbuf_lag(dev_priv)) > d_siz->size)
> -		       && count--) {
> +		       && --count) {
>  			if (!d_siz->wait) {
>  				break;
>  			}
>
>
> ------------------------------------------------------------------------------
> Create and Deploy Rich Internet Apps outside the browser with Adobe(R)AIR(TM)
> software. With Adobe AIR, Ajax developers can use existing skills and code to
> build responsive, highly engaging applications that combine the power of local
> resources and data with the reach of the web. Download the Adobe AIR SDK and
> Ajax docs to start building applications today-http://p.sf.net/sfu/adobe-com
> --
> _______________________________________________
> Dri-devel mailing list
> Dri-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/dri-devel
>   



