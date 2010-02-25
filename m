Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934578Ab0BYXxF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 18:53:05 -0500
Received: from sh.osrg.net ([192.16.179.4]:37439 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754171Ab0BYXxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 18:53:03 -0500
Date: Fri, 26 Feb 2010 08:52:18 +0900
To: konrad.wilk@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, chrisw@sous-sol.org, jeremy@goop.org,
       Ian.Campbell@eu.citrix.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, dwmw2@infradead.org,
       alex.williamson@hp.com
Subject: Re: [PATCH 02/10] swiotlb: Make 'setup_io_tlb_npages' accept new
	'swiotlb=' syntax.
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100225124917.GB9040@phenom.dumpdata.com>
References: <1266510426-6815-3-git-send-email-konrad.wilk@oracle.com>
	<20100225155242F.fujita.tomonori@lab.ntt.co.jp>
	<20100225124917.GB9040@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100226085206P.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 26 Feb 2010 08:52:23 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Feb 2010 07:49:17 -0500
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> On Thu, Feb 25, 2010 at 03:53:20PM +0900, FUJITA Tomonori wrote:
> > On Thu, 18 Feb 2010 11:26:58 -0500
> > Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > 
> > > The old syntax for 'swiotlb' is still in effect, and we extend it
> > > now to include the overflow buffer size. The syntax is now:
> > > 
> > > swiotlb=[force,][nslabs=<pages>,][overflow=<size>] or more
> > > commonly know as:
> > > 
> > > swiotlb=[force]
> > > swiotlb=[nslabs=<pages>]
> > > swiotlb=[overflow=<size>]
> > > 
> > > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > > ---
> > >  Documentation/x86/x86_64/boot-options.txt |    6 ++++-
> > >  lib/swiotlb.c                             |   36 +++++++++++++++++++++++++---
> > >  2 files changed, 37 insertions(+), 5 deletions(-)
> > 
> > 'overflow' is a workaround for broken drivers (that ignores DMA
> > mapping errors). We have fixed such drivers and other hardware IOMMU
> > implementations don't have such workaround. So please don't extend
> > it. We should remove it instead.
> 
> Will do. Do you remember which drivers (or e-mail threads) exhibited this
> behavior so that I can do a regression test to make absolutely certain
> that removing the overflow functionality won't blow something up?

You can easily find such drivers by doing grep
{dma|pci}_map_{single|Sig} and seeing if {dma|pci}_mapping_error is
properly used or not.

There are some yet but the majority of such drivers are unlikely to be
used with IOMMU (e.g. really old drivers).

'overflow' works in only some conditions; that is, broken drivers
could lead to data corruption even with 'overflow'
functionality.

I've not reviewed that patchset carefully but my other comments are:

- exporting too generic naming such as 'do_map_single' is not a good
idea.

- please don't mix up new feature patches with 'fixing the printk
  format, checkpatch warnings' (which I'm not interested in).

