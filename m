Return-Path: <linux-kernel-owner+w=401wt.eu-S1755402AbZFZHdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbZFZHdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 03:33:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbZFZHdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 03:33:05 -0400
Received: from nox.protox.org ([88.191.38.29]:47493 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbZFZHdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 03:33:05 -0400
Subject: Re: TTM page pool allocator
From: Jerome Glisse <glisse@freedesktop.org>
To: Dave Airlie <airlied@gmail.com>
Cc: thomas@shipmail.org, linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
In-Reply-To: <21d7e9970906251700n5f5fbd07ke24022b576b1770b@mail.gmail.com>
References: <1245931298.13359.8.camel@localhost.localdomain>
	 <21d7e9970906251700n5f5fbd07ke24022b576b1770b@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 26 Jun 2009 09:31:55 +0200
Message-Id: <1246001515.2312.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-26 at 10:00 +1000, Dave Airlie wrote:
> On Thu, Jun 25, 2009 at 10:01 PM, Jerome Glisse<glisse@freedesktop.org> wrote:
> > Hi,
> >
> > Thomas i attach a reworked page pool allocator based on Dave works,
> > this one should be ok with ttm cache status tracking. It definitely
> > helps on AGP system, now the bottleneck is in mesa vertex's dma
> > allocation.
> >
> 
> My original version kept a list of wb pages as well, this proved to be
> quite a useful
> optimisation on my test systems when I implemented it, without it I
> was spending ~20%
> of my CPU in getting free pages, granted I always used WB pages on
> PCIE/IGP systems.
> 
> Another optimisation I made at the time was around the populate call,
> (not sure if this
> is what still happens):
> 
> Allocate a 64K local BO for DMA object.
> Write into the first 5 pages from userspace - get WB pages.
> Bind to GART, swap those 5 pages to WC + flush.
> Then populate the rest with WC pages from the list.
> 
> Granted I think allocating WC in the first place from the pool might
> work just as well since most of the DMA buffers are write only.
> 
> Dave.
> 

I think it's better to fix userspace to not allocate as much buffer per
frame as it does now rather than having a pool of wb pages, i removed
it because on my 64M box memory is getting tight, we need to compute
the number of page we still based on memory. Also i think it's ok
to assume that page allocation is fast enough.

I am reworking the patch with lastes Thomas comment, will post new one
after a bit of testing.

Cheers,
Jerome

