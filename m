Return-Path: <linux-kernel-owner+w=401wt.eu-S1754609AbXJARRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbXJARRl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 13:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbXJARRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 13:17:34 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54823 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbXJARRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 13:17:33 -0400
Date: Mon, 1 Oct 2007 10:15:43 -0700
From: Greg KH <greg@kroah.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jiri Kosina <jkosina@suse.cz>, Jeff Garzik <jgarzik@pobox.com>,
       Ayaz Abdulla <aabdulla@nvidia.com>, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: nVidia's MCP61 ethernet card needs quirk for
	wrong class
Message-ID: <20071001171543.GA6653@kroah.com>
References: <Pine.LNX.4.64.0710011615390.7567@jikos.suse.cz> <47010832.8010401@pobox.com> <Pine.LNX.4.64.0710011647000.7567@jikos.suse.cz> <47010A34.9000709@pobox.com> <Pine.LNX.4.64.0710011656090.7567@jikos.suse.cz> <47010E01.2010001@pobox.com> <Pine.LNX.4.64.0710011720210.7567@jikos.suse.cz> <20071001162546.GB6051@kroah.com> <20071001170337.GJ12049@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071001170337.GJ12049@parisc-linux.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2007 at 11:03:38AM -0600, Matthew Wilcox wrote:
> On Mon, Oct 01, 2007 at 09:25:46AM -0700, Greg KH wrote:
> > For config items, we don't want to modify them in any way, we just want
> > to pass-through the data direct from the device.  Look at the sysfs and
> > proc files for pci config spaces.  They are returning binary data stored
> > in the device directly.  We do not want to have to start modifying that
> > data directly just to handle messed up devices like this.
> 
> Nobody's talking about changing the raw pci data.  What we're talking
> about is changing the value read out of
> 
> $ cat /sys/bus/pci/devices/0000\:00\:00.0/class 
> 0x060000

I know, but the next request will be to also fix up those raw values as
someone will have a tool that only uses them :)

> We do tweak at least some of the other similar values (vendor, for sure)
> to work around bugs; not sure we have an example for changing the class
> value yet.
> 
> pciutils knows that the kernel has potentially fixed up the values in
> the individual files, and to trust those over the raw data.

Ah, cool, I didn't realize that pciutils handled this kind of mismatch.
That's good to know.

thanks,

greg k-h
