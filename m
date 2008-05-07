Return-Path: <linux-kernel-owner+w=401wt.eu-S1757304AbYEGK5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbYEGK5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 06:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753848AbYEGK5B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 06:57:01 -0400
Received: from mailtp.via.com.tw ([61.66.243.2]:64517 "EHLO mailtp.via.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753736AbYEGK4z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 06:56:55 -0400
X-Greylist: delayed 912 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 May 2008 06:56:54 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: [Linux-fbdev-devel] [PATCH 1/9] viafb: VIA Frame Buffer Device Driver
Date: Wed, 7 May 2008 18:55:30 +0800
Message-ID: <C80EF34A3D2E494DBAF9AC29C7AE4EB806F67724@exchtp03.taipei.via.com.tw>
In-Reply-To: <C80EF34A3D2E494DBAF9AC29C7AE4EB806F67705@exchtp03.taipei.via.com.tw>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Linux-fbdev-devel] [PATCH 1/9] viafb: VIA Frame Buffer Device Driver
Thread-Index: AcivqWbF3qyu30s5RguMHG+BNihXBgAhNGrAAAA1T2AAABOmsA==
From: <JosephChan@via.com.tw>
To: <JosephChan@via.com.tw>, <akpm@linux-foundation.org>,
       <geert@linux-m68k.org>
Cc: <linux-fbdev-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 07 May 2008 10:55:32.0043 (UTC) FILETIME=[DEA679B0:01C8B030]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joseph Chan <josephchan@via.com.tw>

diff -Nur a/Documentation/fb/viafb.txt b/Documentation/fb/viafb.txt
--- a/Documentation/fb/viafb.txt	1969-12-31 19:00:00.000000000
-0500
+++ b/Documentation/fb/viafb.txt	2008-05-06 06:46:26.000000000
-0400
@@ -0,0 +1,197 @@
+
+        VIA Integration Graphic Chip Console Framebuffer Driver
+
+[Platform]
+-----------------------
+    The console framebuffer driver is for Graphics chips of
+    VIA UniChrome (Pro) Family:
+ 	CLE266, PM800 / CN400,P4M800CE / P4M800Pro / CN700 / VN800, 
+	CX700 / VX700, P4M890 
+    VIA Chrome9 Family:
+	K8M890, CN896 / P4M900, VX800)
+
+[Driver features]
+------------------------
+    Device:CRT, LCD, DVI
+
+    Support Mode:
+        CRT:   
+	    640 x480(60, 75, 85, 100, 120 Hz), 720 x480(60 Hz),
+	    720 x576(60 Hz), 800 x600(60, 75, 85, 100, 120 Hz),
+	    848 x480(60 Hz), 856 x480(60 Hz), 1024 x512(60 Hz),
+	    1024 x768(60, 75, 85, 100 Hz), 1152 x864(75 Hz),
+	    1280 x768(60 Hz), 1280 x960(60 Hz), 1280 x1024(60, 75, 85
Hz),
+	    1440 x1050(60 Hz), 1600 x1200(60, 75 Hz), 1280 x720(60 Hz),
+	    1920 x1080(60 Hz), 1400 x1050(60 Hz), 800 x480(60 Hz)
+
+    color depth:8 bpp, 16 bpp, 32 bpp
+
+    Support 2 D hardware accelerator for kernel 2.6.xx
+
+[Using the viafb module]
+-- -- --------------------
+    Start viafb with default settings,
+        #modprobe viafb
+
+    Start viafb with with user options,
+        #modprobe viafb mode=800x600 via_fb_bpp=16 refresh=60 
+                  active_dev=CRT+DVI dvi_port = DVP1 mode1 = 1024 x768 
+                  via_fb_bpp1 = 16 refresh1 = 60 SAMM_ON = 1
+
+    mode:
+        640 x480(default)
+        720 x480 
+        800 x600 
+        1024 x768
+        ......
+
+    via_fb_bpp:
+        8, 16, 32(default:32)
+
+    refresh:
+        60, 75, 85, 100, 120(default:60)
+
+    lcd_dsp_method:
+        0 : expandsion(default)
+        1 : centering
+
+    lcd_mode:
+        0 : OPEN LDI(default)
+        1 : SPWG
+
+    lcd_panel_id:
+        0 : Resolution: 640 x480, Channel: single, Dithering: Enable 
+        1 : Resolution: 800 x600, Channel: single, Dithering: Enable 
+        2 : Resolution: 1024 x768, Channel: single, Dithering:Enable
(default)
+        3 : Resolution: 1280 x768, Channel: single, Dithering: Enable 
+        4 : Resolution: 1280 x1024, Channel: dual, Dithering: Enable 
+        5 : Resolution: 1400 x1050, Channel: dual, Dithering: Enable 
+        6 : Resolution: 1600 x1200, Channel: dual, Dithering: Enable
+
+        8 : Resolution: 800 x480, Channel: single, Dithering: Enable 
+        9 : Resolution: 1024 x768, Channel: dual, Dithering: Enable 
+        10: Resolution: 1024 x768, Channel: single, Dithering: Disable 
+        11: Resolution: 1024 x768, Channel: dual, Dithering: Disable 
+        12: Resolution: 1280 x768, Channel: single, Dithering: Disable 
+        13: Resolution: 1280 x1024, Channel: dual, Dithering: Disable 
+        14: Resolution: 1400 x1050, Channel: dual, Dithering: Disable 
+        15: Resolution: 1600 x1200, Channel: dual, Dithering: Disable  
+        16: Resolution: 1366 x768, Channel: single, Dithering: Disable 
+        17: Resolution: 1024 x600, Channel: single, Dithering: Enable 
+        18: Resolution: 1280 x768, Channel: dual, Dithering: Enable 
+        19: Resolution: 1280 x800, Channel: single, Dithering: Enable
+    
+    via_fb_accel:
+        0 : No 2 D Hardware Acceleration(default)
+        1 : 2 D Hardware Acceleration
+
+    SAMM_ON:
+        0 : SAMM_ON disable(default)
+        1 : SAMM_ON enable
+
+    mode1:(secondary display device)
+        640 x480(default)
+        720 x480 
+        800 x600 
+        1024 x768 
+        ... ... 
+ 
+    via_fb_bpp1:(secondary display device) 
+        8, 16, 32(default:32)
+
+    refresh1:(secondary display device) 
+        60, 75, 85, 100, 120(default:60)
+
+    active_dev:
+        This option is used to specify active devices.(CRT, DVI, LCD,
CRT + LCD, CRT + DVI,...)
+        DVI stand for DVI or HDMI, Ex.If you want to enable HDMI, set
active_dev = DVI
+        In SAMM case, the previous of active_dev is primary device, and
the following is secondary device.
+
+        For example:
+        To enable one device, such as DVI only, we should use:
+        modprobe viafb active_dev = DVI...To enable two devices, such
as CRT + DVI:
+
+        For DuoView case, we can use:
+        modprobe viafb active_dev = CRT + DVI...OR modprobe viafb
active_dev = DVI + CRT...
+
+        For SAMM case:
+        If CRT is primary and DVI is secondary, we should use:
+            modprobe viafb active_dev = CRT + DVI SAMM_ON = 1...
+        If DVI is primary and CRT is secondary, we should use:
+            modprobe viafb active_dev = DVI + CRT SAMM_ON = 1...
+
+    display_hardware_layout:
+	      This option is uesed to specify display hardware layout
for CX700 chip.
+        1 : LCD only 
+        2 : DVI only 
+        3 : LCD + DVI(default)
+        4 : LCD1 + LCD2(internal + internal)
+        16: LCD1 + ExternalLCD2(internal + external)
+
+    second_size:
+        This option is used to set second device memory size(MB) in
SAMM case.
+        The minimal size is 16. 
+
+    EPIA_DVI:
+        This option is used to enable DVI on EPIA - M 
+        0 : No DVI on EPIA - M(default)
+        1 : DVI on EPIA - M
+
+    BusWidth:
+        When using 24 - Bit Bus Width Digital Interface, this option
should be set.
+        12: 12-Bit LVDS or 12-Bit TMDS(default)
+        24: 24-Bit LVDS or 24-Bit TMDS
+
+    LCDDualEdge:
+        When using Dual Edge Panel, this option should be set.
+        0 : No Dual Edge Panel(default)
+        1 : Dual Edge Panel
+
+    video_dev:
+        This option is used to specify video output devices(CRT, DVI,
LCD) for duoview case.
+        For example:
+        To output video on DVI, we should use:
+            modprobe viafb video_dev = DVI...
+
+    lcd_port:
+	      This option is used to specify lcd output port,
+        available values are "DVP0" "DVP1" "DFP_HIGHLOW" "DFP_HIGH"
+	      "DFP_LOW", for external LCD + external DVI on
CX700(External LCD is on DVP0), 
+        we should use:
+	          modprobe viafb lcd_port = DVP0...
+
+Note:
+    1. CRT may not display properly for DuoView CRT & DVI display at
+       the "640x480" PAL mode with DVI overscan enabled.
+    2. When SAMM is enable, mode and mode1, via_fb_bpp and via_fb_bpp1,
+       refresh and refresh1 can be different.
+    3. When console is depend on viafbinfo1, dynamically change
resolution and bpp,
+       need call VIAFB specified ioctl interface VIAFB_SET_DEVICE.
+       Call common ioctl function FBIOPUT_VSCREENINFO will cause sreen
crush.
+
+[Configure viafb with "fbset" tool]
+-----------------------------------
+    "fbset" is an inbox utility of Linux.
+    1. Inquire current viafb information, type,
+           # fbset -i
+
+    2. Set various resolutions and refresh rates,
+           # fbset <resolution-vertical_sync>
+
+       example,
+           # fbset "1024x768-75"
+       or
+           # fbset -g 1024 768 1024 768 32
+      Check the file "/etc/fb.modes" to find display modes available.
+
+    3. Set the color depth,
+           # fbset -depth <value>
+
+       example,
+           # fbset -depth 16
+
+[Bootup with viafb]:
+--------------------
+    Add the following line to your lilo.conf:
+        append =  "video=viafb:mode:1024x768,via_fb_bpp:32,refresh:85"
+
diff -Nur a/drivers/video/Kconfig b/drivers/video/Kconfig
--- a/drivers/video/Kconfig	2008-05-06 07:05:59.000000000 -0400
+++ b/drivers/video/Kconfig	2008-05-06 07:06:37.000000000 -0400
@@ -1501,6 +1501,24 @@
 	  (315/H/PRO, 55x, 650, 651, 740, 330, 661, 741, 760, 761) as
