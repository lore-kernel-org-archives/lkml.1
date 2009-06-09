Return-Path: <linux-kernel-owner+w=401wt.eu-S1758750AbZFISg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750AbZFISg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 14:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbZFISgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 14:36:49 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:55570 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754196AbZFISgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 14:36:48 -0400
Subject: Re: [BUILD FAILURE 02/04] Next June 04:PPC64 randconfig
	[drivers/usb/host/ohci-hcd.o]
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: linux-usb@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Arnd Bergmann <arnd@arndb.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       Kumar Gala <galak@kernel.crashing.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Linux-Next <linux-next@vger.kernel.org>, Jon Smirl <jonsmirl@gmail.com>,
       Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
       Roman Weissgaerber <weissg@vienna.at>,
       Stephen Rothwell <sfr@canb.auug.org.au>, kernel@wantstofly.org
In-Reply-To: <20090605182651.24094.36577.sendpatchset@elm3a191.beaverton.ibm.com>
References: <20090605182651.24094.36577.sendpatchset@elm3a191.beaverton.ibm.com>
Content-Type: text/plain
Organization: IBM
Date: Wed, 10 Jun 2009 00:06:31 +0530
Message-Id: <1244572592.5497.35.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-05 at 13:26 -0500, Subrata Modak wrote:
> >On Thu, 2009-06-04 at 10:07 -0400, Jon Smirl wrote:
> >On Thu, Jun 4, 2009 at 9:31 AM, Subrata Modak
> > <subrata@linux.vnet.ibm.com> wrote:
> > > CC      drivers/usb/host/ohci-hcd.o
> > > In file included from drivers/usb/host/ohci-hcd.c:1060:
> > > drivers/usb/host/ohci-ppc-of.c:242:2: error: #error "No endianess selected for ppc-of-ohci"
> > > make[3]: *** [drivers/usb/host/ohci-hcd.o] Error 1
> > > make[2]: *** [drivers/usb/host] Error 2
> > > make[1]: *** [drivers/usb] Error 2
> > > make: *** [drivers] Error 2
> > >
> > > I reported this earlier, and there were some discussions:
> > > http://groups.google.co.kr/group/linux.kernel/browse_thread/thread/edff9d5572d3d225
> > 
> > Proposed patch by Arnd should fix this. It has not been merged.
> > http://lkml.org/lkml/2009/4/22/49
> 
> Correct, it fixes the issue. However, since few changes might have gone
> to the Kconfig, the patch does not apply cleanly. Below is the patch, just
> a retake of the earlier one, but on the latest code. 
> 
> David,
> 
> Can you please pickup the following patch ?

David,

Is it you who will be merging this patch. Or, do i need to send it to
somebody else ?

Regards--
Subrata

> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>,
> Resent-by: Subrata Modak <subrata@linux.vnet.ibm.com>
> ---
> 
> --- linux-2.6.30-rc8/drivers/usb/host/Kconfig.orig	2009-06-05 10:31:30.000000000 -0500
> +++ linux-2.6.30-rc8/drivers/usb/host/Kconfig	2009-06-05 10:37:53.000000000 -0500
> @@ -181,26 +181,26 @@ config USB_OHCI_HCD_PPC_SOC
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
> +	Enables support for big-endian USB controllers present on the
> +	OpenFirmware platform bus.
> 
>  config USB_OHCI_HCD_PPC_OF_LE
> -	bool "Support little endian HC"
> -	depends on USB_OHCI_HCD_PPC_OF
> -	default n
> +	bool "OHCI support for OF platform bus (little endian)"
> +	depends on USB_OHCI_HCD && PPC_OF
>  	select USB_OHCI_LITTLE_ENDIAN
> +	---help---
> +	Enables support for little-endian USB controllers present on the
> +	OpenFirmware platform bus.
> +
> +	config USB_OHCI_HCD_PPC_OF
> +	bool
> +	default USB_OHCI_HCD_PPC_OF_BE || USB_OHCI_HCD_PPC_OF_LE
> 
>  config USB_OHCI_HCD_PCI
>  	bool "OHCI support for PCI-bus USB controllers"
> 
> ---
> Regards--
> Subrata
> >

