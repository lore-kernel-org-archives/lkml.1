Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050Ab0AFSGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab0AFSGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 13:06:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756033Ab0AFSGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 13:06:19 -0500
Received: from ppp-156-21.adsl.restena.lu ([158.64.156.21]:56969 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031Ab0AFSGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 13:06:18 -0500
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Jan 2010 13:06:18 EST
Date: Wed, 6 Jan 2010 18:59:13 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>,
       Sylvain Meyer <sylvain.meyer@worldonline.fr>,
       linux-fbdev@vger.kernel.org
Subject: Re: 2.6.33-rc3 -- Intel 945GME (inteldrmfb) -- Two Tux images
 displayed  are side by side (should only show one).
Message-ID: <20100106185913.39003329@neptune.home>
In-Reply-To: <a44ae5cd1001060916s4db1d94fsb7e012ab80ce6add@mail.gmail.com>
References: <a44ae5cd1001060916s4db1d94fsb7e012ab80ce6add@mail.gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 January 2010 Miles Lane <miles.lane@gmail.com> wrote:
> For a long time I have gotten two pictures of Tux showing up when I
> include the Tux display option in my custom kernel builds.  I don't
> know how many kernel revisions ago it was when I started noticing
> this.  It seems like it might have been early in the 2.6 series
> kernels.

Unless your system has exactly one CPU without hyperthreading and with
exactly one core this is the correct bahavior, one tux per logical CPU.

If you just want a single tux you can run your kernel on a system with
only one logical CPU, boot it with maxcpus=1 or rebuild it with
CONFIG_SMP=n... though in those case you will not be able to benefit
from all of your CPU's resources..

Bruno

> dmesg:
> 
> Linux agpgart interface v0.103
> agpgart-intel 0000:00:00.0: Intel 945GME Chipset
> agpgart-intel 0000:00:00.0: detected 7932K stolen memory
> agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
> [drm] Initialized drm 1.1.0 20060810
> i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> i915 0000:00:02.0: setting latency timer to 64
> [drm] set up 7M of stolen space
> integrated sync not supported
> ACPI: Battery Slot [BAT0] (battery present)
> [drm] initialized overlay support
> [drm] LVDS-8: set mode 1024x600 27
> Console: switching to colour frame buffer device 128x37
> fb0: inteldrmfb frame buffer device
> registered panic notifier
> [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
> 
> # lspci -vvxxx -s 2.1
> 
> 00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME,
> 943/940GML Express Integrated Graphics Controller (rev 03)
> 	Subsystem: ASUSTeK Computer Inc. Device 8340
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 	Region 0: Memory at f7f80000 (32-bit, non-prefetchable)
> [size=512K] Capabilities: [d0] Power Management version 2
> 		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-) Status: D0 PME-Enable- DSel=0
> DScale=0 PME- 00: 86 80 a6 27 07 00 90 00 03 00 80 03 00 00 80 00
> 10: 00 00 f8 f7 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 40 83
> 30: 00 00 00 00 d0 00 00 00 00 00 00 00 00 00 00 00
> 40: 00 00 00 00 48 00 00 00 09 00 09 71 23 25 4a a1
> 50: 0e 00 30 00 1b 00 00 00 00 00 00 00 00 00 80 7f
> 60: 00 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00
> 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> c0: 00 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> d0: 01 00 22 00 00 00 00 00 00 00 00 00 00 00 00 00
> e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> f0: 88 40 64 34 10 00 00 00 86 0f 05 00 00 00 00 00
> 
> From .config:
> 
> # Graphics support
> #
> CONFIG_AGP=y
> CONFIG_AGP_INTEL=y
> CONFIG_VGA_ARB=y
> CONFIG_DRM=y
> CONFIG_DRM_KMS_HELPER=y
> CONFIG_DRM_I915=y
> CONFIG_DRM_I915_KMS=y
> CONFIG_VIDEO_OUTPUT_CONTROL=y
> CONFIG_FB=y
> CONFIG_FIRMWARE_EDID=y
> CONFIG_FB_BOOT_VESA_SUPPORT=y
> CONFIG_FB_CFB_FILLRECT=y
> CONFIG_FB_CFB_COPYAREA=y
> CONFIG_FB_CFB_IMAGEBLIT=y
> CONFIG_FB_MODE_HELPERS=y
> CONFIG_FB_TILEBLITTING=y
> 
> # Frame buffer hardware drivers
> #
> CONFIG_FB_VESA=y
> CONFIG_FB_EFI=y
> CONFIG_BACKLIGHT_LCD_SUPPORT=y
> CONFIG_LCD_CLASS_DEVICE=y
> CONFIG_LCD_PLATFORM=y
> CONFIG_BACKLIGHT_CLASS_DEVICE=y
> 
> # Display device support
> #
> CONFIG_DISPLAY_SUPPORT=y
> 
> # Console display driver support
> #
> CONFIG_VGA_CONSOLE=y
> CONFIG_VGACON_SOFT_SCROLLBACK=y
> CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=128
> CONFIG_DUMMY_CONSOLE=y
> CONFIG_FRAMEBUFFER_CONSOLE=y
> CONFIG_LOGO=y
> CONFIG_LOGO_LINUX_CLUT224=y
