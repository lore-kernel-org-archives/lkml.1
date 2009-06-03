Return-Path: <linux-kernel-owner+w=401wt.eu-S1755699AbZFCUAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699AbZFCUAJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 16:00:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753728AbZFCT75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 15:59:57 -0400
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:48969 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753238AbZFCT7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 15:59:55 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
X-IronPort-AV: E=Sophos;i="4.41,299,1241388000";   d="scan'208";a="14155696"
From: stefan verse <stefan.verse@post.rwth-aachen.de>
To: linux-kernel@vger.kernel.org
Subject: possible Bug in IOAPIC concerning serial 8250
Date: Wed, 03 Jun 2009 21:59:55 +0200
Message-id: <2CE90141F99649C08429B52D22C5066A@pepe>
X-Priority: 3 (Normal)
X-MSMail-priority: Normal
X-Mailer: Microsoft Outlook, Build 10.0.2627
X-MIMEOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,
i know, no good place to start, but my problem is a little bit
unspecific concerning Problems with IOAPIC concerning serrial driver
8250 :

1. serial driver 8250 is loaded, but /dev/ttyS0 is unusable

2. hardware is a d945gclf2 mini-itx board from intel, distribution is
easyvdr 0.6.06., Kernel Version is 2.6.29.3, serial port is activated in
BIOS, BIOS rev LF94510J.86A.0171.2009.0403.0118

dmesg reports :
[   21.682611] Serial: 8250/16550 driver, 1 ports, IRQ sharing disabled
[   21.682789] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   21.711689] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A

and lsmod :
8250_pci               27412  0
8250_pnp               14036  0
8250                   20516  2 8250_pci,8250_pnp
serial_core            18708  1 8250

so driver is loaded 

ls -lpr /dev/ttyS0
crw-rw-rw- 1 root tty 4, 64 2009-06-03 07:55 /dev/ttyS0
seems ok to me

but cat < /dev/ttyS0 gives :
cat: -: Eingabe-/Ausgabefehler                  (I/O Error)

/proc/interrupts is missing driver for irq4 :
           CPU0       CPU1       CPU2       CPU3
  0:        283          0          0          0   IO-APIC-edge
timer
  1:          2          0          0          0   IO-APIC-edge
i8042
  4:          2          0          0          0   IO-APIC-edge
  7:          0          0          0          0   IO-APIC-edge
parport0
  8:          1          0          0          0   IO-APIC-edge
rtc0
  9:          1          0          0          0   IO-APIC-fasteoi
acpi
 12:          4          0          0          0   IO-APIC-edge
i8042
 14:      55469          1          0          0   IO-APIC-edge
ide0
 16:          0          0          0          0   IO-APIC-fasteoi
uhci_hcd:usb5
 18:          0          0          0          0   IO-APIC-fasteoi
uhci_hcd:usb4
 19:        718          0          0          0   IO-APIC-fasteoi
ata_piix, uhci_hcd:usb3
 21:    3868819          0          0          0   IO-APIC-fasteoi
saa7146 (0)
 22:        138          0          0          0   IO-APIC-fasteoi   HDA
Intel
 23:   51554438          0          0          0   IO-APIC-fasteoi
ehci_hcd:usb1, uhci_hcd:usb2
 27:      10078          0          0          0   PCI-MSI-edge
eth0
NMI:          0          0          0          0   Non-maskable
interrupts
LOC:    7244673    7074229    1338468    2729063   Local timer
interrupts
RES:       3747       1475       2984        633   Rescheduling
interrupts
CAL:          9        135        135        126   Function call
interrupts
TLB:      48253      11978      30761      25010   TLB shootdowns
TRM:          0          0          0          0   Thermal event
interrupts
SPU:          0          0          0          0   Spurious interrupts
ERR:          0
MIS:          0

/proc/iomem :
00000000-0008efff : System RAM
0008f000-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000e0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-3f534fff : System RAM
  00100000-00637fb9 : Kernel code
  00637fba-0082b4d7 : Kernel data
  00899000-00900bb3 : Kernel bss
3f535000-3f53cfff : reserved
3f53d000-3f5ccfff : System RAM
3f5cd000-3f5d0fff : reserved
3f5d1000-3f65ffff : System RAM
3f660000-3f6effff : ACPI Non-volatile Storage
3f6f0000-3f6f2fff : System RAM
3f6f3000-3f6fefff : ACPI Tables
3f6ff000-3f6fffff : System RAM
3f700000-3fffffff : reserved
40000000-4fffffff : 0000:00:02.0
  40000000-407affff : vesafb
