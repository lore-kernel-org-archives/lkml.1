Return-Path: <linux-kernel-owner+w=401wt.eu-S1755316AbZGASGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbZGASGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 14:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754032AbZGASGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 14:06:24 -0400
Received: from smtp106.sbc.mail.gq1.yahoo.com ([67.195.14.109]:47186 "HELO
	smtp106.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753928AbZGASGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 14:06:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=yxy3UK+B7y5eoHkqnL0E7nBhlihFYZSwD/CK29+my7a99YiGdFPTGup3HTQqQuiM/wNbWaQ2AE9RkF0vVAy/WCmFbtr/xxoka8fu5vroVBrLlYsHXTLy7GdYZb3kNmR0T3qmGY9+7YrrNFihSeW89zWgRlivVkbpXcZ/VHbKDEk=  ;
X-Yahoo-SMTP: HIlLYKCswBDnjrunw3O.NnLyvismjGf1HBYfVTvuneM-
X-YMail-OSG: QP_9VmUVM1lfeo0uykfvkn3Q3ByDRFYbP2wNriQQd9XG.IZotXyNDgF5pHUa6nKN1MoOAERendlLer5ntn6kHmUgcyrnoSZyoF0AZdlD6._6RzgC0uTblnVK9N8lCHu9RpdDAyZBvNEAytYfVHQkBLROUUMC1Wk77kRRnI996g3CV68Umr7_ypzAtcv1aG.ZIe.lmeB1rdqz5Dxic8__wF0PMr1XtSgUbjuHo2l1C10nDSMe5W4C9s0TmtLQAMkSWMlK0g--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: subrata@linux.vnet.ibm.com
Subject: Re: [patch] buildfix ppc randconfig
Date: Wed, 1 Jul 2009 11:06:23 -0700
User-Agent: KMail/1.9.10
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>, sachinp <sachinp@linux.vnet.ibm.com>,
       balbir <balbir@linux.vnet.ibm.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <200906190535.35138.david-b@pacbell.net> <1246454764.6978.60.camel@subratamodak.linux.ibm.com>
In-Reply-To: <1246454764.6978.60.camel@subratamodak.linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907011106.24043.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 July 2009, Subrata Modak wrote:
> Greg/David,
> 
> Has this been checked in? I am not sure if i know this.

It seems not to be in Greg's "gregkh-02-usb.current"
quilt queue.  If Greg's not got near-future cycles
to get USB patches upstream, maybe this can merge
sooner through the PPC tree.

- Dave


> Regards--
> Subrata
> 
> On Fri, 2009-06-19 at 05:35 -0700, David Brownell wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> > 
> > We could just make the USB_OHCI_HCD_PPC_OF option implicit
> > and selected only if at least one of USB_OHCI_HCD_PPC_OF_BE
> > and USB_OHCI_HCD_PPC_OF_LE are set.
> > 
> > [ dbrownell@users.sourceforge.net: fix patch manglation and dependencies ]
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Tested-by: Subrata Modak <subrata@linux.vnet.ibm.com>
> > Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> > ---
> >  drivers/usb/host/Kconfig |   29 +++++++++++++++--------------
> >  1 file changed, 15 insertions(+), 14 deletions(-)
> > 
> > --- a/drivers/usb/host/Kconfig
> > +++ b/drivers/usb/host/Kconfig
> > @@ -181,26 +181,27 @@ config USB_OHCI_HCD_PPC_SOC
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
> 
> 


