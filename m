Return-Path: <linux-kernel-owner+w=401wt.eu-S1751885AbZHGWfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbZHGWfe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 18:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751005AbZHGWfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 18:35:33 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:53418 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbZHGWf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 18:35:27 -0400
From: Ricardo Jorge da Fonseca Marques Ferreira <storm@sys49152.net>
To: linux-kernel@vger.kernel.org
Subject: Regression in ACPI in 2.6.31-rc5
Date: Fri, 7 Aug 2009 23:33:24 +0100
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-git3-13-desktop; KDE/4.3.0; x86_64; ; )
Cc: linux-acpi@vger.kernel.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_0uKfKtLmspeTEsj"
Message-Id: <200908072333.24631.storm@sys49152.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_0uKfKtLmspeTEsj
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Please CC: me as i'm not subscribed to the list.

Hi.
I had two drivers stop working in 2.6.31 that were working fine in 2.6.30. 
They are iwlagn and sky2. If i pass acpi=off to the kernel, they work as 
expected.

This is what is output from the drivers when they don't work:

[    7.878413] sky2 driver version 1.23
[    7.884402] sky2 0000:07:00.0: enabling device (0000 -> 0003)
[    7.889483] sky2 0000:07:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    7.894502] sky2 0000:07:00.0: setting latency timer to 64
[    7.894555] sky2 0000:07:00.0: unsupported chip type 0xff
[    7.899554] sky2 0000:07:00.0: PCI INT A disabled
[    7.904379] sky2: probe of 0000:07:00.0 failed with error -95

[    8.857709] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 
1.3.27kds
[    8.863357] iwlagn: Copyright(c) 2003-2009 Intel Corporation
[    8.875763] iwlagn 0000:08:00.0: enabling device (0000 -> 0002)
[    8.881477] iwlagn 0000:08:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    8.887083] iwlagn 0000:08:00.0: setting latency timer to 64
[    8.887128] iwlagn 0000:08:00.0: Detected Intel Wireless WiFi Link 5100AGN 
REV=0xFDFFFFFF
[    9.073995] iwlagn 0000:08:00.0: Failed, HW not ready
[    9.080292] iwlagn 0000:08:00.0: PCI INT A disabled

Attached are the complete dmesg and lspci -v output.
This is using the SuSE repos version of 2.6.31-rc5 but i tried the vanilla 
kernel packages and the same happens.

Anything i can help with to resolve this, let me know. This bug took out all 
my onboard networking so i'm now using a USB wifi stick.

Thanks

--Boundary-00=_0uKfKtLmspeTEsj
Content-Type: text/x-log;
  charset="UTF-8";
  name="lspci.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="lspci.log"

00:00.0 Host bridge: Intel Corporation Mobile 4 Series Chipset Memory Controller Hub (rev 07)
	Subsystem: Toshiba America Info Systems Device ff50
	Flags: bus master, fast devsel, latency 0
	Capabilities: [e0] Vendor Specific Information <?>
	Kernel driver in use: agpgart-intel
	Kernel modules: intel-agp

00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07) (prog-if 00 [VGA controller])
	Subsystem: Toshiba America Info Systems Device ff50
	Flags: bus master, fast devsel, latency 0, IRQ 28
	Memory at f4000000 (64-bit, non-prefetchable) [size=4M]
	Memory at d0000000 (64-bit, prefetchable) [size=256M]
	I/O ports at 1800 [size=8]
	Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- Count=1/1 Enable+
	Capabilities: [d0] Power Management version 3

00:02.1 Display controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)
	Subsystem: Toshiba America Info Systems Device ff50
	Flags: bus master, fast devsel, latency 0
	Memory at f4400000 (64-bit, non-prefetchable) [size=1M]
	Capabilities: [d0] Power Management version 3

00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Toshiba America Info Systems Device ff50
	Flags: bus master, medium devsel, latency 0, IRQ 16
	I/O ports at 1820 [size=32]
	Capabilities: [50] PCIe advanced features <?>
	Kernel driver in use: uhci_hcd

00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #5 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Toshiba America Info Systems Device ff50
	Flags: bus master, medium devsel, latency 0, IRQ 21
	I/O ports at 1840 [size=32]
	Capabilities: [50] PCIe advanced features <?>
	Kernel driver in use: uhci_hcd

00:1a.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #6 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Toshiba America Info Systems Device ff50
	Flags: bus master, medium devsel, latency 0, IRQ 19
	I/O ports at 1860 [size=32]
	Capabilities: [50] PCIe advanced features <?>
	Kernel driver in use: uhci_hcd

00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 (rev 03) (prog-if 20 [EHCI])
	Subsystem: Toshiba America Info Systems Device ff50
	Flags: bus master, medium devsel, latency 0, IRQ 19
	Memory at f4a04800 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCIe advanced features <?>
	Kernel driver in use: ehci_hcd

00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio Controller (rev 03)
	Subsystem: Toshiba America Info Systems Device ff50
	Flags: bus master, fast devsel, latency 0, IRQ 22
	Memory at f4800000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
	Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Count=1/1 Enable-
	Capabilities: [70] Express Root Complex Integrated Endpoint, MSI 00
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [130] Root Complex Link <?>
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 (rev 03) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=02, subordinate=03, sec-latency=0
	Capabilities: [40] Express Root Port (Slot+), MSI 00
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Count=1/1 Enable+
	Capabilities: [90] Subsystem: Toshiba America Info Systems Device ff50
	Capabilities: [a0] Power Management version 2
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [180] Root Complex Link <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

00:1c.4 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 5 (rev 03) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=07, subordinate=07, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: b6000000-b60fffff
	Capabilities: [40] Express Root Port (Slot+), MSI 00
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Count=1/1 Enable+
	Capabilities: [90] Subsystem: Toshiba America Info Systems Device ff50
	Capabilities: [a0] Power Management version 2
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [180] Root Complex Link <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

00:1c.5 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 6 (rev 03) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=08, subordinate=08, sec-latency=0
	Memory behind bridge: b6100000-b61fffff
	Capabilities: [40] Express Root Port (Slot+), MSI 00
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Count=1/1 Enable+
	Capabilities: [90] Subsystem: Toshiba America Info Systems Device ff50
	Capabilities: [a0] Power Management version 2
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [180] Root Complex Link <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Toshiba America Info Systems Device ff50
	Flags: bus master, medium devsel, latency 0, IRQ 23
	I/O ports at 1880 [size=32]
	Capabilities: [50] PCIe advanced features <?>
	Kernel driver in use: uhci_hcd

00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Toshiba America Info Systems Device ff50
	Flags: bus master, medium devsel, latency 0, IRQ 19
	I/O ports at 18a0 [size=32]
	Capabilities: [50] PCIe advanced features <?>
	Kernel driver in use: uhci_hcd

00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #3 (rev 03) (prog-if 00 [UHCI])
	Subsystem: Toshiba America Info Systems Device ff50
	Flags: bus master, medium devsel, latency 0, IRQ 18
	I/O ports at 18c0 [size=32]
	Capabilities: [50] PCIe advanced features <?>
	Kernel driver in use: uhci_hcd

