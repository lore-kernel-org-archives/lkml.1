Return-Path: <linux-kernel-owner+w=401wt.eu-S1764934AbXHIDci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764934AbXHIDci (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 23:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755444AbXHIDcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 23:32:13 -0400
Received: from 65.44.231.216.in-addr ([216.231.44.65]:52041 "EHLO
	hoth.localdomain" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758351AbXHIDcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 23:32:09 -0400
X-Greylist: delayed 476 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Aug 2007 23:32:08 EDT
From: Zach Carter <linux@zachcarter.com>
To: jgarzik@pobox.com, linux-kernel@vger.kernel.org, linux-net@vger.kernel.org
Subject: PROBLEM: 8139too with MMIO hangs the system
Date: Wed, 8 Aug 2007 20:24:10 -0700
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708082024.10849.linux@zachcarter.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi:

Whenever 8139too is loaded via modprobe, the entire system hangs.  

If we compile the kernel with CONFIG_8139TOO_PIO=y, the problem 
goes away.  However, since every distro we've tried does not 
compile the module this way, all of the installation CDs hang.
We were able to find a specially built Ubuntu that gets around
this.  Magic Sysreq keys do not work when the system hangs in
this way.  

We have reproduced this problem on the stock 2.6.20 Ubuntu 
kernels, mainline 2.6.22, and 2.6.23-rc[12], plus all the 
kernels that were running in the various installation CDs 
we tried.

We set RTL8139_DEBUG to 3 in order to enable copious debug
info for this module in the 2.6.23-rc2 kernel.  After doing 
that, we get this in syslog when the laptop hangs:

ACPI: PCI interrupt for device 0000:03:04.0 disabled

we've tried booting with various options, including:

	acpi=off
	pci=noacpi
	pci=nobios
	pci=bios
	pci=usepirqmask
	pci=noirq

This is an Everex StepNote2053T Laptop.  Our experience is described
here:  http://www.poplarware.com/everexlinux.html

Ubuntu Laptop Testing page here:

	https://wiki.ubuntu.com/LaptopTestingTeam/EverexStepNoteSA2053T

kernel config can be found here: 

	http://www.zachcarter.com/2.6.23-rc2-everex-8139too.config

Any help getting this fixed would be appreciated.  We would be happy
to try any patches, or run any debug commands.   It is rather 
frustrating that none of the distros work out of the box on this
laptop, and would love to help prevent others from having this
same experience.

thanks!

-Zach

+ cat /proc/version
Linux version 2.6.23-rc2 (root@bird) (gcc version 4.1.2 (Ubuntu 4.1.2-0ubuntu4)) #3 SMP Wed Aug 8 10:46:43 PDT 2007
+ /opt/src/linux-2.6/scripts/ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
 
Linux bird 2.6.23-rc2 #3 SMP Wed Aug 8 10:46:43 PDT 2007 i686 GNU/Linux
 
Gnu C                  4.1.2
Gnu make               3.81
binutils               2.17.50
util-linux             2.12r
mount                  2.12r
module-init-tools      3.3-pre2
e2fsprogs              1.40-WIP
jfsutils               1.1.11
reiserfsprogs          3.6.19
xfsprogs               2.8.18
pcmciautils            014
PPP                    2.4.4
Linux C Library        2.5
Dynamic linker (ldd)   2.5
Procps                 3.2.7
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               5.97
udev                   108
wireless-tools         28
Modules Loaded         xt_tcpudp nf_conntrack_ipv4 xt_state iptable_nat nf_nat nf_conntrack nfnetlink iptable_filter ip_tables x_tables binfmt_misc i915 drm ppdev acpi_cpufreq cpufreq_stats cpufreq_powersave cpufreq_ondemand cpufreq_conservative freq_table cpufreq_userspace container sbs dock sbp2 parport_pc lp parport fuse joydev snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device serio_raw iTCO_wdt iTCO_vendor_support snd pcspkr psmouse video output soundcore ac shpchp battery snd_page_alloc pci_hotplug intel_agp button tsdev agpgart evdev ipv6 ext3 jbd mbcache sg usbhid hid sr_mod cdrom sd_mod ata_piix 8139cp uhci_hcd ata_generic ohci1394 ieee1394 8139too mii libata ehci_hcd scsi_mod generic usbcore thermal processor fan
+ cat /proc/cpuinfo
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 14
model name	: Genuine Intel(R) CPU           T2080  @ 1.73GHz
stepping	: 12
cpu MHz		: 100.000
cache size	: 1024 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx constant_tsc arch_perfmon bts pni monitor est tm2 xtpr
bogomips	: 3461.36
clflush size	: 64

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 14
model name	: Genuine Intel(R) CPU           T2080  @ 1.73GHz
stepping	: 12
cpu MHz		: 100.000
cache size	: 1024 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx constant_tsc arch_perfmon bts pni monitor est tm2 xtpr
bogomips	: 5037.31
clflush size	: 64

+ cat /proc/modules
xt_tcpudp 4352 2 - Live 0xf8d88000
nf_conntrack_ipv4 19464 4 - Live 0xf8d39000
xt_state 3584 4 - Live 0xf8941000
iptable_nat 8580 0 - Live 0xf8d35000
nf_nat 21164 1 iptable_nat, Live 0xf8d2e000
nf_conntrack 67016 4 nf_conntrack_ipv4,xt_state,iptable_nat,nf_nat, Live 0xf8d15000
nfnetlink 7192 3 nf_conntrack_ipv4,nf_nat,nf_conntrack, Live 0xf8d12000
iptable_filter 4096 1 - Live 0xf8860000
ip_tables 14436 2 iptable_nat,iptable_filter, Live 0xf8d0d000
x_tables 16516 4 xt_tcpudp,xt_state,iptable_nat,ip_tables, Live 0xf8d07000
binfmt_misc 13192 1 - Live 0xf8d29000
i915 25728 2 - Live 0xf8b71000
drm 83732 3 i915, Live 0xf8cf1000
ppdev 10500 0 - Live 0xf8af9000
acpi_cpufreq 10824 1 - Live 0xf8af0000
cpufreq_stats 7360 0 - Live 0xf8aed000
cpufreq_powersave 2944 0 - Live 0xf8834000
cpufreq_ondemand 9740 1 - Live 0xf8ae9000
cpufreq_conservative 8328 0 - Live 0xf8ae5000
freq_table 6048 3 acpi_cpufreq,cpufreq_stats,cpufreq_ondemand, Live 0xf8af6000
cpufreq_userspace 5540 0 - Live 0xf8add000
container 6016 0 - Live 0xf8ada000
sbs 19848 0 - Live 0xf8ad4000
dock 11536 0 - Live 0xf8ad0000
sbp2 23816 0 - Live 0xf8ac9000
parport_pc 37796 0 - Live 0xf8abe000
lp 12836 0 - Live 0xf8ae0000
parport 37960 3 ppdev,parport_pc,lp, Live 0xf8aab000
fuse 47252 1 - Live 0xf8a9e000
joydev 11712 0 - Live 0xf8a9a000
snd_hda_intel 277020 1 - Live 0xf8dbc000
snd_pcm_oss 44928 0 - Live 0xf8a8e000
snd_mixer_oss 17536 1 snd_pcm_oss, Live 0xf8ab8000
snd_pcm 80772 2 snd_hda_intel,snd_pcm_oss, Live 0xf8a79000
snd_seq_dummy 4996 0 - Live 0xf8a1d000
snd_seq_oss 33536 0 - Live 0xf8a6f000
snd_seq_midi 9728 0 - Live 0xf8a19000
snd_rawmidi 25984 1 snd_seq_midi, Live 0xf8a11000
snd_seq_midi_event 8576 2 snd_seq_oss,snd_seq_midi, Live 0xf8a0d000
snd_seq 53744 6 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event, Live 0xf89fe000
snd_timer 24580 2 snd_pcm,snd_seq, Live 0xf89f6000
snd_seq_device 9484 5 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq, Live 0xf89ed000
serio_raw 8324 0 - Live 0xf89e9000
iTCO_wdt 13220 0 - Live 0xf89e4000
iTCO_vendor_support 5124 1 iTCO_wdt, Live 0xf89f3000
snd 55044 11 snd_hda_intel,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device, Live 0xf89d5000
pcspkr 4480 0 - Live 0xf89d0000
psmouse 40592 0 - Live 0xf8936000
video 18444 0 - Live 0xf8930000
output 5120 1 video, Live 0xf8908000
soundcore 9056 1 snd, Live 0xf892c000
ac 6660 0 - Live 0xf8899000
shpchp 34708 0 - Live 0xf8922000
battery 13192 0 - Live 0xf89cb000
snd_page_alloc 11144 2 snd_hda_intel,snd_pcm, Live 0xf894b000
pci_hotplug 31648 1 shpchp, Live 0xf8919000
intel_agp 25620 1 - Live 0xf8943000
button 9360 0 - Live 0xf8904000
tsdev 9664 0 - Live 0xf88f5000
agpgart 35016 3 drm,intel_agp, Live 0xf88eb000
evdev 11520 5 - Live 0xf88a2000
ipv6 270244 12 - Live 0xf8988000
ext3 134280 5 - Live 0xf88c9000
jbd 60328 1 ext3, Live 0xf88b9000
mbcache 9856 1 ext3, Live 0xf8895000
sg 36764 0 - Live 0xf88fa000
usbhid 31360 0 - Live 0xf890b000
hid 30720 1 usbhid, Live 0xf888c000
sr_mod 17700 0 - Live 0xf8886000
cdrom 37280 1 sr_mod, Live 0xf887b000
sd_mod 30464 7 - Live 0xf8872000
ata_piix 17668 6 - Live 0xf889c000
8139cp 25216 0 - Live 0xf886a000
uhci_hcd 26768 0 - Live 0xf88b1000
ata_generic 8708 0 - Live 0xf8862000
ohci1394 34096 0 - Live 0xf88a7000
ieee1394 94648 2 sbp2,ohci1394, Live 0xf896f000
8139too 29312 0 - Live 0xf8855000
mii 6784 2 8139cp,8139too, Live 0xf8852000
libata 124596 2 ata_piix,ata_generic, Live 0xf894f000
ehci_hcd 37644 0 - Live 0xf8845000
scsi_mod 146700 5 sbp2,sg,sr_mod,sd_mod,libata, Live 0xf8a4a000
generic 6020 0 [permanent], Live 0xf8867000
usbcore 143368 4 usbhid,uhci_hcd,ehci_hcd, Live 0xf8a25000
thermal 14600 0 - Live 0xf883b000
processor 34760 2 acpi_cpufreq,thermal, Live 0xf882a000
fan 6148 0 - Live 0xf8842000
+ cat /proc/ioports
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
0170-0177 : 0000:00:1f.2
  0170-0177 : libata
01f0-01f7 : 0000:00:1f.2
  01f0-01f7 : libata
0376-0376 : 0000:00:1f.2
  0376-0376 : libata
03c0-03df : vga+
03f6-03f6 : 0000:00:1f.2
  03f6-03f6 : libata
0400-041f : 0000:00:1f.3
0480-04bf : 0000:00:1f.0
0800-087f : 0000:00:1f.0
  0800-0803 : ACPI PM1a_EVT_BLK
  0804-0805 : ACPI PM1a_CNT_BLK
  0808-080b : ACPI PM_TMR
  0810-0815 : ACPI CPU throttle
  0820-0820 : ACPI PM2_CNT_BLK
  0828-082f : ACPI GPE0_BLK
  0860-087f : iTCO_wdt
0cf8-0cff : PCI conf1
a000-afff : PCI Bus #02
c000-dfff : PCI Bus #03
  d800-d8ff : 0000:03:04.0
    d800-d8ff : 8139too
e400-e41f : 0000:00:1d.3
  e400-e41f : uhci_hcd
e480-e49f : 0000:00:1d.2
  e480-e49f : uhci_hcd
e800-e81f : 0000:00:1d.1
  e800-e81f : uhci_hcd
e880-e89f : 0000:00:1d.0
  e880-e89f : uhci_hcd
ec00-ec07 : 0000:00:02.0
ffa0-ffaf : 0000:00:1f.2
  ffa0-ffaf : libata
+ cat /proc/iomem
00000000-0009fbff : System RAM
  00000000-00000000 : Crash kernel
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000cf000-000cffff : Adapter ROM
000d0000-000d0fff : Adapter ROM
000f0000-000fffff : System ROM
00100000-3f7bffff : System RAM
  00100000-0030125e : Kernel code
  0030125f-003e9743 : Kernel data
3f7c0000-3f7cdfff : ACPI Tables
3f7ce000-3f7fffff : ACPI Non-volatile Storage
bdf00000-bfefffff : PCI Bus #03
d0000000-dfffffff : 0000:00:02.0
e0000000-efffffff : pnp 00:0b
fec00000-fec00fff : pnp 00:09
fed00000-fed003ff : HPET 0
fed13000-fed19fff : pnp 00:01
fed1c000-fed1ffff : pnp 00:0a
fed20000-fed8ffff : pnp 00:0a
fee00000-fee00fff : reserved
fef00000-ff2fffff : PCI Bus #02
ff300000-ffbfffff : PCI Bus #03
  ff300000-ff300fff : 0000:03:06.0
    ff300000-ff3007ff : ohci1394
  ffbfe000-ffbfe7ff : 0000:03:06.0
  ffbfe800-ffbfe8ff : 0000:03:06.2
  ffbfec00-ffbfecff : 0000:03:04.0
    ffbfec00-ffbfecff : 8139too
  ffbff000-ffbfffff : 0000:03:06.3
ffd80000-ffdfffff : 0000:00:02.1
ffe37c00-ffe37fff : 0000:00:1d.7
  ffe37c00-ffe37fff : ehci_hcd
ffe38000-ffe3bfff : 0000:00:1b.0
  ffe38000-ffe3bfff : ICH HD audio
ffe40000-ffe7ffff : 0000:00:02.0
ffe80000-ffefffff : 0000:00:02.0
fff00000-ffffffff : reserved
+ lspci -vvv
00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS/940GML and 945GT Express Memory Controller Hub (rev 03)
	Subsystem: TWINHEAD INTERNATIONAL Corp Unknown device a003
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information

00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS/940GML Express Integrated Graphics Controller (rev 03) (prog-if 00 [VGA])
	Subsystem: TWINHEAD INTERNATIONAL Corp Unknown device a003
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at ffe80000 (32-bit, non-prefetchable) [size=512K]
	Region 1: I/O ports at ec00 [size=8]
	Region 2: Memory at d0000000 (32-bit, prefetchable) [size=256M]
	Region 3: Memory at ffe40000 (32-bit, non-prefetchable) [size=256K]
	Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable-
		Address: 00000000  Data: 0000
	Capabilities: [d0] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/940GML Express Integrated Graphics Controller (rev 03)
	Subsystem: TWINHEAD INTERNATIONAL Corp Unknown device a003
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Region 0: Memory at ffd80000 (32-bit, non-prefetchable) [size=512K]
	Capabilities: [d0] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 02)
	Subsystem: TWINHEAD INTERNATIONAL Corp Unknown device a003
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at ffe38000 (64-bit, non-prefetchable) [size=16K]
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

00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 (rev 02) (prog-if 00 [Normal decode])
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
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
		Slot: Number 0, PowerLimit 0.000000
		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
		Slot: AttnInd Unknown, PwrInd Unknown, Power-
		Root: Correctable- Non-Fatal- Fatal- PME-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
		Address: fee0300c  Data: 41c1
	Capabilities: [90] Subsystem: TWINHEAD INTERNATIONAL Corp Unknown device a003
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 2 (rev 02) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 0000a000-0000afff
	Memory behind bridge: fef00000-ff2fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: [40] Express Root Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s unlimited, L1 unlimited
		Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 2
		Link: Latency L0s <1us, L1 <4us
		Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x0
		Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
		Slot: Number 0, PowerLimit 0.000000
		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
		Slot: AttnInd Unknown, PwrInd Unknown, Power-
		Root: Correctable- Non-Fatal- Fatal- PME-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0 Enable+
		Address: fee0300c  Data: 41c9
	Capabilities: [90] Subsystem: TWINHEAD INTERNATIONAL Corp Unknown device a003
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #1 (rev 02) (prog-if 00 [UHCI])
	Subsystem: TWINHEAD INTERNATIONAL Corp Unknown device a003
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 18
	Region 4: I/O ports at e880 [size=32]

00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #2 (rev 02) (prog-if 00 [UHCI])
	Subsystem: TWINHEAD INTERNATIONAL Corp Unknown device a003
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 4: I/O ports at e800 [size=32]

00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #3 (rev 02) (prog-if 00 [UHCI])
	Subsystem: TWINHEAD INTERNATIONAL Corp Unknown device a003
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin C routed to IRQ 21
	Region 4: I/O ports at e480 [size=32]

00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #4 (rev 02) (prog-if 00 [UHCI])
	Subsystem: TWINHEAD INTERNATIONAL Corp Unknown device a003
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin D routed to IRQ 16
	Region 4: I/O ports at e400 [size=32]

00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 02) (prog-if 20 [EHCI])
	Subsystem: TWINHEAD INTERNATIONAL Corp Unknown device a003
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at ffe37c00 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2) (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Bus: primary=00, secondary=03, subordinate=04, sec-latency=32
	I/O behind bridge: 0000c000-0000dfff
	Memory behind bridge: ff300000-ffbfffff
	Prefetchable memory behind bridge: 00000000bdf00000-00000000bfefffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR+
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: [50] Subsystem: TWINHEAD INTERNATIONAL Corp Unknown device a003

00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge (rev 02)
	Subsystem: TWINHEAD INTERNATIONAL Corp Unknown device a003
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information

00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) Serial ATA Storage Controller IDE (rev 02) (prog-if 80 [Master])
	Subsystem: TWINHEAD INTERNATIONAL Corp Unknown device a003
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374 [size=1]
	Region 4: I/O ports at ffa0 [size=16]
	Capabilities: [70] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 02)
	Subsystem: TWINHEAD INTERNATIONAL Corp Unknown device a003
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin B routed to IRQ 5
	Region 4: I/O ports at 0400 [size=32]

