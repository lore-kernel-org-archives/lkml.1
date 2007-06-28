Return-Path: <linux-kernel-owner+w=401wt.eu-S932312AbXF2ABU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312AbXF2ABU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 20:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759461AbXF2ABN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 20:01:13 -0400
Received: from 65.44.231.216.in-addr ([216.231.44.65]:45041 "EHLO
	hoth.localdomain" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759390AbXF2ABL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 20:01:11 -0400
X-Greylist: delayed 615 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Jun 2007 20:01:10 EDT
From: Zach Carter <linux@zachcarter.com>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc6-mm1 Intel DMAR crash on AMD x86_64
Date: Thu, 28 Jun 2007 16:50:52 -0700
User-Agent: KMail/1.9.6
References: <20070628034321.38c9f12b.akpm@linux-foundation.org> <1183063232.7813.23.camel@localhost>
In-Reply-To: <1183063232.7813.23.camel@localhost>
Cc: Zan Lynx <zlynx@acm.org>, ashok.raj@intel.com, shaohua.li@intel.com,
       anil.s.keshavamurthy@intel.com,
       Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706281650.53004.linux@zachcarter.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 June 2007 01:40:32 pm you wrote:

> I'll provide more details on request, and when I get the chance.  This
> is a heads-up on the BUG in case someone has an "ah ha!" moment.

I believe I have also reproduced this bug.   I have an ABIT K9 Ultra 
motherboard with NFORCE hardware.   My serial console cannot 
seem to capture it, but removing the DMAR options definately takes 
away the problem and allows me to boot.

If anyone would like me to gather other info or test out patches, 
please let me know.  

Linux hoth 2.6.22-rc6-mm1 #8 SMP Thu Jun 28 16:18:17 PDT 2007 x86_64 x86_64 x86_64 GNU/Linux
 
Gnu C                  4.1.2
Gnu make               3.81
binutils               2.17.50.0.12-4
util-linux             2.13-pre7
mount                  2.13-pre7
module-init-tools      3.3-pre11
e2fsprogs              1.39
pcmciautils            014
quota-tools            3.14.
PPP                    2.4.4
isdn4k-utils           3.9
Linux C Library        > libc.2.6
Dynamic linker (ldd)   2.6
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.12
oprofile               0.9.2
Sh-utils               6.9
udev                   106
wireless-tools         28
Modules Loaded         tun ppdev ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 xt_state nf_conntrack nfnetlink ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables bridge llc hidp l2cap bluetooth ipv6 dm_mirror dm_multipath dm_mod raid10 raid0 video output sbs button dock battery ac lp loop kvm_amd kvm parport_serial snd_hda_intel snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd parport_pc parport soundcore snd_page_alloc usblp k8temp serio_raw hwmon forcedeth shpchp i2c_nforce2 i2c_core sr_mod cdrom floppy sg pata_amd sata_nv libata sd_mod scsi_mod raid456 async_xor async_memcpy async_tx xor raid1 ext3 jbd mbcache ehci_hcd ohci_hcd uhci_hcd

[root@hoth ~]# cat /proc/cpuinfo
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 75
model name      : AMD Athlon(tm) 64 X2 Dual Core Processor 3800+
stepping        : 2
cpu MHz         : 1000.000
cache size      : 512 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm 3dnowext 3dnow rep_good pni cx16 lahf_lm cmp_legacy svm extapic cr8_legacy
bogomips        : 2000.92
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc

processor       : 1
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 75
model name      : AMD Athlon(tm) 64 X2 Dual Core Processor 3800+
stepping        : 2
cpu MHz         : 1000.000
cache size      : 512 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm 3dnowext 3dnow rep_good pni cx16 lahf_lm cmp_legacy svm extapic cr8_legacy
bogomips        : 2000.92
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc

00:00.0 RAM memory: nVidia Corporation MCP55 Memory Controller (rev a1)
	Subsystem: ABIT Computer Corp. Unknown device 1c24
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Capabilities: [44] HyperTransport: Slave or Primary Interface
		Command: BaseUnitID=0 UnitCnt=15 MastHost- DefDir- DUL-
		Link Control 0: CFlE+ CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- LSEn+ ExtCTL- 64b-
		Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
		Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
		Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit DwFcInEn- LWO=8bit DwFcOutEn-
		Revision ID: 1.03
		Link Frequency 0: 1.0GHz
		Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 0: 200MHz+ 300MHz+ 400MHz+ 500MHz+ 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
		Link Frequency 1: 200MHz
		Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 600MHz- 800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Error Handling: PFlE+ OFlE+ PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF- RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
		Prefetchable memory behind bridge Upper: 00-00
		Bus Number: 00
	Capabilities: [e0] #00 [fee0]

00:01.0 ISA bridge: nVidia Corporation MCP55 LPC Bridge (rev a2)
	Subsystem: ABIT Computer Corp. Unknown device 1c24
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0

00:01.1 SMBus: nVidia Corporation MCP55 SMBus (rev a2)
	Subsystem: ABIT Computer Corp. Unknown device 1c24
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin A routed to IRQ 11
	Region 0: I/O ports at fc00 [size=64]
	Region 4: I/O ports at 1c00 [size=64]
	Region 5: I/O ports at 1c40 [size=64]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:01.2 RAM memory: nVidia Corporation MCP55 Memory Controller (rev a2)
	Subsystem: ABIT Computer Corp. Unknown device 1c24
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-

00:02.0 USB Controller: nVidia Corporation MCP55 USB Controller (rev a1) (prog-if 10 [OHCI])
	Subsystem: ABIT Computer Corp. Unknown device 1c24
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at fe02f000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:02.1 USB Controller: nVidia Corporation MCP55 USB Controller (rev a2) (prog-if 20 [EHCI])
	Subsystem: ABIT Computer Corp. Unknown device 1c24
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin B routed to IRQ 22
	Region 0: Memory at fe02e000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [44] Debug port
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME+

00:04.0 IDE interface: nVidia Corporation MCP55 IDE (rev a1) (prog-if 8a [Master SecP PriP])
	Subsystem: Unknown device f47b:1c24
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0 (750ns min, 250ns max)
	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=8]
	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=1]
	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=8]
	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=1]
	Region 4: I/O ports at f000 [size=16]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:05.0 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a2) (prog-if 85 [Master SecO PriO])
	Subsystem: ABIT Computer Corp. Unknown device 1c24
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin A routed to IRQ 21
	Region 0: I/O ports at 09f0 [size=8]
	Region 1: I/O ports at 0bf0 [size=4]
	Region 2: I/O ports at 0970 [size=8]
	Region 3: I/O ports at 0b70 [size=4]
	Region 4: I/O ports at dc00 [size=16]
	Region 5: Memory at fe02d000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [b0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/2 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [cc] HyperTransport: MSI Mapping

00:05.1 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a2) (prog-if 85 [Master SecO PriO])
	Subsystem: ABIT Computer Corp. Unknown device 1c24
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin B routed to IRQ 20
	Region 0: I/O ports at 09e0 [size=8]
	Region 1: I/O ports at 0be0 [size=4]
	Region 2: I/O ports at 0960 [size=8]
	Region 3: I/O ports at 0b60 [size=4]
	Region 4: I/O ports at c800 [size=16]
	Region 5: Memory at fe02c000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [b0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/2 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [cc] HyperTransport: MSI Mapping

00:05.2 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a2) (prog-if 85 [Master SecO PriO])
	Subsystem: ABIT Computer Corp. Unknown device 1c24
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin C routed to IRQ 23
	Region 0: I/O ports at c400 [size=8]
	Region 1: I/O ports at c000 [size=4]
	Region 2: I/O ports at bc00 [size=8]
	Region 3: I/O ports at b800 [size=4]
	Region 4: I/O ports at b400 [size=16]
	Region 5: Memory at fe02b000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [b0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/2 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [cc] HyperTransport: MSI Mapping

00:06.0 PCI bridge: nVidia Corporation MCP55 PCI bridge (rev a2) (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
	I/O behind bridge: 00008000-00009fff
	Memory behind bridge: fdd00000-fddfffff
	Prefetchable memory behind bridge: fde00000-fdefffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
	Capabilities: [b8] Subsystem: nVidia Corporation Unknown device cb84
	Capabilities: [8c] HyperTransport: MSI Mapping

00:06.1 Audio device: nVidia Corporation MCP55 High Definition Audio (rev a2)
	Subsystem: ABIT Computer Corp. Unknown device 1c20
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0 (500ns min, 1250ns max)
	Interrupt: pin B routed to IRQ 20
	Region 0: Memory at fe020000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] Message Signalled Interrupts: Mask+ 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [6c] HyperTransport: MSI Mapping

00:08.0 Bridge: nVidia Corporation MCP55 Ethernet (rev a2)
	Subsystem: ABIT Computer Corp. Unknown device 1c24
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0 (250ns min, 5000ns max)
	Interrupt: pin A routed to IRQ 2299
	Region 0: Memory at fe02a000 (32-bit, non-prefetchable) [size=4K]
	Region 1: I/O ports at b000 [size=8]
	Region 2: Memory at fe029000 (32-bit, non-prefetchable) [size=256]
	Region 3: Memory at fe028000 (32-bit, non-prefetchable) [size=16]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable+ DSel=0 DScale=0 PME-
	Capabilities: [70] MSI-X: Enable- Mask- TabSize=8
		Vector table: BAR=2 offset=00000000
		PBA: BAR=3 offset=00000000
	Capabilities: [50] Message Signalled Interrupts: Mask+ 64bit+ Queue=0/3 Enable+
		Address: 00000000fee0200c  Data: 4191
		Masking: 000000fe  Pending: 00000000
	Capabilities: [6c] HyperTransport: MSI Mapping

00:09.0 Bridge: nVidia Corporation MCP55 Ethernet (rev a2)
	Subsystem: ABIT Computer Corp. Unknown device 1c24
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0 (250ns min, 5000ns max)
	Interrupt: pin A routed to IRQ 2298
	Region 0: Memory at fe027000 (32-bit, non-prefetchable) [size=4K]
	Region 1: I/O ports at ac00 [size=8]
	Region 2: Memory at fe026000 (32-bit, non-prefetchable) [size=256]
	Region 3: Memory at fe025000 (32-bit, non-prefetchable) [size=16]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable+ DSel=0 DScale=0 PME-
	Capabilities: [70] MSI-X: Enable- Mask- TabSize=8
		Vector table: BAR=2 offset=00000000
		PBA: BAR=3 offset=00000000
	Capabilities: [50] Message Signalled Interrupts: Mask+ 64bit+ Queue=0/3 Enable+
		Address: 00000000fee0100c  Data: 4199
		Masking: 000000fe  Pending: 00000000
	Capabilities: [6c] HyperTransport: MSI Mapping

00:0c.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev a2) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 00007000-00007fff
	Memory behind bridge: fdc00000-fdcfffff
	Prefetchable memory behind bridge: 00000000fdb00000-00000000fdbfffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
	Capabilities: [40] Subsystem: nVidia Corporation Unknown device 0000
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable+
		Address: 00000000fee0300c  Data: 4149
	Capabilities: [60] HyperTransport: MSI Mapping
	Capabilities: [80] Express Root Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <512ns, L1 <4us
		Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
		Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
		Device: MaxPayload 256 bytes, MaxReadReq 512 bytes
		Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 3
		Link: Latency L0s <512ns, L1 <4us
		Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x4
		Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug- Surpise-
		Slot: Number 0, PowerLimit 0.000000
		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
		Slot: AttnInd Off, PwrInd On, Power-
		Root: Correctable- Non-Fatal- Fatal- PME-
	Capabilities: [100] Virtual Channel

