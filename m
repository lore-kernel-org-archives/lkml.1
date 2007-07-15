Return-Path: <linux-kernel-owner+w=401wt.eu-S1759885AbXGOKy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759885AbXGOKy1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 06:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755656AbXGOKyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 06:54:15 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60665 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588AbXGOKyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 06:54:14 -0400
Date: Sun, 15 Jul 2007 11:53:58 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: bryan.wu@analog.com, Mike Frysinger <vapier.adi@gmail.com>,
       Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH try#2] Blackfin ethernet driver: on chip ethernet MAC controller driver
Message-ID: <20070715105358.GA18177@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Michael Buesch <mb@bu3sch.de>, bryan.wu@analog.com,
	Mike Frysinger <vapier.adi@gmail.com>,
	Jeff Garzik <jeff@garzik.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
References: <1184491629.3140.59.camel@roc-laptop> <200707151236.51779.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707151236.51779.mb@bu3sch.de>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 15, 2007 at 12:36:51PM +0200, Michael Buesch wrote:
> On Sunday 15 July 2007 11:27:09 Bryan Wu wrote:
> > +#if defined(CONFIG_BFIN_MAC_USE_L1)
> > +# define bfin_mac_alloc(dma_handle, size)  l1_data_sram_zalloc(size)
> > +# define bfin_mac_free(dma_handle, ptr)    l1_data_sram_free(ptr)
> > +#else
> > +# define bfin_mac_alloc(dma_handle, size) \
> > +	 dma_alloc_coherent(NULL, size, dma_handle, GFP_NORMAL)
> 
> What is GFP_NORMAL? It's not defined in latest linus' tree.
> I think you should use GFP_KERNEL, if you can sleep, or GFP_ATOMIC,
> if you can't.

Actually this whole thing looks fishy.  There should be a struct device
for the dma allocation, through a platform_device.  And the
CONFIG_BFIN_MAC_USE_L1 should go away, the l1 sram should have a dma
provider so this can be handled through the dma api.
