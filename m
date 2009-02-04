Return-Path: <linux-kernel-owner+w=401wt.eu-S1757514AbZBDSL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514AbZBDSL6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:11:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbZBDSLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:11:46 -0500
Received: from ppp-110-6.adsl.restena.lu ([158.64.110.6]:60976 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752443AbZBDSLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:11:44 -0500
X-Greylist: delayed 461 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Feb 2009 13:11:43 EST
Date: Wed, 4 Feb 2009 19:03:57 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Dave Airlie <airlied@linux.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, Daniel Vetter <daniel@ffwll.ch>,
       linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, dri-devel@lists.sourceforge.net
Subject: Re: + drivers-gpu-drm-i915-intel_lvdsc-fix-locking-snafu.patch
 added to -mm tree
Message-ID: <20090204190357.7f252f64@neptune.home>
In-Reply-To: <alpine.DEB.2.00.0902030955420.31073@skynet.skynet.ie>
References: <200901292050.n0TKol5b015605@imap1.linux-foundation.org>
	<200901291324.17624.jbarnes@virtuousgeek.org>
	<20090129134825.620e3f84.akpm@linux-foundation.org>
	<20090131152508.GA4668@viiv.ffwll.ch>
	<20090202224448.b19eaca4.akpm@linux-foundation.org>
	<alpine.DEB.2.00.0902030955420.31073@skynet.skynet.ie>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does not work for me.

With this patch applied kernel fails to read EDID data and discover
proper modes. (It ends up displaying a picture looking like the BIOS
bootup image). X fails to start finding no valid mode for LVDS output.

Without the patch Xorg doesn't start either, being blocked in same
area as listed earlier in this thread:
[  373.719792] Xorg          D 00000000  1704  2295   2216
[  373.719803]  da9a1dc4 00203082 dd3f0080 00000000 00000000 dd8c0990 dd84e800 00000000
[  373.719817]  dd84ea4c ffffffff dd84ea50 da9a1de8 c036950e dd8c0990 dd84ea50 dd84ea50
[  373.719832]  dd8c0990 dd84ea4c dd84f000 dd84e800 da9a1df8 c0369479 dd84f000 dd822000
[  373.719845] Call Trace:
[  373.719855]  [<c036950e>] __mutex_lock_slowpath+0x5e/0x90
[  373.719864]  [<c0369479>] mutex_lock+0x19/0x20
[  373.719876]  [<c0278ed0>] intel_lvds_get_modes+0x60/0x90
[  373.719889]  [<c0269069>] drm_helper_probe_single_connector_modes+0x89/0x220
[  373.719898]  [<c036946e>] ? mutex_lock+0xe/0x20
[  373.719908]  [<c02674a1>] drm_mode_getconnector+0x261/0x300
[  373.719922]  [<c025d850>] drm_ioctl+0xe0/0x2b0
[  373.719932]  [<c0267240>] ? drm_mode_getconnector+0x0/0x300
[  373.719942]  [<c025d770>] ? drm_ioctl+0x0/0x2b0
[  373.719951]  [<c0174757>] vfs_ioctl+0x67/0x70
[  373.719960]  [<c0174d2a>] do_vfs_ioctl+0x1fa/0x520
[  373.719969]  [<c0158553>] ? handle_mm_fault+0xd3/0x480
[  373.719980]  [<c01b3f42>] ? reiserfs_file_write+0x82/0xb0
[  373.719988]  [<c016a675>] ? vfs_write+0xe5/0x120
[  373.719997]  [<c01b3ec0>] ? reiserfs_file_write+0x0/0xb0
[  373.720005]  [<c0175089>] sys_ioctl+0x39/0x60
[  373.720014]  [<c0103105>] sysenter_do_call+0x12/0x25


Laptop is Acer Travelmate 660. (855GM)

lspci -nn:
00:00.0 Host bridge [0600]: Intel Corporation 82852/82855 GM/GME/PM/GMV Processor to I/O Controller [8086:3580] (rev 02)
00:00.1 System peripheral [0880]: Intel Corporation 82852/82855 GM/GME/PM/GMV Processor to I/O Controller [8086:3584] (rev 02)
00:00.3 System peripheral [0880]: Intel Corporation 82852/82855 GM/GME/PM/GMV Processor to I/O Controller [8086:3585] (rev 02)
00:02.0 VGA compatible controller [0300]: Intel Corporation 82852/855GM Integrated Graphics Device [8086:3582] (rev 02)
00:02.1 Display controller [0380]: Intel Corporation 82852/855GM Integrated Graphics Device [8086:3582] (rev 02)
00:1d.0 USB Controller [0c03]: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #1 [8086:24c2] (rev 03)
00:1d.1 USB Controller [0c03]: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #2 [8086:24c4] (rev 03)
00:1d.2 USB Controller [0c03]: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #3 [8086:24c7] (rev 03)
00:1d.7 USB Controller [0c03]: Intel Corporation 82801DB/DBM (ICH4/ICH4-M) USB2 EHCI Controller [8086:24cd] (rev 03)
00:1e.0 PCI bridge [0604]: Intel Corporation 82801 Mobile PCI Bridge [8086:2448] (rev 83)
00:1f.0 ISA bridge [0601]: Intel Corporation 82801DBM (ICH4-M) LPC Interface Bridge [8086:24cc] (rev 03)
00:1f.1 IDE interface [0101]: Intel Corporation 82801DBM (ICH4-M) IDE Controller [8086:24ca] (rev 03)
00:1f.3 SMBus [0c05]: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) SMBus Controller [8086:24c3] (rev 03)
00:1f.5 Multimedia audio controller [0401]: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Audio Controller [8086:24c5] (rev 03)
00:1f.6 Modem [0703]: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) AC'97 Modem Controller [8086:24c6] (rev 03)
02:02.0 Ethernet controller [0200]: Broadcom Corporation BCM4401 100Base-T [14e4:4401] (rev 01)
02:04.0 Network controller [0280]: Intel Corporation PRO/Wireless LAN 2100 3B Mini PCI Adapter [8086:1043] (rev 04)
02:06.0 CardBus bridge [0607]: O2 Micro, Inc. OZ711EC1 SmartCardBus Controller [1217:7113] (rev 20)
02:06.1 CardBus bridge [0607]: O2 Micro, Inc. OZ711EC1 SmartCardBus Controller [1217:7113] (rev 20)
02:07.0 FireWire (IEEE 1394) [0c00]: Texas Instruments TSB43AB21 IEEE-1394a-2000 Controller (PHY/Link) [104c:8026]


