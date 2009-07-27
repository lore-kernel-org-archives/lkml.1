Return-Path: <linux-kernel-owner+w=401wt.eu-S1752841AbZG0QCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbZG0QCI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 12:02:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbZG0QCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 12:02:07 -0400
Received: from kroah.org ([198.145.64.141]:44992 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbZG0QCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 12:02:05 -0400
Date: Mon, 27 Jul 2009 08:37:11 -0700
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Dream in staging: separate Kconfig/Makefile into subdirectory
Message-ID: <20090727153711.GA4323@kroah.com>
References: <20090720103532.GD19341@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090720103532.GD19341@elf.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 12:35:32PM +0200, Pavel Machek wrote:
> Separate Kconfig/Makefile glue from dream into subdirectory. I plan to
> add few more drivers, and changing staging/Makefile each time sounds
> like inviting conflicts.
>     
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
> index 300b83e..50f9ab0 100644
> --- a/drivers/staging/Kconfig
> +++ b/drivers/staging/Kconfig
> @@ -133,11 +133,9 @@ source "drivers/staging/cpc-usb/Kconfig"
>  
>  source "drivers/staging/pata_rdc/Kconfig"
>  
> -source "drivers/staging/dream/smd/Kconfig"
> -
> -source "drivers/staging/dream/camera/Kconfig"
> -
>  source "drivers/staging/udlfb/Kconfig"
>  
> +source "drivers/staging/dream/Kconfig"
> +
>  endif # !STAGING_EXCLUDE_BUILD
>  endif # STAGING
> diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
> index 8d2e1c2..4fa2e07 100644
> --- a/drivers/staging/Makefile
> +++ b/drivers/staging/Makefile
> @@ -1,7 +1,7 @@
>  # Makefile for staging directory
>  
>  # fix for build system bug...
> -obj-$(CONFIG_STAGING)		+= staging.o
> +obj-$(CONFIG_STAGING)		+= staging.o dream/

Ick, no, you shouldn't have to do this.

Please jump into the dream subdir based on a Kconfig option, don't go
there every single time.

Care to fix this up?

thanks,

greg k-h
