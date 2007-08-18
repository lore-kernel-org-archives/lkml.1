Return-Path: <linux-kernel-owner+w=401wt.eu-S1756535AbXHRPiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535AbXHRPiL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 11:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754439AbXHRPhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 11:37:54 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:10212 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477AbXHRPhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 11:37:53 -0400
X-IronPort-AV: i="4.19,280,1183348800"; 
   d="scan'208"; a="48804453:sNHT26361706"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [draft] Blackfin Early Printk implmentation
Date: Sat, 18 Aug 2007 11:37:52 -0400
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, "Gerd Hoffmann" <kraxel@redhat.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Bryan Wu" <bryan.wu@analog.com>,
       "Sonic Zhang" <sonic.adi@gmail.com>,
       "Mike Frysinger" <vapier.adi@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <200708152234.06734.rgetz@blackfin.uclinux.org> <200708171607.32849.rgetz@blackfin.uclinux.org> <20070818062333.GA26416@uranus.ravnborg.org>
In-Reply-To: <20070818062333.GA26416@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708181137.52902.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 18 Aug 2007 15:37:51.0667 (UTC) FILETIME=[BCCFB830:01C7E1AD]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 18 Aug 2007 02:23, Sam Ravnborg pondered:
> > > What was preventing you from just using the x86_64 code here?
> > 
> > Some was borrowed - but not much. since we don't support vga, or 
> > 16550 UARTs (Blackfin has it's own on-chip UART), I don't think 
> > this would work.  Everyone implements implements direct IO to 
> > the hardware (except me, since I  put it into the driver file,
> > and force Sonic - the serial driver developer - to maintain it
> > forever). 
> > 
> > Most of the other early printks talks directly to the hardware.
> I only looked at your version and it looked general thats why I brought
> up the code sharing idea - which I agree is not possible.

Believe me - I would actually like this more - put the I/O parts into the 
serial driver or vga driver or xxx driver - and early printk becomes a 
generic function that is supported on every platform, with a CON_BOOT 
defined.

But, I didn't want (or have the time) to go mucking in everyone else's 
arch/drivers to move things around - but the more I think about it - the 
better it would be. Maybe on my next long plane trip I will look at it.

> > > Thinking that all should do the same so maybe alpha ought to
> > > change...
> > 
> > When I looked at all the printk implementations, I thought they were
> > all kind of hokey, and not very common - but what do you want for a
> > debug interface that lasts less than 5 seconds?
> > 
> > ./arch/x86_64/kernel/early_printk.c
> > ./arch/blackfin/kernel/early_printk.c
> > ./arch/sh64/kernel/early_printk.c
> > ./arch/sh/kernel/early_printk.c
> > ./arch/i386/kernel/early_printk.c
> > ./arch/mips/kernel/early_printk.c
> > 
> > I didn't see an alpha implementation - where is it done?
> Alpha uses the imlementation in lib/*print.c somehow.
> And I think the right choice would be to implement
> a private version of early_printk for alpha like the
> other architectures do.

When looked for EARLY_PRINTK in ./arch/alpha - and include/asm-alpha, it only 
shows up in the Kconfig files - nothing seems to use it...

> Thanks for the split-up. I could follow the changes now.

Any issues/comments? Or do things look OK?

-Robin
