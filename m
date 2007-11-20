Return-Path: <linux-kernel-owner+w=401wt.eu-S1757182AbXKTJjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182AbXKTJjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 04:39:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbXKTJjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 04:39:13 -0500
Received: from elvis.franken.de ([193.175.24.41]:36457 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755675AbXKTJjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 04:39:11 -0500
X-Greylist: delayed 4126 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Nov 2007 04:39:11 EST
Date: Tue, 20 Nov 2007 09:29:28 +0100
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Miller <davem@davemloft.net>, James.Bottomley@HansenPartnership.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       rmk@arm.linux.org.uk
Subject: Re: SCSI breakage on non-cache coherent architectures
Message-ID: <20071120082927.GA8856@alpha.franken.de>
References: <1195450523.7022.37.camel@pasglop> <20071119.003802.100741794.davem@davemloft.net> <1195501874.6539.5.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1195501874.6539.5.camel@pasglop>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tsbogend@alpha.franken.de (Thomas Bogendoerfer)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2007 at 06:51:14AM +1100, Benjamin Herrenschmidt wrote:
> 
> On Mon, 2007-11-19 at 00:38 -0800, David Miller wrote:
> > From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Date: Mon, 19 Nov 2007 16:35:23 +1100
> > 
> > > I'm not sure what is the best way to fix that. Internally, I've done
> > > some test whacking some ____cacheline_aligned in the scsi_cmnd data
> > > structure to verify I no longer get random SLAB corruption when using my
> > > USB but that significantly bloats the size of the structure on archs
> > > such as ppc64 that don't need it and have a large cache line size.
> > > 
> > > Unfortunately, I don't think there's any existing Kconfig symbol or arch
> > > provided #define to tell us that we are on a non-coherent arch afaik
> > > that could be used to make that conditional.
> > > 
> > > Another option would be to kmalloc the buffer (wasn't it the case before
> > > btw ?) but I suppose some people will scream at the idea due to how the
> > > command pools are done...
> > 
> > You could make a ____dma_cacheline_aligned and use that.
> > It seems pretty reasonable.
> 
> I was thinking about that. What archs would need it ? arm, mips, what
> else ?

older parisc

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessary a
good idea.                                                [ RFC1925, 2.3 ]
