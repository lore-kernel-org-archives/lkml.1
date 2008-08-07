Return-Path: <linux-kernel-owner+w=401wt.eu-S1754021AbYHGXKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbYHGXKI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 19:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754486AbYHGXJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 19:09:46 -0400
Received: from gir.skynet.ie ([193.1.99.77]:60341 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754236AbYHGXJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 19:09:45 -0400
Date: Fri, 8 Aug 2008 00:09:42 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] drm: sis depends on FB_SIS
In-Reply-To: <20080807083228.0fc40405.randy.dunlap@oracle.com>
Message-ID: <alpine.DEB.0.82.0808080008050.13875@skynet.skynet.ie>
References: <20080807083228.0fc40405.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> From: Randy Dunlap <randy.dunlap@oracle.com>
> cc: airlied@linux.ie
> 
> drm/sis calls mm functions in fb/sis, so make the former depend
> on the latter.
> 
> This one happened with FB_SIS=m, AGP_SIS=y, DRM_SYS=y.
> 
> sis1.out:sis_mm.c:(.text+0x70014): undefined reference to `sis_free'
> sis1.out:sis_mm.c:(.text+0x7002a): undefined reference to `sis_malloc'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

NAK but I've no idea what the right answer is.

If someone asks for sisfb then sis drm uses code from it, if they don't 
ask for it it doesn't. So I want sisfb to be built in if its selected and 
sis drm is built-in.

Maybe I should just rip the dependency out completely, but this patch will 
break stuff badly, if someone was using the SIS DRM without sisfb.

Dave.

 > ---
>  drivers/gpu/drm/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-next-20080806.orig/drivers/gpu/drm/Kconfig
> +++ linux-next-20080806/drivers/gpu/drm/Kconfig
> @@ -86,7 +86,7 @@ config DRM_MGA
>  
>  config DRM_SIS
>  	tristate "SiS video cards"
> -	depends on DRM && AGP
> +	depends on DRM && AGP && FB_SIS
>  	help
>  	  Choose this option if you have a SiS 630 or compatible video
>            chipset. If M is selected the module will be called sis. AGP
> 
> 
> ---
> ~Randy
> Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
> http://linuxplumbersconf.org/
> 
> 
