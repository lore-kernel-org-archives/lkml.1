Return-Path: <linux-kernel-owner+w=401wt.eu-S1758095AbZGRANt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095AbZGRANt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 20:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758046AbZGRANt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 20:13:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46998 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757963AbZGRANs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 20:13:48 -0400
Date: Fri, 17 Jul 2009 17:13:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: airlied@linux.ie, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH] fb/intelfb: conflict with DRM_I915 and hide by default
Message-Id: <20090717171326.4a71d8e3.akpm@linux-foundation.org>
In-Reply-To: <20090703112446.5a69971b@jbarnes-g45>
References: <20090703112446.5a69971b@jbarnes-g45>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Jul 2009 11:24:46 -0700
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> Users get confused by this driver.  It's really a special purpose
> embedded driver, and causes a lot of problems if enabled.  So hide it
> under EMBEDDED by default, and make sure it doesn't get enabled with
> the i915 DRM driver.
> 
> Dave, I'm hoping you can feed this to Linus through your tree.  It's
> appropriate for 2.6.31 I think.
> 
> Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> 
> diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
> index d6d65ef..ec12f7a 100644
> --- a/drivers/video/Kconfig
> +++ b/drivers/video/Kconfig
> @@ -1117,12 +1117,13 @@ config FB_CARILLO_RANCH
>  
>  config FB_INTEL
>  	tristate "Intel 830M/845G/852GM/855GM/865G/915G/945G/945GM/965G/965GM support (EXPERIMENTAL)"
> -	depends on EXPERIMENTAL && FB && PCI && X86 && AGP_INTEL
> +	depends on EXPERIMENTAL && FB && PCI && X86 && AGP_INTEL && EMBEDDED
>  	select FB_MODE_HELPERS
>  	select FB_CFB_FILLRECT
>  	select FB_CFB_COPYAREA
>  	select FB_CFB_IMAGEBLIT
>  	select FB_BOOT_VESA_SUPPORT if FB_INTEL = y
> +	depends on !DRM_I915
>  	help
>  	  This driver supports the on-board graphics built in to the Intel
>            830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM/965G/965GM chipsets.

Nothing happened?

I'll merge this next week(ish) unless given a reason not to.
