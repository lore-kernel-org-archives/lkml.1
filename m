Return-Path: <linux-kernel-owner+w=401wt.eu-S1758086AbZAMTUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086AbZAMTUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 14:20:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752480AbZAMTUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 14:20:22 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:34973 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757299AbZAMTUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 14:20:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Vz8xUP3bqSQVNr1Z6Hwmi7P7hgFiut0ch6E9jBaMRgb9DLEQBVjIN6oA9AeiWYIu69
         SdunXIPgEMJf8AkSEvBq5NHov9S58ft2Tlix+wsKraKHZodxa4WiSUlpOoD6xhNZTrKC
         kQc3PMXZGD6qsddbRRmsSu4PNVfH61gs18ZIw=
Message-ID: <64bb37e0901131120i50bab2afq3e46e1d9a57c7f0@mail.gmail.com>
Date: Tue, 13 Jan 2009 20:20:15 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [git pull] x86 fixes
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20090112221352.GC12462@elte.hu>
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
	 <64bb37e0901121350l696b866k4216a36c36ff5785@mail.gmail.com>
	 <20090112221352.GC12462@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 11:13 PM, Ingo Molnar <mingo@elte.hu> wrote:
> * Torsten Kaiser <just.for.lkml@googlemail.com> wrote:
>> On Mon, Jan 12, 2009 at 9:40 PM, Ingo Molnar <mingo@elte.hu> wrote:
>> > * Torsten Kaiser <just.for.lkml@googlemail.com> wrote:
>> >> On Mon, Jan 12, 2009 at 8:29 PM, Pallipadi, Venkatesh
>> >> <venkatesh.pallipadi@intel.com> wrote:
>> >> > oops. I missed out one file in the earlier test patch. Below is the
>> >> > updated test patch that will go against 29-rc1.
>> >> >
>> >> > Thanks,
>> >> > Venki
>> >> >
>> >> > Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipad@intel.com>
>> >>
>> >> Tested-by: Torsten Kaiser <just.for.lkml@googlemail.com>
>> >>
>> >> The system boots normal and glxgears is accelerated again.
>> >
>> > Could you try the tree below as well please?
>>
>> Before I read this mail, I already tried the tree you send to Linus as a
>> pull request. That worked without a crash, but as expected the DRM
>> related error was still there.
>
> Do you mean today's x86-fixes pull request to Linus?

Yes, ...

> That would be the
> expected behavior: i separated out the PAT fixes from that tree to be able
> to progress with those other fixes - while the PAT angle is investigated.

... I did see that. I tested the DRM just to be sure that I a) got a
kernel without the fix, as I was expecting and b) that this does not
trigger any other unhappiness.

But as written yesterday: That tree did not crash and the DRM thing
was also in -rc1.

> Neither your crash log nor the review of the PAT patches revealed a
> smoking gun (to me at least), but your crash obviously happened, and it
> happened right after you pulled the x86-fixes tree.
>
>> pulled && build, here is the result:
>> [   76.170171] BUG: unable to handle kernel NULL pointer dereference at (null)
>> [   76.178376] IP: [<(null)>] (null)
>
> thanks, that's really helpful!
>
> Below is the delta from the minimal patch you tried earlier today, to the
> full clean patchset.
>
> By all likelyhood, if you apply Venki's patch (which you tested earlier
> today, and which did not crash and gave back 3D performance to you), and
> then apply the patch below, you'll get the same crash again.

That crash was just your tree without, also without the DRM fix from
Venki. In the crashing case its not important anyway, because the
system crashed during X startup, so I never even get a chance to run
any DRM program. ;-P

> So the bug is in the diff below. My first guess would be:
>
> -extern void __iomem *ioremap_wc(unsigned long offset, unsigned long size);
> +extern void __iomem *ioremap_wc(resource_size_t offset, unsigned long size);
>
> we extended 4G to 64-bits on 32-bit systems. If there's a width problem
> somewhere along the road we can mess the pagetables up real big.

I'm on x86_64, so it should be 64bit anyway. But I will not claim to
know the current sizes of resource_size_t or unsigned long. ;)

But I do have 4GB RAM and part of it is remapped beyound the 32bit limit.

