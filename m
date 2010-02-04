Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933285Ab0BDU1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 15:27:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51482 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756513Ab0BDU1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 15:27:46 -0500
Date: Thu, 4 Feb 2010 21:27:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dave Airlie <airlied@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@linux.ie>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: hung bootup with "drm/radeon/kms: move radeon KMS on/off switch
 out of staging."
Message-ID: <20100204202735.GB24716@elte.hu>
References: <20100204170826.GA16397@elte.hu>
 <20100204173602.GA19855@srcf.ucam.org>
 <20100204175445.GB27361@elte.hu>
 <20100204175928.GA20595@srcf.ucam.org>
 <20100204181218.GA6175@elte.hu>
 <a728f9f91002041030o7c8d38edxe573bc0a1327d79@mail.gmail.com>
 <20100204190649.GB6665@elte.hu>
 <a728f9f91002041118m6415844fp1740f18fdc1c9757@mail.gmail.com>
 <alpine.LFD.2.00.1002041123400.3707@localhost.localdomain>
 <21d7e9971002041134m7e4d1a8dif65ccee8b7fbc203@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d7e9971002041134m7e4d1a8dif65ccee8b7fbc203@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Airlie <airlied@gmail.com> wrote:

> On Fri, Feb 5, 2010 at 5:24 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> >
> > On Thu, 4 Feb 2010, Alex Deucher wrote:
> >>
> >> And if it crashes, he'll report a bug and we'll fix it.
> >
> > Ok, you have a bug-report. See earlier in the thread:
> >
> >> btw., i just found another bug activated via this same commit, a boot hang
> >> after DRM init:
> >>
> >> [ ? ?9.858352] [drm] Connector 1:
> >> [ ? ?9.861417] [drm] ? DVI-I
> >> [ ? ?9.864031] [drm] ? HPD1
> >> [ ? ?9.866562] [drm] ? DDC: 0x64 0x64 0x64 0x64 0x64 0x64 0x64 0x64
> >> [ ? ?9.872579] [drm] ? Encoders:
> >> [ ? ?9.875540] [drm] ? ? CRT2: INTERNAL_DAC2
> >> [ ? ?9.879541] [drm] ? ? DFP1: INTERNAL_TMDS1
> >> [ ? ?9.883646] [drm] Connector 2:
> >> [ ? ?9.886695] [drm] ? S-video
> >> [ ? ?9.889483] [drm] ? Encoders:
> >> [ ? ?9.892463] [drm] ? ? TV1: INTERNAL_DAC2
> >> [ ? ?9.896392] i2c i2c-0: master_xfer[0] W, addr=0x50, len=1
> >> [ ? ?9.901796] i2c i2c-0: master_xfer[1] R, addr=0x50, len=128
> >> [ ? ?9.909246] i2c i2c-0: NAK from device addr 0x50 msg #0
> >> [ ? ?9.914564] i2c i2c-1: master_xfer[0] W, addr=0x50, len=1
> >> [ ? ?9.919957] i2c i2c-1: master_xfer[1] R, addr=0x50, len=128
> >> [ ? ?9.927413] i2c i2c-1: NAK from device addr 0x50 msg #0
> >
> > So can we get it fixed, please?
> 
> Ingo,
> 
> got the full dmesg?

Yes, see my report in this thread. Full bootlog up to the hang (serial 
captured) was attached, alongside the kernel config.

> and lspci -vvnn

Attached below.

> the bug reporting needs work, this snippet hasn't the useful info in it.

Linus quoted only the relevant portion of my full bugreport. All the other 
info is in the full mail he quoted.

	Ingo

------------------>

00:00.0 Memory controller [0580]: nVidia Corporation CK804 Memory Controller [10de:005e] (rev a3)
	Subsystem: ASUSTeK Computer Inc. A8N-E Mainboard [1043:815a]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Capabilities: <access denied>

00:01.0 ISA bridge [0601]: nVidia Corporation CK804 ISA Bridge [10de:0050] (rev a3)
	Subsystem: ASUSTeK Computer Inc. K8N4-E or A8N-E Mainboard [1043:815a]
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0

00:01.1 SMBus [0c05]: nVidia Corporation CK804 SMBus [10de:0052] (rev a2)
	Subsystem: ASUSTeK Computer Inc. K8N4-E or A8N-E Mainboard [1043:815a]
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin A routed to IRQ 0
	Region 0: I/O ports at dc00 [size=32]
	Region 4: I/O ports at 4c00 [size=64]
	Region 5: I/O ports at 4c40 [size=64]
	Capabilities: <access denied>