well
 	  as XGI V3XT, V5, V8 and Z7.
 
+config FB_VIA
+	tristate "VIA UniChrome (Pro) and Chrome9 display support"
+	depends on FB && PCI
+	select FB_CFB_FILLRECT
+	select FB_CFB_COPYAREA
+	select FB_CFB_IMAGEBLIT
+	select FB_SOFT_CURSOR
+        help
+          This is the frame buffer device driver for Graphics chips of
VIA 
+          UniChrome (Pro) Family
(CLE266,PM800/CN400,P4M800CE/P4M800Pro/
+          CN700/VN800,CX700/VX700,P4M890) and Chrome9 Family
(K8M890,CN896
+          /P4M900,VX800)
+
+          Say Y if you have a VIA UniChrome graphics board.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called viafb.
+
 config FB_NEOMAGIC
 	tristate "NeoMagic display support"
 	depends on FB && PCI
diff -Nur a/drivers/video/Makefile b/drivers/video/Makefile
--- a/drivers/video/Makefile	2008-05-06 07:05:49.000000000 -0400
+++ b/drivers/video/Makefile	2008-05-06 07:06:44.000000000 -0400
@@ -43,6 +43,7 @@
 obj-$(CONFIG_FB_ATY128)		  += aty/ macmodes.o
 obj-$(CONFIG_FB_RADEON)		  += aty/
 obj-$(CONFIG_FB_SIS)		  += sis/
+obj-$(CONFIG_FB_VIA)		  += via/
 obj-$(CONFIG_FB_KYRO)             += kyro/
 obj-$(CONFIG_FB_SAVAGE)		  += savage/
 obj-$(CONFIG_FB_GEODE)		  += geode/
