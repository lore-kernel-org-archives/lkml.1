Return-Path: <linux-kernel-owner+w=401wt.eu-S1757696AbZIQRbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696AbZIQRbX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 13:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753303AbZIQRbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 13:31:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53571 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753786AbZIQRbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 13:31:07 -0400
Date: Thu, 17 Sep 2009 19:30:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Yinghai Lu <yinghai@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] first round of PCI updates for 2.6.32
Message-ID: <20090917173012.GA11155@elte.hu>
References: <20090915132105.2fdd1d45@jbarnes-g45>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
In-Reply-To: <20090915132105.2fdd1d45@jbarnes-g45>
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


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


* Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> The following changes since commit 332a3392188e0ad966543c87b8da2b9d246f301d:
>   Linus Torvalds (1):
>         Merge git://git.kernel.org/.../herbert/crypto-2.6

Since this went upstream -tip tests have been triggering nasty bootup 
crashes in the PCI code:

[    4.366174] initcall pci_proc_init+0x0/0x7a returned 0 after 976 usecs
[    4.373009] calling  pcie_portdrv_init+0x0/0x60 @ 1
[    4.378368] bus: 'pci_express': registered
[    4.382009] bus: 'pci': add driver pcieport-driver
[    4.387058] bus: 'pci': driver_probe_device: matched device 0000:00:0b.0 with driver pcieport-driver
[    4.396005] bus: 'pci': really_probe: probing driver pcieport-driver with device 0000:00:0b.0
[    4.404056] cpumask_of_node(255): node > nr_node_ids(16)
[    4.410007] Pid: 1, comm: swapper Not tainted 2.6.31 #14941
[    4.415005] Call Trace:
[    4.418010]  [<c182cdac>] ? printk+0x22/0x35
[    4.422009]  [<c10503f6>] cpumask_of_node+0x32/0x74
[    4.427007]  [<c1344e71>] pci_device_probe+0x7a/0xee
[    4.432009]  [<c1381faf>] driver_probe_device+0xc1/0x17a
[    4.437008]  [<c13820be>] __driver_attach+0x56/0x84
[    4.442008]  [<c1381645>] bus_for_each_dev+0x53/0x8e
[    4.447007]  [<c1382068>] ? __driver_attach+0x0/0x84
[    4.452007]  [<c1381d7a>] driver_attach+0x27/0x3a
[    4.456007]  [<c1382068>] ? __driver_attach+0x0/0x84
[    4.461007]  [<c1380f2f>] bus_add_driver+0x122/0x25a
[    4.466008]  [<c1382424>] driver_register+0x9b/0x10c
[    4.471008]  [<c13320a3>] ? __spin_lock_init+0x34/0x69
[    4.476007]  [<c13450df>] __pci_register_driver+0x56/0xc3
[    4.482007]  [<c1c7fb0c>] ? pcie_portdrv_init+0x0/0x60
[    4.487007]  [<c1c7fb49>] pcie_portdrv_init+0x3d/0x60
[    4.492007]  [<c1001096>] do_one_initcall+0x6d/0x183
[    4.497008]  [<c1c5a4d6>] kernel_init+0x187/0x1ec
[    4.501007]  [<c1c5a34f>] ? kernel_init+0x0/0x1ec
[    4.506007]  [<c102cce7>] kernel_thread_helper+0x7/0x10
[    4.511207] ------------[ cut here ]------------
[    4.511999] WARNING: at kernel/lockdep.c:2813 __lock_acquire+0x7bc/0x147a()
[    4.511999] Hardware name: System Product Name
[    4.511999] Modules linked in:
[    4.511999] Pid: 1, comm: swapper Not tainted 2.6.31 #14941
[    4.511999] Call Trace:
[    4.511999]  [<c10947d7>] ? __lock_acquire+0x7bc/0x147a
[    4.511999]  [<c1069325>] warn_slowpath_common+0x74/0xb5
[    4.511999]  [<c110d65c>] ? get_partial_node+0x2c/0xbd
[    4.511999]  [<c1069387>] warn_slowpath_null+0x21/0x35
[    4.511999]  [<c10947d7>] __lock_acquire+0x7bc/0x147a
[    4.511999]  [<c110b526>] ? add_partial+0x26/0x62
[    4.511999]  [<c110d65c>] ? get_partial_node+0x2c/0xbd
[    4.511999]  [<c110b526>] ? add_partial+0x26/0x62
[    4.511999]  [<c110b526>] ? add_partial+0x26/0x62
[    4.511999]  [<c1095479>] ? __lock_acquire+0x145e/0x147a
[    4.511999]  [<c110b526>] ? add_partial+0x26/0x62
[    4.511999]  [<c110d65c>] ? get_partial_node+0x2c/0xbd
[    4.511999]  [<c1095563>] lock_acquire+0xce/0xf6
[    4.511999]  [<c110d65c>] ? get_partial_node+0x2c/0xbd
[    4.511999]  [<c1830676>] _spin_lock+0x35/0x55
[    4.511999]  [<c110d65c>] ? get_partial_node+0x2c/0xbd
[    4.511999]  [<c110d65c>] get_partial_node+0x2c/0xbd
[    4.511999]  [<c110db0a>] __slab_alloc+0x154/0x4a7
[    4.511999]  [<c17e65c4>] ? irq_to_desc_alloc_node+0x99/0x2d2
[    4.511999]  [<c110de9a>] ? kmem_cache_alloc_node_notrace+0x3d/0x104
[    4.511999]  [<c110ded7>] kmem_cache_alloc_node_notrace+0x7a/0x104
[    4.511999]  [<c17e65c4>] ? irq_to_desc_alloc_node+0x99/0x2d2
[    4.511999]  [<c17e65c4>] ? irq_to_desc_alloc_node+0x99/0x2d2
[    4.511999]  [<c17e65c4>] irq_to_desc_alloc_node+0x99/0x2d2
[    4.511999]  [<c1042cde>] create_irq_nr+0x48/0xce
[    4.511999]  [<c1042dd3>] arch_setup_msi_irqs+0x6f/0x1b3
[    4.511999]  [<c134b685>] ? alloc_msi_entry+0x2b/0xb1
[    4.511999]  [<c134c40d>] pci_enable_msi_block+0x228/0x2bf
[    4.511999]  [<c1349380>] pcie_port_device_register+0x318/0x508
[    4.511999]  [<c10934bb>] ? trace_hardirqs_on+0x19/0x2c
[    4.511999]  [<c183049f>] ? _spin_unlock_irqrestore+0x55/0x7d
[    4.511999]  [<c133e63f>] ? pci_bus_read_config_word+0x6f/0x8c
[    4.511999]  [<c1349035>] ? pcie_port_device_probe+0x3b/0x6e
[    4.511999]  [<c17ea9e4>] pcie_portdrv_probe+0x67/0x8f
[    4.511999]  [<c1344b65>] local_pci_probe+0x22/0x35
[    4.511999]  [<c1344e9b>] pci_device_probe+0xa4/0xee
[    4.511999]  [<c1381faf>] driver_probe_device+0xc1/0x17a
[    4.511999]  [<c13820be>] __driver_attach+0x56/0x84
[    4.511999]  [<c1381645>] bus_for_each_dev+0x53/0x8e
[    4.511999]  [<c1382068>] ? __driver_attach+0x0/0x84
[    4.511999]  [<c1381d7a>] driver_attach+0x27/0x3a
[    4.511999]  [<c1382068>] ? __driver_attach+0x0/0x84
[    4.511999]  [<c1380f2f>] bus_add_driver+0x122/0x25a
[    4.511999]  [<c1382424>] driver_register+0x9b/0x10c
[    4.511999]  [<c13320a3>] ? __spin_lock_init+0x34/0x69
[    4.511999]  [<c13450df>] __pci_register_driver+0x56/0xc3
[    4.511999]  [<c1c7fb0c>] ? pcie_portdrv_init+0x0/0x60
[    4.511999]  [<c1c7fb49>] pcie_portdrv_init+0x3d/0x60
[    4.511999]  [<c1001096>] do_one_initcall+0x6d/0x183
[    4.511999]  [<c1c5a4d6>] kernel_init+0x187/0x1ec
[    4.511999]  [<c1c5a34f>] ? kernel_init+0x0/0x1ec
[    4.511999]  [<c102cce7>] kernel_thread_helper+0x7/0x10
[    4.511999] ---[ end trace 5a5d197966b56a2e ]---
[    5.704001] BUG: spinlock lockup on CPU#1, swapper/1, c1bdbaac
[    5.704001] Pid: 1, comm: swapper Tainted: G        W  2.6.31 #14941
[    5.704001] Call Trace:
[    5.704001]  [<c182cdac>] ? printk+0x22/0x35
[    5.704001]  [<c1331fca>] _raw_spin_lock+0x106/0x142
[    5.704001]  [<c183067d>] _spin_lock+0x3c/0x55
[    5.704001]  [<c110d65c>] ? get_partial_node+0x2c/0xbd
[    5.704001]  [<c110d65c>] get_partial_node+0x2c/0xbd
[    5.704001]  [<c110db0a>] __slab_alloc+0x154/0x4a7
[    5.704001]  [<c17e65c4>] ? irq_to_desc_alloc_node+0x99/0x2d2
[    5.704001]  [<c110de9a>] ? kmem_cache_alloc_node_notrace+0x3d/0x104
[    5.704001]  [<c110ded7>] kmem_cache_alloc_node_notrace+0x7a/0x104
[    5.704001]  [<c17e65c4>] ? irq_to_desc_alloc_node+0x99/0x2d2
[    5.704001]  [<c17e65c4>] ? irq_to_desc_alloc_node+0x99/0x2d2
[    5.704001]  [<c17e65c4>] irq_to_desc_alloc_node+0x99/0x2d2
[    5.704001]  [<c1042cde>] create_irq_nr+0x48/0xce
[    5.704001]  [<c1042dd3>] arch_setup_msi_irqs+0x6f/0x1b3
[    5.704001]  [<c134b685>] ? alloc_msi_entry+0x2b/0xb1
[    5.704001]  [<c134c40d>] pci_enable_msi_block+0x228/0x2bf
[    5.704001]  [<c1349380>] pcie_port_device_register+0x318/0x508
[    5.704001]  [<c10934bb>] ? trace_hardirqs_on+0x19/0x2c
[    5.704001]  [<c183049f>] ? _spin_unlock_irqrestore+0x55/0x7d
[    5.704001]  [<c133e63f>] ? pci_bus_read_config_word+0x6f/0x8c
[    5.704001]  [<c1349035>] ? pcie_port_device_probe+0x3b/0x6e
[    5.704001]  [<c17ea9e4>] pcie_portdrv_probe+0x67/0x8f
[    5.704001]  [<c1344b65>] local_pci_probe+0x22/0x35
[    5.704001]  [<c1344e9b>] pci_device_probe+0xa4/0xee
[    5.704001]  [<c1381faf>] driver_probe_device+0xc1/0x17a
[    5.704001]  [<c13820be>] __driver_attach+0x56/0x84
[    5.704001]  [<c1381645>] bus_for_each_dev+0x53/0x8e
[    5.704001]  [<c1382068>] ? __driver_attach+0x0/0x84
[    5.704001]  [<c1381d7a>] driver_attach+0x27/0x3a
[    5.704001]  [<c1382068>] ? __driver_attach+0x0/0x84
[    5.704001]  [<c1380f2f>] bus_add_driver+0x122/0x25a
[    5.704001]  [<c1382424>] driver_register+0x9b/0x10c
[    5.704001]  [<c13320a3>] ? __spin_lock_init+0x34/0x69
[    5.704001]  [<c13450df>] __pci_register_driver+0x56/0xc3
[    5.704001]  [<c1c7fb0c>] ? pcie_portdrv_init+0x0/0x60
[    5.704001]  [<c1c7fb49>] pcie_portdrv_init+0x3d/0x60
[    5.704001]  [<c1001096>] do_one_initcall+0x6d/0x183
[    5.704001]  [<c1c5a4d6>] kernel_init+0x187/0x1ec
[    5.704001]  [<c1c5a34f>] ? kernel_init+0x0/0x1ec
[    5.704001]  [<c102cce7>] kernel_thread_helper+0x7/0x10
[    5.704001] sending NMI to all CPUs:
[    5.704001] NMI backtrace for cpu 1
[    5.704001] 
[    5.704001] Pid: 1, comm: swapper Tainted: G        W  (2.6.31 #14941) System Product Name
[    5.704001] EIP: 0060:[<c1092481>] EFLAGS: 00000046 CPU: 1
[    5.704001] EIP is at trace_hardirqs_off_caller+0xb8/0xbd
[    5.704001] EAX: 00000000 EBX: f60b8000 ECX: c1be08e4 EDX: c103ff84
[    5.704001] ESI: c103ff84 EDI: 00000006 EBP: f60a2c30 ESP: f60a2c24
[    5.704001]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[    5.704001] CR0: 8005003b CR2: 00000000 CR3: 01bd7000 CR4: 000006f0
[    5.704001] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[    5.704001] DR6: ffff0ff0 DR7: 00000400
[    5.704001] Call Trace:
[    5.704001]  [<c109249f>] trace_hardirqs_off+0x19/0x2c
[    5.704001]  [<c103ff84>] default_send_IPI_mask_logical+0xde/0x100
[    5.704001]  [<c103fc91>] default_send_IPI_all+0x35/0x87
[    5.704001]  [<c10404ec>] arch_trigger_all_cpu_backtrace+0x5c/0x9e
[    5.704001]  [<c1331fcf>] _raw_spin_lock+0x10b/0x142
[    5.704001]  [<c183067d>] _spin_lock+0x3c/0x55
[    5.704001]  [<c110d65c>] ? get_partial_node+0x2c/0xbd
[    5.704001]  [<c110d65c>] get_partial_node+0x2c/0xbd
[    5.704001]  [<c110db0a>] __slab_alloc+0x154/0x4a7
[    5.704001]  [<c17e65c4>] ? irq_to_desc_alloc_node+0x99/0x2d2
[    5.704001]  [<c110de9a>] ? kmem_cache_alloc_node_notrace+0x3d/0x104
[    5.704001]  [<c110ded7>] kmem_cache_alloc_node_notrace+0x7a/0x104
[    5.704001]  [<c17e65c4>] ? irq_to_desc_alloc_node+0x99/0x2d2
[    5.704001]  [<c17e65c4>] ? irq_to_desc_alloc_node+0x99/0x2d2
[    5.704001]  [<c17e65c4>] irq_to_desc_alloc_node+0x99/0x2d2
[    5.704001]  [<c1042cde>] create_irq_nr+0x48/0xce
[    5.704001]  [<c1042dd3>] arch_setup_msi_irqs+0x6f/0x1b3
[    5.704001]  [<c134b685>] ? alloc_msi_entry+0x2b/0xb1
[    5.704001]  [<c134c40d>] pci_enable_msi_block+0x228/0x2bf
[    5.704001]  [<c1349380>] pcie_port_device_register+0x318/0x508
[    5.704001]  [<c10934bb>] ? trace_hardirqs_on+0x19/0x2c
[    5.704001]  [<c183049f>] ? _spin_unlock_irqrestore+0x55/0x7d
[    5.704001]  [<c133e63f>] ? pci_bus_read_config_word+0x6f/0x8c
[    5.704001]  [<c1349035>] ? pcie_port_device_probe+0x3b/0x6e
[    5.704001]  [<c17ea9e4>] pcie_portdrv_probe+0x67/0x8f
[    5.704001]  [<c1344b65>] local_pci_probe+0x22/0x35
[    5.704001]  [<c1344e9b>] pci_device_probe+0xa4/0xee
[    5.704001]  [<c1381faf>] driver_probe_device+0xc1/0x17a
[    5.704001]  [<c13820be>] __driver_attach+0x56/0x84
[    5.704001]  [<c1381645>] bus_for_each_dev+0x53/0x8e
[    5.704001]  [<c1382068>] ? __driver_attach+0x0/0x84
[    5.704001]  [<c1381d7a>] driver_attach+0x27/0x3a
[    5.704001]  [<c1382068>] ? __driver_attach+0x0/0x84
[    5.704001]  [<c1380f2f>] bus_add_driver+0x122/0x25a
[    5.704001]  [<c1382424>] driver_register+0x9b/0x10c
[    5.704001]  [<c13320a3>] ? __spin_lock_init+0x34/0x69
[    5.704001]  [<c13450df>] __pci_register_driver+0x56/0xc3
[    5.704001]  [<c1c7fb0c>] ? pcie_portdrv_init+0x0/0x60
[    5.704001]  [<c1c7fb49>] pcie_portdrv_init+0x3d/0x60
[    5.704001]  [<c1001096>] do_one_initcall+0x6d/0x183
[    5.704001]  [<c1c5a4d6>] kernel_init+0x187/0x1ec
[    5.704001]  [<c1c5a34f>] ? kernel_init+0x0/0x1ec
[    5.704001]  [<c102cce7>] kernel_thread_helper+0x7/0x10
[    5.704001] Pid: 1, comm: swapper Tainted: G        W  2.6.31 #14941
[    5.704001] Call Trace:
[    5.704001]  [<c102ae6f>] ? show_regs+0x34/0x4b
[    5.704001]  [<c1831f4d>] nmi_watchdog_tick+0xea/0x222
[    5.704001]  [<c1831365>] do_nmi+0xa9/0x2a9
[    5.704001]  [<c103ff84>] ? default_send_IPI_mask_logical+0xde/0x100
[    5.704001]  [<c1830ea0>] nmi_stack_correct+0x2f/0x34
[    5.704001]  [<c103ff84>] ? default_send_IPI_mask_logical+0xde/0x100
[    5.704001]  [<c103ff84>] ? default_send_IPI_mask_logical+0xde/0x100
[    5.704001]  [<c1092481>] ? trace_hardirqs_off_caller+0xb8/0xbd
[    5.704001]  [<c109249f>] trace_hardirqs_off+0x19/0x2c
[    5.704001]  [<c103ff84>] default_send_IPI_mask_logical+0xde/0x100
[    5.704001]  [<c103fc91>] default_send_IPI_all+0x35/0x87
[    5.704001]  [<c10404ec>] arch_trigger_all_cpu_backtrace+0x5c/0x9e
[    5.704001]  [<c1331fcf>] _raw_spin_lock+0x10b/0x142
[    5.704001]  [<c183067d>] _spin_lock+0x3c/0x55
[    5.704001]  [<c110d65c>] ? get_partial_node+0x2c/0xbd
[    5.704001]  [<c110d65c>] get_partial_node+0x2c/0xbd
[    5.704001]  [<c110db0a>] __slab_alloc+0x154/0x4a7
[    5.704001]  [<c17e65c4>] ? irq_to_desc_alloc_node+0x99/0x2d2
[    5.704001]  [<c110de9a>] ? kmem_cache_alloc_node_notrace+0x3d/0x104
[    5.704001]  [<c110ded7>] kmem_cache_alloc_node_notrace+0x7a/0x104
[    5.704001]  [<c17e65c4>] ? irq_to_desc_alloc_node+0x99/0x2d2
[    5.704001]  [<c17e65c4>] ? irq_to_desc_alloc_node+0x99/0x2d2
[    5.704001]  [<c17e65c4>] irq_to_desc_alloc_node+0x99/0x2d2
[    5.704001]  [<c1042cde>] create_irq_nr+0x48/0xce
[    5.704001]  [<c1042dd3>] arch_setup_msi_irqs+0x6f/0x1b3
[    5.704001]  [<c134b685>] ? alloc_msi_entry+0x2b/0xb1
[    5.704001]  [<c134c40d>] pci_enable_msi_block+0x228/0x2bf
[    5.704001]  [<c1349380>] pcie_port_device_register+0x318/0x508
[    5.704001]  [<c10934bb>] ? trace_hardirqs_on+0x19/0x2c
[    5.704001]  [<c183049f>] ? _spin_unlock_irqrestore+0x55/0x7d
[    5.704001]  [<c133e63f>] ? pci_bus_read_config_word+0x6f/0x8c
[    5.704001]  [<c1349035>] ? pcie_port_device_probe+0x3b/0x6e
[    5.704001]  [<c17ea9e4>] pcie_portdrv_probe+0x67/0x8f
[    5.704001]  [<c1344b65>] local_pci_probe+0x22/0x35
[    5.704001]  [<c1344e9b>] pci_device_probe+0xa4/0xee
[    5.704001]  [<c1381faf>] driver_probe_device+0xc1/0x17a
[    5.704001]  [<c13820be>] __driver_attach+0x56/0x84
[    5.704001]  [<c1381645>] bus_for_each_dev+0x53/0x8e
[    5.704001]  [<c1382068>] ? __driver_attach+0x0/0x84
[    5.704001]  [<c1381d7a>] driver_attach+0x27/0x3a
[    5.704001]  [<c1382068>] ? __driver_attach+0x0/0x84
[    5.704001]  [<c1380f2f>] bus_add_driver+0x122/0x25a
[    5.704001]  [<c1382424>] driver_register+0x9b/0x10c
[    5.704001]  [<c13320a3>] ? __spin_lock_init+0x34/0x69
[    5.704001]  [<c13450df>] __pci_register_driver+0x56/0xc3
[    5.704001]  [<c1c7fb0c>] ? pcie_portdrv_init+0x0/0x60
[    5.704001]  [<c1c7fb49>] pcie_portdrv_init+0x3d/0x60
[    5.704001]  [<c1001096>] do_one_initcall+0x6d/0x183
[    5.704001]  [<c1c5a4d6>] kernel_init+0x187/0x1ec
[    5.704001]  [<c1c5a34f>] ? kernel_init+0x0/0x1ec
[    5.704001]  [<c102cce7>] kernel_thread_helper+0x7/0x10
[  129.036999] NMI backtrace for cpu 0
[  129.036999] 
[  129.036999] Pid: 0, comm: swapper Tainted: G        W  (2.6.31 #14941) System Product Name
[  129.036999] EIP: 0060:[<c10325b2>] EFLAGS: 00000246 CPU: 0
[  129.036999] EIP is at default_idle+0x9a/0x110
[  129.036999] EAX: 00000000 EBX: c1c560d0 ECX: c102af40 EDX: 00733000
[  129.036999] ESI: 00000000 EDI: c1bd8000 EBP: c1bd6fa0 ESP: c1bd6f7c
[  129.036999]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  129.036999] CR0: 8005003b CR2: 00000000 CR3: 01bd7000 CR4: 000006f0
[  129.036999] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  129.036999] DR6: ffff0ff0 DR7: 00000400
[  129.036999] Call Trace:
[  129.036999]  [<c17e54fb>] ? rest_init+0x7f/0x92
[  129.036999]  [<c102af46>] cpu_idle+0xc0/0xee
[  129.036999]  [<c17e54fb>] rest_init+0x7f/0x92
[  129.036999]  [<c1c5ab50>] start_kernel+0x3f8/0x410
[  129.036999]  [<c1c5a079>] __init_begin+0x79/0x8f
[  129.036999] Pid: 0, comm: swapper Tainted: G        W  2.6.31 #14941
[  129.036999] Call Trace:
[  129.036999]  [<c102ae6f>] ? show_regs+0x34/0x4b
[  129.036999]  [<c1831f4d>] nmi_watchdog_tick+0xea/0x222
[  129.036999]  [<c1831365>] do_nmi+0xa9/0x2a9
[  129.036999]  [<c1830ea0>] nmi_stack_correct+0x2f/0x34
[  129.036999]  [<c102af40>] ? cpu_idle+0xba/0xee
[  129.036999]  [<c10325b2>] ? default_idle+0x9a/0x110
[  129.036999]  [<c17e54fb>] ? rest_init+0x7f/0x92
[  129.036999]  [<c102af46>] cpu_idle+0xc0/0xee
[  129.036999]  [<c17e54fb>] rest_init+0x7f/0x92
[  129.036999]  [<c1c5ab50>] start_kernel+0x3f8/0x410
[  129.036999]  [<c1c5a079>] __init_begin+0x79/0x8f

Config and full bootlog attached.

Note:

 CONFIG_DEBUG_PER_CPU_MAPS=y
 CONFIG_CPUMASK_OFFSTACK=y

	Ingo

--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="crash.log"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Linux version 2.6.31 (mingo@sirius) (gcc version 4.3.2 20081=
105 (Red Hat 4.3.2-7) (GCC) ) #14941 SMP PREEMPT Thu Sep 17 19:03:23 CEST 2=
009
[    0.000000] console [earlyser0] enabled
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
[    0.000000]  BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.3 present.
[    0.000000] Phoenix BIOS detected: BIOS may corrupt low RAM, working aro=
und it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usab=
le) =3D=3D> (reserved)
[    0.000000] last_pfn =3D 0x3fff0 max_arch_pfn =3D 0x1000000
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009f800 (usable)
[    0.000000]  modified: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000003fff0000 (usable)
[    0.000000]  modified: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
[    0.000000]  modified: 000000003fff3000 - 0000000040000000 (ACPI data)
[    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] initial memory mapped : 0 - 02800000
[    0.000000] init_memory_mapping: 0000000000000000-00000000375fe000
[    0.000000] NX (Execute Disable) protection: active
[    0.000000]  0000000000 - 0000200000 page 4k
[    0.000000]  0000200000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00375fe000 page 4k
[    0.000000] kernel direct mapping tables up to 375fe000 @ 10000-18000
[    0.000000] Scan SMP from c0000000 for 1024 bytes.
[    0.000000] Scan SMP from c009fc00 for 1024 bytes.
[    0.000000] Scan SMP from c00f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [c00f5680] f5680
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]     Virtual Wire compatibility mode.
[    0.000000]   mpc: f1400-f152c
[    0.000000] MPTABLE: OEM ID: OEM00000
[    0.000000] MPTABLE: Product ID: PROD00000000
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] Warning! Not a NUMA-Q system!
[    0.000000] NUMA - single node, flat memory mode
[    0.000000] Node: 0, start_pfn: 0, end_pfn: 3fff0
[    0.000000]   Setting physnode_map array to node 0 for pfns:
[    0.000000]   0 4000 8000 c000 10000 14000 18000 1c000 20000 24000 28000=
 2c000 30000 34000 38000 3c000=20
