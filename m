Return-Path: <linux-kernel-owner+w=401wt.eu-S932107AbZLNCbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107AbZLNCbG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 21:31:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbZLNCbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 21:31:04 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:2882 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbZLNCa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 21:30:59 -0500
Date: Sun, 13 Dec 2009 19:30:51 -0700
From: Alex Chiang <achiang@hp.com>
To: airlied@redhat.com, rjw@sisk.pl
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: radeon 4830 corruption after resume
Message-ID: <20091214023051.GA29591@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Dave, Rafael,

I can successfully suspend/resume my HP Envy, but upon resume,
the screen is corrupted.

I used the gnome screenshot utility to capture this:

	http://chizang.net/alex/tmp/radeon-4830-corruption.png

But that screenshot leads you to believe the corruption was
100%, when in reality, the text in my xterms was at least
readable, but ugly.

Kernel is latest upstream pulled today. Userspace is Ubuntu Karmic.

Some info inline; xorg.log and pm-suspend.log attached.

Thanks,
/ac


dmesg snip:
 [   20.984196] [drm] Initialized drm 1.1.0 20060810
 [   21.470507] [drm] radeon defaulting to userspace modesetting.
 [   21.471372] [drm] Initialized radeon 1.31.0 20080528 for 0000:01:00.0 on minor 0
 [   22.689868] [drm] Setting GART location based on new memory map
 [   22.690118] [drm] Loading RV730 CP Microcode
 [   22.690121] platform r600_cp.0: firmware: requesting radeon/RV730_pfp.bin
 [   22.721163] platform r600_cp.0: firmware: requesting radeon/RV730_me.bin
 [   22.760768] [drm] Resetting GPU
 [   22.760827] [drm] writeback test succeeded in 2 usecs


achiang@dre:~$ sudo lspci -vv -s 01:00.0
[sudo] password for achiang: 
01:00.0 VGA compatible controller: ATI Technologies Inc Mobility Radeon HD 4830 [M97]
	Subsystem: Hewlett-Packard Company Device 7009
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at c0000000 (32-bit, prefetchable) [size=256M]
	Region 1: I/O ports at 4000 [size=256]
	Region 2: Memory at d4000000 (32-bit, non-prefetchable) [size=64K]
	Expansion ROM at d4020000 [disabled] [size=128K]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0 <64ns, L1 <1us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [100] Vendor Specific Information <?>


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="Xorg.0.log"
Content-Transfer-Encoding: 8bit


X.Org X Server 1.6.4
Release Date: 2009-9-27
X Protocol Version 11, Revision 0
Build Operating System: Linux 2.6.24-23-server x86_64 Ubuntu
Current Operating System: Linux dre 2.6.32 #4 SMP Sun Dec 13 11:27:41 MST 2009 x86_64
Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.32 root=UUID=002d7dd4-cbb2-44be-aaad-25190d2057e1 ro ignore_loglvl
Build Date: 26 October 2009  05:19:56PM
xorg-server 2:1.6.4-2ubuntu4 (buildd@) 
	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
Markers: (--) probed, (**) from config file, (==) default setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
(==) Log file: "/var/log/Xorg.0.log", Time: Sun Dec 13 19:10:11 2009
(II) Loader magic: 0xb40
(II) Module ABI versions:
	X.Org ANSI C Emulation: 0.4
	X.Org Video Driver: 5.0
	X.Org XInput driver : 4.0
	X.Org Server Extension : 2.0
(II) Loader running on linux
(++) using VT number 7

(--) PCI:*(0:1:0:0) 1002:94a0:103c:7009 ATI Technologies Inc Mobility Radeon HD 4830 [M97] rev 0, Mem @ 0xc0000000/268435456, 0xd4000000/65536, I/O @ 0x00004000/256, BIOS @ 0x????????/131072
(==) Using default built-in configuration (30 lines)
(==) --- Start of built-in configuration ---
	Section "Device"
		Identifier	"Builtin Default ati Device 0"
		Driver	"ati"
	EndSection
	Section "Screen"
		Identifier	"Builtin Default ati Screen 0"
		Device	"Builtin Default ati Device 0"
	EndSection
	Section "Device"
		Identifier	"Builtin Default vesa Device 0"
		Driver	"vesa"
	EndSection
	Section "Screen"
		Identifier	"Builtin Default vesa Screen 0"
		Device	"Builtin Default vesa Device 0"
	EndSection
	Section "Device"
		Identifier	"Builtin Default fbdev Device 0"
		Driver	"fbdev"
	EndSection
	Section "Screen"
		Identifier	"Builtin Default fbdev Screen 0"
		Device	"Builtin Default fbdev Device 0"
	EndSection
	Section "ServerLayout"
		Identifier	"Builtin Default Layout"
		Screen	"Builtin Default ati Screen 0"
		Screen	"Builtin Default vesa Screen 0"
		Screen	"Builtin Default fbdev Screen 0"
	EndSection
(==) --- End of built-in configuration ---
(==) ServerLayout "Builtin Default Layout"
(**) |-->Screen "Builtin Default ati Screen 0" (0)
(**) |   |-->Monitor "<default monitor>"
(**) |   |-->Device "Builtin Default ati Device 0"
(==) No monitor specified for screen "Builtin Default ati Screen 0".
	Using a default monitor configuration.
(**) |-->Screen "Builtin Default vesa Screen 0" (1)
(**) |   |-->Monitor "<default monitor>"
(**) |   |-->Device "Builtin Default vesa Device 0"
(==) No monitor specified for screen "Builtin Default vesa Screen 0".
	Using a default monitor configuration.
(**) |-->Screen "Builtin Default fbdev Screen 0" (2)
(**) |   |-->Monitor "<default monitor>"
(**) |   |-->Device "Builtin Default fbdev Device 0"
(==) No monitor specified for screen "Builtin Default fbdev Screen 0".
	Using a default monitor configuration.
(==) Automatically adding devices
(==) Automatically enabling devices
(WW) The directory "/usr/share/fonts/X11/cyrillic" does not exist.
	Entry deleted from font path.
(==) FontPath set to:
	/usr/share/fonts/X11/misc,
	/usr/share/fonts/X11/100dpi/:unscaled,
	/usr/share/fonts/X11/75dpi/:unscaled,
	/usr/share/fonts/X11/Type1,
	/usr/share/fonts/X11/100dpi,
	/usr/share/fonts/X11/75dpi,
	/var/lib/defoma/x-ttcidfont-conf.d/dirs/TrueType,
	built-ins
(==) ModulePath set to "/usr/lib/xorg/modules"
(II) Cannot locate a core pointer device.
(II) Cannot locate a core keyboard device.
(II) The server relies on HAL to provide the list of input devices.
	If no devices become available, reconfigure HAL or disable AllowEmptyInput.
(II) Open ACPI successful (/var/run/acpid.socket)
(II) System resource ranges:
	[0] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[1] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[2] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[3] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[4] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[5] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[6] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[7] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[8] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[9] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[10] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[11] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[12] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[13] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[14] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[15] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[16] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[17] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[18] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[19] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[20] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[21] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[22] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[23] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[24] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[25] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[26] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[27] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[28] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[29] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[30] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[31] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[32] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[33] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[34] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[35] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[36] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[37] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[38] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[39] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[40] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[41] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[42] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[43] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[44] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[45] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[46] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[47] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[48] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[49] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[50] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[51] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[52] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[53] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[54] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[55] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[56] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[57] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[58] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[59] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[60] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[61] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[62] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[63] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[64] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[65] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[66] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[67] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[68] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[69] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[70] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[71] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[72] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[73] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[74] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[75] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[76] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[77] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[78] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[79] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[80] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[81] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[82] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[83] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[84] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[85] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[86] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[87] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[88] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[89] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[90] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[91] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[92] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[93] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[94] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[95] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
(II) LoadModule: "extmod"
(II) Loading /usr/lib/xorg/modules/extensions//libextmod.so
(II) Module extmod: vendor="X.Org Foundation"
	compiled for 1.6.4, module version = 1.0.0
	Module class: X.Org Server Extension
	ABI class: X.Org Server Extension, version 2.0
(II) Loading extension MIT-SCREEN-SAVER
(II) Loading extension XFree86-VidModeExtension
(II) Loading extension XFree86-DGA
(II) Loading extension DPMS
(II) Loading extension XVideo
(II) Loading extension XVideo-MotionCompensation
(II) Loading extension X-Resource
(II) LoadModule: "dbe"
(II) Loading /usr/lib/xorg/modules/extensions//libdbe.so
(II) Module dbe: vendor="X.Org Foundation"
	compiled for 1.6.4, module version = 1.0.0
	Module class: X.Org Server Extension
	ABI class: X.Org Server Extension, version 2.0
(II) Loading extension DOUBLE-BUFFER
(II) LoadModule: "glx"
(II) Loading /usr/lib/xorg/modules/extensions//libglx.so
(II) Module glx: vendor="X.Org Foundation"
	compiled for 1.6.4, module version = 1.0.0
	ABI class: X.Org Server Extension, version 2.0
(==) AIGLX enabled
(II) Loading extension GLX
(II) LoadModule: "record"
(II) Loading /usr/lib/xorg/modules/extensions//librecord.so
(II) Module record: vendor="X.Org Foundation"
	compiled for 1.6.4, module version = 1.13.0
	Module class: X.Org Server Extension
	ABI class: X.Org Server Extension, version 2.0
(II) Loading extension RECORD
(II) LoadModule: "dri"
(II) Loading /usr/lib/xorg/modules/extensions//libdri.so
(II) Module dri: vendor="X.Org Foundation"
	compiled for 1.6.4, module version = 1.0.0
	ABI class: X.Org Server Extension, version 2.0
(II) Loading extension XFree86-DRI
(II) LoadModule: "dri2"
(II) Loading /usr/lib/xorg/modules/extensions//libdri2.so
(II) Module dri2: vendor="X.Org Foundation"
	compiled for 1.6.4, module version = 1.1.0
	ABI class: X.Org Server Extension, version 2.0
(II) Loading extension DRI2
(II) LoadModule: "ati"
(II) Loading /usr/lib/xorg/modules/drivers//ati_drv.so
(II) Module ati: vendor="X.Org Foundation"
	compiled for 1.6.4, module version = 6.12.99
	Module class: X.Org Video Driver
	ABI class: X.Org Video Driver, version 5.0
(II) LoadModule: "radeon"
(II) Loading /usr/lib/xorg/modules/drivers//radeon_drv.so
(II) Module radeon: vendor="X.Org Foundation"
	compiled for 1.6.4, module version = 6.12.99
	Module class: X.Org Video Driver
	ABI class: X.Org Video Driver, version 5.0
(II) LoadModule: "vesa"
(II) Loading /usr/lib/xorg/modules/drivers//vesa_drv.so
(II) Module vesa: vendor="X.Org Foundation"
	compiled for 1.6.3, module version = 2.2.1
	Module class: X.Org Video Driver
	ABI class: X.Org Video Driver, version 5.0
(II) LoadModule: "fbdev"
(II) Loading /usr/lib/xorg/modules/drivers//fbdev_drv.so
(II) Module fbdev: vendor="X.Org Foundation"
	compiled for 1.6.0, module version = 0.4.0
	ABI class: X.Org Video Driver, version 5.0
