Return-Path: <linux-kernel-owner+w=401wt.eu-S1756497AbZAMQkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497AbZAMQkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 11:40:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbZAMQkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 11:40:13 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:56543 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbZAMQkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 11:40:11 -0500
Date: Tue, 13 Jan 2009 08:40:08 -0800
From: Ira Snyder <iws@ovro.caltech.edu>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       shemminger@vyatta.com, netdev@vger.kernel.org
Subject: Re: [PATCH RFC v5] net: add PCINet driver
Message-ID: <20090113164007.GA7434@ovro.caltech.edu>
Mail-Followup-To: Arnd Bergmann <arnd@arndb.de>,
	Rusty Russell <rusty@rustcorp.com.au>,
	David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
	linuxppc-dev@ozlabs.org, shemminger@vyatta.com,
	netdev@vger.kernel.org
References: <20090107195052.GA24981@ovro.caltech.edu> <200901131302.52754.rusty@rustcorp.com.au> <20090113033420.GA11065@ovro.caltech.edu> <200901131733.04341.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901131733.04341.arnd@arndb.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Tue, 13 Jan 2009 08:40:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 05:33:03PM +0100, Arnd Bergmann wrote:
> On Tuesday 13 January 2009, Ira Snyder wrote:
> > On Tue, Jan 13, 2009 at 01:02:52PM +1030, Rusty Russell wrote:
> > > 
> > >    Interesting system: the guest being able to access the
> > >    host's memory but not (fully) vice-versa makes this a
> > >    little different from the current implementations where
> > >    that was assumed.  virtio assumes that the guest will
> > >    publish buffers and someone else (ie. the host) will access them.    
> > 
> > The guest system /could/ publish all of its RAM, but with 256MB per
> > board, 19 boards per cPCI crate, that's way too much for a 32-bit PC to
> > map into it's memory space. That's the real reason I use the 1MB
> > windows. I could make them bigger (16MB would be fine, I think), but I
> > doubt it would make much of a difference to the implementation.
> 
> The way we do it in the existing driver for cell, both sides export
> just a little part of their memory to the other side, and they
> also both get access to one channel of the DMA engine, which is
> enough to transfer larger data sections, as the DMA engine has
> access to all the memory on both sides.

So do you program one channel of the DMA engine from the host side and
another channel from the guest side?

I tried to avoid having the host program the DMA controller at all.
Using the DMAEngine API on the guest did better than I could achieve by
programming the registers manually. I didn't use chaining or any of the
fancier features in my tests, though.

Ira
