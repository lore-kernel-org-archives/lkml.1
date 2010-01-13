Return-Path: <linux-kernel-owner+w=401wt.eu-S1755163Ab0AMJIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab0AMJIk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 04:08:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754841Ab0AMJIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 04:08:39 -0500
Received: from mx01.sz.bfs.de ([194.94.69.103]:21052 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895Ab0AMJIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 04:08:37 -0500
X-Greylist: delayed 1707 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Jan 2010 04:08:37 EST
Message-ID: <4B4D86E3.9090207@bfs.de>
Date: Wed, 13 Jan 2010 09:40:03 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Darren Jenkins <darrenrjenkins@gmail.com>
CC: David Airlie <airlied@linux.ie>,
       dri-devel mailing list <dri-devel@lists.sourceforge.net>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: drivers/gpu/drm/radeon/radeon_cp.c: check for invalid radeon
 family
References: <1261660696.3546.40.camel@ICE-BOX>
In-Reply-To: <1261660696.3546.40.camel@ICE-BOX>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Darren Jenkins schrieb:
> If there is an invalid radeon family the fw_name is NULL and causes an
> NULL pointer dereference.
> This just adds a check for something unexpected.
> 
> Coverity CID: 13252
> 
> Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com>
> diff --git a/drivers/gpu/drm/radeon/radeon_cp.c
> b/drivers/gpu/drm/radeon/radeon_cp.c
> index 0b2f9c2..1e66337 100644
> --- a/drivers/gpu/drm/radeon/radeon_cp.c
> +++ b/drivers/gpu/drm/radeon/radeon_cp.c
> @@ -531,6 +531,8 @@ static int
> radeon_cp_init_microcode(drm_radeon_private_t *dev_priv)
>  		   ((dev_priv->flags & RADEON_FAMILY_MASK) == CHIP_RV570)) {
>  		DRM_INFO("Loading R500 Microcode\n");
>  		fw_name = FIRMWARE_R520;
> +	} else {
> +		return -EINVAL;
>  	}
>  
>  	err = request_firmware(&dev_priv->me_fw, fw_name, &pdev->dev);
> 
> 

Someone should take the job to clear the if forrest and replace it with switch()/case.

just my 2 cents,
 wh
