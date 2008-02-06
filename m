Return-Path: <linux-kernel-owner+w=401wt.eu-S1756691AbYBFSX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691AbYBFSX0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 13:23:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847AbYBFSXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 13:23:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:55428 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179AbYBFSXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 13:23:13 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] 2.6.24 refuses to boot - NMI watchdog problem?
Date: Wed, 6 Feb 2008 13:22:26 -0500
User-Agent: KMail/1.9.5
Cc: Chris Rankin <rankincj@yahoo.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-acpi@vger.kernel.org
References: <123100.29626.qm@web52901.mail.re2.yahoo.com> <20080205153243.dadaace8.akpm@linux-foundation.org>
In-Reply-To: <20080205153243.dadaace8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802061322.27174.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 February 2008 18:32, Andrew Morton wrote:
> On Sat, 2 Feb 2008 23:36:42 +0000 (GMT)
> Chris Rankin <rankincj@yahoo.com> wrote:
> 
> > Hi,
> > 
> > I have a 1 GHz Coppermine PC with 512 MB RAM, and it is failing to boot with the nmi_watchdog=1
> > option. This kernel was rebuilt after doing a "make mrproper". The dmesg log follows:
> 
> Can you tell us if earlier kernels worked OK, and if so which version(s)?
> >From your other mail it appears that 2.6.23 was OK?
> 
> > ...
> >
> > ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
> > WARNING: at arch/x86/kernel/smp_32.c:561 native_smp_call_function_mask()
> > Pid: 1, comm: swapper Not tainted 2.6.24 #1
> >  [<c0112a37>] native_smp_call_function_mask+0x43/0x114
> >  [<c01149f2>] enable_NMI_through_LVT0+0x0/0x26
> >  [<c01049b3>] common_interrupt+0x23/0x28
> >  [<c01149f2>] enable_NMI_through_LVT0+0x0/0x26
> >  [<c01149f2>] enable_NMI_through_LVT0+0x0/0x26
> >  [<c0113c07>] smp_call_function+0x1c/0x1f
> >  [<c01244e2>] on_each_cpu+0x28/0x54
> >  [<c0115eee>] setup_nmi+0x30/0x47
> >  [<c032a820>] setup_IO_APIC+0x88c/0xe49
> >  [<c01b2166>] number+0x159/0x22f
> >  [<c0103078>] __switch_to+0x23/0x133
> >  [<c0282231>] _spin_unlock_irq+0xe/0x22
> >  [<c011bd5a>] finish_task_switch+0x1c/0x50
> >  [<c02807a5>] schedule+0x527/0x541
> >  [<c02821a6>] _spin_unlock+0xd/0x21
> >  [<c028083e>] preempt_schedule+0x43/0x54
> >  [<c0120c92>] vprintk+0x2c1/0x2fc
> >  [<c020c610>] device_add+0x318/0x541
> >  [<c0328084>] native_smp_prepare_cpus+0x45f/0x46f
> >  [<c01e0b07>] acpi_ns_get_device_callback+0xfe/0x11c
> >  [<c0282087>] _spin_lock+0xd/0x5a
> >  [<c011a998>] task_rq_lock+0x28/0x4b
> >  [<c028220f>] _spin_unlock_irqrestore+0xf/0x23
> >  [<c011c13f>] set_cpus_allowed+0x86/0x8e
> >  [<c020e0d9>] __driver_attach+0x0/0x7f
> >  [<c0209860>] serial8250_set_termios+0x2b4/0x2c8
> >  [<c031f349>] kernel_init+0x0/0x2b2
> >  [<c031f39b>] kernel_init+0x52/0x2b2
> >  [<c0282231>] _spin_unlock_irq+0xe/0x22
> >  [<c011bd5a>] finish_task_switch+0x1c/0x50
> >  [<c011cced>] schedule_tail+0x17/0x51
> >  [<c0103ec2>] ret_from_fork+0x6/0x1c
> >  [<c031f349>] kernel_init+0x0/0x2b2
> >  [<c031f349>] kernel_init+0x0/0x2b2
> >  [<c0104bc3>] kernel_thread_helper+0x7/0x10
> >  =======================
> 
> I think we've fixed that now.  Len: if so, has that fix been sent in for
> 2.6.24.1?

No, I don't know of any 2.6.24 oops fixes that aren't already in 2.6.24 --
at least I can't think of any right now.

-Len


> 
> > APIC timer registered as dummy, due to nmi_watchdog=1!
> > Brought up 1 CPUs
> > net_namespace: 64 bytes
> > NET: Registered protocol family 16
> > ACPI: bus type pci registered
> > PCI: PCI BIOS revision 2.10 entry at 0xf0e30, last bus=3
> > PCI: Using configuration type 1
> > Setting up standard PCI resources
> > ACPI: Interpreter enabled
> > ACPI: (supports S0 S1 S5)
> > ACPI: Using IOAPIC for interrupt routing
> > ACPI: PCI Root Bridge [PCI0] (0000:00)
> > PCI quirk: region e400-e47f claimed by ICH4 ACPI/GPIO/TCO
> > PCI quirk: region ec00-ec3f claimed by ICH4 GPIO
> > PCI: Transparent bridge - 0000:00:1e.0
> > ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
> > ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
> > ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
> > ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
> > ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
> > ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
> > ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
> > ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
> > Linux Plug and Play Support v0.97 (c) Adam Belay
> > pnp: PnP ACPI init
> > ACPI: bus type pnp registered
> > pnp: PnP ACPI: found 15 devices
> > ACPI: ACPI bus type pnp unregistered
> > PCI: Using ACPI for IRQ routing
> > PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
> > BUG: NMI Watchdog detected LOCKUP on CPU0, eip c0102ad1, registers:
> > Modules linked in:
> > 
> > Pid: 0, comm: swapper Not tainted (2.6.24 #1)
> > EIP: 0060:[<c0102ad1>] EFLAGS: 00000246 CPU: 0
> > EIP is at default_idle+0x2c/0x3e
> > EAX: 00000000 EBX: c0102aa5 ECX: 010bb000 EDX: fffedb3c
> > ESI: 00000000 EDI: c1409284 EBP: 00000004 ESP: c031bfc8
> >  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> > Process swapper (pid: 0, ti=c031b000 task=c02f4320 task.ti=c031b000)
> > Stack: c010258e c140c000 c034e284 c031f8dc 00000037 c031f0e0 00000000 00009000 
> >        c033b260 00000002 00099800 c0311000 007a2007 00000000 
> > Call Trace:
> >  [<c010258e>] cpu_idle+0x97/0xcc
> >  [<c031f8dc>] start_kernel+0x2e1/0x2e9
> >  [<c031f0e0>] unknown_bootoption+0x0/0x195
> >  =======================
> > Code: 3d 48 a9 35 c0 00 75 32 80 3d e5 97 31 c0 00 74 29 89 e0 25 00 f0 ff ff 83 60 0c fd f0 83 04
> > 24 00 fa 8b 40 08 a8 04 75 04 fb f4 <eb> 01 fb 89 e0 25 00 f0 ff ff 83 48 0c 02 c3 f3 90 c3 55 57
> > 56 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
