Return-Path: <linux-kernel-owner+w=401wt.eu-S1761319AbXIZTHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761319AbXIZTHc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 15:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755484AbXIZTHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 15:07:23 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:5855 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769AbXIZTHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 15:07:22 -0400
Message-ID: <c038f5910709261207k740ad130k151a9b0c8d8e48e0@mail.gmail.com>
Date: Wed, 26 Sep 2007 15:07:14 -0400
From: "samson yeung" <fragmede@onepatchdown.net>
To: linux-kernel@vger.kernel.org
Subject: [Re: NMI error and Intel S5000PSL Motherboards]
Cc: rdunlap@xenotime.net, alan@lxorguk.ukuu.org.uk, AndrewL733@aol.com,
       bbermack@alum.mit.edu, "Justin Mazzola Paluska" <jmp@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 6045eec7e240e694
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm working with AndrewL733 on this issue. I'm doing the git bisect right now.

scanpci -f -1 causes the problem, scanpci -f -2 and scanpci -O do not.

The systems have two 1-Gig sticks in the D1 and C1 slots of the
motherboard. I ran memtest86 overnight and got no errors. (Samsung 1GB
PC2-5300F-555-11-B0)

Both pci=nomsi and pci=nommconf don't change the situation on the
ubuntu's custom kernel. I can try them on a stock kernel.org kernel
after I finish doing the git bisect.

The driver does not even need to be loaded to have the problem
(e1000). I have not tried the 2.6.18 driver with 2.6.20, but I have
tried both the in-kernel driver as well as the newer driver from Intel
with the same result.

The drive is a Seagate Barracuda 7200.9 80 Gbytes with fimware 3.AAE
I can include hdparm -i output if it will help.

The problem is only happening on 64-bit. As noted above, I'm running
git-bisect to test a stock kernel.org kernel. 32-bit Ubuntu does not
exhibit the problem, I have not tested a kernel.org 32-bit kernel.

Extended command output follows:

cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Xeon(R) CPU            5160  @ 3.00GHz
stepping        : 6
cpu MHz         : 1998.000
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
mca cmov pat pse36 clflush dts acpi mmx fx   sr sse sse2 ss ht tm
syscall nx lm constant_tsc pni monitor ds_cpl vmx est tm2 ssse3 cx16
xtpr dca lahf_lm
bogomips        : 5990.11
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 15
model name      : Intel(R) Xeon(R) CPU            5160  @ 3.00GHz
stepping        : 6
cpu MHz         : 1998.000
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
mca cmov pat pse36 clflush dts acpi mmx fx   sr sse sse2 ss ht tm
syscall nx lm constant_tsc pni monitor ds_cpl vmx est tm2 ssse3 cx16
xtpr dca lahf_lm
bogomips        : 5984.99
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 48 bits virtual
power management:

----------------------------------------------------------------------
lspci -v:
00:00.0 Host bridge: Intel Corporation Server Memory Controller Hub (rev b1)
        Subsystem: Intel Corporation Unknown device 3476
        Flags: bus master, fast devsel, latency 0
        Capabilities: <access denied>

00:02.0 PCI bridge: Intel Corporation Server PCI Express x8 Port 2-3
(rev b1) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=01, subordinate=05, sec-latency=0
        I/O behind bridge: 00004000-00004fff
        Memory behind bridge: b8000000-b89fffff
        Capabilities: <access denied>

00:03.0 PCI bridge: Intel Corporation Server PCI Express x4 Port 3
(rev b1) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=06, subordinate=06, sec-latency=0
        Capabilities: <access denied>

00:04.0 PCI bridge: Intel Corporation Server PCI Express x8 Port 4-5
(rev b1) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=07, subordinate=07, sec-latency=0
        Capabilities: <access denied>

00:05.0 PCI bridge: Intel Corporation Server PCI Express x4 Port 5
(rev b1) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=08, subordinate=08, sec-latency=0
        Capabilities: <access denied>

00:06.0 PCI bridge: Intel Corporation Server PCI Express x8 Port 6-7
(rev b1) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=09, subordinate=0c, sec-latency=0
        I/O behind bridge: 00002000-00003fff
        Memory behind bridge: b8b00000-b8cfffff
        Prefetchable memory behind bridge: 00000000b8e00000-00000000b8f00000
        Capabilities: <access denied>

