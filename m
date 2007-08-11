Return-Path: <linux-kernel-owner+w=401wt.eu-S1755594AbXHKMjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594AbXHKMjr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 08:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbXHKMjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 08:39:37 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:48990 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbXHKMjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 08:39:35 -0400
Date: Sat, 11 Aug 2007 15:39:30 +0300 (EEST)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@kivilampi-30.cs.helsinki.fi
To: LKML <linux-kernel@vger.kernel.org>
Subject: v2.6.23-rc2 locks up during boot (without acpi=off)
Message-ID: <Pine.LNX.4.64.0708012131480.1479@kivilampi-30.cs.helsinki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that v2.6.23-rc1 locks up during boot, same thing happens now 
with the latest linus' tree (+net-2.6.24 and tcp-2.6 tree stuff on top 
of it; in -rc1 test they weren't though). The exact location of hang
varies a bit though. No OOPS, does not respond to sysrq or anything else 
besides reset. Last known bootable one is something like 2.6.22-rc4 
(I usually run 2.6.21.5 on this machine, haven't tried any 2.6.22 on
this after those rcs). Problem seems to start after this line:

Time: acpi_pm clocksource has been installed.

...the power led starts blinking (not periodic cycle but more or less 
varying on-off cycle, never seen that led blink before at all, didn't know 
that one can make it blink :-)) and the machine gets consideably slower 
too. Never have it been able to complete booting all they way up to login 
prompt before lock up.

Tried with acpi=off, boots just fine (dmesg comes from it). I can take 

-- 
 i.


$ cat /proc/cpuinfo 
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 6
model           : 4
model name      : AMD Athlon(tm) Processor
stepping        : 2
cpu MHz         : 996.672
cache size      : 256 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 mmx fxsr syscall mmxext 3dnowext 3dnow
bogomips        : 1996.30
clflush size    : 32

