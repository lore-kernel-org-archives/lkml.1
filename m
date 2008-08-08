Return-Path: <linux-kernel-owner+w=401wt.eu-S1756446AbYHHKt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446AbYHHKt4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 06:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbYHHKtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 06:49:47 -0400
Received: from cluster-d.mailcontrol.com ([217.69.20.190]:58262 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951AbYHHKtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 06:49:46 -0400
Message-ID: <489C2457.5030104@csr.com>
Date: Fri, 08 Aug 2008 11:47:51 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Kernel development list <linux-kernel@vger.kernel.org>
CC: e1000-devel@lists.sourceforge.net, jeffrey.t.kirsher@intel.com
Subject: e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Aug 2008 10:47:51.0603 (UTC) FILETIME=[349FA830:01C8F944]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2.6.27-rc1 kernels appear to corrupt the EEPROM/NVM of the 8086:294c
ethernet device (ICH9 I think).  After hacking the driver to ignore the
bad CRC and MAC address I could view the EEPROM with ethtool and it was
all 0xff.

Testing EEPROM reads and writes with ethtool appeared to work but after
a reboot of the system the ethernet device (see lspci -v output) was no
longer present.  Could invalid EEPROM contents with a valid CRC (as
would be the case after my read/write tests) result in the device
failing to enumerate on the PCIe bus?

David

00:00.0 Host bridge: Intel Corporation 82Q35 Express DRAM Controller
(rev 02)
	Subsystem: Hewlett-Packard Company Unknown device 2819
	Flags: bus master, fast devsel, latency 0
	Capabilities: [e0] Vendor Specific Information

00:02.0 VGA compatible controller: Intel Corporation 82Q35 Express
Integrated Graphics Controller (rev 02) (prog-if 00 [VGA controller])
	Subsystem: Hewlett-Packard Company Unknown device 2819
	Flags: bus master, fast devsel, latency 0, IRQ 16
	Memory at f0100000 (32-bit, non-prefetchable) [size=512K]
	I/O ports at 2210 [size=8]
	Memory at e0000000 (32-bit, prefetchable) [size=256M]
	Memory at f0000000 (32-bit, non-prefetchable) [size=1M]
	Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- Queue=0/0
Enable-
	Capabilities: [d0] Power Management version 2

00:03.0 Communication controller: Intel Corporation 82Q35 Express MEI
Controller (rev 02)
	Subsystem: Hewlett-Packard Company Unknown device 2819
	Flags: bus master, fast devsel, latency 0, IRQ 5
	Memory at f0185900 (64-bit, non-prefetchable) [size=16]
	Capabilities: [50] Power Management version 3
	Capabilities: [8c] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0
Enable-

00:03.2 IDE interface: Intel Corporation 82Q35 Express PT IDER
Controller (rev 02) (prog-if 85 [Master SecO PriO])
	Subsystem: Hewlett-Packard Company Unknown device 2819
	Flags: 66MHz, fast devsel, IRQ 18
	I/O ports at 2218 [size=8]
	I/O ports at 2250 [size=4]
	I/O ports at 2220 [size=8]
	I/O ports at 2254 [size=4]
	I/O ports at 21c0 [size=16]
	Capabilities: [c8] Power Management version 3
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0
Enable-

00:03.3 Serial controller: Intel Corporation 82Q35 Express Serial KT
Controller (rev 02) (prog-if 02 [16550])
	Subsystem: Hewlett-Packard Company Unknown device 2819
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 17
	I/O ports at 2228 [size=8]
	Memory at f0184000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [c8] Power Management version 3
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0
Enable-

00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #4 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Unknown device 2819
	Flags: bus master, medium devsel, latency 0, IRQ 20
	I/O ports at 2100 [size=32]
	Capabilities: [50] #13 [0306]

00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #5 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Unknown device 2819
	Flags: bus master, medium devsel, latency 0, IRQ 21
	I/O ports at 2120 [size=32]
	Capabilities: [50] #13 [0306]

00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI
Controller #2 (rev 02) (prog-if 20 [EHCI])
	Subsystem: Hewlett-Packard Company Unknown device 2819
	Flags: bus master, medium devsel, latency 0, IRQ 22
	Memory at f0185000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Debug port
	Capabilities: [98] #13 [0306]

00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio
Controller (rev 02)
	Subsystem: Hewlett-Packard Company Unknown device 2819
	Flags: bus master, fast devsel, latency 0, IRQ 21
	Memory at f0180000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
	Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0
Enable-
	Capabilities: [70] Express Unknown type IRQ 0

00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express
Port 1 (rev 02) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=20, subordinate=20, sec-latency=0
	Capabilities: [40] Express Root Port (Slot+) IRQ 0
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0
Enable+
	Capabilities: [90] Subsystem: Hewlett-Packard Company Unknown device 2819
	Capabilities: [a0] Power Management version 2

00:1c.1 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express
Port 2 (rev 02) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=30, subordinate=30, sec-latency=0
	Capabilities: [40] Express Root Port (Slot+) IRQ 0
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=0/0
Enable+
	Capabilities: [90] Subsystem: Hewlett-Packard Company Unknown device 2819
	Capabilities: [a0] Power Management version 2

00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #1 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Unknown device 2819
	Flags: bus master, medium devsel, latency 0, IRQ 20
	I/O ports at 2140 [size=32]
	Capabilities: [50] #13 [0306]

00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #2 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Unknown device 2819
	Flags: bus master, medium devsel, latency 0, IRQ 21
	I/O ports at 2160 [size=32]
	Capabilities: [50] #13 [0306]

00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
Controller #3 (rev 02) (prog-if 00 [UHCI])
	Subsystem: Hewlett-Packard Company Unknown device 2819
	Flags: bus master, medium devsel, latency 0, IRQ 22
	I/O ports at 2180 [size=32]
	Capabilities: [50] #13 [0306]

00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI
Controller #1 (rev 02) (prog-if 20 [EHCI])
	Subsystem: Hewlett-Packard Company Unknown device 2819
	Flags: bus master, medium devsel, latency 0, IRQ 20
	Memory at f0185400 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Debug port
	Capabilities: [98] #13 [0306]

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92) (prog-if
01 [Subtractive decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=07, subordinate=07, sec-latency=32
	I/O behind bridge: 00001000-00001fff
	Memory behind bridge: f0200000-f02fffff
	Capabilities: [50] Subsystem: Hewlett-Packard Company Unknown device 2819

00:1f.0 ISA bridge: Intel Corporation 82801IO (ICH9DO) LPC Interface
Controller (rev 02)
	Subsystem: Hewlett-Packard Company Unknown device 2819
	Flags: bus master, medium devsel, latency 0
	Capabilities: [e0] Vendor Specific Information

00:1f.2 IDE interface: Intel Corporation 82801IR/IO/IH (ICH9R/DO/DH) 4
port SATA IDE Controller (rev 02) (prog-if 8a [Master SecP PriP])
	Subsystem: Hewlett-Packard Company Unknown device 2819
	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 18
	I/O ports at 01f0 [size=8]
	I/O ports at 03f4 [size=1]
	I/O ports at 0170 [size=8]
	I/O ports at 0374 [size=1]
	I/O ports at 21d0 [size=16]
	I/O ports at 21e0 [size=16]
	Capabilities: [70] Power Management version 3
	Capabilities: [b0] #13 [0306]

00:1f.5 IDE interface: Intel Corporation 82801I (ICH9 Family) 2 port
SATA IDE Controller (rev 02) (prog-if 85 [Master SecO PriO])
	Subsystem: Hewlett-Packard Company Unknown device 2819
	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 18
	I/O ports at 2240 [size=8]
	I/O ports at 2260 [size=4]
	I/O ports at 2248 [size=8]
	I/O ports at 2264 [size=4]
	I/O ports at 21f0 [size=16]
	I/O ports at 2200 [size=16]
	Capabilities: [70] Power Management version 3
	Capabilities: [b0] #13 [0306]

07:04.0 Ethernet controller: Accton Technology Corporation SMC2-1211TX
(rev 10)
	Subsystem: Accton Technology Corporation EN-1207D Fast Ethernet Adapter
	Flags: bus master, medium devsel, latency 32, IRQ 20
	I/O ports at 1100 [size=256]
	Memory at f0200000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [50] Power Management version 2

07:0b.0 RF controller: NEC Corporation Unknown device 015e (rev 02)
(prog-if 10)
	Subsystem: NEC Corporation Unknown device 015e
	Flags: bus master, medium devsel, latency 64, IRQ 22
	Memory at f0200100 (32-bit, non-prefetchable) [size=256]
	Capabilities: [40] Power Management version 2

-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/
