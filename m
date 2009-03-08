Return-Path: <linux-kernel-owner+w=401wt.eu-S1751857AbZCHKyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbZCHKyf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 06:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbZCHKy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 06:54:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59346 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093AbZCHKyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 06:54:24 -0400
Date: Sun, 8 Mar 2009 11:54:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Daniel Yeisley <dan.yeisley@unisys.com>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, stable@kernel.org, tglx@linutronix.de,
       linux-pci@vger.kernel.org
Subject: Re: [tip:x86/apic] x86: MSI: check for BIOS assigned addresses
Message-ID: <20090308105410.GA15010@elte.hu>
References: <1236352309.31604.2.camel@localhost.localdomain> <tip-affd49d36e2e2df4cbb3e07a57db901c23823b6a@git.kernel.org> <20090306184514.GC15526@elte.hu> <1236364109.31604.10.camel@localhost.localdomain> <20090306191345.GD28582@elte.hu> <49B1C884.2020301@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B1C884.2020301@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> Ingo Molnar wrote:
> > * Daniel Yeisley <dan.yeisley@unisys.com> wrote:
> > 
> >> On Fri, 2009-03-06 at 19:45 +0100, Ingo Molnar wrote:
> >>> * Daniel Yeisley <dan.yeisley@unisys.com> wrote:
> >>>
> >>>> Commit-ID:  affd49d36e2e2df4cbb3e07a57db901c23823b6a
> >>>> Gitweb:     http://git.kernel.org/tip/affd49d36e2e2df4cbb3e07a57db901c23823b6a
> >>>> Author:     "Daniel Yeisley" <dan.yeisley@unisys.com>
> >>>> AuthorDate: Fri, 6 Mar 2009 10:11:49 -0500
> >>>> Commit:     Ingo Molnar <mingo@elte.hu>
> >>>> CommitDate: Fri, 6 Mar 2009 19:32:44 +0100
> >>>>
> >>>> x86: MSI: check for BIOS assigned addresses
> >>>>
> >>>> Impact: fix ACPI hotplug on certain systems
> >>> Note, this commit means that i moved the commit over from 
> >>> tip:x86/urgent into tip:x86/apic - i.e. with a 2.6.30 merge 
> >>> date. When exactly was this regression introduced? I think this 
> >>> code never really accepted the MSI settings from the firmware, 
> >>> so changing that behavior might affect a lot of systems.
> >>>
> >>> So i'm uneasy about applying this fix this late in the .29 
> >>> cycle, but marked it for -stable backport so it could hit 
> >>> 2.6.29.1 if it stays problem-free.
> >>>
> >>> 	Ingo
> >> I initially noticed the problem on a 2.6.18 kernel.  ACPI 
> >> hotplugging didn't work unless I booted with pci=nomsi.  I 
> >> don't have a problem with waiting until 2.6.30 to make sure it 
> >> is thoroughly tested.
> > 
> > Okay - so it's an ancient bug. The current track should thus be 
> > fine.
> > 
> 
> please drop this patch. it seems it break msi-x.
> at least igbe with msi-x does not work anymore.

Not just that, it also causes bootup crashes - attached below. 
I'v dropped the patch for now.

	Ingo