diff -Nur a/drivers/video/via/accel.c b/drivers/video/via/accel.c
--- a/drivers/video/via/accel.c	1969-12-31 19:00:00.000000000 -0500
+++ b/drivers/video/via/accel.c	2008-04-29 02:51:13.000000000 -0400
@@ -0,0 +1,245 @@
+/*
+ * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
+ * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
+
+ * This program is free software; you can redistribute it and/or modify
+ * it under  the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2, or (at your 
+ option)
+ * any later version.
+
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTIES OR REPRESENTATIONS; without even
+ * the implied warranty of MERCHANTABILITY or FITNESS FOR
+ * A PARTICULAR PURPOSE.See the GNU General Public License
+ * for more details.
+
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+#include "global.h"
+
+void init_accel(void)
+{
+	parinfo.cursor_start = parinfo.fbmem_free - CURSOR_SIZE;
+	parinfo.fbmem_free -= CURSOR_SIZE;
+	parinfo.fbmem_used += CURSOR_SIZE;
+
+	/* Reverse 8*1024 memory space for cursor image of the XServer
*/
+	parinfo.VQ_start = parinfo.fbmem_free - CURSOR_SIZE - VQ_SIZE;
+	parinfo.VQ_end = parinfo.VQ_start + VQ_SIZE - 1;
+	parinfo.fbmem_free -= (CURSOR_SIZE + VQ_SIZE);
+	parinfo.fbmem_used += (CURSOR_SIZE + VQ_SIZE); }
+
+void init_2d_engine(void)
+{
+	u32 dwVQStartAddr, dwVQEndAddr;
+	u32 dwVQLen, dwVQStartL, dwVQEndL, dwVQStartEndH;
+
+	/* init 2D engine regs to reset 2D engine */
+	MMIO_OUT32(VIA_REG_GEMODE, 0x0);
+	MMIO_OUT32(VIA_REG_SRCPOS, 0x0);
+	MMIO_OUT32(VIA_REG_DSTPOS, 0x0);
+	MMIO_OUT32(VIA_REG_DIMENSION, 0x0);
+	MMIO_OUT32(VIA_REG_PATADDR, 0x0);
+	MMIO_OUT32(VIA_REG_FGCOLOR, 0x0);
+	MMIO_OUT32(VIA_REG_BGCOLOR, 0x0);
+	MMIO_OUT32(VIA_REG_CLIPTL, 0x0);
+	MMIO_OUT32(VIA_REG_CLIPBR, 0x0);
+	MMIO_OUT32(VIA_REG_OFFSET, 0x0);
+	MMIO_OUT32(VIA_REG_KEYCONTROL, 0x0);
+	MMIO_OUT32(VIA_REG_SRCBASE, 0x0);
+	MMIO_OUT32(VIA_REG_DSTBASE, 0x0);
+	MMIO_OUT32(VIA_REG_PITCH, 0x0);
+	MMIO_OUT32(VIA_REG_MONOPAT1, 0x0);
+
+	/* Init AGP and VQ regs */
+	switch (chip_info.gfx_chip_name) {
+	case UNICHROME_K8M890:
+	case UNICHROME_P4M900:
+		MMIO_OUT32(0x41c, 0x00100000);
+		MMIO_OUT32(0x420, 0x680A0000);
+		MMIO_OUT32(0x420, 0x02000000);
+		break;
+
+	default:
+		MMIO_OUT32(VIA_REG_TRANSET, 0x00100000);
+		MMIO_OUT32(VIA_REG_TRANSPACE, 0x00000000);
+		MMIO_OUT32(VIA_REG_TRANSPACE, 0x00333004);
+		MMIO_OUT32(VIA_REG_TRANSPACE, 0x60000000);
+		MMIO_OUT32(VIA_REG_TRANSPACE, 0x61000000);
+		MMIO_OUT32(VIA_REG_TRANSPACE, 0x62000000);
+		MMIO_OUT32(VIA_REG_TRANSPACE, 0x63000000);
+		MMIO_OUT32(VIA_REG_TRANSPACE, 0x64000000);
+		MMIO_OUT32(VIA_REG_TRANSPACE, 0x7D000000);
+
+		MMIO_OUT32(VIA_REG_TRANSET, 0xFE020000);
+		MMIO_OUT32(VIA_REG_TRANSPACE, 0x00000000);
+		break;
+	}
+	if (parinfo.VQ_start != 0) {
+		/* Enable VQ */
+		dwVQStartAddr = parinfo.VQ_start;
+		dwVQEndAddr = parinfo.VQ_end;
+		switch (chip_info.gfx_chip_name) {
+		case UNICHROME_K8M890:
+		case UNICHROME_P4M900:
+			dwVQStartL = 0x70000000 | (dwVQStartAddr &
0xFFFFFF);
+			dwVQEndL = 0x71000000 | (dwVQEndAddr &
0xFFFFFF);
+			dwVQStartEndH =
+			    0x72000000 | ((dwVQStartAddr & 0xFF000000)
>>
+					  24) | ((dwVQEndAddr &
0xFF000000)
+						 >> 16);
+			dwVQLen = 0x73000000 | (VQ_SIZE >> 3);
+			break;
+		default:
+			dwVQStartL = 0x50000000 | (dwVQStartAddr &
0xFFFFFF);
+			dwVQEndL = 0x51000000 | (dwVQEndAddr &
0xFFFFFF);
+			dwVQStartEndH =
+			    0x52000000 | ((dwVQStartAddr & 0xFF000000)
>>
+					  24) | ((dwVQEndAddr &
0xFF000000)
+						 >> 16);
+			dwVQLen = 0x53000000 | (VQ_SIZE >> 3);
+			break;
+		}
+
+		switch (chip_info.gfx_chip_name) {
+		case UNICHROME_K8M890:
+		case UNICHROME_P4M900:
+			MMIO_OUT32(0x41c, 0x00100000);
+			MMIO_OUT32(0x420, dwVQStartEndH);
+			MMIO_OUT32(0x420, dwVQStartL);
+			MMIO_OUT32(0x420, dwVQEndL);
+			MMIO_OUT32(0x420, dwVQLen);
+			MMIO_OUT32(0x420, 0x74301001);
+			MMIO_OUT32(0x420, 0x00000000);
+			break;
+		default:
+			MMIO_OUT32(VIA_REG_TRANSET, 0x00FE0000);
+			MMIO_OUT32(VIA_REG_TRANSPACE, 0x080003FE);
+			MMIO_OUT32(VIA_REG_TRANSPACE, 0x0A00027C);
+			MMIO_OUT32(VIA_REG_TRANSPACE, 0x0B000260);
+			MMIO_OUT32(VIA_REG_TRANSPACE, 0x0C000274);
+			MMIO_OUT32(VIA_REG_TRANSPACE, 0x0D000264);
+			MMIO_OUT32(VIA_REG_TRANSPACE, 0x0E000000);
+			MMIO_OUT32(VIA_REG_TRANSPACE, 0x0F000020);
+			MMIO_OUT32(VIA_REG_TRANSPACE, 0x1000027E);
+			MMIO_OUT32(VIA_REG_TRANSPACE, 0x110002FE);
+			MMIO_OUT32(VIA_REG_TRANSPACE, 0x200F0060);
+
+			MMIO_OUT32(VIA_REG_TRANSPACE, 0x00000006);
+			MMIO_OUT32(VIA_REG_TRANSPACE, 0x40008C0F);
+			MMIO_OUT32(VIA_REG_TRANSPACE, 0x44000000);
+			MMIO_OUT32(VIA_REG_TRANSPACE, 0x45080C04);
+			MMIO_OUT32(VIA_REG_TRANSPACE, 0x46800408);
+
+			MMIO_OUT32(VIA_REG_TRANSPACE, dwVQStartEndH);
+			MMIO_OUT32(VIA_REG_TRANSPACE, dwVQStartL);
+			MMIO_OUT32(VIA_REG_TRANSPACE, dwVQEndL);
+			MMIO_OUT32(VIA_REG_TRANSPACE, dwVQLen);
+			break;
+		}
+	} else {
+		/* Diable VQ */
+		switch (chip_info.gfx_chip_name) {
+		case UNICHROME_K8M890:
+		case UNICHROME_P4M900:
+			MMIO_OUT32(0x41c, 0x00100000);
+			MMIO_OUT32(0x420, 0x74301000);
+			break;
+		default:
+			MMIO_OUT32(VIA_REG_TRANSET, 0x00FE0000);
+			MMIO_OUT32(VIA_REG_TRANSPACE, 0x00000004);
+			MMIO_OUT32(VIA_REG_TRANSPACE, 0x40008C0F);
+			MMIO_OUT32(VIA_REG_TRANSPACE, 0x44000000);
+			MMIO_OUT32(VIA_REG_TRANSPACE, 0x45080C04);
+			MMIO_OUT32(VIA_REG_TRANSPACE, 0x46800408);
+			break;
+		}
+	}
+
+	set_2d_color_depth(parinfo.bpp);
+
+	MMIO_OUT32(VIA_REG_SRCBASE, 0x0);
+	MMIO_OUT32(VIA_REG_DSTBASE, 0x0);
+
+	MMIO_OUT32(VIA_REG_PITCH,
+		   VIA_PITCH_ENABLE |
+		   (((parinfo.hres *
+		      parinfo.bpp >> 3) >> 3) | (((parinfo.hres *
+						   parinfo.
+						   bpp >> 3) >> 3) <<
16)));
+}
+
+void set_2d_color_depth(int bpp)
+{
+	u32 dwGEMode;
+
+	dwGEMode = MMIO_IN32(0x04) & 0xFFFFFCFF;
+
+	switch (bpp) {
+	case 16:
+		dwGEMode |= VIA_GEM_16bpp;
+		break;
+	case 32:
+		dwGEMode |= VIA_GEM_32bpp;
+		break;
+	default:
+		dwGEMode |= VIA_GEM_8bpp;
+		break;
+	}
+
+	/* Set BPP and Pitch */
+	MMIO_OUT32(VIA_REG_GEMODE, dwGEMode);
+}
+
+void hw_cursor_init(void)
+{
+	/* Set Cursor Image Base Address */
+	MMIO_OUT32(VIA_REG_CURSOR_MODE, parinfo.cursor_start);
+	MMIO_OUT32(VIA_REG_CURSOR_POS, 0x0);
+	MMIO_OUT32(VIA_REG_CURSOR_ORG, 0x0);
+	MMIO_OUT32(VIA_REG_CURSOR_BG, 0x0);
+	MMIO_OUT32(VIA_REG_CURSOR_FG, 0x0);
+}
+
+void show_hw_cursor(struct fb_info *info, int Status) {
+	u32 temp;
+	u32 iga_path = ((struct viafb_par *)(info->par))->iga_path;
+
+	temp = MMIO_IN32(VIA_REG_CURSOR_MODE);
+	switch (Status) {
+	case HW_Cursor_ON:
+		temp |= 0x1;
+		break;
+	case HW_Cursor_OFF:
+		temp &= 0xFFFFFFFE;
+		break;
+	}
+	switch (iga_path) {
+	case IGA2:
+		temp |= 0x80000000;
+		break;
+	case IGA1:
+	default:
+		temp &= 0x7FFFFFFF;
+	}
+	MMIO_OUT32(VIA_REG_CURSOR_MODE, temp); }
+
+int wait_engine_idle(void)
+{
+	int loop = 0;
+
+	while (!(MMIO_IN32(VIA_REG_STATUS) & VIA_VR_QUEUE_BUSY)
+	       && (loop++ < MAXLOOP)) ;
+
+	while ((MMIO_IN32(VIA_REG_STATUS) &
+		(VIA_CMD_RGTR_BUSY | VIA_2D_ENG_BUSY | VIA_3D_ENG_BUSY))
&&
+	       (loop++ < MAXLOOP)) ;
+
+	return loop >= MAXLOOP;
+}
diff -Nur a/drivers/video/via/accel.h b/drivers/video/via/accel.h
--- a/drivers/video/via/accel.h	1969-12-31 19:00:00.000000000 -0500
+++ b/drivers/video/via/accel.h	2008-04-29 02:51:14.000000000 -0400
@@ -0,0 +1,190 @@
+/*
+ * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
+ * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
+
+ * This program is free software; you can redistribute it and/or modify
+ * it under  the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2, or (at your 
+ option)
+ * any later version.
+
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTIES OR REPRESENTATIONS; without even
+ * the implied warranty of MERCHANTABILITY or FITNESS FOR
+ * A PARTICULAR PURPOSE.See the GNU General Public License
+ * for more details.
+
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#ifndef __ACCEL_H__
+#define __ACCEL_H__
+
+#ifndef FB_ACCEL_VIA_UNICHROME
+#define FB_ACCEL_VIA_UNICHROME  50
+#endif
+
+/* MMIO Base Address Definition */
+#define MMIO_VGABASE                0x8000
+#define MMIO_CR_READ                MMIO_VGABASE + 0x3D4
+#define MMIO_CR_WRITE               MMIO_VGABASE + 0x3D5
+#define MMIO_SR_READ                MMIO_VGABASE + 0x3C4
+#define MMIO_SR_WRITE               MMIO_VGABASE + 0x3C5
+
+#ifndef VIA_MMIO
+#define VIA_MMIO 1
+#endif
+
+#if VIA_MMIO
+#define MMIO_OUT8(reg, val)  writeb(val, parinfo.io_virt + reg) #define

