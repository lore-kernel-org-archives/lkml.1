Return-Path: <linux-kernel-owner+w=401wt.eu-S1767120AbXDTOyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767120AbXDTOyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 10:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767123AbXDTOyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 10:54:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767120AbXDTOyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 10:54:18 -0400
Date: Fri, 20 Apr 2007 10:51:26 -0400
From: Dave Jones <davej@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, pavel@suse.cz,
       linux-pm@lists.osdl.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, gregkh@suse.de
Subject: Re: [2/2] 2.6.21-rc7: known regressions
Message-ID: <20070420145126.GC25051@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>, Adrian Bunk <bunk@stusta.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	pavel@suse.cz, linux-pm@lists.osdl.org,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, gregkh@suse.de
References: <Pine.LNX.4.64.0704151659570.5473@woody.linux-foundation.org> <20070416003723.GM3691@stusta.de> <4628482B.6040804@goop.org> <20070420050344.GG20566@redhat.com> <46284C84.6060301@goop.org> <20070420051908.GH20566@redhat.com> <462850B3.70901@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <462850B3.70901@goop.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2007 at 10:33:39PM -0700, Jeremy Fitzhardinge wrote:
 > Dave Jones wrote:
 > > Hmm, given you hit the hpet problems and I didn't I think our X60's
 > > aren't quite so similar.  Mine is the one with the swivelly touchscreen
 > > tablet-pc mode. I understand they made a regular 'laptop' X60 too,
 > > is that the one you have perhaps?
 > 
 > Yes, mine is a normal laptop X60.  Still, its hard to imagine how they
 > could be very different; same CPU, same chipset, same graphics.  The
 > main difference is that your's has a Wacom tablet, presumably attached
 > to USB.
 > 
 > Details attached. How does it compare to your machine?

-1142MB HIGHMEM available.
+118MB HIGHMEM available.

So you have more RAM than I do :)

-NX (Execute Disable) protection: active

You enabled PAE, I didn't..
(Though I have tried both, makes no difference)

 DMI present.
+Using APIC driver default

Hmm.

 ACPI: RSDP 000F67B0, 0024 (r2 LENOVO)
-ACPI: XSDT 7F6D1896, 008C (r1 LENOVO TP-7B        2060  LTP        0)
-ACPI: FACP 7F6D1A00, 00F4 (r3 LENOVO TP-7B        2060 LNVO        1)
+ACPI: XSDT 3F6D12F5, 008C (r1 LENOVO TP-7J        1050  LTP        0)
+ACPI: FACP 3F6D1400, 00F4 (r3 LENOVO TP-7J        1050 LNVO        1)

BIOS differences (lots of these)

-Allocating PCI resources starting at 88000000 (gap: 80000000:70000000)
+Allocating PCI resources starting at 50000000 (gap: 40000000:b0000000)

Probably due to the RAM differences shuffling the memmap.

-Kernel command line: ro root=LABEL=/ acpi_sleep=s3_bios combined_mode=libata
+Kernel command line: ro root=/dev/VolGroup00/LogVol00 profile=1

Hmm. I tried..
acpi_sleep=s3_bios
acpi_sleep=s3_mode
acpi_sleep=s3_bios,s3_mode
all did nothing for me.

-CPU: After all inits, caps: bfe9fbff 00100000 00000000 00002940 0000c1a9 00000000 00000000
+CPU: After all inits, caps: bfe9f3ff 00100000 00000000 00002940 0000c1a9 00000000 00000000

Probably PAE

-CPU0: Intel Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
+CPU0: Intel(R) Core(TM) Duo CPU      L2400  @ 1.66GHz stepping 0c

slightly different CPU, but probably not enough to make any difference.

-BUG: at arch/i386/kernel/sched-clock.c:170 init_sched_clock()
- [<c01091b5>] show_trace_log_lvl+0x1a/0x30
- [<c010980c>] show_trace+0x12/0x14
- [<c01098cb>] dump_stack+0x16/0x18
- [<c0468dbd>] init_sched_clock+0x58/0x9b
- [<c0461502>] init+0x14b/0x241
- [<c0108d97>] kernel_thread_helper+0x7/0x10
- =======================

heh, one for Ingo :)

-ACPI: ACPI Dock Station Driver 
-ACPI: \_SB_.PCI0.IDE0.PRIM.MSTR: found ejectable bay
-ACPI: \_SB_.PCI0.IDE0.PRIM.MSTR: Adding notify handler
-ACPI: Bay [\_SB_.PCI0.IDE0.PRIM.MSTR] Added

Hmm, I should try without the dock stuff built.

-PCI: Using MMCONFIG
+PCI: PCI BIOS revision 2.10 entry at 0xfd82b, last bus=24
+PCI: Using configuration type 1

Think I've tried with and without MMCONFIG

-pnp: PnP ACPI: found 11 devices
+pnp: PnP ACPI: found 13 devices

My Wacom tablet is one of them. There's also a mysterious 13th device :)

 ibm_acpi: IBM ThinkPad ACPI Extras v0.13
 ibm_acpi: http://ibm-acpi.sf.net/
-ibm_acpi: ThinkPad EC firmware 7BHT37WW-1.10
+ibm_acpi: ThinkPad EC firmware 7JHT12WW-1.03

possibly just because of the touchscreen.

So most of the differences seem to be BIOS/firmware rather than hardware. 
The PCI bus layout is identical for eg.

Looking at your .config, I notice that you don't have CONFIG_FB_BACKLIGHT set
(because you don't have any framebuffer drivers that use it enabled).
Can you enable say.. CONFIG_FB_RADEON=m and CONFIG_FB_RADEON_BACKLIGHT=y
(which should turn on CONFIG_FB_BACKLIGHT=y by dependancy), and see if
it stops working for you? (You don't even need to load radeonfb.ko, just
have it compiled).

	Dave

-- 
http://www.codemonkey.org.uk
