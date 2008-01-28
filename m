Return-Path: <linux-kernel-owner+w=401wt.eu-S1760356AbYA1Szb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760356AbYA1Szb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 13:55:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754946AbYA1SzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 13:55:18 -0500
Received: from ppp-110-246.adsl.restena.lu ([158.64.110.246]:47193 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753884AbYA1SzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 13:55:14 -0500
X-Greylist: delayed 539 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jan 2008 13:55:13 EST
From: Bruno =?iso-8859-1?q?Pr=E9mont?= <bonbons@linux-vserver.org>
To: Antonino Daplas <adaplas@gmail.com>
Subject: NULL pointer in nvidiafb initialisation (manual modprobe)
Date: Mon, 28 Jan 2008 19:46:09 +0100
User-Agent: KMail/1.9.7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801281946.10230.bonbons@linux-vserver.org>
X-VirusProbe: ClamAV, clean
X-SpamProbe: GOOD 0.0000015 3d66a16b63a014314bd34deac33d1ee6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While booting a nforce (first generation) based computer with udev module
loading disabled and loading nvidiafb.ko later on from console (modprobe
nvidiafb) I experience the following trace.
This does not happen every time nor does it happen when nvidiafb gets
loaded by udev.

Kernel is 2.6.24 from kernel.org with a few patches:
- squashfs3.3
- patches referred to by Raphael in http://lkml.org/lkml/2008/1/27/292

Below, trace, lspci and parts of my config.

Regards,
Bruno


[  196.863964] ACPI: PCI Interrupt Link [LNK5] enabled at IRQ 16
[  196.863975] ACPI: PCI Interrupt 0000:02:00.0[A] -> Link [LNK5] -> GSI 16 (level, high) -> IRQ 16
[  196.864048] nvidiafb: Device ID: 10de01a0
[  196.864115] PM: Adding info for No Bus:i2c-1
[  196.864162] PM: Adding info for No Bus:i2c-2
[  196.864204] PM: Adding info for No Bus:i2c-3
[  197.250886] nvidiafb: HW is currently programmed for CRT
[  197.250894] nvidiafb: Using CRT on CRTC 0
[  197.251046] nvidiafb: MTRR set to ON
[  197.251216] PM: Adding info for No Bus:fb0
[  197.251265] fbcon: NV1a (fb0) is primary device
[  197.333476] PM: Adding info for No Bus:vtcon1
[  197.335478] BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
[  197.335487] printing eip: dfa0e97a *pde = 00000000
[  197.335493] Oops: 0002 [#1]
[  197.335495] Modules linked in: nvidiafb fb_ddc i2c_algo_bit vgastate ipv6 forcedeth w83627hf hwmon_vid hwmon i2c_amd756 i2c_core
[  197.335503]
[  197.335507] Pid: 3404, comm: modprobe Not tainted (2.6.24 #4)
[  197.335510] EIP: 0060:[<dfa0e97a>] EFLAGS: 00010293 CPU: 0
[  197.335524] EIP is at NVDmaWait+0x8a/0x1b0 [nvidiafb]
[  197.335527] EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000001
[  197.335530] ESI: deaeb304 EDI: 3b9ac9ff EBP: dd8888c0 ESP: dd8888a8
[  197.335533]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  197.335537] Process modprobe (pid: 3404, ti=dd888000 task=debb99a0 task.ti=dd888000)
[  197.335539] Stack: 315a5249 deaeb000 00000008 00000000 deacb840 deaeb304 dd8888f4 dfa0ee0d
[  197.335545]        deaeb000 00000007 00000000 00000282 dd920000 00000020 00000010 00000010
[  197.335550]        deacb840 deaeb000 deacb888 dd888930 c023d4f2 00000001 00000010 dd88897c
[  197.335556] Call Trace:
[  197.335558]  [<c0104dea>] show_trace_log_lvl+0x1a/0x30
[  197.335568]  [<c0104ea9>] show_stack_log_lvl+0xa9/0xd0
[  197.335572]  [<c0104f91>] show_registers+0xc1/0x1c0
[  197.335576]  [<c010517f>] die+0xef/0x1e0
[  197.335579]  [<c0116127>] do_page_fault+0x327/0x5d0
[  197.335584]  [<c035c102>] error_code+0x6a/0x70
[  197.335590]  [<dfa0ee0d>] nvidiafb_imageblit+0x36d/0x390 [nvidiafb]
[  197.335597]  [<c023d4f2>] soft_cursor+0x142/0x1c0
[  197.335602]  [<c023d08c>] bit_cursor+0x34c/0x590
[  197.335605]  [<c0237606>] fbcon_cursor+0x196/0x2e0
[  197.335613]  [<c0281653>] hide_cursor+0x23/0x70
[  197.335618]  [<c0283877>] redraw_screen+0xc7/0x1b0
[  197.335622]  [<c0286161>] vc_resize+0x361/0x3d0
[  197.335627]  [<c0239194>] fbcon_init+0x1b4/0x450
[  197.335630]  [<c0281e14>] visual_init+0x94/0xe0
[  197.335634]  [<c0285a86>] bind_con_driver+0x136/0x310
[  197.335638]  [<c0285c93>] take_over_console+0x33/0x40
[  197.335642]  [<c0239494>] fbcon_takeover+0x64/0xa0
[  197.335646]  [<c023a05c>] fbcon_event_notify+0x80c/0x8e0
[  197.335649]  [<c0130202>] notifier_call_chain+0x42/0x60
[  197.335655]  [<c01304d4>] __blocking_notifier_call_chain+0x44/0x60
[  197.335660]  [<c013050a>] blocking_notifier_call_chain+0x1a/0x20
[  197.335664]  [<c022df51>] fb_notifier_call_chain+0x11/0x20
[  197.335668]  [<c022fc17>] register_framebuffer+0xf7/0x1c0
[  197.335673]  [<dfa0a071>] nvidiafb_probe+0x5e1/0xa20 [nvidiafb]
[  197.335680]  [<c022969e>] pci_device_probe+0x5e/0x80
[  197.335689]  [<c028f8c0>] driver_probe_device+0x90/0x1a0
[  197.335696]  [<c028fb3b>] __driver_attach+0x9b/0xa0
[  197.335700]  [<c028ed03>] bus_for_each_dev+0x43/0x70
[  197.335704]  [<c028f729>] driver_attach+0x19/0x20
[  197.335708]  [<c028f08b>] bus_add_driver+0x7b/0x1d0
[  197.335711]  [<c028fcb2>] driver_register+0x42/0x70
[  197.335715]  [<c022981c>] __pci_register_driver+0x4c/0x90
[  197.335720]  [<dfa09947>] nvidiafb_init+0x17/0x20 [nvidiafb]
[  197.335727]  [<c0139b51>] sys_init_module+0x121/0x1580
[  197.335732]  [<c0103e92>] sysenter_past_esp+0x5f/0x85
[  197.335736]  =======================
[  197.335737] Code: 04 00 00 8b 8e 04 04 00 00 29 c8 89 86 08 04 00 00 3b 45 f0 73 ab 8b 86 10 04 00 00
                     8d 51 01 83 fb 08 89 96 04 04 00 00 8d 04 88 <c7> 00 00 00 00 20 0f 8f ee 00 00 00
                     83 be 00 04 00 00 08 77 23
[  197.335757] EIP: [<dfa0e97a>] NVDmaWait+0x8a/0x1b0 [nvidiafb] SS:ESP 0068:dd8888a8
[  197.335767] ---[ end trace 09d1f435a4eaeb0c ]---



Graphics kernel config:
#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_ALI is not set
# CONFIG_AGP_ATI is not set
# CONFIG_AGP_AMD is not set
# CONFIG_AGP_AMD64 is not set
# CONFIG_AGP_INTEL is not set
CONFIG_AGP_NVIDIA=y
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_SWORKS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_AGP_EFFICEON is not set
CONFIG_DRM=m
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=m
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
CONFIG_VGASTATE=m
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=m
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_SYS_FOPS is not set
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
CONFIG_FB_VESA=y
# CONFIG_FB_EFI is not set
# CONFIG_FB_HECUBA is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=m
CONFIG_FB_NVIDIA_I2C=y
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I810 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_INTEL is not set
# CONFIG_FB_MATROX is not set
CONFIG_FB_RADEON=m
CONFIG_FB_RADEON_I2C=y
CONFIG_FB_RADEON_BACKLIGHT=y
# CONFIG_FB_RADEON_DEBUG is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_CYBLA is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_CORGI=y
CONFIG_BACKLIGHT_PROGEAR=y

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=y

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_VIDEO_SELECT=y
# CONFIG_MDA_CONSOLE is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y


lspci (textual and numeric):
00:00.0 Host bridge: nVidia Corporation nForce CPU bridge (rev b2)
00:00.1 RAM memory: nVidia Corporation nForce 220/420 Memory Controller (rev b2)
00:00.2 RAM memory: nVidia Corporation nForce 220/420 Memory Controller (rev b2)
00:00.3 RAM memory: nVidia Corporation nForce 420 Memory Controller (DDR) (rev b2)
00:01.0 ISA bridge: nVidia Corporation nForce ISA Bridge (rev c3)
00:01.1 SMBus: nVidia Corporation nForce PCI System Management (rev c1)
00:02.0 USB Controller: nVidia Corporation nForce USB Controller (rev c3)
00:03.0 USB Controller: nVidia Corporation nForce USB Controller (rev c3)
00:04.0 Ethernet controller: nVidia Corporation nForce Ethernet Controller (rev c2)
00:05.0 Multimedia audio controller: nVidia Corporation nForce Audio (rev c2)
00:06.0 Multimedia audio controller: nVidia Corporation nForce Audio (rev c2)
00:08.0 PCI bridge: nVidia Corporation nForce PCI-to-PCI bridge (rev c2)
00:09.0 IDE interface: nVidia Corporation nForce IDE (rev c3)
00:1e.0 PCI bridge: nVidia Corporation nForce AGP to PCI Bridge (rev b2)
01:04.0 RAID bus controller: Triones Technologies, Inc. HPT374 (rev 07)
01:04.1 RAID bus controller: Triones Technologies, Inc. HPT374 (rev 07)
02:00.0 VGA compatible controller: nVidia Corporation NVCrush11 [GeForce2 MX Integrated Graphics] (rev b1)

00:00.0 0600: 10de:01a4 (rev b2)
00:00.1 0500: 10de:01ac (rev b2)
00:00.2 0500: 10de:01ad (rev b2)
00:00.3 0500: 10de:01ab (rev b2)
00:01.0 0601: 10de:01b2 (rev c3)
00:01.1 0c05: 10de:01b4 (rev c1)
00:02.0 0c03: 10de:01c2 (rev c3)
00:03.0 0c03: 10de:01c2 (rev c3)
00:04.0 0200: 10de:01c3 (rev c2)
00:05.0 0401: 10de:01b0 (rev c2)
00:06.0 0401: 10de:01b1 (rev c2)
00:08.0 0604: 10de:01b8 (rev c2)
00:09.0 0101: 10de:01bc (rev c3)
00:1e.0 0604: 10de:01b7 (rev b2)
01:04.0 0104: 1103:0008 (rev 07)
01:04.1 0104: 1103:0008 (rev 07)
02:00.0 0300: 10de:01a0 (rev b1)

