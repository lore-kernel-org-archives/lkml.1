Return-Path: <linux-kernel-owner+w=401wt.eu-S1753022AbXLECTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbXLECTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 21:19:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbXLECTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 21:19:44 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:42957 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbXLECTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 21:19:43 -0500
Date: Tue, 04 Dec 2007 20:19:04 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [Timers SMP] can this machine be helped?
In-reply-to: <fa./nzsMVb44+6c2x42WGfe04SPDrY@ifi.uio.no>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org
Message-id: <47560A98.9080700@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa./nzsMVb44+6c2x42WGfe04SPDrY@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guennadi Liakhovetski wrote:
> Hi,
> 
> I've got an old 2xP-II @ 400MHz Compaq AP400 system, which I'm still 
> using. It has many peculiarities, so, I wouldn't be surprised if the 
> answer to my questions would be "sorry, the patient is rather dead than 
> alive".
> 
> Some of the problems lie in ACPI area, I tried some time ago to fix the 
> ACPI tables for these machine, but never got enough time for that. So I'm 
> still booting with acpi=noirq
> 
> Another problem is its battery is dead and it's hard soldered to the 
> mainboard (Compaq)...
> 
> It might also have some problems with one of its 3 SCSI busses.
> 
> I compiled a .24-ish kernel for it with CONFIG_NO_HZ and 
> CONFIG_HIGH_RES_TIMERS. To get the system boot at least sometimes I have 
> to specify nohz=off. Then I get
> 
> * Found PM-Timer Bug on the chipset. Due to workarounds for a bug,
> * this clock source is slow. Consider trying other clock sources
> 
> Without this parameter it hangs usually between
> 
> Time: acpi_pm clocksource has been installed.
> 
> and
> 
> Switched to high resolution mode on CPU 1
> Switched to high resolution mode on CPU 0
> 
> Tried booting with clocksource=tsc then I've got
> 
> Marking TSC unstable due to: possible TSC halt in C2.
> 
> And then a few of these:
> 
> BUG: soft lockup - CPU#0 stuck for 13s! [swapper:0]
> 
> Pid: 0, comm: swapper Not tainted (2.6.24-rc2-g8c086340 #3)
> EIP: 0060:[<c0233d33>] EFLAGS: 00000283 CPU: 0
> EIP is at acpi_processor_idle+0x2ae/0x477
> EAX: 00000000 EBX: fffffeab ECX: 00000001 EDX: 00000001
> ESI: c7c5f2d0 EDI: 00122d9f EBP: c03ddfa8 ESP: c03ddf90
>  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> CR0: 8005003b CR2: 081dcf88 CR3: 07e46000 CR4: 000002d0
> DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> DR6: ffff0ff0 DR7: 00000400
>  [<c01053fa>] show_trace_log_lvl+0x1a/0x30
>  [<c0105f42>] show_trace+0x12/0x20
>  [<c01024fc>] show_regs+0x1c/0x20
>  [<c014fabb>] softlockup_tick+0x11b/0x150
>  [<c01311f2>] run_local_timers+0x12/0x20
>  [<c013168f>] update_process_times+0x2f/0x60
>  [<c014597a>] tick_sched_timer+0x6a/0xe0
>  [<c013fba0>] hrtimer_interrupt+0x120/0x1a0
>  [<c0119ff5>] smp_apic_timer_interrupt+0x55/0x90
>  [<c0104e70>] apic_timer_interrupt+0x28/0x30
>  [<c0102624>] cpu_idle+0x84/0xf0
>  [<c0316a7d>] rest_init+0x5d/0x60
>  [<c03e1a7f>] start_kernel+0x2af/0x2f0
>  [<00000000>] run_init_process+0x3feff000/0x20
>  =======================
> 
> so, is there any way I can still reasonably use this system? Which 
> configuration / command-line parameters should I try?
> 
> If needed can provide complete dmesg (with nohz=off or with 
> clocksource=tsc) and .config.

How about disabling ACPI entirely, acpi=off on kernel command line? I 
wouldn't be surprised to see a lot of ACPI stuff broken on an older 
machine like that..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