[    0.000000] node 0 pfn: [0 - 3fff0]
[    0.000000] Reserving 3584 pages of KVA for lmem_map of node 0 at 3f000
[    0.000000] remove_active_range (0, 258048, 261632)
[    0.000000] Reserving total of e00 pages for numa KVA remap
[    0.000000] kva_start_pfn ~ 36600 max_low_pfn ~ 375fe
[    0.000000] max_pfn =3D 3fff0
[    0.000000] 137MB HIGHMEM available.
[    0.000000] 885MB LOWMEM available.
[    0.000000] max_low_pfn =3D 375fe, highstart_pfn =3D 375fe
[    0.000000] Low memory ends at vaddr f75fe000
[    0.000000] node 0 will remap to vaddr f6600000 - f7400000
[    0.000000] allocate_pgdat: node 0 NODE_DATA f6600000
[    0.000000] remap_numa_kva: node 0
[    0.000000] remap_numa_kva: f6600000 to pfn 0003f000
[    0.000000] remap_numa_kva: f6800000 to pfn 0003f200
[    0.000000] remap_numa_kva: f6a00000 to pfn 0003f400
[    0.000000] remap_numa_kva: f6c00000 to pfn 0003f600
[    0.000000] remap_numa_kva: f6e00000 to pfn 0003f800
[    0.000000] remap_numa_kva: f7000000 to pfn 0003fa00
[    0.000000] remap_numa_kva: f7200000 to pfn 0003fc00
[    0.000000] High memory starts at vaddr f75fe000
[    0.000000]   mapped low ram: 0 - 375fe000
[    0.000000]   low ram: 0 - 375fe000
[    0.000000]   node 0 low ram: 00000000 - 375fe000
[    0.000000]   node 0 bootmap 00014000 - 0001aec0
[    0.000000] (10 early reservations) =3D=3D> bootmem [0000000000 - 00375f=
e000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page =3D=3D> [000=
0000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE =3D=3D> [000=
0001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE =3D=3D> [000=
0006000 - 0000007000]
[    0.000000]   #3 [0001000000 - 00023a972c]    TEXT DATA BSS =3D=3D> [000=
1000000 - 00023a972c]
[    0.000000]   #4 [000009f800 - 0000100000]    BIOS reserved =3D=3D> [000=
009f800 - 0000100000]
[    0.000000]   #5 [00023aa000 - 00023be149]              BRK =3D=3D> [000=
23aa000 - 00023be149]
[    0.000000]   #6 [0000010000 - 0000014000]          PGTABLE =3D=3D> [000=
0010000 - 0000014000]
[    0.000000]   #7 [003f000000 - 003fe00000]          KVA RAM
[    0.000000]   #8 [0036600000 - 0037400000]           KVA PG =3D=3D> [003=
6600000 - 0037400000]
[    0.000000]   #9 [0000014000 - 000001b000]          BOOTMAP =3D=3D> [000=
0014000 - 000001b000]
[    0.000000] Scan SMP from c0000000 for 1024 bytes.
[    0.000000] Scan SMP from c009fc00 for 1024 bytes.
[    0.000000] Scan SMP from c00f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [c00f5680] f5680
[    0.000000]   mpc: f1400-f152c
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000375fe
[    0.000000]   HighMem  0x000375fe -> 0x0003fff0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003f000
[    0.000000]     0: 0x0003fe00 -> 0x0003fff0
[    0.000000] On node 0 totalpages: 258431
[    0.000000] free_area_init_node: node 0, pgdat f6600000, node_mem_map f6=
602340
[    0.000000]   DMA zone: 52 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3931 pages, LIFO batch:0
[    0.000000]   Normal zone: 2828 pages used for memmap
[    0.000000]   Normal zone: 219890 pages, LIFO batch:31
[    0.000000]   HighMem zone: 449 pages used for memmap
[    0.000000]   HighMem zone: 31281 pages, LIFO batch:7
[    0.000000] Using APIC driver default
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]     Virtual Wire compatibility mode.
[    0.000000]   mpc: f1400-f152c
[    0.000000] MPTABLE: OEM ID: OEM00000
[    0.000000] MPTABLE: Product ID: PROD00000000
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] Warning! Not a NUMA-Q system!
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] Processor #1
[    0.000000] Bus #0 is PCI  =20
[    0.000000] Bus #1 is PCI  =20
[    0.000000] Bus #2 is PCI  =20
[    0.000000] Bus #3 is PCI  =20
[    0.000000] Bus #4 is PCI  =20
[    0.000000] Bus #5 is PCI  =20
[    0.000000] Bus #6 is ISA  =20
[    0.000000] I/O APIC #2 Version 17 at 0xFEC00000.
[    0.000000] Int: type 0, pol 3, trig 3, bus 00, IRQ 28, APIC ID 2, APIC =
INT 0b
[    0.000000] Int: type 0, pol 3, trig 3, bus 00, IRQ 10, APIC ID 2, APIC =
INT 03
[    0.000000] Int: type 0, pol 3, trig 3, bus 01, IRQ 00, APIC ID 2, APIC =
INT 05
[    0.000000] Int: type 0, pol 3, trig 3, bus 05, IRQ 1c, APIC ID 2, APIC =
INT 0b
[    0.000000] Int: type 3, pol 0, trig 0, bus 06, IRQ 00, APIC ID 2, APIC =
INT 00
[    0.000000] Int: type 0, pol 0, trig 0, bus 06, IRQ 01, APIC ID 2, APIC =
INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 06, IRQ 00, APIC ID 2, APIC =
INT 02
[    0.000000] Int: type 0, pol 0, trig 0, bus 06, IRQ 04, APIC ID 2, APIC =
INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 06, IRQ 06, APIC ID 2, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 06, IRQ 07, APIC ID 2, APIC =
INT 07
[    0.000000] Int: type 0, pol 1, trig 1, bus 06, IRQ 08, APIC ID 2, APIC =
INT 08
[    0.000000] Int: type 0, pol 0, trig 0, bus 06, IRQ 09, APIC ID 2, APIC =
INT 09
[    0.000000] Int: type 0, pol 0, trig 0, bus 06, IRQ 0a, APIC ID 2, APIC =
INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 06, IRQ 0c, APIC ID 2, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 06, IRQ 0d, APIC ID 2, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 06, IRQ 0e, APIC ID 2, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 06, IRQ 0f, APIC ID 2, APIC =
INT 0f
[    0.000000] Lint: type 3, pol 0, trig 0, bus 00, IRQ 00, APIC ID ff, API=
C LINT 00
[    0.000000] Lint: type 1, pol 0, trig 0, bus 00, IRQ 00, APIC ID ff, API=
C LINT 01
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Processors: 2
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] nr_irqs_gsi: 24
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 40000000=
:a0000000)
[    0.000000] NR_CPUS:32 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:16
[    0.000000] PERCPU: Embedded 16 pages/cpu @c2400000 s44828 r0 d20708 u10=
48576
[    0.000000] pcpu-alloc: s44828 r0 d20708 u1048576 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 255102
[    0.000000] Policy zone: HighMem
[    0.000000] Kernel command line: root=3D/dev/sda1 earlyprintk=3Dserial,t=
tyS0,115200,keep console=3Dtty debug initcall_debug enforcing=3D0 apic=3Dve=
rbose ignore_loglevel sysrq_always_enabled selinux=3D0 nmi_watchdog=3D0 3 p=
anic=3D1 3
[    0.000000] debug: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 by=
tes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 byte=
s)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] allocated 5242240 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] Initializing HighMem for node 0 (000375fe:0003fff0)
[    0.000000] Memory: 993052k/1048512k available (8407k kernel code, 40672=
k reserved, 4237k data, 504k init, 126920k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffad3000 - 0xfffff000   (5296 kB)
[    0.000000]     pkmap   : 0xff600000 - 0xff800000   (2048 kB)
[    0.000000]     vmalloc : 0xf7dfe000 - 0xff5fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf75fe000   ( 885 MB)
[    0.000000]       .init : 0xc1c5a000 - 0xc1cd8000   ( 504 kB)
[    0.000000]       .data : 0xc1835cf8 - 0xc1c59324   (4237 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1835cf8   (8407 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: Genslabs=3D14, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D2, Nodes=3D16
[    0.000000] Experimental preemptable hierarchical RCU implementation.
[    0.000000] NR_IRQS:2304 nr_irqs:424
[    0.000000] CPU 0 irqstacks, hard=3Dc2400000 soft=3Dc2401000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2010.383 MHz processor.
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3567 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:             |  ok  |     =
        |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |     =
        |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |     =
        |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |     =
        |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 218 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.001999] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 4020.76 BogoMIPS (lpj=3D2010383)
[    0.003271] Security Framework initialized
[    0.004015] TOMOYO Linux initialized
[    0.005295] Mount-cache hash table entries: 512
[    0.009554] Initializing cgroup subsys debug
[    0.010017] Initializing cgroup subsys cpuacct
[    0.011026] Initializing cgroup subsys memory
[    0.012288] Initializing cgroup subsys devices
[    0.013019] Initializing cgroup subsys freezer
[    0.014012] Initializing cgroup subsys net_cls
[    0.015095] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[    0.016007] CPU: L2 Cache: 512K (64 bytes/line)
[    0.017005] CPU: Physical Processor ID: 0
[    0.018005] CPU: Processor Core ID: 0
[    0.019007] mce: CPU supports 5 MCE banks
[    0.020025] Performance Counters: AMD PMU driver.
[    0.022016] ... version:                 0
[    0.023005] ... bit width:               48
[    0.024004] ... generic counters:        4
[    0.025005] ... value mask:              0000ffffffffffff
[    0.026005] ... max period:              00007fffffffffff
[    0.027005] ... fixed-purpose counters:  0
[    0.028005] ... counter mask:            000000000000000f
[    0.029015] Checking 'hlt' instruction... OK.
[    0.035008] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.036010] ftrace: allocating 29667 entries in 59 pages
[    0.040342] enabled ExtINT on CPU#0
[    0.041067] ExtINT not setup in hardware but reported by MP table
[    0.042108] Mapping cpu 0 to node 0
[    0.043006] ENABLING IO-APIC IRQs
[    0.044005] init IO_APIC IRQs
[    0.045006]  2-0 (apicid-pin) not connected
[    0.047135] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0)
[    0.048040] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0)
[    0.049071] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:1 Ac=
tive:1)
[    0.049999] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0)
[    0.049999] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:1)
[    0.049999] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0)
[    0.049999] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0)
[    0.049999] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0)
[    0.049999] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:0 Ac=
tive:0)
[    0.049999] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 =
Active:0)
[    0.049999] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:1)
[    0.049999] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0)
[    0.049999] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0)
[    0.049999] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0)
[    0.049999] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0)
[    0.049999]  2-16 2-17 2-18 2-19 2-20 2-21 2-22 2-23 (apicid-pin) not co=
nnected
[    0.049999] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D0 pin2=3D0
[    0.049999] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[    0.049999] ...trying to set up timer (IRQ0) through the 8259A ...
[    0.049999] ..... (found apic 0 pin 0) ...
[    0.060840] ....... works.
[    0.061004] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ steppin=
g 02
[    0.064004] Using local APIC timer interrupts.
[    0.064006] calibrating APIC timer ...
[    0.065999] ... lapic delta =3D 1256244
[    0.065999] ..... delta 1256244
[    0.065999] ..... mult: 53963471
[    0.065999] ..... calibration result: 200999
[    0.065999] ..... CPU clock speed is 2009.0990 MHz.
[    0.065999] ..... host bus clock speed is 200.0999 MHz.
[    0.065999] ... verify APIC timer
[    0.168485] ... jiffies delta =3D 100
[    0.169004] ... jiffies result ok
[    0.170030] calling  migration_init+0x0/0x67 @ 1
[    0.171377] initcall migration_init+0x0/0x67 returned 0 after 0 usecs
[    0.172007] calling  spawn_ksoftirqd+0x0/0x67 @ 1
[    0.174112] initcall spawn_ksoftirqd+0x0/0x67 returned 0 after 976 usecs
[    0.175009] calling  init_call_single_data+0x0/0xd0 @ 1
[    0.176016] initcall init_call_single_data+0x0/0xd0 returned 0 after 0 u=
secs
[    0.177007] calling  spawn_softlockup_task+0x0/0x7f @ 1
[    0.178138] initcall spawn_softlockup_task+0x0/0x7f returned 0 after 0 u=
secs
[    0.179007] calling  tracer_alloc_buffers+0x0/0x2bf @ 1
[    0.180287] Testing tracer nop: PASSED
[    0.182011] initcall tracer_alloc_buffers+0x0/0x2bf returned 0 after 195=
3 usecs
[    0.183006] calling  init_trace_printk+0x0/0x2e @ 1
[    0.184007] initcall init_trace_printk+0x0/0x2e returned 0 after 0 usecs
[    0.185773] lockdep: fixing up alternatives.
[    0.186355] CPU 1 irqstacks, hard=3Dc2500000 soft=3Dc2501000
[    0.187011] Booting processor 1 APIC 0x1 ip 0x6000
[    0.001999] Initializing CPU#1
[    0.001999] masked ExtINT on CPU#1
[    0.001999] Mapping cpu 1 to node 0
[    0.001999] Calibrating delay using timer specific routine.. 4019.90 Bog=
oMIPS (lpj=3D2009954)
[    0.001999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/=
line)
[    0.001999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.001999] CPU: Physical Processor ID: 0
[    0.001999] CPU: Processor Core ID: 1
[    0.001999] mce: CPU supports 5 MCE banks
[    0.259060] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ steppin=
g 02
[    0.262078] Brought up 2 CPUs
[    0.263006] Total of 2 processors activated (8040.67 BogoMIPS).
[    0.265652] CPU0 attaching sched-domain:
[    0.266018]  domain 0: span 0-1 level MC
[    0.268005]   groups: 0 1
[    0.269517]   domain 1: span 0-1 level NODE
[    0.271005]    groups: 0-1 (cpu_power =3D 2048)
[    0.273251] CPU1 attaching sched-domain:
[    0.274050]  domain 0: span 0-1 level MC
[    0.276005]   groups: 1 0
[    0.277517]   domain 1: span 0-1 level NODE
[    0.279005]    groups: 0-1 (cpu_power =3D 2048)
[    0.283915] devtmpfs: initialized
[    0.287317] device: 'platform': device_add
[    0.293316] khelper used greatest stack depth: 2676 bytes left
[    0.298148] bus: 'platform': registered
[    0.298181] Registering sysdev class 'cpu'
[    0.308106] calling  init_mmap_min_addr+0x0/0x30 @ 1
[    0.310047] initcall init_mmap_min_addr+0x0/0x30 returned 0 after 0 usecs
[    0.311009] calling  net_ns_init+0x0/0xe7 @ 1
[    0.312340] initcall net_ns_init+0x0/0xe7 returned 0 after 0 usecs
[    0.313010] calling  pci_reboot_init+0x0/0x30 @ 1
[    0.314011] initcall pci_reboot_init+0x0/0x30 returned 0 after 0 usecs
[    0.315007] calling  reboot_init+0x0/0x30 @ 1
[    0.316013] initcall reboot_init+0x0/0x30 returned 0 after 0 usecs
[    0.317008] calling  init_smp_flush+0x0/0x4f @ 1
[    0.318009] initcall init_smp_flush+0x0/0x4f returned 0 after 0 usecs
[    0.319007] calling  sysctl_init+0x0/0x30 @ 1
[    0.320010] initcall sysctl_init+0x0/0x30 returned 0 after 0 usecs
[    0.321007] calling  ksysfs_init+0x0/0xb6 @ 1
[    0.322517] initcall ksysfs_init+0x0/0xb6 returned 0 after 0 usecs
[    0.323008] calling  async_init+0x0/0x6f @ 1
[    0.325038] initcall async_init+0x0/0x6f returned 0 after 976 usecs
[    0.326007] calling  init_jiffies_clocksource+0x0/0x2e @ 1
[    0.327027] initcall init_jiffies_clocksource+0x0/0x2e returned 0 after =
0 usecs
[    0.328006] calling  filelock_init+0x0/0x46 @ 1
[    0.329018] initcall filelock_init+0x0/0x46 returned 0 after 0 usecs
[    0.330006] calling  init_script_binfmt+0x0/0x30 @ 1
[    0.331035] initcall init_script_binfmt+0x0/0x30 returned 0 after 0 usecs
[    0.332006] calling  init_elf_binfmt+0x0/0x30 @ 1
[    0.333008] initcall init_elf_binfmt+0x0/0x30 returned 0 after 0 usecs
[    0.334007] calling  debugfs_init+0x0/0x6a @ 1
[    0.335045] initcall debugfs_init+0x0/0x6a returned 0 after 0 usecs
[    0.336007] calling  securityfs_init+0x0/0x61 @ 1
[    0.337044] initcall securityfs_init+0x0/0x61 returned 0 after 0 usecs
[    0.338006] calling  random32_init+0x0/0xf5 @ 1
[    0.339007] initcall random32_init+0x0/0xf5 returned 0 after 0 usecs
[    0.340007] calling  cpuidle_init+0x0/0x52 @ 1
[    0.341043] initcall cpuidle_init+0x0/0x52 returned 0 after 0 usecs
[    0.342006] calling  sock_init+0x0/0x70 @ 1
[    0.343378] initcall sock_init+0x0/0x70 returned 0 after 0 usecs
[    0.344008] calling  net_inuse_init+0x0/0x3e @ 1
[    0.345034] initcall net_inuse_init+0x0/0x3e returned 0 after 0 usecs
[    0.346006] calling  netpoll_init+0x0/0x58 @ 1
[    0.347006] initcall netpoll_init+0x0/0x58 returned 0 after 0 usecs
[    0.348006] calling  netlink_proto_init+0x0/0x197 @ 1
[    0.349236] NET: Registered protocol family 16
[    0.350172] initcall netlink_proto_init+0x0/0x197 returned 0 after 976 u=
secs
[    0.351008] calling  bdi_class_init+0x0/0x52 @ 1
[    0.352011] device class 'bdi': registering
[    0.354371] initcall bdi_class_init+0x0/0x52 returned 0 after 1953 usecs
[    0.355007] calling  kobject_uevent_init+0x0/0x6d @ 1
[    0.356039] initcall kobject_uevent_init+0x0/0x6d returned 0 after 0 use=
cs
[    0.357008] calling  gpiolib_sysfs_init+0x0/0x93 @ 1
[    0.358005] device class 'gpio': registering
[    0.359452] initcall gpiolib_sysfs_init+0x0/0x93 returned 0 after 976 us=
ecs
[    0.360009] calling  pcibus_class_init+0x0/0x33 @ 1
[    0.361007] device class 'pci_bus': registering
[    0.363145] initcall pcibus_class_init+0x0/0x33 returned 0 after 1953 us=
ecs
[    0.364010] calling  pci_driver_init+0x0/0x2e @ 1
[    0.366176] bus: 'pci': registered
[    0.367008] initcall pci_driver_init+0x0/0x2e returned 0 after 1953 usecs
[    0.368008] calling  backlight_class_init+0x0/0x6a @ 1
[    0.369015] device class 'backlight': registering
[    0.370389] initcall backlight_class_init+0x0/0x6a returned 0 after 976 =
usecs
[    0.371008] calling  video_output_class_init+0x0/0x33 @ 1
[    0.372008] device class 'video_output': registering
[    0.374181] initcall video_output_class_init+0x0/0x33 returned 0 after 1=
953 usecs
[    0.375010] calling  tty_class_init+0x0/0x49 @ 1
[    0.376015] device class 'tty': registering
[    0.377388] initcall tty_class_init+0x0/0x49 returned 0 after 976 usecs
[    0.378008] calling  vtconsole_class_init+0x0/0xbe @ 1
[    0.379016] device class 'vtconsole': registering
[    0.380410] device: 'vtcon0': device_add
[    0.381679] initcall vtconsole_class_init+0x0/0xbe returned 0 after 1953=
 usecs
[    0.382011] calling  register_node_type+0x0/0x5a @ 1
[    0.383009] Registering sysdev class 'node'
[    0.384426] initcall register_node_type+0x0/0x5a returned 0 after 976 us=
ecs
[    0.385008] calling  spi_init+0x0/0xec @ 1
[    0.387085] bus: 'spi': registered
[    0.388006] device class 'spi_master': registering
[    0.389435] initcall spi_init+0x0/0xec returned 0 after 2929 usecs
[    0.390009] calling  i2c_init+0x0/0x74 @ 1
[    0.392243] bus: 'i2c': registered
[    0.393007] device class 'i2c-adapter': registering
[    0.394389] bus: 'i2c': add driver dummy
[    0.396101] initcall i2c_init+0x0/0x74 returned 0 after 4882 usecs
[    0.397009] calling  amd_postcore_init+0x0/0xba @ 1
[    0.398008] initcall amd_postcore_init+0x0/0xba returned 0 after 0 usecs
[    0.399009] calling  arch_kdebugfs_init+0x0/0x3d @ 1
[    0.400035] initcall arch_kdebugfs_init+0x0/0x3d returned 0 after 0 usecs
[    0.401007] calling  init_pit_clocksource+0x0/0xab @ 1
[    0.402007] initcall init_pit_clocksource+0x0/0xab returned 0 after 0 us=
ecs
[    0.403007] calling  kdump_buf_page_init+0x0/0xb0 @ 1
[    0.404014] initcall kdump_buf_page_init+0x0/0xb0 returned 0 after 0 use=
cs
[    0.405007] calling  dmi_id_init+0x0/0x2f9 @ 1
[    0.406006] device class 'dmi': registering
[    0.407411] device: 'id': device_add
[    0.409261] initcall dmi_id_init+0x0/0x2f9 returned 0 after 2929 usecs
[    0.410010] calling  init_cyclone_clocksource+0x0/0x199 @ 1
[    0.411017] initcall init_cyclone_clocksource+0x0/0x199 returned -19 aft=
er 0 usecs
[    0.412009] calling  pci_arch_init+0x0/0x57 @ 1
[    0.413018] PCI: Using configuration type 1 for base access
[    0.414017] initcall pci_arch_init+0x0/0x57 returned 0 after 976 usecs
[    0.415007] calling  topology_init+0x0/0xc8 @ 1
[    0.416006] Registering sys device of class 'node'
[    0.417037] Registering sys device 'node0'
[    0.419128] Registering sys device of class 'cpu'
[    0.420038] Registering sys device 'cpu0'
[    0.422088] Registering sys device of class 'cpu'
[    0.423040] Registering sys device 'cpu1'
[    0.425067] initcall topology_init+0x0/0xc8 returned 0 after 8789 usecs
[    0.426011] calling  mca_init+0x0/0x426 @ 1
[    0.428241] bus: 'MCA': registered
[    0.429011] initcall mca_init+0x0/0x426 returned -19 after 1953 usecs
[    0.430009] calling  param_sysfs_init+0x0/0x216 @ 1
[    0.434051] khelper used greatest stack depth: 2428 bytes left
[    0.570616] initcall param_sysfs_init+0x0/0x216 returned 0 after 135742 =
usecs
[    0.571149] calling  pm_sysrq_init+0x0/0x37 @ 1
[    0.572123] initcall pm_sysrq_init+0x0/0x37 returned 0 after 0 usecs
[    0.573050] calling  audit_watch_init+0x0/0x46 @ 1
[    0.574047] initcall audit_watch_init+0x0/0x46 returned 0 after 0 usecs
[    0.575018] calling  default_bdi_init+0x0/0xc3 @ 1
[    0.576185] device: 'default': device_add
[    0.578636] initcall default_bdi_init+0x0/0xc3 returned 0 after 1953 use=
cs
[    0.579010] calling  init_bio+0x0/0x12b @ 1
[    0.581044] bio: create slab <bio-0> at 0
[    0.583115] initcall init_bio+0x0/0x12b returned 0 after 2929 usecs
[    0.584007] calling  fsnotify_init+0x0/0x2e @ 1
[    0.585010] initcall fsnotify_init+0x0/0x2e returned 0 after 0 usecs
[    0.586007] calling  fsnotify_notification_init+0x0/0x106 @ 1
[    0.587028] initcall fsnotify_notification_init+0x0/0x106 returned 0 aft=
er 0 usecs
[    0.588006] calling  cryptomgr_init+0x0/0x2e @ 1
[    0.589007] initcall cryptomgr_init+0x0/0x2e returned 0 after 0 usecs
[    0.590006] calling  blk_settings_init+0x0/0x3c @ 1
[    0.591006] initcall blk_settings_init+0x0/0x3c returned 0 after 0 usecs
[    0.592006] calling  blk_ioc_init+0x0/0x43 @ 1
[    0.593016] initcall blk_ioc_init+0x0/0x43 returned 0 after 0 usecs
[    0.594006] calling  blk_softirq_init+0x0/0xad @ 1
[    0.595009] initcall blk_softirq_init+0x0/0xad returned 0 after 0 usecs
[    0.596006] calling  blk_iopoll_setup+0x0/0xad @ 1
[    0.597007] initcall blk_iopoll_setup+0x0/0xad returned 0 after 0 usecs
[    0.598006] calling  genhd_device_init+0x0/0x81 @ 1
[    0.599005] device class 'block': registering
[    0.601272] initcall genhd_device_init+0x0/0x81 returned 0 after 1953 us=
ecs
[    0.602009] calling  blk_dev_integrity_init+0x0/0x43 @ 1
[    0.603020] initcall blk_dev_integrity_init+0x0/0x43 returned 0 after 0 =
usecs
[    0.604007] calling  gpiolib_debugfs_init+0x0/0x3e @ 1
[    0.605061] initcall gpiolib_debugfs_init+0x0/0x3e returned 0 after 0 us=
ecs
[    0.606006] calling  pcf857x_init+0x0/0x2e @ 1
[    0.607007] bus: 'i2c': add driver pcf857x
[    0.608427] initcall pcf857x_init+0x0/0x2e returned 0 after 976 usecs
[    0.609009] calling  pci_slot_init+0x0/0x5f @ 1
[    0.610052] initcall pci_slot_init+0x0/0x5f returned 0 after 0 usecs
[    0.611007] calling  misc_init+0x0/0xba @ 1
[    0.612040] device class 'misc': registering
[    0.613471] initcall misc_init+0x0/0xba returned 0 after 976 usecs
[    0.614010] calling  vga_arb_device_init+0x0/0x87 @ 1
[    0.615116] device: 'vga_arbiter': device_add
[    0.617393] vgaarb: loaded
[    0.618013] initcall vga_arb_device_init+0x0/0x87 returned 0 after 2929 =
usecs
[    0.619011] calling  cn_init+0x0/0xef @ 1
[    0.620130] initcall cn_init+0x0/0xef returned 0 after 0 usecs
[    0.621008] calling  tifm_init+0x0/0x94 @ 1
[    0.622630] bus: 'tifm': registered
[    0.623008] device class 'tifm_adapter': registering
[    0.624393] initcall tifm_init+0x0/0x94 returned 0 after 1953 usecs
[    0.625009] calling  tps_init+0x0/0xbf @ 1
[    0.626008] tps65010: version 2 May 2005
[    0.627006] bus: 'i2c': add driver tps65010
[    0.629338] bus: 'i2c': remove driver tps65010
[    0.631068] driver: 'tps65010': driver_release
[    0.643013] bus: 'i2c': add driver tps65010
[    0.644454] bus: 'i2c': remove driver tps65010
[    0.646273] driver: 'tps65010': driver_release
[    0.658012] bus: 'i2c': add driver tps65010
[    0.659440] bus: 'i2c': remove driver tps65010
[    0.661259] driver: 'tps65010': driver_release
[    0.662016] tps65010: no chip?
[    0.663010] initcall tps_init+0x0/0xbf returned -19 after 36132 usecs
[    0.664011] calling  twl4030_init+0x0/0x2e @ 1
[    0.665006] bus: 'i2c': add driver twl4030
[    0.666423] initcall twl4030_init+0x0/0x2e returned 0 after 976 usecs
[    0.667010] calling  da903x_init+0x0/0x2e @ 1
[    0.668009] bus: 'i2c': add driver da903x
[    0.670061] initcall da903x_init+0x0/0x2e returned 0 after 1953 usecs
[    0.671010] calling  pcf50633_init+0x0/0x2e @ 1
[    0.672008] bus: 'i2c': add driver pcf50633
[    0.673423] initcall pcf50633_init+0x0/0x2e returned 0 after 976 usecs
[    0.674008] calling  init_scsi+0x0/0xa8 @ 1
[    0.676499] device class 'scsi_host': registering
[    0.677865] bus: 'scsi': registered
[    0.678008] device class 'scsi_device': registering
[    0.679479] SCSI subsystem initialized
[    0.680011] initcall init_scsi+0x0/0xa8 returned 0 after 4882 usecs
[    0.681009] calling  ata_init+0x0/0x2df @ 1
[    0.683186] libata version 3.00 loaded.
[    0.684008] initcall ata_init+0x0/0x2df returned 0 after 1953 usecs
[    0.685007] calling  phy_init+0x0/0x49 @ 1
[    0.686005] device class 'mdio_bus': registering
[    0.688751] bus: 'mdio_bus': registered
[    0.689010] bus: 'mdio_bus': add driver Generic PHY
[    0.690433] initcall phy_init+0x0/0x49 returned 0 after 3906 usecs
[    0.691009] calling  usb_init+0x0/0x16b @ 1
[    0.692551] bus: 'usb': registered
[    0.693044] bus: 'usb': add driver usbfs
[    0.695307] usbcore: registered new interface driver usbfs
[    0.696063] bus: 'usb': add driver hub
[    0.697486] usbcore: registered new interface driver hub
[    0.698150] bus: 'usb': add driver usb
[    0.700368] usbcore: registered new device driver usb
[    0.701010] initcall usb_init+0x0/0x16b returned 0 after 8789 usecs
[    0.702009] calling  serio_init+0x0/0x92 @ 1
[    0.704307] bus: 'serio': registered
[    0.705136] initcall serio_init+0x0/0x92 returned 0 after 1953 usecs
[    0.706010] calling  input_init+0x0/0x130 @ 1
[    0.707005] device class 'input': registering
[    0.709338] initcall input_init+0x0/0x130 returned 0 after 1953 usecs
[    0.710009] calling  init_dvbdev+0x0/0xda @ 1
[    0.711030] device class 'dvb': registering
[    0.712421] initcall init_dvbdev+0x0/0xda returned 0 after 976 usecs
[    0.713010] calling  power_supply_class_init+0x0/0x4c @ 1
[    0.714016] device class 'power_supply': registering
[    0.715396] initcall power_supply_class_init+0x0/0x4c returned 0 after 9=
76 usecs
[    0.716008] calling  hwmon_init+0x0/0x104 @ 1
[    0.717019] device class 'hwmon': registering
[    0.718392] initcall hwmon_init+0x0/0x104 returned 0 after 976 usecs
[    0.719008] calling  md_init+0x0/0xd3 @ 1
[    0.720077] initcall md_init+0x0/0xd3 returned 0 after 0 usecs
[    0.722006] calling  pci_subsys_init+0x0/0x10d @ 1
[    0.723006] PCI: Probing PCI hardware
[    0.724049] PCI: Probing PCI hardware (bus 00)
[    0.725059] device: 'pci0000:00': device_add
[    0.726063] device: '0000:00': device_add
[    0.727592] PCI: Scanning bus 0000:00
[    0.728096] pci 0000:00:00.0: found [10de:005e] class 000580 header type=
 00
