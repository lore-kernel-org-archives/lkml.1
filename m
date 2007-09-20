Return-Path: <linux-kernel-owner+w=401wt.eu-S1758793AbXITHZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793AbXITHZW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 03:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbXITHZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 03:25:05 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:30814 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbXITHZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 03:25:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Gy4ihhe8GWwnxGdarrI6sBnD24JnPxToXltIPC+FjqNflhaXD0+JBfCXHZNbfp0TVr6FCGn+9pDUesq01B8lJNf2PknqIjhcAe2oDw1BAfnumyUJMzbJyIMlalFzVASLvSxnYGoHxtNbncQ5nYuqCiv4U36QwMGkvlQcptwxsHE=
Message-ID: <46F22048.8050401@gmail.com>
Date: Thu, 20 Sep 2007 09:24:56 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: X-freeze after clflush changes [Was: 2.6.23-rc6-mm1]
References: <20070918011841.2381bd93.akpm@linux-foundation.org>	 <46F10B69.5070008@gmail.com> <46F10DCB.1090302@gmail.com>	 <46F13938.1070709@gmail.com>	 <20070919121017.0cbcbc30.akpm@linux-foundation.org>	 <20070919192453.GB18707@one.firstfloor.org>	 <46F17CA1.5080205@gmail.com>	 <20070919195425.GF18707@one.firstfloor.org>	 <46F17F27.5080000@gmail.com> <21d7e9970709191851s1b3f35c1j42faae3ce6cd0b24@mail.gmail.com>
In-Reply-To: <21d7e9970709191851s1b3f35c1j42faae3ce6cd0b24@mail.gmail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2007 03:51 AM, Dave Airlie wrote:
> On 9/20/07, Jiri Slaby <jirislaby@gmail.com> wrote:
>> On 09/19/2007 09:54 PM, Andi Kleen wrote:
>>>> Yeah. (But X doesn't run -- this is maybe the known issue in this release).
>>> What do you mean with not run?
>> (II) intel(0): Initializing HW Cursor
>> (II) intel(0): xf86BindGARTMemory: bind key 0 at 0x005ff000 (pgoffset 1535)
>> (WW) intel(0): xf86BindGARTMemory: binding of gart memory with key 0
>>         at offset 0x5ff000 failed (Invalid argument)
>>
>> Fatal server error:
>> Couldn't bind memory for front buffer
>>
>> I thought I'd seen a thread about this issue, but I can't find it now. Is it
>> known or am I seeing ghosts yet, Andrew?
>>
> 
> Can you send me a complete Xorg log file?

Maybe you are rather interested in these dmesg lines:
Linux agpgart interface v0.102
agpgart: suspend/resume problematic: resume with 3D/DRI active may lockup X.Org
on some chipset/BIOS combos (see DEBUG_AGP_PM in intel-agp.c)
agpgart: Detected an Intel G33 Chipset.
agpgart: Detected 8192K stolen memory.
agpgart: AGP aperture is 256M @ 0xd0000000
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
[drm] Initialized i915 1.6.0 20060119 on minor 0
...
set status page addr 0x00033000
agpgart: pg_start == 0x000005ff,intel_private.gtt_entries == 0x00000800
agpgart: Trying to insert into local/stolen memory

So the problem is, that X passes too low start.

The X log:
http://www.fi.muni.cz/~xslaby/sklad/Xorg.0.log.old

> and lspci -vv?
# lspci -vvx
00:00.0 Host bridge: Intel Corporation DRAM Controller (rev 02)
        Subsystem: Intel Corporation DRAM Controller
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort+ >SERR- <PERR-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information
00: 86 80 c0 29 06 00 90 20 02 00 00 06 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 c0 29
30: 00 00 00 00 e0 00 00 00 00 00 00 00 00 00 00 00

00:02.0 VGA compatible controller: Intel Corporation Integrated Graphics
Controller (rev 02) (prog-if 00 [VGA])
        Subsystem: Intel Corporation Integrated Graphics Controller
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at ffa80000 (32-bit, non-prefetchable) [size=512K]
        Region 1: I/O ports at ec00 [size=8]
        Region 2: Memory at d0000000 (32-bit, prefetchable) [size=256M]
        Region 3: Memory at ff900000 (32-bit, non-prefetchable) [size=1M]
        Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- Queue=0/0
Enable-
                Address: 00000000  Data: 0000
        Capabilities: [d0] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00: 86 80 c2 29 07 00 90 00 02 00 00 03 00 00 00 00
10: 00 00 a8 ff 01 ec 00 00 08 00 00 d0 00 00 90 ff
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 c2 29
30: 00 00 00 00 90 00 00 00 00 00 00 00 0a 01 00 00

00:03.0 Communication controller: Intel Corporation MEI Controller (rev 02)
        Subsystem: Intel Corporation MEI Controller
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 10
        Region 0: Memory at ffa7bc00 (64-bit, non-prefetchable) [size=16]
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [8c] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0
Enable-
                Address: 0000000000000000  Data: 0000
00: 86 80 c4 29 06 00 10 00 02 00 80 07 00 00 80 00
10: 04 bc a7 ff 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 c4 29
30: 00 00 00 00 50 00 00 00 00 00 00 00 0a 01 00 00

00:03.2 IDE interface: Intel Corporation PT IDER Controller (rev 02) (prog-if 85
[Master SecO PriO])
        Subsystem: Intel Corporation PT IDER Controller
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin C routed to IRQ 12
        Region 0: I/O ports at e880 [size=8]
        Region 1: I/O ports at e800 [size=4]
        Region 2: I/O ports at e480 [size=8]
        Region 3: I/O ports at e400 [size=4]
        Region 4: I/O ports at e080 [size=16]
        Capabilities: [c8] Power Management version 3
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0
Enable-
                Address: 0000000000000000  Data: 0000
00: 86 80 c6 29 05 00 b0 00 02 85 01 01 00 00 00 00
10: 81 e8 00 00 01 e8 00 00 81 e4 00 00 01 e4 00 00
20: 81 e0 00 00 00 00 00 00 00 00 00 00 86 80 c6 29
30: 00 00 00 00 c8 00 00 00 00 00 00 00 0c 03 00 00

00:03.3 Serial controller: Intel Corporation Serial KT Controller (rev 02)
(prog-if 02 [16550])
        Subsystem: Intel Corporation Serial KT Controller
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 17
        Region 0: I/O ports at e000 [size=8]
        Region 1: Memory at ffa7a000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [c8] Power Management version 3
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0
Enable-
                Address: 0000000000000000  Data: 0000
00: 86 80 c7 29 07 00 b0 00 02 02 00 07 00 00 00 00
10: 01 e0 00 00 00 a0 a7 ff 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 c7 29
30: 00 00 00 00 c8 00 00 00 00 00 00 00 05 02 00 00

00:19.0 Ethernet controller: Intel Corporation 82566DM-2 Gigabit Network
Connection (rev 02)
        Subsystem: Intel Corporation Unknown device 0000
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 318
        Region 0: Memory at ffa40000 (32-bit, non-prefetchable) [size=128K]
        Region 1: Memory at ffa79000 (32-bit, non-prefetchable) [size=4K]
        Region 2: I/O ports at dc00 [size=32]
        Capabilities: [c8] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0
Enable+
                Address: 00000000fee0300c  Data: 4199
        Capabilities: [e0] Vendor Specific Information
00: 86 80 bd 10 07 04 10 00 02 00 00 02 00 00 00 00
10: 00 00 a4 ff 00 90 a7 ff 01 dc 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 00 00
30: 00 00 00 00 c8 00 00 00 00 00 00 00 0f 01 00 00

00:1a.0 USB Controller: Intel Corporation USB UHCI Controller #4 (rev 02)
(prog-if 00 [UHCI])
        Subsystem: Intel Corporation USB UHCI Controller #4
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        Region 4: I/O ports at d880 [size=32]
        Capabilities: [50] Vendor Specific Information
00: 86 80 37 29 05 00 90 02 02 00 03 0c 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 81 d8 00 00 00 00 00 00 00 00 00 00 86 80 37 29
30: 00 00 00 00 50 00 00 00 00 00 00 00 0a 01 00 00

00:1a.1 USB Controller: Intel Corporation USB UHCI Controller #5 (rev 02)
(prog-if 00 [UHCI])
        Subsystem: Intel Corporation USB UHCI Controller #5
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 21
        Region 4: I/O ports at d800 [size=32]
        Capabilities: [50] Vendor Specific Information
00: 86 80 38 29 05 00 90 02 02 00 03 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 01 d8 00 00 00 00 00 00 00 00 00 00 86 80 38 29
30: 00 00 00 00 50 00 00 00 00 00 00 00 0e 02 00 00

00:1a.2 USB Controller: Intel Corporation USB UHCI Controller #6 (rev 02)
(prog-if 00 [UHCI])
        Subsystem: Intel Corporation USB UHCI Controller #6
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin C routed to IRQ 18
        Region 4: I/O ports at d480 [size=32]
        Capabilities: [50] Vendor Specific Information
00: 86 80 39 29 05 00 90 02 02 00 03 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 81 d4 00 00 00 00 00 00 00 00 00 00 86 80 39 29
30: 00 00 00 00 50 00 00 00 00 00 00 00 0c 03 00 00

00:1a.7 USB Controller: Intel Corporation USB2 EHCI Controller #2 (rev 02)
(prog-if 20 [EHCI])
        Subsystem: Intel Corporation USB2 EHCI Controller #2
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin D routed to IRQ 19
        Region 0: Memory at ffa7b400 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Debug port
        Capabilities: [98] Vendor Specific Information
00: 86 80 3c 29 06 00 90 02 02 20 03 0c 00 00 00 00
10: 00 b4 a7 ff 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 3c 29
30: 00 00 00 00 50 00 00 00 00 00 00 00 03 04 00 00

00:1b.0 Audio device: Intel Corporation HD Audio Controller (rev 02)
        Subsystem: Intel Corporation HD Audio Controller
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 22
        Region 0: Memory at ffa70000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
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
00: 86 80 3e 29 06 00 10 00 02 00 03 04 08 00 00 00
10: 04 00 a7 ff 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 3e 29
30: 00 00 00 00 50 00 00 00 00 00 00 00 07 01 00 00

00:1d.0 USB Controller: Intel Corporation USB UHCI Controller #1 (rev 02)
(prog-if 00 [UHCI])
        Subsystem: Intel Corporation USB UHCI Controller #1
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 23
        Region 4: I/O ports at d400 [size=32]
        Capabilities: [50] Vendor Specific Information
00: 86 80 34 29 05 00 90 02 02 00 03 0c 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 01 d4 00 00 00 00 00 00 00 00 00 00 86 80 34 29
30: 00 00 00 00 50 00 00 00 00 00 00 00 0a 01 00 00

00:1d.1 USB Controller: Intel Corporation USB UHCI Controller #2 (rev 02)
(prog-if 00 [UHCI])
        Subsystem: Intel Corporation USB UHCI Controller #2
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 19
        Region 4: I/O ports at d080 [size=32]
        Capabilities: [50] Vendor Specific Information
00: 86 80 35 29 05 00 90 02 02 00 03 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 81 d0 00 00 00 00 00 00 00 00 00 00 86 80 35 29
30: 00 00 00 00 50 00 00 00 00 00 00 00 03 02 00 00

00:1d.2 USB Controller: Intel Corporation USB UHCI Controller #3 (rev 02)
(prog-if 00 [UHCI])
        Subsystem: Intel Corporation USB UHCI Controller #3
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin D routed to IRQ 16
        Region 4: I/O ports at d000 [size=32]
        Capabilities: [50] Vendor Specific Information
00: 86 80 36 29 05 00 90 02 02 00 03 0c 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 01 d0 00 00 00 00 00 00 00 00 00 00 86 80 36 29
30: 00 00 00 00 50 00 00 00 00 00 00 00 0a 04 00 00

00:1d.7 USB Controller: Intel Corporation USB2 EHCI Controller #1 (rev 02)
(prog-if 20 [EHCI])
        Subsystem: Intel Corporation USB2 EHCI Controller #1
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 23
        Region 0: Memory at ffa7b000 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Debug port
        Capabilities: [98] Vendor Specific Information
00: 86 80 3a 29 06 00 90 02 02 20 03 0c 00 00 00 00
10: 00 b0 a7 ff 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 3a 29
30: 00 00 00 00 50 00 00 00 00 00 00 00 0a 01 00 00

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92) (prog-if 01
[Subtractive decode])
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
        Latency: 0
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
        Memory behind bridge: ff600000-ff6fffff
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [50] Subsystem: Intel Corporation 82801 PCI Bridge
00: 86 80 4e 24 06 01 10 00 92 01 04 06 00 00 01 00
10: 00 00 00 00 00 00 00 00 00 01 01 20 f0 00 80 22
20: 60 ff 60 ff f1 ff 01 00 00 00 00 00 00 00 00 00
30: 00 00 00 00 50 00 00 00 00 00 00 00 ff 00 02 00

