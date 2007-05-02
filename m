Return-Path: <linux-kernel-owner+w=401wt.eu-S2993272AbXEBOrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993272AbXEBOrY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 10:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993280AbXEBOrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 10:47:24 -0400
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:40940 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993272AbXEBOrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 10:47:21 -0400
Date: Wed, 2 May 2007 16:47:16 +0200
From: Wolfgang Erig <Wolfgang.Erig@gmx.de>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: regression on quad Xeon: no SCSI-disks
Message-ID: <20070502144716.GA11061@erig.dyndns.org>
Mail-Followup-To: Chuck Ebbert <cebbert@redhat.com>,
	linux-kernel@vger.kernel.org,
	Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20070501142431.GA11667@erig.dyndns.org> <46376474.8090505@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46376474.8090505@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 12:01:56PM -0400, Chuck Ebbert wrote:
> Wolfgang Erig wrote:
> > Sorry
> > for detecting this 2 year old regression so late.
> > 
> > 2.6.13 or later is bad.
> > 2.6.12 is good,
> > 
> > "git bisect" worked fine and points to the attached patch.
> > The patch is pretty small. The problem seemed to be dependant
> > on the PCI-architecture of these particular systems.
> > Tried this on two machines with the same behaviour.
> > 
> > Wolfgang
> > 
> > 
> > $ git bisect bad 
> > 299de0343c7d18448a69c635378342e9214b14af is first bad commit
> > commit 299de0343c7d18448a69c635378342e9214b14af
> > Author: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> > Date:   Wed Jun 15 18:59:27 2005 +0400
> > 
> >     [PATCH] PCI: pci_assign_unassigned_resources() on x86
> >     
> >     - Add sanity check for io[port,mem]_resource in setup-bus.c. These
> >       resources look like "free" as they have no parents, but obviously
> >       we must not touch them.
> >     - In i386.c:pci_allocate_bus_resources(), if a bridge resource cannot be
> >       allocated for some reason, then clear its flags. This prevents any child
> >       allocations in this range, so the setup-bus code will work with a clean
> >       resource sub-tree.
> >     - i386.c:pcibios_enable_resources() doesn't enable bridges, as it checks
> >       only resources 0-5, which looks like a clear bug to me. I suspect it
> >       might break hotplug as well in some cases.
> >     
> >     From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> >     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > :040000 040000 ecab084beb95987f3e4ead8b61ce19cc052a5fa3 4c1364a6fd511b6dc6ddec06d787bcf105687835 M      arch
> > :040000 040000 0956f28cde32bd7494d7a87e2814bcd726547a32 0d2e2b611b007085e5a0994a66fd9c0a873ac8f8 M      drivers
> > 
> > ====== on console =======
> > sym0: <875> rev 0x26 at pci 0000:01:02.0 irq 30
> > sym0: Symbios NVRAM, ID 7, Fast-20, SE, parity checking
> > sym0: open drain IRQ line driver, using on-chip SRAM
> > sym0: using LOAD/STORE-based firmware.
> > sym0: SCSI BUS has been reset.
> > scsi0 : sym-2.2.0
> > scsi 0:0:0:0 ABORT operation started.
> > scsi 0:0:0:0 ABORT operation timed-out.
> > scsi 0:0:0:0 DEVICE RESET operation started.
> > scsi 0:0:0:0 DEVICE RESET operation timed-out.
> > scsi 0:0:0:0 BUS RESET operation started.
> > scsi 0:0:0:0 BUS RESET operation timed-out.
> >       ....
> 
> Output from kernel with CONFIG_PCI_DEBUG could be useful.
> 
Linux version 2.6.21-gde46c337 (erig@pippin) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #3 SMP Wed May 2 08:39:55 CEST 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 000000000009d400 end: 000000000009d400 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000000009d400 size: 0000000000002c00 end: 00000000000a0000 type: 2
copy_e820_map() start: 00000000000e7400 size: 0000000000018c00 end: 0000000000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 000000009ff00000 end: 00000000a0000000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 00000000fec00000 size: 0000000000100000 end: 00000000fed00000 type: 2
copy_e820_map() start: 00000000fee00000 size: 0000000000100000 end: 00000000fef00000 type: 2
copy_e820_map() start: 00000000ffe00000 size: 0000000000200000 end: 0000000100000000 type: 2
 BIOS-e820: 0000000000000000 - 000000000009d400 (usable)
 BIOS-e820: 000000000009d400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e7400 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000a0000000 (usable)
 BIOS-e820: 00000000fec00000 - 00000000fed00000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
 BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
