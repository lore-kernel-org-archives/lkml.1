Return-Path: <linux-kernel-owner+w=401wt.eu-S1752178AbYHLUM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178AbYHLUM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 16:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752402AbYHLUMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 16:12:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34463 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbYHLUMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 16:12:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Martin Bligh" <mbligh@google.com>
Subject: Re: Panic on boot for x86_64
Date: Tue, 12 Aug 2008 22:14:53 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@google.com>,
       Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, "Maciej W. Rozycki" <macro@linux-mips.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
References: <33307c790808121251t79af0fajf44cebffa8938051@mail.gmail.com>
In-Reply-To: <33307c790808121251t79af0fajf44cebffa8938051@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808122214.54762.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding CCs]

On Tuesday, 12 of August 2008, Martin Bligh wrote:
> x86_64 seems to panic on boot, since 2.6.26-git2 (or maybe -git1,
> which wouldn't compile)

Well, I use x86_64s all the time and nothing like this happens for me.  A link
to the failing .config might be helpful.

> 2.6.26 works.
> 
> http://test.kernel.org/results/IBM/186461/debug/console
> 
> kernel BUG at arch/x86/kernel/io_apic_64.c:356!
> invalid opcode: 0000 [1] SMP
> CPU 24
> Modules linked in:
> Pid: 1, comm: swapper Not tainted 2.6.27-rc1-git2-autotest #1
> RIP: 0010:[<ffffffff8021bb1a>]  [<ffffffff8021bb1a>] add_pin_to_irq+0x7a/0x90
> RSP: 0018:ffff88032e4b9b40  EFLAGS: 00010216
> RAX: 00000000000000f0 RBX: 00000000000000f0 RCX: 0000000000000001
> RDX: 0000000000000018 RSI: 0000000000000006 RDI: 00000000000000f0
> RBP: 0000000000000006 R08: 0000000000000018 R09: 0000000000000006
> R10: 0000000000000008 R11: ffffffff8038f8dd R12: 0000000000000001
> R13: 0000000000000001 R14: 0000000000000018 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff880bfe733540(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process swapper (pid: 1, threadinfo ffff88032e4b8000, task ffff880bfe4ca050)
> Stack:  ffff88032e4b9be0 ffffffff8021bbae 00000000000000f0 0000000000000001
>  0000000000000000 ffff88032e4b9c0c 00000000000000f0 ffffffff80218d81
>  00000000000000f0 0000000000000000 0000000000000001 ffffffff80218e0c
> Call Trace:
>  [<ffffffff8021bbae>] ? io_apic_set_pci_routing+0x7e/0xa0
>  [<ffffffff80218d81>] ? mp_register_gsi+0xb1/0xd0
>  [<ffffffff80218e0c>] ? acpi_register_gsi+0x6c/0x70
>  [<ffffffff8038fb30>] ? acpi_pci_irq_enable+0x178/0x260
>  [<ffffffff8038f8dd>] ? acpi_pci_allocate_irq+0x0/0x4c
>  [<ffffffff8036d257>] ? pci_enable_resources+0x27/0x160
>  [<ffffffff80368a6a>] ? do_pci_enable_device+0x4a/0x70
>  [<ffffffff80368ae1>] ? __pci_enable_device_flags+0x51/0x60
>  [<ffffffff804dce18>] ? tg3_init_one+0x58/0x1640
>  [<ffffffff8022a950>] ? default_wake_function+0x0/0x10
>  [<ffffffff8022efa8>] ? set_cpus_allowed_ptr+0xe8/0x110
>  [<ffffffff8036ae8f>] ? pci_device_probe+0xdf/0x130
>  [<ffffffff803bf016>] ? driver_probe_device+0x96/0x1a0
>  [<ffffffff803bf1a9>] ? __driver_attach+0x89/0x90
>  [<ffffffff803bf120>] ? __driver_attach+0x0/0x90
>  [<ffffffff803be68d>] ? bus_for_each_dev+0x4d/0x80
>  [<ffffffff8028afa8>] ? kmem_cache_alloc+0xc8/0xf0
>  [<ffffffff803beb7e>] ? bus_add_driver+0xae/0x220
>  [<ffffffff803bf436>] ? driver_register+0x56/0x130
>  [<ffffffff8036b148>] ? __pci_register_driver+0x68/0xb0
>  [<ffffffff806cb610>] ? tg3_init+0x0/0x20
>  [<ffffffff806ad5b1>] ? do_one_initcall+0x41/0x180
>  [<ffffffff802d5798>] ? create_proc_entry+0x58/0xa0
>  [<ffffffff8025eae4>] ? register_irq_proc+0xd4/0xf0
>  [<ffffffff806adb53>] ? kernel_init+0x133/0x190
>  [<ffffffff8020c529>] ? child_rip+0xa/0x11
>  [<ffffffff806ada20>] ? kernel_init+0x0/0x190
>  [<ffffffff8020c51f>] ? child_rip+0x0/0x11
> 
> 
> Code: 89 05 3f 24 42 00 7f 29 48 0f bf c1 48 8d 14 00 48 c1 e0 03 48
> 29 d0 48 8d 90 c0 0e 73 80 66 89 32 66 44 89 42 02 48 83 c4 08 c3 <0f>
> 0b eb fe 66 90 48 c7 c7 28 a4 5c 80 31 c0 e8 b2 7d 01 00 66
> RIP  [<ffffffff8021bb1a>] add_pin_to_irq+0x7a/0x90
>  RSP <ffff88032e4b9b40>
