Return-Path: <linux-kernel-owner+w=401wt.eu-S1752618AbYFHEcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbYFHEcX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 00:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754820AbYFHEcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 00:32:12 -0400
Received: from wsip-70-184-212-2.om.om.cox.net ([70.184.212.2]:41396 "EHLO
	hachi.dashjr.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbYFHEcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 00:32:11 -0400
From: Luke -Jr <luke@dashjr.org>
Organization: -Jr Family
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: bcm33xx port
Date: Sat, 7 Jun 2008 23:32:01 -0500
User-Agent: KMail/1.9.9
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-mips@linux-mips.org
References: <200806072113.26433.luke@dashjr.org> <Pine.LNX.4.55.0806080342310.15673@cliff.in.clinika.pl>
In-Reply-To: <Pine.LNX.4.55.0806080342310.15673@cliff.in.clinika.pl>
PGP-Key-Fingerprint: CE5A D56A 36CC 69FA E7D2 3558 665F C11D D53E 9583
Jabber-ID: luke@dashjr.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806072332.06460.luke@dashjr.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 June 2008, Maciej W. Rozycki wrote:
> On Sat, 7 Jun 2008, Luke -Jr wrote:
> > > I'm not too up on MIPS but there're a few things in the log which stand
> > > out to me:
> > >
> > > Determined physical RAM map:
> > >  memory: 00fa0000 @ 00000000 (usable)
> > > User-defined physical RAM map:
> > >  memory: 007a1200 @ 00000000 (usable)
> > >
> > > Can you confirm these sizes and locations for RAM?  Does anything
> > > change if you don't force the size constraint?
> >
> > According to
> > http://research.msrg.utoronto.ca/ece344/2007s/os161/mips.html , MIPS has
> > a pretty odd memory layout, and I'm honestly not sure how Linux usually
> > handles it. I don't feel competent to try and summarize the details on
> > that page here.
>
>  Nothing odd about the memory layout I would say unless you want to go
> beyond 512MB with a 32-bit system which is not the case here.

Well, I always imagined memory layout as being a simple flat range from 0 to 
all_memory_in_system, but this is my first experience with it at such a low 
level, so I guess I don't know what's "odd" or "normal".

> > > CPU frequency 32.00 MHz
> > >
> > > Really?  Is your bootloader setting the CPU up correctly before handing
> > > control to Linux?
> >
> > The CPU is 200 MHz, I believe. The bootloader is just a part of VxWorks,
> > not really meant to boot anything else.
>
>  CFE is pretty much standard for Broadcom platforms and far from being
> specific to VxWorks.

VxWorks, including the boot loader, is not CFE as far as I am aware. If you're 
referring to the "CFEv2" in the log, that appears to be the default of a 
switch (eg, if Linux doesn't detect anything else).

>  I'd be more concerned about:
>
> Calibrating delay loop (skipped)... 0.00 BogoMIPS preset

The calibration code was crashing, so I set it to a fixed 1 value.
Worst case, some code won't delay as long as it wants to, right?

> > > Reserved instruction in kernel code[#1]:
> > >
> > > You're compiling with an appropriate -march switch?
> >
> > I believe so... It appears to be a "reserved instruction" only because of
> > the memory area it tries to access. The instruction in question is "store
> > word", nothing complex.
>
>  You have got something seriously broken -- __bzero traps exceptions on
> stores for graceful recovery as user addresses may be accessed as is the
> case here.  If the reserved instruction exception handler is reached, then
> clearly the store instruction is not the immediate cause.

What else could it be?
