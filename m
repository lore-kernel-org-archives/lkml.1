Return-Path: <linux-kernel-owner+w=401wt.eu-S1756255AbXJAQ0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255AbXJAQ0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 12:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756041AbXJAQ0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 12:26:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47358 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756037AbXJAQ0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 12:26:36 -0400
Date: Mon, 1 Oct 2007 09:25:46 -0700
From: Greg KH <greg@kroah.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jeff Garzik <jgarzik@pobox.com>, Ayaz Abdulla <aabdulla@nvidia.com>,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: nVidia's MCP61 ethernet card needs quirk for
	wrong class
Message-ID: <20071001162546.GB6051@kroah.com>
References: <Pine.LNX.4.64.0710011615390.7567@jikos.suse.cz> <47010832.8010401@pobox.com> <Pine.LNX.4.64.0710011647000.7567@jikos.suse.cz> <47010A34.9000709@pobox.com> <Pine.LNX.4.64.0710011656090.7567@jikos.suse.cz> <47010E01.2010001@pobox.com> <Pine.LNX.4.64.0710011720210.7567@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710011720210.7567@jikos.suse.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2007 at 05:24:37PM +0200, Jiri Kosina wrote:
> On Mon, 1 Oct 2007, Jeff Garzik wrote:
> > > What would you recommend as a method for userspace to detect whether 
> > > given hardware is a network card, supposing that there is no driver 
> > > bound to it yet?
> > Note the mention of "weird cases" You come up with a general method, 
> > then you have to deal with exceptions to that general method.
> 
> Sure. Still don't see why to do it in kernel, when it is hardware-related 
> though.

I'll defer to Jeff's judgement here.  If the device is broken such that
it does not know to return the correct class, then we need to be able to
have a "quirk" table in the userspace tools to handle the list of
devices that are broken in that way.

For config items, we don't want to modify them in any way, we just want
to pass-through the data direct from the device.  Look at the sysfs and
proc files for pci config spaces.  They are returning binary data stored
in the device directly.  We do not want to have to start modifying that
data directly just to handle messed up devices like this.

So this should be handled by yast or other userspace programs properly,
not by changing the kernel to lie.

> > Another example:  8139too and 8139cp both claim to support 
> > (0x10EC,0x8139) PCI IDs.  The distro installer needs additional 
> > information to know to read the PCI revision, which is what determines 
> > whether or not to use 8139cp driver.
> 
> That's also pretty ugly, sure.
> 
> > Sometimes life is just not as simple as you would like it to be :)
> 
> You tell me :) There is a load of quirks for individual devices that claim 
> themselves to be HID-compliant, but break the specs in various different 
> creative ways :)

That is done purely due to the way that Microsoft wrote their operating
system.  The only way to write a userspace USB driver on windows is to
have it claim to be a HID device.  Then the kernel driver correctly
grabs it, and allows userspace programs to take over control of it.

That is why we have such a huge blacklist of HID devices in our kernel,
and so does Apple.  All because Windows can not easily handle something
we have been doing for over 7 years now.

And yes, you can now write userspace drivers for all USB devices on
Windows now, but you still have to get your userspace-driver signed, and
the interface is so horrible it's not even funny, so companies are still
avoiding it and using the old "make it claim to be a hid device" hack
for new devices.

So the HID table examples really have nothing to do with the broken
network device, as the HID devices are purposfully created that way.
For this network device, someone just messed up at the manufacturer :)

thanks,

greg k-h
