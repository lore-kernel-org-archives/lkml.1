Return-Path: <linux-kernel-owner+w=401wt.eu-S1756123AbZCGC6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbZCGC6m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 21:58:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754501AbZCGC5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 21:57:41 -0500
Received: from kroah.org ([198.145.64.141]:35960 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754924AbZCGC5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 21:57:32 -0500
Date: Fri, 6 Mar 2009 18:40:06 -0800
From: Greg KH <greg@kroah.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Yu Zhao <yu.zhao@intel.com>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH v10 4/7] PCI: add SR-IOV API for Physical Function
	driver
Message-ID: <20090307024006.GE3596@kroah.com>
References: <1235112888-9524-1-git-send-email-yu.zhao@intel.com> <1235112888-9524-5-git-send-email-yu.zhao@intel.com> <20090306203717.GG25995@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090306203717.GG25995@parisc-linux.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 06, 2009 at 01:37:18PM -0700, Matthew Wilcox wrote:
> On Fri, Feb 20, 2009 at 02:54:45PM +0800, Yu Zhao wrote:
> > +	virtfn->sysdata = dev->bus->sysdata;
> > +	virtfn->dev.parent = dev->dev.parent;
> > +	virtfn->dev.bus = dev->dev.bus;
> > +	virtfn->devfn = devfn;
> > +	virtfn->hdr_type = PCI_HEADER_TYPE_NORMAL;
> > +	virtfn->cfg_size = PCI_CFG_SPACE_EXP_SIZE;
> > +	virtfn->error_state = pci_channel_io_normal;
> > +	virtfn->current_state = PCI_UNKNOWN;
> > +	virtfn->is_pcie = 1;
> > +	virtfn->pcie_type = PCI_EXP_TYPE_ENDPOINT;
> > +	virtfn->dma_mask = 0xffffffff;
> > +	virtfn->vendor = dev->vendor;
> > +	virtfn->subsystem_vendor = dev->subsystem_vendor;
> > +	virtfn->class = dev->class;
> 
> There seems to be a certain amount of commonality between this and
> pci_scan_device().  Have you considered trying to make a common helper
> function, or does it not work out well?
> 
> > +	pci_device_add(virtfn, virtfn->bus);
> 
> Greg is probably going to ding you here for adding the device, then
> creating the symlinks.  I believe it's now best practice to create the
> symlinks first, so there's no window where userspace can get confused.

If the uevent gets sent before the symlinks are created, it's a bug.

thanks,

greg k-h
