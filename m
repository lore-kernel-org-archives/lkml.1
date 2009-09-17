Return-Path: <linux-kernel-owner+w=401wt.eu-S1758867AbZIQSAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758867AbZIQSAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 14:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbZIQSAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 14:00:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60576 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429AbZIQSAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 14:00:35 -0400
Date: Thu, 17 Sep 2009 19:59:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Tejun Heo <tj@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] first round of PCI updates for 2.6.32
Message-ID: <20090917175944.GA17304@elte.hu>
References: <20090915132105.2fdd1d45@jbarnes-g45> <20090917173012.GA11155@elte.hu> <20090917103614.6ab1385f@jbarnes-g45>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090917103614.6ab1385f@jbarnes-g45>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Thu, 17 Sep 2009 19:30:12 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > 
> > > The following changes since commit
> > > 332a3392188e0ad966543c87b8da2b9d246f301d: Linus Torvalds (1):
> > >         Merge git://git.kernel.org/.../herbert/crypto-2.6
> > 
> > Since this went upstream -tip tests have been triggering nasty bootup 
> > crashes in the PCI code:
> > 
> > [    4.366174] initcall pci_proc_init+0x0/0x7a returned 0 after 976
> > usecs [    4.373009] calling  pcie_portdrv_init+0x0/0x60 @ 1
> > [    4.378368] bus: 'pci_express': registered
> > [    4.382009] bus: 'pci': add driver pcieport-driver
> > [    4.387058] bus: 'pci': driver_probe_device: matched device
> > 0000:00:0b.0 with driver pcieport-driver [    4.396005] bus: 'pci':
> > really_probe: probing driver pcieport-driver with device 0000:00:0b.0
> > [    4.404056] cpumask_of_node(255): node > nr_node_ids(16)
> > [    4.410007] Pid: 1, comm: swapper Not tainted 2.6.31 #14941
> > [    4.415005] Call Trace: [    4.418010]  [<c182cdac>] ?
> > printk+0x22/0x35 [    4.422009]  [<c10503f6>]
> > cpumask_of_node+0x32/0x74 [    4.427007]  [<c1344e71>]
> > pci_device_probe+0x7a/0xee [    4.432009]  [<c1381faf>]
> > driver_probe_device+0xc1/0x17a [    4.437008]  [<c13820be>]
> > __driver_attach+0x56/0x84 [    4.442008]  [<c1381645>]
> > bus_for_each_dev+0x53/0x8e [    4.447007]  [<c1382068>] ?
> > __driver_attach+0x0/0x84 [    4.452007]  [<c1381d7a>]
> > driver_attach+0x27/0x3a [    4.456007]  [<c1382068>] ?
> > __driver_attach+0x0/0x84 [    4.461007]  [<c1380f2f>]
> > bus_add_driver+0x122/0x25a [    4.466008]  [<c1382424>]
> > driver_register+0x9b/0x10c [    4.471008]  [<c13320a3>] ?
> > __spin_lock_init+0x34/0x69 [    4.476007]  [<c13450df>]
> > __pci_register_driver+0x56/0xc3 [    4.482007]  [<c1c7fb0c>] ?
> > pcie_portdrv_init+0x0/0x60 [    4.487007]  [<c1c7fb49>]
> > pcie_portdrv_init+0x3d/0x60 [    4.492007]  [<c1001096>]
> > do_one_initcall+0x6d/0x183 [    4.497008]  [<c1c5a4d6>]
> > kernel_init+0x187/0x1ec [    4.501007]  [<c1c5a34f>] ?
> > kernel_init+0x0/0x1ec [    4.506007]  [<c102cce7>]
> > kernel_thread_helper+0x7/0x10 [    4.511207] ------------[ cut
> > here ]------------ [    4.511999] WARNING: at kernel/lockdep.c:2813
> > __lock_acquire+0x7bc/0x147a() [    4.511999] Hardware name: System
> > Product Name [    4.511999] Modules linked in:
> > [    4.511999] Pid: 1, comm: swapper Not tainted 2.6.31 #14941
> > [    4.511999] Call Trace:
> > [    4.511999]  [<c10947d7>] ? __lock_acquire+0x7bc/0x147a
> > [    4.511999]  [<c1069325>] warn_slowpath_common+0x74/0xb5
> > [    4.511999]  [<c110d65c>] ? get_partial_node+0x2c/0xbd
> > [    4.511999]  [<c1069387>] warn_slowpath_null+0x21/0x35
> > [    4.511999]  [<c10947d7>] __lock_acquire+0x7bc/0x147a
> > [    4.511999]  [<c110b526>] ? add_partial+0x26/0x62
> > [    4.511999]  [<c110d65c>] ? get_partial_node+0x2c/0xbd
> > [    4.511999]  [<c110b526>] ? add_partial+0x26/0x62
> > [    4.511999]  [<c110b526>] ? add_partial+0x26/0x62
> > [    4.511999]  [<c1095479>] ? __lock_acquire+0x145e/0x147a
> > [    4.511999]  [<c110b526>] ? add_partial+0x26/0x62
> > [    4.511999]  [<c110d65c>] ? get_partial_node+0x2c/0xbd
> > [    4.511999]  [<c1095563>] lock_acquire+0xce/0xf6
> > [    4.511999]  [<c110d65c>] ? get_partial_node+0x2c/0xbd
> > [    4.511999]  [<c1830676>] _spin_lock+0x35/0x55
> > [    4.511999]  [<c110d65c>] ? get_partial_node+0x2c/0xbd
> > [    4.511999]  [<c110d65c>] get_partial_node+0x2c/0xbd
> > [    4.511999]  [<c110db0a>] __slab_alloc+0x154/0x4a7
> > [    4.511999]  [<c17e65c4>] ? irq_to_desc_alloc_node+0x99/0x2d2
> > [    4.511999]  [<c110de9a>] ?
> > kmem_cache_alloc_node_notrace+0x3d/0x104 [    4.511999]  [<c110ded7>]
> > kmem_cache_alloc_node_notrace+0x7a/0x104 [    4.511999]
> > [<c17e65c4>] ? irq_to_desc_alloc_node+0x99/0x2d2 [    4.511999]
> > [<c17e65c4>] ? irq_to_desc_alloc_node+0x99/0x2d2 [    4.511999]
> > [<c17e65c4>] irq_to_desc_alloc_node+0x99/0x2d2 [    4.511999]
> > [<c1042cde>] create_irq_nr+0x48/0xce [    4.511999]  [<c1042dd3>]
> > arch_setup_msi_irqs+0x6f/0x1b3 [    4.511999]  [<c134b685>] ?
> > alloc_msi_entry+0x2b/0xb1 [    4.511999]  [<c134c40d>]
> > pci_enable_msi_block+0x228/0x2bf [    4.511999]  [<c1349380>]
> > pcie_port_device_register+0x318/0x508 [    4.511999]  [<c10934bb>] ?
> > trace_hardirqs_on+0x19/0x2c [    4.511999]  [<c183049f>] ?
> > _spin_unlock_irqrestore+0x55/0x7d [    4.511999]  [<c133e63f>] ?
> > pci_bus_read_config_word+0x6f/0x8c [    4.511999]  [<c1349035>] ?
> > pcie_port_device_probe+0x3b/0x6e [    4.511999]  [<c17ea9e4>]
> > pcie_portdrv_probe+0x67/0x8f [    4.511999]  [<c1344b65>]
> > local_pci_probe+0x22/0x35 [    4.511999]  [<c1344e9b>]
> > pci_device_probe+0xa4/0xee [    4.511999]  [<c1381faf>]
> > driver_probe_device+0xc1/0x17a [    4.511999]  [<c13820be>]
> > __driver_attach+0x56/0x84 [    4.511999]  [<c1381645>]
> > bus_for_each_dev+0x53/0x8e [    4.511999]  [<c1382068>] ?
> > __driver_attach+0x0/0x84 [    4.511999]  [<c1381d7a>]
> > driver_attach+0x27/0x3a [    4.511999]  [<c1382068>] ?
> > __driver_attach+0x0/0x84 [    4.511999]  [<c1380f2f>]
> > bus_add_driver+0x122/0x25a [    4.511999]  [<c1382424>]
> > driver_register+0x9b/0x10c [    4.511999]  [<c13320a3>] ?
> > __spin_lock_init+0x34/0x69 [    4.511999]  [<c13450df>]
> > __pci_register_driver+0x56/0xc3 [    4.511999]  [<c1c7fb0c>] ?
> > pcie_portdrv_init+0x0/0x60 [    4.511999]  [<c1c7fb49>]
> > pcie_portdrv_init+0x3d/0x60 [    4.511999]  [<c1001096>]
> > do_one_initcall+0x6d/0x183 [    4.511999]  [<c1c5a4d6>]
> > kernel_init+0x187/0x1ec [    4.511999]  [<c1c5a34f>] ?
> > kernel_init+0x0/0x1ec [    4.511999]  [<c102cce7>]
> > kernel_thread_helper+0x7/0x10 [    4.511999] ---[ end trace
> > 5a5d197966b56a2e ]--- [    5.704001] BUG: spinlock lockup on CPU#1,
> > swapper/1, c1bdbaac [    5.704001] Pid: 1, comm: swapper Tainted:
> > G        W  2.6.31 #14941 [    5.704001] Call Trace:
> > [    5.704001]  [<c182cdac>] ? printk+0x22/0x35
> > [    5.704001]  [<c1331fca>] _raw_spin_lock+0x106/0x142
> > [    5.704001]  [<c183067d>] _spin_lock+0x3c/0x55
> > [    5.704001]  [<c110d65c>] ? get_partial_node+0x2c/0xbd
> > [    5.704001]  [<c110d65c>] get_partial_node+0x2c/0xbd
> > [    5.704001]  [<c110db0a>] __slab_alloc+0x154/0x4a7
> > [    5.704001]  [<c17e65c4>] ? irq_to_desc_alloc_node+0x99/0x2d2
> > [    5.704001]  [<c110de9a>] ?
> > kmem_cache_alloc_node_notrace+0x3d/0x104 [    5.704001]  [<c110ded7>]
> > kmem_cache_alloc_node_notrace+0x7a/0x104 [    5.704001]
> > [<c17e65c4>] ? irq_to_desc_alloc_node+0x99/0x2d2 [    5.704001]
> > [<c17e65c4>] ? irq_to_desc_alloc_node+0x99/0x2d2 [    5.704001]
> > [<c17e65c4>] irq_to_desc_alloc_node+0x99/0x2d2 [    5.704001]
> > [<c1042cde>] create_irq_nr+0x48/0xce [    5.704001]  [<c1042dd3>]
> > arch_setup_msi_irqs+0x6f/0x1b3 [    5.704001]  [<c134b685>] ?
> > alloc_msi_entry+0x2b/0xb1 [    5.704001]  [<c134c40d>]
> > pci_enable_msi_block+0x228/0x2bf [    5.704001]  [<c1349380>]
> > pcie_port_device_register+0x318/0x508 [    5.704001]  [<c10934bb>] ?
> > trace_hardirqs_on+0x19/0x2c [    5.704001]  [<c183049f>] ?
> > _spin_unlock_irqrestore+0x55/0x7d [    5.704001]  [<c133e63f>] ?
> > pci_bus_read_config_word+0x6f/0x8c [    5.704001]  [<c1349035>] ?
> > pcie_port_device_probe+0x3b/0x6e [    5.704001]  [<c17ea9e4>]
> > pcie_portdrv_probe+0x67/0x8f [    5.704001]  [<c1344b65>]
> > local_pci_probe+0x22/0x35 [    5.704001]  [<c1344e9b>]
> > pci_device_probe+0xa4/0xee [    5.704001]  [<c1381faf>]
> > driver_probe_device+0xc1/0x17a [    5.704001]  [<c13820be>]
> > __driver_attach+0x56/0x84 [    5.704001]  [<c1381645>]
> > bus_for_each_dev+0x53/0x8e [    5.704001]  [<c1382068>] ?
> > __driver_attach+0x0/0x84 [    5.704001]  [<c1381d7a>]
> > driver_attach+0x27/0x3a [    5.704001]  [<c1382068>] ?
> > __driver_attach+0x0/0x84 [    5.704001]  [<c1380f2f>]
> > bus_add_driver+0x122/0x25a [    5.704001]  [<c1382424>]
> > driver_register+0x9b/0x10c [    5.704001]  [<c13320a3>] ?
> > __spin_lock_init+0x34/0x69 [    5.704001]  [<c13450df>]
> > __pci_register_driver+0x56/0xc3 [    5.704001]  [<c1c7fb0c>] ?
> > pcie_portdrv_init+0x0/0x60 [    5.704001]  [<c1c7fb49>]
> > pcie_portdrv_init+0x3d/0x60 [    5.704001]  [<c1001096>]
> > do_one_initcall+0x6d/0x183 [    5.704001]  [<c1c5a4d6>]
> > kernel_init+0x187/0x1ec [    5.704001]  [<c1c5a34f>] ?
> > kernel_init+0x0/0x1ec [    5.704001]  [<c102cce7>]
> > kernel_thread_helper+0x7/0x10 [    5.704001] sending NMI to all CPUs:
> > [    5.704001] NMI backtrace for cpu 1
> > [    5.704001] 
> > [    5.704001] Pid: 1, comm: swapper Tainted: G        W  (2.6.31
> > #14941) System Product Name [    5.704001] EIP: 0060:[<c1092481>]
> > EFLAGS: 00000046 CPU: 1 [    5.704001] EIP is at
> > trace_hardirqs_off_caller+0xb8/0xbd [    5.704001] EAX: 00000000 EBX:
> > f60b8000 ECX: c1be08e4 EDX: c103ff84 [    5.704001] ESI: c103ff84
> > EDI: 00000006 EBP: f60a2c30 ESP: f60a2c24 [    5.704001]  DS: 007b
> > ES: 007b FS: 00d8 GS: 00e0 SS: 0068 [    5.704001] CR0: 8005003b CR2:
> > 00000000 CR3: 01bd7000 CR4: 000006f0 [    5.704001] DR0: 00000000
> > DR1: 00000000 DR2: 00000000 DR3: 00000000 [    5.704001] DR6:
> > ffff0ff0 DR7: 00000400 [    5.704001] Call Trace:
> > [    5.704001]  [<c109249f>] trace_hardirqs_off+0x19/0x2c
> > [    5.704001]  [<c103ff84>] default_send_IPI_mask_logical+0xde/0x100
> > [    5.704001]  [<c103fc91>] default_send_IPI_all+0x35/0x87
> > [    5.704001]  [<c10404ec>] arch_trigger_all_cpu_backtrace+0x5c/0x9e
> > [    5.704001]  [<c1331fcf>] _raw_spin_lock+0x10b/0x142
> > [    5.704001]  [<c183067d>] _spin_lock+0x3c/0x55
> > [    5.704001]  [<c110d65c>] ? get_partial_node+0x2c/0xbd
> > [    5.704001]  [<c110d65c>] get_partial_node+0x2c/0xbd
> > [    5.704001]  [<c110db0a>] __slab_alloc+0x154/0x4a7
> > [    5.704001]  [<c17e65c4>] ? irq_to_desc_alloc_node+0x99/0x2d2
> > [    5.704001]  [<c110de9a>] ?
> > kmem_cache_alloc_node_notrace+0x3d/0x104 [    5.704001]  [<c110ded7>]
> > kmem_cache_alloc_node_notrace+0x7a/0x104 [    5.704001]
> > [<c17e65c4>] ? irq_to_desc_alloc_node+0x99/0x2d2 [    5.704001]
> > [<c17e65c4>] ? irq_to_desc_alloc_node+0x99/0x2d2 [    5.704001]
> > [<c17e65c4>] irq_to_desc_alloc_node+0x99/0x2d2 [    5.704001]
> > [<c1042cde>] create_irq_nr+0x48/0xce [    5.704001]  [<c1042dd3>]
> > arch_setup_msi_irqs+0x6f/0x1b3 [    5.704001]  [<c134b685>] ?
> > alloc_msi_entry+0x2b/0xb1 [    5.704001]  [<c134c40d>]
> > pci_enable_msi_block+0x228/0x2bf [    5.704001]  [<c1349380>]
> > pcie_port_device_register+0x318/0x508 [    5.704001]  [<c10934bb>] ?
> > trace_hardirqs_on+0x19/0x2c [    5.704001]  [<c183049f>] ?
> > _spin_unlock_irqrestore+0x55/0x7d [    5.704001]  [<c133e63f>] ?
> > pci_bus_read_config_word+0x6f/0x8c [    5.704001]  [<c1349035>] ?
> > pcie_port_device_probe+0x3b/0x6e [    5.704001]  [<c17ea9e4>]
> > pcie_portdrv_probe+0x67/0x8f [    5.704001]  [<c1344b65>]
> > local_pci_probe+0x22/0x35 [    5.704001]  [<c1344e9b>]
> > pci_device_probe+0xa4/0xee [    5.704001]  [<c1381faf>]
> > driver_probe_device+0xc1/0x17a [    5.704001]  [<c13820be>]
> > __driver_attach+0x56/0x84 [    5.704001]  [<c1381645>]
> > bus_for_each_dev+0x53/0x8e [    5.704001]  [<c1382068>] ?
> > __driver_attach+0x0/0x84 [    5.704001]  [<c1381d7a>]
> > driver_attach+0x27/0x3a [    5.704001]  [<c1382068>] ?
> > __driver_attach+0x0/0x84 [    5.704001]  [<c1380f2f>]
> > bus_add_driver+0x122/0x25a [    5.704001]  [<c1382424>]
> > driver_register+0x9b/0x10c [    5.704001]  [<c13320a3>] ?
> > __spin_lock_init+0x34/0x69 [    5.704001]  [<c13450df>]
> > __pci_register_driver+0x56/0xc3 [    5.704001]  [<c1c7fb0c>] ?
> > pcie_portdrv_init+0x0/0x60 [    5.704001]  [<c1c7fb49>]
> > pcie_portdrv_init+0x3d/0x60 [    5.704001]  [<c1001096>]
> > do_one_initcall+0x6d/0x183 [    5.704001]  [<c1c5a4d6>]
> > kernel_init+0x187/0x1ec [    5.704001]  [<c1c5a34f>] ?
> > kernel_init+0x0/0x1ec [    5.704001]  [<c102cce7>]
> > kernel_thread_helper+0x7/0x10 [    5.704001] Pid: 1, comm: swapper
> > Tainted: G        W  2.6.31 #14941 [    5.704001] Call Trace:
> > [    5.704001]  [<c102ae6f>] ? show_regs+0x34/0x4b
> > [    5.704001]  [<c1831f4d>] nmi_watchdog_tick+0xea/0x222
> > [    5.704001]  [<c1831365>] do_nmi+0xa9/0x2a9
> > [    5.704001]  [<c103ff84>] ?
> > default_send_IPI_mask_logical+0xde/0x100 [    5.704001]  [<c1830ea0>]
> > nmi_stack_correct+0x2f/0x34 [    5.704001]  [<c103ff84>] ?
> > default_send_IPI_mask_logical+0xde/0x100 [    5.704001]
> > [<c103ff84>] ? default_send_IPI_mask_logical+0xde/0x100
> > [    5.704001]  [<c1092481>] ? trace_hardirqs_off_caller+0xb8/0xbd
> > [    5.704001]  [<c109249f>] trace_hardirqs_off+0x19/0x2c
> > [    5.704001]  [<c103ff84>] default_send_IPI_mask_logical+0xde/0x100
> > [    5.704001]  [<c103fc91>] default_send_IPI_all+0x35/0x87
> > [    5.704001]  [<c10404ec>] arch_trigger_all_cpu_backtrace+0x5c/0x9e
> > [    5.704001]  [<c1331fcf>] _raw_spin_lock+0x10b/0x142
> > [    5.704001]  [<c183067d>] _spin_lock+0x3c/0x55 [    5.704001]
> > [<c110d65c>] ? get_partial_node+0x2c/0xbd [    5.704001]
> > [<c110d65c>] get_partial_node+0x2c/0xbd [    5.704001]  [<c110db0a>]
> > __slab_alloc+0x154/0x4a7 [    5.704001]  [<c17e65c4>] ?
> > irq_to_desc_alloc_node+0x99/0x2d2 [    5.704001]  [<c110de9a>] ?
> > kmem_cache_alloc_node_notrace+0x3d/0x104 [    5.704001]  [<c110ded7>]
> > kmem_cache_alloc_node_notrace+0x7a/0x104 [    5.704001]
> > [<c17e65c4>] ? irq_to_desc_alloc_node+0x99/0x2d2 [    5.704001]
> > [<c17e65c4>] ? irq_to_desc_alloc_node+0x99/0x2d2 [    5.704001]
> > [<c17e65c4>] irq_to_desc_alloc_node+0x99/0x2d2 [    5.704001]
> > [<c1042cde>] create_irq_nr+0x48/0xce [    5.704001]  [<c1042dd3>]
> > arch_setup_msi_irqs+0x6f/0x1b3 [    5.704001]  [<c134b685>] ?
> > alloc_msi_entry+0x2b/0xb1 [    5.704001]  [<c134c40d>]
> > pci_enable_msi_block+0x228/0x2bf [    5.704001]  [<c1349380>]
> > pcie_port_device_register+0x318/0x508 [    5.704001]  [<c10934bb>] ?
> > trace_hardirqs_on+0x19/0x2c [    5.704001]  [<c183049f>] ?
> > _spin_unlock_irqrestore+0x55/0x7d [    5.704001]  [<c133e63f>] ?
> > pci_bus_read_config_word+0x6f/0x8c [    5.704001]  [<c1349035>] ?
> > pcie_port_device_probe+0x3b/0x6e [    5.704001]  [<c17ea9e4>]
> > pcie_portdrv_probe+0x67/0x8f [    5.704001]  [<c1344b65>]
> > local_pci_probe+0x22/0x35 [    5.704001]  [<c1344e9b>]
> > pci_device_probe+0xa4/0xee [    5.704001]  [<c1381faf>]
> > driver_probe_device+0xc1/0x17a [    5.704001]  [<c13820be>]
> > __driver_attach+0x56/0x84 [    5.704001]  [<c1381645>]
> > bus_for_each_dev+0x53/0x8e [    5.704001]  [<c1382068>] ?
> > __driver_attach+0x0/0x84 [    5.704001]  [<c1381d7a>]
> > driver_attach+0x27/0x3a [    5.704001]  [<c1382068>] ?
> > __driver_attach+0x0/0x84 [    5.704001]  [<c1380f2f>]
> > bus_add_driver+0x122/0x25a [    5.704001]  [<c1382424>]
> > driver_register+0x9b/0x10c [    5.704001]  [<c13320a3>] ?
> > __spin_lock_init+0x34/0x69 [    5.704001]  [<c13450df>]
> > __pci_register_driver+0x56/0xc3 [    5.704001]  [<c1c7fb0c>] ?
> > pcie_portdrv_init+0x0/0x60 [    5.704001]  [<c1c7fb49>]
> > pcie_portdrv_init+0x3d/0x60 [    5.704001]  [<c1001096>]
> > do_one_initcall+0x6d/0x183 [    5.704001]  [<c1c5a4d6>]
> > kernel_init+0x187/0x1ec [    5.704001]  [<c1c5a34f>] ?
> > kernel_init+0x0/0x1ec [    5.704001]  [<c102cce7>]
> > kernel_thread_helper+0x7/0x10 [  129.036999] NMI backtrace for cpu 0
> > [  129.036999] 
> > [  129.036999] Pid: 0, comm: swapper Tainted: G        W  (2.6.31
> > #14941) System Product Name [  129.036999] EIP: 0060:[<c10325b2>]
> > EFLAGS: 00000246 CPU: 0 [  129.036999] EIP is at
> > default_idle+0x9a/0x110 [  129.036999] EAX: 00000000 EBX: c1c560d0
> > ECX: c102af40 EDX: 00733000 [  129.036999] ESI: 00000000 EDI:
> > c1bd8000 EBP: c1bd6fa0 ESP: c1bd6f7c [  129.036999]  DS: 007b ES:
> > 007b FS: 00d8 GS: 00e0 SS: 0068 [  129.036999] CR0: 8005003b CR2:
> > 00000000 CR3: 01bd7000 CR4: 000006f0 [  129.036999] DR0: 00000000
> > DR1: 00000000 DR2: 00000000 DR3: 00000000 [  129.036999] DR6:
> > ffff0ff0 DR7: 00000400 [  129.036999] Call Trace:
> > [  129.036999]  [<c17e54fb>] ? rest_init+0x7f/0x92
> > [  129.036999]  [<c102af46>] cpu_idle+0xc0/0xee
> > [  129.036999]  [<c17e54fb>] rest_init+0x7f/0x92
> > [  129.036999]  [<c1c5ab50>] start_kernel+0x3f8/0x410
> > [  129.036999]  [<c1c5a079>] __init_begin+0x79/0x8f
> > [  129.036999] Pid: 0, comm: swapper Tainted: G        W  2.6.31
> > #14941 [  129.036999] Call Trace:
> > [  129.036999]  [<c102ae6f>] ? show_regs+0x34/0x4b
> > [  129.036999]  [<c1831f4d>] nmi_watchdog_tick+0xea/0x222
> > [  129.036999]  [<c1831365>] do_nmi+0xa9/0x2a9
> > [  129.036999]  [<c1830ea0>] nmi_stack_correct+0x2f/0x34
> > [  129.036999]  [<c102af40>] ? cpu_idle+0xba/0xee
> > [  129.036999]  [<c10325b2>] ? default_idle+0x9a/0x110
> > [  129.036999]  [<c17e54fb>] ? rest_init+0x7f/0x92
> > [  129.036999]  [<c102af46>] cpu_idle+0xc0/0xee
> > [  129.036999]  [<c17e54fb>] rest_init+0x7f/0x92
> > [  129.036999]  [<c1c5ab50>] start_kernel+0x3f8/0x410
> > [  129.036999]  [<c1c5a079>] __init_begin+0x79/0x8f
> > 
> > Config and full bootlog attached.
> > 
> > Note:
> > 
> >  CONFIG_DEBUG_PER_CPU_MAPS=y
> >  CONFIG_CPUMASK_OFFSTACK=y
> 
> Does this patch fix it?  I sent it to you earlier but I never heard 
> back...

Ah ... you probably sent it in the merge window communication blackout 
;-)

Will try, thanks.

	Ingo
