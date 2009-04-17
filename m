Return-Path: <linux-kernel-owner+w=401wt.eu-S1759412AbZDQCid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759412AbZDQCid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 22:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759541AbZDQCiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 22:38:21 -0400
Received: from sh.osrg.net ([192.16.179.4]:46501 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759439AbZDQCiT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 22:38:19 -0400
Date: Fri, 17 Apr 2009 11:38:09 +0900
To: dan.j.williams@intel.com
Cc: a.beregalov@gmail.com, kernel-testers@vger.kernel.org,
       linux-kernel@vger.kernel.org, maciej.sosnowski@intel.com
Subject: Re: 2.6.30-rc1: ioatdma: DMA-API: device driver frees DMA memory
 with 	wrong function
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <e9c3a7c20904151027xdf617fbh64fcb5618e195a71@mail.gmail.com>
References: <a4423d670904090536j71be609csf2c32be3ed9cfe1e@mail.gmail.com>
	<a4423d670904150539w1a4fe05ake75ce2aea4538eab@mail.gmail.com>
	<e9c3a7c20904151027xdf617fbh64fcb5618e195a71@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-Id: <20090417113814J.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 17 Apr 2009 11:38:10 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Apr 2009 10:27:48 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> On Wed, Apr 15, 2009 at 5:39 AM, Alexander Beregalov
> <a.beregalov@gmail.com> wrote:
> > 2009/4/9 Alexander Beregalov <a.beregalov@gmail.com>:
> >> ioatdma 0000:00:08.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> >> ioatdma 0000:00:08.0: setting latency timer to 64
> >> ioatdma 0000:00:08.0: Intel(R) I/OAT DMA Engine found, 4 channels,
> >> device version 0x12, driver version 3.64
> >>  alloc irq_desc for 33 on cpu 0 node 0
> >>  alloc kstat_irqs on cpu 0 node 0
> >> ioatdma 0000:00:08.0: irq 33 for MSI/MSI-X
> >> ------------[ cut here ]------------
> >> WARNING: at lib/dma-debug.c:565 check_unmap+0x2f6/0x6a0()
> >> Hardware name: PowerEdge 1950
> >> ioatdma 0000:00:08.0: DMA-API: device driver frees DMA memory with
> >> wrong function [device address=0x000000007f76f800] [size=2000 bytes]
> >> [map
> >> ped as single] [unmapped as page]
> >
> > The problem still persists.
> 
> Thanks for the report Alexander.  Maciej and I are looking into a fix.

Looks like the driver uses pci_unmap_page() to unmap the region
previously mapped by dma_map_single(), right?

It's not the proper usage of DMA API but it doesn't cause any
problems. This is not a urgent issue though it's better to fix it.