(II) RADEON: Driver for ATI Radeon chipsets:
	ATI Radeon Mobility X600 (M24) 3150 (PCIE), ATI FireMV 2400 (PCI),
	ATI Radeon Mobility X300 (M24) 3152 (PCIE),
	ATI FireGL M24 GL 3154 (PCIE), ATI Radeon X600 (RV380) 3E50 (PCIE),
	ATI FireGL V3200 (RV380) 3E54 (PCIE), ATI Radeon IGP320 (A3) 4136,
	ATI Radeon IGP330/340/350 (A4) 4137, ATI Radeon 9500 AD (AGP),
	ATI Radeon 9500 AE (AGP), ATI Radeon 9600TX AF (AGP),
	ATI FireGL Z1 AG (AGP), ATI Radeon 9800SE AH (AGP),
	ATI Radeon 9800 AI (AGP), ATI Radeon 9800 AJ (AGP),
	ATI FireGL X2 AK (AGP), ATI Radeon 9600 AP (AGP),
	ATI Radeon 9600SE AQ (AGP), ATI Radeon 9600XT AR (AGP),
	ATI Radeon 9600 AS (AGP), ATI FireGL T2 AT (AGP), ATI Radeon 9650,
	ATI FireGL RV360 AV (AGP), ATI Radeon 7000 IGP (A4+) 4237,
	ATI Radeon 8500 AIW BB (AGP), ATI Radeon 8500 AIW BC (AGP),
	ATI Radeon IGP320M (U1) 4336, ATI Radeon IGP330M/340M/350M (U2) 4337,
	ATI Radeon Mobility 7000 IGP 4437, ATI Radeon 9000/PRO If (AGP/PCI),
	ATI Radeon 9000 Ig (AGP/PCI), ATI Radeon X800 (R420) JH (AGP),
	ATI Radeon X800PRO (R420) JI (AGP),
	ATI Radeon X800SE (R420) JJ (AGP), ATI Radeon X800 (R420) JK (AGP),
	ATI Radeon X800 (R420) JL (AGP), ATI FireGL X3 (R420) JM (AGP),
	ATI Radeon Mobility 9800 (M18) JN (AGP),
	ATI Radeon X800 SE (R420) (AGP), ATI Radeon X800XT (R420) JP (AGP),
	ATI Radeon X800 VE (R420) JT (AGP), ATI Radeon X850 (R480) (AGP),
	ATI Radeon X850 XT (R480) (AGP), ATI Radeon X850 SE (R480) (AGP),
	ATI Radeon X850 PRO (R480) (AGP), ATI Radeon X850 XT PE (R480) (AGP),
	ATI Radeon Mobility M7 LW (AGP),
	ATI Mobility FireGL 7800 M7 LX (AGP),
	ATI Radeon Mobility M6 LY (AGP), ATI Radeon Mobility M6 LZ (AGP),
	ATI FireGL Mobility 9000 (M9) Ld (AGP),
	ATI Radeon Mobility 9000 (M9) Lf (AGP),
	ATI Radeon Mobility 9000 (M9) Lg (AGP), ATI Radeon 9700 Pro ND (AGP),
	ATI Radeon 9700/9500Pro NE (AGP), ATI Radeon 9600TX NF (AGP),
	ATI FireGL X1 NG (AGP), ATI Radeon 9800PRO NH (AGP),
	ATI Radeon 9800 NI (AGP), ATI FireGL X2 NK (AGP),
	ATI Radeon 9800XT NJ (AGP),
	ATI Radeon Mobility 9600/9700 (M10/M11) NP (AGP),
	ATI Radeon Mobility 9600 (M10) NQ (AGP),
	ATI Radeon Mobility 9600 (M11) NR (AGP),
	ATI Radeon Mobility 9600 (M10) NS (AGP),
	ATI FireGL Mobility T2 (M10) NT (AGP),
	ATI FireGL Mobility T2e (M11) NV (AGP), ATI Radeon QD (AGP),
	ATI Radeon QE (AGP), ATI Radeon QF (AGP), ATI Radeon QG (AGP),
	ATI FireGL 8700/8800 QH (AGP), ATI Radeon 8500 QL (AGP),
	ATI Radeon 9100 QM (AGP), ATI Radeon 7500 QW (AGP/PCI),
	ATI Radeon 7500 QX (AGP/PCI), ATI Radeon VE/7000 QY (AGP/PCI),
	ATI Radeon VE/7000 QZ (AGP/PCI), ATI ES1000 515E (PCI),
	ATI Radeon Mobility X300 (M22) 5460 (PCIE),
	ATI Radeon Mobility X600 SE (M24C) 5462 (PCIE),
	ATI FireGL M22 GL 5464 (PCIE), ATI Radeon X800 (R423) UH (PCIE),
	ATI Radeon X800PRO (R423) UI (PCIE),
	ATI Radeon X800LE (R423) UJ (PCIE),
	ATI Radeon X800SE (R423) UK (PCIE),
	ATI Radeon X800 XTP (R430) (PCIE), ATI Radeon X800 XL (R430) (PCIE),
	ATI Radeon X800 SE (R430) (PCIE), ATI Radeon X800 (R430) (PCIE),
	ATI FireGL V7100 (R423) (PCIE), ATI FireGL V5100 (R423) UQ (PCIE),
	ATI FireGL unknown (R423) UR (PCIE),
	ATI FireGL unknown (R423) UT (PCIE),
	ATI Mobility FireGL V5000 (M26) (PCIE),
	ATI Mobility FireGL V5000 (M26) (PCIE),
	ATI Mobility Radeon X700 XL (M26) (PCIE),
	ATI Mobility Radeon X700 (M26) (PCIE),
	ATI Mobility Radeon X700 (M26) (PCIE),
	ATI Radeon X550XTX 5657 (PCIE), ATI Radeon 9100 IGP (A5) 5834,
	ATI Radeon Mobility 9100 IGP (U3) 5835,
	ATI Radeon XPRESS 200 5954 (PCIE),
	ATI Radeon XPRESS 200M 5955 (PCIE), ATI Radeon 9250 5960 (AGP),
	ATI Radeon 9200 5961 (AGP), ATI Radeon 9200 5962 (AGP),
	ATI Radeon 9200SE 5964 (AGP), ATI FireMV 2200 (PCI),
	ATI ES1000 5969 (PCI), ATI Radeon XPRESS 200 5974 (PCIE),
	ATI Radeon XPRESS 200M 5975 (PCIE),
	ATI Radeon XPRESS 200 5A41 (PCIE),
	ATI Radeon XPRESS 200M 5A42 (PCIE),
	ATI Radeon XPRESS 200 5A61 (PCIE),
	ATI Radeon XPRESS 200M 5A62 (PCIE),
	ATI Radeon X300 (RV370) 5B60 (PCIE),
	ATI Radeon X600 (RV370) 5B62 (PCIE),
	ATI Radeon X550 (RV370) 5B63 (PCIE),
	ATI FireGL V3100 (RV370) 5B64 (PCIE),
	ATI FireMV 2200 PCIE (RV370) 5B65 (PCIE),
	ATI Radeon Mobility 9200 (M9+) 5C61 (AGP),
	ATI Radeon Mobility 9200 (M9+) 5C63 (AGP),
	ATI Mobility Radeon X800 XT (M28) (PCIE),
	ATI Mobility FireGL V5100 (M28) (PCIE),
	ATI Mobility Radeon X800 (M28) (PCIE), ATI Radeon X850 5D4C (PCIE),
	ATI Radeon X850 XT PE (R480) (PCIE),
	ATI Radeon X850 SE (R480) (PCIE), ATI Radeon X850 PRO (R480) (PCIE),
	ATI unknown Radeon / FireGL (R480) 5D50 (PCIE),
	ATI Radeon X850 XT (R480) (PCIE),
	ATI Radeon X800XT (R423) 5D57 (PCIE),
	ATI FireGL V5000 (RV410) (PCIE), ATI Radeon X700 XT (RV410) (PCIE),
	ATI Radeon X700 PRO (RV410) (PCIE),
	ATI Radeon X700 SE (RV410) (PCIE), ATI Radeon X700 (RV410) (PCIE),
	ATI Radeon X700 SE (RV410) (PCIE), ATI Radeon X1800,
	ATI Mobility Radeon X1800 XT, ATI Mobility Radeon X1800,
	ATI Mobility FireGL V7200, ATI FireGL V7200, ATI FireGL V5300,
	ATI Mobility FireGL V7100, ATI Radeon X1800, ATI Radeon X1800,
	ATI Radeon X1800, ATI Radeon X1800, ATI Radeon X1800,
	ATI FireGL V7300, ATI FireGL V7350, ATI Radeon X1600, ATI RV505,
	ATI Radeon X1300/X1550, ATI Radeon X1550, ATI M54-GL,
	ATI Mobility Radeon X1400, ATI Radeon X1300/X1550,
	ATI Radeon X1550 64-bit, ATI Mobility Radeon X1300,
	ATI Mobility Radeon X1300, ATI Mobility Radeon X1300,
	ATI Mobility Radeon X1300, ATI Radeon X1300, ATI Radeon X1300,
	ATI RV505, ATI RV505, ATI FireGL V3300, ATI FireGL V3350,
	ATI Radeon X1300, ATI Radeon X1550 64-bit, ATI Radeon X1300/X1550,
	ATI Radeon X1600, ATI Radeon X1300/X1550, ATI Mobility Radeon X1450,
	ATI Radeon X1300/X1550, ATI Mobility Radeon X2300,
	ATI Mobility Radeon X2300, ATI Mobility Radeon X1350,
	ATI Mobility Radeon X1350, ATI Mobility Radeon X1450,
	ATI Radeon X1300, ATI Radeon X1550, ATI Mobility Radeon X1350,
	ATI FireMV 2250, ATI Radeon X1550 64-bit, ATI Radeon X1600,
	ATI Radeon X1650, ATI Radeon X1600, ATI Radeon X1600,
	ATI Mobility FireGL V5200, ATI Mobility Radeon X1600,
	ATI Radeon X1650, ATI Radeon X1650, ATI Radeon X1600,
	ATI Radeon X1300 XT/X1600 Pro, ATI FireGL V3400,
	ATI Mobility FireGL V5250, ATI Mobility Radeon X1700,
	ATI Mobility Radeon X1700 XT, ATI FireGL V5200,
	ATI Mobility Radeon X1700, ATI Radeon X2300HD,
	ATI Mobility Radeon HD 2300, ATI Mobility Radeon HD 2300,
	ATI Radeon X1950, ATI Radeon X1900, ATI Radeon X1950,
	ATI Radeon X1900, ATI Radeon X1900, ATI Radeon X1900,
	ATI Radeon X1900, ATI Radeon X1900, ATI Radeon X1900,
	ATI Radeon X1900, ATI Radeon X1900, ATI Radeon X1900,
	ATI AMD Stream Processor, ATI Radeon X1900, ATI Radeon X1950,
	ATI RV560, ATI RV560, ATI Mobility Radeon X1900, ATI RV560,
	ATI Radeon X1950 GT, ATI RV570, ATI RV570, ATI FireGL V7400,
	ATI RV560, ATI Radeon X1650, ATI Radeon X1650, ATI RV560,
	ATI Radeon 9100 PRO IGP 7834, ATI Radeon Mobility 9200 IGP 7835,
	ATI Radeon X1200, ATI Radeon X1200, ATI Radeon X1200,
	ATI Radeon X1200, ATI Radeon X1200, ATI RS740, ATI RS740M, ATI RS740,
	ATI RS740M, ATI Radeon HD 2900 XT, ATI Radeon HD 2900 XT,
	ATI Radeon HD 2900 XT, ATI Radeon HD 2900 Pro, ATI Radeon HD 2900 GT,
	ATI FireGL V8650, ATI FireGL V8600, ATI FireGL V7600,
	ATI Radeon 4800 Series, ATI Radeon HD 4870 x2,
	ATI Radeon 4800 Series, ATI Radeon HD 4850 x2,
	ATI FirePro V8750 (FireGL), ATI FirePro V7760 (FireGL),
	ATI Mobility RADEON HD 4850, ATI Mobility RADEON HD 4850 X2,
	ATI Radeon 4800 Series, ATI FirePro RV770, AMD FireStream 9270,
	AMD FireStream 9250, ATI FirePro V8700 (FireGL),
	ATI Mobility RADEON HD 4870, ATI Mobility RADEON M98,
	ATI Radeon 4800 Series, ATI Radeon 4800 Series, ATI FirePro M7750,
	ATI M98, ATI M98, ATI M98, ATI Mobility Radeon HD 4650,
	ATI Radeon RV730 (AGP), ATI Mobility Radeon HD 4670,
	ATI FirePro M5750, ATI Radeon RV730 (AGP),
	ATI RV730XT [Radeon HD 4670], ATI RADEON E4600,
	ATI Radeon HD 4600 Series, ATI RV730 PRO [Radeon HD 4650],
	ATI FirePro V7750 (FireGL), ATI FirePro V5700 (FireGL),
	ATI FirePro V3750 (FireGL), ATI Mobility Radeon HD 4830,
	ATI Mobility Radeon HD 4850, ATI FirePro M7740, ATI RV740,
	ATI Radeon HD 4770, ATI Radeon HD 4700 Series, ATI Radeon HD 4770,
	ATI FirePro M5750, ATI RV610, ATI Radeon HD 2400 XT,
	ATI Radeon HD 2400 Pro, ATI Radeon HD 2400 PRO AGP, ATI FireGL V4000,
	ATI RV610, ATI Radeon HD 2350, ATI Mobility Radeon HD 2400 XT,
	ATI Mobility Radeon HD 2400, ATI RADEON E2400, ATI RV610,
	ATI FireMV 2260, ATI RV670, ATI Radeon HD3870,
	ATI Mobility Radeon HD 3850, ATI Radeon HD3850,
	ATI Mobility Radeon HD 3850 X2, ATI RV670,
	ATI Mobility Radeon HD 3870, ATI Mobility Radeon HD 3870 X2,
	ATI Radeon HD3870 X2, ATI FireGL V7700, ATI Radeon HD3850,
	ATI Radeon HD3690, AMD Firestream 9170, ATI Radeon HD 4550,
	ATI Radeon RV710, ATI Radeon RV710, ATI Radeon HD 4350,
	ATI Mobility Radeon 4300 Series, ATI Mobility Radeon 4500 Series,
	ATI Mobility Radeon 4500 Series, ATI FirePro RG220, ATI RV630,
	ATI Mobility Radeon HD 2600, ATI Mobility Radeon HD 2600 XT,
	ATI Radeon HD 2600 XT AGP, ATI Radeon HD 2600 Pro AGP,
	ATI Radeon HD 2600 XT, ATI Radeon HD 2600 Pro, ATI Gemini RV630,
	ATI Gemini Mobility Radeon HD 2600 XT, ATI FireGL V5600,
	ATI FireGL V3600, ATI Radeon HD 2600 LE,
	ATI Mobility FireGL Graphics Processor, ATI Radeon RV710,
	ATI Radeon HD 3470, ATI Mobility Radeon HD 3430,
	ATI Mobility Radeon HD 3400 Series, ATI Radeon HD 3450,
	ATI Radeon HD 3450, ATI Radeon HD 3430, ATI Radeon HD 3450,
	ATI FirePro V3700, ATI FireMV 2450, ATI FireMV 2260, ATI FireMV 2260,
	ATI Radeon HD 3600 Series, ATI Radeon HD 3650 AGP,
	ATI Radeon HD 3600 PRO, ATI Radeon HD 3600 XT,
	ATI Radeon HD 3600 PRO, ATI Mobility Radeon HD 3650,
	ATI Mobility Radeon HD 3670, ATI Mobility FireGL V5700,
	ATI Mobility FireGL V5725, ATI Radeon HD 3200 Graphics,
	ATI Radeon 3100 Graphics, ATI Radeon HD 3200 Graphics,
	ATI Radeon 3100 Graphics, ATI Radeon HD 3300 Graphics,
	ATI Radeon HD 3200 Graphics, ATI Radeon 3000 Graphics,
	ATI Radeon HD 4200, ATI Radeon 4100, ATI Mobility Radeon HD 4200,
	ATI Mobility Radeon 4100, ATI RS880
