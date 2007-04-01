Return-Path: <linux-kernel-owner+w=401wt.eu-S965194AbXDAWjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965194AbXDAWjY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 18:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965225AbXDAWjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 18:39:24 -0400
Received: from wx-out-0506.google.com ([66.249.82.239]:25230 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965194AbXDAWjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 18:39:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=R2xU7k/HiD2KeFbZDsZpNKyuhZDB4gPbSlh5ZK/ikAUsHtDbQFeQyoS55ozt/jmMp7Me6Sa+plWiAewhZvzPAr0c7X2EgPFPNNoybGobEHz8xRqvLE/cc84lWndPRiJQFpRhEqH8yA//fHgRkHYGmTHB2LADVKX0niVecSoS5xY=
Message-ID: <a71293c20704011539ob1a86cbr7af70e37d678b1a6@mail.gmail.com>
Date: Sun, 1 Apr 2007 18:39:21 -0400
From: "Stephen Evanchik" <evanchsa@gmail.com>
To: linux-kernel@vger.kernel.org, "Jeff Garzik" <jgarzik@pobox.com>
Subject: AHCI exception, ext3 journal aborted on a VIA K8M890 / VT8251
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

I have had a lot trouble with my AHCI controller from kernel version
2.6.19-rc1 to 2.6.21-rc5. The device is detected but the disks never
spinup and thus the rootfs is never found.

I finally was able to get Fedora's 2.6.20 and my 2.6.21-rc5 to boot
with pci=nomsi but I have been getting ext3 errors because the SATA
controller seems to die. It has happened 3 times today and has never
happened with my previous 2.6.18 kernel. The last time it happened I
was rsync'ing about 3GB of files at 30KB/sec and I was away from the
keyboard, LCD off etc. The first time it happened was after my daily
crons jobs run which are very disk intensive and I was again away from
the keyboard. The second time was during another rsync at 30KB/sec I
believe I was browsing the web but can't really be certain.

The error seems to occur when the machine is not idle; usually when I
am uploading a lot of files or scanning the disk (i.e. find / ). I
can't be certain of the trigger so any help isolating it would be
appreciated. I have stripped out any non-free modules (VMware and
fglrx) and am in the process of compiling a vanilla 2.6.20 kernel in
order to exclude any Fedora-isms.

My hardware components are the following:

Motherboard: A8V-VM Socket 939 VIA K8M890 / VT8251
CPU: Opteron 165 dual core
Harddisk: SATA 1.5Gbps WD 160GB drive

Most relevant snippet from dmesg, (you can see a longer version below):

ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata1.00: cmd ca/00:08:c5:b6:03/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 out
        res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1: soft resetting port
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: qc timeout (cmd 0xec)
ata1.00: failed to IDENTIFY (I/O error, err_mask=0x104)
ata1.00: revalidation failed (errno=-5)
ata1: failed to recover some devices, retrying in 5 secs
ata1: hard resetting port


What other information can I provide that would be helpful?


Thanks,
Stephen


==============


* uname -a
  Linux small 2.6.20-1.2307.fc5smp #1 SMP Sun Mar 18 21:02:16 EDT 2007
i686 athlon i386 GNU/Linux

* Kernel commmand line
  ro root=/dev/VolGroup00/LogVol00 rhgb quiet selinux=0 pci=nomsi

* /sbin/lsmod

Module                  Size  Used by
fuse                   46805  2
nfsd                  208561  17
exportfs                9921  1 nfsd
lockd                  62921  2 nfsd
nfs_acl                 7745  1 nfsd
autofs4                24517  1
hidp                   23745  2
l2cap                  30785  5 hidp
bluetooth              58149  2 hidp,l2cap
sunrpc                153853  12 nfsd,lockd,nfs_acl
ipt_REJECT              8769  1
nf_conntrack_ipv4      21837  5
xt_state                6721  5
nf_conntrack           62665  2 nf_conntrack_ipv4,xt_state
nfnetlink              11097  2 nf_conntrack_ipv4,nf_conntrack
xt_tcpudp               7361  6
iptable_filter          7233  1
ip_tables              16517  1 iptable_filter
x_tables               19013  4 ipt_REJECT,xt_state,xt_tcpudp,ip_tables
loop                   20297  0
video                  20037  0
sbs                    19201  0
i2c_ec                  9153  1 sbs
dock                   14233  0
button                 11985  0
battery                14021  0
asus_acpi              20573  0
backlight              10433  1 asus_acpi
ac                      9285  0
ipv6                  275585  18
lp                     16521  0
parport_pc             30309  0
parport                38793  2 lp,parport_pc
cdc_acm                19169  0
snd_emu10k1           114657  1
snd_rawmidi            27073  1 snd_emu10k1
snd_ac97_codec         93541  1 snd_emu10k1
ac97_bus                6593  1 snd_ac97_codec
snd_seq_dummy           8005  0
snd_seq_oss            33857  0
snd_seq_midi_event     11329  1 snd_seq_oss
snd_seq                51505  5 snd_seq_dummy,snd_seq_oss,snd_seq_midi_event
snd_pcm_oss            43873  0
snd_mixer_oss          19649  1 snd_pcm_oss
snd_pcm                75461  3 snd_emu10k1,snd_ac97_codec,snd_pcm_oss
snd_seq_device         11981  5
snd_emu10k1,snd_rawmidi,snd_seq_dummy,snd_seq_oss,snd_seq
snd_timer              25413  3 snd_emu10k1,snd_seq,snd_pcm
snd_page_alloc         14153  2 snd_emu10k1,snd_pcm
snd_util_mem            8897  1 snd_emu10k1
snd_hwdep              12997  1 snd_emu10k1
ehci_hcd               34901  0
sg                     37341  0
i2c_viapro             12885  0
emu10k1_gp              8129  0
snd                    53957  13
snd_emu10k1,snd_rawmidi,snd_ac97_codec,snd_seq_oss,snd_seq,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_seq_device,snd_timer,snd_hwdep
uhci_hcd               27089  0
k8temp                  9665  0
via_rhine              28877  0
gameport               19529  2 emu10k1_gp
soundcore              11937  1 snd
hwmon                   7621  1 k8temp
serio_raw              11077  0
i2c_core               25153  2 i2c_ec,i2c_viapro
k8_edac                18689  0
mii                     9537  1 via_rhine
edac_mc                25929  1 k8_edac
pcspkr                  7361  0
dm_snapshot            20849  0
dm_zero                 6209  0
dm_mirror              25301  0
dm_mod                 58253  8 dm_snapshot,dm_zero,dm_mirror
ahci                   25541  2
libata                104793  1 ahci
sd_mod                 24129  3
scsi_mod              138221  4 sg,ahci,libata,sd_mod
ext3                  126025  2
jbd                    60777  1 ext3


* Full error log

ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata1.00: cmd ca/00:08:c5:b6:03/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 out
        res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1: soft resetting port
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: qc timeout (cmd 0xec)
ata1.00: failed to IDENTIFY (I/O error, err_mask=0x104)
ata1.00: revalidation failed (errno=-5)
ata1: failed to recover some devices, retrying in 5 secs
ata1: hard resetting port
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: qc timeout (cmd 0xec)
ata1.00: failed to IDENTIFY (I/O error, err_mask=0x104)
ata1.00: revalidation failed (errno=-5)
ata1: failed to recover some devices, retrying in 5 secs
ata1: hard resetting port
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: qc timeout (cmd 0xec)
ata1.00: failed to IDENTIFY (I/O error, err_mask=0x104)
ata1.00: revalidation failed (errno=-5)
ata1.00: disabled
ata1: EH complete
sd 0:0:0:0: SCSI error: return code = 0x00040000
end_request: I/O error, dev sda, sector 243397
Buffer I/O error on device dm-0, logical block 4271
lost page write due to I/O error on dm-0
Aborting journal on device dm-0.
sd 0:0:0:0: SCSI error: return code = 0x00040000
end_request: I/O error, dev sda, sector 112310605
sd 0:0:0:0: SCSI error: return code = 0x00040000
end_request: I/O error, dev sda, sector 112310861
sd 0:0:0:0: SCSI error: return code = 0x00040000
end_request: I/O error, dev sda, sector 178467397
Buffer I/O error on device dm-0, logical block 22282271
lost page write due to I/O error on dm-0
sd 0:0:0:0: SCSI error: return code = 0x00040000
end_request: I/O error, dev sda, sector 200427245
Buffer I/O error on device dm-0, logical block 25027252
lost page write due to I/O error on dm-0
Buffer I/O error on device dm-0, logical block 25027253
lost page write due to I/O error on dm-0
Buffer I/O error on device dm-0, logical block 25027254
lost page write due to I/O error on dm-0
sd 0:0:0:0: SCSI error: return code = 0x00040000
end_request: I/O error, dev sda, sector 263139949
Buffer I/O error on device dm-0, logical block 32866340
lost page write due to I/O error on dm-0
sd 0:0:0:0: SCSI error: return code = 0x00040000
end_request: I/O error, dev sda, sector 263140573
Buffer I/O error on device dm-0, logical block 32866418
lost page write due to I/O error on dm-0
sd 0:0:0:0: SCSI error: return code = 0x00040000
end_request: I/O error, dev sda, sector 263141469
Buffer I/O error on device dm-0, logical block 32866530
lost page write due to I/O error on dm-0
sd 0:0:0:0: SCSI error: return code = 0x00040000
end_request: I/O error, dev sda, sector 98513277
Buffer I/O error on device dm-0, logical block 12288006
lost page write due to I/O error on dm-0
sd 0:0:0:0: SCSI error: return code = 0x00040000
EXT3-fs error (device dm-0) in ext3_reserve_inode_write: Journal has aborted
end_request: I/O error, dev sda, sector 98595781
Buffer I/O error on device dm-0, logical block 12298319
lost page write due to I/O error on dm-0
sd 0:0:0:0: SCSI error: return code = 0x00040000
end_request: I/O error, dev sda, sector 112310605
ext3_abort called.
EXT3-fs error (device dm-0): ext3_journal_start_sb: Detected aborted journal
Remounting filesystem read-only
sd 0:0:0:0: SCSI error: return code = 0x00040000
end_request: I/O error, dev sda, sector 209229
sd 0:0:0:0: SCSI error: return code = 0x00040000
end_request: I/O error, dev sda, sector 112310605
sd 0:0:0:0: SCSI error: return code = 0x00040000
end_request: I/O error, dev sda, sector 200427245
journal commit I/O error
sd 0:0:0:0: SCSI error: return code = 0x00040000
end_request: I/O error, dev sda, sector 112310861
sd 0:0:0:0: SCSI error: return code = 0x00040000
end_request: I/O error, dev sda, sector 112311373
sd 0:0:0:0: SCSI error: return code = 0x00040000
end_request: I/O error, dev sda, sector 112311885
sd 0:0:0:0: SCSI error: return code = 0x00040000
end_request: I/O error, dev sda, sector 112110789


* dmesg

Linux version 2.6.20-1.2307.fc5smp
(brewbuilder@hs20-bc1-6.build.redhat.com) (gcc version 4.1.1 20070105
(Red Hat 4.1.1-51)) #1 SMP Sun Mar 18 21:02:16 EDT 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 000000000009fc00 end:
000000000009fc00 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000000009fc00 size: 0000000000000400 end:
00000000000a0000 type: 2
copy_e820_map() start: 00000000000e4000 size: 000000000001c000 end:
0000000000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 000000007feb0000 end:
000000007ffb0000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000007ffb0000 size: 000000000000e000 end:
000000007ffbe000 type: 3
copy_e820_map() start: 000000007ffbe000 size: 0000000000022000 end:
000000007ffe0000 type: 4
copy_e820_map() start: 000000007ffe0000 size: 0000000000020000 end:
0000000080000000 type: 2
copy_e820_map() start: 00000000fec00000 size: 0000000000001000 end:
00000000fec01000 type: 2
copy_e820_map() start: 00000000fecc0000 size: 0000000000001000 end:
00000000fecc1000 type: 2
copy_e820_map() start: 00000000ff780000 size: 0000000000880000 end:
0000000100000000 type: 2
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007ffb0000 (usable)
 BIOS-e820: 000000007ffb0000 - 000000007ffbe000 (ACPI data)
 BIOS-e820: 000000007ffbe000 - 000000007ffe0000 (ACPI NVS)
 BIOS-e820: 000000007ffe0000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fecc0000 - 00000000fecc1000 (reserved)
 BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)
