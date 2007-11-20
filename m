Return-Path: <linux-kernel-owner+w=401wt.eu-S1758591AbXKTOgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758591AbXKTOgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 09:36:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118AbXKTOgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 09:36:13 -0500
Received: from accolon.hansenpartnership.com ([64.109.89.108]:40784 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752101AbXKTOgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 09:36:12 -0500
Subject: Re: SCSI breakage on non-cache coherent architectures
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk
In-Reply-To: <20071120082927.GA8856@alpha.franken.de>
References: <1195450523.7022.37.camel@pasglop>
	 <20071119.003802.100741794.davem@davemloft.net>
	 <1195501874.6539.5.camel@pasglop>  <20071120082927.GA8856@alpha.franken.de>
Content-Type: text/plain
Date: Tue, 20 Nov 2007 08:36:02 -0600
Message-Id: <1195569362.3131.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-11-20 at 09:29 +0100, Thomas Bogendoerfer wrote:
> On Tue, Nov 20, 2007 at 06:51:14AM +1100, Benjamin Herrenschmidt wrote:
> > 
> > On Mon, 2007-11-19 at 00:38 -0800, David Miller wrote:
> > > From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > > Date: Mon, 19 Nov 2007 16:35:23 +1100
> > > 
> > > > I'm not sure what is the best way to fix that. Internally, I've done
> > > > some test whacking some ____cacheline_aligned in the scsi_cmnd data
> > > > structure to verify I no longer get random SLAB corruption when using my
> > > > USB but that significantly bloats the size of the structure on archs
> > > > such as ppc64 that don't need it and have a large cache line size.
> > > > 
> > > > Unfortunately, I don't think there's any existing Kconfig symbol or arch
> > > > provided #define to tell us that we are on a non-coherent arch afaik
> > > > that could be used to make that conditional.
> > > > 
> > > > Another option would be to kmalloc the buffer (wasn't it the case before
> > > > btw ?) but I suppose some people will scream at the idea due to how the
> > > > command pools are done...
> > > 
> > > You could make a ____dma_cacheline_aligned and use that.
> > > It seems pretty reasonable.
> > 
> > I was thinking about that. What archs would need it ? arm, mips, what
> > else ?
> 
> older parisc

Actually, we already established on IRC that the lasi700 driver doesn't
need this, principally because the parisc architecture doesn't do an
invalidate for DMA_FROM_DEVICE but a flush and invalidate
(architecturally, if you read our manuals, even pdc is entitled to write
back dirty lines, so it's not clear there's actually an invalidate
instruction we can use).   This is also one possible temporary fix for
the other architectures if we can't get a different method to work
nicely.

James


James