# lspci -vvv
00:00.0 Host bridge: VIA Technologies, Inc. VT8363/8365 [KT133/KM133] (rev 02)
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
	Latency: 0
	Region 0: Memory at d0000000 (32-bit, prefetchable) [size=64M]
	Capabilities: [a0] AGP version 2.0
		Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW- AGP3- Rate=x1,x2
		Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW- Rate=<none>
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:01.0 PCI bridge: VIA Technologies, Inc. VT8363/8365 [KT133/KM133 AGP] (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
	Latency: 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: fff00000-000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:07.0 ISA bridge: VIA Technologies, Inc. VT82C686 [Apollo Super South] (rev 22)
	Subsystem: VIA Technologies, Inc. VT82C686/A PCI to ISA Bridge
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping+ SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0

00:07.1 IDE interface: VIA Technologies, Inc. VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 10) (prog-if 8a [Master SecP PriP])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 32
	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [size=1]
	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [size=1]
	Region 4: I/O ports at c000 [size=16]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:07.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 10) (prog-if 00 [UHCI])
	Subsystem: VIA Technologies, Inc. (Wrong ID) USB Controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 32, Cache Line Size: 32 bytes
	Interrupt: pin D routed to IRQ 11
	Region 4: I/O ports at c400 [size=32]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:07.3 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 10) (prog-if 00 [UHCI])
	Subsystem: VIA Technologies, Inc. (Wrong ID) USB Controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 32, Cache Line Size: 32 bytes
	Interrupt: pin D routed to IRQ 11
	Region 4: I/O ports at c800 [size=32]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:07.4 Host bridge: VIA Technologies, Inc. VT82C686 [Apollo Super ACPI] (rev 30)
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin ? routed to IRQ 11
	Capabilities: [68] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:07.5 Multimedia audio controller: VIA Technologies, Inc. VT82C686 AC97 Audio Controller (rev 20)
	Subsystem: Analog Devices Unknown device 5348
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin C routed to IRQ 15
	Region 0: I/O ports at cc00 [size=256]
	Region 1: I/O ports at d000 [size=4]
	Region 2: I/O ports at d400 [size=4]
	Capabilities: [c0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:09.0 SCSI storage controller: LSI Logic / Symbios Logic 53c875 (rev 26)
	Subsystem: LSI Logic / Symbios Logic LSI53C876/E PCI to Dual Channel SCSI Controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 72 (4250ns min, 16000ns max), Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 11
	Region 0: I/O ports at d800 [size=256]
	Region 1: Memory at d9002000 (32-bit, non-prefetchable) [size=256]
	Region 2: Memory at d9001000 (32-bit, non-prefetchable) [size=4K]
	[virtual] Expansion ROM at 10000000 [disabled] [size=128K]
	Capabilities: [40] Power Management version 1
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:0a.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ (rev 10)
	Subsystem: Kingmax Technology Inc Unknown device 0203
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (8000ns min, 16000ns max)
	Interrupt: pin A routed to IRQ 10
	Region 0: I/O ports at dc00 [size=256]
	Region 1: Memory at d9000000 (32-bit, non-prefetchable) [size=256]
	[virtual] Expansion ROM at 10020000 [disabled] [size=128K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0-,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:0e.0 VGA compatible controller: 3Dfx Interactive, Inc. Voodoo 3 (rev 01) (prog-if 00 [VGA])
	Subsystem: 3Dfx Interactive, Inc. Voodoo3 2000 PCI
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR+
	Interrupt: pin A routed to IRQ 255
	Region 0: Memory at d4000000 (32-bit, non-prefetchable) [size=32M]
	Region 1: Memory at d6000000 (32-bit, prefetchable) [size=32M]
	Region 2: I/O ports at e000 [size=256]
	[virtual] Expansion ROM at 10040000 [disabled] [size=64K]
	Capabilities: [60] Power Management version 1
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

$ dmesg
Linux version 2.6.23-rc2-ga3c05142 (ijjarvin@kivilampi-30) (gcc version 4.1.1 20060525 (Red Hat 4.1.1-1)) #256 PREEMPT Sat Aug 11 11:52:27 EEST 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000000fff0000 (usable)
 BIOS-e820: 000000000fff0000 - 000000000fff3000 (ACPI NVS)
 BIOS-e820: 000000000fff3000 - 0000000010000000 (ACPI data)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
 limit_regions start: 0000000000000000 - 000000000009fc00 (usable)
 limit_regions start: 000000000009fc00 - 00000000000a0000 (reserved)
 limit_regions start: 00000000000f0000 - 0000000000100000 (reserved)
 limit_regions start: 0000000000100000 - 000000000fff0000 (usable)
 limit_regions start: 000000000fff0000 - 000000000fff3000 (ACPI NVS)
 limit_regions start: 000000000fff3000 - 0000000010000000 (ACPI data)
 limit_regions start: 00000000ffff0000 - 0000000100000000 (reserved)
 limit_regions endfor: 0000000000000000 - 000000000009fc00 (usable)
 limit_regions endfor: 000000000009fc00 - 00000000000a0000 (reserved)
 limit_regions endfor: 00000000000f0000 - 0000000000100000 (reserved)
 limit_regions endfor: 0000000000100000 - 0000000008000000 (usable)
user-defined physical RAM map:
 user: 0000000000000000 - 000000000009fc00 (usable)
 user: 000000000009fc00 - 00000000000a0000 (reserved)
 user: 00000000000f0000 - 0000000000100000 (reserved)
 user: 0000000000100000 - 0000000008000000 (usable)
128MB LOWMEM available.
Entering add_active_range(0, 0, 32768) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->    32768
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->    32768
On node 0 totalpages: 32768
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 224 pages used for memmap
  Normal zone: 28448 pages, LIFO batch:7
  Movable zone: 0 pages used for memmap
DMI 2.3 present.
Allocating PCI resources starting at 10000000 (gap: 08000000:f8000000)
Built 1 zonelists in Zone order.  Total pages: 32512
Kernel command line: BOOT_IMAGE=LinuxTEST ro root=80a mem=128M acpi=off
Local APIC disabled by BIOS -- you can enable it with "lapic"
mapped APIC to ffffb000 (01102000)
Enabling fast FPU save and restore... done.
Initializing CPU#0
PID hash table entries: 512 (order: 9, 2048 bytes)
Detected 996.672 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
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
Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
Memory: 123952k/131072k available (2054k kernel code, 6656k reserved, 974k data, 176k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffb5000 - 0xfffff000   ( 296 kB)
    vmalloc : 0xc8800000 - 0xfffb3000   ( 887 MB)
    lowmem  : 0xc0000000 - 0xc8000000   ( 128 MB)
      .init : 0xc03f8000 - 0xc0424000   ( 176 kB)
      .data : 0xc0301b68 - 0xc03f54a4   ( 974 kB)
      .text : 0xc0100000 - 0xc0301b68   (2054 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 1996.61 BogoMIPS (lpj=3993234)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0183f9ff c1c7f9ff 00000000 00000000 00000000 00000000 00000000 00000000
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 256K (64 bytes/line)
CPU: After all inits, caps: 0183f9ff c1c7f9ff 00000000 00000420 00000000 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
CPU: AMD Athlon(tm) Processor stepping 02
Checking 'hlt' instruction... OK.
NET: Registered protocol family 16
PCI: PCI BIOS revision 2.10 entry at 0xfb220, last bus=1
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI: disabled
PnPBIOS: Scanning system for PnP BIOS support...
PnPBIOS: Found PnP BIOS installation structure at 0xc00fbce0
PnPBIOS: PnP BIOS version 1.0, entry 0xf0000:0xbd10, dseg 0xf0000
PnPBIOS: 15 nodes reported by PnP BIOS; 15 recorded by driver
SCSI subsystem initialized
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
PCI quirk: region 4000-40ff claimed by vt82c586 ACPI
PCI quirk: region 6000-607f claimed by vt82c686 HW-mon
PCI quirk: region 5000-500f claimed by vt82c686 SMB
PCI: Using IRQ router VIA [1106/0686] at 0000:00:07.0
PCI: setting IRQ 10 as level-triggered
PCI: Found IRQ 10 for device 0000:00:0e.0
PCI: Sharing IRQ 10 with 0000:00:0a.0
ACPI Exception (utmutex-0263): AE_BAD_PARAMETER, Thread C114F550 could not acquire Mutex [3] [20070126]
pnp: 00:07: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:07: iomem range 0xfffe0000-0xffffffff has been reserved
pnp: 00:07: iomem range 0xfee00000-0xfee0ffff has been reserved
pnp: 00:07: iomem range 0x100000-0xfffffff could not be reserved
pnp: 00:08: iomem range 0xf0000-0xf3fff could not be reserved
pnp: 00:08: iomem range 0xf4000-0xf7fff could not be reserved
pnp: 00:08: iomem range 0xf8000-0xfffff could not be reserved
pnp: 00:08: iomem range 0xcb800-0xcbfff has been reserved
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:01.0 to 64
NET: Registered protocol family 2
Time: tsc clocksource has been installed.
IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
TCP established hash table entries: 4096 (order: 5, 131072 bytes)
TCP bind hash table entries: 4096 (order: 5, 131072 bytes)
TCP: Hash tables configured (established 4096 bind 4096)
TCP reno registered
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
fuse init (API version 7.8)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: VIA PCI bridge detected. Disabling DAC.
PCI: Disabling Via external APIC routing
Boot video device is 0000:00:0e.0
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Real Time Clock Driver v1.12ac
8139too Fast Ethernet driver 0.9.28
PCI: Found IRQ 10 for device 0000:00:0a.0
PCI: Sharing IRQ 10 with 0000:00:0e.0
eth0: RealTek RTL8139 at 0xc8800000, 00:a0:0c:c7:ef:6c, IRQ 10
eth0:  Identified 8139 chip type 'RTL-8139C'
PCI: setting IRQ 11 as level-triggered
PCI: Found IRQ 11 for device 0000:00:09.0
sym0: <875> rev 0x26 at pci 0000:00:09.0 irq 11
sym0: Symbios NVRAM, ID 7, Fast-20, SE, parity checking
sym0: open drain IRQ line driver, using on-chip SRAM
sym0: using LOAD/STORE-based firmware.
sym0: SCSI BUS has been reset.
scsi0 : sym-2.2.3
 target0:0:0: Scan at boot disabled in NVRAM
 target0:0:1: Scan at boot disabled in NVRAM
 target0:0:2: Multiple LUNs disabled in NVRAM
scsi 0:0:2:0: Direct-Access     IBM      DNES-309170W     SA30 PQ: 0 ANSI: 3
 target0:0:2: tagged command queuing enabled, command queue depth 16.
 target0:0:2: Beginning Domain Validation
 target0:0:2: asynchronous
 target0:0:2: wide asynchronous
 target0:0:2: FAST-10 WIDE SCSI 20.0 MB/s ST (100 ns, offset 16)
 target0:0:2: Domain Validation skipping write tests
 target0:0:2: Ending Domain Validation
scsi 0:0:2:0: phase change 2-3 12@011e7f5c resid=11.
 target0:0:3: Scan at boot disabled in NVRAM
 target0:0:4: Scan at boot disabled in NVRAM
 target0:0:5: Scan at boot disabled in NVRAM
 target0:0:6: Scan at boot disabled in NVRAM
 target0:0:8: Scan at boot disabled in NVRAM
 target0:0:9: Scan at boot disabled in NVRAM
 target0:0:10: Scan at boot disabled in NVRAM
 target0:0:11: Scan at boot disabled in NVRAM
 target0:0:12: Scan at boot disabled in NVRAM
 target0:0:13: Scan at boot disabled in NVRAM
 target0:0:14: Scan at boot disabled in NVRAM
 target0:0:15: Scan at boot disabled in NVRAM
sd 0:0:2:0: [sda] 17916240 512-byte hardware sectors (9173 MB)
sd 0:0:2:0: [sda] Write Protect is off
sd 0:0:2:0: [sda] Mode Sense: c3 00 00 08
sd 0:0:2:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:2:0: [sda] 17916240 512-byte hardware sectors (9173 MB)
sd 0:0:2:0: [sda] Write Protect is off
sd 0:0:2:0: [sda] Mode Sense: c3 00 00 08
sd 0:0:2:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 sda11 >
sd 0:0:2:0: [sda] Attached SCSI disk
PNP: PS/2 Controller [PNP0303,PNP0f13] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI Shortcut mode
input: PS/2 Logitech Mouse as /devices/platform/i8042/serio1/input/input1
VFS: Mounted root (ext2 filesystem) readonly.
Freeing unused kernel memory: 176k freed
input: PC Speaker as /devices/platform/pcspkr/input/input2
parport_pc: VIA 686A/8231 detected
parport_pc: probing current configuration
parport_pc: Current parallel port base: 0x378
parport0: PC-style at 0x378 (0x778), irq 7, using FIFO [PCSPP,TRISTATE,COMPAT,ECP]
parport_pc: VIA parallel port: io=0x378, irq=7
Serial: 8250/16550 driver $Revision: 1.90 $ 2 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Linux agpgart interface v0.102
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
agpgart: Detected VIA Twister-K/KT133x/KM133 chipset
agpgart: AGP aperture is 64M @ 0xd0000000
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
00:0d: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0e: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
USB Universal Host Controller Interface driver v3.0
PCI: Found IRQ 11 for device 0000:00:07.2
PCI: Sharing IRQ 11 with 0000:00:07.3
uhci_hcd 0000:00:07.2: UHCI Host Controller
uhci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:07.2: irq 11, io base 0x0000c400
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
PCI: Found IRQ 11 for device 0000:00:07.3
PCI: Sharing IRQ 11 with 0000:00:07.2
uhci_hcd 0000:00:07.3: UHCI Host Controller
uhci_hcd 0000:00:07.3: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:07.3: irq 11, io base 0x0000c800
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
VP_IDE: IDE controller at PCI slot 0000:00:07.1
VP_IDE: chipset revision 16
VP_IDE: not 100% native mode: will probe irqs later
VP_IDE: VIA vt82c686a (rev 22) IDE UDMA66 controller on pci0000:00:07.1
    ide0: BM-DMA at 0xc000-0xc007, BIOS settings: hda:pio, hdb:pio
    ide1: BM-DMA at 0xc008-0xc00f, BIOS settings: hdc:pio, hdd:pio
Probing IDE interface ide0...
Probing IDE interface ide1...
PCI: setting IRQ 9 as level-triggered
PCI: Found IRQ 9 for device 0000:00:07.5
PCI: Setting latency timer of device 0000:00:07.5 to 64
Adding 132072k swap on /dev/sda9.  Priority:-1 extents:1 across:132072k
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
lp0: using parport0 (interrupt-driven).
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda8, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda7, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda11, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
 target0:0:4: Multiple LUNs disabled in NVRAM
scsi 0:0:4:0: CD-ROM            PLEXTOR  CD-R   PX-W4220T 1.01 PQ: 0 ANSI: 2
 target0:0:4: Beginning Domain Validation
 target0:0:4: asynchronous
 target0:0:4: FAST-10 SCSI 10.0 MB/s ST (100 ns, offset 8)
 target0:0:4: Domain Validation skipping write tests
 target0:0:4: Ending Domain Validation
sr0: scsi3-mmc drive: 20x/20x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 0:0:4:0: Attached scsi CD-ROM sr0
sd 0:0:2:0: Attached scsi generic sg0 type 0
sr 0:0:4:0: Attached scsi generic sg1 type 5
eth0: link up, 100Mbps, full-duplex, lpa 0x41E1
usbcore: registered new interface driver usblp
eth0: no IPv6 routers present