50000000-500fffff : PCI Bus 0000:01
  50000000-5000ffff : 0000:01:00.0
    50000000-5000ffff : r8169
  50020000-5003ffff : 0000:01:00.0
50100000-501fffff : PCI Bus 0000:04
  50100000-501001ff : 0000:04:00.0
    50100000-501001ff : saa7146
50200000-502fffff : PCI Bus 0000:01
  50200000-50200fff : 0000:01:00.0
    50200000-50200fff : r8169
50300000-5037ffff : 0000:00:02.0
50380000-503bffff : 0000:00:02.0
503c0000-503c3fff : 0000:00:1b.0
  503c0000-503c3fff : ICH HD audio
503c4000-503c43ff : 0000:00:1d.7
  503c4000-503c43ff : ehci_hcd
f0000000-ffffffff : reserved
  f0000000-f3ffffff : pnp 00:01
  fec00000-fec00fff : IOAPIC 0
  fed13000-fed13fff : pnp 00:01
  fed14000-fed17fff : pnp 00:01
  fed18000-fed18fff : pnp 00:01
  fed19000-fed19fff : pnp 00:01
  fed1c000-fed1ffff : pnp 00:01
  fed20000-fed3ffff : pnp 00:01
  fed45000-fed99fff : pnp 00:01
  fee00000-fee00fff : Local APIC

/proc/ioports shows no serial on 3f8 :
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0064-0064 : keyboard
0070-0071 : rtc0
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:1f.1
  0170-0177 : piix
01f0-01f7 : 0000:00:1f.1
  01f0-01f7 : piix
0376-0376 : 0000:00:1f.1
  0376-0376 : piix
0378-037a : parport0
03c0-03df : vesafb
03f6-03f6 : 0000:00:1f.1
  03f6-03f6 : piix
0400-047f : 0000:00:1f.0
  0400-047f : pnp 00:06
    0400-0403 : ACPI PM1a_EVT_BLK
    0404-0405 : ACPI PM1a_CNT_BLK
    0408-040b : ACPI PM_TMR
    0410-0415 : ACPI CPU throttle
    0420-0420 : ACPI PM2_CNT_BLK
    0428-042f : ACPI GPE0_BLK
    0430-0433 : iTCO_wdt
    0460-047f : iTCO_wdt
0500-053f : 0000:00:1f.0
  0500-053f : pnp 00:06
0680-06ff : pnp 00:06
0778-077a : parport0
0cf8-0cff : PCI conf1
1000-1fff : PCI Bus 0000:01
  1000-10ff : 0000:01:00.0
    1000-10ff : r8169
2000-201f : 0000:00:1f.3
  2000-201f : i801_smbus
2020-203f : 0000:00:1d.3
  2020-203f : uhci_hcd
2040-205f : 0000:00:1d.2
  2040-205f : uhci_hcd
2060-207f : 0000:00:1d.1
  2060-207f : uhci_hcd
2080-209f : 0000:00:1d.0
  2080-209f : uhci_hcd
20a0-20af : 0000:00:1f.2
  20a0-20af : ata_piix
20b0-20bf : 0000:00:1f.1
  20b0-20bf : piix
20c0-20c7 : 0000:00:1f.2
  20c0-20c7 : ata_piix
20c8-20cf : 0000:00:1f.2
  20c8-20cf : ata_piix


3. module, IOAPIC, D945GCLF2, 8250, ACPI, serial
    4. Linux version 2.6.29.3 (root@VDR) (gcc version 4.1.2 20061115
(prerelease) (Debian 4.1.1-21)) #13 SMP PREEMPT Sun May 31$
5. 
6.
7. D945GCLF2
7.1
Gnu C                  4.1.2
Gnu make               3.81
binutils               2.17
util-linux             2.12r
mount                  2.12r
module-init-tools      3.3-pre2
e2fsprogs              1.40-WIP
Linux C Library        2.3.6
Dynamic linker (ldd)   2.3.6
Procps                 3.2.7
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               5.97
udev                   105
Modules Loaded         ipv6 8250_pci 8250_pnp 8250 serial_core kbtab
raid1 i2c_viapro dm_snapshot dm_mirror dm_region_hash dm_log md_mod
dm_mod dvb_usb_opera dvb_pll dvb_usb dvb_ttpci lnbp21 l64781 saa7146_vv
saa7146 videobuf_dma_sg videobuf_core videodev v4l1_compat ves1820
tda8083 sp8870 stv0297 ves1x93 ttpci_eeprom stv0299 dvb_core
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss
snd_pcm snd_mixer_oss snd_seq_dummy snd_seq_oss snd_seq_midi_event
snd_seq rtc_cmos snd_timer snd_seq_device rtc_core parport_pc iTCO_wdt
parport pcspkr rtc_lib i2c_i801 iTCO_vendor_support r8169 snd mii
soundcore snd_page_alloc evdev