00:07.0 PCI bridge: Intel Corporation Server PCI Express x4 Port 7
(rev b1) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=0d, subordinate=0d, sec-latency=0
        Capabilities: <access denied>

00:08.0 System peripheral: Intel Corporation Server DMA Engine (rev b1)
        Subsystem: Intel Corporation Unknown device 3476
        Flags: bus master, fast devsel, latency 0, IRQ 1
        Memory at fe700000 (64-bit, non-prefetchable) [size=1K]
        Capabilities: <access denied>

00:10.0 Host bridge: Intel Corporation Server Error Reporting Registers (rev b1)
        Subsystem: Intel Corporation Unknown device 3476
        Flags: fast devsel

00:10.1 Host bridge: Intel Corporation Server Error Reporting Registers (rev b1)
        Subsystem: Intel Corporation Unknown device 3476
        Flags: fast devsel

00:10.2 Host bridge: Intel Corporation Server Error Reporting Registers (rev b1)
        Subsystem: Intel Corporation Unknown device 3476
        Flags: fast devsel

00:11.0 Host bridge: Intel Corporation Reserved Registers (rev b1)
        Subsystem: Intel Corporation Unknown device 3476
        Flags: fast devsel

00:13.0 Host bridge: Intel Corporation Reserved Registers (rev b1)
        Subsystem: Intel Corporation Unknown device 3476
        Flags: fast devsel

00:15.0 Host bridge: Intel Corporation Server FBD Registers (rev b1)
        Subsystem: Intel Corporation Unknown device 3476
        Flags: fast devsel

00:16.0 Host bridge: Intel Corporation Server FBD Registers (rev b1)
        Subsystem: Intel Corporation Unknown device 3476
        Flags: fast devsel

00:1c.0 PCI bridge: Intel Corporation Enterprise Southbridge PCI
Express Root Port 1 (rev 09) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=0e, subordinate=0e, sec-latency=0
        Capabilities: <access denied>

00:1d.0 USB Controller: Intel Corporation Enterprise Southbridge UHCI
USB #1 (rev 09) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation Unknown device 3476
        Flags: bus master, medium devsel, latency 0, IRQ 98
        I/O ports at 5080 [size=32]

00:1d.1 USB Controller: Intel Corporation Enterprise Southbridge UHCI
USB #2 (rev 09) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation Unknown device 3476
        Flags: bus master, medium devsel, latency 0, IRQ 106
        I/O ports at 5060 [size=32]

00:1d.2 USB Controller: Intel Corporation Enterprise Southbridge UHCI
USB #3 (rev 09) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation Unknown device 3476
        Flags: bus master, medium devsel, latency 0, IRQ 98
        I/O ports at 5040 [size=32]

00:1d.3 USB Controller: Intel Corporation Enterprise Southbridge UHCI
USB #4 (rev 09) (prog-if 00 [UHCI])
        Subsystem: Intel Corporation Unknown device 3476
        Flags: bus master, medium devsel, latency 0, IRQ 106
        I/O ports at 5020 [size=32]