1664MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000f6910
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   655360
early_node_map[1] active PFN ranges
    0:        0 ->   655360
DMI 2.1 present.
Intel MultiProcessor Specification v1.4
    Virtual Wire compatibility mode.
OEM ID: SIEMENS  Product ID: PRIMERGY 870 APIC at: 0xFEE00000
Processor #3 6:7 APIC version 17
Processor #0 6:7 APIC version 17
Processor #1 6:7 APIC version 17
Processor #2 6:7 APIC version 17
I/O APIC #4 Version 17 at 0xFEC00000.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Processors: 4
Allocating PCI resources starting at a8000000 (gap: a0000000:5ec00000)
Built 1 zonelists.  Total pages: 650240
Kernel command line: BOOT_IMAGE=2.6-git ro root=802 console=tty0 console=ttyS0,38400
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 550.016 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 2596736k/2621440k available (1206k kernel code, 23576k reserved, 574k data, 152k init, 1703936k highmem)
virtual kernel memory layout:
    fixmap  : 0xffe1c000 - 0xfffff000   (1932 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc02c3000 - 0xc02e9000   ( 152 kB)
      .data : 0xc022db9b - 0xc02bd654   ( 574 kB)
      .text : 0xc0100000 - 0xc022db9b   (1206 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 1100.86 BogoMIPS (lpj=5504322)
Mount-cache hash table entries: 512
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 512K
CPU serial number disabled.
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 9k freed
CPU0: Intel Pentium III (Katmai) stepping 03
Booting processor 1/0 eip 2000
Initializing CPU#1
Calibrating delay using timer specific routine.. 1100.09 BogoMIPS (lpj=5500450)
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 512K
CPU serial number disabled.
CPU1: Intel Pentium III (Katmai) stepping 03
Booting processor 2/1 eip 2000
Initializing CPU#2
Calibrating delay using timer specific routine.. 1100.04 BogoMIPS (lpj=5500246)
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 512K
CPU serial number disabled.
CPU2: Intel Pentium III (Katmai) stepping 03
Booting processor 3/2 eip 2000
Initializing CPU#3
Calibrating delay using timer specific routine.. 1100.03 BogoMIPS (lpj=5500169)
CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 512K
CPU serial number disabled.
CPU3: Intel Pentium III (Katmai) stepping 03
Total of 4 processors activated (4401.03 BogoMIPS).
ExtINT not setup in hardware but reported by MP table
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=0 pin2=0
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
checking TSC synchronization [CPU#0 -> CPU#2]: passed.
checking TSC synchronization [CPU#0 -> CPU#3]: passed.
Brought up 4 CPUs
migration_cost=1658
NET: Registered protocol family 16
PCI: PCI BIOS revision 2.10 entry at 0xfdad3, last bus=3
PCI: Using configuration type 1
Setting up standard PCI resources
SCSI subsystem initialized
PCI: Probing PCI hardware
PCI quirk: region 1000-103f claimed by PIIX4 ACPI
PCI quirk: region 1040-104f claimed by PIIX4 SMB
PIIX4 devres C PIO at 0c8c-0c8f
PCI: Searching for i450NX host bridges on 0000:00:10.0
PCI: Firmware left 0000:01:01.0 e100 interrupts enabled, disabling
PCI->APIC IRQ transform: 0000:03:0e.0[A] -> IRQ 26
PCI->APIC IRQ transform: 0000:00:02.2[D] -> IRQ 19
PCI->APIC IRQ transform: 0000:00:05.1[A] -> IRQ 28
PCI->APIC IRQ transform: 0000:01:01.0[A] -> IRQ 29
PCI->APIC IRQ transform: 0000:01:02.0[A] -> IRQ 30
PCI->APIC IRQ transform: 0000:01:03.0[A] -> IRQ 31
PCI: Cannot allocate resource region 0 of device 0000:00:04.0
PCI: Error while updating region 0000:00:04.0/0 (a8008000 != fec08000)
Time: tsc clocksource has been installed.
PCI: Bridge: 0000:00:05.0
  IO window: 3000-3fff
  MEM window: fa100000-fa2fffff
  PREFETCH window: fa600000-fa6fffff
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1572864 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
highmem bounce pool size: 64 pages
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Real Time Clock Driver v1.12ac
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
serial8250: ttyS2 at I/O 0x3e8 (irq = 4) is a 16550A
serial8250: ttyS3 at I/O 0x2e8 (irq = 3) is a 16550A
parport0: PC-style at 0x378 (0x778) [PCSPP(,...)]
parport0: irq 7 detected
eepro100.c:v1.09j-t 9/29/99 Donald Becker http://www.scyld.com/network/eepro100.html
eepro100.c: $Revision: 1.36 $ 2000/11/17 Modified by Andrey V. Savochkin <saw@saw.sw.com.sg> and others
eth0: OEM i82557/i82558 10/100 Ethernet, 08:00:06:0D:90:33, IRQ 29.
  Receiver lock-up bug exists -- enabling work-around.
  Board assembly 742170-254, Physical connectors present: RJ45
  Primary interface chip i82555 PHY #1.
  General self-test: passed.
  Serial sub-system self-test: passed.
  Internal registers self-test: passed.
  ROM checksum self-test: passed (0x24c9f043).
  Receiver lock-up workaround activated.
Clocksource tsc unstable (delta = 119966425 ns)
Time: jiffies clocksource has been installed.
sym0: <875> rev 0x26 at pci 0000:01:02.0 irq 30
sym0: Symbios NVRAM, ID 7, Fast-20, SE, parity checking
sym0: open drain IRQ line driver, using on-chip SRAM
sym0: using LOAD/STORE-based firmware.
sym0: SCSI BUS has been reset.
scsi0 : sym-2.2.3
scsi 0:0:0:0: ABORT operation started.
scsi 0:0:0:0: ABORT operation timed-out.
scsi 0:0:0:0: DEVICE RESET operation started.
scsi 0:0:0:0: DEVICE RESET operation timed-out.
scsi 0:0:0:0: BUS RESET operation started.
scsi 0:0:0:0: BUS RESET operation timed-out.
scsi 0:0:0:0: HOST RESET operation started.
sym0: SCSI BUS has been reset.
scsi 0:0:0:0: HOST RESET operation timed-out.
scsi 0:0:0:0: scsi: Device offlined - not ready after error recovery
scsi 0:0:1:0: ABORT operation started.
scsi 0:0:1:0: ABORT operation timed-out.
scsi 0:0:1:0: DEVICE RESET operation started.
scsi 0:0:1:0: DEVICE RESET operation timed-out.
scsi 0:0:1:0: BUS RESET operation started.
scsi 0:0:1:0: BUS RESET operation timed-out.
scsi 0:0:1:0: HOST RESET operation started.
sym0: SCSI BUS has been reset.
scsi 0:0:1:0: HOST RESET operation timed-out.
scsi 0:0:1:0: scsi: Device offlined - not ready after error recovery
scsi 0:0:2:0: ABORT operation started.
