Return-Path: <linux-kernel-owner+w=401wt.eu-S1754668AbZDGIAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbZDGIAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 04:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbZDGIAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 04:00:00 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:40211 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbZDGH7y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 03:59:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=ct2Ndg5FkRLatG+0q6VdLz/rBzkXC3/Gt+Aevz0xM1mGTnAhXJ7Savz8etJ1kxfvaj
         ej8MieflHkSLN/o18C7jq30u3Iw0DC90eEN1ZR3cSMN741LBdYne6YfU1/OLqpWecPc1
         E1yEIg0gX8g+wnUoo6jLZ+ZhuIztM/98UDLPw=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: 2.6.29, today's git changes, oops at boot, BUG: unable to handle kernel paging request at ffffffffa00f0016
Date: Tue, 7 Apr 2009 09:59:46 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-final; KDE/4.2.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>
References: <200904061251.53189.a.miskiewicz@gmail.com> <19f34abd0904070040k28af40bbo8e93497d69fa3b26@mail.gmail.com>
In-Reply-To: <19f34abd0904070040k28af40bbo8e93497d69fa3b26@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904070959.46784.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 of April 2009, Vegard Nossum wrote:
> 2009/4/6 Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>:
> > Pulled Linus git few minutes ago and new oops at boot (happens on every
> > boot). Yesterday git version was fine. Oopsed just while/after udev
> > started.
>
> Hi, thanks for the report. Some musings below.
>
> > x86_64, thinkpad t400
> >
> > latest commit 0221c81b1b8eb0cbb6b30a0ced52ead32d2b4e4c
> >
> > [    2.674741] VFS: Mounted root (xfs filesystem) readonly on device 8:3.
> > [    2.674800] Trying to move old root to /initrd ... okay
> > [    2.681684] Freeing unused kernel memory: 384k freed
> > [    4.768259] input: Power Button (FF) as /class/input/input1
> > [    4.769911] ACPI: AC Adapter [AC] (on-line)
> > [    4.784019] ACPI: Power Button (FF) [PWRF]
> > [    4.784082] input: Lid Switch as /class/input/input2
> > [    4.784629] ACPI: Lid Switch [LID]
> > [    4.784673] input: Sleep Button (CM) as /class/input/input3
> > [    4.798528] ACPI: SSDT 00000000bd6d6c20 002C8 (v01  PmRef  Cpu0Ist
> > 00003000 INTL 20050624) [    4.798954] BUG: unable to handle kernel
> > paging request at ffffffffa00f0016 [    4.799073] ACPI: SSDT
> > 00000000bd6d4020 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624) [  
> >  4.799180] IP: [<ffffffffa00f0016>] 0xffffffffa00f0016
>
> So we are trying to execute a non-existing address. This is a vmalloc
> address, so I guess it was in a module that had been unloaded. The
> fact that it doesn't resolve to a symbol name also points in the
> direction of a module that was just unloaded.
>
> > [    4.799279] PGD 203067 PUD 207063 PMD 13b015067 PTE 0
> > [    4.799498] Oops: 0010 [#1] PREEMPT SMP
> > [    4.799675] last sysfs file: /sys/block/sda/uevent
> > [    4.799733] CPU 0
> > [    4.799826] Modules linked in: processor(+) battery ac button(+)
> > crc_itu_t xfs exportfs scsi_wait_scan sd_mod crc_t10dif ahci libata
> > scsi_mod
>
> But why isn't there a "last unloaded" entry? Are you sure this is the
> complete line?

I'm sure. There is no such line in dmesg.

>
> > [    4.800001] Pid: 3140, comm: async/0 Not tainted 2.6.29 #177 2764CTO
> > [    4.800001] RIP: 0010:[<ffffffffa00f0016>]  [<ffffffffa00f0016>]
> > 0xffffffffa00f0016 [    4.800001] RSP: 0018:ffff880138f8fec8  EFLAGS:
> > 00010246
> > [    4.800001] RAX: ffff880138f8ffd8 RBX: 0000000000000000 RCX:
> > ffffffff80588630 [    4.800001] RDX: ffffffff80588660 RSI:
> > 0000000000000006 RDI: 0000000000000000 [    4.800001] RBP:
> > ffff880138f8ff20 R08: ffff880138f8e000 R09: ffff880028034500 [  
> >  4.800001] R10: 0000000300000000 R11: 0000000100000000 R12:
> > ffff880139c05400 [    4.800001] R13: ffff88013b90dd70 R14:
> > 0000000000000001 R15: 0000000000000001 [    4.800001] FS:
> >  0000000000000000(0000) GS:ffff880028023000(0000) knlGS:0000000000000000
> > [    4.800001] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b [  
> >  4.800001] CR2: ffffffffa00f0016 CR3: 000000013b045000 CR4:
> > 00000000000006e0 [    4.800001] DR0: 0000000000000000 DR1:
> > 0000000000000000 DR2: 0000000000000000 [    4.800001] DR3:
> > 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400 [  
> >  4.800001] Process async/0 (pid: 3140, threadinfo ffff880138f8e000, task
> > ffff88013969d980) [    4.800001] Stack:
> > [    4.800001]  ffffffff802554f7 0000000000000000 ffff88013969d980
> > ffffffff80238703 [    4.801466]  ffff88013b90dee8 ffffffff80588618
> > ffff88013b90dd70 0000000000000000 [    4.801466]  ffffffff802553de
> > ffff88013b90dd70 ffff88013b88df00 ffff880138f8ff40 [    4.801466] Call
> > Trace:
> > [    4.801466]  [<ffffffff802554f7>] ? async_thread+0x119/0x220
> > [    4.801466]  [<ffffffff80238703>] ? default_wake_function+0x0/0xf
> > [    4.801466]  [<ffffffff802553de>] ? async_thread+0x0/0x220
> > [    4.801466]  [<ffffffff8024fd6d>] kthread+0x49/0x76
> > [    4.801466]  [<ffffffff8020caaa>] child_rip+0xa/0x20
> > [    4.801466]  [<ffffffff8024fd24>] ? kthread+0x0/0x76
> > [    4.801466]  [<ffffffff8020caa0>] ? child_rip+0x0/0x20
> > [    4.801466] Code:  Bad RIP value.
>
> Yeah, async_thread() probably called a function that doesn't exist
> (anymore).
>
> > [    4.801466] RIP  [<ffffffffa00f0016>] 0xffffffffa00f0016
> > [    4.801466]  RSP <ffff880138f8fec8>
> > [    4.801466] CR2: ffffffffa00f0016
> > [    4.801466] ---[ end trace bc6c5e0bfc2ec314 ]---
> > [    4.803382] ACPI: Sleep Button (CM) [SLPB]
> > [    4.804132] Monitor-Mwait will be used to enter C-1 state
> > [    4.804195] Monitor-Mwait will be used to enter C-2 state
> > [    4.804263] Monitor-Mwait will be used to enter C-3 state
> > [    4.804373] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
> > [    4.804612] processor ACPI_CPU:00: registered as cooling_device0
> > [    4.804671] ACPI: Processor [CPU0] (supports 8 throttling states)
> > [    4.805283] ACPI: SSDT 00000000bd6d5ca0 001CF (v01  PmRef    ApIst
> > 00003000 INTL 20050624) [    4.805852] ACPI: SSDT 00000000bd6d5f20 0008D
> > (v01  PmRef    ApCst 00003000 INTL 20050624) [    4.807419] ACPI: CPU1
> > (power states: C1[C1] C2[C2] C3[C3])
> > [    4.807655] processor ACPI_CPU:01: registered as cooling_device1
> > [    4.807715] ACPI: Processor [CPU1] (supports 8 throttling states)
> > [    4.816002] Marking TSC unstable due to TSC halts in idle
> > [    4.935770] usbcore: registered new interface driver usbfs
>
> So... missing module_get() somewhere?

Could 46ec8598fde74ba59703575c22a6fb0b6b151bb6 
ACPI: support acpi_device_ops .notify methods
be guilty? 

>
> Maybe you can try to boot with the "initcall_debug" parameter? Adding
> "debug" might also give some more info. And just in case, though it
> might produce a lot of output, adding "ignore_loglevel" would make
> sure that everything makes it to the console.

[    0.000000] Linux version 2.6.29 (arekm@carme-pld) (gcc version 4.3.3 20090331 (release) (PLD-Linux) ) #12 SMP PREEMPT Tue Apr 7 09:47:01 CEST 2009
[    0.000000] Command line: root=/dev/sda3 elevator=cfq resume=/dev/sda2 ro nopat initcall_debug debug ignore_loglevel
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
[    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bd4a1000 (usable)
[    0.000000]  BIOS-e820: 00000000bd4a1000 - 00000000bd4a7000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd4a7000 - 00000000bd5b7000 (usable)
[    0.000000]  BIOS-e820: 00000000bd5b7000 - 00000000bd60f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd60f000 - 00000000bd6c6000 (usable)
[    0.000000]  BIOS-e820: 00000000bd6c6000 - 00000000bd6d1000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd6d1000 - 00000000bd6d4000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bd6d4000 - 00000000bd6d8000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd6d8000 - 00000000bd6dc000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd6dc000 - 00000000bd6df000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd6df000 - 00000000bd706000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd706000 - 00000000bd708000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bd708000 - 00000000bd90f000 (reserved)
[    0.000000]  BIOS-e820: 00000000bd90f000 - 00000000bd99f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bd99f000 - 00000000bd9ff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bd9ff000 - 00000000bda00000 (usable)
[    0.000000]  BIOS-e820: 00000000bdc00000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000013c000000 (usable)
[    0.000000] PAT support disabled.
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] DMI present.
[    0.000000] last_pfn = 0x13c000 max_arch_pfn = 0x100000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 13C000000 mask FFC000000 uncachable
[    0.000000]   1 base 0BE000000 mask FFE000000 uncachable
[    0.000000]   2 base 000000000 mask F80000000 write-back
[    0.000000]   3 base 080000000 mask FC0000000 write-back
[    0.000000]   4 base 100000000 mask FC0000000 write-back
[    0.000000]   5 base 0BDE00000 mask FFFE00000 uncachable
[    0.000000]   6 disabled
[    0.000000] e820 update range: 00000000bde00000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xbda00 max_arch_pfn = 0x100000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000bda00000
[    0.000000]  0000000000 - 00bda00000 page 2M
[    0.000000] kernel direct mapping tables up to bda00000 @ 8000-c000
[    0.000000] init_memory_mapping: 0000000100000000-000000013c000000
[    0.000000]  0100000000 - 013c000000 page 2M
[    0.000000] kernel direct mapping tables up to 13c000000 @ a000-10000
[    0.000000] RAMDISK: 37f62000 - 37feffcd
[    0.000000] ACPI: RSDP 00000000000f64e0 00024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 00000000bd96a2c6 0009C (v01 LENOVO TP-7U    00002070  LTP 00000000)
[    0.000000] ACPI: FACP 00000000bd96a400 000F4 (v03 LENOVO TP-7U    00002070 LNVO 00000001)
[    0.000000] ACPI: DSDT 00000000bd96a7db 0F3A8 (v01 LENOVO TP-7U    00002070 MSFT 03000000)
[    0.000000] ACPI: FACS 00000000bd98e000 00040
[    0.000000] ACPI: SSDT 00000000bd96a5b4 00227 (v01 LENOVO TP-7U    00002070 MSFT 03000000)
[    0.000000] ACPI: ECDT 00000000bd979b83 00052 (v01 LENOVO TP-7U    00002070 LNVO 00000001)
[    0.000000] ACPI: APIC 00000000bd979bd5 00078 (v01 LENOVO TP-7U    00002070 LNVO 00000001)
[    0.000000] ACPI: MCFG 00000000bd979c4d 0003C (v01 LENOVO TP-7U    00002070 LNVO 00000001)
[    0.000000] ACPI: HPET 00000000bd979c89 00038 (v01 LENOVO TP-7U    00002070 LNVO 00000001)
[    0.000000] ACPI: SLIC 00000000bd979dc2 00176 (v01 LENOVO TP-7U    00002070  LTP 00000000)
[    0.000000] ACPI: BOOT 00000000bd979f38 00028 (v01 LENOVO TP-7U    00002070  LTP 00000001)
[    0.000000] ACPI: ASF! 00000000bd979f60 000A0 (v16 LENOVO TP-7U    00002070 PTL  00000001)
[    0.000000] ACPI: SSDT 00000000bd98d213 0054F (v01 LENOVO TP-7U    00002070 INTL 20050513)
[    0.000000] ACPI: TCPA 00000000bd707000 00032 (v00                 00000000      00000000)
[    0.000000] ACPI: DMAR 00000000bd706000 00120 (v01                00000001      00000000)
[    0.000000] ACPI: SSDT 00000000bd6d3000 00655 (v01  PmRef    CpuPm 00003000 INTL 20050624)
[    0.000000] ACPI: SSDT 00000000bd6d2000 00274 (v01  PmRef  Cpu0Tst 00003000 INTL 20050624)
[    0.000000] ACPI: SSDT 00000000bd6d1000 00242 (v01  PmRef    ApTst 00003000 INTL 20050624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 013c000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 0000737ec0]    TEXT DATA BSS ==> [0000200000 - 0000737ec0]
[    0.000000]   #3 [0037f62000 - 0037feffcd]          RAMDISK ==> [0037f62000 - 0037feffcd]
[    0.000000]   #4 [000009ec00 - 0000100000]    BIOS reserved ==> [000009ec00 - 0000100000]
[    0.000000]   #5 [0000738000 - 000073814c]              BRK ==> [0000738000 - 000073814c]
[    0.000000]   #6 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
[    0.000000]   #7 [000000a000 - 000000b000]          PGTABLE ==> [000000a000 - 000000b000]
[    0.000000] found SMP MP-table at [ffff8800000f6520] f6520
[    0.000000]  [ffffe20000000000-ffffe200045fffff] PMD -> [ffff880028200000-ffff88002c7fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0013c000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[6] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000bd4a1
[    0.000000]     0: 0x000bd4a7 -> 0x000bd5b7
[    0.000000]     0: 0x000bd60f -> 0x000bd6c6
[    0.000000]     0: 0x000bd9ff -> 0x000bda00
[    0.000000]     0: 0x00100000 -> 0x0013c000
[    0.000000] On node 0 totalpages: 1021447
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1438 pages reserved
[    0.000000]   DMA zone: 2504 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 757409 pages, LIFO batch:31
[    0.000000]   Normal zone: 3360 pages used for memmap
[    0.000000]   Normal zone: 242400 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] 4 Processors exceeds NR_CPUS limit of 2
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bd4a1000 - 00000000bd4a7000
[    0.000000] PM: Registered nosave memory: 00000000bd5b7000 - 00000000bd60f000
[    0.000000] PM: Registered nosave memory: 00000000bd6c6000 - 00000000bd6d1000
[    0.000000] PM: Registered nosave memory: 00000000bd6d1000 - 00000000bd6d4000
[    0.000000] PM: Registered nosave memory: 00000000bd6d4000 - 00000000bd6d8000
[    0.000000] PM: Registered nosave memory: 00000000bd6d8000 - 00000000bd6dc000
[    0.000000] PM: Registered nosave memory: 00000000bd6dc000 - 00000000bd6df000
[    0.000000] PM: Registered nosave memory: 00000000bd6df000 - 00000000bd706000
[    0.000000] PM: Registered nosave memory: 00000000bd706000 - 00000000bd708000
[    0.000000] PM: Registered nosave memory: 00000000bd708000 - 00000000bd90f000
[    0.000000] PM: Registered nosave memory: 00000000bd90f000 - 00000000bd99f000
[    0.000000] PM: Registered nosave memory: 00000000bd99f000 - 00000000bd9ff000
[    0.000000] PM: Registered nosave memory: 00000000bda00000 - 00000000bdc00000
[    0.000000] PM: Registered nosave memory: 00000000bdc00000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fed00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fed10000
[    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed14000
[    0.000000] PM: Registered nosave memory: 00000000fed14000 - 00000000fed18000
[    0.000000] PM: Registered nosave memory: 00000000fed18000 - 00000000fed1a000
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed90000
[    0.000000] PM: Registered nosave memory: 00000000fed90000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff800000
[    0.000000] PM: Registered nosave memory: 00000000ff800000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c2000000 (gap: c0000000:20000000)
[    0.000000] NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages at ffff880028023000, static data 73440 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1002313
[    0.000000] Kernel command line: root=/dev/sda3 elevator=cfq resume=/dev/sda2 ro nopat initcall_debug debug ignore_loglevel
[    0.000000] Initializing CPU#0
[    0.000000] NR_IRQS:320
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2526.688 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.004000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.004000] Checking aperture...
[    0.004000] No AGP bridge found
[    0.004000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.004000] Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
[    0.004000] software IO TLB at phys 0x20000000 - 0x24000000
[    0.004000] Memory: 3934680k/5177344k available (2489k kernel code, 1091556k absent, 150124k reserved, 1374k data, 392k init)
[    0.004000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.004000] hpet clockevent registered
[    0.004000] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 5053.37 BogoMIPS (lpj=10106752)
[    0.004000] Security Framework initialized
[    0.004000] Mount-cache hash table entries: 256
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 6144K
[    0.004000] [ds] using Core 2/Atom configuration
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] CPU0: Thermal monitoring enabled (TM2)
[    0.004000] using mwait in idle threads.
[    0.004000] ACPI: Core revision 20090320
[    0.020054] Setting APIC routing to flat
[    0.020471] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.061124] CPU0: Intel(R) Core(TM)2 Duo CPU     T9400  @ 2.53GHz stepping 06
[    0.064001] calling  migration_init+0x0/0x5c @ 1
[    0.064001] initcall migration_init+0x0/0x5c returned 1 after 0 usecs
[    0.064001] initcall migration_init+0x0/0x5c returned with error code 1 
[    0.064001] calling  spawn_ksoftirqd+0x0/0x5a @ 1
[    0.064001] initcall spawn_ksoftirqd+0x0/0x5a returned 0 after 0 usecs
[    0.064001] calling  init_call_single_data+0x0/0x66 @ 1
[    0.064001] initcall init_call_single_data+0x0/0x66 returned 0 after 0 usecs
[    0.064001] calling  spawn_softlockup_task+0x0/0x75 @ 1
[    0.064001] initcall spawn_softlockup_task+0x0/0x75 returned 0 after 0 usecs
[    0.064001] calling  relay_init+0x0/0x14 @ 1
[    0.064001] initcall relay_init+0x0/0x14 returned 0 after 0 usecs
[    0.064001] calling  tracer_alloc_buffers+0x0/0x17e @ 1
[    0.064001] initcall tracer_alloc_buffers+0x0/0x17e returned 0 after 0 usecs
[    0.064001] calling  init_trace_printk+0x0/0x12 @ 1
[    0.064001] initcall init_trace_printk+0x0/0x12 returned 0 after 0 usecs
[    0.064001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 5053.96 BogoMIPS (lpj=10107927)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 6144K
[    0.004000] [ds] using Core 2/Atom configuration
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] CPU1: Thermal monitoring enabled (TM2)
[    0.152737] CPU1: Intel(R) Core(TM)2 Duo CPU     T9400  @ 2.53GHz stepping 06
[    0.153344] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.156028] Brought up 2 CPUs
[    0.156084] Total of 2 processors activated (10107.33 BogoMIPS).
[    0.156187] CPU0 attaching sched-domain:
[    0.156243]  domain 0: span 0-1 level MC
[    0.156339]   groups: 0 1
[    0.156514] CPU1 attaching sched-domain:
[    0.156570]  domain 0: span 0-1 level MC
[    0.156665]   groups: 1 0
[    0.156897] calling  init_cpufreq_transition_notifier_list+0x0/0x1b @ 1
[    0.156897] initcall init_cpufreq_transition_notifier_list+0x0/0x1b returned 0 after 0 usecs
[    0.156897] calling  net_ns_init+0x0/0xfd @ 1
[    0.156897] net_namespace: 1952 bytes
[    0.156897] initcall net_ns_init+0x0/0xfd returned 0 after 0 usecs
[    0.156897] calling  e820_mark_nvs_memory+0x0/0x40 @ 1
[    0.156897] initcall e820_mark_nvs_memory+0x0/0x40 returned 0 after 0 usecs
[    0.156897] calling  cpufreq_tsc+0x0/0x28 @ 1
[    0.156897] initcall cpufreq_tsc+0x0/0x28 returned 0 after 0 usecs
[    0.156897] calling  init_lapic_sysfs+0x0/0x2d @ 1
[    0.156897] initcall init_lapic_sysfs+0x0/0x2d returned 0 after 0 usecs
[    0.156897] calling  init_smp_flush+0x0/0x23 @ 1
[    0.156897] initcall init_smp_flush+0x0/0x23 returned 0 after 0 usecs
[    0.156897] calling  alloc_frozen_cpus+0x0/0x8 @ 1
[    0.156897] initcall alloc_frozen_cpus+0x0/0x8 returned 0 after 0 usecs
[    0.156897] calling  sysctl_init+0x0/0x32 @ 1
[    0.156897] initcall sysctl_init+0x0/0x32 returned 0 after 0 usecs
[    0.156907] calling  ksysfs_init+0x0/0xbb @ 1
[    0.156977] initcall ksysfs_init+0x0/0xbb returned 0 after 0 usecs
[    0.157037] calling  async_init+0x0/0x62 @ 1
[    0.157102] initcall async_init+0x0/0x62 returned 0 after 0 usecs
[    0.157102] calling  init_jiffies_clocksource+0x0/0x12 @ 1
[    0.157102] initcall init_jiffies_clocksource+0x0/0x12 returned 0 after 0 usecs
[    0.160004] calling  pm_init+0x0/0x34 @ 1
[    0.160064] initcall pm_init+0x0/0x34 returned 0 after 0 usecs
[    0.160123] calling  pm_disk_init+0x0/0x19 @ 1
[    0.160181] initcall pm_disk_init+0x0/0x19 returned 0 after 0 usecs
[    0.160241] calling  swsusp_header_init+0x0/0x2c @ 1
[    0.160300] initcall swsusp_header_init+0x0/0x2c returned 0 after 0 usecs
[    0.160361] calling  filelock_init+0x0/0x2e @ 1
[    0.160419] initcall filelock_init+0x0/0x2e returned 0 after 0 usecs
[    0.160479] calling  init_script_binfmt+0x0/0x12 @ 1
[    0.160537] initcall init_script_binfmt+0x0/0x12 returned 0 after 0 usecs
[    0.160597] calling  init_elf_binfmt+0x0/0x12 @ 1
[    0.160654] initcall init_elf_binfmt+0x0/0x12 returned 0 after 0 usecs
[    0.160714] calling  init_compat_elf_binfmt+0x0/0x12 @ 1
[    0.160772] initcall init_compat_elf_binfmt+0x0/0x12 returned 0 after 0 usecs
[    0.160833] calling  debugfs_init+0x0/0x5a @ 1
[    0.160892] initcall debugfs_init+0x0/0x5a returned 0 after 0 usecs
[    0.160952] calling  securityfs_init+0x0/0x51 @ 1
[    0.161011] initcall securityfs_init+0x0/0x51 returned 0 after 0 usecs
[    0.161071] calling  random32_init+0x0/0xd7 @ 1
[    0.161128] initcall random32_init+0x0/0xd7 returned 0 after 0 usecs
[    0.161188] calling  regulator_init+0x0/0x2e @ 1
[    0.161244] regulator: core version 0.5
[    0.161309] initcall regulator_init+0x0/0x2e returned 0 after 0 usecs
[    0.161370] calling  cpufreq_core_init+0x0/0x7f @ 1
[    0.161428] initcall cpufreq_core_init+0x0/0x7f returned 0 after 0 usecs
[    0.161488] calling  cpuidle_init+0x0/0x40 @ 1
[    0.161547] initcall cpuidle_init+0x0/0x40 returned 0 after 0 usecs
[    0.161606] calling  sock_init+0x0/0x5e @ 1
[    0.161691] initcall sock_init+0x0/0x5e returned 0 after 0 usecs
[    0.161751] calling  net_inuse_init+0x0/0x26 @ 1
[    0.161809] initcall net_inuse_init+0x0/0x26 returned 0 after 0 usecs
[    0.161869] calling  netpoll_init+0x0/0x31 @ 1
[    0.161926] initcall netpoll_init+0x0/0x31 returned 0 after 0 usecs
[    0.161986] calling  netlink_proto_init+0x0/0x1ce @ 1
[    0.162048] NET: Registered protocol family 16
[    0.162111] initcall netlink_proto_init+0x0/0x1ce returned 0 after 0 usecs
[    0.162172] calling  bdi_class_init+0x0/0x41 @ 1
[    0.162249] initcall bdi_class_init+0x0/0x41 returned 0 after 0 usecs
[    0.162309] calling  kobject_uevent_init+0x0/0x47 @ 1
[    0.162369] initcall kobject_uevent_init+0x0/0x47 returned 0 after 0 usecs
[    0.162429] calling  gpiolib_sysfs_init+0x0/0x96 @ 1
[    0.162499] initcall gpiolib_sysfs_init+0x0/0x96 returned 0 after 0 usecs
[    0.162560] calling  pcibus_class_init+0x0/0x19 @ 1
[    0.162625] initcall pcibus_class_init+0x0/0x19 returned 0 after 0 usecs
[    0.162686] calling  pci_driver_init+0x0/0x12 @ 1
[    0.162758] initcall pci_driver_init+0x0/0x12 returned 0 after 0 usecs
[    0.162818] calling  tty_class_init+0x0/0x31 @ 1
[    0.162883] initcall tty_class_init+0x0/0x31 returned 0 after 0 usecs
[    0.162943] calling  vtconsole_class_init+0x0/0xc3 @ 1
[    0.163021] initcall vtconsole_class_init+0x0/0xc3 returned 0 after 0 usecs
[    0.163082] calling  amd_postcore_init+0x0/0x81d @ 1
[    0.163140] initcall amd_postcore_init+0x0/0x81d returned 0 after 0 usecs
[    0.163200] calling  arch_kdebugfs_init+0x0/0x24 @ 1
[    0.163260] initcall arch_kdebugfs_init+0x0/0x24 returned 0 after 0 usecs
[    0.163320] calling  mtrr_if_init+0x0/0x63 @ 1
[    0.163379] initcall mtrr_if_init+0x0/0x63 returned 0 after 0 usecs
[    0.163438] calling  ffh_cstate_init+0x0/0x2a @ 1
[    0.163496] initcall ffh_cstate_init+0x0/0x2a returned 0 after 0 usecs
[    0.163556] calling  acpi_pci_init+0x0/0x5c @ 1
[    0.163613] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.163684] ACPI: bus type pci registered
[    0.163740] initcall acpi_pci_init+0x0/0x5c returned 0 after 0 usecs
[    0.163800] calling  dmi_id_init+0x0/0x381 @ 1
[    0.163890] initcall dmi_id_init+0x0/0x381 returned 0 after 0 usecs
[    0.164003] calling  dma_bus_init+0x0/0x3f @ 1
[    0.164068] initcall dma_bus_init+0x0/0x3f returned 0 after 0 usecs
[    0.164128] calling  dma_channel_table_init+0x0/0x10e @ 1
[    0.164191] initcall dma_channel_table_init+0x0/0x10e returned 0 after 0 usecs
[    0.165930] calling  pci_arch_init+0x0/0x57 @ 1
[    0.166009] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 63
[    0.166069] PCI: MCFG area at e0000000 reserved in E820
[    0.168472] PCI: Using MMCONFIG at e0000000 - e3ffffff
[    0.168530] PCI: Using configuration type 1 for base access
[    0.168591] initcall pci_arch_init+0x0/0x57 returned 0 after 3906 usecs
[    0.168651] calling  topology_init+0x0/0x3e @ 1
[    0.168727] initcall topology_init+0x0/0x3e returned 0 after 0 usecs
[    0.168788] calling  mtrr_init_finialize+0x0/0x3d @ 1
[    0.168846] initcall mtrr_init_finialize+0x0/0x3d returned 0 after 0 usecs
[    0.168907] calling  param_sysfs_init+0x0/0x24b @ 1
[    0.169233] initcall param_sysfs_init+0x0/0x24b returned 0 after 0 usecs
[    0.169295] calling  pm_sysrq_init+0x0/0x19 @ 1
[    0.169354] initcall pm_sysrq_init+0x0/0x19 returned 0 after 0 usecs
[    0.169414] calling  init_slow_work+0x0/0x3b @ 1
[    0.169473] initcall init_slow_work+0x0/0x3b returned 0 after 0 usecs
[    0.169534] calling  default_bdi_init+0x0/0x38 @ 1
[    0.169610] initcall default_bdi_init+0x0/0x38 returned 0 after 0 usecs
[    0.169671] calling  init_bio+0x0/0xc9 @ 1
[    0.169732] bio: create slab <bio-0> at 0
[    0.169790] initcall init_bio+0x0/0xc9 returned 0 after 0 usecs
[    0.169850] calling  bio_integrity_init+0x0/0xaa @ 1
[    0.169939] initcall bio_integrity_init+0x0/0xaa returned 0 after 0 usecs
[    0.170000] calling  cryptomgr_init+0x0/0x31 @ 1
[    0.170062] initcall cryptomgr_init+0x0/0x31 returned 0 after 0 usecs
[    0.170122] calling  blk_settings_init+0x0/0x2a @ 1
[    0.170180] initcall blk_settings_init+0x0/0x2a returned 0 after 0 usecs
[    0.170240] calling  blk_ioc_init+0x0/0x2a @ 1
[    0.170297] initcall blk_ioc_init+0x0/0x2a returned 0 after 0 usecs
[    0.170357] calling  blk_softirq_init+0x0/0x70 @ 1
[    0.170415] initcall blk_softirq_init+0x0/0x70 returned 0 after 0 usecs
[    0.170475] calling  genhd_device_init+0x0/0x66 @ 1
[    0.170574] initcall genhd_device_init+0x0/0x66 returned 0 after 0 usecs
[    0.170634] calling  blk_dev_integrity_init+0x0/0x2a @ 1
[    0.170693] initcall blk_dev_integrity_init+0x0/0x2a returned 0 after 0 usecs
[    0.170754] calling  gpiolib_debugfs_init+0x0/0x24 @ 1
[    0.170814] initcall gpiolib_debugfs_init+0x0/0x24 returned 0 after 0 usecs
[    0.170876] calling  pci_slot_init+0x0/0x47 @ 1
[    0.170935] initcall pci_slot_init+0x0/0x47 returned 0 after 0 usecs
[    0.170994] calling  acpi_init+0x0/0x265 @ 1
[    0.172088] ACPI: EC: EC description table is found, configuring boot EC
[    0.179167] ACPI: BIOS _OSI(Linux) query ignored
[    0.176018] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.197404] ACPI: Interpreter enabled
[    0.197461] ACPI: (supports S0 S3 S4 S5)
[    0.197692] ACPI: Using IOAPIC for interrupt routing
[    0.220607] ACPI: EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.220668] ACPI: EC: driver started in interrupt mode
[    0.220887] ACPI: Power Resource [PUBS] (on)
[    0.220887] initcall acpi_init+0x0/0x265 returned 0 after 50781 usecs
[    0.220887] calling  dock_init+0x0/0x8d @ 1
[    0.225095] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.225156] initcall dock_init+0x0/0x8d returned 0 after 0 usecs
[    0.225215] calling  acpi_pci_root_init+0x0/0x28 @ 1
[    0.225668] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.225800] pci 0000:00:02.0: reg 10 64bit mmio: [0xf4400000-0xf47fffff]
[    0.225864] pci 0000:00:02.0: reg 18 64bit mmio: [0xd0000000-0xdfffffff]
[    0.225925] pci 0000:00:02.0: reg 20 io port: [0x1800-0x1807]
[    0.226013] pci 0000:00:02.1: reg 10 64bit mmio: [0xf4200000-0xf42fffff]
[    0.226122] pci 0000:00:03.0: reg 10 64bit mmio: [0xfc226800-0xfc22680f]
[    0.226209] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.226269] pci 0000:00:03.0: PME# disabled
[    0.226413] pci 0000:00:19.0: reg 10 32bit mmio: [0xfc000000-0xfc01ffff]
[    0.226478] pci 0000:00:19.0: reg 14 32bit mmio: [0xfc025000-0xfc025fff]
[    0.226543] pci 0000:00:19.0: reg 18 io port: [0x1840-0x185f]
[    0.228067] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.228129] pci 0000:00:19.0: PME# disabled
[    0.228246] pci 0000:00:1a.0: reg 20 io port: [0x1860-0x187f]
[    0.228389] pci 0000:00:1a.1: reg 20 io port: [0x1880-0x189f]
[    0.228532] pci 0000:00:1a.2: reg 20 io port: [0x18a0-0x18bf]
[    0.228678] pci 0000:00:1a.7: reg 10 32bit mmio: [0xfc226c00-0xfc226fff]
[    0.228799] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.228861] pci 0000:00:1a.7: PME# disabled
[    0.228968] pci 0000:00:1b.0: reg 10 64bit mmio: [0xfc020000-0xfc023fff]
[    0.229081] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.229142] pci 0000:00:1b.0: PME# disabled
[    0.229276] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.229337] pci 0000:00:1c.0: PME# disabled
[    0.229472] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.229533] pci 0000:00:1c.1: PME# disabled
[    0.229670] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.229732] pci 0000:00:1c.3: PME# disabled
[    0.229867] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.229928] pci 0000:00:1c.4: PME# disabled
[    0.230053] pci 0000:00:1d.0: reg 20 io port: [0x18c0-0x18df]
[    0.230196] pci 0000:00:1d.1: reg 20 io port: [0x18e0-0x18ff]
[    0.230339] pci 0000:00:1d.2: reg 20 io port: [0x1c00-0x1c1f]
[    0.230485] pci 0000:00:1d.7: reg 10 32bit mmio: [0xfc227000-0xfc2273ff]
[    0.230606] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.230668] pci 0000:00:1d.7: PME# disabled
[    0.230961] pci 0000:00:1f.2: reg 10 io port: [0x1c48-0x1c4f]
[    0.231024] pci 0000:00:1f.2: reg 14 io port: [0x183c-0x183f]
[    0.231088] pci 0000:00:1f.2: reg 18 io port: [0x1c40-0x1c47]
[    0.231151] pci 0000:00:1f.2: reg 1c io port: [0x1838-0x183b]
[    0.231215] pci 0000:00:1f.2: reg 20 io port: [0x1c20-0x1c3f]
[    0.231278] pci 0000:00:1f.2: reg 24 32bit mmio: [0xfc226000-0xfc2267ff]
[    0.231380] pci 0000:00:1f.2: PME# supported from D3hot
[    0.231440] pci 0000:00:1f.2: PME# disabled
[    0.231532] pci 0000:00:1f.3: reg 10 64bit mmio: [0xfc227400-0xfc2274ff]
[    0.231608] pci 0000:00:1f.3: reg 20 io port: [0x1c60-0x1c7f]
[    0.231874] pci 0000:03:00.0: reg 10 64bit mmio: [0xf4300000-0xf4301fff]
[    0.232107] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.232192] pci 0000:03:00.0: PME# disabled
[    0.232350] pci 0000:00:1c.1: bridge 32bit mmio: [0xf4300000-0xf43fffff]
[    0.232470] pci 0000:00:1c.3: bridge io port: [0x2000-0x2fff]
[    0.232531] pci 0000:00:1c.3: bridge 32bit mmio: [0xf8000000-0xf9ffffff]
[    0.232596] pci 0000:00:1c.3: bridge 64bit mmio pref: [0xf4000000-0xf40fffff]
[    0.232710] pci 0000:00:1c.4: bridge io port: [0x3000-0x3fff]
[    0.232771] pci 0000:00:1c.4: bridge 32bit mmio: [0xfa000000-0xfbffffff]
[    0.232836] pci 0000:00:1c.4: bridge 64bit mmio pref: [0xf4100000-0xf41fffff]
[    0.232942] pci 0000:15:00.0: reg 10 32bit mmio: [0xf4800000-0xf4800fff]
[    0.233027] pci 0000:15:00.0: supports D1 D2
[    0.233083] pci 0000:15:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.233146] pci 0000:15:00.0: PME# disabled
[    0.233250] pci 0000:15:00.1: reg 10 32bit mmio: [0xf4801000-0xf48017ff]
[    0.233376] pci 0000:15:00.1: supports D1 D2
[    0.233432] pci 0000:15:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.233495] pci 0000:15:00.1: PME# disabled
[    0.233598] pci 0000:15:00.2: reg 10 32bit mmio: [0xf4801800-0xf48018ff]
[    0.233724] pci 0000:15:00.2: supports D1 D2
[    0.233780] pci 0000:15:00.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.233843] pci 0000:15:00.2: PME# disabled
[    0.233946] pci 0000:15:00.3: reg 10 32bit mmio: [0xf4801c00-0xf4801cff]
[    0.234072] pci 0000:15:00.3: supports D1 D2
[    0.234128] pci 0000:15:00.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.234191] pci 0000:15:00.3: PME# disabled
[    0.234293] pci 0000:15:00.4: reg 10 32bit mmio: [0xf4802000-0xf48020ff]
[    0.234420] pci 0000:15:00.4: supports D1 D2
[    0.234476] pci 0000:15:00.4: PME# supported from D0 D1 D2 D3hot D3cold
[    0.234538] pci 0000:15:00.4: PME# disabled
[    0.234641] pci 0000:15:00.5: reg 10 32bit mmio: [0xf4802400-0xf48024ff]
[    0.234767] pci 0000:15:00.5: supports D1 D2
[    0.234824] pci 0000:15:00.5: PME# supported from D0 D1 D2 D3hot D3cold
[    0.234886] pci 0000:15:00.5: PME# disabled
[    0.235013] pci 0000:00:1e.0: transparent bridge
[    0.235072] pci 0000:00:1e.0: bridge io port: [0x4000-0x7fff]
[    0.235133] pci 0000:00:1e.0: bridge 32bit mmio: [0xf4800000-0xf7ffffff]
[    0.235198] pci 0000:00:1e.0: bridge 64bit mmio pref: [0xf0000000-0xf3ffffff]
[    0.235308] pci_bus 0000:00: on NUMA node 0
[    0.235368] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.235579] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[    0.235709] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.235839] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[    0.235968] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
[    0.236074] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    0.241484] initcall acpi_pci_root_init+0x0/0x28 returned 0 after 15625 usecs
[    0.241546] calling  acpi_pci_link_init+0x0/0x43 @ 1
[    0.241747] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.242404] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[    0.243060] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[    0.243715] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.244369] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.245025] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[    0.245680] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[    0.246336] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[    0.246874] initcall acpi_pci_link_init+0x0/0x43 returned 0 after 3906 usecs
[    0.246935] calling  pnp_init+0x0/0x12 @ 1
[    0.247003] initcall pnp_init+0x0/0x12 returned 0 after 0 usecs
[    0.247062] calling  misc_init+0x0/0x9f @ 1
[    0.247130] initcall misc_init+0x0/0x9f returned 0 after 0 usecs
[    0.247190] calling  serio_init+0x0/0x89 @ 1
[    0.247268] initcall serio_init+0x0/0x89 returned 0 after 0 usecs
[    0.247268] calling  input_init+0x0/0x106 @ 1
[    0.247268] initcall input_init+0x0/0x106 returned 0 after 0 usecs
[    0.247268] calling  rtc_init+0x0/0x71 @ 1
[    0.247268] initcall rtc_init+0x0/0x71 returned 0 after 0 usecs
[    0.247268] calling  power_supply_class_init+0x0/0x38 @ 1
[    0.247268] initcall power_supply_class_init+0x0/0x38 returned 0 after 0 usecs
[    0.247268] calling  hwmon_init+0x0/0x42 @ 1
[    0.247268] initcall hwmon_init+0x0/0x42 returned 0 after 0 usecs
[    0.247268] calling  thermal_init+0x0/0x40 @ 1
[    0.247268] initcall thermal_init+0x0/0x40 returned 0 after 0 usecs
[    0.248003] calling  pci_subsys_init+0x0/0x109 @ 1
[    0.248060] PCI: Using ACPI for IRQ routing
[    0.248276] initcall pci_subsys_init+0x0/0x109 returned 0 after 0 usecs
[    0.248336] calling  proto_init+0x0/0x12 @ 1
[    0.248395] initcall proto_init+0x0/0x12 returned 0 after 0 usecs
[    0.250123] calling  net_dev_init+0x0/0x179 @ 1
[    0.250235] initcall net_dev_init+0x0/0x179 returned 0 after 0 usecs
[    0.250295] calling  neigh_init+0x0/0x71 @ 1
[    0.250352] initcall neigh_init+0x0/0x71 returned 0 after 0 usecs
[    0.250411] calling  fib_rules_init+0x0/0xa6 @ 1
[    0.250470] initcall fib_rules_init+0x0/0xa6 returned 0 after 0 usecs
[    0.250530] calling  pktsched_init+0x0/0xc4 @ 1
[    0.250588] initcall pktsched_init+0x0/0xc4 returned 0 after 0 usecs
[    0.250648] calling  tc_filter_init+0x0/0x4c @ 1
[    0.250706] initcall tc_filter_init+0x0/0x4c returned 0 after 0 usecs
[    0.250765] calling  tc_action_init+0x0/0x4c @ 1
[    0.250823] initcall tc_action_init+0x0/0x4c returned 0 after 0 usecs
[    0.250882] calling  genl_init+0x0/0xd8 @ 1
[    0.268007] initcall genl_init+0x0/0xd8 returned 0 after 19531 usecs
[    0.268068] calling  cipso_v4_init+0x0/0x64 @ 1
[    0.268127] initcall cipso_v4_init+0x0/0x64 returned 0 after 0 usecs
[    0.268187] calling  wireless_nlevent_init+0x0/0x31 @ 1
[    0.268245] initcall wireless_nlevent_init+0x0/0x31 returned 0 after 0 usecs
[    0.268305] calling  netlbl_init+0x0/0x81 @ 1
[    0.268361] NetLabel: Initializing
[    0.268416] NetLabel:  domain hash size = 128
[    0.268471] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.268540] NetLabel:  unlabeled traffic allowed by default
[    0.268598] initcall netlbl_init+0x0/0x81 returned 0 after 0 usecs
[    0.268657] calling  sysctl_init+0x0/0x49 @ 1
[    0.268714] initcall sysctl_init+0x0/0x49 returned 0 after 0 usecs
[    0.268774] calling  pci_iommu_init+0x0/0x12 @ 1
[    0.268847] initcall pci_iommu_init+0x0/0x12 returned 0 after 0 usecs
[    0.268907] calling  print_all_ICs+0x0/0x564 @ 1
[    0.268966] initcall print_all_ICs+0x0/0x564 returned 0 after 0 usecs
[    0.269025] calling  hpet_late_init+0x0/0x1c6 @ 1
[    0.269086] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.269345] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.272019] initcall hpet_late_init+0x0/0x1c6 returned 0 after 3906 usecs
[    0.272065] calling  clocksource_done_booting+0x0/0x12 @ 1
[    0.272123] initcall clocksource_done_booting+0x0/0x12 returned 0 after 0 usecs
[    0.272194] calling  rb_init_debugfs+0x0/0x40 @ 1
[    0.272256] initcall rb_init_debugfs+0x0/0x40 returned 0 after 0 usecs
[    0.272315] calling  tracer_init_debugfs+0x0/0x3dd @ 1
[    0.272418] initcall tracer_init_debugfs+0x0/0x3dd returned 0 after 0 usecs
[    0.272478] calling  init_trace_printk_function_export+0x0/0x40 @ 1
[    0.272539] initcall init_trace_printk_function_export+0x0/0x40 returned 0 after 0 usecs
[    0.272610] calling  init_pipe_fs+0x0/0x4c @ 1
[    0.272672] initcall init_pipe_fs+0x0/0x4c returned 0 after 0 usecs
[    0.272732] calling  init_mnt_writers+0x0/0x5a @ 1
[    0.272790] initcall init_mnt_writers+0x0/0x5a returned 0 after 0 usecs
[    0.272849] calling  eventpoll_init+0x0/0xba @ 1
[    0.272908] initcall eventpoll_init+0x0/0xba returned 0 after 0 usecs
[    0.272968] calling  anon_inode_init+0x0/0x11f @ 1
[    0.273032] initcall anon_inode_init+0x0/0x11f returned 0 after 0 usecs
[    0.273092] calling  acpi_event_init+0x0/0x80 @ 1
[    0.292010] initcall acpi_event_init+0x0/0x80 returned 0 after 19538 usecs
[    0.292070] calling  pnpacpi_init+0x0/0x8c @ 1
[    0.292126] pnp: PnP ACPI init
[    0.292187] ACPI: bus type pnp registered
[    0.356450] pnp: PnP ACPI: found 10 devices
[    0.356507] ACPI: ACPI bus type pnp unregistered
[    0.356565] initcall pnpacpi_init+0x0/0x8c returned 0 after 62927 usecs
[    0.356625] calling  pnp_system_init+0x0/0x12 @ 1
[    0.356687] system 00:00: iomem range 0x0-0x9ffff could not be reserved
[    0.356747] system 00:00: iomem range 0xc0000-0xc3fff has been reserved
[    0.356807] system 00:00: iomem range 0xc4000-0xc7fff has been reserved
[    0.356867] system 00:00: iomem range 0xc8000-0xcbfff has been reserved
[    0.356927] system 00:00: iomem range 0xcc000-0xcffff has been reserved
[    0.356987] system 00:00: iomem range 0xdc000-0xdffff could not be reserved
[    0.357047] system 00:00: iomem range 0xe0000-0xe3fff could not be reserved
[    0.357107] system 00:00: iomem range 0xe4000-0xe7fff could not be reserved
[    0.357168] system 00:00: iomem range 0xe8000-0xebfff could not be reserved
[    0.357228] system 00:00: iomem range 0xec000-0xeffff could not be reserved
[    0.357288] system 00:00: iomem range 0xf0000-0xfffff could not be reserved
[    0.357349] system 00:00: iomem range 0x100000-0xbfffffff could not be reserved
[    0.357420] system 00:00: iomem range 0xfec00000-0xfed3ffff could not be reserved
[    0.357498] system 00:00: iomem range 0xfed4c000-0xffffffff could not be reserved
[    0.357572] system 00:02: ioport range 0x1000-0x107f has been reserved
[    0.357632] system 00:02: ioport range 0x1180-0x11ff has been reserved
[    0.357691] system 00:02: ioport range 0x800-0x80f has been reserved
[    0.357751] system 00:02: ioport range 0x15e0-0x15ef has been reserved
[    0.357811] system 00:02: ioport range 0x1600-0x167f has been reserved
[    0.357870] system 00:02: ioport range 0x1680-0x169f has been reserved
[    0.357930] system 00:02: iomem range 0xe0000000-0xefffffff has been reserved
[    0.357991] system 00:02: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.358052] system 00:02: iomem range 0xfed10000-0xfed13fff has been reserved
[    0.358112] system 00:02: iomem range 0xfed18000-0xfed18fff has been reserved
[    0.358173] system 00:02: iomem range 0xfed19000-0xfed19fff has been reserved
[    0.358234] system 00:02: iomem range 0xfed45000-0xfed4bfff has been reserved
[    0.358306] initcall pnp_system_init+0x0/0x12 returned 0 after 1585 usecs
[    0.358366] calling  chr_dev_init+0x0/0xa1 @ 1
[    0.358526] initcall chr_dev_init+0x0/0xa1 returned 0 after 100 usecs
[    0.358586] calling  firmware_class_init+0x0/0x79 @ 1
[    0.358651] initcall firmware_class_init+0x0/0x79 returned 0 after 6 usecs
[    0.358712] calling  cpufreq_gov_performance_init+0x0/0x12 @ 1
[    0.358771] initcall cpufreq_gov_performance_init+0x0/0x12 returned 0 after 0 usecs
[    0.358842] calling  cpufreq_gov_dbs_init+0x0/0xc9 @ 1
[    0.358944] initcall cpufreq_gov_dbs_init+0x0/0xc9 returned 0 after 41 usecs
[    0.359005] calling  init_acpi_pm_clocksource+0x0/0xdd @ 1
[    0.363559] initcall init_acpi_pm_clocksource+0x0/0xdd returned 0 after 4389 usecs
[    0.363630] calling  pcibios_assign_resources+0x0/0x88 @ 1
[    0.363725] pci 0000:15:00.0: CardBus bridge, secondary bus 0000:16
[    0.363784] pci 0000:15:00.0:   IO window: 0x004000-0x0040ff
[    0.363846] pci 0000:15:00.0:   IO window: 0x004400-0x0044ff
[    0.363907] pci 0000:15:00.0:   PREFETCH window: 0xf0000000-0xf3ffffff
[    0.363970] pci 0000:15:00.0:   MEM window: 0xc4000000-0xc7ffffff
[    0.364039] pci 0000:00:1c.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.364102] pci 0000:00:1c.0: setting latency timer to 64
[    0.364165] pci 0000:00:1c.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    0.364227] pci 0000:00:1c.1: setting latency timer to 64
[    0.364291] pci 0000:00:1c.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    0.364353] pci 0000:00:1c.3: setting latency timer to 64
[    0.364415] pci 0000:00:1c.4: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.364477] pci 0000:00:1c.4: setting latency timer to 64
[    0.364540] pci 0000:00:1e.0: setting latency timer to 64
[    0.364604] pci 0000:15:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.364669] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.364727] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.364787] pci_bus 0000:02: resource 0 mem: [0x0-0x0]
[    0.364844] pci_bus 0000:02: resource 1 mem: [0x0-0x0]
[    0.364902] pci_bus 0000:02: resource 2 mem: [0x0-0x0]
[    0.364959] pci_bus 0000:02: resource 3 mem: [0x0-0x0]
[    0.365017] pci_bus 0000:03: resource 0 mem: [0x0-0x0]
[    0.365074] pci_bus 0000:03: resource 1 mem: [0xf4300000-0xf43fffff]
[    0.365133] pci_bus 0000:03: resource 2 mem: [0x0-0x0]
[    0.365191] pci_bus 0000:03: resource 3 mem: [0x0-0x0]
[    0.365248] pci_bus 0000:05: resource 0 io:  [0x2000-0x2fff]
[    0.365307] pci_bus 0000:05: resource 1 mem: [0xf8000000-0xf9ffffff]
[    0.365366] pci_bus 0000:05: resource 2 mem: [0xf4000000-0xf40fffff]
[    0.365425] pci_bus 0000:05: resource 3 mem: [0x0-0x0]
[    0.365501] pci_bus 0000:0d: resource 0 io:  [0x3000-0x3fff]
[    0.365560] pci_bus 0000:0d: resource 1 mem: [0xfa000000-0xfbffffff]
[    0.365619] pci_bus 0000:0d: resource 2 mem: [0xf4100000-0xf41fffff]
[    0.365678] pci_bus 0000:0d: resource 3 mem: [0x0-0x0]
[    0.365736] pci_bus 0000:15: resource 0 io:  [0x4000-0x7fff]
[    0.365794] pci_bus 0000:15: resource 1 mem: [0xf4800000-0xf7ffffff]
[    0.365853] pci_bus 0000:15: resource 2 mem: [0xf0000000-0xf3ffffff]
[    0.365912] pci_bus 0000:15: resource 3 io:  [0x00-0xffff]
[    0.365970] pci_bus 0000:15: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.366030] pci_bus 0000:16: resource 0 io:  [0x4000-0x40ff]
[    0.366088] pci_bus 0000:16: resource 1 io:  [0x4400-0x44ff]
[    0.366147] pci_bus 0000:16: resource 2 mem: [0xf0000000-0xf3ffffff]
[    0.366206] pci_bus 0000:16: resource 3 mem: [0xc4000000-0xc7ffffff]
[    0.366266] initcall pcibios_assign_resources+0x0/0x88 returned 0 after 2516 usecs
[    0.366337] calling  sysctl_core_init+0x0/0x38 @ 1
[    0.366409] initcall sysctl_core_init+0x0/0x38 returned 0 after 14 usecs
[    0.366470] calling  inet_init+0x0/0x209 @ 1
[    0.366531] NET: Registered protocol family 2
[    0.413519] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.414236] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.415568] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.416014] TCP: Hash tables configured (established 262144 bind 65536)
[    0.416074] TCP reno registered
[    0.425555] initcall inet_init+0x0/0x209 returned 0 after 57639 usecs
[    0.425618] calling  af_unix_init+0x0/0x55 @ 1
[    0.425675] NET: Registered protocol family 1
[    0.425738] initcall af_unix_init+0x0/0x55 returned 0 after 62 usecs
[    0.425799] calling  populate_rootfs+0x0/0x2b1 @ 1
[    0.425899] checking if image is initramfs...
[    0.438914] rootfs image is initramfs; unpacking...
[    0.438980] Freeing initrd memory: 567k freed
[    0.439130] initcall populate_rootfs+0x0/0x2b1 returned 0 after 12962 usecs
[    0.439191] calling  i8259A_init_sysfs+0x0/0x22 @ 1
[    0.439276] initcall i8259A_init_sysfs+0x0/0x22 returned 0 after 26 usecs
[    0.439336] calling  vsyscall_init+0x0/0x6c @ 1
[    0.439406] initcall vsyscall_init+0x0/0x6c returned 0 after 12 usecs
[    0.439466] calling  sbf_init+0x0/0xef @ 1
[    0.439525] Simple Boot Flag at 0x35 set to 0x1
[    0.439585] initcall sbf_init+0x0/0xef returned 0 after 60 usecs
[    0.439644] calling  i8237A_init_sysfs+0x0/0x22 @ 1
[    0.439715] initcall i8237A_init_sysfs+0x0/0x22 returned 0 after 12 usecs
[    0.439775] calling  add_rtc_cmos+0x0/0xc4 @ 1
[    0.439836] initcall add_rtc_cmos+0x0/0xc4 returned 0 after 4 usecs
[    0.439897] calling  cache_sysfs_init+0x0/0x62 @ 1
[    0.441708] initcall cache_sysfs_init+0x0/0x62 returned 0 after 78 usecs
[    0.441769] calling  mce_init_device+0x0/0x15a @ 1
[    0.441879] initcall mce_init_device+0x0/0x15a returned 0 after 50 usecs
[    0.441939] calling  periodic_mcheck_init+0x0/0x14 @ 1
[    0.441998] initcall periodic_mcheck_init+0x0/0x14 returned 0 after 0 usecs
[    0.442058] calling  thermal_throttle_init_device+0x0/0x95 @ 1
[    0.442121] initcall thermal_throttle_init_device+0x0/0x95 returned 0 after 2 usecs
[    0.442192] calling  ioapic_init_sysfs+0x0/0xa7 @ 1
[    0.442263] initcall ioapic_init_sysfs+0x0/0xa7 returned 0 after 12 usecs
[    0.442323] calling  add_pcspkr+0x0/0x28 @ 1
[    0.442397] initcall add_pcspkr+0x0/0x28 returned 0 after 16 usecs
[    0.442458] calling  start_periodic_check_for_corruption+0x0/0x37 @ 1
[    0.442518] initcall start_periodic_check_for_corruption+0x0/0x37 returned 0 after 0 usecs
[    0.442590] calling  audit_classes_init+0x0/0xaf @ 1
[    0.442652] initcall audit_classes_init+0x0/0xaf returned 0 after 4 usecs
[    0.442712] calling  init_vdso_vars+0x0/0x229 @ 1
[    0.442778] initcall init_vdso_vars+0x0/0x229 returned 0 after 8 usecs
[    0.442838] calling  ia32_binfmt_init+0x0/0x14 @ 1
[    0.442899] initcall ia32_binfmt_init+0x0/0x14 returned 0 after 3 usecs
[    0.442959] calling  sysenter_setup+0x0/0x2df @ 1
[    0.443020] initcall sysenter_setup+0x0/0x2df returned 0 after 3 usecs
[    0.443080] calling  init_sched_debug_procfs+0x0/0x2c @ 1
[    0.443142] initcall init_sched_debug_procfs+0x0/0x2c returned 0 after 3 usecs
[    0.443213] calling  proc_schedstat_init+0x0/0x22 @ 1
[    0.443272] initcall proc_schedstat_init+0x0/0x22 returned 0 after 0 usecs
[    0.443332] calling  proc_execdomains_init+0x0/0x22 @ 1
[    0.443392] initcall proc_execdomains_init+0x0/0x22 returned 0 after 1 usecs
[    0.443452] calling  ioresources_init+0x0/0x3c @ 1
[    0.443512] initcall ioresources_init+0x0/0x3c returned 0 after 1 usecs
[    0.443572] calling  uid_cache_init+0x0/0x8d @ 1
[    0.443632] initcall uid_cache_init+0x0/0x8d returned 0 after 2 usecs
[    0.443692] calling  init_posix_timers+0x0/0xe4 @ 1
[    0.443752] initcall init_posix_timers+0x0/0xe4 returned 0 after 1 usecs
[    0.443812] calling  init_posix_cpu_timers+0x0/0xb0 @ 1
[    0.443870] initcall init_posix_cpu_timers+0x0/0xb0 returned 0 after 0 usecs
[    0.443931] calling  nsproxy_cache_init+0x0/0x2d @ 1
[    0.443989] initcall nsproxy_cache_init+0x0/0x2d returned 0 after 0 usecs
[    0.444051] calling  create_proc_profile+0x0/0x230 @ 1
[    0.444109] initcall create_proc_profile+0x0/0x230 returned 0 after 0 usecs
[    0.444170] calling  timekeeping_init_device+0x0/0x22 @ 1
[    0.444242] initcall timekeeping_init_device+0x0/0x22 returned 0 after 12 usecs
[    0.444312] calling  init_clocksource_sysfs+0x0/0x50 @ 1
[    0.444384] initcall init_clocksource_sysfs+0x0/0x50 returned 0 after 12 usecs
[    0.444455] calling  init_timer_list_procfs+0x0/0x2c @ 1
[    0.444514] initcall init_timer_list_procfs+0x0/0x2c returned 0 after 1 usecs
[    0.444575] calling  init_tstats_procfs+0x0/0x2c @ 1
[    0.444634] initcall init_tstats_procfs+0x0/0x2c returned 0 after 1 usecs
[    0.444694] calling  futex_init+0x0/0x67 @ 1
[    0.444759] initcall futex_init+0x0/0x67 returned 0 after 7 usecs
[    0.444818] calling  proc_dma_init+0x0/0x22 @ 1
[    0.444877] initcall proc_dma_init+0x0/0x22 returned 0 after 1 usecs
[    0.444937] calling  proc_modules_init+0x0/0x22 @ 1
[    0.444996] initcall proc_modules_init+0x0/0x22 returned 0 after 1 usecs
[    0.445056] calling  kallsyms_init+0x0/0x25 @ 1
[    0.445114] initcall kallsyms_init+0x0/0x25 returned 0 after 0 usecs
[    0.445174] calling  snapshot_device_init+0x0/0x12 @ 1
[    0.445247] initcall snapshot_device_init+0x0/0x12 returned 0 after 14 usecs
[    0.445308] calling  crash_save_vmcoreinfo_init+0x0/0x4a5 @ 1
[    0.445386] initcall crash_save_vmcoreinfo_init+0x0/0x4a5 returned 0 after 18 usecs
[    0.445458] calling  crash_notes_memory_init+0x0/0x38 @ 1
[    0.445522] initcall crash_notes_memory_init+0x0/0x38 returned 0 after 1 usecs
[    0.445593] calling  ikconfig_init+0x0/0x39 @ 1
[    0.445652] initcall ikconfig_init+0x0/0x39 returned 0 after 1 usecs
[    0.445711] calling  audit_init+0x0/0x15a @ 1
[    0.445767] audit: initializing netlink socket (disabled)
[    0.445832] type=2000 audit(1239097788.444:1): initialized
[    0.445892] initcall audit_init+0x0/0x15a returned 0 after 121 usecs
[    0.445952] calling  audit_tree_init+0x0/0x49 @ 1
[    0.446011] initcall audit_tree_init+0x0/0x49 returned 0 after 0 usecs
[    0.446070] calling  utsname_sysctl_init+0x0/0x14 @ 1
[    0.446140] initcall utsname_sysctl_init+0x0/0x14 returned 0 after 11 usecs
[    0.446201] calling  init_tracepoints+0x0/0x12 @ 1
[    0.446259] initcall init_tracepoints+0x0/0x12 returned 0 after 0 usecs
[    0.446319] calling  init_lstats_procfs+0x0/0x25 @ 1
[    0.446378] initcall init_lstats_procfs+0x0/0x25 returned 0 after 1 usecs
[    0.446438] calling  init_events+0x0/0x67 @ 1
[    0.446496] initcall init_events+0x0/0x67 returned 0 after 1 usecs
[    0.446555] calling  init_blk_tracer+0x0/0x57 @ 1
[    0.446872] initcall init_blk_tracer+0x0/0x57 returned 0 after 253 usecs
[    0.446935] calling  init_per_zone_pages_min+0x0/0x88 @ 1
[    0.447268] initcall init_per_zone_pages_min+0x0/0x88 returned 0 after 265 usecs
[    0.447339] calling  pdflush_init+0x0/0x12 @ 1
[    0.447433] initcall pdflush_init+0x0/0x12 returned 0 after 34 usecs
[    0.447493] calling  kswapd_init+0x0/0x20 @ 1
[    0.447567] initcall kswapd_init+0x0/0x20 returned 0 after 16 usecs
[    0.447626] calling  init_tmpfs+0x0/0xda @ 1
[    0.447704] initcall init_tmpfs+0x0/0xda returned 0 after 20 usecs
[    0.447764] calling  setup_vmstat+0x0/0xc3 @ 1
[    0.447828] initcall setup_vmstat+0x0/0xc3 returned 0 after 6 usecs
[    0.447887] calling  mm_sysfs_init+0x0/0x29 @ 1
[    0.447947] initcall mm_sysfs_init+0x0/0x29 returned 0 after 2 usecs
[    0.448006] calling  proc_vmalloc_init+0x0/0x25 @ 1
[    0.448065] initcall proc_vmalloc_init+0x0/0x25 returned 0 after 1 usecs
[    0.448125] calling  procswaps_init+0x0/0x22 @ 1
[    0.448184] initcall procswaps_init+0x0/0x22 returned 0 after 1 usecs
[    0.448243] calling  hugetlb_init+0x0/0x316 @ 1
[    0.448301] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.448366] initcall hugetlb_init+0x0/0x316 returned 0 after 63 usecs
[    0.448425] calling  slab_proc_init+0x0/0x25 @ 1
[    0.448484] initcall slab_proc_init+0x0/0x25 returned 0 after 1 usecs
[    0.448544] calling  slab_sysfs_init+0x0/0xf0 @ 1
[    0.449585] initcall slab_sysfs_init+0x0/0xf0 returned 0 after 959 usecs
[    0.449645] calling  fasync_init+0x0/0x2a @ 1
[    0.449726] initcall fasync_init+0x0/0x2a returned 0 after 22 usecs
[    0.449785] calling  proc_filesystems_init+0x0/0x22 @ 1
[    0.449845] initcall proc_filesystems_init+0x0/0x22 returned 0 after 1 usecs
[    0.449905] calling  dnotify_init+0x0/0x2a @ 1
[    0.449989] initcall dnotify_init+0x0/0x2a returned 0 after 25 usecs
[    0.450049] calling  inotify_setup+0x0/0x12 @ 1
[    0.450106] initcall inotify_setup+0x0/0x12 returned 0 after 0 usecs
[    0.450165] calling  inotify_user_setup+0x0/0xb8 @ 1
[    0.450233] initcall inotify_user_setup+0x0/0xb8 returned 0 after 8 usecs
[    0.450293] calling  aio_setup+0x0/0x71 @ 1
[    0.450401] initcall aio_setup+0x0/0x71 returned 0 after 49 usecs
[    0.450460] calling  proc_locks_init+0x0/0x22 @ 1
[    0.450519] initcall proc_locks_init+0x0/0x22 returned 0 after 1 usecs
[    0.450579] calling  init_sys32_ioctl+0x0/0x85 @ 1
[    0.450648] initcall init_sys32_ioctl+0x0/0x85 returned 0 after 11 usecs
[    0.450708] calling  dquot_init+0x0/0x105 @ 1
[    0.450764] VFS: Disk quotas dquot_6.5.2
[    0.450866] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.450931] initcall dquot_init+0x0/0x105 returned 0 after 162 usecs
[    0.450991] calling  proc_cmdline_init+0x0/0x22 @ 1
[    0.451050] initcall proc_cmdline_init+0x0/0x22 returned 0 after 1 usecs
[    0.451110] calling  proc_cpuinfo_init+0x0/0x22 @ 1
[    0.451169] initcall proc_cpuinfo_init+0x0/0x22 returned 0 after 1 usecs
[    0.451229] calling  proc_devices_init+0x0/0x22 @ 1
[    0.451288] initcall proc_devices_init+0x0/0x22 returned 0 after 0 usecs
[    0.451348] calling  proc_interrupts_init+0x0/0x22 @ 1
[    0.451407] initcall proc_interrupts_init+0x0/0x22 returned 0 after 0 usecs
[    0.451467] calling  proc_loadavg_init+0x0/0x22 @ 1
[    0.451526] initcall proc_loadavg_init+0x0/0x22 returned 0 after 0 usecs
[    0.451586] calling  proc_meminfo_init+0x0/0x22 @ 1
[    0.451645] initcall proc_meminfo_init+0x0/0x22 returned 0 after 1 usecs
[    0.451705] calling  proc_stat_init+0x0/0x22 @ 1
[    0.451763] initcall proc_stat_init+0x0/0x22 returned 0 after 1 usecs
[    0.451823] calling  proc_uptime_init+0x0/0x22 @ 1
[    0.451882] initcall proc_uptime_init+0x0/0x22 returned 0 after 0 usecs
[    0.451942] calling  proc_version_init+0x0/0x22 @ 1
[    0.452000] initcall proc_version_init+0x0/0x22 returned 0 after 0 usecs
[    0.452060] calling  proc_kmsg_init+0x0/0x25 @ 1
[    0.452119] initcall proc_kmsg_init+0x0/0x25 returned 0 after 0 usecs
[    0.452178] calling  proc_page_init+0x0/0x42 @ 1
[    0.452237] initcall proc_page_init+0x0/0x42 returned 0 after 1 usecs
[    0.452297] calling  init_devpts_fs+0x0/0x3f @ 1
[    0.452359] initcall init_devpts_fs+0x0/0x3f returned 0 after 5 usecs
[    0.452419] calling  init_ramfs_fs+0x0/0x12 @ 1
[    0.452477] initcall init_ramfs_fs+0x0/0x12 returned 0 after 0 usecs
[    0.452537] calling  init_hugetlbfs_fs+0x0/0x98 @ 1
[    0.452627] initcall init_hugetlbfs_fs+0x0/0x98 returned 0 after 31 usecs
[    0.452688] calling  init_romfs_fs+0x0/0x87 @ 1
[    0.452744] ROMFS MTD (C) 2007 Red Hat, Inc.
[    0.452825] initcall init_romfs_fs+0x0/0x87 returned 0 after 77 usecs
[    0.452884] calling  ipc_init+0x0/0x23 @ 1
[    0.452943] msgmni has been set to 7687
[    0.453003] initcall ipc_init+0x0/0x23 returned 0 after 60 usecs
[    0.453062] calling  ipc_sysctl_init+0x0/0x14 @ 1
[    0.453141] initcall ipc_sysctl_init+0x0/0x14 returned 0 after 20 usecs
[    0.453201] calling  init_mqueue_fs+0x0/0xc6 @ 1
[    0.453302] initcall init_mqueue_fs+0x0/0xc6 returned 0 after 42 usecs
[    0.453362] calling  key_proc_init+0x0/0x33 @ 1
[    0.453421] initcall key_proc_init+0x0/0x33 returned 0 after 1 usecs
[    0.453490] calling  crypto_wq_init+0x0/0x2e @ 1
[    0.453584] initcall crypto_wq_init+0x0/0x2e returned 0 after 35 usecs
[    0.453649] calling  crypto_algapi_init+0x0/0xd @ 1
[    0.453716] initcall crypto_algapi_init+0x0/0xd returned 0 after 6 usecs
[    0.453780] calling  chainiv_module_init+0x0/0x12 @ 1
[    0.453843] initcall chainiv_module_init+0x0/0x12 returned 0 after 1 usecs
[    0.453906] calling  eseqiv_module_init+0x0/0x12 @ 1
[    0.453964] initcall eseqiv_module_init+0x0/0x12 returned 0 after 0 usecs
[    0.454024] calling  hmac_module_init+0x0/0x12 @ 1
[    0.454082] initcall hmac_module_init+0x0/0x12 returned 0 after 0 usecs
[    0.455810] calling  md5_mod_init+0x0/0x12 @ 1
[    0.455912] initcall md5_mod_init+0x0/0x12 returned 0 after 42 usecs
[    0.455972] calling  sha256_generic_mod_init+0x0/0x3f @ 1
[    0.456219] initcall sha256_generic_mod_init+0x0/0x3f returned 0 after 178 usecs
[    0.456294] calling  krng_mod_init+0x0/0x12 @ 1
[    0.456432] alg: No test for stdrng (krng)
[    0.456496] initcall krng_mod_init+0x0/0x12 returned 0 after 138 usecs
[    0.456559] calling  proc_genhd_init+0x0/0x3c @ 1
[    0.456621] initcall proc_genhd_init+0x0/0x3c returned 0 after 3 usecs
[    0.456681] calling  bsg_init+0x0/0x12a @ 1
[    0.456779] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.456851] initcall bsg_init+0x0/0x12a returned 0 after 109 usecs
[    0.456910] calling  noop_init+0x0/0x14 @ 1
[    0.456966] io scheduler noop registered
[    0.457023] initcall noop_init+0x0/0x14 returned 0 after 54 usecs
[    0.457082] calling  as_init+0x0/0x14 @ 1
[    0.457138] io scheduler anticipatory registered
[    0.457195] initcall as_init+0x0/0x14 returned 0 after 55 usecs
[    0.457254] calling  deadline_init+0x0/0x14 @ 1
[    0.457311] io scheduler deadline registered
[    0.457367] initcall deadline_init+0x0/0x14 returned 0 after 54 usecs
[    0.457427] calling  cfq_init+0x0/0x94 @ 1
[    0.457515] io scheduler cfq registered (default)
[    0.457573] initcall cfq_init+0x0/0x94 returned 0 after 83 usecs
[    0.457633] calling  percpu_counter_startup+0x0/0x39 @ 1
[    0.457691] initcall percpu_counter_startup+0x0/0x39 returned 0 after 0 usecs
[    0.457753] calling  pci_init+0x0/0x35 @ 1
[    0.457817] pci 0000:00:02.0: Boot video device
[    0.458031] initcall pci_init+0x0/0x35 returned 0 after 215 usecs
[    0.458091] calling  pci_proc_init+0x0/0x6b @ 1
[    0.458198] initcall pci_proc_init+0x0/0x6b returned 0 after 48 usecs
[    0.458258] calling  pcie_portdrv_init+0x0/0x4c @ 1
[    0.458413] pcieport-driver 0000:00:1c.0: irq 24 for MSI/MSI-X
[    0.458487] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.458706] pcieport-driver 0000:00:1c.1: irq 25 for MSI/MSI-X
[    0.458779] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    0.458999] pcieport-driver 0000:00:1c.3: irq 26 for MSI/MSI-X
[    0.459072] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[    0.459293] pcieport-driver 0000:00:1c.4: irq 27 for MSI/MSI-X
[    0.459366] pcieport-driver 0000:00:1c.4: setting latency timer to 64
[    0.459522] initcall pcie_portdrv_init+0x0/0x4c returned 0 after 1177 usecs
[    0.459583] calling  aer_service_init+0x0/0x20 @ 1
[    0.459650] initcall aer_service_init+0x0/0x20 returned 0 after 9 usecs
[    0.459710] calling  acpi_reserve_resources+0x0/0xeb @ 1
[    0.459771] initcall acpi_reserve_resources+0x0/0xeb returned 0 after 1 usecs
[    0.459832] calling  irqrouter_init_sysfs+0x0/0x38 @ 1
[    0.459905] initcall irqrouter_init_sysfs+0x0/0x38 returned 0 after 15 usecs
[    0.459967] calling  rand_initialize+0x0/0x2c @ 1
[    0.460036] initcall rand_initialize+0x0/0x2c returned 0 after 10 usecs
[    0.460096] calling  tty_init+0x0/0xf5 @ 1
[    0.460980] initcall tty_init+0x0/0xf5 returned 0 after 807 usecs
[    0.461039] calling  pty_init+0x0/0x5df @ 1
[    0.471408] initcall pty_init+0x0/0x5df returned 0 after 10068 usecs
[    0.471468] calling  sysrq_init+0x0/0x25 @ 1
[    0.471527] initcall sysrq_init+0x0/0x25 returned 0 after 1 usecs
[    0.471586] calling  hpet_init+0x0/0x6a @ 1
[    0.471734] initcall hpet_init+0x0/0x6a returned 0 after 89 usecs
[    0.471794] calling  mod_init+0x0/0xbc @ 1
[    0.471865] initcall mod_init+0x0/0xbc returned -19 after 14 usecs
[    0.471924] calling  agp_init+0x0/0x26 @ 1
[    0.471980] Linux agpgart interface v0.103
[    0.472037] initcall agp_init+0x0/0x26 returned 0 after 54 usecs
[    0.472096] calling  serial8250_init+0x0/0x112 @ 1
[    0.472153] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.472402] initcall serial8250_init+0x0/0x112 returned 0 after 242 usecs
[    0.472462] calling  serial8250_pnp_init+0x0/0x12 @ 1
[    0.472622] initcall serial8250_pnp_init+0x0/0x12 returned 0 after 99 usecs
[    0.472683] calling  serial8250_pci_init+0x0/0x1b @ 1
[    0.472766] initcall serial8250_pci_init+0x0/0x1b returned 0 after 24 usecs
[    0.472828] calling  topology_sysfs_init+0x0/0x5e @ 1
[    0.472894] initcall topology_sysfs_init+0x0/0x5e returned 0 after 7 usecs
[    0.472954] calling  brd_init+0x0/0x193 @ 1
[    0.473597] brd: module loaded
[    0.473653] initcall brd_init+0x0/0x193 returned 0 after 624 usecs
[    0.473713] calling  net_olddevs_init+0x0/0x9e @ 1
[    0.473774] initcall net_olddevs_init+0x0/0x9e returned 0 after 3 usecs
[    0.473834] calling  i8042_init+0x0/0x386 @ 1
[    0.473924] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    0.483795] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.483856] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.483916] initcall i8042_init+0x0/0x386 returned 0 after 9791 usecs
[    0.483976] calling  mousedev_init+0x0/0x8d @ 1
[    0.484080] mice: PS/2 mouse device common for all mice
[    0.484139] initcall mousedev_init+0x0/0x8d returned 0 after 102 usecs
[    0.484199] calling  atkbd_init+0x0/0x27 @ 1
[    0.484267] initcall atkbd_init+0x0/0x27 returned 0 after 11 usecs
[    0.484326] calling  cmos_init+0x0/0x4c @ 1
[    0.484404] rtc_cmos 00:07: RTC can wake from S4
[    0.484495] rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
[    0.484580] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.484648] initcall cmos_init+0x0/0x4c returned 0 after 259 usecs
[    0.484708] calling  init_ladder+0x0/0x12 @ 1
[    0.484765] cpuidle: using governor ladder
[    0.484822] initcall init_ladder+0x0/0x12 returned 0 after 55 usecs
[    0.484881] calling  init_menu+0x0/0x12 @ 1
[    0.484937] cpuidle: using governor menu
[    0.484994] initcall init_menu+0x0/0x12 returned 0 after 54 usecs
[    0.485053] calling  ledtrig_ide_init+0x0/0x1b @ 1
[    0.485111] initcall ledtrig_ide_init+0x0/0x1b returned 0 after 0 usecs
[    0.485172] calling  defon_trig_init+0x0/0x12 @ 1
[    0.485229] initcall defon_trig_init+0x0/0x12 returned 0 after 0 usecs
[    0.485290] calling  flow_cache_init+0x0/0x1a6 @ 1
[    0.485362] initcall flow_cache_init+0x0/0x1a6 returned 0 after 13 usecs
[    0.485422] calling  blackhole_module_init+0x0/0x12 @ 1
[    0.485516] initcall blackhole_module_init+0x0/0x12 returned 0 after 0 usecs
[    0.485578] calling  sysctl_ipv4_init+0x0/0x4e @ 1
[    0.485842] initcall sysctl_ipv4_init+0x0/0x4e returned 0 after 201 usecs
[    0.485903] calling  init_syncookies+0x0/0x19 @ 1
[    0.485982] initcall init_syncookies+0x0/0x19 returned 0 after 20 usecs
[    0.486043] calling  ipv4_netfilter_init+0x0/0x12 @ 1
[    0.486102] initcall ipv4_netfilter_init+0x0/0x12 returned 0 after 0 usecs
[    0.486162] calling  cubictcp_register+0x0/0x65 @ 1
[    0.486220] TCP cubic registered
[    0.486276] initcall cubictcp_register+0x0/0x65 returned 0 after 54 usecs
[    0.486336] calling  packet_init+0x0/0x47 @ 1
[    0.486392] NET: Registered protocol family 17
[    0.486455] initcall packet_init+0x0/0x47 returned 0 after 61 usecs
[    0.486514] calling  dcbnl_init+0x0/0x32 @ 1
[    0.486571] initcall dcbnl_init+0x0/0x32 returned 0 after 0 usecs
[    0.486632] calling  hpet_insert_resource+0x0/0x23 @ 1
[    0.486691] initcall hpet_insert_resource+0x0/0x23 returned 0 after 0 usecs
[    0.486752] calling  update_mp_table+0x0/0x684 @ 1
[    0.486810] initcall update_mp_table+0x0/0x684 returned 0 after 0 usecs
[    0.486870] calling  lapic_insert_resource+0x0/0x40 @ 1
[    0.486929] initcall lapic_insert_resource+0x0/0x40 returned 0 after 0 usecs
[    0.486989] calling  init_lapic_nmi_sysfs+0x0/0x39 @ 1
[    0.487047] initcall init_lapic_nmi_sysfs+0x0/0x39 returned 0 after 0 usecs
[    0.487107] calling  ioapic_insert_resources+0x0/0x58 @ 1
[    0.487166] initcall ioapic_insert_resources+0x0/0x58 returned 0 after 0 usecs
[    0.487237] calling  io_apic_bug_finalize+0x0/0x1b @ 1
[    0.487295] initcall io_apic_bug_finalize+0x0/0x1b returned 0 after 0 usecs
[    0.487356] calling  check_early_ioremap_leak+0x0/0x67 @ 1
[    0.487414] initcall check_early_ioremap_leak+0x0/0x67 returned 0 after 0 usecs
[    0.487485] calling  pat_memtype_list_init+0x0/0x29 @ 1
[    0.487546] initcall pat_memtype_list_init+0x0/0x29 returned 0 after 2 usecs
[    0.487606] calling  sched_init_debug+0x0/0x24 @ 1
[    0.487665] initcall sched_init_debug+0x0/0x24 returned 0 after 1 usecs
[    0.487726] calling  init_oops_id+0x0/0x31 @ 1
[    0.487785] initcall init_oops_id+0x0/0x31 returned 0 after 2 usecs
[    0.487845] calling  disable_boot_consoles+0x0/0x3a @ 1
[    0.487904] initcall disable_boot_consoles+0x0/0x3a returned 0 after 0 usecs
[    0.487965] calling  pm_qos_power_init+0x0/0xca @ 1
[    0.488084] initcall pm_qos_power_init+0x0/0xca returned 0 after 59 usecs
[    0.488146] calling  software_resume+0x0/0x170 @ 1
[    0.488203] async_waiting @ 1
[    0.488257] async_continuing @ 1 after 0 usec
[    0.488330] initcall software_resume+0x0/0x170 returned -6 after 123 usecs
[    0.488391] initcall software_resume+0x0/0x170 returned with error code -6 
[    0.488451] calling  taskstats_init+0x0/0x95 @ 1
[    0.488511] registered taskstats version 1
[    0.488567] initcall taskstats_init+0x0/0x95 returned 0 after 57 usecs
[    0.488627] calling  clear_boot_tracer+0x0/0x2d @ 1
[    0.488685] initcall clear_boot_tracer+0x0/0x2d returned 0 after 0 usecs
[    0.488745] calling  max_swapfiles_check+0x0/0x8 @ 1
[    0.488802] initcall max_swapfiles_check+0x0/0x8 returned 0 after 0 usecs
[    0.488863] calling  random32_reseed+0x0/0xa9 @ 1
[    0.488927] initcall random32_reseed+0x0/0xa9 returned 0 after 6 usecs
[    0.488987] calling  pci_resource_alignment_sysfs_init+0x0/0x19 @ 1
[    0.489049] initcall pci_resource_alignment_sysfs_init+0x0/0x19 returned 0 after 1 usecs
[    0.489121] calling  pci_sysfs_init+0x0/0x4c @ 1
[    0.489269] initcall pci_sysfs_init+0x0/0x4c returned 0 after 87 usecs
[    0.489328] calling  regulator_init_complete+0x0/0x13a @ 1
[    0.489387] initcall regulator_init_complete+0x0/0x13a returned 0 after 0 usecs
[    0.489458] calling  seqgen_init+0x0/0xf @ 1
[    0.489529] initcall seqgen_init+0x0/0xf returned 0 after 8 usecs
[    0.489589] calling  rtc_hctosys+0x0/0x152 @ 1
[    0.489670] rtc_cmos 00:07: setting system clock to 2009-04-07 09:49:49 UTC (1239097789)
[    0.489742] initcall rtc_hctosys+0x0/0x152 returned 0 after 94 usecs
[    0.489802] calling  memmap_init+0x0/0xa7 @ 1
[    0.489927] initcall memmap_init+0x0/0xa7 returned 0 after 67 usecs
[    0.489987] calling  pci_mmcfg_late_insert_resources+0x0/0x163 @ 1
[    0.490048] initcall pci_mmcfg_late_insert_resources+0x0/0x163 returned 0 after 1 usecs
[    0.491788] calling  tcp_congestion_default+0x0/0x12 @ 1
[    0.491847] initcall tcp_congestion_default+0x0/0x12 returned 0 after 0 usecs
[    0.491908] calling  ip_auto_config+0x0/0xe54 @ 1
[    0.491968] initcall ip_auto_config+0x0/0xe54 returned 0 after 1 usecs
[    0.492028] calling  initialize_hashrnd+0x0/0x19 @ 1
[    0.492088] initcall initialize_hashrnd+0x0/0x19 returned 0 after 2 usecs
[    0.492150] async_waiting @ 1
[    0.492205] async_continuing @ 1 after 0 usec
[    0.492268] Freeing unused kernel memory: 392k freed
[    0.496388] input: AT Translated Set 2 keyboard as /class/input/input0
[    0.504761] calling  init_scsi+0x0/0x91 [scsi_mod] @ 900
[    0.504929] SCSI subsystem initialized
[    0.504992] initcall init_scsi+0x0/0x91 [scsi_mod] returned 0 after 161 usecs
[    0.516575] calling  ata_init+0x0/0x388 [libata] @ 901
[    0.516724] libata version 3.00 loaded.
[    0.516789] initcall ata_init+0x0/0x388 [libata] returned 0 after 139 usecs
[    0.519189] calling  ahci_init+0x0/0x20 [ahci] @ 1733
[    0.519264] ahci 0000:00:1f.2: version 3.0
[    0.519332] ahci 0000:00:1f.2: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.519446] ahci 0000:00:1f.2: irq 28 for MSI/MSI-X
[    0.519541] ahci: SSS flag set, parallel bus scan disabled
[    0.519622] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x3 impl SATA mode
[    0.519694] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part 
[    0.519767] ahci 0000:00:1f.2: setting latency timer to 64
[    0.520001] scsi0 : ahci
[    0.520126] scsi1 : ahci
[    0.520342] scsi2 : ahci
[    0.520474] scsi3 : ahci
[    0.521314] ata1: SATA max UDMA/133 abar m2048@0xfc226000 port 0xfc226100 irq 28
[    0.521386] ata2: SATA max UDMA/133 abar m2048@0xfc226000 port 0xfc226180 irq 28
[    0.521456] ata3: DUMMY
[    0.521511] ata4: DUMMY
[    0.521593] initcall ahci_init+0x0/0x20 [ahci] returned 0 after 2288 usecs
[    0.524235] calling  init_sd+0x0/0x100 [sd_mod] @ 1887
[    0.524313] Driver 'sd' needs updating - please use bus_type methods
[    0.524393] initcall init_sd+0x0/0x100 [sd_mod] returned 0 after 95 usecs
[    0.524722] calling  wait_scan_init+0x0/0xd [scsi_wait_scan] @ 1916
[    0.524783] initcall wait_scan_init+0x0/0xd [scsi_wait_scan] returned 0 after 0 usecs
[    0.549494] Switched to high resolution mode on CPU 1
[    0.552033] Switched to high resolution mode on CPU 0
[    0.792018] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    0.792715] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[    0.792775] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    0.792915] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[    0.792975] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    0.793396] ata1.00: ATA-8: FUJITSU MHZ2160BJ G1, 0084001F, max UDMA/100
[    0.793457] ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    0.794186] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
[    0.794245] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[    0.794383] ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
[    0.794442] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    0.794881] ata1.00: configured for UDMA/100
[    0.808877] ata1.00: configured for UDMA/100
[    0.808934] ata1: EH complete
[    0.809072] scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHZ2160B 0084 PQ: 0 ANSI: 5
[    0.809320] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
[    0.809402] sd 0:0:0:0: [sda] Write Protect is off
[    0.809459] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.809534] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.809677]  sda: sda1 sda2 sda3 sda4
[    0.846834] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.128017] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.131405] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
[    1.132499] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
[    1.132558] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    1.133596] ata2.00: ATAPI: Optiarc  DVD RW AD-7910S, 1.D0, max UDMA/100
[    1.137377] ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
[    1.138461] ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
[    1.138521] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 filtered out
[    1.139577] ata2.00: configured for UDMA/100
[    1.157611] scsi 1:0:0:0: CD-ROM            Optiarc  DVD RW AD-7910S  1.D0 PQ: 0 ANSI: 5
[    2.529053] calling  init_xfs_fs+0x0/0xaa [xfs] @ 1958
[    2.529112] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[    2.529582] SGI XFS Quota Management subsystem
[    2.529656] initcall init_xfs_fs+0x0/0xaa [xfs] returned 0 after 519 usecs
[    2.568143] XFS mounting filesystem sda3
[    2.907261] Ending clean XFS mount for filesystem: sda3
[    5.039448] calling  acpi_button_init+0x0/0x56 [button] @ 3091
[    5.039579] input: Power Button (FF) as /class/input/input1
[    5.046418] calling  acpi_ac_init+0x0/0x45 [ac] @ 3127
[    5.046932] ACPI: AC Adapter [AC] (on-line)
[    5.047010] initcall acpi_ac_init+0x0/0x45 [ac] returned 0 after 519 usecs
[    5.053653] calling  acpi_battery_init+0x0/0x16 [battery] @ 3146
[    5.053716] initcall acpi_battery_init+0x0/0x16 [battery] returned 0 after 1 usecs
[    5.053968] ACPI: Power Button (FF) [PWRF]
[    5.054076] input: Lid Switch as /class/input/input2
[    5.054590] ACPI: Lid Switch [LID]
[    5.054687] input: Sleep Button (CM) as /class/input/input3
[    5.067949] calling  cfg80211_init+0x0/0x74 [cfg80211] @ 3026
[    5.069023] ACPI: Sleep Button (CM) [SLPB]
[    5.069104] initcall acpi_button_init+0x0/0x56 [button] returned 0 after 28888 usecs
[    5.077609] calling  evdev_init+0x0/0x12 [evdev] @ 3170
[    5.094337] ACPI: Battery Slot [BAT0] (battery present)
[    5.094418] BUG: unable to handle kernel NULL pointer dereference at (null)
[    5.094559] IP: [<ffffffffa00fd040>] 0xffffffffa00fd040
[    5.094659] PGD 13998a067 PUD 139979067 PMD 0 
[    5.094837] Oops: 0002 [#1] PREEMPT SMP 
[    5.095014] last sysfs file: /sys/devices/platform/i8042/modalias
[    5.095073] CPU 0 
[    5.095168] Modules linked in: evdev(+) cfg80211(+) battery ac button crc_itu_t xfs exportfs scsi_wait_scan sd_mod crc_t10dif ahci libata scsi_mod
[    5.095860] Pid: 3167, comm: async/0 Not tainted 2.6.29 #12 2764CTO
[    5.095920] RIP: 0010:[<ffffffffa00fd040>]  [<ffffffffa00fd040>] 0xffffffffa00fd040
[    5.096032] RSP: 0018:ffff8801390fbec0  EFLAGS: 00010246
[    5.096090] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff80343007
[    5.096150] RDX: ffff8801390fbe90 RSI: ffff880028030f50 RDI: ffffe20004480340
[    5.096210] RBP: ffff8801390fbec0 R08: ffffffff805bbc10 R09: ffffffff805d6de0
[    5.096270] R10: 0000000300000000 R11: ffff8801390fbe70 R12: ffff88013a943880
[    5.096330] R13: ffff88013b91fd70 R14: 0000000000000001 R15: 0000000000000001
[    5.096391] FS:  0000000000000000(0000) GS:ffff880028023000(0000) knlGS:0000000000000000
[    5.096462] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[    5.096520] CR2: 0000000000000000 CR3: 0000000139977000 CR4: 00000000000006e0
[    5.096580] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    5.096640] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    5.096701] Process async/0 (pid: 3167, threadinfo ffff8801390fa000, task ffff880139cfacc0)
[    5.096772] Stack:
[    5.096824]  ffff8801390fbf20 ffffffff80256da3 0000000000000000 ffff880139cfacc0
[    5.097005]  ffffffff80239b89 ffff88013b91fee8 ffffffff80596618 ffff88013b91fd70
[    5.097275]  0000000000000000 ffffffff80256c8a ffff88013b91fd70 ffff88013b88df00
[    5.097595] Call Trace:
[    5.097648]  [<ffffffff80256da3>] async_thread+0x119/0x220
[    5.097749]  [<ffffffff80239b89>] ? default_wake_function+0x0/0xf
[    5.097849]  [<ffffffff80256c8a>] ? async_thread+0x0/0x220
[    5.097937]  [<ffffffff80251345>] kthread+0x49/0x76
[    5.097937]  [<ffffffff8020cb6a>] child_rip+0xa/0x20
[    5.097937]  [<ffffffff802512fc>] ? kthread+0x0/0x76
[    5.097937]  [<ffffffff8020cb60>] ? child_rip+0x0/0x20
[    5.097937] Code: 00 00 00 25 00 be 3b 01 00 00 00 00 00 00 00 00 00 00 00 25 70 b9 3b 01 00 00 00 25 e0 bb 3b 01 00 00 00 25 f0 bd 3b 01 00 00 00 <00> 00 00 00 00 00 00 00 25 30 bb 3b 01 
00 00 00 25 00 bc 3b 01 
[    5.097937] RIP  [<ffffffffa00fd040>] 0xffffffffa00fd040
[    5.097937]  RSP <ffff8801390fbec0>
[    5.097937] CR2: 0000000000000000
[    5.101279] ---[ end trace d3f60aa79338c308 ]---
[    5.102446] calling  acpi_thermal_init+0x0/0x7b [thermal] @ 3093
[    5.104928] calling  init_pcmcia_cs+0x0/0x2f [pcmcia_core] @ 3148
[    5.104999] initcall init_pcmcia_cs+0x0/0x2f [pcmcia_core] returned 0 after 8 usecs
[    5.111304] thermal LNXTHERM:01: registered as thermal_zone0
[    5.111370] ACPI: Thermal Zone [THM0] (47 C)
[    5.113007] thermal LNXTHERM:02: registered as thermal_zone1
[    5.113072] ACPI: Thermal Zone [THM1] (38 C)
[    5.113140] initcall acpi_thermal_init+0x0/0x7b [thermal] returned 0 after 10381 usecs
[    5.118685] calling  nonstatic_sysfs_init+0x0/0x12 [rsrc_nonstatic] @ 3148
[    5.118749] initcall nonstatic_sysfs_init+0x0/0x12 [rsrc_nonstatic] returned 0 after 0 usecs
[    5.120678] calling  acpi_processor_init+0x0/0x102 [processor] @ 3085
[    5.121328] ACPI: SSDT 00000000bd6d6c20 002C8 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    5.122012] ACPI: SSDT 00000000bd6d4020 0087A (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    5.124874] Monitor-Mwait will be used to enter C-1 state
[    5.124936] Monitor-Mwait will be used to enter C-2 state
[    5.124995] Monitor-Mwait will be used to enter C-3 state
[    5.125105] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    5.127021] processor ACPI_CPU:00: registered as cooling_device0
[    5.127081] ACPI: Processor [CPU0] (supports 8 throttling states)
[    5.127686] ACPI: SSDT 00000000bd6d5ca0 001CF (v01  PmRef    ApIst 00003000 INTL 20050624)
[    5.128253] ACPI: SSDT 00000000bd6d5f20 0008D (v01  PmRef    ApCst 00003000 INTL 20050624)
[    5.129809] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    5.130051] processor ACPI_CPU:01: registered as cooling_device1
[    5.130111] ACPI: Processor [CPU1] (supports 8 throttling states)
[    5.130351] initcall acpi_processor_init+0x0/0x102 [processor] returned 0 after 9383 usecs
[    5.132175] Marking TSC unstable due to TSC halts in idle
[    5.134500] calling  snd_mem_init+0x0/0x2c [snd_page_alloc] @ 3012
[    5.134565] initcall snd_mem_init+0x0/0x2c [snd_page_alloc] returned 0 after 3 usecs
[    5.137164] initcall cfg80211_init+0x0/0x74 [cfg80211] returned 0 after 67525 usecs
[    5.137285] cfg80211: Calling CRDA to update world regulatory domain
[    5.144136] initcall evdev_init+0x0/0x12 [evdev] returned 0 after 64905 usecs
[    5.174883] calling  usb_init+0x0/0x164 [usbcore] @ 3041
[    5.175041] usbcore: registered new interface driver usbfs
[    5.175129] usbcore: registered new interface driver hub
[    5.175216] usbcore: registered new device driver usb
[    5.175281] initcall usb_init+0x0/0x164 [usbcore] returned 0 after 305 usecs
[    5.188954] calling  yenta_socket_init+0x0/0x20 [yenta_socket] @ 3148
[    5.189088] yenta_cardbus 0000:15:00.0: CardBus bridge found [17aa:20c6]
[    5.268205] calling  ricoh_mmc_drv_init+0x0/0x3c [ricoh_mmc] @ 3157
[    5.268266] ricoh-mmc: Ricoh MMC Controller disabling driver
[    5.268323] ricoh-mmc: Copyright(c) Philip Langdale
[    5.293205] calling  nvram_init+0x0/0x82 [nvram] @ 2319
[    5.293338] Non-volatile memory driver v1.3
[    5.293397] initcall nvram_init+0x0/0x82 [nvram] returned 0 after 122 usecs
[    5.327787] calling  init_sg+0x0/0x14c [sg] @ 3050
[    5.327892] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    5.327979] scsi 1:0:0:0: Attached scsi generic sg1 type 5
[    5.328072] initcall init_sg+0x0/0x14c [sg] returned 0 after 218 usecs
[    5.348846] calling  ieee80211_init+0x0/0xb [mac80211] @ 3026
[    5.348913] initcall ieee80211_init+0x0/0xb [mac80211] returned 0 after 1 usecs
[    5.372048] calling  e1000_init_module+0x0/0x70 [e1000e] @ 3014
[    5.372108] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.4-k4
[    5.372167] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[    5.372260] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    5.372326] e1000e 0000:00:19.0: setting latency timer to 64
[    5.372519] e1000e 0000:00:19.0: irq 29 for MSI/MSI-X
[    5.377993] calling  init_soundcore+0x0/0x7b [soundcore] @ 3012
[    5.378064] initcall init_soundcore+0x0/0x7b [soundcore] returned 0 after 9 usecs
[    5.394032] calling  pcspkr_init+0x0/0x12 [pcspkr] @ 3063
[    5.394133] input: PC Speaker as /class/input/input4
[    5.400969] calling  i2c_init+0x0/0x6c [i2c_core] @ 3055
[    5.401068] initcall i2c_init+0x0/0x6c [i2c_core] returned 0 after 27 usecs
[    5.411205] calling  ehci_hcd_init+0x0/0x7c [ehci_hcd] @ 3008
[    5.411266] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.421111] initcall pcspkr_init+0x0/0x12 [pcspkr] returned 0 after 26384 usecs
[    5.425560] calling  agp_intel_init+0x0/0x2e [intel_agp] @ 2994
[    5.451145] calling  i2c_i801_init+0x0/0x20 [i2c_i801] @ 3055
[    5.464955] calling  alsa_sound_init+0x0/0x79 [snd] @ 3012
[    5.465049] initcall alsa_sound_init+0x0/0x79 [snd] returned 0 after 16 usecs
[    5.466464] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:21:86:a2:19:06
[    5.466534] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    5.466619] 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: 1008ff-0ff
[    5.466714] initcall e1000_init_module+0x0/0x70 [e1000e] returned 0 after 92382 usecs
[    5.467482] ehci_hcd 0000:00:1a.7: power state changed by ACPI to D0
[    5.467548] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    5.467628] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    5.467689] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    5.467787] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    5.469925] calling  iTCO_vendor_init_module+0x0/0x1c [iTCO_vendor_support] @ 3048
[    5.470026] iTCO_vendor_support: vendor-support=0
[    5.470106] initcall iTCO_vendor_init_module+0x0/0x1c [iTCO_vendor_support] returned 0 after 76 usecs
[    5.471762] ehci_hcd 0000:00:1a.7: debug port 1
[    5.471822] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    5.471894] ehci_hcd 0000:00:1a.7: irq 23, io mem 0xfc226c00
[    5.477212] Monitor-Mwait will be used to enter C-3 state
[    5.485020] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    5.485097] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    5.485178] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.485248] usb usb1: Product: EHCI Host Controller
[    5.485305] usb usb1: Manufacturer: Linux 2.6.29 ehci_hcd
[    5.485363] usb usb1: SerialNumber: 0000:00:1a.7
[    5.485379] calling  iTCO_wdt_init_module+0x0/0x67 [iTCO_wdt] @ 3048
[    5.485382] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[    5.485550] iTCO_wdt: Found a ICH9M-E TCO device (Version=2, TCOBASE=0x1060)
[    5.485618] usb usb1: configuration #1 chosen from 1 choice
[    5.485660] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    5.485666] initcall iTCO_wdt_init_module+0x0/0x67 [iTCO_wdt] returned 0 after 274 usecs
[    5.485844] hub 1-0:1.0: USB hub found
[    5.485906] hub 1-0:1.0: 6 ports detected
[    5.486091] agpgart-intel 0000:00:00.0: Intel Mobile IntelÂŽ GM45 Express Chipset
[    5.487788] agpgart-intel 0000:00:00.0: detected 32764K stolen memory
[    5.488448] calling  alsa_timer_init+0x0/0x1e7 [snd_timer] @ 3012
[    5.488612] initcall alsa_timer_init+0x0/0x1e7 [snd_timer] returned 0 after 72 usecs
[    5.491587] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    5.491686] initcall agp_intel_init+0x0/0x2e [intel_agp] returned 0 after 64511 usecs
[    5.491902] i801_smbus 0000:00:1f.3: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    5.492044] initcall i2c_i801_init+0x0/0x20 [i2c_i801] returned 0 after 39861 usecs
[    5.492663] ehci_hcd 0000:00:1d.7: power state changed by ACPI to D0
[    5.492732] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    5.492807] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    5.492868] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    5.492955] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    5.496939] ehci_hcd 0000:00:1d.7: debug port 1
[    5.497052] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    5.497126] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xfc227000
[    5.504096] Clocksource tsc unstable (delta = -272044657 ns)
[    5.513108] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    5.513193] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    5.513256] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.513333] usb usb2: Product: EHCI Host Controller
[    5.513389] usb usb2: Manufacturer: Linux 2.6.29 ehci_hcd
[    5.513447] usb usb2: SerialNumber: 0000:00:1d.7
[    5.513569] usb usb2: configuration #1 chosen from 1 choice
[    5.513667] hub 2-0:1.0: USB hub found
[    5.513731] hub 2-0:1.0: 6 ports detected
[    5.513912] initcall ehci_hcd_init+0x0/0x7c [ehci_hcd] returned 0 after 100236 usecs
[    5.534751] calling  cdrom_init+0x0/0x6a [cdrom] @ 3052
[    5.534839] initcall cdrom_init+0x0/0x6a [cdrom] returned 0 after 24 usecs
[    5.549064] calling  uhci_hcd_init+0x0/0xc6 [uhci_hcd] @ 3338
[    5.549128] uhci_hcd: USB Universal Host Controller Interface driver
[    5.549866] uhci_hcd 0000:00:1a.0: power state changed by ACPI to D0
[    5.549932] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    5.550000] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    5.550060] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    5.550147] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    5.550256] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00001860
[    5.550357] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    5.550419] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.550489] usb usb3: Product: UHCI Host Controller
[    5.550548] usb usb3: Manufacturer: Linux 2.6.29 uhci_hcd
[    5.550607] usb usb3: SerialNumber: 0000:00:1a.0
[    5.550749] usb usb3: configuration #1 chosen from 1 choice
[    5.550837] hub 3-0:1.0: USB hub found
[    5.550897] hub 3-0:1.0: 2 ports detected
[    5.551049] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    5.551113] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    5.551172] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    5.551248] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    5.551348] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001880
[    5.551436] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    5.551496] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.551565] usb usb4: Product: UHCI Host Controller
[    5.551622] usb usb4: Manufacturer: Linux 2.6.29 uhci_hcd
[    5.551679] usb usb4: SerialNumber: 0000:00:1a.1
[    5.551776] usb usb4: configuration #1 chosen from 1 choice
[    5.551856] hub 4-0:1.0: USB hub found
[    5.551915] hub 4-0:1.0: 2 ports detected
[    5.552840] uhci_hcd 0000:00:1a.2: power state changed by ACPI to D0
[    5.552912] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    5.552976] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    5.553037] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    5.553140] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    5.553240] uhci_hcd 0000:00:1a.2: irq 22, io base 0x000018a0
[    5.553335] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    5.553394] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.553464] usb usb5: Product: UHCI Host Controller
[    5.553520] usb usb5: Manufacturer: Linux 2.6.29 uhci_hcd
[    5.553578] usb usb5: SerialNumber: 0000:00:1a.2
[    5.555389] usb usb5: configuration #1 chosen from 1 choice
[    5.555469] hub 5-0:1.0: USB hub found
[    5.555528] hub 5-0:1.0: 2 ports detected
[    5.556231] uhci_hcd 0000:00:1d.0: power state changed by ACPI to D0
[    5.556293] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.556357] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    5.556416] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    5.556494] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    5.556607] uhci_hcd 0000:00:1d.0: irq 16, io base 0x000018c0
[    5.556700] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    5.556765] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.556835] usb usb6: Product: UHCI Host Controller
[    5.556891] usb usb6: Manufacturer: Linux 2.6.29 uhci_hcd
[    5.556949] usb usb6: SerialNumber: 0000:00:1d.0
[    5.557080] usb usb6: configuration #1 chosen from 1 choice
[    5.557177] hub 6-0:1.0: USB hub found
[    5.557237] hub 6-0:1.0: 2 ports detected
[    5.557397] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    5.557463] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    5.557523] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    5.557603] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    5.557705] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018e0
[    5.557802] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    5.557862] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.557934] usb usb7: Product: UHCI Host Controller
[    5.557992] usb usb7: Manufacturer: Linux 2.6.29 uhci_hcd
[    5.558052] usb usb7: SerialNumber: 0000:00:1d.1
[    5.558157] usb usb7: configuration #1 chosen from 1 choice
[    5.558237] hub 7-0:1.0: USB hub found
[    5.558297] hub 7-0:1.0: 2 ports detected
[    5.558457] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    5.558523] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    5.558582] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    5.558657] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    5.558758] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001c00
[    5.558846] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    5.558908] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    5.558979] usb usb8: Product: UHCI Host Controller
[    5.559038] usb usb8: Manufacturer: Linux 2.6.29 uhci_hcd
[    5.559095] usb usb8: SerialNumber: 0000:00:1d.2
[    5.559212] usb usb8: configuration #1 chosen from 1 choice
[    5.559296] hub 8-0:1.0: USB hub found
[    5.559356] hub 8-0:1.0: 2 ports detected
[    5.559529] initcall uhci_hcd_init+0x0/0xc6 [uhci_hcd] returned 0 after 10155 usecs
[    5.573870] calling  video_output_class_init+0x0/0x19 [output] @ 3140
[    5.573944] initcall video_output_class_init+0x0/0x19 [output] returned 0 after 10 usecs
[    5.596208] calling  fbmem_init+0x0/0x96 [fb] @ 3143
[    5.596290] initcall fbmem_init+0x0/0x96 [fb] returned 0 after 15 usecs
[    5.601616] calling  init_sr+0x0/0x49 [sr_mod] @ 3052
[    5.601676] Driver 'sr' needs updating - please use bus_type methods
[    5.611006] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    5.611078] Uniform CD-ROM driver Revision: 3.20
[    5.611202] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    5.611269] initcall init_sr+0x0/0x49 [sr_mod] returned 0 after 9366 usecs
[    5.615610] calling  alsa_pcm_init+0x0/0x71 [snd_pcm] @ 3012
[    5.615681] initcall alsa_pcm_init+0x0/0x71 [snd_pcm] returned 0 after 5 usecs
[    5.616526] calling  serio_raw_init+0x0/0x20 [serio_raw] @ 3068
[    5.616621] initcall serio_raw_init+0x0/0x20 [serio_raw] returned 0 after 14 usecs
[    5.624920] calling  acpi_wmi_init+0x0/0x5a [wmi] @ 3145
[    5.625066] ACPI: WMI: Mapper loaded
[    5.625125] initcall acpi_wmi_init+0x0/0x5a [wmi] returned 0 after 139 usecs
[    5.675105] calling  backlight_class_init+0x0/0x62 [backlight] @ 3143
[    5.675186] initcall backlight_class_init+0x0/0x62 [backlight] returned 0 after 12 usecs
[    5.677695] calling  fw_core_init+0x0/0x89 [firewire_core] @ 3153
[    5.677772] initcall fw_core_init+0x0/0x89 [firewire_core] returned 0 after 13 usecs
[    5.723874] calling  psmouse_init+0x0/0x75 [psmouse] @ 3068
[    5.724007] initcall psmouse_init+0x0/0x75 [psmouse] returned 0 after 67 usecs
[    5.729759] calling  alsa_hwdep_init+0x0/0x69 [snd_hwdep] @ 3012
[    5.729827] initcall alsa_hwdep_init+0x0/0x69 [snd_hwdep] returned 0 after 5 usecs
[    5.757196] calling  leds_init+0x0/0x45 [led_class] @ 2319
[    5.757287] initcall leds_init+0x0/0x45 [led_class] returned 0 after 13 usecs
[    5.771219] calling  acpi_video_init+0x0/0x6b [video] @ 3140
[    5.771288] initcall acpi_video_init+0x0/0x6b [video] returned 0 after 5 usecs
[    5.810867] calling  mmc_init+0x0/0x72 [mmc_core] @ 3158
[    5.811016] initcall mmc_init+0x0/0x72 [mmc_core] returned 0 after 81 usecs
[    5.856075] usb 1-6: new high speed USB device using ehci_hcd and address 3
[    5.868222] calling  alsa_card_azx_init+0x0/0x20 [snd_hda_intel] @ 3438
[    5.868325] HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    5.868434] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    5.875527] calling  sdhci_drv_init+0x0/0x24 [sdhci] @ 3158
[    5.875588] sdhci: Secure Digital Host Controller Interface driver
[    5.875647] sdhci: Copyright(c) Pierre Ossman
[    5.875707] initcall sdhci_drv_init+0x0/0x24 [sdhci] returned 0 after 114 usecs
[    5.884593] calling  rfkill_init+0x0/0x65 [rfkill] @ 2319
[    5.884669] initcall rfkill_init+0x0/0x65 [rfkill] returned 0 after 9 usecs
[    5.893008] calling  fw_ohci_init+0x0/0x20 [firewire_ohci] @ 3153
[    5.902022] calling  sdhci_drv_init+0x0/0x20 [sdhci_pci] @ 3158
[    5.972821] calling  thinkpad_acpi_module_init+0x0/0x9bc [thinkpad_acpi] @ 2319
[    5.974856] calling  patch_conexant_init+0x0/0x12 [snd_hda_codec_conexant] @ 3448
[    5.974936] initcall patch_conexant_init+0x0/0x12 [snd_hda_codec_conexant] returned 0 after 1 usecs
[    5.975813] thinkpad_acpi: ThinkPad ACPI Extras v0.22
[    5.975871] thinkpad_acpi: http://ibm-acpi.sf.net/
[    5.975933] thinkpad_acpi: ThinkPad BIOS 7UET61WW (2.07 ), EC 7VHT12WW-1.01
[    5.975992] thinkpad_acpi: Lenovo ThinkPad T400, model 2764CTO
[    5.976612] thinkpad_acpi: radio switch found; radios are disabled
[    5.976776] thinkpad_acpi: This ThinkPad has standard ACPI backlight brightness control, supported by the ACPI video driver
[    5.976855] thinkpad_acpi: Disabling thinkpad-acpi brightness events by default...
[    5.986137] Registered led device: tpacpi::thinklight
[    5.986231] Registered led device: tpacpi::power
[    5.986301] Registered led device: tpacpi::standby
[    5.989861] thinkpad_acpi: Standard ACPI backlight interface available, not loading native one.
[    5.990298] input: ThinkPad Extra Buttons as /class/input/input5
[    6.000923] usb 1-6: New USB device found, idVendor=17ef, idProduct=1004
[    6.000983] usb 1-6: New USB device strings: Mfr=2, Product=1, SerialNumber=3
[    6.001062] usb 1-6: Product: Integrated Camera
[    6.001118] usb 1-6: Manufacturer: Chicony Electronics Co., Ltd.
[    6.001182] usb 1-6: SerialNumber: SN0001
[    6.001333] usb 1-6: configuration #1 chosen from 1 choice
[    6.007206] input: HDA Intel Headphone as /class/input/input6
[    6.013051] calling  iwl_init+0x0/0x7b [iwlagn] @ 3026
[    6.013113] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27ks
[    6.013185] iwlagn: Copyright(c) 2003-2009 Intel Corporation
[    6.013338] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    6.013429] iwlagn 0000:03:00.0: setting latency timer to 64
[    6.013598] iwlagn 0000:03:00.0: Detected Intel Wireless WiFi Link 5350AGN REV=0x24
[    6.032758] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[    6.032912] iwlagn 0000:03:00.0: irq 30 for MSI/MSI-X
[    6.033425] phy0: Selected rate control algorithm 'iwl-agn-rs'
[    6.034504] phy0: Failed to initialize wep: -2
[    6.041108] initcall thinkpad_acpi_module_init+0x0/0x9bc [thinkpad_acpi] returned 0 after 66609 usecs
[    6.056138] input: HDA Intel Mic as /class/input/input7
[    6.065142] iwlagn 0000:03:00.0: Failed to register hw (error -2)
[    6.065283] iwlagn 0000:03:00.0: PCI INT A disabled
[    6.065345] iwlagn: probe of 0000:03:00.0 failed with error -2
[    6.065430] initcall iwl_init+0x0/0x7b [iwlagn] returned 0 after 51086 usecs
[    6.072139] input: HDA Intel Mic as /class/input/input8
[    6.088115] input: HDA Intel Headphone as /class/input/input9
[    6.098088] calling  videodev_init+0x0/0x89 [videodev] @ 3468
[    6.098147] Linux video capture interface: v2.00
[    6.098217] initcall videodev_init+0x0/0x89 [videodev] returned 0 after 66 usecs
[    6.104281] initcall alsa_card_azx_init+0x0/0x20 [snd_hda_intel] returned 0 after 230449 usecs
[    6.131474] calling  crypto_ecb_module_init+0x0/0x12 [ecb] @ 3481
[    6.131538] initcall crypto_ecb_module_init+0x0/0x12 [ecb] returned 0 after 1 usecs
[    6.154788] calling  uvc_init+0x0/0xa3 [uvcvideo] @ 3468
[    6.154898] uvcvideo: Found UVC 1.00 device Integrated Camera (17ef:1004)
[    6.159852] input: Integrated Camera as /class/input/input10
[    6.193094] usbcore: registered new interface driver uvcvideo
[    6.193159] USB Video Class driver (v0.1.0)
[    6.193219] initcall uvc_init+0x0/0xa3 [uvcvideo] returned 0 after 37468 usecs
[    6.244068] usb 3-1: new low speed USB device using uhci_hcd and address 2
[    6.381337] Synaptics Touchpad, model: 1, fw: 7.0, id: 0x1c0b1, caps: 0xd04791/0xb00000
[    6.381419] serio: Synaptics pass-through port at isa0060/serio1/input0
[    6.417383] usb 3-1: New USB device found, idVendor=046d, idProduct=c404
[    6.417443] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    6.417503] usb 3-1: Product: Trackball
[    6.417564] usb 3-1: Manufacturer: Logitech
[    6.417720] usb 3-1: configuration #1 chosen from 1 choice
[    6.425772] input: SynPS/2 Synaptics TouchPad as /class/input/input11
[    6.459311] calling  joydev_init+0x0/0x12 [joydev] @ 3553
[    6.459378] initcall joydev_init+0x0/0x12 [joydev] returned 0 after 3 usecs
[    6.475418] calling  hid_init+0x0/0x48 [hid] @ 3551
[    6.475503] initcall hid_init+0x0/0x48 [hid] returned 0 after 22 usecs
[    6.486006] calling  hid_init+0x0/0xd1 [usbhid] @ 3551
[    6.486146] usbcore: registered new interface driver hiddev
[    6.504628] input: Logitech Trackball as /class/input/input12
[    6.533113] generic-usb 0003:046D:C404.0001: input,hidraw0: USB HID v1.10 Mouse [Logitech Trackball] on usb-0000:00:1a.0-1/input0
[    6.533204] usbcore: registered new interface driver usbhid
[    6.533262] usbhid: v2.6:USB HID core driver
[    6.533322] initcall hid_init+0x0/0xd1 [usbhid] returned 0 after 46146 usecs
[   12.153353] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[   12.390740] input: TPPS/2 IBM TrackPoint as /class/input/input13


>
>
> Vegard


-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/