dmesg output:
...
[    0.525418] Linux agpgart interface v0.103
[    0.525497] agpgart-intel 0000:00:00.0: Intel 855GM Chipset
[    0.526219] agpgart-intel 0000:00:00.0: detected 32636K stolen memory
[    0.527759] agpgart-intel 0000:00:00.0: AGP aperture is 128M @ 0xe8000000
[    0.527926] [drm] Initialized drm 1.1.0 20060810
[    0.528014] pci 0000:00:02.0: power state changed by ACPI to D0
[    0.528354] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
[    0.528409] PCI: setting IRQ 11 as level-triggered
[    0.528415] pci 0000:00:02.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
[    0.528490] pci 0000:00:02.0: setting latency timer to 64
[    0.609992] Switched to high resolution mode on CPU 0
[    1.004444] i2c-adapter i2c-0: unable to read EDID block.
[    1.080091] pci 0000:00:02.0: VGA-1: no EDID data
[    1.425597] fbcon: inteldrmfb (fb0) is primary device
[    1.719256] [drm:intel_crtc_mode_set] *ERROR* Couldn't find PLL settings for mode!
[    1.719261] [drm] LVDS-8: set mode 1400x1050 d
[    2.047448] Console: switching to colour frame buffer device 175x65
[    2.118731] fb0: inteldrmfb frame buffer device
[    2.119078] registered panic notifier
[    2.119361] [drm] Initialized i915 1.6.0 20080730 on minor 0
...


