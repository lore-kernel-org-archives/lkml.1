Return-Path: <linux-kernel-owner+w=401wt.eu-S1760848AbYGAUll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760848AbYGAUll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 16:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754394AbYGAUld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 16:41:33 -0400
Received: from gir.skynet.ie ([193.1.99.77]:33005 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754348AbYGAUlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 16:41:32 -0400
Date: Tue, 1 Jul 2008 21:41:30 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] DRM/i915: only use tiled blits on 965+
In-Reply-To: <200807011232.53124.jbarnes@virtuousgeek.org>
Message-ID: <alpine.DEB.0.82.0807012140570.30359@skynet.skynet.ie>
References: <200807011232.53124.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> When scheduled swaps occur, we need to blit between front & back buffers.  If
> the buffers are tiled, we need to set the appropriate XY_SRC_COPY tile bit,
> but only on 965 chips, since it will cause corruption on pre-965 (e.g. 945).
> 
> Bug reported by and fix tested by Tomas Janousek <tomi@nomi.cz>.
> 
> Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

Acked-by: Dave Airlie <airlied@linux.ie>

Linus please push for -final.

Dave.

> 
> diff --git a/drivers/char/drm/i915_irq.c b/drivers/char/drm/i915_irq.c
> index f7f16e7..df03611 100644
> --- a/drivers/char/drm/i915_irq.c
> +++ b/drivers/char/drm/i915_irq.c
> @@ -62,11 +62,11 @@ static void i915_vblank_tasklet(struct drm_device *dev)
>  	u32 ropcpp = (0xcc << 16) | ((cpp - 1) << 24);
>  	RING_LOCALS;
>  
> -	if (sarea_priv->front_tiled) {
> +	if (IS_I965G(dev) && sarea_priv->front_tiled) {
>  		cmd |= XY_SRC_COPY_BLT_DST_TILED;
>  		dst_pitch >>= 2;
>  	}
> -	if (sarea_priv->back_tiled) {
> +	if (IS_I965G(dev) && sarea_priv->back_tiled) {
>  		cmd |= XY_SRC_COPY_BLT_SRC_TILED;
>  		src_pitch >>= 2;
>  	}
> 
> 
