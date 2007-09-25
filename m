Return-Path: <linux-kernel-owner+w=401wt.eu-S1751117AbXIYImZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751117AbXIYImZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 04:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750754AbXIYImR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 04:42:17 -0400
Received: from wx-out-0506.google.com ([66.249.82.229]:60551 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbXIYImQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 04:42:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Aal6lrMO6/MBAxYOzFh+WgD78YRiyvx6czpSjxcZe3Ms5BSTtLSWVSRyjHCCS4SemkCizItRRnlUz4AymclHW6wZwp1tTX/MZ86X473mvGOqV1r+Y37i36TMbNOqgwE/iDY4kZJ4Ubl9w9kCGA3sOBOxP62s3oxFpbOpvWc+8qA=
Message-ID: <21d7e9970709250142v49ba4bedp4ae5ccfe0f2277e7@mail.gmail.com>
Date: Tue, 25 Sep 2007 18:42:14 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: [PATCH/RFC] video gfx: merge kconfig menus
Cc: lkml <linux-kernel@vger.kernel.org>, airlied@linux.ie, adaplas@gmail.com,
       akpm <akpm@linux-foundation.org>
In-Reply-To: <20070924232536.b1123359.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070924232536.b1123359.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/25/07, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> Is there some reason that we don't put all video gfx config in one
> place?  Is the split just historical, based on subdirectory locations,
> or is there a bigger reason for it?
>
> [to apply cleanly, this patch depends on a patch that was sent
> to linux-fbdev-devel, which is subscribers-only, so I didn't cc: lkml
> on it:  http://marc.info/?l=linux-fbdev-devel&m=119070044232621&w=2]
>
> ---
>
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Move AGP and DRM menus into the video graphics support menu.
>   They use 'menuconfig' so that they can all be disabled with
>   one selection.
> Make the console menu use 'menuconfig' so that it can all be
>   disabled with one selection.
> Make the frame buffer menu use 'menuconfig' so that it can all be
>   disabled with one selection.
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Fine by me.. some day we might move the directories but this is a good start..

Acked-by: Dave Airlie <airlied@linux.ie>

Dave.
> ---
>  drivers/char/Kconfig     |    4 ----
>  drivers/char/agp/Kconfig |    2 +-
>  drivers/char/drm/Kconfig |    2 +-
>  drivers/video/Kconfig    |   11 +++++++----
>  4 files changed, 9 insertions(+), 10 deletions(-)
>
> --- linux-2.6.23-rc8.orig/drivers/char/Kconfig
> +++ linux-2.6.23-rc8/drivers/char/Kconfig
> @@ -896,10 +896,6 @@ config GPIO_TB0219
>         depends on TANBAC_TB022X
>         select GPIO_VR41XX
>
> -source "drivers/char/agp/Kconfig"
> -
> -source "drivers/char/drm/Kconfig"
> -
>  source "drivers/char/pcmcia/Kconfig"
>
>  config MWAVE
> --- linux-2.6.23-rc8.orig/drivers/video/Kconfig
> +++ linux-2.6.23-rc8/drivers/video/Kconfig
> @@ -5,8 +5,9 @@
>  menu "Graphics support"
>         depends on HAS_IOMEM
>
> -source "drivers/video/backlight/Kconfig"
> -source "drivers/video/display/Kconfig"
> +source "drivers/char/agp/Kconfig"
> +
> +source "drivers/char/drm/Kconfig"
>
>  config VGASTATE
>         tristate
> @@ -19,7 +20,7 @@ config VIDEO_OUTPUT_CONTROL
>           This framework adds support for low-level control of the video
>           output switch.
>
> -config FB
> +menuconfig FB
>         tristate "Support for frame buffer devices"
>         ---help---
>           The frame buffer device provides an abstraction for the graphics
> @@ -1860,6 +1861,9 @@ if ARCH_OMAP
>         source "drivers/video/omap/Kconfig"
>  endif
>
> +source "drivers/video/backlight/Kconfig"
> +source "drivers/video/display/Kconfig"
> +
>  if VT
>         source "drivers/video/console/Kconfig"
>  endif
> @@ -1869,4 +1873,3 @@ if FB || SGI_NEWPORT_CONSOLE
>  endif
>
>  endmenu
> -
> --- linux-2.6.23-rc8.orig/drivers/char/agp/Kconfig
> +++ linux-2.6.23-rc8/drivers/char/agp/Kconfig
> @@ -1,4 +1,4 @@
> -config AGP
> +menuconfig AGP
>         tristate "/dev/agpgart (AGP Support)"
>         depends on ALPHA || IA64 || PARISC || PPC || X86
>         depends on PCI
> --- linux-2.6.23-rc8.orig/drivers/char/drm/Kconfig
> +++ linux-2.6.23-rc8/drivers/char/drm/Kconfig
> @@ -4,7 +4,7 @@
>  # This driver provides support for the
>  # Direct Rendering Infrastructure (DRI) in XFree86 4.1.0 and higher.
>  #
> -config DRM
> +menuconfig DRM
>         tristate "Direct Rendering Manager (XFree86 4.1.0 and higher DRI support)"
>         depends on (AGP || AGP=n) && PCI && !EMULATED_CMPXCHG
>         help
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
