Return-Path: <linux-kernel-owner+w=401wt.eu-S1160997AbXAaTqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1160997AbXAaTqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 14:46:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161003AbXAaTqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 14:46:53 -0500
Received: from mail.gmx.net ([213.165.64.20]:48628 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1160997AbXAaTqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 14:46:52 -0500
X-Authenticated: #24128601
From: Sebastian Kemper <sebastian_ml@gmx.net>
To: linux-kernel@vger.kernel.org
Subject: 2.6.20-rc7 mtrr handling
Date: Wed, 31 Jan 2007 20:46:02 +0100
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701312046.02196.sebastian_ml@gmx.net>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list,

I read about the changes regarding the mtrr code in the upcoming 2.6.20 
kernel and so today I tried rc7.

Since quite some time I had warning messages like

mtrr... overlaps existing...

whenever I started up Xorg with DRI enabled. This doesn't happen anymore 
with 2.6.20-rc7.

But now /proc/mtrr shows 256MB of video ram, same as lspci, whereas the 
real amount of video ram (as properly detected by X) is only 128MB.

I have a Radeon 9250 from Connect3d with AGP, DVI, VGA, TV-Out and 
128bit memory bus width.

I'm wondering if this misdetection could become an issue.

cat /proc/mtrr
reg00: base=0x00000000 (   0MB), size= 512MB: write-back, count=1
reg01: base=0xe0000000 (3584MB), size= 128MB: write-combining, count=2
reg02: base=0xd0000000 (3328MB), size= 256MB: write-combining, count=3

The lines are RAM, AGP Aperture Size and video ram.

grep -i videoram /var/log/Xorg.0.log
(--) RADEON(0): Mapped VideoRAM: 131072 kByte (128 bit DDR SDRAM)

lspci -vvv
...
02:00.0 VGA compatible controller: ATI Technologies Inc RV280 [Radeon 
9200 PRO] (rev 01) (prog-if 00 [VGA])
        Subsystem: Connect Components Ltd Unknown device 2801
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (2000ns min), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at d0000000 (32-bit, prefetchable) [size=256M]
        Region 1: I/O ports at d000 [size=256]
        Region 2: Memory at e9000000 (32-bit, non-prefetchable) 
[size=64K]
        [virtual] Expansion ROM at e8000000 [disabled] [size=128K]
        Capabilities: [58] AGP version 3.0
                Status: RQ=256 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- 
HTrans- 64bit- FW+ AGP3+ Rate=x4,x8
                Command: RQ=32 ArqSz=2 Cal=0 SBA+ AGP+ GART64- 64bit- 
FW- Rate=x8
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

dmesg shows:

...
radeonfb: Found Intel x86 BIOS ROM Image
radeonfb: Retrieved PLL infos from BIOS
radeonfb: Reference=27.00 MHz (RefDiv=12) Memory=240.00 Mhz, 
System=166.00 MHz
radeonfb: PLL min 20000 max 40000
radeonfb: Monitor 1 type DFP found
radeonfb: EDID probed
radeonfb: Monitor 2 type no found
radeonfb: Dynamic Clock Power Management enabled
Console: switching to colour frame buffer device 160x64
radeonfb (0000:02:00.0): ATI Radeon Y`
...
agpgart: Found an AGP 3.0 compliant device at 0000:00:00.0.
agpgart: Putting AGP V3 device at 0000:00:00.0 into 8x mode
agpgart: Putting AGP V3 device at 0000:02:00.0 into 8x mode
[drm] Setting GART location based on new memory map
[drm] Loading R200 Microcode
[drm] writeback test succeeded in 1 usecs
agpgart: Found an AGP 3.0 compliant device at 0000:00:00.0.
agpgart: Putting AGP V3 device at 0000:00:00.0 into 8x mode
agpgart: Putting AGP V3 device at 0000:02:00.0 into 8x mode
[drm] Loading R200 Microcode

/usr/src/linux/scripts/ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux section_eight 2.6.20-rc7 #2 Wed Jan 31 20:23:30 CET 2007 i686 AMD 
Sempron(tm)   2400+ AuthenticAMD GNU/Linux

Gnu C                  4.1.1
Gnu make               3.81
binutils               2.16.1
util-linux             2.12r
mount                  2.12r
module-init-tools      3.2.2
e2fsprogs              1.39
Linux C Library        > libc.2.4
Dynamic linker (ldd)   2.4
Procps                 3.2.6
Net-tools              1.60
Kbd                    1.12
Sh-utils               6.4
udev                   103
Modules Loaded         lirc_serial lirc_dev snd_ice1712 
snd_ice17xx_ak4xxx snd_ak4xxx_adda snd_cs8427 snd_ac97_codec snd_pcm 
snd_page_alloc ac97_bus snd_i2c snd_mpu401_uart snd_rawmidi dvb_ttpci 
saa7146_vv video_buf saa7146 ttpci_eeprom stv0299 dvb_core

Regards
Sebastian
