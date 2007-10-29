Return-Path: <linux-kernel-owner+w=401wt.eu-S1754379AbXJ2UTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379AbXJ2UTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 16:19:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753153AbXJ2UTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 16:19:14 -0400
Received: from mga03.intel.com ([143.182.124.21]:20512 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753059AbXJ2UTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 16:19:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,343,1188802800"; 
   d="scan'208";a="307946970"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Dave Airlie <airlied@linux.ie>
Subject: Re: [RFC] AGP initial support for chipset flushing..
Date: Mon, 29 Oct 2007 13:12:45 -0700
User-Agent: KMail/1.9.7
Cc: dri-devel@lists.sourceforge.net, keithp@keithp.com,
       linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
References: <Pine.LNX.4.64.0710290811070.1170@skynet.skynet.ie> <200710291247.24791.jesse.barnes@intel.com> <Pine.LNX.4.64.0710291951100.1170@skynet.skynet.ie>
In-Reply-To: <Pine.LNX.4.64.0710291951100.1170@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710291312.46328.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 29, 2007 12:52 pm Dave Airlie wrote:
> > In this case, we're performing basically a
> > dma_sync*(...DMA_TO_DEVICE) right?  Can we be sure that a single
> > flush is sufficient?  Is there any window between when we flush and
> > when we start accessing memory with the device that we could get
> > into more caching trouble?
>
> Not that I can think off, but I don't work for the company who
> screwed up the coherency :-), and I don't have the docs, so please
> investigate for me ;-)

It *looks* like it'll be enough.  I assume Keith has talked to the 
chipset guys to confirm this.

> > Looks reasonable, I'm not sure we can do much better.  The only
> > concern I have is that allocating some more PCI space like that may
> > end up clobbering some *other* hidden BIOS mapping, but there's not
> > a whole lot we can do about that.
>
> Again I'm trying to workaround broken BIOS.. nothing I can do.

Right, BIOSes are so much fun to deal with.  One other thing:  it looks 
like the flush mmio space has to be allocated above the top of DRAM but 
below 4G.  I wonder if there's an easy way to guarantee this with the 
pci_bus* routines...

Jesse
