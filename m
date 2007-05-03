Return-Path: <linux-kernel-owner+w=401wt.eu-S964810AbXECIlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964810AbXECIlp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 04:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933004AbXECIlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 04:41:45 -0400
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:50974 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932768AbXECIln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 04:41:43 -0400
Date: Thu, 3 May 2007 10:41:41 +0200
From: Wolfgang Erig <Wolfgang.Erig@gmx.de>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: regression on quad Xeon: no SCSI-disks
Message-ID: <20070503084141.GA22742@erig.dyndns.org>
Mail-Followup-To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
	Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20070501142431.GA11667@erig.dyndns.org> <46376474.8090505@redhat.com> <20070502144716.GA11061@erig.dyndns.org> <20070502211215.A19444@jurassic.park.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070502211215.A19444@jurassic.park.msu.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ivan,

On Wed, May 02, 2007 at 09:12:15PM +0400, Ivan Kokshaysky wrote:
> On Wed, May 02, 2007 at 04:47:16PM +0200, Wolfgang Erig wrote:
> > On Tue, May 01, 2007 at 12:01:56PM -0400, Chuck Ebbert wrote:
> > > Output from kernel with CONFIG_PCI_DEBUG could be useful.
> > > 
> > Linux version 2.6.21-gde46c337 (erig@pippin) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #3 SMP Wed May 2 08:39:55 CEST 2007
> 
> Still no clues. Could you post 'lspci -vvv', 'cat /proc/ioports' and
> 'cat /proc/iomem' outputs from working kernel?

the output is attached.

I saw a strange problem with ehternet too.
After booting the bad kernel and reboot the good kernel,
the ethernet doesn't work anymore. Multiple reboot, power off,
trying older kernel 2.4.27 didn't help. Pulling the power cable
fixed the problem.

I am prepared to do tweaks to your small patch, but I need your help.
My own blindly experiments failed miserably.

Wolfgang


$ uname -a
Linux pippin 2.6.12 #1 SMP Mon Apr 30 17:31:13 CEST 2007 i686 GNU/Linux
$ lspci -vvv
00:02.0 ISA bridge: Intel Corporation 82371AB/EB/MB PIIX4 ISA (rev 02)
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0

00:02.1 IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev 01) (prog-if 80 [Master])
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64
	Region 4: I/O ports at 2020 [disabled] [size=16]

00:02.2 USB Controller: Intel Corporation 82371AB/EB/MB PIIX4 USB (rev 01) (prog-if 00 [UHCI])
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64
	Interrupt: pin D routed to IRQ 19
	Region 4: I/O ports at 2000 [size=32]

00:02.3 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 02)
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin ? routed to IRQ 9

00:03.0 VGA compatible controller: Cirrus Logic GD 5446 (rev 45) (prog-if 00 [VGA])
	Subsystem: Siemens Nixdorf AG Unknown device 0034
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Region 0: Memory at fc000000 (32-bit, prefetchable) [size=32M]
	Region 1: Memory at fa000000 (32-bit, non-prefetchable) [size=4K]

00:04.0 System peripheral: Siemens Nixdorf AG FSC Multiprocessor Interrupt Controller (rev 02)
	Subsystem: Siemens Nixdorf AG Unknown device 0035
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Region 0: Memory at a0000000 (32-bit, non-prefetchable) [size=1K]

00:05.0 PCI bridge: Intel Corporation 80960RP [i960 RP Microprocessor/Bridge] (rev 03) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: fa100000-fa2fffff
	Prefetchable memory behind bridge: fa600000-fa6fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-

00:05.1 I2O: Intel Corporation 80960RP [i960RP Microprocessor] (rev 03) (prog-if 01)
	Subsystem: Siemens Nixdorf AG Unknown device 0036
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 28
	Region 0: Memory at fa500000 (32-bit, prefetchable) [size=1M]

00:10.0 Host bridge: Intel Corporation 450NX - 82451NX Memory & I/O Controller (rev 03)
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-

00:12.0 Host bridge: Intel Corporation 450NX - 82454NX/84460GX PCI Expander Bridge (rev 02)
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
	Latency: 72, Cache Line Size: 32 bytes

