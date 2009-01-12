Return-Path: <linux-kernel-owner+w=401wt.eu-S1757514AbZALVuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514AbZALVuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 16:50:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbZALVuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 16:50:05 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:58740 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbZALVuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 16:50:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jyAABrYbEf8QhfN3awtWmcL9VfhFBr3CW42r1dZhlutANttEOLkhO8iQjnKuR0fdlB
         LnEzobEWm2wG3PuJE/3tqk3RwFxP0twPq2qjLH51NR+3PVZ1BuzVA4hPnSGuuRkH3Q44
         pkg1TXcZUi1ohweKW6V68T7JVaQ5Cb1qlgMPo=
Message-ID: <64bb37e0901121350l696b866k4216a36c36ff5785@mail.gmail.com>
Date: Mon, 12 Jan 2009 22:50:00 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [git pull] x86 fixes
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20090112204041.GB3329@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090111143951.GA6666@elte.hu>
	 <64bb37e0901110845o2561db4auf68b86d024d210a0@mail.gmail.com>
	 <7E82351C108FA840AB1866AC776AEC4643BB73C5@orsmsx505.amr.corp.intel.com>
	 <64bb37e0901121101y73c492fel38a70681f226b526@mail.gmail.com>
	 <20090112191934.GA28851@linux-os.sc.intel.com>
	 <20090112192912.GA31650@linux-os.sc.intel.com>
	 <64bb37e0901121205u78195ac4j145fa922f9e99107@mail.gmail.com>
	 <20090112204041.GB3329@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 9:40 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Torsten Kaiser <just.for.lkml@googlemail.com> wrote:
>
>> On Mon, Jan 12, 2009 at 8:29 PM, Pallipadi, Venkatesh
>> <venkatesh.pallipadi@intel.com> wrote:
>> > oops. I missed out one file in the earlier test patch. Below is the
>> > updated test patch that will go against 29-rc1.
>> >
>> > Thanks,
>> > Venki
>> >
>> > Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipad@intel.com>
>>
>> Tested-by: Torsten Kaiser <just.for.lkml@googlemail.com>
>>
>> The system boots normal and glxgears is accelerated again.
>
> Could you try the tree below as well please?

Before I read this mail, I already tried the tree you send to Linus as
a pull request.
That worked without a crash, but as expected the DRM related error was
still there.

> It's functionally the same as the patch you just tried - with a few
> cleanups. (If you again get a crash then we know that it's the difference
> between this version and the patch you just tried that causes the crash.)
>
> You can git-pull the URI below into v2.6.29-rc1.
>
>        Ingo
>
> ---------------------->
> Please pull the latest x86/pat git tree from:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86/pat

