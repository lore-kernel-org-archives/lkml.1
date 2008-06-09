Return-Path: <linux-kernel-owner+w=401wt.eu-S1758622AbYFIWBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758622AbYFIWBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 18:01:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbYFIWAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 18:00:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753137AbYFIWAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 18:00:49 -0400
Date: Mon, 9 Jun 2008 14:55:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, apw@shadowen.org, linux-pci@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [BUG] 2.6.26-rc5-mm1- kernel BUG at
 arch/x86/kernel/io_apic_64.c:355!
Message-Id: <20080609145504.6cdfc886.akpm@linux-foundation.org>
In-Reply-To: <484D68F8.9090807@linux.vnet.ibm.com>
References: <20080609053908.8021a635.akpm@linux-foundation.org>
	<484D68F8.9090807@linux.vnet.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Jun 2008 23:01:36 +0530
Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> Hi Andrew,
> 
> The 2.6.26-rc5-mm1 kernel panics while bootup on 32 way, x86_64 machine.
> passing noapic as the command line parameter, boots up
> the machine fine.
> 
> kernel BUG at arch/x86/kernel/io_apic_64.c:355!
> invalid opcode: 0000 [1] SMP 
> last sysfs file: 
> CPU 24 
> Modules linked in:
> Pid: 1, comm: swapper Not tainted 2.6.26-rc5-mm1-autotest #1
> RIP: 0010:[<ffffffff8021b9da>]  [<ffffffff8021b9da>] add_pin_to_irq+0x7a/0x90
> RSP: 0018:ffff81061e4cbb60  EFLAGS: 00010216
> RAX: 00000000000000f0 RBX: 00000000000000f0 RCX: 0000000000000001
> RDX: 0000000000000018 RSI: 0000000000000006 RDI: 00000000000000f0
> RBP: 0000000000000006 R08: 0000000000000018 R09: 0000000000000006
> R10: 0000000000000008 R11: ffffffff803948e6 R12: 0000000000000001
> R13: 0000000000000001 R14: 0000000000000018 R15: ffff81061e4cbc04
> FS:  0000000000000000(0000) GS:ffff810bfe7be5c0(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process swapper (pid: 1, threadinfo ffff81061e4ca000, task ffff81032e4b96d0)
> Stack:  0000000000000006 ffffffff8021ba6e 00000000000000f0 0000000000000001
>  0000000000000000 0000000000000000 ffff81061e4cbc00 ffffffff80218991
>  00000000000000f0 0000000000000000 0000000000000001 ffffffff80218a1a
> Call Trace:
>  [<ffffffff8021ba6e>] io_apic_set_pci_routing+0x7e/0xb0
>  [<ffffffff80218991>] mp_register_gsi+0xb1/0xd0
>  [<ffffffff80218a1a>] acpi_register_gsi+0x6a/0x70
>  [<ffffffff80394b20>] acpi_pci_irq_enable+0x14f/0x220
>  [<ffffffff803948e6>] acpi_pci_allocate_irq+0x0/0x4c
>  [<ffffffff8036e14a>] do_pci_enable_device+0x4a/0x70
>  [<ffffffff8036e1c1>] __pci_enable_device_flags+0x51/0x60
>  [<ffffffff804f1608>] tg3_init_one+0x58/0x1640
>  [<ffffffff80229790>] default_wake_function+0x0/0x10
>  [<ffffffff8022e942>] set_cpus_allowed_ptr+0xc2/0xf0
>  [<ffffffff803703b7>] pci_device_probe+0xe7/0x130
>  [<ffffffff803c38b6>] driver_probe_device+0x96/0x1a0
>  [<ffffffff803c3a49>] __driver_attach+0x89/0x90
>  [<ffffffff803c39c0>] __driver_attach+0x0/0x90
>  [<ffffffff803c2dbd>] bus_for_each_dev+0x4d/0x80
>  [<ffffffff8028f708>] kmem_cache_alloc+0xc8/0xf0
>  [<ffffffff803c341e>] bus_add_driver+0xae/0x220
>  [<ffffffff803c3cd6>] driver_register+0x56/0x130
>  [<ffffffff80370678>] __pci_register_driver+0x68/0xb0
>  [<ffffffff806e5060>] tg3_init+0x0/0x20
>  [<ffffffff806c8a63>] kernel_init+0x153/0x320
>  [<ffffffff8020c378>] child_rip+0xa/0x12
>  [<ffffffff806c8910>] kernel_init+0x0/0x320
>  [<ffffffff8020c36e>] child_rip+0x0/0x12
> 
> 
> Code: 89 05 27 88 43 00 7f 29 48 0f bf c1 48 8d 14 00 48 c1 e0 03 48 29 d0 48 8d 90 00 44 74 80 66 89 32 66 44 89 42 02 48 83 c4 08 c3 <0f> 0b eb fe 66 90 48 c7 c7 08 7d 5e 80 31 c0 e8 72 7b 01 00 66 
> RIP  [<ffffffff8021b9da>] add_pin_to_irq+0x7a/0x90
>  RSP <ffff81061e4cbb60>
> ---[ end trace 5a53b6247c28d358 ]---

Here:

static void add_pin_to_irq(unsigned int irq, int apic, int pin)
{
	static int first_free_entry = NR_IRQS;
	struct irq_pin_list *entry = irq_2_pin + irq;

	BUG_ON(irq >= NR_IRQS);


There are massive changes to tg3, massive changes in the relevant x86
ACPI code and massive changes everywhere else.

So I don't have a clue who broke it, but it wasn't me!

You're testing linux-next, aren't you.  Did you test the June 6 tree,
upon which 2.6.26-rc5-mm1 was based?

Thanks.