[    0.729072] pci 0000:00:00.0: calling quirk_resource_alignment+0x0/0x1d0
[    0.730107] pci 0000:00:01.0: found [10de:0050] class 000601 header type=
 00
[    0.731044] pci 0000:00:01.0: calling quirk_resource_alignment+0x0/0x1d0
[    0.732042] pci 0000:00:01.1: found [10de:0052] class 000c05 header type=
 00
[    0.733023] pci 0000:00:01.1: reg 10 io port: [0xdc00-0xdc1f]
[    0.734023] pci 0000:00:01.1: reg 20 io port: [0x4c00-0x4c3f]
[    0.735011] pci 0000:00:01.1: reg 24 io port: [0x4c40-0x4c7f]
[    0.736015] pci 0000:00:01.1: calling quirk_resource_alignment+0x0/0x1d0
[    0.737021] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    0.738008] pci 0000:00:01.1: PME# disabled
[    0.739051] pci 0000:00:02.0: found [10de:005a] class 000c03 header type=
 00
[    0.740022] pci 0000:00:02.0: reg 10 32bit mmio: [0xda102000-0xda102fff]
[    0.741036] pci 0000:00:02.0: calling quirk_resource_alignment+0x0/0x1d0
[    0.742019] pci 0000:00:02.0: supports D1 D2
[    0.743005] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.744007] pci 0000:00:02.0: PME# disabled
[    0.745043] pci 0000:00:02.1: found [10de:005b] class 000c03 header type=
 00
[    0.746031] pci 0000:00:02.1: reg 10 32bit mmio: [0xfeb00000-0xfeb000ff]
[    0.747036] pci 0000:00:02.1: calling quirk_resource_alignment+0x0/0x1d0
[    0.748027] pci 0000:00:02.1: supports D1 D2
[    0.749005] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.750008] pci 0000:00:02.1: PME# disabled
[    0.751053] pci 0000:00:04.0: found [10de:0059] class 000401 header type=
 00
[    0.752022] pci 0000:00:04.0: reg 10 io port: [0xd400-0xd4ff]
[    0.753010] pci 0000:00:04.0: reg 14 io port: [0xd800-0xd8ff]
[    0.754010] pci 0000:00:04.0: reg 18 32bit mmio: [0xda101000-0xda101fff]
[    0.755027] pci 0000:00:04.0: calling quirk_resource_alignment+0x0/0x1d0
[    0.756019] pci 0000:00:04.0: supports D1 D2
[    0.757040] pci 0000:00:06.0: found [10de:0053] class 000101 header type=
 00
[    0.758038] pci 0000:00:06.0: reg 20 io port: [0xf000-0xf00f]
[    0.759020] pci 0000:00:06.0: calling quirk_resource_alignment+0x0/0x1d0
[    0.760052] pci 0000:00:09.0: found [10de:005c] class 000604 header type=
 01
[    0.761025] pci 0000:00:09.0: calling quirk_resource_alignment+0x0/0x1d0
[    0.762039] pci 0000:00:0a.0: found [10de:0057] class 000680 header type=
 00
[    0.763022] pci 0000:00:0a.0: reg 10 32bit mmio: [0xda100000-0xda100fff]
[    0.764010] pci 0000:00:0a.0: reg 14 io port: [0xd000-0xd007]
[    0.765031] pci 0000:00:0a.0: calling quirk_resource_alignment+0x0/0x1d0
[    0.766019] pci 0000:00:0a.0: supports D1 D2
[    0.767005] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.768007] pci 0000:00:0a.0: PME# disabled
[    0.769044] pci 0000:00:0b.0: found [10de:005d] class 000604 header type=
 01
[    0.770043] pci 0000:00:0b.0: calling quirk_resource_alignment+0x0/0x1d0
[    0.771040] pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.772007] pci 0000:00:0b.0: PME# disabled
[    0.773051] pci 0000:00:0c.0: found [10de:005d] class 000604 header type=
 01
[    0.774043] pci 0000:00:0c.0: calling quirk_resource_alignment+0x0/0x1d0
[    0.775039] pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.776007] pci 0000:00:0c.0: PME# disabled
[    0.777050] pci 0000:00:0d.0: found [10de:005d] class 000604 header type=
 01
[    0.779007] pci 0000:00:0d.0: calling quirk_resource_alignment+0x0/0x1d0
[    0.780040] pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.781007] pci 0000:00:0d.0: PME# disabled
[    0.782051] pci 0000:00:0e.0: found [10de:005d] class 000604 header type=
 01
[    0.783042] pci 0000:00:0e.0: calling quirk_resource_alignment+0x0/0x1d0
[    0.785036] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.786007] pci 0000:00:0e.0: PME# disabled
[    0.787059] pci 0000:00:18.0: found [1022:1100] class 000600 header type=
 00
[    0.788037] pci 0000:00:18.0: calling quirk_resource_alignment+0x0/0x1d0
[    0.789049] pci 0000:00:18.1: found [1022:1101] class 000600 header type=
 00
[    0.790038] pci 0000:00:18.1: calling quirk_resource_alignment+0x0/0x1d0
[    0.791040] pci 0000:00:18.2: found [1022:1102] class 000600 header type=
 00
[    0.792038] pci 0000:00:18.2: calling quirk_resource_alignment+0x0/0x1d0
[    0.793034] pci 0000:00:18.3: found [1022:1103] class 000600 header type=
 00
[    0.794038] pci 0000:00:18.3: calling quirk_resource_alignment+0x0/0x1d0
[    0.795028] PCI: Fixups for bus 0000:00
[    0.796007] pci 0000:00:09.0: scanning behind bridge, config 050500, pas=
s 0
[    0.797028] PCI: Scanning bus 0000:05
[    0.798051] pci 0000:05:07.0: found [10ec:8139] class 000200 header type=
 00
[    0.799028] pci 0000:05:07.0: reg 10 io port: [0xc000-0xc0ff]
[    0.800012] pci 0000:05:07.0: reg 14 32bit mmio: [0xda000000-0xda0000ff]
[    0.801039] pci 0000:05:07.0: calling quirk_resource_alignment+0x0/0x1d0
[    0.802023] pci 0000:05:07.0: supports D1 D2
[    0.803005] pci 0000:05:07.0: PME# supported from D1 D2 D3hot
[    0.804008] pci 0000:05:07.0: PME# disabled
[    0.805054] PCI: Fixups for bus 0000:05
[    0.806005] pci 0000:00:09.0: transparent bridge
[    0.807008] pci 0000:00:09.0: bridge io port: [0xc000-0xcfff]
[    0.808008] pci 0000:00:09.0: bridge 32bit mmio: [0xda000000-0xda0fffff]
[    0.809010] PCI: Bus scan for 0000:05 returning with max=3D05
[    0.810009] pci 0000:00:0b.0: scanning behind bridge, config 040400, pas=
s 0
[    0.812019] PCI: Scanning bus 0000:04
[    0.813062] PCI: Fixups for bus 0000:04
[    0.814016] PCI: Bus scan for 0000:04 returning with max=3D04
[    0.815008] pci 0000:00:0c.0: scanning behind bridge, config 030300, pas=
s 0
[    0.816027] PCI: Scanning bus 0000:03
[    0.817062] PCI: Fixups for bus 0000:03
[    0.818016] PCI: Bus scan for 0000:03 returning with max=3D03
[    0.819008] pci 0000:00:0d.0: scanning behind bridge, config 020200, pas=
s 0
[    0.820027] PCI: Scanning bus 0000:02
[    0.821064] PCI: Fixups for bus 0000:02
[    0.822016] PCI: Bus scan for 0000:02 returning with max=3D02
[    0.823008] pci 0000:00:0e.0: scanning behind bridge, config 010100, pas=
s 0
[    0.824026] PCI: Scanning bus 0000:01
[    0.825041] pci 0000:01:00.0: found [1002:5b60] class 000300 header type=
 00
[    0.826014] pci 0000:01:00.0: calling quirk_no_ata_d3+0x0/0x40
[    0.827143] pci 0000:01:00.0: reg 10 32bit mmio pref: [0xd0000000-0xd7ff=
ffff]
[    0.828011] pci 0000:01:00.0: reg 14 io port: [0xb000-0xb0ff]
[    0.829011] pci 0000:01:00.0: reg 18 32bit mmio: [0xd9000000-0xd900ffff]
[    0.830027] pci 0000:01:00.0: reg 30 32bit mmio pref: [0x000000-0x01ffff]
[    0.831010] pci 0000:01:00.0: calling quirk_resource_alignment+0x0/0x1d0
[    0.832039] pci 0000:01:00.0: supports D1 D2
[    0.833056] pci 0000:01:00.1: found [1002:5b70] class 000380 header type=
 00
[    0.834014] pci 0000:01:00.1: calling quirk_no_ata_d3+0x0/0x40
[    0.835013] pci 0000:01:00.1: reg 10 32bit mmio: [0xd9010000-0xd901ffff]
[    0.836043] pci 0000:01:00.1: calling quirk_resource_alignment+0x0/0x1d0
[    0.837036] pci 0000:01:00.1: supports D1 D2
[    0.838079] PCI: Fixups for bus 0000:01
[    0.839010] pci 0000:00:0e.0: bridge io port: [0xb000-0xbfff]
[    0.840008] pci 0000:00:0e.0: bridge 32bit mmio: [0xd8000000-0xd9ffffff]
[    0.841010] pci 0000:00:0e.0: bridge 64bit mmio pref: [0xd0000000-0xd7ff=
ffff]
[    0.842005] PCI: Bus scan for 0000:01 returning with max=3D01
[    0.843008] pci 0000:00:09.0: scanning behind bridge, config 050500, pas=
s 1
[    0.844010] pci 0000:00:0b.0: scanning behind bridge, config 040400, pas=
s 1
[    0.845010] pci 0000:00:0c.0: scanning behind bridge, config 030300, pas=
s 1
[    0.846010] pci 0000:00:0d.0: scanning behind bridge, config 020200, pas=
s 1
[    0.847010] pci 0000:00:0e.0: scanning behind bridge, config 010100, pas=
s 1
[    0.848008] PCI: Bus scan for 0000:00 returning with max=3D05
[    0.849013] device: '0000:00:00.0': device_add
[    0.850038] bus: 'pci': add device 0000:00:00.0
[    0.852427] device: '0000:00:01.0': device_add
[    0.853041] bus: 'pci': add device 0000:00:01.0
[    0.854581] device: '0000:00:01.1': device_add
[    0.855039] bus: 'pci': add device 0000:00:01.1
[    0.857314] device: '0000:00:02.0': device_add
[    0.858042] bus: 'pci': add device 0000:00:02.0
[    0.859583] device: '0000:00:02.1': device_add
[    0.860042] bus: 'pci': add device 0000:00:02.1
[    0.862201] device: '0000:00:04.0': device_add
[    0.863041] bus: 'pci': add device 0000:00:04.0
[    0.864614] device: '0000:00:06.0': device_add
[    0.865042] bus: 'pci': add device 0000:00:06.0
[    0.867118] device: '0000:00:09.0': device_add
[    0.868042] bus: 'pci': add device 0000:00:09.0
[    0.870646] device: '0000:00:0a.0': device_add
[    0.872041] bus: 'pci': add device 0000:00:0a.0
[    0.874084] device: '0000:00:0b.0': device_add
[    0.875046] bus: 'pci': add device 0000:00:0b.0
[    0.877529] device: '0000:00:0c.0': device_add
[    0.878043] bus: 'pci': add device 0000:00:0c.0
[    0.879586] device: '0000:00:0d.0': device_add
[    0.880042] bus: 'pci': add device 0000:00:0d.0
[    0.882415] device: '0000:00:0e.0': device_add
[    0.883042] bus: 'pci': add device 0000:00:0e.0
[    0.885028] device: '0000:00:18.0': device_add
[    0.886049] bus: 'pci': add device 0000:00:18.0
[    0.888519] device: '0000:00:18.1': device_add
[    0.889046] bus: 'pci': add device 0000:00:18.1
[    0.890610] device: '0000:00:18.2': device_add
[    0.891042] bus: 'pci': add device 0000:00:18.2
[    0.893432] device: '0000:00:18.3': device_add
[    0.894043] bus: 'pci': add device 0000:00:18.3
[    0.895585] device: '0000:05:07.0': device_add
[    0.896042] bus: 'pci': add device 0000:05:07.0
[    0.898324] device: '0000:05': device_add
[    0.899524] device: '0000:04': device_add
[    0.901221] device: '0000:03': device_add
[    0.902528] device: '0000:02': device_add
[    0.904102] device: '0000:01:00.0': device_add
[    0.905044] bus: 'pci': add device 0000:01:00.0
[    0.907314] vgaarb: device added: PCI:0000:01:00.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.908373] device: '0000:01:00.1': device_add
[    0.909042] bus: 'pci': add device 0000:01:00.1
[    0.911166] device: '0000:01': device_add
[    0.912814] pci 0000:00:00.0: default IRQ router [10de:005e]
[    0.914444] initcall pci_subsys_init+0x0/0x10d returned 0 after 186523 u=
secs
[    0.915012] calling  proto_init+0x0/0x2e @ 1
[    0.916054] initcall proto_init+0x0/0x2e returned 0 after 0 usecs
[    0.917026] calling  net_dev_init+0x0/0x1a4 @ 1
[    0.918076] device class 'net': registering
[    0.919542] device: 'lo': device_add
[    0.921879] initcall net_dev_init+0x0/0x1a4 returned 0 after 2929 usecs
[    0.922011] calling  neigh_init+0x0/0x83 @ 1
[    0.923010] initcall neigh_init+0x0/0x83 returned 0 after 0 usecs
[    0.924006] calling  fib_rules_init+0x0/0xb6 @ 1
[    0.925010] initcall fib_rules_init+0x0/0xb6 returned 0 after 0 usecs
[    0.926006] calling  pktsched_init+0x0/0xd2 @ 1
[    0.927060] initcall pktsched_init+0x0/0xd2 returned 0 after 0 usecs
[    0.928007] calling  tc_filter_init+0x0/0x60 @ 1
[    0.929007] initcall tc_filter_init+0x0/0x60 returned 0 after 0 usecs
[    0.930006] calling  tc_action_init+0x0/0x60 @ 1
[    0.931006] initcall tc_action_init+0x0/0x60 returned 0 after 0 usecs
[    0.932006] calling  genl_init+0x0/0x98 @ 1
[    0.933231] initcall genl_init+0x0/0x98 returned 0 after 0 usecs
[    0.934008] calling  wanrouter_init+0x0/0x61 @ 1
[    0.935008] Sangoma WANPIPE Router v1.1 (c) 1995-2000 Sangoma Technologi=
es Inc.
[    0.936068] initcall wanrouter_init+0x0/0x61 returned 0 after 976 usecs
[    0.937008] calling  wpan_phy_class_init+0x0/0x33 @ 1
[    0.938007] device class 'ieee802154': registering
[    0.939380] initcall wpan_phy_class_init+0x0/0x33 returned 0 after 976 u=
secs
[    0.940009] calling  sysctl_init+0x0/0x5b @ 1
[    0.941013] initcall sysctl_init+0x0/0x5b returned 0 after 0 usecs
[    0.942007] calling  pci_iommu_init+0x0/0x2b @ 1
[    0.943008] initcall pci_iommu_init+0x0/0x2b returned 0 after 0 usecs
[    0.944006] calling  print_all_ICs+0x0/0x50c @ 1
[    0.945005]=20
[    0.945006] printing PIC contents
[    0.946007] ... PIC  IMR: fffa
[    0.946999] ... PIC  IRR: 0001
[    0.947005] ... PIC  ISR: 0001
[    0.948006] ... PIC ELCR: 0828
[    0.949006] printing local APIC contents on CPU#0/0:
[    0.949999] ... APIC ID:      00000000 (0)
[    0.949999] ... APIC VERSION: 00040010
[    0.949999] ... APIC TASKPRI: 00000000 (00)
[    0.949999] ... APIC ARBPRI: 000000e0 (e0)
[    0.949999] ... APIC PROCPRI: 00000000
[    0.949999] ... APIC LDR: 01000000
[    0.949999] ... APIC DFR: ffffffff
[    0.949999] ... APIC SPIV: 000001ff
[    0.949999] ... APIC ISR field:
[    0.949999] 000000000000000000000000000000000000000000000000000000000000=
0000
[    0.949999] ... APIC TMR field:
[    0.949999] 000000000000000000000000000000000000000000000000000000000000=
0000
[    0.949999] ... APIC IRR field:
[    0.949999] 000000000000000000000000000000000000000000000000000000000000=
8000
[    0.949999] ... APIC ESR: 00000000
[    0.949999] ... APIC ICR: 000008fd
[    0.949999] ... APIC ICR2: 02000000
[    0.949999] ... APIC LVTT: 000200ef
[    0.949999] ... APIC LVTPC: 00000400
[    0.949999] ... APIC LVT0: 00010700
[    0.949999] ... APIC LVT1: 00000400
[    0.949999] ... APIC LVTERR: 000000fe
[    0.949999] ... APIC TMICT: 00003112
[    0.949999] ... APIC TMCCT: 00000c22
[    0.949999] ... APIC TDCR: 00000003
[    0.949999]=20
[    0.949998] printing local APIC contents on CPU#1/1:
[    0.949999] ... APIC ID:      01000000 (1)
[    0.949999] ... APIC VERSION: 00040010
[    0.949999] ... APIC TASKPRI: 00000000 (00)
[    0.949999] ... APIC ARBPRI: 000000e0 (e0)
[    0.949999] ... APIC PROCPRI: 00000000
[    0.949999] ... APIC LDR: 02000000
[    0.949999] ... APIC DFR: ffffffff
[    0.949999] ... APIC SPIV: 000001ff
[    0.949999] ... APIC ISR field:
[    0.949999] 000000000000000000000000000000000000000000000000000000000000=
0000
[    0.949999] ... APIC TMR field:
[    0.949999] 000000000000000000000000000000000000000000000000000000000000=
0000
[    0.949999] ... APIC IRR field:
[    0.949999] 000000000000000000000000000000000000000000000000000000000000=
8000
[    0.949999] ... APIC ESR: 00000000
[    0.949999] ... APIC ICR: 000008fd
[    0.949999] ... APIC ICR2: 01000000
[    0.949999] ... APIC LVTT: 000200ef
[    0.949999] ... APIC LVTPC: 00010400
[    0.949999] ... APIC LVT0: 00010700
[    0.949999] ... APIC LVT1: 00010400
[    0.949999] ... APIC LVTERR: 000000fe
[    0.949999] ... APIC TMICT: 00003112
[    0.949999] ... APIC TMCCT: 00001958
[    0.949999] ... APIC TDCR: 00000003
[    0.949999]=20
[    1.055478] number of MP IRQ sources: 17.
[    1.056005] number of IO-APIC #2 registers: 24.
[    1.057005] testing the IO APIC.......................
[    1.058008]=20
[    1.059004] IO APIC #2......
[    1.060005] .... register #00: 00000000
[    1.061004] .......    : physical APIC id: 00
[    1.062004] .......    : Delivery Type: 0
[    1.063004] .......    : LTS          : 0
[    1.064005] .... register #01: 00170011
[    1.065004] .......     : max redirection entries: 0017
[    1.066004] .......     : PRQ implemented: 0
[    1.067004] .......     : IO APIC version: 0011
[    1.068005] .... register #02: 00000000
[    1.069004] .......     : arbitration: 00
[    1.070004] .... IRQ redirection table:
[    1.071004]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:  =20
[    1.072007]  00 003 0    0    0   0   0    1    1    30
[    1.074007]  01 003 0    0    0   0   0    1    1    31
[    1.076007]  02 000 1    0    0   0   0    0    0    00
[    1.078007]  03 003 1    1    0   1   0    1    1    33
[    1.080007]  04 003 0    0    0   0   0    1    1    34
[    1.082007]  05 003 1    1    0   1   0    1    1    35
[    1.084007]  06 003 0    0    0   0   0    1    1    36
[    1.086007]  07 003 1    0    0   0   0    1    1    37
[    1.088007]  08 003 0    0    0   0   0    1    1    38
[    1.090007]  09 003 0    0    0   0   0    1    1    39
[    1.092007]  0a 003 0    0    0   0   0    1    1    3A
[    1.094007]  0b 003 1    1    0   1   0    1    1    3B
[    1.096007]  0c 003 0    0    0   0   0    1    1    3C
[    1.098007]  0d 003 0    0    0   0   0    1    1    3D
[    1.100007]  0e 003 0    0    0   0   0    1    1    3E
[    1.102007]  0f 003 0    0    0   0   0    1    1    3F
[    1.104007]  10 000 1    0    0   0   0    0    0    00
[    1.106007]  11 000 1    0    0   0   0    0    0    00
[    1.108007]  12 000 1    0    0   0   0    0    0    00
[    1.110007]  13 000 1    0    0   0   0    0    0    00
[    1.112007]  14 000 1    0    0   0   0    0    0    00
[    1.114007]  15 000 1    0    0   0   0    0    0    00
[    1.116007]  16 000 1    0    0   0   0    0    0    00
[    1.118007]  17 000 1    0    0   0   0    0    0    00
[    1.120004] IRQ to pin mappings:
[    1.121005] IRQ0 -> 0:0
[    1.123004] IRQ1 -> 0:1
[    1.125171] IRQ3 -> 0:3
[    1.126690] IRQ4 -> 0:4
[    1.128171] IRQ5 -> 0:5
[    1.129691] IRQ6 -> 0:6
[    1.131171] IRQ7 -> 0:7
[    1.133172] IRQ8 -> 0:8
[    1.135004] IRQ9 -> 0:9
[    1.137171] IRQ10 -> 0:10
[    1.139004] IRQ11 -> 0:11
[    1.141170] IRQ12 -> 0:12
[    1.143171] IRQ13 -> 0:13
[    1.144777] IRQ14 -> 0:14
[    1.146171] IRQ15 -> 0:15
[    1.148008] .................................... done.
[    1.149006] initcall print_all_ICs+0x0/0x50c returned 0 after 199218 use=
cs
[    1.150007] calling  clocksource_done_booting+0x0/0x2e @ 1
[    1.151007] initcall clocksource_done_booting+0x0/0x2e returned 0 after =
0 usecs
[    1.152007] calling  ftrace_init_debugfs+0x0/0x24b @ 1
[    1.154335] initcall ftrace_init_debugfs+0x0/0x24b returned 0 after 976 =
usecs
[    1.155007] calling  rb_init_debugfs+0x0/0x46 @ 1
[    1.156032] initcall rb_init_debugfs+0x0/0x46 returned 0 after 0 usecs
[    1.157006] calling  tracer_init_debugfs+0x0/0x2f4 @ 1
[    1.159889] initcall tracer_init_debugfs+0x0/0x2f4 returned 0 after 976 =
usecs
[    1.160007] calling  init_trace_printk_function_export+0x0/0x49 @ 1
[    1.161030] initcall init_trace_printk_function_export+0x0/0x49 returned=
 0 after 0 usecs
[    1.162006] calling  event_trace_init+0x0/0x1b8 @ 1
[    1.194325] initcall event_trace_init+0x0/0x1b8 returned 0 after 30273 u=
secs
[    1.195008] calling  init_pipe_fs+0x0/0x5d @ 1
[    1.196266] initcall init_pipe_fs+0x0/0x5d returned 0 after 0 usecs
[    1.197009] calling  eventpoll_init+0x0/0xd5 @ 1
[    1.198069] initcall eventpoll_init+0x0/0xd5 returned 0 after 0 usecs
[    1.199007] calling  anon_inode_init+0x0/0x10c @ 1
[    1.201160] initcall anon_inode_init+0x0/0x10c returned 0 after 976 usecs
[    1.202009] calling  tomoyo_initerface_init+0x0/0x131 @ 1
[    1.203625] initcall tomoyo_initerface_init+0x0/0x131 returned 0 after 0=
 usecs
