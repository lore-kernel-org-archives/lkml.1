Return-Path: <linux-kernel-owner+w=401wt.eu-S1756909AbXISJR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909AbXISJR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 05:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754990AbXISJRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 05:17:50 -0400
Received: from smtp.andrew.cmu.edu ([128.2.10.83]:45905 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396AbXISJRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 05:17:48 -0400
X-Greylist: delayed 1948 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Sep 2007 05:17:47 EDT
Message-ID: <46F0E19D.8000400@andrew.cmu.edu>
Date: Wed, 19 Sep 2007 04:45:17 -0400
From: Low Yucheng <ylow@andrew.cmu.edu>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: System Freeze on Particular workload with kernel 2.6.22.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[1.] Summary
System Freeze on Particular workload with kernel 2.6.22.6

[2.] Description
System freezes on repeated application of the following command
for f in *png ; do convert -quality 100 $f `basename $f png`jpg; done

Problem is consistent and repeatable.
Problem persists when running on a different drive, and also in pure console (no X).

One time, the following error logged in syslog:
Sep 19 04:22:11 mossnew kernel: [  301.883919] VM: killing process convert
Sep 19 04:22:11 mossnew kernel: [  301.884382] swap_free: Unused swap offset entry 0000ff00
Sep 19 04:22:11 mossnew kernel: [  301.884421] swap_free: Unused swap offset entry 00000300
Sep 19 04:22:11 mossnew kernel: [  301.884456] swap_free: Unused swap offset entry 00000200
Sep 19 04:22:11 mossnew kernel: [  301.884491] swap_free: Unused swap offset entry 0000ff00
Sep 19 04:22:11 mossnew kernel: [  301.884527] swap_free: Unused swap offset entry 0000ff00
Sep 19 04:22:11 mossnew kernel: [  301.884562] swap_free: Unused swap offset entry 00000100

Should not be a RAM problem. RAM has survived 12 hrs of Memtest with no errors.
Should not be a CPU problem either. I have been running CPU intensive tasks for days.

[3.] Keywords
freeze, swap_free,VM

[4.] /proc/version
Linux version 2.6.22.6intelcore2 (root@mossnew) (gcc version 4.1.2 (Ubuntu 4.1.2-0ubuntu4)) #1 SMP Sat Sep 15 00:29:00 EDT 2007

[5.] No Oops

[6.] Trigger
- Create a large number of png images. (a few hundred)

- repeatedly run
for f in *png ; do convert -quality 100 $f `basename $f png`jpg; done

- This might be subjective, but the freeze seems to show up sooner if there is a CPU heavy
process running in the background.

[7] Environment
[7.1] Software /script/ver_linux

Linux mossnew 2.6.22.6intelcore2 #1 SMP Sat Sep 15 00:29:00 EDT 2007 x86_64 GNU/Linux

Gnu C                  4.1.2
Gnu make               3.81
binutils               2.17.50
util-linux             2.12r
mount                  2.12r
module-init-tools      3.3-pre2
e2fsprogs              1.40-WIP
reiserfsprogs          3.6.19
pcmciautils            014
PPP                    2.4.4
Linux C Library        > libc.2.5
Dynamic linker (ldd)   2.5
Procps                 3.2.7
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               5.97
udev                   108
wireless-tools         28
Modules Loaded         isofs udf binfmt_misc ipv6 ppdev ac sbs battery video dock button container af_packet nls_iso8859_1 nls_cp437 vfat fat nls_utf8 ntfs w83627ehf i2c_isa i2c_core coretemp sbp2 
parport_pc lp parport fuse snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq atl1 snd_timer snd_seq_device sr_mod cdrom mii 
psmouse snd pcspkr soundcore snd_page_alloc shpchp pci_hotplug serio_raw intel_agp tsdev evdev ext3 jbd mbcache usb_storage sg sd_mod generic usbhid hid ata_piix libusual ohci1394 ieee1394 floppy 
ata_generic libata scsi_mod ehci_hcd uhci_hcd usbcore thermal processor fan



[7.2] Processor information
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Duo CPU     E6750  @ 2.66GHz
stepping        : 11
cpu MHz         : 2671.602
cache size      : 4096 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx lm constant_tsc pni monitor ds_cpl vmx smx est tm2 
ssse3 cx16 xtpr lahf_lm
bogomips        : 5346.72
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Core(TM)2 Duo CPU     E6750  @ 2.66GHz
stepping        : 11
cpu MHz         : 2671.602
cache size      : 4096 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall nx lm constant_tsc pni monitor ds_cpl vmx smx est tm2 
ssse3 cx16 xtpr lahf_lm
bogomips        : 5343.20
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:


[7.3] Module info
isofs 39268 1 - Live 0xffffffff883ac000
udf 90088 0 - Live 0xffffffff88395000
binfmt_misc 14604 1 - Live 0xffffffff88390000
ipv6 313320 12 - Live 0xffffffff88342000
ppdev 11016 0 - Live 0xffffffff8833e000
ac 6984 0 - Live 0xffffffff8833b000
sbs 21200 0 - Live 0xffffffff88334000
battery 12168 0 - Live 0xffffffff88330000
video 20240 0 - Live 0xffffffff8832a000
dock 12072 0 - Live 0xffffffff88326000
button 10080 0 - Live 0xffffffff88322000
container 6144 0 - Live 0xffffffff8831f000
af_packet 27276 0 - Live 0xffffffff88317000
nls_iso8859_1 6272 2 - Live 0xffffffff88314000
nls_cp437 8000 3 - Live 0xffffffff88311000
vfat 15872 2 - Live 0xffffffff8830c000
fat 59888 1 vfat, Live 0xffffffff882fc000
nls_utf8 3200 1 - Live 0xffffffff88045000
ntfs 103776 1 - Live 0xffffffff882e1000
w83627ehf 24144 0 - Live 0xffffffff882da000
i2c_isa 6080 1 w83627ehf, Live 0xffffffff882d7000
i2c_core 29952 2 w83627ehf,i2c_isa, Live 0xffffffff882ce000
coretemp 8640 0 - Live 0xffffffff882ca000
sbp2 26888 0 - Live 0xffffffff882c2000
parport_pc 41704 0 - Live 0xffffffff882b6000
lp 14728 0 - Live 0xffffffff882b1000
parport 44044 3 ppdev,parport_pc,lp, Live 0xffffffff882a5000
fuse 52272 1 - Live 0xffffffff88297000
snd_hda_intel 326944 1 - Live 0xffffffff88246000
snd_pcm_oss 49920 0 - Live 0xffffffff88238000
snd_mixer_oss 19904 1 snd_pcm_oss, Live 0xffffffff88232000
snd_pcm 94408 2 snd_hda_intel,snd_pcm_oss, Live 0xffffffff88219000
snd_seq_dummy 5188 0 - Live 0xffffffff88216000
snd_seq_oss 36864 0 - Live 0xffffffff8820c000
snd_seq_midi 10752 0 - Live 0xffffffff88208000
snd_rawmidi 29632 1 snd_seq_midi, Live 0xffffffff881ff000
snd_seq_midi_event 9664 2 snd_seq_oss,snd_seq_midi, Live 0xffffffff881fb000
snd_seq 62432 6 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event, Live 0xffffffff881ea000
atl1 39884 0 - Live 0xffffffff881df000
snd_timer 27016 2 snd_pcm,snd_seq, Live 0xffffffff881d7000
snd_seq_device 10004 5 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq, Live 0xffffffff881d3000
sr_mod 19556 1 - Live 0xffffffff881cd000
cdrom 41512 1 sr_mod, Live 0xffffffff881c1000
mii 7232 1 atl1, Live 0xffffffff881be000
psmouse 45404 0 - Live 0xffffffff881b1000
snd 69352 11 snd_hda_intel,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device, Live 0xffffffff8819f000
pcspkr 4352 0 - Live 0xffffffff8819c000
soundcore 10016 1 snd, Live 0xffffffff88198000
snd_page_alloc 11664 2 snd_hda_intel,snd_pcm, Live 0xffffffff88194000
shpchp 37980 0 - Live 0xffffffff88189000
pci_hotplug 18120 1 shpchp, Live 0xffffffff88183000
serio_raw 8900 0 - Live 0xffffffff8817f000
intel_agp 30112 0 - Live 0xffffffff88176000
tsdev 10368 0 - Live 0xffffffff88172000
evdev 12800 3 - Live 0xffffffff8816d000
ext3 146448 2 - Live 0xffffffff88148000
jbd 68784 1 ext3, Live 0xffffffff88136000
mbcache 11080 1 ext3, Live 0xffffffff88132000
usb_storage 81472 1 - Live 0xffffffff8811d000
sg 41128 0 - Live 0xffffffff88111000
sd_mod 32128 10 - Live 0xffffffff88108000
generic 7108 0 [permanent], Live 0xffffffff880bc000
usbhid 32256 1 - Live 0xffffffff880ff000
hid 33152 1 usbhid, Live 0xffffffff880f5000
ata_piix 18436 6 - Live 0xffffffff880ef000
libusual 22184 1 usb_storage, Live 0xffffffff880e8000
ohci1394 38600 0 - Live 0xffffffff880db000
ieee1394 109336 2 sbp2,ohci1394, Live 0xffffffff880bf000
floppy 68904 0 - Live 0xffffffff880aa000
ata_generic 9796 0 - Live 0xffffffff880a4000
libata 140880 2 ata_piix,ata_generic, Live 0xffffffff88080000
scsi_mod 172536 6 sbp2,sr_mod,usb_storage,sg,sd_mod,libata, Live 0xffffffff88054000
ehci_hcd 39308 0 - Live 0xffffffff88047000
uhci_hcd 29344 0 - Live 0xffffffff8803c000
usbcore 160240 7 usb_storage,usbhid,libusual,ehci_hcd,uhci_hcd, Live 0xffffffff88013000
thermal 16208 0 - Live 0xffffffff8800e000
processor 29896 1 thermal, Live 0xffffffff88005000
fan 6600 0 - Live 0xffffffff88002000

[7.4.1] /proc/ioports
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
0290-0297 : pnp 00:07
   0295-0296 : w83627ehf
03c0-03df : vga+
03f2-03f5 : floppy
03f7-03f7 : floppy DIR
03f8-03ff : serial
0400-041f : 0000:00:1f.3
0800-0803 : ACPI PM1a_EVT_BLK
0804-0805 : ACPI PM1a_CNT_BLK
0808-080b : ACPI PM_TMR
0810-0815 : ACPI CPU throttle
0820-082f : ACPI GPE0_BLK
0cf8-0cff : PCI conf1
a400-a40f : 0000:00:1f.2
a480-a48f : 0000:00:1f.2
   a480-a48f : libata
a800-a803 : 0000:00:1f.2
   a800-a803 : libata
a880-a887 : 0000:00:1f.2
   a880-a887 : libata
ac00-ac03 : 0000:00:1f.2
   ac00-ac03 : libata
b000-b007 : 0000:00:1f.2
   b000-b007 : libata
b400-b40f : 0000:00:1f.5
b480-b48f : 0000:00:1f.5
   b480-b48f : libata
b800-b803 : 0000:00:1f.5
   b800-b803 : libata
b880-b887 : 0000:00:1f.5
   b880-b887 : libata
bc00-bc03 : 0000:00:1f.5
   bc00-bc03 : libata
c000-c007 : 0000:00:1f.5
   c000-c007 : libata
c080-c09f : 0000:00:1d.0
   c080-c09f : uhci_hcd
c400-c41f : 0000:00:1d.1
   c400-c41f : uhci_hcd
c480-c49f : 0000:00:1d.2
   c480-c49f : uhci_hcd
c800-c81f : 0000:00:1a.0
   c800-c81f : uhci_hcd
c880-c89f : 0000:00:1a.1
   c880-c89f : uhci_hcd
cc00-cc1f : 0000:00:1a.2
   cc00-cc1f : uhci_hcd
d000-dfff : PCI Bus #01
   dc00-dc7f : 0000:01:00.0
e000-efff : PCI Bus #04
   ec00-ec7f : 0000:04:03.0


[7.4.2] /proc/iomem
00000000-0009fbff : System RAM
   00000000-00000000 : Crash kernel
0009fc00-0009ffff : reserved
000c0000-000cffff : pnp 00:0e
000e4000-000fffff : reserved
00100000-7ff7ffff : System RAM
   00200000-00436a8c : Kernel code
   00436a8d-0055c57f : Kernel data
7ff80000-7ff8dfff : ACPI Tables
7ff8e000-7ffdffff : ACPI Non-volatile Storage
7ffe0000-7fffffff : reserved
d0000000-dfffffff : PCI Bus #01
   d0000000-dfffffff : 0000:01:00.0
e0000000-efffffff : pnp 00:0d
faf00000-faffffff : PCI Bus #03
fbff8000-fbffbfff : 0000:00:1b.0
   fbff8000-fbffbfff : ICH HD audio
fbfff400-fbfff4ff : 0000:00:1f.3
fbfff800-fbfffbff : 0000:00:1d.7
   fbfff800-fbfffbff : ehci_hcd
fbfffc00-fbffffff : 0000:00:1a.7
   fbfffc00-fbffffff : ehci_hcd
fc000000-fe9fffff : PCI Bus #01
   fc000000-fcffffff : 0000:01:00.0
   fd000000-fdffffff : 0000:01:00.0
   fe000000-fe01ffff : 0000:01:00.0
fea00000-feafffff : PCI Bus #02
   feaa0000-feabffff : 0000:02:00.0
   feac0000-feafffff : 0000:02:00.0
     feac0000-feafffff : atl1
feb00000-febfffff : PCI Bus #04
   febff800-febfffff : 0000:04:03.0
     febff800-febfffff : ohci1394
fec00000-fec00fff : IOAPIC 0
   fec00000-fec00fff : pnp 00:0b
fed14000-fed19fff : pnp 00:01
fed1c000-fed1ffff : pnp 00:08
fed20000-fed3ffff : pnp 00:08
fed50000-fed8ffff : pnp 00:08
fee00000-fee00fff : Local APIC
ffa00000-ffafffff : pnp 00:08
fff00000-ffffffff : reserved


[7.5] pci information

00:00.0 Host bridge: Intel Corporation Unknown device 29c0 (rev 02)
         Subsystem: ASUSTeK Computer Inc. Unknown device 8276
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
         Latency: 0
         Capabilities: [e0] Vendor Specific Information

00:01.0 PCI bridge: Intel Corporation Unknown device 29c1 (rev 02) (prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0, Cache Line Size: 32 bytes
         Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
         I/O behind bridge: 0000d000-0000dfff
         Memory behind bridge: fc000000-fe9fffff
         Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
         BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
         Capabilities: [88] Subsystem: ASUSTeK Computer Inc. Unknown device 8276
         Capabilities: [80] Power Management version 3
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
                 Address: fee0300c  Data: 4159
         Capabilities: [a0] Express Root Port (Slot+) IRQ 0
                 Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                 Device: Latency L0s <64ns, L1 <1us
                 Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                 Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                 Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                 Link: Supported Speed 2.5Gb/s, Width x16, ASPM L0s, Port 2
                 Link: Latency L0s <256ns, L1 <4us
                 Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
                 Link: Speed 2.5Gb/s, Width x16
                 Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug- Surpise-
                 Slot: Number 0, PowerLimit 75.000000
                 Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
                 Slot: AttnInd Off, PwrInd On, Power-
                 Root: Correctable- Non-Fatal- Fatal- PME-

00:1a.0 USB Controller: Intel Corporation Unknown device 2937 (rev 02) (prog-if 00 [UHCI])
         Subsystem: ASUSTeK Computer Inc. Unknown device 8277
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin A routed to IRQ 16
         Region 4: I/O ports at c800 [size=32]
         Capabilities: [50] Vendor Specific Information

00:1a.1 USB Controller: Intel Corporation Unknown device 2938 (rev 02) (prog-if 00 [UHCI])
         Subsystem: ASUSTeK Computer Inc. Unknown device 8277
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin B routed to IRQ 21
         Region 4: I/O ports at c880 [size=32]
         Capabilities: [50] Vendor Specific Information

00:1a.2 USB Controller: Intel Corporation Unknown device 2939 (rev 02) (prog-if 00 [UHCI])
         Subsystem: ASUSTeK Computer Inc. Unknown device 8277
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin C routed to IRQ 18
         Region 4: I/O ports at cc00 [size=32]
         Capabilities: [50] Vendor Specific Information

00:1a.7 USB Controller: Intel Corporation Unknown device 293c (rev 02) (prog-if 20 [EHCI])
         Subsystem: ASUSTeK Computer Inc. Unknown device 8277
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin C routed to IRQ 18
         Region 0: Memory at fbfffc00 (32-bit, non-prefetchable) [size=1K]
         Capabilities: [50] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [58] Debug port
         Capabilities: [98] Vendor Specific Information

00:1b.0 Audio device: Intel Corporation Unknown device 293e (rev 02)
         Subsystem: ASUSTeK Computer Inc. Unknown device 829f
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0, Cache Line Size: 32 bytes
         Interrupt: pin A routed to IRQ 22
         Region 0: Memory at fbff8000 (64-bit, non-prefetchable) [size=16K]
         Capabilities: [50] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
                 Address: 0000000000000000  Data: 0000
         Capabilities: [70] Express Unknown type IRQ 0
                 Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                 Device: Latency L0s <64ns, L1 <1us
                 Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                 Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                 Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                 Link: Supported Speed unknown, Width x0, ASPM unknown, Port 0
                 Link: Latency L0s <64ns, L1 <1us
                 Link: ASPM Disabled CommClk- ExtSynch-
                 Link: Speed unknown, Width x0

00:1c.0 PCI bridge: Intel Corporation Unknown device 2940 (rev 02) (prog-if 00 [Normal decode])
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0, Cache Line Size: 32 bytes
         Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
         I/O behind bridge: 0000f000-00000fff
         Memory behind bridge: fff00000-000fffff
         Prefetchable memory behind bridge: 00000000faf00000-00000000faffffff
         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
         BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
         Capabilities: [40] Express Root Port (Slot+) IRQ 0
                 Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                 Device: Latency L0s <64ns, L1 <1us
                 Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                 Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                 Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                 Link: Supported Speed 2.5Gb/s, Width x4, ASPM L0s L1, Port 1
                 Link: Latency L0s <1us, L1 <4us
                 Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                 Link: Speed 2.5Gb/s, Width x0
                 Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
                 Slot: Number 0, PowerLimit 10.000000
                 Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
                 Slot: AttnInd Unknown, PwrInd Unknown, Power-
                 Root: Correctable- Non-Fatal- Fatal- PME-
         Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
                 Address: fee0300c  Data: 4161
         Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Unknown device 8277
         Capabilities: [a0] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1c.5 PCI bridge: Intel Corporation Unknown device 294a (rev 02) (prog-if 00 [Normal decode])
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0, Cache Line Size: 32 bytes
         Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
         I/O behind bridge: 0000f000-00000fff
         Memory behind bridge: fea00000-feafffff
         Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
         BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
         Capabilities: [40] Express Root Port (Slot+) IRQ 0
                 Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                 Device: Latency L0s <64ns, L1 <1us
                 Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                 Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                 Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                 Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 6
                 Link: Latency L0s <256ns, L1 <4us
                 Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
                 Link: Speed 2.5Gb/s, Width x1
                 Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
                 Slot: Number 0, PowerLimit 10.000000
                 Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
                 Slot: AttnInd Unknown, PwrInd Unknown, Power-
                 Root: Correctable- Non-Fatal- Fatal- PME-
         Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
                 Address: fee0300c  Data: 4169
         Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Unknown device 8277
         Capabilities: [a0] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1d.0 USB Controller: Intel Corporation Unknown device 2934 (rev 02) (prog-if 00 [UHCI])
         Subsystem: ASUSTeK Computer Inc. Unknown device 8277
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin A routed to IRQ 23
         Region 4: I/O ports at c080 [size=32]
         Capabilities: [50] Vendor Specific Information

00:1d.1 USB Controller: Intel Corporation Unknown device 2935 (rev 02) (prog-if 00 [UHCI])
         Subsystem: ASUSTeK Computer Inc. Unknown device 8277
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin B routed to IRQ 19
         Region 4: I/O ports at c400 [size=32]
         Capabilities: [50] Vendor Specific Information

00:1d.2 USB Controller: Intel Corporation Unknown device 2936 (rev 02) (prog-if 00 [UHCI])
         Subsystem: ASUSTeK Computer Inc. Unknown device 8277
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin C routed to IRQ 18
         Region 4: I/O ports at c480 [size=32]
         Capabilities: [50] Vendor Specific Information

00:1d.7 USB Controller: Intel Corporation Unknown device 293a (rev 02) (prog-if 20 [EHCI])
         Subsystem: ASUSTeK Computer Inc. Unknown device 8277
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin A routed to IRQ 23
         Region 0: Memory at fbfff800 (32-bit, non-prefetchable) [size=1K]
         Capabilities: [50] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [58] Debug port
         Capabilities: [98] Vendor Specific Information

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92) (prog-if 01 [Subtractive decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Bus: primary=00, secondary=04, subordinate=04, sec-latency=32
         I/O behind bridge: 0000e000-0000efff
         Memory behind bridge: feb00000-febfffff
         Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
         Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
         BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
         Capabilities: [50] Subsystem: ASUSTeK Computer Inc. Unknown device 8277

00:1f.0 ISA bridge: Intel Corporation Unknown device 2918 (rev 02)
         Subsystem: ASUSTeK Computer Inc. Unknown device 8277
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Capabilities: [e0] Vendor Specific Information

00:1f.2 IDE interface: Intel Corporation Unknown device 2921 (rev 02) (prog-if 8f [Master SecP SecO PriP PriO])
         Subsystem: ASUSTeK Computer Inc. Unknown device 8277
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin B routed to IRQ 22
         Region 0: I/O ports at b000 [size=8]
         Region 1: I/O ports at ac00 [size=4]
         Region 2: I/O ports at a880 [size=8]
         Region 3: I/O ports at a800 [size=4]
         Region 4: I/O ports at a480 [size=16]
         Region 5: I/O ports at a400 [size=16]
         Capabilities: [70] Power Management version 3
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [b0] Vendor Specific Information

00:1f.3 SMBus: Intel Corporation Unknown device 2930 (rev 02)
         Subsystem: ASUSTeK Computer Inc. Unknown device 8277
         Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Interrupt: pin C routed to IRQ 5
         Region 0: Memory at fbfff400 (64-bit, non-prefetchable) [size=256]
         Region 4: I/O ports at 0400 [size=32]

00:1f.5 IDE interface: Intel Corporation Unknown device 2926 (rev 02) (prog-if 85 [Master SecO PriO])
         Subsystem: ASUSTeK Computer Inc. Unknown device 8277
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin B routed to IRQ 22
         Region 0: I/O ports at c000 [size=8]
         Region 1: I/O ports at bc00 [size=4]
         Region 2: I/O ports at b880 [size=8]
         Region 3: I/O ports at b800 [size=4]
         Region 4: I/O ports at b480 [size=16]
         Region 5: I/O ports at b400 [size=16]
         Capabilities: [70] Power Management version 3
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [b0] Vendor Specific Information

01:00.0 VGA compatible controller: nVidia Corporation G70 [GeForce 7600 GT] (rev a1) (prog-if 00 [VGA])
         Subsystem: LeadTek Research Inc. Unknown device 2089
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0, Cache Line Size: 32 bytes
         Interrupt: pin A routed to IRQ 11
         Region 0: Memory at fd000000 (32-bit, non-prefetchable) [size=16M]
         Region 1: Memory at d0000000 (64-bit, prefetchable) [size=256M]
         Region 3: Memory at fc000000 (64-bit, non-prefetchable) [size=16M]
         Region 5: I/O ports at dc00 [size=128]
         [virtual] Expansion ROM at fe000000 [disabled] [size=128K]
         Capabilities: [60] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [68] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
                 Address: 0000000000000000  Data: 0000
         Capabilities: [78] Express Endpoint IRQ 0
                 Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                 Device: Latency L0s <256ns, L1 <4us
                 Device: AtnBtn- AtnInd- PwrInd-
                 Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                 Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                 Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
                 Link: Supported Speed 2.5Gb/s, Width x16, ASPM L0s L1, Port 0
                 Link: Latency L0s <256ns, L1 <4us
                 Link: ASPM Disabled RCB 128 bytes CommClk+ ExtSynch-
                 Link: Speed 2.5Gb/s, Width x16

02:00.0 Ethernet controller: Attansic Technology Corp. L1 Gigabit Ethernet Adapter (rev b0)
         Subsystem: ASUSTeK Computer Inc. Unknown device 8226
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0, Cache Line Size: 32 bytes
         Interrupt: pin A routed to IRQ 508
         Region 0: Memory at feac0000 (64-bit, non-prefetchable) [size=256K]
         Expansion ROM at feaa0000 [disabled] [size=128K]
         Capabilities: [40] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [48] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
                 Address: 00000000fee0300c  Data: 4199
         Capabilities: [58] Express Endpoint IRQ 0
                 Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                 Device: Latency L0s <4us, L1 unlimited
                 Device: AtnBtn+ AtnInd+ PwrInd+
                 Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                 Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                 Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
                 Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s, Port 0
                 Link: Latency L0s unlimited, L1 unlimited
                 Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
                 Link: Speed 2.5Gb/s, Width x1

04:03.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394 Host Controller (rev c0) (prog-if 10 [OHCI])
         Subsystem: ASUSTeK Computer Inc. Unknown device 81fe
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 64 (8000ns max), Cache Line Size: 32 bytes
         Interrupt: pin A routed to IRQ 16
         Region 0: Memory at febff800 (32-bit, non-prefetchable) [size=2K]
         Region 1: I/O ports at ec00 [size=128]
         Capabilities: [50] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2+ AuxCurrent=0mA PME(D0-,D1-,D2+,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-



[7.6] SCSI information

Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: HDT722525DLA380  Rev: V44O
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: HDT722525DLA380  Rev: V44O
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: WDC WD2500KS-00M Rev: 02.0
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi3 Channel: 00 Id: 00 Lun: 00
   Vendor: ATA      Model: WDC WD5000ABYS-0 Rev: 12.0
   Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 00
   Vendor: LITE-ON  Model: DVDRW SHW-1635S  Rev: YS0R
   Type:   CD-ROM                           ANSI  SCSI revision: 00