> the other possibility would be this hunk:
>
> -       is_range_ram = pagerange_is_ram(start, end);
> -       if (is_range_ram == 1)
> -               return reserve_ram_pages_type(start, end, req_type, new_type);
> -       else if (is_range_ram < 0)
> -               return -EINVAL;
> +       /*
> +        * For legacy reasons, some parts of the physical address range in the
> +        * legacy 1MB region is treated as non-RAM (even when listed as RAM in
> +        * the e820 tables).  So we will track the memory attributes of this
> +        * legacy 1MB region using the linear memtype_list always.
> +        */
> +       if (end >= ISA_END_ADDRESS) {
> +               is_range_ram = pagerange_is_ram(start, end);
> +               if (is_range_ram == 1)
> +                       return reserve_ram_pages_type(start, end, req_type,
> +                                                     new_type);
> +               else if (is_range_ram < 0)
> +                       return -EINVAL;
> +       }
>
> That is this patch's effect:
>
>  4fa1489: x86, pat: fix reserve_memtype() for legacy 1MB range

reverted that patch und booted => still crashes, but in yet another strange way:
[   93.160112] int3: 0000 [#1] SMP
[   93.164076] last sysfs file:
/sys/devices/pci0000:00/0000:00:0f.0/0000:01:00.0/enable
[   93.170009] CPU 0
[   93.170009] Modules linked in: w83792d tuner tea5767 tda8290
tuner_xc2028 xc5000 tda9887 tuner_simple tuner_types mt20xx tea5761
tvaudio msp3400 bttv ir_common v4l2_common videodev v4l1_compat
v4l2_compat_ioctl32 videobuf_dma_sg videobuf_core usbhid btcx_risc hid
tveeprom pata_amd sg
[   93.170009] Pid: 0, comm: swapper Not tainted
2.6.29-rc1-ingo-00009-geae2f18 #2
[   93.170009] RIP: 0010:[<ffffffff8099ecc1>]  [<ffffffff8099ecc1>]
per_cpu__rcu_bh_data+0x1/0xc0
[   93.170009] RSP: 0018:ffffffff809a8ed8  EFLAGS: 00000286
[   93.170009] RAX: ffff88011ddf1930 RBX: ffffffff809a8ed0 RCX: ffffffff80a008c8
[   93.170009] RDX: 00000000000003fc RSI: ffff880028014c00 RDI: ffffffff807e9440
[   93.170009] RBP: 000000000000000a R08: ffff880028013180 R09: 0000000000000000
[   93.170009] R10: ffffffff8087fe58 R11: 0000000000000001 R12: ffffffff80261b39
[   93.170009] R13: 0000000000000100 R14: 000000000000000a R15: ffffffff8099ecc0
[   93.170009] FS:  00007f2d71cf56f0(0000) GS:ffffffff809b1040(0000)
knlGS:0000000000000000
[   93.170009] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[   93.170009] CR2: 00007f2d7185a920 CR3: 0000000000201000 CR4: 00000000000006e0
[   93.170009] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   93.170009] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   93.170009] Process swapper (pid: 0, threadinfo ffffffff8087e000,
task ffffffff807de360)
[   93.170009] Stack:
[   93.170009]  ffffffff809a8ef8 ffffffff80277c12 000000000000000a
0000000000000040
[   93.170009]  ffffffff809a8f38 ffffffff809a8f10 ffffffff8021b230
ffffffff809a8f50
[   93.170009]  ffffffff8021b6de 00000000000e0000 ffff88007c407af8
0000000000000086
[   93.170009] Call Trace:
[   93.170009]  <IRQ> <0> [<ffffffff80277c12>] ? rcu_process_callbacks+0x32/0x60
[   93.170009]  [<ffffffff8021b230>] ? post_set+0x20/0x40
[   93.170009]  [<ffffffff8021b6de>] ? generic_set_mtrr+0x11e/0x140
[   93.170009]  [<ffffffff80219457>] ? ipi_handler+0x47/0xb0
[   93.170009]  [<ffffffff8026af80>] ?
generic_smp_call_function_interrupt+0x50/0x100
[   93.170009]  [<ffffffff8021e54f>] ? smp_call_function_interrupt+0x1f/0x30
[   93.170009]  [<ffffffff8020c863>] ? call_function_interrupt+0x13/0x20
[   93.170009]  <EOI> <0>Code: cc cc cc cc cc cc cc cc cc cc cc cc cc
cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
cc cc cc cc cc cc cc <cc> cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
cc cc cc cc cc
[   93.170009] RIP  [<ffffffff8099ecc1>] per_cpu__rcu_bh_data+0x1/0xc0
[   93.170009]  RSP <ffffffff809a8ed8>
[   93.181327] ---[ end trace e7dd93fe22e9ffa7 ]---
[   93.181327] Kernel panic - not syncing: Fatal exception in interrupt
[   93.172531] BUG: unable to handle kernel NULL pointer dereference at (null)
[   93.172531] IP: [<ffffffff8026af53>]
generic_smp_call_function_interrupt+0x23/0x100
[   93.172531] PGD 11b918067 PUD 11b83e067 PMD 0
[   93.172531] Oops: 0000 [#2] SMP
[   93.172531] last sysfs file:
/sys/devices/pci0000:00/0000:00:0f.0/0000:01:00.0/enable
[   93.172531] CPU 2
[   93.172531] Modules linked in: w83792d tuner tea5767 tda8290
tuner_xc2028 xc5000 tda9887 tuner_simple tuner_types mt20xx tea5761
tvaudio msp3400 bttv ir_common v4l2_common videodev v4l1_compat
v4l2_compat_ioctl32 videobuf_dma_sg videobuf_core usbhid btcx_risc hid
tveeprom pata_amd sg
[   93.172531] Pid: 3283, comm: X Tainted: G      D
2.6.29-rc1-ingo-00009-geae2f18 #2
[   93.172531] RIP: 0010:[<ffffffff8026af53>]  [<ffffffff8026af53>]
generic_smp_call_function_interrupt+0x23/0x100
[   93.172531] RSP: 0018:ffff88011f127f80  EFLAGS: 00010046
[   93.172531] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff88007f13ab80
[   93.172531] RDX: ffffffff809a2d00 RSI: 0000000000000000 RDI: 0000000000000002
[   93.172531] RBP: ffff88011f127fa0 R08: 0000000000000000 R09: ffff88011e40f780
[   93.172531] R10: ffff88007c407e48 R11: 0000000000000000 R12: ffff88011ddf1ee0
[   93.172531] R13: 0000000000000000 R14: 0000000000000002 R15: ffff88011e59a780
[   93.172531] FS:  00007f3267f8e6f0(0000) GS:ffff88011f0de000(0000)
knlGS:0000000000000000
[   93.172531] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   93.172531] CR2: 0000000000000000 CR3: 000000011b9b7000 CR4: 00000000000006e0
[   93.172531] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   93.172531] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   93.172531] Process X (pid: 3283, threadinfo ffff88007c406000, task
ffff88007d145700)
[   93.172531] Stack:
[   93.172531]  ffff88011e59a780 ffff88007e09c3d8 0000000000000000
ffff88007e09c3d8
[   93.172531]  ffff88011f127fb0 ffffffff8021e54f ffff88007c407c80
ffffffff8020c863 <EOI>
[   93.172531]  841f0ffffffcebe9 ff02680000000000 02e850ec8348ffff
00011b8de8fffff1
[   93.172531] Call Trace:
[   93.172531]  <IRQ> <0> [<ffffffff8021e54f>]
smp_call_function_interrupt+0x1f/0x30
[   93.172531]  [<ffffffff8020c863>] call_function_interrupt+0x13/0x20
[   93.172531]  <EOI> <0>Code: e8 d3 0a 05 00 c9 c3 90 55 48 89 e5 41
56 65 44 8b 34 25 24 00 00 00 41 55 41 54 53 48 8b 1d 55 df 57 00 eb
06 0f 1f 00 48 8b 1b <48> 8b 03 48 81 fb a0 8e 7e 80 0f 18 08 0f 84 9a
00 00 00 4c 8d
[   93.172531] RIP  [<ffffffff8026af53>]
generic_smp_call_function_interrupt+0x23/0x100
[   93.172531]  RSP <ffff88011f127f80>
[   93.172531] CR2: 0000000000000000
[   93.172531] ---[ end trace e7dd93fe22e9ffa8 ]---
[   93.172531] Kernel panic - not syncing: Fatal exception in interrupt
[   93.172531] ------------[ cut here ]------------
[   93.172531] WARNING: at kernel/smp.c:299 smp_call_function_many+0x1e9/0x250()
[   93.172531] Hardware name: KFN5-D SLI
[   93.172531] Modules linked in: w83792d tuner tea5767 tda8290
tuner_xc2028 xc5000 tda9887 tuner_simple tuner_types mt20xx tea5761
tvaudio msp3400 bttv ir_common v4l2_common videodev v4l1_compat
v4l2_compat_ioctl32 videobuf_dma_sg videobuf_core usbhid btcx_risc hid
tveeprom pata_amd sg
[   93.172531] Pid: 3283, comm: X Tainted: G      D
2.6.29-rc1-ingo-00009-geae2f18 #2
[   93.172531] Call Trace:
[   93.172531]  <IRQ>  [<ffffffff802440a0>] warn_slowpath+0xd0/0x130
[   93.172531]  [<ffffffff8065d1cf>] ? _spin_unlock_irqrestore+0x2f/0x40
[   93.172531]  [<ffffffff8024494d>] ? release_console_sem+0x1dd/0x230
[   93.172531]  [<ffffffff8026ada9>] smp_call_function_many+0x1e9/0x250
[   93.172531]  [<ffffffff80213570>] ? stop_this_cpu+0x0/0x30
[   93.172531]  [<ffffffff8024494d>] ? release_console_sem+0x1dd/0x230
[   93.172531]  [<ffffffff8026ae30>] smp_call_function+0x20/0x30
[   93.172531]  [<ffffffff8021e4c0>] native_smp_send_stop+0x30/0x70
[   93.172531]  [<ffffffff8065a114>] panic+0xa8/0x165
[   93.172531]  [<ffffffff8065d1cf>] ? _spin_unlock_irqrestore+0x2f/0x40
[   93.172531]  [<ffffffff8024494d>] ? release_console_sem+0x1dd/0x230
[   93.172531]  [<ffffffff80244c75>] ? console_unblank+0x75/0x90
[   93.172531]  [<ffffffff8020fca3>] oops_end+0x93/0xa0
[   93.172531]  [<ffffffff8022a864>] do_page_fault+0x424/0x980
[   93.172531]  [<ffffffff80261b39>] ? getnstimeofday+0x59/0xe0
[   93.172531]  [<ffffffff8065cdbd>] ? trace_hardirqs_off_thunk+0x3a/0x6c
[   93.172531]  [<ffffffff8065d52f>] page_fault+0x1f/0x30
[   93.172531]  [<ffffffff8026af53>] ?
generic_smp_call_function_interrupt+0x23/0x100
[   93.172531]  [<ffffffff8021e54f>] smp_call_function_interrupt+0x1f/0x30
[   93.172531]  [<ffffffff8020c863>] call_function_interrupt+0x13/0x20
[   93.172531]  <EOI> <4>---[ end trace e7dd93fe22e9ffa9 ]---
[   93.172531] ------------[ cut here ]------------
[   93.172531] WARNING: at kernel/smp.c:220
smp_call_function_single+0xa7/0x110()
[   93.172531] Hardware name: KFN5-D SLI
[   93.172531] Modules linked in: w83792d tuner tea5767 tda8290
tuner_xc2028 xc5000 tda9887 tuner_simple tuner_types mt20xx tea5761
tvaudio msp3400 bttv ir_common v4l2_common videodev v4l1_compat
v4l2_compat_ioctl32 videobuf_dma_sg videobuf_core usbhid btcx_risc hid
tveeprom pata_amd sg
[   93.172531] Pid: 3283, comm: X Tainted: G      D W
2.6.29-rc1-ingo-00009-geae2f18 #2
[   93.172531] Call Trace:
[   93.172531]  <IRQ>  [<ffffffff802440a0>] warn_slowpath+0xd0/0x130
[   93.172531]  [<ffffffff8065a063>] ? dump_stack+0x72/0x7b
[   93.172531]  [<ffffffff8026ba97>] ? print_modules+0x57/0xb0
[   93.172531]  [<ffffffff802440ba>] ? warn_slowpath+0xea/0x130
[   93.172531]  [<ffffffff8065d1cf>] ? _spin_unlock_irqrestore+0x2f/0x40
[   93.172531]  [<ffffffff8024494d>] ? release_console_sem+0x1dd/0x230
[   93.172531]  [<ffffffff8026ab57>] smp_call_function_single+0xa7/0x110
[   93.172531]  [<ffffffff8026ad7a>] smp_call_function_many+0x1ba/0x250
[   93.172531]  [<ffffffff80213570>] ? stop_this_cpu+0x0/0x30
[   93.172531]  [<ffffffff8024494d>] ? release_console_sem+0x1dd/0x230
[   93.172531]  [<ffffffff8026ae30>] smp_call_function+0x20/0x30
[   93.172531]  [<ffffffff8021e4c0>] native_smp_send_stop+0x30/0x70
[   93.172531]  [<ffffffff8065a114>] panic+0xa8/0x165
[   93.172531]  [<ffffffff8065d1cf>] ? _spin_unlock_irqrestore+0x2f/0x40
[   93.172531]  [<ffffffff8024494d>] ? release_console_sem+0x1dd/0x230
[   93.172531]  [<ffffffff80244c75>] ? console_unblank+0x75/0x90
[   93.172531]  [<ffffffff8020fca3>] oops_end+0x93/0xa0
[   93.172531]  [<ffffffff8022a864>] do_page_fault+0x424/0x980
[   93.172531]  [<ffffffff80261b39>] ? getnstimeofday+0x59/0xe0
[   93.172531]  [<ffffffff8065cdbd>] ? trace_hardirqs_off_thunk+0x3a/0x6c
[   93.172531]  [<ffffffff8065d52f>] page_fault+0x1f/0x30
[   93.172531]  [<ffffffff8026af53>] ?
generic_smp_call_function_interrupt+0x23/0x100
[   93.172531]  [<ffffffff8021e54f>] smp_call_function_interrupt+0x1f/0x30
[   93.172531]  [<ffffffff8020c863>] call_function_interrupt+0x13/0x20
[   93.172531]  <EOI> <4>---[ end trace e7dd93fe22e9ffaa ]---