00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 (rev 03) (prog-if 20 [EHCI])
	Subsystem: Toshiba America Info Systems Device ff50
	Flags: bus master, medium devsel, latency 0, IRQ 23
	Memory at f4a04c00 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCIe advanced features <?>
	Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 93) (prog-if 01 [Subtractive decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=0a, subordinate=0a, sec-latency=32
	Memory behind bridge: f4700000-f47fffff
	Capabilities: [50] Subsystem: Toshiba America Info Systems Device ff50

00:1f.0 ISA bridge: Intel Corporation ICH9M LPC Interface Controller (rev 03)
	Subsystem: Toshiba America Info Systems Device ff50
	Flags: bus master, medium devsel, latency 0
	Capabilities: [e0] Vendor Specific Information <?>
	Kernel modules: iTCO_wdt

00:1f.2 SATA controller: Intel Corporation ICH9M/M-E SATA AHCI Controller (rev 03) (prog-if 01 [AHCI 1.0])
	Subsystem: Toshiba America Info Systems Device ff50
	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 27
	I/O ports at 1818 [size=8]
	I/O ports at 180c [size=4]
	I/O ports at 1810 [size=8]
	I/O ports at 1808 [size=4]
	I/O ports at 18e0 [size=32]
	Memory at f4a04000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Count=1/16 Enable+
	Capabilities: [70] Power Management version 3
	Capabilities: [a8] SATA HBA <?>
	Capabilities: [b0] PCIe advanced features <?>
	Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 03)
	Subsystem: Toshiba America Info Systems Device ff50
	Flags: medium devsel, IRQ 19
	Memory at b6200000 (64-bit, non-prefetchable) [size=256]
	I/O ports at 1c00 [size=32]
	Kernel modules: i2c-i801

07:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8040 PCI-E Fast Ethernet Controller (rev 12)
	Subsystem: Toshiba America Info Systems Device ff50
	Flags: fast devsel, IRQ 16
	Memory at b6000000 (64-bit, non-prefetchable) [size=16K]
	I/O ports at 2000 [size=256]
	Capabilities: [48] Power Management version 3
	Capabilities: [5c] Message Signalled Interrupts: Mask- 64bit+ Count=1/1 Enable-
	Capabilities: [c0] Express Legacy Endpoint, MSI 00
	Capabilities: [100] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSVoil-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSVoil-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSVoil-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 1f, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [130] Device Serial Number 00-23-8b-ff-ff-67-11-3b
	Kernel modules: sky2

08:00.0 Network controller: Intel Corporation Wireless WiFi Link 5100
	Subsystem: Intel Corporation Device 1201
	Flags: fast devsel, IRQ 17
	Memory at b6100000 (64-bit, non-prefetchable) [size=8K]
	Capabilities: [c8] Power Management version 3
	Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Count=1/1 Enable-
	Capabilities: [e0] Express Endpoint, MSI 00
	Capabilities: [100] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSVoil-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSVoil-
		UESvrt:	DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSVoil-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [140] Device Serial Number 46-e1-18-ff-ff-fa-22-00
	Kernel driver in use: iwlagn
	Kernel modules: iwlagn

0a:01.0 FireWire (IEEE 1394): O2 Micro, Inc. Firewire (IEEE 1394) (rev 02) (prog-if 10 [OHCI])
	Subsystem: Toshiba America Info Systems Device ff50
	Flags: bus master, stepping, medium devsel, latency 32, IRQ 16
	Memory at ff501000 (32-bit, non-prefetchable) [size=4K]
	Memory at f4700000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [60] Power Management version 2
	Kernel driver in use: ohci1394
	Kernel modules: ohci1394

0a:01.2 SD Host controller: O2 Micro, Inc. Integrated MMC/SD Controller (rev 02) (prog-if 01)
	Subsystem: Toshiba America Info Systems Device ff50
	Flags: bus master, slow devsel, latency 32, IRQ 16
	Memory at f4700800 (32-bit, non-prefetchable) [size=256]
	Capabilities: [a0] Power Management version 2
	Kernel driver in use: sdhci-pci
	Kernel modules: sdhci-pci

0a:01.3 Mass storage controller: O2 Micro, Inc. Integrated MS/xD Controller (rev 01)
	Subsystem: Toshiba America Info Systems Device ff50
	Flags: slow devsel, IRQ 255
	Memory at f4702000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [a0] Power Management version 2


--Boundary-00=_0uKfKtLmspeTEsj
Content-Type: text/x-log;
  charset="UTF-8";
  name="dmesg.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="dmesg.log"

[    0.000000] Linux version 2.6.31-rc5-git3-13-desktop (geeko@buildhost) (=
gcc version 4.3.2 [gcc-4_3-branch revision 141291] (SUSE Linux) ) #1 SMP PR=
EEMPT 2009-08-06 23:25:57 +0200
[    0.000000] Command line: root=3D/dev/disk/by-id/ata-TOSHIBA_MK3252GSX_Z=
86CSPDUS-part2 repair=3D1 resume=3D/dev/disk/by-id/ata-TOSHIBA_MK3252GSX_Z8=
6CSPDUS-part1 splash=3Dsilent elevator=3Dcfq vga=3D0x317
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
[    0.000000]  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000b5aa1000 (usable)
[    0.000000]  BIOS-e820: 00000000b5aa1000 - 00000000b5aa7000 (reserved)
[    0.000000]  BIOS-e820: 00000000b5aa7000 - 00000000b5bba000 (usable)
[    0.000000]  BIOS-e820: 00000000b5bba000 - 00000000b5c0f000 (reserved)
[    0.000000]  BIOS-e820: 00000000b5c0f000 - 00000000b5d08000 (usable)
[    0.000000]  BIOS-e820: 00000000b5d08000 - 00000000b5f0f000 (reserved)
[    0.000000]  BIOS-e820: 00000000b5f0f000 - 00000000b5f18000 (usable)
[    0.000000]  BIOS-e820: 00000000b5f18000 - 00000000b5f1f000 (reserved)
[    0.000000]  BIOS-e820: 00000000b5f1f000 - 00000000b5f65000 (usable)
[    0.000000]  BIOS-e820: 00000000b5f65000 - 00000000b5f9f000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000b5f9f000 - 00000000b5fe1000 (usable)
[    0.000000]  BIOS-e820: 00000000b5fe1000 - 00000000b5fff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000b5fff000 - 00000000b6000000 (usable)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
[    0.000000] DMI present.
[    0.000000] last_pfn =3D 0x140000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 base 100000000 mask FC0000000 write-back
[    0.000000]   3 base 0B8000000 mask FF8000000 uncachable
[    0.000000]   4 base 0B7E00000 mask FFFE00000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] e820 update range: 00000000b7e00000 - 0000000100000000 (usab=
le) =3D=3D> (reserved)
[    0.000000] last_pfn =3D 0xb6000 max_arch_pfn =3D 0x400000000
[    0.000000] e820 update range: 0000000000001000 - 0000000000006000 (usab=
le) =3D=3D> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000001000 (usable)
[    0.000000]  modified: 0000000000001000 - 0000000000006000 (reserved)
[    0.000000]  modified: 0000000000006000 - 000000000009f400 (usable)
[    0.000000]  modified: 000000000009f400 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000d2000 - 00000000000d4000 (reserved)
[    0.000000]  modified: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000b5aa1000 (usable)
[    0.000000]  modified: 00000000b5aa1000 - 00000000b5aa7000 (reserved)
[    0.000000]  modified: 00000000b5aa7000 - 00000000b5bba000 (usable)
[    0.000000]  modified: 00000000b5bba000 - 00000000b5c0f000 (reserved)
[    0.000000]  modified: 00000000b5c0f000 - 00000000b5d08000 (usable)
[    0.000000]  modified: 00000000b5d08000 - 00000000b5f0f000 (reserved)
[    0.000000]  modified: 00000000b5f0f000 - 00000000b5f18000 (usable)
[    0.000000]  modified: 00000000b5f18000 - 00000000b5f1f000 (reserved)
[    0.000000]  modified: 00000000b5f1f000 - 00000000b5f65000 (usable)
[    0.000000]  modified: 00000000b5f65000 - 00000000b5f9f000 (ACPI NVS)
[    0.000000]  modified: 00000000b5f9f000 - 00000000b5fe1000 (usable)
[    0.000000]  modified: 00000000b5fe1000 - 00000000b5fff000 (ACPI data)
[    0.000000]  modified: 00000000b5fff000 - 00000000b6000000 (usable)
[    0.000000]  modified: 0000000100000000 - 0000000140000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000b6000000
[    0.000000]  0000000000 - 00b6000000 page 2M
[    0.000000] kernel direct mapping tables up to b6000000 @ 8000-c000
[    0.000000] init_memory_mapping: 0000000100000000-0000000140000000
[    0.000000]  0100000000 - 0140000000 page 2M
[    0.000000] kernel direct mapping tables up to 140000000 @ a000-10000
[    0.000000] RAMDISK: 37a98000 - 37fef116
[    0.000000] ACPI: RSDP 00000000000f6e60 00024 (v02 TOSQCI)
[    0.000000] ACPI: XSDT 00000000b5ff4a00 0007C (v01 TOSQCI TOSQCI00 06040=
000  LTP 00000000)
[    0.000000] ACPI: FACP 00000000b5fe5000 000F4 (v03 T0SQCI TOSQCI00 06040=
000 ALAN 00000001)
[    0.000000] ACPI: DSDT 00000000b5fe6000 09F7C (v02 TOSQCI CANTIGA  06040=
000 INTL 20061109)
[    0.000000] ACPI: FACS 00000000b5f9efc0 00040
[    0.000000] ACPI: APIC 00000000b5ffed1e 00068 (v01 INTEL  CRESTLNE 06040=
000 LOHR 0000005A)
[    0.000000] ACPI: HPET 00000000b5ffed86 00038 (v01 TOSQCI TOSQCI00 06040=
000 LOHR 0000005A)
[    0.000000] ACPI: MCFG 00000000b5ffedbe 0003C (v01 TOSQCI TOSQCI00 06040=
000 LOHR 0000005A)
[    0.000000] ACPI: APIC 00000000b5ffedfa 00068 (v01 PTLTD  	 APIC   06040=
000  LTP 00000000)
[    0.000000] ACPI: BOOT 00000000b5ffee62 00028 (v01 PTLTD  $SBFTBL$ 06040=
000  LTP 00000001)
[    0.000000] ACPI: SLIC 00000000b5ffee8a 00176 (v01 TOSQCI TOSQCI00 06040=
000  LTP 00000000)
[    0.000000] ACPI: SSDT 00000000b5ff4aa4 00196 (v01 SataRe SataAhci 00001=
000 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000b5fe4000 00655 (v01  PmRef    CpuPm 00003=
000 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000b5fe3000 00259 (v01  PmRef  Cpu0Tst 00003=
000 INTL 20061109)
[    0.000000] ACPI: SSDT 00000000b5fe2000 0020F (v01  PmRef    ApTst 00003=
000 INTL 20061109)
[    0.000000] ACPI: BIOS bug: multiple APIC/MADT found, using 0
[    0.000000] ACPI: If "acpi_apic_instance=3D2" works better, notify linux=
=2Dacpi@vger.kernel.org
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000140000000
[    0.000000] Bootmem setup node 0 0000000000000000-0000000140000000
[    0.000000]   NODE_DATA [000000000000b000 - 0000000000022fff]
[    0.000000]   bootmap [0000000000023000 -  000000000004afff] pages 28
[    0.000000] (8 early reservations) =3D=3D> bootmem [0000000000 - 0140000=
000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page =3D=3D> [000=
0000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE =3D=3D> [000=
0006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 0001c59cb0]    TEXT DATA BSS =3D=3D> [000=
1000000 - 0001c59cb0]
[    0.000000]   #3 [0037a98000 - 0037fef116]          RAMDISK =3D=3D> [003=
7a98000 - 0037fef116]
[    0.000000]   #4 [000009f400 - 0000100000]    BIOS reserved =3D=3D> [000=
009f400 - 0000100000]
[    0.000000]   #5 [0001c5a000 - 0001c5a1e4]              BRK =3D=3D> [000=
1c5a000 - 0001c5a1e4]
[    0.000000]   #6 [0000008000 - 000000a000]          PGTABLE =3D=3D> [000=
0008000 - 000000a000]
[    0.000000]   #7 [000000a000 - 000000b000]          PGTABLE =3D=3D> [000=
000a000 - 000000b000]
[    0.000000] found SMP MP-table at [ffff8800000f6f20] f6f20
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> [ffff880001e0000=
0-ffff8800055fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00140000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[10] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000001
[    0.000000]     0: 0x00000006 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000b5aa1
[    0.000000]     0: 0x000b5aa7 -> 0x000b5bba
[    0.000000]     0: 0x000b5c0f -> 0x000b5d08
[    0.000000]     0: 0x000b5f0f -> 0x000b5f18
[    0.000000]     0: 0x000b5f1f -> 0x000b5f65
[    0.000000]     0: 0x000b5f9f -> 0x000b5fe1
[    0.000000]     0: 0x000b5fff -> 0x000b6000
[    0.000000]     0: 0x00100000 -> 0x00140000
[    0.000000] On node 0 totalpages: 1006809
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 102 pages reserved
[    0.000000]   DMA zone: 3836 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 726391 pages, LIFO batch:31
[    0.000000]   Normal zone: 3584 pages used for memmap
[    0.000000]   Normal zone: 258560 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 0000000000001000 - 00000000000=
06000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000=
a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000=
d2000
[    0.000000] PM: Registered nosave memory: 00000000000d2000 - 00000000000=
d4000
[    0.000000] PM: Registered nosave memory: 00000000000d4000 - 00000000000=
dc000
[    0.000000] PM: Registered nosave memory: 00000000000dc000 - 00000000001=
00000
[    0.000000] PM: Registered nosave memory: 00000000b5aa1000 - 00000000b5a=
a7000
[    0.000000] PM: Registered nosave memory: 00000000b5bba000 - 00000000b5c=
0f000
[    0.000000] PM: Registered nosave memory: 00000000b5d08000 - 00000000b5f=
0f000
[    0.000000] PM: Registered nosave memory: 00000000b5f18000 - 00000000b5f=
1f000
[    0.000000] PM: Registered nosave memory: 00000000b5f65000 - 00000000b5f=
9f000
[    0.000000] PM: Registered nosave memory: 00000000b5fe1000 - 00000000b5f=
ff000
[    0.000000] PM: Registered nosave memory: 00000000b6000000 - 00000001000=
00000
[    0.000000] Allocating PCI resources starting at b6000000 (gap: b6000000=
:4a000000)
[    0.000000] NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages at ffff88000564b000, static data 8=
2784 bytes
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Tota=
l pages: 988787
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=3D/dev/disk/by-id/ata-TOSHIBA_MK32=
52GSX_Z86CSPDUS-part2 repair=3D1 resume=3D/dev/disk/by-id/ata-TOSHIBA_MK325=
2GSX_Z86CSPDUS-part1 splash=3Dsilent elevator=3Dcfq vga=3D0x317
[    0.000000] bootsplash: silent mode.
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.000000] Placing 64MB software IO TLB between ffff88000568c000 - ffff=
88000968c000
[    0.000000] software IO TLB at phys 0x568c000 - 0x968c000
[    0.000000] Memory: 3885104k/5242880k available (5588k kernel code, 1215=
644k absent, 142132k reserved, 4405k data, 1004k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:424
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2526.452 MHz processor.
[    0.000089] Console: colour dummy device 80x25
[    0.000091] console [tty0] enabled
[    0.000547] hpet clockevent registered
[    0.000552] HPET: 4 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.000561] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 5052.90 BogoMIPS (lpj=3D2526452)
[    0.007074] kdb version 4.4 by Keith Owens, Scott Lurndal. Copyright SGI=
, All Rights Reserved
[    0.007185] Security Framework initialized
[    0.007206] AppArmor: AppArmor initialized
[    0.007515] Dentry cache hash table entries: 524288 (order: 10, 4194304 =
bytes)
[    0.009793] Inode-cache hash table entries: 262144 (order: 9, 2097152 by=
tes)
[    0.011308] Mount-cache hash table entries: 256
[    0.011495] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.011500] CPU: L2 cache: 3072K
[    0.011505] CPU 0/0x0 -> Node 0
[    0.011508] CPU: Physical Processor ID: 0
[    0.011511] CPU: Processor Core ID: 0
[    0.011515] mce: CPU supports 6 MCE banks
[    0.011524] CPU0: Thermal monitoring enabled (TM2)
[    0.011530] using mwait in idle threads.
[    0.011532] Performance Counters: Core2 events, Intel PMU driver.
[    0.011541] ... version:                 2
[    0.011543] ... bit width:               40
[    0.011546] ... generic counters:        2
[    0.011549] ... value mask:              000000ffffffffff
[    0.011552] ... max period:              000000007fffffff
[    0.011555] ... fixed-purpose counters:  3
[    0.011558] ... counter mask:            0000000700000003
[    0.012471] ACPI: Core revision 20090521
[    0.028068] Setting APIC routing to flat
[    0.029313] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
=2D1
[    0.039322] CPU0: Intel(R) Core(TM)2 Duo CPU     P8700  @ 2.53GHz steppi=
ng 0a
[    0.039993] Booting processor 1 APIC 0x1 ip 0x6000
[    0.000999] Initializing CPU#1
[    0.000999] Calibrating delay using timer specific routine.. 5053.74 Bog=
oMIPS (lpj=3D2526874)
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 3072K
[    0.000999] CPU 1/0x1 -> Node 0
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 1
[    0.000999] mce: CPU supports 6 MCE banks
[    0.000999] CPU1: Thermal monitoring enabled (TM2)
[    0.000999] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x701060007=
0106
[    0.111553] CPU1: Intel(R) Core(TM)2 Duo CPU     P8700  @ 2.53GHz steppi=
ng 0a
[    0.111581] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.112009] Brought up 2 CPUs
[    0.112009] Total of 2 processors activated (10106.65 BogoMIPS).
[    0.112071] CPU0 attaching sched-domain:
[    0.112073]  domain 0: span 0-1 level MC
[    0.112076]   groups: 0 1
[    0.112081] CPU1 attaching sched-domain:
[    0.112082]  domain 0: span 0-1 level MC
[    0.112084]   groups: 1 0
[    0.114609] devtmpfs: initialized
[    0.117834] Booting paravirtualized kernel on bare hardware
[    0.118004] regulator: core version 0.5
[    0.118035] Time: 23:15:13  Date: 08/07/09
[    0.118091] NET: Registered protocol family 16
[    0.118217] ACPI FADT declares the system doesn't support PCIe ASPM, so =
disable it
[    0.118223] ACPI: bus type pci registered
[    0.118291] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 -=
 255
