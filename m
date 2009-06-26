Return-Path: <linux-kernel-owner+w=401wt.eu-S1755929AbZFZHes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbZFZHes (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 03:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbZFZHel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 03:34:41 -0400
Received: from nox.protox.org ([88.191.38.29]:41451 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbZFZHel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 03:34:41 -0400
Subject: Re: TTM page pool allocator
From: Jerome Glisse <glisse@freedesktop.org>
To: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas@shipmail.org>
Cc: Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
In-Reply-To: <4A446B49.8040001@shipmail.org>
References: <1245931298.13359.8.camel@localhost.localdomain>
	 <21d7e9970906251700n5f5fbd07ke24022b576b1770b@mail.gmail.com>
	 <4A446B49.8040001@shipmail.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Jun 2009 09:33:35 +0200
Message-Id: <1246001615.2312.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-26 at 08:31 +0200, Thomas Hellström wrote:
> Dave Airlie skrev:
> > On Thu, Jun 25, 2009 at 10:01 PM, Jerome Glisse<glisse@freedesktop.org> wrote:
> >   
> >> Hi,
> >>
> >> Thomas i attach a reworked page pool allocator based on Dave works,
> >> this one should be ok with ttm cache status tracking. It definitely
> >> helps on AGP system, now the bottleneck is in mesa vertex's dma
> >> allocation.
> >>
> >>     
> >
> > My original version kept a list of wb pages as well, this proved to be
> > quite a useful
> > optimisation on my test systems when I implemented it, without it I
> > was spending ~20%
> > of my CPU in getting free pages, granted I always used WB pages on
> > PCIE/IGP systems.
> >
> > Another optimisation I made at the time was around the populate call,
> > (not sure if this
> > is what still happens):
> >
> > Allocate a 64K local BO for DMA object.
> > Write into the first 5 pages from userspace - get WB pages.
> > Bind to GART, swap those 5 pages to WC + flush.
> > Then populate the rest with WC pages from the list.
> > Granted I think allocating WC in the first place from the pool might
> > work just as well since most of the DMA buffers are write only.
> >   
> 
> Yes, I think in the latter case the user-space driver should take care 
> to specify WC from the beginning, when the BO is allocated.
> 
> BTW is there any DMA buffer verification taking place on WC buffers on 
> Radeon?


Command buffer submitted from userspace are never bo object, they are
normal memory so they are cached, kernel copy the content into bo
buffer which have proper cache status.

Cheers,
Jerome

