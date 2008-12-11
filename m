Return-Path: <linux-kernel-owner+w=401wt.eu-S1757720AbYLKUyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720AbYLKUyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 15:54:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756250AbYLKUym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 15:54:42 -0500
Received: from ns.suse.de ([195.135.220.2]:40571 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756209AbYLKUym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 15:54:42 -0500
Date: Thu, 11 Dec 2008 12:50:33 -0800
From: Greg KH <gregkh@suse.de>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: hjk@linutronix.de, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [RESEND][PATCH] uio: Add of_platform_driver to uio_pdrv_genirq
Message-ID: <20081211205033.GA7080@suse.de>
References: <1229007937-5501-1-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229007937-5501-1-git-send-email-w.sang@pengutronix.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2008 at 04:05:37PM +0100, Wolfram Sang wrote:
> Make the generic uio-driver also accessible for of devices. It utilizes the
> standard 'reg' and 'interrupt' properties. A typical usage would look like
> this:
> 
> 	fpga-io@00003000 {
> 		compatible = "generic-uio";
> 		reg = <0x00003000 0x20>;
> 		interrupts = <0xa>;
> 		interrupt-parent = <&fpga_irq_mux>;
> 	};
> 
> To achieve this, the probe function has been refactored, so it can be used by
> platform and of code. Then, the of driver has been added.
> 
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> ---
>  drivers/uio/uio_pdrv_genirq.c |  178 ++++++++++++++++++++++++++++++++++++------
>  1 file changed, 154 insertions(+), 24 deletions(-)
> 
> Index: playground/drivers/uio/uio_pdrv_genirq.c
> ===================================================================
> --- playground.orig/drivers/uio/uio_pdrv_genirq.c
> +++ playground/drivers/uio/uio_pdrv_genirq.c
> @@ -1,13 +1,15 @@
>  /*
>   * drivers/uio/uio_pdrv_genirq.c
>   *
> - * Userspace I/O platform driver with generic IRQ handling code.
> + * Userspace I/O platform & of driver with generic IRQ handling code.
>   *
>   * Copyright (C) 2008 Magnus Damm
> + * Copyright (C) 2008 Wolfram Sang, Pengutronix e.K.
>   *
>   * Based on uio_pdrv.c by Uwe Kleine-Koenig,
>   * Copyright (C) 2008 by Digi International Inc.
>   * All rights reserved.
> + * Adding of_platform_driver based on xilinxfb.c by Grant Likely.
>   *
>   * This program is free software; you can redistribute it and/or modify it
>   * under the terms of the GNU General Public License version 2 as published by
> @@ -20,6 +22,10 @@
>  #include <linux/bitops.h>
>  #include <linux/interrupt.h>
>  #include <linux/stringify.h>
> +#if defined(CONFIG_OF)
> +#include <linux/of_device.h>
> +#include <linux/of_platform.h>
> +#endif

You should never need to test a config variable in order to know to
include a header file or not.

> +/* ---------------------------------------------------------------------
> + * OF bus binding
> + */
> +
> +#if defined(CONFIG_OF)

Same goes here, don't put #if in .c files please.

thanks,

greg k-h
