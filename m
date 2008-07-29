Return-Path: <linux-kernel-owner+w=401wt.eu-S1755385AbYG2WQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbYG2WQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 18:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754269AbYG2WQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 18:16:29 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:7147 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbYG2WQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 18:16:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Z5pHmNFVOP/9R9Gx8A/jIQOK7W2Gga/rKDAJKOpPyBXPxDTtmJev/liTgbMQcF02ND
         a6JPjEg4eP3SD/3tygKZrtMWDgvf8DYfSzuVlL4Ip04zkbfPvf7l1X8hRGD49fJU5qE0
         h4Dr9K9fr8RTduAewITLedId6oVehlhYShLtc=
Message-ID: <86802c440807291516r74df37aaud26d282728ff822e@mail.gmail.com>
Date: Tue, 29 Jul 2008 15:16:27 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>
Subject: Re: [PATCH] x86: 64bit support more than 256 irq v2
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200807291414.55479.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807291414.55479.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 2:14 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
> Dhaval Giani got:
> kernel BUG at arch/x86/kernel/io_apic_64.c:357!
> invalid opcode: 0000 [1] SMP
> CPU 24
> Modules linked in:
> Pid: 1, comm: swapper Not tainted 2.6.27-rc1-autokern1 #1
> RIP: 0010:[<ffffffff8021bb2e>]  [<ffffffff8021bb2e>] add_pin_to_irq+0x8e/0xa0
> RSP: 0018:ffff88032e4b9b30  EFLAGS: 00010216
> RAX: 00000000000000f0 RBX: 00000000000000f0 RCX: 0000000000000000
> RDX: 000000000000afaf RSI: 0000000000000046 RDI: ffffffff80738234
> RBP: 0000000000000006 R08: 0000000000000000 R09: ffff8800280992c0
> R10: 0000000000000000 R11: ffffffff80372060 R12: 0000000000000018
> R13: 0000000000000001 R14: 0000000000000018 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff880bfe733540(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process swapper (pid: 1, threadinfo ffff88032e4b8000, task ffff880bfe4ca050)
> Stack:  00000000000000f0 0000000000000006 0000000000000001 ffffffff8021bbbe
>  00000000000000f0 0000000000000001 0000000000000000 ffff88032e4b9c0c
>  00000000000000f0 ffffffff80218d81 00000000000000f0 0000000000000000
> Call Trace:
>  [<ffffffff8021bbbe>] ? io_apic_set_pci_routing+0x7e/0xa0
>  [<ffffffff80218d81>] ? mp_register_gsi+0xb1/0xd0
>  [<ffffffff80218e0c>] ? acpi_register_gsi+0x6c/0x70
>  [<ffffffff80392f30>] ? acpi_pci_irq_enable+0x178/0x260
>  [<ffffffff80392cdd>] ? acpi_pci_allocate_irq+0x0/0x4c
>  [<ffffffff80370657>] ? pci_enable_resources+0x27/0x160
>  [<ffffffff8036be6a>] ? do_pci_enable_device+0x4a/0x70
>  [<ffffffff8036bee1>] ? __pci_enable_device_flags+0x51/0x60
>  [<ffffffff804e01e8>] ? tg3_init_one+0x58/0x1640
>  [<ffffffff8022a980>] ? default_wake_function+0x0/0x10
>  [<ffffffff8022efd8>] ? set_cpus_allowed_ptr+0xe8/0x110
>  [<ffffffff8036e28f>] ? pci_device_probe+0xdf/0x130
>  [<ffffffff803c2416>] ? driver_probe_device+0x96/0x1a0
>  [<ffffffff803c25a9>] ? __driver_attach+0x89/0x90
>  [<ffffffff803c2520>] ? __driver_attach+0x0/0x90
>  [<ffffffff803c1a8d>] ? bus_for_each_dev+0x4d/0x80
>  [<ffffffff8028e168>] ? kmem_cache_alloc+0xc8/0xf0
>  [<ffffffff803c1f7e>] ? bus_add_driver+0xae/0x220
>  [<ffffffff803c2836>] ? driver_register+0x56/0x130
>  [<ffffffff8036e548>] ? __pci_register_driver+0x68/0xb0
>  [<ffffffff806cf8e0>] ? tg3_init+0x0/0x20
>  [<ffffffff806b15b1>] ? do_one_initcall+0x41/0x180
>  [<ffffffff802d8a08>] ? create_proc_entry+0x58/0xa0
>  [<ffffffff80261cc4>] ? register_irq_proc+0xd4/0xf0
>  [<ffffffff806b1b53>] ? kernel_init+0x133/0x190
>  [<ffffffff8020c529>] ? child_rip+0xa/0x11
>  [<ffffffff806b1a20>] ? kernel_init+0x0/0x190
>  [<ffffffff8020c51f>] ? child_rip+0x0/0x11
>
>
> Code: 89 05 2b 54 42 00 7f 27 48 0f bf c1 48 8d 14 00 48 c1 e0 03 48 29 d0 48 8d 90 c0 5e 73 80 66 89 2a 66 44 89 62 02 5b 5d 41 5c c3 <0f> 0b eb fe 48 c7 c7 c8 db 5c 80 31 c0 e8 60 7e 01 00 48 83 ec
> RIP  [<ffffffff8021bb2e>] add_pin_to_irq+0x8e/0xa0
>  RSP <ffff88032e4b9b30>
>
> his system (x3950) has 8 ioapic, irq > 256
>
> caused by
>        commit 9b7dc567d03d74a1fbae84e88949b6a60d922d82
>        Author: Thomas Gleixner <tglx@linutronix.de>
>        Date:   Fri May 2 20:10:09 2008 +0200
>
>           x86: unify interrupt vector defines
>
>           The interrupt vector defines are copied 4 times around with minimal
>           differences. Move them all into asm-x86/irq_vectors.h
>
>
> 64bit allow same vector for different cpu to serve different irq
>
> also change next in irq_pin_list from short to int. because for 4096 NR_IRQS
> is 2^(8+12).
>
> v2: accoding to Eric W. Biederman, change to NR_IRQ_VECTORS to NR_IRQS
>    use NR_VECTORS*NR_CPUS directly
>
> need to create that array dynamically later

seems MAX_SMP doesn't like it. even can not be built.

working on make NR_IRQS related array to be allocated dynamically.

YH
