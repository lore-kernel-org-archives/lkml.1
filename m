Return-Path: <linux-kernel-owner+w=401wt.eu-S1763792AbXGQPXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763792AbXGQPXX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 11:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752310AbXGQPXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 11:23:16 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41621 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752122AbXGQPXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 11:23:15 -0400
From: akepner@sgi.com
Date: Tue, 17 Jul 2007 08:22:44 -0700
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: linux-kernel@vger.kernel.org, Roland Dreier <rdreier@cisco.com>,
       glebn@voltaire.com
Subject: Re: [RFC/PATCH] allow memory to be tagged "coherent" via dma_map_sg()
Message-ID: <20070717152244.GI16538@sgi.com>
References: <20070717021812.GH16538@sgi.com> <20070717101658.GB18721@rhun.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070717101658.GB18721@rhun.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2007 at 01:16:58PM +0300, Muli Ben-Yehuda wrote:
> On Mon, Jul 16, 2007 at 07:18:12PM -0700, akepner@sgi.com wrote:
> .....
> > --- a/include/linux/dma-mapping.h
> > +++ b/include/linux/dma-mapping.h
> > @@ -95,4 +95,11 @@ static inline void dmam_release_declared_memory(struct device *dev)
> >  }
> >  #endif /* ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY */
> >  
> > +#ifndef ARCH_DOES_POSTED_DMA
> > +static inline int
> > +dma_data_direction_set_dmaflush(enum dma_data_direction dir, int dmaflush) {
> > +	return (dir);
> > +}
> > +#endif /* ARCH_DOES_POSTED_DMA */
> > +
> >  #endif
> 
> The generic bits look much better than the previous version,
> thanks. Is the generic dma_data_direction_set_dmaflush really needed?

Yes, dma_data_direction_set_dmaflush is used in ib_umem_get() to pass 
the additional bit down to sn_dma_map_sg(). 

> if yes, what about dma_data_direction_get_direction and
> dma_data_direction_get_dmaflush?
> 

The dma_data_direction_get_* functions are used only in sn2-arch-
specific code (sn_dma_map_sg()), so they don't need to be defined 
for other architectures.

-- 
Arthur

