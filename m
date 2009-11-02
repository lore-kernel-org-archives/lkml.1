Return-Path: <linux-kernel-owner+w=401wt.eu-S1755307AbZKBOeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbZKBOeB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 09:34:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755234AbZKBOeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 09:34:00 -0500
Received: from casper.infradead.org ([85.118.1.10]:37888 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404AbZKBOd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 09:33:59 -0500
Date: Mon, 2 Nov 2009 14:33:52 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Clemens Ladisch <clemens@ladisch.de>
cc: Dave Airlie <airlied@redhat.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Eric Anholt <eric@anholt.net>, dri-devel@lists.sourceforge.net,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] drm/i915: allocate framebuffer cmap
In-Reply-To: <4AEE8D6F.60209@ladisch.de>
Message-ID: <alpine.LFD.2.00.0911021431360.30135@casper.infradead.org>
References: <4AEE8CDD.10600@ladisch.de> <4AEE8D6F.60209@ladisch.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> Without an allocated colormap, FBIOGETCMAP fails.  This would make
> programs restore an all-black colormap ("links -g") or fail to work
> altogether ("mplayer -vo fbdev2").
> 
> Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
> ---
> Untested.
> 
> --- linux-2.6/drivers/gpu/drm/i915/intel_fb.c
> +++ linux-2.6/drivers/gpu/drm/i915/intel_fb.c
> @@ -227,6 +227,10 @@ static int intelfb_create(struct drm_dev
>  
>  	fb->fbdev = info;
>  
> +	ret = fb_alloc_cmap(&info->cmap, 256, 0);
> +	if (ret)
> +		goto out_unpin;
> +
>  	par->intel_fb = intel_fb;
>  
>  	/* To allow resizeing without swapping buffers */

It would be better to place that code in drm_fb_helper_single_fb_probe.
Also instead of 256 I would recommend using crtc->gamma_size.

