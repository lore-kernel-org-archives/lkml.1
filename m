Return-Path: <linux-kernel-owner+w=401wt.eu-S934812AbXGMGK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934812AbXGMGK7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 02:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933813AbXGMGKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 02:10:51 -0400
Received: from gate.crashing.org ([63.228.1.57]:50541 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933043AbXGMGKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 02:10:50 -0400
Date: Fri, 13 Jul 2007 01:10:46 -0500 (CDT)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@gate.crashing.org
To: Greg KH <greg@kroah.com>
cc: linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: Move prototypes for EXPORT_SYMBOL functions to
 include/linux/pci.h
In-Reply-To: <20070713060511.GA23618@kroah.com>
Message-ID: <Pine.LNX.4.64.0707130108490.25195@gate.crashing.org>
References: <Pine.LNX.4.64.0707130015550.1975@blarg.am.freescale.net>
 <20070713053303.GB17039@kroah.com> <9A567C91-1DE7-46CC-91A0-58D498B8248B@kernel.crashing.org>
 <20070713060511.GA23618@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2007, Greg KH wrote:

> On Fri, Jul 13, 2007 at 12:55:39AM -0500, Kumar Gala wrote:
> >
> >  On Jul 13, 2007, at 12:33 AM, Greg KH wrote:
> >
> > > On Fri, Jul 13, 2007 at 12:16:29AM -0500, Kumar Gala wrote:
> > >> pci_do_scan_bus() and pci_bus_find_capability() are marked EXPORT_SYMBOL
> > >> and thus usable outside of the PCI drive core itself.  Make the prototypes
> > >> for these functions accessible to everyone.
> > >
> > > Well, no, I'd like to only have the pci hotplug drivers use them if
> > > possible.  So until we have proper namespaces on the exported symbols,
> > > I'd really like to keep these as-is if possible.
> > >
> > > Or are you needing these symbols for some code outside of the
> > > drivers/pci/ directory tree?
> >
> >  I need pci_bus_find_capability() in arch/powerpc pci code.
> >
> >  I'm using it as a way to tell if we are a PCIe PHB.
>
> Ok, care to export only that function then?

that's fine, will do.

I assume we want to kill the prototype pci_bus_alloc_resource() in
drivers/pci/pci.h since its duplicated in include/linux/pci.h

Also, I wasn't sure 'extern int pci_bus_find_capability'.. or just 'int
pci_bus_find_capability'?

-k