[    0.118296] PCI: Not using MMCONFIG.
[    0.118299] PCI: Using configuration type 1 for base access
[    0.119061] bio: create slab <bio-0> at 0
[    0.120106] ACPI: EC: Look up EC in DSDT
[    0.126221] ACPI: BIOS _OSI(Linux) query ignored
[    0.128104] ACPI: EC: non-query interrupt received, switching to interru=
pt mode
[    0.633002] ACPI: EC: missing confirmations, switch off interrupt mode.
[    0.796112] ACPI: Interpreter enabled
[    0.796117] ACPI: (supports S0 S3 S4 S5)
[    0.796143] ACPI: Using IOAPIC for interrupt routing
[    0.796197] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 -=
 255
[    0.798923] PCI: MCFG area at e0000000 reserved in ACPI motherboard reso=
urces
[    0.810560] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.817014] ACPI: EC: GPE =3D 0x18, I/O: command/status =3D 0x66, data =
=3D 0x62
[    0.817019] ACPI: EC: driver started in poll mode
[    0.817448] ACPI: No dock devices found.
[    0.818121] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.818210] pci 0000:00:02.0: reg 10 64bit mmio: [0xf4000000-0xf43fffff]
[    0.818216] pci 0000:00:02.0: reg 18 64bit mmio: [0xd0000000-0xdfffffff]
[    0.818220] pci 0000:00:02.0: reg 20 io port: [0x1800-0x1807]
[    0.818253] pci 0000:00:02.1: reg 10 64bit mmio: [0xf4400000-0xf44fffff]
[    0.818373] pci 0000:00:1a.0: reg 20 io port: [0x1820-0x183f]
[    0.818464] pci 0000:00:1a.1: reg 20 io port: [0x1840-0x185f]
[    0.818555] pci 0000:00:1a.2: reg 20 io port: [0x1860-0x187f]
[    0.818648] pci 0000:00:1a.7: reg 10 32bit mmio: [0xf4a04800-0xf4a04bff]
[    0.818713] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.818721] pci 0000:00:1a.7: PME# disabled
[    0.818777] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf4800000-0xf4803fff]
[    0.818836] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.818842] pci 0000:00:1b.0: PME# disabled
[    0.818925] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.818932] pci 0000:00:1c.0: PME# disabled
[    0.819025] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.819031] pci 0000:00:1c.4: PME# disabled
[    0.819117] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.819123] pci 0000:00:1c.5: PME# disabled
[    0.819198] pci 0000:00:1d.0: reg 20 io port: [0x1880-0x189f]
[    0.819287] pci 0000:00:1d.1: reg 20 io port: [0x18a0-0x18bf]
[    0.819379] pci 0000:00:1d.2: reg 20 io port: [0x18c0-0x18df]
[    0.819471] pci 0000:00:1d.7: reg 10 32bit mmio: [0xf4a04c00-0xf4a04fff]
[    0.819538] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.819545] pci 0000:00:1d.7: PME# disabled
[    0.819793] pci 0000:00:1f.2: reg 10 io port: [0x1818-0x181f]
[    0.819800] pci 0000:00:1f.2: reg 14 io port: [0x180c-0x180f]
[    0.819808] pci 0000:00:1f.2: reg 18 io port: [0x1810-0x1817]
[    0.819815] pci 0000:00:1f.2: reg 1c io port: [0x1808-0x180b]
[    0.819822] pci 0000:00:1f.2: reg 20 io port: [0x18e0-0x18ff]
[    0.819829] pci 0000:00:1f.2: reg 24 32bit mmio: [0xf4a04000-0xf4a047ff]
[    0.819875] pci 0000:00:1f.2: PME# supported from D3hot
[    0.819881] pci 0000:00:1f.2: PME# disabled
[    0.819921] pci 0000:00:1f.3: reg 10 64bit mmio: [0x000000-0x0000ff]
[    0.819939] pci 0000:00:1f.3: reg 20 io port: [0x1c00-0x1c1f]
[    0.820029] pci 0000:00:1c.0: bridge io port: [0x00-0xfff]
[    0.820033] pci 0000:00:1c.0: bridge 32bit mmio: [0x000000-0x0fffff]
[    0.820041] pci 0000:00:1c.0: bridge 64bit mmio pref: [0x000000-0x0fffff]
[    0.820113] pci 0000:07:00.0: reg 10 64bit mmio: [0x000000-0x003fff]
[    0.820123] pci 0000:07:00.0: reg 18 io port: [0x00-0xff]
[    0.820203] pci 0000:07:00.0: supports D1 D2
[    0.820204] pci 0000:07:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.820213] pci 0000:07:00.0: PME# disabled
[    0.820289] pci 0000:00:1c.4: bridge io port: [0x00-0xfff]
[    0.820294] pci 0000:00:1c.4: bridge 32bit mmio: [0x000000-0x0fffff]
[    0.820301] pci 0000:00:1c.4: bridge 64bit mmio pref: [0x000000-0x0fffff]
[    0.820388] pci 0000:08:00.0: reg 10 64bit mmio: [0x000000-0x001fff]
[    0.820501] pci 0000:08:00.0: PME# supported from D0 D3hot D3cold
[    0.820510] pci 0000:08:00.0: PME# disabled
[    0.820593] pci 0000:00:1c.5: bridge io port: [0x00-0xfff]
[    0.820598] pci 0000:00:1c.5: bridge 32bit mmio: [0x000000-0x0fffff]
[    0.820605] pci 0000:00:1c.5: bridge 64bit mmio pref: [0x000000-0x0fffff]
[    0.820647] pci 0000:0a:01.0: reg 10 32bit mmio: [0xff501000-0xff501fff]
[    0.820655] pci 0000:0a:01.0: reg 14 32bit mmio: [0xf4700000-0xf47007ff]
[    0.820702] pci 0000:0a:01.0: supports D1 D2
[    0.820704] pci 0000:0a:01.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.820711] pci 0000:0a:01.0: PME# disabled
[    0.820759] pci 0000:0a:01.2: reg 10 32bit mmio: [0xf4700800-0xf47008ff]
[    0.820826] pci 0000:0a:01.2: supports D1 D2
[    0.820828] pci 0000:0a:01.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.820835] pci 0000:0a:01.2: PME# disabled
[    0.820883] pci 0000:0a:01.3: reg 10 32bit mmio: [0xf4702000-0xf4702fff]
[    0.820948] pci 0000:0a:01.3: supports D1 D2
[    0.820950] pci 0000:0a:01.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.820957] pci 0000:0a:01.3: PME# disabled
[    0.821026] pci 0000:00:1e.0: transparent bridge
[    0.821035] pci 0000:00:1e.0: bridge 32bit mmio: [0xf4700000-0xf47fffff]
[    0.821070] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.821226] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.821336] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.821426] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05._PRT]
[    0.835123] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 1=
5) *11
[    0.835249] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 *5 6 7 11 12 14 =
15)
[    0.835373] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 *6 7 10 12 14 =
15)
[    0.835496] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 1=
5) *10
[    0.835621] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 1=
5) *0, disabled.
[    0.835746] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 *11 12 14 =
15)
[    0.835870] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 *10 12 14 =
15)
[    0.835994] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 *7 11 12 14 =
15)
[    0.836187] SCSI subsystem initialized
[    0.836832] libata version 3.00 loaded.
[    0.836832] usbcore: registered new interface driver usbfs
[    0.836832] usbcore: registered new interface driver hub
[    0.836832] usbcore: registered new device driver usb
[    0.836832] PCI: Using ACPI for IRQ routing
[    0.836832] pci 0000:00:1c.0: BAR 13: can't allocate resource
[    0.836832] pci 0000:00:1c.0: BAR 14: can't allocate resource
[    0.836832] pci 0000:00:1c.0: BAR 15: can't allocate resource
[    0.836832] pci 0000:00:1c.4: BAR 13: can't allocate resource
[    0.836832] pci 0000:00:1c.4: BAR 14: can't allocate resource
[    0.836832] pci 0000:00:1c.4: BAR 15: can't allocate resource
[    0.836832] pci 0000:00:1c.5: BAR 13: can't allocate resource
[    0.836832] pci 0000:00:1c.5: BAR 14: can't allocate resource
[    0.836832] pci 0000:00:1c.5: BAR 15: can't allocate resource
[    0.839028] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.839036] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.843007] Switched to high resolution mode on CPU 0
[    0.843619] Switched to high resolution mode on CPU 1
[    0.843711] AppArmor: AppArmor Filesystem Enabled
[    0.845258] pnp: PnP ACPI init
[    0.845268] ACPI: bus type pnp registered
[    0.846503] pnp 00:04: io resource (0x2e-0x2f) overlaps 0000:07:00.0 BAR=
 2 (0x0-0xff), disabling
