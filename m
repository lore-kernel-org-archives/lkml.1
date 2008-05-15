Return-Path: <linux-kernel-owner+w=401wt.eu-S1760163AbYEOLaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760163AbYEOLaz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 07:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754593AbYEOLao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 07:30:44 -0400
Received: from relay4.jackal-net.at ([193.154.151.101]:41304 "EHLO
	vm02.server04.jackal-net.at" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754378AbYEOLak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 07:30:40 -0400
Message-ID: <482C1EC4.9000901@jackal-net.at>
Date: Thu, 15 May 2008 13:30:12 +0200
From: Michael Lang <Michael.Lang@jackal-net.at>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: Kernel Panic when accessing NFS share and locking files
References: <482B2108.4090902@jackal-net.at>	<20080514204932.13243cab.akpm@linux-foundation.org> <20080514205528.3bf3955d@infradead.org>
In-Reply-To: <20080514205528.3bf3955d@infradead.org>
Content-Type: multipart/mixed;
 boundary="------------070309070106090408080304"
X-Milter: vm02.server04.jackal-net.at
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070309070106090408080304
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit

Arjan van de Ven wrote:
> On Wed, 14 May 2008 20:49:32 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
>
>   
>> On Wed, 14 May 2008 19:27:36 +0200 Michael Lang
>> <Michael.Lang@jackal-net.at> wrote:
>>
>>     
>>> Hi,
>>>
>>> we encountered a serious problem, when using Solaris NFS (Server) 
>>> accessing it with a CentOS5.1/RHEL5.1 client.
>>>       
>
>
>
>   
>> Which kernel version is being used?
>>     
>
> that'll be a 2.6.18 variant ;)
>
> there have been some, but not too many, reports of a trace like this:
> http://www.kerneloops.org/search.php?search=__fput
>   

at least 2.6.25-3 also reports it as a kernel bug, but doesn't panic any 
more ...
i attached the whole dmesg to the mail ...
regards

Michael Lang

------------[ cut here ]------------
kernel BUG at fs/locks.c:2051!
invalid opcode: 0000 [1] SMP
CPU 1
Modules linked in: ipt_REJECT iptable_filter ip_tables bridge nfsd 
auth_rpcgss exportfs autofs4 hidp nfs lockd nfs_acl rfcomm l2cap 
bluetooth sunrpc raid1 dm_round_robin tun ip6t_REJECT xt_tcpudp 
ip6table_filter ip6_tables x_tables ib_iser rdma_cm ib_cm iw_cm ib_sa 
ib_mad ib_core ib_addr iscsi_tcp libiscsi scsi_transport_iscsi 
cpufreq_ondemand acpi_cpufreq ipv6 dm_multipath sbs sbshc battery 
acpi_memhotplug ac lp sg floppy ide_cd_mod cdrom serio_raw snd_hda_intel 
parport_pc snd_seq_dummy snd_seq_oss button parport snd_seq_midi_event 
snd_seq snd_seq_device 8139too 8139cp snd_pcm_oss i2c_i801 mii 
snd_mixer_oss snd_pcm i2c_core snd_timer snd pcspkr soundcore shpchp 
snd_page_alloc dm_snapshot dm_zero dm_mirror dm_mod ata_piix libata 
sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd [last unloaded: 
microcode]
Pid: 4763, comm: python Not tainted 2.6.25.3 #1
RIP: 0010:[<ffffffff80299f5d>] [<ffffffff80299f5d>] 
locks_remove_flock+0xe2/0x102
RSP: 0018:ffff81000d1dfe38 EFLAGS: 00010246
RAX: 0000000000000081 RBX: ffff81000d31d2e8 RCX: ffff81001cc638c0
RDX: ffff81000f4101c0 RSI: 0000000000000286 RDI: ffffffff80580dc0
RBP: ffff810011232140 R08: ffff81001747aac0 R09: ffff81000d1dfb00
R10: 0000000000000004 R11: 000000200000001f R12: ffff81000d31d1e8
R13: ffff81000d31d1e8 R14: ffff81001ac4c680 R15: ffff81000df68220
FS: 00000000421e6940(0063) GS:ffff81001d979840(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000003335ebfe80 CR3: 000000000ee12000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process python (pid: 4763, threadinfo ffff81000d1de000, task 
ffff81000f4101c0)
Stack: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
0000000000000000 ffff810011232140 0000000000001299 0000000000000000
0000000000000000 0000000000000000 0000000000000000 ffff810011232140
Call Trace:
[<ffffffff8028d229>] ? __fput+0x97/0x17e
[<ffffffff80297692>] ? sys_fcntl+0x2eb/0x2f7
[<ffffffff8020be19>] ? tracesys+0xdc/0xe1


Code: 48 39 68 58 75 29 0f b6 40 60 a8 02 74 0a 48 89 df e8 5f fe ff ff 
eb 1a a8 20 74 0f be 02 00 00 00 48 89 df e8 e9 fe ff ff eb 07 <0f> 0b 
eb fe 48 89 c3 48 8b 03 48 85 c0 75 c6 e8 97 9d 1d 00 48
RIP [<ffffffff80299f5d>] locks_remove_flock+0xe2/0x102
RSP <ffff81000d1dfe38>
---[ end trace e4d79afa854e3611 ]---



--------------070309070106090408080304
Content-Type: text/plain;
 name="kernel-bug.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kernel-bug.txt"

Linux version 2.6.25.3 (root@lang) (gcc version 4.1.2 20070626 (Red Hat 4.1.2-14)) #1 SMP Thu May 15 09:20:40 CEST 2008
Command line: ro root=/dev/Grp_Root/Log_root rhgb quiet
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001df2f800 (usable)
 BIOS-e820: 000000001df2f800 - 000000001df30000 (ACPI NVS)
 BIOS-e820: 000000001df30000 - 000000001df40000 (ACPI data)
 BIOS-e820: 000000001df40000 - 000000001dff0000 (ACPI NVS)
 BIOS-e820: 000000001dff0000 - 000000001e000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fed13000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000feda0000 (reserved)
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 122671) 1 entries of 3200 used
end_pfn_map = 1043872
DMI 2.3 present.
ACPI: RSDP 000F4EB0, 0014 (r0 ACPIAM)
ACPI: RSDT 1DF30000, 0048 (r1 INTEL  D915GEV  20050728 MSFT       97)
ACPI: FACP 1DF30200, 0081 (r2 INTEL  D915GEV  20050728 MSFT       97)
ACPI: DSDT 1DF30440, 5C05 (r1 INTEL  D915GEV         1 INTL  2002026)
ACPI: FACS 1DF40000, 0040
ACPI: APIC 1DF30390, 0068 (r1 INTEL  D915GEV  20050728 MSFT       97)
ACPI: MCFG 1DF30400, 003C (r1 INTEL  D915GEV  20050728 MSFT       97)
ACPI: ASF! 1DF36050, 0099 (r16 LEGEND I865PASF        1 INTL  2002026)
ACPI: SSDT 1DF360F0, 0175 (r1 DpgPmm  Cpu1Ist       10 INTL  2002026)
ACPI: SSDT 1DF36500, 0175 (r1 DpgPmm  Cpu2Ist       10 INTL  2002026)
ACPI: SSDT 1DF36910, 0138 (r1 DpgPmm    CpuPm       10 INTL  2002026)
ACPI: TCPA 1DF36A50, 0032 (r1 INTEL  TBLOEMID        1 MSFT       97)
ACPI: WDDT 1DF36A82, 0040 (r1 INTEL  OEMWDDT         1 INTL  2002026)
No NUMA configuration found
Faking a node at 0000000000000000-000000001df2f000
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 122671) 1 entries of 3200 used
Bootmem setup node 0 0000000000000000-000000001df2f000
  NODE_DATA [000000000000b000 - 0000000000013fff]
  bootmap [0000000000014000 -  0000000000017be7] pages 4
