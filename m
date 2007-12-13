Return-Path: <linux-kernel-owner+w=401wt.eu-S1763163AbXLMUKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763163AbXLMUKr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 15:10:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765322AbXLMUKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 15:10:25 -0500
Received: from mga03.intel.com ([143.182.124.21]:60612 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764560AbXLMUKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 15:10:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,163,1196668800"; 
   d="scan'208";a="340550452"
From: Jesse Barnes <jesse.barnes@intel.com>
To: benh@kernel.crashing.org
Subject: Re: Possible issue with dangling PCI BARs
Date: Thu, 13 Dec 2007 12:04:17 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Robert Hancock <hancockr@shaw.ca>, linux-pci@atrey.karlin.mff.cuni.cz,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <fa.YfTvVN5C3e6zwXPW5biWgeZ9XXc@ifi.uio.no> <1197544621.15741.132.camel@pasglop> <1197544820.15741.137.camel@pasglop>
In-Reply-To: <1197544820.15741.137.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712131204.18227.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 13, 2007 3:20 Benjamin Herrenschmidt wrote:
> > > Supporting pci_enable_device_io / pci_enable_device_mmio /
> > > pci_iomap_io / pci_iomap_mmio seems to cover pretty much all the
> > > use cases we have.
> > >
> > > The users we have right now that are:
> > >
> > >         - pata_cs5520   (can be dealt with easily)
> > >         - old IDE       (with the new resource handling for
> > > legacy IDE can use pci_enable_device_io I think, ditto
> > > pci/cs5520)
> > >         - scx200_acb    (looks like a simple substitution works)
> > >         - lpfc          pci_enable_device_mmio
> > >         - qla2xxx       pci_enable_device ? (enables IO and MMIO)
>
> I may have not fully undestood you in my previous reply. You are
> proposing replacing pci_enable_device_bars() with a pair of
> pci_enable_device_io/mem ?
>
> I think that would be a good idea indeed.

Yeah, that seems like a reasonable compromise.  Though in practice I'd 
expect the full disable decode approach to work fairly well too.  I 
mean, if we really end up failing to allocate space for the device with 
the root drive on it, there are probably bigger issues than just 
failing to get a few bytes of I/O space for it...

OTOH like Robert said, many devices really only need either MMIO or IO 
space enabled, not both, so having separate enable/disable routines for 
them makes a lot of sense.

Jesse