[    0.846510] pnp 00:04: io resource (0x4e-0x4f) overlaps 0000:07:00.0 BAR=
 2 (0x0-0xff), disabling
[    0.846516] pnp 00:04: io resource (0x61-0x61) overlaps 0000:07:00.0 BAR=
 2 (0x0-0xff), disabling
[    0.846522] pnp 00:04: io resource (0x63-0x63) overlaps 0000:07:00.0 BAR=
 2 (0x0-0xff), disabling
[    0.846527] pnp 00:04: io resource (0x65-0x65) overlaps 0000:07:00.0 BAR=
 2 (0x0-0xff), disabling
[    0.846533] pnp 00:04: io resource (0x67-0x67) overlaps 0000:07:00.0 BAR=
 2 (0x0-0xff), disabling
[    0.846538] pnp 00:04: io resource (0x68-0x68) overlaps 0000:07:00.0 BAR=
 2 (0x0-0xff), disabling
[    0.846544] pnp 00:04: io resource (0x6c-0x6c) overlaps 0000:07:00.0 BAR=
 2 (0x0-0xff), disabling
[    0.846549] pnp 00:04: io resource (0x70-0x70) overlaps 0000:07:00.0 BAR=
 2 (0x0-0xff), disabling
[    0.846555] pnp 00:04: io resource (0x80-0x80) overlaps 0000:07:00.0 BAR=
 2 (0x0-0xff), disabling
[    0.846560] pnp 00:04: io resource (0x92-0x92) overlaps 0000:07:00.0 BAR=
 2 (0x0-0xff), disabling
[    0.846566] pnp 00:04: io resource (0xb2-0xb3) overlaps 0000:07:00.0 BAR=
 2 (0x0-0xff), disabling
[    0.847953] pnp: PnP ACPI: found 9 devices
[    0.847957] ACPI: ACPI bus type pnp unregistered
[    0.847968] system 00:02: iomem range 0xfed00000-0xfed003ff has been res=
erved
[    0.847977] system 00:04: ioport range 0x3e0-0x3e1 has been reserved
[    0.847981] system 00:04: ioport range 0x400-0x47f has been reserved
[    0.847986] system 00:04: ioport range 0x680-0x69f has been reserved
[    0.847990] system 00:04: ioport range 0x480-0x48f has been reserved
[    0.847994] system 00:04: ioport range 0xffff-0xffff has been reserved
[    0.847999] system 00:04: ioport range 0xffff-0xffff has been reserved
[    0.848003] system 00:04: ioport range 0x1180-0x11ff has been reserved
[    0.848008] system 00:04: ioport range 0x164e-0x164f has been reserved
[    0.848012] system 00:04: ioport range 0xfe00-0xfe00 has been reserved
[    0.848020] system 00:08: iomem range 0xfed1c000-0xfed1ffff has been res=
erved
[    0.848025] system 00:08: iomem range 0xfed10000-0xfed13fff has been res=
erved
[    0.848030] system 00:08: iomem range 0xfed18000-0xfed18fff has been res=
erved
[    0.848034] system 00:08: iomem range 0xfed19000-0xfed19fff has been res=
erved
[    0.848039] system 00:08: iomem range 0xe0000000-0xefffffff has been res=
erved
[    0.848043] system 00:08: iomem range 0xfed20000-0xfed3ffff has been res=
erved
[    0.848049] system 00:08: iomem range 0xfed45000-0xfed8ffff has been res=
erved
[    0.852867] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    0.852872] pci 0000:00:1c.0:   IO window: disabled
[    0.852879] pci 0000:00:1c.0:   MEM window: disabled
[    0.852886] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.852905] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:07
[    0.852910] pci 0000:00:1c.4:   IO window: 0x2000-0x2fff
[    0.852918] pci 0000:00:1c.4:   MEM window: 0xb6000000-0xb60fffff
[    0.852924] pci 0000:00:1c.4:   PREFETCH window: disabled
[    0.852942] pci 0000:00:1c.5: PCI bridge, secondary bus 0000:08
[    0.852945] pci 0000:00:1c.5:   IO window: disabled
[    0.852952] pci 0000:00:1c.5:   MEM window: 0xb6100000-0xb61fffff
[    0.852958] pci 0000:00:1c.5:   PREFETCH window: disabled
[    0.852965] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:0a
[    0.852969] pci 0000:00:1e.0:   IO window: disabled
[    0.852976] pci 0000:00:1e.0:   MEM window: 0xf4700000-0xf47fffff
[    0.852982] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.852996]   alloc irq_desc for 17 on node 0
[    0.852998]   alloc kstat_irqs on node 0
[    0.853003] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.853012] pci 0000:00:1c.0: setting latency timer to 64
[    0.853020] pci 0000:00:1c.4: enabling device (0000 -> 0003)
[    0.853026] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.853034] pci 0000:00:1c.4: setting latency timer to 64
[    0.853042] pci 0000:00:1c.5: enabling device (0000 -> 0002)
[    0.853047]   alloc irq_desc for 16 on node 0
[    0.853048]   alloc kstat_irqs on node 0
[    0.853051] pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.853059] pci 0000:00:1c.5: setting latency timer to 64
[    0.853067] pci 0000:00:1e.0: setting latency timer to 64
[    0.853071] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.853073] pci_bus 0000:00: resource 1 mem: [0x000000-0xfffffffffffffff=
f]
[    0.853076] pci_bus 0000:02: resource 0 mem: [0x0-0xfff]
[    0.853077] pci_bus 0000:02: resource 1 mem: [0x0-0xfffff]
[    0.853079] pci_bus 0000:02: resource 2 mem: [0x0-0xfffff]
[    0.853081] pci_bus 0000:07: resource 0 io:  [0x2000-0x2fff]
[    0.853083] pci_bus 0000:07: resource 1 mem: [0xb6000000-0xb60fffff]
[    0.853085] pci_bus 0000:07: resource 2 mem: [0x0-0xfffff]
[    0.853087] pci_bus 0000:08: resource 0 mem: [0x0-0xfff]
[    0.853089] pci_bus 0000:08: resource 1 mem: [0xb6100000-0xb61fffff]
[    0.853091] pci_bus 0000:08: resource 2 mem: [0x0-0xfffff]
[    0.853094] pci_bus 0000:0a: resource 1 mem: [0xf4700000-0xf47fffff]
[    0.853096] pci_bus 0000:0a: resource 3 io:  [0x00-0xffff]
[    0.853098] pci_bus 0000:0a: resource 4 mem: [0x000000-0xfffffffffffffff=
f]
[    0.853157] NET: Registered protocol family 2
[    0.853332] IP route cache hash table entries: 131072 (order: 8, 1048576=
 bytes)
