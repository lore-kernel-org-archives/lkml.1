Return-Path: <linux-kernel-owner+w=401wt.eu-S933670AbXK2VAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933670AbXK2VAx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 16:00:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932642AbXK2VAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 16:00:44 -0500
Received: from mail.gmx.net ([213.165.64.20]:54582 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932619AbXK2VAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 16:00:40 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/O5SthAijOdXYY5KcNPENPKsvrlzQPK717wOI5D0
	7ro7B+7VpeIuTB
Date: Thu, 29 Nov 2007 22:00:38 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: [Timers SMP] can this machine be helped?
Message-ID: <Pine.LNX.4.64.0711292144260.6673@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've got an old 2xP-II @ 400MHz Compaq AP400 system, which I'm still 
using. It has many peculiarities, so, I wouldn't be surprised if the 
answer to my questions would be "sorry, the patient is rather dead than 
alive".

Some of the problems lie in ACPI area, I tried some time ago to fix the 
ACPI tables for these machine, but never got enough time for that. So I'm 
still booting with acpi=noirq

Another problem is its battery is dead and it's hard soldered to the 
mainboard (Compaq)...

It might also have some problems with one of its 3 SCSI busses.

I compiled a .24-ish kernel for it with CONFIG_NO_HZ and 
CONFIG_HIGH_RES_TIMERS. To get the system boot at least sometimes I have 
to specify nohz=off. Then I get

* Found PM-Timer Bug on the chipset. Due to workarounds for a bug,
* this clock source is slow. Consider trying other clock sources

Without this parameter it hangs usually between

Time: acpi_pm clocksource has been installed.

and

Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0

Tried booting with clocksource=tsc then I've got

Marking TSC unstable due to: possible TSC halt in C2.

And then a few of these:

BUG: soft lockup - CPU#0 stuck for 13s! [swapper:0]

Pid: 0, comm: swapper Not tainted (2.6.24-rc2-g8c086340 #3)
EIP: 0060:[<c0233d33>] EFLAGS: 00000283 CPU: 0
EIP is at acpi_processor_idle+0x2ae/0x477
EAX: 00000000 EBX: fffffeab ECX: 00000001 EDX: 00000001
ESI: c7c5f2d0 EDI: 00122d9f EBP: c03ddfa8 ESP: c03ddf90
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 081dcf88 CR3: 07e46000 CR4: 000002d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c01053fa>] show_trace_log_lvl+0x1a/0x30
 [<c0105f42>] show_trace+0x12/0x20
 [<c01024fc>] show_regs+0x1c/0x20
 [<c014fabb>] softlockup_tick+0x11b/0x150
 [<c01311f2>] run_local_timers+0x12/0x20
 [<c013168f>] update_process_times+0x2f/0x60
 [<c014597a>] tick_sched_timer+0x6a/0xe0
 [<c013fba0>] hrtimer_interrupt+0x120/0x1a0
 [<c0119ff5>] smp_apic_timer_interrupt+0x55/0x90
 [<c0104e70>] apic_timer_interrupt+0x28/0x30
 [<c0102624>] cpu_idle+0x84/0xf0
 [<c0316a7d>] rest_init+0x5d/0x60
 [<c03e1a7f>] start_kernel+0x2af/0x2f0
 [<00000000>] run_init_process+0x3feff000/0x20
 =======================

so, is there any way I can still reasonably use this system? Which 
configuration / command-line parameters should I try?

If needed can provide complete dmesg (with nohz=off or with 
clocksource=tsc) and .config.

Thanks
Guennadi
---
Guennadi Liakhovetski
