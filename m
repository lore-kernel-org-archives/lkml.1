Return-Path: <linux-kernel-owner+w=401wt.eu-S1754916AbXEGTwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916AbXEGTwN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 15:52:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754904AbXEGTwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 15:52:09 -0400
Received: from mra05.ch.as12513.net ([82.153.254.73]:37532 "EHLO
	mra05.ch.as12513.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787AbXEGTwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 15:52:07 -0400
X-Greylist: delayed 1492 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 May 2007 15:52:07 EDT
Date: Mon, 7 May 2007 20:27:11 +0100
From: Martin Habets <errandir_news@mph.eclipse.co.uk>
To: Mark Fortescue <mark@mtfhpc.demon.co.uk>
Cc: wli@holomorphy.com, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [TESTING NEEDED] drivers/serial/sunzilog: Interrupt enable before ISR handler installed
Message-ID: <20070507192711.GA27915@palantir8>
Mail-Followup-To: Mark Fortescue <mark@mtfhpc.demon.co.uk>,
	wli@holomorphy.com, linux-kernel@vger.kernel.org,
	sparclinux@vger.kernel.org, linux-serial@vger.kernel.org
References: <Pine.LNX.4.61.0704281529090.8157@mtfhpc.demon.co.uk> <20070428.210147.111207684.davem@davemloft.net> <Pine.LNX.4.61.0704292250290.1747@mtfhpc.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0704292250290.1747@mtfhpc.demon.co.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

Gave this a spin on my SS20 today, have the console on the
serial port. No problems seen. You will need to provide a
signed-off-by line to get it accepted upstream, see 
Documentation/SubmittingPatches.

ffd60050: ttyS0 at MMIO 0xf1100000 (irq = 44) is a zs (ESCC)
Console: ttyS0 (SunZilog zs0)
ffd60050: ttyS1 at MMIO 0xf1100004 (irq = 44) is a zs (ESCC)
ffd60130: Keyboard at MMIO 0xf1000000 (irq = 44) is a zs
ffd60130: Mouse at MMIO 0xf1000004 (irq = 44) is a zs

Cheers,
Martin Habets

	Ack-by: Martin Habets <errandir_news@mph.eclipse.co.uk>

On Sun, Apr 29, 2007 at 11:00:29PM +0100, Mark Fortescue wrote:
> I have altered the patch as advised and I have attached it to prevent my 
> email client from making a mess of it.
> 
> The attached patch changes the interrupt enable sequence for the sunzilog 
> driver so that interrupts are not enabled untill after the interrupt 
> handler has been installed. If this is not done, some SS1 and SS2 sun4c 
> systems panic on un-handled interrupt before the handler gets installed 
> preventing boot.
> 
> It also adds in support for the ESCC version of the zilog chips. The ESCC 
> detection works but the FIFO enable may cause issues with modem and 
> receive character status. My interpretation of the SCC manual and the code 
> is that it sould be OK.
> 
> ---
> 
> Regards
> 	Mark Fortescue.