00:1f.0 ISA bridge: Intel Corporation LPC Interface Controller (rev 02)
        Subsystem: Intel Corporation LPC Interface Controller
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information
00: 86 80 10 29 07 00 10 02 02 00 01 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 10 29
30: 00 00 00 00 e0 00 00 00 00 00 00 00 00 00 00 00

00:1f.2 SATA controller: Intel Corporation 6 port SATA AHCI Controller (rev 02)
(prog-if 01 [AHCI 1.0])
        Subsystem: Intel Corporation 6 port SATA AHCI Controller
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 319
        Region 0: I/O ports at cc00 [size=8]
        Region 1: I/O ports at c880 [size=4]
        Region 2: I/O ports at c800 [size=8]
        Region 3: I/O ports at c480 [size=4]
        Region 4: I/O ports at c400 [size=32]
        Region 5: Memory at ffa78800 (32-bit, non-prefetchable) [size=2K]
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/4
Enable+
                Address: fee0300c  Data: 4169
        Capabilities: [70] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [a8] #12 [0010]
        Capabilities: [b0] Vendor Specific Information
00: 86 80 22 29 07 04 b0 02 02 01 06 01 00 00 00 00
10: 01 cc 00 00 81 c8 00 00 01 c8 00 00 81 c4 00 00
20: 01 c4 00 00 00 88 a7 ff 00 00 00 00 86 80 22 29
30: 00 00 00 00 80 00 00 00 00 00 00 00 03 02 00 00

