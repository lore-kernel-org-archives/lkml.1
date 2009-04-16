Return-Path: <linux-kernel-owner+w=401wt.eu-S1754360AbZDPBB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360AbZDPBB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 21:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbZDPBBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 21:01:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:46995 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbZDPBBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 21:01:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,195,1239001200"; 
   d="scan'208";a="403546791"
Subject: Re: 2.6.30-rc1 (latest git): thinkpad-acpi: cannot control
	brightness with hotkeys (BISECTED)
From: yakui_zhao <yakui.zhao@intel.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Niel Lambrechts <niel.lambrechts@gmail.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux.kernel" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
In-Reply-To: <20090415164939.GA27807@srcf.ucam.org>
References: <49E10684.5090101@gmail.com>
	 <20090411150555.8b13ed18.akpm@linux-foundation.org>
	 <20090412161448.GC26502@khazad-dum.debian.net> <49E234ED.5010105@gmail.com>
	 <1239585695.5564.5.camel@localhost.localdomain> <49E3575A.60204@gmail.com>
	 <20090413203450.GC16152@khazad-dum.debian.net> <49E5234E.5070303@gmail.com>
	 <20090415164939.GA27807@srcf.ucam.org>
Content-Type: text/plain
Organization: Intel Open Source Technology Center
Date: Thu, 16 Apr 2009 09:02:53 +0800
Message-Id: <1239843773.3638.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-16 at 00:49 +0800, Matthew Garrett wrote:
> Does this help?
If so, we don't need the following patch.
   >http://marc.info/?l=linux-acpi&m=123967828429865&w=2
   >check whether the ACPI video driver is deferrable only when KMS is
set


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

