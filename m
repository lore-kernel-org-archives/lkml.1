Return-Path: <linux-kernel-owner+w=401wt.eu-S1759349AbYFHDUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759349AbYFHDUm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 23:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754432AbYFHDUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 23:20:33 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64242 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753673AbYFHDUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 23:20:32 -0400
Date: Sun, 8 Jun 2008 04:19:58 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Luke -Jr <luke@dashjr.org>
cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: bcm33xx port
In-Reply-To: <200806072113.26433.luke@dashjr.org>
Message-ID: <Pine.LNX.4.55.0806080342310.15673@cliff.in.clinika.pl>
References: <200806072113.26433.luke@dashjr.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Jun 2008, Luke -Jr wrote:

> > I'm not too up on MIPS but there're a few things in the log which stand
> > out to me:
> >
> > Determined physical RAM map:
> >  memory: 00fa0000 @ 00000000 (usable)
> > User-defined physical RAM map:
> >  memory: 007a1200 @ 00000000 (usable)
> >
> > Can you confirm these sizes and locations for RAM?  Does anything change
> > if you don't force the size constraint?
> 
> According to http://research.msrg.utoronto.ca/ece344/2007s/os161/mips.html ,
> MIPS has a pretty odd memory layout, and I'm honestly not sure how Linux 
> usually handles it. I don't feel competent to try and summarize the details 
> on that page here.

 Nothing odd about the memory layout I would say unless you want to go 
beyond 512MB with a 32-bit system which is not the case here.

> > CPU frequency 32.00 MHz
> >
> > Really?  Is your bootloader setting the CPU up correctly before handing
> > control to Linux?
> 
> The CPU is 200 MHz, I believe. The bootloader is just a part of VxWorks, not 
> really meant to boot anything else.

 CFE is pretty much standard for Broadcom platforms and far from being
specific to VxWorks.

 The clock frequency of the CPU is calculated by Linux based on the rate
of the internal timer calibrated against the real-time clock or possibly
another reference of a known rate.  That's assuming board setup has got it
right, of course.

 I'd be more concerned about:

Calibrating delay loop (skipped)... 0.00 BogoMIPS preset

> > irq 8: nobody cared (try booting with the "irqpoll" option)
> >
> > What's on IRQ8, should anyone care at this early stage?  Did the
> > bootloader enable this (should it)?
> 
> No idea, sorry.

 What the bootloader does should no matter -- whatever piece of code
initializes the interrupt controller used for IRQ 8 should mask all the
sources off till a handler is installed anyway.

> > Reserved instruction in kernel code[#1]:
> >
> > You're compiling with an appropriate -march switch?
> 
> I believe so... It appears to be a "reserved instruction" only because of the 
> memory area it tries to access. The instruction in question is "store word", 
> nothing complex.

 You have got something seriously broken -- __bzero traps exceptions on
stores for graceful recovery as user addresses may be accessed as is the
case here.  If the reserved instruction exception handler is reached, then
clearly the store instruction is not the immediate cause.

 You might be better off asking questions at <linux-mips@linux-mips.org>.

  Maciej