00:1d.7 USB Controller: Intel Corporation Enterprise Southbridge EHCI
USB (rev 09) (prog-if 20 [EHCI])
        Subsystem: Intel Corporation Unknown device 3476
        Flags: bus master, medium devsel, latency 0, IRQ 98
        Memory at b8d00400 (32-bit, non-prefetchable) [size=1K]
        Capabilities: <access denied>

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev d9)
(prog-if 01 [Subtractive decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=0f, subordinate=0f, sec-latency=32
        I/O behind bridge: 00001000-00001fff
        Memory behind bridge: b8a00000-b8afffff
        Prefetchable memory behind bridge: 00000000b0000000-00000000b7f00000
        Capabilities: <access denied>

00:1f.0 ISA bridge: Intel Corporation Enterprise Southbridge LPC (rev 09)
        Subsystem: Intel Corporation Unknown device 3476
        Flags: bus master, medium devsel, latency 0

00:1f.1 IDE interface: Intel Corporation Enterprise Southbridge PATA
(rev 09) (prog-if 8a [Master SecP PriP])
        Subsystem: Intel Corporation Unknown device 3476
        Flags: bus master, medium devsel, latency 0, IRQ 90
        I/O ports at <ignored>
        I/O ports at <ignored>
        I/O ports at <ignored>
        I/O ports at <ignored>
        I/O ports at 50b0 [size=16]

00:1f.2 IDE interface: Intel Corporation Enterprise Southbridge SATA
IDE (rev 09) (prog-if 8f [Master SecP SecO PriP PriO])
        Subsystem: Intel Corporation Unknown device 3476
        Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 90
        I/O ports at 50c8 [size=8]
        I/O ports at 50e4 [size=4]
        I/O ports at 50c0 [size=8]
        I/O ports at 50e0 [size=4]
        I/O ports at 50a0 [size=16]
        Memory at b8d00000 (32-bit, non-prefetchable) [size=1K]
        Capabilities: <access denied>

00:1f.3 SMBus: Intel Corporation Enterprise Southbridge SMBus (rev 09)
        Subsystem: Intel Corporation Unknown device 3476
        Flags: medium devsel, IRQ 10
        I/O ports at 5000 [size=32]

01:00.0 PCI bridge: Intel Corporation Enterprise Southbridge PCI
Express Upstream Port (rev 01) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=01, secondary=02, subordinate=04, sec-latency=0
        I/O behind bridge: 00004000-00004fff
        Memory behind bridge: b8000000-b88fffff
        Capabilities: <access denied>

01:00.3 PCI bridge: Intel Corporation Enterprise Southbridge PCI
Express to PCI-X Bridge (rev 01) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=01, secondary=05, subordinate=05, sec-latency=64
        Capabilities: <access denied>

02:00.0 PCI bridge: Intel Corporation Enterprise Southbridge PCI
Express Downstream Port E1 (rev 01) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=02, secondary=03, subordinate=03, sec-latency=0
        Capabilities: <access denied>

02:02.0 PCI bridge: Intel Corporation Enterprise Southbridge PCI
Express Downstream Port E3 (rev 01) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=02, secondary=04, subordinate=04, sec-latency=0
        I/O behind bridge: 00004000-00004fff
        Memory behind bridge: b8000000-b88fffff
        Capabilities: <access denied>

04:00.0 Ethernet controller: Intel Corporation PRO/1000 EB Network
Connection with I/O Acceleration (rev 01)
        Subsystem: Intel Corporation Unknown device 3476
        Flags: bus master, fast devsel, latency 0, IRQ 122
        Memory at b8820000 (32-bit, non-prefetchable) [size=128K]
        Memory at b8400000 (32-bit, non-prefetchable) [size=4M]
        I/O ports at 4020 [size=32]
        Capabilities: <access denied>

04:00.1 Ethernet controller: Intel Corporation PRO/1000 EB Network
Connection with I/O Acceleration (rev 01)
        Subsystem: Intel Corporation Unknown device 3476
        Flags: bus master, fast devsel, latency 0, IRQ 130
        Memory at b8800000 (32-bit, non-prefetchable) [size=128K]
        Memory at b8000000 (32-bit, non-prefetchable) [size=4M]
        I/O ports at 4000 [size=32]
        Capabilities: <access denied>

09:00.0 PCI bridge: Integrated Device Technology, Inc. Unknown device
8018 (rev 04) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=09, secondary=0a, subordinate=0c, sec-latency=0
        I/O behind bridge: 00002000-00003fff
        Memory behind bridge: b8b00000-b8cfffff
        Prefetchable memory behind bridge: 00000000b8e00000-00000000b8f00000
        Capabilities: <access denied>

0a:00.0 PCI bridge: Integrated Device Technology, Inc. Unknown device
8018 (rev 04) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=0a, secondary=0b, subordinate=0b, sec-latency=0
        I/O behind bridge: 00003000-00003fff
        Memory behind bridge: b8c00000-b8cfffff
        Prefetchable memory behind bridge: 00000000b8e00000-00000000b8e00000
        Capabilities: <access denied>

0a:01.0 PCI bridge: Integrated Device Technology, Inc. Unknown device
8018 (rev 04) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=0a, secondary=0c, subordinate=0c, sec-latency=0
        I/O behind bridge: 00002000-00002fff
        Memory behind bridge: b8b00000-b8bfffff
        Prefetchable memory behind bridge: 00000000b8f00000-00000000b8f00000
        Capabilities: <access denied>

0b:00.0 Ethernet controller: Intel Corporation Unknown device 10a4 (rev 06)
        Subsystem: Intel Corporation Unknown device 10a4
        Flags: bus master, fast devsel, latency 0, IRQ 138
        Memory at b8c60000 (32-bit, non-prefetchable) [size=128K]
        Memory at b8c40000 (32-bit, non-prefetchable) [size=128K]
        I/O ports at 3020 [size=32]
        Expansion ROM at b8e00000 [disabled] [size=128K]
        Capabilities: <access denied>

0b:00.1 Ethernet controller: Intel Corporation Unknown device 10a4 (rev 06)
        Subsystem: Intel Corporation Unknown device 10a4
        Flags: bus master, fast devsel, latency 0, IRQ 146
        Memory at b8c20000 (32-bit, non-prefetchable) [size=128K]
        Memory at b8c00000 (32-bit, non-prefetchable) [size=128K]
        I/O ports at 3000 [size=32]
        Expansion ROM at b8e20000 [disabled] [size=128K]
        Capabilities: <access denied>

0c:00.0 Ethernet controller: Intel Corporation Unknown device 10a4 (rev 06)
        Subsystem: Intel Corporation Unknown device 10a4
        Flags: bus master, fast devsel, latency 0, IRQ 154
        Memory at b8b60000 (32-bit, non-prefetchable) [size=128K]
        Memory at b8b40000 (32-bit, non-prefetchable) [size=128K]
        I/O ports at 2020 [size=32]
        Expansion ROM at b8f00000 [disabled] [size=128K]
        Capabilities: <access denied>

0c:00.1 Ethernet controller: Intel Corporation Unknown device 10a4 (rev 06)
        Subsystem: Intel Corporation Unknown device 10a4
        Flags: bus master, fast devsel, latency 0, IRQ 162
        Memory at b8b20000 (32-bit, non-prefetchable) [size=128K]
        Memory at b8b00000 (32-bit, non-prefetchable) [size=128K]
        I/O ports at 2000 [size=32]
        Expansion ROM at b8f20000 [disabled] [size=128K]
        Capabilities: <access denied>

0f:0c.0 VGA compatible controller: ATI Technologies Inc ES1000 (rev
02) (prog-if 00 [VGA])
        Subsystem: Intel Corporation Unknown device 3476
        Flags: bus master, stepping, fast Back2Back, medium devsel,
latency 32, IRQ 11
        Memory at b0000000 (32-bit, prefetchable) [size=128M]
        I/O ports at 1000 [size=256]
        Memory at b8a00000 (32-bit, non-prefetchable) [size=64K]
        Expansion ROM at fffe0000 [disabled] [size=128K]
        Capabilities: <access denied>

-----------------------------------------------------------------------------------------
strace: I don't know what syscall_273 does. I trimmed the output to
include syscall 273 and the lines surrounding it. I can include the
entirety of the strace if it will help.

arch_prctl(ARCH_SET_FS, 0x2aca24060f50) = 0
mprotect(0x2aca23e3b000, 12288, PROT_READ) = 0
munmap(0x2aca238e2000, 36649)           = 0
set_tid_address(0x2aca24060fe0)         = 10319
syscall_273(0x2aca24060ff0, 0x18, 0x7fff87790188, 0x2aca233193c0,
0x2aca24060f50, 0x2aca233352b8, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1,
0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1, 0x1,
0x1, 0x1, 0x1, 0x1, 0x1) = 0
rt_sigaction(SIGRTMIN, {0x2aca23e4a3a0, [], SA_RESTORER|SA_SIGINFO,
0x2aca23e53200}, NULL, 8) = 0
rt_sigaction(SIGRT_1, {0x2aca23e4a2f0, [],
SA_RESTORER|SA_RESTART|SA_SIGINFO, 0x2aca23e53200}, NULL, 8) = 0
rt_sigprocmask(SIG_UNBLOCK, [RTMIN RT_1], NULL, 8) = 0
ioperm(0, 0x400, 0x1)                   = 0

Samson