00:0d.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev a2) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 00006000-00006fff
	Memory behind bridge: fda00000-fdafffff
	Prefetchable memory behind bridge: 00000000fd900000-00000000fd9fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
	Capabilities: [40] Subsystem: nVidia Corporation Unknown device 0000
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable+
		Address: 00000000fee0300c  Data: 4151
	Capabilities: [60] HyperTransport: MSI Mapping
	Capabilities: [80] Express Root Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <512ns, L1 <4us
		Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
		Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
		Device: MaxPayload 256 bytes, MaxReadReq 512 bytes
		Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 2
		Link: Latency L0s <512ns, L1 <4us
		Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x4
		Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug- Surpise-
		Slot: Number 0, PowerLimit 0.000000
		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
		Slot: AttnInd Off, PwrInd On, Power-
		Root: Correctable- Non-Fatal- Fatal- PME-
	Capabilities: [100] Virtual Channel

00:0e.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev a2) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	I/O behind bridge: 00005000-00005fff
	Memory behind bridge: fd800000-fd8fffff
	Prefetchable memory behind bridge: 00000000fd700000-00000000fd7fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
	Capabilities: [40] Subsystem: nVidia Corporation Unknown device 0000
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable+
		Address: 00000000fee0300c  Data: 4159
	Capabilities: [60] HyperTransport: MSI Mapping
	Capabilities: [80] Express Root Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <512ns, L1 <4us
		Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
		Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
		Device: MaxPayload 256 bytes, MaxReadReq 512 bytes
		Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 1
		Link: Latency L0s <512ns, L1 <4us
		Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x8
		Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug- Surpise-
		Slot: Number 0, PowerLimit 0.000000
		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
		Slot: AttnInd Off, PwrInd On, Power-
		Root: Correctable- Non-Fatal- Fatal- PME-
	Capabilities: [100] Virtual Channel