7.2 
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 28
model name      : Intel(R) Atom(TM) CPU  330   @ 1.60GHz
stepping        : 2
cpu MHz         : 1596.070
cache size      : 512 KB
physical id     : 0
siblings        : 4
core id         : 0
cpu cores       : 2
apicid          : 0
initial apicid  : 0
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat clflush dts acpi mmx fxsr sse sse2 s$
bogomips        : 3192.14
clflush size    : 64
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 28
model name      : Intel(R) Atom(TM) CPU  330   @ 1.60GHz
stepping        : 2
cpu MHz         : 1596.070
cache size      : 512 KB
physical id     : 0
siblings        : 4
core id         : 1
cpu cores       : 2
apicid          : 2
initial apicid  : 2
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat clflush dts acpi mmx fxsr sse sse2 s$
bogomips        : 3191.48
clflush size    : 64
power management:

processor       : 2
vendor_id       : GenuineIntel
cpu family      : 6

7.3
ipv6 241364 22 - Live 0xf95db000
8250_pci 27412 0 - Live 0xf9421000
8250_pnp 14036 0 - Live 0xf940a000
8250 20516 2 8250_pci,8250_pnp, Live 0xf93f7000
serial_core 18708 1 8250, Live 0xf93e6000
kbtab 3892 0 - Live 0xf93d7000
raid1 21620 1 - Live 0xf93c8000
i2c_viapro 7624 0 - Live 0xf911d000
dm_snapshot 18904 0 - Live 0xf9110000
dm_mirror 14296 0 - Live 0xf9101000
dm_region_hash 10964 1 dm_mirror, Live 0xf9013000
dm_log 9752 2 dm_mirror,dm_region_hash, Live 0xf8fb8000
md_mod 86128 2 raid1, Live 0xf90e9000
dm_mod 52676 3 dm_snapshot,dm_mirror,dm_log, Live 0xf90a3000
dvb_usb_opera 8700 10 - Live 0xf8f0b000
dvb_pll 8744 1 dvb_usb_opera, Live 0xf8e6d000
dvb_usb 16032 1 dvb_usb_opera, Live 0xf8e51000
dvb_ttpci 337760 18 - Live 0xf9127000
lnbp21 1780 1 dvb_ttpci, Live 0xf8f40000
l64781 6424 1 dvb_ttpci, Live 0xf8f29000
saa7146_vv 45780 1 dvb_ttpci, Live 0xf90bc000
saa7146 17436 2 dvb_ttpci,saa7146_vv, Live 0xf8fff000
videobuf_dma_sg 11832 1 saa7146_vv, Live 0xf8f71000
videobuf_core 17496 2 saa7146_vv,videobuf_dma_sg, Live 0xf8f6a000
videodev 41600 1 saa7146_vv, Live 0xf8fab000
v4l1_compat 13240 2 saa7146_vv,videodev, Live 0xf8f3a000
ves1820 6008 1 dvb_ttpci, Live 0xf8f07000
tda8083 5400 1 dvb_ttpci, Live 0xf8e71000
sp8870 6528 1 dvb_ttpci, Live 0xf8e5b000
stv0297 6900 1 dvb_ttpci, Live 0xf8df9000
ves1x93 6072 1 dvb_ttpci, Live 0xf8df3000
ttpci_eeprom 2036 1 dvb_ttpci, Live 0xf8be4000
stv0299 9468 2 dvb_usb_opera,dvb_ttpci, Live 0xf8bd2000
dvb_core 85184 3 dvb_usb,dvb_ttpci,stv0299, Live 0xf8fd4000
snd_hda_codec_realtek 188344 1 - Live 0xf905e000
snd_hda_intel 24232 0 - Live 0xf900b000
snd_hda_codec 64212 2 snd_hda_codec_realtek,snd_hda_intel, Live
0xf8fed000
snd_hwdep 6872 1 snd_hda_codec, Live 0xf8fd0000
snd_pcm_oss 36544 0 - Live 0xf8fbc000
snd_pcm 72568 3 snd_hda_intel,snd_hda_codec,snd_pcm_oss, Live 0xf8f97000
snd_mixer_oss 13940 1 snd_pcm_oss, Live 0xf8f75000
snd_seq_dummy 2552 0 - Live 0xf8f67000
snd_seq_oss 29056 0 - Live 0xf8f56000
snd_seq_midi_event 6836 1 snd_seq_oss, Live 0xf8f42000
snd_seq 47824 5 snd_seq_dummy,snd_seq_oss,snd_seq_midi_event, Live
0xf8f2c000
rtc_cmos 10156 0 - Live 0xf8f12000
snd_timer 20380 2 snd_pcm,snd_seq, Live 0xf8e77000
snd_seq_device 6912 3 snd_seq_dummy,snd_seq_oss,snd_seq, Live 0xf8bdd000
rtc_core 16272 1 rtc_cmos, Live 0xf8bbc000
parport_pc 36932 0 - Live 0xf8e61000
iTCO_wdt 10904 0 - Live 0xf8dfc000
parport 34188 1 parport_pc, Live 0xf8be7000
pcspkr 2356 0 - Live 0xf8be1000
rtc_lib 2900 1 rtc_core, Live 0xf8bd6000
i2c_i801 8708 0 - Live 0xf8bc6000
iTCO_vendor_support 3640 1 iTCO_wdt, Live 0xf8bb1000
r8169 32888 0 - Live 0xf8de8000

