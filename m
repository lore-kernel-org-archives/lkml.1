Return-Path: <linux-kernel-owner+w=401wt.eu-S1423266AbXBIWCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423266AbXBIWCg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 17:02:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423270AbXBIWCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 17:02:36 -0500
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:52178 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423266AbXBIWCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 17:02:35 -0500
Message-ID: <45CCEF79.1060105@lwfinger.net>
Date: Fri, 09 Feb 2007 16:02:33 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: asil.jinn@gmail.com
Subject: Strange message in log upon resuming a PCIe system
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A bcm43xx user is having problems with suspend/resume with a PCIe system. This may be the first time
we have tried to resume with PCIe. The problem occurs someplace within the initialization of the
bcm43xx chip and we are still tracing it; however, there are some strange messages in the log from
the pnp, namely:

pnp: Device 00:04 does not support activation.
pnp: Device 00:05 does not support activation.

How does one trace back these device numbers? The output of 'lspci -v' shows the following:

00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS/940GML and 945GT Express Memory
Controller Hub (rev 03)
        Subsystem: Dell Unknown device 01c2
        Flags: bus master, fast devsel, latency 0
        Capabilities: <access denied>

00:01.0 PCI bridge: Intel Corporation Mobile 945GM/PM/GMS/940GML and 945GT Express PCI Express Root
Port (rev 03) (prog-if 00 [Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        Memory behind bridge: dd000000-dfefffff
        Prefetchable memory behind bridge: 00000000c0000000-00000000cfffffff
        Capabilities: <access denied>

00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 01)
        Subsystem: Dell Unknown device 01c2
        Flags: bus master, fast devsel, latency 0, IRQ 19
        Memory at dfffc000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: <access denied>

00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 (rev 01) (prog-if 00
[Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=0b, subordinate=0b, sec-latency=0
        Capabilities: <access denied>

00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 2 (rev 01) (prog-if 00
[Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=0c, subordinate=0c, sec-latency=0
        Memory behind bridge: dcf00000-dcffffff
        Capabilities: <access denied>

00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 3 (rev 01) (prog-if 00
[Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=09, subordinate=09, sec-latency=0
        Memory behind bridge: dce00000-dcefffff
        Capabilities: <access denied>

00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #1 (rev 01) (prog-if 00 [UHCI])
        Subsystem: Dell Unknown device 01c2
        Flags: bus master, medium devsel, latency 0, IRQ 20
        I/O ports at bf80 [size=32]

00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #2 (rev 01) (prog-if 00 [UHCI])
        Subsystem: Dell Unknown device 01c2
        Flags: bus master, medium devsel, latency 0, IRQ 19
        I/O ports at bf60 [size=32]

00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #3 (rev 01) (prog-if 00 [UHCI])
        Subsystem: Dell Unknown device 01c2
        Flags: bus master, medium devsel, latency 0, IRQ 21
        I/O ports at bf40 [size=32]

00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #4 (rev 01) (prog-if 00 [UHCI])
        Subsystem: Dell Unknown device 01c2
        Flags: bus master, medium devsel, latency 0, IRQ 22
        I/O ports at bf20 [size=32]

00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 01)
(prog-if 20 [EHCI])
        Subsystem: Dell Unknown device 01c2
        Flags: bus master, medium devsel, latency 0, IRQ 20
        Memory at ffa80000 (32-bit, non-prefetchable) [size=1K]
        Capabilities: <access denied>

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e1) (prog-if 01 [Subtractive decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=03, subordinate=03, sec-latency=32
        Capabilities: <access denied>

00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge (rev 01)
        Subsystem: Dell Unknown device 01c2
        Flags: bus master, medium devsel, latency 0
        Capabilities: <access denied>

00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) Serial ATA Storage Controller
IDE (rev 01) (prog-if 80 [Master])
        Subsystem: Dell Unknown device 01c2
        Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 17
        I/O ports at 01f0 [size=8]
        I/O ports at 03f4 [size=1]
        I/O ports at 0170 [size=8]
        I/O ports at 0374 [size=1]
        I/O ports at bfa0 [size=16]
        Capabilities: <access denied>

00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 01)
        Subsystem: Dell Unknown device 01c2
        Flags: medium devsel, IRQ 17
        I/O ports at 10c0 [size=32]

01:00.0 VGA compatible controller: nVidia Corporation Quadro NVS 110M / GeForce Go 7300 (rev a1)
(prog-if 00 [VGA])
        Subsystem: Dell Unknown device 01c2
        Flags: bus master, fast devsel, latency 0, IRQ 16
        Memory at dd000000 (32-bit, non-prefetchable) [size=16M]
        Memory at c0000000 (64-bit, prefetchable) [size=256M]
        Memory at de000000 (64-bit, non-prefetchable) [size=16M]
        [virtual] Expansion ROM at df000000 [disabled] [size=128K]
        Capabilities: <access denied>

09:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5752 Gigabit Ethernet PCI Express
(rev 02)
        Subsystem: Dell Unknown device 01c2
        Flags: bus master, fast devsel, latency 0, IRQ 18
        Memory at dcef0000 (64-bit, non-prefetchable) [size=64K]
        Capabilities: <access denied>

0c:00.0 Network controller: Broadcom Corporation BCM4310 UART (rev 01)
        Subsystem: Dell Unknown device 0007
        Flags: bus master, fast devsel, latency 0, IRQ 17
        Memory at dcffc000 (32-bit, non-prefetchable) [size=16K]
        Capabilities: <access denied>

Thanks,

Larry