03:04.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ (rev 10)
	Subsystem: TWINHEAD INTERNATIONAL Corp Unknown device a003
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (8000ns min, 16000ns max)
	Interrupt: pin A routed to IRQ 16
	Region 0: I/O ports at d800 [size=256]
	Region 1: Memory at ffbfec00 (32-bit, non-prefetchable) [size=256]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0-,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

03:06.0 FireWire (IEEE 1394): O2 Micro, Inc. Firewire (IEEE 1394) (rev 02) (prog-if 10 [OHCI])
	Subsystem: TWINHEAD INTERNATIONAL Corp Unknown device a003
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at ff300000 (32-bit, non-prefetchable) [size=4K]
	Region 1: Memory at ffbfe000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME+

03:06.2 Generic system peripheral [0805]: O2 Micro, Inc. Integrated MMC/SD Controller (rev 01)
	Subsystem: TWINHEAD INTERNATIONAL Corp Unknown device a003
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin A routed to IRQ 5
	Region 0: Memory at ffbfe800 (32-bit, non-prefetchable) [size=256]
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

03:06.3 Mass storage controller: O2 Micro, Inc. Integrated MS/xD Controller (rev 01)
	Subsystem: TWINHEAD INTERNATIONAL Corp Unknown device a003
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR+
	Interrupt: pin A routed to IRQ 5
	Region 0: Memory at ffbff000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

+ cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: FUJITSU MHV2100B Rev: 0000
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: Optiarc  Model: DVD RW AD-5530A  Rev: AX24
  Type:   CD-ROM                           ANSI  SCSI revision: 05