00:1f.3 SMBus: Intel Corporation SMBus Controller (rev 02)
        Subsystem: Intel Corporation SMBus Controller
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin C routed to IRQ 18
        Region 0: Memory at ffa7b800 (64-bit, non-prefetchable) [size=256]
        Region 4: I/O ports at 0400 [size=32]
00: 86 80 30 29 03 00 80 02 02 00 05 0c 00 00 00 00
10: 04 b8 a7 ff 00 00 00 00 00 00 00 00 00 00 00 00
20: 01 04 00 00 00 00 00 00 00 00 00 00 86 80 30 29
30: 00 00 00 00 00 00 00 00 00 00 00 00 03 03 00 00

00:1f.5 IDE interface: Intel Corporation 2 port SATA IDE Controller (rev 02)
(prog-if 85 [Master SecO PriO])
        Subsystem: Intel Corporation 2 port SATA IDE Controller
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 19
        Region 0: I/O ports at c000 [size=8]
        Region 1: I/O ports at bc00 [size=4]
        Region 2: I/O ports at b880 [size=8]
        Region 3: I/O ports at b800 [size=4]
        Region 4: I/O ports at b480 [size=16]
        Region 5: I/O ports at b400 [size=16]
        Capabilities: [70] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [b0] Vendor Specific Information