[    0.854449] TCP established hash table entries: 524288 (order: 11, 83886=
08 bytes)
[    0.858108] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.858603] TCP: Hash tables configured (established 524288 bind 65536)
[    0.858608] TCP reno registered
[    0.858765] NET: Registered protocol family 1
[    0.858834] Unpacking initramfs...
[    0.944033] Freeing initrd memory: 5468k freed
[    0.946049] Simple Boot Flag at 0x36 set to 0x1
[    0.946370] Scanning for low memory corruption every 60 seconds
[    0.946576] audit: initializing netlink socket (disabled)
[    0.946595] type=3D2000 audit(1249686912.946:1): initialized
[    0.949690] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.949818] VFS: Disk quotas dquot_6.5.2
[    0.949855] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.950001] msgmni has been set to 1899
[    0.950223] alg: No test for stdrng (krng)
[    0.950261] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 253)
[    0.950267] io scheduler noop registered
[    0.950270] io scheduler anticipatory registered
[    0.950273] io scheduler deadline registered
[    0.950294] io scheduler cfq registered (default)
[    0.950360] pci 0000:00:02.0: Boot video device
[    0.950662]   alloc irq_desc for 24 on node 0
[    0.950664]   alloc kstat_irqs on node 0
[    0.950677] pcieport-driver 0000:00:1c.0: irq 24 for MSI/MSI-X
[    0.950688] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.950856]   alloc irq_desc for 25 on node 0
[    0.950858]   alloc kstat_irqs on node 0
[    0.950866] pcieport-driver 0000:00:1c.4: irq 25 for MSI/MSI-X
[    0.950876] pcieport-driver 0000:00:1c.4: setting latency timer to 64
[    0.951040]   alloc irq_desc for 26 on node 0
[    0.951042]   alloc kstat_irqs on node 0
[    0.951050] pcieport-driver 0000:00:1c.5: irq 26 for MSI/MSI-X
[    0.951061] pcieport-driver 0000:00:1c.5: setting latency timer to 64
[    0.951491] vesafb: framebuffer at 0xd0000000, mapped to 0xffffc90011100=
000, using 6144k, total 131008k
[    0.951497] vesafb: mode is 1024x768x16, linelength=3D2048, pages=3D84
[    0.951501] vesafb: scrolling: redraw
[    0.951505] vesafb: Truecolor: size=3D0:5:6:5, shift=3D0:11:5:0
[    0.951678] bootsplash 3.1.6-2004/03/31: looking for picture...
[    0.960651] bootsplash: silentjpeg size 100719 bytes
[    0.971563] bootsplash: ...found (1024x768, 38691 bytes, v3).
[    1.003477] Console: switching to colour frame buffer device 124x44
[    1.047157] fb0: VESA VGA frame buffer device
[    1.048776] Non-volatile memory driver v1.3
[    1.048874] Linux agpgart interface v0.103
[    1.048969] Serial: 8250/16550 driver, 8 ports, IRQ sharing disabled
[    1.049340] Platform driver 'serial8250' needs updating - please use dev=
_pm_ops
[    1.049757] ahci 0000:00:1f.2: version 3.0
[    1.049774]   alloc irq_desc for 19 on node 0
[    1.049776]   alloc kstat_irqs on node 0
[    1.049784] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.049976]   alloc irq_desc for 27 on node 0
[    1.049978]   alloc kstat_irqs on node 0
[    1.049988] ahci 0000:00:1f.2: irq 27 for MSI/MSI-X
[    1.050079] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x=
33 impl SATA mode
[    1.050266] ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pio slum pa=
rt ems=20
[    1.050436] ahci 0000:00:1f.2: setting latency timer to 64
[    1.056048] scsi0 : ahci
[    1.056205] scsi1 : ahci
[    1.056312] scsi2 : ahci
[    1.056415] scsi3 : ahci
[    1.056519] scsi4 : ahci
[    1.056624] scsi5 : ahci
[    1.056824] ata1: SATA max UDMA/133 abar m2048@0xf4a04000 port 0xf4a0410=
0 irq 27
[    1.056995] ata2: SATA max UDMA/133 abar m2048@0xf4a04000 port 0xf4a0418=
0 irq 27
[    1.057169] ata3: DUMMY
[    1.057226] ata4: DUMMY
[    1.057284] ata5: SATA max UDMA/133 abar m2048@0xf4a04000 port 0xf4a0430=
0 irq 27
[    1.059192] ata6: SATA max UDMA/133 abar m2048@0xf4a04000 port 0xf4a0438=
0 irq 27
[    1.061181] Fixed MDIO Bus: probed
[    1.063134] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.065311] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 19 (level, low) -> I=
RQ 19
[    1.067581] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    1.067584] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    1.069905] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus =
number 1
[    1.076248] ehci_hcd 0000:00:1a.7: debug port 1
[    1.078700] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    1.078713] ehci_hcd 0000:00:1a.7: irq 19, io mem 0xf4a04800
[    1.091009] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    1.093624] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    1.096353] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.099176] usb usb1: Product: EHCI Host Controller
[    1.102058] usb usb1: Manufacturer: Linux 2.6.31-rc5-git3-13-desktop ehc=
i_hcd
[    1.105106] usb usb1: SerialNumber: 0000:00:1a.7
[    1.108274] usb usb1: configuration #1 chosen from 1 choice
[    1.111492] hub 1-0:1.0: USB hub found
[    1.114741] hub 1-0:1.0: 6 ports detected
[    1.119266]   alloc irq_desc for 23 on node 0
[    1.119268]   alloc kstat_irqs on node 0
[    1.119273] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> I=
RQ 23
[    1.122755] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.122759] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.126273] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus =
number 2
[    1.133818] ehci_hcd 0000:00:1d.7: debug port 1
[    1.137485] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    1.137501] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf4a04c00
[    1.151010] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.154820] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    1.158643] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.162452] usb usb2: Product: EHCI Host Controller
[    1.166258] usb usb2: Manufacturer: Linux 2.6.31-rc5-git3-13-desktop ehc=
i_hcd
[    1.170161] usb usb2: SerialNumber: 0000:00:1d.7
[    1.174067] usb usb2: configuration #1 chosen from 1 choice
[    1.177902] hub 2-0:1.0: USB hub found
[    1.181634] hub 2-0:1.0: 6 ports detected
[    1.185359] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.189078] uhci_hcd: USB Universal Host Controller Interface driver
[    1.192811] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[    1.196626] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.196630] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    1.200472] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus =
number 3
[    1.204471] uhci_hcd 0000:00:1a.0: irq 16, io base 0x00001820
[    1.208510] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    1.212655] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.216777] usb usb3: Product: UHCI Host Controller
[    1.220974] usb usb3: Manufacturer: Linux 2.6.31-rc5-git3-13-desktop uhc=
i_hcd
[    1.225192] usb usb3: SerialNumber: 0000:00:1a.0
[    1.229502] usb usb3: configuration #1 chosen from 1 choice
[    1.233765] hub 3-0:1.0: USB hub found
[    1.238045] hub 3-0:1.0: 2 ports detected
[    1.243262]   alloc irq_desc for 21 on node 0
[    1.243265]   alloc kstat_irqs on node 0
[    1.243269] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> I=
RQ 21
[    1.247543] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    1.247546] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    1.251741] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus =
number 4
[    1.256020] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001840
[    1.260257] usb usb4: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    1.264527] usb usb4: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.268840] usb usb4: Product: UHCI Host Controller
[    1.273156] usb usb4: Manufacturer: Linux 2.6.31-rc5-git3-13-desktop uhc=
i_hcd
[    1.277510] usb usb4: SerialNumber: 0000:00:1a.1
[    1.281874] usb usb4: configuration #1 chosen from 1 choice
[    1.286222] hub 4-0:1.0: USB hub found
[    1.290461] hub 4-0:1.0: 2 ports detected
[    1.294701] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 19 (level, low) -> I=
RQ 19
[    1.298989] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    1.298992] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    1.303227] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus =
number 5
[    1.307579] uhci_hcd 0000:00:1a.2: irq 19, io base 0x00001860
[    1.311873] usb usb5: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    1.316202] usb usb5: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.320562] usb usb5: Product: UHCI Host Controller
[    1.324876] usb usb5: Manufacturer: Linux 2.6.31-rc5-git3-13-desktop uhc=
i_hcd
[    1.329295] usb usb5: SerialNumber: 0000:00:1a.2
[    1.333764] usb usb5: configuration #1 chosen from 1 choice
[    1.338181] hub 5-0:1.0: USB hub found
[    1.342561] hub 5-0:1.0: 2 ports detected
[    1.346913] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> I=
RQ 23
[    1.351278] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.351282] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.355581] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus =
number 6
[    1.359956] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00001880
[    1.364298] usb usb6: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    1.368719] usb usb6: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.373277] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.373351] usb usb6: Product: UHCI Host Controller
[    1.373352] usb usb6: Manufacturer: Linux 2.6.31-rc5-git3-13-desktop uhc=
i_hcd
[    1.373354] usb usb6: SerialNumber: 0000:00:1d.0
[    1.373406] usb usb6: configuration #1 chosen from 1 choice
[    1.373438] hub 6-0:1.0: USB hub found
[    1.373444] hub 6-0:1.0: 2 ports detected
[    1.404049] ata5: SATA link down (SStatus 0 SControl 300)
[    1.408375] ata6: SATA link down (SStatus 0 SControl 300)
[    1.412599] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.416835] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> I=
RQ 19
[    1.417718] ACPI Warning: \_SB_.PCI0.SAT0.PRT0._GTF: Return type mismatc=
h - found Integer, expected Buffer 20090521 nspredef-940
[    1.417725] ata1.00: _GTF unexpected object type 0x1
[    1.434519] ata2.00: ATAPI: MATSHITADVD-RAM UJ862AS, 1.50, max UDMA/33
[    1.434522] usb 1-1: new high speed USB device using ehci_hcd and addres=
s 2
[    1.434539] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    1.434542] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.434552] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus =
number 7
[    1.434583] uhci_hcd 0000:00:1d.1: irq 19, io base 0x000018a0
[    1.434619] usb usb7: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    1.434621] usb usb7: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.434622] usb usb7: Product: UHCI Host Controller
[    1.434624] usb usb7: Manufacturer: Linux 2.6.31-rc5-git3-13-desktop uhc=
i_hcd
[    1.434625] usb usb7: SerialNumber: 0000:00:1d.1
[    1.434689] usb usb7: configuration #1 chosen from 1 choice
[    1.434713] hub 7-0:1.0: USB hub found
[    1.434718] hub 7-0:1.0: 2 ports detected
[    1.454194] ata1.00: ATA-8: TOSHIBA MK3252GSX, LV010M, max UDMA/100
[    1.454196] ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.502931]   alloc irq_desc for 18 on node 0
[    1.502933]   alloc kstat_irqs on node 0
[    1.502938] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> I=
RQ 18
[    1.503763] ata1.00: _GTF unexpected object type 0x1
[    1.505439] ata1.00: configured for UDMA/100
[    1.505545] scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK3252GS LV=
01 PQ: 0 ANSI: 5
[    1.505705] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB=
/298 GiB)
[    1.505746] sd 0:0:0:0: [sda] Write Protect is off
[    1.505748] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.505769] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.505884]  sda:
[    1.505936] ata2.00: configured for UDMA/33
[    1.544577] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    1.544580] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.549286] ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0xf t4
[    1.549289] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus =
number 8
[    1.549327] uhci_hcd 0000:00:1d.2: irq 18, io base 0x000018c0
[    1.549365] usb usb8: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    1.549366] usb usb8: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    1.549368] usb usb8: Product: UHCI Host Controller
[    1.549369] usb usb8: Manufacturer: Linux 2.6.31-rc5-git3-13-desktop uhc=
i_hcd
[    1.549371] usb usb8: SerialNumber: 0000:00:1d.2
[    1.549431] usb usb8: configuration #1 chosen from 1 choice
[    1.549455] hub 8-0:1.0: USB hub found
[    1.549463] hub 8-0:1.0: 2 ports detected
[    1.559520]  sda1 sda2
[    1.566029] Initializing USB Mass Storage driver...
[    1.566068] usbcore: registered new interface driver usb-storage
[    1.566070] USB Mass Storage support registered.
[    1.566104] usbcore: registered new interface driver libusual
[    1.566115] usbcore: registered new interface driver ums-alauda
[    1.566125] usbcore: registered new interface driver ums-cypress
[    1.566136] usbcore: registered new interface driver ums-datafab
[    1.566146] usbcore: registered new interface driver ums-freecom
[    1.566158] usbcore: registered new interface driver ums-isd200
[    1.566168] usbcore: registered new interface driver ums-jumpshot
[    1.566177] usbcore: registered new interface driver ums-karma
[    1.566188] usbcore: registered new interface driver ums-onetouch
[    1.566198] usbcore: registered new interface driver ums-sddr09
[    1.566208] usbcore: registered new interface driver ums-sddr55
[    1.566218] usbcore: registered new interface driver ums-usbat
[    1.566258] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x6=
4 irq 1,12
[    1.566269] Platform driver 'i8042' needs updating - please use dev_pm_o=
ps
[    1.568639] i8042.c: Detected active multiplexing controller, rev 1.1.
[    1.570912] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.570917] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    1.570920] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    1.570922] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    1.570924] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    1.570987] mice: PS/2 mouse device common for all mice
[    1.571095] rtc_cmos 00:05: RTC can wake from S4
[    1.571132] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    1.571164] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    1.571174] cpuidle: using governor ladder
[    1.571176] cpuidle: using governor menu
[    1.571401] usbcore: registered new interface driver hiddev
[    1.571414] usbcore: registered new interface driver usbhid
[    1.571416] usbhid: v2.6:USB HID core driver
[    1.727963] TCP cubic registered
[    1.731058] NET: Registered protocol family 10
[    1.734489] lo: Disabled Privacy Extensions
[    1.737769] lib80211: common routines for IEEE802.11 drivers
[    1.740811] lib80211_crypt: registered algorithm 'NULL'
[    1.740897] PM: Checking image partition /dev/disk/by-id/ata-TOSHIBA_MK3=
252GSX_Z86CSPDUS-part1
[    1.741136] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.744169] ata2: irq_stat 0x40000001
[    1.747133] ata2: hard resetting link
[    1.755909] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input0
[    1.760433] usb 1-1: New USB device found, idVendor=3D05e3, idProduct=3D=
0606
[    1.763572] usb 1-1: New USB device strings: Mfr=3D0, Product=3D1, Seria=
lNumber=3D0
[    1.766770] usb 1-1: Product: USB2.0 Hub
[    1.769992] usb 1-1: configuration #1 chosen from 1 choice
[    1.773458] hub 1-1:1.0: USB hub found
[    1.776935] hub 1-1:1.0: 4 ports detected
[    1.935012] usb 2-1: new high speed USB device using ehci_hcd and addres=
s 2
[    2.193148] usb 2-1: New USB device found, idVendor=3D07d1, idProduct=3D=
3c03
[    2.196409] usb 2-1: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0
[    2.199750] usb 2-1: Product: 802.11 bg WLAN
[    2.203116] usb 2-1: Manufacturer: Ralink
[    2.206565] usb 2-1: configuration #1 chosen from 1 choice
[    2.312016] usb 2-4: new high speed USB device using ehci_hcd and addres=
s 3
[    2.443953] usb 2-4: New USB device found, idVendor=3D04f2, idProduct=3D=
b008
[    2.447658] usb 2-4: New USB device strings: Mfr=3D2, Product=3D1, Seria=
lNumber=3D3
[    2.451434] usb 2-4: Product: Chicony USB 2.0 Camera
[    2.455332] usb 2-4: Manufacturer: Chicony Electronics Co., Ltd.
[    2.459245] usb 2-4: SerialNumber: SN0001
[    2.463227] usb 2-4: configuration #1 chosen from 1 choice
[    2.473269] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.480889] ata2.00: configured for UDMA/33
[    2.486254] ata2: EH complete
[    2.502762] scsi 1:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ862AS  1.=
50 PQ: 0 ANSI: 5
[    2.506840] PM: Resume from disk failed.
[    2.506856] registered taskstats version 1
[    2.510920]   Magic number: 5:697:301
[    2.514948] tty tty30: hash matches
[    2.519057] rtc_cmos 00:05: setting system clock to 2009-08-07 23:15:15 =
UTC (1249686915)
[    2.523343] Freeing unused kernel memory: 1004k freed
[    2.527793] Write protecting the kernel read-only data: 8848k
[    2.573378] BIOS EDD facility v0.16 2004-Jun-25, 3 devices found
[    2.588181] udevd version 128 started
[    2.622150] Synaptics Touchpad, model: 1, fw: 7.0, id: 0x1e0b1, caps: 0x=
d04711/0xa00000
[    2.660391] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042=
/serio4/input/input1
[    2.681029] usb 3-2: new low speed USB device using uhci_hcd and address=
 2
