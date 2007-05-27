Return-Path: <linux-kernel-owner+w=401wt.eu-S1757992AbXE0AQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992AbXE0AQv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 20:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbXE0AQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 20:16:43 -0400
Received: from colo.lackof.org ([198.49.126.79]:49256 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898AbXE0AQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 20:16:43 -0400
Date: Sat, 26 May 2007 18:16:31 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: David Miller <davem@davemloft.net>
Cc: grundler@parisc-linux.org, abraham.manu@gmail.com, rdreier@cisco.com,
       greg@kroah.com, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org
Subject: Re: PCIE
Message-ID: <20070527001631.GC31023@colo.lackof.org>
References: <46584C30.4030206@gmail.com> <20070526.154910.78725926.davem@davemloft.net> <20070526235515.GA31023@colo.lackof.org> <20070526.170039.119261389.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070526.170039.119261389.davem@davemloft.net>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 26, 2007 at 05:00:39PM -0700, David Miller wrote:
> From: Grant Grundler <grundler@parisc-linux.org>
> Date: Sat, 26 May 2007 17:55:15 -0600
> 
> > MSI (and MSI-X) vectors are required to be exclusive.
> > I submitted that change to pci.txt last year:
> > 	http://lkml.org/lkml/2006/12/25/2
> > 
> > and ISTR I've posted that bit of the PCI spec a few years ago.
> > But it probably was to linux-pci mailing list only.
> 
> This requirement only extends to the PCI host controller,
> how that interfaces to the cpu and it's limitations is
> an entirely other matter.

Are they really? The device is generating the transaction on the bus.
The PCI host controller (in general) will be routing that transaction
to wherever the "dest addr" of the MSI lives. It doesn't have to be
in the CPU but it will certainly be a proxy for that CPU if it's not.
We won't care if the proxy only have one IRQ line going to the CPU
as long as the de-muxing of the "data" portion results in a unique
identifier that can be mapped to exactly one interrupt handler.

> > The cpus haven't been using interrupt pins for a long time now.
> > Anything with a Local-xAPIC is already using transactions to
> > signal interrupts even if the OS isn't aware of it.
> 
> I'm not talking about x86, x86_64, et al.
> 
> I'm talking about embedded ARM chips and the like, and yes they
> very possibly will be using PCI-E controllers at some point.

It doesn't matter if it's embedded or not.  Trying to share what
is the equivalent to an "edge triggered" interrupt is futile.
MSI "vectors" need to be exclusive.

thanks,
grant