[    4.276015] calling  pcie_portdrv_init+0x0/0x4c @ 1
[    4.280343] bus: 'pci_express': registered
[    4.284017] bus: 'pci': add driver pcieport-driver
[    4.288046] bus: 'pci': driver_probe_device: matched device 0000:00:0b.0 with driver pcieport-driver
[    4.292014] bus: 'pci': really_probe: probing driver pcieport-driver with device 0000:00:0b.0
[    4.296148] pcieport-driver 0000:00:0b.0: setting latency timer to 64
[    4.304157]   alloc irq_desc for 16 on cpu 0 node 0
[    4.308008]   alloc kstat_irqs on cpu 0 node 0
[    4.308124] ------------[ cut here ]------------
[    4.312008] kernel BUG at arch/x86/kernel/apic/io_apic.c:1362!
[    4.312008] invalid opcode: 0000 [#1] SMP 
[    4.312008] last sysfs file: 
[    4.312008] CPU 0 
[    4.312008] Modules linked in:
[    4.312008] Pid: 7, comm: work_on_cpu/0 Not tainted 2.6.29-rc7-tip-02101-g8d7adfc-dirty #31737 SMP Sun Mar 8 11:50:18 CET 2009 System Product Name
[    4.312008] RIP: 0010:[<ffffffff80221e36>]  [<ffffffff80221e36>] __clear_irq_vector+0x1d/0xd8
[    4.312008] RSP: 0018:ffff88003f121bf0  EFLAGS: 00010046
[    4.312008] RAX: 0000000000000246 RBX: ffff88003ea0b1a0 RCX: 0000000000000002
[    4.312008] RDX: 8c6318c6318c6300 RSI: ffff88003ea0b1a0 RDI: 0000000000000010
[    4.312008] RBP: ffff88003f121c10 R08: ffff88003f118998 R09: 0000000000000070
[    4.312008] R10: 0000000000000000 R11: ffffffff80222c03 R12: 0000000000000010
[    4.312008] R13: 0000000000000010 R14: ffff88003f2a31b0 R15: 0000000000000001
[    4.312008] FS:  0000000000000000(0000) GS:ffff8800035b0000(0000) knlGS:0000000000000000
[    4.312008] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[    4.312008] CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
[    4.312008] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    4.312008] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    4.312008] Process work_on_cpu/0 (pid: 7, threadinfo ffff88003f120000, task ffff88003f118000)
[    4.312008] Stack:
[    4.312008]  0000000000000246 0000000000000010 ffff88003ea0b1a0 ffff88003f2a31b0
[    4.312008]  ffff88003f121c40 ffffffff80222c11 ffff88003f121c50 ffff88003ea060a8
[    4.312008]  ffff88003f2a38b0 ffff88003f2a38b0 ffff88003f121c50 ffffffff80222c36
[    4.312008] Call Trace:
[    4.312008]  [<ffffffff80222c11>] destroy_irq+0x4f/0x66
[    4.312008]  [<ffffffff80222c36>] arch_teardown_msi_irq+0xe/0x10
[    4.312008]  [<ffffffff80471099>] arch_teardown_msi_irqs+0x2c/0xa3
[    4.312008]  [<ffffffff80471188>] msi_free_irqs+0x5d/0xff
[    4.312008]  [<ffffffff80471a8f>] msi_capability_init+0x134/0x16d
[    4.312008]  [<ffffffff8047202e>] pci_enable_msi+0x7c/0x82
[    4.312008]  [<ffffffff804707ff>] assign_interrupt_mode+0xda/0x10b
[    4.312008]  [<ffffffff80470a0d>] pcie_port_device_register+0xb3/0x123
[    4.312008]  [<ffffffff80260f9c>] ? do_work_for_cpu+0x0/0x20
[    4.312008]  [<ffffffff807e10af>] pcie_portdrv_probe+0x8c/0xb4
[    4.312008]  [<ffffffff8046baee>] local_pci_probe+0x17/0x1b
[    4.312008]  [<ffffffff80260fb4>] do_work_for_cpu+0x18/0x20
[    4.312008]  [<ffffffff80261492>] run_workqueue+0x10c/0x221
[    4.312008]  [<ffffffff80261440>] ? run_workqueue+0xba/0x221
[    4.312008]  [<ffffffff802611b5>] ? test_ti_thread_flag+0x9/0x11
[    4.312008]  [<ffffffff80262282>] worker_thread+0xd6/0xe7
[    4.312008]  [<ffffffff802658b8>] ? autoremove_wake_function+0x0/0x3d
[    4.312008]  [<ffffffff802621ac>] ? worker_thread+0x0/0xe7
[    4.312008]  [<ffffffff802656d3>] kthread+0x4e/0x7b
[    4.312008]  [<ffffffff80c54140>] ? early_idt_handler+0x0/0x73
[    4.312008]  [<ffffffff8020d1ca>] child_rip+0xa/0x20
[    4.312008]  [<ffffffff8020cb90>] ? restore_args+0x0/0x30
[    4.312008]  [<ffffffff80265685>] ? kthread+0x0/0x7b
[    4.312008]  [<ffffffff8020d1c0>] ? child_rip+0x0/0x20
[    4.312008] Code: ff 8b 35 2e 78 a1 00 e8 cd ff ff ff c9 c3 55 48 89 e5 41 56 41 55 41 54 53 e8 97 9f fe ff 8a 56 1c 41 89 fd 48 89 f3 84 d2 75 04 <0f> 0b eb fe 0f b6 d2 4c 8b 35 d4 b1 5f 00 48 c7 c0 20 b0 00 00 
[    4.312008] RIP  [<ffffffff80221e36>] __clear_irq_vector+0x1d/0xd8
[    4.312008]  RSP <ffff88003f121bf0>