(II) VESA: driver for VESA chipsets: vesa
(II) FBDEV: driver for framebuffer: fbdev
(II) Primary Device is: PCI 01@00:00:0
(II) resource ranges after xf86ClaimFixedResources() call:
	[0] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[1] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[2] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[3] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[4] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[5] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[6] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[7] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[8] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[9] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[10] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[11] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[12] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[13] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[14] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[15] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[16] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[17] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[18] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[19] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[20] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[21] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[22] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[23] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[24] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[25] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[26] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[27] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[28] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[29] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[30] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[31] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[32] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[33] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[34] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[35] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[36] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[37] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[38] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[39] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[40] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[41] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[42] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[43] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[44] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[45] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[46] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[47] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[48] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[49] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[50] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[51] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[52] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[53] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[54] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[55] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[56] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[57] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[58] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[59] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[60] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[61] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[62] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[63] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[64] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[65] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[66] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[67] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[68] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[69] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[70] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[71] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[72] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[73] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[74] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[75] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[76] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[77] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[78] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[79] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[80] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[81] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[82] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[83] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[84] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[85] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[86] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[87] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[88] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[89] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[90] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[91] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[92] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[93] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[94] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[95] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
(II) [KMS] drm report modesetting isn't supported.
(WW) Falling back to old probe method for vesa
(WW) Falling back to old probe method for fbdev
(II) Loading sub module "fbdevhw"
(II) LoadModule: "fbdevhw"
(II) Loading /usr/lib/xorg/modules/linux//libfbdevhw.so
(II) Module fbdevhw: vendor="X.Org Foundation"
	compiled for 1.6.4, module version = 0.0.2
	ABI class: X.Org Video Driver, version 5.0
(EE) open /dev/fb0: No such file or directory
(II) resource ranges after probing:
	[0] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[1] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[2] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[3] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[4] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[5] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[6] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[7] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[8] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[9] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[10] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[11] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[12] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[13] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[14] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[15] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[16] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[17] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[18] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[19] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[20] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[21] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[22] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[23] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[24] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[25] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[26] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[27] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[28] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[29] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[30] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[31] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[32] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[33] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[34] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[35] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[36] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[37] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[38] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[39] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[40] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[41] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[42] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[43] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[44] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[45] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[46] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[47] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[48] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[49] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[50] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[51] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[52] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[53] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[54] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[55] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[56] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[57] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[58] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[59] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[60] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[61] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[62] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[63] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[64] 0	0	0x000a0000 - 0x000affff (0x10000) MS[B]
	[65] 0	0	0x000b0000 - 0x000b7fff (0x8000) MS[B]
	[66] 0	0	0x000b8000 - 0x000bffff (0x8000) MS[B]
	[67] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[68] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[69] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[70] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[71] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[72] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[73] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[74] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[75] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[76] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[77] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[78] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[79] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[80] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[81] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[82] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[83] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[84] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[85] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[86] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[87] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[88] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[89] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[90] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[91] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[92] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[93] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[94] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[95] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[96] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[97] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[98] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[99] 0	0	0x000003b0 - 0x000003bb (0xc) IS[B]
	[100] 0	0	0x000003c0 - 0x000003df (0x20) IS[B]
(II) Setting vga for screen 0.
(II) RADEON(0): Built from git commit 7968e1fb89f6b59d1654df48249bf4b81990c008
(II) RADEON(0): TOTO SAYS 00000000d4000000
(II) RADEON(0): MMIO registers at 0x00000000d4000000: size 64KB
(II) RADEON(0): PCI bus 1 card 0 func 0
(II) RADEON(0): Creating default Display subsection in Screen section
	"Builtin Default ati Screen 0" for depth/fbbpp 24/32
(==) RADEON(0): Depth 24, (--) framebuffer bpp 32
(II) RADEON(0): Pixel depth = 24 bits stored in 4 bytes (32 bpp pixmaps)
(==) RADEON(0): Default visual is TrueColor
(II) Loading sub module "vgahw"
(II) LoadModule: "vgahw"
(II) Loading /usr/lib/xorg/modules//libvgahw.so
(II) Module vgahw: vendor="X.Org Foundation"
	compiled for 1.6.4, module version = 0.1.0
	ABI class: X.Org Video Driver, version 5.0
(II) RADEON(0): vgaHWGetIOBase: hwp->IOBase is 0x03d0, hwp->PIOOffset is 0x0000
(==) RADEON(0): RGB weight 888
(II) RADEON(0): Using 8 bits per RGB (8 bit DAC)
(--) RADEON(0): Chipset: "ATI Mobility Radeon HD 4830" (ChipID = 0x94a0)
(--) RADEON(0): Linear framebuffer at 0x00000000c0000000
(II) RADEON(0): PCIE card detected
(II) Loading sub module "int10"
(II) LoadModule: "int10"
(II) Loading /usr/lib/xorg/modules//libint10.so
(II) Module int10: vendor="X.Org Foundation"
	compiled for 1.6.4, module version = 1.0.0
	ABI class: X.Org Video Driver, version 5.0
(II) RADEON(0): initializing int10
(II) RADEON(0): Primary V_BIOS segment is: 0xc000
(II) RADEON(0): ATOM BIOS detected
(II) RADEON(0): ATOM BIOS Rom: 
	SubsystemVendorID: 0x103c SubsystemID: 0x7009
	IOBaseAddress: 0x4000
	Filename: BR35289.003 
	BIOS Bootup Message: 
BR35289.003 M97 DDR3 128bit 400e/800m                                       

(II) RADEON(0): Framebuffer space used by Firmware (kb): 20
(II) RADEON(0): Start of VRAM area used by Firmware: 0xfffec
(II) RADEON(0): AtomBIOS requests 20kB of VRAM scratch space
(II) RADEON(0): AtomBIOS VRAM scratch base: 0xfffec
(II) RADEON(0): Cannot get VRAM scratch space. Allocating in main memory instead
(II) RADEON(0): Default Engine Clock: 400000
(II) RADEON(0): Default Memory Clock: 800000
(II) RADEON(0): Maximum Pixel ClockPLL Frequency Output: 1200000
(II) RADEON(0): Minimum Pixel ClockPLL Frequency Output: 0
(II) RADEON(0): Maximum Pixel ClockPLL Frequency Input: 16000
(II) RADEON(0): Minimum Pixel ClockPLL Frequency Input: 6000
(II) RADEON(0): Maximum Pixel Clock: 400000
(II) RADEON(0): Reference Clock: 27000
drmOpenDevice: node name is /dev/dri/card0
drmOpenByBusid: Searching for BusID pci:0000:01:00.0
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: open result is 10, (OK)
drmOpenByBusid: drmOpenMinor returns 10
drmOpenByBusid: drmGetBusid reports pci:0000:01:00.0
(II) RADEON(0): [dri] Found DRI library version 1.3.0 and kernel module version 1.31.0
(==) RADEON(0): Page Flipping disabled on r5xx and newer chips.

(II) RADEON(0): Will try to use DMA for Xv image transfers
(II) RADEON(0): Detected total video RAM=1048576K, accessible=262144K (PCI BAR=262144K)
(--) RADEON(0): Mapped VideoRAM: 262144 kByte (128 bit DDR SDRAM)
(II) RADEON(0): Color tiling disabled
(II) Loading sub module "ddc"
(II) LoadModule: "ddc"
(II) Module "ddc" already built-in
(II) Loading sub module "i2c"
(II) LoadModule: "i2c"
(II) Module "i2c" already built-in
(II) RADEON(0): ref_freq: 2700, min_out_pll: 64800, max_out_pll: 120000, min_in_pll: 600, max_in_pll: 1600, xclk: 40000, sclk: 400.000000, mclk: 800.000000
(II) RADEON(0): PLL parameters: rf=2700 rd=12 min=64800 max=120000; xclk=40000
(WW) RADEON(0): LVDS Info:
XRes: 1920, YRes: 1080, DotClock: 138500
HBlank: 160, HOverPlus: 48, HSyncWidth: 32
VBlank: 31, VOverPlus: 3, VSyncWidth: 5
(II) RADEON(0): Output LVDS has no monitor section
(II) RADEON(0): I2C bus "LVDS" initialized.
(II) RADEON(0): Output HDMI-0 has no monitor section
(II) RADEON(0): I2C bus "HDMI-0" initialized.
(II) RADEON(0): Port0:
  XRANDR name: LVDS
  Connector: LVDS
  LCD1: INTERNAL_UNIPHY2
  DDC reg: 0x7f68
(II) RADEON(0): Port1:
  XRANDR name: HDMI-0
  Connector: HDMI-A
  DFP1: INTERNAL_UNIPHY
  DDC reg: 0x7e40