[    1.205011] calling  blk_scsi_ioctl_init+0x0/0x2a4 @ 1
[    1.206008] initcall blk_scsi_ioctl_init+0x0/0x2a4 returned 0 after 0 us=
ecs
[    1.207006] calling  chr_dev_init+0x0/0xb8 @ 1
[    1.208059] device class 'mem': registering
[    1.210114] device: 'mem': device_add
[    1.212347] device: 'null': device_add
[    1.213544] device: 'port': device_add
[    1.214538] device: 'zero': device_add
[    1.215542] device: 'full': device_add
[    1.217130] device: 'random': device_add
[    1.219506] device: 'urandom': device_add
[    1.220543] device: 'kmsg': device_add
[    1.222168] device: 'oldmem': device_add
[    1.224517] initcall chr_dev_init+0x0/0xb8 returned 0 after 15625 usecs
[    1.225011] calling  firmware_class_init+0x0/0x80 @ 1
[    1.226010] device class 'firmware': registering
[    1.228053] initcall firmware_class_init+0x0/0x80 returned 0 after 1953 =
usecs
[    1.229010] calling  ieee1394_init+0x0/0x227 @ 1
[    1.231377] bus: 'ieee1394': registered
[    1.232027] device class 'ieee1394_host': registering
[    1.233395] device class 'ieee1394_protocol': registering
[    1.235293] device class 'ieee1394_node': registering
[    1.236392] device class 'ieee1394': registering
[    1.237490] bus: 'ieee1394': add driver nodemgr
[    1.238427] initcall ieee1394_init+0x0/0x227 returned 0 after 7812 usecs
[    1.239012] calling  ssb_modinit+0x0/0x7d @ 1
[    1.240493] bus: 'ssb': registered
[    1.241043] initcall ssb_modinit+0x0/0x7d returned 0 after 976 usecs
[    1.242010] calling  pcibios_assign_resources+0x0/0xa1 @ 1
[    1.243285] pci 0000:00:09.0: PCI bridge, secondary bus 0000:05
[    1.244008] pci 0000:00:09.0:   IO window: 0xc000-0xcfff
[    1.245021] pci 0000:00:09.0:   MEM window: 0xda000000-0xda0fffff
[    1.246007] pci 0000:00:09.0:   PREFETCH window: disabled
[    1.247008] pci 0000:00:0b.0: PCI bridge, secondary bus 0000:04
[    1.248005] pci 0000:00:0b.0:   IO window: disabled
[    1.249009] pci 0000:00:0b.0:   MEM window: disabled
[    1.250007] pci 0000:00:0b.0:   PREFETCH window: disabled
[    1.251008] pci 0000:00:0c.0: PCI bridge, secondary bus 0000:03
[    1.252005] pci 0000:00:0c.0:   IO window: disabled
[    1.253008] pci 0000:00:0c.0:   MEM window: disabled
[    1.254007] pci 0000:00:0c.0:   PREFETCH window: disabled
[    1.256008] pci 0000:00:0d.0: PCI bridge, secondary bus 0000:02
[    1.257005] pci 0000:00:0d.0:   IO window: disabled
[    1.258012] pci 0000:00:0d.0:   MEM window: disabled
[    1.259007] pci 0000:00:0d.0:   PREFETCH window: disabled
[    1.260023] pci 0000:01:00.0: BAR 6: got res [0xd8000000-0xd801ffff] bus=
 [0xd8000000-0xd801ffff] flags 0x27200
[    1.261010] pci 0000:00:0e.0: PCI bridge, secondary bus 0000:01
[    1.262008] pci 0000:00:0e.0:   IO window: 0xb000-0xbfff
[    1.263008] pci 0000:00:0e.0:   MEM window: 0xd8000000-0xd9ffffff
[    1.264008] pci 0000:00:0e.0:   PREFETCH window: 0x000000d0000000-0x0000=
00d7ffffff
[    1.265018] pci 0000:00:09.0: setting latency timer to 64
[    1.266014] pci 0000:00:0b.0: setting latency timer to 64
[    1.267013] pci 0000:00:0c.0: setting latency timer to 64
[    1.268013] pci 0000:00:0d.0: setting latency timer to 64
[    1.269013] pci 0000:00:0e.0: setting latency timer to 64
[    1.270008] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    1.271006] pci_bus 0000:00: resource 1 mem: [0x000000-0xfffffffffffffff=
f]
[    1.272006] pci_bus 0000:05: resource 0 io:  [0xc000-0xcfff]
[    1.273006] pci_bus 0000:05: resource 1 mem: [0xda000000-0xda0fffff]
[    1.274006] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
[    1.275006] pci_bus 0000:05: resource 4 mem: [0x000000-0xfffffffffffffff=
f]
[    1.276006] pci_bus 0000:01: resource 0 io:  [0xb000-0xbfff]
[    1.277006] pci_bus 0000:01: resource 1 mem: [0xd8000000-0xd9ffffff]
[    1.278006] pci_bus 0000:01: resource 2 pref mem [0xd0000000-0xd7ffffff]
[    1.279007] initcall pcibios_assign_resources+0x0/0xa1 returned 0 after =
35156 usecs
[    1.280006] calling  sysctl_core_init+0x0/0x4c @ 1
[    1.281058] initcall sysctl_core_init+0x0/0x4c returned 0 after 0 usecs
[    1.282006] calling  inet_init+0x0/0x1ec @ 1
[    1.283070] NET: Registered protocol family 2
[    1.284262] IP route cache hash table entries: 32768 (order: 5, 131072 b=
ytes)
[    1.286533] TCP established hash table entries: 131072 (order: 8, 104857=
6 bytes)
[    1.288814] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[    1.299024] TCP: Hash tables configured (established 131072 bind 65536)
[    1.300052] TCP reno registered
[    1.302218] initcall inet_init+0x0/0x1ec returned 0 after 18554 usecs
[    1.303010] calling  af_unix_init+0x0/0x66 @ 1
[    1.305016] NET: Registered protocol family 1
[    1.306064] initcall af_unix_init+0x0/0x66 returned 0 after 1953 usecs
[    1.307008] calling  init_sunrpc+0x0/0x73 @ 1
[    1.308807] RPC: Registered udp transport module.
[    1.309009] RPC: Registered tcp transport module.
[    1.310013] initcall init_sunrpc+0x0/0x73 returned 0 after 1953 usecs
[    1.311008] calling  populate_rootfs+0x0/0xa9 @ 1
[    1.313013] initcall populate_rootfs+0x0/0xa9 returned 0 after 976 usecs
[    1.314012] calling  irqfd_module_init+0x0/0x51 @ 1
[    1.315228] initcall irqfd_module_init+0x0/0x51 returned 0 after 0 usecs
[    1.316008] calling  vmx_init+0x0/0x223 @ 1
[    1.318341] kvm: no hardware support
[    1.320487] initcall vmx_init+0x0/0x223 returned -95 after 2929 usecs
[    1.321010] initcall vmx_init+0x0/0x223 returned with error code -95=20
[    1.322136] calling  i8259A_init_sysfs+0x0/0x3c @ 1
[    1.323007] Registering sysdev class 'i8259'
[    1.324446] Registering sys device of class 'i8259'
[    1.325037] Registering sys device 'i82590'
[    1.327138] initcall i8259A_init_sysfs+0x0/0x3c returned 0 after 3906 us=
ecs
[    1.327006] Clocksource tsc unstable (delta =3D 1181583819 ns)
[    1.328008] calling  sbf_init+0x0/0xfa @ 1
[    1.329020] initcall sbf_init+0x0/0xfa returned 0 after 0 usecs
[    1.330009] calling  i8237A_init_sysfs+0x0/0x3c @ 1
[    1.331005] Registering sysdev class 'i8237'
[    1.333067] Registering sys device of class 'i8237'
[    1.334038] Registering sys device 'i82370'
[    1.335335] initcall i8237A_init_sysfs+0x0/0x3c returned 0 after 3906 us=
ecs
[    1.336011] calling  add_rtc_cmos+0x0/0x50 @ 1
[    1.337021] Registering platform device 'rtc_cmos'. Parent at platform
[    1.338016] device: 'rtc_cmos': device_add
[    1.339040] bus: 'platform': add device rtc_cmos
[    1.341247] platform rtc_cmos: registered platform RTC device (no PNP de=
vice found)
[    1.342010] initcall add_rtc_cmos+0x0/0x50 returned 0 after 4882 usecs
[    1.343053] calling  cache_sysfs_init+0x0/0xa8 @ 1
[    1.348102] initcall cache_sysfs_init+0x0/0xa8 returned 0 after 3906 use=
cs
[    1.349017] calling  cpu_debug_init+0x0/0x232 @ 1
[    1.359811] cpu0(2) debug files 137
[    1.370296] cpu1(2) debug files 137
[    1.371013] initcall cpu_debug_init+0x0/0x232 returned 0 after 20507 use=
cs
[    1.372007] calling  mce_init_device+0x0/0x197 @ 1
[    1.373056] Registering sysdev class 'machinecheck'
[    1.374422] Registering sys device of class 'machinecheck'
[    1.376015] Registering sys device 'machinecheck0'
[    1.378201] Registering sys device of class 'machinecheck'
[    1.379043] Registering sys device 'machinecheck1'
[    1.380564] device: 'mcelog': device_add
[    1.382306] initcall mce_init_device+0x0/0x197 returned 0 after 8789 use=
cs
[    1.383012] calling  inject_init+0x0/0x3f @ 1
[    1.384006] Machine check injector initialized
[    1.385009] initcall inject_init+0x0/0x3f returned 0 after 976 usecs
[    1.386007] calling  thermal_throttle_init_device+0x0/0xd3 @ 1
[    1.387008] initcall thermal_throttle_init_device+0x0/0xd3 returned 0 af=
ter 0 usecs
[    1.388007] calling  ioapic_init_sysfs+0x0/0xa3 @ 1
[    1.389005] Registering sysdev class 'ioapic'
[    1.391166] Registering sys device of class 'ioapic'
[    1.392038] Registering sys device 'ioapic0'
[    1.393411] initcall ioapic_init_sysfs+0x0/0xa3 returned 0 after 3906 us=
ecs
[    1.394008] calling  add_pcspkr+0x0/0x47 @ 1
[    1.395024] Registering platform device 'pcspkr'. Parent at platform
[    1.396014] device: 'pcspkr': device_add
[    1.397039] bus: 'platform': add device pcspkr
[    1.398427] initcall add_pcspkr+0x0/0x47 returned 0 after 2929 usecs
[    1.399010] calling  start_periodic_check_for_corruption+0x0/0x56 @ 1
[    1.400010] Scanning for low memory corruption every 60 seconds
[    1.401015] initcall start_periodic_check_for_corruption+0x0/0x56 return=
ed 0 after 976 usecs
[    1.402008] calling  start_pageattr_test+0x0/0x5c @ 1
[    1.404014] initcall start_pageattr_test+0x0/0x5c returned 0 after 976 u=
secs
[    1.405007] calling  pt_dump_init+0x0/0x88 @ 1
[    1.406035] initcall pt_dump_init+0x0/0x88 returned 0 after 0 usecs
[    1.407007] calling  init+0x0/0x2e @ 1
[    1.408618] initcall init+0x0/0x2e returned 0 after 0 usecs
[    1.409008] calling  init_sched_debug_procfs+0x0/0x46 @ 1
[    1.410038] initcall init_sched_debug_procfs+0x0/0x46 returned 0 after 0=
 usecs
[    1.411008] calling  proc_schedstat_init+0x0/0x3b @ 1
[    1.412029] initcall proc_schedstat_init+0x0/0x3b returned 0 after 0 use=
cs
[    1.413008] calling  proc_execdomains_init+0x0/0x3b @ 1
[    1.414029] initcall proc_execdomains_init+0x0/0x3b returned 0 after 0 u=
secs
[    1.415008] calling  ioresources_init+0x0/0x50 @ 1
[    1.416047] initcall ioresources_init+0x0/0x50 returned 0 after 0 usecs
[    1.417008] calling  uid_cache_init+0x0/0x97 @ 1
[    1.418042] initcall uid_cache_init+0x0/0x97 returned 0 after 0 usecs
[    1.419007] calling  init_posix_timers+0x0/0xca @ 1
[    1.420019] initcall init_posix_timers+0x0/0xca returned 0 after 0 usecs
[    1.421007] calling  init_posix_cpu_timers+0x0/0xa7 @ 1
[    1.422007] initcall init_posix_cpu_timers+0x0/0xa7 returned 0 after 0 u=
secs
[    1.423006] calling  nsproxy_cache_init+0x0/0x46 @ 1
[    1.424016] initcall nsproxy_cache_init+0x0/0x46 returned 0 after 0 usecs
[    1.425007] calling  create_proc_profile+0x0/0x286 @ 1
[    1.426006] initcall create_proc_profile+0x0/0x286 returned 0 after 0 us=
ecs
[    1.427007] calling  timekeeping_init_device+0x0/0x3c @ 1
[    1.428005] Registering sysdev class 'timekeeping'
[    1.429366] Registering sys device of class 'timekeeping'
[    1.430041] Registering sys device 'timekeeping0'
[    1.431366] initcall timekeeping_init_device+0x0/0x3c returned 0 after 2=
929 usecs
[    1.432008] calling  init_clocksource_sysfs+0x0/0x62 @ 1
[    1.433009] Registering sysdev class 'clocksource'
[    1.434381] Registering sys device of class 'clocksource'
[    1.436027] Registering sys device 'clocksource0'
[    1.438035] initcall init_clocksource_sysfs+0x0/0x62 returned 0 after 48=
82 usecs
[    1.439010] calling  init_timer_list_procfs+0x0/0x46 @ 1
[    1.440033] initcall init_timer_list_procfs+0x0/0x46 returned 0 after 0 =
usecs
[    1.441008] calling  init_tstats_procfs+0x0/0x46 @ 1
[    1.442030] initcall init_tstats_procfs+0x0/0x46 returned 0 after 0 usecs
[    1.443008] calling  lockdep_proc_init+0x0/0x6e @ 1
[    1.444071] initcall lockdep_proc_init+0x0/0x6e returned 0 after 0 usecs
[    1.445009] calling  futex_init+0x0/0x84 @ 1
[    1.446059] initcall futex_init+0x0/0x84 returned 0 after 0 usecs
[    1.447007] calling  init_rttest+0x0/0x123 @ 1
[    1.448008] Registering sysdev class 'rttest'
[    1.449497] Registering sys device of class 'rttest'
[    1.450040] Registering sys device 'rttest0'
[    1.452155] Registering sys device of class 'rttest'
[    1.453037] Registering sys device 'rttest1'
[    1.454541] Registering sys device of class 'rttest'
[    1.455039] Registering sys device 'rttest2'
[    1.457415] Registering sys device of class 'rttest'
[    1.458038] Registering sys device 'rttest3'
[    1.460014] Registering sys device of class 'rttest'
[    1.461039] Registering sys device 'rttest4'
[    1.462518] Registering sys device of class 'rttest'
[    1.463044] Registering sys device 'rttest5'
[    1.465247] Registering sys device of class 'rttest'
[    1.466039] Registering sys device 'rttest6'
[    1.467545] Registering sys device of class 'rttest'
[    1.468040] Registering sys device 'rttest7'
[    1.469364] Initializing RT-Tester: OK
[    1.470010] initcall init_rttest+0x0/0x123 returned 0 after 21484 usecs
[    1.471009] calling  proc_dma_init+0x0/0x3b @ 1
[    1.472032] initcall proc_dma_init+0x0/0x3b returned 0 after 0 usecs
[    1.473008] calling  proc_modules_init+0x0/0x3b @ 1
[    1.474031] initcall proc_modules_init+0x0/0x3b returned 0 after 0 usecs
[    1.475008] calling  kallsyms_init+0x0/0x3e @ 1
[    1.476030] initcall kallsyms_init+0x0/0x3e returned 0 after 0 usecs
[    1.477008] calling  pid_namespaces_init+0x0/0x46 @ 1
[    1.478018] initcall pid_namespaces_init+0x0/0x46 returned 0 after 0 use=
cs
[    1.479007] calling  ikconfig_init+0x0/0x59 @ 1
[    1.480029] initcall ikconfig_init+0x0/0x59 returned 0 after 0 usecs
[    1.481008] calling  audit_init+0x0/0x140 @ 1
[    1.482005] audit: initializing netlink socket (disabled)
[    1.483119] type=3D2000 audit(1253228886.482:1): initialized
[    1.484017] initcall audit_init+0x0/0x140 returned 0 after 1953 usecs
[    1.485008] calling  audit_tree_init+0x0/0x5a @ 1
[    1.486016] initcall audit_tree_init+0x0/0x5a returned 0 after 0 usecs
[    1.487007] calling  init_kprobes+0x0/0x14c @ 1
[    1.494782] initcall init_kprobes+0x0/0x14c returned 0 after 5859 usecs
[    1.495007] calling  hung_task_init+0x0/0x61 @ 1
[    1.496141] initcall hung_task_init+0x0/0x61 returned 0 after 0 usecs
[    1.497007] calling  rcuclassic_trace_init+0x0/0xfa @ 1
[    1.498161] initcall rcuclassic_trace_init+0x0/0xfa returned 0 after 0 u=
secs
[    1.499007] calling  utsname_sysctl_init+0x0/0x30 @ 1
[    1.500020] initcall utsname_sysctl_init+0x0/0x30 returned 0 after 0 use=
cs
[    1.501007] calling  init_tracepoints+0x0/0x33 @ 1
[    1.502007] initcall init_tracepoints+0x0/0x33 returned 0 after 0 usecs
[    1.503007] calling  ftrace_mod_cmd_init+0x0/0x2e @ 1
[    1.504050] initcall ftrace_mod_cmd_init+0x0/0x2e returned 0 after 0 use=
cs
[    1.505006] calling  init_events+0x0/0x79 @ 1
[    1.506010] initcall init_events+0x0/0x79 returned 0 after 0 usecs
[    1.507006] calling  init_sched_switch_trace+0x0/0x2e @ 1
[    1.510052] Testing tracer sched_switch: PASSED
[    1.621635] initcall init_sched_switch_trace+0x0/0x2e returned 0 after 1=
10351 usecs
[    1.622008] calling  init_function_trace+0x0/0x54 @ 1
[    1.625012] Testing tracer function: PASSED
[    1.733007] Testing dynamic ftrace: PASSED
[    1.978647] initcall init_function_trace+0x0/0x54 returned 0 after 34667=
9 usecs
[    1.979008] calling  init_irqsoff_tracer+0x0/0x30 @ 1
[    1.983011] Testing tracer irqsoff: PASSED
[    1.995646] initcall init_irqsoff_tracer+0x0/0x30 returned 0 after 14648=
 usecs
[    1.996014] calling  init_wakeup_tracer+0x0/0x3c @ 1
[    2.001013] Testing tracer wakeup: PASSED
[    2.318019] Testing tracer wakeup_rt: PASSED
[    2.636659] initcall init_wakeup_tracer+0x0/0x3c returned 0 after 624023=
 usecs
[    2.637008] calling  stack_trace_init+0x0/0x7a @ 1
[    2.638094] initcall stack_trace_init+0x0/0x7a returned 0 after 0 usecs
[    2.639012] calling  init_mmio_trace+0x0/0x2e @ 1
[    2.640010] initcall init_mmio_trace+0x0/0x2e returned 0 after 0 usecs
[    2.641011] calling  init_power_trace+0x0/0x2e @ 1
[    2.642008] initcall init_power_trace+0x0/0x2e returned 0 after 0 usecs
[    2.643005] calling  init_kmem_tracer+0x0/0x69 @ 1
[    2.644007] Warning: could not register the kmem tracer
[    2.645006] initcall init_kmem_tracer+0x0/0x69 returned 1 after 976 usecs
[    2.646007] initcall init_kmem_tracer+0x0/0x69 returned with error code =
1=20
[    2.647006] calling  perf_counter_sysfs_init+0x0/0x33 @ 1
[    2.648059] initcall perf_counter_sysfs_init+0x0/0x33 returned 0 after 0=
 usecs
[    2.649006] calling  init_per_zone_wmark_min+0x0/0x85 @ 1
[    2.650089] initcall init_per_zone_wmark_min+0x0/0x85 returned 0 after 0=
 usecs