pulled && build, here is the result:
[   76.170171] BUG: unable to handle kernel NULL pointer dereference at (null)
[   76.178376] IP: [<(null)>] (null)
[   76.180010] PGD 0
[   76.180010] Oops: 0010 [#1] SMP
[   76.180010] last sysfs file:
/sys/devices/pci0000:00/0000:00:0d.0/0000:02:00.0/irq
[   76.180010] CPU 0
[   76.180010] Modules linked in: w83792d tuner tea5767 tda8290
tuner_xc2028 xc5000 tda9887 tuner_simple tuner_types mt20xx tea5761
tvaudio msp3400 bttv ir_
common v4l2_common videodev usbhid v4l1_compat hid v4l2_compat_ioctl32
videobuf_dma_sg videobuf_core btcx_risc sg pata_amd tveeprom
[   76.180010] Pid: 0, comm: swapper Not tainted
2.6.29-rc1-ingo-00008-g4fa1489 #1
[   76.180010] RIP: 0010:[<0000000000000000>]  [<(null)>] (null)
[   76.180010] RSP: 0018:ffffffff809a8938  EFLAGS: 00010092
[   76.180010] RAX: 0000000000000020 RBX: 0000000000000000 RCX: 00000000000003ff
[   76.180010] RDX: 0000000000000020 RSI: 0000000000000400 RDI: 0000000000000020
[   76.180010] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
[   76.180010] R10: ffffffff80a00320 R11: 0000000000000000 R12: 0000000000000000
[   76.180010] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[   76.180010] FS:  00007fa7b3ecf740(0000) GS:ffffffff809b1040(0000)
knlGS:0000000000000000
[   76.180010] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[   76.180010] CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
[   76.180010] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   76.180010] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   76.180010] Process swapper (pid: 0, threadinfo ffffffff8087e000,
task ffffffff807de360)
[   76.180010] Stack:
[   76.180010]  ffff88007e5c8da0 0000000000000000 0000000000000000
0000000400000000
[   76.180010]  0000000000000092 00000000803f158f ffffffff809a8a28
ffffffff803f184a
[   76.180010]  0000000000000000 ffffffff809a89a8 0000000000000000
00000000ffffffff
[   76.180010] Call Trace:
[   76.180010]  <IRQ> <0> [<ffffffff803f184a>] ? number+0x2aa/0x2d0
[   76.180010]  [<ffffffff8023a518>] ? enqueue_task_fair+0x188/0x2c0
[   76.180010]  [<ffffffff8065a258>] ? printk+0x67/0x6f
[   76.180010]  [<ffffffff804cc70f>] ? ata_scsi_qc_complete+0x1df/0x4c0
[   76.180010]  [<ffffffff8022a267>] ? is_prefetch+0xa7/0x280
[   76.180010]  [<ffffffff8024426e>] ? oops_enter+0xe/0x10
[   76.180010]  [<ffffffff8020fd3b>] ? oops_begin+0x8b/0xa0
[   76.180010]  [<ffffffff8022a7b9>] ? do_page_fault+0x379/0x980
[   76.180010]  [<ffffffff803f24d1>] ? vsnprintf+0x351/0xbb0
[   76.180010]  [<ffffffff8065cddd>] ? trace_hardirqs_off_thunk+0x3a/0x6c
[   76.180010]  [<ffffffff8065d54f>] ? page_fault+0x1f/0x30
[   76.180010]  [<ffffffff8023a51c>] ? enqueue_task_fair+0x18c/0x2c0
[   76.180010]  [<ffffffff8023a518>] ? enqueue_task_fair+0x188/0x2c0
[   76.180010]  [<ffffffff80234d90>] ? enqueue_task+0x50/0x60
[   76.180010]  [<ffffffff80234ea2>] ? activate_task+0x22/0x30
[   76.180010]  [<ffffffff80238ae2>] ? try_to_wake_up+0x232/0x2d0
[   76.180010]  [<ffffffff80238b8d>] ? default_wake_function+0xd/0x10
[   76.180010]  [<ffffffff8025a761>] ? autoremove_wake_function+0x11/0x40
[   76.180010]  [<ffffffff80261b59>] ? getnstimeofday+0x59/0xe0
[   76.180010]  [<ffffffff80235842>] ? __wake_up_common+0x52/0x80
[   76.180010]  [<ffffffff802367a3>] ? __wake_up+0x43/0x70
[   76.180010]  [<ffffffff80256c70>] ? delayed_work_timer_fn+0x0/0x40
[   76.180010]  [<ffffffff80256c4c>] ? __queue_work+0x6c/0x90
[   76.180010]  [<ffffffff80256cad>] ? delayed_work_timer_fn+0x3d/0x40
[   76.180010]  [<ffffffff80210f20>] ? update_vsyscall+0xd0/0xe0
[   76.180010]  [<ffffffff8026202f>] ? update_wall_time+0x3ff/0x520
[   76.180010]  [<ffffffff8021b230>] ? post_set+0x20/0x40
[   76.180010]  [<ffffffff8021b6de>] ? generic_set_mtrr+0x11e/0x140
[   76.180010]  [<ffffffff80219457>] ? ipi_handler+0x47/0xb0
[   76.180010]  [<ffffffff8026afa0>] ?
generic_smp_call_function_interrupt+0x50/0x100
[   76.180010]  [<ffffffff8021e54f>] ? smp_call_function_interrupt+0x1f/0x30
[   76.180010]  [<ffffffff8020c863>] ? call_function_interrupt+0x13/0x20
[   76.180010]  <EOI> <0>Code:  Bad RIP value.
[   76.180010] RIP  [<(null)>] (null)
[   76.180010]  RSP <ffffffff809a8938>
[   76.180010] CR2: 0000000000000000
[   76.180010] ---[ end trace 4da1e896c873962a ]---
[   76.180010] Kernel panic - not syncing: Fatal exception in interrupt
[   76.180010] ------------[ cut here ]------------
[   76.180010] WARNING: at kernel/smp.c:299 smp_call_function_many+0x1e9/0x250()
[   76.180010] Hardware name: KFN5-D SLI
[   76.180010] Modules linked in: w83792d tuner tea5767 tda8290
tuner_xc2028 xc5000 tda9887 tuner_simple tuner_types mt20xx tea5761
tvaudio msp3400 bttv ir_common v4l2_common videodev usbhid v4l1_compat
hid v4l2_compat_ioctl32 videobuf_dma_sg videobuf_core btcx_risc sg
pata_amd tveeprom
[   76.180010] Pid: 0, comm: swapper Tainted: G      D
2.6.29-rc1-ingo-00008-g4fa1489 #1
[   76.180010] Call Trace:
[   76.180010]  <IRQ>  [<ffffffff802440c0>] warn_slowpath+0xd0/0x130
[   76.180010]  [<ffffffff8065d1ef>] ? _spin_unlock_irqrestore+0x2f/0x40
[   76.180010]  [<ffffffff8024496d>] ? release_console_sem+0x1dd/0x230
[   76.180010]  [<ffffffff8026adc9>] smp_call_function_many+0x1e9/0x250
[   76.180010]  [<ffffffff80213570>] ? stop_this_cpu+0x0/0x30
[   76.180010]  [<ffffffff8024496d>] ? release_console_sem+0x1dd/0x230
[   76.180010]  [<ffffffff8026ae50>] smp_call_function+0x20/0x30
[   76.180010]  [<ffffffff8021e4c0>] native_smp_send_stop+0x30/0x70
[   76.180010]  [<ffffffff8065a134>] panic+0xa8/0x165
[   76.180010]  [<ffffffff8065d1ef>] ? _spin_unlock_irqrestore+0x2f/0x40
[   76.180010]  [<ffffffff8024496d>] ? release_console_sem+0x1dd/0x230
[   76.180010]  [<ffffffff80244c95>] ? console_unblank+0x75/0x90
[   76.180010]  [<ffffffff8020fca3>] oops_end+0x93/0xa0
[   76.180010]  [<ffffffff8022a864>] do_page_fault+0x424/0x980
[   76.180010]  [<ffffffff8065cddd>] ? trace_hardirqs_off_thunk+0x3a/0x6c
[   76.180010]  [<ffffffff803f184a>] ? number+0x2aa/0x2d0
[   76.180010]  [<ffffffff8023a518>] ? enqueue_task_fair+0x188/0x2c0
[   76.180010]  [<ffffffff8065a258>] ? printk+0x67/0x6f
[   76.180010]  [<ffffffff804cc70f>] ? ata_scsi_qc_complete+0x1df/0x4c0
[   76.180010]  [<ffffffff8022a267>] ? is_prefetch+0xa7/0x280
[   76.180010]  [<ffffffff8024426e>] ? oops_enter+0xe/0x10
[   76.180010]  [<ffffffff8020fd3b>] ? oops_begin+0x8b/0xa0
[   76.180010]  [<ffffffff8022a7b9>] ? do_page_fault+0x379/0x980
[   76.180010]  [<ffffffff803f24d1>] ? vsnprintf+0x351/0xbb0
[   76.180010]  [<ffffffff8065cddd>] ? trace_hardirqs_off_thunk+0x3a/0x6c
[   76.180010]  [<ffffffff8065d54f>] ? page_fault+0x1f/0x30
[   76.180010]  [<ffffffff8023a51c>] ? enqueue_task_fair+0x18c/0x2c0
[   76.180010]  [<ffffffff8023a518>] ? enqueue_task_fair+0x188/0x2c0
[   76.180010]  [<ffffffff80234d90>] ? enqueue_task+0x50/0x60
[   76.180010]  [<ffffffff80234ea2>] ? activate_task+0x22/0x30
[   76.180010]  [<ffffffff80238ae2>] ? try_to_wake_up+0x232/0x2d0
[   76.180010]  [<ffffffff80238b8d>] ? default_wake_function+0xd/0x10
[   76.180010]  [<ffffffff8025a761>] ? autoremove_wake_function+0x11/0x40
[   76.180010]  [<ffffffff80261b59>] ? getnstimeofday+0x59/0xe0
[   76.180010]  [<ffffffff80235842>] ? __wake_up_common+0x52/0x80
[   76.180010]  [<ffffffff802367a3>] ? __wake_up+0x43/0x70
[   76.180010]  [<ffffffff80256c70>] ? delayed_work_timer_fn+0x0/0x40
[   76.180010]  [<ffffffff80256c4c>] ? __queue_work+0x6c/0x90
[   76.180010]  [<ffffffff80256cad>] ? delayed_work_timer_fn+0x3d/0x40
[   76.180010]  [<ffffffff80210f20>] ? update_vsyscall+0xd0/0xe0
[   76.180010]  [<ffffffff8026202f>] ? update_wall_time+0x3ff/0x520
[   76.180010]  [<ffffffff8021b230>] ? post_set+0x20/0x40
[   76.180010]  [<ffffffff8021b6de>] ? generic_set_mtrr+0x11e/0x140
[   76.180010]  [<ffffffff80219457>] ? ipi_handler+0x47/0xb0
[   76.180010]  [<ffffffff8026afa0>] ?
generic_smp_call_function_interrupt+0x50/0x100
[   76.180010]  [<ffffffff8021e54f>] ? smp_call_function_interrupt+0x1f/0x30
[   76.180010]  [<ffffffff8020c863>] ? call_function_interrupt+0x13/0x20
[   76.180010]  <EOI> <4>---[ end trace 4da1e896c873962b ]---
[   86.211282] INFO: RCU detected CPU 1 stall (t=1000 jiffies)
[   86.211282] Pid: 3278, comm: X Tainted: G      D W
2.6.29-rc1-ingo-00008-g4fa1489 #1
[   86.211282] Call Trace:
[   86.211282]  <IRQ>  [<ffffffff80277cdb>] __rcu_pending+0x7b/0x2c0
[   86.211282]  [<ffffffff80277f4e>] rcu_pending+0x2e/0x70
[   86.211282]  [<ffffffff8024ebee>] update_process_times+0x3e/0x70
[   86.211282]  [<ffffffff8026610d>] tick_sched_timer+0x6d/0xc0
[   86.211282]  [<ffffffff8025d42f>] __run_hrtimer+0x5f/0x130
[   86.211282]  [<ffffffff8025dcf5>] hrtimer_interrupt+0xa5/0x120
[   86.211282]  [<ffffffff8021f7b3>] smp_apic_timer_interrupt+0x83/0xc0
[   86.211282]  [<ffffffff8020c6e3>] apic_timer_interrupt+0x13/0x20
[   86.211282]  <EOI>

This time not even the keyboard leds where blinking, the system was
completely dead.

HTH

Torsten
