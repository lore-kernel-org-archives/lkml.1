Return-Path: <linux-kernel-owner+w=401wt.eu-S1758432AbZKJWbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758432AbZKJWbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 17:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757509AbZKJWbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 17:31:19 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60575 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757096AbZKJWbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 17:31:18 -0500
Date: Tue, 10 Nov 2009 14:30:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jerome Glisse <jglisse@redhat.com>
Cc: airlied@gmail.com, dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/radeon/kms: Fix oops when set_base is call with no
 FB
Message-Id: <20091110143056.defb1a82.akpm@linux-foundation.org>
In-Reply-To: <1257361399-5128-1-git-send-email-jglisse@redhat.com>
References: <1257361399-5128-1-git-send-email-jglisse@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  4 Nov 2009 20:03:19 +0100
Jerome Glisse <jglisse@redhat.com> wrote:

> Just do nothings crct_set_base i call with no FB.
> 

hmpf.  It's obvious that you spent hours carefully describing this
patch for us.

> diff --git a/drivers/gpu/drm/radeon/atombios_crtc.c b/drivers/gpu/drm/radeon/atombios_crtc.c
> index c15287a..f5987af 100644
> --- a/drivers/gpu/drm/radeon/atombios_crtc.c
> +++ b/drivers/gpu/drm/radeon/atombios_crtc.c
> @@ -578,8 +578,11 @@ int atombios_crtc_set_base(struct drm_crtc *crtc, int x, int y,
>  	uint64_t fb_location;
>  	uint32_t fb_format, fb_pitch_pixels, tiling_flags;
>  
> -	if (!crtc->fb)
> -		return -EINVAL;
> +	/* no fb bound */
> +	if (!crtc->fb) {
> +		DRM_DEBUG("No FB bound\n");
> +		return 0;
> +	}
>  
>  	radeon_fb = to_radeon_framebuffer(crtc->fb);
>  
> diff --git a/drivers/gpu/drm/radeon/radeon_legacy_crtc.c b/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
> index 8d0b7aa..5794364 100644
> --- a/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
> +++ b/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
> @@ -408,6 +408,11 @@ int radeon_crtc_set_base(struct drm_crtc *crtc, int x, int y,
>  	uint32_t gen_cntl_reg, gen_cntl_val;
>  
>  	DRM_DEBUG("\n");
> +	/* no fb bound */
> +	if (!crtc->fb) {
> +		DRM_DEBUG("No FB bound\n");
> +		return 0;
> +	}
>  
>  	radeon_fb = to_radeon_framebuffer(crtc->fb);

Under which circumstances does this oops occur?  What userspace actions?

See, curious minds want to know whether this patch is needed in 2.6.33,
2.6.32, 2.6.31.x, 2.6.30,x, etc, etc.  Often we rely upon the
originator to provide us with enough information to make that decision.
You didn't do this.  Please always do so.