00: 86 80 26 29 07 00 b0 02 02 85 01 01 00 00 00 00
10: 01 c0 00 00 01 bc 00 00 81 b8 00 00 01 b8 00 00
20: 81 b4 00 00 01 b4 00 00 00 00 00 00 86 80 26 29
30: 00 00 00 00 70 00 00 00 00 00 00 00 03 02 00 00

00:1f.6 Signal processing controller: Intel Corporation Thermal Subsystem (rev 02)
        Subsystem: Intel Corporation Thermal Subsystem
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
        Interrupt: pin C routed to IRQ 12
        Region 0: Memory at ffa6f000 (64-bit, non-prefetchable) [size=4K]
        Capabilities: [50] Power Management version 3
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
00: 86 80 32 29 02 00 10 00 02 00 80 11 00 00 00 00
10: 04 f0 a6 ff 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 32 29
30: 00 00 00 00 50 00 00 00 00 00 00 00 0c 03 00 00

01:00.0 Ethernet controller: Atheros Communications, Inc. AR5212 802.11abg NIC
(rev 01)
        Subsystem: Wistron NeWeb Corp. CM9 Wireless a/b/g MiniPCI Adapter
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (2500ns min, 7000ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 14
        Region 0: Memory at ff6f0000 (32-bit, non-prefetchable) [size=64K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=2 PME-
00: 8c 16 13 00 16 00 90 02 01 00 00 02 08 40 00 00
10: 00 00 6f ff 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 01 50 00 00 5f 18 12 10
30: 00 00 00 00 44 00 00 00 00 00 00 00 0e 01 0a 1c


> my 945 works fine with my drm tree on top of Linus with clflush + my
> agp fix I just sent out ..

Should I try?

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
