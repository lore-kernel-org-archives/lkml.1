Return-Path: <linux-kernel-owner+w=401wt.eu-S1763225AbXERTRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763225AbXERTRA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 15:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755219AbXERTQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 15:16:53 -0400
Received: from ik-out-1112.google.com ([66.249.90.178]:52732 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbXERTQu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 15:16:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=mt6EVomv1viuGOSOcuUw5hC8yJg4razT4ICSgM2c+P08Cr6C1lyFYOelGlXUDiRaR5CKHCJRqbh2hksU5u1gegnN8Q5AbzB8iz1F6ngmJjHYzmNcNxNan6ObZZg8mOpiUb7nkDu9TgVw83b2Yh4ihkGJ487yu+fEs+sXEl4bGcM=
Date: Fri, 18 May 2007 21:16:45 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.21-mm1 and now 2.6.21-git: SLUB Crashes on boot - crypto?
Message-ID: <20070518191645.GA10815@dreamland.darkstar.lan>
References: <d1af83620705100410n482f4f9h428b7cab5501d963@mail.gmail.com> <20070514173823.GA7137@dreamland.darkstar.lan> <20070515014344.GA8850@gondor.apana.org.au> <20070515185212.GA18783@dreamland.darkstar.lan> <20070518031931.GA13048@gondor.apana.org.au> <68676e00705180509s64b737e2k37c5b2e713c96932@mail.gmail.com> <20070518131455.GA20918@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20070518131455.GA20918@gondor.apana.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Il Fri, May 18, 2007 at 11:14:55PM +1000, Herbert Xu ha scritto: 
> On Fri, May 18, 2007 at 02:09:54PM +0200, Luca wrote:
> > 
> > Well, pretty sure. The OOPS says 2.6.22-rc1-libata-g705962cc-dirty,
> > git agrees and I've done a full rebuild. The .config is generated
> > using 'make oldconfig' using the 2.6.21 as baseline, maybe ALGAPI is
> > coming from there?
> 
> Sorry, my mistake.  That bug only happens if you have padlock turned on.
> 
> Anyway, if possible could you post the complete dmesg when it crashes?
> I'd like to see what has happened up to the point where it crashes.

Output from serial console is enlightening (sort of...):

Loading IPsec SA/SP database from /etc/ipsec-tools.conf: BUG: unable to
handle kernel paging request at virtual address 6b6b6ceb printing eip:
b0141aef
[oops]

Problem is that:
- /etc/ipsec-tools.conf is empty (everything is commented out), it's
  a leftover of previous experiments.
- AH and ESP are disabled in the kernel since I don't use them anymore.

Removing setkey script from init.d makes the OOPS disappear though;
nothing happens if I manually run setkey after the boot...

This is the full log:

Linux version 2.6.22-rc1-libata-g705962cc-dirty (kronos@dreamland.darkstar.lan) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #63 SMP PREEMPT Thu May 17 00:22:29 CEST 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009c800 (usable)
 BIOS-e820: 000000000009c800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003ff90000 (usable)
 BIOS-e820: 000000003ff90000 - 000000003ff9e000 (ACPI data)
 BIOS-e820: 000000003ff9e000 - 000000003ffe0000 (ACPI NVS)
 BIOS-e820: 000000003ffe0000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
1023MB LOWMEM available.
found SMP MP-table at 000ff780
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   262032
early_node_map[1] active PFN ranges
    0:        0 ->   262032
DMI 2.4 present.
ACPI: RSDP 000FA980, 0024 (r2 ACPIAM)
ACPI: XSDT 3FF90100, 0054 (r1 KOZIRO FRONTIER 12000611 MSFT       97)
ACPI: FACP 3FF90290, 00F4 (r3 MSTEST OEMFACP  12000611 MSFT       97)
ACPI: DSDT 3FF905C0, 8F8C (r1  A0637 A0637000        0 INTL 20060113)
ACPI: FACS 3FF9E000, 0040
ACPI: APIC 3FF90390, 006C (r1 MSTEST OEMAPIC  12000611 MSFT       97)
ACPI: MCFG 3FF90400, 003C (r1 MSTEST OEMMCFG  12000611 MSFT       97)
ACPI: SLIC 3FF90440, 0176 (r1 KOZIRO FRONTIER 12000611 MSFT       97)
ACPI: OEMB 3FF9E040, 007B (r1 MSTEST AMI_OEM  12000611 MSFT       97)
ACPI: HPET 3FF99550, 0038 (r1 MSTEST OEMHPET  12000611 MSFT       97)
ACPI: PM-Timer IO Port: 0x808
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 6:15 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1 6:15 APIC version 20
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Enabling APIC mode:  Flat.  Using 1 I/O APICs
ACPI: HPET id: 0x8086a202 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 50000000 (gap: 40000000:bee00000)
Built 1 zonelists.  Total pages: 259985
Kernel command line: BOOT_IMAGE=linux-2.6.22r1 ro video=radeonfb:1024x768-8@60 lapic apic=verbose root=/dev/mapper/mainVol-root console=tty0 console=ttyS0,57600n8
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=b042e000 soft=b042c000
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 2135.141 MHz processor.
Console: colour VGA+ 80x25
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:    8
... MAX_LOCK_DEPTH:          30
... MAX_LOCKDEP_KEYS:        2048
... CLASSHASH_SIZE:           1024
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 992 kB
 per task-struct memory footprint: 1200 bytes
------------------------
| Locking API testsuite:
----------------------------------------------------------------------------
                                 | spin |wlock |rlock |mutex | wsem | rsem |
  --------------------------------------------------------------------------
                     A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                 A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
             A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
             A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
         A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
         A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
         A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                    double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                  initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
                 bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
  --------------------------------------------------------------------------
              recursive read-lock:             |  ok  |             |  ok  |
           recursive read-lock #2:             |  ok  |             |  ok  |
            mixed read-write-lock:             |  ok  |             |  ok  |
            mixed write-read-lock:             |  ok  |             |  ok  |
  --------------------------------------------------------------------------
     hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
     soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
     hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
     soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
       sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
       sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
         hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
         soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
         hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
         soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
    hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
    soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
      hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
      soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
      hard-irq read-recursion/123:  ok  |
      soft-irq read-recursion/123:  ok  |
      hard-irq read-recursion/132:  ok  |
      soft-irq read-recursion/132:  ok  |
      hard-irq read-recursion/213:  ok  |
      soft-irq read-recursion/213:  ok  |
      hard-irq read-recursion/231:  ok  |
      soft-irq read-recursion/231:  ok  |
      hard-irq read-recursion/312:  ok  |
      soft-irq read-recursion/312:  ok  |
      hard-irq read-recursion/321:  ok  |
      soft-irq read-recursion/321:  ok  |
-------------------------------------------------------
Good, all 218 testcases passed! |
---------------------------------
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1029676k/1048128k available (2016k kernel code, 17880k reserved, 981k data, 212k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffb7000 - 0xfffff000   ( 288 kB)
    vmalloc : 0xf0800000 - 0xfffb5000   ( 247 MB)
    lowmem  : 0xb0000000 - 0xeff90000   (1023 MB)
      .init : 0xb03f2000 - 0xb0427000   ( 212 kB)
      .data : 0xb02f8234 - 0xb03ed894   ( 981 kB)
      .text : 0xb0100000 - 0xb02f8234   (2016 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
Calibrating delay using timer specific routine.. 4273.69 BogoMIPS (lpj=8547386)
Mount-cache hash table entries: 512
monitor/mwait feature present.
using mwait in idle threads.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
lockdep: not fixing up alternatives.
ACPI: Core revision 20070126
Parsing all Control Methods:
Table [DSDT](id 0001) - 1008 Objects with 75 Devices 286 Methods 36 Regions
 tbxface-0587 [02] tb_load_namespace     : ACPI Tables successfully acquired
evxfevnt-0091 [02] enable                : Transition to ACPI mode successful
CPU0: Intel(R) Core(TM)2 CPU          6400  @ 2.13GHz stepping 06
enabled ExtINT on CPU#0
lockdep: not fixing up alternatives.
Booting processor 1/1 eip 3000
CPU 1 irqstacks, hard=b042f000 soft=b042d000
Initializing CPU#1
masked ExtINT on CPU#1
Calibrating delay using timer specific routine.. 4270.07 BogoMIPS (lpj=8540143)
monitor/mwait feature present.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel(R) Core(TM)2 CPU          6400  @ 2.13GHz stepping 06
Total of 2 processors activated (8543.76 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
Using local APIC timer interrupts.
calibrating APIC timer ...
... lapic delta = 1667977
... PM timer delta = 357950
... PM timer result ok
..... delta 1667977
..... mult: 71634589
..... calibration result: 1067505
..... CPU clock speed is 2135.0049 MHz.
..... host bus clock speed is 266.3505 MHz.
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
migration_cost=36
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
PCI: Not using MMCONFIG.
PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=5
PCI: Using configuration type 1
Setting up standard PCI resources
evgpeblk-0952 [04] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4 regs on int 0x9
evgpeblk-1048 [03] ev_initialize_gpe_bloc: Found 11 Wake, Enabled 2 Runtime GPEs in this block
Completing Region/Field/Buffer/Package initialization:.....................................................................................................................................................................................................................................
Initialized 35/36 Regions 44/44 Fields 51/51 Buffers 99/100 Packages (1017 nodes)
Initializing Device/Processor/Thermal objects by executing _INI methods:.
Executed 1 _INI methods requiring 1 _STA executions (examined 81 objects)
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
PCI quirk: region 0480-04bf claimed by ICH6 GPIO
PCI: Firmware left 0000:05:01.0 e100 interrupts enabled, disabling
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11 12 14 *15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 *14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 17 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
testing the IO APIC.......................
.................................... done.
ACPI: RTC can wake from S4
pnp: 00:01: iomem range 0xfed14000-0xfed19fff has been reserved
pnp: 00:08: ioport range 0x290-0x297 has been reserved
pnp: 00:09: iomem range 0xffafe000-0xffb0cbff could not be reserved
pnp: 00:09: iomem range 0xffb00000-0xffbfffff could not be reserved
pnp: 00:09: iomem range 0xfed1c000-0xfed1ffff has been reserved
pnp: 00:09: iomem range 0xfed20000-0xfed8ffff has been reserved
pnp: 00:0c: iomem range 0xfec00000-0xfec00fff has been reserved
pnp: 00:0c: iomem range 0xfee00000-0xfee00fff could not be reserved
pnp: 00:0f: iomem range 0xe0000000-0xefffffff has been reserved
pnp: 00:10: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:10: iomem range 0xc0000-0xcffff could not be reserved
pnp: 00:10: iomem range 0xe0000-0xfffff could not be reserved
pnp: 00:10: iomem range 0x100000-0x3fffffff could not be reserved
Time: tsc clocksource has been installed.
Switched to NOHz mode on CPU #1
Switched to NOHz mode on CPU #0
PCI: Bridge: 0000:00:01.0
  IO window: 7000-9fff
  MEM window: ff200000-ff2fffff
  PREFETCH window: bfd00000-dfcfffff
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: dfd00000-dfdfffff
PCI: Bridge: 0000:00:1c.3
  IO window: disabled.
  MEM window: ff400000-ff4fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.4
  IO window: a000-afff
  MEM window: ff300000-ff3fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
  IO window: b000-cfff
  MEM window: ff500000-ff9fffff
  PREFETCH window: dfe00000-dfefffff
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 17
ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 16 (level, low) -> IRQ 16
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 65536 (order: 9, 2621440 bytes)
TCP bind hash table entries: 65536 (order: 9, 2359296 bytes)
TCP: Hash tables configured (established 65536 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 2814k freed
Machine check exception polling timer started.
Total HugeTLB memory allocated, 0
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
assign_interrupt_mode Found MSI capability
assign_interrupt_mode Found MSI capability
assign_interrupt_mode Found MSI capability
assign_interrupt_mode Found MSI capability
radeonfb_pci_register BEGIN
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
radeonfb (0000:01:00.0): Found 131072k of DDR 256 bits wide videoram
radeonfb (0000:01:00.0): mapped 16384k videoram
radeonfb: Found Intel x86 BIOS ROM Image
Retrieved PLL infos from ATOM BIOS
radeonfb: Reference=27.00 MHz (RefDiv=12) Memory=540.00 Mhz, System=520.00 MHz
PLL min 20000 max 50000
TMDS PLL from BIOS: 16500 b011c
index 3 port 2 conn 2 dac -1 ddc 0 tmds 0
index 4 port 2 conn 2 dac 1 ddc 0 tmds -1
index 7 port 1 conn 2 dac -1 ddc 1 tmds 1
Starting monitor auto detection...
i2c-adapter i2c-1: unable to read EDID block.
i2c-adapter i2c-1: unable to read EDID block.
i2c-adapter i2c-1: unable to read EDID block.
radeonfb: I2C (port 1) ... not found
radeonfb: I2C (port 0) ... found CRT display
 * Connector 1 is DVI-I. Head -1, Monitor: None 
   ddc port: 1, dac: -1, tmds: 1
 * Connector 2 is DVI-I. Head 0, Monitor: CRT (EDID probed)
   ddc port: 0, dac: 1, tmds: 0
hStart = 1048, hEnd = 1184, hTotal = 1344
vStart = 771, vEnd = 777, vTotal = 806
h_total_disp = 0x7f00a7	   hsync_strt_wid = 0x910422
v_total_disp = 0x2ff0325	   vsync_strt_wid = 0x860302
pixclock = 15384
freq = 6500
freq = 6500, PLL min = 20000, PLL max = 50000
ref_div = 12, ref_clk = 2700, output_freq = 26000
ref_div = 12, ref_clk = 2700, output_freq = 26000
post div = 0x2
fb_div = 0x74
ppll_div_3 = 0x20074
Console: switching to colour frame buffer device 128x48
radeonfb (0000:01:00.0): ATI Radeon ]R 
radeonfb_pci_register END
ACPI Error (utglobal-0126): Unknown exception code: 0xFFFFFFF0 [20070126]
Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
Hangcheck: Using get_cycles().
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: module loaded
netconsole: not configured, aborting
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 17
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq ilck stag pm led clo pmp pio slum part 
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 cmd 0xf080c900 ctl 0x00000000 bmdma 0x00000000 irq 0
ata2: SATA max UDMA/133 cmd 0xf080c980 ctl 0x00000000 bmdma 0x00000000 irq 0
ata3: SATA max UDMA/133 cmd 0xf080ca00 ctl 0x00000000 bmdma 0x00000000 irq 0
ata4: SATA max UDMA/133 cmd 0xf080ca80 ctl 0x00000000 bmdma 0x00000000 irq 0
ata5: SATA max UDMA/133 cmd 0xf080cb00 ctl 0x00000000 bmdma 0x00000000 irq 0
ata6: SATA max UDMA/133 cmd 0xf080cb80 ctl 0x00000000 bmdma 0x00000000 irq 0
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ata_hpa_resize 1: sectors = 488397168, hpa_sectors = 488397168
ata1.00: ATA-7: ST3250820AS, 3.AAE, max UDMA/133
ata1.00: 488397168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata1.00: ata_hpa_resize 1: sectors = 488397168, hpa_sectors = 488397168
ata1.00: configured for UDMA/133
ata2: SATA link down (SStatus 0 SControl 300)
ata3: SATA link down (SStatus 0 SControl 300)
ata4: SATA link down (SStatus 0 SControl 300)
ata5: SATA link down (SStatus 0 SControl 300)
ata6: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      ST3250820AS      3.AA PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: [LDM] sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
ahci 0000:02:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
ahci 0000:02:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
scsi6 : ahci
scsi7 : ahci
ata7: SATA max UDMA/133 cmd 0xf081c100 ctl 0x00000000 bmdma 0x00000000 irq 0
ata8: SATA max UDMA/133 cmd 0xf081c180 ctl 0x00000000 bmdma 0x00000000 irq 0
ata7: SATA link down (SStatus 0 SControl 300)
ata8: SATA link down (SStatus 0 SControl 300)
PCI: Enabling device 0000:02:00.1 (0000 -> 0001)
ACPI: PCI Interrupt 0000:02:00.1[B] -> GSI 17 (level, low) -> IRQ 18
scsi8 : pata_jmicron
scsi9 : pata_jmicron
ata9: PATA max UDMA/100 cmd 0x0001ac00 ctl 0x0001a882 bmdma 0x0001a400 irq 0
ata10: PATA max UDMA/100 cmd 0x0001a800 ctl 0x0001a482 bmdma 0x0001a408 irq 0
ata9.00: ATAPI, max UDMA/33
ata9.01: ATAPI, max UDMA/33
ata9.00: configured for UDMA/33
ata9.01: configured for UDMA/33
ATA: abnormal status 0x7F on port 0x0001a807
scsi 8:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-4167B DL13 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 78x/78x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 8:0:0:0: Attached scsi generic sg1 type 5
scsi 8:0:1:0: CD-ROM            WAITEC   ALADAR/1         B1.5 PQ: 0 ANSI: 5
sr1: scsi3-mmc drive: 16x/40x writer cd/rw xa/form2 cdda tray
sr 8:0:1:0: Attached scsi generic sg2 type 5
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 15
Using IPI No-Shortcut mode
Freeing unused kernel memory: 212k freed
Write protecting the kernel read-only data: 778k
Loading, please wait...
Begin: Loading essential drivers... ...
SGI XFS with ACLs, large block numbers, no debug enabled
sata_uli 0000:05:02.0: version 1.1
ACPI: PCI Interrupt 0000:05:02.0[A] -> GSI 23 (level, low) -> IRQ 19
scsi10 : sata_uli
scsi11 : sata_uli
ata11: SATA max UDMA/133 cmd 0x0001c000 ctl 0x0001bc02 bmdma 0x0001b480 irq 0
ata12: SATA max UDMA/133 cmd 0x0001b880 ctl 0x0001b802 bmdma 0x0001b488 irq 0
ata11: SATA link down (SStatus 0 SControl 310)
input: ImPS/2 Generic Wheel Mouse as /class/input/input1
ata12: SATA link down (SStatus 0 SControl 310)
ACPI: PCI Interrupt 0000:05:02.1[A] -> GSI 23 (level, low) -> IRQ 19
scsi12 : pata_ali
scsi13 : pata_ali
ata13: PATA max UDMA/133 cmd 0x0001c880 ctl 0x0001c802 bmdma 0x0001c080 irq 0
ata14: PATA max UDMA/133 cmd 0x0001c480 ctl 0x0001c402 bmdma 0x0001c088 irq 0
ata13: device not ready (errno=-19), forcing hardreset
ata13: BUG: prereset() requested invalid reset type
ata14.00: ata_hpa_resize 1: sectors = 240121728, hpa_sectors = 240121728
ata14.00: ATA-7: Maxtor 6Y120L0, YAR41VW0, max UDMA/133
ata14.00: 240121728 sectors, multi 16: LBA 
ata14.01: ata_hpa_resize 1: sectors = 20044080, hpa_sectors = 20044080
ata14.01: ATA-4: QUANTUM FIREBALLlct10 10, A03.0900, max UDMA/66
ata14.01: 20044080 sectors, multi 16: LBA 
ata14.01: limited to UDMA/33 due to 40-wire cable
ata14.00: ata_hpa_resize 1: sectors = 240121728, hpa_sectors = 240121728
ata14.00: configured for UDMA/133
ata14.01: ata_hpa_resize 1: sectors = 20044080, hpa_sectors = 20044080
ata14.01: configured for UDMA/33
scsi 13:0:0:0: Direct-Access     ATA      Maxtor 6Y120L0   YAR4 PQ: 0 ANSI: 5
sd 13:0:0:0: [sdb] 240121728 512-byte hardware sectors (122942 MB)
sd 13:0:0:0: [sdb] Write Protect is off
sd 13:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 13:0:0:0: [sdb] 240121728 512-byte hardware sectors (122942 MB)
sd 13:0:0:0: [sdb] Write Protect is off
sd 13:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2 sdb3
sd 13:0:0:0: [sdb] Attached SCSI disk
sd 13:0:0:0: Attached scsi generic sg3 type 0
scsi 13:0:1:0: Direct-Access     ATA      QUANTUM FIREBALL A03. PQ: 0 ANSI: 5
sd 13:0:1:0: [sdc] 20044080 512-byte hardware sectors (10263 MB)
sd 13:0:1:0: [sdc] Write Protect is off
sd 13:0:1:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 13:0:1:0: [sdc] 20044080 512-byte hardware sectors (10263 MB)
sd 13:0:1:0: [sdc] Write Protect is off
sd 13:0:1:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdc: sdc1 sdc2
sd 13:0:1:0: [sdc] Attached SCSI disk
sd 13:0:1:0: Attached scsi generic sg4 type 0
Done.
Begin: Running /scripts/init-premount ...
ACPI Warning (tbutils-0158): Incorrect checksum in table [OEMB] -  1F, should be 12 [20070126]
ACPI: SSDT 3FF9E0C0, 01C6 (r1    AMI   CPU1PM        1 INTL 20060113)
Parsing all Control Methods:
Table [SSDT](id 0052) - 9 Objects with 0 Devices 3 Methods 0 Regions
ACPI: SSDT 3FF9E290, 013A (r1    AMI   CPU2PM        1 INTL 20060113)
Parsing all Control Methods:
Table [SSDT](id 0055) - 7 Objects with 0 Devices 4 Methods 0 Regions
ACPI Exception (processor_core-0781): AE_NOT_FOUND, Processor Device is not present [20070126]
ACPI Exception (processor_core-0781): AE_NOT_FOUND, Processor Device is not present [20070126]
Done.
Begin: Mounting root file system... ...
Begin: Running /scripts/local-top ...
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
  4 logical volume(s) in volume group "mainVol" now active
Done.
Begin: Running /scripts/local-premount ...
resume: libgcrypt version: 1.2.3
resume: Could not read the image
Done.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with journal data mode.
Begin: Running /scripts/local-bottom ...
Done.
Done.
Begin: Running /scripts/init-bottom ...
Done.
INIT: version 2.86 booting
Setting hostname to 'dreamland.darkstar.lan'...done.
Files under mount point '/lib/init/rw' will be hidden.
Starting the hotplug events dispatcher: udevd.
Synthesizing the initial hotplug events...done.
Waiting for /dev to be fully populated...usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 19 (level, low) -> IRQ 17
Linux agpgart interface v0.102 (c) Dave Jones
PCI: Setting latency timer of device 0000:03:00.0 to 64
agpgart: Detected an Intel 965G Chipset.
agpgart: AGP aperture is 256M @ 0x0
atl1 0000:03:00.0: version 2.0.7
parport_pc 00:0b: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
USB Universal Host Controller Interface driver v3.0
e100: Intel(R) PRO/100 Network Driver, 3.5.17-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
PCI: Enabling device 0000:00:1f.3 (0001 -> 0003)
ACPI: PCI Interrupt 0000:00:1f.3[C] -> GSI 18 (level, low) -> IRQ 20
ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1a.0 to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000e000
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 17 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1a.1 to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1a.1: irq 18, io base 0x0000e080
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.0: irq 19, io base 0x0000d800
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.1: irq 17, io base 0x0000d880
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.2: irq 20, io base 0x0000dc00
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1a.7 to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 6
ehci_hcd 0000:00:1a.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1a.7
ehci_hcd 0000:00:1a.7: irq 20, io mem 0xffaff400
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 4 ports detected
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 7
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 19, io mem 0xffaff000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 6 ports detected
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1b.0 to 64
ACPI: PCI Interrupt 0000:05:03.0[A] -> GSI 21 (level, low) -> IRQ 22
ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[22]  MMIO=[ff7ef800-ff7effff]  Max Packet=[2048]  IR/IT contexts=[4/8]
ACPI: PCI Interrupt 0000:05:01.0[A] -> GSI 22 (level, low) -> IRQ 21
e100: eth0: e100_probe: addr 0xdfeff000, irq 21, MAC addr 00:50:8B:5C:21:8B
done.
Setting parameters of disc:  /dev/sda failed!
Activating swap:swapon on /dev/sAdding 787176k swap on /dev/sdc2.  Priority:9 extents:1 across:787176k
dc2
.
Will now check root file system:fsck 1.40-WIP (14-Nov-2006)
Setting the system clock..
System Clock set. Local time: Fri May 18 19:20:26 CEST 2007.
Cleaning up ifupdown....
Loading kernel module ipv6.
NET: Registered protocol family 10
Loading kernel module i2c-isa.
Loading kernel module acpi-cpufreq.
processor_perflib-0519 [00] processor_get_psd     : Invalid _PSD data
processor_perflib-0519 [00] processor_get_psd     : Invalid _PSD data
Loading kernel module cpufreq_ondemand.
Loading device-mapper support.
Loading device-mapper support.
Setting up LVM Volume Groups...
  Reading all physical volumes.  This may take a while...
  Found volume group "storage" using metadata type lvm2
  Found volume group "mainVol" using metadata type lvm2
  1 logical volume(s) in volume group "storage" now active
  4 logical volume(s) in volume group "mainVol" now active
Will now check all file systems.
fsck 1.40-WIP (14-Nov-2006)
Checking all file systems.
[/sbin/fsck.ext3 (1) -- /usr] fsck.ext3 -a -C0 /dev/mainVol/usr 
usr: clean, 177358/4587520 files, 8695364/9175040 blocks (check in 2 mounts)
[/sbin/fsck.ext3 (1) -- /home] fsck.ext3 -a -C0 /dev/mainVol/home 
home: clean, 313656/8945664 files, 17534356/17886208 blocks (check in 3 mounts)
[/sbin/fsck.ext3 (1) -- /var] fsck.ext3 -a -C0 /dev/mainVol/var 
var: clean, 101247/1310720 files, 1595929/2621440 blocks
[/sbin/fsck.xfs (1) -- /mnt/media] fsck.xfs -a /dev/storage/media 
/sbin/fsck.xfs: XFS file system.
Done checking file systems. 
A log is being saved in /var/log/fsck/checkfs if that location is writable.
Setting kernel variables...done.
Starting filesystem in userspace: fusefuse init (API version 7.8)
.
Will now mount local filesystems:mount: special device /dev/hdd1 does not exist
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Filesystem "dm-4": Disabling barriers, not supported by the underlying device
XFS mounting filesystem dm-4
Ending clean XFS mount for filesystem: dm-4
 [31mfailed![39;49m
Will now activate swapfile swap:done.
Discovering hardware: e100 ohci1394
Skipping Module e100. It's already loaded.
Skipping Module ohci1394. It's already loaded.
Cleaning /tmp...done.
Cleaning /var/run...done.
Cleaning /var/lock...done.
Loading IPsec SA/SP database from /etc/ipsec-tools.conf: BUG: unable to handle kernel paging request at virtual address 6b6b6ceb
 printing eip:
b0141aef
*pde = 00000000
Oops: 0002 [#1]
PREEMPT SMP 
Modules linked in: sha1 md5 hmac crypto_hash cryptomgr crypto_algapi nfsd exportfs lockd sunrpc vfat fat nls_base fuse cpufreq_ondemand acpi_cpufreq freq_table i2c_isa ipv6 snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm ohci1394 e100 ieee1394 snd_timer ehci_hcd uhci_hcd parport_pc parport i2c_i801 intel_agp agpgart atl1 mii usbcore snd soundcore snd_page_alloc dm_snapshot dm_mod thermal processor fan pata_ali sata_uli reiserfs xfs
CPU:    0
EIP:    0060:[<b0141aef>]    Not tainted VLI
EFLAGS: 00010256   (2.6.22-rc1-libata-g705962cc-dirty #63)
EIP is at module_put+0x1c/0x57
eax: 00000000   ebx: 6b6b6b6b   ecx: 00000001   edx: e8c2d000
esi: 00000000   edi: e93c0920   ebp: 00000000   esp: e8c2dfa8
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process cryptomgr (pid: 4575, ti=e8c2d000 task=efd24070 task.ti=e8c2d000)
Stack: e93c0920 00000000 e93c0920 f19ac235 00000282 e8aa2bc0 00000000 e93c0920 
       f19ac1b3 00000000 00000000 b0131351 0000007b b0131316 00000000 b0104b3b 
       e8aa2bb4 00000000 00000000 00000000 00000000 00000000 
Call Trace:
 [<f19ac235>] cryptomgr_probe+0x82/0x99 [cryptomgr]
 [<f19ac1b3>] cryptomgr_probe+0x0/0x99 [cryptomgr]
 [<b0131351>] kthread+0x3b/0x62
 [<b0131316>] kthread+0x0/0x62
 [<b0104b3b>] kernel_thread_helper+0x7/0x10
 =======================
Code: e8 fa 70 08 00 83 c4 0c 89 d8 5b 5e 5f 5d c3 53 89 c3 83 ec 08 85 c0 74 49 b8 01 00 00 00 e8 ba a4 fd ff e8 34 70 09 00 c1 e0 07 <ff> 8c 18 80 01 00 00 83 3b 02 75 0b 8b 83 88 02 00 00 e8 18 9e 
EIP: [<b0141aef>] module_put+0x1c/0x57 SS:ESP 0068:e8c2dfa8
note: cryptomgr[4575] exited with preempt_count 1
BUG: unable to handle kernel paging request at virtual address 6b6b6d6b
 printing eip:
b0141aef
*pde = 00000000
Oops: 0002 [#2]
PREEMPT SMP 
Modules linked in: des cbc blkcipher sha1 md5 hmac crypto_hash cryptomgr crypto_algapi nfsd exportfs lockd sunrpc vfat fat nls_base fuse cpufreq_ondemand acpi_cpufreq freq_table i2c_isa ipv6 snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm ohci1394 e100 ieee1394 snd_timer ehci_hcd uhci_hcd parport_pc parport i2c_i801 intel_agp agpgart atl1 mii usbcore snd soundcore snd_page_alloc dm_snapshot dm_mod thermal processor fan pata_ali sata_uli reiserfs xfs
CPU:    1
EIP:    0060:[<b0141aef>]    Not tainted VLI
EFLAGS: 00010212   (2.6.22-rc1-libata-g705962cc-dirty #63)
EIP is at module_put+0x1c/0x57
eax: 00000080   ebx: 6b6b6b6b   ecx: 00000001   edx: ee7c4000
esi: f1b3fb60   edi: ee600e98   ebp: fffffffe   esp: ee7c4fa8
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process cryptomgr (pid: 4614, ti=ee7c4000 task=ee22eaf0 task.ti=ee7c4000)
Stack: fffffffe f1b3fb60 fffffffe f19ac235 00000282 e8aa2bc0 00000000 ee600e98 
       f19ac1b3 00000000 00000000 b0131351 0000007b b0131316 00000000 b0104b3b 
       e8aa2bb4 00000000 00000000 00000000 00000000 00000000 
Call Trace:
 [<f19ac235>] cryptomgr_probe+0x82/0x99 [cryptomgr]
 [<f19ac1b3>] cryptomgr_probe+0x0/0x99 [cryptomgr]
 [<b0131351>] kthread+0x3b/0x62
 [<b0131316>] kthread+0x0/0x62
 [<b0104b3b>] kernel_thread_helper+0x7/0x10
 =======================
Code: e8 fa 70 08 00 83 c4 0c 89 d8 5b 5e 5f 5d c3 53 89 c3 83 ec 08 85 c0 74 49 b8 01 00 00 00 e8 ba a4 fd ff e8 34 70 09 00 c1 e0 07 <ff> 8c 18 80 01 00 00 83 3b 02 75 0b 8b 83 88 02 00 00 e8 18 9e 
EIP: [<b0141aef>] module_put+0x1c/0x57 SS:ESP 0068:ee7c4fa8
note: cryptomgr[4614] exited with preempt_count 1
BUG: unable to handle kernel paging request at virtual address 6b6b6d6b
 printing eip:
b0141aef
*pde = 00000000
Oops: 0002 [#3]
PREEMPT SMP 
Modules linked in: des cbc blkcipher sha1 md5 hmac crypto_hash cryptomgr crypto_algapi nfsd exportfs lockd sunrpc vfat fat nls_base fuse cpufreq_ondemand acpi_cpufreq freq_table i2c_isa ipv6 snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm ohci1394 e100 ieee1394 snd_timer ehci_hcd uhci_hcd parport_pc parport i2c_i801 intel_agp agpgart atl1 mii usbcore snd soundcore snd_page_alloc dm_snapshot dm_mod thermal processor fan pata_ali sata_uli reiserfs xfs
CPU:    1
EIP:    0060:[<b0141aef>]    Not tainted VLI
EFLAGS: 00010212   (2.6.22-rc1-libata-g705962cc-dirty #63)
EIP is at module_put+0x1c/0x57
eax: 00000080   ebx: 6b6b6b6b   ecx: 00000001   edx: e9187000
esi: f1b3fb60   edi: ee600808   ebp: fffffffe   esp: e9187fa8
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process cryptomgr (pid: 4637, ti=e9187000 task=edfd8070 task.ti=e9187000)
Stack: fffffffe f1b3fb60 fffffffe f19ac235 00000282 e8aa2bc0 00000000 ee600808 
       f19ac1b3 00000000 00000000 b0131351 0000007b b0131316 00000000 b0104b3b 
       e8aa2bb4 00000000 00000000 00000000 00000000 00000000 
Call Trace:
 [<f19ac235>] cryptomgr_probe+0x82/0x99 [cryptomgr]
 [<f19ac1b3>] cryptomgr_probe+0x0/0x99 [cryptomgr]
 [<b0131351>] kthread+0x3b/0x62
 [<b0131316>] kthread+0x0/0x62
 [<b0104b3b>] kernel_thread_helper+0x7/0x10
 =======================
Code: e8 fa 70 08 00 83 c4 0c 89 d8 5b 5e 5f 5d c3 53 89 c3 83 ec 08 85 c0 74 49 b8 01 00 00 00 e8 ba a4 fd ff e8 34 70 09 00 c1 e0 07 <ff> 8c 18 80 01 00 00 83 3b 02 75 0b 8b 83 88 02 00 00 e8 18 9e 
EIP: [<b0141aef>] module_put+0x1c/0x57 SS:ESP 0068:e9187fa8
note: cryptomgr[4637] exited with preempt_count 1
done.
Setting up resolvconf...done.
Setting up networking....
Configuring network interfaces...e100: eth0: e100_watchdog: link up, 100Mbps, full-duplex
CBQ: class 00010001 has bad quantum==0, repaired.
u32 classifier
    input device check on 
    Actions configured 
Reloading Squid configuration files.
done.
done.
Starting portmap daemon....
Setting sensors limits: done.
Setting console screen modes and fonts.
Setting up ALSA...done.
Initializing random number generator...done.
Setting up X server socket directory /tmp/.X11-unix....
Setting up ICE socket directory /tmp/.ICE-unix....
INIT: Entering runlevel: 2
Starting system log daemon....
Starting kernel log daemon....
Starting domain name service...: bind.
Starting portmap daemon...Already running..
Starting SpamAssassin Mail Filter Daemon: spamd.
Loading ACPI modules...Module already loaded: processor
Loaded module: button
Module already loaded: fan
Module already loaded: thermal
.
Starting Advanced Configuration and Power Interface daemon....
CPUFreq Utilities: Setting ondemand CPUFreq governor... CPU0  CPU1 done.
Starting Common Unix Printing System: cupsd.
Starting Dynamic DNS service update utility: ddclient.
Starting mouse interface server: gpm.
icecast2 daemon disabled - read /etc/default/icecast2.
Starting internet superserver: inetd.
Starting news server: done.
Starting SMP IRQ Balancer: irqbalance.
Exporting directories for NFS kernel daemon....
Starting NFS kernel daemon: nfsd mountd.
Starting internet superserver: inetdStarting Postfix Mail Transport Agent: postfix.
Starting radvd: radvd.
Starting Samba daemons: nmbd smbd.
[33m*[39;49m Not starting S.M.A.R.T. daemon smartd, disabled via /etc/default/smartmontools
Starting OpenBSD Secure Shell server: sshd.
Starting the system activity data collector: sadc.
Starting User-mode networking switch:  uml_switch.
Starting the Winbind daemon: winbind.
Starting NFS common utilities: statd idmapd.
Starting Squid HTTP proxy: squid.
Configuring kernel parameters... done
Starting anac(h)ronistic cron: anacron.
Starting deferred execution scheduler: atd.
Starting periodic command scheduler....
Enabling additional executable binary formats: binfmt-support.
Starting web server (apache2)....
Running local boot scripts (/etc/rc.local).

Luca
-- 
Sbagliare è umano, ma per incasinare davvero le cose serve un computer.