[    2.848867] usb 3-2: New USB device found, idVendor=3D046d, idProduct=3D=
c50a
[    2.853513] usb 3-2: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0
[    2.858086] usb 3-2: Product: USB Receiver
[    2.862653] usb 3-2: Manufacturer: Logitech
[    2.867231] usb 3-2: configuration #1 chosen from 1 choice
[    2.891171] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:=
1a.0/usb3/3-2/3-2:1.0/input/input2
[    2.896005] generic-usb 0003:046D:C50A.0001: input,hidraw0: USB HID v1.1=
0 Mouse [Logitech USB Receiver] on usb-0000:00:1a.0-2/input0
[    2.953569] PM: Marking nosave pages: 0000000000001000 - 0000000000006000
[    2.953572] PM: Marking nosave pages: 000000000009f000 - 0000000000100000
[    2.953576] PM: Marking nosave pages: 00000000b5aa1000 - 00000000b5aa7000
[    2.953579] PM: Marking nosave pages: 00000000b5bba000 - 00000000b5c0f000
[    2.953582] PM: Marking nosave pages: 00000000b5d08000 - 00000000b5f0f000
[    2.953596] PM: Marking nosave pages: 00000000b5f18000 - 00000000b5f1f000
[    2.953598] PM: Marking nosave pages: 00000000b5f65000 - 00000000b5f9f000
[    2.953601] PM: Marking nosave pages: 00000000b5fe1000 - 00000000b5fff000
[    2.953604] PM: Marking nosave pages: 00000000b6000000 - 0000000100000000
[    2.955202] PM: Basic memory bitmaps created
[    2.971913] PM: Basic memory bitmaps freed
[    2.977495] PM: Starting manual resume from disk
[    2.977497] PM: Resume from partition 8:1
[    2.977498] PM: Checking hibernation image.
[    2.977717] PM: Resume from disk failed.
[    2.980590] usb 1-1.1: new high speed USB device using ehci_hcd and addr=
ess 4
[    3.097353] usb 1-1.1: New USB device found, idVendor=3D059b, idProduct=
=3D0370
[    3.102941] usb 1-1.1: New USB device strings: Mfr=3D2, Product=3D3, Ser=
ialNumber=3D1
[    3.108529] usb 1-1.1: Product: External HD
[    3.114077] usb 1-1.1: Manufacturer: Iomega
[    3.119592] usb 1-1.1: SerialNumber: 152000000733
[    3.125171] usb 1-1.1: configuration #1 chosen from 1 choice
[    3.132313] scsi6 : SCSI emulation for USB Mass Storage devices
[    3.138694] usb-storage: device found at 4
[    3.138697] usb-storage: waiting for device to settle before scanning
[    3.202253] usb 1-1.2: new high speed USB device using ehci_hcd and addr=
ess 5
[    3.294394] usb 1-1.2: New USB device found, idVendor=3D1058, idProduct=
=3D1001
[    3.299944] usb 1-1.2: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D3
[    3.305518] usb 1-1.2: Product: External HDD   =20
[    3.311087] usb 1-1.2: Manufacturer: Western Digital=20
[    3.316594] usb 1-1.2: SerialNumber: 574341505732323139323037
[    3.322115] usb 1-1.2: configuration #1 chosen from 1 choice
[    3.327728] scsi7 : SCSI emulation for USB Mass Storage devices
[    3.335092] usb-storage: device found at 5
[    3.335096] usb-storage: waiting for device to settle before scanning
[    3.398292] usb 1-1.4: new high speed USB device using ehci_hcd and addr=
ess 6
[    3.487417] kjournald starting.  Commit interval 15 seconds
[    3.493471] EXT3 FS on sda2, internal journal
[    3.499331] EXT3-fs: mounted filesystem with ordered data mode.
[    3.505811] usb 1-1.4: New USB device found, idVendor=3D05e3, idProduct=
=3D0606
[    3.511654] usb 1-1.4: New USB device strings: Mfr=3D0, Product=3D1, Ser=
ialNumber=3D0
[    3.517449] usb 1-1.4: Product: USB2.0 Hub
[    3.523241] usb 1-1.4: configuration #1 chosen from 1 choice
[    3.529365] hub 1-1.4:1.0: USB hub found
[    3.535316] hub 1-1.4:1.0: 4 ports detected
[    3.816260] usb 1-1.4.2: new high speed USB device using ehci_hcd and ad=
dress 7
[    3.901026] usb 1-1.4.2: New USB device found, idVendor=3D05e3, idProduc=
t=3D070e
[    3.906763] usb 1-1.4.2: New USB device strings: Mfr=3D0, Product=3D1, S=
erialNumber=3D2
[    3.912396] usb 1-1.4.2: Product: USB Storage
[    3.917839] usb 1-1.4.2: SerialNumber: 000000009601
[    3.923251] usb 1-1.4.2: configuration #1 chosen from 1 choice
[    3.929113] scsi8 : SCSI emulation for USB Mass Storage devices
[    3.934363] usb-storage: device found at 7
[    3.934365] usb-storage: waiting for device to settle before scanning
[    4.007301] usb 1-1.4.3: new high speed USB device using ehci_hcd and ad=
dress 8
[    4.097941] usb 1-1.4.3: New USB device found, idVendor=3D03f0, idProduc=
t=3D5611
[    4.103090] usb 1-1.4.3: New USB device strings: Mfr=3D1, Product=3D2, S=
erialNumber=3D3
[    4.108171] usb 1-1.4.3: Product: Photosmart C3100 series
[    4.113203] usb 1-1.4.3: Manufacturer: HP
[    4.118112] usb 1-1.4.3: SerialNumber: MY68SC52KM04P9
[    4.123092] usb 1-1.4.3: configuration #1 chosen from 1 choice
[    4.128279] scsi9 : SCSI emulation for USB Mass Storage devices
[    4.133019] usb-storage: device found at 8
[    4.133021] usb-storage: waiting for device to settle before scanning
[    4.141850] scsi 6:0:0:0: Direct-Access     ST336032 0AS                =
   PQ: 0 ANSI: 2
