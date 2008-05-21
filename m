Return-Path: <linux-kernel-owner+w=401wt.eu-S936645AbYEUR1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936645AbYEUR1b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 13:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935732AbYEUR1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 13:27:08 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:44004 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764332AbYEUR1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 13:27:04 -0400
Message-ID: <48345B5E.1090506@linux.vnet.ibm.com>
Date: Wed, 21 May 2008 22:56:54 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080505)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andy Whitcroft <apw@shadowen.org>
Subject: [BUG] linux-next: Tree for May 19/20/21 - BUG at arch/x86/kernel/io_apic_64.c:353!
References: <20080519174120.2083ea57.sfr@canb.auug.org.au> <48315607.4080207@linux.vnet.ibm.com>
In-Reply-To: <48315607.4080207@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kamalesh Babulal wrote:
> Hi Stephen,
> 
> The next-20080519 kernel panics at the add_pin_to_irq(), while booting up on one
> of the x86_64 machine. 
> 
> kernel BUG at arch/x86/kernel/io_apic_64.c:353!
> invalid opcode: 0000 [1] SMP 
> last sysfs file: 
> CPU 24 
> Modules linked in:
> Pid: 1, comm: swapper Not tainted 2.6.26-rc3-next-20080519-sched-devel.git-autotest #1
> RIP: 0010:[<ffffffff8021ce6a>]  [<ffffffff8021ce6a>] add_pin_to_irq+0x7a/0x90
> RSP: 0018:ffff81061e4cbb60  EFLAGS: 00010216
> RAX: 00000000000000f0 RBX: 00000000000000f0 RCX: 0000000000000001
> RDX: 0000000000000018 RSI: 0000000000000006 RDI: 00000000000000f0
> RBP: 0000000000000006 R08: 0000000000000018 R09: 0000000000000006
> R10: 0000000000000008 R11: ffffffff80391ca6 R12: 0000000000000001
> R13: 0000000000000001 R14: 0000000000000018 R15: ffff81061e4cbc04
> FS:  0000000000000000(0000) GS:ffff810bfe7bf540(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process swapper (pid: 1, threadinfo ffff81061e4ca000, task ffff81032e4b96d0)
> Stack:  0000000000000006 ffffffff8021cefe 00000000000000f0 0000000000000001
>  0000000000000000 0000000000000000 ffff81061e4cbc00 ffffffff80219f91
>  00000000000000f0 0000000000000000 0000000000000001 ffffffff8021a01a
> Call Trace:
>  [<ffffffff8021cefe>] io_apic_set_pci_routing+0x7e/0xb0
>  [<ffffffff80219f91>] mp_register_gsi+0xb1/0xd0
>  [<ffffffff8021a01a>] acpi_register_gsi+0x6a/0x70
>  [<ffffffff80391ed0>] acpi_pci_irq_enable+0x14f/0x1f9
>  [<ffffffff80391ca6>] acpi_pci_allocate_irq+0x0/0x4c
>  [<ffffffff8036b7aa>] do_pci_enable_device+0x4a/0x70
>  [<ffffffff8036b821>] __pci_enable_device_flags+0x51/0x60
>  [<ffffffff804d7b58>] tg3_init_one+0x58/0x15e0
>  [<ffffffff8022a040>] default_wake_function+0x0/0x10
>  [<ffffffff8022fc42>] set_cpus_allowed_ptr+0xc2/0xf0
>  [<ffffffff8036d6bf>] pci_device_probe+0xdf/0x130
>  [<ffffffff803c0b46>] driver_probe_device+0x96/0x1a0
>  [<ffffffff803c0cd9>] __driver_attach+0x89/0x90
>  [<ffffffff803c0c50>] __driver_attach+0x0/0x90
>  [<ffffffff803c01bd>] bus_for_each_dev+0x4d/0x80
>  [<ffffffff8028f038>] kmem_cache_alloc+0xc8/0xf0
>  [<ffffffff803c06ae>] bus_add_driver+0xae/0x220
>  [<ffffffff803c0f66>] driver_register+0x56/0x130
>  [<ffffffff8036d978>] __pci_register_driver+0x68/0xb0
>  [<ffffffff806c2570>] tg3_init+0x0/0x20
>  [<ffffffff806a6a13>] kernel_init+0x123/0x2f0
>  [<ffffffff8020c438>] child_rip+0xa/0x12
>  [<ffffffff806a68f0>] kernel_init+0x0/0x2f0
>  [<ffffffff8020c42e>] child_rip+0x0/0x12
> 
> 
> Code: 89 05 f7 53 41 00 7f 29 48 0f bf c1 48 8d 14 00 48 c1 e0 03 48 29 d0 48 8d 90 e0 f3 71 80 66 89 32 66 44 89 42 02 48 83 c4 08 c3 <0f> 0b eb fe 66 90 48 c7 c7 68 05 5c 80 31 c0 e8 d2 77 01 00 66 
> RIP  [<ffffffff8021ce6a>] add_pin_to_irq+0x7a/0x90
>  RSP <ffff81061e4cbb60>
> ---[ end trace 13dd5b9e45b9159b ]---
> Kernel panic - not syncing: Attempted to kill init!
> Pid: 1, comm: swapper Tainted: G      D   2.6.26-rc3-next-20080519-sched-devel.git-autotest #1
> 
> Call Trace:
>  [<ffffffff802346d6>] panic+0x86/0x170
>  [<ffffffff8023543e>] printk+0x4e/0x60
>  [<ffffffff802383a1>] do_exit+0x761/0x770
>  [<ffffffff8020c8e1>] oops_end+0xc1/0xd0
>  [<ffffffff8020de66>] do_invalid_op+0x86/0xa0
>  [<ffffffff8021ce6a>] add_pin_to_irq+0x7a/0x90
>  [<ffffffff803aacc4>] vt_console_print+0x224/0x2f0
>  [<ffffffff80371390>] dummycon_dummy+0x0/0x10
>  [<ffffffff804e6cd9>] error_exit+0x0/0x51
>  [<ffffffff80391ca6>] acpi_pci_allocate_irq+0x0/0x4c
>  [<ffffffff8021ce6a>] add_pin_to_irq+0x7a/0x90
>  [<ffffffff8021cefe>] io_apic_set_pci_routing+0x7e/0xb0
>  [<ffffffff80219f91>] mp_register_gsi+0xb1/0xd0
>  [<ffffffff8021a01a>] acpi_register_gsi+0x6a/0x70
>  [<ffffffff80391ed0>] acpi_pci_irq_enable+0x14f/0x1f9
>  [<ffffffff80391ca6>] acpi_pci_allocate_irq+0x0/0x4c
>  [<ffffffff8036b7aa>] do_pci_enable_device+0x4a/0x70
>  [<ffffffff8036b821>] __pci_enable_device_flags+0x51/0x60
>  [<ffffffff804d7b58>] tg3_init_one+0x58/0x15e0
>  [<ffffffff8022a040>] default_wake_function+0x0/0x10
>  [<ffffffff8022fc42>] set_cpus_allowed_ptr+0xc2/0xf0
>  [<ffffffff8036d6bf>] pci_device_probe+0xdf/0x130
>  [<ffffffff803c0b46>] driver_probe_device+0x96/0x1a0
>  [<ffffffff803c0cd9>] __driver_attach+0x89/0x90
>  [<ffffffff803c0c50>] __driver_attach+0x0/0x90
>  [<ffffffff803c01bd>] bus_for_each_dev+0x4d/0x80
>  [<ffffffff8028f038>] kmem_cache_alloc+0xc8/0xf0
>  [<ffffffff803c06ae>] bus_add_driver+0xae/0x220
>  [<ffffffff803c0f66>] driver_register+0x56/0x130
>  [<ffffffff8036d978>] __pci_register_driver+0x68/0xb0
>  [<ffffffff806c2570>] tg3_init+0x0/0x20
>  [<ffffffff806a6a13>] kernel_init+0x123/0x2f0
>  [<ffffffff8020c438>] child_rip+0xa/0x12
>  [<ffffffff806a68f0>] kernel_init+0x0/0x2f0
>  [<ffffffff8020c42e>] child_rip+0x0/0x12
> 
> 
Hi Stephen,

This kernel panic while booting up is reproducible with the next-20080519, 
next-20080520 and next-20080521 kernels.

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
