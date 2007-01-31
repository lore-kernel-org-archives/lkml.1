Return-Path: <linux-kernel-owner+w=401wt.eu-S933113AbXAaL5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113AbXAaL5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 06:57:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933115AbXAaL5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 06:57:09 -0500
Received: from mail2.qmul.ac.uk ([138.37.6.6]:49546 "EHLO mail2.qmul.ac.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933113AbXAaL5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 06:57:06 -0500
X-Greylist: delayed 5014 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Jan 2007 06:57:05 EST
Message-ID: <45C0708C.3000609@qmul.ac.uk>
Date: Wed, 31 Jan 2007 10:33:48 +0000
From: James Ray <j.ray@qmul.ac.uk>
User-Agent: Thunderbird 1.5.0.5 (X11/20060728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: ahci SATA with Intel ESB2 on 2.6.20-rc6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Sender-Host-Address: 138.37.8.35
X-QM-Scan-Virus: virusscan says the message is clean
X-QM-Scan-Virus: ClamAV says the message is clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

All,

	I have tried to follow
http://www.kernel.org/pub/linux/docs/lkml/reporting-bugs.html as closely
as possible below. Hope this helps someone pin-point the problem and
hopefully provide a fix. I am willing to try testing things out on this
system if its of any help.

[1.] One line summary of the problem:
	ACHI Driver is erroring on 2.6.20-rc6.

[2.] Full description of the problem/report:
	Been having problems with the AHCI driver for this new server for quite
some time now, it slowly seems to be getting better as the version
numbers increase (2.6.15 seemed fine, though I didn't test much,
2.6.1[7-8] was unusable, 2.6.20-rc6 seems nearly perfect) but I still
see some errors appearing on the system. I have swapped disks in the
system and I see the problem with 3 different systems (all identical)
and 3 different sets of disks.

[3.] Keywords (i.e., modules, networking, kernel):
	AHCI, SATA, kernel

[4.] Kernel version (from /proc/version):
	Linux version 2.6.20-rc6 (root@termite) (gcc version 4.1.1 20070105
(Red Hat 4.1.1-51)) #2 SMP Tue Jan 30 10:37:53 GMT 2007

[5.] Output of Oops.. message (if applicable) with symbolic information
     resolved (see Documentation/oops-tracing.txt)
	Didn't trigger an Oops.

[6.] A small shell script or example program which triggers the
     problem (if possible)
	Running bonnie++ seems to trigger the problem at times:
	 bonnie++ -d /mnt/test/ -s 4096:1024 -n 2000:20:10:2000 -m termite -r
2048 -u 0:0

[7.] Environment
[7.1.] Software (add the output of the ver_linux script here)
Linux termite 2.6.20-rc6 #2 SMP Tue Jan 30 10:37:53 GMT 2007 x86_64
x86_64 x86_64 GNU/Linux

Gnu C                  4.1.1
Gnu make               3.81
binutils               2.17.50.0.6-2.fc6
util-linux             2.13-pre7
mount                  2.13-pre7
module-init-tools      3.3-pre1
e2fsprogs              1.39
pcmciautils            014
quota-tools            3.13.
Linux C Library        > libc.2.5
Dynamic linker (ldd)   2.5
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.12
Sh-utils               5.97
udev                   095
Modules Loaded         autofs4 iptable_filter ip_tables ip6t_REJECT
xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 dm_multipath video
sbs i2c_ec dock button battery asus_acpi backlight ac parport_pc lp
parport ata_piix sg ide_cd i2c_i801 serio_raw cdrom i2c_core pcspkr
shpchp e1000 dm_snapshot dm_zero dm_mirror dm_mod ahci libata sd_mod
scsi_mod raid456 xor raid1 ext3 jbd ehci_hcd ohci_hcd uhci_hcd

[7.2.] Processor information (from /proc/cpuinfo):
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Xeon(R) CPU            5130  @ 2.00GHz
stepping        : 6
cpu MHz         : 1994.997
cache size      : 4096 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall
nx lm constant_tsc pni monitor ds_cpl vmx tm2 ssse3 cx16 xtpr dca lahf_lm
bogomips        : 3992.93
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Xeon(R) CPU            5130  @ 2.00GHz
stepping        : 6
cpu MHz         : 1994.997
cache size      : 4096 KB
physical id     : 3
siblings        : 2
core id         : 0
cpu cores       : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall
nx lm constant_tsc pni monitor ds_cpl vmx tm2 ssse3 cx16 xtpr dca lahf_lm
bogomips        : 3990.05
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 2
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Xeon(R) CPU            5130  @ 2.00GHz
stepping        : 6
cpu MHz         : 1994.997
cache size      : 4096 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall
nx lm constant_tsc pni monitor ds_cpl vmx tm2 ssse3 cx16 xtpr dca lahf_lm
bogomips        : 3990.07
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 3
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Xeon(R) CPU            5130  @ 2.00GHz
stepping        : 6
cpu MHz         : 1994.997
cache size      : 4096 KB
physical id     : 3
siblings        : 2
core id         : 1
cpu cores       : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall
nx lm constant_tsc pni monitor ds_cpl vmx tm2 ssse3 cx16 xtpr dca lahf_lm
bogomips        : 3990.01
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

[7.3.] Module information (from /proc/modules):
autofs4 32648 2 - Live 0xffffffff88264000
iptable_filter 11904 0 - Live 0xffffffff88260000
ip_tables 28904 1 iptable_filter, Live 0xffffffff88257000
ip6t_REJECT 14336 1 - Live 0xffffffff88252000
xt_tcpudp 12288 5 - Live 0xffffffff8824e000
ip6table_filter 11776 1 - Live 0xffffffff8824a000
ip6_tables 23496 1 ip6table_filter, Live 0xffffffff88243000
x_tables 29704 4 ip_tables,ip6t_REJECT,xt_tcpudp,ip6_tables, Live
0xffffffff8823a000
ipv6 331744 37 ip6t_REJECT, Live 0xffffffff881e8000
dm_multipath 28432 0 - Live 0xffffffff881e0000
video 26888 0 - Live 0xffffffff881d8000
sbs 25552 0 - Live 0xffffffff881d0000
i2c_ec 14208 1 sbs, Live 0xffffffff881cb000
dock 20000 0 - Live 0xffffffff881c5000
button 17440 0 - Live 0xffffffff881bf000
battery 19464 0 - Live 0xffffffff881b9000
asus_acpi 27308 0 - Live 0xffffffff881b1000
backlight 15872 1 asus_acpi, Live 0xffffffff881ac000
ac 14472 0 - Live 0xffffffff881a7000
parport_pc 38568 0 - Live 0xffffffff8819c000
lp 23376 0 - Live 0xffffffff88195000
parport 49676 2 parport_pc,lp, Live 0xffffffff88187000
ata_piix 25988 0 - Live 0xffffffff8817f000
sg 45736 0 - Live 0xffffffff88172000
ide_cd 49696 0 - Live 0xffffffff88164000
i2c_i801 17556 0 - Live 0xffffffff8815e000
serio_raw 16388 0 - Live 0xffffffff88158000
cdrom 44456 1 ide_cd, Live 0xffffffff8814c000
i2c_core 33024 2 i2c_ec,i2c_i801, Live 0xffffffff88142000
pcspkr 12160 0 - Live 0xffffffff8813e000
shpchp 43036 0 - Live 0xffffffff88130000
e1000 132160 0 - Live 0xffffffff8810c000
dm_snapshot 25712 0 - Live 0xffffffff88104000
dm_zero 10752 0 - Live 0xffffffff88100000
dm_mirror 31040 0 - Live 0xffffffff880f7000
dm_mod 70544 13 dm_multipath,dm_snapshot,dm_zero,dm_mirror, Live
0xffffffff880e4000
ahci 32260 8 - Live 0xffffffff880db000
libata 119712 2 ata_piix,ahci, Live 0xffffffff880bc000
sd_mod 30208 10 - Live 0xffffffff880b3000
scsi_mod 165080 4 sg,ahci,libata,sd_mod, Live 0xffffffff88089000
raid456 131104 0 - Live 0xffffffff88067000
xor 14224 1 raid456, Live 0xffffffff88062000
raid1 32384 4 - Live 0xffffffff88059000
ext3 142224 6 - Live 0xffffffff88035000
jbd 73968 1 ext3, Live 0xffffffff88021000
ehci_hcd 41484 0 - Live 0xffffffff88015000
ohci_hcd 29700 0 - Live 0xffffffff8800c000
uhci_hcd 33952 0 - Live 0xffffffff88002000

[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
[root@termite /]# cat /proc/ioports
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-006f : keyboard
0070-0077 : rtc
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:1f.1
01f0-01f7 : 0000:00:1f.1
  01f0-01f7 : ide0
02f8-02ff : serial
0376-0376 : 0000:00:1f.1
03c0-03df : vga+
03f6-03f6 : 0000:00:1f.1
  03f6-03f6 : ide0
03f8-03ff : serial
0400-0403 : ACPI PM1a_EVT_BLK
0404-0405 : ACPI PM1a_CNT_BLK
0408-040b : ACPI PM_TMR
0410-0415 : ACPI CPU throttle
0428-042f : ACPI GPE0_BLK
0500-053f : pnp 00:06
0800-087f : pnp 00:06
0cf8-0cff : PCI conf1
1000-1fff : PCI Bus #0c
  1000-10ff : 0000:0c:0c.0
2000-2fff : PCI Bus #01
  2000-2fff : PCI Bus #02
    2000-2fff : PCI Bus #05
      2000-201f : 0000:05:00.1
        2000-201f : e1000
      2020-203f : 0000:05:00.0
        2020-203f : e1000
3000-301f : 0000:00:1f.3
  3000-301f : i801_smbus
3020-303f : 0000:00:1f.2
  3020-303f : ahci
3040-305f : 0000:00:1d.3
  3040-305f : uhci_hcd
3060-307f : 0000:00:1d.2
  3060-307f : uhci_hcd
3080-309f : 0000:00:1d.1
  3080-309f : uhci_hcd
30a0-30bf : 0000:00:1d.0
  30a0-30bf : uhci_hcd
30c0-30cf : 0000:00:1f.1
  30c0-30c7 : ide0
  30c8-30cf : ide1
30d0-30d7 : 0000:00:1f.2
  30d0-30d7 : ahci
30d8-30df : 0000:00:1f.2
  30d8-30df : ahci
30f0-30f3 : 0000:00:1f.2
  30f0-30f3 : ahci
30f4-30f7 : 0000:00:1f.2
  30f4-30f7 : ahci
[root@termite /]# cat /proc/iomem
00000000-0009ebff : System RAM
  00000000-00000000 : Crash kernel
000a0000-000bffff : Video RAM area
000c0000-000c8fff : Video ROM
000cb000-000cbfff : Adapter ROM
000cc000-000ccfff : Adapter ROM
000f0000-000fffff : System ROM
00100000-7f91dfff : System RAM
  00200000-004570ff : Kernel code
  00457100-005bf17f : Kernel data
7f91e000-7f9cffff : ACPI Non-volatile Storage
7f9d0000-7fa41fff : System RAM
7fa42000-7fa99fff : reserved
7fa9a000-7fad3fff : System RAM
7fad4000-7fb19fff : ACPI Non-volatile Storage
7fb1a000-7fb2bfff : System RAM
7fb2c000-7fb39fff : ACPI Tables
7fb3a000-7fbfffff : System RAM
b0000000-b7ffffff : PCI Bus #0c
  b0000000-b7ffffff : 0000:0c:0c.0
b8000000-b89fffff : PCI Bus #01
  b8000000-b88fffff : PCI Bus #02
    b8000000-b88fffff : PCI Bus #05
      b8000000-b83fffff : 0000:05:00.1
        b8000000-b83fffff : e1000
      b8400000-b87fffff : 0000:05:00.0
        b8400000-b87fffff : e1000
      b8800000-b881ffff : 0000:05:00.1
        b8800000-b881ffff : e1000
      b8820000-b883ffff : 0000:05:00.0
        b8820000-b883ffff : e1000
b8a00000-b8afffff : PCI Bus #0c
  b8a00000-b8a0ffff : 0000:0c:0c.0
b8b00000-b8b003ff : 0000:00:1f.2
  b8b00000-b8b003ff : ahci
b8b00400-b8b007ff : 0000:00:1d.7
  b8b00400-b8b007ff : ehci_hcd
fe700000-fe7003ff : 0000:00:08.0
fec00000-fec00fff : IOAPIC 0
fec80000-fec80fff : IOAPIC 1
fed00000-fed003ff : HPET 0
fee00000-fee00fff : Local APIC
ffe00000-ffe0bfff : reserved
fffe0000-ffffffff : 0000:0c:0c.0

[7.5.] PCI information ('lspci -vvv' as root)
[root@termite /]# lspci -vvv
00:00.0 Host bridge: Intel Corporation 5000P Chipset Memory Controller
Hub (rev b1)
        Subsystem: Intel Corporation Unknown device 346c
        Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr+ Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 0
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Message Signalled Interrupts: 64bit-
Queue=0/1 Enable-
                Address: fee00000  Data: 0000
        Capabilities: [6c] Express Root Port (Slot-) IRQ 0
                Device: Supported: MaxPayload 256 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x4, ASPM L0s, Port 0
                Link: Latency L0s unlimited, L1 unlimited
                Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x4
                Root: Correctable+ Non-Fatal+ Fatal+ PME+

00:02.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x8
Port 2-3 (rev b1) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr+ Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=01, subordinate=06, sec-latency=0
        I/O behind bridge: 00002000-00002fff
        Memory behind bridge: b8000000-b89fffff
        Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Message Signalled Interrupts: 64bit-
Queue=0/1 Enable+
                Address: fee00000  Data: 4041
        Capabilities: [6c] Express Root Port (Slot-) IRQ 0
                Device: Supported: MaxPayload 256 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s, Port 2
                Link: Latency L0s unlimited, L1 unlimited
                Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x8
                Root: Correctable+ Non-Fatal+ Fatal+ PME+

00:03.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4
Port 3 (rev b1) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=07, subordinate=07, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Message Signalled Interrupts: 64bit-
Queue=0/1 Enable+
                Address: fee00000  Data: 4049
        Capabilities: [6c] Express Root Port (Slot-) IRQ 0
                Device: Supported: MaxPayload 256 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x4, ASPM L0s, Port 3
                Link: Latency L0s unlimited, L1 unlimited
                Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x0
                Root: Correctable- Non-Fatal- Fatal- PME-

00:04.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4
Port 4 (rev b1) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=08, subordinate=08, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Message Signalled Interrupts: 64bit-
Queue=0/1 Enable+
                Address: fee00000  Data: 4051
        Capabilities: [6c] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 256 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x4, ASPM L0s, Port 4
                Link: Latency L0s unlimited, L1 unlimited
                Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x4
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug-
Surpise-
                Slot: Number 6, PowerLimit 0.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
                Slot: AttnInd Off, PwrInd On, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-

00:05.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4
Port 5 (rev b1) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=09, subordinate=09, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Message Signalled Interrupts: 64bit-
Queue=0/1 Enable+
                Address: fee00000  Data: 4059
        Capabilities: [6c] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 256 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x4, ASPM L0s, Port 5
                Link: Latency L0s unlimited, L1 unlimited
                Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x4
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug-
Surpise-
                Slot: Number 6, PowerLimit 0.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
                Slot: AttnInd Off, PwrInd On, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-

00:06.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x8
Port 6-7 (rev b1) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=0a, subordinate=0a, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Message Signalled Interrupts: 64bit-
Queue=0/1 Enable+
                Address: fee00000  Data: 4061
        Capabilities: [6c] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 256 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s, Port 6
                Link: Latency L0s unlimited, L1 unlimited
                Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x4
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug-
Surpise-
                Slot: Number 6, PowerLimit 0.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
                Slot: AttnInd Off, PwrInd On, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-

00:07.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4
Port 7 (rev b1) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=0b, subordinate=0b, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Message Signalled Interrupts: 64bit-
Queue=0/1 Enable+
                Address: fee00000  Data: 4069
        Capabilities: [6c] Express Root Port (Slot-) IRQ 0
                Device: Supported: MaxPayload 256 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x4, ASPM L0s, Port 7
                Link: Latency L0s unlimited, L1 unlimited
                Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x0
                Root: Correctable- Non-Fatal- Fatal- PME-

00:08.0 System peripheral: Intel Corporation 5000 Series Chipset DMA
Engine (rev b1)
        Subsystem: Intel Corporation Unknown device 346c
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr+ Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 1
        Region 0: Memory at fe700000 (64-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Message Signalled Interrupts: 64bit-
Queue=0/0 Enable-
                Address: fee00000  Data: 0000
        Capabilities: [6c] Express Unknown type IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s <64ns, L1 <1us
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed unknown, Width x0, ASPM unknown,
Port 0
                Link: Latency L0s <64ns, L1 <1us
                Link: ASPM L1 Enabled CommClk- ExtSynch-
                Link: Speed unknown, Width x0

00:10.0 Host bridge: Intel Corporation 5000 Series Chipset Error
Reporting Registers (rev b1)
        Subsystem: Intel Corporation Unknown device 346c
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-

00:10.1 Host bridge: Intel Corporation 5000 Series Chipset Error
Reporting Registers (rev b1)
        Subsystem: Intel Corporation Unknown device 346c
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-

00:10.2 Host bridge: Intel Corporation 5000 Series Chipset Error
Reporting Registers (rev b1)
        Subsystem: Intel Corporation Unknown device 346c
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-

00:11.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved
Registers (rev b1)
        Subsystem: Intel Corporation Unknown device 346c
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-

00:13.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved
Registers (rev b1)
        Subsystem: Intel Corporation Unknown device 346c
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-

00:15.0 Host bridge: Intel Corporation 5000 Series Chipset FBD Registers
(rev b1)
        Subsystem: Intel Corporation Unknown device 346c
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-

00:16.0 Host bridge: Intel Corporation 5000 Series Chipset FBD Registers
(rev b1)
        Subsystem: Intel Corporation Unknown device 346c
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-

00:1d.0 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset
UHCI USB Controller #1 (rev 09) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation Unknown device 346c
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 23
        Region 4: I/O ports at 30a0 [size=32]

00:1d.1 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset
UHCI USB Controller #2 (rev 09) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation Unknown device 346c
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 22
        Region 4: I/O ports at 3080 [size=32]

00:1d.2 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset
UHCI USB Controller #3 (rev 09) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation Unknown device 346c
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin C routed to IRQ 23
        Region 4: I/O ports at 3060 [size=32]

00:1d.3 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset
UHCI USB Controller #4 (rev 09) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation Unknown device 346c
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin D routed to IRQ 22
        Region 4: I/O ports at 3040 [size=32]

00:1d.7 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset
EHCI USB2 Controller (rev 09) (prog-if 20 [EHCI])
        Subsystem: Intel Corporation Unknown device 346c
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 23
        Region 0: Memory at b8b00400 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Debug port

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev d9) (prog-if
01 [Subtractive decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr+ Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Bus: primary=00, secondary=0c, subordinate=0c, sec-latency=32
        I/O behind bridge: 00001000-00001fff
        Memory behind bridge: b8a00000-b8afffff
        Prefetchable memory behind bridge: 00000000b0000000-00000000b7f00000
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
        Capabilities: [50] #0d [0000]

00:1f.0 ISA bridge: Intel Corporation 631xESB/632xESB/3100 Chipset LPC
Interface Controller (rev 09)
        Subsystem: Intel Corporation Unknown device 346c
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr+ Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0

00:1f.1 IDE interface: Intel Corporation 631xESB/632xESB IDE Controller
(rev 09) (prog-if 8a [Master SecP PriP])
        Subsystem: Intel Corporation Unknown device 346c
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 20
        Region 0: I/O ports at 01f0 [size=8]
        Region 1: I/O ports at 03f4 [size=1]
        Region 2: I/O ports at 0170 [size=8]
        Region 3: I/O ports at 0374 [size=1]
        Region 4: I/O ports at 30c0 [size=16]

00:1f.2 SATA controller: Intel Corporation 631xESB/632xESB SATA Storage
Controller AHCI (rev 09) (prog-if 01 [AHCI 1.0])
        Subsystem: Intel Corporation Unknown device 346c
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr+ Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 20
        Region 0: I/O ports at 30d8 [size=8]
        Region 1: I/O ports at 30f4 [size=4]
        Region 2: I/O ports at 30d0 [size=8]
        Region 3: I/O ports at 30f0 [size=4]
        Region 4: I/O ports at 3020 [size=32]
        Region 5: Memory at b8b00000 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [70] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [a8] #12 [0010]

00:1f.3 SMBus: Intel Corporation 631xESB/632xESB/3100 Chipset SMBus
Controller (rev 09)
        Subsystem: Intel Corporation Unknown device 346c
        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr+ Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin B routed to IRQ 20
        Region 4: I/O ports at 3000 [size=32]

01:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express
Upstream Port (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr+ Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=01, secondary=02, subordinate=05, sec-latency=0
        I/O behind bridge: 00002000-00002fff
        Memory behind bridge: b8000000-b88fffff
        Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [44] Express Upstream Port IRQ 0
                Device: Supported: MaxPayload 256 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s <64ns, L1 <1us
                Device: AtnBtn- AtnInd- PwrInd-
                Device: SlotPowerLimit 0.000000
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s, Port 0
                Link: Latency L0s unlimited, L1 unlimited
                Link: ASPM Disabled CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x8
        Capabilities: [70] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [80] #0d [0000]

01:00.3 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express to
PCI-X Bridge (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr+ Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=01, secondary=06, subordinate=06, sec-latency=64
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
        Secondary status: 66MHz+ FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [44] Express PCI/PCI-X Bridge IRQ 0
                Device: Supported: MaxPayload 256 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s <64ns, L1 <1us
                Device: AtnBtn- AtnInd- PwrInd-
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
                Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s, Port 0
                Link: Latency L0s unlimited, L1 unlimited
                Link: ASPM Disabled CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x8
        Capabilities: [6c] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [80] #0d [0000]
        Capabilities: [d8] PCI-X bridge device
                Secondary Status: 64bit+ 133MHz+ SCD- USC- SCO- SRD-
Freq=133MHz                Status: Dev=00:00.3 64bit- 133MHz- SCD- USC-
SCO- SRD-
                Upstream: Capacity=65535 CommitmentLimit=65535
                Downstream: Capacity=65535 CommitmentLimit=65535

02:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express
Downstream Port E1 (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr+ Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=02, secondary=03, subordinate=03, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [44] Express Downstream Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 256 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s <64ns, L1 <1us
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x4, ASPM L0s, Port 0
                Link: Latency L0s unlimited, L1 unlimited
                Link: ASPM Disabled CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x0
                Slot: AtnBtn+ PwrCtrl+ MRL+ AtnInd+ PwrInd+ HotPlug+
Surpise-
                Slot: Number 2, PowerLimit 0.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
                Slot: AttnInd Off, PwrInd On, Power-
        Capabilities: [60] Message Signalled Interrupts: 64bit+
Queue=0/0 Enable+
                Address: 00000000fee00000  Data: 4071
        Capabilities: [70] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [80] #0d [0000]

02:01.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express
Downstream Port E2 (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr+ Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=02, secondary=04, subordinate=04, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [44] Express Downstream Port (Slot-) IRQ 0
                Device: Supported: MaxPayload 256 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s <64ns, L1 <1us
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x4, ASPM L0s, Port 0
                Link: Latency L0s unlimited, L1 unlimited
                Link: ASPM Disabled CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x0
        Capabilities: [60] Message Signalled Interrupts: 64bit+
Queue=0/0 Enable+
                Address: 00000000fee00000  Data: 4079
        Capabilities: [70] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [80] #0d [0000]

02:02.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express
Downstream Port E3 (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr+ Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=02, secondary=05, subordinate=05, sec-latency=0
        I/O behind bridge: 00002000-00002fff
        Memory behind bridge: b8000000-b88fffff
        Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [44] Express Downstream Port (Slot-) IRQ 0
                Device: Supported: MaxPayload 256 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s <64ns, L1 <1us
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x4, ASPM L0s, Port 0
                Link: Latency L0s unlimited, L1 unlimited
                Link: ASPM Disabled CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x4
        Capabilities: [60] Message Signalled Interrupts: 64bit+
Queue=0/0 Enable+
                Address: 00000000fee00000  Data: 4081
        Capabilities: [70] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [80] #0d [0000]

05:00.0 Ethernet controller: Intel Corporation 80003ES2LAN Gigabit
Ethernet Controller (Copper) (rev 01)
        Subsystem: Intel Corporation Unknown device 346c
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr+ Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 2294
        Region 0: Memory at b8820000 (32-bit, non-prefetchable) [size=128K]
        Region 1: Memory at b8400000 (32-bit, non-prefetchable) [size=4M]
        Region 2: I/O ports at 2020 [size=32]
        Capabilities: [c8] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [d0] Message Signalled Interrupts: 64bit+
Queue=0/0 Enable+
                Address: 00000000fee07000  Data: 4086
        Capabilities: [e0] Express Endpoint IRQ 0
                Device: Supported: MaxPayload 256 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s <512ns, L1 <64us
                Device: AtnBtn- AtnInd- PwrInd-
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported-
                Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x4, ASPM unknown,
Port 0
                Link: Latency L0s <128ns, L1 <64us
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x4

05:00.1 Ethernet controller: Intel Corporation 80003ES2LAN Gigabit
Ethernet Controller (Copper) (rev 01)
        Subsystem: Intel Corporation Unknown device 346c
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr+ Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin B routed to IRQ 19
        Region 0: Memory at b8800000 (32-bit, non-prefetchable) [size=128K]
        Region 1: Memory at b8000000 (32-bit, non-prefetchable) [size=4M]
        Region 2: I/O ports at 2000 [size=32]
        Capabilities: [c8] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [d0] Message Signalled Interrupts: 64bit+
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [e0] Express Endpoint IRQ 0
                Device: Supported: MaxPayload 256 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s <512ns, L1 <64us
                Device: AtnBtn- AtnInd- PwrInd-
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported-
                Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x4, ASPM unknown,
Port 0
                Link: Latency L0s <128ns, L1 <64us
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x4

0c:0c.0 VGA compatible controller: ATI Technologies Inc ES1000 (rev 02)
(prog-if 00 [VGA])
        Subsystem: Intel Corporation Unknown device 346c
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping+ SERR+ FastB2B+
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (2000ns min), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at b0000000 (32-bit, prefetchable) [size=128M]
        Region 1: I/O ports at 1000 [size=256]
        Region 2: Memory at b8a00000 (32-bit, non-prefetchable) [size=64K]
        Expansion ROM at fffe0000 [disabled] [size=128K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

[7.6.] SCSI information (from /proc/scsi/scsi)
[root@termite /]# cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD2500YS-01S Rev: 20.0
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD2500YS-01S Rev: 20.0
  Type:   Direct-Access                    ANSI SCSI revision: 05

[7.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):
This is the error message that appears:
Jan 31 10:01:50 termite kernel: ata2.00: exception Emask 0x10 SAct
0x7fffffff SErr 0x80002 action 0x2 frozen
Jan 31 10:01:50 termite kernel: ata2.00: (irq_stat 0x08000000, interface
fatal error)
Jan 31 10:01:50 termite kernel: ata2.00: cmd
61/00:00:51:8f:ab/04:00:02:00:00/40 tag 0 cdb 0x0 data 524288 out
Jan 31 10:01:50 termite kernel:          res
40/00:4c:51:9b:ab/00:00:02:00:00/40 Emask 0x10 (ATA bus error)
Jan 31 10:01:50 termite kernel: ata2.00: cmd
61/00:08:39:47:ab/04:00:02:00:00/40 tag 1 cdb 0x0 data 524288 out
Jan 31 10:01:50 termite kernel:          res
40/00:4c:51:9b:ab/00:00:02:00:00/40 Emask 0x10 (ATA bus error)
Jan 31 10:01:50 termite kernel: ata2.00: cmd
61/00:10:51:93:ab/04:00:02:00:00/40 tag 2 cdb 0x0 data 524288 out
Jan 31 10:01:50 termite kernel:          res
40/00:4c:51:9b:ab/00:00:02:00:00/40 Emask 0x10 (ATA bus error)
Jan 31 10:01:50 termite kernel: ata2.00: cmd
61/00:18:39:43:ab/04:00:02:00:00/40 tag 3 cdb 0x0 data 524288 out
Jan 31 10:01:50 termite kernel:          res
40/00:4c:51:9b:ab/00:00:02:00:00/40 Emask 0x10 (ATA bus error)
Jan 31 10:01:50 termite kernel: ata2.00: cmd
61/00:20:41:4b:ab/04:00:02:00:00/40 tag 4 cdb 0x0 data 524288 out
Jan 31 10:01:50 termite kernel:          res
40/00:4c:51:9b:ab/00:00:02:00:00/40 Emask 0x10 (ATA bus error)
Jan 31 10:01:50 termite kernel: ata2.00: cmd
61/00:28:41:67:ab/04:00:02:00:00/40 tag 5 cdb 0x0 data 524288 out
Jan 31 10:02:03 termite kernel:          res
40/00:4c:51:9b:ab/00:00:02:00:00/40 Emask 0x10 (ATA bus error)
Jan 31 10:02:03 termite kernel: ata2.00: cmd
61/00:30:49:83:ab/04:00:02:00:00/40 tag 6 cdb 0x0 data 524288 out
Jan 31 10:02:27 termite kernel:          res
40/00:4c:51:9b:ab/00:00:02:00:00/40 Emask 0x10 (ATA bus error)
Jan 31 10:02:45 termite kernel: ata2.00: cmd
61/00:38:49:87:ab/04:00:02:00:00/40 tag 7 cdb 0x0 data 524288 out
Jan 31 10:02:46 termite kernel:          res
40/00:4c:51:9b:ab/00:00:02:00:00/40 Emask 0x10 (ATA bus error)
Jan 31 10:02:46 termite kernel: ata2.00: cmd
61/00:40:51:97:ab/04:00:02:00:00/40 tag 8 cdb 0x0 data 524288 out
Jan 31 10:02:46 termite kernel:          res
40/00:4c:51:9b:ab/00:00:02:00:00/40 Emask 0x10 (ATA bus error)
Jan 31 10:02:52 termite kernel: ata2.00: cmd
61/00:48:51:9b:ab/04:00:02:00:00/40 tag 9 cdb 0x0 data 524288 out
Jan 31 10:02:52 termite kernel:          res
40/00:4c:51:9b:ab/00:00:02:00:00/40 Emask 0x10 (ATA bus error)
Jan 31 10:02:53 termite kernel: ata2.00: cmd
61/00:50:51:9f:ab/04:00:02:00:00/40 tag 10 cdb 0x0 data 524288 out
Jan 31 10:02:59 termite kernel:          res
40/00:4c:51:9b:ab/00:00:02:00:00/40 Emask 0x10 (ATA bus error)
Jan 31 10:02:59 termite kernel: ata2.00: cmd
61/00:58:41:4f:ab/04:00:02:00:00/40 tag 11 cdb 0x0 data 524288 out
Jan 31 10:02:59 termite kernel:          res
40/00:4c:51:9b:ab/00:00:02:00:00/40 Emask 0x10 (ATA bus error)
Jan 31 10:02:59 termite kernel: ata2.00: cmd
61/00:60:41:53:ab/04:00:02:00:00/40 tag 12 cdb 0x0 data 524288 out
Jan 31 10:03:10 termite kernel:          res
40/00:4c:51:9b:ab/00:00:02:00:00/40 Emask 0x10 (ATA bus error)
Jan 31 10:03:20 termite kernel: ata2.00: cmd
61/00:68:41:57:ab/04:00:02:00:00/40 tag 13 cdb 0x0 data 524288 out
Jan 31 10:03:21 termite kernel:          res
40/00:4c:51:9b:ab/00:00:02:00:00/40 Emask 0x10 (ATA bus error)
Jan 31 10:03:25 termite kernel: ata2.00: cmd
61/00:70:49:6b:ab/04:00:02:00:00/40 tag 14 cdb 0x0 data 524288 out
Jan 31 10:03:30 termite kernel:          res
40/00:4c:51:9b:ab/00:00:02:00:00/40 Emask 0x10 (ATA bus error)
Jan 31 10:03:30 termite kernel: ata2.00: cmd
61/00:78:49:6f:ab/04:00:02:00:00/40 tag 15 cdb 0x0 data 524288 out
Jan 31 10:03:30 termite kernel:          res
40/00:4c:51:9b:ab/00:00:02:00:00/40 Emask 0x10 (ATA bus error)
Jan 31 10:03:30 termite kernel: ata2.00: cmd
61/08:80:29:6a:9a/00:00:02:00:00/40 tag 16 cdb 0x0 data 4096 out
Jan 31 10:03:30 termite kernel:          res
40/00:4c:51:9b:ab/00:00:02:00:00/40 Emask 0x10 (ATA bus error)
Jan 31 10:03:30 termite kernel: ata2.00: cmd
61/00:88:49:73:ab/04:00:02:00:00/40 tag 17 cdb 0x0 data 524288 out
Jan 31 10:03:30 termite kernel:          res
40/00:4c:51:9b:ab/00:00:02:00:00/40 Emask 0x10 (ATA bus error)
Jan 31 10:03:30 termite kernel: ata2.00: cmd
61/00:90:41:5b:ab/04:00:02:00:00/40 tag 18 cdb 0x0 data 524288 out
Jan 31 10:03:30 termite kernel:          res
40/00:4c:51:9b:ab/00:00:02:00:00/40 Emask 0x10 (ATA bus error)
Jan 31 10:03:30 termite kernel: ata2.00: cmd
61/00:98:41:5f:ab/04:00:02:00:00/40 tag 19 cdb 0x0 data 524288 out
Jan 31 10:03:30 termite kernel:          res
40/00:4c:51:9b:ab/00:00:02:00:00/40 Emask 0x10 (ATA bus error)
Jan 31 10:03:30 termite kernel: ata2.00: cmd
61/00:a0:41:63:ab/04:00:02:00:00/40 tag 20 cdb 0x0 data 524288 out
Jan 31 10:03:30 termite kernel:          res
40/00:4c:51:9b:ab/00:00:02:00:00/40 Emask 0x10 (ATA bus error)
Jan 31 10:03:30 termite kernel: ata2.00: cmd
61/00:a8:49:77:ab/04:00:02:00:00/40 tag 21 cdb 0x0 data 524288 out
Jan 31 10:03:30 termite kernel:          res
40/00:4c:51:9b:ab/00:00:02:00:00/40 Emask 0x10 (ATA bus error)
Jan 31 10:03:30 termite kernel: ata2.00: cmd
61/00:b0:49:7b:ab/04:00:02:00:00/40 tag 22 cdb 0x0 data 524288 out
Jan 31 10:03:30 termite kernel:          res
40/00:4c:51:9b:ab/00:00:02:00:00/40 Emask 0x10 (ATA bus error)
Jan 31 10:03:30 termite kernel: ata2.00: cmd
61/00:b8:49:7f:ab/04:00:02:00:00/40 tag 23 cdb 0x0 data 524288 out
Jan 31 10:03:30 termite kernel:          res
40/00:4c:51:9b:ab/00:00:02:00:00/40 Emask 0x10 (ATA bus error)
Jan 31 10:03:30 termite kernel: ata2.00: cmd
61/00:c0:51:8b:ab/04:00:02:00:00/40 tag 24 cdb 0x0 data 524288 out
Jan 31 10:03:30 termite kernel:          res
40/00:4c:51:9b:ab/00:00:02:00:00/40 Emask 0x10 (ATA bus error)
Jan 31 10:03:30 termite kernel: ata2.00: cmd
61/00:c8:39:2b:ab/04:00:02:00:00/40 tag 25 cdb 0x0 data 524288 out
Jan 31 10:03:30 termite kernel:          res
40/00:4c:51:9b:ab/00:00:02:00:00/40 Emask 0x10 (ATA bus error)
Jan 31 10:03:30 termite kernel: ata2.00: cmd
61/00:d0:39:2f:ab/04:00:02:00:00/40 tag 26 cdb 0x0 data 524288 out
Jan 31 10:03:30 termite kernel:          res
40/00:4c:51:9b:ab/00:00:02:00:00/40 Emask 0x10 (ATA bus error)
Jan 31 10:03:30 termite kernel: ata2.00: cmd
61/00:d8:39:33:ab/04:00:02:00:00/40 tag 27 cdb 0x0 data 524288 out
Jan 31 10:03:30 termite kernel:          res
40/00:4c:51:9b:ab/00:00:02:00:00/40 Emask 0x10 (ATA bus error)
Jan 31 10:03:30 termite kernel: ata2.00: cmd
61/00:e0:39:37:ab/04:00:02:00:00/40 tag 28 cdb 0x0 data 524288 out
Jan 31 10:03:30 termite kernel:          res
40/00:4c:51:9b:ab/00:00:02:00:00/40 Emask 0x10 (ATA bus error)
Jan 31 10:03:30 termite kernel: ata2.00: cmd
61/00:e8:39:3b:ab/04:00:02:00:00/40 tag 29 cdb 0x0 data 524288 out
Jan 31 10:03:30 termite kernel:          res
40/00:4c:51:9b:ab/00:00:02:00:00/40 Emask 0x10 (ATA bus error)
Jan 31 10:03:30 termite kernel: ata2.00: cmd
61/00:f0:39:3f:ab/04:00:02:00:00/40 tag 30 cdb 0x0 data 524288 out
Jan 31 10:03:30 termite kernel:          res
40/00:4c:51:9b:ab/00:00:02:00:00/40 Emask 0x10 (ATA bus error)
Jan 31 10:03:30 termite kernel: ata2: soft resetting port
Jan 31 10:03:30 termite kernel: ata2: SATA link up 3.0 Gbps (SStatus 123
SControl 300)
Jan 31 10:03:30 termite kernel: ata2.00: configured for UDMA/133
Jan 31 10:03:30 termite kernel: ata2: EH complete
Jan 31 10:03:30 termite kernel: SCSI device sdb: 490234752 512-byte hdwr
sectors (251000 MB)
Jan 31 10:03:30 termite kernel: sdb: Write Protect is off
Jan 31 10:03:30 termite kernel: SCSI device sdb: write cache: enabled,
read cache: enabled, doesn't support DPO or FUA

[X.] Other notes, patches, fixes, workarounds:
	Nothing found that helps as of yet.

-- 
James Ray.                          <j.ray@qmul.ac.uk>
Computing Services
Queen Mary, University of London
