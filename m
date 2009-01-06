Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbZAFTqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbZAFTqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 14:46:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbZAFTqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 14:46:03 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37569 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136AbZAFTqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 14:46:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [PATCH] x86 PCI: Do not use interrupt links for devices using MSI-X
Date: Tue, 6 Jan 2009 20:45:19 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <200901042308.42625.rjw@sisk.pl> <200901061019.04488.bjorn.helgaas@hp.com>
In-Reply-To: <200901061019.04488.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901062045.21766.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 January 2009, Bjorn Helgaas wrote:
> On Sunday 04 January 2009 03:08:42 pm Rafael J. Wysocki wrote:
> > pcibios_enable_device() and pcibios_disable_device() don't handle
> > IRQs for devices that have MSI enabled and it should tread the
> > devices with MSI-X enabled in the same way.
> 
> There are other places that need similar fixes, too, aren't there?
> I see cris, frv, ia64, and a driver or two testing dev->msi_enabled.

Well, I didn't look at the other places, just found this one while reviewing
the code.

I'll check them later this week.
 
> > --- linux-2.6.orig/arch/x86/pci/common.c
> > +++ linux-2.6/arch/x86/pci/common.c
> > @@ -551,14 +551,14 @@ int pcibios_enable_device(struct pci_dev
> >  	if ((err = pci_enable_resources(dev, mask)) < 0)
> >  		return err;
> >  
> > -	if (!dev->msi_enabled)
> > +	if (!dev->msi_enabled && !dev->msix_enabled)
> >  		return pcibios_enable_irq(dev);
> >  	return 0;
> >  }
> >  
> >  void pcibios_disable_device (struct pci_dev *dev)
> >  {
> > -	if (!dev->msi_enabled && pcibios_disable_irq)
> > +	if (!dev->msi_enabled && !dev->msix_enabled && pcibios_disable_irq)
> >  		pcibios_disable_irq(dev);
> >  }
