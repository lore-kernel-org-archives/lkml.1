Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbYIYUqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbYIYUqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 16:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753946AbYIYUqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 16:46:34 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:64312 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905AbYIYUqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 16:46:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DGw6xD59hzox4q0qkkYixXYx+vq/Qcw925XjTByKKh6v5ba4sDrhwafu1oOS5LEkCq
         9uN5wSucuPN5M7JF/Tv/Vu3vtVVaQsLW5myWdwWXSzLpmozkDTBBk+r+jvjk4LH38S4v
         kwUYFWgLjkrqJwnSUiaLQJl337WuyDpyuShIc=
Message-ID: <19f34abd0809251346r62cff1ck4730260f17e643b3@mail.gmail.com>
Date: Thu, 25 Sep 2008 22:46:32 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: v2.6.27-rc7: x86: #GP on panic?
Cc: "Ingo Molnar" <mingo@elte.hu>, x86@kernel.org,
       linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <19f34abd0809250820q2df15e93u43374b7317e2f7be@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0809241209l3a69d607v153549ee43e085e9@mail.gmail.com>
	 <20080925080417.GB27048@elte.hu> <48DB5186.8060502@zytor.com>
	 <19f34abd0809250707i18ded94aib177c884d4d6a3bd@mail.gmail.com>
	 <19f34abd0809250820q2df15e93u43374b7317e2f7be@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 5:20 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> No, I was wrong! It *does* happen for vanilla as well, but it doesn't
> happen reliably.
>
> [    4.043370] Kernel panic - not syncing: VFS: Unable to mount root
> fs on unknown-block(2,0)
> [    4.048765] general protection fault: fff2 [1] SMP
> [    4.048765] CPU 0
> [    4.048765] Modules linked in:
> [    4.048765] Pid: 1, comm: swapper Tainted: G        W 2.6.27-rc7 #8
> [    4.048765] RIP: 0010:[<ffffffff81019d27>]  [<ffffffff81019d27>]
> native_smp_send_stop+0x29/0x2d
> [    4.048765] RSP: 0018:ffff880007867d70  EFLAGS: 00000286
> [    4.048765] RAX: 00000000000000ff RBX: 0000000000000286 RCX: 0000000000000000
> [    4.048765] RDX: 0000000000000005 RSI: ffffffff81019ce1 RDI: 0000000000000000
> [    4.048765] RBP: ffff880007867d80 R08: 0000000000000000 R09: ffff880087867bff
> [    4.048765] R10: ffff880087867bff R11: 000000000000000a R12: ffff88000707b018
> [    4.048765] R13: ffff88000707b000 R14: 0000000000008001 R15: ffffffff8159d550
> [    4.048765] FS:  0000000000000000(0000) GS:ffffffff816fae00(0000)
> knlGS:0000000000000000
> [    4.048765] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> [    4.048765] CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006a0
> [    4.048765] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [    4.048765] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
> [    4.048765] Process swapper (pid: 1, threadinfo ffff880007866000,
> task ffff880007868000)
> [    4.048765] Stack:  000000000000506f ffffffff8159d52d
> ffff880007867e70 ffffffff81034454
> [    4.048765]  0000003000000010 ffff880007867e80 ffff880007867db0
> ffff880007867e80
> [    4.048765]  ffff880007867dd0 ffff880007867e80 ffff880007899360
> 000000000000500e
> [    4.048765] Call Trace:
> [    4.048765]  [<ffffffff81034454>] panic+0xe8/0x193
> [    4.048765]  [<ffffffff8118ef5f>] ? kobject_put+0x44/0x49
> [    4.048765]  [<ffffffff8121778e>] ? put_device+0x15/0x17
> [    4.048765]  [<ffffffff8121ad49>] ? class_for_each_device+0xfe/0x10e
> [    4.048765]  [<ffffffff81715059>] mount_block_root+0x1ee/0x205
> [    4.048765]  [<ffffffff81009417>] ? name_to_dev_t+0x1bb/0xda4
> [    4.048765]  [<ffffffff817152cd>] mount_root+0xe5/0xea
> [    4.048765]  [<ffffffff81715449>] prepare_namespace+0x177/0x1a4
> [    4.048765]  [<ffffffff810aaede>] ? putname+0x37/0x39
> [    4.048765]  [<ffffffff81714d0f>] kernel_init+0x16a/0x178
> [    4.048765]  [<ffffffff8102bde3>] ? schedule_tail+0x24/0x5d
> [    4.048765]  [<ffffffff8100cf79>] child_rip+0xa/0x11
> [    4.048765]  [<ffffffff811b92a4>] ? acpi_ds_init_one_object+0x0/0x88
> [    4.048765]  [<ffffffff81714ba5>] ? kernel_init+0x0/0x178
> [    4.048765]  [<ffffffff8100cf6f>] ? child_rip+0x0/0x11
> [    4.048765]
> [    4.048765]
> [    4.048765] Code: eb fd 55 48 89 e5 53 51 83 3d 25 e8 78 00 00 75
> 1a 31 d2 31 f6 48 c7 c7 e1 9c 01 81 e8 a7 a4 03 00 9c 5b fa e8 94 09
> 00 00 53 9d <5a> 5b c9 c3 55 31 c0 48 89 e5 89 04 25 b0 c0 5f ff 65 83
> 04 25
> [    4.048765] RIP  [<ffffffff81019d27>] native_smp_send_stop+0x29/0x2d
> [    4.048765]  RSP <ffff880007867d70>
> [    4.048765] ---[ end trace 4eaa2a86a8e2da22 ]---
>
> This was after 49 successful boots (qemu running the same clean kernel
> in a loop over and over).
>
> Could be a qemu thing, though.

