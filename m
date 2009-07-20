Return-Path: <linux-kernel-owner+w=401wt.eu-S1753565AbZGTSUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbZGTSUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 14:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbZGTSUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 14:20:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40826 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255AbZGTSUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 14:20:30 -0400
Date: Mon, 20 Jul 2009 21:19:19 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Hans J. Koch" <hjk@linutronix.de>, anthony@codemonkey.ws, avi@redhat.com,
       kvm@vger.kernel.org, chrisw@redhat.com, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4] uio: add generic driver for PCI 2.3 devices
Message-ID: <20090720181919.GA18747@redhat.com>
References: <20090715201340.GA12279@redhat.com> <20090715213909.GA3637@local> <20090720101702.68fee1ab@jbarnes-g45>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090720101702.68fee1ab@jbarnes-g45>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 10:17:02AM -0700, Jesse Barnes wrote:
> On Wed, 15 Jul 2009 23:39:11 +0200
> "Hans J. Koch" <hjk@linutronix.de> wrote:
> 
> > On Wed, Jul 15, 2009 at 11:13:40PM +0300, Michael S. Tsirkin wrote:
> > > This adds a generic uio driver that can bind to any PCI device.
> > > First user will be virtualization where a qemu userspace process
> > > needs to give guest OS access to the device.
> > > 
> > > Interrupts are handled using the Interrupt Disable bit in the PCI
> > > command register and Interrupt Status bit in the PCI status
> > > register.  All devices compliant to PCI 2.3 (circa 2002) and all
> > > compliant PCI Express devices should support these bits.  Driver
> > > detects this support, and won't bind to devices which do not
> > > support the Interrupt Disable Bit in the command register.
> > > 
> > > It's expected that more features of interest to virtualization will
> > > be added to this driver in the future. Possibilities are: mmap for
> > > device resources, MSI/MSI-X, eventfd (to interface with kvm), iommu.
> > 
> > Well, I'm not enough of a PCI expert to tell whether your 2.3-test
> > works or not (can it have side effects, e.g. trigger an interrupt
> > when you toggle that bit?). I've added Jesse Barnes to Cc: since you
> > modify a PCI core header file. If there are no objections from the
> > PCI people, I guess we can take this.
> 
> pci_reg.h portion looks fine to me, and only supporting devices with
> the interrupt disable bit certainly simplifies things.  There were some
> other questions on the thread though (like Greg's similar driver); not
> sure if you've answered those yet.

Yes, and Greg seems satisfied :). See 20090716181919.GB27811@suse.de.
Chris Wright (author of pci-stub that was mentioned) also acked the
patch.

> -- 
> Jesse Barnes, Intel Open Source Technology Center