7.4
/proc/ioports 
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0064-0064 : keyboard
0070-0071 : rtc0
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:1f.1
  0170-0177 : piix
01f0-01f7 : 0000:00:1f.1
  01f0-01f7 : piix
0376-0376 : 0000:00:1f.1
  0376-0376 : piix
0378-037a : parport0
03c0-03df : vesafb
03f6-03f6 : 0000:00:1f.1
  03f6-03f6 : piix
0400-047f : 0000:00:1f.0
  0400-047f : pnp 00:06
    0400-0403 : ACPI PM1a_EVT_BLK
    0404-0405 : ACPI PM1a_CNT_BLK
    0408-040b : ACPI PM_TMR
    0410-0415 : ACPI CPU throttle
    0420-0420 : ACPI PM2_CNT_BLK
    0428-042f : ACPI GPE0_BLK
    0430-0433 : iTCO_wdt
    0460-047f : iTCO_wdt
0500-053f : 0000:00:1f.0
  0500-053f : pnp 00:06
0680-06ff : pnp 00:06
0778-077a : parport0
0cf8-0cff : PCI conf1
1000-1fff : PCI Bus 0000:01
  1000-10ff : 0000:01:00.0
    1000-10ff : r8169
2000-201f : 0000:00:1f.3
  2000-201f : i801_smbus
2020-203f : 0000:00:1d.3
  2020-203f : uhci_hcd
2040-205f : 0000:00:1d.2
  2040-205f : uhci_hcd
2060-207f : 0000:00:1d.1
  2060-207f : uhci_hcd
2080-209f : 0000:00:1d.0
  2080-209f : uhci_hcd
20a0-20af : 0000:00:1f.2
  20a0-20af : ata_piix
20b0-20bf : 0000:00:1f.1
  20b0-20bf : piix
20c0-20c7 : 0000:00:1f.2
  20c0-20c7 : ata_piix
20c8-20cf : 0000:00:1f.2
  20c8-20cf : ata_piix

/proc/iomem :
00000000-0008efff : System RAM
0008f000-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000e0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-3f534fff : System RAM
  00100000-00637fb9 : Kernel code
  00637fba-0082b4d7 : Kernel data
  00899000-00900bb3 : Kernel bss
3f535000-3f53cfff : reserved
3f53d000-3f5ccfff : System RAM
3f5cd000-3f5d0fff : reserved
3f5d1000-3f65ffff : System RAM
3f660000-3f6effff : ACPI Non-volatile Storage
3f6f0000-3f6f2fff : System RAM
3f6f3000-3f6fefff : ACPI Tables
3f6ff000-3f6fffff : System RAM
3f700000-3fffffff : reserved
40000000-4fffffff : 0000:00:02.0
  40000000-407affff : vesafb
50000000-500fffff : PCI Bus 0000:01
  50000000-5000ffff : 0000:01:00.0
    50000000-5000ffff : r8169
  50020000-5003ffff : 0000:01:00.0