[    4.147459] sd 6:0:0:0: [sdb] 703282608 512-byte logical blocks: (360 GB=
/335 GiB)
[    4.147606] usb-storage: device scan complete
[    4.154458] sd 6:0:0:0: [sdb] Write Protect is off
[    4.159090] sd 6:0:0:0: [sdb] Mode Sense: 38 00 00 00
[    4.159092] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[    4.166961] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[    4.171599]  sdb:
[    4.210344] usb 1-1.4.4: new high speed USB device using ehci_hcd and ad=
dress 9
[    4.334885] scsi 7:0:0:0: Direct-Access     WD       5000AAJ External 1.=
06 PQ: 0 ANSI: 0
[    4.340631] sd 7:0:0:0: [sdc] 976773168 512-byte logical blocks: (500 GB=
/465 GiB)
[    4.346255] sd 7:0:0:0: [sdc] Write Protect is off
[    4.350988] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
[    4.350990] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[    4.351343] usb-storage: device scan complete
[    4.357125] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[    4.361786]  sdc: sdc1
[    4.368379] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[    4.373105] usb 1-1.4.4: New USB device found, idVendor=3D0402, idProduc=
t=3D5621
[    4.377871] usb 1-1.4.4: New USB device strings: Mfr=3D0, Product=3D1, S=
erialNumber=3D2
[    4.379256] sd 7:0:0:0: [sdc] Attached SCSI disk
[    4.387184] usb 1-1.4.4: Product: USB 2.0 Storage Device
[    4.391683] usb 1-1.4.4: SerialNumber: 00042222200000014305
[    4.396198] usb 1-1.4.4: configuration #1 chosen from 1 choice
[    4.400831] scsi10 : SCSI emulation for USB Mass Storage devices
[    4.405308] usb-storage: device found at 9
[    4.405309] usb-storage: waiting for device to settle before scanning
[    4.935143] scsi 8:0:0:0: Direct-Access     Generic  STORAGE DEVICE   96=
01 PQ: 0 ANSI: 0
[    4.940640] scsi 8:0:0:1: Direct-Access     Generic  STORAGE DEVICE   96=
01 PQ: 0 ANSI: 0
[    4.947134] scsi 8:0:0:2: Direct-Access     Generic  STORAGE DEVICE   96=
01 PQ: 0 ANSI: 0
[    4.952002] sd 8:0:0:0: [sdd] Attached SCSI removable disk
[    4.956887] sd 8:0:0:1: [sde] Attached SCSI removable disk
[    4.962521] scsi 8:0:0:3: Direct-Access     Generic  STORAGE DEVICE   96=
01 PQ: 0 ANSI: 0
[    4.968607] sd 8:0:0:2: [sdf] Attached SCSI removable disk
[    4.973274] sd 8:0:0:3: [sdg] Attached SCSI removable disk
[    4.977676] usb-storage: device scan complete
[    5.132685] scsi 9:0:0:0: Direct-Access     HP       Photosmart C3180 1.=
00 PQ: 0 ANSI: 2
[    5.138803] usb-storage: device scan complete
[    5.138945] sd 9:0:0:0: [sdh] Attached SCSI removable disk
[    5.406120] scsi 10:0:0:0: CD-ROM            TSSTcorp CD/DVDW SH-W162C T=
S09 PQ: 0 ANSI: 0
[    5.410805] usb-storage: device scan complete
[    6.577369]  sdb1
[    6.585110] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[    6.589589] sd 6:0:0:0: [sdb] Attached SCSI disk
[    6.785886] udevd version 128 started
[    7.353224] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    7.357860] scsi 1:0:0:0: Attached scsi generic sg1 type 5
[    7.362542] sd 6:0:0:0: Attached scsi generic sg2 type 0
[    7.424051] sd 7:0:0:0: Attached scsi generic sg3 type 0
[    7.428613] sd 8:0:0:0: Attached scsi generic sg4 type 0
[    7.433196] sd 8:0:0:1: Attached scsi generic sg5 type 0
[    7.437644] sd 8:0:0:2: Attached scsi generic sg6 type 0
[    7.442086] sd 8:0:0:3: Attached scsi generic sg7 type 0
[    7.446366] sd 9:0:0:0: Attached scsi generic sg8 type 0
[    7.450695] scsi 10:0:0:0: Attached scsi generic sg9 type 5
[    7.489366] usblp0: USB Bidirectional printer dev 8 if 1 alt 0 proto 2 v=
id 0x03F0 pid 0x5611
[    7.493642] usbcore: registered new interface driver usblp
[    7.520873] input: PC Speaker as /devices/platform/pcspkr/input/input3
[    7.696713] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input4
[    7.701099] ACPI: Power Button [PWRF]
[    7.702073] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 =
cdda tray
[    7.702076] Uniform CD-ROM driver Revision: 3.20
[    7.702171] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    7.715315] iTCO_vendor_support: vendor-support=3D0
[    7.715439] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0=
C:00/input/input5
[    7.715511] ACPI: Power Button [PWRB]
[    7.715556] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:=
00/input/input6
[    7.715771] ACPI: Lid Switch [LID]
[    7.745502] sr1: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
[    7.750494] sr 10:0:0:0: Attached scsi CD-ROM sr1
[    7.765068] ACPI: WMI: Mapper loaded
[    7.773302] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 19 (level, low) ->=
 IRQ 19
[    7.778278] ACPI: I/O resource 0000:00:1f.3 [0x1c00-0x1c1f] conflicts wi=
th ACPI region SMBI [0x1c00-0x1c0f]
[    7.783444] ACPI: Device needs an ACPI driver
[    7.788456] i801_smbus: probe of 0000:00:1f.3 failed with error -16
[    7.798448] ACPI: AC Adapter [ACAD] (on-line)
[    7.878413] sky2 driver version 1.23
[    7.884402] sky2 0000:07:00.0: enabling device (0000 -> 0003)
[    7.889483] sky2 0000:07:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    7.894502] sky2 0000:07:00.0: setting latency timer to 64
[    7.894555] sky2 0000:07:00.0: unsupported chip type 0xff
[    7.899554] sky2 0000:07:00.0: PCI INT A disabled
[    7.904379] sky2: probe of 0000:07:00.0 failed with error -95
[    7.913789] ACPI: SSDT 00000000b5f1ac20 00265 (v01  PmRef  Cpu0Ist 00003=
000 INTL 20061109)
[    7.919838] ACPI: SSDT 00000000b5f18620 00594 (v01  PmRef  Cpu0Cst 00003=
001 INTL 20061109)
[    7.927350] ACPI Warning: Invalid throttling state, reset 20090521 proce=
ssor_throttling-843
[    7.935721] Monitor-Mwait will be used to enter C-1 state
[    7.937017] Monitor-Mwait will be used to enter C-2 state
[    7.939037] Monitor-Mwait will be used to enter C-3 state
[    7.939044] Marking TSC unstable due to TSC halts in idle
[    7.944211] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    7.950115] processor LNXCPU:00: registered as cooling_device0
[    7.955105] ACPI: Processor [CPU0] (supports 8 throttling states)
[    7.960757] ACPI: SSDT 00000000b5f19ca0 001CF (v01  PmRef    ApIst 00003=
000 INTL 20061109)
[    7.966558] ACPI: SSDT 00000000b5f19f20 0008D (v01  PmRef    ApCst 00003=
000 INTL 20061109)
[    7.972375] ACPI Warning: Invalid throttling state, reset 20090521 proce=
ssor_throttling-843
[    7.978824] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    7.983940] processor LNXCPU:01: registered as cooling_device1
[    7.988989] ACPI: Processor [CPU1] (supports 8 throttling states)
[    7.996325] cfg80211: Calling CRDA to update world regulatory domain
[    8.065169] thermal LNXTHERM:01: registered as thermal_zone0
[    8.070493] ACPI: Thermal Zone [THRM] (53 C)
[    8.078533] agpgart-intel 0000:00:00.0: Intel Mobile Intel=C2=AE GM45 Ex=
press Chipset
[    8.084850] agpgart-intel 0000:00:00.0: detected 131068K stolen memory
[    8.092440] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    8.389786] Linux video capture interface: v2.00
[    8.399668] cfg80211: World regulatory domain updated:
[    8.404999] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max=
_eirp)
[    8.410299] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    8.413705] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[    8.420786] iTCO_wdt: Found a ICH9M TCO device (Version=3D2, TCOBASE=3D0=
x0460)
[    8.426635] iTCO_wdt: initialized. heartbeat=3D30 sec (nowayout=3D0)
[    8.500035] Clocksource tsc unstable (delta =3D -274372625 ns)
[    8.524317] ACPI: Battery Slot [BAT1] (battery present)
[    8.566601] sdhci: Secure Digital Host Controller Interface driver
[    8.571769] sdhci: Copyright(c) Pierre Ossman
[    8.599024] ohci1394 0000:0a:01.0: PCI INT A -> GSI 16 (level, low) -> I=
RQ 16
[    8.634749] uvcvideo: Found UVC 1.00 device Chicony USB 2.0 Camera (04f2=
:b008)
[    8.644560] input: Chicony USB 2.0 Camera as /devices/pci0000:00/0000:00=
:1d.7/usb2/2-4/2-4:1.0/input/input7
[    8.650067] usbcore: registered new interface driver uvcvideo
[    8.655220] USB Video Class driver (v0.1.0)
[    8.661457] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=3D[16]  MMIO=3D=
[ff501000-ff5017ff]  Max Packet=3D[2048]  IR/IT contexts=3D[8/8]
[    8.674920] sdhci-pci 0000:0a:01.2: SDHCI controller found [1217:7120] (=
rev 2)
[    8.680754] sdhci-pci 0000:0a:01.2: PCI INT A -> GSI 16 (level, low) -> =
IRQ 16
[    8.686465] mmc0: Unknown controller version (2). You may experience pro=
blems.
[    8.692107] Registered led device: mmc0::
[    8.697860] mmc0: SDHCI controller on PCI [0000:0a:01.2] using DMA
[    8.857709] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.=
3.27kds
[    8.863357] iwlagn: Copyright(c) 2003-2009 Intel Corporation
[    8.875763] iwlagn 0000:08:00.0: enabling device (0000 -> 0002)
[    8.881477] iwlagn 0000:08:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ=
 17
