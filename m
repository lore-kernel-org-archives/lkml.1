Return-Path: <linux-kernel-owner+w=401wt.eu-S1756727AbYDBMyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727AbYDBMyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 08:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754418AbYDBMyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 08:54:31 -0400
Received: from usermail.globalproof.net ([194.146.153.18]:57930 "EHLO
	usermail.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240AbYDBMya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 08:54:30 -0400
From: "Denys Fedoryshchenko" <denys@visp.net.lb>
To: linux-kernel@vger.kernel.org
Subject: atyfb rmmod & vram crash, 2.6.24, 2.6.25-rc8
Date: Wed, 2 Apr 2008 15:54:12 +0300
Message-Id: <20080402124854.M56647@visp.net.lb>
X-Mailer: OpenWebMail 2.52 
X-OriginatingIP: 195.69.208.251 (denys@visp.net.lb)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VGA card i dont know how much RAM there actually, but lspci here shows looks
like 16MB:

03:09.0 VGA compatible controller: ATI Technologies Inc 3D Rage Pro 215GP (rev
5c) (prog-if 00 [VGA controller])
        Subsystem: ATI Technologies Inc Rage Pro Turbo
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping+ SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 66 (2000ns min), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 21
        Region 0: Memory at f0000000 (32-bit, prefetchable) [size=16M]
        Region 1: I/O ports at 2000 [size=256]
        Region 2: Memory at d0121000 (32-bit, non-prefetchable) [size=4K]
        Kernel driver in use: atyfb



Loading without parameters

atyfb: using auxiliary register aperture
atyfb: 3D RAGE PRO (Mach64 GP, PQFP, PCI) [0x4750 rev 0x7c]
atyfb: Mach64 BIOS is located at c0000, mapped at c00c0000.
atyfb: BIOS frequency table:
atyfb: PCLK_min_freq 984, PCLK_max_freq 23600, ref_freq 2950, ref_divider 64
atyfb: MCLK_pwd 4200, MCLK_max_freq 7500, XCLK_max_freq 10000, SCLK_freq 5000
atyfb: 8M SGRAM (1:1), 29.498928 MHz XTAL, 236 MHz PLL, 75 Mhz MCLK, 100 MHz XCLK
atyfb: fb0: ATY Mach64 frame buffer device on PCI

It detects 8M.
If i put parameter vram=8
atyfb: 3D RAGE PRO (Mach64 GP, PQFP, PCI) [0x4750 rev 0x7c]
atyfb: Mach64 BIOS is located at c0000, mapped at c00c0000.
atyfb: BIOS frequency table:
atyfb: PCLK_min_freq 984, PCLK_max_freq 23600, ref_freq 2950, ref_divider 64
atyfb: MCLK_pwd 4200, MCLK_max_freq 7500, XCLK_max_freq 10000, SCLK_freq 5000
atyfb: 0M SGRAM (1:1), 29.498928 MHz XTAL, 236 MHz PLL, 75 Mhz MCLK, 100 MHz XCLK
atyfb: not enough video RAM
atyfb: can't set default video mode

And most interesting when i do rmmod
tv1 ~ # rmmod atyfb
Segmentation fault

and dmesg:
BUG: unable to handle kernel NULL pointer dereference at 00000448
IP: [<ce8fd0f2>] :atyfb:aty_set_crtc+0x9/0x19d
*pde = 00000000
Oops: 0000 [#1] SMP
Modules linked in: atyfb(-) fb backlight cfbcopyarea cfbimgblt cfbfillrect
rtc_cmos rtc_core rtc_lib e100 mii snd_intel8x0 snd_ac97_codec ac97_bus
snd_pcm snd_timer snd soundcore snd_page_alloc i2c_i801 i2c_core rng_core
iTCO_wdt uhci_hcd usbcore [last unloaded: atyfb]

Pid: 5198, comm: rmmod Not tainted (2.6.25-rc8-video #1)
EIP: 0060:[<ce8fd0f2>] EFLAGS: 00010286 CPU: 1
EIP is at aty_set_crtc+0x9/0x19d [atyfb]
EAX: 00000000 EBX: 00000000 ECX: cd8c6854 EDX: ce9064a0
ESI: ce9064a0 EDI: ce905830 EBP: cc9a1ed0 ESP: cc9a1ec8
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process rmmod (pid: 5198, ti=cc9a1000 task=cc9da000 task.ti=cc9a1000)
Stack: 00000000 ccacd000 cc9a1ee0 ce900d20 cd8c6800 ce905830 cc9a1eec c01c8376
       cd8c6854 cc9a1efc c0208c92 cd8c3854 cd8c6854 cc9a1f10 c02090c1 ce905830
       00000000 c0369060 cc9a1f24 c02086bc 00000000 ce905830 00000880 cc9a1f34
Call Trace:
 [<ce900d20>] ? atyfb_pci_remove+0x1d/0xb3 [atyfb]
 [<c01c8376>] ? pci_device_remove+0x19/0x39
 [<c0208c92>] ? __device_release_driver+0x60/0x7d
 [<c02090c1>] ? driver_detach+0x8e/0xcd
 [<c02086bc>] ? bus_remove_driver+0x63/0x7f
 [<c020914c>] ? driver_unregister+0x2a/0x2e
 [<c01c852e>] ? pci_unregister_driver+0x1e/0x64
 [<ce900d01>] ? atyfb_exit+0xd/0xf [atyfb]
 [<c013be85>] ? sys_delete_module+0x195/0x1d0
 [<c0110b8c>] ? do_page_fault+0x251/0x505
 [<c012e5cd>] ? up_read+0x16/0x29
 [<c0110b8c>] ? do_page_fault+0x251/0x505
 [<c0103892>] ? sysenter_past_esp+0x5f/0x91
 =======================
Code: 01 00 00 00 e8 84 ff ff ff a8 02 74 0e 8b 07 89 83 dc 03 00 00 8b b3 50
04 00 00 89 f0 5b 5e 5f 5d c3 55 89 e5 56 53 89 c3 89 d6 <83> b8 48 04 00 00
00 74 5f 8b 52 2c 81 e2 ff ff ff fc 8b 80 48
EIP: [<ce8fd0f2>] aty_set_crtc+0x9/0x19d [atyfb] SS:ESP 0068:cc9a1ec8
---[ end trace 1c998179e35e2f76 ]---

I will try to enable more debug, but probably this information is enough?

--
Denys Fedoryshchenko
Technical Manager
Virtual ISP S.A.L.

