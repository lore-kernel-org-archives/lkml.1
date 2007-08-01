Return-Path: <linux-kernel-owner+w=401wt.eu-S1763099AbXHABG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763099AbXHABG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 21:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759368AbXHABGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 21:06:14 -0400
Received: from web58101.mail.re3.yahoo.com ([68.142.236.124]:38843 "HELO
	web58101.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758538AbXHABGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 21:06:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=GOMoTcna3OoCKKj4SU6dLOqGOpC/cXLPsEulqgpBG22cqy4egElYZlHYyIVJ0fTiGEyJLsUtzKp4v1/WVGwdzVtgnIRw5EYd6aWAk1lhyIojbJXXGbo5O+hJJ1LExqDccWeQqB8bbNW7XOC26yDDRzEIj25EA6iF+LXOYR4XK40=;
X-YMail-OSG: rg3fGwoVM1mwJA3LDoEHZRZxFn8BQv6eeuHx3uHH4MI5yWlh6gjZ4Fkka2vrqsw0XMxGLpH.5uKwb8c5uQahj0Ey
Date: Tue, 31 Jul 2007 18:06:09 -0700 (PDT)
From: Craig Block <chblock3@yahoo.com>
Subject: Re:  IRQ Delivery Problem for MCP65  
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-1105814460-1185930369=:46155"
Content-Transfer-Encoding: 8bit
Message-ID: <920239.46155.qm@web58101.mail.re3.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--0-1105814460-1185930369=:46155
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Content-Id: 
Content-Disposition: inline

--- Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> > --- Craig Block <chblock3@yahoo.com> wrote:

> > I'm having trouble getting Linux to see any hard drives on an ASUS M2N-X
> > motherboard with an MCP65 (nForce 520) chipset.  When the kernel probes the
> > AHCI controllers, it hangs for a minute or so on each one and returns the
> > following;
> >
> > ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> 
> I googled for some more info about similar issues and found very similar
> problem being discussed on Gentoo forum:
> 
> The important part is here:
>
> "when I disabled Message Signaled Interrupts (MSI and MSI-X) under "Bus
> Options" in the kernel, the problem magically went away (disabling MSI)"
> 
> which indicates IRQ routing problems (as suspected from dmesg output and also
> stated by Tejun).  Have you already tried disabling MSI IRQs with "pci=nomsi"
> (not "nomsi") or even completely disabling CONFIG_PCI_MSI support?

Thanks a ton, building the kernel with PCI_MSI not set did the trick. 
Attempting to disable MSI using pci=nomsi at the boot prompt did not eliminate
the problem.  I had to build the kernel without MSI support.  There's a few
interesting differences in the dmesg output with "PCI_MSI=y" and PCI_MSI not
set;

With PCI_MSI not set;

ata1: SATA max UDMA/133 cmd 0xf8804100 ctl 0x00000000 bmdma 0x00000000 irq 5
ata2: SATA max UDMA/133 cmd 0xf8804180 ctl 0x00000000 bmdma 0x00000000 irq 5
ata3: SATA max UDMA/133 cmd 0xf8804200 ctl 0x00000000 bmdma 0x00000000 irq 5
ata4: SATA max UDMA/133 cmd 0xf8804280 ctl 0x00000000 bmdma 0x00000000 irq 5

With PCI_MSI=y;

ata1: SATA max UDMA/133 cmd 0xf8804100 ctl 0x00000000 bmdma 0x00000000 irq 219
ata2: SATA max UDMA/133 cmd 0xf8804180 ctl 0x00000000 bmdma 0x00000000 irq 219
ata3: SATA max UDMA/133 cmd 0xf8804200 ctl 0x00000000 bmdma 0x00000000 irq 219
ata4: SATA max UDMA/133 cmd 0xf8804280 ctl 0x00000000 bmdma 0x00000000 irq 219

Also, there's a spurous interrupt message that appears with PCI_MSI=y;

spurious 8259A interrupt: IRQ7.

I attached the two dmesg instances for reference.

 - Craig


       
____________________________________________________________________________________
Building a website is a piece of cake. Yahoo! Small Business gives you all the tools to get online.
http://smallbusiness.yahoo.com/webhosting 
--0-1105814460-1185930369=:46155
Content-Type: text/plain; name=dmesg-no_msi
Content-Description: 1568775106-dmesg-no_msi
Content-Disposition: inline; filename=dmesg-no_msi

6896k available (1556k kernel code, 24352k reserved, 545k data, 168k init, 1179392k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffaf000 - 0xfffff000   ( 320 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc0310000 - 0xc033a000   ( 168 kB)
      .data : 0xc0285011 - 0xc030d70c   ( 545 kB)
      .text : 0xc0100000 - 0xc0285011   (1556 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 4824.67 BogoMIPS (lpj=2412339)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 078bfbff ebd3fbff 00000000 00000000 00002001 00000000 0000011d
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: After all inits, caps: 078bfbff ebd3fbff 00000000 00000410 00002001 00000000 0000011d
Compat vDSO mapped to ffffe000.
CPU: AMD Athlon(tm) 64 Processor 3800+ stepping 01
Checking 'hlt' instruction... OK.
ExtINT not setup in hardware but reported by MP table
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=0 pin2=0
NET: Registered protocol family 16
PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=5
PCI: Using configuration type 1
Setting up standard PCI resources
SCSI subsystem initialized
libata version 2.21 loaded.
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
PCI: Transparent bridge - 0000:00:08.0
PCI: Using IRQ router default [10de/0441] at 0000:00:01.0
PCI->APIC IRQ transform: 0000:00:01.1[A] -> IRQ 10
PCI->APIC IRQ transform: 0000:00:02.0[A] -> IRQ 11
PCI->APIC IRQ transform: 0000:00:02.1[B] -> IRQ 10
PCI->APIC IRQ transform: 0000:00:07.0[B] -> IRQ 11
PCI->APIC IRQ transform: 0000:00:0a.0[A] -> IRQ 5
PCI->APIC IRQ transform: 0000:01:08.0[A] -> IRQ 11
PCI->APIC IRQ transform: 0000:04:00.0[A] -> IRQ 11
PCI: Bridge: 0000:00:08.0
  IO window: d000-dfff
  MEM window: dbf00000-dbffffff
Time: tsc clocksource has been installed.
  PREFETCH window: 88000000-880fffff
PCI: Bridge: 0000:00:0b.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0c.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0d.0
  IO window: e000-efff
  MEM window: dc000000-dfffffff
  PREFETCH window: c0000000-cfffffff
PCI: Bridge: 0000:00:0e.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:08.0 to 64
PCI: Setting latency timer of device 0000:00:0b.0 to 64
PCI: Setting latency timer of device 0000:00:0c.0 to 64
PCI: Setting latency timer of device 0000:00:0d.0 to 64
PCI: Setting latency timer of device 0000:00:0e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 4591k freed
highmem bounce pool size: 64 pages
NTFS driver 2.1.28 [Flags: R/O].
io scheduler noop registered
io scheduler cfq registered (default)
Boot video device is 0000:04:00.0
PCI: Setting latency timer of device 0000:00:0b.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0b.0:pcie00]
PCI: Setting latency timer of device 0000:00:0c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0c.0:pcie00]
PCI: Setting latency timer of device 0000:00:0d.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0d.0:pcie00]
PCI: Setting latency timer of device 0000:00:0e.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0e.0:pcie00]
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250.0: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
parport0: PC-style at 0x378 [PCSPP(,...)]
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: module loaded
3c59x: Donald Becker and others.
0000:01:08.0: 3Com PCI 3c905B Cyclone 100baseTx at f8800c00.
ahci 0000:00:0a.0: version 2.2
ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
ahci 0000:00:0a.0: flags: 64bit led clo pmp pio 
PCI: Setting latency timer of device 0000:00:0a.0 to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 cmd 0xf8804100 ctl 0x00000000 bmdma 0x00000000 irq 5
ata2: SATA max UDMA/133 cmd 0xf8804180 ctl 0x00000000 bmdma 0x00000000 irq 5
ata3: SATA max UDMA/133 cmd 0xf8804200 ctl 0x00000000 bmdma 0x00000000 irq 5
ata4: SATA max UDMA/133 cmd 0xf8804280 ctl 0x00000000 bmdma 0x00000000 irq 5
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-7: WDC WD800JD-75MSA3, 10.01E04, max UDMA/133
ata1.00: 156250000 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/133
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: ATA-7: WDC WD800JD-75MSA3, 10.01E04, max UDMA/133
ata2.00: 156250000 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata2.00: configured for UDMA/133
ata3: SATA link down (SStatus 0 SControl 300)
ata4: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      WDC WD800JD-75MS 10.0 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 156250000 512-byte hardware sectors (80000 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 156250000 512-byte hardware sectors (80000 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1
sd 0:0:0:0: [sda] Attached SCSI disk
scsi 1:0:0:0: Direct-Access     ATA      WDC WD800JD-75MS 10.0 PQ: 0 ANSI: 5
sd 1:0:0:0: [sdb] 156250000 512-byte hardware sectors (80000 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:0:0: [sdb] 156250000 512-byte hardware sectors (80000 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1
sd 1:0:0:0: [sdb] Attached SCSI disk
pata_amd 0000:00:09.0: version 0.3.8
PCI: Setting latency timer of device 0000:00:09.0 to 64
scsi4 : pata_amd
scsi5 : pata_amd
ata5: PATA max UDMA/133 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001ffa0 irq 14
ata6: PATA max UDMA/133 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001ffa8 irq 15
ata5.00: ATAPI: LITE-ON COMBO SOHC-5232K, NK0H, max UDMA/44
ata5.00: configured for UDMA/44
ata6: port disabled. ignoring.
scsi 4:0:0:0: CD-ROM            LITE-ON  COMBO SOHC-5232K NK0H PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 32x/40x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 4:0:0:0: Attached scsi CD-ROM sr0
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
input: PC Speaker as /class/input/input1
logips2pp: Detected unknown logitech mouse model 19
input: PS/2 Logitech Mouse as /class/input/input2
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI Shortcut mode
Freeing unused kernel memory: 168k freed

--0-1105814460-1185930369=:46155
Content-Type: text/plain; name=dmesg-with_msi
Content-Description: 2129196301-dmesg-with_msi
Content-Disposition: inline; filename=dmesg-with_msi

U#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 2411.064 MHz processor.
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 2071404k/2096896k available (1560k kernel code, 24360k reserved, 545k data, 168k init, 1179392k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffaf000 - 0xfffff000   ( 320 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc0312000 - 0xc033c000   ( 168 kB)
      .data : 0xc02860d1 - 0xc030e70c   ( 545 kB)
      .text : 0xc0100000 - 0xc02860d1   (1560 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 4824.67 BogoMIPS (lpj=2412338)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 078bfbff ebd3fbff 00000000 00000000 00002001 00000000 0000011d
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: After all inits, caps: 078bfbff ebd3fbff 00000000 00000410 00002001 00000000 0000011d
Compat vDSO mapped to ffffe000.
CPU: AMD Athlon(tm) 64 Processor 3800+ stepping 01
Checking 'hlt' instruction... OK.
ExtINT not setup in hardware but reported by MP table
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=0 pin2=0
NET: Registered protocol family 16
PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=5
PCI: Using configuration type 1
Setting up standard PCI resources
SCSI subsystem initialized
libata version 2.21 loaded.
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
PCI: Transparent bridge - 0000:00:08.0
PCI: Using IRQ router default [10de/0441] at 0000:00:01.0
PCI->APIC IRQ transform: 0000:00:01.1[A] -> IRQ 10
PCI->APIC IRQ transform: 0000:00:02.0[A] -> IRQ 11
PCI->APIC IRQ transform: 0000:00:02.1[B] -> IRQ 10
PCI->APIC IRQ transform: 0000:00:07.0[B] -> IRQ 11
PCI->APIC IRQ transform: 0000:00:0a.0[A] -> IRQ 5
PCI->APIC IRQ transform: 0000:01:08.0[A] -> IRQ 11
PCI->APIC IRQ transform: 0000:04:00.0[A] -> IRQ 11
PCI: Bridge: 0000:00:08.0
  IO window: d000-dfff
  MEM window: dbf00000-dbffffff
Time: tsc clocksource has been installed.
  PREFETCH window: 88000000-880fffff
PCI: Bridge: 0000:00:0b.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0c.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0d.0
  IO window: e000-efff
  MEM window: dc000000-dfffffff
  PREFETCH window: c0000000-cfffffff
PCI: Bridge: 0000:00:0e.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:08.0 to 64
PCI: Setting latency timer of device 0000:00:0b.0 to 64
PCI: Setting latency timer of device 0000:00:0c.0 to 64
PCI: Setting latency timer of device 0000:00:0d.0 to 64
PCI: Setting latency timer of device 0000:00:0e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 4591k freed
highmem bounce pool size: 64 pages
NTFS driver 2.1.28 [Flags: R/O].
io scheduler noop registered
io scheduler cfq registered (default)
Boot video device is 0000:04:00.0
PCI: Setting latency timer of device 0000:00:0b.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0b.0:pcie00]
PCI: Setting latency timer of device 0000:00:0c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0c.0:pcie00]
PCI: Setting latency timer of device 0000:00:0d.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0d.0:pcie00]
PCI: Setting latency timer of device 0000:00:0e.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0e.0:pcie00]
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250.0: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
parport0: PC-style at 0x378 [PCSPP(,...)]
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
loop: module loaded
3c59x: Donald Becker and others.
0000:01:08.0: 3Com PCI 3c905B Cyclone 100baseTx at f8800c00.
ahci 0000:00:0a.0: version 2.2
ahci 0000:00:0a.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
ahci 0000:00:0a.0: flags: 64bit led clo pmp pio 
PCI: Setting latency timer of device 0000:00:0a.0 to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 cmd 0xf8804100 ctl 0x00000000 bmdma 0x00000000 irq 219
ata2: SATA max UDMA/133 cmd 0xf8804180 ctl 0x00000000 bmdma 0x00000000 irq 219
ata3: SATA max UDMA/133 cmd 0xf8804200 ctl 0x00000000 bmdma 0x00000000 irq 219
ata4: SATA max UDMA/133 cmd 0xf8804280 ctl 0x00000000 bmdma 0x00000000 irq 219
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
APIC error on CPU0: 00(40)
ata1.00: qc timeout (cmd 0xec)
ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
APIC error on CPU0: 40(40)
ata1.00: qc timeout (cmd 0xec)
ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
ata1: limiting SATA link speed to 1.5 Gbps
ata1.00: limiting speed to UDMA7:PIO5
ata1: SATA link up <unknown> (SStatus 103 SControl 310)
APIC error on CPU0: 40(40)
ata1.00: qc timeout (cmd 0xec)
ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
APIC error on CPU0: 40(40)
ata2.00: qc timeout (cmd 0xec)
ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
APIC error on CPU0: 40(40)
ata2.00: qc timeout (cmd 0xec)
ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
ata2: limiting SATA link speed to 1.5 Gbps
ata2.00: limiting speed to UDMA7:PIO5
ata2: SATA link up <unknown> (SStatus 103 SControl 310)
APIC error on CPU0: 40(40)
ata2.00: qc timeout (cmd 0xec)
ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3: SATA link down (SStatus 0 SControl 300)
ata4: SATA link down (SStatus 0 SControl 300)
pata_amd 0000:00:09.0: version 0.3.8
PCI: Setting latency timer of device 0000:00:09.0 to 64
scsi4 : pata_amd
scsi5 : pata_amd
ata5: PATA max UDMA/133 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001ffa0 irq 14
ata6: PATA max UDMA/133 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001ffa8 irq 15
ata5.00: ATAPI: LITE-ON COMBO SOHC-5232K, NK0H, max UDMA/44
ata5.00: configured for UDMA/44
ata6: port disabled. ignoring.
scsi 4:0:0:0: CD-ROM            LITE-ON  COMBO SOHC-5232K NK0H PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 0x/40x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 4:0:0:0: Attached scsi CD-ROM sr0
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
input: PC Speaker as /class/input/input1
logips2pp: Detected unknown logitech mouse model 19
input: PS/2 Logitech Mouse as /class/input/input2
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI Shortcut mode
Freeing unused kernel memory: 168k freed

--0-1105814460-1185930369=:46155--
