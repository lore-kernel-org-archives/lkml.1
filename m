Return-Path: <linux-kernel-owner+w=401wt.eu-S1760133AbZASXvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760133AbZASXvg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 18:51:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbZASXv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 18:51:26 -0500
Received: from h4320.serverkompetenz.net ([81.169.172.102]:46167 "EHLO
	www.deb-support.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752127AbZASXvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 18:51:25 -0500
Date: Mon, 19 Jan 2009 23:51:22 +0000
From: Michael Bramer <michael@debsupport.de>
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH] drivers/serial/8250_pci.c (add support for '8-port RS-232 MIC-3620 from advantech'
Message-ID: <20090119235122.GE21026@deb-support.de>
References: <20090118135359.GA3087@deb-support.de> <20090119145101.GA16732@ports.donpac.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090119145101.GA16732@ports.donpac.ru>
User-Agent: Mutt/1.5.9i
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: grisu@deb-support.de
X-SA-Exim-Scanned: No (on www.deb-support.de); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 05:51:01PM +0300, Andrey Panin wrote:
> On 018, 01 18, 2009 at 01:53:59PM +0000, Michael Bramer wrote:
> > Hello
> > 
> > This is my first mail to this list... sorry for all my mistakes
> > 
> > We use a 8-port RS-232 MIC-3620 from advantech (see
> > http://www.advantech.com/products/8-port-RS-232-Communication-CPCI-Card/mod_1-2MLG80.aspx)
> > and need linux support for this card.
> > 
> > This patch add is:
> > -------------------------------------
> > --- a/drivers/serial/8250_pci.c
> > +++ b/drivers/serial/8250_pci.c
> > @@ -768,6 +769,8 @@
> >  #define PCI_SUBDEVICE_ID_OCTPRO422      0x0208
> >  #define PCI_SUBDEVICE_ID_POCTAL232      0x0308
> >  #define PCI_SUBDEVICE_ID_POCTAL422      0x0408
> > +#define PCI_VENDOR_ID_ADVANTECH         0x13fe
> > +#define PCI_DEVICE_ID_ADVANTECH_PCI3620 0x3620
> > 
> >  /*
> >   * Master list of serial port init/setup/exit quirks.
> > @@ -789,6 +792,16 @@
> >                 .setup          = addidata_apci7800_setup,
> >         },
> >         /*
> > +        * ADVANTECH
> > +        */
> > +       {
> > +               .vendor         = PCI_VENDOR_ID_ADVANTECH,
> > +               .device         = PCI_DEVICE_ID_ADVANTECH_PCI3620,
> > +               .subvendor      = PCI_DEVICE_ID_ADVANTECH_PCI3620,
> > +               .subdevice      = PCI_ANY_ID,
> > +               .setup          = pci_default_setup,
> > +       },
> > +       /*
> >          * AFAVLAB cards - these may be called via parport_serial
> >          *  It is not clear whether this applies to all products.
> >          */
> 
> This part is not needed at all, pci_default_setup() will be used by default.

ok. I don't test this. But you are right. The last entry in
pci_serial_quirks should catch it. 

This make the patch to a 'add only 5 lines for support of 8
Ports'-Patch. :-)

Should I post a new patch, without this 10 lines?

BTW: there are one other card's with a part like this:
 - PCI_DEVICE_ID_PLX_9030
  
Gruss
Grisu
-- 
Michael Bramer  -- http://www.feuerwehr.kreuzau.de/wiki/
PGP: finger grisu@db.debian.org  -- Linux Sysadmin   -- Use Debian Linux
"Wenn ich die Folgen geahnt hätte, wäre ich Uhrmacher geworden!"
                                                 --- Albert Einstein