00:0f.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev a2) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
	I/O behind bridge: 00004000-00004fff
	Memory behind bridge: fd600000-fd6fffff
	Prefetchable memory behind bridge: 00000000e0000000-00000000efffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-
	Capabilities: [40] Subsystem: nVidia Corporation Unknown device 0000
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable+
		Address: 00000000fee0300c  Data: 4161
	Capabilities: [60] HyperTransport: MSI Mapping
	Capabilities: [80] Express Root Port (Slot+) IRQ 0
		Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <512ns, L1 <4us
		Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
		Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
		Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
		Link: Supported Speed 2.5Gb/s, Width x16, ASPM L0s L1, Port 0
		Link: Latency L0s <512ns, L1 <4us
		Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
		Link: Speed 2.5Gb/s, Width x16
		Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug- Surpise-
		Slot: Number 0, PowerLimit 0.000000
		Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
		Slot: AttnInd Off, PwrInd On, Power-
		Root: Correctable- Non-Fatal- Fatal- PME-
	Capabilities: [100] Virtual Channel

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Capabilities: [80] HyperTransport: Host or Secondary Interface
		!!! Possibly incomplete decoding
		Command: WarmRst+ DblEnd-
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0
		Link Config: MLWI=16bit MLWO=16bit LWI=16bit LWO=16bit
		Revision ID: 1.02

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Capabilities: [f0] #0f [0010]

