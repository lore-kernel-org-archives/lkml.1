Return-Path: <linux-kernel-owner+w=401wt.eu-S1756911AbYISCJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbYISCJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 22:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755271AbYISCJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 22:09:07 -0400
Received: from gw.goop.org ([64.81.55.164]:56118 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690AbYISCJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 22:09:06 -0400
Message-ID: <48D309C2.6080800@goop.org>
Date: Thu, 18 Sep 2008 19:09:06 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Bryan Donlan <bdonlan@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Kernel OOPS and panic on boot in advantech watchdog init
References: <3e8340490809181902q31e8227fq72a7bea688b594c1@mail.gmail.com>
In-Reply-To: <3e8340490809181902q31e8227fq72a7bea688b594c1@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Donlan wrote:
> When testing a non-modular kernel on i386 with many of the default
> drivers left on under Xen, I got the following oops and panic on boot:
>   

Yes.  Some drivers assume their hardware is there and attempt to access
it without doing any kind of probing; watchdog drivers seem to be
particularly bad at this.

The only good answer at the moment is to disable this driver in your
config, or build it as a module.

    J

> {many, many lines cut}
> [   29.975610] acquirewdt: I/O address 0x0043 already in use
> [   29.979380] acquirewdt: probe of acquirewdt failed with error -5
> [   29.979380] WDT driver for Advantech single board computer initialising.
> [   30.122533] advantechwdt: I/O address 0x0443 already in use
> [   30.126288] advantechwdt: probe of advantechwdt failed with error -5
> [   30.126288] alim7101_wdt: Steve Hill <steve@navaho.co.uk>.
> [   30.126288] alim7101_wdt: ALi M7101 PMU not present - WDT not set
> [   30.328280] BUG: unable to handle kernel paging request at d6023220
> [   30.332244] IP: [<c021f6f3>] xen_set_pte+0x3/0x10
> [   30.332244] *pdpt = 000000054cd7e027
> [   30.332244] Oops: 0003 [#1] SMP
> [   30.332244]
> [   30.332244] Pid: 1, comm: swapper Tainted: G        W (2.6.27-rc5pvtest #1)
> [   30.332244] EIP: 0061:[<c021f6f3>] EFLAGS: 00010286 CPU: 3
> [   30.332244] EIP is at xen_set_pte+0x3/0x10
> [   30.332244] EAX: d6023220 EBX: 80000000 ECX: 800007ff EDX: fffff063
> [   30.332244] ESI: fffff063 EDI: 00001000 EBP: d6023220 ESP: d6031e9c
> [   30.332244]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0069
> [   30.332244] Process swapper (pid: 1, ti=d6030000 task=d602c000
> task.ti=d6030000)
> [   30.332244] Stack: c037be42 fffff063 800007ff 28fab000 d7045000
> d7044000 c0f9a018 d7045000
> [   30.332244]        c10575c0 000fffef d7044fff d7044fff d7045000
> fffef000 00000000 00001000
> [   30.332244]        00000010 c023d311 00000173 80000000 00000010
> d6031f28 d7045000 fffefcb0
> [   30.332244] Call Trace:
> [   30.332244]  [<c037be42>] ioremap_page_range+0x1e2/0x280
> [   30.332244]  [<c023d311>] __ioremap_caller+0x1e1/0x340
> [   30.332244]  [<c0ffeaa7>] sc520_wdt_init+0x27/0x100
> [   30.332244]  [<c0ffea80>] sc520_wdt_init+0x0/0x100
> [   30.332244]  [<c023d5a8>] ioremap_nocache+0x18/0x20
> [   30.332244]  [<c0ffeaa7>] sc520_wdt_init+0x27/0x100
> [   30.332244]  [<c0ffeaa7>] sc520_wdt_init+0x27/0x100
> [   30.332244]  [<c0ffe6dd>] advwdt_init+0x4d/0x70
> [   30.332244]  [<c0203099>] do_one_initcall+0x99/0x180
> [   30.332244]  [<c0203033>] do_one_initcall+0x33/0x180
> [   30.332244]  [<c02e9ccf>] proc_register+0xff/0x1b0
> [   30.332244]  [<c02e9b1e>] __proc_create+0x8e/0x110
> [   30.332244]  [<c02e9e84>] create_proc_entry+0x54/0xa0
> [   30.332244]  [<c0285ea9>] register_irq_proc+0xb9/0xd0
> [   30.332244]  [<c0fbe642>] kernel_init+0x112/0x170
> [   30.332244]  [<c0fbe530>] kernel_init+0x0/0x170
> [   30.332244]  [<c0224a4f>] kernel_thread_helper+0x7/0x10
> [   30.332244]  =======================
> [   30.332244] Code: 00 8d bc 27 00 00 00 00 e9 6b ff ff ff 8d 74 26
> 00 8d bc 27 00 00 00 00 e9 5b ff ff ff 8d 74 26 00 8d bc 27 00 00 00
> 00 89 48 04 <89> 10 c3 8d 76 00 8d bc 27 00 00 00 00 83 ec 10 89 5c 24
> 08 89
> [   30.332244] EIP: [<c021f6f3>] xen_set_pte+0x3/0x10 SS:ESP 0069:d6031e9c
> [   30.332244] ---[ end trace 4eaa2a86a8e2da22 ]---
> [   30.332244] Kernel panic - not syncing: Attempted to kill init!
> [   30.332244] ------------[ cut here ]------------
> [   30.332244] WARNING: at kernel/smp.c:332 smp_call_function_mask+0x1c1/0x1d0()
> [   30.332244] Pid: 1, comm: swapper Tainted: G      D W 2.6.27-rc5pvtest #1
> [   30.332244]  [<c024dbaa>] warn_on_slowpath+0x5a/0xa0
> [   30.332244]  [<c03b1eaf>] fbcon_cursor+0x19f/0x300
> [   30.332244]  [<c02654d7>] atomic_notifier_call_chain+0x17/0x20
> [   30.332244]  [<c047716f>] notify_update+0x1f/0x30
> [   30.332244]  [<c04773fa>] vt_console_print+0x20a/0x2d0
> [   30.332244]  [<c04619e7>] force_evtchn_callback+0x17/0x30
> [   30.332244]  [<c02211ea>] check_events+0x8/0xe
> [   30.332244]  [<c0221153>] xen_restore_fl_direct_end+0x0/0x1
> [   30.332244]  [<c04619e7>] force_evtchn_callback+0x17/0x30
> [   30.332244]  [<c02211ea>] check_events+0x8/0xe
> [   30.332244]  [<c0221153>] xen_restore_fl_direct_end+0x0/0x1
> [   30.332244]  [<c024e500>] vprintk+0x170/0x350
> [   30.332244]  [<c026f011>] smp_call_function_mask+0x1c1/0x1d0
> [   30.332244]  [<c0275f7c>] crash_kexec+0x6c/0xd0
> [   30.332244]  [<c0221153>] xen_restore_fl_direct_end+0x0/0x1
> [   30.332244]  [<c024e500>] vprintk+0x170/0x350
> [   30.332244]  [<c0479013>] do_unblank_screen+0x23/0x140
> [   30.332244]  [<c026f034>] smp_call_function+0x14/0x20
> [   30.332244]  [<c024da95>] panic+0x55/0x110
> [   30.332244]  [<c0251177>] do_exit+0x857/0x860
> [   30.332244]  [<c024e6fb>] printk+0x1b/0x20
> [   30.332244]  [<c0224f01>] oops_end+0xb1/0xc0
> [   30.332244]  [<c023c81a>] do_page_fault+0x29a/0x9d0
> [   30.332244]  [<c0224a9f>] xen_do_upcall+0x7/0xc
> [   30.332244]  [<c023c580>] do_page_fault+0x0/0x9d0
> [   30.332244]  [<c0b341ba>] error_code+0x72/0x78
> [   30.332244]  [<c022007b>] xen_pgd_pin+0x3b/0x110
> [   30.332244]  [<c021f6f3>] xen_set_pte+0x3/0x10
> [   30.332244]  [<c037be42>] ioremap_page_range+0x1e2/0x280
> [   30.332244]  [<c023d311>] __ioremap_caller+0x1e1/0x340
> [   30.332244]  [<c0ffeaa7>] sc520_wdt_init+0x27/0x100
> [   30.332244]  [<c0ffea80>] sc520_wdt_init+0x0/0x100
> [   30.332244]  [<c023d5a8>] ioremap_nocache+0x18/0x20
> [   30.332244]  [<c0ffeaa7>] sc520_wdt_init+0x27/0x100
> [   30.332244]  [<c0ffeaa7>] sc520_wdt_init+0x27/0x100
> [   30.332244]  [<c0ffe6dd>] advwdt_init+0x4d/0x70
> [   30.332244]  [<c0203099>] do_one_initcall+0x99/0x180
> [   30.332244]  [<c0203033>] do_one_initcall+0x33/0x180
> [   30.332244]  [<c02e9ccf>] proc_register+0xff/0x1b0
> [   30.332244]  [<c02e9b1e>] __proc_create+0x8e/0x110
> [   30.332244]  [<c02e9e84>] create_proc_entry+0x54/0xa0
> [   30.332244]  [<c0285ea9>] register_irq_proc+0xb9/0xd0
> [   30.332244]  [<c0fbe642>] kernel_init+0x112/0x170
> [   30.332244]  [<c0fbe530>] kernel_init+0x0/0x170
> [   30.332244]  [<c0224a4f>] kernel_thread_helper+0x7/0x10
> [   30.332244]  =======================
> [   30.332244] ---[ end trace 4eaa2a86a8e2da22 ]---
>
> The hardware in question is, of course, not present. My .config and
> full boot log are attached; I'm using git
> afa153fd7b6afcd55dd6df6aea06bb53aa1d3608 from linus's tree. This
> particular boot was done with pv-grub, but the crash also occurs
> without pv-grub, that is, booted directly through Xen.
>   