00:13.0 Host bridge: Intel Corporation 450NX - 82454NX/84460GX PCI Expander Bridge (rev 02)
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
	Latency: 72, Cache Line Size: 32 bytes

00:14.0 Host bridge: Intel Corporation 450NX - 82454NX/84460GX PCI Expander Bridge (rev 02)
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
	Latency: 72, Cache Line Size: 32 bytes

01:01.0 Ethernet controller: Intel Corporation 82557/8/9 [Ethernet Pro 100] (rev 05)
	Subsystem: Siemens Nixdorf AG Unknown device 0031
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (2000ns min, 14000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 29
	Region 0: Memory at fa600000 (32-bit, prefetchable) [size=4K]
	Region 1: I/O ports at 3800 [size=32]
	Region 2: Memory at fa100000 (32-bit, non-prefetchable) [size=1M]
	Capabilities: <access denied>

01:02.0 SCSI storage controller: LSI Logic / Symbios Logic 53c875 (rev 26)
	Subsystem: LSI Logic / Symbios Logic LSI53C876/E PCI to Dual Channel SCSI Controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 72 (4250ns min, 16000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 30
	Region 0: I/O ports at 3000 [size=256]
	Region 1: Memory at fa202000 (32-bit, non-prefetchable) [size=256]
	Region 2: Memory at fa200000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>

01:03.0 SCSI storage controller: LSI Logic / Symbios Logic 53c875 (rev 26)
	Subsystem: LSI Logic / Symbios Logic LSI53C876/E PCI to Dual Channel SCSI Controller
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 72 (4250ns min, 16000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 31
	Region 0: I/O ports at 3400 [size=256]
	Region 1: Memory at fa202400 (32-bit, non-prefetchable) [size=256]
	Region 2: Memory at fa201000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>

03:0e.0 SCSI storage controller: QLogic Corp. QLA2100 64-bit Fibre Channel Adapter (rev 03)
	Subsystem: QLogic Corp. QLA2100 64-bit Fibre Channel Adapter
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 26
	Region 0: I/O ports at 4000 [size=256]
	Region 1: Memory at fe200000 (32-bit, non-prefetchable) [size=4K]

$ cat /proc/ioports
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
02e8-02ef : serial
02f8-02ff : serial
0378-037a : parport0
03c0-03df : vga+
03e8-03ef : serial
03f8-03ff : serial
0cf8-0cff : PCI conf1
1000-103f : 0000:00:02.3
1040-105f : 0000:00:02.3
2000-201f : 0000:00:02.2
2020-202f : 0000:00:02.1
3000-3fff : PCI Bus #01
  3000-30ff : 0000:01:02.0
    3000-30ff : sym53c8xx
  3400-34ff : 0000:01:03.0
    3400-34ff : sym53c8xx
  3800-381f : 0000:01:01.0
    3800-381f : eepro100
4000-40ff : 0000:03:0e.0
$ cat /proc/iomem
00000000-0009d3ff : System RAM
0009d400-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000c8000-000cbfff : Adapter ROM
000f0000-000fffff : System ROM
00100000-9fffffff : System RAM
  00100000-0022f9be : Kernel code
  0022f9bf-002cc67f : Kernel data
a0000000-a00003ff : 0000:00:04.0
fa000000-fa000fff : 0000:00:03.0
fa100000-fa2fffff : PCI Bus #01
  fa100000-fa1fffff : 0000:01:01.0
  fa200000-fa200fff : 0000:01:02.0
    fa200000-fa200fff : sym53c8xx
  fa201000-fa201fff : 0000:01:03.0
    fa201000-fa201fff : sym53c8xx
  fa202000-fa2020ff : 0000:01:02.0
    fa202000-fa2020ff : sym53c8xx
  fa202400-fa2024ff : 0000:01:03.0
    fa202400-fa2024ff : sym53c8xx
fa500000-fa5fffff : 0000:00:05.1
fa600000-fa6fffff : PCI Bus #01
  fa600000-fa600fff : 0000:01:01.0
    fa600000-fa600fff : eepro100
fc000000-fdffffff : 0000:00:03.0
fe200000-fe200fff : 0000:03:0e.0
fec00000-fecfffff : reserved
fee00000-feefffff : reserved
ffe00000-ffffffff : reserved
