Return-Path: <linux-kernel-owner+w=401wt.eu-S1755564AbZGOWJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbZGOWJN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 18:09:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754914AbZGOWJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 18:09:13 -0400
Received: from cantor.suse.de ([195.135.220.2]:44121 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793AbZGOWJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 18:09:12 -0400
Date: Wed, 15 Jul 2009 15:08:29 -0700
From: Greg KH <gregkh@suse.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: anthony@codemonkey.ws, avi@redhat.com, kvm@vger.kernel.org,
       chrisw@redhat.com, hjk@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4] uio: add generic driver for PCI 2.3 devices
Message-ID: <20090715220829.GB31962@suse.de>
References: <20090715201340.GA12279@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090715201340.GA12279@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 11:13:40PM +0300, Michael S. Tsirkin wrote:
> This adds a generic uio driver that can bind to any PCI device.  First
> user will be virtualization where a qemu userspace process needs to give
> guest OS access to the device.
> 
> Interrupts are handled using the Interrupt Disable bit in the PCI command
> register and Interrupt Status bit in the PCI status register.  All devices
> compliant to PCI 2.3 (circa 2002) and all compliant PCI Express devices should
> support these bits.  Driver detects this support, and won't bind to devices
> which do not support the Interrupt Disable Bit in the command register.
> 
> It's expected that more features of interest to virtualization will be
> added to this driver in the future. Possibilities are: mmap for device
> resources, MSI/MSI-X, eventfd (to interface with kvm), iommu.
> 
> Acked-by: Chris Wright <chrisw@redhat.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
> 
> Hans, Greg, please review and consider for upstream.
> 
> This is intended to solve the problem in virtualization that shared
> interrupts do not work with assigned devices. Earlier versions of this
> patch have circulated on kvm@vger.

How does this play with the pci-stub driver that I thought was written
to solve this very problem?  Will it conflict?

In fact, it looks like you copied the comments for this driver directly
from the pci-stub driver :)

How about moving that documentation into a place that people will notice
it, like the rest of the UIO documentation?

And right now you are just sending the irq to userspace, what is
userspace supposed to do with it?  Do you have a userspace program that
uses this interface today to verify that everything works?  If so, care
to provide a pointer to it?

thanks,

greg k-h