Xorg log extract
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: open result is 9, (OK)
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: open result is 9, (OK)
drmOpenByBusid: Searching for BusID pci:0000:00:02.0
drmOpenDevice: node name is /dev/dri/card0
drmOpenDevice: open result is 9, (OK)
drmOpenByBusid: drmOpenMinor returns 9
drmOpenByBusid: drmGetBusid reports pci:0000:00:02.0
(II) [drm] DRM interface version 1.3
(II) [drm] DRM open master succeeded.
(II) intel(0): Output VGA1 has no monitor section
(II) intel(0): Output LVDS1 has no monitor section
(II) intel(0): Output DVI1 has no monitor section
(II) intel(0): EDID for output VGA1
(II) intel(0): Not using default mode "640x350" (vrefresh out of range)
(II) intel(0): Not using default mode "640x400" (vrefresh out of range)
(II) intel(0): Not using default mode "720x400" (vrefresh out of range)
...
(II) intel(0): Not using default mode "2048x1536" (width too large for virtual size)
(II) intel(0): Not using default mode "2048x1536" (width too large for virtual size)
(II) intel(0): Printing probed modes for output VGA1
(II) intel(0): Modeline "1024x768"x60.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
(II) intel(0): Modeline "800x600"x60.3   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
(II) intel(0): Modeline "640x480"x59.9   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
(II) intel(0): EDID for output LVDS1
(II) intel(0): Not using mode "X<98><89><DD>X<98><89><DD>\z<94><DD>^A" (height too large for virtual size)
(II) intel(0): Not using default mode "640x350" (vrefresh out of range)
(II) intel(0): Not using default mode "640x400" (vrefresh out of range)
(II) intel(0): Not using default mode "720x400" (vrefresh out of range)
...
(II) intel(0): No remaining probed modes for output LVDS1
(II) intel(0): EDID for output DVI1
(II) intel(0): Output VGA1 disconnected
(II) intel(0): Output LVDS1 connected
(II) intel(0): Output DVI1 disconnected
(WW) intel(0): Unable to find initial modes
(EE) intel(0): Output LVDS1 enabled but has no modes
(==) intel(0): video overlay key set to 0x101fe
(==) intel(0): Will not try to enable page flipping
(==) intel(0): Triple buffering disabled
(==) intel(0): Using gamma correction (1.0, 1.0, 1.0)
(EE) intel(0): No modes.
(II) UnloadModule: "intel"
(EE) Screen(s) found, but none have a usable configuration.

Fatal server error:
no screens found


i915+drm are built-in and KMS is triggered by command line:
  hpet=force BOOT_IMAGE=KMS-2.6.29-3.3 ro root=806 softlevel=default
  modeset=1 i915.modeset=1

lilo is configured with vga=normal.

Bruno


On Tue, 03 February 2009 Dave Airlie <airlied@linux.ie> wrote:
> 
> On Mon, 2 Feb 2009, Andrew Morton wrote:
> 
> > (cc's added)
> > 
> > On Sat, 31 Jan 2009 16:25:08 +0100 Daniel Vetter <daniel@ffwll.ch>
> > wrote:
> > 
> > > On Thu, Jan 29, 2009 at 01:48:25PM -0800, Andrew Morton wrote:
> > > > On Thu, 29 Jan 2009 13:24:17 -0800
> > > > Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > > > > On Thursday, January 29, 2009 12:50 pm
> > > > > akpm@linux-foundation.org wrote:
> > 
> > So I assume that it would make sense to track this as a post-2.6.28
> > regression?
> > 
> 
> From ac048e1734699dd98f4bdf4daf2b9592d4a4d38e Mon Sep 17 00:00:00 2001
> From: Dave Airlie <airlied@redhat.com>
> Date: Tue, 3 Feb 2009 19:05:12 +1000
> Subject: [PATCH] i915: fix unneeded locking in i915 LVDS get modes
> code.
> 
> This code is always called under the lock from the higher layers,
> so need to go locking it here.
> 
> Signed-off-by: Dave Airlie <airlied@redhat.com>
> ---
>  drivers/gpu/drm/i915/intel_lvds.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_lvds.c
> b/drivers/gpu/drm/i915/intel_lvds.c index b36a521..cf8da64 100644
> --- a/drivers/gpu/drm/i915/intel_lvds.c
> +++ b/drivers/gpu/drm/i915/intel_lvds.c
> @@ -311,10 +311,8 @@ static int intel_lvds_get_modes(struct
> drm_connector *connector) if (dev_priv->panel_fixed_mode != NULL) {
>  		struct drm_display_mode *mode;
>  
> -		mutex_lock(&dev->mode_config.mutex);
>  		mode = drm_mode_duplicate(dev,
> dev_priv->panel_fixed_mode); drm_mode_probed_add(connector, mode);
> -		mutex_unlock(&dev->mode_config.mutex);
>  
>  		return 1;
>  	}
