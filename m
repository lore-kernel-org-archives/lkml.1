Return-Path: <linux-kernel-owner+w=401wt.eu-S1754624AbYIERJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbYIERJO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 13:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbYIERI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 13:08:59 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:51632 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751097AbYIERI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 13:08:58 -0400
Date: Fri, 5 Sep 2008 18:08:51 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Christer Weinigel <christer@weinigel.se>, linux-kernel@vger.kernel.org,
       Pierre Ossman <drzeus-list@drzeus.cx>
Subject: Re: Proposed SDIO layer rework
Message-ID: <20080905170851.GB1916@fluff.org.uk>
References: <48C11BF3.2060609@weinigel.se> <20080905131855.GY26082@trinity.fluff.org> <48C13869.9040603@weinigel.se> <20080905140216.GZ26082@trinity.fluff.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080905140216.GZ26082@trinity.fluff.org>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2008 at 03:02:16PM +0100, Ben Dooks wrote:
> On Fri, Sep 05, 2008 at 03:47:21PM +0200, Christer Weinigel wrote:
> > Ben Dooks wrote:
> > >>Most of the CPU is probably spent doing PIO transfers to the SDIO 
> > >>controller, if DMA starts working in the s3cmci driver, the CPU load 
> > >>difference will be even larger.
> > >
> > >I'm not sure if I'll get the time to look at this before the new kernel
> > >is released... anyway DMA may not be much of a win for smaller transfers
> > >anyway, since the setup (the cache will need to be cleaned out or the
> > >transfer memory made unbuffered)  and complete time will add another
> > >IRQ's worth of response time. This means small transfers are probably
> > >better off using PIO.
> > 
> > Yes.  For the DMA-capable S3C SPI driver I wrote, I added some 
> > thresholds, so for smaller transfers than a certain number of bytes, I 
> > skip DMA and just do a polled/interrupt transfer instead.  For short 
> > transfers at high clock rates it's not even worth getting an interrupt 
> > per byte, it's better to just busy wait for each byte, since the 
> > interrupt overhead is larger than the time between each byte.
> > 
> > A SDIO CMD/response packet is 48 bits, so at 25 MHz that is only about 4 
> > us and I think the interrupt overhead is more than that.  So if we 
> > really want to squeeze every last clock cycle out of the SDIO driver it 
> > may be better to busy wait for the end of simple CMD52s instead of using 
> > the an interrupt to complete the transfer.
> > 
> > I'll clean up my s3cmci patches and send them to you, but I can't 
> > promise when I'll be done, so it'll probably have to wait for the next 
> > kernel release.
> 
> Any chance of getting a list of what you've got in progress and at-least
> the byte/word patch sorted out before the next merge window?

I should have added that at least if I know what you are working on,
then we can come to some arrangement on who should do what for the
next kernel release. I would like to get the fixups for word/byte code
in, and anything else that does not require huge amounts of testing.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
