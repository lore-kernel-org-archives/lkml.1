Return-Path: <linux-kernel-owner+w=401wt.eu-S1758762AbXGCGXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762AbXGCGXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 02:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753480AbXGCGXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 02:23:10 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:37880 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbXGCGXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 02:23:09 -0400
From: Oliver Neukum <oliver@neukum.org>
To: linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] [PATCH 3/4] usb: allocated usb releated dma buffer =?iso-8859-1?q?with=09kmalloc=5Fnode?=
Date: Tue, 3 Jul 2007 08:23:07 +0200
User-Agent: KMail/1.9.7
Cc: Greg KH <greg@kroah.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
References: <200706291326.43563.yinghai.lu@sun.com> <86802c440707022233g2021b49dg48534f813f628585@mail.gmail.com> <20070703060155.GB19086@kroah.com>
In-Reply-To: <20070703060155.GB19086@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707030823.07815.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 3. Juli 2007 schrieb Greg KH:
> On Mon, Jul 02, 2007 at 10:33:12PM -0700, Yinghai Lu wrote:
> >  On 7/2/07, Greg KH <greg@kroah.com> wrote:
> > > On Mon, Jul 02, 2007 at 03:36:37PM -0700, Yinghai Lu wrote:
> > > > [PATCH 3/4] usb: allocated usb releated dma buffer with kmalloc_node
> > > >
> > > > For amd64 based two way system. USB always on node0. but dma buffer for 
> > > urb
> > > > allocated via kmalloc always get ram on node1. So change to kmalloc_node 
> > > to
> > > > get dma_buffer on corresponding node
> > >
> > > Are all of these changes really necessary?  You are doing this for some
> > > allocations that take a _long_ time when sending to the device due to
> > > the speed of the device.
> > >
> > > I could possibly see this making a difference on some drivers, but for
> > > the core, and for the basic USB structures, I can't imagine it is really
> > > worth it.
> > >
> > > Or do you have numbers showing the differences here?
> > >
> > > Patch included fully below for the benifit of the usb list, which you
> > > should have cc:ed...
> > 
> >  dma buffer could be allocated via alloc_pages_coherent. or
> >  kmalloc/dma_map_single.
> >  alloc_pages_coherent get the dma_buffer on corresponding node.
> >  but kmalloc/dma_map_single always get dma_buffer on last node. or say
> >  device is on HT chain node0,  it will get dma buffer on node 7 of 8
> >  socket system.
> >  also on two way system with 4G+4G RAM conf. device on node 0 will get
> >  dma_buffer above 4G, and if the dma_mask is less 32bit, will need
> >  extra iommu mapping.
> >  In my mcp55+io55 system, it show dma_map_single is keepping called by
> >  usb input: keyboard/mouse (8/0x40 bytes), and forcedeth. (0x670bytes)
> 
> Ok, so two drivers might need this, but not the whole usb core, right?

If those two drivers need the extended allocator, why not use it where
it is beneficial, even if the benefit is small?

	Regards
		Oliver
