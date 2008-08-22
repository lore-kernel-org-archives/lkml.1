Return-Path: <linux-kernel-owner+w=401wt.eu-S1756021AbYHVRU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021AbYHVRU7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 13:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754418AbYHVRUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 13:20:46 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:38838 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645AbYHVRUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 13:20:45 -0400
Date: Fri, 22 Aug 2008 14:20:54 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.{26.2,27-rc} oops on virtualbox
Message-ID: <20080822142054.403cbdef@doriath.conectiva>
In-Reply-To: <20080822163520.GA9860@Krystal>
References: <20080820162925.75a5e064@doriath.conectiva>
	<48ADDF4F.2020401@zytor.com>
	<48AE5FCF.6030103@zytor.com>
	<20080822065012.GV14110@elte.hu>
	<20080822113941.147a1db0@doriath.conectiva>
	<20080822153451.GA8390@Krystal>
	<20080822132948.57e47076@doriath.conectiva>
	<20080822163520.GA9860@Krystal>
Organization: Mandriva
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.7; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/1QuTG+.SlIrbrjqeqk68zz8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/1QuTG+.SlIrbrjqeqk68zz8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Em Fri, 22 Aug 2008 12:35:20 -0400
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> escreveu:

| * Luiz Fernando N. Capitulino (lcapitulino@mandriva.com.br) wrote:
| > Em Fri, 22 Aug 2008 11:34:52 -0400
| > Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> escreveu:
| > 
| > | * Luiz Fernando N. Capitulino (lcapitulino@mandriva.com.br) wrote:
| > | > Em Fri, 22 Aug 2008 08:50:12 +0200
| > | > Ingo Molnar <mingo@elte.hu> escreveu:
| > | > 
| > | > | 
| > | > | * H. Peter Anvin <hpa@zytor.com> wrote:
| > | > | 
| > | > | > H. Peter Anvin wrote:
| > | > | >>>
| > | > | >>>  Does this look like a kernel bug?
| > | > | >>>
| > | > | >>
| > | > | >> No, it looks like a very common virtualizer bug.  Does the attached  
| > | > | >> patch work for you?
| > | > | >>
| > | > | >
| > | > | > Also, in addition to this, please try tip:master.  There is a patch in 
| > | > | > tip:master which I hope should fix this problem, but the details are 
| > | > | > important.
| > | > | 
| > | > | access coordinates would be at:
| > | > | 
| > | > |   http://people.redhat.com/mingo/tip.git/README
| > | > 
| > | >  As I already have Linus tree downloaded I have cloned it in
| > | > the usual way.
| > | > 
| > | >  Got the same results: OOPS in virtualbox but it works on QEMU.
| > | > 
| > | >  The OOPS's output follows and I have attached the .config I'm using
| > | > to reproduce the problem.
| > | > 
| > | 
| > | Can you try booting with the kernel argument :
| > |   debug_alternative 
| > | 
| > | The dmesg of the kernel bootup up to the oops would be helpful.
| > | 
| > | My guess is that there may be something wrong with irq disabling which
| > | protects text_poke_early in apply_alternatives().
| > 
| >  I have attached two files:
| > 
| >   - normal.txt: normal boot with no debug options
| >   - debug-alternative.txt ignore_loglevel and debug-alternative boot
| >     options
| > 
| >  I had to pass ignore_loglevel otherwise it wouldn't print
| > anything.
| > 
| 
| Ok, now can you try booting with either of those args :
| 
| noreplace-paravirt
| noreplace-smp
| 
| And see which one(s) works ?

 noreplace-paravirt works, the other one causes no change.

 You will find the full boot log (with debug-alternative enabled)
attached.

-- 
Luiz Fernando N. Capitulino

--MP_/1QuTG+.SlIrbrjqeqk68zz8
Content-Type: text/plain; name=working.txt
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=working.txt

Linux version 2.6.27-rc4-test25 (lcapitulino@build1.conectiva) (gcc version 4.3.1 20080626 (prerelease) (GCC) ) #89 SMP Fri Aug 22 12:47:34 BRT 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000007ff0000 (usable)
 BIOS-e820: 0000000007ff0000 - 0000000008000000 (ACPI data)
 BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
debug: ignoring loglevel setting.
last_pfn = 0x7ff0 max_arch_pfn = 0x100000
kernel direct mapping tables up to 7ff0000 @ 7000-d000
RAMDISK: 07b9b000 - 07fbf89d
DMI 2.5 present.
ACPI: RSDP 000E0000, 0024 (r2 VBOX  )
ACPI: XSDT 07FF0030, 002C (r1 VBOX   VBOXXSDT        1 ASL        61)
ACPI: FACP 07FF0060, 00F4 (r4 VBOX   VBOXFACP        1 ASL        61)
ACPI: DSDT 07FF01A0, 1064 (r1 VBOX   VBOXBIOS        2 INTL 20080213)
ACPI: FACS 07FF0160, 0040
0MB HIGHMEM available.
127MB LOWMEM available.
  mapped low ram: 0 - 07ff0000
  low ram: 00000000 - 07ff0000
  bootmap 00002000 - 00003000
