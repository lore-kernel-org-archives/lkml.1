Return-Path: <linux-kernel-owner+w=401wt.eu-S1761392AbXGOMKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761392AbXGOMKs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 08:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759053AbXGOMKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 08:10:37 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:2009 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757994AbXGOMKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 08:10:36 -0400
X-IronPort-AV: i="4.16,540,1175486400"; 
   d="scan'208"; a="34919796:sNHT30811116"
Subject: Re: [PATCH try#2] Blackfin ethernet driver: on chip ethernet MAC
	controller driver
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Michael Buesch <mb@bu3sch.de>, bryan.wu@analog.com,
       Mike Frysinger <vapier.adi@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
In-Reply-To: <20070715105358.GA18177@infradead.org>
References: <1184491629.3140.59.camel@roc-laptop>
	 <200707151236.51779.mb@bu3sch.de>  <20070715105358.GA18177@infradead.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Sun, 15 Jul 2007 20:10:30 +0800
Message-Id: <1184501430.3140.75.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 15 Jul 2007 12:10:35.0105 (UTC) FILETIME=[25FF7510:01C7C6D9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-15 at 11:53 +0100, Christoph Hellwig wrote:
> On Sun, Jul 15, 2007 at 12:36:51PM +0200, Michael Buesch wrote:
> > On Sunday 15 July 2007 11:27:09 Bryan Wu wrote:
> > > +#if defined(CONFIG_BFIN_MAC_USE_L1)
> > > +# define bfin_mac_alloc(dma_handle, size)  l1_data_sram_zalloc(size)
> > > +# define bfin_mac_free(dma_handle, ptr)    l1_data_sram_free(ptr)
> > > +#else
> > > +# define bfin_mac_alloc(dma_handle, size) \
> > > +	 dma_alloc_coherent(NULL, size, dma_handle, GFP_NORMAL)
> > 
> > What is GFP_NORMAL? It's not defined in latest linus' tree.
> > I think you should use GFP_KERNEL, if you can sleep, or GFP_ATOMIC,
> > if you can't.
> 
> Actually this whole thing looks fishy.  There should be a struct device
> for the dma allocation, through a platform_device.  And the
> CONFIG_BFIN_MAC_USE_L1 should go away, the l1 sram should have a dma
> provider so this can be handled through the dma api.

We do have L1 memory DMA allocator and manager, it is depends on
Blackfin arch.
And this driver is Blackfin on-chip ethernet MAC controller. 

So it is OK, any idea?

Thanks
- Bryan Wu
