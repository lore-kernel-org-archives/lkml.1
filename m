Return-Path: <linux-kernel-owner+w=401wt.eu-S1752274AbXD1U1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274AbXD1U1V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 16:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbXD1U1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 16:27:20 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2309 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbXD1U1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 16:27:19 -0400
Date: Sat, 28 Apr 2007 21:27:01 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-ID: <20070428202701.GA30343@flint.arm.linux.org.uk>
Mail-Followup-To: Adrian Bunk <bunk@stusta.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Diego Calleja <diegocg@gmail.com>,
	Chuck Ebbert <cebbert@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org> <20070426040806.GJ3468@stusta.de> <20070426125802.GL3468@stusta.de> <alpine.LFD.0.98.0704260828550.9964@woody.linux-foundation.org> <4630DB24.4030005@redhat.com> <20070426201325.8a1ebda3.diegocg@gmail.com> <alpine.LFD.0.98.0704261126010.9964@woody.linux-foundation.org> <20070426224148.69b91b2e.diegocg@gmail.com> <alpine.LFD.0.98.0704261354560.9964@woody.linux-foundation.org> <20070428195320.GZ3468@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070428195320.GZ3468@stusta.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2007 at 09:53:20PM +0200, Adrian Bunk wrote:
> We are already quite good at ignoring bug reports that come through 
> linux-kernel, and it's an _advantage_ of the kernel Bugzilla to see more 
> than 1600 open bugs because this tells how bad we are at handling bugs.
> How many thousand bug reports have been ignored during the same time on 
> linux-kernel?

However, look at this bug:

  http://bugme.osdl.org/show_bug.cgi?id=7760

It's outside my knowledge to be able to fix for various reasons:

1. I don't know _anything_ about IXP4xx hardware, so I'm not the right
   person to own this bug.

2. I've no idea who's looking after IXP4xx stuff now.  (When it was
   posted to the ARM kernel list by Rob, it was ignored so I guess the
   IXP4xx maintainer isn't watching for bugs, if such a person even
   exists.)

3. I've little idea about why the MM page allocation is failing early.

4. The ARM DMA bounce code is a hack, and I'm pretty sure that this
   failure is a result of trying to use this contorted code instead
   of the relevant subsystems having a correct DMA mask.

Can you make any suggestion what should be done about this bug?

I'm personally very tempted to close it as "won't fix" (I wish there was
a "can't fix" category.)

As for my other bugs:

  http://bugme.osdl.org/show_bug.cgi?id=8149

Again, EP93xx is not my thing, but I've recently merged a patch to allow
AMBA PL010 uarts (which are present on this platform) to use the clock
control API.

The EP93xx people (provided they're willing) now need to do whatever's
required to resolve that bug.  (Hopefully they've taken ownership of
that bug now.)

  http://bugme.osdl.org/show_bug.cgi?id=4270
  http://bugme.osdl.org/show_bug.cgi?id=5875
  http://bugme.osdl.org/show_bug.cgi?id=7750

I'm no longer serial maintainer.  Bug IDs after about 7000 reflect bugs
submitted since I've resigned my serial maintainership, and therefore
I've ignored them.  It's far easier to ignore bug reports in bugzilla
than it is to get categories reassigned (to whom? - dunno) or even
deleted (if no one steps up presumably that's what needs to happen?)

  http://bugme.osdl.org/show_bug.cgi?id=7389

This one isn't a regression, or even a bug IMHO, but could be viewed as
undesirable behaviour.  Fixing it is utterly non-trivial though.

A serial port which happens to have an IrDA device on it is still a serial
port at the end of the day, and as long as we have legacy probing, a serial
port at a standard COM port address will be detected as such.  There's
never been any facility in the kernel to get around serial ports being
at standard COM port addresses.

Moreover, there's a whole class of applications which want IrDA devices
to be presented to userspace as a serial port rather than a special
network device, so unilaterally ignoring IrDA devices which look like
serial is not really an option.

Basically, IrDA and serial need to develop a way to work in harmony
with each other.  That's a long-term thing though.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