Keeping it going also found this bootup failure:

[    0.321423] Freeing SMP alternatives: 39k freed
[    0.323950] ACPI: Core revision 20080609
[    0.360390] divide error: 0000 [1] SMP
[    0.360944] CPU 0
[    0.360944] Modules linked in:
[    0.360944] Pid: 1, comm: swapper Tainted: G        W 2.6.27-rc7 #9
[    0.360944] RIP: 0010:[<ffffffff81039193>]  [<ffffffff81039193>]
__do_softirq+0x49/0xc5
[    0.360944] RSP: 0018:ffffffff81792f00  EFLAGS: 00000206
[    0.360944] RAX: ffff880007867fd8 RBX: 0000000000000042 RCX: ffff880007867d90
[    0.360944] RDX: ffff880007867d90 RSI: 0000000000000086 RDI: ffffffff817ac208
[    0.360944] RBP: ffffffff81792f20 R08: ffff88000100d0b0 R09: ffff88000100d040
[    0.360944] R10: ffff88000100d040 R11: ffffffff81646b40 R12: ffffffff816ec080
[    0.360944] R13: 000000000000000a R14: 0000000000000000 R15: 0000000000000000
[    0.360944] FS:  0000000000000000(0000) GS:ffffffff816fae00(0000)
knlGS:0000000000000000
[    0.360944] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[    0.360944] CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006a0
[    0.360944] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    0.360944] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
[    0.360944] Process swapper (pid: 1, threadinfo ffff880007866000,
task ffff880007868000)
[    0.360944] Stack:  0000000000000046 0000000000000000
ffffffff817893e0 0000000000000030
[    0.360944]  ffffffff81792f38 ffffffff8100d24c ffffffff81792f38
ffffffff81792f58
[    0.360944]  ffffffff8100eb81 ffff880007867ce8 0000000000000000
ffffffff81792f68
[    0.360944] Call Trace:
[    0.360944]  <IRQ>  [<ffffffff8100d24c>] call_softirq+0x1c/0x28
[    0.360944]  [<ffffffff8100eb81>] do_softirq+0x32/0x89
[    0.360944]  [<ffffffff810392ad>] irq_exit+0x3f/0x82
[    0.360944]  [<ffffffff8100e9b3>] do_IRQ+0x147/0x166
[    0.360944]  [<ffffffff8100c5a1>] ret_from_intr+0x0/0xb
[    0.360944]  <EOI>  [<ffffffff8107013f>] ? noop+0x0/0x6
[    0.360944]  [<ffffffff8107121b>] ? default_disable+0x0/0x6
[    0.360944]  [<ffffffff8145ba2c>] ? _spin_unlock_irqrestore+0x8/0xa
[    0.360944]  [<ffffffff8107101f>] ? set_irq_chip+0x79/0x84
[    0.360944]  [<ffffffff810715fa>] ? handle_edge_irq+0x0/0x12f
[    0.360944]  [<ffffffff810717d2>] ? set_irq_chip_and_handler_name+0x19/0x33
[    0.360944]  [<ffffffff8101b8e4>] ? setup_IO_APIC_irq+0x18b/0x1bb
[    0.360944]  [<ffffffff8101ad4b>] ? ioapic_read_entry+0x71/0x84
[    0.360944]  [<ffffffff817237bd>] ? setup_IO_APIC+0x158/0x66b
[    0.360944]  [<ffffffff8101b05b>] ? clear_IO_APIC+0x31/0x41
[    0.360944]  [<ffffffff817235d3>] ? enable_IO_APIC+0x165/0x170
[    0.360944]  [<ffffffff81721171>] ? native_smp_prepare_cpus+0x25a/0x2bb
[    0.360944]  [<ffffffff81714bfe>] ? kernel_init+0x59/0x178
[    0.360944]  [<ffffffff8102bde3>] ? schedule_tail+0x24/0x5d
[    0.360944]  [<ffffffff8100cf79>] ? child_rip+0xa/0x11
[    0.360944]  [<ffffffff811b92a4>] ? acpi_ds_init_one_object+0x0/0x88
[    0.360944]  [<ffffffff81714ba5>] ? kernel_init+0x0/0x178
[    0.360944]  [<ffffffff8100cf6f>] ? child_rip+0x0/0x11
[    0.360944]
[    0.360944]
[    0.360944] Code: 34 00 00 00 81 80 48 e0 ff ff 00 01 00 00 65 44
8b 34 25 24 00 00 00 65 c7 04 25 34 00 00 00 00 00 00 00 fb 49 c7 c4
80 c0 6e 81
[    0.360944] RIP  [<ffffffff81039193>] __do_softirq+0x49/0xc5
[    0.360944]  RSP <ffffffff81792f00>

But I don't see how the divide error could occur here:

ffffffff8103918b:       fb                      sti
ffffffff8103918c:       49 c7 c4 80 c0 6e 81    mov    $0xffffffff816ec080,%r12
ffffffff81039193:       f6 c3 01                test   $0x1,%bl
ffffffff81039196:       74 27                   je     ffffffff810391bf <__do_so
ffffffff81039198:       4c 89 e7                mov    %r12,%rdi
ffffffff8103919b:       41 ff 14 24             callq  *(%r12)

Seems like an external interrupt happened and was delivered after the sti?

Hm. I guess it smells like a qemu bug since it's rather easily
reproducible here and sounds strange that nobody else saw it. Is qemu
0.9.1.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