[    2.651006] calling  kswapd_init+0x0/0x7a @ 1
[    2.653030] initcall kswapd_init+0x0/0x7a returned 0 after 976 usecs
[    2.654006] calling  setup_vmstat+0x0/0xf7 @ 1
[    2.655107] initcall setup_vmstat+0x0/0xf7 returned 0 after 0 usecs
[    2.656008] calling  mm_sysfs_init+0x0/0x41 @ 1
[    2.657048] initcall mm_sysfs_init+0x0/0x41 returned 0 after 0 usecs
[    2.658006] calling  proc_vmalloc_init+0x0/0x3e @ 1
[    2.659029] initcall proc_vmalloc_init+0x0/0x3e returned 0 after 0 usecs
[    2.660008] calling  init_emergency_pool+0x0/0x73 @ 1
[    2.661116] highmem bounce pool size: 64 pages
[    2.662007] initcall init_emergency_pool+0x0/0x73 returned 0 after 976 u=
secs
[    2.663006] calling  procswaps_init+0x0/0x3b @ 1
[    2.664028] initcall procswaps_init+0x0/0x3b returned 0 after 0 usecs
[    2.665008] calling  hugetlb_init+0x0/0x383 @ 1
[    2.666007] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.667132] initcall hugetlb_init+0x0/0x383 returned 0 after 976 usecs
[    2.668006] calling  slab_proc_init+0x0/0x3e @ 1
[    2.669028] initcall slab_proc_init+0x0/0x3e returned 0 after 0 usecs
[    2.670008] calling  slab_sysfs_init+0x0/0xd5 @ 1
[    2.717035] initcall slab_sysfs_init+0x0/0xd5 returned 0 after 44921 use=
cs
[    2.718079] calling  fasync_init+0x0/0x43 @ 1
[    2.719066] initcall fasync_init+0x0/0x43 returned 0 after 0 usecs
[    2.720032] calling  proc_filesystems_init+0x0/0x3b @ 1
[    2.721037] initcall proc_filesystems_init+0x0/0x3b returned 0 after 0 u=
secs
[    2.722013] calling  dnotify_init+0x0/0x8e @ 1
[    2.724073] initcall dnotify_init+0x0/0x8e returned 0 after 976 usecs
[    2.725008] calling  inotify_setup+0x0/0x2e @ 1
[    2.726006] initcall inotify_setup+0x0/0x2e returned 0 after 0 usecs
[    2.727006] calling  inotify_user_setup+0x0/0xbd @ 1
[    2.728334] initcall inotify_user_setup+0x0/0xbd returned 0 after 0 usecs
[    2.729009] calling  aio_setup+0x0/0xb5 @ 1
[    2.730335] initcall aio_setup+0x0/0xb5 returned 0 after 0 usecs
[    2.731007] calling  proc_locks_init+0x0/0x3b @ 1
[    2.732031] initcall proc_locks_init+0x0/0x3b returned 0 after 0 usecs
[    2.733008] calling  init_mbcache+0x0/0x30 @ 1
[    2.734007] initcall init_mbcache+0x0/0x30 returned 0 after 0 usecs
[    2.735006] calling  dquot_init+0x0/0xe7 @ 1
[    2.736004] VFS: Disk quotas dquot_6.5.2
[    2.738387] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    2.739010] initcall dquot_init+0x0/0xe7 returned 0 after 2929 usecs
[    2.740010] calling  init_v2_quota_format+0x0/0x2e @ 1
[    2.741043] initcall init_v2_quota_format+0x0/0x2e returned 0 after 0 us=
ecs
[    2.742007] calling  proc_cmdline_init+0x0/0x3b @ 1
[    2.743031] initcall proc_cmdline_init+0x0/0x3b returned 0 after 0 usecs
[    2.744007] calling  proc_cpuinfo_init+0x0/0x3b @ 1
[    2.745031] initcall proc_cpuinfo_init+0x0/0x3b returned 0 after 0 usecs
[    2.746008] calling  proc_devices_init+0x0/0x3b @ 1
[    2.747029] initcall proc_devices_init+0x0/0x3b returned 0 after 0 usecs
[    2.748007] calling  proc_interrupts_init+0x0/0x3b @ 1
[    2.749031] initcall proc_interrupts_init+0x0/0x3b returned 0 after 0 us=
ecs
[    2.750008] calling  proc_loadavg_init+0x0/0x3b @ 1
[    2.751031] initcall proc_loadavg_init+0x0/0x3b returned 0 after 0 usecs
[    2.752008] calling  proc_meminfo_init+0x0/0x3b @ 1
[    2.753030] initcall proc_meminfo_init+0x0/0x3b returned 0 after 0 usecs
[    2.754007] calling  proc_stat_init+0x0/0x3b @ 1
[    2.755030] initcall proc_stat_init+0x0/0x3b returned 0 after 0 usecs
[    2.756008] calling  proc_uptime_init+0x0/0x3b @ 1
[    2.757029] initcall proc_uptime_init+0x0/0x3b returned 0 after 0 usecs
[    2.758008] calling  proc_version_init+0x0/0x3b @ 1
[    2.759029] initcall proc_version_init+0x0/0x3b returned 0 after 0 usecs
[    2.760008] calling  proc_softirqs_init+0x0/0x3b @ 1
[    2.761030] initcall proc_softirqs_init+0x0/0x3b returned 0 after 0 usecs
[    2.762008] calling  proc_kcore_init+0x0/0x5f @ 1
[    2.763029] initcall proc_kcore_init+0x0/0x5f returned 0 after 0 usecs
[    2.764008] calling  vmcore_init+0x0/0x9f5 @ 1
[    2.765007] initcall vmcore_init+0x0/0x9f5 returned 0 after 0 usecs
[    2.766006] calling  proc_kmsg_init+0x0/0x3e @ 1
[    2.767032] initcall proc_kmsg_init+0x0/0x3e returned 0 after 0 usecs
[    2.768008] calling  proc_page_init+0x0/0x56 @ 1
[    2.769050] initcall proc_page_init+0x0/0x56 returned 0 after 0 usecs
[    2.770009] calling  init_devpts_fs+0x0/0x5d @ 1
[    2.772404] initcall init_devpts_fs+0x0/0x5d returned 0 after 976 usecs
[    2.773009] calling  init_reiserfs_fs+0x0/0x98 @ 1
[    2.775430] initcall init_reiserfs_fs+0x0/0x98 returned 0 after 976 usecs
[    2.776009] calling  init_ext3_fs+0x0/0x85 @ 1
[    2.779088] initcall init_ext3_fs+0x0/0x85 returned 0 after 1953 usecs
[    2.780011] calling  init_ext2_fs+0x0/0x85 @ 1
[    2.782773] initcall init_ext2_fs+0x0/0x85 returned 0 after 976 usecs
[    2.783008] calling  journal_init+0x0/0xd5 @ 1
[    2.786534] initcall journal_init+0x0/0xd5 returned 0 after 2929 usecs
[    2.793028] calling  init_squashfs_fs+0x0/0x7c @ 1
[    2.798963] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    2.804029] initcall init_squashfs_fs+0x0/0x7c returned 0 after 5859 use=
cs
[    2.811012] calling  init_ramfs_fs+0x0/0x2e @ 1
[    2.816015] initcall init_ramfs_fs+0x0/0x2e returned 0 after 0 usecs
[    2.822008] calling  init_hugetlbfs_fs+0x0/0xa1 @ 1
[    2.827969] initcall init_hugetlbfs_fs+0x0/0xa1 returned 0 after 976 use=
cs
[    2.835009] calling  init_minix_fs+0x0/0x75 @ 1
[    2.840306] initcall init_minix_fs+0x0/0x75 returned 0 after 976 usecs
[    2.846008] calling  init_fat_fs+0x0/0x65 @ 1
[    2.852518] initcall init_fat_fs+0x0/0x65 returned 0 after 976 usecs
[    2.858011] calling  init_msdos_fs+0x0/0x2e @ 1
[    2.863011] initcall init_msdos_fs+0x0/0x2e returned 0 after 0 usecs
[    2.869007] calling  init_hfs_fs+0x0/0x6f @ 1
[    2.874675] initcall init_hfs_fs+0x0/0x6f returned 0 after 976 usecs
[    2.880007] calling  vxfs_init+0x0/0x6c @ 1
[    2.885829] initcall vxfs_init+0x0/0x6c returned 0 after 0 usecs
[    2.891010] calling  init_nfs_fs+0x0/0x155 @ 1
[    2.899553] initcall init_nfs_fs+0x0/0x155 returned 0 after 2929 usecs
[    2.906012] calling  init_nlm+0x0/0x3b @ 1
[    2.910021] initcall init_nlm+0x0/0x3b returned 0 after 0 usecs
[    2.916010] calling  init_nls_cp437+0x0/0x2e @ 1
[    2.920042] initcall init_nls_cp437+0x0/0x2e returned 0 after 0 usecs
[    2.927007] calling  init_nls_cp855+0x0/0x2e @ 1
[    2.931007] initcall init_nls_cp855+0x0/0x2e returned 0 after 0 usecs
[    2.938007] calling  init_nls_cp860+0x0/0x2e @ 1
[    2.942007] initcall init_nls_cp860+0x0/0x2e returned 0 after 0 usecs
[    2.949007] calling  init_nls_cp861+0x0/0x2e @ 1
[    2.953007] initcall init_nls_cp861+0x0/0x2e returned 0 after 0 usecs
[    2.960007] calling  init_nls_cp862+0x0/0x2e @ 1
[    2.964007] initcall init_nls_cp862+0x0/0x2e returned 0 after 0 usecs
[    2.971007] calling  init_nls_cp863+0x0/0x2e @ 1
[    2.975007] initcall init_nls_cp863+0x0/0x2e returned 0 after 0 usecs
[    2.982006] calling  init_nls_cp865+0x0/0x2e @ 1
[    2.986007] initcall init_nls_cp865+0x0/0x2e returned 0 after 0 usecs
[    2.993006] calling  init_nls_cp866+0x0/0x2e @ 1
[    2.997007] initcall init_nls_cp866+0x0/0x2e returned 0 after 0 usecs
[    3.004007] calling  init_nls_cp1251+0x0/0x2e @ 1
[    3.008007] initcall init_nls_cp1251+0x0/0x2e returned 0 after 0 usecs
[    3.015007] calling  init_nls_iso8859_4+0x0/0x2e @ 1
[    3.020007] initcall init_nls_iso8859_4+0x0/0x2e returned 0 after 0 usecs
[    3.027007] calling  init_nls_iso8859_9+0x0/0x2e @ 1
[    3.031007] initcall init_nls_iso8859_9+0x0/0x2e returned 0 after 0 usecs
[    3.038007] calling  init_nls_iso8859_13+0x0/0x2e @ 1
[    3.043012] initcall init_nls_iso8859_13+0x0/0x2e returned 0 after 0 use=
cs
[    3.050007] calling  init_nls_iso8859_15+0x0/0x2e @ 1
[    3.055007] initcall init_nls_iso8859_15+0x0/0x2e returned 0 after 0 use=
cs
[    3.062007] calling  init_nls_utf8+0x0/0x3c @ 1
[    3.066007] initcall init_nls_utf8+0x0/0x3c returned 0 after 0 usecs
[    3.073006] calling  init_sysv_fs+0x0/0x63 @ 1
[    3.078411] initcall init_sysv_fs+0x0/0x63 returned 0 after 976 usecs
[    3.084010] calling  init_cifs+0x0/0x453 @ 1
[    3.091300] initcall init_cifs+0x0/0x453 returned 0 after 1953 usecs
[    3.097013] calling  init_efs_fs+0x0/0x80 @ 1
[    3.101010] EFS: 1.0a - http://aeschi.ch.eu.org/efs/
[    3.108123] initcall init_efs_fs+0x0/0x80 returned 0 after 6835 usecs
[    3.114011] calling  init_affs_fs+0x0/0x75 @ 1
[    3.119620] initcall init_affs_fs+0x0/0x75 returned 0 after 976 usecs
[    3.126008] calling  init_qnx4_fs+0x0/0x82 @ 1
[    3.131163] QNX4 filesystem 0.2.3 registered.
[    3.135010] initcall init_qnx4_fs+0x0/0x82 returned 0 after 4882 usecs
[    3.141008] calling  init_adfs_fs+0x0/0x75 @ 1
[    3.147310] initcall init_adfs_fs+0x0/0x75 returned 0 after 976 usecs
[    3.153010] calling  init_udf_fs+0x0/0x75 @ 1
[    3.158734] initcall init_udf_fs+0x0/0x75 returned 0 after 0 usecs
[    3.164008] calling  init_omfs_fs+0x0/0x2e @ 1
[    3.169012] initcall init_omfs_fs+0x0/0x2e returned 0 after 0 usecs
[    3.175009] calling  init_nilfs_fs+0x0/0xa5 @ 1
[    3.182917] initcall init_nilfs_fs+0x0/0xa5 returned 0 after 1953 usecs
[    3.189014] calling  init_btrfs_fs+0x0/0xa2 @ 1
[    3.198009] device: 'btrfs-control': device_add
[    3.203180] Btrfs loaded
[    3.205060] initcall init_btrfs_fs+0x0/0xa2 returned 0 after 10742 usecs
[    3.212010] calling  ipc_init+0x0/0x3f @ 1
[    3.216067] msgmni has been set to 1691
[    3.220069] initcall ipc_init+0x0/0x3f returned 0 after 3906 usecs
[    3.226014] calling  ipc_sysctl_init+0x0/0x30 @ 1
[    3.231021] initcall ipc_sysctl_init+0x0/0x30 returned 0 after 0 usecs
[    3.237009] calling  init_mqueue_fs+0x0/0xc2 @ 1
[    3.242843] initcall init_mqueue_fs+0x0/0xc2 returned 0 after 976 usecs
[    3.249010] calling  key_proc_init+0x0/0x6d @ 1
[    3.254058] initcall key_proc_init+0x0/0x6d returned 0 after 0 usecs
[    3.260009] calling  crypto_wq_init+0x0/0x4e @ 1
[    3.265456] initcall crypto_wq_init+0x0/0x4e returned 0 after 0 usecs
[    3.271008] calling  crypto_algapi_init+0x0/0x2b @ 1
[    3.276034] initcall crypto_algapi_init+0x0/0x2b returned 0 after 0 usecs
[    3.283008] calling  skcipher_module_init+0x0/0x4b @ 1
[    3.288007] initcall skcipher_module_init+0x0/0x4b returned 0 after 0 us=
ecs
[    3.295007] calling  chainiv_module_init+0x0/0x2e @ 1
[    3.300032] initcall chainiv_module_init+0x0/0x2e returned 0 after 0 use=
cs
[    3.307006] calling  eseqiv_module_init+0x0/0x2e @ 1
[    3.312008] initcall eseqiv_module_init+0x0/0x2e returned 0 after 0 usecs
[    3.319006] calling  md5_mod_init+0x0/0x2e @ 1
[    3.323833] initcall md5_mod_init+0x0/0x2e returned 0 after 0 usecs
[    3.330008] calling  rmd256_mod_init+0x0/0x2e @ 1
[    3.334961] initcall rmd256_mod_init+0x0/0x2e returned 0 after 0 usecs
[    3.341007] calling  sha1_generic_mod_init+0x0/0x2e @ 1
[    3.346856] initcall sha1_generic_mod_init+0x0/0x2e returned 0 after 0 u=
secs
[    3.353007] calling  wp512_mod_init+0x0/0x72 @ 1
[    3.359242] initcall wp512_mod_init+0x0/0x72 returned 0 after 976 usecs
[    3.365010] calling  crypto_ecb_module_init+0x0/0x2e @ 1
[    3.371062] initcall crypto_ecb_module_init+0x0/0x2e returned 0 after 0 =
usecs
[    3.378008] calling  crypto_cbc_module_init+0x0/0x2e @ 1
[    3.383026] initcall crypto_cbc_module_init+0x0/0x2e returned 0 after 0 =
usecs
[    3.390012] calling  crypto_module_init+0x0/0x2e @ 1
[    3.395014] initcall crypto_module_init+0x0/0x2e returned 0 after 0 usecs
[    3.402008] calling  cryptd_init+0x0/0x10b @ 1
[    3.406015] initcall cryptd_init+0x0/0x10b returned 0 after 0 usecs
[    3.413007] calling  des_generic_mod_init+0x0/0x53 @ 1
[    3.418755] initcall des_generic_mod_init+0x0/0x53 returned 0 after 0 us=
ecs
[    3.425007] calling  aes_init+0x0/0x2e @ 1
[    3.429975] initcall aes_init+0x0/0x2e returned 0 after 0 usecs
[    3.435008] calling  cast6_mod_init+0x0/0x2e @ 1
[    3.440537] initcall cast6_mod_init+0x0/0x2e returned 0 after 0 usecs
[    3.447008] calling  arc4_init+0x0/0x2e @ 1
[    3.451427] initcall arc4_init+0x0/0x2e returned 0 after 0 usecs
[    3.457008] calling  seed_init+0x0/0x2e @ 1
[    3.461788] initcall seed_init+0x0/0x2e returned 0 after 0 usecs
[    3.467008] calling  deflate_mod_init+0x0/0x2e @ 1
[    3.473147] initcall deflate_mod_init+0x0/0x2e returned 0 after 976 usecs
[    3.473172] cryptomgr_test used greatest stack depth: 2304 bytes left
[    3.486013] calling  zlib_mod_init+0x0/0x2e @ 1
[    3.491634] initcall zlib_mod_init+0x0/0x2e returned 0 after 976 usecs
[    3.491658] cryptomgr_test used greatest stack depth: 1940 bytes left
[    3.504008] calling  crc32c_mod_init+0x0/0x2e @ 1
[    3.509683] initcall crc32c_mod_init+0x0/0x2e returned 0 after 0 usecs
[    3.516007] calling  crypto_authenc_module_init+0x0/0x2e @ 1
[    3.521008] initcall crypto_authenc_module_init+0x0/0x2e returned 0 afte=
r 0 usecs
[    3.529007] calling  lzo_mod_init+0x0/0x2e @ 1
[    3.533887] initcall lzo_mod_init+0x0/0x2e returned 0 after 0 usecs
[    3.540007] calling  krng_mod_init+0x0/0x2e @ 1
[    3.544734] alg: No test for stdrng (krng)
[    3.545015] initcall krng_mod_init+0x0/0x2e returned 0 after 976 usecs
[    3.552008] calling  prng_mod_init+0x0/0x2e @ 1
[    3.573686] initcall prng_mod_init+0x0/0x2e returned 0 after 16601 usecs
[    3.580007] calling  ghash_mod_init+0x0/0x2e @ 1
[    3.585087] alg: No test for ghash (ghash-generic)
[    3.586012] initcall ghash_mod_init+0x0/0x2e returned 0 after 1953 usecs
[    3.593008] calling  proc_genhd_init+0x0/0x50 @ 1
[    3.598055] initcall proc_genhd_init+0x0/0x50 returned 0 after 0 usecs
[    3.604007] calling  noop_init+0x0/0x30 @ 1
[    3.608044] io scheduler noop registered
[    3.612007] initcall noop_init+0x0/0x30 returned 0 after 3906 usecs
[    3.618006] calling  as_init+0x0/0x30 @ 1
[    3.622005] io scheduler anticipatory registered (default)
[    3.628007] initcall as_init+0x0/0x30 returned 0 after 5859 usecs
[    3.634006] calling  deadline_init+0x0/0x30 @ 1
[    3.638006] io scheduler deadline registered
[    3.643006] initcall deadline_init+0x0/0x30 returned 0 after 4882 usecs
[    3.649006] calling  debug_objects_init_debugfs+0x0/0x76 @ 1
[    3.655062] initcall debug_objects_init_debugfs+0x0/0x76 returned 0 afte=
r 0 usecs
[    3.662006] calling  libcrc32c_mod_init+0x0/0x48 @ 1
[    3.667016] initcall libcrc32c_mod_init+0x0/0x48 returned 0 after 0 usecs
[    3.674006] calling  percpu_counter_startup+0x0/0x35 @ 1
[    3.679009] initcall percpu_counter_startup+0x0/0x35 returned 0 after 0 =
usecs
[    3.687007] calling  audit_classes_init+0x0/0x6b @ 1
[    3.691039] initcall audit_classes_init+0x0/0x6b returned 0 after 0 usecs
[    3.698006] calling  dynamic_debug_init+0x0/0x119 @ 1
[    3.704680] initcall dynamic_debug_init+0x0/0x119 returned 0 after 1953 =
usecs
[    3.712008] calling  bt8xxgpio_init+0x0/0x3a @ 1
[    3.716008] bus: 'pci': add driver bt8xxgpio
[    3.721706] initcall bt8xxgpio_init+0x0/0x3a returned 0 after 4882 usecs
[    3.728009] calling  pci_init+0x0/0x51 @ 1
[    3.732024] pci 0000:00:00.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x2f
[    3.739045] pci 0000:00:00.0: calling quirk_cardbus_legacy+0x0/0x46
[    3.745009] pci 0000:00:00.0: calling quirk_usb_early_handoff+0x0/0x5a9
[    3.751008] pci 0000:00:00.0: calling pci_fixup_video+0x0/0xb3
[    3.757020] pci 0000:00:01.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x2f
[    3.764010] pci 0000:00:01.0: calling quirk_cardbus_legacy+0x0/0x46
[    3.770009] pci 0000:00:01.0: calling quirk_usb_early_handoff+0x0/0x5a9
[    3.777007] pci 0000:00:01.0: calling pci_fixup_video+0x0/0xb3
[    3.782021] pci 0000:00:01.1: calling nv_msi_ht_cap_quirk_leaf+0x0/0x2f
[    3.789014] pci 0000:00:01.1: calling quirk_cardbus_legacy+0x0/0x46
[    3.795007] pci 0000:00:01.1: calling quirk_usb_early_handoff+0x0/0x5a9
[    3.802006] pci 0000:00:01.1: calling pci_fixup_video+0x0/0xb3
[    3.808025] pci 0000:00:02.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x2f
[    3.814019] pci 0000:00:02.0: calling quirk_cardbus_legacy+0x0/0x46
[    3.820007] pci 0000:00:02.0: calling quirk_usb_early_handoff+0x0/0x5a9
[    3.838038] pci 0000:00:02.0: calling pci_fixup_video+0x0/0xb3
[    3.844022] pci 0000:00:02.1: calling nv_msi_ht_cap_quirk_leaf+0x0/0x2f
[    3.850016] pci 0000:00:02.1: calling quirk_cardbus_legacy+0x0/0x46
[    3.857007] pci 0000:00:02.1: calling quirk_usb_early_handoff+0x0/0x5a9
[    3.863043] pci 0000:00:02.1: calling pci_fixup_video+0x0/0xb3
[    3.869021] pci 0000:00:04.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x2f
[    3.876014] pci 0000:00:04.0: calling quirk_cardbus_legacy+0x0/0x46
[    3.882007] pci 0000:00:04.0: calling quirk_usb_early_handoff+0x0/0x5a9
[    3.888006] pci 0000:00:04.0: calling pci_fixup_video+0x0/0xb3
[    3.894019] pci 0000:00:06.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x2f
[    3.901013] pci 0000:00:06.0: calling quirk_cardbus_legacy+0x0/0x46
[    3.907007] pci 0000:00:06.0: calling quirk_usb_early_handoff+0x0/0x5a9
[    3.914006] pci 0000:00:06.0: calling pci_fixup_video+0x0/0xb3
[    3.919019] pci 0000:00:09.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x2f
[    3.926010] pci 0000:00:09.0: calling quirk_cardbus_legacy+0x0/0x46
[    3.932007] pci 0000:00:09.0: calling quirk_usb_early_handoff+0x0/0x5a9
[    3.939006] pci 0000:00:09.0: calling pci_fixup_video+0x0/0xb3
[    3.945020] pci 0000:00:0a.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x2f
[    3.951013] pci 0000:00:0a.0: calling quirk_cardbus_legacy+0x0/0x46
[    3.958007] pci 0000:00:0a.0: calling quirk_usb_early_handoff+0x0/0x5a9
[    3.964006] pci 0000:00:0a.0: calling pci_fixup_video+0x0/0xb3
[    3.970019] pci 0000:00:0b.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x2f
[    3.976095] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    3.982008] pci 0000:00:0b.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/=
0x8c
[    3.989012] pci 0000:00:0b.0: Found disabled HT MSI Mapping
[    3.995016] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    4.000008] pci 0000:00:0b.0: calling quirk_nvidia_ck804_pcie_aer_ext_ca=
p+0x0/0x84
[    4.008008] pci 0000:00:0b.0: calling quirk_cardbus_legacy+0x0/0x46
[    4.014007] pci 0000:00:0b.0: calling quirk_usb_early_handoff+0x0/0x5a9
[    4.020006] pci 0000:00:0b.0: calling pci_fixup_video+0x0/0xb3
[    4.026020] pci 0000:00:0c.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x2f
[    4.033103] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    4.038008] pci 0000:00:0c.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/=
0x8c
[    4.045015] pci 0000:00:0c.0: Found disabled HT MSI Mapping
[    4.051016] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    4.056007] pci 0000:00:0c.0: calling quirk_nvidia_ck804_pcie_aer_ext_ca=
p+0x0/0x84
[    4.064007] pci 0000:00:0c.0: calling quirk_cardbus_legacy+0x0/0x46
[    4.070010] pci 0000:00:0c.0: calling quirk_usb_early_handoff+0x0/0x5a9
[    4.077006] pci 0000:00:0c.0: calling pci_fixup_video+0x0/0xb3
[    4.082020] pci 0000:00:0d.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x2f
[    4.089115] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    4.095008] pci 0000:00:0d.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/=
0x8c
[    4.102015] pci 0000:00:0d.0: Found disabled HT MSI Mapping
[    4.107016] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    4.113007] pci 0000:00:0d.0: calling quirk_nvidia_ck804_pcie_aer_ext_ca=
p+0x0/0x84
[    4.120007] pci 0000:00:0d.0: calling quirk_cardbus_legacy+0x0/0x46
[    4.126007] pci 0000:00:0d.0: calling quirk_usb_early_handoff+0x0/0x5a9
[    4.133006] pci 0000:00:0d.0: calling pci_fixup_video+0x0/0xb3
[    4.139020] pci 0000:00:0e.0: calling nv_msi_ht_cap_quirk_leaf+0x0/0x2f
[    4.145126] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    4.151008] pci 0000:00:0e.0: calling quirk_nvidia_ck804_msi_ht_cap+0x0/=
0x8c
[    4.158015] pci 0000:00:0e.0: Found disabled HT MSI Mapping
[    4.164018] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    4.169007] pci 0000:00:0e.0: calling quirk_nvidia_ck804_pcie_aer_ext_ca=
p+0x0/0x84
[    4.177007] pci 0000:00:0e.0: calling quirk_cardbus_legacy+0x0/0x46
[    4.183007] pci 0000:00:0e.0: calling quirk_usb_early_handoff+0x0/0x5a9
[    4.190006] pci 0000:00:0e.0: calling pci_fixup_video+0x0/0xb3
[    4.196021] pci 0000:00:18.0: calling quirk_amd_nb_node+0x0/0x6c
[    4.202010] pci 0000:00:18.0: calling quirk_cardbus_legacy+0x0/0x46
[    4.208007] pci 0000:00:18.0: calling quirk_usb_early_handoff+0x0/0x5a9
[    4.214006] pci 0000:00:18.0: calling pci_fixup_video+0x0/0xb3
[    4.220020] pci 0000:00:18.1: calling quirk_amd_nb_node+0x0/0x6c
[    4.226010] pci 0000:00:18.1: calling quirk_cardbus_legacy+0x0/0x46
[    4.232007] pci 0000:00:18.1: calling quirk_usb_early_handoff+0x0/0x5a9
[    4.239006] pci 0000:00:18.1: calling pci_fixup_video+0x0/0xb3
[    4.245020] pci 0000:00:18.2: calling quirk_amd_nb_node+0x0/0x6c
[    4.251010] pci 0000:00:18.2: calling quirk_cardbus_legacy+0x0/0x46
[    4.257007] pci 0000:00:18.2: calling quirk_usb_early_handoff+0x0/0x5a9
[    4.264006] pci 0000:00:18.2: calling pci_fixup_video+0x0/0xb3
[    4.269020] pci 0000:00:18.3: calling quirk_amd_nb_node+0x0/0x6c
[    4.275010] pci 0000:00:18.3: calling quirk_cardbus_legacy+0x0/0x46
[    4.282007] pci 0000:00:18.3: calling quirk_usb_early_handoff+0x0/0x5a9
[    4.288006] pci 0000:00:18.3: calling pci_fixup_video+0x0/0xb3
[    4.294021] pci 0000:05:07.0: calling quirk_cardbus_legacy+0x0/0x46
[    4.300009] pci 0000:05:07.0: calling quirk_usb_early_handoff+0x0/0x5a9
[    4.307006] pci 0000:05:07.0: calling pci_fixup_video+0x0/0xb3
[    4.313020] pci 0000:01:00.0: calling quirk_cardbus_legacy+0x0/0x46
[    4.319009] pci 0000:01:00.0: calling quirk_usb_early_handoff+0x0/0x5a9
[    4.326009] pci 0000:01:00.0: calling pci_fixup_video+0x0/0xb3
[    4.331007] pci 0000:01:00.0: Boot video device
[    4.336020] pci 0000:01:00.1: calling quirk_cardbus_legacy+0x0/0x46
[    4.342008] pci 0000:01:00.1: calling quirk_usb_early_handoff+0x0/0x5a9
[    4.349006] pci 0000:01:00.1: calling pci_fixup_video+0x0/0xb3
[    4.355019] initcall pci_init+0x0/0x51 returned 0 after 608398 usecs
[    4.361008] calling  pci_proc_init+0x0/0x7a @ 1
[    4.366174] initcall pci_proc_init+0x0/0x7a returned 0 after 976 usecs
[    4.373009] calling  pcie_portdrv_init+0x0/0x60 @ 1
[    4.378368] bus: 'pci_express': registered
[    4.382009] bus: 'pci': add driver pcieport-driver
[    4.387058] bus: 'pci': driver_probe_device: matched device 0000:00:0b.0=
 with driver pcieport-driver