(II) RADEON(0): I2C device "LVDS:E-EDID segment register" registered at address 0x60.
(II) RADEON(0): I2C device "LVDS:ddc2" registered at address 0xA0.
(II) RADEON(0): EDID vendor "LGD", prod id 507
(II) RADEON(0): Printing DDC gathered Modelines:
(II) RADEON(0): Modeline "1920x1080"x0.0  138.50  1920 1968 2000 2080  1080 1083 1088 1111 -hsync -vsync (66.6 kHz)
(II) RADEON(0): Output: LVDS, Detected Monitor Type: 2
(II) RADEON(0): EDID data from the display on output: LVDS ----------------------
(II) RADEON(0): Manufacturer: LGD  Model: 1fb  Serial#: 0
(II) RADEON(0): Year: 2009  Week: 0
(II) RADEON(0): EDID Version: 1.3
(II) RADEON(0): Digital Display Input
(II) RADEON(0): Max Image Size [cm]: horiz.: 35  vert.: 19
(II) RADEON(0): Gamma: 2.20
(II) RADEON(0): No DPMS capabilities specified
(II) RADEON(0): Supported color encodings: RGB 4:4:4 YCrCb 4:4:4 
(II) RADEON(0): First detailed timing is preferred mode
(II) RADEON(0): redX: 0.621 redY: 0.352   greenX: 0.314 greenY: 0.586
(II) RADEON(0): blueX: 0.147 blueY: 0.118   whiteX: 0.313 whiteY: 0.329
(II) RADEON(0): Manufacturer's mask: 0
(II) RADEON(0): Supported detailed timing:
(II) RADEON(0): clock: 138.5 MHz   Image Size:  345 x 194 mm
(II) RADEON(0): h_active: 1920  h_sync: 1968  h_sync_end 2000 h_blank_end 2080 h_border: 0
(II) RADEON(0): v_active: 1080  v_sync: 1083  v_sync_end 1088 v_blanking: 1111 v_border: 0
(II) RADEON(0):  LG Display
(II) RADEON(0):  LP156WF1-TLE1
(II) RADEON(0): EDID (in hex):
(II) RADEON(0): 	00ffffffffffff0030e4fb0100000000
(II) RADEON(0): 	00130103802313780a08d59f5a509625
(II) RADEON(0): 	1e505400000001010101010101010101
(II) RADEON(0): 	0101010101011a3680a070381f403020
(II) RADEON(0): 	350059c2100000190000000000000000
(II) RADEON(0): 	00000000000000000000000000fe004c
(II) RADEON(0): 	4720446973706c61790a2020000000fe
(II) RADEON(0): 	004c503135365746312d544c4531009c
finished output detect: 0
(II) RADEON(0): I2C device "HDMI-0:E-EDID segment register" registered at address 0x60.
(II) RADEON(0): I2C device "HDMI-0:ddc2" registered at address 0xA0.
(II) RADEON(0): Output: HDMI-0, Detected Monitor Type: 0
finished output detect: 1
finished all detect
before xf86InitialConfiguration
(II) RADEON(0): EDID for output LVDS
(II) RADEON(0): Manufacturer: LGD  Model: 1fb  Serial#: 0
(II) RADEON(0): Year: 2009  Week: 0
(II) RADEON(0): EDID Version: 1.3
(II) RADEON(0): Digital Display Input
(II) RADEON(0): Max Image Size [cm]: horiz.: 35  vert.: 19
(II) RADEON(0): Gamma: 2.20
(II) RADEON(0): No DPMS capabilities specified
(II) RADEON(0): Supported color encodings: RGB 4:4:4 YCrCb 4:4:4 
(II) RADEON(0): First detailed timing is preferred mode
(II) RADEON(0): redX: 0.621 redY: 0.352   greenX: 0.314 greenY: 0.586
(II) RADEON(0): blueX: 0.147 blueY: 0.118   whiteX: 0.313 whiteY: 0.329
(II) RADEON(0): Manufacturer's mask: 0
(II) RADEON(0): Supported detailed timing:
(II) RADEON(0): clock: 138.5 MHz   Image Size:  345 x 194 mm
(II) RADEON(0): h_active: 1920  h_sync: 1968  h_sync_end 2000 h_blank_end 2080 h_border: 0
(II) RADEON(0): v_active: 1080  v_sync: 1083  v_sync_end 1088 v_blanking: 1111 v_border: 0
(II) RADEON(0):  LG Display
(II) RADEON(0):  LP156WF1-TLE1
(II) RADEON(0): EDID (in hex):
(II) RADEON(0): 	00ffffffffffff0030e4fb0100000000
(II) RADEON(0): 	00130103802313780a08d59f5a509625
(II) RADEON(0): 	1e505400000001010101010101010101
(II) RADEON(0): 	0101010101011a3680a070381f403020
(II) RADEON(0): 	350059c2100000190000000000000000
(II) RADEON(0): 	00000000000000000000000000fe004c
(II) RADEON(0): 	4720446973706c61790a2020000000fe
(II) RADEON(0): 	004c503135365746312d544c4531009c
(II) RADEON(0): EDID vendor "LGD", prod id 507
(II) RADEON(0): Printing DDC gathered Modelines:
(II) RADEON(0): Modeline "1920x1080"x0.0  138.50  1920 1968 2000 2080  1080 1083 1088 1111 -hsync -vsync (66.6 kHz)
(II) RADEON(0): Output: LVDS, Detected Monitor Type: 2
(II) RADEON(0): EDID data from the display on output: LVDS ----------------------
(II) RADEON(0): Manufacturer: LGD  Model: 1fb  Serial#: 0
(II) RADEON(0): Year: 2009  Week: 0
(II) RADEON(0): EDID Version: 1.3
(II) RADEON(0): Digital Display Input
(II) RADEON(0): Max Image Size [cm]: horiz.: 35  vert.: 19
(II) RADEON(0): Gamma: 2.20
(II) RADEON(0): No DPMS capabilities specified
(II) RADEON(0): Supported color encodings: RGB 4:4:4 YCrCb 4:4:4 
(II) RADEON(0): First detailed timing is preferred mode
(II) RADEON(0): redX: 0.621 redY: 0.352   greenX: 0.314 greenY: 0.586
(II) RADEON(0): blueX: 0.147 blueY: 0.118   whiteX: 0.313 whiteY: 0.329
(II) RADEON(0): Manufacturer's mask: 0
(II) RADEON(0): Supported detailed timing:
(II) RADEON(0): clock: 138.5 MHz   Image Size:  345 x 194 mm
(II) RADEON(0): h_active: 1920  h_sync: 1968  h_sync_end 2000 h_blank_end 2080 h_border: 0
(II) RADEON(0): v_active: 1080  v_sync: 1083  v_sync_end 1088 v_blanking: 1111 v_border: 0
(II) RADEON(0):  LG Display
(II) RADEON(0):  LP156WF1-TLE1
(II) RADEON(0): EDID (in hex):
(II) RADEON(0): 	00ffffffffffff0030e4fb0100000000
(II) RADEON(0): 	00130103802313780a08d59f5a509625
(II) RADEON(0): 	1e505400000001010101010101010101
(II) RADEON(0): 	0101010101011a3680a070381f403020
(II) RADEON(0): 	350059c2100000190000000000000000
(II) RADEON(0): 	00000000000000000000000000fe004c
(II) RADEON(0): 	4720446973706c61790a2020000000fe
(II) RADEON(0): 	004c503135365746312d544c4531009c
(II) RADEON(0): EDID vendor "LGD", prod id 507
(II) RADEON(0): Printing probed modes for output LVDS
(II) RADEON(0): Modeline "1920x1080"x59.9  138.50  1920 1968 2000 2080  1080 1083 1088 1111 -hsync -vsync (66.6 kHz)
(II) RADEON(0): Modeline "1680x1050"x60.0  146.25  1680 1784 1960 2240  1050 1053 1059 1089 -hsync +vsync (65.3 kHz)
(II) RADEON(0): Modeline "1400x1050"x60.0  121.75  1400 1488 1632 1864  1050 1053 1057 1089 -hsync +vsync (65.3 kHz)
(II) RADEON(0): Modeline "1280x1024"x59.9  109.00  1280 1368 1496 1712  1024 1027 1034 1063 -hsync +vsync (63.7 kHz)
(II) RADEON(0): Modeline "1440x900"x59.9  106.50  1440 1528 1672 1904  900 903 909 934 -hsync +vsync (55.9 kHz)
(II) RADEON(0): Modeline "1280x960"x59.9  101.25  1280 1360 1488 1696  960 963 967 996 -hsync +vsync (59.7 kHz)
(II) RADEON(0): Modeline "1280x854"x59.9   89.25  1280 1352 1480 1680  854 857 867 887 -hsync +vsync (53.1 kHz)
(II) RADEON(0): Modeline "1280x800"x59.8   83.50  1280 1352 1480 1680  800 803 809 831 -hsync +vsync (49.7 kHz)
(II) RADEON(0): Modeline "1280x720"x59.9   74.50  1280 1344 1472 1664  720 723 728 748 -hsync +vsync (44.8 kHz)
(II) RADEON(0): Modeline "1152x768"x59.8   71.75  1152 1216 1328 1504  768 771 781 798 -hsync +vsync (47.7 kHz)
(II) RADEON(0): Modeline "1024x768"x59.9   63.50  1024 1072 1176 1328  768 771 775 798 -hsync +vsync (47.8 kHz)
(II) RADEON(0): Modeline "800x600"x59.9   38.25  800 832 912 1024  600 603 607 624 -hsync +vsync (37.4 kHz)
(II) RADEON(0): Modeline "640x480"x59.4   23.75  640 664 720 800  480 483 487 500 -hsync +vsync (29.7 kHz)
(II) RADEON(0): Output: HDMI-0, Detected Monitor Type: 0
(II) RADEON(0): EDID for output HDMI-0
(II) RADEON(0): Output LVDS connected
(II) RADEON(0): Output HDMI-0 disconnected
(II) RADEON(0): Using exact sizes for initial modes
(II) RADEON(0): Output LVDS using initial mode 1920x1080
(**) RADEON(0): Display dimensions: (350, 190) mm
(**) RADEON(0): DPI set to (139, 256)
(II) Loading sub module "fb"
(II) LoadModule: "fb"
(II) Loading /usr/lib/xorg/modules//libfb.so
(II) Module fb: vendor="X.Org Foundation"
	compiled for 1.6.4, module version = 1.0.0
	ABI class: X.Org ANSI C Emulation, version 0.4
(==) RADEON(0): Using gamma correction (1.0, 1.0, 1.0)
(II) Loading sub module "ramdac"
(II) LoadModule: "ramdac"
(II) Module "ramdac" already built-in
(==) RADEON(0): Will attempt to use R6xx/R7xx EXA support if DRI is enabled.
(II) Loading sub module "exa"
(II) LoadModule: "exa"
(II) Loading /usr/lib/xorg/modules//libexa.so
(II) Module exa: vendor="X.Org Foundation"
	compiled for 1.6.4, module version = 2.4.0
	ABI class: X.Org Video Driver, version 5.0
(!!) RADEON(0): For information on using the multimedia capabilities
	of this adapter, please see http://gatos.sf.net.
(!!) RADEON(0): MergedFB support has been removed and replaced with xrandr 1.2 support
(II) UnloadModule: "vesa"
(II) Unloading /usr/lib/xorg/modules/drivers//vesa_drv.so
(II) UnloadModule: "fbdev"
(II) Unloading /usr/lib/xorg/modules/drivers//fbdev_drv.so
(II) UnloadModule: "fbdevhw"
(II) Unloading /usr/lib/xorg/modules/linux//libfbdevhw.so
(--) Depth 24 pixmap format is 32 bpp
(II) do I need RAC?  No, I don't.
(II) resource ranges after preInit:
	[0] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[1] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[2] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[3] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[4] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[5] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[6] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[7] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[8] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[9] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[10] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[11] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[12] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[13] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[14] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[15] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[16] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[17] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[18] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[19] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[20] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[21] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[22] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[23] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[24] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[25] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[26] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[27] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[28] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[29] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[30] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[31] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[32] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[33] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[34] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[35] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[36] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[37] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[38] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[39] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[40] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[41] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[42] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[43] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[44] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[45] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[46] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[47] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[48] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[49] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[50] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[51] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[52] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[53] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[54] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[55] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[56] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[57] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[58] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[59] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[60] -1	0	0xffffffff - 0xffffffff (0x1) MX[B]
	[61] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[62] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[63] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[64] 0	0	0x000a0000 - 0x000affff (0x10000) MS[B]
	[65] 0	0	0x000b0000 - 0x000b7fff (0x8000) MS[B]
	[66] 0	0	0x000b8000 - 0x000bffff (0x8000) MS[B]
	[67] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[68] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[69] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[70] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[71] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[72] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[73] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[74] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[75] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[76] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[77] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[78] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[79] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[80] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[81] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[82] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[83] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[84] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[85] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[86] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[87] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[88] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[89] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[90] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[91] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[92] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[93] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[94] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[95] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[96] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[97] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[98] -1	0	0x00000000 - 0x00000000 (0x1) IX[B]
	[99] 0	0	0x000003b0 - 0x000003bb (0xc) IS[B]
	[100] 0	0	0x000003c0 - 0x000003df (0x20) IS[B]
