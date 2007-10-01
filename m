Return-Path: <linux-kernel-owner+w=401wt.eu-S1754863AbXJARDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbXJARDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 13:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbXJARDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 13:03:40 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:54063 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbXJARDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 13:03:39 -0400
Date: Mon, 1 Oct 2007 11:03:38 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Greg KH <greg@kroah.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Jeff Garzik <jgarzik@pobox.com>,
       Ayaz Abdulla <aabdulla@nvidia.com>, linux-pci@atrey.karlin.mff.cuni.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: nVidia's MCP61 ethernet card needs quirk for wrong class
Message-ID: <20071001170337.GJ12049@parisc-linux.org>
References: <Pine.LNX.4.64.0710011615390.7567@jikos.suse.cz> <47010832.8010401@pobox.com> <Pine.LNX.4.64.0710011647000.7567@jikos.suse.cz> <47010A34.9000709@pobox.com> <Pine.LNX.4.64.0710011656090.7567@jikos.suse.cz> <47010E01.2010001@pobox.com> <Pine.LNX.4.64.0710011720210.7567@jikos.suse.cz> <20071001162546.GB6051@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071001162546.GB6051@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2007 at 09:25:46AM -0700, Greg KH wrote:
> I'll defer to Jeff's judgement here.  If the device is broken such that
> it does not know to return the correct class, then we need to be able to
> have a "quirk" table in the userspace tools to handle the list of
> devices that are broken in that way.

I think Jeff is right on this particular point -- better to have this
worked around in the userspace tool than in the kernel.

> For config items, we don't want to modify them in any way, we just want
> to pass-through the data direct from the device.  Look at the sysfs and
> proc files for pci config spaces.  They are returning binary data stored
> in the device directly.  We do not want to have to start modifying that
> data directly just to handle messed up devices like this.

Nobody's talking about changing the raw pci data.  What we're talking
about is changing the value read out of

$ cat /sys/bus/pci/devices/0000\:00\:00.0/class 
0x060000

We do tweak at least some of the other similar values (vendor, for sure)
to work around bugs; not sure we have an example for changing the class
value yet.

pciutils knows that the kernel has potentially fixed up the values in
the individual files, and to trust those over the raw data.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
