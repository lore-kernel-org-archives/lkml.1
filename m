Return-Path: <linux-kernel-owner+w=401wt.eu-S1758098AbXHUVQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098AbXHUVQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 17:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753757AbXHUVQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 17:16:40 -0400
Received: from postin.uv.es ([147.156.1.90]:45250 "EHLO postin.uv.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152AbXHUVQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 17:16:37 -0400
X-Greylist: delayed 4428 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Aug 2007 17:16:36 EDT
From: =?iso-8859-1?q?Jos=E9_Luis_Pati=F1o_Andr=E9s?= <jopan@alumni.uv.es>
Organization: Universitat de =?iso-8859-1?q?Val=E8ncia?=
To: linux-kernel@vger.kernel.org
Subject: Problems with IDE on linux 2.6.22.X
Date: Tue, 21 Aug 2007 21:49:11 +0200
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708212149.12912.jopan@alumni.uv.es>
X-RelayDelay-Mem: Whitelisted relay cuervo.ci.uv.es [147.156.1.157]. Not delayed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I'm writing for you because i'm experiencing some serious problems with the 
IDE system on linux kernel 2.6.22 series, *I think* specifically with the 
module IDE_GENERIC.

This is tested on all the 2.6.22 kernels (2.6.22, 2.6.22.1, 2.6.22.2, 2.6.22.3 
and 2.6.22.4).

Well, I'm using Debian GNU/Linux on a Lenovo 3000-n100 laptop. The kernel that 
I'm using now is a 2.6.20.15, compiled by myself, which works correctly. But 
when I try to run a 2.6.22 series kernel, compiled with the same options than 
the 2.6.20.15, some bad things happens.

First, there is a kernel panic, because kernel tries to boot the root 
partition from a hda disk, but I'm using sda disks, not hda.

Here is the kernel panic message:
###################
#VFS: Cannot open root device "sda3" or unknown-block (0,0)
#Please, append a correct "root=" boot option; here are the available 
#partitions:
#0300	97685784	hda driver: ide-disk
#	0301	29832763 hda1
#	0302	4931955	 hda2
#	0303	60308010 hda3
#	0304	1               hda4
#	0305	2610531   hda5
#Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block 
#(0,0)
###################

Somebody tolds me that I can solve this problem unchecking the IDE_GENERIC 
option in the kernel configuration. It's true, but when I do this the DVD 
device is not recognized by the kernel. No exists. In my working 2.6.20.15 
kernel, the 'cat /proc/ide/drivers' command outputs this:
###################
#ide-disk		version	1.18
#ide-cdrom	version	4.61
###################

But in 2.6.22.X, the output is only:
###################
#ide-disk		version 1.18
###################

I'm sure that is not a bad configuration options problem, because the problem 
appears too when, for example, I try to boot an openSUSE-10.3-beta liveCD, 
which has a 2.6.22.1 kernel, and boot process stops with this warning:
###################
#----> Probing module: generic
#----> Failed to detect CD drive!
#----> rebootException: reboot in 60 sec...
###################

Well, I never reported a kernel bug and I'm following the submitting 
recomendations of the webpage: 
http://www.eu.kernel.org/pub/linux/docs/lkml/reporting-bugs.html
So, there is some information about my system for your consideration:


- ver_linux script:
###################
#Linux cadmium 2.6.22.3 #1 SMP PREEMPT Fri Aug 17 12:24:14 UTC 2007 i686 
#GNU/Linux
#
#Gnu C                  4.1.3
#Gnu make               3.81
#binutils               Binutils
#util-linux             2.12r
#mount                  2.12r
#module-init-tools      3.3-pre11
#e2fsprogs              1.40-WIP
#pcmciautils            014
#Linux C Library        > libc.2.6
#Dynamic linker (ldd)   2.6
#Procps                 3.2.7
#Net-tools              1.60
#Console-tools          0.2.3
#Sh-utils               5.97
#udev                   114
#wireless-tools         28
#Modules Loaded         arc4 ecb blkcipher ieee80211_crypt_wep ipw3945 
#ieee80211 ieee80211_crypt rfcomm l2cap thermal fan button ac battery 
#cpufreq_performance cpufreq_conservative cpufreq_powersave cpufreq_stats 
#nvram acpi_cpufreq processor cpufreq_ondemand freq_table sbp2 hci_usb 
#bluetooth joydev ohci1394 ieee1394 pcmcia firmware_class snd_hda_intel 
#snd_pcm_oss snd_mixer_oss sdhci firewire_ohci firewire_core 8139too 
#yenta_socket snd_pcm snd_timer i2c_i801 mmc_core rsrc_nonstatic pcmcia_core 
#snd 8139cp mii crc_itu_t psmouse i2c_core rtc soundcore snd_page_alloc 
#serio_raw ehci_hcd uhci_hcd usbcore sg evdev
###################

- /proc/cpuinfo:
###################
#processor	: 0
#vendor_id	: GenuineIntel
#cpu family	: 6
#model		: 14
#model name	: Genuine Intel(R) CPU           T2300  @ 1.66GHz
#stepping	: 8
#cpu MHz		: 1000.000
#cache size	: 2048 KB
#physical id	: 0
#siblings	: 2
#core id		: 0
#cpu cores	: 2
#fdiv_bug	: no
#hlt_bug		: no
#f00f_bug	: no
#coma_bug	: no
#fpu		: yes
#fpu_exception	: yes
#cpuid level	: 10
#wp		: yes
#flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat 
#clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx constant_tsc pni monitor 
#est tm2 xtpr
#bogomips	: 3328.33
#clflush size	: 64
#
#processor	: 1
#vendor_id	: GenuineIntel
#cpu family	: 6
#model		: 14
#model name	: Genuine Intel(R) CPU           T2300  @ 1.66GHz
#stepping	: 8
#cpu MHz		: 1000.000
#cache size	: 2048 KB
#physical id	: 0
#siblings	: 2
#core id		: 1
#cpu cores	: 2
#fdiv_bug	: no
#hlt_bug		: no
#f00f_bug	: no
#coma_bug	: no
#fpu		: yes
#fpu_exception	: yes
#cpuid level	: 10
#wp		: yes
#flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat 
#clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx constant_tsc pni monitor 
#est tm2 xtpr
#bogomips	: 3325.06
#clflush size	: 64
###################

- /proc/modules:
###################
#arc4 1920 2 - Live 0xf8e66000
#ecb 3456 2 - Live 0xf881a000
#blkcipher 6148 1 ecb, Live 0xf8e69000
#ieee80211_crypt_wep 5120 1 - Live 0xf8e83000
#ipw3945 184160 1 - Live 0xf8efe000
#ieee80211 45740 1 ipw3945, Live 0xf8e31000
#ieee80211_crypt 5824 2 ieee80211_crypt_wep,ieee80211, Live 0xf8e22000
#rfcomm 36568 0 - Live 0xf8e3e000
#l2cap 22528 5 rfcomm, Live 0xf8e2a000
#thermal 13384 0 - Live 0xf8e10000
#fan 4740 0 - Live 0xf8e1f000
#button 7824 0 - Live 0xf8e1c000
#ac 5124 0 - Live 0xf8e19000
#battery 9924 0 - Live 0xf8e15000
#cpufreq_performance 1984 0 - Live 0xf8e0e000
#cpufreq_conservative 6792 0 - Live 0xf8df6000
#cpufreq_powersave 1728 0 - Live 0xf8b81000
#cpufreq_stats 5072 0 - Live 0xf8df9000
#nvram 8392 0 - Live 0xf8e0a000
#acpi_cpufreq 8792 0 - Live 0xf8e06000
#processor 30652 2 thermal,acpi_cpufreq, Live 0xf8dfd000
#cpufreq_ondemand 8204 0 - Live 0xf8c25000
#freq_table 4424 3 cpufreq_stats,acpi_cpufreq,cpufreq_ondemand, Live 
#0xf8be4000
#sbp2 21768 0 - Live 0xf8c42000
#hci_usb 16348 2 - Live 0xf8c3d000
#bluetooth 49956 7 rfcomm,l2cap,hci_usb, Live 0xf8c4e000
#joydev 9472 0 - Live 0xf8c1d000
#ohci1394 32368 0 - Live 0xf8c34000
#ieee1394 87864 2 sbp2,ohci1394, Live 0xf8c9b000
#pcmcia 37356 0 - Live 0xf8c29000
#firmware_class 9664 2 ipw3945,pcmcia, Live 0xf8c11000
#snd_hda_intel 239192 0 - Live 0xf8c5f000
#snd_pcm_oss 39264 0 - Live 0xf8bfa000
#snd_mixer_oss 15488 1 snd_pcm_oss, Live 0xf8bd5000
#sdhci 16524 0 - Live 0xf8b98000
#firewire_ohci 16384 0 - Live 0xf8bd0000
#firewire_core 38848 1 firewire_ohci, Live 0xf8c06000
#8139too 25152 0 - Live 0xf8bda000
#yenta_socket 24780 1 - Live 0xf8bb0000
#snd_pcm 72260 2 snd_hda_intel,snd_pcm_oss, Live 0xf8be7000
#snd_timer 21060 1 snd_pcm, Live 0xf8b83000
#i2c_i801 8272 0 - Live 0xf887b000
#mmc_core 26052 1 sdhci, Live 0xf8ba8000
#rsrc_nonstatic 11904 1 yenta_socket, Live 0xf8820000
#pcmcia_core 37400 3 pcmcia,yenta_socket,rsrc_nonstatic, Live 0xf8bc5000
#snd 48804 5 snd_hda_intel,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_timer, Live 
#0xf8bb8000
#8139cp 21824 0 - Live 0xf8b91000
#mii 5184 2 8139too,8139cp, Live 0xf8847000
#crc_itu_t 2048 1 firewire_core, Live 0xf8824000
#psmouse 35920 0 - Live 0xf8b9e000
#i2c_core 23808 1 i2c_i801, Live 0xf8b8a000
#rtc 12568 0 - Live 0xf8837000
#soundcore 7840 1 snd, Live 0xf8828000
#snd_page_alloc 9416 2 snd_hda_intel,snd_pcm, Live 0xf8843000
#serio_raw 6660 0 - Live 0xf8834000
#ehci_hcd 30796 0 - Live 0xf884d000
#uhci_hcd 22800 0 - Live 0xf883c000
#usbcore 125256 4 hci_usb,ehci_hcd,uhci_hcd, Live 0xf885b000
#sg 32604 0 - Live 0xf882b000
#evdev 9280 4 - Live 0xf881c000
###################

- /proc/ioports:
###################
#0000-001f : dma1
#0020-0021 : pic1
#0040-0043 : timer0
#0050-0053 : timer1
#0060-006f : keyboard
#0070-0077 : rtc
#0080-008f : dma page reg
#00a0-00a1 : pic2
#00c0-00df : dma2
#00f0-00ff : fpu
#0170-0177 : 0000:00:1f.2
#  0170-0177 : libata
#01f0-01f7 : 0000:00:1f.2
#  01f0-01f7 : libata
#0376-0376 : 0000:00:1f.2
#  0376-0376 : libata
#03c0-03df : vesafb
#03f6-03f6 : 0000:00:1f.2
#  03f6-03f6 : libata
#06a0-06af : pnp 00:07
#06b0-06ff : pnp 00:07
#0cf8-0cff : PCI conf1
#1000-107f : 0000:00:1f.0
#  1000-1003 : ACPI PM1a_EVT_BLK
#  1004-1005 : ACPI PM1a_CNT_BLK
#  1008-100b : ACPI PM_TMR
#  1010-1015 : ACPI CPU throttle
#  1020-1020 : ACPI PM2_CNT_BLK
#  1028-102f : ACPI GPE0_BLK
#1180-11bf : 0000:00:1f.0
#1800-181f : 0000:00:1d.0
#  1800-181f : uhci_hcd
#1820-183f : 0000:00:1d.1
#  1820-183f : uhci_hcd
#1840-185f : 0000:00:1d.2
#  1840-185f : uhci_hcd
#1860-187f : 0000:00:1d.3
#  1860-187f : uhci_hcd
#18b0-18bf : 0000:00:1f.2
#  18b0-18bf : libata
#18c0-18df : 0000:00:1f.3
#  18c0-18df : i801_smbus
#2000-2fff : PCI Bus #05
#  2000-20ff : 0000:05:01.0
#    2000-20ff : 8139too
#  2400-24ff : PCI CardBus #06
#  2800-28ff : PCI CardBus #06
###################

- /proc/iomem:
###################
#00000000-0009f7ff : System RAM
#  00000000-00000000 : Crash kernel
#0009f800-0009ffff : reserved
#000a0000-000bffff : Video RAM area
#000c0000-000cefff : Video ROM
#000cf000-000cffff : Adapter ROM
#000f0000-000fffff : System ROM
#00100000-3fe8ffff : System RAM
#  00100000-002cec04 : Kernel code
#  002cec05-00388a43 : Kernel data
#3fe90000-3fe99fff : ACPI Tables
#3fe9a000-3fefffff : ACPI Non-volatile Storage
#3ff00000-3fffffff : reserved
#50000000-53ffffff : PCI Bus #05
#  50000000-53ffffff : PCI CardBus #06
#54000000-57ffffff : PCI CardBus #06
#b0000000-b0003fff : 0000:00:1b.0
#  b0000000-b0003fff : ICH HD audio
#b0004000-b00043ff : 0000:00:1d.7
#  b0004000-b00043ff : ehci_hcd
#b1000000-b2ffffff : PCI Bus #01
#  b1000000-b1ffffff : 0000:01:00.0
#  b2000000-b2ffffff : 0000:01:00.0
#b3000000-b30fffff : PCI Bus #03
#  b3000000-b3000fff : 0000:03:00.0
#    b3000000-b3000fff : ipw3945
#b3100000-b31fffff : PCI Bus #05
#  b3100000-b31000ff : 0000:05:01.0
#    b3100000-b31000ff : 8139too
#  b3100400-b31004ff : 0000:05:06.1
#    b3100400-b31004ff : sdhci:slot0
#  b3100800-b3100fff : 0000:05:06.0
#    b3100800-b3100fff : firewire_ohci
#  b3101000-b3101fff : 0000:05:04.0
#    b3101000-b3101fff : yenta_socket
#  b3102000-b31020ff : 0000:05:06.2
#  b3102400-b31024ff : 0000:05:06.3
#  b3102800-b31028ff : 0000:05:06.4
#c0000000-cfffffff : PCI Bus #01
#  c0000000-cfffffff : 0000:01:00.0
#    c0000000-c3ffffff : vesafb
#e0000000-efffffff : reserved
#fec00000-fec0ffff : reserved
#fed00000-fed003ff : reserved
#fed14000-fed19fff : reserved
#fed1c000-fed8ffff : reserved
#fee00000-fee00fff : reserved
#ff000000-ffffffff : reserved
###################

- lspci -vvv output:
###################
00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS/940GML and 945GT 
Express Memory Controller Hub (rev 03)
	Subsystem: Lenovo Unknown device 2061
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort+ >SERR- <PERR-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information

00:01.0 PCI bridge: Intel Corporation Mobile 945GM/PM/GMS/940GML and 945GT 
Express PCI Express Root Port (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: b1000000-b2ffffff
	Prefetchable memory behind bridge: 00000000c0000000-00000000cfffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-
	Capabilities: [88] Subsystem: Lenovo Unknown device 2062
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 
Enable+
		Address: fee0300c  Data: 41b9
	Capabilities: [a0] Express Root Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <64ns, L1 <1us
		Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed 2.5Gb/s, Width x16, ASPM L0s L1, Port 2
		Link: Latency L0s <1us, L1 <4us
		Link: ASPM L0s L1 Enabled RCB 64 bytes CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x16
		Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug- Surpise-
		Slot: Number 1, PowerLimit 75.000000
		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
		Slot: AttnInd Off, PwrInd On, Power-
		Root: Correctable- Non-Fatal- Fatal- PME-
	Capabilities: [100] Virtual Channel
	Capabilities: [140] Unknown (5)

00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition 
Audio Controller (rev 02)
	Subsystem: Lenovo Unknown device 2066
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 22
	Region 0: Memory at b0000000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 
Enable-
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
	Capabilities: [100] Virtual Channel
	Capabilities: [130] Unknown (5)

00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 
(rev 02) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
	Capabilities: [40] Express Root Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s unlimited, L1 unlimited
		Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 1
		Link: Latency L0s <1us, L1 <4us
		Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x0
		Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
		Slot: Number 2, PowerLimit 6.500000
		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq-
		Slot: AttnInd Unknown, PwrInd Unknown, Power-
		Root: Correctable- Non-Fatal- Fatal- PME-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 
Enable+
		Address: fee0300c  Data: 41c1
	Capabilities: [90] Subsystem: Lenovo Unknown device 2067
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Virtual Channel
	Capabilities: [180] Unknown (5)

00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 2 
(rev 02) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: b3000000-b30fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
	Capabilities: [40] Express Root Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s unlimited, L1 unlimited
		Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 2
		Link: Latency L0s <256ns, L1 <4us
		Link: ASPM L1 Enabled RCB 64 bytes CommClk+ ExtSynch-
		Link: Speed 2.5Gb/s, Width x1
		Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
		Slot: Number 3, PowerLimit 6.500000
		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIrq-
		Slot: AttnInd Unknown, PwrInd Unknown, Power-
		Root: Correctable- Non-Fatal- Fatal- PME-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 
Enable+
		Address: fee0300c  Data: 41c9
	Capabilities: [90] Subsystem: Lenovo Unknown device 2068
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [100] Virtual Channel
	Capabilities: [180] Unknown (5)

00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #1 
(rev 02) (prog-if 00 [UHCI])
	Subsystem: Lenovo Unknown device 206b
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- 
<MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 19
	Region 4: I/O ports at 1800 [size=32]

00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #2 
(rev 02) (prog-if 00 [UHCI])
	Subsystem: Lenovo Unknown device 206c
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- 
<MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 18
	Region 4: I/O ports at 1820 [size=32]

00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #3 
(rev 02) (prog-if 00 [UHCI])
	Subsystem: Lenovo Unknown device 206d
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- 
<MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin C routed to IRQ 20
	Region 4: I/O ports at 1840 [size=32]

00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #4 
(rev 02) (prog-if 00 [UHCI])
	Subsystem: Lenovo Unknown device 206e
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- 
<MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin D routed to IRQ 16
	Region 4: I/O ports at 1860 [size=32]

00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI 
Controller (rev 02) (prog-if 20 [EHCI])
	Subsystem: Lenovo Unknown device 206f
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- 
<MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at b0004000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2) 
(prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR-
	Latency: 0
	Bus: primary=00, secondary=05, subordinate=09, sec-latency=32
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: b3100000-b31fffff
	Prefetchable memory behind bridge: 0000000050000000-0000000053ffffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- 
<MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: [50] Subsystem: Lenovo Unknown device 2070

00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge 
(rev 02)
	Subsystem: Lenovo Unknown device 2071
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- 
<MAbort- >SERR- <PERR-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information

00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) Serial ATA 
Storage Controller IDE (rev 02) (prog-if 80 [Master])
	Subsystem: Lenovo Unknown device 2072
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- 
<MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 18
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374 [size=1]
	Region 4: I/O ports at 18b0 [size=16]
	Capabilities: [70] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 
02)
	Subsystem: Lenovo Unknown device 2073
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- 
<MAbort- >SERR- <PERR-
	Interrupt: pin B routed to IRQ 18
	Region 4: I/O ports at 18c0 [size=32]

