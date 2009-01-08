Return-Path: <linux-kernel-owner+w=401wt.eu-S1758912AbZAHKUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758912AbZAHKUg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 05:20:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750905AbZAHKU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 05:20:28 -0500
Received: from h155.mvista.com ([63.81.120.155]:12342 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750713AbZAHKU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 05:20:28 -0500
Message-ID: <4965D363.6040608@ru.mvista.com>
Date: Thu, 08 Jan 2009 13:20:19 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-fbdev-devel@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       adaplas@gmail.com
Subject: Re: [PATCH 1/3] radeonfb: Fix 64 bits resources on 32 bits archs
References: <20080422012723.BA9F2DE13F@ozlabs.org>
In-Reply-To: <20080422012723.BA9F2DE13F@ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Benjamin Herrenschmidt wrote:

> This fixes radeonfb to not truncate 64 bits resources on 32 bits
> platforms. Unfortunately, there are still issues with addresses
> returned to userspace via struct fb_fix_screeninfo. This will
> have to be dealt with separately.
>
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>   

   I'm seeing that these 3 patch series (dating back to April) still 
unapplied. Have everybody forgotten about them? I'd like to see them 
finally applied.

> --- linux-work.orig/drivers/video/aty/radeon_base.c	2008-04-22 11:04:19.000000000 +1000
> +++ linux-work/drivers/video/aty/radeon_base.c	2008-04-22 11:05:00.000000000 +1000
> @@ -1886,7 +1886,7 @@ static int __devinit radeon_set_fbinfo (
>  	info->screen_size = rinfo->mapped_vram;
>  	/* Fill fix common fields */
>  	strlcpy(info->fix.id, rinfo->name, sizeof(info->fix.id));
> -        info->fix.smem_start = rinfo->fb_base_phys;
> +        info->fix.smem_start = (unsigned long)rinfo->fb_base_phys;
>          info->fix.smem_len = rinfo->video_ram;
>          info->fix.type = FB_TYPE_PACKED_PIXELS;
>          info->fix.visual = FB_VISUAL_PSEUDOCOLOR;
> @@ -1894,7 +1894,7 @@ static int __devinit radeon_set_fbinfo (
>          info->fix.ypanstep = 1;
>          info->fix.ywrapstep = 0;
>          info->fix.type_aux = 0;
> -        info->fix.mmio_start = rinfo->mmio_base_phys;
> +        info->fix.mmio_start = (unsigned long)rinfo->mmio_base_phys;
>          info->fix.mmio_len = RADEON_REGSIZE;
>  	info->fix.accel = FB_ACCEL_ATI_RADEON;
>  
> Index: linux-work/drivers/video/aty/radeonfb.h
> ===================================================================
> --- linux-work.orig/drivers/video/aty/radeonfb.h	2008-04-22 11:03:17.000000000 +1000
> +++ linux-work/drivers/video/aty/radeonfb.h	2008-04-22 11:03:27.000000000 +1000
> @@ -287,8 +287,8 @@ struct radeonfb_info {
>  
>  	char			name[DEVICE_NAME_SIZE];
>  
> -	unsigned long		mmio_base_phys;
> -	unsigned long		fb_base_phys;
> +	resource_size_t		mmio_base_phys;
> +	resource_size_t		fb_base_phys;
>  
>  	void __iomem		*mmio_base;
>  	void __iomem		*fb_base;

WBR, Sergei