(II) RADEON(0): RADEONScreenInit c0000000 0 0
Output UNIPHY2 transmitter setup success
Blank CRTC 0 success
Disable CRTC 0 success
Disable CRTC memreq 0 success
Blank CRTC 1 success
Disable CRTC 1 success
Disable CRTC memreq 1 success
(II) RADEON(0): Dynamic Power Management Disabled
(==) RADEON(0): Using 24 bit depth buffer
mc fb loc is 00ff00c0
(II) RADEON(0): RADEONInitMemoryMap() : 
(II) RADEON(0):   mem_size         : 0x40000000
(II) RADEON(0):   MC_FB_LOCATION   : 0x00ff00c0
(II) RADEON(0):   MC_AGP_LOCATION  : 0x003f0000
(II) RADEON(0): Depth moves disabled by default
(II) RADEON(0): Allocating from a screen of 262080 kb
(II) RADEON(0): Will use 32 kb for hardware cursor 0 at offset 0x00f00000
(II) RADEON(0): Will use 32 kb for hardware cursor 1 at offset 0x00f04000
(II) RADEON(0): Will use 15360 kb for front buffer at offset 0x00000000
(II) RADEON(0): Will use 64 kb for PCI GART at offset 0x0fff0000
(II) RADEON(0): Will use 15360 kb for back buffer at offset 0x00f08000
(II) RADEON(0): Will use 15360 kb for depth buffer at offset 0x01e08000
(II) RADEON(0): Will use 107520 kb for textures at offset 0x02d08000
(II) RADEON(0): Will use 108448 kb for X Server offscreen at offset 0x09608000
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: open result is 10, (OK)
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: open result is 10, (OK)
drmOpenByBusid: Searching for BusID pci:0000:01:00.0
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: open result is 10, (OK)
drmOpenByBusid: drmOpenMinor returns 10
drmOpenByBusid: drmGetBusid reports pci:0000:01:00.0
(II) [drm] DRM interface version 1.3
(II) [drm] DRM open master succeeded.
(II) RADEON(0): [drm] Using the DRM lock SAREA also for drawables.
(II) RADEON(0): [drm] framebuffer handle = 0xc0000000
(II) RADEON(0): [drm] added 1 reserved context for kernel
(II) RADEON(0): X context handle = 0x1
(II) RADEON(0): [drm] installed DRM signal handler
(II) RADEON(0): [pci] 32768 kB allocated with handle 0x123be900
(II) RADEON(0): [pci] ring handle = 0x2b800000
(II) RADEON(0): [pci] Ring mapped at 0x7fc3b194c000
(II) RADEON(0): [pci] Ring contents 0x00000000
(II) RADEON(0): [pci] ring read ptr handle = 0x1b7fe000
(II) RADEON(0): [pci] Ring read ptr mapped at 0x7fc3b1a6e000
(II) RADEON(0): [pci] Ring read ptr contents 0x00000000
(II) RADEON(0): [pci] vertex/indirect buffers handle = 0x2b7fe000
(II) RADEON(0): [pci] Vertex/indirect buffers mapped at 0x7fc39cc18000
(II) RADEON(0): [pci] Vertex/indirect buffers contents 0x00000000
(II) RADEON(0): [pci] GART texture map handle = 0x2b801000
(II) RADEON(0): [pci] GART Texture map mapped at 0x7fc39af98000
(II) RADEON(0): [drm] register handle = 0x2fff9000
(II) RADEON(0): [dri] Visual configs initialized
(II) RADEON(0): RADEONRestoreMemMapRegisters() : 
(II) RADEON(0):   MC_FB_LOCATION   : 0x00ff00c0 0x003f0000
(II) RADEON(0):   MC_AGP_LOCATION  : 0x003f0000
(==) RADEON(0): Backing store disabled
(II) RADEON(0): [DRI] installation complete
(II) RADEON(0): [drm] Added 32 65536 byte vertex/indirect buffers
(II) RADEON(0): [drm] Mapped 32 vertex/indirect buffers
(II) RADEON(0): [drm] dma control initialized, using IRQ 16
(II) RADEON(0): [drm] Initialized kernel GART heap manager, 29884416
(WW) RADEON(0): DRI init changed memory map, adjusting ...
(WW) RADEON(0):   MC_FB_LOCATION  was: 0x00ff00c0 is: 0x00ff00c0
(WW) RADEON(0):   MC_AGP_LOCATION was: 0x003f0000 is: 0x00030000
(II) RADEON(0): RADEONRestoreMemMapRegisters() : 
(II) RADEON(0):   MC_FB_LOCATION   : 0x00ff00c0 0x00ff00c0
(II) RADEON(0):   MC_AGP_LOCATION  : 0x00030000
(II) RADEON(0): Direct rendering enabled
(II) RADEON(0): Setting EXA maxPitchBytes
(II) EXA(0): Offscreen pixmap area of 111050752 bytes
(II) EXA(0): Driver registered support for the following operations:
(II)         Solid
(II)         Copy
(II)         Composite (RENDER acceleration)
(II)         UploadToScreen
(II)         DownloadFromScreen
(II) RADEON(0): Acceleration enabled
(II) RADEON(0): DPMS enabled
(==) RADEON(0): Silken mouse enabled
(II) RADEON(0): Set up textured video
Output UNIPHY2 transmitter setup success
(II) RADEON(0): UNIPHY0 transmitter: Coherent Mode enabled
Output UNIPHY0 transmitter setup success
Blank CRTC 0 success
Disable CRTC 0 success
Disable CRTC memreq 0 success
Blank CRTC 1 success
Disable CRTC 1 success
Disable CRTC memreq 1 success
Output UNIPHY2 transmitter setup success
Blank CRTC 0 success
Disable CRTC 0 success
Disable CRTC memreq 0 success
Mode 1920x1080 - 2080 1111 10
(II) RADEON(0): RADEONRestoreMemMapRegisters() : 
(II) RADEON(0):   MC_FB_LOCATION   : 0x00ff00c0 0x00ff00c0
(II) RADEON(0):   MC_AGP_LOCATION  : 0x00030000
freq: 138500000
best_freq: 138600000
best_feedback_div: 77
best_frac_feedback_div: 0
best_ref_div: 3
best_post_div: 5
(II) RADEON(0): crtc(0) Clock: mode 138500, PLL 138600
(II) RADEON(0): crtc(0) PLL  : refdiv 3, fbdiv 0x4D(77), fracfbdiv 0, pdiv 5
Set CRTC 0 PLL success
Set CRTC Timing success
Set CRTC 0 Overscan success
Not using RMX
scaler 0 setup success
Set CRTC 0 Source success
crtc 0 YUV disable setup success
Output UNIPHY2 transmitter setup success
Output DIG1 encoder setup success
Output DIG1 encoder setup success
Output UNIPHY2 transmitter setup success
Output UNIPHY2 transmitter setup success
Output UNIPHY2 transmitter setup success
Enable CRTC memreq 0 success
Enable CRTC 0 success
Unblank CRTC 0 success
(II) RADEON(0): UNIPHY0 transmitter: Coherent Mode enabled
Output UNIPHY0 transmitter setup success
Blank CRTC 1 success
Disable CRTC 1 success
Disable CRTC memreq 1 success
(II) RADEON(0): RandR 1.2 enabled, ignore the following RandR disabled message.
(--) RandR disabled
(II) Setting vga for screen 0.
(II) Initializing built-in extension Generic Event Extension
(II) Initializing built-in extension SHAPE
(II) Initializing built-in extension MIT-SHM
(II) Initializing built-in extension XInputExtension
(II) Initializing built-in extension XTEST
(II) Initializing built-in extension BIG-REQUESTS
(II) Initializing built-in extension SYNC
(II) Initializing built-in extension XKEYBOARD
(II) Initializing built-in extension XC-MISC
(II) Initializing built-in extension SECURITY
(II) Initializing built-in extension XINERAMA
(II) Initializing built-in extension XFIXES
(II) Initializing built-in extension RENDER
(II) Initializing built-in extension RANDR
(II) Initializing built-in extension COMPOSITE
(II) Initializing built-in extension DAMAGE
(II) AIGLX: Screen 0 is not DRI2 capable
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: open result is 11, (OK)
drmOpenByBusid: Searching for BusID pci:0000:01:00.0
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: open result is 11, (OK)
drmOpenByBusid: drmOpenMinor returns 11
drmOpenByBusid: drmGetBusid reports pci:0000:01:00.0
(EE) AIGLX error: dlopen of /usr/lib/dri/r600_dri.so failed (/usr/lib/dri/r600_dri.so: cannot open shared object file: No such file or directory)
(EE) AIGLX: reverting to software rendering
(II) AIGLX: Loaded and initialized /usr/lib/dri/swrast_dri.so
(II) GLX: Initialized DRISWRAST GL provider for screen 0
(II) RADEON(0): Setting screen physical size to 345 x 194
(II) config/hal: Adding input device AT Translated Set 2 keyboard
(II) LoadModule: "evdev"
(II) Loading /usr/lib/xorg/modules/input//evdev_drv.so
(II) Module evdev: vendor="X.Org Foundation"
	compiled for 1.6.4, module version = 2.2.5
	Module class: X.Org XInput Driver
	ABI class: X.Org XInput driver, version 4.0
(**) AT Translated Set 2 keyboard: always reports core events
(**) AT Translated Set 2 keyboard: Device: "/dev/input/event4"
(II) AT Translated Set 2 keyboard: Found keys
(II) AT Translated Set 2 keyboard: Configuring as keyboard
(II) XINPUT: Adding extended input device "AT Translated Set 2 keyboard" (type: KEYBOARD)
(**) Option "xkb_rules" "evdev"
(**) Option "xkb_model" "pc105"
(**) Option "xkb_layout" "us"
(II) config/hal: Adding input device Microsoft Microsoft Wireless Optical Desktop® 2.10
(**) Microsoft Microsoft Wireless Optical Desktop® 2.10: always reports core events
(**) Microsoft Microsoft Wireless Optical Desktop® 2.10: Device: "/dev/input/event6"
(II) Microsoft Microsoft Wireless Optical Desktop® 2.10: Found 9 mouse buttons
(II) Microsoft Microsoft Wireless Optical Desktop® 2.10: Found x and y relative axes
(II) Microsoft Microsoft Wireless Optical Desktop® 2.10: Found scroll wheel(s)
(II) Microsoft Microsoft Wireless Optical Desktop® 2.10: Found x and y absolute axes
(II) Microsoft Microsoft Wireless Optical Desktop® 2.10: Found keys
(II) Microsoft Microsoft Wireless Optical Desktop® 2.10: Configuring as mouse
(II) Microsoft Microsoft Wireless Optical Desktop® 2.10: Configuring as keyboard
(**) Microsoft Microsoft Wireless Optical Desktop® 2.10: YAxisMapping: buttons 4 and 5
(**) Microsoft Microsoft Wireless Optical Desktop® 2.10: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
(II) XINPUT: Adding extended input device "Microsoft Microsoft Wireless Optical Desktop® 2.10" (type: KEYBOARD)
(**) Option "xkb_rules" "evdev"
(**) Option "xkb_model" "pc105"
(**) Option "xkb_layout" "us"
(**) Microsoft Microsoft Wireless Optical Desktop® 2.10: (accel) keeping acceleration scheme 1
(**) Microsoft Microsoft Wireless Optical Desktop® 2.10: (accel) filter chain progression: 2.00
(**) Microsoft Microsoft Wireless Optical Desktop® 2.10: (accel) filter stage 0: 20.00 ms
(**) Microsoft Microsoft Wireless Optical Desktop® 2.10: (accel) set acceleration profile 0
(II) Microsoft Microsoft Wireless Optical Desktop® 2.10: initialized for relative axes.
(WW) Microsoft Microsoft Wireless Optical Desktop® 2.10: ignoring absolute axes.
(II) config/hal: Adding input device Microsoft Microsoft Wireless Optical Desktop® 2.10
(**) Microsoft Microsoft Wireless Optical Desktop® 2.10: always reports core events
(**) Microsoft Microsoft Wireless Optical Desktop® 2.10: Device: "/dev/input/event5"
(II) Microsoft Microsoft Wireless Optical Desktop® 2.10: Found keys
(II) Microsoft Microsoft Wireless Optical Desktop® 2.10: Configuring as keyboard
(II) XINPUT: Adding extended input device "Microsoft Microsoft Wireless Optical Desktop® 2.10" (type: KEYBOARD)
(**) Option "xkb_rules" "evdev"
(**) Option "xkb_model" "pc105"
(**) Option "xkb_layout" "us"
(II) config/hal: Adding input device Power Button
(**) Power Button: always reports core events
(**) Power Button: Device: "/dev/input/event0"
(II) Power Button: Found keys
(II) Power Button: Configuring as keyboard
(II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD)
(**) Option "xkb_rules" "evdev"
(**) Option "xkb_model" "pc105"
(**) Option "xkb_layout" "us"
(II) config/hal: Adding input device Video Bus
(**) Video Bus: always reports core events
(**) Video Bus: Device: "/dev/input/event7"
(II) Video Bus: Found keys
(II) Video Bus: Configuring as keyboard
(II) XINPUT: Adding extended input device "Video Bus" (type: KEYBOARD)
(**) Option "xkb_rules" "evdev"
(**) Option "xkb_model" "pc105"
(**) Option "xkb_layout" "us"
(II) config/hal: Adding input device Power Button
(**) Power Button: always reports core events
(**) Power Button: Device: "/dev/input/event2"
(II) Power Button: Found keys
(II) Power Button: Configuring as keyboard
(II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD)
(**) Option "xkb_rules" "evdev"
(**) Option "xkb_model" "pc105"
(**) Option "xkb_layout" "us"
(II) config/hal: Adding input device Macintosh mouse button emulation
(**) Macintosh mouse button emulation: always reports core events
(**) Macintosh mouse button emulation: Device: "/dev/input/event3"
(II) Macintosh mouse button emulation: Found 3 mouse buttons
(II) Macintosh mouse button emulation: Found x and y relative axes
(II) Macintosh mouse button emulation: Configuring as mouse
(**) Macintosh mouse button emulation: YAxisMapping: buttons 4 and 5
(**) Macintosh mouse button emulation: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
(II) XINPUT: Adding extended input device "Macintosh mouse button emulation" (type: MOUSE)
(**) Macintosh mouse button emulation: (accel) keeping acceleration scheme 1
(**) Macintosh mouse button emulation: (accel) filter chain progression: 2.00
(**) Macintosh mouse button emulation: (accel) filter stage 0: 20.00 ms
(**) Macintosh mouse button emulation: (accel) set acceleration profile 0
(II) Macintosh mouse button emulation: initialized for relative axes.
(II) config/hal: Adding input device HP Webcam
(**) HP Webcam: always reports core events
(**) HP Webcam: Device: "/dev/input/event9"
(II) HP Webcam: Found keys
(II) HP Webcam: Configuring as keyboard
(II) XINPUT: Adding extended input device "HP Webcam" (type: KEYBOARD)
(**) Option "xkb_rules" "evdev"
(**) Option "xkb_model" "pc105"
(**) Option "xkb_layout" "us"
(II) config/hal: Adding input device SynPS/2 Synaptics TouchPad
(II) LoadModule: "synaptics"
(II) Loading /usr/lib/xorg/modules/input//synaptics_drv.so
(II) Module synaptics: vendor="X.Org Foundation"
	compiled for 1.6.4, module version = 1.1.2
	Module class: X.Org XInput Driver
	ABI class: X.Org XInput driver, version 4.0
