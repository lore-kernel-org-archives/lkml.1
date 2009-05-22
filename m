Return-Path: <linux-kernel-owner+w=401wt.eu-S1757631AbZEVQeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631AbZEVQeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 12:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756177AbZEVQeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 12:34:03 -0400
Received: from xenotime.net ([72.52.64.118]:42182 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753699AbZEVQeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 12:34:02 -0400
Message-ID: <4A16D495.9040301@xenotime.net>
Date: Fri, 22 May 2009 09:36:37 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       Greg KH <gregkh@suse.de>, Sebastian Haas <haas@ems-wuensche.com>
Subject: Re: [PATCH -next] cpc-usb: fix PROC_FS dependency
References: <20090522185110.3f95b03e.sfr@canb.auug.org.au> <4A16D325.4030202@oracle.com>
In-Reply-To: <4A16D325.4030202@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> The proper way to check for and enforce a kconfig symbol
> dependency is via Kconfig files, not by using #error in
> a source file followed by 9 other compile errors.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Sebastian Haas <haas@ems-wuensche.com>
> ---
>  drivers/staging/cpc-usb/Kconfig       |    2 +-
>  drivers/staging/cpc-usb/cpc-usb_drv.c |   10 +---------
>  2 files changed, 2 insertions(+), 10 deletions(-)
> 
> --- linux-next-20090522.orig/drivers/staging/cpc-usb/cpc-usb_drv.c
> +++ linux-next-20090522/drivers/staging/cpc-usb/cpc-usb_drv.c
> @@ -27,12 +27,8 @@
>  #include <linux/completion.h>
>  #include <asm/uaccess.h>
>  #include <linux/usb.h>
> -
>  #include <linux/version.h>
> -
> -#ifdef CONFIG_PROC_FS
> -#   include <linux/proc_fs.h>
> -#endif
> +#include <linux/proc_fs.h>
>  
>  #include "cpc.h"
>  
> @@ -57,10 +53,6 @@ MODULE_LICENSE("GPL v2");
>  #define USB_CPCUSB_M16C_PRODUCT_ID    0x0888
>  #define USB_CPCUSB_LPC2119_PRODUCT_ID 0x0444
>  
> -#ifndef CONFIG_PROC_FS
> -#error "PROCFS needed"
> -#endif
> -
>  #define CPC_USB_PROC_DIR     CPC_PROC_DIR "cpc-usb"
>  
>  static struct proc_dir_entry *procDir;
> --- linux-next-20090522.orig/drivers/staging/cpc-usb/Kconfig
> +++ linux-next-20090522/drivers/staging/cpc-usb/Kconfig
> @@ -1,4 +1,4 @@
>  config USB_CPC
>  	tristate "CPC CAN USB driver"
> -	depends on USB
> +	depends on USB && PROC_FS
>  	default n

BTW, I'm surprised that there is no NET or CAN dependency here.

-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