01:00.0 VGA compatible controller: nVidia Corporation Quadro NVS 110M / 
GeForce Go 7300 (rev a1) (prog-if 00 [VGA])
	Subsystem: Lenovo Unknown device 2065
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 7
	Region 0: Memory at b2000000 (32-bit, non-prefetchable) [size=16M]
	Region 1: Memory at c0000000 (64-bit, prefetchable) [size=256M]
	Region 3: Memory at b1000000 (64-bit, non-prefetchable) [size=16M]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [68] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 
Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [78] Express Endpoint IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <1us, L1 <4us
		Device: AtnBtn- AtnInd- PwrInd-
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
		Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
		Link: Supported Speed 2.5Gb/s, Width x16, ASPM L0s L1, Port 0
		Link: Latency L0s <1us, L1 <4us
		Link: ASPM L0s L1 Enabled RCB 128 bytes CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x16
	Capabilities: [100] Virtual Channel
	Capabilities: [128] Power Budgeting

03:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG Network 
Connection (rev 02)
	Subsystem: Intel Corporation Thinkpad  X60s, R60e model 0657
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 17
	Region 0: Memory at b3000000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [c8] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 
Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [e0] Express Legacy Endpoint IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <512ns, L1 unlimited
		Device: AtnBtn- AtnInd- PwrInd-
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 0
		Link: Latency L0s <128ns, L1 <64us
		Link: ASPM L0s L1 Enabled RCB 64 bytes CommClk+ ExtSynch-
		Link: Speed 2.5Gb/s, Width x1
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [140] Device Serial Number 63-a5-23-ff-ff-de-18-00

