Return-Path: <linux-kernel-owner+w=401wt.eu-S1752327AbYDDVH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327AbYDDVH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 17:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196AbYDDVHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 17:07:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33143 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080AbYDDVHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 17:07:15 -0400
Date: Fri, 4 Apr 2008 14:01:32 -0700
From: Greg KH <gregkh@suse.de>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: pci: add to global list before sysfs?
Message-ID: <20080404210132.GA14418@suse.de>
References: <20080404191350.7f0183a5@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080404191350.7f0183a5@mjolnir.drzeus.cx>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2008 at 07:13:50PM +0200, Pierre Ossman wrote:
> Hi Greg,
> 
> I have a PCI hotplug problem I was hoping you could provide some
> insight into.
> 
> I want the PCI layer to make sure that all subfunctions of a newly
> added card are visible via pci_get_device() before any of them are
> binded to drivers. I.e. I want pci_bus_add_devices() to first make a
> pass and add the devices to the global list, then a second pass for
> device_add().

What "global list"?  You mean the one that I just deleted with my
patchset that is in -mm and going to be in 2.6.26?  :)

> The reason I want this is because I have at least two chips where I
> need to know which other subfunctions are present on the card in order
> to correctly initalise the subfunction I'm currently probing. Right now
> that fails miserably as the driver does not see the other devices in
> its probe function.

How will changing the addition of the device to the list affect this
behavior?  Do you want to walk the list in your driver's probe function,
looking for the "subfunction" that is not yet added to the list?

> Is it possible to do this or will things break left and right if I
> add them to the global list before I register them with the driver core?

As I mention above, the "global list" is now gone, so it's going to be a
bit harder to do this.  We now only keep one list of all PCI devices,
and that is with the driver core mechanisms as the duplicate list was
just sitting there doing nothing for the past 4 years.

So is the problem that your driver need to bind to multiple pci devices
at the same time in order to work properly?

Or is this just really broken hardware?

confused,

greg k-h
