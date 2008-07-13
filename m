Return-Path: <linux-kernel-owner+w=401wt.eu-S1753892AbYGMJ0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbYGMJ0g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 05:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbYGMJ03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 05:26:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54413 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631AbYGMJ01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 05:26:27 -0400
Date: Sun, 13 Jul 2008 11:26:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Mike Travis <travis@sgi.com>
Subject: Re: per-cpu related?
Message-ID: <20080713092613.GB12749@elte.hu>
References: <86802c440807130116u3b850485jec220bc15892873e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807130116u3b850485jec220bc15892873e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> calling  pcie_portdrv_init+0x0/0x77
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
> IP: [<ffffffff802557de>] hrtick_start_fair+0x8e/0x178
> PGD 0
> Oops: 0000 [1] SMP
> CPU 4
> Modules linked in:
> Pid: 103, comm: events/4 Not tainted 2.6.26-rc9-tip-01834-g99e624f-dirty #354
> RIP: 0010:[<ffffffff802557de>]  [<ffffffff802557de>]
> hrtick_start_fair+0x8e/0x178
> RSP: 0018:ffff88082486dbd0  EFLAGS: 00010046
> RAX: 0000000000000000 RBX: ffff880824870000 RCX: 0000000000000006
> RDX: ffff88084423e700 RSI: ffff880824870000 RDI: ffff88084423e700
> RBP: ffff88082486dc00 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff88084423e700
> R13: ffff880844239700 R14: ffff880824870000 R15: 0000000000000c18
> FS:  0000000000000000(0000) GS:ffff881024c3a600(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process events/4 (pid: 103, threadinfo ffff88082486c000, task ffff880824864230)
> Stack:  ffff880844248118 0000000060ce4c84 ffff880844239700 ffff880824955878
>  ffff88084423e700 0000000000000000 ffff88082486dc40 ffffffff80258339
>  ffff88082486dc30 ffffffff805196dd 0000000060ce4c84 ffff880824955840
> Call Trace:
>  [<ffffffff80258339>] dequeue_task_fair+0x64/0x83
>  [<ffffffff805196dd>] ? __first_cpu+0x26/0x49
>  [<ffffffff80254387>] dequeue_task+0xd3/0xf5
>  [<ffffffff80254434>] deactivate_task+0x36/0x55
>  [<ffffffff802547b0>] pull_task+0x31/0x7d
>  [<ffffffff8025691b>] load_balance_fair+0x192/0x27c
>  [<ffffffff80a4daf3>] schedule+0x3e0/0x96d
>  [<ffffffff802c3303>] ? vmstat_update+0x0/0x5e
>  [<ffffffff8027a965>] ? schedule_delayed_work+0x31/0x48
>  [<ffffffff80279b8a>] worker_thread+0xbb/0x114
>  [<ffffffff8027e788>] ? autoremove_wake_function+0x0/0x63
>  [<ffffffff80279acf>] ? worker_thread+0x0/0x114
>  [<ffffffff8027e2e3>] kthread+0x61/0xa4
>  [<ffffffff802634ee>] ? schedule_tail+0x3b/0x8a
>  [<ffffffff8022b589>] child_rip+0xa/0x11
>  [<ffffffff8027e282>] ? kthread+0x0/0xa4

i've triggered a similar crash yesterday - see it below.

	Ingo

[    9.230000] initcall ahci_init+0x0/0x47 returned 0 after 0 msecs
[    9.240000] calling  piix_init+0x0/0x55
[    9.240000] ata_piix 0000:00:1f.1: version 2.12
[    9.240000] IOAPIC[0]: Set routing entry (2-18 -> 0x59 -> IRQ 18 Mode:1 Active:1)
[    9.250000] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
[    9.260000] PCI: Setting latency timer of device 0000:00:1f.1 to 64
[    9.270000] BUG: unable to handle kernel paging request at ffff88080101c1f8
[    9.270000] IP: [<ffffffff80230576>] dequeue_task+0x73/0xf0
[    9.270000] PGD 202063 PUD 0 
[    9.270000] Thread overran stack, or stack corrupted
[    9.270000] Oops: 0000 [1] SMP 
[    9.270000] CPU 0 
[    9.270000] Modules linked in:
[    9.270000] Pid: 1, comm: swapper Tainted: G   M      2.6.26-rc9-01344-gfa93e3e-dirty #13956
[    9.270000] RIP: 0010:[<ffffffff80230576>]  [<ffffffff80230576>] dequeue_task+0x73/0xf0
[    9.270000] RSP: 0018:ffff88003f9b7420  EFLAGS: 00010046
[    9.270000] RAX: ffff88000101c200 RBX: ffff88003f9b4000 RCX: ffffffff80db5d40
[    9.270000] RDX: 00000000ffffffff RSI: ffff88003f9b6000 RDI: ffff880001026d40
[    9.270000] RBP: ffff88003f9b7440 R08: 0000000000000000 R09: 0000000000000001
[    9.270000] R10: 00000000ffff8e6e R11: 0000000000000000 R12: 0000000000000000
[    9.270000] R13: ffff880001026d40 R14: 0000000000000002 R15: ffff88003f9b76c0
[    9.270000] FS:  0000000000000000(0000) GS:ffffffff80c56640(0000) knlGS:0000000000000000
[    9.270000] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[    9.270000] CR2: ffff88080101c1f8 CR3: 0000000000201000 CR4: 00000000000006e0
[    9.270000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    9.270000] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    9.270000] Process swapper (pid: 1, threadinfo ffff88003f9b6000, task ffff88003f9b4000)
[    9.270000] Stack:  0000000076a041aa 0000000000000046 0000000076a041aa ffff880001026d40
[    9.270000]  ffff88003f9b7470 ffffffff80230674 0000000000000000 ffffffff8088c020
[    9.270000]  0000000076a041aa 7fffffffffffffff ffff88003f9b7570 ffffffff80889898
[    9.270000] Call Trace:
[    9.270000]  [<ffffffff80230674>] deactivate_task+0x31/0x50
[    9.270000]  [<ffffffff8088c020>] ? _spin_lock+0xd/0x4c
[    9.270000]  [<ffffffff80889898>] schedule+0x20a/0x6af
[    9.270000]  [<ffffffff80233d68>] ? __enqueue_entity+0x9d/0xb3
[    9.270000]  [<ffffffff80233f43>] ? enqueue_entity+0x1c5/0x1e6
[    9.270000]  [<ffffffff8088a2bf>] schedule_timeout+0x36/0xf7
[    9.270000]  [<ffffffff8088a02e>] wait_for_common+0xee/0x17a
[    9.270000]  [<ffffffff802398fe>] ? default_wake_function+0x0/0x36
[    9.270000]  [<ffffffff8088a1f3>] wait_for_completion+0x2b/0x41
[    9.270000]  [<ffffffff80259c92>] kthread_create+0xc7/0x14d
[    9.270000]  [<ffffffff805f5798>] ? scsi_error_handler+0x0/0x552
[    9.270000]  [<ffffffff80425490>] ? snprintf+0x70/0x89
[    9.270000]  [<ffffffff80420998>] ? kref_init+0xd/0x3b
[    9.270000]  [<ffffffff8041f676>] ? kobject_init+0x5b/0xb1
[    9.270000]  [<ffffffff80856245>] ? klist_init+0xd/0x4c
[    9.270000]  [<ffffffff804a760d>] ? device_initialize+0x57/0xf5
[    9.270000]  [<ffffffff8025c791>] ? __mutex_init+0xd/0x4b
[    9.270000]  [<ffffffff805f20c7>] scsi_host_alloc+0x2e6/0x343
[    9.270000]  [<ffffffff80666dcf>] ata_scsi_add_hosts+0x4e/0x130
[    9.270000]  [<ffffffff80663eba>] ata_host_register+0xb0/0x296
[    9.270000]  [<ffffffff804acf4a>] ? devres_open_group+0xb1/0xd5
[    9.270000]  [<ffffffff8066bc36>] ata_pci_sff_activate_host+0x1af/0x1f0
[    9.270000]  [<ffffffff8066dfc2>] ? ata_sff_interrupt+0x0/0x26a
[    9.270000]  [<ffffffff808790ab>] piix_init_one+0x69e/0x6cb
[    9.270000]  [<ffffffff80438790>] pci_call_probe+0x92/0xdf
[    9.270000]  [<ffffffff8043894a>] pci_device_probe+0x69/0xa9
[    9.270000]  [<ffffffff804aa7be>] driver_probe_device+0xb3/0x178
[    9.270000]  [<ffffffff8025df56>] ? down+0x4b/0x68
[    9.270000]  [<ffffffff804aa8e6>] __driver_attach+0x63/0xa4
[    9.270000]  [<ffffffff804aa883>] ? __driver_attach+0x0/0xa4
[    9.270000]  [<ffffffff804a9de4>] bus_for_each_dev+0x63/0xb1
[    9.270000]  [<ffffffff804aa5a9>] driver_attach+0x34/0x4a
[    9.270000]  [<ffffffff804a9594>] bus_add_driver+0xcc/0x22c
[    9.270000]  [<ffffffff8041f9e0>] ? kset_find_obj+0x4c/0x97
[    9.270000]  [<ffffffff804aac0a>] driver_register+0xbc/0x153
[    9.270000]  [<ffffffff80438c41>] __pci_register_driver+0x67/0xb6
[    9.270000]  [<ffffffff80ccf3f6>] ? piix_init+0x0/0x55
[    9.270000]  [<ffffffff80ccf427>] piix_init+0x31/0x55
[    9.270000]  [<ffffffff80ca296d>] kernel_init+0x1c6/0x333
[    9.270000]  [<ffffffff8023cb86>] ? finish_task_switch+0x41/0xe0
[    9.270000]  [<ffffffff8020d4d9>] child_rip+0xa/0x11
[    9.270000]  [<ffffffff8020cb7c>] ? restore_args+0x0/0x30
[    9.270000]  [<ffffffff80ca27a7>] ? kernel_init+0x0/0x333
[    9.270000]  [<ffffffff8020d4cf>] ? child_rip+0x0/0x11
[    9.270000] 
[    9.270000] 
[    9.270000] Code: 29 c8 48 29 d0 48 c1 f8 03 48 01 d0 48 89 86 a0 00 00 00 48 8b 73 08 48 8b 05 9f 66 a2 00 48 c7 c1 40 5d db 80 45 31 c0 8b 56 1c <48> 8b 04 d0 48 8b 93 10 04 00 00 48 8b 40 08 48 8b 84 01 10 08 
[    9.270000] RIP  [<ffffffff80230576>] dequeue_task+0x73/0xf0
[    9.270000]  RSP <ffff88003f9b7420>
[    9.270000] CR2: ffff88080101c1f8
[    9.270000] Kernel panic - not syncing: Fatal exception
Press any key to enter the menu
