Return-Path: <linux-kernel-owner+w=401wt.eu-S1756703AbYDFXvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703AbYDFXvW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 19:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755399AbYDFXvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 19:51:15 -0400
Received: from gir.skynet.ie ([193.1.99.77]:40344 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755205AbYDFXvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 19:51:14 -0400
Date: Mon, 7 Apr 2008 00:51:12 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] fix IS_I9XX macro in i915 DRM driver
In-Reply-To: <200804061155.04965.jbarnes@virtuousgeek.org>
Message-ID: <alpine.DEB.0.82.0804070050330.17493@skynet.skynet.ie>
References: <200804061155.04965.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Now that we're mapping registers in the DRM driver at load time, the driver 
> actually checks the PCI ID, so we need to make sure the macros have all the 
> right bits (and longer term use the DRM headers as the sole copy of the PCI & 
> register definitions).
> 
> This patch adds 945GME support to the DRM headers, fixing a regression 
> reported in http://bugzilla.kernel.org/show_bug.cgi?id=10395.
> 
> Dave, please ack asap so this will be fixed in 2.6.25 proper.
> 
> Thanks,
> Jesse
> 
> Tested-by:  Alexander Oltu <alexander@all-2.com>
> Signed-off-by:  Jesse Barnes <jesse.barnes@intel.com>

Acked-by: Dave Airlie <airlied@linux.ie>

Linus please get into 2.6.25 if possible.

Dave.

> 
> diff --git a/drivers/char/drm/i915_drv.h b/drivers/char/drm/i915_drv.h
> index c10d128..675d88b 100644
> --- a/drivers/char/drm/i915_drv.h
> +++ b/drivers/char/drm/i915_drv.h
> @@ -1092,8 +1092,8 @@ extern int i915_wait_ring(struct drm_device * dev, int 
> n, const char *caller);
>  #define IS_I915G(dev) ((dev)->pci_device == 0x2582 || (dev)->pci_device == 
> 0x258a)
>  #define IS_I915GM(dev) ((dev)->pci_device == 0x2592)
>  #define IS_I945G(dev) ((dev)->pci_device == 0x2772)
> -#define IS_I945GM(dev) ((dev)->pci_device == 0x27A2)
> -
> +#define IS_I945GM(dev) ((dev)->pci_device == 0x27A2 ||\
> +		        (dev)->pci_device == 0x27AE)
>  #define IS_I965G(dev) ((dev)->pci_device == 0x2972 || \
>  		       (dev)->pci_device == 0x2982 || \
>  		       (dev)->pci_device == 0x2992 || \
> 
> 
