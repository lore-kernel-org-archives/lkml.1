Return-Path: <linux-kernel-owner+w=401wt.eu-S1756089AbXJ2UcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbXJ2UcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 16:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbXJ2UcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 16:32:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:29247 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627AbXJ2UcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 16:32:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,344,1188802800"; 
   d="scan'208";a="307953768"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Keith Packard <keithp@keithp.com>
Subject: Re: [RFC] AGP initial support for chipset flushing..
Date: Mon, 29 Oct 2007 13:28:09 -0700
User-Agent: KMail/1.9.7
Cc: Dave Airlie <airlied@skynet.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net
References: <Pine.LNX.4.64.0710290811070.1170@skynet.skynet.ie> <200710291247.24791.jesse.barnes@intel.com> <1193688778.4723.35.camel@koto.keithp.com>
In-Reply-To: <1193688778.4723.35.camel@koto.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710291328.10763.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 29, 2007 1:12 pm Keith Packard wrote:
> On Mon, 2007-10-29 at 12:47 -0700, Jesse Barnes wrote:
> > In this case, we're performing basically a
> > dma_sync*(...DMA_TO_DEVICE) right?
>
> But this is just for the GPU; every other DMA device in the system is
> cache-coherent.

Right.

> >   Can we be sure that a single flush is sufficient?  Is there any
> > window between when we flush and when we start accessing memory
> > with the device that we could get into more caching trouble?
>
> An uncached write to this page will not complete until the buffers
> are completely flushed.

Yeah, so we should be safe.

> > Looks reasonable, I'm not sure we can do much better.  The only
> > concern I have is that allocating some more PCI space like that may
> > end up clobbering some *other* hidden BIOS mapping, but there's not
> > a whole lot we can do about that.
>
> This isn't a hidden mapping; the i965 doesn't allocate space for it
> in the BIOS.

I know, that's what I'm worried about.  If the BIOS is broken enough to 
not allocate MMIO space for the flush page, it may also be broken 
enough that our hand crafted MMIO space allocation will end up 
conflicting with some unreported BIOS area, which would be bad.

Jesse
