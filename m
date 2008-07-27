Return-Path: <linux-kernel-owner+w=401wt.eu-S1758678AbYG0B1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678AbYG0B1n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 21:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756836AbYG0B1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 21:27:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:54530 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757152AbYG0B1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 21:27:34 -0400
Date: Sat, 26 Jul 2008 18:24:54 -0700
From: Greg KH <gregkh@suse.de>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: don't hide bios bug warning
Message-ID: <20080727012454.GA22219@suse.de>
References: <200807261812.15836.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807261812.15836.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2008 at 06:12:15PM -0700, Yinghai Lu wrote:
> 
> quirk_usb_disable_handoff will wait a while if there is BIOS bug.
> let the end user know the reason for that.
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> ---
>  drivers/usb/host/pci-quirks.c |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6/drivers/usb/host/pci-quirks.c
> ===================================================================
> --- linux-2.6.orig/drivers/usb/host/pci-quirks.c
> +++ linux-2.6/drivers/usb/host/pci-quirks.c
> @@ -190,7 +190,8 @@ static void __devinit quirk_usb_handoff_
>  			msleep(10);
>  		}
>  		if (wait_time <= 0)
> -			dev_warn(&pdev->dev, "OHCI: BIOS handoff failed"
> +			dev_printk(KERN_WARNING, &pdev->dev,
> +					"OHCI: BIOS handoff failed"

This is the exact same thing here, no change.

> @@ -242,7 +243,8 @@ static void __devinit quirk_usb_disable_
>  		switch (cap & 0xff) {
>  		case 1:			/* BIOS/SMM/... handoff support */
>  			if ((cap & EHCI_USBLEGSUP_BIOS)) {
> -				dev_dbg(&pdev->dev, "EHCI: BIOS handoff\n");
> +				dev_printk(KERN_DEBUG, &pdev->dev,
> +						"EHCI: BIOS handoff\n");

Is this what you really want to see?  But you just made things noiser.

> @@ -283,7 +285,8 @@ static void __devinit quirk_usb_disable_
>  				/* well, possibly buggy BIOS... try to shut
>  				 * it down, and hope nothing goes too wrong
>  				 */
> -				dev_warn(&pdev->dev, "EHCI: BIOS handoff failed"
> +				dev_printk(KERN_WARNING, &pdev->dev,
> +						"EHCI: BIOS handoff failed"

This is the exact same thing, no change.

confused,

greg k-h