early res: 0 [0-fff] BIOS data page
early res: 1 [6000-7fff] SMP_TRAMPOLINE
early res: 2 [200000-9a390b] TEXT DATA BSS
early res: 3 [1dc1a000-1df1e88a] RAMDISK
early res: 4 [9fc00-a0bff] EBDA
early res: 5 [8000-afff] PGTABLE
 [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0
 [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 on node 0
 [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001a00000 on node 0
 [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001e00000 on node 0
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   122671
On node 0 totalpages: 122574
  DMA zone: 56 pages used for memmap
  DMA zone: 1964 pages reserved
  DMA zone: 1979 pages, LIFO batch:0
  DMA32 zone: 1621 pages used for memmap
  DMA32 zone: 116954 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 20000000 (gap: 1e000000:c2000000)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 65008 bytes of per cpu data
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 118933
Policy zone: DMA32
Kernel command line: ro root=/dev/Grp_Root/Log_root rhgb quiet
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 16384 bytes)
TSC calibrated against PM_TIMER
time.c: Detected 2999.978 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Checking aperture...
Memory: 470668k/490684k available (2533k kernel code, 19628k reserved, 1274k data, 300k init)
CPA: page pool initialized 1 of 1 pages preallocated
Calibrating delay using timer specific routine.. 6003.31 BogoMIPS (lpj=3001656)
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
Mount-cache hash table entries: 256
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 2048K
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM1)
ACPI: Core revision 20070126
Using local APIC timer interrupts.
APIC timer calibration result 12499895
Detected 12.499 MHz APIC timer.
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 5999.62 BogoMIPS (lpj=2999812)
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 2048K
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU1: Thermal monitoring enabled (TM1)
              Intel(R) Pentium(R) 4 CPU 3.00GHz stepping 03
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
CPU0 attaching sched-domain:
 domain 0: span 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000003
  groups: 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000001 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000002
  domain 1: span 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000003
   groups: 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000003
   domain 2: span 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000003
    groups: 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000003
CPU1 attaching sched-domain:
 domain 0: span 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000003
  groups: 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000002 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000001
  domain 1: span 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000003
   groups: 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000003
   domain 2: span 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000003
    groups: 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000003
net_namespace: 1016 bytes
NET: Registered protocol family 16
No dock devices found.
ACPI: \_SB_.PCI0.IDE1.CHN1.DRV0: found ejectable bay
ACPI: \_SB_.PCI0.IDE1.CHN1.DRV0: Adding notify handler
ACPI: Bay [\_SB_.PCI0.IDE1.CHN1.DRV0] Added
ACPI: bus type pci registered
PCI: Using MMCONFIG at e0000000 - efffffff
PCI: Using configuration type 1
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs *3 4 5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: Power Resource [URP1] (off)
ACPI: Power Resource [FDDP] (off)
ACPI: Power Resource [LPTP] (off)
ACPI: Power Resource [URP2] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 15 devices
ACPI: ACPI bus type pnp unregistered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
PCI-GART: No AMD northbridge found.
system 00:0a: ioport range 0x4d0-0x4d1 has been reserved
system 00:0a: ioport range 0x400-0x47f has been reserved
system 00:0a: ioport range 0x500-0x53f has been reserved
system 00:0c: iomem range 0xffc00000-0xfff7ffff has been reserved
system 00:0d: ioport range 0x400-0x47f has been reserved
system 00:0d: ioport range 0x680-0x6ff has been reserved
system 00:0d: ioport range 0x500-0x53f has been reserved
system 00:0d: iomem range 0xeec00000-0xeec03fff could not be reserved
system 00:0d: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:0d: iomem range 0xfee00000-0xfee00fff could not be reserved
system 00:0d: iomem range 0xe0000000-0xefffffff could not be reserved
system 00:0d: iomem range 0xfed13000-0xfed13fff could not be reserved
system 00:0d: iomem range 0xfed14000-0xfed17fff could not be reserved
system 00:0d: iomem range 0xfed18000-0xfed18fff could not be reserved
system 00:0d: iomem range 0xfed19000-0xfed19fff could not be reserved
system 00:0d: iomem range 0xfed1c000-0xfed1ffff could not be reserved
system 00:0d: iomem range 0xfed20000-0xfed9ffff could not be reserved
system 00:0e: iomem range 0x0-0x9ffff could not be reserved
system 00:0e: iomem range 0xc0000-0xdffff has been reserved
system 00:0e: iomem range 0xe0000-0xfffff could not be reserved
system 00:0e: iomem range 0x100000-0x1dffffff could not be reserved
system 00:0e: iomem range 0x0-0x0 could not be reserved
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: 0xffa00000-0xffafffff
  PREFETCH window: 0x00000000cff00000-0x00000000cfffffff
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: 0xff600000-0xff6fffff
  PREFETCH window: 0x00000000cfb00000-0x00000000cfbfffff
PCI: Bridge: 0000:00:1c.1
  IO window: a000-afff
  MEM window: 0xff700000-0xff7fffff
  PREFETCH window: 0x00000000cfc00000-0x00000000cfcfffff
PCI: Bridge: 0000:00:1c.2
  IO window: disabled.
  MEM window: 0xff800000-0xff8fffff
  PREFETCH window: 0x00000000cfd00000-0x00000000cfdfffff
PCI: Bridge: 0000:00:1c.3
  IO window: disabled.
  MEM window: 0xff900000-0xff9fffff
  PREFETCH window: 0x00000000cfe00000-0x00000000cfefffff
PCI: Bridge: 0000:00:1e.0
  IO window: b000-bfff
  MEM window: 0xff500000-0xff5fffff
  PREFETCH window: 0x00000000cfa00000-0x00000000cfafffff
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:01.0 to 64
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.1 to 64
ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1c.2 to 64
ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1c.3 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 3, 32768 bytes)
TCP established hash table entries: 16384 (order: 6, 262144 bytes)
TCP bind hash table entries: 16384 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 3090k freed
audit: initializing netlink socket (disabled)
type=2000 audit(1210850220.530:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
SELinux:  Registering netfilter hooks
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:02.0: Boot video device
pci 0000:00:1d.7: EHCI: BIOS handoff failed (BIOS bug?) 01010001
PCI: Setting latency timer of device 0000:00:01.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:01.0:pcie00]
Allocate Port Service[0000:00:01.0:pcie03]
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
Allocate Port Service[0000:00:1c.0:pcie02]
Allocate Port Service[0000:00:1c.0:pcie03]
PCI: Setting latency timer of device 0000:00:1c.1 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.1:pcie00]
Allocate Port Service[0000:00:1c.1:pcie02]
Allocate Port Service[0000:00:1c.1:pcie03]
PCI: Setting latency timer of device 0000:00:1c.2 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.2:pcie00]
Allocate Port Service[0000:00:1c.2:pcie02]
Allocate Port Service[0000:00:1c.2:pcie03]
PCI: Setting latency timer of device 0000:00:1c.3 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.3:pcie00]
Allocate Port Service[0000:00:1c.3:pcie02]
Allocate Port Service[0000:00:1c.3:pcie03]
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI: ACPI0007:00 is registered as cooling_device0
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: ACPI0007:01 is registered as cooling_device1
ACPI: Processor [CPU2] (supports 8 throttling states)
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Linux agpgart interface v0.103
agpgart: Detected an Intel 915G Chipset.
agpgart: Detected 32508K stolen memory.
agpgart: AGP aperture is 256M @ 0xd0000000
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
brd: module loaded
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ICH6: IDE controller (0x8086:0x266f rev 0x03) at  PCI slot 0000:00:1f.1
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
ICH6: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:DMA, hdb:PIO
    ide1: BM-DMA at 0xffa8-0xffaf, BIOS settings: hdc:PIO, hdd:PIO
