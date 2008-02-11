Return-Path: <linux-kernel-owner+w=401wt.eu-S1757028AbYBKShB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028AbYBKShB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 13:37:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750901AbYBKSgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 13:36:53 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50882 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbYBKSgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 13:36:51 -0500
Date: Mon, 11 Feb 2008 18:36:15 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8] ide: add struct ide_port_info instances to legacy host drivers
Message-ID: <20080211183615.GA29891@flint.arm.linux.org.uk>
References: <20080106170220.6861.4814.sendpatchset@localhost.localdomain> <20080106170310.6861.14522.sendpatchset@localhost.localdomain> <479E3AEA.5090600@ru.mvista.com> <200802020035.30918.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802020035.30918.bzolnier@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2008 at 12:35:30AM +0100, Bartlomiej Zolnierkiewicz wrote:
> > > Index: b/drivers/ide/arm/icside.c
> > > ===================================================================
> > > --- a/drivers/ide/arm/icside.c
> > > +++ b/drivers/ide/arm/icside.c
> > > @@ -459,11 +456,19 @@ icside_register_v5(struct icside_state *
> > >  
> > >  	idx[0] = hwif->index;
> > >  
> > > -	ide_device_add(idx);
> > > +	ide_device_add(idx, NULL);
> > >  
> > >  	return 0;
> > >  }
> > >  
> > > +static const struct ide_port_info icside_v6_port_info __initdata = {
> > > +	.host_flags		= IDE_HFLAG_SERIALIZE |
> > > +				  IDE_HFLAG_NO_DMA | /* no SFF-style DMA */
> > > +				  IDE_HFLAG_NO_AUTOTUNE,
> > > +	.mwdma_mask		= ATA_MWDMA2,
> > > +	.swdma_mask		= ATA_SWDMA2,
> > > +};
> > > +
> > 
> >     Interesting... this driver's support for SWDMA0 is broken since the cycle 
> > should be 960 ns long, not 480, and SWDMA2 is underclocked using the same 
> > cycle as SWDMA1, 480 ns...
> 
> Added Russell to Cc:.

Underclocking the DMA is not a problem - if you look at the timing
diagrams and associated tables in the ATA specifications, you'll
find that they specify the *minimum* cycle timings.

However, you're correct that SWDMA0 is not able to be supported.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