Similar additional warning where also on the very first crash that
just like this one also left the keyboard leds blinking.
I did not post them for the first crash, because I suspected that
these WARNINGs where just triggered because the first Oops messed
something up.

> if you have more testing capacity, could you please try tip/master again:

I will see, if I find time to test tip/master later...

>  http://people.redhat.com/mingo/tip.git/README
>
> by all likelyhood it will crash for you (it has the PAT fixes included).
> Then type this:
>
>  git revert 4fa1489
>
> Does that solve the crash and give you good 3D performance again?

Reverting 4fa1489 did not help.
Output from git log from the tree I tested:
eae2f1895569e51a97f359759826519f7e0f2a61 Revert "x86, pat: fix
reserve_memtype() for legacy 1MB range"
4fa1489d2a74c1e3c6231f449d73ce46131523ae x86, pat: fix
reserve_memtype() for legacy 1MB range
895252ccb3050383e1dcf2c2536065e346c2fa14 x86 PAT: remove CPA WARN_ON
for zero pte
838b120c59b530ba58cc0197d208d08455733472 x86 PAT: ioremap_wc should
take resource_size_t parameter
283c81fe6568202db345649e874d2a0f29dc5a84 x86 PAT: return compatible
mapping to remap_pfn_range callers
dfed11010f7b2d994444bcd83ec4cc7e80d7d030 x86 PAT: change
track_pfn_vma_new to take pgprot_t pointer param
a8eae3321ea94fe06c6a76b48cc6a082116b1784 x86 PAT: consolidate old
memtype new memtype check into a function
18d82ebde7e40bf67c84b505a12be26133a89932 x86 PAT: remove PFNMAP type
on track_pfn_vma_new() error
ae04d1401577bb63151480a053057de58b8e10bb powerpc: Fix cpufreq drivers
after cpufreq core changes
c59765042f53a79a7a65585042ff463b69cb248c Linux 2.6.29-rc1

I could not test the 3D performance, as X kept killing the system on startup. ;)
But as already written: Just the fix from Venkatesh alone did fix 3D
for me and did not result in any crashes.

Torsten