Probing IDE interface ide0...
hda: TOSHIBA CDW/DVD SDR1712C, ATAPI CD/DVD-ROM drive
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/33 mode selected
Probing IDE interface ide1...
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
ide-floppy driver 1.00
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
TCP bic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
registered taskstats version 1
Freeing unused kernel memory: 300k freed
Write protecting the kernel read-only data: 912k
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000c800
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000cc00
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000d000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1d.3 to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000d400
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
input: ImPS/2 Generic Wheel Mouse as /class/input/input0
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
input: AT Translated Set 2 keyboard as /class/input/input1
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 128 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xff43bc00
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 8 ports detected
SCSI subsystem initialized
Driver 'sd' needs updating - please use bus_type methods
libata version 3.00 loaded.
ata_piix 0000:00:1f.2: version 2.12
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: SATA max UDMA/133 cmd 0xe800 ctl 0xe400 bmdma 0xd800 irq 19
ata2: SATA max UDMA/133 cmd 0xe000 ctl 0xdc00 bmdma 0xd808 irq 19
ata1.00: ATA-7: Maxtor 6L080M0, BANC1G10, max UDMA/133
ata1.00: 160086528 sectors, multi 16: LBA NCQ (not used)
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      Maxtor 6L080M0   BANC PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 160086528 512-byte hardware sectors (81964 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 160086528 512-byte hardware sectors (81964 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
SELinux:  Disabled at runtime.
SELinux:  Unregistering netfilter hooks
type=1404 audit(1210850233.736:2): selinux=0 auid=4294967295 ses=4294967295
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
input: PC Speaker as /class/input/input2
intel_rng: Firmware space is locked read-only. If you can't or
intel_rng: don't want to disable this in firmware setup, and if
intel_rng: you are certain that your system has a functional
intel_rng: RNG, try using the 'no_fwh_detect' option.
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 19 (level, low) -> IRQ 19
8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
8139cp 0000:06:00.0: This (id 10ec:8139 rev 10) is not an 8139C+ compatible chip
8139cp 0000:06:00.0: Try the "8139too" driver instead.
8139too Fast Ethernet driver 0.9.28
ACPI: PCI Interrupt 0000:06:00.0[A] -> GSI 21 (level, low) -> IRQ 21
eth0: RealTek RTL8139 at 0xffffc20010184000, 00:00:b4:bd:bd:14, IRQ 21
eth0:  Identified 8139 chip type 'RTL-8139A'
input: Power Button (FF) as /class/input/input3
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input4
ACPI: Power Button (CM) [PWRB]
parport_pc 00:09: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE]
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1b.0 to 64
hda: ATAPI 52X DVD-ROM CD-R/RW drive, 1536kB Cache
Uniform CD-ROM driver Revision: 3.20
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
sd 0:0:0:0: Attached scsi generic sg0 type 0
lp0: using parport0 (interrupt-driven).
lp0: console ready
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
device-mapper: multipath: version 1.0.5 loaded
EXT3 FS on dm-0, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-14, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-6, internal journal
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-7, internal journal
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
Adding 524280k swap on /dev/Grp_Root/SWAP.  Priority:-1 extents:1 across:524280k
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
warning: process `kudzu' used the deprecated sysctl system call with 1.23.
Loading iSCSI transport class v2.0-869.
iscsi: registered transport (tcp)
iscsi: registered transport (iser)
ip6_tables: (C) 2000-2006 Netfilter Core Team
process `sysctl' is using deprecated sysctl (syscall) net.ipv6.neigh.default.retrans_time; Use net.ipv6.neigh.default.retrans_time_ms instead.
eth0: link up, 100Mbps, full-duplex, lpa 0x41E1
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
scsi2 : iSCSI Initiator over TCP/IP
tun0: Disabled Privacy Extensions
tun1: Disabled Privacy Extensions
scsi 2:0:0:0: Direct-Access     IET      VIRTUAL-DISK     0    PQ: 0 ANSI: 4
sd 2:0:0:0: [sdb] 41943040 512-byte hardware sectors (21475 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 77 00 00 08
sd 2:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sdb] 41943040 512-byte hardware sectors (21475 MB)
sd 2:0:0:0: [sdb] Write Protect is off
sd 2:0:0:0: [sdb] Mode Sense: 77 00 00 08
sd 2:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 < sdb5 >
sd 2:0:0:0: [sdb] Attached SCSI disk
sd 2:0:0:0: Attached scsi generic sg1 type 0
scsi3 : iSCSI Initiator over TCP/IP
scsi 3:0:0:0: Direct-Access     IET      VIRTUAL-DISK     0    PQ: 0 ANSI: 4
sd 3:0:0:0: [sdc] 41943040 512-byte hardware sectors (21475 MB)
sd 3:0:0:0: [sdc] Write Protect is off
sd 3:0:0:0: [sdc] Mode Sense: 77 00 00 08
sd 3:0:0:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 3:0:0:0: [sdc] 41943040 512-byte hardware sectors (21475 MB)
sd 3:0:0:0: [sdc] Write Protect is off
sd 3:0:0:0: [sdc] Mode Sense: 77 00 00 08
sd 3:0:0:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdc: sdc1 < sdc5 >
sd 3:0:0:0: [sdc] Attached SCSI disk
sd 3:0:0:0: Attached scsi generic sg2 type 0
scsi4 : iSCSI Initiator over TCP/IP
device-mapper: multipath round-robin: version 1.0.0 loaded
scsi 4:0:0:0: Direct-Access     IET      VIRTUAL-DISK     0    PQ: 0 ANSI: 4
sd 4:0:0:0: [sdd] 262144 512-byte hardware sectors (134 MB)
sd 4:0:0:0: [sdd] Write Protect is off
sd 4:0:0:0: [sdd] Mode Sense: 77 00 00 08
sd 4:0:0:0: [sdd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 4:0:0:0: [sdd] 262144 512-byte hardware sectors (134 MB)
sd 4:0:0:0: [sdd] Write Protect is off
sd 4:0:0:0: [sdd] Mode Sense: 77 00 00 08
sd 4:0:0:0: [sdd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdd: unknown partition table
sd 4:0:0:0: [sdd] Attached SCSI disk
sd 4:0:0:0: Attached scsi generic sg3 type 0
scsi5 : iSCSI Initiator over TCP/IP
scsi 5:0:0:0: Direct-Access     IET      VIRTUAL-DISK     0    PQ: 0 ANSI: 4
sd 5:0:0:0: [sde] 262144 512-byte hardware sectors (134 MB)
sd 5:0:0:0: [sde] Write Protect is off
sd 5:0:0:0: [sde] Mode Sense: 77 00 00 08
sd 5:0:0:0: [sde] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 5:0:0:0: [sde] 262144 512-byte hardware sectors (134 MB)
sd 5:0:0:0: [sde] Write Protect is off
sd 5:0:0:0: [sde] Mode Sense: 77 00 00 08
sd 5:0:0:0: [sde] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sde: unknown partition table
sd 5:0:0:0: [sde] Attached SCSI disk
sd 5:0:0:0: Attached scsi generic sg4 type 0
scsi6 : iSCSI Initiator over TCP/IP
eth0: no IPv6 routers present
scsi 6:0:0:0: Direct-Access     IET      VIRTUAL-DISK     0    PQ: 0 ANSI: 4
sd 6:0:0:0: [sdf] 41943040 512-byte hardware sectors (21475 MB)
sd 6:0:0:0: [sdf] Write Protect is off
sd 6:0:0:0: [sdf] Mode Sense: 77 00 00 08
sd 6:0:0:0: [sdf] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 6:0:0:0: [sdf] 41943040 512-byte hardware sectors (21475 MB)
sd 6:0:0:0: [sdf] Write Protect is off
sd 6:0:0:0: [sdf] Mode Sense: 77 00 00 08
sd 6:0:0:0: [sdf] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sdf: unknown partition table
sd 6:0:0:0: [sdf] Attached SCSI disk
sd 6:0:0:0: Attached scsi generic sg5 type 0
warning: `named' uses 32-bit capabilities (legacy support in use)
md: md0 stopped.
md: bind<dm-17>
md: bind<dm-11>
md: raid1 personality registered for level 1
raid1: raid set md0 active with 2 out of 2 mirrors
kjournald starting.  Commit interval 5 seconds
EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
EXT3 FS on md0, internal journal
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.9
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period
Bridge firewalling registered
virbr0: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
ip_tables: (C) 2000-2006 Netfilter Core Team
------------[ cut here ]------------
kernel BUG at fs/locks.c:2051!
invalid opcode: 0000 [1] SMP 
CPU 1 
Modules linked in: ipt_REJECT iptable_filter ip_tables bridge nfsd auth_rpcgss exportfs autofs4 hidp nfs lockd nfs_acl rfcomm l2cap bluetooth sunrpc raid1 dm_round_robin tun ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables x_tables ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi scsi_transport_iscsi cpufreq_ondemand acpi_cpufreq ipv6 dm_multipath sbs sbshc battery acpi_memhotplug ac lp sg floppy ide_cd_mod cdrom serio_raw snd_hda_intel parport_pc snd_seq_dummy snd_seq_oss button parport snd_seq_midi_event snd_seq snd_seq_device 8139too 8139cp snd_pcm_oss i2c_i801 mii snd_mixer_oss snd_pcm i2c_core snd_timer snd pcspkr soundcore shpchp snd_page_alloc dm_snapshot dm_zero dm_mirror dm_mod ata_piix libata sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd [last unloaded: microcode]
Pid: 4763, comm: python Not tainted 2.6.25.3 #1
RIP: 0010:[<ffffffff80299f5d>]  [<ffffffff80299f5d>] locks_remove_flock+0xe2/0x102
RSP: 0018:ffff81000d1dfe38  EFLAGS: 00010246
RAX: 0000000000000081 RBX: ffff81000d31d2e8 RCX: ffff81001cc638c0
RDX: ffff81000f4101c0 RSI: 0000000000000286 RDI: ffffffff80580dc0
RBP: ffff810011232140 R08: ffff81001747aac0 R09: ffff81000d1dfb00
R10: 0000000000000004 R11: 000000200000001f R12: ffff81000d31d1e8
R13: ffff81000d31d1e8 R14: ffff81001ac4c680 R15: ffff81000df68220
FS:  00000000421e6940(0063) GS:ffff81001d979840(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000003335ebfe80 CR3: 000000000ee12000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process python (pid: 4763, threadinfo ffff81000d1de000, task ffff81000f4101c0)
Stack:  0000000000000000 0000000000000000 0000000000000000 0000000000000000
 0000000000000000 ffff810011232140 0000000000001299 0000000000000000
 0000000000000000 0000000000000000 0000000000000000 ffff810011232140
Call Trace:
 [<ffffffff8028d229>] ? __fput+0x97/0x17e
 [<ffffffff80297692>] ? sys_fcntl+0x2eb/0x2f7
 [<ffffffff8020be19>] ? tracesys+0xdc/0xe1


Code: 48 39 68 58 75 29 0f b6 40 60 a8 02 74 0a 48 89 df e8 5f fe ff ff eb 1a a8 20 74 0f be 02 00 00 00 48 89 df e8 e9 fe ff ff eb 07 <0f> 0b eb fe 48 89 c3 48 8b 03 48 85 c0 75 c6 e8 97 9d 1d 00 48 
RIP  [<ffffffff80299f5d>] locks_remove_flock+0xe2/0x102
 RSP <ffff81000d1dfe38>
---[ end trace e4d79afa854e3611 ]---
------------[ cut here ]------------
kernel BUG at fs/locks.c:2051!
invalid opcode: 0000 [2] SMP 
CPU 0 
Modules linked in: ipt_REJECT iptable_filter ip_tables bridge nfsd auth_rpcgss exportfs autofs4 hidp nfs lockd nfs_acl rfcomm l2cap bluetooth sunrpc raid1 dm_round_robin tun ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables x_tables ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi scsi_transport_iscsi cpufreq_ondemand acpi_cpufreq ipv6 dm_multipath sbs sbshc battery acpi_memhotplug ac lp sg floppy ide_cd_mod cdrom serio_raw snd_hda_intel parport_pc snd_seq_dummy snd_seq_oss button parport snd_seq_midi_event snd_seq snd_seq_device 8139too 8139cp snd_pcm_oss i2c_i801 mii snd_mixer_oss snd_pcm i2c_core snd_timer snd pcspkr soundcore shpchp snd_page_alloc dm_snapshot dm_zero dm_mirror dm_mod ata_piix libata sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd [last unloaded: microcode]
Pid: 4825, comm: python Tainted: G      D  2.6.25.3 #1
RIP: 0010:[<ffffffff80299f5d>]  [<ffffffff80299f5d>] locks_remove_flock+0xe2/0x102
RSP: 0018:ffff8100105e9e38  EFLAGS: 00010246
RAX: 0000000000000081 RBX: ffff81000ece76c0 RCX: ffff81001b8aa7c0
RDX: ffff8100121ec9b0 RSI: 0000000000000282 RDI: ffffffff80580dc0
RBP: ffff81000ef73780 R08: ffff81001747aac0 R09: ffff8100105e9b00
R10: 0000000000000007 R11: 0000000000000000 R12: ffff81000ece75c0
R13: ffff81000ece75c0 R14: ffff81001ac4c680 R15: ffff81001a0a2080
FS:  0000000042885940(0063) GS:ffffffff805b9000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007fb683bdf000 CR3: 00000000101c3000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process python (pid: 4825, threadinfo ffff8100105e8000, task ffff8100121ec9b0)
Stack:  0000000000000000 0000000000000000 0000000000000000 0000000000000000
 0000000000000000 ffff81000ef73780 00000000000012d6 0000000000000000
 0000000000000000 0000000000000000 0000000000000000 ffff81000ef73780
Call Trace:
 [<ffffffff8028d229>] ? __fput+0x97/0x17e
 [<ffffffff80297692>] ? sys_fcntl+0x2eb/0x2f7
 [<ffffffff8020be19>] ? tracesys+0xdc/0xe1


Code: 48 39 68 58 75 29 0f b6 40 60 a8 02 74 0a 48 89 df e8 5f fe ff ff eb 1a a8 20 74 0f be 02 00 00 00 48 89 df e8 e9 fe ff ff eb 07 <0f> 0b eb fe 48 89 c3 48 8b 03 48 85 c0 75 c6 e8 97 9d 1d 00 48 
RIP  [<ffffffff80299f5d>] locks_remove_flock+0xe2/0x102
 RSP <ffff8100105e9e38>
---[ end trace e4d79afa854e3611 ]---
------------[ cut here ]------------
kernel BUG at fs/locks.c:2051!
invalid opcode: 0000 [3] SMP 
CPU 1 
Modules linked in: ipt_REJECT iptable_filter ip_tables bridge nfsd auth_rpcgss exportfs autofs4 hidp nfs lockd nfs_acl rfcomm l2cap bluetooth sunrpc raid1 dm_round_robin tun ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables x_tables ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi scsi_transport_iscsi cpufreq_ondemand acpi_cpufreq ipv6 dm_multipath sbs sbshc battery acpi_memhotplug ac lp sg floppy ide_cd_mod cdrom serio_raw snd_hda_intel parport_pc snd_seq_dummy snd_seq_oss button parport snd_seq_midi_event snd_seq snd_seq_device 8139too 8139cp snd_pcm_oss i2c_i801 mii snd_mixer_oss snd_pcm i2c_core snd_timer snd pcspkr soundcore shpchp snd_page_alloc dm_snapshot dm_zero dm_mirror dm_mod ata_piix libata sd_mod scsi_mod ext3 jbd ehci_hcd ohci_hcd uhci_hcd [last unloaded: microcode]
Pid: 4838, comm: python Tainted: G      D  2.6.25.3 #1
RIP: 0010:[<ffffffff80299f5d>]  [<ffffffff80299f5d>] locks_remove_flock+0xe2/0x102
RSP: 0018:ffff81001026fe38  EFLAGS: 00010246
RAX: 0000000000000081 RBX: ffff81000d323a98 RCX: ffff8100125d23c0
RDX: ffff8100121ec9b0 RSI: 0000000000000286 RDI: ffffffff80580dc0
RBP: ffff81000ef58e40 R08: ffff81001747aac0 R09: ffff81001026fb00
R10: 0000000000000006 R11: 0000000000000000 R12: ffff81000d323998
R13: ffff81000d323998 R14: ffff81001ac4c680 R15: ffff81001a0a28a0
FS:  00000000418f2940(0063) GS:ffff81001d979840(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f70a3472830 CR3: 0000000002eb3000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process python (pid: 4838, threadinfo ffff81001026e000, task ffff8100121ec9b0)
Stack:  0000000000000000 0000000000000000 0000000000000000 0000000000000000
 0000000000000000 ffff81000ef58e40 00000000000012e3 0000000000000000
 0000000000000000 0000000000000000 0000000000000000 ffff81000ef58e40
Call Trace:
 [<ffffffff8028d229>] ? __fput+0x97/0x17e
 [<ffffffff80297692>] ? sys_fcntl+0x2eb/0x2f7
 [<ffffffff8020be19>] ? tracesys+0xdc/0xe1


Code: 48 39 68 58 75 29 0f b6 40 60 a8 02 74 0a 48 89 df e8 5f fe ff ff eb 1a a8 20 74 0f be 02 00 00 00 48 89 df e8 e9 fe ff ff eb 07 <0f> 0b eb fe 48 89 c3 48 8b 03 48 85 c0 75 c6 e8 97 9d 1d 00 48 
RIP  [<ffffffff80299f5d>] locks_remove_flock+0xe2/0x102
 RSP <ffff81001026fe38>
---[ end trace e4d79afa854e3611 ]---

--------------070309070106090408080304--