+MMIO_OUT16(reg, val) writew(val, parinfo.io_virt + reg) #define 
+MMIO_OUT32(reg, val) writel(val, parinfo.io_virt + reg)
+#define MMIO_IN8(reg)       readb(parinfo.io_virt + reg)
+#define MMIO_IN16(reg)      readw(parinfo.io_virt + reg)
+#define MMIO_IN32(reg)      readl(parinfo.io_virt + reg)
+
+#else
+#define MMIO_OUT8(reg, val)  outb(val, reg) #define MMIO_OUT16(reg, 
+val) outw(val, reg) #define MMIO_OUT32(reg, val) outl(val, reg)
+#define MMIO_IN8(reg)       inb(reg)
+#define MMIO_IN16(reg)      inw(reg)
+#define MMIO_IN32(reg)      inl(reg)
+#endif
+
+/* HW Cursor Status Define */
+#define HW_Cursor_ON    0
+#define HW_Cursor_OFF   1
+
+#define CURSOR_SIZE     (8 * 1024)
+#define VQ_SIZE         (256 * 1024)
+
+#define VIA_MMIO_BLTBASE        0x200000
+#define VIA_MMIO_BLTSIZE        0x200000
+
+/* Defines for 2D registers */
+#define VIA_REG_GECMD           0x000
+#define VIA_REG_GEMODE          0x004
+#define VIA_REG_SRCPOS          0x008
+#define VIA_REG_DSTPOS          0x00C
+/* width and height */
+#define VIA_REG_DIMENSION       0x010
+#define VIA_REG_PATADDR         0x014
+#define VIA_REG_FGCOLOR         0x018
+#define VIA_REG_BGCOLOR         0x01C
+/* top and left of clipping */
+#define VIA_REG_CLIPTL          0x020
+/* bottom and right of clipping */
+#define VIA_REG_CLIPBR          0x024
+#define VIA_REG_OFFSET          0x028
+/* color key control */
+#define VIA_REG_KEYCONTROL      0x02C
+#define VIA_REG_SRCBASE         0x030
+#define VIA_REG_DSTBASE         0x034
+/* pitch of src and dst */
+#define VIA_REG_PITCH           0x038
+#define VIA_REG_MONOPAT0        0x03C
+#define VIA_REG_MONOPAT1        0x040
+/* from 0x100 to 0x1ff */
+#define VIA_REG_COLORPAT        0x100
+
+/* VIA_REG_PITCH(0x38): Pitch Setting */
+#define VIA_PITCH_ENABLE        0x80000000
+
+/* defines for VIA HW cursor registers */
+#define VIA_REG_CURSOR_MODE     0x2D0
+#define VIA_REG_CURSOR_POS      0x2D4
+#define VIA_REG_CURSOR_ORG      0x2D8
+#define VIA_REG_CURSOR_BG       0x2DC
+#define VIA_REG_CURSOR_FG       0x2E0
+
+/* VIA_REG_GEMODE(0x04): GE mode */
+#define VIA_GEM_8bpp            0x00000000
+#define VIA_GEM_16bpp           0x00000100
+#define VIA_GEM_32bpp           0x00000300
+
+/* VIA_REG_GECMD(0x00): 2D Engine Command  */
+#define VIA_GEC_NOOP            0x00000000
+#define VIA_GEC_BLT             0x00000001
+#define VIA_GEC_LINE            0x00000005
+
+/* Rotate Command */
+#define VIA_GEC_ROT             0x00000008
+
+#define VIA_GEC_SRC_XY          0x00000000
+#define VIA_GEC_SRC_LINEAR      0x00000010
+#define VIA_GEC_DST_XY          0x00000000
+#define VIA_GEC_DST_LINRAT      0x00000020
+
+#define VIA_GEC_SRC_FB          0x00000000
+#define VIA_GEC_SRC_SYS         0x00000040
+#define VIA_GEC_DST_FB          0x00000000
+#define VIA_GEC_DST_SYS         0x00000080
+
+/* source is mono */
+#define VIA_GEC_SRC_MONO        0x00000100
+/* pattern is mono */
+#define VIA_GEC_PAT_MONO        0x00000200
+/* mono src is opaque */
+#define VIA_GEC_MSRC_OPAQUE     0x00000000
+/* mono src is transparent */
+#define VIA_GEC_MSRC_TRANS      0x00000400
+/* pattern is in frame buffer */
+#define VIA_GEC_PAT_FB          0x00000000
+/* pattern is from reg setting */
+#define VIA_GEC_PAT_REG         0x00000800
+
+#define VIA_GEC_CLIP_DISABLE    0x00000000
+#define VIA_GEC_CLIP_ENABLE     0x00001000
+
+#define VIA_GEC_FIXCOLOR_PAT    0x00002000
+
+#define VIA_GEC_INCX            0x00000000
+#define VIA_GEC_DECY            0x00004000
+#define VIA_GEC_INCY            0x00000000
+#define VIA_GEC_DECX            0x00008000
+/* mono pattern is opaque */
+#define VIA_GEC_MPAT_OPAQUE     0x00000000
+/* mono pattern is transparent */
+#define VIA_GEC_MPAT_TRANS      0x00010000
+
+#define VIA_GEC_MONO_UNPACK     0x00000000
+#define VIA_GEC_MONO_PACK       0x00020000
+#define VIA_GEC_MONO_DWORD      0x00000000
+#define VIA_GEC_MONO_WORD       0x00040000
+#define VIA_GEC_MONO_BYTE       0x00080000
+
+#define VIA_GEC_LASTPIXEL_ON    0x00000000
+#define VIA_GEC_LASTPIXEL_OFF   0x00100000
+#define VIA_GEC_X_MAJOR         0x00000000
+#define VIA_GEC_Y_MAJOR         0x00200000
+#define VIA_GEC_QUICK_START     0x00800000
+
+/* defines for VIA 3D registers */
+#define VIA_REG_STATUS          0x400
+#define VIA_REG_TRANSET         0x43C
+#define VIA_REG_TRANSPACE       0x440
+
+/* VIA_REG_STATUS(0x400): Engine Status */
+
+/* Command Regulator is busy */
+#define VIA_CMD_RGTR_BUSY       0x00000080
+/* 2D Engine is busy */
+#define VIA_2D_ENG_BUSY         0x00000002
+/* 3D Engine is busy */
+#define VIA_3D_ENG_BUSY         0x00000001
+/* Virtual Queue is busy */
+#define VIA_VR_QUEUE_BUSY       0x00020000
+
+#define MAXLOOP                 0xFFFFFF
+
+void init_accel(void);
+void init_2d_engine(void);
+void set_2d_color_depth(int);
+void hw_cursor_init(void);
+void show_hw_cursor(struct fb_info *info, int Status); int 
+wait_engine_idle(void);
+
+#endif /* __ACCEL_H__ */
diff -Nur a/drivers/video/via/chip.h b/drivers/video/via/chip.h
--- a/drivers/video/via/chip.h	1969-12-31 19:00:00.000000000 -0500
+++ b/drivers/video/via/chip.h	2008-04-29 02:51:15.000000000 -0400
@@ -0,0 +1,189 @@
+/*
+ * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
+ * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
+
+ * This program is free software; you can redistribute it and/or modify
+ * it under  the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2, or (at your 
+ option)
+ * any later version.
+
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTIES OR REPRESENTATIONS; without even
+ * the implied warranty of MERCHANTABILITY or FITNESS FOR
+ * A PARTICULAR PURPOSE.See the GNU General Public License
+ * for more details.
+
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+#ifndef __CHIP_H__
+#define __CHIP_H__
+
+#include "global.h"
+
+/***************************************/
+/* Definition Graphic Chip Information */ 
+/***************************************/
+
+#define     PCI_VIA_VENDOR_ID       0x1106
+
+/* Define VIA Graphic Chip Name */
+#define     UNICHROME_CLE266        1
+#define     UNICHROME_CLE266_DID    0x3122
+#define     CLE266_REVISION_AX      0x0A
+#define     CLE266_REVISION_CX      0x0C
+
+#define     UNICHROME_K400          2
+#define     UNICHROME_K400_DID      0x7205
+
+#define     UNICHROME_K800          3
+#define     UNICHROME_K800_DID      0x3108
+
+#define     UNICHROME_PM800          4
+#define     UNICHROME_PM800_DID      0x3118
+
+#define     UNICHROME_CN700         5
+#define     UNICHROME_CN700_DID     0x3344
+
+#define     UNICHROME_CX700         6
+#define     UNICHROME_CX700_DID     0x3157
+#define     CX700_REVISION_700         0x0
+#define     CX700_REVISION_700M      0x1
+#define     CX700_REVISION_700M2    0x2
+
+#define     UNICHROME_CN750         7
+#define     UNICHROME_CN750_DID     0x3225
+
+#define     UNICHROME_K8M890        8
+#define     UNICHROME_K8M890_DID    0x3230
+
+#define     UNICHROME_P4M890        9
+#define     UNICHROME_P4M890_DID    0x3343
+
+#define     UNICHROME_P4M900        10
+#define     UNICHROME_P4M900_DID    0x3371
+
+#define     UNICHROME_VX800         11
+#define     UNICHROME_VX800_DID     0x1122
+/**************************************************/
+/* Definition TMDS Trasmitter Information         */
+/**************************************************/
+
+/* Definition TMDS Trasmitter Index */
+#define     NON_TMDS_TRANSMITTER    0x00
+#define     VT1632_TMDS             0x01
+#define     INTEGRATED_TMDS         0x42
+
+/* Definition TMDS Trasmitter I2C Slave Address */
+#define     VT1632_TMDS_I2C_ADDR    0x10
+
+/**************************************************/
+/* Definition LVDS Trasmitter Information         */
+/**************************************************/
+
+/* Definition LVDS Trasmitter Index */
+#define     NON_LVDS_TRANSMITTER    0x00
+#define     VT1631_LVDS             0x01
+#define     VT1636_LVDS             0x0E
+#define     INTEGRATED_LVDS         0x41
+
+/* Definition Digital Transmitter Mode */
+#define     TX_DATA_12_BITS         0x01
+#define     TX_DATA_24_BITS         0x02
+#define     TX_DATA_DDR_MODE        0x04
+#define     TX_DATA_SDR_MODE        0x08
+
+/* Definition LVDS Trasmitter I2C Slave Address */
+#define     VT1631_LVDS_I2C_ADDR    0x70
+#define     VT3271_LVDS_I2C_ADDR    0x80
+#define     VT1636_LVDS_I2C_ADDR    0x80
+
+struct tmds_chip_information {
+	int tmds_chip_name;
+	int tmds_chip_slave_addr;
+	int dvi_panel_id;
+	int data_mode;
+	int output_interface;
+	int i2c_port;
+	int device_type;
+};
+
+struct lvds_chip_information {
+	int lvds_chip_name;
+	int lvds_chip_slave_addr;
+	int data_mode;
+	int output_interface;
+	int i2c_port;
+};
+
+struct chip_information {
+	int gfx_chip_name;
+	int gfx_chip_revision;
+	int chip_on_slot;
+	struct tmds_chip_information tmds_chip_info;
+	struct lvds_chip_information lvds_chip_info;
+	struct lvds_chip_information lvds_chip_info2; };
+
+struct crt_setting_information {
+	int iga_path;
+	int h_active;
+	int v_active;
+	int bpp;
+	int refresh_rate;
+};
+
+struct tmds_setting_information {
+	int iga_path;
+	int h_active;
+	int v_active;
+	int bpp;
+	int refresh_rate;
+	int get_dvi_size_method;
+	int max_pixel_clock;
+	int dvi_panel_size;
+	int dvi_panel_hres;
+	int dvi_panel_vres;
+	int native_size;
+};
+
+struct lvds_setting_information {
+	int iga_path;
+	int h_active;
+	int v_active;
+	int bpp;
+	int refresh_rate;
+	int get_lcd_size_method;
+	int lcd_panel_id;
+	int lcd_panel_size;
+	int lcd_panel_hres;
+	int lcd_panel_vres;
+	int display_method;
+	int device_lcd_dualedge;
+	int LCDDithering;
+	int lcd_mode;
+	u32 vclk;		/*panel mode clock value */
+};
+
+struct GFX_DPA_SETTING {
+	int ClkRangeIndex;
+	u8 DVP0;		/* CR96[3:0] */
+	u8 DVP0DataDri_S1;	/* SR2A[5]   */
+	u8 DVP0DataDri_S;	/* SR1B[1]   */
+	u8 DVP0ClockDri_S1;	/* SR2A[4]   */
+	u8 DVP0ClockDri_S;	/* SR1E[2]   */
+	u8 DVP1;		/* CR9B[3:0] */
+	u8 DVP1Driving;		/* SR65[3:0], Data and Clock driving */
+	u8 DFPHigh;		/* CR97[3:0] */
+	u8 DFPLow;		/* CR99[3:0] */
+
+};
+
+struct VT1636_DPA_SETTING {
+	int PanelSizeID;
+	u8 CLK_SEL_ST1;
+	u8 CLK_SEL_ST2;
+};
+#endif /* __CHIP_H__ */
diff -Nur a/drivers/video/via/debug.h b/drivers/video/via/debug.h
--- a/drivers/video/via/debug.h	1969-12-31 19:00:00.000000000 -0500
+++ b/drivers/video/via/debug.h	2008-05-04 06:42:33.000000000 -0400
@@ -0,0 +1,41 @@
+/*
+ * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
+ * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
+
+ * This program is free software; you can redistribute it and/or modify
+ * it under  the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2, or (at your 
+ option)
+ * any later version.
+
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTIES OR REPRESENTATIONS; without even
+ * the implied warranty of MERCHANTABILITY or FITNESS FOR
+ * A PARTICULAR PURPOSE.See the GNU General Public License
+ * for more details.
+
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+#ifndef __DEBUG_H__
+#define __DEBUG_H__
+
+#ifndef VIAFB_DEBUG
+#define VIAFB_DEBUG 0
+#endif
+
+#if VIAFB_DEBUG
+#define DEBUG_MSG(f, a...)   printk(f, ## a)
+#else
+#define DEBUG_MSG(f, a...)
+#endif
+
+#define VIAFB_WARN 0
+#if VIAFB_WARN
+#define WARN_MSG(f, a...)   printk(f, ## a)
+#else
+#define WARN_MSG(f, a...)
+#endif
+
+#endif /* __DEBUG_H__ */
diff -Nur a/drivers/video/via/dvi.c b/drivers/video/via/dvi.c
--- a/drivers/video/via/dvi.c	1969-12-31 19:00:00.000000000 -0500
+++ b/drivers/video/via/dvi.c	2008-05-04 07:28:49.000000000 -0400
@@ -0,0 +1,721 @@
+/*
+ * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
+ * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
+
+ * This program is free software; you can redistribute it and/or modify
+ * it under  the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2, or (at your 
+ option)
+ * any later version.
+
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTIES OR REPRESENTATIONS; without even
+ * the implied warranty of MERCHANTABILITY or FITNESS FOR
+ * A PARTICULAR PURPOSE.See the GNU General Public License
+ * for more details.
+
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+#include "global.h"
+
+int check_tmds_chip(int device_id_subaddr, int device_id) {
+	if (tmds_register_read(device_id_subaddr) == device_id)
+		return (OK);
+	else
+		return (FAIL);
+}
+
+void init_dvi_size(void)
+{
+	DEBUG_MSG(KERN_INFO "init_dvi_size()\n");
+	DEBUG_MSG(KERN_INFO "tmds_setting_info.get_dvi_size_method
%d\n",
+		  tmds_setting_info.get_dvi_size_method);
+
+	switch (tmds_setting_info.get_dvi_size_method) {
+	case GET_DVI_SIZE_BY_SYSTEM_BIOS:
+		break;
+	case GET_DVI_SZIE_BY_HW_STRAPPING:
+		break;
+	case GET_DVI_SIZE_BY_VGA_BIOS:
+	default:
+		dvi_get_panel_info();
+		break;
+	}
+	return;
+}
+
+int tmds_trasmitter_identify(void)
+{
+	unsigned char sr2a = 0, sr1e = 0, sr3e = 0;
+
+	/* Turn on ouputting pad */
+	switch (chip_info.gfx_chip_name) {
+	case UNICHROME_K8M890:
+	    /*=* DFP Low Pad on *=*/
+		sr2a = read_reg(VIASR, SR2A);
+		write_reg_mask(SR2A, VIASR, 0x03, BIT0 + BIT1);
+		break;
+
+	case UNICHROME_P4M900:
+	case UNICHROME_P4M890:
+		/* DFP Low Pad on */
+		sr2a = read_reg(VIASR, SR2A);
+		write_reg_mask(SR2A, VIASR, 0x03, BIT0 + BIT1);
+		/* DVP0 Pad on */
+		sr1e = read_reg(VIASR, SR1E);
+		write_reg_mask(SR1E, VIASR, 0xC0, BIT6 + BIT7);
+		break;
+
+	default:
+	    /* DVP0/DVP1 Pad on */
+		sr1e = read_reg(VIASR, SR1E);
+		write_reg_mask(SR1E, VIASR, 0xF0, BIT4 + BIT5 + BIT6 +
BIT7);
+	    /* SR3E[1]Multi-function selection:
+	    0 = Emulate I2C and DDC bus by GPIO2/3/4. */
+		sr3e = read_reg(VIASR, SR3E);
+		write_reg_mask(SR3E, VIASR, 0x0, BIT5);
+		break;
+	}
+
+	/* Check for VT1632: */
+	chip_info.tmds_chip_info.tmds_chip_name = VT1632_TMDS;
+	chip_info.tmds_chip_info.tmds_chip_slave_addr =
VT1632_TMDS_I2C_ADDR;
+	chip_info.tmds_chip_info.i2c_port = I2CPORTINDEX;
+	if (check_tmds_chip(VT1632_DEVICE_ID_REG, VT1632_DEVICE_ID) !=
FAIL) {
+	/*Currently only support 12bits,dual edge,add 24bits mode later
*/
+		tmds_register_write(0x08, 0x3b);
+
+		DEBUG_MSG(KERN_INFO "\n VT1632 TMDS ! \n");
+		DEBUG_MSG(KERN_INFO "\n %2d",
+			  chip_info.tmds_chip_info.tmds_chip_name);
+		DEBUG_MSG(KERN_INFO "\n %2d",
+			  chip_info.tmds_chip_info.i2c_port);
+		return (OK);
+	} else {
+		chip_info.tmds_chip_info.i2c_port = GPIOPORTINDEX;
+		if (check_tmds_chip(VT1632_DEVICE_ID_REG,
VT1632_DEVICE_ID)
+		    != FAIL) {
+			tmds_register_write(0x08, 0x3b);
+			DEBUG_MSG(KERN_INFO "\n VT1632 TMDS ! \n");
+			DEBUG_MSG(KERN_INFO "\n %2d",
+
chip_info.tmds_chip_info.tmds_chip_name);
+			DEBUG_MSG(KERN_INFO "\n %2d",
+				  chip_info.tmds_chip_info.i2c_port);
+			return (OK);
+		}
+	}
+
+	chip_info.tmds_chip_info.tmds_chip_name = INTEGRATED_TMDS;
+
+	if ((chip_info.gfx_chip_name == UNICHROME_CX700) &&
+	    ((display_hardware_layout == HW_LAYOUT_DVI_ONLY) ||
+	     (display_hardware_layout == HW_LAYOUT_LCD_DVI))) {
+		DEBUG_MSG(KERN_INFO "\n Integrated TMDS ! \n");
+		return (OK);
+	}
+
+	switch (chip_info.gfx_chip_name) {
+	case UNICHROME_K8M890:
+		write_reg(SR2A, VIASR, sr2a);
+		break;
+
+	case UNICHROME_P4M900:
+	case UNICHROME_P4M890:
+		write_reg(SR2A, VIASR, sr2a);
+		write_reg(SR1E, VIASR, sr1e);
+		break;
+
+	default:
+		write_reg(SR1E, VIASR, sr1e);
+		write_reg(SR3E, VIASR, sr3e);
+		break;
+	}
+
+	chip_info.tmds_chip_info.tmds_chip_name = NON_TMDS_TRANSMITTER;
+	chip_info.tmds_chip_info.tmds_chip_slave_addr =
VT1632_TMDS_I2C_ADDR;
+	return (FAIL);
+}
+
+void tmds_register_write(int index, u8 data) {
+	u8 tmp;
+
+	tmp = chip_info.chip_on_slot;
+	switch (chip_info.tmds_chip_info.i2c_port) {
+	case I2CPORTINDEX:
+		chip_info.chip_on_slot = PORT_ON_AMR;
+		break;
+
+	case GPIOPORTINDEX:
+	default:
+		chip_info.chip_on_slot = PORT_ON_AGP;
+		break;
+	}
+
+	i2cWriteByte(chip_info.tmds_chip_info.tmds_chip_slave_addr,
index,
+		     data);
+
+	chip_info.chip_on_slot = tmp;
+
+}
+
+int tmds_register_read(int index)
+{
+	u8 data;
+	int status;
+	u8 tmp;
+
+	tmp = chip_info.chip_on_slot;
+	switch (chip_info.tmds_chip_info.i2c_port) {
+	case I2CPORTINDEX:
+		chip_info.chip_on_slot = PORT_ON_AMR;
+		break;
+
+	case GPIOPORTINDEX:
+	default:
+		chip_info.chip_on_slot = PORT_ON_AGP;
+		break;
+	}
+
+	status =
+	    i2cReadByte((u8)
chip_info.tmds_chip_info.tmds_chip_slave_addr,
+			(u8) index, &data);
+	chip_info.chip_on_slot = tmp;
+	return (data);
+}
+
+int tmds_register_read_bytes(int index, u8 *buff, int buff_len) {
+	int status;
+	u8 tmp;
+
+	tmp = chip_info.chip_on_slot;
+	switch (chip_info.tmds_chip_info.i2c_port) {
+	case I2CPORTINDEX:
+		chip_info.chip_on_slot = PORT_ON_AMR;
+		break;
+
+	case GPIOPORTINDEX:
+	default:
+		chip_info.chip_on_slot = PORT_ON_AGP;
+		break;
+	}
+
+	status =
+	    i2cReadBytes((u8) chip_info.tmds_chip_info.
+			 tmds_chip_slave_addr, (u8) index, buff,
buff_len);
+	chip_info.chip_on_slot = tmp;
+	return (status);
+}
+
+int check_reduce_blanking_mode(int mode_index, int refresh_rate) {
+	if (refresh_rate != 60)
+		return (FALSE);
+
+	switch (mode_index) {
+		/* Following modes have reduce blanking mode. */
+	case VIA_RES_1360X768:
+	case VIA_RES_1400X1050:
+	case VIA_RES_1440X900:
+	case VIA_RES_1600X900:
+	case VIA_RES_1680X1050:
+	case VIA_RES_1920X1080:
+	case VIA_RES_1920X1200:
+		break;
+
+	default:
+		DEBUG_MSG(KERN_INFO
+			  "This dvi mode %d have no reduce blanking
mode!\n",
+			  mode_index);
+		return (FALSE);
+	}
+
+	return (TRUE);
+}
+
+/* DVI Set Mode */
+void dvi_set_mode(int video_index, int mode_bpp, int set_iga) {
+	struct VideoModeTable *videoMode = NULL;
+	struct crt_mode_table *pDviTiming;
+	unsigned long desirePixelClock, maxPixelClock;
+	int status = 0;
+	videoMode = get_modetbl_pointer(video_index);
+	pDviTiming = videoMode->crtc;
+	desirePixelClock = pDviTiming->clk / 1000000;
+	maxPixelClock = (unsigned
long)tmds_setting_info.max_pixel_clock;
+
+	DEBUG_MSG(KERN_INFO "\nDVI_set_mode!!\n");
+
+	if ((maxPixelClock != 0) && (desirePixelClock > maxPixelClock))
{
+		/*Check if reduce-blanking mode is exist */
+		status =
+		    check_reduce_blanking_mode(video_index,
+
pDviTiming->refresh_rate);
+		if (status) {
+			video_index += 100;	/*Use reduce-blanking
mode */
+			videoMode = get_modetbl_pointer(video_index);
+			pDviTiming = videoMode->crtc;
+			DEBUG_MSG(KERN_INFO
+				  "DVI use reduce blanking mode %d!!\n",
+				  video_index);
+		}
+	}
+	fill_crtc_timing(pDviTiming, video_index, mode_bpp / 8,
set_iga);
+	set_output_path(DEVICE_DVI, set_iga,
+			chip_info.tmds_chip_info.output_interface);
+}
+
+/* Sense DVI Connector */
+int dvi_sense(void)
+{
+	u8 RegSR1E = 0, RegSR3E = 0, RegCR6B = 0, RegCR91 = 0, RegCR93 =
+	    0, RegCR9B = 0, data;
+	int ret = FALSE;
+
+	DEBUG_MSG(KERN_INFO "dvi_sense!!\n");
+
+	if (chip_info.gfx_chip_name == UNICHROME_CLE266) {
+		/* DI1 Pad on */
+		RegSR1E = read_reg(VIASR, SR1E);
+		write_reg(SR1E, VIASR, RegSR1E | 0x30);
+
+		/* CR6B[0]VCK Input Selection: 1 = External clock. */
+		RegCR6B = read_reg(VIACR, CR6B);
+		write_reg(CR6B, VIACR, RegCR6B | 0x08);
+
+		/* CR91[4] VDD On [3] Data On [2] VEE On [1] Back Light
Off
+		   [0] Software Control Power Sequence */
+		RegCR91 = read_reg(VIACR, CR91);
+		write_reg(CR91, VIACR, 0x1D);
+
+		/* CR93[7] DI1 Data Source Selection: 1 = DSP2.
+		   CR93[5] DI1 Clock Source: 1 = internal.
+		   CR93[4] DI1 Clock Polarity.
+		   CR93[3:1] DI1 Clock Adjust. CR93[0] DI1 enable */
+		RegCR93 = read_reg(VIACR, CR93);
+		write_reg(CR93, VIACR, 0x01);
+	} else {
+		/* DVP0/DVP1 Pad on */
+		RegSR1E = read_reg(VIASR, SR1E);
+		write_reg(SR1E, VIASR, RegSR1E | 0xF0);
+
+		/* SR3E[1]Multi-function selection:
+		   0 = Emulate I2C and DDC bus by GPIO2/3/4. */
+		RegSR3E = read_reg(VIASR, SR3E);
+		write_reg(SR3E, VIASR, RegSR3E & (~0x20));
+
+		/* CR91[4] VDD On [3] Data On [2] VEE On [1] Back Light
Off
+		   [0] Software Control Power Sequence */
+		RegCR91 = read_reg(VIACR, CR91);
+		write_reg(CR91, VIACR, 0x1D);
+
+		/*CR9B[4] DVP1 Data Source Selection: 1 = From secondary
+		display.CR9B[2:0] DVP1 Clock Adjust */
+		RegCR9B = read_reg(VIACR, CR9B);
+		write_reg(CR9B, VIACR, 0x01);
+	}
+
+	data = (u8) tmds_register_read(0x09);
+	if (data & 0x04)
+		ret = TRUE;
+
+	if (ret == FALSE) {
+		if (dvi_query_EDID())
+			ret = TRUE;
+	}
+
+	/* Restore status */
+	if (chip_info.gfx_chip_name == UNICHROME_CLE266) {
+		write_reg(SR1E, VIASR, RegSR1E);
+		write_reg(CR6B, VIACR, RegCR6B);
+		write_reg(CR91, VIACR, RegCR91);
+		write_reg(CR93, VIACR, RegCR93);
+	} else {
+		write_reg(SR1E, VIASR, RegSR1E);
+		write_reg(SR3E, VIASR, RegSR3E);
+		write_reg(CR91, VIACR, RegCR91);
+		write_reg(CR9B, VIACR, RegCR9B);
+	}
+
+	return ret;
+}
+
+/* Query Flat Panel's EDID Table Version Through DVI Connector */ int 
+dvi_query_EDID(void) {
+	u8 data0, data1;
+	int restore;
+
+	DEBUG_MSG(KERN_INFO "dvi_query_EDID!!\n");
+
+	restore = chip_info.tmds_chip_info.tmds_chip_slave_addr;
+	chip_info.tmds_chip_info.tmds_chip_slave_addr = 0xA0;
+
+	data0 = (u8) tmds_register_read(0x00);
+	data1 = (u8) tmds_register_read(0x01);
+	if ((data0 == 0) && (data1 == 0xFF)) {
+		chip_info.tmds_chip_info.tmds_chip_slave_addr = restore;
+		return (EDID_VERSION_1);	/* Found EDID1 Table */
+	}
+
+	data0 = (u8) tmds_register_read(0x00);
+	chip_info.tmds_chip_info.tmds_chip_slave_addr = restore;
+	if (data0 == 0x20)
+		return (EDID_VERSION_2);	/* Found EDID2 Table */
+	else
+		return (FALSE);
+}
+
+/*
+ *
+ * int dvi_get_panel_size_from_DDCv1(void)
+ *
+ *     - Get Panel Size Using EDID1 Table
+ *
+ * Return Type:    int
+ *
+ */
+int dvi_get_panel_size_from_DDCv1(void)
+{
+	int i, max_h = 0, max_v = 0, tmp, restore;
+	unsigned char rData;
+	unsigned char EDID_DATA[18];
+
+	DEBUG_MSG(KERN_INFO "\n dvi_get_panel_size_from_DDCv1 \n");
+
+	restore = chip_info.tmds_chip_info.tmds_chip_slave_addr;
+	chip_info.tmds_chip_info.tmds_chip_slave_addr = 0xA0;
+
+	for (i = 0x23; i < 0x6D; i++) {
+		switch (i) {
+		case 0x23:
+			rData = tmds_register_read(0x23);
+			if (rData & 0x3C)
+				max_h = 640;
+			if (rData & 0xC0)
+				max_h = 720;
+			if (rData & 0x03)
+				max_h = 800;
+			break;
+		case 0x24:
+			rData = tmds_register_read(0x24);
+			if (rData & 0xC0)
+				max_h = 800;
+			if (rData & 0x1E)
+				max_h = 1024;
+			if (rData & 0x01)
+				max_h = 1280;
+			break;
+		case 0x26:
+		case 0x28:
+		case 0x2A:
+		case 0x2C:
+		case 0x2E:
+		case 0x30:
+		case 0x32:
+		case 0x34:
+			rData = tmds_register_read(i);
+			if (rData == 1)
+				break;
+			/* data = (data + 31) * 8 */
+			tmp = (rData + 31) << 3;
+			if (tmp > max_h)
+				max_h = tmp;
+			break;
+
+		case 0x36:
+		case 0x48:
+		case 0x5A:
+		case 0x6C:
+			tmds_register_read_bytes(i, EDID_DATA, 10);
+			if (!(EDID_DATA[0] || EDID_DATA[1])) {
+				/* The first two byte must be zero. */
+				if (EDID_DATA[3] == 0xFD) {
+					/* To get max pixel clock. */
+
tmds_setting_info.max_pixel_clock =
+					    EDID_DATA[9] * 10;
+				}
+			}
+			break;
+
+		default:
+			break;
+		}
+	}
+
+	switch (max_h) {
+	case 640:
+		tmds_setting_info.dvi_panel_size = VIA_RES_640X480;
+		break;
+	case 800:
+		tmds_setting_info.dvi_panel_size = VIA_RES_800X600;
+		break;
+	case 1024:
+		tmds_setting_info.dvi_panel_size = VIA_RES_1024X768;
+		break;
+	case 1280:
+		tmds_setting_info.dvi_panel_size = VIA_RES_1280X1024;
+		break;
+	case 1400:
+		tmds_setting_info.dvi_panel_size = VIA_RES_1400X1050;
+		break;
+	case 1440:
+		tmds_setting_info.dvi_panel_size = VIA_RES_1440X1050;
+		break;
+	case 1600:
+		tmds_setting_info.dvi_panel_size = VIA_RES_1600X1200;
+		break;
+	case 1920:
+		if (max_v == 1200)
+			tmds_setting_info.dvi_panel_size =
VIA_RES_1920X1200;
+		else
+			tmds_setting_info.dvi_panel_size =
VIA_RES_1920X1080;
+		break;
+	default:
+		tmds_setting_info.dvi_panel_size = VIA_RES_1024X768;
+		DEBUG_MSG(KERN_INFO "Unknow panel size max resolution =
%d !\
+					 set default panel size.\n",
max_h);
+		break;
+	}
+
+	DEBUG_MSG(KERN_INFO "DVI max pixelclock = %d\n",
+		  tmds_setting_info.max_pixel_clock);
+	chip_info.tmds_chip_info.tmds_chip_slave_addr = restore;
+	return tmds_setting_info.dvi_panel_size; }
+
+/*
+ *
+ * int dvi_get_panel_size_from_DDCv2(void)
+ *
+ *     - Get Panel Size Using EDID2 Table
+ *
+ * Return Type:    int
+ *
+ */
+int dvi_get_panel_size_from_DDCv2(void)
+{
+	int HSize = 0, restore;
+	unsigned char R_Buffer[2];
+
+	DEBUG_MSG(KERN_INFO "\n dvi_get_panel_size_from_DDCv2 \n");
+
+	restore = chip_info.tmds_chip_info.tmds_chip_slave_addr;
+	chip_info.tmds_chip_info.tmds_chip_slave_addr = 0xA2;
+
+	/* Horizontal: 0x76, 0x77 */
+	tmds_register_read_bytes(0x76, R_Buffer, 2);
+	HSize = R_Buffer[0];
+	HSize += R_Buffer[1] << 8;
+
+	switch (HSize) {
+	case 640:
+		tmds_setting_info.dvi_panel_size = VIA_RES_640X480;
+		break;
+	case 800:
+		tmds_setting_info.dvi_panel_size = VIA_RES_800X600;
+		break;
+	case 1024:
+		tmds_setting_info.dvi_panel_size = VIA_RES_1024X768;
+		break;
+	case 1280:
+		tmds_setting_info.dvi_panel_size = VIA_RES_1280X1024;
+		break;
+	case 1400:
+		tmds_setting_info.dvi_panel_size = VIA_RES_1400X1050;
+		break;
+	case 1440:
+		tmds_setting_info.dvi_panel_size = VIA_RES_1440X1050;
+		break;
+	case 1600:
+		tmds_setting_info.dvi_panel_size = VIA_RES_1600X1200;
+		break;
+	default:
+		tmds_setting_info.dvi_panel_size = VIA_RES_1024X768;
+		DEBUG_MSG(KERN_INFO "Unknow panel size max resolution =
%d!\
+					set default panel size.\n",
HSize);
+		break;
+	}
+
+	chip_info.tmds_chip_info.tmds_chip_slave_addr = restore;
+	return tmds_setting_info.dvi_panel_size; }
+
+/*
+ *
+ * unsigned char dvi_get_panel_info(void)
+ *
+ *     - Get Panel Size
+ *
+ * Return Type:    unsigned char
+ */
+unsigned char dvi_get_panel_info(void)
+{
+	DEBUG_MSG(KERN_INFO "dvi_get_panel_info! \n");
+
+	dvi_sense();
+	switch (dvi_query_EDID()) {
+	case 1:
+		dvi_get_panel_size_from_DDCv1();
+		break;
+	case 2:
+		dvi_get_panel_size_from_DDCv2();
+		break;
+	default:
+		break;
+	}
+
+	DEBUG_MSG(KERN_INFO "dvi panel size is %2d \n",
+		  tmds_setting_info.dvi_panel_size);
+	return (unsigned char)(tmds_setting_info.dvi_panel_size);
+}
+
+/* If Disable DVI, turn off pad */
+void dvi_disable(void)
+{
+	if (chip_info.tmds_chip_info.output_interface == INTERFACE_DVP0)
+		write_reg(SR1E, VIASR, read_reg(VIASR, SR1E) & (~0xC0));
+
+	if (chip_info.tmds_chip_info.output_interface == INTERFACE_DVP1)
+		write_reg(SR1E, VIASR, read_reg(VIASR, SR1E) & (~0x30));
+
+	if (chip_info.tmds_chip_info.output_interface ==
INTERFACE_DFP_HIGH)
+		write_reg(SR2A, VIASR, read_reg(VIASR, SR2A) & (~0x0C));
+
+	if (chip_info.tmds_chip_info.output_interface ==
INTERFACE_DFP_LOW)
+		write_reg(SR2A, VIASR, read_reg(VIASR, SR2A) & (~0x03));
+
+	if (chip_info.tmds_chip_info.output_interface == INTERFACE_TMDS)
+		/* Turn off TMDS power. */
+		write_reg(CRD2, VIACR, read_reg(VIACR, CRD2) | 0x08); }
+
+/* If Enable DVI, turn off pad */
+void dvi_enable(void)
+{
+	if (chip_info.tmds_chip_info.output_interface == INTERFACE_DVP0)
{
+		write_reg(SR1E, VIASR, read_reg(VIASR, SR1E) | 0xC0);
+		if (chip_info.gfx_chip_name == UNICHROME_CLE266)
+			tmds_register_write(0x88, 0x3b);
+		else
+			/*clear CR91[5] to direct on display period
+			   in the secondary diplay path */
+			write_reg(CR91, VIACR, read_reg(VIACR, CR91) &
0xDF);
+	}
+
+	if (chip_info.tmds_chip_info.output_interface == INTERFACE_DVP1)
{
+		write_reg(SR1E, VIASR, read_reg(VIASR, SR1E) | 0x30);
+
+		/*fix dvi cann't be enabled with MB VT5718C4 - Al Zhang
*/
+		if (chip_info.gfx_chip_name == UNICHROME_CLE266) {
+			tmds_register_write(0x88, 0x3b);
+		} else {
+			/*clear CR91[5] to direct on display period
+			  in the secondary diplay path */
+			write_reg(CR91, VIACR, read_reg(VIACR, CR91) &
0xDF);
+		}
+
+		/*fix DVI cannot enable on EPIA-M board */
+		if (platform_epia_dvi == 1) {
+			write_reg_mask(CR91, VIACR, 0x1f, 0x1f);
+			write_reg_mask(CR88, VIACR, 0x00, BIT6 + BIT0);
+			if (via_bus_width == 24) {
+				if (device_lcd_dualedge == 1)
+					i2cWriteByte(chip_info.
+						     tmds_chip_info.
+
tmds_chip_slave_addr,
+						     0x08, 0x3F);
+				else
+					i2cWriteByte(chip_info.
+						     tmds_chip_info.
+
tmds_chip_slave_addr,
+						     0x08, 0x37);
+			}
+		}
+	}
+
+	if (chip_info.tmds_chip_info.output_interface ==
INTERFACE_DFP_HIGH) {
+		write_reg(SR2A, VIASR, read_reg(VIASR, SR2A) | 0x0C);
+		write_reg(CR91, VIACR, read_reg(VIACR, CR91) & 0xDF);
+	}
+
+	if (chip_info.tmds_chip_info.output_interface ==
INTERFACE_DFP_LOW) {
+		write_reg(SR2A, VIASR, read_reg(VIASR, SR2A) | 0x03);
+		write_reg(CR91, VIACR, read_reg(VIACR, CR91) & 0xDF);
+	}
+	if (chip_info.tmds_chip_info.output_interface == INTERFACE_TMDS)
{
+		/* Turn on Display period in the panel path. */
+		write_reg_mask(CR91, VIACR, 0, BIT7);
+
+		/* Turn on TMDS power. */
+		write_reg_mask(CRD2, VIACR, 0, BIT3);
+	}
+}
+
+int check_hdmi_connected_device(void)
+{
+	int bEdidExist = FALSE;
+	u8 byTemp = 0, byTemp1 = 0, byTemp2 = 0;
+	u8 byVendorDataBlock;
+	int restore, result = DEV_CONNECT_DVI;
+
+	restore = chip_info.tmds_chip_info.tmds_chip_slave_addr;
+	chip_info.tmds_chip_info.tmds_chip_slave_addr = 0xA0;
+	byTemp = (u8) tmds_register_read(0x00);
+
+	if (byTemp == 0x00) {
+		byTemp = (u8) tmds_register_read(0x01);
+		if (byTemp == 0xFF)
+			bEdidExist = TRUE;
+	}
+
+	if (bEdidExist) {
+		byTemp = (u8) tmds_register_read(0x80);
+		byTemp1 = (u8) tmds_register_read(0x81);
+
+		if (byTemp == 0x02 && byTemp1 == 0x03) {
+			byTemp = (u8) tmds_register_read(0x82);
+
+			if (!(byTemp == 0 || byTemp == 4)) {
+				byVendorDataBlock = 0x82 + 2;
+
+				byTemp1 = (u8)
+
tmds_register_read(byVendorDataBlock);
+				while ((byTemp1 & 0xE0) != 0x60
+				       && byVendorDataBlock < (byTemp +
0x82)) {
+					byTemp1 &= 0x1F;
+
+					byVendorDataBlock += (byTemp1 +
1);
+
+					byTemp1 = (u8)
+					    tmds_register_read
+					    (byVendorDataBlock);
+				}
+				if ((byTemp1 & 0xE0) == 0x60) {
+					byTemp = (u8)
+					    tmds_register_read
+					    (byVendorDataBlock + 1);
+					byTemp1 = (u8)
+					    tmds_register_read
+					    (byVendorDataBlock + 2);
+					byTemp2 = (u8)
+					    tmds_register_read
+					    (byVendorDataBlock + 3);
+
+					if (byTemp == 0x03
+					    && byTemp1 == 0x0C
+					    && byTemp2 == 0x00)
+						result =
DEV_CONNECT_HDMI;
+				}
+			}
+		}
+	}
+
+	chip_info.tmds_chip_info.tmds_chip_slave_addr = restore;
+	return result;
+}
