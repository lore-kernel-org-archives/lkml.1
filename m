Return-Path: <linux-kernel-owner+w=401wt.eu-S933913AbXEVQfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933913AbXEVQfa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 12:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757884AbXEVQfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 12:35:21 -0400
Received: from vsmtp21.tin.it ([212.216.176.109]:61658 "EHLO vsmtp21.tin.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755769AbXEVQfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 12:35:19 -0400
From: Luigi Genoni <l.genoni@oltrelinux.com>
To: linux-kernel@vger.kernel.org
Subject: BUG: at mm/slab.c:777 __find_general_cachep()
Date: Tue, 22 May 2007 18:35:11 +0200
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_/uxUG8iOf6XQo+a"
Message-Id: <200705221835.11559.l.genoni@oltrelinux.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_/uxUG8iOf6XQo+a
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

While doing eavy I/O on a RAID1 logical volume with reiserfs with kernel 
2.6.22-rc2 on Athlon64 3800+ X2, i got:

BUG: at mm/slab.c:777 __find_general_cachep()

Call Trace:
 [<ffffffff8027eeba>] __kmalloc+0xfa/0x110
 [<ffffffff802b60f1>] compat_core_sys_select+0xd1/0x250
 [<ffffffff802b7bf5>] compat_sys_select+0xe5/0x190
 [<ffffffff80285a83>] sys_read+0x53/0x90
 [<ffffffff8021f542>] ia32_sysret+0x0/0xa

linux 2.6.22-rc2 is copiled with gcc 4.2.0 (glibc 2.5).

system is:

DarkStar:{venom}:~>cat /proc/cpuinfo
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 43
model name      : AMD Athlon(tm) 64 X2 Dual Core Processor 3800+
stepping        : 1
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
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt lm 
3dnowext 3dnow pni lahf_lm cmp_legacy
bogomips        : 2000.93
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp

processor       : 1
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 43
model name      : AMD Athlon(tm) 64 X2 Dual Core Processor 3800+
stepping        : 1
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
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt lm 
3dnowext 3dnow pni lahf_lm cmp_legacy
bogomips        : 2000.93
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp


has 2 GB RAM DR400

here is lspci:

arkStar:{root}:/home/venom>lspci -v
00:00.0 Memory controller: nVidia Corporation CK804 Memory Controller (rev a3)
        Subsystem: ASUSTeK Computer Inc. A8N-E Mainboard
        Flags: bus master, 66MHz, fast devsel, latency 0
        Capabilities: [44] HyperTransport: Slave or Primary Interface
        Capabilities: [e0] HyperTransport: MSI Mapping

00:01.0 ISA bridge: nVidia Corporation CK804 ISA Bridge (rev a3)
        Subsystem: ASUSTeK Computer Inc. K8N4-E or A8N-E Mainboard
        Flags: bus master, 66MHz, fast devsel, latency 0

00:01.1 SMBus: nVidia Corporation CK804 SMBus (rev a2)
        Subsystem: ASUSTeK Computer Inc. K8N4-E or A8N-E Mainboard
        Flags: 66MHz, fast devsel, IRQ 10
        I/O ports at e400 [size=32]
        I/O ports at 4c00 [size=64]
        I/O ports at 4c40 [size=64]
        Capabilities: [44] Power Management version 2

00:02.0 USB Controller: nVidia Corporation CK804 USB Controller (rev a2) 
(prog-if 10 [OHCI])
        Subsystem: ASUSTeK Computer Inc. K8N4-E or A8N-E Mainboard
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 21
        Memory at d5004000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [44] Power Management version 2

00:02.1 USB Controller: nVidia Corporation CK804 USB Controller (rev a3) 
(prog-if 20 [EHCI])
        Subsystem: ASUSTeK Computer Inc. K8N4-E or A8N-E Mainboard
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 20
        Memory at d5005000 (32-bit, non-prefetchable) [size=256]
        Capabilities: [44] Debug port
        Capabilities: [80] Power Management version 2

00:04.0 Multimedia audio controller: nVidia Corporation CK804 AC'97 Audio 
Controller (rev a2)
        Subsystem: ASUSTeK Computer Inc. Unknown device 8166
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 22
        I/O ports at dc00 [size=256]
        I/O ports at e000 [size=256]
        Memory at d5003000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [44] Power Management version 2

00:06.0 IDE interface: nVidia Corporation CK804 IDE (rev f2) (prog-if 8a 
[Master SecP PriP])
        Subsystem: Unknown device f043:815a
        Flags: bus master, 66MHz, fast devsel, latency 0
        [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] 
[size=8]
        [virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] 
[size=1]
        [virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] 
[size=8]
        [virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] 
[size=1]
        I/O ports at f000 [size=16]
        Capabilities: [44] Power Management version 2

00:07.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev f3) 
(prog-if 85 [Master SecO PriO])
        Subsystem: ASUSTeK Computer Inc. A8N-E Mainboard
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 23
        I/O ports at 09f0 [size=8]
        I/O ports at 0bf0 [size=4]
        I/O ports at 0970 [size=8]
        I/O ports at 0b70 [size=4]
        I/O ports at d800 [size=16]
        Memory at d5002000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [44] Power Management version 2

