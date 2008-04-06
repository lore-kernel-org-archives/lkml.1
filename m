Return-Path: <linux-kernel-owner+w=401wt.eu-S1754035AbYDFOeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbYDFOeu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 10:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbYDFOek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 10:34:40 -0400
Received: from mail.gmx.net ([213.165.64.20]:58886 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751506AbYDFOeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 10:34:37 -0400
Cc: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="========GMX106941207492474385500"
Date: Sun, 06 Apr 2008 16:34:34 +0200
From: "Gerhard Pircher" <gerhard_pircher@gmx.net>
In-Reply-To: <21d7e9970804060044i25b36802p1859ca25fa532494@mail.gmail.com>
Message-ID: <20080406143434.106940@gmx.net>
MIME-Version: 1.0
References: <47E82D68.5070305@imap.cc> 
 <21d7e9970803241622v10b887a6p869535102b486279@mail.gmail.com> 
 <47E83D14.8070800@imap.cc> 
 <21d7e9970803241753q433e7545pdd00eae189846a8@mail.gmail.com> 
 <21d7e9970803302153s314d48d3o7120a56092eeaede@mail.gmail.com>  <47F1FA3F.
 <21d7e9970804060044i25b36802p1859ca25fa532494@mail.gmail.com>
Subject: Re: [2.6.25-rc6] possible regression: X server dying
To: "Dave Airlie" <airlied@gmail.com>
X-Authenticated: #6097454
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1+pTKo2IcGpbNBNYjT26WAGTRklnOJ57vC8CSZqBo
 Fc0XU7RAnZ/ynj3ygeD/DjB+akJyZSx63jDg== 
X-GMX-UID: FaqRdItneWUkIFxsNG9n3swjL0tsZk3/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--========GMX106941207492474385500
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

-------- Original-Nachricht --------
> Datum: Sun, 6 Apr 2008 17:44:25 +1000
> Von: "Dave Airlie" <airlied@gmail.com>
> An: "Tilman Schmidt" <tilman@imap.cc>
> CC: linux-kernel@vger.kernel.org
> Betreff: Re: [2.6.25-rc6] possible regression: X server dying

> >  0: /usr/bin/X(xf86SigHandler+0x81) [0x80e6d81]
> >  1: [0xb7ef7400]
> >  2: /usr/lib/xorg/modules//extensions/libglx.so [0xb7b7d8e8]
> >  3: /usr/lib/xorg/modules//extensions/libglx.so(DoRender+0xdd)
> [0xb7b7645d]
> >  4: /usr/lib/xorg/modules//extensions/libglx.so [0xb7b7657c]
> >  5: /usr/lib/xorg/modules//extensions/libglx.so [0xb7b7aa6d]
> >  6: /usr/bin/X [0x815809e]
> >
> >  7: /usr/bin/X(Dispatch+0x1af) [0x808f68f]
> >  8: /usr/bin/X(main+0x47e) [0x807717e]
> >  9: /lib/libc.so.6(__libc_start_main+0xe0) [0xb7c8bfe0]
> >  10: /usr/bin/X(FontFileCompleteXLFD+0x1e5) [0x8076501]
> >
> >  But I know next to nothing about GL, so I'm out of my depth there.
> >  I'd welcome any suggestions on how to provoke the crash more
> >  regularly so that I could attempt to bisect.
> 
> Its one of the GL screensavers, not sure how to narrow it down, use
> ldd to figure out which ones are using GL.
> 
> I've no idea how the kernel is influencing this.
> 
> Dave.

Sorry for hijacking this thread, but I have a similar problem with the
Xorg X server. I'm using kernel 2.6.25-rc8 on my AmigaOne (PowerPC) and
the X server dies right on startup, but only if DRI/DRM is enabled.
I tested this with both Xorg 7.1 (Debian Etch version) and Xorg 7.2
(Lenny). The X server was working fine with kernel 2.6.25-rc6. I have
to mention that the AmigaOne uses uncached memory for DMA operations.
Benjamin Herrenschmidt fixed DRI recently for non cache coherent systems
and his patches are working fine (I applied them to kernel 2.6.25-rc6).
Please take a look at the attached Xorg.0.log file or at the excerpt
below:

(**) RADEON(0): Initializing backing store
(==) RADEON(0): Backing store disabled
(**) RADEON(0): DRI Finishing init !
(II) RADEON(0): X context handle = 0x1

Backtrace:
0: /usr/bin/X(xf86SigHandler+0x94) [0x100934c4]
1: [0x100374]
2: [0x102272a8]
3: /usr/lib/xorg/modules/extensions//libdri.so(DRIFinishScreenInit+0xb0) [0xf9948b0]
4: /usr/lib/xorg/modules/drivers//radeon_drv.so(RADEONDRIFinishScreenInit+0x68) [0xf8a699c]
5: /usr/lib/xorg/modules/drivers//radeon_drv.so(RADEONScreenInit+0xf74) [0xf895f78]
6: /usr/bin/X(AddScreen+0x21c) [0x1002d79c]
7: /usr/bin/X(InitOutput+0x284) [0x1006d364]
8: /usr/bin/X(main+0x294) [0x1002e004]
9: /lib/libc.so.6 [0xfc75b10]
10: /lib/libc.so.6 [0xfc75cd0]

Fatal server error:
Caught signal 11.  Server aborting

(**) RADEON(0): RADEONLeaveVT

regards,

Gerhard

BTW: Please put me on CC:!
-- 
Psst! Geheimtipp: Online Games kostenlos spielen bei den GMX Free Games! 
http://games.entertainment.gmx.net/de/entertainment/games/free

--========GMX106941207492474385500
Content-Type: text/x-log; charset="iso-8859-15"; name="Xorg.0.log"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="Xorg.0.log"


X Window System Version 1.3.0
Release Date: 19 April 2007
X Protocol Version 11, Revision 0, Release 1.3
Build Operating System: Linux Debian (xorg-server 2:1.3.0.0.dfsg-12)
Current Operating System: Linux amigaone 2.6.25-rc8 #84 Thu Apr 3 22:52:51 CEST 2008 ppc
Build Date: 17 August 2007
	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
Module Loader present
Markers: (--) probed, (**) from config file, (==) default setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
(==) Log file: "/var/log/Xorg.0.log", Time: Sat Apr  5 23:27:42 2008
(==) Using config file: "/etc/X11/xorg.conf"
(==) ServerLayout "Default Layout"
(**) |-->Screen "Default Screen" (0)
(**) |   |-->Monitor "LCD2080UXi"
(**) |   |-->Device "ATI Technologies Inc RV280 [Radeon 9200]"
(**) |-->Input Device "Generic Keyboard"
(**) |-->Input Device "Configured Mouse"
(WW) The directory "/usr/share/fonts/X11/cyrillic" does not exist.
	Entry deleted from font path.
(WW) The directory "/var/lib/defoma/x-ttcidfont-conf.d/dirs/TrueType" does not exist.
	Entry deleted from font path.
(==) FontPath set to:
	/usr/share/fonts/X11/misc,
	/usr/share/fonts/X11/100dpi/:unscaled,
	/usr/share/fonts/X11/75dpi/:unscaled,
	/usr/share/fonts/X11/Type1,
	/usr/share/fonts/X11/100dpi,
	/usr/share/fonts/X11/75dpi
(==) RgbPath set to "/etc/X11/rgb"
(==) ModulePath set to "/usr/lib/xorg/modules"
(II) No APM support in BIOS or kernel
(II) Loader magic: 0x101f9688
(II) Module ABI versions:
	X.Org ANSI C Emulation: 0.3
	X.Org Video Driver: 1.2
	X.Org XInput driver : 0.7
	X.Org Server Extension : 0.3
	X.Org Font Renderer : 0.5
(II) Loader running on linux
(II) LoadModule: "pcidata"
(II) Loading /usr/lib/xorg/modules//libpcidata.so
(II) Module pcidata: vendor="X.Org Foundation"
	compiled for 1.3.0, module version = 1.0.0
	ABI class: X.Org Video Driver, version 1.2
(++) using VT number 7

(II) PCI: PCI scan (all values are in hex)
(II) PCI: 00:00:0: chip 10cc,0660 card 0000,0000 rev 01 class 06,00,00 hdr 00
(II) PCI: 00:01:0: chip 10cc,0661 card 0000,0000 rev 00 class 06,04,00 hdr 01
(II) PCI: 00:06:0: chip 10b7,9200 card 10b7,1000 rev 78 class 02,00,00 hdr 00
(II) PCI: 00:07:0: chip 1106,0686 card 0000,0000 rev 40 class 06,01,00 hdr 80
(II) PCI: 00:07:1: chip 1106,0571 card 0000,0000 rev 06 class 01,01,8a hdr 00
(II) PCI: 00:07:2: chip 1106,3038 card 0925,1234 rev 1a class 0c,03,00 hdr 00
(II) PCI: 00:07:3: chip 1106,3038 card 0925,1234 rev 1a class 0c,03,00 hdr 00
(II) PCI: 00:07:4: chip 1106,3057 card 0000,0000 rev 40 class 00,00,00 hdr 00
(II) PCI: 00:07:5: chip 1106,3058 card 0000,0000 rev 50 class 04,01,00 hdr 00
(II) PCI: 00:07:6: chip 1106,3068 card 0000,0000 rev 30 class 07,80,00 hdr 00
(II) PCI: 00:08:0: chip 109e,036e card 0070,13eb rev 11 class 04,00,00 hdr 80
(II) PCI: 00:08:1: chip 109e,0878 card 0070,13eb rev 11 class 04,80,00 hdr 80
(II) PCI: 00:09:0: chip 1102,0002 card 1102,8067 rev 0a class 04,01,00 hdr 80
(II) PCI: 00:09:1: chip 1102,7002 card 1102,0020 rev 0a class 09,80,00 hdr 80
(II) PCI: 00:0a:0: chip 10b9,5237 card 10b9,5272 rev 03 class 0c,03,10 hdr 80
(II) PCI: 00:0a:1: chip 10b9,5237 card 10b9,5272 rev 03 class 0c,03,10 hdr 80
(II) PCI: 00:0a:2: chip 10b9,5237 card 10b9,5272 rev 03 class 0c,03,10 hdr 80
(II) PCI: 00:0a:3: chip 10b9,5239 card 10b9,5272 rev 01 class 0c,03,20 hdr 80
(II) PCI: 00:0a:4: chip 10b9,5253 card 10b9,5253 rev 00 class 0c,00,10 hdr 80
(II) PCI: 01:00:0: chip 1002,5961 card 174b,7c13 rev 01 class 03,00,00 hdr 80
(II) PCI: 01:00:1: chip 1002,5941 card 174b,7c12 rev 01 class 03,80,00 hdr 00
(II) PCI: End of PCI scan
(II) Host-to-PCI bridge:
(II) Bus 0: bridge is at (0:0:0), (0,0,1), BCTRL: 0x0008 (VGA_EN is set)
(II) Bus 0 I/O range:
	[0] -1	0	0x00000000 - 0x0000ffff (0x10000) IX[B]
(II) Bus 0 non-prefetchable memory range:
	[0] -1	0	0x00000000 - 0xffffffff (0x0) MX[B]
(II) Bus 0 prefetchable memory range:
	[0] -1	0	0x00000000 - 0xffffffff (0x0) MX[B]
(II) PCI-to-PCI bridge:
(II) Bus 1: bridge is at (0:1:0), (0,1,1), BCTRL: 0x001c (VGA_EN is set)
(II) Bus 1 non-prefetchable memory range:
	[0] -1	0	0x88000000 - 0x880fffff (0x100000) MX[B]
(II) Bus 1 prefetchable memory range:
	[0] -1	0	0x80000000 - 0x87ffffff (0x8000000) MX[B]
(II) PCI-to-ISA bridge:
(II) Bus -1: bridge is at (0:7:0), (0,-1,-1), BCTRL: 0x0008 (VGA_EN is set)
(--) PCI: (0:8:0) Brooktree Corporation Bt878 Video Capture rev 17, Mem @ 0x98101000/12
(--) PCI:*(1:0:0) ATI Technologies Inc RV280 [Radeon 9200] rev 1, Mem @ 0x80000000/27, 0x88000000/16, I/O @ 0x2000/8, BIOS @ 0x88020000/17
(--) PCI: (1:0:1) ATI Technologies Inc RV280 [Radeon 9200] (Secondary) rev 1, Mem @ 0x90000000/0, 0x88010000/16
(II) Addressable bus resource ranges are
	[0] -1	0	0x00000000 - 0xffffffff (0x0) MX[B]
	[1] -1	0	0x00000000 - 0x0000ffff (0x10000) IX[B]
(II) OS-reported resource ranges:
	[0] -1	0	0x00100000 - 0x3fffffff (0x3ff00000) MX[B]E(B)
	[1] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[2] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[3] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[4] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[5] -1	0	0x00000000 - 0x000000ff (0x100) IX[B]
(II) Active PCI resource ranges:
	[0] -1	0	0x98106800 - 0x98106fff (0x800) MX[B]
	[1] -1	0	0x98106000 - 0x981060ff (0x100) MX[B]
	[2] -1	0	0x98105000 - 0x98105fff (0x1000) MX[B]
	[3] -1	0	0x98104000 - 0x98104fff (0x1000) MX[B]
	[4] -1	0	0x98103000 - 0x98103fff (0x1000) MX[B]
	[5] -1	0	0x98102000 - 0x98102fff (0x1000) MX[B]
	[6] -1	0	0x98100000 - 0x9810007f (0x80) MX[B]
	[7] -1	0	0x88010000 - 0x8801ffff (0x10000) MX[B](B)
	[8] -1	0	0x90000000 - 0x90000000 (0x1) MX[B](B)
	[9] -1	0	0x88020000 - 0x8803ffff (0x20000) MX[B](B)
	[10] -1	0	0x88000000 - 0x8800ffff (0x10000) MX[B](B)
	[11] -1	0	0x80000000 - 0x87ffffff (0x8000000) MX[B](B)
	[12] -1	0	0x98101000 - 0x98101fff (0x1000) MX[B](B)
	[13] -1	0	0xfe802420 - 0xfe802427 (0x8) IX[B]
	[14] -1	0	0xfe802400 - 0xfe80241f (0x20) IX[B]
	[15] -1	0	0xfe802300 - 0xfe8023ff (0x100) IX[B]
	[16] -1	0	0xfe802204 - 0xfe802207 (0x4) IX[B]
	[17] -1	0	0xfe802200 - 0xfe802203 (0x4) IX[B]
	[18] -1	0	0xfe802100 - 0xfe8021ff (0x100) IX[B]
	[19] -1	0	0xfe8020a0 - 0xfe8020bf (0x20) IX[B]
	[20] -1	0	0xfe802080 - 0xfe80209f (0x20) IX[B]
	[21] -1	0	0xfe00cc00 - 0xfe00cc0f (0x10) IX[B]
	[22] -1	0	0xfe802000 - 0xfe80207f (0x80) IX[B]
	[23] -1	0	0xfe002000 - 0xfe0020ff (0x100) IX[B](B)
(II) Active PCI resource ranges after removing overlaps:
	[0] -1	0	0x98106800 - 0x98106fff (0x800) MX[B]
	[1] -1	0	0x98106000 - 0x981060ff (0x100) MX[B]
	[2] -1	0	0x98105000 - 0x98105fff (0x1000) MX[B]
	[3] -1	0	0x98104000 - 0x98104fff (0x1000) MX[B]
	[4] -1	0	0x98103000 - 0x98103fff (0x1000) MX[B]
	[5] -1	0	0x98102000 - 0x98102fff (0x1000) MX[B]
	[6] -1	0	0x98100000 - 0x9810007f (0x80) MX[B]
	[7] -1	0	0x88010000 - 0x8801ffff (0x10000) MX[B](B)
	[8] -1	0	0x90000000 - 0x90000000 (0x1) MX[B](B)
	[9] -1	0	0x88020000 - 0x8803ffff (0x20000) MX[B](B)
	[10] -1	0	0x88000000 - 0x8800ffff (0x10000) MX[B](B)
	[11] -1	0	0x80000000 - 0x87ffffff (0x8000000) MX[B](B)
	[12] -1	0	0x98101000 - 0x98101fff (0x1000) MX[B](B)
	[13] -1	0	0xfe802420 - 0xfe802427 (0x8) IX[B]
	[14] -1	0	0xfe802400 - 0xfe80241f (0x20) IX[B]
	[15] -1	0	0xfe802300 - 0xfe8023ff (0x100) IX[B]
	[16] -1	0	0xfe802204 - 0xfe802207 (0x4) IX[B]
	[17] -1	0	0xfe802200 - 0xfe802203 (0x4) IX[B]
	[18] -1	0	0xfe802100 - 0xfe8021ff (0x100) IX[B]
	[19] -1	0	0xfe8020a0 - 0xfe8020bf (0x20) IX[B]
	[20] -1	0	0xfe802080 - 0xfe80209f (0x20) IX[B]
	[21] -1	0	0xfe00cc00 - 0xfe00cc0f (0x10) IX[B]
	[22] -1	0	0xfe802000 - 0xfe80207f (0x80) IX[B]
	[23] -1	0	0xfe002000 - 0xfe0020ff (0x100) IX[B](B)
(II) OS-reported resource ranges after removing overlaps with PCI:
	[0] -1	0	0x00100000 - 0x3fffffff (0x3ff00000) MX[B]E(B)
	[1] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[2] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[3] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[4] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[5] -1	0	0x00000000 - 0x000000ff (0x100) IX[B]
(II) All system resource ranges:
	[0] -1	0	0x00100000 - 0x3fffffff (0x3ff00000) MX[B]E(B)
	[1] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[2] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[3] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[4] -1	0	0x98106800 - 0x98106fff (0x800) MX[B]
	[5] -1	0	0x98106000 - 0x981060ff (0x100) MX[B]
	[6] -1	0	0x98105000 - 0x98105fff (0x1000) MX[B]
	[7] -1	0	0x98104000 - 0x98104fff (0x1000) MX[B]
	[8] -1	0	0x98103000 - 0x98103fff (0x1000) MX[B]
	[9] -1	0	0x98102000 - 0x98102fff (0x1000) MX[B]
	[10] -1	0	0x98100000 - 0x9810007f (0x80) MX[B]
	[11] -1	0	0x88010000 - 0x8801ffff (0x10000) MX[B](B)
	[12] -1	0	0x90000000 - 0x90000000 (0x1) MX[B](B)
	[13] -1	0	0x88020000 - 0x8803ffff (0x20000) MX[B](B)
	[14] -1	0	0x88000000 - 0x8800ffff (0x10000) MX[B](B)
	[15] -1	0	0x80000000 - 0x87ffffff (0x8000000) MX[B](B)
	[16] -1	0	0x98101000 - 0x98101fff (0x1000) MX[B](B)
	[17] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[18] -1	0	0x00000000 - 0x000000ff (0x100) IX[B]
	[19] -1	0	0xfe802420 - 0xfe802427 (0x8) IX[B]
	[20] -1	0	0xfe802400 - 0xfe80241f (0x20) IX[B]
	[21] -1	0	0xfe802300 - 0xfe8023ff (0x100) IX[B]
	[22] -1	0	0xfe802204 - 0xfe802207 (0x4) IX[B]
	[23] -1	0	0xfe802200 - 0xfe802203 (0x4) IX[B]
	[24] -1	0	0xfe802100 - 0xfe8021ff (0x100) IX[B]
	[25] -1	0	0xfe8020a0 - 0xfe8020bf (0x20) IX[B]
	[26] -1	0	0xfe802080 - 0xfe80209f (0x20) IX[B]
	[27] -1	0	0xfe00cc00 - 0xfe00cc0f (0x10) IX[B]
	[28] -1	0	0xfe802000 - 0xfe80207f (0x80) IX[B]
	[29] -1	0	0xfe002000 - 0xfe0020ff (0x100) IX[B](B)
(II) LoadModule: "extmod"
(II) Loading /usr/lib/xorg/modules/extensions//libextmod.so
(II) Module extmod: vendor="X.Org Foundation"
	compiled for 1.3.0, module version = 1.0.0
	Module class: X.Org Server Extension
	ABI class: X.Org Server Extension, version 0.3
(II) Loading extension SHAPE
(II) Loading extension MIT-SUNDRY-NONSTANDARD
(II) Loading extension BIG-REQUESTS
(II) Loading extension SYNC
(II) Loading extension MIT-SCREEN-SAVER
(II) Loading extension XC-MISC
(II) Loading extension XFree86-VidModeExtension
(II) Loading extension XFree86-Misc
(II) Loading extension XFree86-DGA
(II) Loading extension DPMS
(II) Loading extension TOG-CUP
(II) Loading extension Extended-Visual-Information
(II) Loading extension XVideo
(II) Loading extension XVideo-MotionCompensation
(II) Loading extension X-Resource
(II) LoadModule: "dbe"
(II) Loading /usr/lib/xorg/modules/extensions//libdbe.so
(II) Module dbe: vendor="X.Org Foundation"
	compiled for 1.3.0, module version = 1.0.0
	Module class: X.Org Server Extension
	ABI class: X.Org Server Extension, version 0.3
(II) Loading extension DOUBLE-BUFFER
(II) LoadModule: "glx"
(II) Loading /usr/lib/xorg/modules/extensions//libglx.so
(II) Module glx: vendor="X.Org Foundation"
	compiled for 1.3.0, module version = 1.0.0
	ABI class: X.Org Server Extension, version 0.3
(==) AIGLX enabled
(II) Loading extension GLX
(II) LoadModule: "freetype"
(II) Loading /usr/lib/xorg/modules//fonts/libfreetype.so
(II) Module freetype: vendor="X.Org Foundation & the After X-TT Project"
	compiled for 1.3.0, module version = 2.1.0
	Module class: X.Org Font Renderer
	ABI class: X.Org Font Renderer, version 0.5
(II) Loading font FreeType
(II) LoadModule: "record"
(II) Loading /usr/lib/xorg/modules/extensions//librecord.so
(II) Module record: vendor="X.Org Foundation"
	compiled for 1.3.0, module version = 1.13.0
	Module class: X.Org Server Extension
	ABI class: X.Org Server Extension, version 0.3
(II) Loading extension RECORD
(II) LoadModule: "dri"
(II) Loading /usr/lib/xorg/modules/extensions//libdri.so
(II) Module dri: vendor="X.Org Foundation"
	compiled for 1.3.0, module version = 1.0.0
	ABI class: X.Org Server Extension, version 0.3
(II) Loading extension XFree86-DRI
(II) LoadModule: "ati"
(II) Loading /usr/lib/xorg/modules/drivers//ati_drv.so
(II) Module ati: vendor="X.Org Foundation"
	compiled for 7.1.1, module version = 6.6.3
	Module class: X.Org Video Driver
	ABI class: X.Org Video Driver, version 1.0
(II) LoadModule: "kbd"
(II) Loading /usr/lib/xorg/modules/input//kbd_drv.so
(II) Module kbd: vendor="X.Org Foundation"
	compiled for 1.3.0, module version = 1.2.1
	Module class: X.Org XInput Driver
	ABI class: X.Org XInput driver, version 0.7
(II) LoadModule: "mouse"
(II) Loading /usr/lib/xorg/modules/input//mouse_drv.so
(II) Module mouse: vendor="X.Org Foundation"
	compiled for 1.3.0, module version = 1.2.2
	Module class: X.Org XInput Driver
	ABI class: X.Org XInput driver, version 0.7
(II) ATI: ATI driver (version 6.6.3) for chipset: ati
(II) R128: Driver for ATI Rage 128 chipsets:
	ATI Rage 128 Mobility M3 LE (PCI), ATI Rage 128 Mobility M3 LF (AGP),
	ATI Rage 128 Mobility M4 MF (AGP), ATI Rage 128 Mobility M4 ML (AGP),
	ATI Rage 128 Pro GL PA (AGP?), ATI Rage 128 Pro GL PB (AGP?),
	ATI Rage 128 Pro GL PC (AGP?), ATI Rage 128 Pro GL PD (PCI),
	ATI Rage 128 Pro GL PE (AGP?), ATI Rage 128 Pro GL PF (AGP),
	ATI Rage 128 Pro VR PG (AGP?), ATI Rage 128 Pro VR PH (AGP?),
	ATI Rage 128 Pro VR PI (AGP?), ATI Rage 128 Pro VR PJ (AGP?),
	ATI Rage 128 Pro VR PK (AGP?), ATI Rage 128 Pro VR PL (AGP?),
	ATI Rage 128 Pro VR PM (AGP?), ATI Rage 128 Pro VR PN (AGP?),
	ATI Rage 128 Pro VR PO (AGP?), ATI Rage 128 Pro VR PP (PCI),
	ATI Rage 128 Pro VR PQ (AGP?), ATI Rage 128 Pro VR PR (PCI),
	ATI Rage 128 Pro VR PS (AGP?), ATI Rage 128 Pro VR PT (AGP?),
	ATI Rage 128 Pro VR PU (AGP?), ATI Rage 128 Pro VR PV (AGP?),
	ATI Rage 128 Pro VR PW (AGP?), ATI Rage 128 Pro VR PX (AGP?),
	ATI Rage 128 GL RE (PCI), ATI Rage 128 GL RF (AGP),
	ATI Rage 128 RG (AGP), ATI Rage 128 VR RK (PCI),
	ATI Rage 128 VR RL (AGP), ATI Rage 128 4X SE (AGP?),
	ATI Rage 128 4X SF (AGP?), ATI Rage 128 4X SG (AGP?),
	ATI Rage 128 4X SH (AGP?), ATI Rage 128 4X SK (AGP?),
	ATI Rage 128 4X SL (AGP?), ATI Rage 128 4X SM (AGP),
	ATI Rage 128 4X SN (AGP?), ATI Rage 128 Pro ULTRA TF (AGP),
	ATI Rage 128 Pro ULTRA TL (AGP), ATI Rage 128 Pro ULTRA TR (AGP),
	ATI Rage 128 Pro ULTRA TS (AGP?), ATI Rage 128 Pro ULTRA TT (AGP?),
	ATI Rage 128 Pro ULTRA TU (AGP?)
(II) RADEON: Driver for ATI Radeon chipsets: ATI Radeon QD (AGP),
	ATI Radeon QE (AGP), ATI Radeon QF (AGP), ATI Radeon QG (AGP),
	ATI Radeon VE/7000 QY (AGP/PCI), ATI Radeon VE/7000 QZ (AGP/PCI),
	ATI ES1000 515E (PCI), ATI ES1000 5969 (PCI),
	ATI Radeon Mobility M7 LW (AGP),
	ATI Mobility FireGL 7800 M7 LX (AGP),
	ATI Radeon Mobility M6 LY (AGP), ATI Radeon Mobility M6 LZ (AGP),
	ATI Radeon IGP320 (A3) 4136, ATI Radeon IGP320M (U1) 4336,
	ATI Radeon IGP330/340/350 (A4) 4137,
	ATI Radeon IGP330M/340M/350M (U2) 4337,
	ATI Radeon 7000 IGP (A4+) 4237, ATI Radeon Mobility 7000 IGP 4437,
	ATI FireGL 8700/8800 QH (AGP), ATI Radeon 8500 QL (AGP),
	ATI Radeon 9100 QM (AGP), ATI Radeon 8500 AIW BB (AGP),
	ATI Radeon 8500 AIW BC (AGP), ATI Radeon 7500 QW (AGP/PCI),
	ATI Radeon 7500 QX (AGP/PCI), ATI Radeon 9000/PRO If (AGP/PCI),
	ATI Radeon 9000 Ig (AGP/PCI), ATI FireGL Mobility 9000 (M9) Ld (AGP),
	ATI Radeon Mobility 9000 (M9) Lf (AGP),
	ATI Radeon Mobility 9000 (M9) Lg (AGP),
	ATI Radeon 9100 IGP (A5) 5834,
	ATI Radeon Mobility 9100 IGP (U3) 5835, ATI Radeon 9100 PRO IGP 7834,
	ATI Radeon Mobility 9200 IGP 7835, ATI Radeon 9250 5960 (AGP),
	ATI Radeon 9200 5961 (AGP), ATI Radeon 9200 5962 (AGP),
	ATI Radeon 9200SE 5964 (AGP), ATI FireMV 2200 (PCI),
	ATI Radeon Mobility 9200 (M9+) 5C61 (AGP),
	ATI Radeon Mobility 9200 (M9+) 5C63 (AGP), ATI Radeon 9500 AD (AGP),
	ATI Radeon 9500 AE (AGP), ATI Radeon 9600TX AF (AGP),
	ATI FireGL Z1 AG (AGP), ATI Radeon 9700 Pro ND (AGP),
	ATI Radeon 9700/9500Pro NE (AGP), ATI Radeon 9600TX NF (AGP),
	ATI FireGL X1 NG (AGP), ATI Radeon 9600 AP (AGP),
	ATI Radeon 9600SE AQ (AGP), ATI Radeon 9600XT AR (AGP),
	ATI Radeon 9600 AS (AGP), ATI FireGL T2 AT (AGP),
	ATI FireGL RV360 AV (AGP),
	ATI Radeon Mobility 9600/9700 (M10/M11) NP (AGP),
	ATI Radeon Mobility 9600 (M10) NQ (AGP),
	ATI Radeon Mobility 9600 (M11) NR (AGP),
	ATI Radeon Mobility 9600 (M10) NS (AGP),
	ATI FireGL Mobility T2 (M10) NT (AGP),
	ATI FireGL Mobility T2e (M11) NV (AGP), ATI Radeon 9650,
	ATI Radeon 9800SE AH (AGP), ATI Radeon 9800 AI (AGP),
	ATI Radeon 9800 AJ (AGP), ATI FireGL X2 AK (AGP),
	ATI Radeon 9800PRO NH (AGP), ATI Radeon 9800 NI (AGP),
	ATI FireGL X2 NK (AGP), ATI Radeon 9800XT NJ (AGP),
	ATI Radeon X600 (RV380) 3E50 (PCIE),
	ATI FireGL V3200 (RV380) 3E54 (PCIE),
	ATI Radeon Mobility X600 (M24) 3150 (PCIE),
	ATI Radeon Mobility X300 (M24) 3152 (PCIE),
	ATI FireGL M24 GL 3154 (PCIE), ATI Radeon X300 (RV370) 5B60 (PCIE),
	ATI Radeon X600 (RV370) 5B62 (PCIE),
	ATI Radeon X550 (RV370) 5B63 (PCIE),
	ATI FireGL V3100 (RV370) 5B64 (PCIE),
	ATI FireMV 2200 PCIE (RV370) 5B65 (PCIE),
	ATI Radeon Mobility X300 (M22) 5460 (PCIE),
	ATI Radeon Mobility X600 SE (M24C) 5462 (PCIE),
	ATI FireGL M22 GL 5464 (PCIE), ATI Radeon XPRESS 200 5A41 (PCIE),
	ATI Radeon XPRESS 200M 5A42 (PCIE),
	ATI Radeon XPRESS 200 5A61 (PCIE),
	ATI Radeon XPRESS 200M 5A62 (PCIE),
	ATI Radeon XPRESS 200 5954 (PCIE),
	ATI Radeon XPRESS 200M 5955 (PCIE),
	ATI Radeon XPRESS 200 5974 (PCIE),
	ATI Radeon XPRESS 200M 5975 (PCIE), ATI FireGL V5000 (RV410) (PCIE),
	ATI Mobility FireGL V5000 (M26) (PCIE),
	ATI Mobility FireGL V5000 (M26) (PCIE),
	ATI Mobility Radeon X700 XL (M26) (PCIE),
	ATI Mobility Radeon X700 (M26) (PCIE),
	ATI Mobility Radeon X700 (M26) (PCIE),
	ATI Radeon X700 PRO (RV410) (PCIE),
	ATI Radeon X700 XT (RV410) (PCIE), ATI Radeon X700 (RV410) (PCIE),
	ATI Radeon X700 SE (RV410) (PCIE), ATI Radeon X700 SE (RV410) (PCIE),
	ATI Radeon X800 (R420) JH (AGP), ATI Radeon X800PRO (R420) JI (AGP),
	ATI Radeon X800SE (R420) JJ (AGP), ATI Radeon X800 (R420) JK (AGP),
	ATI Radeon X800 (R420) JL (AGP), ATI FireGL X3 (R420) JM (AGP),
	ATI Radeon Mobility 9800 (M18) JN (AGP),
	ATI Radeon X800XT (R420) JP (AGP), ATI Radeon X800 SE (R420) (AGP),
	ATI Radeon AIW X800 VE (R420) JT (AGP),
	ATI Radeon X800 (R423) UH (PCIE),
	ATI Radeon X800PRO (R423) UI (PCIE),
	ATI Radeon X800LE (R423) UJ (PCIE),
	ATI Radeon X800SE (R423) UK (PCIE),
	ATI FireGL V5100 (R423) UQ (PCIE),
	ATI FireGL unknown (R423) UR (PCIE),
	ATI FireGL unknown (R423) UT (PCIE),
	ATI Radeon X800XT (R423) 5D57 (PCIE), ATI FireGL V7100 (R423) (PCIE),
	ATI Mobility FireGL V5100 (M28) (PCIE),
	ATI Mobility Radeon X800 (M28) (PCIE),
	ATI Mobility Radeon X800 XT (M28) (PCIE),
	ATI Radeon X800 (R430) (PCIE), ATI Radeon X800 XL (R430) (PCIE),
	ATI Radeon X800 SE (R430) (PCIE), ATI Radeon X800 XTP (R430) (PCIE),
	ATI Radeon X850 5D4C (PCIE),
	ATI unknown Radeon / FireGL (R480) 5D50 (PCIE),
	ATI Radeon X850 SE (R480) (PCIE), ATI Radeon X850 PRO (R480) (PCIE),
	ATI Radeon X850 XT (R480) (PCIE),
	ATI Radeon X850 XT PE (R480) (PCIE),
	ATI Radeon X850 PRO (R480) (AGP), ATI Radeon X850 SE (R480) (AGP),
	ATI Radeon X850 XT (R480) (AGP), ATI Radeon X850 XT PE (R480) (AGP)
(II) Primary Device is: PCI 01:00:0
(II) ATI:  Candidate "Device" section "ATI Technologies Inc RV280 [Radeon 9200]".
(WW) RADEON: No matching Device section for instance (BusID PCI:1:0:1) found
(--) Chipset ATI Radeon 9200 5961 (AGP) found
(II) resource ranges after xf86ClaimFixedResources() call:
	[0] -1	0	0x00100000 - 0x3fffffff (0x3ff00000) MX[B]E(B)
	[1] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[2] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[3] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[4] -1	0	0x98106800 - 0x98106fff (0x800) MX[B]
	[5] -1	0	0x98106000 - 0x981060ff (0x100) MX[B]
	[6] -1	0	0x98105000 - 0x98105fff (0x1000) MX[B]
	[7] -1	0	0x98104000 - 0x98104fff (0x1000) MX[B]
	[8] -1	0	0x98103000 - 0x98103fff (0x1000) MX[B]
	[9] -1	0	0x98102000 - 0x98102fff (0x1000) MX[B]
	[10] -1	0	0x98100000 - 0x9810007f (0x80) MX[B]
	[11] -1	0	0x88010000 - 0x8801ffff (0x10000) MX[B](B)
	[12] -1	0	0x90000000 - 0x90000000 (0x1) MX[B](B)
	[13] -1	0	0x88020000 - 0x8803ffff (0x20000) MX[B](B)
	[14] -1	0	0x88000000 - 0x8800ffff (0x10000) MX[B](B)
	[15] -1	0	0x80000000 - 0x87ffffff (0x8000000) MX[B](B)
	[16] -1	0	0x98101000 - 0x98101fff (0x1000) MX[B](B)
	[17] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[18] -1	0	0x00000000 - 0x000000ff (0x100) IX[B]
	[19] -1	0	0xfe802420 - 0xfe802427 (0x8) IX[B]
	[20] -1	0	0xfe802400 - 0xfe80241f (0x20) IX[B]
	[21] -1	0	0xfe802300 - 0xfe8023ff (0x100) IX[B]
	[22] -1	0	0xfe802204 - 0xfe802207 (0x4) IX[B]
	[23] -1	0	0xfe802200 - 0xfe802203 (0x4) IX[B]
	[24] -1	0	0xfe802100 - 0xfe8021ff (0x100) IX[B]
	[25] -1	0	0xfe8020a0 - 0xfe8020bf (0x20) IX[B]
	[26] -1	0	0xfe802080 - 0xfe80209f (0x20) IX[B]
	[27] -1	0	0xfe00cc00 - 0xfe00cc0f (0x10) IX[B]
	[28] -1	0	0xfe802000 - 0xfe80207f (0x80) IX[B]
	[29] -1	0	0xfe002000 - 0xfe0020ff (0x100) IX[B](B)
(II) Loading sub module "radeon"
(II) LoadModule: "radeon"
(II) Loading /usr/lib/xorg/modules/drivers//radeon_drv.so
(II) Module radeon: vendor="X.Org Foundation"
	compiled for 7.1.1, module version = 4.2.0
	Module class: X.Org Video Driver
	ABI class: X.Org Video Driver, version 1.0
(WW) ****INVALID IO ALLOCATION**** b: 0xfe002000 e: 0xfe0020ff correcting
(EE) end of block range 0xfdffffff < begin 0xfe000000
(II) window:
	[0] -1	0	0x00000000 - 0xffffffff (0x0) MX[B]
	[1] -1	0	0x00000000 - 0x0000ffff (0x10000) IX[B]
(II) resSize:
(II) window fixed:
	[0] -1	0	0x00000000 - 0xffffffff (0x0) MX[B]
	[1] -1	0	0x00000000 - 0x0000ffff (0x10000) IX[B]
(II) resource ranges after probing:
	[0] -1	0	0x00100000 - 0x3fffffff (0x3ff00000) MX[B]E(B)
	[1] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[2] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[3] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[4] -1	0	0x98106800 - 0x98106fff (0x800) MX[B]
	[5] -1	0	0x98106000 - 0x981060ff (0x100) MX[B]
	[6] -1	0	0x98105000 - 0x98105fff (0x1000) MX[B]
	[7] -1	0	0x98104000 - 0x98104fff (0x1000) MX[B]
	[8] -1	0	0x98103000 - 0x98103fff (0x1000) MX[B]
	[9] -1	0	0x98102000 - 0x98102fff (0x1000) MX[B]
	[10] -1	0	0x98100000 - 0x9810007f (0x80) MX[B]
	[11] -1	0	0x88010000 - 0x8801ffff (0x10000) MX[B](B)
	[12] -1	0	0x90000000 - 0x90000000 (0x1) MX[B](B)
	[13] -1	0	0x88020000 - 0x8803ffff (0x20000) MX[B](B)
	[14] -1	0	0x88000000 - 0x8800ffff (0x10000) MX[B](B)
	[15] -1	0	0x80000000 - 0x87ffffff (0x8000000) MX[B](B)
	[16] -1	0	0x98101000 - 0x98101fff (0x1000) MX[B](B)
	[17] 0	0	0x000a0000 - 0x000affff (0x10000) MS[B]
	[18] 0	0	0x000b0000 - 0x000b7fff (0x8000) MS[B]
	[19] 0	0	0x000b8000 - 0x000bffff (0x8000) MS[B]
	[20] -1	0	0x00000400 - 0x000004ff (0x100) IX[B](B)
	[21] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[22] -1	0	0x00000000 - 0x000000ff (0x100) IX[B]
	[23] -1	0	0xfe802420 - 0xfe802427 (0x8) IX[B]
	[24] -1	0	0xfe802400 - 0xfe80241f (0x20) IX[B]
	[25] -1	0	0xfe802300 - 0xfe8023ff (0x100) IX[B]
	[26] -1	0	0xfe802204 - 0xfe802207 (0x4) IX[B]
	[27] -1	0	0xfe802200 - 0xfe802203 (0x4) IX[B]
	[28] -1	0	0xfe802100 - 0xfe8021ff (0x100) IX[B]
	[29] -1	0	0xfe8020a0 - 0xfe8020bf (0x20) IX[B]
	[30] -1	0	0xfe802080 - 0xfe80209f (0x20) IX[B]
	[31] -1	0	0xfe00cc00 - 0xfe00cc0f (0x10) IX[B]
	[32] -1	0	0xfe802000 - 0xfe80207f (0x80) IX[B]
	[33] 0	0	0xfe0003b0 - 0xfe0003bb (0xc) IS[B]
	[34] 0	0	0xfe0003c0 - 0xfe0003df (0x20) IS[B]
(II) Setting vga for screen 0.
(**) RADEON(0): RADEONPreInit
(II) RADEON(0): MMIO registers at 0x88000000: size 64KB
(II) RADEON(0): PCI bus 1 card 0 func 0
(**) RADEON(0): Depth 24, (--) framebuffer bpp 32
(II) RADEON(0): Pixel depth = 24 bits stored in 4 bytes (32 bpp pixmaps)
(==) RADEON(0): Default visual is TrueColor
(**) RADEON(0): Option "BusType" "PCI"
(**) RADEON(0): Option "AccelMethod" "EXA"
(II) RADEON(0): VGAAccess option set to FALSE, VGA module load skipped
(==) RADEON(0): RGB weight 888
(II) RADEON(0): Using 8 bits per RGB (8 bit DAC)
(==) RADEON(0): X server will not keep DPI constant for all screen sizes
(--) RADEON(0): Chipset: "ATI Radeon 9200 5961 (AGP)" (ChipID = 0x5961)
(--) RADEON(0): Linear framebuffer at 0x80000000
(--) RADEON(0): BIOS at 0x88020000
(II) RADEON(0): AGP card detected
(**) RADEON(0): Forced into PCI mode
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: open result is 5, (OK)
drmOpenByBusid: Searching for BusID pci:0000:01:00.0
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: open result is 5, (OK)
drmOpenByBusid: drmOpenMinor returns 5
drmOpenByBusid: drmGetBusid reports pci:0000:01:00.0
(II) RADEON(0): [dri] Found DRI library version 1.3.0 and kernel module version 1.28.0
(II) Loading sub module "shadowfb"
(II) LoadModule: "shadowfb"
(II) Loading /usr/lib/xorg/modules//libshadowfb.so
(II) Module shadowfb: vendor="X.Org Foundation"
	compiled for 1.3.0, module version = 1.0.0
	ABI class: X.Org ANSI C Emulation, version 0.3
(II) RADEON(0): Page flipping disabled
(II) RADEON(0): Will try to use DMA for Xv image transfers
(II) RADEON(0): Generation 2 PCI interface, using max accessible memory
(II) RADEON(0): Detected total video RAM=131072K, accessible=131072K (PCI BAR=131072K)
(--) RADEON(0): Mapped VideoRAM: 131072 kByte (128 bit DDR SDRAM)
(II) RADEON(0): Color tiling enabled by default
(II) Loading sub module "ddc"
(II) LoadModule: "ddc"(II) Module already built-in
(II) Loading sub module "i2c"
(II) LoadModule: "i2c"(II) Module already built-in
(II) RADEON(0): I2C bus "DDC" initialized.
(II) Attempted to read BIOS 64KB from /sys/bus/pci/devices/0000:01:00.0/rom: got 52KB
(II) RADEON(0): Legacy BIOS detected
(II) RADEON(0): Connector0: DDCType-2, DACType-1, TMDSType-0, ConnectorType-3
(II) RADEON(0): Connector1: DDCType-3, DACType-0, TMDSType--1, ConnectorType-2
(II) RADEON(0): I2C device "DDC:ddc2" registered at address 0xA0.
(II) RADEON(0): I2C device "DDC:ddc2" removed.
(II) RADEON(0): DDC Type: 2, Detected Type: 3
(II) RADEON(0): I2C device "DDC:ddc2" registered at address 0xA0.
(II) RADEON(0): I2C device "DDC:ddc2" removed.
(II) RADEON(0): I2C device "DDC:ddc2" registered at address 0xA0.
(II) RADEON(0): I2C device "DDC:ddc2" removed.
(II) RADEON(0): I2C device "DDC:ddc2" registered at address 0xA0.
(II) RADEON(0): I2C device "DDC:ddc2" removed.
(II) RADEON(0): DDC Type: 3, Detected Type: 0
(II) RADEON(0): EDID data from the display on port 1 ----------------------
(II) RADEON(0): Manufacturer: NEC  Model: 669a  Serial#: 16843009
(II) RADEON(0): Year: 2005  Week: 44
(II) RADEON(0): EDID Version: 1.3
(II) RADEON(0): Digital Display Input
(II) RADEON(0): Max H-Image Size [cm]: horiz.: 41  vert.: 31
(II) RADEON(0): Gamma: 2.20
(II) RADEON(0): DPMS capabilities: StandBy Suspend Off; RGB/Color Display
(II) RADEON(0): First detailed timing is preferred mode
(II) RADEON(0): redX: 0.639 redY: 0.342   greenX: 0.290 greenY: 0.615
(II) RADEON(0): blueX: 0.146 blueY: 0.072   whiteX: 0.313 whiteY: 0.329
(II) RADEON(0): Supported VESA Video Modes:
(II) RADEON(0): 720x400@70Hz
(II) RADEON(0): 640x480@60Hz
(II) RADEON(0): 640x480@67Hz
(II) RADEON(0): 640x480@72Hz
(II) RADEON(0): 640x480@75Hz
(II) RADEON(0): 800x600@56Hz
(II) RADEON(0): 800x600@60Hz
(II) RADEON(0): 800x600@72Hz
(II) RADEON(0): 800x600@75Hz
(II) RADEON(0): 832x624@75Hz
(II) RADEON(0): 1024x768@60Hz
(II) RADEON(0): 1024x768@70Hz
(II) RADEON(0): 1024x768@75Hz
(II) RADEON(0): 1280x1024@75Hz
(II) RADEON(0): 1152x870@75Hz
(II) RADEON(0): Manufacturer's mask: 0
(II) RADEON(0): Supported Future Video Modes:
(II) RADEON(0): #0: hsize: 640  vsize 480  refresh: 85  vid: 22833
(II) RADEON(0): #1: hsize: 800  vsize 600  refresh: 85  vid: 22853
(II) RADEON(0): #2: hsize: 1024  vsize 768  refresh: 85  vid: 22881
(II) RADEON(0): #3: hsize: 1152  vsize 864  refresh: 75  vid: 20337
(II) RADEON(0): #4: hsize: 1280  vsize 960  refresh: 85  vid: 22913
(II) RADEON(0): #5: hsize: 1280  vsize 1024  refresh: 85  vid: 39297
(II) RADEON(0): #6: hsize: 1600  vsize 1200  refresh: 60  vid: 16553
(II) RADEON(0): Supported additional Video Mode:
(II) RADEON(0): clock: 162.0 MHz   Image Size:  408 x 306 mm
(II) RADEON(0): h_active: 1600  h_sync: 1664  h_sync_end 1856 h_blank_end 2160 h_border: 0
(II) RADEON(0): v_active: 1200  v_sync: 1201  v_sync_end 1204 v_blanking: 1250 v_border: 0
(II) RADEON(0): Ranges: V min: 50  V max: 85 Hz, H min: 31  H max: 92 kHz, PixClock max 170 MHz
(II) RADEON(0): Monitor name: LCD2080UXi
(II) RADEON(0): Serial No: 5Y102473YB
(II) RADEON(0): EDID (in hex):
(II) RADEON(0): 	00ffffffffffff0038a39a6601010101
(II) RADEON(0): 	2c0f010380291f78eaa6a5a3574a9d25
(II) RADEON(0): 	125054bfef80315945596159714f8159
(II) RADEON(0): 	8199a9400101483f403062b0324040c0
(II) RADEON(0): 	130098321100001e000000fd0032551f
(II) RADEON(0): 	5c11000a202020202020000000fc004c
(II) RADEON(0): 	4344323038305558690a2020000000ff
(II) RADEON(0): 	00355931303234373359420a2020000b
(II) RADEON(0): 
(II) RADEON(0): Primary:
 Monitor   -- TMDS
 Connector -- DVI-I
 DAC Type  -- TVDAC/ExtDAC
 TMDS Type -- Internal
 DDC Type  -- DVI_DDC
(II) RADEON(0): Secondary:
 Monitor   -- CRT
 Connector -- VGA
 DAC Type  -- Primary
 TMDS Type -- NONE
 DDC Type  -- VGA_DDC
(II) RADEON(0): PLL parameters: rf=2700 rd=12 min=20000 max=40000; xclk=20000
(WW) RADEON(0): Failed to detect secondary monitor DDC, default HSync and VRefresh used
(==) RADEON(0): Using gamma correction (1.0, 1.0, 1.0)
(II) RADEON(0): Validating modes on Primary head ---------
(II) RADEON(0): DFP table revision: 4
(II) RADEON(0): Panel infos found from DDC detailed: 1600x1200
(II) RADEON(0): Valid Mode from Detailed timing table: 1600x1200
(II) RADEON(0): Valid Mode from standard timing table: 640x480
(II) RADEON(0): Valid Mode from standard timing table: 800x600
(II) RADEON(0): Valid Mode from standard timing table: 1024x768
(II) RADEON(0): Valid Mode from standard timing table: 1152x864
(II) RADEON(0): Valid Mode from standard timing table: 1280x960
(II) RADEON(0): Valid Mode from standard timing table: 1280x1024
(II) RADEON(0): Valid Mode from standard timing table: 1600x1200
(II) RADEON(0): Valid Mode from established timing table: 1280x1024
(II) RADEON(0): Valid Mode from established timing table: 1024x768
(II) RADEON(0): Valid Mode from established timing table: 1024x768
(II) RADEON(0): Valid Mode from established timing table: 1024x768
(II) RADEON(0): Valid Mode from established timing table: 832x624
(II) RADEON(0): Valid Mode from established timing table: 800x600
(II) RADEON(0): Valid Mode from established timing table: 800x600
(II) RADEON(0): Valid Mode from established timing table: 800x600
(II) RADEON(0): Valid Mode from established timing table: 800x600
(II) RADEON(0): Valid Mode from established timing table: 640x480
(II) RADEON(0): Valid Mode from established timing table: 640x480
(II) RADEON(0): Valid Mode from established timing table: 640x480
(II) RADEON(0): Total of 20 mode(s) found.
(II) RADEON(0): Total number of valid DDC mode(s) found: 20
(II) RADEON(0): Validating CRTC2 modes for MergedFB ------------ 
(II) RADEON(0): CRT2 Monitor: Using default hsync range of 31.50-37.90 kHz
(II) RADEON(0): CRT2 Monitor: Using default vrefresh range of 50.00-70.00 Hz
(II) RADEON(0): Clock range:  20.00 to 400.00 MHz
(II) RADEON(0): Not using default mode "640x350" (vrefresh out of range)
(II) RADEON(0): Not using default mode "320x175" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "640x400" (vrefresh out of range)
(II) RADEON(0): Not using default mode "320x200" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "720x400" (vrefresh out of range)
(II) RADEON(0): Not using default mode "360x200" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "640x480" (mode clock too high)
(II) RADEON(0): Not using default mode "320x240" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "640x480" (vrefresh out of range)
(II) RADEON(0): Not using default mode "320x240" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "640x480" (vrefresh out of range)
(II) RADEON(0): Not using default mode "320x240" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "640x480" (hsync out of range)
(II) RADEON(0): Not using default mode "320x240" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "800x600" (mode clock too high)
(II) RADEON(0): Not using default mode "400x300" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "800x600" (mode clock too high)
(II) RADEON(0): Not using default mode "400x300" (mode clock too high)
(II) RADEON(0): Not using default mode "800x600" (hsync out of range)
(II) RADEON(0): Not using default mode "400x300" (hsync out of range)
(II) RADEON(0): Not using default mode "800x600" (hsync out of range)
(II) RADEON(0): Not using default mode "400x300" (hsync out of range)
(II) RADEON(0): Not using default mode "800x600" (hsync out of range)
(II) RADEON(0): Not using default mode "400x300" (hsync out of range)
(II) RADEON(0): Not using default mode "1024x768" (vrefresh out of range)
(II) RADEON(0): Not using default mode "512x384" (vrefresh out of range)
(II) RADEON(0): Not using default mode "1024x768" (hsync out of range)
(II) RADEON(0): Not using default mode "512x384" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1024x768" (hsync out of range)
(II) RADEON(0): Not using default mode "512x384" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1024x768" (hsync out of range)
(II) RADEON(0): Not using default mode "512x384" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1024x768" (hsync out of range)
(II) RADEON(0): Not using default mode "512x384" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1152x864" (hsync out of range)
(II) RADEON(0): Not using default mode "576x432" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1280x960" (hsync out of range)
(II) RADEON(0): Not using default mode "640x480" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1280x960" (hsync out of range)
(II) RADEON(0): Not using default mode "640x480" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1280x1024" (hsync out of range)
(II) RADEON(0): Not using default mode "640x512" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1280x1024" (hsync out of range)
(II) RADEON(0): Not using default mode "640x512" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1280x1024" (hsync out of range)
(II) RADEON(0): Not using default mode "640x512" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1600x1200" (hsync out of range)
(II) RADEON(0): Not using default mode "800x600" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1600x1200" (hsync out of range)
(II) RADEON(0): Not using default mode "800x600" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1600x1200" (hsync out of range)
(II) RADEON(0): Not using default mode "800x600" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1600x1200" (hsync out of range)
(II) RADEON(0): Not using default mode "800x600" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1600x1200" (hsync out of range)
(II) RADEON(0): Not using default mode "800x600" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1792x1344" (hsync out of range)
(II) RADEON(0): Not using default mode "896x672" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1792x1344" (hsync out of range)
(II) RADEON(0): Not using default mode "896x672" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1856x1392" (hsync out of range)
(II) RADEON(0): Not using default mode "928x696" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1856x1392" (hsync out of range)
(II) RADEON(0): Not using default mode "928x696" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1920x1440" (hsync out of range)
(II) RADEON(0): Not using default mode "960x720" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1920x1440" (hsync out of range)
(II) RADEON(0): Not using default mode "960x720" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "832x624" (hsync out of range)
(II) RADEON(0): Not using default mode "416x312" (hsync out of range)
(II) RADEON(0): Not using default mode "1280x768" (hsync out of range)
(II) RADEON(0): Not using default mode "640x384" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1280x800" (hsync out of range)
(II) RADEON(0): Not using default mode "640x400" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1152x768" (hsync out of range)
(II) RADEON(0): Not using default mode "576x384" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1152x864" (hsync out of range)
(II) RADEON(0): Not using default mode "576x432" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1400x1050" (hsync out of range)
(II) RADEON(0): Not using default mode "700x525" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1400x1050" (hsync out of range)
(II) RADEON(0): Not using default mode "700x525" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1400x1050" (hsync out of range)
(II) RADEON(0): Not using default mode "700x525" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1400x1050" (hsync out of range)
(II) RADEON(0): Not using default mode "700x525" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1440x900" (hsync out of range)
(II) RADEON(0): Not using default mode "720x450" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1600x1024" (hsync out of range)
(II) RADEON(0): Not using default mode "800x512" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1680x1050" (hsync out of range)
(II) RADEON(0): Not using default mode "840x525" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1920x1200" (hsync out of range)
(II) RADEON(0): Not using default mode "960x600" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1920x1200" (hsync out of range)
(II) RADEON(0): Not using default mode "960x600" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "1920x1440" (hsync out of range)
(II) RADEON(0): Not using default mode "960x720" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "2048x1536" (hsync out of range)
(II) RADEON(0): Not using default mode "1024x768" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "2048x1536" (hsync out of range)
(II) RADEON(0): Not using default mode "1024x768" (bad mode clock/interlace/doublescan)
(II) RADEON(0): Not using default mode "2048x1536" (hsync out of range)
(II) RADEON(0): Not using default mode "1024x768" (bad mode clock/interlace/doublescan)
(WW) RADEON(0): Mode pool is empty
(EE) RADEON(0): No valid modes found
(EE) RADEON(0): No valid mode found for CRTC2, disabling MergedFB
(II) RADEON(0): Total of 0 CRTC2 modes found for MergedFB------------ 
(--) RADEON(0): Virtual size is 1600x1200 (pitch 1600)
(**) RADEON(0): *Default mode "1600x1200": 162.0 MHz (scaled from 0.0 MHz), 75.0 kHz, 60.0 Hz
(II) RADEON(0): Modeline "1600x1200"  162.00  1600 1664 1856 2160  1200 1201 1204 1250 +hsync +vsync
(**) RADEON(0): *Default mode "1280x1024": 162.0 MHz (scaled from 0.0 MHz), 75.0 kHz, 60.0 Hz
(II) RADEON(0): Modeline "1280x1024"  162.00  1280 1664 1856 2160  1024 1201 1204 1250 +hsync +vsync
(**) RADEON(0): *Default mode "1024x768": 162.0 MHz (scaled from 0.0 MHz), 75.0 kHz, 60.0 Hz
(II) RADEON(0): Modeline "1024x768"  162.00  1024 1664 1856 2160  768 1201 1204 1250 +hsync +vsync
(**) RADEON(0): *Default mode "800x600": 162.0 MHz (scaled from 0.0 MHz), 75.0 kHz, 60.0 Hz
(II) RADEON(0): Modeline "800x600"  162.00  800 1664 1856 2160  600 1201 1204 1250 +hsync +vsync
(**) RADEON(0): *Default mode "640x480": 162.0 MHz (scaled from 0.0 MHz), 75.0 kHz, 60.0 Hz
(II) RADEON(0): Modeline "640x480"  162.00  640 1664 1856 2160  480 1201 1204 1250 -hsync -vsync
(**) RADEON(0):  Default mode "1600x1200": 162.0 MHz (scaled from 0.0 MHz), 75.0 kHz, 60.0 Hz
(II) RADEON(0): Modeline "1600x1200"  162.00  1600 1664 1856 2160  1200 1201 1204 1250 +hsync +vsync
(**) RADEON(0):  Default mode "1280x1024": 162.0 MHz (scaled from 0.0 MHz), 75.0 kHz, 60.0 Hz
(II) RADEON(0): Modeline "1280x1024"  162.00  1280 1664 1856 2160  1024 1201 1204 1250 +hsync +vsync
(**) RADEON(0):  Default mode "1280x960": 162.0 MHz (scaled from 0.0 MHz), 75.0 kHz, 60.0 Hz
(II) RADEON(0): Modeline "1280x960"  162.00  1280 1664 1856 2160  960 1201 1204 1250 +hsync +vsync
(**) RADEON(0):  Default mode "1152x864": 162.0 MHz (scaled from 0.0 MHz), 75.0 kHz, 60.0 Hz
(II) RADEON(0): Modeline "1152x864"  162.00  1152 1664 1856 2160  864 1201 1204 1250 +hsync +vsync
(**) RADEON(0):  Default mode "1024x768": 162.0 MHz (scaled from 0.0 MHz), 75.0 kHz, 60.0 Hz
(II) RADEON(0): Modeline "1024x768"  162.00  1024 1664 1856 2160  768 1201 1204 1250 +hsync +vsync
(**) RADEON(0):  Default mode "1024x768": 162.0 MHz (scaled from 0.0 MHz), 75.0 kHz, 60.0 Hz
(II) RADEON(0): Modeline "1024x768"  162.00  1024 1664 1856 2160  768 1201 1204 1250 -hsync -vsync
(**) RADEON(0):  Default mode "1024x768": 162.0 MHz (scaled from 0.0 MHz), 75.0 kHz, 60.0 Hz
(II) RADEON(0): Modeline "1024x768"  162.00  1024 1664 1856 2160  768 1201 1204 1250 -hsync -vsync
(**) RADEON(0):  Default mode "832x624": 162.0 MHz (scaled from 0.0 MHz), 75.0 kHz, 60.0 Hz
(II) RADEON(0): Modeline "832x624"  162.00  832 1664 1856 2160  624 1201 1204 1250 -hsync -vsync
(**) RADEON(0):  Default mode "800x600": 162.0 MHz (scaled from 0.0 MHz), 75.0 kHz, 60.0 Hz
(II) RADEON(0): Modeline "800x600"  162.00  800 1664 1856 2160  600 1201 1204 1250 +hsync +vsync
(**) RADEON(0):  Default mode "800x600": 162.0 MHz (scaled from 0.0 MHz), 75.0 kHz, 60.0 Hz
(II) RADEON(0): Modeline "800x600"  162.00  800 1664 1856 2160  600 1201 1204 1250 +hsync +vsync
(**) RADEON(0):  Default mode "800x600": 162.0 MHz (scaled from 0.0 MHz), 75.0 kHz, 60.0 Hz
(II) RADEON(0): Modeline "800x600"  162.00  800 1664 1856 2160  600 1201 1204 1250 +hsync +vsync
(**) RADEON(0):  Default mode "800x600": 162.0 MHz (scaled from 0.0 MHz), 75.0 kHz, 60.0 Hz
(II) RADEON(0): Modeline "800x600"  162.00  800 1664 1856 2160  600 1201 1204 1250 +hsync +vsync
(**) RADEON(0):  Default mode "640x480": 162.0 MHz (scaled from 0.0 MHz), 75.0 kHz, 60.0 Hz
(II) RADEON(0): Modeline "640x480"  162.00  640 1664 1856 2160  480 1201 1204 1250 -hsync -vsync
(**) RADEON(0):  Default mode "640x480": 162.0 MHz (scaled from 0.0 MHz), 75.0 kHz, 60.0 Hz
(II) RADEON(0): Modeline "640x480"  162.00  640 1664 1856 2160  480 1201 1204 1250 -hsync -vsync
(**) RADEON(0):  Default mode "640x480": 162.0 MHz (scaled from 0.0 MHz), 75.0 kHz, 60.0 Hz
(II) RADEON(0): Modeline "640x480"  162.00  640 1664 1856 2160  480 1201 1204 1250 -hsync -vsync
(--) RADEON(0): Display dimensions: (410, 310) mm
(--) RADEON(0): DPI set to (99, 98)
(II) Loading sub module "fb"
(II) LoadModule: "fb"
(II) Loading /usr/lib/xorg/modules//libfb.so
(II) Module fb: vendor="X.Org Foundation"
	compiled for 1.3.0, module version = 1.0.0
	ABI class: X.Org ANSI C Emulation, version 0.3
(II) Loading sub module "ramdac"
(II) LoadModule: "ramdac"(II) Module already built-in
(**) RADEON(0): Using EXA acceleration architecture
(II) Loading sub module "exa"
(II) LoadModule: "exa"
(II) Loading /usr/lib/xorg/modules//libexa.so
(II) Module exa: vendor="X.Org Foundation"
	compiled for 1.3.0, module version = 2.1.0
	ABI class: X.Org Video Driver, version 1.2
(II) RADEON(0): No MM_TABLE found - assuming CARD is not TV-in capable.
(!!) RADEON(0): For information on using the multimedia capabilities
	of this adapter, please see http://gatos.sf.net.
(--) Depth 24 pixmap format is 32 bpp
(II) do I need RAC?  No, I don't.
(II) resource ranges after preInit:
	[0] 0	0	0x88000000 - 0x8800ffff (0x10000) MX[B]
	[1] 0	0	0x80000000 - 0x87ffffff (0x8000000) MX[B]
	[2] -1	0	0x00100000 - 0x3fffffff (0x3ff00000) MX[B]E(B)
	[3] -1	0	0x000f0000 - 0x000fffff (0x10000) MX[B]
	[4] -1	0	0x000c0000 - 0x000effff (0x30000) MX[B]
	[5] -1	0	0x00000000 - 0x0009ffff (0xa0000) MX[B]
	[6] -1	0	0x98106800 - 0x98106fff (0x800) MX[B]
	[7] -1	0	0x98106000 - 0x981060ff (0x100) MX[B]
	[8] -1	0	0x98105000 - 0x98105fff (0x1000) MX[B]
	[9] -1	0	0x98104000 - 0x98104fff (0x1000) MX[B]
	[10] -1	0	0x98103000 - 0x98103fff (0x1000) MX[B]
	[11] -1	0	0x98102000 - 0x98102fff (0x1000) MX[B]
	[12] -1	0	0x98100000 - 0x9810007f (0x80) MX[B]
	[13] -1	0	0x88010000 - 0x8801ffff (0x10000) MX[B](B)
	[14] -1	0	0x90000000 - 0x90000000 (0x1) MX[B](B)
	[15] -1	0	0x88020000 - 0x8803ffff (0x20000) MX[B](B)
	[16] -1	0	0x88000000 - 0x8800ffff (0x10000) MX[B](B)
	[17] -1	0	0x80000000 - 0x87ffffff (0x8000000) MX[B](B)
	[18] -1	0	0x98101000 - 0x98101fff (0x1000) MX[B](B)
	[19] 0	0	0x000a0000 - 0x000affff (0x10000) MS[B](OprU)
	[20] 0	0	0x000b0000 - 0x000b7fff (0x8000) MS[B](OprU)
	[21] 0	0	0x000b8000 - 0x000bffff (0x8000) MS[B](OprU)
	[22] 0	0	0xfe000400 - 0xfe0004ff (0x100) IX[B]
	[23] -1	0	0x00000400 - 0x000004ff (0x100) IX[B](B)
	[24] -1	0	0x0000ffff - 0x0000ffff (0x1) IX[B]
	[25] -1	0	0x00000000 - 0x000000ff (0x100) IX[B]
	[26] -1	0	0xfe802420 - 0xfe802427 (0x8) IX[B]
	[27] -1	0	0xfe802400 - 0xfe80241f (0x20) IX[B]
	[28] -1	0	0xfe802300 - 0xfe8023ff (0x100) IX[B]
	[29] -1	0	0xfe802204 - 0xfe802207 (0x4) IX[B]
	[30] -1	0	0xfe802200 - 0xfe802203 (0x4) IX[B]
	[31] -1	0	0xfe802100 - 0xfe8021ff (0x100) IX[B]
	[32] -1	0	0xfe8020a0 - 0xfe8020bf (0x20) IX[B]
	[33] -1	0	0xfe802080 - 0xfe80209f (0x20) IX[B]
	[34] -1	0	0xfe00cc00 - 0xfe00cc0f (0x10) IX[B]
	[35] -1	0	0xfe802000 - 0xfe80207f (0x80) IX[B]
	[36] 0	0	0xfe0003b0 - 0xfe0003bb (0xc) IS[B](OprU)
	[37] 0	0	0xfe0003c0 - 0xfe0003df (0x20) IS[B](OprU)
(**) RADEON(0): RADEONScreenInit 80000000 0
(**) RADEON(0): Map: 0x80000000, 0x08000000
(**) RADEON(0): RADEONSave
(**) RADEON(0): RADEONSaveMode(0x10224970)
(**) RADEON(0): Read: 0x0000000c 0x00010090 0x00000000
(**) RADEON(0): Read: rd=12, fd=144, pd=1
(**) RADEON(0): RADEONSaveMode returns 0x10224970
(==) RADEON(0): Using 24 bit depth buffer
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: open result is 5, (OK)
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: open result is 5, (OK)
drmOpenByBusid: Searching for BusID pci:0000:01:00.0
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: open result is 5, (OK)
drmOpenByBusid: drmOpenMinor returns 5
drmOpenByBusid: drmGetBusid reports pci:0000:01:00.0
(II) RADEON(0): [drm] DRM interface version 1.3
(II) RADEON(0): [drm] created "radeon" driver at busid "pci:0000:01:00.0"
(II) RADEON(0): [drm] added 8192 byte SAREA at 0xf1031000
(II) RADEON(0): [drm] mapped SAREA 0xf1031000 to 0x48020000
(II) RADEON(0): [drm] framebuffer handle = 0x80000000
(II) RADEON(0): [drm] added 1 reserved context for kernel
(II) RADEON(0): [pci] 8192 kB allocated with handle 0x00000000
(II) RADEON(0): [pci] ring handle = 0xf2143000
(II) RADEON(0): [pci] Ring mapped at 0x50062000
(II) RADEON(0): [pci] Ring contents 0x00000000
(II) RADEON(0): [pci] ring read ptr handle = 0xf2244000
(II) RADEON(0): [pci] Ring read ptr mapped at 0x48022000
(II) RADEON(0): [pci] Ring read ptr contents 0x00000000
(II) RADEON(0): [pci] vertex/indirect buffers handle = 0xf2245000
(II) RADEON(0): [pci] Vertex/indirect buffers mapped at 0x50163000
(II) RADEON(0): [pci] Vertex/indirect buffers contents 0x00000000
(II) RADEON(0): [pci] GART texture map handle = 0xf2445000
(II) RADEON(0): [pci] GART Texture map mapped at 0x50363000
(II) RADEON(0): [drm] register handle = 0x88000000
(II) RADEON(0): [dri] Visual configs initialized
(**) RADEON(0): DRI New memory map param
(**) RADEON(0): RADEONInitMemoryMap() : 
(**) RADEON(0):   mem_size         : 0x08000000
(**) RADEON(0):   MC_FB_LOCATION   : 0x87ff8000
(**) RADEON(0):   MC_AGP_LOCATION  : 0xffffffc0
(**) RADEON(0): RADEONModeInit()
1600x1200     162.00  1600 1664 1856 2160  1200 1201 1204 1250 (24,32) +H +V
1600x1200     162.00  1600 1664 1856 2160  1200 1201 1204 1250 (24,32) +H +V
(**) RADEON(0): Pitch = 13107400 bytes (virtualX = 1600, displayWidth = 1600)
(**) RADEON(0): dc=16200, of=32400, fd=144, pd=2
(**) RADEON(0): TMDS_PLL from 1f600f4 to 1f60111
(II) RADEON(0): BIOS HotKeys Disabled
(**) RADEON(0): RADEONInit returns 0x10225320
(**) RADEON(0): RADEONRestoreMode()
(**) RADEON(0): RADEONRestoreMode(0x10225320)
(**) RADEON(0): RADEONRestoreMemMapRegisters() : 
(**) RADEON(0):   MC_FB_LOCATION   : 0x87ff8000
(**) RADEON(0):   MC_AGP_LOCATION  : 0xffffffc0
(**) RADEON(0):   Map Changed ! Applying ...
(**) RADEON(0):   Map applied, resetting engine ...
(**) RADEON(0): Updating display base addresses...
(**) RADEON(0): Memory map updated.
(**) RADEON(0): Programming CRTC1, offset: 0x00000000
(**) RADEON(0): Wrote: 0x0000000c 0x00010090 0x00000000 (0x0000a700)
(**) RADEON(0): Wrote: rd=12, fd=144, pd=1
(**) RADEON(0): GRPH_BUFFER_CNTL from 20205c5c to 20185c5c
(**) RADEON(0): RADEONSaveScreen(0)
(II) RADEON(0): Depth moves disabled by default
(**) RADEON(0): Setting up initial surfaces
(**) RADEON(0): Initializing fb layer
(**) RADEON(0): Setting up accel memmap
(==) RADEON(0): Using accelerated EXA DownloadFromScreen hook
(II) RADEON(0): Allocating from a screen of 131072 kb
(II) RADEON(0): Will use 7500 kb for front buffer at offset 0x00000000
(II) RADEON(0): Will use 16 kb for hardware cursor at offset 0x00753000
(II) RADEON(0): Will use 7500 kb for back buffer at offset 0x00757000
(II) RADEON(0): Will use 7500 kb for depth buffer at offset 0x00eaa000
(II) RADEON(0): Will use 54272 kb for textures at offset 0x015fd000
(II) RADEON(0): Will use 54284 kb for X Server offscreen at offset 0x04afd000
(**) RADEON(0): Initializing backing store
(==) RADEON(0): Backing store disabled
(**) RADEON(0): DRI Finishing init !
(II) RADEON(0): X context handle = 0x1

Backtrace:
0: /usr/bin/X(xf86SigHandler+0x94) [0x100934c4]
1: [0x100374]
2: [0x102272a8]
3: /usr/lib/xorg/modules/extensions//libdri.so(DRIFinishScreenInit+0xb0) [0xf9948b0]
4: /usr/lib/xorg/modules/drivers//radeon_drv.so(RADEONDRIFinishScreenInit+0x68) [0xf8a699c]
5: /usr/lib/xorg/modules/drivers//radeon_drv.so(RADEONScreenInit+0xf74) [0xf895f78]
6: /usr/bin/X(AddScreen+0x21c) [0x1002d79c]
7: /usr/bin/X(InitOutput+0x284) [0x1006d364]
8: /usr/bin/X(main+0x294) [0x1002e004]
9: /lib/libc.so.6 [0xfc75b10]
10: /lib/libc.so.6 [0xfc75cd0]

Fatal server error:
Caught signal 11.  Server aborting

(**) RADEON(0): RADEONLeaveVT
(**) RADEON(0): RADEONRestore
(**) RADEON(0): RADEONRestoreMode()
(**) RADEON(0): RADEONRestoreMode(0x10224970)
(**) RADEON(0): RADEONRestoreMemMapRegisters() : 
(**) RADEON(0):   MC_FB_LOCATION   : 0x7fff0000
(**) RADEON(0):   MC_AGP_LOCATION  : 0xffffe000
(**) RADEON(0):   Map Changed ! Applying ...
(**) RADEON(0):   Map applied, resetting engine ...
(**) RADEON(0): Updating display base addresses...
(**) RADEON(0): Memory map updated.
(**) RADEON(0): Programming CRTC1, offset: 0x00000000
(**) RADEON(0): Wrote: 0x0000000c 0x00010090 0x00000000 (0x0000a700)
(**) RADEON(0): Wrote: rd=12, fd=144, pd=1
(**) RADEON(0): Ok, leaving now...

--========GMX106941207492474385500--