05:01.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL-8139/8139C/8139C+ (rev 10)
	Subsystem: Lenovo Unknown device 2074
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- 
<MAbort- >SERR- <PERR-
	Latency: 64 (8000ns min, 16000ns max)
	Interrupt: pin A routed to IRQ 21
	Region 0: I/O ports at 2000 [size=256]
	Region 1: Memory at b3100000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0-,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

05:04.0 CardBus bridge: ENE Technology Inc CB1410 Cardbus Controller (rev 01)
	Subsystem: Lenovo Unknown device 2075
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- 
<MAbort- >SERR- <PERR-
	Latency: 168, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at b3101000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=05, secondary=06, subordinate=09, sec-latency=176
	Memory window 0: 50000000-53fff000 (prefetchable)
	Memory window 1: 54000000-57fff000
	I/O window 0: 00002400-000024ff
	I/O window 1: 00002800-000028ff
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+ PostWrite+
	16-bit legacy interface ports at 0001

05:06.0 FireWire (IEEE 1394): Ricoh Co Ltd Unknown device 0832 (prog-if 10 
[OHCI])
	Subsystem: Lenovo Unknown device 2076
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- 
<MAbort- >SERR- <PERR-
	Latency: 64 (500ns min, 1000ns max)
	Interrupt: pin A routed to IRQ 22
	Region 0: Memory at b3100800 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME+

