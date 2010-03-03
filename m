Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab0CCQOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 11:14:36 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:41936 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab0CCQOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 11:14:35 -0500
Date: Wed, 3 Mar 2010 17:14:28 +0100
From: Bastian Blank <waldi@debian.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 4 of 4] Linux pvops: xen pci platform
	device driver
Message-ID: <20100303161428.GB26656@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <waldi@debian.org>,
	Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
	"xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <alpine.DEB.2.00.1003021748250.22259@kaball-desktop> <20100303121726.GA26656@wavehammer.waldi.eu.org> <alpine.DEB.2.00.1003031520320.4648@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1003031520320.4648@kaball-desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 03:52:07PM +0000, Stefano Stabellini wrote:
> On Wed, 3 Mar 2010, Bastian Blank wrote:
> > Why is version 1 grant table the default on HVM?
> Because version 2 is known not to work on HVM, fixing this is on my TODO
> list.

Well, then the later modification to 2 in the hvm case is bogus.

> > > +/* NB. [aux-]ide-disks options do not unplug IDE CD-ROM drives. */
> > > +/* NB. aux-ide-disks is equiv to ide-disks except ignores primary master. */
> > > +static char *dev_unplug;
> > > +module_param(dev_unplug, charp, 0644);
> > > +MODULE_PARM_DESC(dev_unplug, "Emulated devices to unplug: "
> > > +		 "[all,][ide-disks,][aux-ide-disks,][nics]\n");
> > 
> > What is this parameter about?
> 
> During the initialization of the xen pci device driver, we write to a
> magic ioport that causes qemu to unplug some emulated devices, disc and
> network in particular.
> This parameter is meant to present the user a choice about what emulated
> devices to unplug.

Somehow I don't think this belongs here. It looks like a workaround, you
can always ask qemu to not bind them at the beginning and the guest
system to not provide drivers.

> > > +#define XEN_IOPORT_BASE 0x10
> > 
> > Why are this constants defined in the driver themself? They only make
> > sense if there are two components making use of them.
> Yep, the other one is qemu.

Well, if it is a published interface move it into a header file.

> > > +	if (request_mem_region(mmio_addr, mmio_len, DRV_NAME) == NULL) {
> > > +		printk(KERN_ERR ":MEM I/O resource 0x%lx @ 0x%lx busy\n",
> > > +		       mmio_addr, mmio_len);
> > > +		return -EBUSY;
> > 
> > Why is this a sign of busy?
> 
> I think we were just trying to follow the behaviour of the other drivers
> of real pci devices.
> I am not sure how this condition could happen on Xen.

I checked again. There are many different return values used, but EBUSY
seems to be the most.

Bastian

-- 
The heart is not a logical organ.
		-- Dr. Janet Wallace, "The Deadly Years", stardate 3479.4
