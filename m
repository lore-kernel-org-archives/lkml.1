Return-Path: <linux-kernel-owner+w=401wt.eu-S1755334AbXJAQTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbXJAQTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 12:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661AbXJAQT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 12:19:26 -0400
Received: from ara.aytolacoruna.es ([212.51.63.12]:41237 "EHLO
	mx.aytolacoruna.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbXJAQT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 12:19:26 -0400
Date: Mon, 1 Oct 2007 18:19:11 +0200
From: Santiago Garcia Mantinan <manty@manty.net>
To: Mark Lord <lkml@rtr.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 32-bit Athlon X2 won't poweroff  (was:  Fix SMP poweroff hangs)
Message-ID: <20071001161911.GA2419@pul.manty.net>
References: <46FD05B8.2040302@rtr.ca> <46FD0724.5060009@rtr.ca> <1190991316.18681.38.camel@chaos> <46FD5BAF.8040304@rtr.ca> <20070930090032.GA2405@pul.manty.net> <46FFDB29.9040400@rtr.ca> <20070930175446.GA2472@pul.manty.net> <46FFEF41.8010104@rtr.ca> <20070930200336.GA2441@pul.manty.net> <470028C5.7020501@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470028C5.7020501@rtr.ca>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> So for this to work, I believe that either ACPI or APM has to have been
> configured into the kernel (and the modules loaded).  Your kernel .config
> from earlier shows ACPI built-in to the kernel core, so it should be 
> present.

Yes, and it is indeed, the acpid is running and it detects my power button
and starts the poweroff when I hit it.

> Unless you booted with noacpi or some such parameter..
> So let's have a look at the kernel boot logs,

I believe this is normal, I have done a grep -i acpi on the dmesg, here is
the result, if you want the full dmesg tell me:

 BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
 BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
ACPI: RSDP 000F7560, 0014 (r0 Nvidia)
ACPI: RSDT 3FFF3040, 0030 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
ACPI: FACP 3FFF30C0, 0074 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
ACPI: DSDT 3FFF3180, 65F2 (r1 NVIDIA AWRDACPI     1000 MSFT  100000E)
ACPI: FACS 3FFF0000, 0040
ACPI: MCFG 3FFF9880, 003C (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
ACPI: APIC 3FFF97C0, 007C (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
ACPI: PM-Timer IO Port: 0x4008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: BIOS IRQ0 pin2 override ignored.
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
ACPI: IRQ9 used by override.
ACPI: IRQ14 used by override.
ACPI: IRQ15 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: Core revision 20070126
 tbxface-0598 [00] tb_load_namespace     : ACPI Tables successfully acquired
evxfevnt-0091 [00] enable                : Transition to ACPI mode successful
ACPI: bus type pci registered
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK3] (IRQs *3 4 5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUBA] (IRQs *3 4 5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LUBB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LMAC] (IRQs 3 4 *5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LACI] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 3 4 *5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LUB2] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSID] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LFID] (IRQs 3 4 *5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LPCA] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0, disabled.
ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0, disabled.
ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0
ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
ACPI: PCI Interrupt Link [APC5] (IRQs *16), disabled.
ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 16 devices
ACPI: ACPI bus type pnp unregistered
PCI: Using ACPI for IRQ routing
Time: acpi_pm clocksource has been installed.
ACPI: Power Button (FF) [PWRF]
ACPI: Power Button (CM) [PWRB]
ACPI: Thermal Zone [THRM] (40 C)
ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
ACPI: PCI Interrupt 0000:05:08.0[A] -> Link [APC3] -> GSI 18 (level, low) -> IRQ 16
ACPI: PCI Interrupt Link [APCJ] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:04.0[A] -> Link [APCJ] -> GSI 23 (level, low) -> IRQ 17
ACPI: PCI Interrupt Link [APCH] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [APCH] -> GSI 22 (level, low) -> IRQ 18
ACPI: PCI Interrupt Link [APCF] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [APCF] -> GSI 21 (level, low) -> IRQ 19
ACPI: PCI Interrupt Link [APCL] enabled at IRQ 20
ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [APCL] -> GSI 20 (level, low) -> IRQ 20
parport_pc 00:09: reported by Plug and Play ACPI

> and you could also try CONGIG_ACPI_DEBUG=y

I did so (in fact the above grep is with that activated) but the only things
that came out as new stuff were these two lines:

 tbxface-0598 [00] tb_load_namespace     : ACPI Tables successfully acquired 
evxfevnt-0091 [00] enable                : Transition to ACPI mode successful

Nothing new came out on the halt -f -p test :-(

If you guys have any other tests on mind just let me know.

Regards...
-- 
Manty/BestiaTester -> http://manty.net