1151MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000ff780
NX (Execute Disable) protection: active
Entering add_active_range(0, 0, 524208) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   524208
early_node_map[1] active PFN ranges
    0:        0 ->   524208
On node 0 totalpages: 524208
  DMA zone: 40 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4056 pages, LIFO batch:0
  Normal zone: 2200 pages used for memmap
  Normal zone: 223080 pages, LIFO batch:31
  HighMem zone: 2879 pages used for memmap
  HighMem zone: 291953 pages, LIFO batch:31
DMI 2.3 present.
Using APIC driver default
ACPI: RSDP (v002 ACPIAM                                ) @ 0x000fa850
ACPI: XSDT (v001 A M I  OEMXSDT  0x06000619 MSFT 0x00000097) @ 0x7ffb0100
ACPI: FADT (v003 A M I  OEMFACP  0x06000619 MSFT 0x00000097) @ 0x7ffb0290
ACPI: MADT (v001 A M I  OEMAPIC  0x06000619 MSFT 0x00000097) @ 0x7ffb0390
ACPI: MCFG (v001 A M I  OEMMCFG  0x06000619 MSFT 0x00000097) @ 0x7ffb0400
ACPI: OEMB (v001 A M I  AMI_OEM  0x06000619 MSFT 0x00000097) @ 0x7ffbe040
ACPI: DSDT (v001  A0339 A0339000 0x00000000 INTL 0x02002026) @ 0x00000000
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 15:3 APIC version 16
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1 15:3 APIC version 16
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 3, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x03] address[0xfecc0000] gsi_base[24])
IOAPIC[1]: apic_id 3, version 3, address 0xfecc0000, GSI 24-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 2 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 88000000 (gap: 80000000:7ec00000)
Detected 1800.236 MHz processor.
Built 1 zonelists.  Total pages: 519089
Kernel command line: ro root=/dev/VolGroup00/LogVol00 rhgb quiet
selinux=0 pci=nomsi
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
mapped IOAPIC to ffffb000 (fecc0000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c076d000 soft=c074d000
PID hash table entries: 4096 (order: 12, 16384 bytes)
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 2068256k/2096832k available (2181k kernel code, 27368k
reserved, 915k data, 240k init, 1179328k highmem)
virtual kernel memory layout:
    fixmap  : 0xffc56000 - 0xfffff000   (3748 kB)
    pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
    vmalloc : 0xf8800000 - 0xff9fe000   ( 113 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc070c000 - 0xc0748000   ( 240 kB)
      .data : 0xc0621575 - 0xc0706494   ( 915 kB)
      .text : 0xc0400000 - 0xc0621575   (2181 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 3601.63 BogoMIPS (lpj=1800818)
Security Framework v1.0.0 initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 178bfbff e3d3fbff 00000000 00000000
00000001 00000000 00000003
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0(2) -> Core 0
CPU: After all inits, caps: 178bfbff e3d3fbff 00000000 00000410
00000001 00000000 00000003
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
ACPI: Core revision 20060707
CPU0: AMD Dual Core AMD Opteron(tm) Processor 165 stepping 02
SMP alternatives: switching to SMP code
Booting processor 1/1 eip 3000
CPU 1 irqstacks, hard=c076e000 soft=c074e000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3599.65 BogoMIPS (lpj=1799827)
CPU: After generic identify, caps: 178bfbff e3d3fbff 00000000 00000000
00000001 00000000 00000003
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 1(2) -> Core 1
CPU: After all inits, caps: 178bfbff e3d3fbff 00000000 00000410
00000001 00000000 00000003
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: AMD Dual Core AMD Opteron(tm) Processor 165 stepping 02
Total of 2 processors activated (7201.29 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=0 pin2=0
checking TSC synchronization across 2 CPUs:
CPU#0 had -84 usecs TSC skew, fixed it up.
CPU#1 had 84 usecs TSC skew, fixed it up.
Brought up 2 CPUs
sizeof(vma)=88 bytes
sizeof(page)=40 bytes
sizeof(inode)=420 bytes
sizeof(dentry)=144 bytes
sizeof(ext3inode)=596 bytes
sizeof(buffer_head)=56 bytes
sizeof(skbuff)=176 bytes
sizeof(task_struct)=1424 bytes
migration_cost=345
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
PCI: Not using MMCONFIG.
PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=5
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
0000:00:0f.1: cannot adjust BAR0 (not I/O)
0000:00:0f.1: cannot adjust BAR1 (not I/O)
0000:00:0f.1: cannot adjust BAR2 (not I/O)
0000:00:0f.1: cannot adjust BAR3 (not I/O)
Boot video device is 0000:02:00.0
PCI: Transparent bridge - 0000:00:13.1
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NBPG._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PA._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11 12 14 *15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *10 11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 11 devices
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
pnp: 00:05: ioport range 0x290-0x297 has been reserved
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:02.0
  IO window: d000-dfff
  MEM window: fbf00000-fbffffff
  PREFETCH window: d0000000-dfffffff
PCI: Bridge: 0000:00:13.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:13.1
  IO window: e000-efff
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:01.0 to 64
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 27 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:02.0 to 64
PCI: Setting latency timer of device 0000:00:13.0 to 64
PCI: Setting latency timer of device 0000:00:13.1 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 9, 2621440 bytes)
TCP bind hash table entries: 65536 (order: 8, 1310720 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 1830k freed
apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
apm: disabled - APM is not SMP safe.
audit: initializing netlink socket (disabled)
audit(1175464944.811:1): initialized
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
ksign: Installing public key data
Loading keyring
- Added public key D81E1D1A80E5E114
- User ID: Red Hat, Inc. (Kernel Module GPG key)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: Setting latency timer of device 0000:00:02.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:02.0:pcie00]
Allocate Port Service[0000:00:02.0:pcie02]
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU1] (supports 16 throttling states)
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Linux agpgart interface v0.101 (c) Dave Jones
agpgart: Detected AGP bridge 0
agpgart: AGP aperture is 128M @ 0xf0000000
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:08: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 16384K size 4096 blocksize
input: Macintosh mouse button emulation as /class/input/input0
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
VP_IDE: IDE controller at PCI slot 0000:00:0f.1
VP_IDE: chipset revision 7
VP_IDE: not 100% native mode: will probe irqs later
VP_IDE: VIA vt8251 (rev 00) IDE UDMA133 controller on pci0000:00:0f.1
    ide0: BM-DMA at 0xfc00-0xfc07, BIOS settings: hda:pio, hdb:pio
Probing IDE interface ide0...
Probing IDE interface ide0...
Probing IDE interface ide1...
ide-floppy driver 0.99.newide
usbcore: registered new interface driver libusual
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
TCP bic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
powernow-k8: Found 2 Dual Core AMD Opteron(tm) Processor 165
processors (version 2.00.00)
powernow-k8:    0 : fid 0xa (1800 MHz), vid 0x8
powernow-k8:    1 : fid 0x2 (1000 MHz), vid 0x12
Using IPI No-Shortcut mode
ACPI: (supports S0 S1 S3 S4 S5)
Freeing unused kernel memory: 240k freed
Write protecting the kernel read-only data: 597k
Time: acpi_pm clocksource has been installed.
SCSI subsystem initialized
libata version 2.00 loaded.
ahci 0000:00:0f.0: version 2.0
ACPI: PCI Interrupt 0000:00:0f.0[B] -> GSI 21 (level, low) -> IRQ 17
ahci 0000:00:0f.0: AHCI 0001.0000 32 slots 4 ports 3 Gbps 0xf impl SATA mode
ahci 0000:00:0f.0: flags: 64bit ncq pm led clo pmp pio slum part
ata1: SATA max UDMA/133 cmd 0xF8806D00 ctl 0x0 bmdma 0x0 irq 17
ata2: SATA max UDMA/133 cmd 0xF8806D80 ctl 0x0 bmdma 0x0 irq 17
ata3: SATA max UDMA/133 cmd 0xF8806E00 ctl 0x0 bmdma 0x0 irq 17
ata4: SATA max UDMA/133 cmd 0xF8806E80 ctl 0x0 bmdma 0x0 irq 17
scsi0 : ahci
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-6, max UDMA/100, 312581808 sectors: LBA48
ata1.00: ata1: dev 0 multi count 16
ata1.00: applying bridge limits
ata1.00: configured for UDMA/100
scsi1 : ahci
ata2: SATA link down (SStatus 0 SControl 300)
scsi2 : ahci
ata3: SATA link down (SStatus 0 SControl 300)
scsi3 : ahci
ata4: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JD-00F 02.0 PQ: 0 ANSI: 5
SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sda: sda1 sda2
sd 0:0:0:0: Attached scsi disk sda
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
input: PC Speaker as /class/input/input1
EDAC MC: Ver: 2.0.1 Mar 18 2007
EDAC MC0: Giving out device to k8_edac Athlon64/Opteron: DEV 0000:00:18.2
via-rhine.c:v1.10-LK1.4.2 Sept-11-2006 Written by Donald Becker
ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 23 (level, low) -> IRQ 18
eth0: VIA Rhine II at 0xfbeff400, 00:18:f3:02:37:08, IRQ 18.
eth0: MII PHY found at address 1, status 0x786d advertising 01e1 Link 45e1.
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:10.0[A] -> GSI 20 (level, low) -> IRQ 19
uhci_hcd 0000:00:10.0: UHCI Host Controller
uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:10.0: irq 19, io base 0x0000b000
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:10.1[C] -> GSI 22 (level, low) -> IRQ 20
uhci_hcd 0000:00:10.1: UHCI Host Controller
uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:10.1: irq 20, io base 0x0000a800
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:10.2[B] -> GSI 21 (level, low) -> IRQ 17
uhci_hcd 0000:00:10.2: UHCI Host Controller
uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:10.2: irq 17, io base 0x0000a400
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
sd 0:0:0:0: Attached scsi generic sg0 type 0
ACPI: PCI Interrupt 0000:00:10.3[D] -> GSI 23 (level, low) -> IRQ 18
uhci_hcd 0000:00:10.3: UHCI Host Controller
uhci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:10.3: irq 18, io base 0x0000a000
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:10.4[C] -> GSI 22 (level, low) -> IRQ 20
ehci_hcd 0000:00:10.4: EHCI Host Controller
ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 5
ehci_hcd 0000:00:10.4: debug port 1
ehci_hcd 0000:00:10.4: irq 20, io mem 0xfbeff800
ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 8 ports detected
gameport: EMU10K1 is pci0000:05:09.1/gameport0, io 0xe400, speed 962kHz
ACPI: PCI Interrupt 0000:05:09.0[A] -> GSI 17 (level, low) -> IRQ 21
usb 5-4: new high speed USB device using ehci_hcd and address 3
usb 5-4: configuration #1 chosen from 1 choice
hub 5-4:1.0: USB hub found
hub 5-4:1.0: 7 ports detected
usb 2-1: new full speed USB device using uhci_hcd and address 2
usb 2-1: configuration #1 chosen from 1 choice
hub 2-1:1.0: USB hub found
hub 2-1:1.0: 3 ports detected
usb 5-4.2: new full speed USB device using ehci_hcd and address 4
usb 5-4.2: configuration #1 chosen from 2 choices
usb 2-1.1: new low speed USB device using uhci_hcd and address 3
usb 2-1.1: configuration #1 chosen from 1 choice
input: LOGITECH USB Keyboard as /class/input/input2
input: USB HID v1.10 Keyboard [LOGITECH USB Keyboard] on usb-0000:00:10.1-1.1
input: LOGITECH USB Keyboard as /class/input/input3
input: USB HID v1.10 Device [LOGITECH USB Keyboard] on usb-0000:00:10.1-1.1
usb 2-1.3: new low speed USB device using uhci_hcd and address 4
usb 2-1.3: configuration #1 chosen from 1 choice
input: Logitech USB Receiver as /class/input/input4
input: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:10.1-1.3
cdc_acm 5-4.2:1.0: ttyACM0: USB ACM device
usbcore: registered new interface driver cdc_acm
drivers/usb/class/cdc-acm.c: v0.25:USB Abstract Control Model driver
for USB modems and ISDN adapters
floppy0: no floppy controllers found
lp: driver loaded but no devices found
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
Mobile IPv6
input: Power Button (FF) as /class/input/input5
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (CM) as /class/input/input6
ACPI: Sleep Button (CM) [SLPB]
input: Power Button (CM) as /class/input/input7
ACPI: Power Button (CM) [PWRB]
No dock devices found.
ibm_acpi: ec object not found
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
loop: loaded (max 8 devices)
EXT3 FS on dm-0, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 2129912k swap on /dev/VolGroup00/LogVol01.  Priority:-1
extents:1 across:2129912k
ip_tables: (C) 2000-2006 Netfilter Core Team
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (8192 buckets, 65536 max)
eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.8
Bluetooth: L2CAP socket layer initialized
Bluetooth: HIDP (Human Interface Emulation) ver 1.1
eth0: no IPv6 routers present
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period
eth0: no IPv6 routers present
