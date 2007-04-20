Return-Path: <linux-kernel-owner+w=401wt.eu-S2993268AbXDTP2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993268AbXDTP2L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 11:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993269AbXDTP2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 11:28:10 -0400
Received: from gw.goop.org ([64.81.55.164]:41801 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993268AbXDTP2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 11:28:09 -0400
Message-ID: <4628DC0A.60707@goop.org>
Date: Fri, 20 Apr 2007 08:28:10 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, pavel@suse.cz,
       linux-pm@lists.osdl.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, gregkh@suse.de
Subject: Re: [2/2] 2.6.21-rc7: known regressions
References: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org> <20070416003723.GM3691@stusta.de> <4628482B.6040804@goop.org> <20070420050344.GG20566@redhat.com> <46284C84.6060301@goop.org> <20070420051908.GH20566@redhat.com> <462850B3.70901@goop.org> <20070420145126.GC25051@redhat.com>
In-Reply-To: <20070420145126.GC25051@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> -BUG: at arch/i386/kernel/sched-clock.c:170 init_sched_clock()
> - [<c01091b5>] show_trace_log_lvl+0x1a/0x30
> - [<c010980c>] show_trace+0x12/0x14
> - [<c01098cb>] dump_stack+0x16/0x18
> - [<c0468dbd>] init_sched_clock+0x58/0x9b
> - [<c0461502>] init+0x14b/0x241
> - [<c0108d97>] kernel_thread_helper+0x7/0x10
> - =======================
>
> heh, one for Ingo :)
>   

Andi, I think.  I've got his firstfloor.org patches applied to this kernel.

> -ACPI: ACPI Dock Station Driver 
> -ACPI: \_SB_.PCI0.IDE0.PRIM.MSTR: found ejectable bay
> -ACPI: \_SB_.PCI0.IDE0.PRIM.MSTR: Adding notify handler
> -ACPI: Bay [\_SB_.PCI0.IDE0.PRIM.MSTR] Added
>
> Hmm, I should try without the dock stuff built.
>
> -PCI: Using MMCONFIG
> +PCI: PCI BIOS revision 2.10 entry at 0xfd82b, last bus=24
> +PCI: Using configuration type 1
>
> Think I've tried with and without MMCONFIG
>
> -pnp: PnP ACPI: found 11 devices
> +pnp: PnP ACPI: found 13 devices
>
> My Wacom tablet is one of them. There's also a mysterious 13th device :)
>
>  ibm_acpi: IBM ThinkPad ACPI Extras v0.13
>  ibm_acpi: http://ibm-acpi.sf.net/
> -ibm_acpi: ThinkPad EC firmware 7BHT37WW-1.10
> +ibm_acpi: ThinkPad EC firmware 7JHT12WW-1.03
>
> possibly just because of the touchscreen.
>   

I'm running a very recent BIOS in order to enable hardware
virtualization (VT/VMX).  The BIOS updates also update the EC firmware.

> So most of the differences seem to be BIOS/firmware rather than hardware. 
> The PCI bus layout is identical for eg.
>   

Do you have Intel wireless?  I realized one chance I'd made was to swap
the Atheros wireless with Intel, since it just seems to work better
overall.  I'd never had any major suspend/resume problems that I could
attribute to madwifi though (lots of minor wifi-related ones though).

> Looking at your .config, I notice that you don't have CONFIG_FB_BACKLIGHT set
> (because you don't have any framebuffer drivers that use it enabled).
> Can you enable say.. CONFIG_FB_RADEON=m and CONFIG_FB_RADEON_BACKLIGHT=y
> (which should turn on CONFIG_FB_BACKLIGHT=y by dependancy), and see if
> it stops working for you? (You don't even need to load radeonfb.ko, just
> have it compiled).

OK, I'll give it a spin.

    J