[    8.887083] iwlagn 0000:08:00.0: setting latency timer to 64
[    8.887128] iwlagn 0000:08:00.0: Detected Intel Wireless WiFi Link 5100A=
GN REV=3D0xFDFFFFFF
[    8.892723]   alloc irq_desc for 22 on node 0
[    8.892726]   alloc kstat_irqs on node 0
[    8.892733] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> =
IRQ 22
[    8.898342] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    9.013211] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sou=
nd/card0/input8
[    9.019021] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sou=
nd/card0/input9
[    9.024613] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b=
=2E0/sound/card0/input10
[    9.073995] iwlagn 0000:08:00.0: Failed, HW not ready
[    9.080292] iwlagn 0000:08:00.0: PCI INT A disabled
[    9.103364] phy0: Selected rate control algorithm 'minstrel'
[    9.103868] Registered led device: rt73usb-phy0::radio
[    9.109388] Registered led device: rt73usb-phy0::assoc
[    9.115034] Registered led device: rt73usb-phy0::quality
[    9.120942] usbcore: registered new interface driver rt73usb
[    9.128912] wlan0 renamed to wlan1 by udevd [1754]
[    9.134740] udev: renamed network interface wlan0 to wlan1
[    9.932990] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[001b240001542c=
7b]
[   10.022653] Adding 4200956k swap on /dev/sda1.  Priority:-1 extents:1 ac=
ross:4200956k=20
[   11.147966] device-mapper: uevent: version 1.0.3
[   11.153623] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised:=
 dm-devel@redhat.com
[   11.558144] loop: module loaded
[   11.786914] fuse init (API version 7.12)
[   14.837032] type=3D1505 audit(1249683327.805:2): operation=3D"profile_lo=
ad" pid=3D2108 name=3D/bin/ping
[   14.860303] type=3D1505 audit(1249683327.829:3): operation=3D"profile_lo=
ad" pid=3D2109 name=3D/sbin/klogd
[   15.589761] type=3D1505 audit(1249683328.558:4): operation=3D"profile_lo=
ad" pid=3D2110 name=3D/sbin/syslog-ng
[   15.655031] type=3D1505 audit(1249683328.623:5): operation=3D"profile_lo=
ad" pid=3D2111 name=3D/sbin/syslogd
[   15.699478] type=3D1505 audit(1249683328.667:6): operation=3D"profile_lo=
ad" pid=3D2112 name=3D/usr/sbin/avahi-daemon
[   15.739613] type=3D1505 audit(1249683328.708:7): operation=3D"profile_lo=
ad" pid=3D2113 name=3D/usr/sbin/identd
[   15.781706] type=3D1505 audit(1249683328.749:8): operation=3D"profile_lo=
ad" pid=3D2114 name=3D/usr/sbin/mdnsd
[   15.836617] type=3D1505 audit(1249683328.805:9): operation=3D"profile_lo=
ad" pid=3D2119 name=3D/usr/sbin/nscd
[   15.899576] type=3D1505 audit(1249683328.867:10): operation=3D"profile_l=
oad" pid=3D2146 name=3D/usr/sbin/ntpd
[   15.954324] type=3D1505 audit(1249683328.923:11): operation=3D"profile_l=
oad" pid=3D2153 name=3D/usr/sbin/traceroute
[   32.914365] [drm] Initialized drm 1.1.0 20060810
[   32.960780] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   32.960785] pci 0000:00:02.0: setting latency timer to 64
[   32.975764]   alloc irq_desc for 28 on node 0
[   32.975768]   alloc kstat_irqs on node 0
[   32.975778] pci 0000:00:02.0: irq 28 for MSI/MSI-X
[   33.039449] acpi device:05: registered as cooling_device2
[   33.040015] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:0=
0/device:01/input/input11
[   33.040140] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: n=
o)
[   33.040220] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on mi=
nor 0
[   33.417008] CE: hpet increasing min_delta_ns to 15000 nsec
[   36.846635] Bluetooth: Core ver 2.15
[   36.847428] NET: Registered protocol family 31
[   36.847431] Bluetooth: HCI device and connection manager initialized
[   36.847434] Bluetooth: HCI socket layer initialized
[   37.267318] Bluetooth: L2CAP ver 2.13
[   37.267320] Bluetooth: L2CAP socket layer initialized
[   37.385433] Bluetooth: RFCOMM TTY layer initialized
[   37.385437] Bluetooth: RFCOMM socket layer initialized
[   37.385439] Bluetooth: RFCOMM ver 1.11
[   38.306519] Bluetooth: SCO (Voice Link) ver 0.6
[   38.306527] Bluetooth: SCO socket layer initialized
[   39.205272] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   39.205275] Bluetooth: BNEP filters: protocol multicast
[   39.528399] Bridge firewalling registered
[   46.515904] rt73usb 2-1:1.0: firmware: requesting rt73.bin
[   47.368717] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[   47.451725] NET: Registered protocol family 17
[   48.201554] bootsplash: status on console 0 changed to on
[   55.246915] [drm:gm45_get_vblank_counter] *ERROR* trying to get vblank c=
ount for disabled pipe 0
[  151.582393] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  155.806904] kjournald starting.  Commit interval 15 seconds
[  155.806926] EXT3-fs warning: maximal mount count reached, running e2fsck=
 is recommended
[  155.808190] EXT3 FS on sdc1, internal journal
[  155.808197] EXT3-fs: mounted filesystem with ordered data mode.
[  155.947629] kjournald starting.  Commit interval 15 seconds
[  155.948751] EXT3 FS on sdb1, internal journal
[  155.948766] EXT3-fs: mounted filesystem with ordered data mode.
[  201.168353] usb 2-1: USB disconnect, address 2
[  201.168746] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x0=
7 failed for offset 0x3040 with error -19.
[  201.168756] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x0=
6 failed for offset 0x3040 with error -19.
[  201.168766] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x0=
6 failed for offset 0x3028 with error -19.
[  201.168775] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x0=
6 failed for offset 0x3064 with error -19.
[  201.168785] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x0=
c failed for offset 0x0000 with error -19.
[  201.168802] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x0=
a failed for offset 0x0000 with error -19.
[  201.168963] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x0=
a failed for offset 0x0000 with error -19.
[  201.169026] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x0=
a failed for offset 0x0000 with error -19.
[  201.169093] phy0 -> rt2x00usb_vendor_request: Error - Vendor Request 0x0=
a failed for offset 0x0000 with error -19.
[  208.217129] usb 2-1: new high speed USB device using ehci_hcd and addres=
s 4
[  208.473618] usb 2-1: New USB device found, idVendor=3D07d1, idProduct=3D=
3c03
[  208.473628] usb 2-1: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0
[  208.473635] usb 2-1: Product: 802.11 bg WLAN
[  208.473640] usb 2-1: Manufacturer: Ralink
[  208.473901] usb 2-1: configuration #1 chosen from 1 choice
[  208.738971] phy2: Selected rate control algorithm 'minstrel'
[  208.740773] Registered led device: rt73usb-phy2::radio
[  208.740822] Registered led device: rt73usb-phy2::assoc
[  208.740860] Registered led device: rt73usb-phy2::quality
[  208.744327] wlan0 renamed to wlan1 by udevd [4796]
[  208.746238] udev: renamed network interface wlan0 to wlan1
[  212.836842] rt73usb 2-1:1.0: firmware: requesting rt73.bin
[  212.932183] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  270.352692] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  272.366404] wlan1: authenticate with AP 00:16:01:ad:e4:c0
[  272.367987] wlan1: authenticated
[  272.367995] wlan1: associate with AP 00:16:01:ad:e4:c0
[  272.370404] wlan1: RX AssocResp from 00:16:01:ad:e4:c0 (capab=3D0x431 st=
atus=3D0 aid=3D1)
[  272.370412] wlan1: associated
[  272.390721] ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
[  282.696064] wlan1: no IPv6 routers present

--Boundary-00=_0uKfKtLmspeTEsj--
