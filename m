Return-Path: <linux-kernel-owner+w=401wt.eu-S1758703AbXKTF3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758703AbXKTF3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 00:29:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758491AbXKTF3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 00:29:19 -0500
Received: from smtp.syd.people.net.au ([218.214.225.98]:45606 "HELO
	smtp.syd.people.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758236AbXKTF3S (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 00:29:18 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Nov 2007 00:29:17 EST
Date: Tue, 20 Nov 2007 16:22:25 +1100
From: Erik de Castro Lopo <mle+lk@mega-nerd.com>
To: Linux-kernel@vger.kernel.org
Subject: BUG: soft lockup detected on CPU#0! in 2.6.23.8
Message-Id: <20071120162225.c5006305.mle+lk@mega-nerd.com>
Reply-To: Linux-kernel@vger.kernel.org
Organization: Erik Conspiracy Secret Labs
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

HI all,

I've just compiled 2.6.23.8 from kernel.org sources and I getting a
bunch of these soft lockups detected. This seems to be similar to
the problems reported here:

    http://lkml.org/lkml/2007/11/19/345

but I am not as far as I am aware using the ondemand governor.

    > cat /proc/acpi/processor/CPU0/info 
    processor id:            0
    acpi id:                 0
    bus mastering control:   no
    power management:        no
    throttling control:      no
    limit interface:         no

What is suspisious is "Clocksource tsc unstable".

Dump from dmsg follows. Any light people can shed on this much
appreciated.

Cheers,
Erik


[   80.215847] Marking TSC unstable due to: cpufreq changes.
[   80.217903] Time: acpi_pm clocksource has been installed.
[   80.217908] BUG: soft lockup detected on CPU#0!
[   80.217924]  [<c014212b>] softlockup_tick+0xbb/0xf0
[   80.217934]  [<c0126152>] update_process_times+0x32/0x80
[   80.217941]  [<c0139395>] tick_sched_timer+0x75/0x1c0
[   80.217952]  [<c0133e70>] hrtimer_interrupt+0x170/0x1c0
[   80.217960]  [<c011119d>] smp_apic_timer_interrupt+0x3d/0x80
[   80.217966]  [<c0104bc8>] apic_timer_interrupt+0x28/0x30
[   80.217973]  [<c043007b>] pci_pcbios_init+0x18b/0x260
[   80.217979]  [<c0102fab>] default_idle+0x2b/0x40
[   80.217984]  [<c0103008>] cpu_idle+0x48/0x80
[   80.217987]  [<c041087f>] start_kernel+0x21f/0x2a0
[   80.217992]  [<c04102e0>] unknown_bootoption+0x0/0x1d0
[   80.217997]  =======================
[   80.757447] Clocksource tsc unstable (delta = -99999062 ns)
[   98.773859] BUG: soft lockup detected on CPU#0!
[   98.773881]  [<c014212b>] softlockup_tick+0xbb/0xf0
[   98.773893]  [<c0126152>] update_process_times+0x32/0x80
[   98.773901]  [<c0139395>] tick_sched_timer+0x75/0x1c0
[   98.773913]  [<c0133e70>] hrtimer_interrupt+0x170/0x1c0
[   98.773922]  [<c011119d>] smp_apic_timer_interrupt+0x3d/0x80
[   98.773930]  [<c0104bc8>] apic_timer_interrupt+0x28/0x30
[   98.773938]  [<c0340000>] hci_sock_setsockopt+0x0/0x1b0
[   98.773947]  =======================
[   85.153581] BUG: soft lockup detected on CPU#0!
[   85.153602]  [<c014212b>] softlockup_tick+0xbb/0xf0
[   85.153614]  [<c0126152>] update_process_times+0x32/0x80
[   85.153621]  [<c0139395>] tick_sched_timer+0x75/0x1c0
[   85.153631]  [<c0133e70>] hrtimer_interrupt+0x170/0x1c0
[   85.153639]  [<c011119d>] smp_apic_timer_interrupt+0x3d/0x80
[   85.153645]  [<c0104bc8>] apic_timer_interrupt+0x28/0x30
[   85.153653]  [<c0340000>] hci_sock_setsockopt+0x0/0x1b0
[   85.153660]  =======================
[   72.741364] usb 1-1: reset full speed USB device using uhci_hcd and address 2
[   99.596976] BUG: soft lockup detected on CPU#0!
[   99.596995]  [<c014212b>] softlockup_tick+0xbb/0xf0
[   99.597006]  [<c0126152>] update_process_times+0x32/0x80
[   99.597013]  [<c0139395>] tick_sched_timer+0x75/0x1c0
[   99.597024]  [<c0133e70>] hrtimer_interrupt+0x170/0x1c0
[   99.597032]  [<c011119d>] smp_apic_timer_interrupt+0x3d/0x80
[   99.597038]  [<c0104bc8>] apic_timer_interrupt+0x28/0x30
[   99.597045]  [<c043007b>] pci_pcbios_init+0x18b/0x260
[   99.597050]  [<c0102fab>] default_idle+0x2b/0x40
[   99.597054]  [<c0103008>] cpu_idle+0x48/0x80
[   99.597057]  [<c041087f>] start_kernel+0x21f/0x2a0
[   99.597063]  [<c04102e0>] unknown_bootoption+0x0/0x1d0
[   99.597068]  =======================
[  124.441285] BUG: soft lockup detected on CPU#0!
[  124.441305]  [<c014212b>] softlockup_tick+0xbb/0xf0
[  124.441315]  [<c0126152>] update_process_times+0x32/0x80
[  124.441323]  [<c0139395>] tick_sched_timer+0x75/0x1c0
[  124.441336]  [<c0133e70>] hrtimer_interrupt+0x170/0x1c0
[  124.441345]  [<c011119d>] smp_apic_timer_interrupt+0x3d/0x80
[  124.441352]  [<c0104bc8>] apic_timer_interrupt+0x28/0x30
[  124.441360]  [<c043007b>] pci_pcbios_init+0x18b/0x260
[  124.441366]  [<c0102fab>] default_idle+0x2b/0x40
[  124.441371]  [<c0103008>] cpu_idle+0x48/0x80
[  124.441375]  [<c041087f>] start_kernel+0x21f/0x2a0
[  124.441381]  [<c04102e0>] unknown_bootoption+0x0/0x1d0
[  124.441388]  =======================


-- 
-----------------------------------------------------------------
Erik de Castro Lopo
-----------------------------------------------------------------
Linux, the UNIX defragmentation tool.
