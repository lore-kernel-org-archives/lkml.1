Return-Path: <linux-kernel-owner+w=401wt.eu-S1757894AbZJLStC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894AbZJLStC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 14:49:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757811AbZJLStB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 14:49:01 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:44936 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbZJLStA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 14:49:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PzX5a54BfEEG42pi6kSbZVMN82augxX4H3001ZiMvb0E+c/ikQysXHLmJA9awH3KqN
         66nfakuJGaWwNsNR0nByiI4Kt8xmQmxNETIMdWlLEnSDE1wzmGsaWDFeWLmPKstqCWkt
         hsXBRqodeuy/iD0L/BZUHEEB5AzGvU7HlJD0s=
Date: Mon, 12 Oct 2009 20:46:51 +0200
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Theodore Tso <tytso@mit.edu>, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.32 regression (bisected): Video tearing/glitching with
	T400 laptops
Message-ID: <20091012184651.GA4603@Pilar.aei.mpg.de>
References: <E1Mtqnb-0002x7-TJ@closure.thunk.org> <20091008103620.5e5aae66@jbarnes-g45> <20091010204106.GA8251@mit.edu> <20091012095438.1e82b54f@jbarnes-g45>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012095438.1e82b54f@jbarnes-g45>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 12.Oct'09 at  9:54:38 -0700, Jesse Barnes wrote:
> > 
> > Nope, unfortunately, it's not helping on my T400 laptop.  I'm still
> > getting huge amounts of glitching and tearing with this patch applied
> > against -rc3.
> > 
> > What I'm using for now to fix up my system is this patch.
> > 
> 
> How about this one?  I have one more idea to try out if this doesn't
> work (hacking on it now).

I was also experiencing something very similar to Theodore's bug 
report and, at least for me, the patch below fixed the issue (the
previous one also had no effect).


> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
> index 7a5fb79..1451945 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -1047,7 +1047,7 @@ static void g4x_enable_fbc(struct drm_crtc *crtc, unsigned long interval)
>  	dev_priv->cfb_fence = obj_priv->fence_reg;
>  	dev_priv->cfb_plane = intel_crtc->plane;
>  
> -	dpfc_ctl = plane | DPFC_SR_EN | DPFC_CTL_LIMIT_1X;
> +	dpfc_ctl = plane | DPFC_CTL_LIMIT_1X;
>  	if (obj_priv->tiling_mode != I915_TILING_NONE) {
>  		dpfc_ctl |= DPFC_CTL_FENCE_EN | dev_priv->cfb_fence;
>  		I915_WRITE(DPFC_CHICKEN, DPFC_HT_MODIFY);
> --

