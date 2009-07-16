Return-Path: <linux-kernel-owner+w=401wt.eu-S933021AbZGPSWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933021AbZGPSWr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 14:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933013AbZGPSWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 14:22:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54346 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933010AbZGPSWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 14:22:43 -0400
Date: Thu, 16 Jul 2009 11:19:19 -0700
From: Greg KH <gregkh@suse.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: anthony@codemonkey.ws, avi@redhat.com, kvm@vger.kernel.org,
       chrisw@redhat.com, hjk@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4] uio: add generic driver for PCI 2.3 devices
Message-ID: <20090716181919.GB27811@suse.de>
References: <20090715201340.GA12279@redhat.com>
 <20090715220829.GB31962@suse.de>
 <20090716123101.GA15975@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090716123101.GA15975@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 03:31:01PM +0300, Michael S. Tsirkin wrote:
> On Wed, Jul 15, 2009 at 03:08:29PM -0700, Greg KH wrote:
> > On Wed, Jul 15, 2009 at 11:13:40PM +0300, Michael S. Tsirkin wrote:
> > > This adds a generic uio driver that can bind to any PCI device.  First
> > > user will be virtualization where a qemu userspace process needs to give
> > > guest OS access to the device.
> > > 
> > > Interrupts are handled using the Interrupt Disable bit in the PCI command
> > > register and Interrupt Status bit in the PCI status register.  All devices
> > > compliant to PCI 2.3 (circa 2002) and all compliant PCI Express devices should
> > > support these bits.  Driver detects this support, and won't bind to devices
> > > which do not support the Interrupt Disable Bit in the command register.
> > > 
> > > It's expected that more features of interest to virtualization will be
> > > added to this driver in the future. Possibilities are: mmap for device
> > > resources, MSI/MSI-X, eventfd (to interface with kvm), iommu.
> > > 
> > > Acked-by: Chris Wright <chrisw@redhat.com>
> > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > ---
> > > 
> > > Hans, Greg, please review and consider for upstream.
> > > 
> > > This is intended to solve the problem in virtualization that shared
> > > interrupts do not work with assigned devices. Earlier versions of this
> > > patch have circulated on kvm@vger.
> > 
> > How does this play with the pci-stub driver that I thought was written
> > to solve this very problem?
> 
> 
> AFAIK the problem pci stub was written to solve is simply to bind to a
> device. You then have to use another kernel module which looks the
> device up with something like pci_get_bus_and_slot to do anything
> useful. In particular, for non-shared interrupts, we can disable the
> interrupt in the apic. But this does not work well for shared
> interrupts. Thus this work.
> 
> The uio driver will be used in virtualization scenarious, a couple
> of possible ones that have been mentioned on the kvm list are:
> - device assignment (guest access to device) for simple devices with
>   shared interrupts: emulating PCI is tricky enough to better be done in
>   userspace. shared interrupt support is important as it happens
>   with real devices
> - simple communication between guest and host:
>   we create a virtual device in host, and userspace
>   driver in guest gets events and passes them on
>   to e.g. dbus. shared interrupt support is important
>   to avoid wasting irqs

Ah, ok, thanks for all of the explanation, that makes sense.

greg k-h
