Return-Path: <linux-kernel-owner+w=401wt.eu-S1761909AbZATPMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761909AbZATPMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 10:12:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755769AbZATPMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 10:12:21 -0500
Received: from ports.donpac.ru ([80.254.111.81]:33615 "EHLO ports.donpac.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754977AbZATPMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 10:12:20 -0500
Date: Tue, 20 Jan 2009 18:12:16 +0300
From: Andrey Panin <pazke@donpac.ru>
To: Michael Bramer <michael@debsupport.de>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH] drivers/serial/8250_pci.c (add support for '8-port RS-232 MIC-3620 from advantech'
Message-ID: <20090120151216.GB16732@ports.donpac.ru>
Mail-Followup-To: Michael Bramer <michael@debsupport.de>,
	linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
References: <20090118135359.GA3087@deb-support.de> <20090119145101.GA16732@ports.donpac.ru> <20090119235122.GE21026@deb-support.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090119235122.GE21026@deb-support.de>
X-Uname: Linux 2.6.18-4-powerpc64 ppc64
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 019, 01 19, 2009 at 11:51:22PM +0000, Michael Bramer wrote:
> On Mon, Jan 19, 2009 at 05:51:01PM +0300, Andrey Panin wrote:
> > On 018, 01 18, 2009 at 01:53:59PM +0000, Michael Bramer wrote:
> > > Hello
> > > 
> > > This is my first mail to this list... sorry for all my mistakes
> > > 
> > > We use a 8-port RS-232 MIC-3620 from advantech (see
> > > http://www.advantech.com/products/8-port-RS-232-Communication-CPCI-Card/mod_1-2MLG80.aspx)
> > > and need linux support for this card.
> > > 
> > > This patch add is:
> > > -------------------------------------
> > > --- a/drivers/serial/8250_pci.c
> > > +++ b/drivers/serial/8250_pci.c
> > > @@ -768,6 +769,8 @@
> > >  #define PCI_SUBDEVICE_ID_OCTPRO422      0x0208
> > >  #define PCI_SUBDEVICE_ID_POCTAL232      0x0308
> > >  #define PCI_SUBDEVICE_ID_POCTAL422      0x0408
> > > +#define PCI_VENDOR_ID_ADVANTECH         0x13fe
> > > +#define PCI_DEVICE_ID_ADVANTECH_PCI3620 0x3620
> > > 
> > >  /*
> > >   * Master list of serial port init/setup/exit quirks.
> > > @@ -789,6 +792,16 @@
> > >                 .setup          = addidata_apci7800_setup,
> > >         },
> > >         /*
> > > +        * ADVANTECH
> > > +        */
> > > +       {
> > > +               .vendor         = PCI_VENDOR_ID_ADVANTECH,
> > > +               .device         = PCI_DEVICE_ID_ADVANTECH_PCI3620,
> > > +               .subvendor      = PCI_DEVICE_ID_ADVANTECH_PCI3620,
> > > +               .subdevice      = PCI_ANY_ID,
> > > +               .setup          = pci_default_setup,
> > > +       },
> > > +       /*
> > >          * AFAVLAB cards - these may be called via parport_serial
> > >          *  It is not clear whether this applies to all products.
> > >          */
> > 
> > This part is not needed at all, pci_default_setup() will be used by default.
> 
> ok. I don't test this. But you are right. The last entry in
> pci_serial_quirks should catch it. 
> 
> This make the patch to a 'add only 5 lines for support of 8
> Ports'-Patch. :-)
> 
> Should I post a new patch, without this 10 lines?

Yes and add Signed-off-by: line please.

> BTW: there are one other card's with a part like this:
>  - PCI_DEVICE_ID_PLX_9030

We can safely remove it.

> Gruss
> Grisu
> -- 
> Michael Bramer  -- http://www.feuerwehr.kreuzau.de/wiki/
> PGP: finger grisu@db.debian.org  -- Linux Sysadmin   -- Use Debian Linux
> "Wenn ich die Folgen geahnt h?tte, w?re ich Uhrmacher geworden!"
>                                                  --- Albert Einstein