(9 early reservations) ==> bootmem [0000000000 - 0007ff0000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
  #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
  #3 [0000100000 - 0000814b10]    TEXT DATA BSS ==> [0000100000 - 0000814b10]
  #4 [0007b9b000 - 0007fbf89d]          RAMDISK ==> [0007b9b000 - 0007fbf89d]
  #5 [0000815000 - 0000819000]    INIT_PG_TABLE ==> [0000815000 - 0000819000]
  #6 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #7 [0000007000 - 0000009000]          PGTABLE ==> [0000007000 - 0000009000]
  #8 [0000002000 - 0000003000]          BOOTMAP ==> [0000002000 - 0000003000]
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  Normal   0x00001000 -> 0x00007ff0
  HighMem  0x00007ff0 -> 0x00007ff0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x00007ff0
On node 0 totalpages: 32655
free_area_init_node: node 0, pgdat c041f600, node_mem_map c1000000
  DMA zone: 3947 pages, LIFO batch:0
  Normal zone: 28292 pages, LIFO batch:7
ACPI: PM-Timer IO Port: 0x4008
SMP: Allowing 1 CPUs, 0 hotplug CPUs
Found and enabled local APIC!
mapped APIC to ffffb000 (fee00000)
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
Allocating PCI resources starting at 10000000 (gap: 8000000:f7fc0000)
PERCPU: Allocating 40224 bytes of per cpu data
NR_CPUS: 32, nr_cpu_ids: 1, nr_node_ids 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 32239
Kernel command line: initrd=alt0/all.rdz vga=788 splash=silent BOOT_IMAGE=alt0/vmlinuz vga=0 console=ttyS0,9600 console=tty ignore_loglevel debug-alternative noreplace-paravirt
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 512 (order: 9, 2048 bytes)
TSC calibrated against PM_TIMER
Detected 2410.580 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:    8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:           4096
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 2335 kB
 per task-struct memory footprint: 1152 bytes
Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
Memory: 117088k/131008k available (2340k kernel code, 13364k reserved, 1027k data, 308k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xffe18000 - 0xfffff000   (1948 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xc8800000 - 0xff7fe000   ( 879 MB)
    lowmem  : 0xc0000000 - 0xc7ff0000   ( 127 MB)
      .init : 0xc0451000 - 0xc049e000   ( 308 kB)
      .data : 0xc03493b8 - 0xc044a040   (1027 kB)
      .text : 0xc0100000 - 0xc03493b8   (2340 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=12, HWalign=128, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
Calibrating delay loop (skipped), value calculated using timer frequency.. 4821.16 BogoMIPS (lpj=2410580)
Security Framework initialized
Mount-cache hash table entries: 512
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Checking 'hlt' instruction... OK.
apply_alternatives: alt table c048afa4 -> c048f11f
SMP alternatives: switching to UP code
Freeing SMP alternatives: 10k freed
ACPI: Core revision 20080609
ACPI: setting ELCR to 0200 (from 0c00)
weird, boot CPU (#0) not listedby the BIOS.
SMP motherboard not detected.
SMP disabled
Brought up 1 CPUs
Total of 1 processors activated (4821.16 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 0 level CPU
  groups: 0
khelper used greatest stack depth: 6824 bytes left
net_namespace: 384 bytes
Booting paravirtualized kernel on bare hardware
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfadb0, last bus=0
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 5 9 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 5 9 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 5 9 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 5 9 *10 11)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 6 devices
ACPI: ACPI bus type pnp unregistered
PnPBIOS: Disabled by ACPI PNP
PCI: Using ACPI for IRQ routing
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [0, ffffffffffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
TCP established hash table entries: 4096 (order: 3, 32768 bytes)
TCP bind hash table entries: 4096 (order: 5, 131072 bytes)
TCP: Hash tables configured (established 4096 bind 4096)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs...<7>Switched to high resolution mode on CPU 0
 it is
Freeing initrd memory: 4242k freed
khelper used greatest stack depth: 6640 bytes left
apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
apm: overridden by ACPI.
audit: initializing netlink socket (disabled)
type=2000 audit(1219414726.056:1): initialized
HugeTLB registered 4 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
msgmni has been set to 237
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:00.0: Limiting direct PCI/PCI transfers
pci 0000:00:01.0: Activating ISA DMA hang workarounds
pci 0000:00:02.0: Boot video device
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16450
brd: module loaded
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
cpuidle: using governor ladder
cpuidle: using governor menu
input: ImExPS/2 Generic Explorer Mouse as /class/input/input1
TCP cubic registered
Using IPI No-Shortcut mode
registered taskstats version 1
Freeing unused kernel memory: 308k freed

--MP_/1QuTG+.SlIrbrjqeqk68zz8--