[    4.396005] bus: 'pci': really_probe: probing driver pcieport-driver wit=
h device 0000:00:0b.0
[    4.404056] cpumask_of_node(255): node > nr_node_ids(16)
[    4.410007] Pid: 1, comm: swapper Not tainted 2.6.31 #14941
[    4.415005] Call Trace:
[    4.418010]  [<c182cdac>] ? printk+0x22/0x35
[    4.422009]  [<c10503f6>] cpumask_of_node+0x32/0x74
[    4.427007]  [<c1344e71>] pci_device_probe+0x7a/0xee
[    4.432009]  [<c1381faf>] driver_probe_device+0xc1/0x17a
[    4.437008]  [<c13820be>] __driver_attach+0x56/0x84
[    4.442008]  [<c1381645>] bus_for_each_dev+0x53/0x8e
[    4.447007]  [<c1382068>] ? __driver_attach+0x0/0x84
[    4.452007]  [<c1381d7a>] driver_attach+0x27/0x3a
[    4.456007]  [<c1382068>] ? __driver_attach+0x0/0x84
[    4.461007]  [<c1380f2f>] bus_add_driver+0x122/0x25a
[    4.466008]  [<c1382424>] driver_register+0x9b/0x10c
[    4.471008]  [<c13320a3>] ? __spin_lock_init+0x34/0x69
[    4.476007]  [<c13450df>] __pci_register_driver+0x56/0xc3
[    4.482007]  [<c1c7fb0c>] ? pcie_portdrv_init+0x0/0x60
[    4.487007]  [<c1c7fb49>] pcie_portdrv_init+0x3d/0x60
[    4.492007]  [<c1001096>] do_one_initcall+0x6d/0x183
[    4.497008]  [<c1c5a4d6>] kernel_init+0x187/0x1ec
[    4.501007]  [<c1c5a34f>] ? kernel_init+0x0/0x1ec
[    4.506007]  [<c102cce7>] kernel_thread_helper+0x7/0x10
[    4.511207] ------------[ cut here ]------------
[    4.511999] WARNING: at kernel/lockdep.c:2813 __lock_acquire+0x7bc/0x147=
a()
[    4.511999] Hardware name: System Product Name
[    4.511999] Modules linked in:
[    4.511999] Pid: 1, comm: swapper Not tainted 2.6.31 #14941
[    4.511999] Call Trace:
[    4.511999]  [<c10947d7>] ? __lock_acquire+0x7bc/0x147a
[    4.511999]  [<c1069325>] warn_slowpath_common+0x74/0xb5
[    4.511999]  [<c110d65c>] ? get_partial_node+0x2c/0xbd
[    4.511999]  [<c1069387>] warn_slowpath_null+0x21/0x35
[    4.511999]  [<c10947d7>] __lock_acquire+0x7bc/0x147a
[    4.511999]  [<c110b526>] ? add_partial+0x26/0x62
[    4.511999]  [<c110d65c>] ? get_partial_node+0x2c/0xbd
[    4.511999]  [<c110b526>] ? add_partial+0x26/0x62
[    4.511999]  [<c110b526>] ? add_partial+0x26/0x62
[    4.511999]  [<c1095479>] ? __lock_acquire+0x145e/0x147a
[    4.511999]  [<c110b526>] ? add_partial+0x26/0x62
[    4.511999]  [<c110d65c>] ? get_partial_node+0x2c/0xbd
[    4.511999]  [<c1095563>] lock_acquire+0xce/0xf6
[    4.511999]  [<c110d65c>] ? get_partial_node+0x2c/0xbd
[    4.511999]  [<c1830676>] _spin_lock+0x35/0x55
[    4.511999]  [<c110d65c>] ? get_partial_node+0x2c/0xbd
[    4.511999]  [<c110d65c>] get_partial_node+0x2c/0xbd
[    4.511999]  [<c110db0a>] __slab_alloc+0x154/0x4a7
[    4.511999]  [<c17e65c4>] ? irq_to_desc_alloc_node+0x99/0x2d2
[    4.511999]  [<c110de9a>] ? kmem_cache_alloc_node_notrace+0x3d/0x104
[    4.511999]  [<c110ded7>] kmem_cache_alloc_node_notrace+0x7a/0x104
[    4.511999]  [<c17e65c4>] ? irq_to_desc_alloc_node+0x99/0x2d2
[    4.511999]  [<c17e65c4>] ? irq_to_desc_alloc_node+0x99/0x2d2
[    4.511999]  [<c17e65c4>] irq_to_desc_alloc_node+0x99/0x2d2
[    4.511999]  [<c1042cde>] create_irq_nr+0x48/0xce
[    4.511999]  [<c1042dd3>] arch_setup_msi_irqs+0x6f/0x1b3
[    4.511999]  [<c134b685>] ? alloc_msi_entry+0x2b/0xb1
[    4.511999]  [<c134c40d>] pci_enable_msi_block+0x228/0x2bf
[    4.511999]  [<c1349380>] pcie_port_device_register+0x318/0x508
[    4.511999]  [<c10934bb>] ? trace_hardirqs_on+0x19/0x2c
[    4.511999]  [<c183049f>] ? _spin_unlock_irqrestore+0x55/0x7d
[    4.511999]  [<c133e63f>] ? pci_bus_read_config_word+0x6f/0x8c
[    4.511999]  [<c1349035>] ? pcie_port_device_probe+0x3b/0x6e
[    4.511999]  [<c17ea9e4>] pcie_portdrv_probe+0x67/0x8f
[    4.511999]  [<c1344b65>] local_pci_probe+0x22/0x35
[    4.511999]  [<c1344e9b>] pci_device_probe+0xa4/0xee
[    4.511999]  [<c1381faf>] driver_probe_device+0xc1/0x17a
[    4.511999]  [<c13820be>] __driver_attach+0x56/0x84
[    4.511999]  [<c1381645>] bus_for_each_dev+0x53/0x8e
[    4.511999]  [<c1382068>] ? __driver_attach+0x0/0x84
[    4.511999]  [<c1381d7a>] driver_attach+0x27/0x3a
[    4.511999]  [<c1382068>] ? __driver_attach+0x0/0x84
[    4.511999]  [<c1380f2f>] bus_add_driver+0x122/0x25a
[    4.511999]  [<c1382424>] driver_register+0x9b/0x10c
[    4.511999]  [<c13320a3>] ? __spin_lock_init+0x34/0x69
[    4.511999]  [<c13450df>] __pci_register_driver+0x56/0xc3
[    4.511999]  [<c1c7fb0c>] ? pcie_portdrv_init+0x0/0x60
[    4.511999]  [<c1c7fb49>] pcie_portdrv_init+0x3d/0x60
[    4.511999]  [<c1001096>] do_one_initcall+0x6d/0x183
[    4.511999]  [<c1c5a4d6>] kernel_init+0x187/0x1ec
[    4.511999]  [<c1c5a34f>] ? kernel_init+0x0/0x1ec
[    4.511999]  [<c102cce7>] kernel_thread_helper+0x7/0x10
[    4.511999] ---[ end trace 5a5d197966b56a2e ]---
[    5.704001] BUG: spinlock lockup on CPU#1, swapper/1, c1bdbaac
[    5.704001] Pid: 1, comm: swapper Tainted: G        W  2.6.31 #14941
[    5.704001] Call Trace:
[    5.704001]  [<c182cdac>] ? printk+0x22/0x35
[    5.704001]  [<c1331fca>] _raw_spin_lock+0x106/0x142
[    5.704001]  [<c183067d>] _spin_lock+0x3c/0x55
[    5.704001]  [<c110d65c>] ? get_partial_node+0x2c/0xbd
[    5.704001]  [<c110d65c>] get_partial_node+0x2c/0xbd
[    5.704001]  [<c110db0a>] __slab_alloc+0x154/0x4a7
[    5.704001]  [<c17e65c4>] ? irq_to_desc_alloc_node+0x99/0x2d2
[    5.704001]  [<c110de9a>] ? kmem_cache_alloc_node_notrace+0x3d/0x104
[    5.704001]  [<c110ded7>] kmem_cache_alloc_node_notrace+0x7a/0x104
[    5.704001]  [<c17e65c4>] ? irq_to_desc_alloc_node+0x99/0x2d2
[    5.704001]  [<c17e65c4>] ? irq_to_desc_alloc_node+0x99/0x2d2
[    5.704001]  [<c17e65c4>] irq_to_desc_alloc_node+0x99/0x2d2
[    5.704001]  [<c1042cde>] create_irq_nr+0x48/0xce
[    5.704001]  [<c1042dd3>] arch_setup_msi_irqs+0x6f/0x1b3
[    5.704001]  [<c134b685>] ? alloc_msi_entry+0x2b/0xb1
[    5.704001]  [<c134c40d>] pci_enable_msi_block+0x228/0x2bf
[    5.704001]  [<c1349380>] pcie_port_device_register+0x318/0x508
[    5.704001]  [<c10934bb>] ? trace_hardirqs_on+0x19/0x2c
[    5.704001]  [<c183049f>] ? _spin_unlock_irqrestore+0x55/0x7d
[    5.704001]  [<c133e63f>] ? pci_bus_read_config_word+0x6f/0x8c
[    5.704001]  [<c1349035>] ? pcie_port_device_probe+0x3b/0x6e
[    5.704001]  [<c17ea9e4>] pcie_portdrv_probe+0x67/0x8f
[    5.704001]  [<c1344b65>] local_pci_probe+0x22/0x35
[    5.704001]  [<c1344e9b>] pci_device_probe+0xa4/0xee
[    5.704001]  [<c1381faf>] driver_probe_device+0xc1/0x17a
[    5.704001]  [<c13820be>] __driver_attach+0x56/0x84
[    5.704001]  [<c1381645>] bus_for_each_dev+0x53/0x8e
[    5.704001]  [<c1382068>] ? __driver_attach+0x0/0x84
[    5.704001]  [<c1381d7a>] driver_attach+0x27/0x3a
[    5.704001]  [<c1382068>] ? __driver_attach+0x0/0x84
[    5.704001]  [<c1380f2f>] bus_add_driver+0x122/0x25a
[    5.704001]  [<c1382424>] driver_register+0x9b/0x10c
[    5.704001]  [<c13320a3>] ? __spin_lock_init+0x34/0x69
[    5.704001]  [<c13450df>] __pci_register_driver+0x56/0xc3
[    5.704001]  [<c1c7fb0c>] ? pcie_portdrv_init+0x0/0x60
[    5.704001]  [<c1c7fb49>] pcie_portdrv_init+0x3d/0x60
[    5.704001]  [<c1001096>] do_one_initcall+0x6d/0x183
[    5.704001]  [<c1c5a4d6>] kernel_init+0x187/0x1ec
[    5.704001]  [<c1c5a34f>] ? kernel_init+0x0/0x1ec
[    5.704001]  [<c102cce7>] kernel_thread_helper+0x7/0x10
[    5.704001] sending NMI to all CPUs:
[    5.704001] NMI backtrace for cpu 1
[    5.704001]=20
[    5.704001] Pid: 1, comm: swapper Tainted: G        W  (2.6.31 #14941) S=
ystem Product Name
[    5.704001] EIP: 0060:[<c1092481>] EFLAGS: 00000046 CPU: 1
[    5.704001] EIP is at trace_hardirqs_off_caller+0xb8/0xbd
[    5.704001] EAX: 00000000 EBX: f60b8000 ECX: c1be08e4 EDX: c103ff84
[    5.704001] ESI: c103ff84 EDI: 00000006 EBP: f60a2c30 ESP: f60a2c24
[    5.704001]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[    5.704001] CR0: 8005003b CR2: 00000000 CR3: 01bd7000 CR4: 000006f0
[    5.704001] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[    5.704001] DR6: ffff0ff0 DR7: 00000400
[    5.704001] Call Trace:
[    5.704001]  [<c109249f>] trace_hardirqs_off+0x19/0x2c
[    5.704001]  [<c103ff84>] default_send_IPI_mask_logical+0xde/0x100
[    5.704001]  [<c103fc91>] default_send_IPI_all+0x35/0x87
[    5.704001]  [<c10404ec>] arch_trigger_all_cpu_backtrace+0x5c/0x9e
[    5.704001]  [<c1331fcf>] _raw_spin_lock+0x10b/0x142
[    5.704001]  [<c183067d>] _spin_lock+0x3c/0x55
[    5.704001]  [<c110d65c>] ? get_partial_node+0x2c/0xbd
[    5.704001]  [<c110d65c>] get_partial_node+0x2c/0xbd
[    5.704001]  [<c110db0a>] __slab_alloc+0x154/0x4a7
[    5.704001]  [<c17e65c4>] ? irq_to_desc_alloc_node+0x99/0x2d2
[    5.704001]  [<c110de9a>] ? kmem_cache_alloc_node_notrace+0x3d/0x104
[    5.704001]  [<c110ded7>] kmem_cache_alloc_node_notrace+0x7a/0x104
[    5.704001]  [<c17e65c4>] ? irq_to_desc_alloc_node+0x99/0x2d2
[    5.704001]  [<c17e65c4>] ? irq_to_desc_alloc_node+0x99/0x2d2
[    5.704001]  [<c17e65c4>] irq_to_desc_alloc_node+0x99/0x2d2
[    5.704001]  [<c1042cde>] create_irq_nr+0x48/0xce
[    5.704001]  [<c1042dd3>] arch_setup_msi_irqs+0x6f/0x1b3
[    5.704001]  [<c134b685>] ? alloc_msi_entry+0x2b/0xb1
[    5.704001]  [<c134c40d>] pci_enable_msi_block+0x228/0x2bf
[    5.704001]  [<c1349380>] pcie_port_device_register+0x318/0x508
[    5.704001]  [<c10934bb>] ? trace_hardirqs_on+0x19/0x2c
[    5.704001]  [<c183049f>] ? _spin_unlock_irqrestore+0x55/0x7d
[    5.704001]  [<c133e63f>] ? pci_bus_read_config_word+0x6f/0x8c
[    5.704001]  [<c1349035>] ? pcie_port_device_probe+0x3b/0x6e
[    5.704001]  [<c17ea9e4>] pcie_portdrv_probe+0x67/0x8f
[    5.704001]  [<c1344b65>] local_pci_probe+0x22/0x35
[    5.704001]  [<c1344e9b>] pci_device_probe+0xa4/0xee
[    5.704001]  [<c1381faf>] driver_probe_device+0xc1/0x17a
[    5.704001]  [<c13820be>] __driver_attach+0x56/0x84
[    5.704001]  [<c1381645>] bus_for_each_dev+0x53/0x8e
[    5.704001]  [<c1382068>] ? __driver_attach+0x0/0x84
[    5.704001]  [<c1381d7a>] driver_attach+0x27/0x3a
[    5.704001]  [<c1382068>] ? __driver_attach+0x0/0x84
[    5.704001]  [<c1380f2f>] bus_add_driver+0x122/0x25a
[    5.704001]  [<c1382424>] driver_register+0x9b/0x10c
[    5.704001]  [<c13320a3>] ? __spin_lock_init+0x34/0x69
[    5.704001]  [<c13450df>] __pci_register_driver+0x56/0xc3
[    5.704001]  [<c1c7fb0c>] ? pcie_portdrv_init+0x0/0x60
[    5.704001]  [<c1c7fb49>] pcie_portdrv_init+0x3d/0x60
[    5.704001]  [<c1001096>] do_one_initcall+0x6d/0x183
[    5.704001]  [<c1c5a4d6>] kernel_init+0x187/0x1ec
[    5.704001]  [<c1c5a34f>] ? kernel_init+0x0/0x1ec
[    5.704001]  [<c102cce7>] kernel_thread_helper+0x7/0x10
[    5.704001] Pid: 1, comm: swapper Tainted: G        W  2.6.31 #14941
[    5.704001] Call Trace:
[    5.704001]  [<c102ae6f>] ? show_regs+0x34/0x4b
[    5.704001]  [<c1831f4d>] nmi_watchdog_tick+0xea/0x222
[    5.704001]  [<c1831365>] do_nmi+0xa9/0x2a9
[    5.704001]  [<c103ff84>] ? default_send_IPI_mask_logical+0xde/0x100
[    5.704001]  [<c1830ea0>] nmi_stack_correct+0x2f/0x34
[    5.704001]  [<c103ff84>] ? default_send_IPI_mask_logical+0xde/0x100
[    5.704001]  [<c103ff84>] ? default_send_IPI_mask_logical+0xde/0x100
[    5.704001]  [<c1092481>] ? trace_hardirqs_off_caller+0xb8/0xbd
[    5.704001]  [<c109249f>] trace_hardirqs_off+0x19/0x2c
[    5.704001]  [<c103ff84>] default_send_IPI_mask_logical+0xde/0x100
[    5.704001]  [<c103fc91>] default_send_IPI_all+0x35/0x87
[    5.704001]  [<c10404ec>] arch_trigger_all_cpu_backtrace+0x5c/0x9e
[    5.704001]  [<c1331fcf>] _raw_spin_lock+0x10b/0x142
[    5.704001]  [<c183067d>] _spin_lock+0x3c/0x55
[    5.704001]  [<c110d65c>] ? get_partial_node+0x2c/0xbd
[    5.704001]  [<c110d65c>] get_partial_node+0x2c/0xbd
[    5.704001]  [<c110db0a>] __slab_alloc+0x154/0x4a7
[    5.704001]  [<c17e65c4>] ? irq_to_desc_alloc_node+0x99/0x2d2
[    5.704001]  [<c110de9a>] ? kmem_cache_alloc_node_notrace+0x3d/0x104
[    5.704001]  [<c110ded7>] kmem_cache_alloc_node_notrace+0x7a/0x104
[    5.704001]  [<c17e65c4>] ? irq_to_desc_alloc_node+0x99/0x2d2
[    5.704001]  [<c17e65c4>] ? irq_to_desc_alloc_node+0x99/0x2d2
[    5.704001]  [<c17e65c4>] irq_to_desc_alloc_node+0x99/0x2d2
[    5.704001]  [<c1042cde>] create_irq_nr+0x48/0xce
[    5.704001]  [<c1042dd3>] arch_setup_msi_irqs+0x6f/0x1b3
[    5.704001]  [<c134b685>] ? alloc_msi_entry+0x2b/0xb1
[    5.704001]  [<c134c40d>] pci_enable_msi_block+0x228/0x2bf
[    5.704001]  [<c1349380>] pcie_port_device_register+0x318/0x508
[    5.704001]  [<c10934bb>] ? trace_hardirqs_on+0x19/0x2c
[    5.704001]  [<c183049f>] ? _spin_unlock_irqrestore+0x55/0x7d
[    5.704001]  [<c133e63f>] ? pci_bus_read_config_word+0x6f/0x8c
[    5.704001]  [<c1349035>] ? pcie_port_device_probe+0x3b/0x6e
[    5.704001]  [<c17ea9e4>] pcie_portdrv_probe+0x67/0x8f
[    5.704001]  [<c1344b65>] local_pci_probe+0x22/0x35
[    5.704001]  [<c1344e9b>] pci_device_probe+0xa4/0xee
[    5.704001]  [<c1381faf>] driver_probe_device+0xc1/0x17a
[    5.704001]  [<c13820be>] __driver_attach+0x56/0x84
[    5.704001]  [<c1381645>] bus_for_each_dev+0x53/0x8e
[    5.704001]  [<c1382068>] ? __driver_attach+0x0/0x84
[    5.704001]  [<c1381d7a>] driver_attach+0x27/0x3a
[    5.704001]  [<c1382068>] ? __driver_attach+0x0/0x84
[    5.704001]  [<c1380f2f>] bus_add_driver+0x122/0x25a
[    5.704001]  [<c1382424>] driver_register+0x9b/0x10c
[    5.704001]  [<c13320a3>] ? __spin_lock_init+0x34/0x69
[    5.704001]  [<c13450df>] __pci_register_driver+0x56/0xc3
[    5.704001]  [<c1c7fb0c>] ? pcie_portdrv_init+0x0/0x60
[    5.704001]  [<c1c7fb49>] pcie_portdrv_init+0x3d/0x60
[    5.704001]  [<c1001096>] do_one_initcall+0x6d/0x183
[    5.704001]  [<c1c5a4d6>] kernel_init+0x187/0x1ec
[    5.704001]  [<c1c5a34f>] ? kernel_init+0x0/0x1ec
[    5.704001]  [<c102cce7>] kernel_thread_helper+0x7/0x10
[  129.036999] NMI backtrace for cpu 0
[  129.036999]=20
[  129.036999] Pid: 0, comm: swapper Tainted: G        W  (2.6.31 #14941) S=
ystem Product Name
[  129.036999] EIP: 0060:[<c10325b2>] EFLAGS: 00000246 CPU: 0
[  129.036999] EIP is at default_idle+0x9a/0x110
[  129.036999] EAX: 00000000 EBX: c1c560d0 ECX: c102af40 EDX: 00733000
[  129.036999] ESI: 00000000 EDI: c1bd8000 EBP: c1bd6fa0 ESP: c1bd6f7c
[  129.036999]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  129.036999] CR0: 8005003b CR2: 00000000 CR3: 01bd7000 CR4: 000006f0
[  129.036999] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  129.036999] DR6: ffff0ff0 DR7: 00000400
[  129.036999] Call Trace:
[  129.036999]  [<c17e54fb>] ? rest_init+0x7f/0x92
[  129.036999]  [<c102af46>] cpu_idle+0xc0/0xee
[  129.036999]  [<c17e54fb>] rest_init+0x7f/0x92
[  129.036999]  [<c1c5ab50>] start_kernel+0x3f8/0x410
[  129.036999]  [<c1c5a079>] __init_begin+0x79/0x8f
[  129.036999] Pid: 0, comm: swapper Tainted: G        W  2.6.31 #14941
[  129.036999] Call Trace:
[  129.036999]  [<c102ae6f>] ? show_regs+0x34/0x4b
[  129.036999]  [<c1831f4d>] nmi_watchdog_tick+0xea/0x222
[  129.036999]  [<c1831365>] do_nmi+0xa9/0x2a9
[  129.036999]  [<c1830ea0>] nmi_stack_correct+0x2f/0x34
[  129.036999]  [<c102af40>] ? cpu_idle+0xba/0xee
[  129.036999]  [<c10325b2>] ? default_idle+0x9a/0x110
[  129.036999]  [<c17e54fb>] ? rest_init+0x7f/0x92
[  129.036999]  [<c102af46>] cpu_idle+0xc0/0xee
[  129.036999]  [<c17e54fb>] rest_init+0x7f/0x92
[  129.036999]  [<c1c5ab50>] start_kernel+0x3f8/0x410
[  129.036999]  [<c1c5a079>] __init_begin+0x79/0x8f
=03

--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=config

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.31
# Thu Sep 17 19:02:20 2009
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
# CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_KTIME_SCALAR=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
# CONFIG_KERNEL_GZIP is not set
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
# CONFIG_TASK_XACCT is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_TREE=y

#
# RCU Subsystem
#
# CONFIG_TREE_RCU is not set
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_RCU_TRACE=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_EXACT=y
CONFIG_TREE_RCU_TRACE=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=20
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_USER_SCHED=y
# CONFIG_CGROUP_SCHED is not set
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
# CONFIG_CGROUP_NS is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
# CONFIG_CPUSETS is not set
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
CONFIG_CGROUP_MEM_RES_CTLR=y
# CONFIG_CGROUP_MEM_RES_CTLR_SWAP is not set
CONFIG_MM_OWNER=y
# CONFIG_SYSFS_DEPRECATED_V2 is not set
# CONFIG_RELAY is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_EXTRA_PASS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_HAVE_PERF_COUNTERS=y

#
# Performance Counters
#
CONFIG_PERF_COUNTERS=y
# CONFIG_EVENT_PROFILE is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
CONFIG_STRIP_ASM_SYMS=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# CONFIG_MARKERS is not set
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_API_DEBUG=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_SLOW_WORK is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBDAF=y
# CONFIG_BLK_DEV_BSG is not set
CONFIG_BLK_DEV_INTEGRITY=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_AS=y
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="anticipatory"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_SPARSE_IRQ=y
CONFIG_NUMA_IRQ_DESC=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_BIGSMP=y
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_X86_ELAN=y
# CONFIG_X86_RDC321X is not set
CONFIG_X86_32_NON_STANDARD=y
CONFIG_X86_NUMAQ=y
CONFIG_X86_VISWS=y
CONFIG_X86_SUMMIT=y
# CONFIG_X86_ES7000 is not set
CONFIG_SCHED_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
# CONFIG_MEMTEST is not set
CONFIG_X86_SUMMIT_NUMA=y
CONFIG_X86_CYCLONE_TIMER=y
CONFIG_X86_CPU=y
CONFIG_X86_L1_CACHE_BYTES=64
CONFIG_X86_INTERNODE_CACHE_BYTES=64
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=4
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
# CONFIG_X86_DS is not set
# CONFIG_HPET_TIMER is not set
CONFIG_DMI=y
# CONFIG_IOMMU_HELPER is not set
# CONFIG_IOMMU_API is not set
CONFIG_NR_CPUS=32
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_VISWS_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
# CONFIG_X86_OLD_MCE is not set
CONFIG_X86_NEW_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
# CONFIG_X86_ANCIENT_MCE is not set
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
CONFIG_I8K=m
# CONFIG_X86_REBOOTFIXUPS is not set
CONFIG_MICROCODE=m
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
# CONFIG_X86_MSR is not set
CONFIG_X86_CPUID=m
CONFIG_X86_CPU_DEBUG=y
# CONFIG_NOHIGHMEM is not set
# CONFIG_HIGHMEM4G is not set
CONFIG_HIGHMEM64G=y
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_X86_PAE=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_NUMA=y

#
# NUMA (Summit) requires SMP, 64GB highmem support, ACPI
#
CONFIG_NODES_SHIFT=4
CONFIG_HAVE_ARCH_BOOTMEM=y
CONFIG_ARCH_HAVE_MEMORY_PRESENT=y
CONFIG_NEED_NODE_MEMMAP_SIZE=y
CONFIG_HAVE_ARCH_ALLOC_REMAP=y
CONFIG_ARCH_DISCONTIGMEM_ENABLE=y
CONFIG_ARCH_DISCONTIGMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
CONFIG_DISCONTIGMEM_MANUAL=y
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_DISCONTIGMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_HAVE_MLOCK=y
CONFIG_HAVE_MLOCKED_PAGE_BIT=y
CONFIG_MMU_NOTIFIER=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_HIGHPTE=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW_64K=y
CONFIG_MATH_EMULATION=y
# CONFIG_MTRR is not set
# CONFIG_SECCOMP is not set
CONFIG_CC_STACKPROTECTOR_ALL=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
CONFIG_CMDLINE_BOOL=y
CONFIG_CMDLINE=""
# CONFIG_CMDLINE_OVERRIDE is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
# CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID is not set

#
# Power management and ACPI options
#
# CONFIG_PM is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
CONFIG_PCI_GODIRECT=y
# CONFIG_PCI_GOOLPC is not set
# CONFIG_PCI_GOANY is not set
CONFIG_PCI_DIRECT=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
CONFIG_PCIEAER_INJECT=m
# CONFIG_PCIEASPM is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_LEGACY is not set
CONFIG_PCI_DEBUG=y
CONFIG_PCI_STUB=y
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
CONFIG_MCA=y
CONFIG_MCA_LEGACY=y
# CONFIG_MCA_PROC_FS is not set
# CONFIG_SCx200 is not set
# CONFIG_OLPC is not set
CONFIG_PCCARD=m
CONFIG_PCMCIA_DEBUG=y
CONFIG_PCMCIA=m
CONFIG_PCMCIA_LOAD_CIS=y
# CONFIG_PCMCIA_IOCTL is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
CONFIG_PCCARD_NONSTATIC=m
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=m
CONFIG_BINFMT_MISC=m
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_MMAP is not set
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=m
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
# CONFIG_IP_ROUTE_VERBOSE is not set
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
# CONFIG_NET_IPIP is not set
CONFIG_NET_IPGRE=m
# CONFIG_NET_IPGRE_BROADCAST is not set
CONFIG_IP_MROUTE=y
# CONFIG_IP_PIMSM_V1 is not set
# CONFIG_IP_PIMSM_V2 is not set
CONFIG_ARPD=y
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
CONFIG_INET_ESP=m
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
CONFIG_INET_XFRM_MODE_TRANSPORT=m
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
# CONFIG_TCP_CONG_CUBIC is not set
CONFIG_TCP_CONG_WESTWOOD=y
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=y
# CONFIG_TCP_CONG_HYBLA is not set
CONFIG_TCP_CONG_VEGAS=y
CONFIG_TCP_CONG_SCALABLE=y
# CONFIG_TCP_CONG_LP is not set
# CONFIG_TCP_CONG_VENO is not set
# CONFIG_TCP_CONG_YEAH is not set
CONFIG_TCP_CONG_ILLINOIS=m
# CONFIG_DEFAULT_BIC is not set
# CONFIG_DEFAULT_CUBIC is not set
# CONFIG_DEFAULT_HTCP is not set
CONFIG_DEFAULT_VEGAS=y
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="vegas"
CONFIG_TCP_MD5SIG=y
# CONFIG_IPV6 is not set
# CONFIG_NETLABEL is not set
# CONFIG_NETWORK_SECMARK is not set
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
# CONFIG_NETFILTER_NETLINK_QUEUE is not set
# CONFIG_NETFILTER_NETLINK_LOG is not set
# CONFIG_NF_CONNTRACK is not set
# CONFIG_NETFILTER_TPROXY is not set
CONFIG_NETFILTER_XTABLES=y
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=y
# CONFIG_NETFILTER_XT_TARGET_DSCP is not set
CONFIG_NETFILTER_XT_TARGET_HL=m
CONFIG_NETFILTER_XT_TARGET_LED=m
# CONFIG_NETFILTER_XT_TARGET_MARK is not set
# CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
# CONFIG_NETFILTER_XT_TARGET_NFQUEUE is not set
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m
# CONFIG_NETFILTER_XT_MATCH_COMMENT is not set
# CONFIG_NETFILTER_XT_MATCH_DCCP is not set
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ESP=y
# CONFIG_NETFILTER_XT_MATCH_HASHLIMIT is not set
CONFIG_NETFILTER_XT_MATCH_HL=y
CONFIG_NETFILTER_XT_MATCH_IPRANGE=y
# CONFIG_NETFILTER_XT_MATCH_LENGTH is not set
# CONFIG_NETFILTER_XT_MATCH_LIMIT is not set
CONFIG_NETFILTER_XT_MATCH_MAC=y
CONFIG_NETFILTER_XT_MATCH_MARK=m
# CONFIG_NETFILTER_XT_MATCH_MULTIPORT is not set
CONFIG_NETFILTER_XT_MATCH_OWNER=m
# CONFIG_NETFILTER_XT_MATCH_POLICY is not set
# CONFIG_NETFILTER_XT_MATCH_PHYSDEV is not set
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
# CONFIG_NETFILTER_XT_MATCH_QUOTA is not set
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=y
CONFIG_NETFILTER_XT_MATCH_RECENT=y
CONFIG_NETFILTER_XT_MATCH_RECENT_PROC_COMPAT=y
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
# CONFIG_NETFILTER_XT_MATCH_TIME is not set
CONFIG_NETFILTER_XT_MATCH_U32=m
CONFIG_IP_VS=m
CONFIG_IP_VS_DEBUG=y
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
# CONFIG_IP_VS_PROTO_AH is not set

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
# CONFIG_IP_VS_LC is not set
# CONFIG_IP_VS_WLC is not set
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
CONFIG_IP_VS_SED=m
# CONFIG_IP_VS_NQ is not set

#
# IPVS application helper
#
# CONFIG_IP_VS_FTP is not set

