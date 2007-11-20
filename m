Return-Path: <linux-kernel-owner+w=401wt.eu-S1757576AbXKTK6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576AbXKTK6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 05:58:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754606AbXKTK6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 05:58:45 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:59150 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754790AbXKTK6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 05:58:45 -0500
Date: Tue, 20 Nov 2007 11:58:41 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: djenkins@mvista.co.uk
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: MMC sub-system: SDIO block-mode with increment address issue
Message-ID: <20071120115841.25765bd3@poseidon.drzeus.cx>
In-Reply-To: <1195472694.18869.57.camel@libdev3.libertesoft.co.uk>
References: <1195472694.18869.57.camel@libdev3.libertesoft.co.uk>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2007 11:44:54 +0000
Dean Jenkins <djenkins@mvista.co.uk> wrote:

> This E-mail is for the attention of Pierre Ossman (MMC sub-system
> maintainer)

A cc helps if you want my attention. ;)

> 
> Hi Pierre,
> 
> I've being trying to get SDIO block-mode with incrementing address to
> work on an OMAP2430 based reference board with an SDIO card.
> 
> Looking at the latest code ( as of 19/11/2007 ) on the mmc-git tree (I'm
> not a git expert so I'm not sure how to reference the codebase). I have
> a comment to make concerning the following code snippet...

git log or git show will give you your current top commit id.
> 
> I think the lines
> 
> 227                         if (incr_addr)
> 228                                 addr += size;
> 
> are incorrect and should be removed. I think the SDIO increment address
> parameter relates to the internal operation of the SDIO card and NOT to
> the external register address of the FIFO. In other words, I think with
> incrementing address enabled in block mode, the register address of the
> FIFO in the SDIO function register space will be erroneously changed on
> the next block write and will fail (it seems to fail on my card). It
> seems strange to change the register address ?
> 

I don't follow. The SDIO specification very clearly defines the behaviour of incrementing address. The referenced code is very much needed to keep that behaviour when we need to split up the transfer.

I assume what you want is multiple transactions with incrementing address, but each transaction restarting at the same base address. In that case you'll have to call the sdio register functions multiple times.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