50100000-501fffff : PCI Bus 0000:04
  50100000-501001ff : 0000:04:00.0
    50100000-501001ff : saa7146
50200000-502fffff : PCI Bus 0000:01
  50200000-50200fff : 0000:01:00.0
    50200000-50200fff : r8169
50300000-5037ffff : 0000:00:02.0
50380000-503bffff : 0000:00:02.0
503c0000-503c3fff : 0000:00:1b.0
  503c0000-503c3fff : ICH HD audio
503c4000-503c43ff : 0000:00:1d.7
  503c4000-503c43ff : ehci_hcd
f0000000-ffffffff : reserved
  f0000000-f3ffffff : pnp 00:01
  fec00000-fec00fff : IOAPIC 0
  fed13000-fed13fff : pnp 00:01
  fed14000-fed17fff : pnp 00:01
  fed18000-fed18fff : pnp 00:01
  fed19000-fed19fff : pnp 00:01
  fed1c000-fed1ffff : pnp 00:01
  fed20000-fed3ffff : pnp 00:01
  fed45000-fed99fff : pnp 00:01
  fee00000-fee00fff : Local APIC

7.5
lspci -vvv
00:00.0 Host bridge: Intel Corporation 945G/GZ/P/PL Express Memory
Controller Hub (rev 02)
        Subsystem: Intel Corporation Unknown device 464c
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information

00:02.0 VGA compatible controller: Intel Corporation 945G/GZ Express
Integrated Graphics Controller (rev 02) (prog-if 00 [VGA])
        Subsystem: Intel Corporation Unknown device 464c
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at 50300000 (32-bit, non-prefetchable)
[size=512K]
        Region 1: I/O ports at 20e0 [size=8]
        Region 2: Memory at 40000000 (32-bit, prefetchable) [size=256M]
        Region 3: Memory at 50380000 (32-bit, non-prefetchable)
[size=256K]
        Capabilities: [90] Message Signalled Interrupts: Mask- 64bit-
Queue=0/0 Enable-
                Address: 00000000  Data: 0000
        Capabilities: [d0] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High
Definition Audio Controller (rev 01)
        Subsystem: Intel Corporation Unknown device d604
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 22
        Region 0: Memory at 503c0000 (64-bit, non-prefetchable)