#
# IP: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV4 is not set
CONFIG_IP_NF_QUEUE=m
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_MATCH_ADDRTYPE=y
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=y
CONFIG_IP_NF_MATCH_TTL=y
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_LOG=y
CONFIG_IP_NF_TARGET_ULOG=y
CONFIG_IP_NF_MANGLE=y
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
# CONFIG_IP_NF_RAW is not set
CONFIG_IP_NF_SECURITY=y
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
# CONFIG_IP_NF_ARP_MANGLE is not set

#
# DECnet: Netfilter Configuration
#
CONFIG_DECNET_NF_GRABULATOR=m
# CONFIG_BRIDGE_NF_EBTABLES is not set
CONFIG_IP_DCCP=y
CONFIG_INET_DCCP_DIAG=m

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
CONFIG_IP_DCCP_CCID2_DEBUG=y
CONFIG_IP_DCCP_CCID3=y
CONFIG_IP_DCCP_CCID3_DEBUG=y
CONFIG_IP_DCCP_CCID3_RTO=100
CONFIG_IP_DCCP_TFRC_LIB=y
CONFIG_IP_DCCP_TFRC_DEBUG=y

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
# CONFIG_NET_DCCPPROBE is not set
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_MSG is not set
CONFIG_SCTP_DBG_OBJCNT=y
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
# CONFIG_RDS is not set
CONFIG_TIPC=m
CONFIG_TIPC_ADVANCED=y
CONFIG_TIPC_ZONES=3
CONFIG_TIPC_CLUSTERS=1
CONFIG_TIPC_NODES=255
CONFIG_TIPC_SLAVE_NODES=0
CONFIG_TIPC_PORTS=8191
CONFIG_TIPC_LOG=0
CONFIG_TIPC_DEBUG=y
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
# CONFIG_ATM_CLIP_NO_ICMP is not set
# CONFIG_ATM_LANE is not set
# CONFIG_ATM_BR2684 is not set
CONFIG_STP=m
CONFIG_BRIDGE=m
CONFIG_NET_DSA=y
# CONFIG_NET_DSA_TAG_DSA is not set
CONFIG_NET_DSA_TAG_EDSA=y
# CONFIG_NET_DSA_TAG_TRAILER is not set
CONFIG_NET_DSA_MV88E6XXX=y
# CONFIG_NET_DSA_MV88E6060 is not set
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
CONFIG_NET_DSA_MV88E6123_61_65=y
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=m
# CONFIG_LLC2 is not set
CONFIG_IPX=m
CONFIG_IPX_INTERN=y
CONFIG_ATALK=m
# CONFIG_DEV_APPLETALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
CONFIG_ECONET=m
# CONFIG_ECONET_AUNUDP is not set
# CONFIG_ECONET_NATIVE is not set
CONFIG_WAN_ROUTER=y
# CONFIG_PHONET is not set
CONFIG_IEEE802154=y
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=y
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=y
CONFIG_NET_SCH_ATM=m
# CONFIG_NET_SCH_PRIO is not set
CONFIG_NET_SCH_MULTIQ=y
# CONFIG_NET_SCH_RED is not set
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=y
CONFIG_NET_SCH_GRED=y
CONFIG_NET_SCH_DSMARK=y
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_DRR=y
CONFIG_NET_SCH_INGRESS=y

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
CONFIG_NET_CLS_TCINDEX=y
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_ROUTE=y
CONFIG_NET_CLS_FW=y
# CONFIG_NET_CLS_U32 is not set
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
# CONFIG_NET_CLS_FLOW is not set
CONFIG_NET_CLS_CGROUP=y
# CONFIG_NET_EMATCH is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=y
CONFIG_GACT_PROB=y
# CONFIG_NET_ACT_MIRRED is not set
# CONFIG_NET_ACT_IPT is not set
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=y
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_ACT_SKBEDIT=m
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
CONFIG_NET_DROP_MONITOR=y
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=y
CONFIG_AX25_DAMA_SLAVE=y
CONFIG_NETROM=m
# CONFIG_ROSE is not set

#
# AX.25 network device drivers
#
CONFIG_MKISS=m
CONFIG_6PACK=m
CONFIG_BPQETHER=y
CONFIG_BAYCOM_SER_FDX=m
CONFIG_BAYCOM_SER_HDX=y
CONFIG_YAM=y
CONFIG_CAN=m
# CONFIG_CAN_RAW is not set
CONFIG_CAN_BCM=m

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
# CONFIG_CAN_DEV is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=m

#
# IrDA protocols
#
# CONFIG_IRLAN is not set
CONFIG_IRNET=m
# CONFIG_IRCOMM is not set
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
CONFIG_IRDA_FAST_RR=y
CONFIG_IRDA_DEBUG=y

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=m

#
# Dongle support
#
# CONFIG_DONGLE is not set
CONFIG_KINGSUN_DONGLE=m
CONFIG_KSDAZZLE_DONGLE=m
CONFIG_KS959_DONGLE=m

#
# FIR device drivers
#
# CONFIG_USB_IRDA is not set
# CONFIG_SIGMATEL_FIR is not set
# CONFIG_NSC_FIR is not set
CONFIG_WINBOND_FIR=m
CONFIG_TOSHIBA_FIR=m
CONFIG_SMC_IRCC_FIR=m
CONFIG_ALI_FIR=m
CONFIG_VLSI_FIR=m
CONFIG_VIA_FIR=m
CONFIG_MCS_FIR=m
CONFIG_BT=m
# CONFIG_BT_L2CAP is not set
CONFIG_BT_SCO=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=m
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
# CONFIG_BT_HCIUART_BCSP is not set
CONFIG_BT_HCIUART_LL=y
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=m
CONFIG_BT_HCIDTL1=m
# CONFIG_BT_HCIBT3C is not set
CONFIG_BT_HCIBLUECARD=m
CONFIG_BT_HCIBTUART=m
CONFIG_BT_HCIVHCI=m
CONFIG_BT_MRVL=m
CONFIG_AF_RXRPC=y
CONFIG_AF_RXRPC_DEBUG=y
CONFIG_RXKAD=m
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
CONFIG_CFG80211_DEVELOPER_WARNINGS=y
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_CFG80211_DEFAULT_PS=y
CONFIG_CFG80211_DEFAULT_PS_VALUE=1
CONFIG_CFG80211_DEBUGFS=y
# CONFIG_WIRELESS_OLD_REGULATORY is not set
# CONFIG_WIRELESS_EXT is not set
# CONFIG_LIB80211 is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_RC_MINSTREL=y
# CONFIG_MAC80211_RC_DEFAULT_PID is not set
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
CONFIG_MAC80211_DEBUG_MENU=y
CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT=y
CONFIG_MAC80211_NOINLINE=y
CONFIG_MAC80211_VERBOSE_DEBUG=y
# CONFIG_MAC80211_HT_DEBUG is not set
CONFIG_MAC80211_TKIP_DEBUG=y
CONFIG_MAC80211_IBSS_DEBUG=y
CONFIG_MAC80211_VERBOSE_PS_DEBUG=y
# CONFIG_MAC80211_DRIVER_API_TRACER is not set
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_DEBUG_DRIVER=y
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
CONFIG_BLK_CPQ_DA=y
# CONFIG_BLK_CPQ_CISS_DA is not set
CONFIG_BLK_DEV_DAC960=y
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_CRYPTOLOOP=m
CONFIG_BLK_DEV_NBD=y
# CONFIG_BLK_DEV_OSD is not set
CONFIG_BLK_DEV_SX8=m
CONFIG_BLK_DEV_UB=y
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_XIP=y
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
CONFIG_MISC_DEVICES=y
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=m
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_HP_ILO=y
CONFIG_DELL_LAPTOP=m
# CONFIG_ISL29003 is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
CONFIG_EEPROM_AT25=m
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
CONFIG_CB710_CORE=m
CONFIG_CB710_DEBUG=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=m
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_ENCLOSURE=m
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
# CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=y
CONFIG_SCSI_CXGB3_ISCSI=y
# CONFIG_SCSI_BNX2_ISCSI is not set
CONFIG_BLK_DEV_3W_XXXX_RAID=y
CONFIG_SCSI_3W_9XXX=y
# CONFIG_SCSI_ACARD is not set
CONFIG_SCSI_AACRAID=m
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
# CONFIG_AIC7XXX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC7XXX_OLD=m
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=5000
# CONFIG_AIC79XX_DEBUG_ENABLE is not set
CONFIG_AIC79XX_DEBUG_MASK=0
CONFIG_AIC79XX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC94XX=y
CONFIG_AIC94XX_DEBUG=y
CONFIG_SCSI_MVSAS=m
CONFIG_SCSI_MVSAS_DEBUG=y
# CONFIG_SCSI_DPT_I2O is not set
CONFIG_SCSI_ADVANSYS=y
CONFIG_SCSI_ARCMSR=m
CONFIG_SCSI_ARCMSR_AER=y
CONFIG_MEGARAID_NEWGEN=y
# CONFIG_MEGARAID_MM is not set
CONFIG_MEGARAID_LEGACY=y
CONFIG_MEGARAID_SAS=y
CONFIG_SCSI_MPT2SAS=m
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT2SAS_LOGGING=y
CONFIG_SCSI_HPTIOP=m
CONFIG_SCSI_BUSLOGIC=m
CONFIG_SCSI_FLASHPOINT=y
CONFIG_LIBFC=y
CONFIG_LIBFCOE=m
CONFIG_FCOE=m
CONFIG_FCOE_FNIC=m
# CONFIG_SCSI_DMX3191D is not set
CONFIG_SCSI_EATA=y
CONFIG_SCSI_EATA_TAGGED_QUEUE=y
CONFIG_SCSI_EATA_LINKED_COMMANDS=y
CONFIG_SCSI_EATA_MAX_TAGS=16
CONFIG_SCSI_FUTURE_DOMAIN=y
CONFIG_SCSI_FD_MCS=y
CONFIG_SCSI_GDTH=m
CONFIG_SCSI_IBMMCA=m
# CONFIG_IBMMCA_SCSI_ORDER_STANDARD is not set
CONFIG_IBMMCA_SCSI_DEV_RESET=y
CONFIG_SCSI_IPS=m
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
CONFIG_SCSI_NCR_D700=y
CONFIG_SCSI_STEX=m
# CONFIG_SCSI_SYM53C8XX_2 is not set
CONFIG_SCSI_IPR=m
CONFIG_SCSI_IPR_TRACE=y
CONFIG_SCSI_IPR_DUMP=y
CONFIG_SCSI_NCR_Q720=m
CONFIG_SCSI_NCR53C8XX_DEFAULT_TAGS=8
CONFIG_SCSI_NCR53C8XX_MAX_TAGS=32
CONFIG_SCSI_NCR53C8XX_SYNC=20
CONFIG_SCSI_QLOGIC_1280=y
CONFIG_SCSI_QLA_FC=y
CONFIG_SCSI_QLA_ISCSI=y
CONFIG_SCSI_LPFC=y
CONFIG_SCSI_LPFC_DEBUG_FS=y
CONFIG_SCSI_SIM710=m
# CONFIG_SCSI_DC395x is not set
CONFIG_SCSI_DC390T=y
# CONFIG_SCSI_NSP32 is not set
# CONFIG_SCSI_DEBUG is not set
CONFIG_SCSI_PMCRAID=m
# CONFIG_SCSI_SRP is not set
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
CONFIG_PCMCIA_AHA152X=m
CONFIG_PCMCIA_FDOMAIN=m
CONFIG_PCMCIA_NINJA_SCSI=m
# CONFIG_PCMCIA_QLOGIC is not set
# CONFIG_PCMCIA_SYM53C500 is not set
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=m
CONFIG_SCSI_DH_HP_SW=m
# CONFIG_SCSI_DH_EMC is not set
CONFIG_SCSI_DH_ALUA=m
CONFIG_SCSI_OSD_INITIATOR=m
CONFIG_SCSI_OSD_ULD=m
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
# CONFIG_SATA_PMP is not set
CONFIG_SATA_AHCI=y
CONFIG_SATA_SIL24=y
CONFIG_ATA_SFF=y
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=y
CONFIG_SATA_MV=m
CONFIG_SATA_NV=y
CONFIG_PDC_ADMA=y
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
CONFIG_SATA_SX4=m
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
CONFIG_SATA_VIA=y
CONFIG_SATA_VITESSE=m
# CONFIG_SATA_INIC162X is not set
# CONFIG_PATA_ALI is not set
CONFIG_PATA_AMD=y
CONFIG_PATA_ARTOP=y
CONFIG_PATA_ATIIXP=y
CONFIG_PATA_CMD640_PCI=y
CONFIG_PATA_CMD64X=m
CONFIG_PATA_CS5520=m
CONFIG_PATA_CS5530=y
CONFIG_PATA_CS5535=m
CONFIG_PATA_CS5536=m
CONFIG_PATA_CYPRESS=y
CONFIG_PATA_EFAR=m
CONFIG_ATA_GENERIC=y
CONFIG_PATA_HPT366=m
CONFIG_PATA_HPT37X=y
CONFIG_PATA_HPT3X2N=y
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
CONFIG_PATA_JMICRON=m
CONFIG_PATA_TRIFLEX=y
CONFIG_PATA_MARVELL=y
# CONFIG_PATA_MPIIX is not set
CONFIG_PATA_OLDPIIX=y
CONFIG_PATA_NETCELL=y
CONFIG_PATA_NINJA32=m
CONFIG_PATA_NS87410=m
CONFIG_PATA_NS87415=y
CONFIG_PATA_OPTI=y
# CONFIG_PATA_OPTIDMA is not set
CONFIG_PATA_PCMCIA=m
CONFIG_PATA_PDC_OLD=y
# CONFIG_PATA_RADISYS is not set
CONFIG_PATA_RDC=y
CONFIG_PATA_RZ1000=m
CONFIG_PATA_SC1200=m
# CONFIG_PATA_SERVERWORKS is not set
CONFIG_PATA_PDC2027X=m
CONFIG_PATA_SIL680=m
CONFIG_PATA_SIS=m
# CONFIG_PATA_VIA is not set
CONFIG_PATA_WINBOND=y
CONFIG_PATA_SCH=m
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=y
# CONFIG_MD_RAID0 is not set
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
CONFIG_MD_RAID6_PQ=m
CONFIG_MD_MULTIPATH=y
CONFIG_MD_FAULTY=y
CONFIG_BLK_DEV_DM=y
CONFIG_DM_DEBUG=y
CONFIG_DM_CRYPT=m
# CONFIG_DM_SNAPSHOT is not set
# CONFIG_DM_MIRROR is not set
CONFIG_DM_ZERO=y
# CONFIG_DM_MULTIPATH is not set
CONFIG_DM_DELAY=y
# CONFIG_DM_UEVENT is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
# CONFIG_FUSION_FC is not set
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=128
# CONFIG_FUSION_CTL is not set
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#

#
# You can enable one or both FireWire driver stacks.
#

#
# See the help texts for more information.
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_OHCI_DEBUG=y
CONFIG_FIREWIRE_SBP2=y
# CONFIG_FIREWIRE_NET is not set
CONFIG_IEEE1394=y
CONFIG_IEEE1394_OHCI1394=y
CONFIG_IEEE1394_PCILYNX=y
CONFIG_IEEE1394_SBP2=y
CONFIG_IEEE1394_SBP2_PHYS_DMA=y
CONFIG_IEEE1394_ETH1394_ROM_ENTRY=y
CONFIG_IEEE1394_ETH1394=y
CONFIG_IEEE1394_RAWIO=m
CONFIG_IEEE1394_VIDEO1394=m
CONFIG_IEEE1394_DV1394=y
# CONFIG_IEEE1394_VERBOSEDEBUG is not set
CONFIG_I2O=y
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_EXT_ADAPTEC_DMA64=y
CONFIG_I2O_CONFIG=m
CONFIG_I2O_CONFIG_OLD_IOCTL=y
CONFIG_I2O_BUS=y
# CONFIG_I2O_BLOCK is not set
CONFIG_I2O_SCSI=m
CONFIG_I2O_PROC=m
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_IFB=m
# CONFIG_DUMMY is not set
# CONFIG_BONDING is not set
CONFIG_MACVLAN=m
CONFIG_EQUALIZER=y
CONFIG_TUN=m
CONFIG_VETH=m
# CONFIG_ARCNET is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=m
CONFIG_DAVICOM_PHY=m
CONFIG_QSEMI_PHY=m
CONFIG_LXT_PHY=m
CONFIG_CICADA_PHY=m
# CONFIG_VITESSE_PHY is not set
CONFIG_SMSC_PHY=y
# CONFIG_BROADCOM_PHY is not set
CONFIG_ICPLUS_PHY=y
CONFIG_REALTEK_PHY=y
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
CONFIG_LSI_ET1011C_PHY=y
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=m
CONFIG_MDIO_GPIO=m
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
CONFIG_HAPPYMEAL=y
# CONFIG_SUNGEM is not set
CONFIG_CASSINI=m
CONFIG_NET_VENDOR_3COM=y
CONFIG_EL3=m
CONFIG_ELMC=m
CONFIG_ELMC_II=m
CONFIG_VORTEX=y
CONFIG_TYPHOON=m
CONFIG_NET_VENDOR_SMC=y
# CONFIG_ULTRAMCA is not set
CONFIG_ENC28J60=y
CONFIG_ENC28J60_WRITEVERIFY=y
CONFIG_ETHOC=m
CONFIG_DNET=m
CONFIG_NET_TULIP=y
# CONFIG_DE2104X is not set
CONFIG_TULIP=m
CONFIG_TULIP_MWI=y
# CONFIG_TULIP_MMIO is not set
CONFIG_TULIP_NAPI=y
CONFIG_TULIP_NAPI_HW_MITIGATION=y
CONFIG_DE4X5=m
# CONFIG_WINBOND_840 is not set
CONFIG_DM9102=y
CONFIG_ULI526X=m
CONFIG_PCMCIA_XIRCOM=m
CONFIG_AT1700=m
CONFIG_DEPCA=y
# CONFIG_HP100 is not set
CONFIG_NE2_MCA=m
# CONFIG_IBMLANA is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=y
CONFIG_PCNET32=y
# CONFIG_AMD8111_ETH is not set
CONFIG_ADAPTEC_STARFIRE=y
CONFIG_B44=y
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_FORCEDETH=y
CONFIG_FORCEDETH_NAPI=y
CONFIG_E100=y
CONFIG_FEALNX=y
# CONFIG_NATSEMI is not set
CONFIG_NE2K_PCI=m
# CONFIG_8139CP is not set
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
# CONFIG_8139TOO_TUNE_TWISTER is not set
CONFIG_8139TOO_8129=y
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R6040=m
# CONFIG_SIS900 is not set
CONFIG_EPIC100=m
CONFIG_SMSC9420=m
CONFIG_SUNDANCE=m
CONFIG_SUNDANCE_MMIO=y
# CONFIG_TLAN is not set
# CONFIG_KS8842 is not set
CONFIG_KS8851=y
CONFIG_VIA_RHINE=y
# CONFIG_VIA_RHINE_MMIO is not set
CONFIG_SC92031=y
CONFIG_ATL2=y
CONFIG_NETDEV_1000=y
CONFIG_ACENIC=y
CONFIG_ACENIC_OMIT_TIGON_I=y
# CONFIG_DL2K is not set
CONFIG_E1000=m
CONFIG_E1000E=y
CONFIG_IP1000=m
CONFIG_IGB=m
CONFIG_IGBVF=y
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
CONFIG_YELLOWFIN=m
CONFIG_R8169=m
CONFIG_SIS190=y
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_TIGON3=y
CONFIG_BNX2=m
# CONFIG_CNIC is not set
CONFIG_QLA3XXX=y
CONFIG_ATL1=y
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
CONFIG_JME=y
CONFIG_NETDEV_10000=y
CONFIG_MDIO=y
CONFIG_CHELSIO_T1=y
CONFIG_CHELSIO_T1_1G=y
CONFIG_CHELSIO_T3_DEPENDS=y
CONFIG_CHELSIO_T3=y
# CONFIG_ENIC is not set
CONFIG_IXGBE=m
CONFIG_IXGB=m
CONFIG_S2IO=y
# CONFIG_VXGE is not set
# CONFIG_MYRI10GE is not set
# CONFIG_NETXEN_NIC is not set
CONFIG_NIU=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
# CONFIG_TEHUTI is not set
CONFIG_BNX2X=y
# CONFIG_QLGE is not set
# CONFIG_SFC is not set
CONFIG_BE2NET=y
CONFIG_TR=m
CONFIG_IBMTR=m
CONFIG_IBMOL=m
# CONFIG_IBMLS is not set
CONFIG_3C359=m
CONFIG_TMS380TR=m
CONFIG_TMSPCI=m
CONFIG_ABYSS=m
CONFIG_MADGEMC=m
# CONFIG_SMCTR is not set
# CONFIG_WLAN is not set

#
# WiMAX Wireless Broadband devices
#

#
# Enable MMC support to see WiMAX SDIO drivers
#
# CONFIG_WIMAX_I2400M_USB is not set

#
# USB Network Adapters
#
CONFIG_USB_CATC=m
CONFIG_USB_KAWETH=m
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
CONFIG_USB_USBNET=y
# CONFIG_USB_NET_AX8817X is not set
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_CDC_EEM=y
# CONFIG_USB_NET_DM9601 is not set
CONFIG_USB_NET_SMSC95XX=m
CONFIG_USB_NET_GL620A=m
CONFIG_USB_NET_NET1080=m
CONFIG_USB_NET_PLUSB=y
CONFIG_USB_NET_MCS7830=m
CONFIG_USB_NET_RNDIS_HOST=m
CONFIG_USB_NET_CDC_SUBSET=y
# CONFIG_USB_ALI_M5632 is not set
# CONFIG_USB_AN2720 is not set
CONFIG_USB_BELKIN=y
# CONFIG_USB_ARMLINUX is not set
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=y
CONFIG_USB_HSO=m
# CONFIG_USB_NET_INT51X1 is not set
CONFIG_NET_PCMCIA=y
# CONFIG_PCMCIA_3C589 is not set
# CONFIG_PCMCIA_3C574 is not set
# CONFIG_PCMCIA_FMVJ18X is not set
CONFIG_PCMCIA_PCNET=m
CONFIG_PCMCIA_NMCLAN=m
CONFIG_PCMCIA_SMC91C92=m
CONFIG_PCMCIA_XIRC2PS=m
CONFIG_PCMCIA_AXNET=m
CONFIG_PCMCIA_IBMTR=m
CONFIG_WAN=y
# CONFIG_LANMEDIA is not set
CONFIG_HDLC=y
CONFIG_HDLC_RAW=m
CONFIG_HDLC_RAW_ETH=m
CONFIG_HDLC_CISCO=m
CONFIG_HDLC_FR=y
# CONFIG_HDLC_PPP is not set

#
# X.25/LAPB support is disabled
#
# CONFIG_PCI200SYN is not set
CONFIG_WANXL=y
CONFIG_PC300TOO=y
CONFIG_FARSYNC=y
CONFIG_DSCC4=m
# CONFIG_DSCC4_PCISYNC is not set
CONFIG_DSCC4_PCI_RST=y
# CONFIG_DLCI is not set
CONFIG_WAN_ROUTER_DRIVERS=m
# CONFIG_CYCLADES_SYNC is not set
# CONFIG_SBNI is not set
CONFIG_ATM_DRIVERS=y
CONFIG_ATM_DUMMY=m
CONFIG_ATM_TCP=m
CONFIG_ATM_LANAI=m
# CONFIG_ATM_ENI is not set
CONFIG_ATM_FIRESTREAM=m
CONFIG_ATM_ZATM=m
CONFIG_ATM_ZATM_DEBUG=y
# CONFIG_ATM_NICSTAR is not set
# CONFIG_ATM_IDT77252 is not set
CONFIG_ATM_AMBASSADOR=m
CONFIG_ATM_AMBASSADOR_DEBUG=y
CONFIG_ATM_HORIZON=m
CONFIG_ATM_HORIZON_DEBUG=y
CONFIG_ATM_IA=m
# CONFIG_ATM_IA_DEBUG is not set
# CONFIG_ATM_FORE200E is not set
CONFIG_ATM_HE=m
CONFIG_ATM_HE_USE_SUNI=y
CONFIG_ATM_SOLOS=m
# CONFIG_IEEE802154_DRIVERS is not set
CONFIG_FDDI=m
# CONFIG_DEFXX is not set
CONFIG_SKFP=m
CONFIG_HIPPI=y
CONFIG_ROADRUNNER=y
CONFIG_ROADRUNNER_LARGE_RINGS=y
CONFIG_PPP=y
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=y
CONFIG_PPP_SYNC_TTY=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_MPPE=y
CONFIG_PPPOE=y
CONFIG_PPPOATM=m
CONFIG_PPPOL2TP=m
CONFIG_SLIP=y
# CONFIG_SLIP_COMPRESSED is not set
CONFIG_SLHC=y
CONFIG_SLIP_SMART=y
# CONFIG_SLIP_MODE_SLIP6 is not set
CONFIG_NET_FC=y
CONFIG_NETCONSOLE=y
# CONFIG_NETCONSOLE_DYNAMIC is not set
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_ISDN=y
# CONFIG_ISDN_I4L is not set
# CONFIG_MISDN is not set
# CONFIG_ISDN_CAPI is not set
CONFIG_PHONE=m
# CONFIG_PHONE_IXJ is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_LKKBD is not set
CONFIG_KEYBOARD_GPIO=y
CONFIG_KEYBOARD_MATRIX=m
CONFIG_KEYBOARD_LM8323=m
# CONFIG_KEYBOARD_NEWTON is not set
CONFIG_KEYBOARD_STOWAWAY=y
# CONFIG_KEYBOARD_SUNKBD is not set
CONFIG_KEYBOARD_TWL4030=y
CONFIG_KEYBOARD_XTKBD=y
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
# CONFIG_MOUSE_PS2_SENTELIC is not set
CONFIG_MOUSE_PS2_TOUCHKIT=y
CONFIG_MOUSE_SERIAL=m
CONFIG_MOUSE_APPLETOUCH=m
CONFIG_MOUSE_BCM5974=m
CONFIG_MOUSE_VSXXXAA=y
CONFIG_MOUSE_GPIO=m
CONFIG_MOUSE_SYNAPTICS_I2C=y
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=m
CONFIG_TABLET_USB_AIPTEK=m
# CONFIG_TABLET_USB_GTCO is not set
CONFIG_TABLET_USB_KBTAB=m
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_ADS7846=m
# CONFIG_TOUCHSCREEN_AD7877 is not set
# CONFIG_TOUCHSCREEN_AD7879_I2C is not set
CONFIG_TOUCHSCREEN_AD7879_SPI=y
CONFIG_TOUCHSCREEN_AD7879=y
CONFIG_TOUCHSCREEN_DA9034=y
# CONFIG_TOUCHSCREEN_EETI is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
CONFIG_TOUCHSCREEN_WACOM_W8001=y
CONFIG_TOUCHSCREEN_MTOUCH=y
CONFIG_TOUCHSCREEN_INEXIO=y
CONFIG_TOUCHSCREEN_MK712=y
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
CONFIG_TOUCHSCREEN_TOUCHWIN=y
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_TOUCHSCREEN_USB_JASTEC=y
# CONFIG_TOUCHSCREEN_USB_E2I is not set
CONFIG_TOUCHSCREEN_TOUCHIT213=m
CONFIG_TOUCHSCREEN_TSC2007=m
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
CONFIG_SERIO_CT82C710=m
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
# CONFIG_DEVKMEM is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_CS=m
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
# CONFIG_SERIAL_8250_MANY_PORTS is not set
# CONFIG_SERIAL_8250_SHARE_IRQ is not set
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_8250_MCA=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
# CONFIG_RTC is not set
CONFIG_GEN_RTC=m
CONFIG_GEN_RTC_X=y
CONFIG_R3964=y
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=m
CONFIG_CARDMAN_4000=m
CONFIG_CARDMAN_4040=m
CONFIG_IPWIRELESS=m
CONFIG_MWAVE=y
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
CONFIG_CS5535_GPIO=m
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=m
CONFIG_I2C_ALI1563=y
CONFIG_I2C_ALI15X3=y
CONFIG_I2C_AMD756=m
# CONFIG_I2C_AMD756_S4882 is not set
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=m
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=y
# CONFIG_I2C_NFORCE2_S4985 is not set
CONFIG_I2C_SIS5595=y
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_GPIO=y
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_SIMTEC is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT_LIGHT=m
CONFIG_I2C_TAOS_EVM=m
CONFIG_I2C_TINY_USB=m

