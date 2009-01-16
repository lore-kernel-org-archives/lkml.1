Return-Path: <linux-kernel-owner+w=401wt.eu-S1759436AbZAPHZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759436AbZAPHZS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 02:25:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754867AbZAPHZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 02:25:01 -0500
Received: from iona.labri.fr ([147.210.8.143]:49928 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057AbZAPHZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 02:25:00 -0500
X-Greylist: delayed 1884 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Jan 2009 02:25:00 EST
Message-ID: <49702EEB.2010501@gmail.com>
Date: Fri, 16 Jan 2009 07:53:31 +0100
From: Brice Goglin <Brice.Goglin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Richard Purdie <rpurdie@linux.intel.com>
CC: Dave Airlie <airlied@gmail.com>, Dave Airlie <airlied@linux.ie>,
       dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm
References: <alpine.DEB.2.00.0812290819020.20427@skynet.skynet.ie>	 <1231513655.5317.30.camel@dax.rpnet.com>	 <1231524232.5317.43.camel@dax.rpnet.com>	 <1231550011.5317.72.camel@dax.rpnet.com>	 <21d7e9970901091804x61e2ba3cofd37d536df2d48b3@mail.gmail.com>	 <1231581491.5330.8.camel@dax.rpnet.com>	 <21d7e9970901101504w2c21ca22t9106770c4ada696c@mail.gmail.com> <1231631460.5330.25.camel@dax.rpnet.com>
In-Reply-To: <1231631460.5330.25.camel@dax.rpnet.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Purdie wrote:
> On Sun, 2009-01-11 at 09:04 +1000, Dave Airlie wrote:
>> Does the attached patch work?
> 
> If its fixed to compile, it fixes the problem. I don't know if your
> making this against some other tree or it was just a typo so I've
> attached the fixed version that worked for me below.

Richard's fixed patch fixes a similar hang here with 2.6.29-rc1,
Xserver 1.5.3 and intel 2.6.0 as soon as I start a GLX program.

Thanks.
Brice


> [PATCH] drm/i915: setup sarea properly in master_priv
> 
> If we are running DRI1 userspace, we really need to set the sarea up
> properly.
> 
> Signed-off-by: Richard Purdie <rpurdie@linux.intel.com>
> 
> diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
> index 62a4bf7..868f574 100644
> --- a/drivers/gpu/drm/i915/i915_dma.c
> +++ b/drivers/gpu/drm/i915/i915_dma.c
> @@ -177,6 +177,14 @@ static int i915_initialize(struct drm_device * dev, drm_i915_init_t * init)
>  	drm_i915_private_t *dev_priv = dev->dev_private;
>  	struct drm_i915_master_private *master_priv = dev->primary->master->driver_priv;
>  
> +	master_priv->sarea = drm_getsarea(dev);
> +	if (master_priv->sarea) {
> +		master_priv->sarea_priv = (drm_i915_sarea_t *)
> +			((u8 *)master_priv->sarea->handle + init->sarea_priv_offset);
> +	} else {
> +		DRM_DEBUG("sarea not found assuming DRI2 userspace\n");
> +	}
> +
>  	if (init->ring_size != 0) {
>  		if (dev_priv->ring.ring_obj != NULL) {
>  			i915_dma_cleanup(dev);