(II) Synaptics touchpad driver version 1.1.2
(**) Option "Device" "/dev/input/event10"
(II) SynPS/2 Synaptics TouchPad: x-axis range 1472 - 5472
(II) SynPS/2 Synaptics TouchPad: y-axis range 1408 - 4448
(II) SynPS/2 Synaptics TouchPad: pressure range 0 - 255
(II) SynPS/2 Synaptics TouchPad: finger width range 0 - 0
(II) SynPS/2 Synaptics TouchPad: buttons: left right
(**) Option "SHMConfig" "on"
(--) SynPS/2 Synaptics TouchPad: touchpad found
(**) SynPS/2 Synaptics TouchPad: always reports core events
(II) XINPUT: Adding extended input device "SynPS/2 Synaptics TouchPad" (type: TOUCHPAD)
(**) SynPS/2 Synaptics TouchPad: (accel) keeping acceleration scheme 1
(**) SynPS/2 Synaptics TouchPad: (accel) filter chain progression: 2.00
(**) SynPS/2 Synaptics TouchPad: (accel) filter stage 0: 20.00 ms
(**) SynPS/2 Synaptics TouchPad: (accel) set acceleration profile 0
(--) SynPS/2 Synaptics TouchPad: touchpad found
(II) RADEON(0): EDID for output LVDS
(II) RADEON(0): Manufacturer: LGD  Model: 1fb  Serial#: 0
(II) RADEON(0): Year: 2009  Week: 0
(II) RADEON(0): EDID Version: 1.3
(II) RADEON(0): Digital Display Input
(II) RADEON(0): Max Image Size [cm]: horiz.: 35  vert.: 19
(II) RADEON(0): Gamma: 2.20
(II) RADEON(0): No DPMS capabilities specified
(II) RADEON(0): Supported color encodings: RGB 4:4:4 YCrCb 4:4:4 
(II) RADEON(0): First detailed timing is preferred mode
(II) RADEON(0): redX: 0.621 redY: 0.352   greenX: 0.314 greenY: 0.586
(II) RADEON(0): blueX: 0.147 blueY: 0.118   whiteX: 0.313 whiteY: 0.329
(II) RADEON(0): Manufacturer's mask: 0
(II) RADEON(0): Supported detailed timing:
(II) RADEON(0): clock: 138.5 MHz   Image Size:  345 x 194 mm
(II) RADEON(0): h_active: 1920  h_sync: 1968  h_sync_end 2000 h_blank_end 2080 h_border: 0
(II) RADEON(0): v_active: 1080  v_sync: 1083  v_sync_end 1088 v_blanking: 1111 v_border: 0
(II) RADEON(0):  LG Display
(II) RADEON(0):  LP156WF1-TLE1
(II) RADEON(0): EDID (in hex):
(II) RADEON(0): 	00ffffffffffff0030e4fb0100000000
(II) RADEON(0): 	00130103802313780a08d59f5a509625
(II) RADEON(0): 	1e505400000001010101010101010101
(II) RADEON(0): 	0101010101011a3680a070381f403020
(II) RADEON(0): 	350059c2100000190000000000000000
(II) RADEON(0): 	00000000000000000000000000fe004c
(II) RADEON(0): 	4720446973706c61790a2020000000fe
(II) RADEON(0): 	004c503135365746312d544c4531009c
(II) RADEON(0): EDID vendor "LGD", prod id 507
(II) RADEON(0): Printing DDC gathered Modelines:
(II) RADEON(0): Modeline "1920x1080"x0.0  138.50  1920 1968 2000 2080  1080 1083 1088 1111 -hsync -vsync (66.6 kHz)
(II) RADEON(0): Output: LVDS, Detected Monitor Type: 2
(II) RADEON(0): EDID data from the display on output: LVDS ----------------------
(II) RADEON(0): Manufacturer: LGD  Model: 1fb  Serial#: 0
(II) RADEON(0): Year: 2009  Week: 0
(II) RADEON(0): EDID Version: 1.3
(II) RADEON(0): Digital Display Input
(II) RADEON(0): Max Image Size [cm]: horiz.: 35  vert.: 19
(II) RADEON(0): Gamma: 2.20
(II) RADEON(0): No DPMS capabilities specified
(II) RADEON(0): Supported color encodings: RGB 4:4:4 YCrCb 4:4:4 
(II) RADEON(0): First detailed timing is preferred mode
(II) RADEON(0): redX: 0.621 redY: 0.352   greenX: 0.314 greenY: 0.586
(II) RADEON(0): blueX: 0.147 blueY: 0.118   whiteX: 0.313 whiteY: 0.329
(II) RADEON(0): Manufacturer's mask: 0
(II) RADEON(0): Supported detailed timing:
(II) RADEON(0): clock: 138.5 MHz   Image Size:  345 x 194 mm
(II) RADEON(0): h_active: 1920  h_sync: 1968  h_sync_end 2000 h_blank_end 2080 h_border: 0
(II) RADEON(0): v_active: 1080  v_sync: 1083  v_sync_end 1088 v_blanking: 1111 v_border: 0
(II) RADEON(0):  LG Display
(II) RADEON(0):  LP156WF1-TLE1
(II) RADEON(0): EDID (in hex):
(II) RADEON(0): 	00ffffffffffff0030e4fb0100000000
(II) RADEON(0): 	00130103802313780a08d59f5a509625
(II) RADEON(0): 	1e505400000001010101010101010101
(II) RADEON(0): 	0101010101011a3680a070381f403020
(II) RADEON(0): 	350059c2100000190000000000000000
(II) RADEON(0): 	00000000000000000000000000fe004c
(II) RADEON(0): 	4720446973706c61790a2020000000fe
(II) RADEON(0): 	004c503135365746312d544c4531009c
(II) RADEON(0): EDID vendor "LGD", prod id 507
(II) RADEON(0): Printing probed modes for output LVDS
(II) RADEON(0): Modeline "1920x1080"x59.9  138.50  1920 1968 2000 2080  1080 1083 1088 1111 -hsync -vsync (66.6 kHz)
(II) RADEON(0): Modeline "1680x1050"x60.0  146.25  1680 1784 1960 2240  1050 1053 1059 1089 -hsync +vsync (65.3 kHz)
(II) RADEON(0): Modeline "1400x1050"x60.0  121.75  1400 1488 1632 1864  1050 1053 1057 1089 -hsync +vsync (65.3 kHz)
(II) RADEON(0): Modeline "1280x1024"x59.9  109.00  1280 1368 1496 1712  1024 1027 1034 1063 -hsync +vsync (63.7 kHz)
(II) RADEON(0): Modeline "1440x900"x59.9  106.50  1440 1528 1672 1904  900 903 909 934 -hsync +vsync (55.9 kHz)
(II) RADEON(0): Modeline "1280x960"x59.9  101.25  1280 1360 1488 1696  960 963 967 996 -hsync +vsync (59.7 kHz)
(II) RADEON(0): Modeline "1280x854"x59.9   89.25  1280 1352 1480 1680  854 857 867 887 -hsync +vsync (53.1 kHz)
(II) RADEON(0): Modeline "1280x800"x59.8   83.50  1280 1352 1480 1680  800 803 809 831 -hsync +vsync (49.7 kHz)
(II) RADEON(0): Modeline "1280x720"x59.9   74.50  1280 1344 1472 1664  720 723 728 748 -hsync +vsync (44.8 kHz)
(II) RADEON(0): Modeline "1152x768"x59.8   71.75  1152 1216 1328 1504  768 771 781 798 -hsync +vsync (47.7 kHz)
(II) RADEON(0): Modeline "1024x768"x59.9   63.50  1024 1072 1176 1328  768 771 775 798 -hsync +vsync (47.8 kHz)
(II) RADEON(0): Modeline "800x600"x59.9   38.25  800 832 912 1024  600 603 607 624 -hsync +vsync (37.4 kHz)
(II) RADEON(0): Modeline "640x480"x59.4   23.75  640 664 720 800  480 483 487 500 -hsync +vsync (29.7 kHz)
(II) RADEON(0): Output: HDMI-0, Detected Monitor Type: 0
(II) RADEON(0): EDID for output HDMI-0
(II) RADEON(0): EDID for output LVDS
(II) RADEON(0): Manufacturer: LGD  Model: 1fb  Serial#: 0
(II) RADEON(0): Year: 2009  Week: 0
(II) RADEON(0): EDID Version: 1.3
(II) RADEON(0): Digital Display Input
(II) RADEON(0): Max Image Size [cm]: horiz.: 35  vert.: 19
(II) RADEON(0): Gamma: 2.20
(II) RADEON(0): No DPMS capabilities specified
(II) RADEON(0): Supported color encodings: RGB 4:4:4 YCrCb 4:4:4 
(II) RADEON(0): First detailed timing is preferred mode
(II) RADEON(0): redX: 0.621 redY: 0.352   greenX: 0.314 greenY: 0.586
(II) RADEON(0): blueX: 0.147 blueY: 0.118   whiteX: 0.313 whiteY: 0.329
(II) RADEON(0): Manufacturer's mask: 0
(II) RADEON(0): Supported detailed timing:
(II) RADEON(0): clock: 138.5 MHz   Image Size:  345 x 194 mm
(II) RADEON(0): h_active: 1920  h_sync: 1968  h_sync_end 2000 h_blank_end 2080 h_border: 0
(II) RADEON(0): v_active: 1080  v_sync: 1083  v_sync_end 1088 v_blanking: 1111 v_border: 0
(II) RADEON(0):  LG Display
(II) RADEON(0):  LP156WF1-TLE1
(II) RADEON(0): EDID (in hex):
(II) RADEON(0): 	00ffffffffffff0030e4fb0100000000
(II) RADEON(0): 	00130103802313780a08d59f5a509625
(II) RADEON(0): 	1e505400000001010101010101010101
(II) RADEON(0): 	0101010101011a3680a070381f403020
(II) RADEON(0): 	350059c2100000190000000000000000
(II) RADEON(0): 	00000000000000000000000000fe004c
(II) RADEON(0): 	4720446973706c61790a2020000000fe
(II) RADEON(0): 	004c503135365746312d544c4531009c
(II) RADEON(0): EDID vendor "LGD", prod id 507
(II) RADEON(0): Printing DDC gathered Modelines:
(II) RADEON(0): Modeline "1920x1080"x0.0  138.50  1920 1968 2000 2080  1080 1083 1088 1111 -hsync -vsync (66.6 kHz)
(II) RADEON(0): Output: LVDS, Detected Monitor Type: 2
(II) RADEON(0): EDID data from the display on output: LVDS ----------------------
(II) RADEON(0): Manufacturer: LGD  Model: 1fb  Serial#: 0
(II) RADEON(0): Year: 2009  Week: 0
(II) RADEON(0): EDID Version: 1.3
(II) RADEON(0): Digital Display Input
(II) RADEON(0): Max Image Size [cm]: horiz.: 35  vert.: 19
(II) RADEON(0): Gamma: 2.20
(II) RADEON(0): No DPMS capabilities specified
(II) RADEON(0): Supported color encodings: RGB 4:4:4 YCrCb 4:4:4 
(II) RADEON(0): First detailed timing is preferred mode
(II) RADEON(0): redX: 0.621 redY: 0.352   greenX: 0.314 greenY: 0.586
(II) RADEON(0): blueX: 0.147 blueY: 0.118   whiteX: 0.313 whiteY: 0.329
(II) RADEON(0): Manufacturer's mask: 0
(II) RADEON(0): Supported detailed timing:
(II) RADEON(0): clock: 138.5 MHz   Image Size:  345 x 194 mm
(II) RADEON(0): h_active: 1920  h_sync: 1968  h_sync_end 2000 h_blank_end 2080 h_border: 0
(II) RADEON(0): v_active: 1080  v_sync: 1083  v_sync_end 1088 v_blanking: 1111 v_border: 0
(II) RADEON(0):  LG Display
(II) RADEON(0):  LP156WF1-TLE1
(II) RADEON(0): EDID (in hex):
(II) RADEON(0): 	00ffffffffffff0030e4fb0100000000
(II) RADEON(0): 	00130103802313780a08d59f5a509625
(II) RADEON(0): 	1e505400000001010101010101010101
(II) RADEON(0): 	0101010101011a3680a070381f403020
(II) RADEON(0): 	350059c2100000190000000000000000
(II) RADEON(0): 	00000000000000000000000000fe004c
(II) RADEON(0): 	4720446973706c61790a2020000000fe
(II) RADEON(0): 	004c503135365746312d544c4531009c
(II) RADEON(0): EDID vendor "LGD", prod id 507
(II) RADEON(0): Printing probed modes for output LVDS
(II) RADEON(0): Modeline "1920x1080"x59.9  138.50  1920 1968 2000 2080  1080 1083 1088 1111 -hsync -vsync (66.6 kHz)
(II) RADEON(0): Modeline "1680x1050"x60.0  146.25  1680 1784 1960 2240  1050 1053 1059 1089 -hsync +vsync (65.3 kHz)
(II) RADEON(0): Modeline "1400x1050"x60.0  121.75  1400 1488 1632 1864  1050 1053 1057 1089 -hsync +vsync (65.3 kHz)
(II) RADEON(0): Modeline "1280x1024"x59.9  109.00  1280 1368 1496 1712  1024 1027 1034 1063 -hsync +vsync (63.7 kHz)
(II) RADEON(0): Modeline "1440x900"x59.9  106.50  1440 1528 1672 1904  900 903 909 934 -hsync +vsync (55.9 kHz)
(II) RADEON(0): Modeline "1280x960"x59.9  101.25  1280 1360 1488 1696  960 963 967 996 -hsync +vsync (59.7 kHz)
(II) RADEON(0): Modeline "1280x854"x59.9   89.25  1280 1352 1480 1680  854 857 867 887 -hsync +vsync (53.1 kHz)
(II) RADEON(0): Modeline "1280x800"x59.8   83.50  1280 1352 1480 1680  800 803 809 831 -hsync +vsync (49.7 kHz)
(II) RADEON(0): Modeline "1280x720"x59.9   74.50  1280 1344 1472 1664  720 723 728 748 -hsync +vsync (44.8 kHz)
(II) RADEON(0): Modeline "1152x768"x59.8   71.75  1152 1216 1328 1504  768 771 781 798 -hsync +vsync (47.7 kHz)
(II) RADEON(0): Modeline "1024x768"x59.9   63.50  1024 1072 1176 1328  768 771 775 798 -hsync +vsync (47.8 kHz)
(II) RADEON(0): Modeline "800x600"x59.9   38.25  800 832 912 1024  600 603 607 624 -hsync +vsync (37.4 kHz)
(II) RADEON(0): Modeline "640x480"x59.4   23.75  640 664 720 800  480 483 487 500 -hsync +vsync (29.7 kHz)
(II) RADEON(0): Output: HDMI-0, Detected Monitor Type: 0
(II) RADEON(0): EDID for output HDMI-0
(II) RADEON(0): EDID for output LVDS
(II) RADEON(0): Manufacturer: LGD  Model: 1fb  Serial#: 0
(II) RADEON(0): Year: 2009  Week: 0
(II) RADEON(0): EDID Version: 1.3
(II) RADEON(0): Digital Display Input
(II) RADEON(0): Max Image Size [cm]: horiz.: 35  vert.: 19
(II) RADEON(0): Gamma: 2.20
(II) RADEON(0): No DPMS capabilities specified
(II) RADEON(0): Supported color encodings: RGB 4:4:4 YCrCb 4:4:4 
(II) RADEON(0): First detailed timing is preferred mode
(II) RADEON(0): redX: 0.621 redY: 0.352   greenX: 0.314 greenY: 0.586
(II) RADEON(0): blueX: 0.147 blueY: 0.118   whiteX: 0.313 whiteY: 0.329
(II) RADEON(0): Manufacturer's mask: 0
(II) RADEON(0): Supported detailed timing:
(II) RADEON(0): clock: 138.5 MHz   Image Size:  345 x 194 mm
(II) RADEON(0): h_active: 1920  h_sync: 1968  h_sync_end 2000 h_blank_end 2080 h_border: 0
(II) RADEON(0): v_active: 1080  v_sync: 1083  v_sync_end 1088 v_blanking: 1111 v_border: 0
(II) RADEON(0):  LG Display
(II) RADEON(0):  LP156WF1-TLE1
(II) RADEON(0): EDID (in hex):
(II) RADEON(0): 	00ffffffffffff0030e4fb0100000000
(II) RADEON(0): 	00130103802313780a08d59f5a509625
(II) RADEON(0): 	1e505400000001010101010101010101
(II) RADEON(0): 	0101010101011a3680a070381f403020
(II) RADEON(0): 	350059c2100000190000000000000000
(II) RADEON(0): 	00000000000000000000000000fe004c
(II) RADEON(0): 	4720446973706c61790a2020000000fe
(II) RADEON(0): 	004c503135365746312d544c4531009c
(II) RADEON(0): EDID vendor "LGD", prod id 507
(II) RADEON(0): Printing DDC gathered Modelines:
(II) RADEON(0): Modeline "1920x1080"x0.0  138.50  1920 1968 2000 2080  1080 1083 1088 1111 -hsync -vsync (66.6 kHz)
(II) RADEON(0): Output: LVDS, Detected Monitor Type: 2
(II) RADEON(0): EDID data from the display on output: LVDS ----------------------
(II) RADEON(0): Manufacturer: LGD  Model: 1fb  Serial#: 0
(II) RADEON(0): Year: 2009  Week: 0
(II) RADEON(0): EDID Version: 1.3
(II) RADEON(0): Digital Display Input
(II) RADEON(0): Max Image Size [cm]: horiz.: 35  vert.: 19
(II) RADEON(0): Gamma: 2.20
(II) RADEON(0): No DPMS capabilities specified
(II) RADEON(0): Supported color encodings: RGB 4:4:4 YCrCb 4:4:4 
(II) RADEON(0): First detailed timing is preferred mode
(II) RADEON(0): redX: 0.621 redY: 0.352   greenX: 0.314 greenY: 0.586
(II) RADEON(0): blueX: 0.147 blueY: 0.118   whiteX: 0.313 whiteY: 0.329
(II) RADEON(0): Manufacturer's mask: 0
(II) RADEON(0): Supported detailed timing:
(II) RADEON(0): clock: 138.5 MHz   Image Size:  345 x 194 mm
(II) RADEON(0): h_active: 1920  h_sync: 1968  h_sync_end 2000 h_blank_end 2080 h_border: 0
(II) RADEON(0): v_active: 1080  v_sync: 1083  v_sync_end 1088 v_blanking: 1111 v_border: 0
(II) RADEON(0):  LG Display
(II) RADEON(0):  LP156WF1-TLE1
(II) RADEON(0): EDID (in hex):
(II) RADEON(0): 	00ffffffffffff0030e4fb0100000000
(II) RADEON(0): 	00130103802313780a08d59f5a509625
(II) RADEON(0): 	1e505400000001010101010101010101
(II) RADEON(0): 	0101010101011a3680a070381f403020
(II) RADEON(0): 	350059c2100000190000000000000000
(II) RADEON(0): 	00000000000000000000000000fe004c
(II) RADEON(0): 	4720446973706c61790a2020000000fe
(II) RADEON(0): 	004c503135365746312d544c4531009c
(II) RADEON(0): EDID vendor "LGD", prod id 507
(II) RADEON(0): Printing probed modes for output LVDS
(II) RADEON(0): Modeline "1920x1080"x59.9  138.50  1920 1968 2000 2080  1080 1083 1088 1111 -hsync -vsync (66.6 kHz)
(II) RADEON(0): Modeline "1680x1050"x60.0  146.25  1680 1784 1960 2240  1050 1053 1059 1089 -hsync +vsync (65.3 kHz)
(II) RADEON(0): Modeline "1400x1050"x60.0  121.75  1400 1488 1632 1864  1050 1053 1057 1089 -hsync +vsync (65.3 kHz)
(II) RADEON(0): Modeline "1280x1024"x59.9  109.00  1280 1368 1496 1712  1024 1027 1034 1063 -hsync +vsync (63.7 kHz)
(II) RADEON(0): Modeline "1440x900"x59.9  106.50  1440 1528 1672 1904  900 903 909 934 -hsync +vsync (55.9 kHz)
(II) RADEON(0): Modeline "1280x960"x59.9  101.25  1280 1360 1488 1696  960 963 967 996 -hsync +vsync (59.7 kHz)
(II) RADEON(0): Modeline "1280x854"x59.9   89.25  1280 1352 1480 1680  854 857 867 887 -hsync +vsync (53.1 kHz)
(II) RADEON(0): Modeline "1280x800"x59.8   83.50  1280 1352 1480 1680  800 803 809 831 -hsync +vsync (49.7 kHz)
(II) RADEON(0): Modeline "1280x720"x59.9   74.50  1280 1344 1472 1664  720 723 728 748 -hsync +vsync (44.8 kHz)
(II) RADEON(0): Modeline "1152x768"x59.8   71.75  1152 1216 1328 1504  768 771 781 798 -hsync +vsync (47.7 kHz)
(II) RADEON(0): Modeline "1024x768"x59.9   63.50  1024 1072 1176 1328  768 771 775 798 -hsync +vsync (47.8 kHz)
(II) RADEON(0): Modeline "800x600"x59.9   38.25  800 832 912 1024  600 603 607 624 -hsync +vsync (37.4 kHz)
(II) RADEON(0): Modeline "640x480"x59.4   23.75  640 664 720 800  480 483 487 500 -hsync +vsync (29.7 kHz)
(II) RADEON(0): Output: HDMI-0, Detected Monitor Type: 0
(II) RADEON(0): EDID for output HDMI-0

