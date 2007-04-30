Return-Path: <linux-kernel-owner+w=401wt.eu-S1423323AbXD3Onj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423323AbXD3Onj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 10:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423325AbXD3Onj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 10:43:39 -0400
Received: from mta10.adelphia.net ([68.168.78.202]:62764 "EHLO
	mta10.adelphia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423323AbXD3Onh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 10:43:37 -0400
Message-ID: <46360097.5090909@acm.org>
Date: Mon, 30 Apr 2007 09:43:35 -0500
From: Corey Minyard <minyard@acm.org>
User-Agent: Icedove 1.5.0.10 (X11/20070328)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       openipmi-developer@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 11/36] Use menuconfig objects II - IPMI
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr> <Pine.LNX.4.61.0704301332570.29151@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0704301332570.29151@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I checked this out and it seems to work fine.  This does seem a little
nicer than the way it was, so if this is the way the kernel is heading
I'll ack it.

-corey

Jan Engelhardt wrote:
> Change Kconfig objects from "menu, config" into "menuconfig" so
> that the user can disable the whole feature without having to
> enter the menu first.
>
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
>
> ---
>  drivers/char/ipmi/Kconfig |   12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
>
> --- linux-2.6.21-mm_20070428.orig/drivers/char/ipmi/Kconfig
> +++ linux-2.6.21-mm_20070428/drivers/char/ipmi/Kconfig
> @@ -2,8 +2,7 @@
>  # IPMI device configuration
>  #
>  
> -menu "IPMI"
> -config IPMI_HANDLER
> +menuconfig IPMI_HANDLER
>         tristate 'IPMI top-level message handler'
>         help
>           This enables the central IPMI message handler, required for IPMI
> @@ -16,9 +15,10 @@ config IPMI_HANDLER
>  
>  	 If unsure, say N.
>  
> +if IPMI_HANDLER
> +
>  config IPMI_PANIC_EVENT
>         bool 'Generate a panic event to all BMCs on a panic'
> -       depends on IPMI_HANDLER
>         help
>           When a panic occurs, this will cause the IPMI message handler to
>  	 generate an IPMI event describing the panic to each interface
> @@ -38,14 +38,12 @@ config IPMI_PANIC_STRING
>  
>  config IPMI_DEVICE_INTERFACE
>         tristate 'Device interface for IPMI'
> -       depends on IPMI_HANDLER
>         help
>           This provides an IOCTL interface to the IPMI message handler so
>  	 userland processes may use IPMI.  It supports poll() and select().
>  
>  config IPMI_SI
>         tristate 'IPMI System Interface handler'
> -       depends on IPMI_HANDLER
>         help
>           Provides a driver for System Interfaces (KCS, SMIC, BT).
>  	 Currently, only KCS and SMIC are supported.  If
> @@ -53,15 +51,13 @@ config IPMI_SI
>  
>  config IPMI_WATCHDOG
>         tristate 'IPMI Watchdog Timer'
> -       depends on IPMI_HANDLER
>         help
>           This enables the IPMI watchdog timer.
>  
>  config IPMI_POWEROFF
>         tristate 'IPMI Poweroff'
> -       depends on IPMI_HANDLER
>         help
>           This enables a function to power off the system with IPMI if
>  	 the IPMI management controller is capable of this.
>  
> -endmenu
> +endif # IPMI_HANDLER
>   

