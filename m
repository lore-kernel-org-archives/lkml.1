Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327AbZKLXjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbZKLXjM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 18:39:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755220AbZKLXjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 18:39:09 -0500
Received: from lucidpixels.com ([75.144.35.66]:49322 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754822AbZKLXjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 18:39:08 -0500
Date: Thu, 12 Nov 2009 18:39:12 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Dave Jones <davej@redhat.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.31.4: WARNING: at arch/x86/kernel/hpet.c:390
 hpet_next_event+0x70/0x80() [occurs when ACPI_PROCESSOR=y]
In-Reply-To: <alpine.DEB.2.00.0911121127500.6976@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.0911121830160.2309@p34.internal.lan>
References: <alpine.DEB.2.00.0911080932590.4556@p34.internal.lan> <20091111195016.GB22225@redhat.com> <alpine.DEB.2.00.0911111608020.5456@p34.internal.lan> <alpine.DEB.2.00.0911121120330.6976@p34.internal.lan>
 <alpine.DEB.2.00.0911121127500.6976@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 12 Nov 2009, Justin Piszcz wrote:

>
>
> On Thu, 12 Nov 2009, Justin Piszcz wrote:
>
>> On Wed, 11 Nov 2009, Justin Piszcz wrote:
>> 
>>> Hi,
>
>> Again, the problem:
>> [    3.318770] cpuidle: using governor ladder
>> [    3.321556] ------------[ cut here ]------------
>> [    3.321560] WARNING: at arch/x86/kernel/hpet.c:390 
>> hpet_next_event+0x70/0x80()
>> [    3.321561] Hardware name:
>> [    3.321562] Modules linked in:
>> [    3.321564] Pid: 0, comm: swapper Not tainted 2.6.31.5 #17
>> [    3.321565] Call Trace:
>> [    3.321567]  [<ffffffff81042f00>] ? hpet_next_event+0x70/0x80
>> [    3.321568]  [<ffffffff81042f00>] ? hpet_next_event+0x70/0x80
>> [    3.321571]  [<ffffffff81056724>] ? warn_slowpath_common+0x74/0xd0
>> [    3.321573]  [<ffffffff81042f00>] ? hpet_next_event+0x70/0x80
>> [    3.321576]  [<ffffffff81077696>] ? tick_dev_program_event+0x36/0xb0
>> [    3.321578]  [<ffffffff81077079>] ? 
>> tick_broadcast_oneshot_control+0x119/0x120
>> [    3.321579]  [<ffffffff8107683d>] ? tick_notify+0x22d/0x420
>> [    3.321581]  [<ffffffff8106fe37>] ? notifier_call_chain+0x37/0x70
>> [    3.321583]  [<ffffffff8107612b>] ? clockevents_notify+0x2b/0x90
>> [    3.321586]  [<ffffffff81244848>] ? acpi_idle_enter_bm+0x15f/0x2d3
>> [    3.321587]  [<ffffffff812446de>] ? acpi_idle_enter_c1+0xf1/0xfc
>> [    3.321590]  [<ffffffff812e6d7a>] ? cpuidle_idle_call+0xba/0x120
>> [    3.321593]  [<ffffffff8102b832>] ? cpu_idle+0x62/0xc0
>> [    3.321596] ---[ end trace cac202f11005305c ]---
>> [    3.553852] cpuidle: using governor menu
>
> Other user with this problem:
> http://lkml.org/lkml/2009/10/2/330 - Nobody responded to his report.
>
> This has been also been reported on other forums with no fix / conclusion on
> any type of fix or work-around.
>
> Justin.
>
>

Someone sent me a patch off-list which prints out what hpet is doing:

Hi,

Unfortunately I cannot login fast enough to get a full dmesg:

It continually scrolls with this:

[   11.463500] hpet_next_event: hpet_writel failed: 0x9c90955 != 0xa0e8b7b
[   11.463972] hpet_next_event: hpet_writel failed: 0xa0e8b7b != 0x9cb9398
[   11.475121] hpet_next_event: hpet_writel failed: 0x9cb9398 != 0xa0e8b71
[   11.475144] hpet_next_event: hpet_writel failed: 0xa0e8b71 != 0x9ce0459
[   11.486274] hpet_next_event: hpet_writel failed: 0x9ce0459 != 0xa0e8b61
[   11.486343] hpet_next_event: hpet_writel failed: 0xa0e8b61 != 0x9d076c0
[   11.497492] hpet_next_event: hpet_writel failed: 0x9d076c0 != 0xa0e8b4c
[   11.497962] hpet_next_event: hpet_writel failed: 0xa0e8b4c != 0x9d30119
[   11.509111] hpet_next_event: hpet_writel failed: 0x9d30119 != 0xa0e8b3c
[   11.509134] hpet_next_event: hpet_writel failed: 0xa0e8b3c != 0x9d571a9
[   11.520275] hpet_next_event: hpet_writel failed: 0x9d571a9 != 0xa0e8b2f
[   11.520293] hpet_next_event: hpet_writel failed: 0xa0e8b2f != 0x9d7e24d
[   11.531443] hpet_next_event: hpet_writel failed: 0x9d7e24d != 0xa0e8b1d
[   11.531947] hpet_next_event: hpet_writel failed: 0xa0e8b1d != 0x9da6e46
[   11.543095] hpet_next_event: hpet_writel failed: 0x9da6e46 != 0xa0e8b0c

When I do not load processor.ko though, the error does not occur.

Something is wrong with processor.ko that screws up hpet.

With the patch applied and processor.ko removed from the kernel:

$ dmesg | grep -i hpet
[    0.000000] ACPI: HPET 00000000cf7f3000 00038 (v01 INTEL  KBIBX10J 00000F26 MSFT 0100000D)
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000232] hpet clockevent registered
[    0.000246] HPET: 8 timers in total, 5 timers will be used for per-cpu timer
[    0.655058] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 24, 25, 26, 27, 28, 0
[    0.655064] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.658023] hpet: hpet2 irq 24 for MSI
[    0.658247] hpet: hpet3 irq 25 for MSI
[    0.658994] hpet: hpet4 irq 26 for MSI
[    0.659328] hpet: hpet5 irq 27 for MSI
[    0.660007] hpet: hpet6 irq 28 for MSI
[    3.014543] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs

No issues.

Also, when the kernel is spewing those failed writes for HPET, I bet that is
what is responsible for the high pitch noise as well, using a kernel without
the processor module and no hpet_write failures, there is no high pitch noise.

What is going on here?

Has hpet+ACPI/processor.ko been tested with the P55 chipset?

Justin.