--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="pm-suspend.log"

Initial commandline parameters: 
Sat Dec 12 15:10:52 MST 2009: Running hooks for suspend.
/usr/lib/pm-utils/sleep.d/000record suspend suspend: success.
/usr/lib/pm-utils/sleep.d/00auto-quirk suspend suspend: Adding quirks from HAL: --quirk-dpms-on --quirk-dpms-suspend --quirk-vbe-post --quirk-vbemode-restore --quirk-vbestate-restore --quirk-vga-mode-3 
success.
/usr/lib/pm-utils/sleep.d/00logging suspend suspend: Linux dre 2.6.31-14-generic #48-Ubuntu SMP Fri Oct 16 14:05:01 UTC 2009 x86_64 GNU/Linux
Module                  Size  Used by
binfmt_misc            10220  1 
ppdev                   8232  0 
arc4                    2144  2 
snd_hda_codec_atihdmi     4320  1 
ecb                     3296  2 
iwlagn                124832  0 
snd_hda_codec_idt      72976  1 
iwlcore               133248  1 iwlagn
uvcvideo               65260  0 
snd_hda_intel          31880  2 
snd_hda_codec          87584  3 snd_hda_codec_atihdmi,snd_hda_codec_idt,snd_hda_intel
iptable_filter          3872  0 
ip_tables              21200  1 iptable_filter
x_tables               25832  1 ip_tables
lp                     11908  0 
joydev                 13088  0 
videodev               43360  1 uvcvideo
hp_accel               12480  0 
lis3lv02d               9312  1 hp_accel
mac80211              210104  2 iwlagn,iwlcore
v4l1_compat            16804  2 uvcvideo,videodev
input_polldev           4720  1 lis3lv02d
atl1c                  36516  0 
led_class               5256  2 iwlcore,hp_accel
v4l2_compat_ioctl32    13344  1 videodev
parport                40528  2 ppdev,lp
snd_hwdep               9352  1 snd_hda_codec
snd_pcm_oss            44704  0 
snd_mixer_oss          18976  1 snd_pcm_oss
snd_pcm                93160  3 snd_hda_intel,snd_hda_codec,snd_pcm_oss
snd_seq_dummy           3460  0 
snd_seq_oss            33440  0 
snd_seq_midi            8192  0 
cfg80211              109144  3 iwlagn,iwlcore,mac80211
psmouse                57124  0 
serio_raw               6596  0 
snd_rawmidi            27360  1 snd_seq_midi
snd_seq_midi_event      8448  2 snd_seq_oss,snd_seq_midi
snd_seq                60608  6 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event
snd_timer              26992  2 snd_pcm,snd_seq
snd_seq_device          8308  5 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq
snd                    77096  16 snd_hda_codec_idt,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device
soundcore               9088  1 snd
snd_page_alloc         10928  2 snd_hda_intel,snd_pcm
video                  23612  0 
output                  3680  1 video
radeon                684512  1 
ttm                    43056  1 radeon
drm                   193856  3 radeon,ttm
i2c_algo_bit            7076  1 radeon
             total       used       free     shared    buffers     cached
