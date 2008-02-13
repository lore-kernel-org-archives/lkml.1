Return-Path: <linux-kernel-owner+w=401wt.eu-S1765795AbYBMRfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765795AbYBMRfu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 12:35:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933753AbYBMRe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 12:34:56 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45882 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933331AbYBMRey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 12:34:54 -0500
Date: Wed, 13 Feb 2008 09:28:24 -0800
From: Greg KH <greg@kroah.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, muli@il.ibm.com, jdmason@kudzu.us,
       linux-ide@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org, discuss@x86-64.org
Subject: Re: pci_get_device_reverse(), why does Calgary need this?
Message-ID: <20080213172824.GB10733@kroah.com>
References: <20080213001506.GA13933@kroah.com> <20080213021737.72b9815d@core> <20080213044536.GC10101@kroah.com> <200802131334.12351.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802131334.12351.bzolnier@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 01:34:12PM +0100, Bartlomiej Zolnierkiewicz wrote:
> On Wednesday 13 February 2008, Greg KH wrote:
> > On Wed, Feb 13, 2008 at 02:17:37AM +0000, Alan Cox wrote:
> > > > Why does the calgary driver need this?  Can we just use pci_get_device()
> > > > instead?  Why do you need to walk the device list backwards?  Do you get
> > > > false positives going forward?
> > > 
> > > It doesn't look to be performance critical so the driver can
> > > pci_get_device until the end and use the final hit anyway.
> > 
> > That would make more sense.
> > 
> > > IDE reverse is more problematic but nobody seems to use it.
> > 
> > I've seen two posters say they use it.  I'm wondering what it is really
> > solving if they use it, and why if it's really needed, scsi never had to
> > implement such a hack...
> 
> It is no longer solving anything, just adds more pain. ;)
> 
> [ The option comes from 2.2.x (so long before LABEL=/ and /dev/disk/by-id/
>   became popular).  Some "off-board" controllers integrated on motherboards
>   used to appear before "on-board" IDE on PCI bus so this option was meant
>   to preserve the legacy ordering. ]
> 
> Since it is valid only when "Probe IDE PCI devices in the PCI bus order
> (DEPRECATED)" config option is used it is already on its way out (though
> marking it as obsoleted would make it more explicit).
> 
> I think that removing "ide=reverse" in 2.6.26 would be OK...

Great, thanks for your blessing.  I'll make up a patch and send it to
you for approval.

thanks,

greg k-h
