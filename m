Return-Path: <linux-kernel-owner+w=401wt.eu-S1752223AbZEYMyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223AbZEYMyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 08:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751679AbZEYMyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 08:54:36 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:49005 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbZEYMyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 08:54:35 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Harald Welte <HaraldWelte@viatech.com>
Subject: Re: i2c-viapro / via-fb drivers on VIA CX700
Date: Mon, 25 May 2009 07:54:32 -0500
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200905221139.26941.lkml@morethan.org> <200905241332.39946.lkml@morethan.org> <20090525013132.GA8702@prithivi.gnumonks.org>
In-Reply-To: <20090525013132.GA8702@prithivi.gnumonks.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905250754.34921.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun May 24 2009, Harald Welte wrote:
> On Sun, May 24, 2009 at 01:32:37PM -0500, Michael S. Zick wrote:
> 
> > The i2c-viapro driver (in spite of its comments) does not work
> > on CX700 (written before manual was released) - it is reading
> > the serial number rather than the second data port. ;)
> > (No access to the chipset temperature/voltage data on SMBus).
>

None of by comments have been verified sufficiently to be considered
for reporting as a bug.  Not yet.  
I need to carefully check my initial findings.

Also, both the code base and my configuration has changed greatly
since I just made those first notes.

None of those things on my "to check" list are critical to solving
a "hard lock-up" problem.
Now that I get pairs of builds with vastly different behavior - -
I can start narrowing in on the prime cause -
My plan -
*) Make local changes to printk.c that will behave differently
under heavy message floods (I have the re-try loop in ehci-hcd
available to generate the floods with).
*) Build, again, with the lockdep reporting -
This will do one of two things -
**) Make true reports - which can be found and fixed
**) Make false reports due to whatever is being worked-around
with changing the LOCK_PREFIX macro.
Even in the second case, we will get locations in the source
to eye-ball/test for the effect of the LOCK_PREFIX macro.
 
> This is surprising.  I just manually verified the driver against the
> cx700 programming manual, and it seems to do the right thing.  Lacking
> access to a cx700 board right now, I cannot perform an actual test.
> 
> Where exactly is the bug about the wrong register that you mentioned?
> I'd rather fix that ASAP.
> 

Let me re-check my notes on that against the -rc7 build, I really,
really would like to have SMBus access to those thermal monitors.
Also, the Everex CloudBook (not the Sylvania gBook) controls the
power to the Wifi card as an SMBus device.
The Wifi card works much better with power applied.  ;)

> > The via-fb driver just "doesn't work" - Haven't looked at it yet.
> 
> good to know.  Seems like I need to get access to a CX700 based board.
>  
> > There isn't a driver for the hardware watchdog on CX700 - 
> 
> JFYI: I wrote one but it doesn't work on the vx800/vx855, and VIA is currently
> trying to figure out why.
> 

Not a big issue at this point, as I read the manual, our choices are
to either pull down the chipset "power off" or "reset" lines with it.
Since those choices are probably grown into the silicon...
Now if we had the choice to generate a crash dump...

If you can send me a link to your preliminary code, I will check it
against the CX700 - - I do have a machine that will let it trigger. ;)

> > There isn't a driver for the machine error reporting -
> 
> I think the CPU just claims to report it but in reality doesn't... this was
> made to make some proprietary software happy, AFAIR.
> 

I think that a working SMBus driver would give enough access to
the chip set for practical purposes - these machines don't support
ECC ram - the BIOS (your demo board BIOS if we believe dmidump)
should be handling other machine check exceptions.

Thanks very much for your time.
Mike