[size=16K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [70] Express Unknown type IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s <64ns, L1 <1us
                Device: Errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed unknown, Width x0, ASPM unknown,
Port 0
                Link: Latency L0s <64ns, L1 <1us
                Link: ASPM Disabled CommClk- ExtSynch-
                Link: Speed unknown, Width x0

00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 1 (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        I/O behind bridge: 00001000-00001fff
        Memory behind bridge: 50200000-502fffff
        Prefetchable memory behind bridge:
0000000050000000-00000000500fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1,
Port 1
                Link: Latency L0s <1us, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x1
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+
Surpise+
                Slot: Number 1, PowerLimit 10.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq-
                Slot: AttnInd Unknown, PwrInd Unknown, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-
Queue=0/0 Enable+
                Address: fee0f00c  Data: 4181
        Capabilities: [90] Subsystem: Gammagraphx, Inc. Unknown device
0000
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 3 (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge:
00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1,
Port 3
                Link: Latency L0s <1us, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x0
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+
Surpise+
                Slot: Number 3, PowerLimit 10.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq-
                Slot: AttnInd Unknown, PwrInd Unknown, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-
Queue=0/0 Enable+
                Address: fee0f00c  Data: 4189
        Capabilities: [90] Subsystem: Gammagraphx, Inc. Unknown device
0000
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 4 (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge:
00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1,
Port 4
                Link: Latency L0s <1us, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x0
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+
Surpise+
                Slot: Number 4, PowerLimit 10.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt-
HPIrq-
                Slot: AttnInd Unknown, PwrInd Unknown, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-
Queue=0/0 Enable+
                Address: fee0f00c  Data: 4191
        Capabilities: [90] Subsystem: Gammagraphx, Inc. Unknown device
0000
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
#1 (rev 01) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation Unknown device 464c
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 23
        Region 4: I/O ports at 2080 [size=32]

00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
#2 (rev 01) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation Unknown device 464c
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 19
        Region 4: I/O ports at 2060 [size=32]

00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
#3 (rev 01) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation Unknown device 464c
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin C routed to IRQ 18
        Region 4: I/O ports at 2040 [size=32]

00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
#4 (rev 01) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation Unknown device 464c
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin D routed to IRQ 16
        Region 4: I/O ports at 2020 [size=32]

00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI
Controller (rev 01) (prog-if 20 [EHCI])
        Subsystem: Intel Corporation Unknown device 464c
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 23
        Region 0: Memory at 503c4000 (32-bit, non-prefetchable)
[size=1K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Debug port

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev e1) (prog-if
01 [Subtractive decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Bus: primary=00, secondary=04, subordinate=04, sec-latency=32
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: 50100000-501fffff
        Prefetchable memory behind bridge:
00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [50] Subsystem: Intel Corporation Unknown device
464c

00:1f.0 ISA bridge: Intel Corporation 82801GB/GR (ICH7 Family) LPC
Interface Bridge (rev 01)
        Subsystem: Intel Corporation Unknown device 464c
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information

00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE
Controller (rev 01) (prog-if 8a [Master SecP PriP])
        Subsystem: Intel Corporation Unknown device 464c
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 18
        Region 0: I/O ports at 01f0 [size=8]
        Region 1: I/O ports at 03f4 [size=1]
        Region 2: I/O ports at 0170 [size=8]
        Region 3: I/O ports at 0374 [size=1]
        Region 4: I/O ports at 20b0 [size=16]

00:1f.2 IDE interface: Intel Corporation 82801GB/GR/GH (ICH7 Family)
Serial ATA Storage Controller IDE (rev 01) (prog-if 8f [Master SecP SecO
PriP PriO])
        Subsystem: Intel Corporation Unknown device 464c
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 19
        Region 0: I/O ports at 20c8 [size=8]
        Region 1: I/O ports at 20ec [size=4]
        Region 2: I/O ports at 20c0 [size=8]
        Region 3: I/O ports at 20e8 [size=4]
        Region 4: I/O ports at 20a0 [size=16]
        Capabilities: [70] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller
(rev 01)
        Subsystem: Intel Corporation Unknown device 464c
        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin B routed to IRQ 19
        Region 4: I/O ports at 2000 [size=32]

01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 02)
        Subsystem: Intel Corporation Unknown device 0001
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 27
        Region 0: I/O ports at 1000 [size=256]
        Region 2: Memory at 50200000 (64-bit, non-prefetchable)
[size=4K]
        Region 4: Memory at 50000000 (64-bit, prefetchable) [size=64K]
        Expansion ROM at 50020000 [disabled] [size=128K]
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+
Queue=0/0 Enable+
                Address: 00000000fee0f00c  Data: 4199
        Capabilities: [70] Express Endpoint IRQ 1
                Device: Supported: MaxPayload 256 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s <512ns, L1 <64us
                Device: AtnBtn- AtnInd- PwrInd-
                Device: Errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 4096 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1,
Port 0
                Link: Latency L0s <512ns, L1 <64us
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x1
        Capabilities: [b0] MSI-X: Enable- Mask- TabSize=2
                Vector table: BAR=4 offset=00000000
                PBA: BAR=4 offset=00000800
        Capabilities: [d0] Vital Product Data

04:00.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
        Subsystem: Technotrend Systemtechnik GmbH
Siemens/Technotrend/Hauppauge DVB card rev1.3 or rev1.5
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B+
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (3750ns min, 9500ns max)
        Interrupt: pin A routed to IRQ 21
        Region 0: Memory at 50100000 (32-bit, non-prefetchable)
[size=512]

7.6
7.7
/proc/tty/drivers
/dev/tty             /dev/tty        5       0 system:/dev/tty
/dev/console         /dev/console    5       1 system:console
/dev/ptmx            /dev/ptmx       5       2 system
/dev/vc/0            /dev/vc/0       4       0 system:vtmaster
serial               /dev/ttyS       4      64 serial
pty_slave            /dev/pts      136 0-1048575 pty:slave
pty_master           /dev/ptm      128 0-1048575 pty:master
pty_slave            /dev/ttyp       3 0-255 pty:slave
pty_master           /dev/pty        2 0-255 pty:master
unknown              /dev/tty        4 1-63 console

/proc/tty/driver/serial
serinfo:1.0 driver revision:
0: uart:unknown port:000003F8 irq:4


If you need more information, let me know. Perhaps you have ideas, what
can be testet further. My guess is, BIOS reports a wrong base address
for serial port. Or ACPI doesn't find the parameters.

Best regards,
Stefan Verse



