Return-Path: <linux-kernel-owner+w=401wt.eu-S1754388Ab0A2Ti3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388Ab0A2Ti3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 14:38:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754199Ab0A2Ti3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 14:38:29 -0500
Received: from kroah.org ([198.145.64.141]:46054 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792Ab0A2Ti2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 14:38:28 -0500
Date: Fri, 29 Jan 2010 11:35:32 -0800
From: Greg KH <greg@kroah.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Ming Lei <tom.leiming@gmail.com>, linux-usb@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: USB mass storage and ARM cache coherency
Message-ID: <20100129193532.GA6292@kroah.com>
References: <1264775655.4242.85.camel@pc1117.cambridge.arm.com>
 <d82e647a1001290823s1c651e4am113f843bef4ff9e2@mail.gmail.com>
 <1264782843.4242.91.camel@pc1117.cambridge.arm.com>
 <4B632033.2010309@ru.mvista.com>
 <20100129185434.GH19501@one-eyed-alien.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100129185434.GH19501@one-eyed-alien.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 10:54:34AM -0800, Matthew Dharm wrote:
> On Fri, Jan 29, 2010 at 08:51:47PM +0300, Sergei Shtylyov wrote:
> > Catalin Marinas wrote:
> > 
> > >That would be a more general solution rather than going through each HCD
> > >driver since my understanding is that flush_dcache_page() is only needed
> > >together with the mass storage support.
> > 
> >   Note that DMA capable driver can be doing some transfers in PIO mode 
> > or falling back to PIO mode if DMA mode transfer is unsuccessful (the 
> > musb driver is an example of the latter and if the DMA rewrite patches 
> > will get accepted, it'll do short transfers in PIO mode).
> 
> Given that an HCD can choose, on the fly, if it's using DMA or PIO, the HCD
> driver is the only place to reasonably put any cache-synchronization code.
> 
> That said, what do the other SCSI HCDs do?  I'm guessing the question gets
> kinda muddy there, since the other SCSI HCDs all talk directly to some
> piece of hardware, and thus are responsible for the cache management
> themselves.
> 
> Based on that, one could argue that ub and usb-storage should be doing
> this.
> 
> HOWEVER, I firmly believe that the cache-management functions belong with
> the driver that actually talks to the low-level hardware, as that's the
> only place where you can be 100% certain of what cache operations are
> needed.  After all, I think someone is working on a USB-over-IP transport,
> and trying to manage cache at the usb-storage level in that scenario is
> just silly.
> 
> So, let's put this in the HCD drivers and be done with it.

I agree, that's the place to fix this issue.

thanks,

greg k-h
