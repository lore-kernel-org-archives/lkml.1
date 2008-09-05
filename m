Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbYIEOC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbYIEOC0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 10:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbYIEOCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 10:02:18 -0400
Received: from trinity.fluff.org ([89.145.97.151]:55582 "EHLO
	trinity.fluff.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbYIEOCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 10:02:18 -0400
Date: Fri, 5 Sep 2008 15:02:16 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Christer Weinigel <christer@weinigel.se>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
       Pierre Ossman <drzeus-list@drzeus.cx>
Subject: Re: Proposed SDIO layer rework
Message-ID: <20080905140216.GZ26082@trinity.fluff.org>
References: <48C11BF3.2060609@weinigel.se> <20080905131855.GY26082@trinity.fluff.org> <48C13869.9040603@weinigel.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C13869.9040603@weinigel.se>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.9i
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2008 at 03:47:21PM +0200, Christer Weinigel wrote:
> Ben Dooks wrote:
> >>Most of the CPU is probably spent doing PIO transfers to the SDIO 
> >>controller, if DMA starts working in the s3cmci driver, the CPU load 
> >>difference will be even larger.
> >
> >I'm not sure if I'll get the time to look at this before the new kernel
> >is released... anyway DMA may not be much of a win for smaller transfers
> >anyway, since the setup (the cache will need to be cleaned out or the
> >transfer memory made unbuffered)  and complete time will add another
> >IRQ's worth of response time. This means small transfers are probably
> >better off using PIO.
> 
> Yes.  For the DMA-capable S3C SPI driver I wrote, I added some 
> thresholds, so for smaller transfers than a certain number of bytes, I 
> skip DMA and just do a polled/interrupt transfer instead.  For short 
> transfers at high clock rates it's not even worth getting an interrupt 
> per byte, it's better to just busy wait for each byte, since the 
> interrupt overhead is larger than the time between each byte.
> 
> A SDIO CMD/response packet is 48 bits, so at 25 MHz that is only about 4 
> us and I think the interrupt overhead is more than that.  So if we 
> really want to squeeze every last clock cycle out of the SDIO driver it 
> may be better to busy wait for the end of simple CMD52s instead of using 
> the an interrupt to complete the transfer.
> 
> I'll clean up my s3cmci patches and send them to you, but I can't 
> promise when I'll be done, so it'll probably have to wait for the next 
> kernel release.

Any chance of getting a list of what you've got in progress and at-least
the byte/word patch sorted out before the next merge window?

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

