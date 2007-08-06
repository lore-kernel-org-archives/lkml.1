Return-Path: <linux-kernel-owner+w=401wt.eu-S1765341AbXHFV6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765341AbXHFV6j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 17:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758362AbXHFV6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 17:58:32 -0400
Received: from gate.crashing.org ([63.228.1.57]:46307 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758132AbXHFV6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 17:58:31 -0400
In-Reply-To: <46B79562.9020202@genesi-usa.com>
References: <200708020440.l724edCT290676@shell01.TheWorld.com> <46B79562.9020202@genesi-usa.com>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <f4545a576abeddf00f076a0cae9e3fdd@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: linuxppc-dev@ozlabs.org, Alan Curry <pacman@TheWorld.com>,
       linux-kernel@vger.kernel.org
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH] powerpc: Pegasos keyboard detection
Date: Mon, 6 Aug 2007 23:57:35 +0200
To: Matt Sealey <matt@genesi-usa.com>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 2) The fix was in the wrong place anyway, if it was going to be done 
> anywhere
> at all it needs to be in 
> arch/powerpc/kernel/prom_init.c:fixup_device_tree_chrp()
> like the ISA ranges breakage (which is on Briq) and IDE IRQ 
> misnumbering fix.
> Not the keyboard platform driver.

Yeah.  In the bootwrapper.

> 3) In any case this should be something that is fixed in the firmware, 
> as any
> stalwart, stubborn Linux developer will rant at you about.

Sure, if you *can* get a fix for the firmware.  Until every
user has this update, fixing it in the kernel wrapper helps
users.

> As for Segher, bootwrapper not such a good place as that's still 
> mussing up
> the kernel with these fixes. Let the boot loader do it for the OS, and 
> don't
> mess up the OS with device-tree fixups.

Sure, the bootloader can do it too, but then we need to fix
every bootloader that's used with Linux on this platform.
Maybe that's just one, that would make things simple :-)

> After all it may not just be Linux
> that stumbles on it. Why have the same patch in every OS?

This is just pragmatics: Linux needs the workaround -> Linux
implements the workaround.  Sure it is not a _proper_ fix, but
a correctly implemented workaround "fixes" it for all users,
forever.

> With nvramrc, the fix is done for EVERY operating system from firmware 
> upwards.

But it's something every user has to do separately.

> The semi-official Genesi line of support and what I have been told by 
> the board
> designer is if you need to fix something in the device tree, that is 
> what nvramrc
> is for, and that is why Open Firmware runs Forth scripts.

That's hardly the only reason.  But yeah, that's one way to
implement the workaround, but _we_ (the Linux community) cannot
do it like that (easily) for all users.


Segher