00:08.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev f3) 
(prog-if 85 [Master SecO PriO])
        Subsystem: ASUSTeK Computer Inc. K8N4-E or A8N-E Mainboard
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 22
        I/O ports at 09e0 [size=8]
        I/O ports at 0be0 [size=4]
        I/O ports at 0960 [size=8]
        I/O ports at 0b60 [size=4]
        I/O ports at c400 [size=16]
        Memory at d5001000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [44] Power Management version 2

00:09.0 PCI bridge: nVidia Corporation CK804 PCI Bridge (rev a2) (prog-if 01 
[Subtractive decode])
        Flags: bus master, 66MHz, fast devsel, latency 0
        Bus: primary=00, secondary=05, subordinate=05, sec-latency=128
        I/O behind bridge: 0000a000-0000afff
        Memory behind bridge: d3000000-d4ffffff
        Prefetchable memory behind bridge: 88000000-880fffff

00:0a.0 Bridge: nVidia Corporation CK804 Ethernet Controller (rev a3)
        Subsystem: ASUSTeK Computer Inc. Unknown device 816a
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 23
        Memory at d5000000 (32-bit, non-prefetchable) [size=4K]
        I/O ports at b000 [size=8]
        Capabilities: [44] Power Management version 2

00:0b.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3) (prog-if 00 
[Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
        Capabilities: [40] Power Management version 2
        Capabilities: [48] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/1 Enable+
        Capabilities: [58] HyperTransport: MSI Mapping
        Capabilities: [80] Express Root Port (Slot+) IRQ 0
        Capabilities: [100] Virtual Channel

00:0c.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3) (prog-if 00 
[Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
        Capabilities: [40] Power Management version 2
        Capabilities: [48] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/1 Enable+
        Capabilities: [58] HyperTransport: MSI Mapping
        Capabilities: [80] Express Root Port (Slot+) IRQ 0
        Capabilities: [100] Virtual Channel

00:0d.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3) (prog-if 00 
[Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
        Capabilities: [40] Power Management version 2
        Capabilities: [48] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/1 Enable+
        Capabilities: [58] HyperTransport: MSI Mapping
        Capabilities: [80] Express Root Port (Slot+) IRQ 0
        Capabilities: [100] Virtual Channel

00:0e.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3) (prog-if 00 
[Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        I/O behind bridge: 00009000-00009fff
        Memory behind bridge: d0000000-d2ffffff
        Prefetchable memory behind bridge: 00000000c0000000-00000000cfffffff
        Capabilities: [40] Power Management version 2
        Capabilities: [48] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/1 Enable+
        Capabilities: [58] HyperTransport: MSI Mapping
        Capabilities: [80] Express Root Port (Slot+) IRQ 0
        Capabilities: [100] Virtual Channel

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
HyperTransport Technology Configuration
        Flags: fast devsel
        Capabilities: [80] HyperTransport: Host or Secondary Interface

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Address Map
        Flags: fast devsel

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM 
Controller
        Flags: fast devsel

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Miscellaneous Control
        Flags: fast devsel

01:00.0 VGA compatible controller: nVidia Corporation G70 [GeForce 7600 GS] 
(rev a1) (prog-if 00 [VGA])
        Flags: bus master, fast devsel, latency 0, IRQ 18
        Memory at d0000000 (32-bit, non-prefetchable) [size=16M]
        Memory at c0000000 (64-bit, prefetchable) [size=256M]
        Memory at d1000000 (64-bit, non-prefetchable) [size=16M]
        I/O ports at 9000 [size=128]
        [virtual] Expansion ROM at d2000000 [disabled] [size=128K]
        Capabilities: [60] Power Management version 2
        Capabilities: [68] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/0 Enable-
        Capabilities: [78] Express Endpoint IRQ 0
        Capabilities: [100] Virtual Channel
        Capabilities: [128] Power Budgeting

05:02.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394 Host Controller 
(rev 80) (prog-if 10 [OHCI])
        Subsystem: ASUSTeK Computer Inc. A8V Deluxe or A8N-VM CSM Mainboard
        Flags: bus master, stepping, medium devsel, latency 32, IRQ 19
        Memory at d4001000 (32-bit, non-prefetchable) [size=2K]
        I/O ports at a000 [size=128]
        Capabilities: [50] Power Management version 2

05:04.0 Ethernet controller: 3Com Corporation 3c905C-TX/TX-M [Tornado] (rev 
78)
        Subsystem: 3Com Corporation 3C905CX-TX/TX-M Fast Etherlink for PC 
Management NIC
        Flags: bus master, medium devsel, latency 32, IRQ 17
        I/O ports at a400 [size=128]
        Memory at d4000000 (32-bit, non-prefetchable) [size=128]
        [virtual] Expansion ROM at 88000000 [disabled] [size=128K]
        Capabilities: [dc] Power Management version 2


--Boundary-00=_/uxUG8iOf6XQo+a
Content-Type: application/x-gzip;
  name="config.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="config.gz"

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
2ZsAAA==

--Boundary-00=_/uxUG8iOf6XQo+a--
