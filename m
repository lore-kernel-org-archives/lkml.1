Return-Path: <linux-kernel-owner+w=401wt.eu-S1757346AbZEXSct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346AbZEXSct (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 14:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbZEXScl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 14:32:41 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:43123 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbZEXScl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 14:32:41 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Date: Sun, 24 May 2009 13:32:37 -0500
User-Agent: KMail/1.9.9
Cc: Harald Welte <HaraldWelte@viatech.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <200905221139.26941.lkml@morethan.org> <200905240727.30677.lkml@morethan.org> <4A198B24.9040404@zytor.com>
In-Reply-To: <4A198B24.9040404@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905241332.39946.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun May 24 2009, H. Peter Anvin wrote:
> Michael S. Zick wrote:
> > 
> > @hpa - I still like your suggestion that it is only one (or a few)
> > uses of atomic ops that is incorrect and in general atomic ops
> > should compile away on uni-processor.
> > 
> 
> Actually, the more I think about it the more I suspect there is a race
> condition either in the chip set or in any VIA-specific drivers (if
> there are any.)  Putting LOCKs in random places will slow the CPU down
> significantly, so it might resolve the race condition without actually
> solving the problem.
>

They are mostly out of the -09143 and -09144 builds -
No cpufreq (I.E: no e_powersaver).
The padlock-* drivers are modules which must be manually loaded. 

The i2c-viapro driver (in spite of its comments) does not work
on CX700 (written before manual was released) - it is reading
the serial number rather than the second data port. ;)
(No access to the chipset temperature/voltage data on SMBus).

The via-fb driver just "doesn't work" - Haven't looked at it yet.

There is a VIA-specific driver for the VIA USB controller, but it
isn't in the x86 part of the tree - Haven't looked at it yet.

There isn't a driver for the hardware watchdog on CX700 - 
There isn't a driver for the machine error reporting -

= = = =

Although there may be timing requirement differences on the
CX700 and CN896 - I think more likely a human error (typo)
in the "clobber" lines of the asm - Have not yet audited that,
but it is high on my list.

Note: I have seem to recall that newer gcc's optimizer presume 
that the flags register is preserved across asm - 
It didn't use to do that - but there is now a "cc" to deal with
that - Have not yet audited for that, but it is high on my list.

Busy, busy, busy - -
The -09144lk on C7-M/CX700 now up for 3 3/4 hours close to a new
record - but ehci-hcd has not yet gone into a re-try loop.

Mike
> 	-hpa
> 