Mem:       8187836    8071236     116600          0      93352    7115180
-/+ buffers/cache:     862704    7325132
Swap:      4996172          0    4996172
success.
/usr/lib/pm-utils/sleep.d/00powersave suspend suspend: success.
/usr/lib/pm-utils/sleep.d/01PulseAudio suspend suspend: success.
/etc/pm/sleep.d/10_grub-common suspend suspend: success.
/etc/pm/sleep.d/10_unattended-upgrades-hibernate suspend suspend: success.
/usr/lib/pm-utils/sleep.d/49bluetooth suspend suspend: not applicable.
/usr/lib/pm-utils/sleep.d/55NetworkManager suspend suspend: success.
/usr/lib/pm-utils/sleep.d/75modules suspend suspend: success.
/usr/lib/pm-utils/sleep.d/90clock suspend suspend: not applicable.
/usr/lib/pm-utils/sleep.d/94cpufreq suspend suspend: success.
/usr/lib/pm-utils/sleep.d/95anacron suspend suspend: stop: Unknown instance: 
success.
/usr/lib/pm-utils/sleep.d/95led suspend suspend: not applicable.
/usr/lib/pm-utils/sleep.d/96laptop-mode suspend suspend: success.
/usr/lib/pm-utils/sleep.d/98smart-kernel-video suspend suspend: not applicable.
/usr/lib/pm-utils/sleep.d/99video suspend suspend: kernel.acpi_video_flags = 0
Allocated buffer at 0x11000 (base is 0x0)
ES: 0x1100 EBX: 0x0000
success.
/etc/pm/sleep.d/action_wpa suspend suspend: success.
Sat Dec 12 15:10:55 MST 2009: performing suspend
Sat Dec 12 15:59:59 MST 2009: Awake.
Sat Dec 12 15:59:59 MST 2009: Running hooks for resume
/etc/pm/sleep.d/action_wpa resume suspend: success.
/usr/lib/pm-utils/sleep.d/99video resume suspend: Function not supported
Function not supported
success.
/usr/lib/pm-utils/sleep.d/98smart-kernel-video resume suspend: success.
/usr/lib/pm-utils/sleep.d/96laptop-mode resume suspend: success.
/usr/lib/pm-utils/sleep.d/95led resume suspend: not applicable.
/usr/lib/pm-utils/sleep.d/95anacron resume suspend: success.
/usr/lib/pm-utils/sleep.d/94cpufreq resume suspend: success.
/usr/lib/pm-utils/sleep.d/90clock resume suspend: not applicable.
/usr/lib/pm-utils/sleep.d/75modules resume suspend: success.
/usr/lib/pm-utils/sleep.d/55NetworkManager resume suspend: success.
/usr/lib/pm-utils/sleep.d/49bluetooth resume suspend: not applicable.
/etc/pm/sleep.d/10_unattended-upgrades-hibernate resume suspend: success.
/etc/pm/sleep.d/10_grub-common resume suspend: success.
/usr/lib/pm-utils/sleep.d/01PulseAudio resume suspend: success.
/usr/lib/pm-utils/sleep.d/00powersave resume suspend: success.
/usr/lib/pm-utils/sleep.d/00logging resume suspend: success.
/usr/lib/pm-utils/sleep.d/00auto-quirk resume suspend: success.
/usr/lib/pm-utils/sleep.d/000record resume suspend: success.
Sat Dec 12 16:00:04 MST 2009: Finished.
Initial commandline parameters: 
Sat Dec 12 20:16:12 MST 2009: Running hooks for suspend.
/usr/lib/pm-utils/sleep.d/000record suspend suspend: success.
/usr/lib/pm-utils/sleep.d/00auto-quirk suspend suspend: Adding quirks from HAL: --quirk-dpms-on --quirk-dpms-suspend --quirk-vbe-post --quirk-vbemode-restore --quirk-vbestate-restore --quirk-vga-mode-3 
success.
/usr/lib/pm-utils/sleep.d/00logging suspend suspend: Linux dre 2.6.32achiang #1 SMP Sat Dec 12 16:11:17 MST 2009 x86_64 GNU/Linux
Module                  Size  Used by
binfmt_misc             7454  1 
ppdev                   6059  0 
snd_hda_codec_atihdmi     2879  1 
snd_hda_codec_idt      59622  1 
snd_hda_intel          23609  2 
snd_hda_codec          79633  3 snd_hda_codec_atihdmi,snd_hda_codec_idt,snd_hda_intel
snd_hwdep               6606  1 snd_hda_codec
snd_pcm_oss            39645  0 
snd_mixer_oss          16456  1 snd_pcm_oss
snd_pcm                84013  3 snd_hda_intel,snd_hda_codec,snd_pcm_oss
snd_seq_dummy           1734  0 
snd_seq_oss            29511  0 
snd_seq_midi            5669  0 
snd_rawmidi            22557  1 snd_seq_midi
snd_seq_midi_event      6931  2 snd_seq_oss,snd_seq_midi
snd_seq                54478  6 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event
arc4                    1425  2 
snd_timer              22574  2 snd_pcm,snd_seq
iptable_filter          2679  0 
joydev                 10418  0 
uvcvideo               60826  0 
snd_seq_device          6450  5 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq
iwlagn                111656  0 
hp_accel               12056  0 
lp                      9112  0 
lis3lv02d               7311  1 hp_accel
snd                    68465  16 snd_hda_codec_idt,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device
videodev               39814  1 uvcvideo
ip_tables              17486  1 iptable_filter
iwlcore               121306  1 iwlagn
input_polldev           3058  1 lis3lv02d
psmouse                60980  0 
v4l1_compat            15537  2 uvcvideo,videodev
soundcore               7860  1 snd
atl1c                  31145  0 
parport                36303  2 ppdev,lp
led_class               3556  2 hp_accel,iwlcore
serio_raw               4672  0 
v4l2_compat_ioctl32    11252  1 videodev
x_tables               21645  1 ip_tables
snd_page_alloc          8388  2 snd_hda_intel,snd_pcm
mac80211              185276  2 iwlagn,iwlcore
cfg80211              140103  3 iwlagn,iwlcore,mac80211
fbcon                  38591  71 
tileblit                2375  1 fbcon
font                    8005  1 fbcon
bitblit                 5667  1 fbcon
softcursor              1517  1 bitblit
radeon                576989  2 
ttm                    43336  1 radeon
drm_kms_helper         28010  1 radeon
video                  19498  0 
output                  2391  1 video
drm                   184997  4 radeon,ttm,drm_kms_helper
i2c_algo_bit            5584  1 radeon
             total       used       free     shared    buffers     cached
Mem:       8187684     745196    7442488          0      63664     230676
-/+ buffers/cache:     450856    7736828
Swap:      4996172          0    4996172
success.
/usr/lib/pm-utils/sleep.d/00powersave suspend suspend: success.
/usr/lib/pm-utils/sleep.d/01PulseAudio suspend suspend: success.
/etc/pm/sleep.d/10_grub-common suspend suspend: success.
/etc/pm/sleep.d/10_unattended-upgrades-hibernate suspend suspend: success.
/usr/lib/pm-utils/sleep.d/49bluetooth suspend suspend: not applicable.
/usr/lib/pm-utils/sleep.d/55NetworkManager suspend suspend: success.
/usr/lib/pm-utils/sleep.d/75modules suspend suspend: success.
/usr/lib/pm-utils/sleep.d/90clock suspend suspend: not applicable.
/usr/lib/pm-utils/sleep.d/94cpufreq suspend suspend: success.
/usr/lib/pm-utils/sleep.d/95anacron suspend suspend: stop: Unknown instance: 
success.
/usr/lib/pm-utils/sleep.d/95led suspend suspend: not applicable.
/usr/lib/pm-utils/sleep.d/96laptop-mode suspend suspend: success.
/usr/lib/pm-utils/sleep.d/98smart-kernel-video suspend suspend: success.
/usr/lib/pm-utils/sleep.d/99video suspend suspend: kernel.acpi_video_flags = 0
success.
/etc/pm/sleep.d/action_wpa suspend suspend: success.
Sat Dec 12 20:16:14 MST 2009: performing suspend
Sat Dec 12 20:43:22 MST 2009: Awake.
Sat Dec 12 20:43:22 MST 2009: Running hooks for resume
/etc/pm/sleep.d/action_wpa resume suspend: success.
/usr/lib/pm-utils/sleep.d/99video resume suspend: Returned exit code 1.
/usr/lib/pm-utils/sleep.d/98smart-kernel-video resume suspend: success.
/usr/lib/pm-utils/sleep.d/96laptop-mode resume suspend: success.
/usr/lib/pm-utils/sleep.d/95led resume suspend: not applicable.
/usr/lib/pm-utils/sleep.d/95anacron resume suspend: success.
/usr/lib/pm-utils/sleep.d/94cpufreq resume suspend: success.
/usr/lib/pm-utils/sleep.d/90clock resume suspend: not applicable.
/usr/lib/pm-utils/sleep.d/75modules resume suspend: success.
/usr/lib/pm-utils/sleep.d/55NetworkManager resume suspend: success.
/usr/lib/pm-utils/sleep.d/49bluetooth resume suspend: not applicable.
/etc/pm/sleep.d/10_unattended-upgrades-hibernate resume suspend: success.
/etc/pm/sleep.d/10_grub-common resume suspend: success.
/usr/lib/pm-utils/sleep.d/01PulseAudio resume suspend: success.
/usr/lib/pm-utils/sleep.d/00powersave resume suspend: success.
/usr/lib/pm-utils/sleep.d/00logging resume suspend: success.
/usr/lib/pm-utils/sleep.d/00auto-quirk resume suspend: success.
/usr/lib/pm-utils/sleep.d/000record resume suspend: success.
Initial commandline parameters: 
Sun Dec 13 19:07:57 MST 2009: Running hooks for suspend.
/usr/lib/pm-utils/sleep.d/000record suspend suspend: success.
/usr/lib/pm-utils/sleep.d/00auto-quirk suspend suspend: Adding quirks from HAL: --quirk-dpms-on --quirk-dpms-suspend --quirk-vbe-post --quirk-vbemode-restore --quirk-vbestate-restore --quirk-vga-mode-3 
success.
/usr/lib/pm-utils/sleep.d/00logging suspend suspend: Linux dre 2.6.32 #4 SMP Sun Dec 13 11:27:41 MST 2009 x86_64 GNU/Linux
Module                  Size  Used by
isofs                  29327  0 
udf                    69850  0 
crc_itu_t               1667  1 udf
radeon                499781  1 
ttm                    52214  1 radeon
drm_kms_helper         25544  1 radeon
drm                   178417  4 radeon,ttm,drm_kms_helper
i2c_algo_bit            4874  1 radeon
binfmt_misc             7203  1 
arc4                    1377  2 
snd_hda_codec_atihdmi     2591  1 
snd_hda_codec_idt      52903  1 
snd_hda_intel          22389  2 
snd_hda_codec          75738  3 snd_hda_codec_atihdmi,snd_hda_codec_idt,snd_hda_intel
snd_hwdep               6078  1 snd_hda_codec
snd_pcm_oss            33674  0 
snd_mixer_oss          13449  1 snd_pcm_oss
snd_pcm                75256  3 snd_hda_intel,snd_hda_codec,snd_pcm_oss
snd_seq_dummy           1638  0 
snd_seq_oss            26156  0 
snd_seq_midi            5154  0 
snd_rawmidi            20204  1 snd_seq_midi
iwlagn                 89334  0 
snd_seq_midi_event      6457  2 snd_seq_oss,snd_seq_midi
iwlcore               109106  1 iwlagn
snd_seq                48369  6 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event
uvcvideo               53717  0 
snd_timer              19922  2 snd_pcm,snd_seq
hp_accel               11864  0 
psmouse                50492  0 
mac80211              164058  2 iwlagn,iwlcore
snd_seq_device          6070  5 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq
lis3lv02d               6831  1 hp_accel
iptable_filter          2631  0 
joydev                  9485  0 
videodev               34861  1 uvcvideo
snd                    60747  16 snd_hda_codec_idt,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device
soundcore               6978  1 snd
v4l1_compat            12357  2 uvcvideo,videodev
ip_tables              15419  1 iptable_filter
hid_microsoft           2781  0 
input_polldev           4007  1 lis3lv02d
video                  20532  0 
atl1c                  26716  0 
snd_page_alloc          7666  2 snd_hda_intel,snd_pcm
serio_raw               4475  0 
v4l2_compat_ioctl32     9934  1 videodev
cfg80211              123216  3 iwlagn,iwlcore,mac80211
x_tables               19540  1 ip_tables
led_class               3412  1 hp_accel
output                  2247  1 video
usbhid                 34185  0 
             total       used       free     shared    buffers     cached
Mem:       8188644    1000312    7188332          0      51932     354636
-/+ buffers/cache:     593744    7594900
Swap:      4996172          0    4996172
success.
/usr/lib/pm-utils/sleep.d/00powersave suspend suspend: success.
/usr/lib/pm-utils/sleep.d/01PulseAudio suspend suspend: success.
/etc/pm/sleep.d/10_grub-common suspend suspend: success.
/etc/pm/sleep.d/10_unattended-upgrades-hibernate suspend suspend: success.
/usr/lib/pm-utils/sleep.d/49bluetooth suspend suspend: not applicable.
/usr/lib/pm-utils/sleep.d/55NetworkManager suspend suspend: success.
/usr/lib/pm-utils/sleep.d/75modules suspend suspend: success.
/usr/lib/pm-utils/sleep.d/90clock suspend suspend: not applicable.
/usr/lib/pm-utils/sleep.d/94cpufreq suspend suspend: success.
/usr/lib/pm-utils/sleep.d/95anacron suspend suspend: stop: Unknown instance: 
success.
/usr/lib/pm-utils/sleep.d/95led suspend suspend: not applicable.
/usr/lib/pm-utils/sleep.d/96laptop-mode suspend suspend: success.
/usr/lib/pm-utils/sleep.d/98smart-kernel-video suspend suspend: not applicable.
/usr/lib/pm-utils/sleep.d/99video suspend suspend: kernel.acpi_video_flags = 0
Allocated buffer at 0x11000 (base is 0x0)
ES: 0x1100 EBX: 0x0000
success.
/etc/pm/sleep.d/action_wpa suspend suspend: success.
Sun Dec 13 19:08:01 MST 2009: performing suspend
Sun Dec 13 19:08:16 MST 2009: Awake.
Sun Dec 13 19:08:16 MST 2009: Running hooks for resume
/etc/pm/sleep.d/action_wpa resume suspend: success.
/usr/lib/pm-utils/sleep.d/99video resume suspend: Function not supported
Function not supported
success.
/usr/lib/pm-utils/sleep.d/98smart-kernel-video resume suspend: success.
/usr/lib/pm-utils/sleep.d/96laptop-mode resume suspend: success.
/usr/lib/pm-utils/sleep.d/95led resume suspend: not applicable.
/usr/lib/pm-utils/sleep.d/95anacron resume suspend: success.
/usr/lib/pm-utils/sleep.d/94cpufreq resume suspend: success.
/usr/lib/pm-utils/sleep.d/90clock resume suspend: not applicable.
/usr/lib/pm-utils/sleep.d/75modules resume suspend: success.
/usr/lib/pm-utils/sleep.d/55NetworkManager resume suspend: success.
/usr/lib/pm-utils/sleep.d/49bluetooth resume suspend: not applicable.
/etc/pm/sleep.d/10_unattended-upgrades-hibernate resume suspend: success.
/etc/pm/sleep.d/10_grub-common resume suspend: success.
/usr/lib/pm-utils/sleep.d/01PulseAudio resume suspend: success.
/usr/lib/pm-utils/sleep.d/00powersave resume suspend: success.
/usr/lib/pm-utils/sleep.d/00logging resume suspend: success.
/usr/lib/pm-utils/sleep.d/00auto-quirk resume suspend: success.
/usr/lib/pm-utils/sleep.d/000record resume suspend: success.
Sun Dec 13 19:08:19 MST 2009: Finished.

--wRRV7LY7NUeQGEoC--