#
# Graphics adapter I2C/DDC channel drivers
#
CONFIG_I2C_VOODOO3=m

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_STUB is not set
CONFIG_SCx200_ACB=m

#
# Miscellaneous I2C Chip support
#
CONFIG_DS1682=y
CONFIG_SENSORS_PCA9539=m
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
CONFIG_I2C_DEBUG_ALGO=y
CONFIG_I2C_DEBUG_BUS=y
CONFIG_I2C_DEBUG_CHIP=y
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_BITBANG=m
# CONFIG_SPI_GPIO is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
CONFIG_SPI_TLE62X0=y

#
# PPS support
#
# CONFIG_PPS is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y

#
# Memory mapped GPIO expanders:
#

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_TWL4030=m

#
# PCI GPIO expanders:
#
CONFIG_GPIO_BT8XX=y

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=m
# CONFIG_GPIO_MCP23S08 is not set
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=m
# CONFIG_W1_MASTER_DS2482 is not set
CONFIG_W1_MASTER_GPIO=m

#
# 1-wire Slaves
#
# CONFIG_W1_SLAVE_THERM is not set
CONFIG_W1_SLAVE_SMEM=m
# CONFIG_W1_SLAVE_DS2431 is not set
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=m
CONFIG_BATTERY_DS2760=y
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_DA9030 is not set
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_CHARGER_PCF50633=m
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
CONFIG_SENSORS_ABITUGURU=m
# CONFIG_SENSORS_ABITUGURU3 is not set
CONFIG_SENSORS_AD7414=y
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADCXX=y
# CONFIG_SENSORS_ADM1021 is not set
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=y
CONFIG_SENSORS_ADM1029=m
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7462=y
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7473=y
CONFIG_SENSORS_ADT7475=m
# CONFIG_SENSORS_K8TEMP is not set
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=m
# CONFIG_SENSORS_FSCHER is not set
# CONFIG_SENSORS_FSCPOS is not set
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_G760A=y
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=y
# CONFIG_SENSORS_CORETEMP is not set
CONFIG_SENSORS_IT87=y
CONFIG_SENSORS_LM63=y
# CONFIG_SENSORS_LM70 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
CONFIG_SENSORS_LM78=m
# CONFIG_SENSORS_LM80 is not set
CONFIG_SENSORS_LM83=y
CONFIG_SENSORS_LM85=m
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
CONFIG_SENSORS_LTC4215=m
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_MAX1111 is not set
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_PCF8591=m
# CONFIG_SENSORS_SHT15 is not set
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_DME1737=m
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=y
CONFIG_SENSORS_ADS7828=m
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP401 is not set
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=y
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=m
# CONFIG_SENSORS_W83L785TS is not set
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=y
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_HDAPS is not set
CONFIG_SENSORS_LIS3_SPI=m
CONFIG_SENSORS_APPLESMC=m
CONFIG_HWMON_DEBUG_CHIP=y
CONFIG_THERMAL=m
CONFIG_THERMAL_HWMON=y
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
CONFIG_TWL4030_WATCHDOG=m
CONFIG_ACQUIRE_WDT=m
CONFIG_ADVANTECH_WDT=y
CONFIG_ALIM1535_WDT=y
CONFIG_ALIM7101_WDT=m
# CONFIG_SC520_WDT is not set
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
CONFIG_IBMASR=m
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=y
# CONFIG_ITCO_WDT is not set
CONFIG_IT8712F_WDT=y
# CONFIG_IT87_WDT is not set
CONFIG_HP_WATCHDOG=m
CONFIG_SC1200_WDT=y
# CONFIG_PC87413_WDT is not set
CONFIG_60XX_WDT=y
CONFIG_SBC8360_WDT=y
# CONFIG_SBC7240_WDT is not set
CONFIG_CPU5_WDT=m
# CONFIG_SMSC_SCH311X_WDT is not set
CONFIG_SMSC37B787_WDT=y
CONFIG_W83627HF_WDT=y
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
CONFIG_W83877F_WDT=m
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=y
CONFIG_WDTPCI=m

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=y
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
# CONFIG_SSB_B43_PCI_BRIDGE is not set
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=m
CONFIG_MFD_SM501=y
CONFIG_MFD_SM501_GPIO=y
# CONFIG_HTC_PASIC3 is not set
CONFIG_TPS65010=y
CONFIG_TWL4030_CORE=y
# CONFIG_MFD_TMIO is not set
CONFIG_PMIC_DA903X=y
CONFIG_MFD_WM8400=m
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_PCF50633=y
# CONFIG_PCF50633_ADC is not set
# CONFIG_PCF50633_GPIO is not set
# CONFIG_AB3100_CORE is not set
CONFIG_EZX_PCAP=y
# CONFIG_REGULATOR is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
CONFIG_VIDEO_ALLOW_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_DVB_CORE=y
CONFIG_VIDEO_MEDIA=m

#
# Multimedia drivers
#
CONFIG_VIDEO_SAA7146=m
CONFIG_VIDEO_SAA7146_VV=m
# CONFIG_MEDIA_ATTACH is not set
CONFIG_MEDIA_TUNER=m
CONFIG_MEDIA_TUNER_CUSTOMISE=y
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
# CONFIG_MEDIA_TUNER_MT20XX is not set
CONFIG_MEDIA_TUNER_MT2060=m
CONFIG_MEDIA_TUNER_MT2266=m
# CONFIG_MEDIA_TUNER_MT2131 is not set
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC2028=m
# CONFIG_MEDIA_TUNER_XC5000 is not set
CONFIG_MEDIA_TUNER_MXL5005S=m
CONFIG_MEDIA_TUNER_MXL5007T=m
CONFIG_MEDIA_TUNER_MC44S803=m
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_V4L1=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEO_IR=m
# CONFIG_VIDEO_CAPTURE_DRIVERS is not set
# CONFIG_RADIO_ADAPTERS is not set
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y
CONFIG_DVB_CAPTURE_DRIVERS=y

#
# Supported SAA7146 based PCI Adapters
#
CONFIG_TTPCI_EEPROM=m
CONFIG_DVB_AV7110=m
CONFIG_DVB_AV7110_OSD=y
# CONFIG_DVB_BUDGET_CORE is not set

#
# Supported USB Adapters
#
CONFIG_DVB_USB=y
# CONFIG_DVB_USB_DEBUG is not set
CONFIG_DVB_USB_A800=y
CONFIG_DVB_USB_DIBUSB_MB=m
CONFIG_DVB_USB_DIBUSB_MB_FAULTY=y
# CONFIG_DVB_USB_DIBUSB_MC is not set
CONFIG_DVB_USB_DIB0700=y
CONFIG_DVB_USB_UMT_010=y
CONFIG_DVB_USB_CXUSB=y
CONFIG_DVB_USB_M920X=y
# CONFIG_DVB_USB_GL861 is not set
# CONFIG_DVB_USB_AU6610 is not set
# CONFIG_DVB_USB_DIGITV is not set
# CONFIG_DVB_USB_VP7045 is not set
CONFIG_DVB_USB_VP702X=y
CONFIG_DVB_USB_GP8PSK=m
CONFIG_DVB_USB_NOVA_T_USB2=m
CONFIG_DVB_USB_TTUSB2=m
CONFIG_DVB_USB_DTT200U=m
CONFIG_DVB_USB_OPERA1=m
# CONFIG_DVB_USB_AF9005 is not set
CONFIG_DVB_USB_DW2102=y
CONFIG_DVB_USB_CINERGY_T2=y
CONFIG_DVB_USB_ANYSEE=y
CONFIG_DVB_USB_DTV5100=y
CONFIG_DVB_USB_AF9015=y
CONFIG_DVB_USB_CE6230=m
CONFIG_DVB_TTUSB_BUDGET=m
CONFIG_DVB_TTUSB_DEC=y
CONFIG_SMS_SIANO_MDTV=m

#
# Siano module components
#
# CONFIG_SMS_USB_DRV is not set

#
# Supported FlexCopII (B2C2) Adapters
#
CONFIG_DVB_B2C2_FLEXCOP=y
CONFIG_DVB_B2C2_FLEXCOP_PCI=m
# CONFIG_DVB_B2C2_FLEXCOP_USB is not set
CONFIG_DVB_B2C2_FLEXCOP_DEBUG=y

#
# Supported BT878 Adapters
#

#
# Supported Pluto2 Adapters
#
CONFIG_DVB_PLUTO2=y

#
# Supported SDMC DM1105 Adapters
#
CONFIG_DVB_DM1105=m

#
# Supported FireWire (IEEE 1394) Adapters
#
CONFIG_DVB_FIREDTV=y
CONFIG_DVB_FIREDTV_IEEE1394=y
CONFIG_DVB_FIREDTV_INPUT=y

#
# Supported DVB Frontends
#
CONFIG_DVB_FE_CUSTOMISE=y

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=m
# CONFIG_DVB_STB6100 is not set
CONFIG_DVB_STV090x=y
CONFIG_DVB_STV6110x=y

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=m
CONFIG_DVB_CX24123=y
CONFIG_DVB_MT312=m
CONFIG_DVB_ZL10036=m
CONFIG_DVB_ZL10039=m
# CONFIG_DVB_S5H1420 is not set
CONFIG_DVB_STV0288=y
CONFIG_DVB_STB6000=y
CONFIG_DVB_STV0299=y
CONFIG_DVB_STV6110=m
CONFIG_DVB_STV0900=y
# CONFIG_DVB_TDA8083 is not set
CONFIG_DVB_TDA10086=m
# CONFIG_DVB_TDA8261 is not set
# CONFIG_DVB_VES1X93 is not set
CONFIG_DVB_TUNER_ITD1000=y
CONFIG_DVB_TUNER_CX24113=y
CONFIG_DVB_TDA826X=y
CONFIG_DVB_TUA6100=m
CONFIG_DVB_CX24116=y
CONFIG_DVB_SI21XX=y

#
# DVB-T (terrestrial) frontends
#
# CONFIG_DVB_SP8870 is not set
CONFIG_DVB_SP887X=m
CONFIG_DVB_CX22700=m
CONFIG_DVB_CX22702=y
CONFIG_DVB_DRX397XD=y
CONFIG_DVB_L64781=m
CONFIG_DVB_TDA1004X=y
# CONFIG_DVB_NXT6000 is not set
# CONFIG_DVB_MT352 is not set
CONFIG_DVB_ZL10353=m
CONFIG_DVB_DIB3000MB=y
CONFIG_DVB_DIB3000MC=y
CONFIG_DVB_DIB7000M=m
CONFIG_DVB_DIB7000P=m
CONFIG_DVB_TDA10048=m
CONFIG_DVB_AF9013=y

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=m
CONFIG_DVB_TDA10021=m
# CONFIG_DVB_TDA10023 is not set
CONFIG_DVB_STV0297=y

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
# CONFIG_DVB_NXT200X is not set
CONFIG_DVB_OR51211=m
CONFIG_DVB_OR51132=m
CONFIG_DVB_BCM3510=m
CONFIG_DVB_LGDT330X=y
CONFIG_DVB_LGDT3304=m
CONFIG_DVB_LGDT3305=y
CONFIG_DVB_S5H1409=y
CONFIG_DVB_AU8522=m
CONFIG_DVB_S5H1411=m

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=m

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=m
# CONFIG_DVB_TUNER_DIB0070 is not set

#
# SEC control devices for DVB-S
#
CONFIG_DVB_LNBP21=m
# CONFIG_DVB_ISL6405 is not set
# CONFIG_DVB_ISL6421 is not set
CONFIG_DVB_ISL6423=y
CONFIG_DVB_LGS8GL5=m
CONFIG_DVB_LGS8GXX=m

#
# Tools to develop new frontends
#
CONFIG_DVB_DUMMY_FE=y
CONFIG_DAB=y
CONFIG_USB_DABUSB=y

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
# CONFIG_FB is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_LCD_LTV350QV=m
CONFIG_LCD_ILI9320=m
CONFIG_LCD_TDO24M=m
CONFIG_LCD_VGG2432A4=m
CONFIG_LCD_PLATFORM=m
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_PROGEAR is not set
CONFIG_BACKLIGHT_DA903X=m
CONFIG_BACKLIGHT_MBP_NVIDIA=y
# CONFIG_BACKLIGHT_SAHARA is not set

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=y

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FONT_8x16=y
CONFIG_SOUND=m
# CONFIG_SOUND_OSS_CORE is not set
# CONFIG_SND is not set
# CONFIG_SOUND_PRIME is not set
# CONFIG_HID_SUPPORT is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
CONFIG_USB_DEBUG=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
CONFIG_USB_DYNAMIC_MINORS=y
# CONFIG_USB_OTG is not set
# CONFIG_USB_MON is not set
CONFIG_USB_WUSB=y
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=m
CONFIG_USB_XHCI_HCD_DEBUGGING=y
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_OXU210HP_HCD=m
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_ISP1760_HCD=y
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_SSB=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_U132_HCD=m
CONFIG_USB_SL811_HCD=y
# CONFIG_USB_SL811_CS is not set
CONFIG_USB_R8A66597_HCD=y
# CONFIG_USB_WHCI_HCD is not set
CONFIG_USB_HWA_HCD=y

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=m
# CONFIG_USB_WDM is not set
CONFIG_USB_TMC=y

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
CONFIG_USB_STORAGE_DEBUG=y
CONFIG_USB_STORAGE_DATAFAB=m
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=m
CONFIG_USB_STORAGE_SDDR55=y
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
CONFIG_USB_STORAGE_ONETOUCH=y
CONFIG_USB_STORAGE_KARMA=y
CONFIG_USB_STORAGE_CYPRESS_ATACB=y
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
CONFIG_USB_MICROTEK=m

#
# USB port drivers
#
CONFIG_USB_SERIAL=m
CONFIG_USB_EZUSB=y
# CONFIG_USB_SERIAL_GENERIC is not set
CONFIG_USB_SERIAL_AIRCABLE=m
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=m
CONFIG_USB_SERIAL_CH341=m
# CONFIG_USB_SERIAL_WHITEHEAT is not set
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
# CONFIG_USB_SERIAL_CP210X is not set
CONFIG_USB_SERIAL_CYPRESS_M8=m
# CONFIG_USB_SERIAL_EMPEG is not set
# CONFIG_USB_SERIAL_FTDI_SIO is not set
# CONFIG_USB_SERIAL_FUNSOFT is not set
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_IR=m
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
# CONFIG_USB_SERIAL_GARMIN is not set
CONFIG_USB_SERIAL_IPW=m
# CONFIG_USB_SERIAL_IUU is not set
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
CONFIG_USB_SERIAL_KEYSPAN=m
CONFIG_USB_SERIAL_KEYSPAN_MPR=y
# CONFIG_USB_SERIAL_KEYSPAN_USA28 is not set
CONFIG_USB_SERIAL_KEYSPAN_USA28X=y
# CONFIG_USB_SERIAL_KEYSPAN_USA28XA is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA28XB is not set
CONFIG_USB_SERIAL_KEYSPAN_USA19=y
CONFIG_USB_SERIAL_KEYSPAN_USA18X=y
CONFIG_USB_SERIAL_KEYSPAN_USA19W=y
# CONFIG_USB_SERIAL_KEYSPAN_USA19QW is not set
CONFIG_USB_SERIAL_KEYSPAN_USA19QI=y
# CONFIG_USB_SERIAL_KEYSPAN_USA49W is not set
# CONFIG_USB_SERIAL_KEYSPAN_USA49WLC is not set
# CONFIG_USB_SERIAL_KLSI is not set
CONFIG_USB_SERIAL_KOBIL_SCT=m
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
CONFIG_USB_SERIAL_MOS7840=m
CONFIG_USB_SERIAL_MOTOROLA=m
CONFIG_USB_SERIAL_NAVMAN=m
# CONFIG_USB_SERIAL_PL2303 is not set
# CONFIG_USB_SERIAL_OTI6858 is not set
CONFIG_USB_SERIAL_QUALCOMM=m
CONFIG_USB_SERIAL_SPCP8X5=m
# CONFIG_USB_SERIAL_HP4X is not set
# CONFIG_USB_SERIAL_SAFE is not set
CONFIG_USB_SERIAL_SIEMENS_MPI=m
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
# CONFIG_USB_SERIAL_SYMBOL is not set
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
CONFIG_USB_SERIAL_OPTICON=m
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
CONFIG_USB_RIO500=y
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
CONFIG_USB_CYPRESS_CY7C63=m
CONFIG_USB_CYTHERM=m
CONFIG_USB_IDMOUSE=y
CONFIG_USB_FTDI_ELAN=y
CONFIG_USB_APPLEDISPLAY=m
CONFIG_USB_SISUSBVGA=y
CONFIG_USB_SISUSBVGA_CON=y
CONFIG_USB_LD=m
# CONFIG_USB_TRANCEVIBRATOR is not set
CONFIG_USB_IOWARRIOR=m
CONFIG_USB_TEST=m
# CONFIG_USB_ISIGHTFW is not set
CONFIG_USB_VST=y
CONFIG_USB_ATM=m
# CONFIG_USB_SPEEDTOUCH is not set
# CONFIG_USB_CXACRU is not set
CONFIG_USB_UEAGLEATM=m
CONFIG_USB_XUSBATM=m
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
CONFIG_USB_GPIO_VBUS=m
CONFIG_NOP_USB_XCEIV=m
CONFIG_UWB=y
CONFIG_UWB_HWA=y
CONFIG_UWB_WHCI=m
CONFIG_UWB_WLP=m
CONFIG_UWB_I1480U=y
# CONFIG_UWB_I1480U_WLP is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
CONFIG_LEDS_ALIX2=m
CONFIG_LEDS_PCA9532=m
CONFIG_LEDS_GPIO=m
CONFIG_LEDS_GPIO_PLATFORM=y
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=m
CONFIG_LEDS_DA903X=m
CONFIG_LEDS_DAC124S085=m
CONFIG_LEDS_BD2802=m

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=y
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
CONFIG_LEDS_TRIGGER_GPIO=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=m
# CONFIG_INFINIBAND_USER_MAD is not set
# CONFIG_INFINIBAND_USER_ACCESS is not set
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=m
CONFIG_INFINIBAND_MTHCA_DEBUG=y
# CONFIG_INFINIBAND_AMSO1100 is not set
CONFIG_INFINIBAND_CXGB3=m
CONFIG_INFINIBAND_CXGB3_DEBUG=y
# CONFIG_MLX4_INFINIBAND is not set
# CONFIG_INFINIBAND_NES is not set
CONFIG_INFINIBAND_IPOIB=m
CONFIG_INFINIBAND_IPOIB_CM=y
CONFIG_INFINIBAND_IPOIB_DEBUG=y
CONFIG_INFINIBAND_IPOIB_DEBUG_DATA=y
# CONFIG_INFINIBAND_SRP is not set
CONFIG_INFINIBAND_ISER=m
CONFIG_EDAC=y

#
# Reporting subsystems
#
CONFIG_EDAC_DEBUG=y
CONFIG_EDAC_DEBUG_VERBOSE=y
CONFIG_EDAC_MM_EDAC=m
# CONFIG_EDAC_AMD76X is not set
CONFIG_EDAC_E7XXX=m
# CONFIG_EDAC_E752X is not set
CONFIG_EDAC_I82875P=m
CONFIG_EDAC_I82975X=m
CONFIG_EDAC_I3000=m
CONFIG_EDAC_X38=m
CONFIG_EDAC_I5400=m
CONFIG_EDAC_I82860=m
CONFIG_EDAC_R82600=m
# CONFIG_EDAC_I5000 is not set
CONFIG_EDAC_I5100=m
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y

#
# DMA Devices
#
# CONFIG_INTEL_IOATDMA is not set
CONFIG_AUXDISPLAY=y
# CONFIG_UIO is not set

#
# TI VLYNQ
#
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y

#
# Firmware Drivers
#
CONFIG_EDD=m
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
CONFIG_DMIID=y
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=y

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=m
CONFIG_EXT4DEV_COMPAT=y
# CONFIG_EXT4_FS_XATTR is not set
CONFIG_FS_XIP=y
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=m
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_CHECK=y
# CONFIG_REISERFS_PROC_INFO is not set
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=y
# CONFIG_BTRFS_FS_POSIX_ACL is not set
CONFIG_NILFS2_FS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
# CONFIG_JOLIET is not set
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
# CONFIG_VFAT_FS is not set
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_NTFS_FS=m
CONFIG_NTFS_DEBUG=y
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=y
# CONFIG_ADFS_FS_RW is not set
CONFIG_AFFS_FS=y
# CONFIG_ECRYPT_FS is not set
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=m
CONFIG_BEFS_FS=m
CONFIG_BEFS_DEBUG=y
CONFIG_BFS_FS=m
CONFIG_EFS_FS=y
CONFIG_CRAMFS=m
CONFIG_SQUASHFS=y
CONFIG_SQUASHFS_EMBEDDED=y
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=y
CONFIG_OMFS_FS=y
# CONFIG_HPFS_FS is not set
CONFIG_QNX4FS_FS=y
# CONFIG_ROMFS_FS is not set
CONFIG_SYSV_FS=y
# CONFIG_UFS_FS is not set
# CONFIG_EXOFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
# CONFIG_NFS_V3_ACL is not set
CONFIG_NFS_V4=y
CONFIG_NFS_V4_1=y
# CONFIG_ROOT_NFS is not set
# CONFIG_NFSD is not set
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_SUNRPC_XPRT_RDMA=m
CONFIG_RPCSEC_GSS_KRB5=y
CONFIG_RPCSEC_GSS_SPKM3=m
CONFIG_SMB_FS=m
# CONFIG_SMB_NLS_DEFAULT is not set
CONFIG_CIFS=y
# CONFIG_CIFS_STATS is not set
CONFIG_CIFS_WEAK_PW_HASH=y
# CONFIG_CIFS_UPCALL is not set
# CONFIG_CIFS_XATTR is not set
CONFIG_CIFS_DEBUG2=y
CONFIG_CIFS_DFS_UPCALL=y
# CONFIG_CIFS_EXPERIMENTAL is not set
# CONFIG_NCP_FS is not set
CONFIG_CODA_FS=m
CONFIG_AFS_FS=y
# CONFIG_AFS_DEBUG is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
CONFIG_ACORN_PARTITION_CUMANA=y
# CONFIG_ACORN_PARTITION_EESOX is not set
# CONFIG_ACORN_PARTITION_ICS is not set
CONFIG_ACORN_PARTITION_ADFS=y
# CONFIG_ACORN_PARTITION_POWERTEC is not set
CONFIG_ACORN_PARTITION_RISCIX=y
# CONFIG_OSF_PARTITION is not set
CONFIG_AMIGA_PARTITION=y
CONFIG_ATARI_PARTITION=y
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
# CONFIG_EFI_PARTITION is not set
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
# CONFIG_NLS_CODEPAGE_857 is not set
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
# CONFIG_NLS_CODEPAGE_869 is not set
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
# CONFIG_NLS_CODEPAGE_932 is not set
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=y
CONFIG_NLS_ASCII=m
# CONFIG_NLS_ISO8859_1 is not set
CONFIG_NLS_ISO8859_2=m
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=y
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
CONFIG_DEBUG_OBJECTS=y
CONFIG_DEBUG_OBJECTS_SELFTEST=y
# CONFIG_DEBUG_OBJECTS_FREE is not set
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_DEBUG_KMEMLEAK=y
CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE=400
CONFIG_DEBUG_KMEMLEAK_TEST=m
CONFIG_DEBUG_PREEMPT=y
# CONFIG_DEBUG_RT_MUTEXES is not set
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_HIGHMEM=y
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_SG=y
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_BOOT_PRINTK_DELAY=y
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
# CONFIG_KPROBES_SANITY_TEST is not set
CONFIG_BACKTRACE_SELF_TEST=m
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_LKDTM=m
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FTRACE_NMI_ENTER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_RING_BUFFER=y
CONFIG_FTRACE_NMI_ENTER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_IRQSOFF_TRACER=y
# CONFIG_PREEMPT_TRACER is not set
# CONFIG_SYSPROF_TRACER is not set
CONFIG_SCHED_TRACER=y
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_BOOT_TRACER=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_POWER_TRACER=y
CONFIG_STACK_TRACER=y
CONFIG_KMEMTRACE=y
# CONFIG_WORKQUEUE_TRACER is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_DYNAMIC_FTRACE=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
CONFIG_MMIOTRACE=y
# CONFIG_MMIOTRACE_TEST is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_FIREWIRE_OHCI_REMOTE_DMA=y
CONFIG_BUILD_DOCSRC=y
CONFIG_DYNAMIC_DEBUG=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_KGDB=y
# CONFIG_KGDB_SERIAL_CONSOLE is not set
CONFIG_KGDB_TESTS=y
# CONFIG_KGDB_TESTS_ON_BOOT is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_4KSTACKS=y
CONFIG_DOUBLEFAULT=y
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
CONFIG_IO_DELAY_UDELAY=y
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=2
# CONFIG_DEBUG_BOOT_PARAMS is not set
CONFIG_CPA_DEBUG=y
# CONFIG_OPTIMIZE_INLINING is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
# CONFIG_SECURITY_NETWORK is not set
CONFIG_SECURITY_PATH=y
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
# CONFIG_SECURITY_ROOTPLUG is not set
CONFIG_SECURITY_TOMOYO=y
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
# CONFIG_CRYPTO_FIPS is not set
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_TEST=m

#
# Authenticated Encryption with Associated Data
#
# CONFIG_CRYPTO_CCM is not set
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=m
# CONFIG_CRYPTO_CTS is not set
CONFIG_CRYPTO_ECB=y
# CONFIG_CRYPTO_LRW is not set
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=m
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=m
# CONFIG_CRYPTO_SHA512 is not set
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_586 is not set
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=m
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SALSA20=m
# CONFIG_CRYPTO_SALSA20_586 is not set
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
CONFIG_KVM_INTEL=y
# CONFIG_KVM_AMD is not set
# CONFIG_LGUEST is not set
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_NLATTR=y

--6c2NcOVqGQ03X4Wi--
