Return-Path: <linux-kernel-owner+w=401wt.eu-S1758845AbXGCHDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758845AbXGCHDX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 03:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755532AbXGCHDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 03:03:16 -0400
Received: from canuck.infradead.org ([209.217.80.40]:60451 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658AbXGCHDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 03:03:16 -0400
Date: Tue, 3 Jul 2007 00:03:12 -0700
From: Greg KH <greg@kroah.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-usb-devel@lists.sourceforge.net, Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: Re: [linux-usb-devel] [PATCH 3/4] usb: allocated usb releated dma
	buffer with?kmalloc_node
Message-ID: <20070703070312.GA19924@kroah.com>
References: <200706291326.43563.yinghai.lu@sun.com> <86802c440707022233g2021b49dg48534f813f628585@mail.gmail.com> <20070703060155.GB19086@kroah.com> <200707030823.07815.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707030823.07815.oliver@neukum.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2007 at 08:23:07AM +0200, Oliver Neukum wrote:
> Am Dienstag, 3. Juli 2007 schrieb Greg KH:
> > On Mon, Jul 02, 2007 at 10:33:12PM -0700, Yinghai Lu wrote:
> > >  On 7/2/07, Greg KH <greg@kroah.com> wrote:
> > > > On Mon, Jul 02, 2007 at 03:36:37PM -0700, Yinghai Lu wrote:
> > > > > [PATCH 3/4] usb: allocated usb releated dma buffer with kmalloc_node
> > > > >
> > > > > For amd64 based two way system. USB always on node0. but dma buffer for 
> > > > urb
> > > > > allocated via kmalloc always get ram on node1. So change to kmalloc_node 
> > > > to
> > > > > get dma_buffer on corresponding node
> > > >
> > > > Are all of these changes really necessary?  You are doing this for some
> > > > allocations that take a _long_ time when sending to the device due to
> > > > the speed of the device.
> > > >
> > > > I could possibly see this making a difference on some drivers, but for
> > > > the core, and for the basic USB structures, I can't imagine it is really
> > > > worth it.
> > > >
> > > > Or do you have numbers showing the differences here?
> > > >
> > > > Patch included fully below for the benifit of the usb list, which you
> > > > should have cc:ed...
> > > 
> > >  dma buffer could be allocated via alloc_pages_coherent. or
> > >  kmalloc/dma_map_single.
> > >  alloc_pages_coherent get the dma_buffer on corresponding node.
> > >  but kmalloc/dma_map_single always get dma_buffer on last node. or say
> > >  device is on HT chain node0,  it will get dma buffer on node 7 of 8
> > >  socket system.
> > >  also on two way system with 4G+4G RAM conf. device on node 0 will get
> > >  dma_buffer above 4G, and if the dma_mask is less 32bit, will need
> > >  extra iommu mapping.
> > >  In my mcp55+io55 system, it show dma_map_single is keepping called by
> > >  usb input: keyboard/mouse (8/0x40 bytes), and forcedeth. (0x670bytes)
> > 
> > Ok, so two drivers might need this, but not the whole usb core, right?
> 
> If those two drivers need the extended allocator, why not use it where
> it is beneficial, even if the benefit is small?

What is the benefit?  Speed isn't an issue here, so what is?

thanks,

greg k-h