01:08.0 FireWire (IEEE 1394): Texas Instruments TSB43AB22/A IEEE-1394a-2000 Controller (PHY/Link) (prog-if 10 [OHCI])
	Subsystem: ABIT Computer Corp. Unknown device 1c20
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 2 (500ns min, 1000ns max), Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at fddff000 (32-bit, non-prefetchable) [size=2K]
	Region 1: Memory at fddf8000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

01:09.0 Serial controller: NetMos Technology PCI 9835 Multi-I/O Controller (rev 01) (prog-if 02 [16550])
	Subsystem: LSI Logic / Symbios Logic Unknown device 0001
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin A routed to IRQ 17
	Region 0: I/O ports at 9c00 [size=8]
	Region 1: I/O ports at 9800 [size=8]
	Region 2: I/O ports at 9400 [size=8]
	Region 3: I/O ports at 9000 [size=8]
	Region 4: I/O ports at 8c00 [size=8]
	Region 5: I/O ports at 8800 [size=16]

05:00.0 VGA compatible controller: ATI Technologies Inc RV370 [Sapphire X550 Silent] (prog-if 00 [VGA])
	Subsystem: PC Partner Limited Unknown device 1490
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at e0000000 (32-bit, prefetchable) [size=256M]
	Region 1: I/O ports at 4c00 [size=256]
	Region 2: Memory at fd6f0000 (32-bit, non-prefetchable) [size=64K]
	[virtual] Expansion ROM at fd600000 [disabled] [size=128K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express Endpoint IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag+
		Device: Latency L0s <128ns, L1 <2us
		Device: AtnBtn- AtnInd- PwrInd-
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed 2.5Gb/s, Width x16, ASPM L0s L1, Port 0
		Link: Latency L0s <128ns, L1 <1us
		Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
		Link: Speed 2.5Gb/s, Width x16
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [100] Advanced Error Reporting

05:00.1 Display controller: ATI Technologies Inc RV370 secondary [Sapphire X550 Silent]
	Subsystem: PC Partner Limited Unknown device 1491
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Region 0: Memory at fd6e0000 (32-bit, non-prefetchable) [disabled] [size=64K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express Endpoint IRQ 0
		Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
		Device: Latency L0s <128ns, L1 <2us
		Device: AtnBtn- AtnInd- PwrInd-
		Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
		Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
		Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
		Link: Supported Speed 2.5Gb/s, Width x16, ASPM L0s L1, Port 0
		Link: Latency L0s <128ns, L1 <1us
		Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
		Link: Speed 2.5Gb/s, Width x16



