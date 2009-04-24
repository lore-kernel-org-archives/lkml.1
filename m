Return-Path: <linux-kernel-owner+w=401wt.eu-S1756997AbZDXEnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997AbZDXEnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 00:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbZDXEnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 00:43:07 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:18268 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbZDXEnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 00:43:05 -0400
Date: Fri, 24 Apr 2009 00:43:00 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: intel-gfx@lists.freedesktop.org, linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i915: Register ACPI video even when not modesetting
In-reply-to: <20090415204636.GA32365@srcf.ucam.org>
Message-id: <alpine.LFD.2.00.0904240040460.15843@localhost.localdomain>
References: <20090415204636.GA32365@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

applied

(and acpi-devel fixed to linux-acpi on cc:-)

thanks,
Len Brown, Intel Open Source Technology Center

On Wed, 15 Apr 2009, Matthew Garrett wrote:

> The ACPI video driver defers registration to the i915 driver if the 
> system supports opregion-mediated backlight control. This registration 
> was only being performed in the KMS case. Ensure it's done even if we 
> don't have modesetting enabled.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> 
> diff --git a/drivers/gpu/drm/i915/i915_opregion.c b/drivers/gpu/drm/i915/i915_opregion.c
> index 6942772..8dc1fd3 100644
> --- a/drivers/gpu/drm/i915/i915_opregion.c
> +++ b/drivers/gpu/drm/i915/i915_opregion.c
> @@ -370,11 +370,8 @@ int intel_opregion_init(struct drm_device *dev, int resume)
>  	if (mboxes & MBOX_ACPI) {
>  		DRM_DEBUG("Public ACPI methods supported\n");
>  		opregion->acpi = base + OPREGION_ACPI_OFFSET;
> -		if (drm_core_check_feature(dev, DRIVER_MODESET)) {
> +		if (drm_core_check_feature(dev, DRIVER_MODESET))
>  			intel_didl_outputs(dev);
> -			if (!resume)
> -				acpi_video_register();
> -		}
>  	} else {
>  		DRM_DEBUG("Public ACPI methods not supported\n");
>  		err = -ENOTSUPP;
> @@ -391,6 +388,10 @@ int intel_opregion_init(struct drm_device *dev, int resume)
>  		opregion->asle = base + OPREGION_ASLE_OFFSET;
>  	}
>  
> +	if (!resume)
> +		acpi_video_register();
> +
> +
>  	/* Notify BIOS we are ready to handle ACPI video ext notifs.
>  	 * Right now, all the events are handled by the ACPI video module.
>  	 * We don't actually need to do anything with them. */
> 
> -- 
> Matthew Garrett | mjg59@srcf.ucam.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
