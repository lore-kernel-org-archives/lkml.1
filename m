Return-Path: <linux-kernel-owner+w=401wt.eu-S1751837AbXA0QTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837AbXA0QTh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 11:19:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbXA0QTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 11:19:37 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:51322 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbXA0QTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 11:19:36 -0500
Date: Sat, 27 Jan 2007 09:19:35 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Greg KH <greg@kroah.com>
Cc: Martin Mares <mj@ucw.cz>, colpatch@us.ibm.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [RFC] pci_bus conversion to struct device
Message-ID: <20070127161935.GB10427@parisc-linux.org>
References: <20070118005344.GA8391@kroah.com> <20070118022352.GA17531@parisc-linux.org> <mj+md-20070118.081204.18154.nikam@ucw.cz> <20070118090044.GA23596@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070118090044.GA23596@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 18, 2007 at 01:00:44AM -0800, Greg KH wrote:
> On Thu, Jan 18, 2007 at 09:14:06AM +0100, Martin Mares wrote:
> > Hello!
> > 
> > > I recommend we just delete the pci_bus class.  I don't think it serves
> > > any useful purpose.  The bridge can be inferred frmo the sysfs hierarchy
> > > (not to mention lspci will tell you).  The cpuaffinity file should be
> > > moved from the bus to the device -- it really doesn't make any sense to
> > > talk about which cpu a bus is affine to, only a device.
> > 
> > It doesn't seem to serve any useful purpose other than the affinity now,
> > but I still think that it conceptually belongs there, because it makes
> > sense to have per-bus attributes. For example, in the future we could
> > show data width and signalling speed.

Data width is kind of hard to figure out since it's negotiated per
transaction.  One could conceive of a device which only does 32-bit
transactions to some addresses, and 64-bit transactions to others.

What I've done in recent patches is make these kinds of attributes
available per slot.

> So, if it were to stay, where in the tree should it be?  Hanging off of
> the pci device that is the bridge?  Or just placing these files within
> the pci device directory itself, as it is the bridge.

/sys/bus/pci/busses ?

> There are also some "legacy io" binary sysfs files in these directories
> for those platforms that support it (#ifdef HAVE_PCI_LEGACY), and I'm
> guessing that there is some user for them out there, otherwise they
> would not have been added...
> 
> Hm, only ia64 enables that option.  Matthew, do you care about those
> files?

I think they were added for Altix ... not sure who uses them.  Maybe X?
