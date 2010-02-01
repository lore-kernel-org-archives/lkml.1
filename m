Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab0BANuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 08:50:12 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39468 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753192Ab0BANuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 08:50:09 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Catalin Marinas <catalin.marinas@arm.com>
To: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>, linux-usb@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20100129185434.GH19501@one-eyed-alien.net>
References: <20100129185434.GH19501@one-eyed-alien.net>
Content-Type: text/plain
Organization: ARM Ltd
Date: Mon, 01 Feb 2010 13:49:46 +0000
Message-Id: <1265032186.25750.31.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Feb 2010 13:49:47.0681 (UTC) FILETIME=[6B017910:01CAA345]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-29 at 18:54 +0000, Matthew Dharm wrote:
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

Doing this (flush_dcache_page) in the HCD driver (ISP1760) solves my
problem. I'll post a patch and also cc the driver maintainer.

Thanks.

-- 
Catalin