05:06.1 Generic system peripheral [0805]: Ricoh Co Ltd R5C822 
SD/SDIO/MMC/MS/MSPro Host Adapter (rev 19)
	Subsystem: Lenovo Unknown device 2077
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- 
<MAbort- >SERR- <PERR-
	Latency: 64
	Interrupt: pin B routed to IRQ 19
	Region 0: Memory at b3100400 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME-

05:06.2 System peripheral: Ricoh Co Ltd Unknown device 0843 (rev 01)
	Subsystem: Lenovo Unknown device 2078
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- 
<MAbort- >SERR- <PERR-
	Interrupt: pin B routed to IRQ 7
	Region 0: Memory at b3102000 (32-bit, non-prefetchable) [disabled] [size=256]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME-

05:06.3 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host Adapter 
(rev 0a)
	Subsystem: Lenovo Unknown device 2079
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- 
<MAbort- >SERR- <PERR-
	Interrupt: pin B routed to IRQ 7
	Region 0: Memory at b3102400 (32-bit, non-prefetchable) [disabled] [size=256]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME-

05:06.4 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev 05)
	Subsystem: Lenovo Unknown device 207a
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- 
SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- 
<MAbort- >SERR- <PERR-
	Interrupt: pin B routed to IRQ 7
	Region 0: Memory at b3102800 (32-bit, non-prefetchable) [disabled] [size=256]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=2 PME-
###################

- /proc/scsi/scsi:
###################
#Attached devices:
#Host: scsi0 Channel: 00 Id: 00 Lun: 00
#  Vendor: ATA      Model: HTS541010G9SA00  Rev: MBZI
#  Type:   Direct-Access                    ANSI  SCSI revision: 05
#Host: scsi1 Channel: 00 Id: 00 Lun: 00
#  Vendor: HL-DT-ST Model: DVDRAM GMA-4082N Rev: HA01
#  Type:   CD-ROM                           ANSI  SCSI revision: 05
###################



And that's all. I hope can be useful for you. I'm not a kernel expert, but if 
you think I can help in any way, feel free to write me at this mail address.

Thanks for your time!
