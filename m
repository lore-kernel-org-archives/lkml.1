Return-Path: <linux-kernel-owner+w=401wt.eu-S1761151AbYDSLaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761151AbYDSLaf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 07:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753968AbYDSLaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 07:30:25 -0400
Received: from mail.gmx.net ([213.165.64.20]:55842 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753880AbYDSLaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 07:30:23 -0400
Content-Type: text/plain; charset="us-ascii"
Date: Sat, 19 Apr 2008 13:30:20 +0200
From: "Gerhard Pircher" <gerhard_pircher@gmx.net>
In-Reply-To: <21d7e9970804060044i25b36802p1859ca25fa532494@mail.gmail.com>
Message-ID: <20080419113020.107710@gmx.net>
MIME-Version: 1.0
References: <47E82D68.5070305@imap.cc> 
 <21d7e9970803241622v10b887a6p869535102b486279@mail.gmail.com> 
 <47E83D14.8070800@imap.cc> 
 <21d7e9970803241753q433e7545pdd00eae189846a8@mail.gmail.com> 
 <21d7e9970803302153s314d48d3o7120a56092eeaede@mail.gmail.com>  <47F1FA3F.
 <21d7e9970804060044i25b36802p1859ca25fa532494@mail.gmail.com>
Subject: [2.6.25] X server dying due to lock not being held
To: linux-kernel@vger.kernel.org
X-Authenticated: #6097454
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX18PO5t7G4sPL3y6KQMuFBWH5V7x2uXL2oqgLXBOT9
 kuiGHL6MGV78xWcpLNhKmJA2Un+HiK35y4iA== 
Content-Transfer-Encoding: 7bit
X-GMX-UID: ++I7cCQZPjl+LBs+azU2+mU7MTE2NYkY
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm running kernel 2.6.25 here on my AmigaOne G4 PowerPC machine and the
Xorg server dies since version 2.6.25-rc8, if DRI is enabled. I'm using a
Radeon9200 in PCIGART mode. The test was performed on a Debian Lenny
system.

The kernel log says the following:
> Apr 18 22:43:51 amigaone kernel: [drm:radeon_cp_init] *ERROR* radeon_cp_init called without lock held, held  0 owner 00000000 ef26a180
> Apr 18 22:43:51 amigaone kernel: [drm:drm_unlock] *ERROR* Process 2020 using kernel context 0

The Xorg.0.log contains the following stacktrace:
> (**) RADEON(0): RADEONScreenInit 80000000 0
> (**) RADEON(0): Map: 0x80000000, 0x08000000
> (**) RADEON(0): RADEONSave
> (**) RADEON(0): RADEONSaveMode(0x102246f8)
> (**) RADEON(0): Read: 0x0000000c 0x00010090 0x00000000
> (**) RADEON(0): Read: rd=12, fd=144, pd=1
> (**) RADEON(0): RADEONSaveMode returns 0x102246f8
> (==) RADEON(0): Using 24 bit depth buffer
> drmOpenDevice: node name is /dev/dri/card0
> drmOpenDevice: open result is 5, (OK)
> drmOpenDevice: node name is /dev/dri/card0
> drmOpenDevice: open result is 5, (OK)
> drmOpenByBusid: Searching for BusID pci:0000:01:00.0
> drmOpenDevice: node name is /dev/dri/card0
> drmOpenDevice: open result is 5, (OK)
> drmOpenByBusid: drmOpenMinor returns 5
> drmOpenByBusid: drmGetBusid reports pci:0000:01:00.0
> (II) RADEON(0): [drm] DRM interface version 1.3
> (II) RADEON(0): [drm] created "radeon" driver at busid "pci:0000:01:00.0"
> (II) RADEON(0): [drm] added 8192 byte SAREA at 0xf1031000
> (II) RADEON(0): [drm] mapped SAREA 0xf1031000 to 0x48020000
> (II) RADEON(0): [drm] framebuffer handle = 0x80000000
> (II) RADEON(0): [drm] added 1 reserved context for kernel
> (II) RADEON(0): [pci] 8192 kB allocated with handle 0x00000000
> (II) RADEON(0): [pci] ring handle = 0xf2143000
> (II) RADEON(0): [pci] Ring mapped at 0x50063000
> (II) RADEON(0): [pci] Ring contents 0x00000000
> (II) RADEON(0): [pci] ring read ptr handle = 0xf2244000
> (II) RADEON(0): [pci] Ring read ptr mapped at 0x48022000
> (II) RADEON(0): [pci] Ring read ptr contents 0x00000000
> (II) RADEON(0): [pci] vertex/indirect buffers handle = 0xf2245000
> (II) RADEON(0): [pci] Vertex/indirect buffers mapped at 0x50164000
> (II) RADEON(0): [pci] Vertex/indirect buffers contents 0x00000000
> (II) RADEON(0): [pci] GART texture map handle = 0xf2445000
> (II) RADEON(0): [pci] GART Texture map mapped at 0x50364000
> (II) RADEON(0): [drm] register handle = 0x88000000
> (II) RADEON(0): [dri] Visual configs initialized
> (**) RADEON(0): DRI New memory map param
> (**) RADEON(0): RADEONInitMemoryMap() : 
> (**) RADEON(0):   mem_size         : 0x08000000
> (**) RADEON(0):   MC_FB_LOCATION   : 0x87ff8000
> (**) RADEON(0):   MC_AGP_LOCATION  : 0xffffffc0
> (**) RADEON(0): RADEONModeInit()
> 1600x1200     162.00  1600 1664 1856 2160  1200 1201 1204 1250 (24,32) +H +V
> 1600x1200     162.00  1600 1664 1856 2160  1200 1201 1204 1250 (24,32) +H +V
> (**) RADEON(0): Pitch = 13107400 bytes (virtualX = 1600, displayWidth = 1600)
> (**) RADEON(0): dc=16200, of=32400, fd=144, pd=2
> (**) RADEON(0): TMDS_PLL from 1f600f4 to 1f60111
> (II) RADEON(0): BIOS HotKeys Disabled
> (**) RADEON(0): RADEONInit returns 0x102250a8
> (**) RADEON(0): RADEONRestoreMode()
> (**) RADEON(0): RADEONRestoreMode(0x102250a8)
> (**) RADEON(0): RADEONRestoreMemMapRegisters() : 
> (**) RADEON(0):   MC_FB_LOCATION   : 0x87ff8000
> (**) RADEON(0):   MC_AGP_LOCATION  : 0xffffffc0
> (**) RADEON(0):   Map Changed ! Applying ...
> (**) RADEON(0):   Map applied, resetting engine ...
> (**) RADEON(0): Updating display base addresses...
> (**) RADEON(0): Memory map updated.
> (**) RADEON(0): Programming CRTC1, offset: 0x00000000
> (**) RADEON(0): Wrote: 0x0000000c 0x00010090 0x00000000 (0x0000a700)
> (**) RADEON(0): Wrote: rd=12, fd=144, pd=1
> (**) RADEON(0): GRPH_BUFFER_CNTL from 20205c5c to 20185c5c
> (**) RADEON(0): RADEONSaveScreen(0)
> (II) RADEON(0): Depth moves disabled by default
> (**) RADEON(0): Setting up initial surfaces
> (**) RADEON(0): Initializing fb layer
> (**) RADEON(0): Setting up accel memmap
> (==) RADEON(0): Using accelerated EXA DownloadFromScreen hook
> (II) RADEON(0): Allocating from a screen of 131072 kb
> (II) RADEON(0): Will use 7500 kb for front buffer at offset 0x00000000
> (II) RADEON(0): Will use 16 kb for hardware cursor at offset 0x00753000
> (II) RADEON(0): Will use 7500 kb for back buffer at offset 0x00757000
> (II) RADEON(0): Will use 7500 kb for depth buffer at offset 0x00eaa000
> (II) RADEON(0): Will use 54272 kb for textures at offset 0x015fd000
> (II) RADEON(0): Will use 54284 kb for X Server offscreen at offset 0x04afd000
> (**) RADEON(0): Initializing backing store
> (==) RADEON(0): Backing store disabled
> (**) RADEON(0): DRI Finishing init !
> (II) RADEON(0): X context handle = 0x1
> 
> Backtrace:
> 0: /usr/bin/X(xf86SigHandler+0x94) [0x100934c4]
> 1: [0x100374]
> 2: [0x10227030]
> 3: /usr/lib/xorg/modules/extensions//libdri.so(DRIFinishScreenInit+0xb0) [0xf98a8b0]
> 4: /usr/lib/xorg/modules/drivers//radeon_drv.so(RADEONDRIFinishScreenInit+0x68) [0xf89c99c]
> 5: /usr/lib/xorg/modules/drivers//radeon_drv.so(RADEONScreenInit+0xf74) [0xf88bf78]
> 6: /usr/bin/X(AddScreen+0x21c) [0x1002d79c]
> 7: /usr/bin/X(InitOutput+0x284) [0x1006d364]
> 8: /usr/bin/X(main+0x294) [0x1002e004]
> 9: /lib/libc.so.6 [0xfc6b720]
> 10: /lib/libc.so.6 [0xfc6b8e0]
> 
> Fatal server error:
> Caught signal 11.  Server aborting
> 
> (**) RADEON(0): RADEONLeaveVT
> (**) RADEON(0): RADEONRestore
> (**) RADEON(0): RADEONRestoreMode()
> (**) RADEON(0): RADEONRestoreMode(0x102246f8)
> (**) RADEON(0): RADEONRestoreMemMapRegisters() : 
> (**) RADEON(0):   MC_FB_LOCATION   : 0x7fff0000
> (**) RADEON(0):   MC_AGP_LOCATION  : 0xffffe000
> (**) RADEON(0):   Map Changed ! Applying ...
> (**) RADEON(0):   Map applied, resetting engine ...
> (**) RADEON(0): Updating display base addresses...
> (**) RADEON(0): Memory map updated.
> (**) RADEON(0): Programming CRTC1, offset: 0x00000000
> (**) RADEON(0): Wrote: 0x0000000c 0x00010090 0x00000000 (0x0000a700)
> (**) RADEON(0): Wrote: rd=12, fd=144, pd=1
> (**) RADEON(0): Ok, leaving now...

Any ideas what could be wrong here?

Thanks!

regards,

Gerhard

BTW: Please put me on CC:!
-- 
Psst! Geheimtipp: Online Games kostenlos spielen bei den GMX Free Games! 
http://games.entertainment.gmx.net/de/entertainment/games/free
