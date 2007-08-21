Return-Path: <linux-kernel-owner+w=401wt.eu-S1757022AbXHUUzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022AbXHUUzz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 16:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754149AbXHUUzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 16:55:39 -0400
Received: from accolon.hansenpartnership.com ([64.109.89.108]:44280 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753926AbXHUUzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 16:55:37 -0400
Subject: Re: [PATCH 2/3] dma: override "dma_flags_set_dmaflush" for sn-ia64
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: akepner@sgi.com, Jes Sorensen <jes@sgi.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, rdreier@cisco.com,
       linux-ia64 <linux-ia64@vger.kernel.org>
In-Reply-To: <20070821130515.6e745b17.randy.dunlap@oracle.com>
References: <20070818002746.GU1813@sgi.com> <46C94FD5.6000006@sgi.com>
	 <20070821193522.GD5592@sgi.com>
	 <20070821130515.6e745b17.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Tue, 21 Aug 2007 15:55:29 -0500
Message-Id: <1187729729.18410.48.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-21 at 13:05 -0700, Randy Dunlap wrote:
> > diff --git a/Documentation/DMA-API.txt b/Documentation/DMA-API.txt
> > index cc7a8c3..e117b72 100644
> > --- a/Documentation/DMA-API.txt
> > +++ b/Documentation/DMA-API.txt
> > @@ -392,6 +392,28 @@ Notes:  You must do this:
> >  
> >  See also dma_map_single().
> >  
> > +int
> > +dma_flags_set_dmaflush(int dir)
> > +
> > +Amend dir (one of the enum dma_data_direction values), with a platform-
> 
> no comma.
> 
> > +specific "dmaflush" attribute. Unless the platform supports "posted DMA" 
> 
> add comma after "posted DMA" and drop lots of trailing spaces.
> 
> > +this is a no-op

Almost every platform supports posted DMA ... its a property of most PCI
bridge chips.

> > +On platforms that support posted DMA, dma_flags_set_dmaflush() causes 
> > +device writes to the associated memory region to flush in-flight DMA. 
> > +This can be important, for example, when (DMA) writes to the memory 
> > +region indicate that DMA of data is complete. If DMA of data and DMA of 
> > +the completion indication race, as they can do when the platform supports 
> > +posted DMA, then the completion indication may arrive in host memory 
> > +ahead of some data.

This isn't possible on most platforms.  PCI write posting can only be
flushed by a read transaction on the device (or sometimes any device on
the bridge).  Either this interface is misnamed and misdescribed, or it
can't work for most systems.

> > +To prevent this, you might map the memory region used for completion 
> > +indications as follows:
> > +
> > +	int count, flags = dma_flags_set_dmaflush(DMA_BIDIRECTIONAL);
> > +	.....
> > +	count = dma_map_sg(dev, sglist, nents, flags);

James


