Return-Path: <linux-kernel-owner+w=401wt.eu-S1755237AbZGAN1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbZGAN1F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 09:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753031AbZGAN0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 09:26:54 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:43625 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbZGAN0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 09:26:53 -0400
Subject: Re: [patch] buildfix ppc randconfig
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       sachinp <sachinp@linux.vnet.ibm.com>,
       balbir <balbir@linux.vnet.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200906190535.35138.david-b@pacbell.net>
References: <200906190535.35138.david-b@pacbell.net>
Content-Type: text/plain
Organization: IBM
Date: Wed, 01 Jul 2009 18:56:04 +0530
Message-Id: <1246454764.6978.60.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg/David,

Has this been checked in? I am not sure if i know this.

Regards--
Subrata

On Fri, 2009-06-19 at 05:35 -0700, David Brownell wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> We could just make the USB_OHCI_HCD_PPC_OF option implicit
> and selected only if at least one of USB_OHCI_HCD_PPC_OF_BE
> and USB_OHCI_HCD_PPC_OF_LE are set.
> 
> [ dbrownell@users.sourceforge.net: fix patch manglation and dependencies ]
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Tested-by: Subrata Modak <subrata@linux.vnet.ibm.com>
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> ---
>  drivers/usb/host/Kconfig |   29 +++++++++++++++--------------
>  1 file changed, 15 insertions(+), 14 deletions(-)
> 
> --- a/drivers/usb/host/Kconfig
> +++ b/drivers/usb/host/Kconfig
> @@ -181,26 +181,27 @@ config USB_OHCI_HCD_PPC_SOC
>  	  Enables support for the USB controller on the MPC52xx or
>  	  STB03xxx processor chip.  If unsure, say Y.
> 
> -config USB_OHCI_HCD_PPC_OF
> -	bool "OHCI support for PPC USB controller on OF platform bus"
> -	depends on USB_OHCI_HCD && PPC_OF
> -	default y
> -	---help---
> -	  Enables support for the USB controller PowerPC present on the
> -	  OpenFirmware platform bus.
> -
>  config USB_OHCI_HCD_PPC_OF_BE
> -	bool "Support big endian HC"
> -	depends on USB_OHCI_HCD_PPC_OF
> -	default y
> +	bool "OHCI support for OF platform bus (big endian)"
> +	depends on USB_OHCI_HCD && PPC_OF
>  	select USB_OHCI_BIG_ENDIAN_DESC
>  	select USB_OHCI_BIG_ENDIAN_MMIO
> +	---help---
> +	  Enables support for big-endian USB controllers present on the
> +	  OpenFirmware platform bus.
> 
>  config USB_OHCI_HCD_PPC_OF_LE
> -	bool "Support little endian HC"
> -	depends on USB_OHCI_HCD_PPC_OF
> -	default n
> +	bool "OHCI support for OF platform bus (little endian)"
> +	depends on USB_OHCI_HCD && PPC_OF
>  	select USB_OHCI_LITTLE_ENDIAN
> +	---help---
> +	  Enables support for little-endian USB controllers present on the
> +	  OpenFirmware platform bus.
> +
> +config USB_OHCI_HCD_PPC_OF
> +	bool
> +	depends on USB_OHCI_HCD && PPC_OF
> +	default USB_OHCI_HCD_PPC_OF_BE || USB_OHCI_HCD_PPC_OF_LE
> 
>  config USB_OHCI_HCD_PCI
>  	bool "OHCI support for PCI-bus USB controllers"

