Return-Path: <linux-kernel-owner+w=401wt.eu-S1756209AbZFOGvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbZFOGvl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 02:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbZFOGvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 02:51:32 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:50735 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863AbZFOGva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 02:51:30 -0400
Subject: Re: [BUILD FAILURE 02/04] Next June 04:PPC64 randconfig
	[drivers/usb/host/ohci-hcd.o]
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: David Brownell <david-b@pacbell.net>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-usb@vger.kernel.org,
       Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       Kumar Gala <galak@kernel.crashing.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Linux-Next <linux-next@vger.kernel.org>, Jon Smirl <jonsmirl@gmail.com>,
       Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, kernel@wantstofly.org
In-Reply-To: <1244799348.5234.13.camel@subratamodak.linux.ibm.com>
References: <20090605182651.24094.36577.sendpatchset@elm3a191.beaverton.ibm.com>
	 <200906091738.58154.david-b@pacbell.net>
	 <1244799348.5234.13.camel@subratamodak.linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Organization: IBM
Date: Mon, 15 Jun 2009 12:21:18 +0530
Message-Id: <1245048679.5239.8.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-12 at 15:05 +0530, Subrata Modak wrote: 
> On Tue, 2009-06-09 at 17:38 -0700, David Brownell wrote:
> > On Friday 05 June 2009, Subrata Modak wrote:
> > > Correct, it fixes the issue. However, since few changes might have gone
> > > to the Kconfig, the patch does not apply cleanly. Below is the patch, just
> > > a retake of the earlier one, but on the latest code. 
> > 
> > And it got mangled a bit along the way.  Plus, the original one
> > goofed up Kconfig dependency displays ... both issues fixed in
> > this version, against current mainline GIT.
> > 
> > If someone can verify all four PPC/OF/OHCI configs build on
> > on PPC64, I'm OK with it.
> > 
> > - Dave
> 
> Dave,
> 
> Sorry for being late. The patch fixes the issue on the latest git for
> PPC64. Infact, the whole drivers/usb/host/ builds just fine:
> 
> linux-2.6 # make drivers/usb/host/
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   SYMLINK include/asm -> include/asm-powerpc
>   CALL    scripts/checksyscalls.sh
>   CC      drivers/usb/host/ohci-hcd.o
>   CC      drivers/usb/host/pci-quirks.o
>   CC      drivers/usb/host/uhci-hcd.o
>   LD      drivers/usb/host/built-in.o
>   CC [M]  drivers/usb/host/isp116x-hcd.o
>   CC [M]  drivers/usb/host/u132-hcd.o
> 
> You can check in the patch now.

Dave,

Have you checked in this patch ? Or, does it require some more
modification/updates from somebody´s side ?

Regards--
Subrata

> 
> Regards--
> Subrata
> 
> > 
> > 
> > ========== CUT HERE
> > From: Arnd Bergmann <arnd@arndb.de>
> > Subject: fix build failure for PPC64 randconfig [usb/ohci]
> > 
> > We could just make the USB_OHCI_HCD_PPC_OF option implicit
> > and selected only if at least one of USB_OHCI_HCD_PPC_OF_BE
> > and USB_OHCI_HCD_PPC_OF_LE are set.
> > 
> > [ dbrownell@users.sourceforge.net: fix patch manglation and dependencies ]
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Resent-by: Subrata Modak <subrata@linux.vnet.ibm.com>
> > Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> > ---
> >  drivers/usb/host/Kconfig |   29 +++++++++++++++--------------
> >  1 file changed, 15 insertions(+), 14 deletions(-)
> > 
> > --- a/drivers/usb/host/Kconfig
> > +++ b/drivers/usb/host/Kconfig
> > @@ -180,26 +180,27 @@ config USB_OHCI_HCD_PPC_SOC
> >  	  Enables support for the USB controller on the MPC52xx or
> >  	  STB03xxx processor chip.  If unsure, say Y.
> > 
> > -config USB_OHCI_HCD_PPC_OF
> > -	bool "OHCI support for PPC USB controller on OF platform bus"
> > -	depends on USB_OHCI_HCD && PPC_OF
> > -	default y
> > -	---help---
> > -	  Enables support for the USB controller PowerPC present on the
> > -	  OpenFirmware platform bus.
> > -
> >  config USB_OHCI_HCD_PPC_OF_BE
> > -	bool "Support big endian HC"
> > -	depends on USB_OHCI_HCD_PPC_OF
> > -	default y
> > +	bool "OHCI support for OF platform bus (big endian)"
> > +	depends on USB_OHCI_HCD && PPC_OF
> >  	select USB_OHCI_BIG_ENDIAN_DESC
> >  	select USB_OHCI_BIG_ENDIAN_MMIO
> > +	---help---
> > +	  Enables support for big-endian USB controllers present on the
> > +	  OpenFirmware platform bus.
> > 
> >  config USB_OHCI_HCD_PPC_OF_LE
> > -	bool "Support little endian HC"
> > -	depends on USB_OHCI_HCD_PPC_OF
> > -	default n
> > +	bool "OHCI support for OF platform bus (little endian)"
> > +	depends on USB_OHCI_HCD && PPC_OF
> >  	select USB_OHCI_LITTLE_ENDIAN
> > +	---help---
> > +	  Enables support for little-endian USB controllers present on the
> > +	  OpenFirmware platform bus.
> > +
> > +config USB_OHCI_HCD_PPC_OF
> > +	bool
> > +	depends on USB_OHCI_HCD && PPC_OF
> > +	default USB_OHCI_HCD_PPC_OF_BE || USB_OHCI_HCD_PPC_OF_LE
> > 
> >  config USB_OHCI_HCD_PCI
> >  	bool "OHCI support for PCI-bus USB controllers"
> > 