00:02.0 USB Controller [0c03]: nVidia Corporation CK804 USB Controller [10de:005a] (rev a2) (prog-if 10 [OHCI])
	Subsystem: ASUSTeK Computer Inc. K8N4-E or A8N-E Mainboard [1043:815a]
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin A routed to IRQ 0
	Region 0: Memory at da102000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>

00:02.1 USB Controller [0c03]: nVidia Corporation CK804 USB Controller [10de:005b] (rev a3) (prog-if 20 [EHCI])
	Subsystem: ASUSTeK Computer Inc. K8N4-E or A8N-E Mainboard [1043:815a]
	Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin B routed to IRQ 0
	Region 0: Memory at feb00000 (32-bit, non-prefetchable) [size=256]
	Capabilities: <access denied>

00:04.0 Multimedia audio controller [0401]: nVidia Corporation CK804 AC'97 Audio Controller [10de:0059] (rev a2)
	Subsystem: ASUSTeK Computer Inc. K8N4-E or A8N-E Mainboard [1043:812a]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0 (500ns min, 1250ns max)
	Interrupt: pin A routed to IRQ 3
	Region 0: I/O ports at d400 [size=256]
	Region 1: I/O ports at d800 [size=256]
	Region 2: Memory at da101000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: <access denied>

00:06.0 IDE interface [0101]: nVidia Corporation CK804 IDE [10de:0053] (rev f2) (prog-if 8a [Master SecP PriP])
	Subsystem: ASUSTeK Computer Inc. K8N4-E or A8N-E Mainboard [1043:815a]
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0 (750ns min, 250ns max)
	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=8]
	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=1]
	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=8]
	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=1]
	Region 4: I/O ports at f000 [size=16]
	Capabilities: <access denied>

00:09.0 PCI bridge [0604]: nVidia Corporation CK804 PCI Bridge [10de:005c] (rev a2) (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=128
	I/O behind bridge: 0000c000-0000cfff
	Memory behind bridge: da000000-da0fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-

00:0a.0 Bridge [0680]: nVidia Corporation CK804 Ethernet Controller [10de:0057] (rev a3)
	Subsystem: ASUSTeK Computer Inc. K8N4-E or A8N-E Mainboard [1043:8141]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0 (250ns min, 5000ns max)
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at da100000 (32-bit, non-prefetchable) [size=4K]
	Region 1: I/O ports at d000 [size=8]
	Capabilities: <access denied>

00:0b.0 PCI bridge [0604]: nVidia Corporation CK804 PCIE Bridge [10de:005d] (rev a3) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: <access denied>

00:0c.0 PCI bridge [0604]: nVidia Corporation CK804 PCIE Bridge [10de:005d] (rev a3) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: <access denied>

00:0d.0 PCI bridge [0604]: nVidia Corporation CK804 PCIE Bridge [10de:005d] (rev a3) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
	Capabilities: <access denied>

00:0e.0 PCI bridge [0604]: nVidia Corporation CK804 PCIE Bridge [10de:005d] (rev a3) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000b000-0000bfff
	Memory behind bridge: d8000000-d9ffffff
	Prefetchable memory behind bridge: 00000000d0000000-00000000d7ffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
	Capabilities: <access denied>

00:18.0 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration [1022:1100]
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Capabilities: <access denied>

00:18.1 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map [1022:1101]
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-

00:18.2 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller [1022:1102]
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-

00:18.3 Host bridge [0600]: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control [1022:1103]
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-

01:00.0 VGA compatible controller [0300]: ATI Technologies Inc RV370 5B60 [Radeon X300 (PCIE)] [1002:5b60] (prog-if 00 [VGA])
	Subsystem: PC Partner Limited Unknown device [174b:0500]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 5
	Region 0: Memory at d0000000 (32-bit, prefetchable) [size=128M]
	Region 1: I/O ports at b000 [size=256]
	Region 2: Memory at d9000000 (32-bit, non-prefetchable) [size=64K]
	[virtual] Expansion ROM at d8000000 [disabled] [size=128K]
	Capabilities: <access denied>

01:00.1 Display controller [0380]: ATI Technologies Inc RV370 [Radeon X300SE] [1002:5b70]
	Subsystem: PC Partner Limited Unknown device [174b:0501]
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Region 0: Memory at d9010000 (32-bit, non-prefetchable) [disabled] [size=64K]
	Capabilities: <access denied>

05:07.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ [10ec:8139] (rev 10)
	Subsystem: Realtek Semiconductor Co., Ltd. RT8139 [10ec:8139]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (8000ns min, 16000ns max)
	Interrupt: pin A routed to IRQ 11
	Region 0: I/O ports at c000 [size=256]
	Region 1: Memory at da000000 (32-bit, non-prefetchable) [size=256]
	Capabilities: <access denied>

