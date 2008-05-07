Return-Path: <linux-kernel-owner+w=401wt.eu-S1755762AbYEGLLC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762AbYEGLLC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 07:11:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756874AbYEGLJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 07:09:45 -0400
Received: from mailtp.via.com.tw ([61.66.243.2]:1331 "EHLO mailtp.via.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755915AbYEGLJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 07:09:41 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: [Linux-fbdev-devel] [PATCH 4/9] viafb: VIA Frame Buffer Device Driver
Date: Wed, 7 May 2008 19:09:36 +0800
Message-ID: <C80EF34A3D2E494DBAF9AC29C7AE4EB806F67755@exchtp03.taipei.via.com.tw>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Linux-fbdev-devel] [PATCH 4/9] viafb: VIA Frame Buffer Device Driver
Thread-Index: AcivqWbF3qyu30s5RguMHG+BNihXBgAhNGrAAAA1T2AAABOmsAAAH3FwAAAG77AAAALdcA==
From: <JosephChan@via.com.tw>
To: <JosephChan@via.com.tw>, <akpm@linux-foundation.org>,
       <geert@linux-m68k.org>
Cc: <linux-fbdev-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 07 May 2008 11:09:37.0631 (UTC) FILETIME=[D6A8F6F0:01C8B032]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m47BBTEB002109

Signed-off-by: Joseph Chan <josephchan@via.com.tw>

diff -Nur a/drivers/video/via/ioctl.h b/drivers/video/via/ioctl.h
--- a/drivers/video/via/ioctl.h	1969-12-31 19:00:00.000000000 -0500
+++ b/drivers/video/via/ioctl.h	2008-04-29 05:31:51.000000000 -0400
@@ -0,0 +1,212 @@
+/*
+ * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
+ * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
+
+ * This program is free software; you can redistribute it and/or modify
+ * it under  the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2, or (at your option)
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
+#ifndef __IOCTL_H__
+#define __IOCTL_H__
+
+#ifndef __user
+#define __user
+#endif
+
+/* VIAFB IOCTL definition */
+#define VIAFB_GET_INFO_SIZE		0x56494101	/* 'VIA\01' */
+#define VIAFB_GET_INFO			0x56494102	/* 'VIA\02' */
+#define VIAFB_HOTPLUG			0x56494103	/* 'VIA\03' */
+#define VIAFB_SET_HOTPLUG_FLAG		0x56494104	/* 'VIA\04' */
+#define VIAFB_GET_RESOLUTION		0x56494105	/* 'VIA\05' */
+#define VIAFB_GET_SAMM_INFO		0x56494107	/* 'VIA\07' */
+#define VIAFB_TURN_ON_OUTPUT_DEVICE     0x56494108	/* 'VIA\08' */
+#define VIAFB_TURN_OFF_OUTPUT_DEVICE    0x56494109	/* 'VIA\09' */
+#define VIAFB_SET_DEVICE		0x5649410A
+#define VIAFB_GET_DEVICE		0x5649410B
+#define VIAFB_GET_DRIVER_VERSION	0x56494112	/* 'VIA\12' */
+#define VIAFB_GET_CHIP_INFO		0x56494113	/* 'VIA\13' */
+#define VIAFB_SET_DEVICE_INFO           0x56494114
+#define VIAFB_GET_DEVICE_INFO           0x56494115
+
+#define VIAFB_GET_DEVICE_SUPPORT	0x56494118
+#define VIAFB_GET_DEVICE_CONNECT	0x56494119
+#define VIAFB_GET_PANEL_SUPPORT_EXPAND	0x5649411A
+#define VIAFB_GET_DRIVER_NAME		0x56494122
+#define VIAFB_GET_DEVICE_SUPPORT_STATE	0x56494123
+#define VIAFB_GET_GAMMA_LUT		0x56494124
+#define VIAFB_SET_GAMMA_LUT		0x56494125
+#define VIAFB_GET_GAMMA_SUPPORT_STATE	0x56494126
+#define VIAFB_SET_VIDEO_DEVICE		0x56494127
+#define VIAFB_GET_VIDEO_DEVICE		0x56494128
+#define VIAFB_SET_SECOND_MODE		0x56494129
+#define VIAFB_SYNC_SURFACE		0x56494130
+#define VIAFB_GET_DRIVER_CAPS		0x56494131
+#define VIAFB_GET_IGA_SCALING_INFO	0x56494132
+#define VIAFB_GET_PANEL_MAX_SIZE	0x56494133
+#define VIAFB_GET_PANEL_MAX_POSITION	0x56494134
+#define VIAFB_SET_PANEL_SIZE		0x56494135
+#define VIAFB_SET_PANEL_POSITION        0x56494136
+#define VIAFB_GET_PANEL_POSITION        0x56494137
+#define VIAFB_GET_PANEL_SIZE		0x56494138
+
+#define None_Device 0x00
+#define CRT_Device  0x01
+#define LCD_Device  0x02
+#define DVI_Device  0x08
+#define CRT2_Device 0x10
+#define LCD2_Device 0x40
+
+#define OP_LCD_CENTERING   0x01
+#define OP_LCD_PANEL_ID    0x02
+#define OP_LCD_MODE        0x03
+
+/*SAMM operation flag*/
+#define OP_SAMM            0x80
+
+#define LCD_PANEL_ID_MAXIMUM	22
+
+#define STATE_ON            0x1
+#define STATE_OFF           0x0
+#define STATE_DEFAULT       0xFFFF
+
+#define MAX_ACTIVE_DEV_NUM  2
+
+struct device_t {
+	unsigned short crt:1;
+	unsigned short dvi:1;
+	unsigned short lcd:1;
+	unsigned short samm:1;
+	unsigned short primary_dev;
+
+	unsigned short lcd_dsp_cent:1;
+	unsigned char lcd_panel_id;
+	unsigned char lcd_mode:1;
+
+	unsigned short xres, yres;
+	unsigned short xres1, yres1;
+	unsigned short refresh;
+	unsigned short bpp;
+	unsigned short refresh1;
+	unsigned short bpp1;
+	unsigned short sequence;
+
+	unsigned short epia_dvi:1;
+	unsigned short lcd_dual_edge:1;
+	unsigned short bus_width;
+	unsigned short lcd2:1;
+};
+
+struct viafb_ioctl_info {
+	u32 viafb_id;		/* for identifying viafb */
+#define VIAID       0x56494146	/* Identify myself with 'VIAF' */
+	u16 vendor_id;
+	u16 device_id;
+	u8 version;
+	u8 revision;
+	u8 reserved[246];	/* for future use */
+};
+
+struct viafb_ioctl_mode {
+	u32 xres;
+	u32 yres;
+	u32 refresh;
+	u32 bpp;
+	u32 xres_sec;
+	u32 yres_sec;
+	u32 virtual_xres_sec;
+	u32 virtual_yres_sec;
+	u32 refresh_sec;
+	u32 bpp_sec;
+};
+struct viafb_ioctl_samm {
+	u32 samm_status;
+	u32 size_prim;
+	u32 size_sec;
+	u32 mem_base;
+	u32 offset_sec;
+};
+
+struct viafb_driver_version {
+	int iMajorNum;
+	int iKernelNum;
+	int iOSNum;
+	int iMinorNum;
+};
+
+struct viafb_ioctl_lcd_attribute {
+	unsigned int panel_id;
+	unsigned int display_center;
+	unsigned int lcd_mode;
+};
+
+struct viafb_ioctl_setting {
+	/* Enable or disable active devices */
+	unsigned short device_flag;
+	/* Indicate which device should be turn on or turn off. */
+	unsigned short device_status;
+	unsigned int reserved;
+	/* Indicate which LCD's attribute can be changed. */
+	unsigned short lcd_operation_flag;
+	/* 1: SAMM ON  0: SAMM OFF */
+	unsigned short samm_status;
+	/* horizontal resolution of first device */
+	unsigned short first_dev_hor_res;
+	/* vertical resolution of first device */
+	unsigned short first_dev_ver_res;
+	/* horizontal resolution of second device */
+	unsigned short second_dev_hor_res;
+	/* vertical resolution of second device */
+	unsigned short second_dev_ver_res;
+	/* refresh rate of first device */
+	unsigned short first_dev_refresh;
+	/* bpp of first device */
+	unsigned short first_dev_bpp;
+	/* refresh rate of second device */
+	unsigned short second_dev_refresh;
+	/* bpp of second device */
+	unsigned short second_dev_bpp;
+	/* Indicate which device are primary display device. */
+	unsigned int primary_device;
+	/* Indicate which device will show video. only valid in duoview mode */
+	unsigned int video_device_status;
+	unsigned int struct_reserved[34];
+	struct viafb_ioctl_lcd_attribute lcd_attributes;
+};
+
+struct _UTFunctionCaps {
+	unsigned int dw3DScalingState;
+	unsigned int reserved[31];
+};
+
+struct _POSITIONVALUE {
+	unsigned int dwX;
+	unsigned int dwY;
+};
+
+struct _panel_size_pos_info {
+	unsigned int device_type;
+	int x;
+	int y;
+};
+
+extern int LCD_ON;
+extern int DVI_ON;
+
+int ioctl_get_viafb_info(u_long arg);
+int ioctl_hotplug(int hres, int vres, int bpp);
+
+#endif /* __IOCTL_H__ */
diff -Nur a/drivers/video/via/lcd.c b/drivers/video/via/lcd.c
--- a/drivers/video/via/lcd.c	1969-12-31 19:00:00.000000000 -0500
+++ b/drivers/video/via/lcd.c	2008-05-04 07:13:03.000000000 -0400
@@ -0,0 +1,1741 @@
+/*
+ * Copyright 1998-2008 VIA Technologies, Inc. All Rights Reserved.
+ * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
+
+ * This program is free software; you can redistribute it and/or modify
+ * it under  the terms of the GNU General Public License as published
+ * by the Free Software Foundation; either version 2, or (at your option)
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
+#include "global.h"
+#include "lcdtbl.h"
+
+struct iga2_shadow_crtc_timing iga2_shadow_crtc_reg = {
+	/* IGA2 Shadow Horizontal Total */
+	{IGA2_SHADOW_HOR_TOTAL_REG_NUM, {{CR6D, 0, 7}, {CR71, 3, 3} } },
+	/* IGA2 Shadow Horizontal Blank End */
+	{IGA2_SHADOW_HOR_BLANK_END_REG_NUM, {{CR6E, 0, 7} } },
+	/* IGA2 Shadow Vertical Total */
+	{IGA2_SHADOW_VER_TOTAL_REG_NUM, {{CR6F, 0, 7}, {CR71, 0, 2} } },
+	/* IGA2 Shadow Vertical Addressable Video */
+	{IGA2_SHADOW_VER_ADDR_REG_NUM, {{CR70, 0, 7}, {CR71, 4, 6} } },
+	/* IGA2 Shadow Vertical Blank Start */
+	{IGA2_SHADOW_VER_BLANK_START_REG_NUM,
+	 {{CR72, 0, 7}, {CR74, 4, 6} } },
+	/* IGA2 Shadow Vertical Blank End */
+	{IGA2_SHADOW_VER_BLANK_END_REG_NUM, {{CR73, 0, 7}, {CR74, 0, 2} } },
+	/* IGA2 Shadow Vertical Sync Start */
+	{IGA2_SHADOW_VER_SYNC_START_REG_NUM, {{CR75, 0, 7}, {CR76, 4, 6} } },
+	/* IGA2 Shadow Vertical Sync End */
+	{IGA2_SHADOW_VER_SYNC_END_REG_NUM, {{CR76, 0, 3} } }
+};
+
+struct _lcd_scaling_factor lcd_scaling_factor = {
+	/* LCD Horizontal Scaling Factor Register */
+	{LCD_HOR_SCALING_FACTOR_REG_NUM,
+	 {{CR9F, 0, 1}, {CR77, 0, 7}, {CR79, 4, 5} } },
+	/* LCD Vertical Scaling Factor Register */
+	{LCD_VER_SCALING_FACTOR_REG_NUM,
+	 {{CR79, 3, 3}, {CR78, 0, 7}, {CR79, 6, 7} } }
+};
+struct _lcd_scaling_factor lcd_scaling_factor_CLE = {
+	/* LCD Horizontal Scaling Factor Register */
+	{LCD_HOR_SCALING_FACTOR_REG_NUM_CLE, {{CR77, 0, 7}, {CR79, 4, 5} } },
+	/* LCD Vertical Scaling Factor Register */
+	{LCD_VER_SCALING_FACTOR_REG_NUM_CLE, {{CR78, 0, 7}, {CR79, 6, 7} } }
+};
+
+int check_lvds_chip(int device_id_subaddr, int device_id)
+{
+	if (lvds_register_read(device_id_subaddr) == device_id)
+		return (OK);
+	else
+		return (FAIL);
+}
+
+void init_lcd_size(void)
+{
+	DEBUG_MSG(KERN_INFO "init_lcd_size()\n");
+	DEBUG_MSG(KERN_INFO "lvds_setting_info.get_lcd_size_method %d\n",
+		  lvds_setting_info.get_lcd_size_method);
+
+	switch (lvds_setting_info.get_lcd_size_method) {
+	case GET_LCD_SIZE_BY_SYSTEM_BIOS:
+		break;
+	case GET_LCD_SZIE_BY_HW_STRAPPING:
+		break;
+	case GET_LCD_SIZE_BY_VGA_BIOS:
+		DEBUG_MSG(KERN_INFO "Get LCD Size method by VGA BIOS !!\n");
+		lvds_setting_info.lcd_panel_size =
+		    fp_id_to_vindex(lcd_panel_id);
+		DEBUG_MSG(KERN_INFO "LCD Panel_ID = %d\n",
+			  lvds_setting_info.lcd_panel_id);
+		DEBUG_MSG(KERN_INFO "LCD Panel Size = %d\n",
+			  lvds_setting_info.lcd_panel_size);
+		break;
+	case GET_LCD_SIZE_BY_USER_SETTING:
+		DEBUG_MSG(KERN_INFO "Get LCD Size method by user setting !!\n");
+		lvds_setting_info.lcd_panel_size =
+		    fp_id_to_vindex(lcd_panel_id);
+		DEBUG_MSG(KERN_INFO "LCD Panel_ID = %d\n",
+			  lvds_setting_info.lcd_panel_id);
+		DEBUG_MSG(KERN_INFO "LCD Panel Size = %d\n",
+			  lvds_setting_info.lcd_panel_size);
+		break;
+	default:
+		DEBUG_MSG(KERN_INFO "init_lcd_size fail\n");
+		lvds_setting_info.lcd_panel_id = LCD_PANEL_ID1_800X600;
+		lvds_setting_info.lcd_panel_size =
+		    fp_id_to_vindex(LCD_PANEL_ID1_800X600);
+	}
+	lvds_setting_info2.lcd_panel_id = lvds_setting_info.lcd_panel_id;
+	lvds_setting_info2.lcd_panel_size = lvds_setting_info.lcd_panel_size;
+	lvds_setting_info2.lcd_panel_hres = lvds_setting_info.lcd_panel_hres;
+	lvds_setting_info2.lcd_panel_vres = lvds_setting_info.lcd_panel_vres;
+	lvds_setting_info2.device_lcd_dualedge =
+	    lvds_setting_info.device_lcd_dualedge;
+	lvds_setting_info2.LCDDithering = lvds_setting_info.LCDDithering;
+}
+
+bool lvds_identify_integratedlvds(void)
+{
+	if (display_hardware_layout == HW_LAYOUT_LCD_EXTERNAL_LCD2) {
+		/* Two dual channel LCD (Internal LVDS + External LVDS): */
+		/* If we have an external LVDS, such as VT1636, we should
+		   have its chip ID already. */
+		if (chip_info.lvds_chip_info.lvds_chip_name) {
+			chip_info.lvds_chip_info2.lvds_chip_name =
+			    INTEGRATED_LVDS;
+			DEBUG_MSG(KERN_INFO "Support two dual channel LVDS!\
+				  (Internal LVDS + External LVDS)\n");
+		} else {
+			chip_info.lvds_chip_info.lvds_chip_name =
+			    INTEGRATED_LVDS;
+			DEBUG_MSG(KERN_INFO "Not found external LVDS,\
+				  so can't support two dual channel LVDS!\n");
+		}
+	} else if (display_hardware_layout == HW_LAYOUT_LCD1_LCD2) {
+		/* Two single channel LCD (Internal LVDS + Internal LVDS): */
+		chip_info.lvds_chip_info.lvds_chip_name = INTEGRATED_LVDS;
+		chip_info.lvds_chip_info2.lvds_chip_name = INTEGRATED_LVDS;
+		DEBUG_MSG(KERN_INFO "Support two single channel LVDS!\
+			  (Internal LVDS + Internal LVDS)\n");
+	} else if (display_hardware_layout != HW_LAYOUT_DVI_ONLY) {
+		/* If we have found external LVDS, just use it,
+		   otherwise, we will use internal LVDS as default. */
+		if (!chip_info.lvds_chip_info.lvds_chip_name) {
+			chip_info.lvds_chip_info.lvds_chip_name =
+			    INTEGRATED_LVDS;
+			DEBUG_MSG(KERN_INFO "Found Integrated LVDS!\n");
+		}
+	} else {
+		chip_info.lvds_chip_info.lvds_chip_name = NON_LVDS_TRANSMITTER;
+		DEBUG_MSG(KERN_INFO "Do not support LVDS!\n");
+		return FALSE;
+	}
+
+	return TRUE;
+}
+
+int lvds_trasmitter_identify(void)
+{
+	u8 tmp;
+	tmp = chip_info.chip_on_slot;
+	chip_info.chip_on_slot = PORT_ON_AMR;
+	if (lvds_identify_vt1636()) {
+		chip_info.lvds_chip_info.i2c_port = I2CPORTINDEX;
+		DEBUG_MSG(KERN_INFO
+			  "Found VIA VT1636 LVDS on port i2c 0x31 \n");
+	} else {
+		chip_info.chip_on_slot = PORT_ON_AGP;
+		if (lvds_identify_vt1636()) {
+			chip_info.lvds_chip_info.i2c_port = GPIOPORTINDEX;
+			DEBUG_MSG(KERN_INFO
+				  "Found VIA VT1636 LVDS on port gpio 0x2c \n");
+		}
+	}
+	chip_info.chip_on_slot = tmp;
+
+	if (chip_info.gfx_chip_name == UNICHROME_CX700)
+		lvds_identify_integratedlvds();
+
+	if (chip_info.lvds_chip_info.lvds_chip_name)
+		return TRUE;
+	/* Check for VT1631: */
+	chip_info.lvds_chip_info.lvds_chip_name = VT1631_LVDS;
+	chip_info.lvds_chip_info.lvds_chip_slave_addr = VT1631_LVDS_I2C_ADDR;
+
+	if (check_lvds_chip(VT1631_DEVICE_ID_REG, VT1631_DEVICE_ID) != FAIL) {
+		DEBUG_MSG(KERN_INFO "\n VT1631 LVDS ! \n");
+		DEBUG_MSG(KERN_INFO "\n %2d",
+			  chip_info.lvds_chip_info.lvds_chip_name);
+		DEBUG_MSG(KERN_INFO "\n %2d",
+			  chip_info.lvds_chip_info.lvds_chip_name);
+		return (OK);
+	}
+
+	chip_info.lvds_chip_info.lvds_chip_name = NON_LVDS_TRANSMITTER;
+	chip_info.lvds_chip_info.lvds_chip_slave_addr = VT1631_LVDS_I2C_ADDR;
+	return (FAIL);
+}
+
+int fp_id_to_vindex(int panel_id)
+{
+	DEBUG_MSG(KERN_INFO "fp_get_panel_id()\n");
+
+	if (panel_id > LCD_PANEL_ID_MAXIMUM)
+		lcd_panel_id = panel_id = read_reg(VIACR, CR3F) & 0x0F;
+
+	switch (panel_id) {
+	case 0x0:
+		lvds_setting_info.lcd_panel_hres = 640;
+		lvds_setting_info.lcd_panel_vres = 480;
+		lvds_setting_info.lcd_panel_id = LCD_PANEL_ID0_640X480;
+		lvds_setting_info.device_lcd_dualedge = 0;
+		lvds_setting_info.LCDDithering = 1;
+		return (VIA_RES_640X480);
+		break;
+	case 0x1:
+		lvds_setting_info.lcd_panel_hres = 800;
+		lvds_setting_info.lcd_panel_vres = 600;
+		lvds_setting_info.lcd_panel_id = LCD_PANEL_ID1_800X600;
+		lvds_setting_info.device_lcd_dualedge = 0;
+		lvds_setting_info.LCDDithering = 1;
+		return (VIA_RES_800X600);
+		break;
+	case 0x2:
+		lvds_setting_info.lcd_panel_hres = 1024;
+		lvds_setting_info.lcd_panel_vres = 768;
+		lvds_setting_info.lcd_panel_id = LCD_PANEL_ID2_1024X768;
+		lvds_setting_info.device_lcd_dualedge = 0;
+		lvds_setting_info.LCDDithering = 1;
+		return (VIA_RES_1024X768);
+		break;
+	case 0x3:
+		lvds_setting_info.lcd_panel_hres = 1280;
+		lvds_setting_info.lcd_panel_vres = 768;
+		lvds_setting_info.lcd_panel_id = LCD_PANEL_ID3_1280X768;
+		lvds_setting_info.device_lcd_dualedge = 0;
+		lvds_setting_info.LCDDithering = 1;
+		return (VIA_RES_1280X768);
+		break;
+	case 0x4:
+		lvds_setting_info.lcd_panel_hres = 1280;
+		lvds_setting_info.lcd_panel_vres = 1024;
+		lvds_setting_info.lcd_panel_id = LCD_PANEL_ID4_1280X1024;
+		lvds_setting_info.device_lcd_dualedge = 1;
+		lvds_setting_info.LCDDithering = 1;
+		return (VIA_RES_1280X1024);
+		break;
+	case 0x5:
+		lvds_setting_info.lcd_panel_hres = 1400;
+		lvds_setting_info.lcd_panel_vres = 1050;
+		lvds_setting_info.lcd_panel_id = LCD_PANEL_ID5_1400X1050;
+		lvds_setting_info.device_lcd_dualedge = 1;
+		lvds_setting_info.LCDDithering = 1;
+		return (VIA_RES_1400X1050);
+		break;
+	case 0x6:
+		lvds_setting_info.lcd_panel_hres = 1600;
+		lvds_setting_info.lcd_panel_vres = 1200;
+		lvds_setting_info.lcd_panel_id = LCD_PANEL_ID6_1600X1200;
+		lvds_setting_info.device_lcd_dualedge = 1;
+		lvds_setting_info.LCDDithering = 1;
+		return (VIA_RES_1600X1200);
+		break;
+	case 0x8:
+		lvds_setting_info.lcd_panel_hres = 800;
+		lvds_setting_info.lcd_panel_vres = 480;
+		lvds_setting_info.lcd_panel_id = LCD_PANEL_IDA_800X480;
+		lvds_setting_info.device_lcd_dualedge = 0;
+		lvds_setting_info.LCDDithering = 1;
+		return (VIA_RES_800X480);
+		break;
+	case 0x9:
+		lvds_setting_info.lcd_panel_hres = 1024;
+		lvds_setting_info.lcd_panel_vres = 768;
+		lvds_setting_info.lcd_panel_id = LCD_PANEL_ID2_1024X768;
+		lvds_setting_info.device_lcd_dualedge = 1;
+		lvds_setting_info.LCDDithering = 1;
+		return (VIA_RES_1024X768);
+		break;
+	case 0xA:
+		lvds_setting_info.lcd_panel_hres = 1024;
+		lvds_setting_info.lcd_panel_vres = 768;
+		lvds_setting_info.lcd_panel_id = LCD_PANEL_ID2_1024X768;
+		lvds_setting_info.device_lcd_dualedge = 0;
+		lvds_setting_info.LCDDithering = 0;
+		return (VIA_RES_1024X768);
+		break;
+	case 0xB:
+		lvds_setting_info.lcd_panel_hres = 1024;
+		lvds_setting_info.lcd_panel_vres = 768;
+		lvds_setting_info.lcd_panel_id = LCD_PANEL_ID2_1024X768;
+		lvds_setting_info.device_lcd_dualedge = 1;
+		lvds_setting_info.LCDDithering = 0;
+		return (VIA_RES_1024X768);
+		break;
+	case 0xC:
+		lvds_setting_info.lcd_panel_hres = 1280;
+		lvds_setting_info.lcd_panel_vres = 768;
+		lvds_setting_info.lcd_panel_id = LCD_PANEL_ID3_1280X768;
+		lvds_setting_info.device_lcd_dualedge = 0;
+		lvds_setting_info.LCDDithering = 0;
+		return (VIA_RES_1280X768);
+		break;
+	case 0xD:
+		lvds_setting_info.lcd_panel_hres = 1280;
+		lvds_setting_info.lcd_panel_vres = 1024;
+		lvds_setting_info.lcd_panel_id = LCD_PANEL_ID4_1280X1024;
+		lvds_setting_info.device_lcd_dualedge = 1;
+		lvds_setting_info.LCDDithering = 0;
+		return (VIA_RES_1280X1024);
+		break;
+	case 0xE:
+		lvds_setting_info.lcd_panel_hres = 1400;
+		lvds_setting_info.lcd_panel_vres = 1050;
+		lvds_setting_info.lcd_panel_id = LCD_PANEL_ID5_1400X1050;
+		lvds_setting_info.device_lcd_dualedge = 1;
+		lvds_setting_info.LCDDithering = 0;
+		return (VIA_RES_1400X1050);
+		break;
+	case 0xF:
+		lvds_setting_info.lcd_panel_hres = 1600;
+		lvds_setting_info.lcd_panel_vres = 1200;
+		lvds_setting_info.lcd_panel_id = LCD_PANEL_ID6_1600X1200;
+		lvds_setting_info.device_lcd_dualedge = 1;
+		lvds_setting_info.LCDDithering = 0;
+		return (VIA_RES_1600X1200);
+		break;
+	case 0x10:
+		lvds_setting_info.lcd_panel_hres = 1366;
+		lvds_setting_info.lcd_panel_vres = 768;
+		lvds_setting_info.lcd_panel_id = LCD_PANEL_ID7_1366X768;
+		lvds_setting_info.device_lcd_dualedge = 0;
+		lvds_setting_info.LCDDithering = 0;
+		return (VIA_RES_1368X768);
+		break;
+	case 0x11:
+		lvds_setting_info.lcd_panel_hres = 1024;
+		lvds_setting_info.lcd_panel_vres = 600;
+		lvds_setting_info.lcd_panel_id = LCD_PANEL_ID8_1024X600;
+		lvds_setting_info.device_lcd_dualedge = 0;
+		lvds_setting_info.LCDDithering = 1;
+		return (VIA_RES_1024X600);
+		break;
+	case 0x12:
+		lvds_setting_info.lcd_panel_hres = 1280;
+		lvds_setting_info.lcd_panel_vres = 768;
+		lvds_setting_info.lcd_panel_id = LCD_PANEL_ID3_1280X768;
+		lvds_setting_info.device_lcd_dualedge = 1;
+		lvds_setting_info.LCDDithering = 1;
+		return (VIA_RES_1280X768);
+		break;
+	case 0x13:
+		lvds_setting_info.lcd_panel_hres = 1280;
+		lvds_setting_info.lcd_panel_vres = 800;
+		lvds_setting_info.lcd_panel_id = LCD_PANEL_ID9_1280X800;
+		lvds_setting_info.device_lcd_dualedge = 0;
+		lvds_setting_info.LCDDithering = 1;
+		return (VIA_RES_1280X800);
+		break;
+	case 0x14:
+		lvds_setting_info.lcd_panel_hres = 1360;
+		lvds_setting_info.lcd_panel_vres = 768;
+		lvds_setting_info.lcd_panel_id = LCD_PANEL_IDB_1360X768;
+		lvds_setting_info.device_lcd_dualedge = 0;
+		lvds_setting_info.LCDDithering = 0;
+		return (VIA_RES_1360X768);
+		break;
+	case 0x15:
+		lvds_setting_info.lcd_panel_hres = 1280;
+		lvds_setting_info.lcd_panel_vres = 768;
+		lvds_setting_info.lcd_panel_id = LCD_PANEL_ID3_1280X768;
+		lvds_setting_info.device_lcd_dualedge = 1;
+		lvds_setting_info.LCDDithering = 0;
+		return (VIA_RES_1280X768);
+		break;
+	case 0x16:
+		lvds_setting_info.lcd_panel_hres = 480;
+		lvds_setting_info.lcd_panel_vres = 640;
+		lvds_setting_info.lcd_panel_id = LCD_PANEL_IDC_480X640;
+		lvds_setting_info.device_lcd_dualedge = 0;
+		lvds_setting_info.LCDDithering = 1;
+		return (VIA_RES_480X640);
+		break;
+	default:
+		lvds_setting_info.lcd_panel_hres = 800;
+		lvds_setting_info.lcd_panel_vres = 600;
+		lvds_setting_info.lcd_panel_id = LCD_PANEL_ID1_800X600;
+		lvds_setting_info.device_lcd_dualedge = 0;
+		lvds_setting_info.LCDDithering = 1;
+		return (VIA_RES_800X600);
+	}
+}
+
+void lvds_register_write(int index, u8 data)
+{
+	u8 tmp;
+
+	tmp = chip_info.chip_on_slot;
+
+	chip_info.chip_on_slot = PORT_ON_AGP;
+
+	i2cWriteByte(chip_info.lvds_chip_info.lvds_chip_slave_addr, index,
+		     data);
+
+	chip_info.chip_on_slot = tmp;
+
+}
+
+int lvds_register_read(int index)
+{
+	u8 data;
+	int status;
+	u8 tmp;
+
+	tmp = chip_info.chip_on_slot;
+
+	chip_info.chip_on_slot = PORT_ON_AGP;
+	status =
+	    i2cReadByte((u8) chip_info.lvds_chip_info.lvds_chip_slave_addr,
+			(u8) index, &data);
+
+	chip_info.chip_on_slot = tmp;
+	return (data);
+}
+
+void load_lcd_scaling(int set_hres, int set_vres, int panel_hres,
+		      int panel_vres)
+{
+	int reg_value = 0;
+	int load_reg_num;
+	struct io_register *reg = NULL;
+
+	DEBUG_MSG(KERN_INFO "load_lcd_scaling()!!\n");
+
+	/* LCD Scaling Enable */
+	write_reg_mask(CR79, VIACR, 0x07, BIT0 + BIT1 + BIT2);
+	if (UNICHROME_P4M900 == chip_info.gfx_chip_name) {
+		load_scaling_factor_for_p4m900(set_hres, set_vres,
+					       panel_hres, panel_vres);
+		return;
+	}
+
+	/* Check if expansion for horizontal */
+	if (set_hres != panel_hres) {
+		/* Load Horizontal Scaling Factor */
+		switch (chip_info.gfx_chip_name) {
+		case UNICHROME_CLE266:
+		case UNICHROME_K400:
+			reg_value =
+			    CLE266_LCD_HOR_SCF_FORMULA(set_hres, panel_hres);
+			load_reg_num =
+			    lcd_scaling_factor_CLE.lcd_hor_scaling_factor.
+			    reg_num;
+			reg = lcd_scaling_factor_CLE.lcd_hor_scaling_factor.reg;
+			load_reg(reg_value, load_reg_num, reg, VIACR);
+			break;
+		case UNICHROME_K800:
+		case UNICHROME_PM800:
+		case UNICHROME_CN700:
+		case UNICHROME_CX700:
+		case UNICHROME_K8M890:
+		case UNICHROME_P4M890:
+			reg_value =
+			    K800_LCD_HOR_SCF_FORMULA(set_hres, panel_hres);
+			/* Horizontal scaling enabled */
+			write_reg_mask(CRA2, VIACR, 0xC0, BIT7 + BIT6);
+			load_reg_num =
+			    lcd_scaling_factor.lcd_hor_scaling_factor.reg_num;
+			reg = lcd_scaling_factor.lcd_hor_scaling_factor.reg;
+			load_reg(reg_value, load_reg_num, reg, VIACR);
+			break;
+		}
+
+		DEBUG_MSG(KERN_INFO "Horizontal Scaling value = %d", reg_value);
+	} else {
+		/* Horizontal scaling disabled */
+		write_reg_mask(CRA2, VIACR, 0x00, BIT7);
+	}
+
+	/* Check if expansion for vertical */
+	if (set_vres != panel_vres) {
+		/* Load Vertical Scaling Factor */
+		switch (chip_info.gfx_chip_name) {
+		case UNICHROME_CLE266:
+		case UNICHROME_K400:
+			reg_value =
+			    CLE266_LCD_VER_SCF_FORMULA(set_vres, panel_vres);
+			load_reg_num =
+			    lcd_scaling_factor_CLE.lcd_ver_scaling_factor.
+			    reg_num;
+			reg = lcd_scaling_factor_CLE.lcd_ver_scaling_factor.reg;
+			load_reg(reg_value, load_reg_num, reg, VIACR);
+			break;
+		case UNICHROME_K800:
+		case UNICHROME_PM800:
+		case UNICHROME_CN700:
+		case UNICHROME_CX700:
+		case UNICHROME_K8M890:
+		case UNICHROME_P4M890:
+			reg_value =
+			    K800_LCD_VER_SCF_FORMULA(set_vres, panel_vres);
+			/* Vertical scaling enabled */
+			write_reg_mask(CRA2, VIACR, 0x08, BIT3);
+			load_reg_num =
+			    lcd_scaling_factor.lcd_ver_scaling_factor.reg_num;
+			reg = lcd_scaling_factor.lcd_ver_scaling_factor.reg;
+			load_reg(reg_value, load_reg_num, reg, VIACR);
+			break;
+		}
+
+		DEBUG_MSG(KERN_INFO "Vertical Scaling value = %d", reg_value);
+	} else {
+		/* Vertical scaling disabled */
+		write_reg_mask(CRA2, VIACR, 0x00, BIT3);
+	}
+}
+
+void load_lcd_k400_patch_tbl(int set_hres, int set_vres, int panel_id)
+{
+	int vmode_index;
+	int reg_num = 0;
+	struct io_reg *lcd_patch_reg = NULL;
+
+	if (lvds_setting_info.iga_path == IGA2)
+		vmode_index = get_mode_index(set_hres, set_vres, 1);
+	else
+		vmode_index = get_mode_index(set_hres, set_vres, 0);
+	switch (panel_id) {
+		/* LCD 800x600 */
+	case LCD_PANEL_ID1_800X600:
+		switch (vmode_index) {
+		case VIA_RES_640X400:
+		case VIA_RES_640X480:
+			reg_num = NUM_TOTAL_K400_LCD_RES_6X4_8X6;
+			lcd_patch_reg = K400_LCD_RES_6X4_8X6;
+			break;
+		case VIA_RES_720X480:
+		case VIA_RES_720X576:
+			reg_num = NUM_TOTAL_K400_LCD_RES_7X4_8X6;
+			lcd_patch_reg = K400_LCD_RES_7X4_8X6;
+			break;
+		}
+		break;
+
+		/* LCD 1024x768 */
+	case LCD_PANEL_ID2_1024X768:
+		switch (vmode_index) {
+		case VIA_RES_640X400:
+		case VIA_RES_640X480:
+			reg_num = NUM_TOTAL_K400_LCD_RES_6X4_10X7;
+			lcd_patch_reg = K400_LCD_RES_6X4_10X7;
+			break;
+		case VIA_RES_720X480:
+		case VIA_RES_720X576:
+			reg_num = NUM_TOTAL_K400_LCD_RES_7X4_10X7;
+			lcd_patch_reg = K400_LCD_RES_7X4_10X7;
+			break;
+		case VIA_RES_800X600:
+			reg_num = NUM_TOTAL_K400_LCD_RES_8X6_10X7;
+			lcd_patch_reg = K400_LCD_RES_8X6_10X7;
+			break;
+		}
+		break;
+
+		/* LCD 1280x1024 */
+	case LCD_PANEL_ID4_1280X1024:
+		switch (vmode_index) {
+		case VIA_RES_640X400:
+		case VIA_RES_640X480:
+			reg_num = NUM_TOTAL_K400_LCD_RES_6X4_12X10;
+			lcd_patch_reg = K400_LCD_RES_6X4_12X10;
+			break;
+		case VIA_RES_720X480:
+		case VIA_RES_720X576:
+			reg_num = NUM_TOTAL_K400_LCD_RES_7X4_12X10;
+			lcd_patch_reg = K400_LCD_RES_7X4_12X10;
+			break;
+		case VIA_RES_800X600:
+			reg_num = NUM_TOTAL_K400_LCD_RES_8X6_12X10;
+			lcd_patch_reg = K400_LCD_RES_8X6_12X10;
+			break;
+		case VIA_RES_1024X768:
+			reg_num = NUM_TOTAL_K400_LCD_RES_10X7_12X10;
+			lcd_patch_reg = K400_LCD_RES_10X7_12X10;
+			break;
+
+		}
+		break;
+
+		/* LCD 1400x1050 */
+	case LCD_PANEL_ID5_1400X1050:
+		switch (vmode_index) {
+		case VIA_RES_640X480:
+			reg_num = NUM_TOTAL_K400_LCD_RES_6X4_14X10;
+			lcd_patch_reg = K400_LCD_RES_6X4_14X10;
+			break;
+		case VIA_RES_800X600:
+			reg_num = NUM_TOTAL_K400_LCD_RES_8X6_14X10;
+			lcd_patch_reg = K400_LCD_RES_8X6_14X10;
+			break;
+		case VIA_RES_1024X768:
+			reg_num = NUM_TOTAL_K400_LCD_RES_10X7_14X10;
+			lcd_patch_reg = K400_LCD_RES_10X7_14X10;
+			break;
+		case VIA_RES_1280X768:
+		case VIA_RES_1280X800:
+		case VIA_RES_1280X960:
+		case VIA_RES_1280X1024:
+			reg_num = NUM_TOTAL_K400_LCD_RES_12X10_14X10;
+			lcd_patch_reg = K400_LCD_RES_12X10_14X10;
+			break;
+		}
+		break;
+
+		/* LCD 1600x1200 */
+	case LCD_PANEL_ID6_1600X1200:
+		switch (vmode_index) {
+		case VIA_RES_640X400:
+		case VIA_RES_640X480:
+			reg_num = NUM_TOTAL_K400_LCD_RES_6X4_16X12;
+			lcd_patch_reg = K400_LCD_RES_6X4_16X12;
+			break;
+		case VIA_RES_720X480:
+		case VIA_RES_720X576:
+			reg_num = NUM_TOTAL_K400_LCD_RES_7X4_16X12;
+			lcd_patch_reg = K400_LCD_RES_7X4_16X12;
+			break;
+		case VIA_RES_800X600:
+			reg_num = NUM_TOTAL_K400_LCD_RES_8X6_16X12;
+			lcd_patch_reg = K400_LCD_RES_8X6_16X12;
+			break;
+		case VIA_RES_1024X768:
+			reg_num = NUM_TOTAL_K400_LCD_RES_10X7_16X12;
+			lcd_patch_reg = K400_LCD_RES_10X7_16X12;
+			break;
+		case VIA_RES_1280X768:
+		case VIA_RES_1280X800:
+		case VIA_RES_1280X960:
+		case VIA_RES_1280X1024:
+			reg_num = NUM_TOTAL_K400_LCD_RES_12X10_16X12;
+			lcd_patch_reg = K400_LCD_RES_12X10_16X12;
+			break;
+		}
+		break;
+
+		/* LCD 1366x768 */
+	case LCD_PANEL_ID7_1366X768:
+		switch (vmode_index) {
+		case VIA_RES_640X480:
+			reg_num = NUM_TOTAL_K400_LCD_RES_6X4_1366X7;
+			lcd_patch_reg = K400_LCD_RES_6X4_1366X7;
+			break;
+		case VIA_RES_720X480:
+		case VIA_RES_720X576:
+			reg_num = NUM_TOTAL_K400_LCD_RES_7X4_1366X7;
+			lcd_patch_reg = K400_LCD_RES_7X4_1366X7;
+			break;
+		case VIA_RES_800X600:
+			reg_num = NUM_TOTAL_K400_LCD_RES_8X6_1366X7;
+			lcd_patch_reg = K400_LCD_RES_8X6_1366X7;
+			break;
+		case VIA_RES_1024X768:
+			reg_num = NUM_TOTAL_K400_LCD_RES_10X7_1366X7;
+			lcd_patch_reg = K400_LCD_RES_10X7_1366X7;
+			break;
+		case VIA_RES_1280X768:
+		case VIA_RES_1280X800:
+		case VIA_RES_1280X960:
+		case VIA_RES_1280X1024:
+			reg_num = NUM_TOTAL_K400_LCD_RES_12X10_1366X7;
+			lcd_patch_reg = K400_LCD_RES_12X10_1366X7;
+			break;
+		}
+		break;
+
+		/* LCD 1360x768 */
+	case LCD_PANEL_IDB_1360X768:
+		break;
+	}
+	if (reg_num != 0) {
+		/* H.W. Reset : ON */
+		write_reg_mask(CR17, VIACR, 0x00, BIT7);
+
+		write_regx(lcd_patch_reg, reg_num);
+
+		/* H.W. Reset : OFF */
+		write_reg_mask(CR17, VIACR, 0x80, BIT7);
+
+		/* Reset PLL */
+		write_reg_mask(SR40, VIASR, 0x02, BIT1);
+		write_reg_mask(SR40, VIASR, 0x00, BIT1);
+
+		/* Fire! */
+		outb(inb(VIARMisc) | (BIT2 + BIT3), VIAWMisc);
+	}
+}
+
+void load_lcd_p880_patch_tbl(int set_hres, int set_vres, int panel_id)
+{
+	int vmode_index;
+	int reg_num = 0;
+	struct io_reg *lcd_patch_reg = NULL;
+
+	if (lvds_setting_info.iga_path == IGA2)
+		vmode_index = get_mode_index(set_hres, set_vres, 1);
+	else
+		vmode_index = get_mode_index(set_hres, set_vres, 0);
+
+	switch (panel_id) {
+	case LCD_PANEL_ID5_1400X1050:
+		switch (vmode_index) {
+		case VIA_RES_640X480:
+			reg_num = NUM_TOTAL_P880_LCD_RES_6X4_14X10;
+			lcd_patch_reg = P880_LCD_RES_6X4_14X10;
+			break;
+		case VIA_RES_800X600:
+			reg_num = NUM_TOTAL_P880_LCD_RES_8X6_14X10;
+			lcd_patch_reg = P880_LCD_RES_8X6_14X10;
+			break;
+		}
+		break;
+	case LCD_PANEL_ID6_1600X1200:
+		switch (vmode_index) {
+		case VIA_RES_640X400:
+		case VIA_RES_640X480:
+			reg_num = NUM_TOTAL_P880_LCD_RES_6X4_16X12;
+			lcd_patch_reg = P880_LCD_RES_6X4_16X12;
+			break;
+		case VIA_RES_720X480:
+		case VIA_RES_720X576:
+			reg_num = NUM_TOTAL_P880_LCD_RES_7X4_16X12;
+			lcd_patch_reg = P880_LCD_RES_7X4_16X12;
+			break;
+		case VIA_RES_800X600:
+			reg_num = NUM_TOTAL_P880_LCD_RES_8X6_16X12;
+			lcd_patch_reg = P880_LCD_RES_8X6_16X12;
+			break;
+		case VIA_RES_1024X768:
+			reg_num = NUM_TOTAL_P880_LCD_RES_10X7_16X12;
+			lcd_patch_reg = P880_LCD_RES_10X7_16X12;
+			break;
+		case VIA_RES_1280X768:
+		case VIA_RES_1280X960:
+		case VIA_RES_1280X1024:
+			reg_num = NUM_TOTAL_P880_LCD_RES_12X10_16X12;
+			lcd_patch_reg = P880_LCD_RES_12X10_16X12;
+			break;
+		}
+		break;
+
+	}
+	if (reg_num != 0) {
+		/* H.W. Reset : ON */
+		write_reg_mask(CR17, VIACR, 0x00, BIT7);
+
+		write_regx(lcd_patch_reg, reg_num);
+
+		/* H.W. Reset : OFF */
+		write_reg_mask(CR17, VIACR, 0x80, BIT7);
+
+		/* Reset PLL */
+		write_reg_mask(SR40, VIASR, 0x02, BIT1);
+		write_reg_mask(SR40, VIASR, 0x00, BIT1);
+
+		/* Fire! */
+		outb(inb(VIARMisc) | (BIT2 + BIT3), VIAWMisc);
+	}
+}
+
+void load_lcd_patch_regs(int set_hres, int set_vres, int panel_id, int set_iga)
+{
+	int vmode_index;
+
+	if (lvds_setting_info.iga_path == IGA2)
+		vmode_index = get_mode_index(set_hres, set_vres, 1);
+	else
+		vmode_index = get_mode_index(set_hres, set_vres, 0);
+
+	unlock_crt();
+
+	/* Patch for simultaneous & Expansion */
+	if ((set_iga == IGA1_IGA2)
+	    && (lvds_setting_info.display_method == LCD_EXPANDSION)) {
+		switch (chip_info.gfx_chip_name) {
+		case UNICHROME_CLE266:
+		case UNICHROME_K400:
+			load_lcd_k400_patch_tbl(set_hres, set_vres, panel_id);
+			break;
+		case UNICHROME_K800:
+			break;
+		case UNICHROME_PM800:
+		case UNICHROME_CN700:
+		case UNICHROME_CX700:
+			load_lcd_p880_patch_tbl(set_hres, set_vres, panel_id);
+		}
+	}
+
+	lock_crt();
+}
+
+void via_pitch_alignment_patch_lcd(struct lvds_setting_information
+				   *plvds_setting_info,
+				   struct lvds_chip_information
+				   *plvds_chip_info)
+{
+	unsigned char cr13, cr35, cr65, cr66, cr67;
+	unsigned long dwScreenPitch = 0;
+	unsigned long dwPitch;
+
+	dwPitch = plvds_setting_info->h_active * (plvds_setting_info->bpp >> 3);
+	if (dwPitch & 0x1F) {
+		dwScreenPitch = ((dwPitch + 31) & ~31) >> 3;
+		if (plvds_setting_info->iga_path == IGA2) {
+			if (plvds_setting_info->bpp > 8) {
+				cr66 = (unsigned char)(dwScreenPitch & 0xFF);
+				write_reg(CR66, VIACR, cr66);
+				cr67 = read_reg(VIACR, CR67) & 0xFC;
+				cr67 |=
+				    (unsigned
+				     char)((dwScreenPitch & 0x300) >> 8);
+				write_reg(CR67, VIACR, cr67);
+			}
+
+			/* Fetch Count */
+			cr67 = read_reg(VIACR, CR67) & 0xF3;
+			cr67 |= (unsigned char)((dwScreenPitch & 0x600) >> 7);
+			write_reg(CR67, VIACR, cr67);
+			cr65 = (unsigned char)((dwScreenPitch >> 1) & 0xFF);
+			cr65 += 2;
+			write_reg(CR65, VIACR, cr65);
+		} else {
+			if (plvds_setting_info->bpp > 8) {
+				cr13 = (unsigned char)(dwScreenPitch & 0xFF);
+				write_reg(CR13, VIACR, cr13);
+				cr35 = read_reg(VIACR, CR35) & 0x1F;
+				cr35 |=
+				    (unsigned
+				     char)((dwScreenPitch & 0x700) >> 3);
+				write_reg(CR35, VIACR, cr35);
+			}
+		}
+	}
+}
+void lcd_patch_skew_dvp0(struct lvds_setting_information
+			 *plvds_setting_info,
+			 struct lvds_chip_information *plvds_chip_info)
+{
+	if (VT1636_LVDS == plvds_chip_info->lvds_chip_name) {
+		switch (chip_info.gfx_chip_name) {
+		case UNICHROME_P4M900:
+			vt1636_patch_skew_on_vt3364(plvds_setting_info,
+						    plvds_chip_info);
+			break;
+		case UNICHROME_P4M890:
+			vt1636_patch_skew_on_vt3327(plvds_setting_info,
+						    plvds_chip_info);
+			break;
+		}
+	}
+}
+void lcd_patch_skew_dvp1(struct lvds_setting_information
+			 *plvds_setting_info,
+			 struct lvds_chip_information *plvds_chip_info)
+{
+	if (VT1636_LVDS == plvds_chip_info->lvds_chip_name) {
+		switch (chip_info.gfx_chip_name) {
+		case UNICHROME_CX700:
+			vt1636_patch_skew_on_vt3324(plvds_setting_info,
+						    plvds_chip_info);
+			break;
+		}
+	}
+}
+void lcd_patch_skew(struct lvds_setting_information *plvds_setting_info,
+		    struct lvds_chip_information *plvds_chip_info)
+{
+	DEBUG_MSG(KERN_INFO "lcd_patch_skew\n");
+	switch (plvds_chip_info->output_interface) {
+	case INTERFACE_DVP0:
+		lcd_patch_skew_dvp0(plvds_setting_info, plvds_chip_info);
+		break;
+	case INTERFACE_DVP1:
+		lcd_patch_skew_dvp1(plvds_setting_info, plvds_chip_info);
+		break;
+	case INTERFACE_DFP_LOW:
+		if (UNICHROME_P4M900 == chip_info.gfx_chip_name) {
+			write_reg_mask(CR99, VIACR, 0x08,
+				       BIT0 + BIT1 + BIT2 + BIT3);
+		}
+		break;
+	}
+}
+
+/* LCD Set Mode */
+void lcd_set_mode(struct crt_mode_table *mode_crt_table,
+		  struct lvds_setting_information *plvds_setting_info,
+		  struct lvds_chip_information *plvds_chip_info)
+{
+	int video_index = plvds_setting_info->lcd_panel_size;
+	int set_iga = plvds_setting_info->iga_path;
+	int mode_bpp = plvds_setting_info->bpp;
+	int load_reg_num = 0;
+	int reg_value = 0;
+	int set_hres, set_vres;
+	int panel_hres, panel_vres;
+	u32 pll_D_N;
+	int offset;
+	struct io_register *reg = NULL;
+	struct display_timing mode_crt_reg, panel_crt_reg;
+	struct crt_mode_table *panel_crt_table = NULL;
+	struct VideoModeTable *vmode_tbl = NULL;
+
+	DEBUG_MSG(KERN_INFO "LCD_Set_Mode!!\n");
+	/* Get mode table */
+	mode_crt_reg = mode_crt_table->crtc;
+	/* Get panel table Pointer */
+	vmode_tbl = get_modetbl_pointer(video_index);
+	panel_crt_table = vmode_tbl->crtc;
+	panel_crt_reg = panel_crt_table->crtc;
+	DEBUG_MSG(KERN_INFO "bellow LCD_Set_Mode!!\n");
+	set_hres = plvds_setting_info->h_active;
+	set_vres = plvds_setting_info->v_active;
+	panel_hres = plvds_setting_info->lcd_panel_hres;
+	panel_vres = plvds_setting_info->lcd_panel_vres;
+	if (VT1636_LVDS == plvds_chip_info->lvds_chip_name)
+		init_lvds_vt1636(plvds_setting_info, plvds_chip_info);
+	plvds_setting_info->vclk = panel_crt_table->clk;
+	if (set_iga == IGA1) {
+		/* IGA1 doesn't have LCD scaling, so set it as centering. */
+		load_crtc_timing(lcd_centering_timging
+				 (mode_crt_reg, panel_crt_reg), IGA1);
+	} else {
+		/* Expansion */
+		if ((plvds_setting_info->display_method ==
+		     LCD_EXPANDSION) & ((set_hres != panel_hres)
+					|| (set_vres != panel_vres))) {
+			/* expansion timing IGA2 loaded panel set timing*/
+			load_crtc_timing(panel_crt_reg, IGA2);
+			DEBUG_MSG(KERN_INFO "load_crtc_timing!!\n");
+			load_lcd_scaling(set_hres, set_vres, panel_hres,
+					 panel_vres);
+			DEBUG_MSG(KERN_INFO "load_lcd_scaling!!\n");
+		} else {	/* Centering */
+			/* centering timing IGA2 always loaded panel
+			   and mode releative timing */
+			load_crtc_timing(lcd_centering_timging
+					 (mode_crt_reg, panel_crt_reg), IGA2);
+			write_reg_mask(CR79, VIACR, 0x00, BIT0 + BIT1 + BIT2);
+			/* LCD scaling disabled */
+		}
+	}
+
+	if (set_iga == IGA1_IGA2) {
+		load_crtc_shadow_timing(mode_crt_reg, panel_crt_reg);
+		/* Fill shadow registers */
+
+		switch (plvds_setting_info->lcd_panel_id) {
+		case LCD_PANEL_ID0_640X480:
+			offset = 80;
+			break;
+		case LCD_PANEL_ID1_800X600:
+		case LCD_PANEL_IDA_800X480:
+			offset = 110;
+			break;
+		case LCD_PANEL_ID2_1024X768:
+			offset = 150;
+			break;
+		case LCD_PANEL_ID3_1280X768:
+		case LCD_PANEL_ID4_1280X1024:
+		case LCD_PANEL_ID5_1400X1050:
+		case LCD_PANEL_ID9_1280X800:
+			offset = 190;
+			break;
+		case LCD_PANEL_ID6_1600X1200:
+			offset = 250;
+			break;
+		case LCD_PANEL_ID7_1366X768:
+		case LCD_PANEL_IDB_1360X768:
+			offset = 212;
+			break;
+		default:
+			offset = 140;
+			break;
+		}
+
+		/* Offset for simultaneous */
+		reg_value = offset;
+		load_reg_num = offset_reg.iga2_offset_reg.reg_num;
+		reg = offset_reg.iga2_offset_reg.reg;
+		load_reg(reg_value, load_reg_num, reg, VIACR);
+		DEBUG_MSG(KERN_INFO "load_reg!!\n");
+		load_fetch_count_reg(set_hres, 4, IGA2);
+		/* Fetch count for simultaneous */
+	} else {		/* SAMM */
+		/* Offset for IGA2 only */
+		load_offset_reg(set_hres, mode_bpp / 8, set_iga);
+		/* Fetch count for IGA2 only */
+		load_fetch_count_reg(set_hres, mode_bpp / 8, set_iga);
+
+		if ((chip_info.gfx_chip_name != UNICHROME_CLE266)
+		    && (chip_info.gfx_chip_name != UNICHROME_K400))
+			load_FIFO_reg(set_iga, set_hres, set_vres);
+
+		set_color_depth(mode_bpp / 8, set_iga);
+	}
+
+	fill_lcd_format();
+
+	pll_D_N = get_clk_value(panel_crt_table[0].clk);
+	DEBUG_MSG(KERN_INFO "PLL=0x%x", pll_D_N);
+	set_vclock(pll_D_N, set_iga);
+
+	set_output_path(DEVICE_LCD, set_iga, plvds_chip_info->output_interface);
+	lcd_patch_skew(plvds_setting_info, plvds_chip_info);
+
+	/* If K8M800, enable LCD Prefetch Mode. */
+	if ((chip_info.gfx_chip_name == UNICHROME_K800)
+	    || (UNICHROME_K8M890 == chip_info.gfx_chip_name))
+		write_reg_mask(CR6A, VIACR, 0x01, BIT0);
+
+	load_lcd_patch_regs(set_hres, set_vres,
+			    plvds_setting_info->lcd_panel_id, set_iga);
+
+	DEBUG_MSG(KERN_INFO "load_lcd_patch_regs!!\n");
+
+	/* Patch for non 32bit alignment mode */
+	via_pitch_alignment_patch_lcd(plvds_setting_info, plvds_chip_info);
+}
+
+void integrated_lvds_disable(struct lvds_setting_information
+			     *plvds_setting_info,
+			     struct lvds_chip_information *plvds_chip_info)
+{
+	bool turn_off_first_powersequence = FALSE;
+	bool turn_off_second_powersequence = FALSE;
+	if (INTERFACE_LVDS0LVDS1 == plvds_chip_info->output_interface)
+		turn_off_first_powersequence = TRUE;
+	if (INTERFACE_LVDS0 == plvds_chip_info->output_interface)
+		turn_off_first_powersequence = TRUE;
+	if (INTERFACE_LVDS1 == plvds_chip_info->output_interface)
+		turn_off_second_powersequence = TRUE;
+	if (turn_off_second_powersequence) {
+		/* Use second power sequence control: */
+
+		/* Turn off power sequence. */
+		write_reg_mask(CRD4, VIACR, 0, BIT1);
+
+		/* Turn off back light. */
+		write_reg_mask(CRD3, VIACR, 0xC0, BIT6 + BIT7);
+	}
+	if (turn_off_first_powersequence) {
+		/* Use first power sequence control: */
+
+		/* Turn off power sequence. */
+		write_reg_mask(CR6A, VIACR, 0, BIT3);
+
+		/* Turn off back light. */
+		write_reg_mask(CR91, VIACR, 0xC0, BIT6 + BIT7);
+	}
+
+	/* Turn DFP High/Low Pad off. */
+	write_reg_mask(SR2A, VIASR, 0, BIT0 + BIT1 + BIT2 + BIT3);
+
+	/* Power off LVDS channel. */
+	switch (plvds_chip_info->output_interface) {
+	case INTERFACE_LVDS0:
+		{
+			write_reg_mask(CRD2, VIACR, 0x80, BIT7);
+			break;
+		}
+
+	case INTERFACE_LVDS1:
+		{
+			write_reg_mask(CRD2, VIACR, 0x40, BIT6);
+			break;
+		}
+
+	case INTERFACE_LVDS0LVDS1:
+		{
+			write_reg_mask(CRD2, VIACR, 0xC0, BIT6 + BIT7);
+			break;
+		}
+	}
+}
+
+void integrated_lvds_enable(struct lvds_setting_information
+			    *plvds_setting_info,
+			    struct lvds_chip_information *plvds_chip_info)
+{
+	bool turn_on_first_powersequence = FALSE;
+	bool turn_on_second_powersequence = FALSE;
+
+	DEBUG_MSG(KERN_INFO "integrated_lvds_enable, out_interface:%d\n",
+		  plvds_chip_info->output_interface);
+	if (plvds_setting_info->lcd_mode == LCD_SPWG)
+		write_reg_mask(CRD2, VIACR, 0x00, BIT0 + BIT1);
+	 else
+		write_reg_mask(CRD2, VIACR, 0x03, BIT0 + BIT1);
+	if (INTERFACE_LVDS0LVDS1 == plvds_chip_info->output_interface)
+		turn_on_first_powersequence = TRUE;
+	if (INTERFACE_LVDS0 == plvds_chip_info->output_interface)
+		turn_on_first_powersequence = TRUE;
+	if (INTERFACE_LVDS1 == plvds_chip_info->output_interface)
+		turn_on_second_powersequence = TRUE;
+
+	if (turn_on_second_powersequence) {
+		/* Use second power sequence control: */
+
+		/* Use hardware control power sequence. */
+		write_reg_mask(CRD3, VIACR, 0, BIT0);
+
+		/* Turn on back light. */
+		write_reg_mask(CRD3, VIACR, 0, BIT6 + BIT7);
+
+		/* Turn on hardware power sequence. */
+		write_reg_mask(CRD4, VIACR, 0x02, BIT1);
+	}
+	if (turn_on_first_powersequence) {
+		/* Use first power sequence control: */
+
+		/* Use hardware control power sequence. */
+		write_reg_mask(CR91, VIACR, 0, BIT0);
+
+		/* Turn on back light. */
+		write_reg_mask(CR91, VIACR, 0, BIT6 + BIT7);
+
+		/* Turn on hardware power sequence. */
+		write_reg_mask(CR6A, VIACR, 0x08, BIT3);
+	}
+
+	/* Turn DFP High/Low pad on. */
+	write_reg_mask(SR2A, VIASR, 0x0F, BIT0 + BIT1 + BIT2 + BIT3);
+
+	/* Power on LVDS channel. */
+	switch (plvds_chip_info->output_interface) {
+	case INTERFACE_LVDS0:
+		{
+			write_reg_mask(CRD2, VIACR, 0, BIT7);
+			break;
+		}
+
+	case INTERFACE_LVDS1:
+		{
+			write_reg_mask(CRD2, VIACR, 0, BIT6);
+			break;
+		}
+
+	case INTERFACE_LVDS0LVDS1:
+		{
+			write_reg_mask(CRD2, VIACR, 0, BIT6 + BIT7);
+			break;
+		}
+	}
+}
+
+void lcd_disable(void)
+{
+
+	if (chip_info.gfx_chip_name == UNICHROME_CLE266) {
+		lcd_powersequence_off();
+		/* DI1 pad off */
+		write_reg_mask(SR1E, VIASR, 0x00, 0x30);
+	} else if (chip_info.gfx_chip_name == UNICHROME_CX700) {
+		if (LCD2_ON
+		    && (INTEGRATED_LVDS ==
+			chip_info.lvds_chip_info2.lvds_chip_name))
+			integrated_lvds_disable(&lvds_setting_info2,
+						&chip_info.lvds_chip_info2);
+		if (INTEGRATED_LVDS == chip_info.lvds_chip_info.lvds_chip_name)
+			integrated_lvds_disable(&lvds_setting_info,
+						&chip_info.lvds_chip_info);
+		if (VT1636_LVDS == chip_info.lvds_chip_info.lvds_chip_name)
+			disable_lvds_vt1636(&lvds_setting_info,
+					    &chip_info.lvds_chip_info);
+	} else if (VT1636_LVDS == chip_info.lvds_chip_info.lvds_chip_name) {
+		disable_lvds_vt1636(&lvds_setting_info,
+				    &chip_info.lvds_chip_info);
+	} else {
+		/* DFP-HL pad off          */
+		write_reg_mask(SR2A, VIASR, 0x00, 0x0F);
+		/* Backlight off           */
+		write_reg_mask(SR3D, VIASR, 0x00, 0x20);
+		/* 24 bit DI data paht off */
+		write_reg_mask(CR91, VIACR, 0x80, 0x80);
+		/* Simultaneout disabled   */
+		write_reg_mask(CR6B, VIACR, 0x00, 0x08);
+	}
+
+	/* Disable expansion bit   */
+	write_reg_mask(CR79, VIACR, 0x00, 0x01);
+	/* CRT path set to IGA1    */
+	write_reg_mask(SR16, VIASR, 0x00, 0x40);
+	/* Simultaneout disabled   */
+	write_reg_mask(CR6B, VIACR, 0x00, 0x08);
+	/* IGA2 path disabled      */
+	write_reg_mask(CR6A, VIACR, 0x00, 0x80);
+
+}
+
+void lcd_enable(void)
+{
+	if (chip_info.gfx_chip_name == UNICHROME_CLE266) {
+		/* DI1 pad on */
+		write_reg_mask(SR1E, VIASR, 0x30, 0x30);
+		lcd_powersequence_on();
+	} else if (chip_info.gfx_chip_name == UNICHROME_CX700) {
+		if (LCD2_ON && (INTEGRATED_LVDS ==
+			chip_info.lvds_chip_info2.lvds_chip_name))
+			integrated_lvds_enable(&lvds_setting_info2, \
+					       &chip_info.lvds_chip_info2);
+		if (INTEGRATED_LVDS == chip_info.lvds_chip_info.lvds_chip_name)
+			integrated_lvds_enable(&lvds_setting_info, \
+					       &chip_info.lvds_chip_info);
+		if (VT1636_LVDS == chip_info.lvds_chip_info.lvds_chip_name)
+			enable_lvds_vt1636(&lvds_setting_info, \
+					   &chip_info.lvds_chip_info);
+	} else if (VT1636_LVDS == chip_info.lvds_chip_info.lvds_chip_name) {
+		enable_lvds_vt1636(&lvds_setting_info,
+				   &chip_info.lvds_chip_info);
+	} else {
+		/* DFP-HL pad on           */
+		write_reg_mask(SR2A, VIASR, 0x0F, 0x0F);
+		/* Backlight on            */
+		write_reg_mask(SR3D, VIASR, 0x20, 0x20);
+		/* 24 bit DI data paht on  */
+		write_reg_mask(CR91, VIACR, 0x00, 0x80);
+
+		/* Set data source selection bit by iga path */
+		if (lvds_setting_info.iga_path == IGA1) {
+			/* DFP-H set to IGA1       */
+			write_reg_mask(CR97, VIACR, 0x00, 0x10);
+			/* DFP-L set to IGA1       */
+			write_reg_mask(CR99, VIACR, 0x00, 0x10);
+		} else {
+			/* DFP-H set to IGA2       */
+			write_reg_mask(CR97, VIACR, 0x10, 0x10);
+			/* DFP-L set to IGA2       */
+			write_reg_mask(CR99, VIACR, 0x10, 0x10);
+		}
+		/* LCD enabled             */
+		write_reg_mask(CR6A, VIACR, 0x48, 0x48);
+	}
+
+	if ((lvds_setting_info.iga_path == IGA1)
+	    || (lvds_setting_info.iga_path == IGA1_IGA2)) {
+		/* CRT path set to IGA2    */
+		write_reg_mask(SR16, VIASR, 0x40, 0x40);
+		/* IGA2 path disabled      */
+		write_reg_mask(CR6A, VIACR, 0x00, 0x80);
+		/* IGA2 path enabled       */
+	} else {		/* IGA2 */
+		write_reg_mask(CR6A, VIACR, 0x80, 0x80);
+	}
+
+}
+
+void lcd_powersequence_off(void)
+{
+	int i, mask, data;
+
+	/* Software control power sequence */
+	write_reg_mask(CR91, VIACR, 0x11, 0x11);
+
+	for (i = 0; i < 3; i++) {
+		mask = PowerSequenceOff[0][i];
+		data = PowerSequenceOff[1][i] & mask;
+		write_reg_mask(CR91, VIACR, (u8) data, (u8) mask);
+		delays(PowerSequenceOff[2][i]);
+	}
+
+	/* Disable LCD */
+	write_reg_mask(CR6A, VIACR, 0x00, 0x08);
+}
+
+void lcd_powersequence_on(void)
+{
+	int i, mask, data;
+
+	/* Software control power sequence */
+	write_reg_mask(CR91, VIACR, 0x11, 0x11);
+
+	/* Enable LCD */
+	write_reg_mask(CR6A, VIACR, 0x08, 0x08);
+
+	for (i = 0; i < 3; i++) {
+		mask = PowerSequenceOn[0][i];
+		data = PowerSequenceOn[1][i] & mask;
+		write_reg_mask(CR91, VIACR, (u8) data, (u8) mask);
+		delays(PowerSequenceOn[2][i]);
+	}
+
+	delays(1);
+}
+
+void fill_lcd_format(void)
+{
+	u8 bdithering = 0, bdual = 0;
+
+	if (lvds_setting_info.device_lcd_dualedge)
+		bdual = BIT4;
+	if (lvds_setting_info.LCDDithering)
+		bdithering = BIT0;
+	/* Dual & Dithering */
+	write_reg_mask(CR88, VIACR, (bdithering | bdual), BIT4 + BIT0);
+}
+
+void check_diport_of_integrated_lvds(struct lvds_chip_information
+				     *plvds_chip_info,
+				     struct lvds_setting_information
+				     *plvds_setting_info)
+{
+	/* Determine LCD DI Port by hardware layout. */
+	switch (display_hardware_layout) {
+	case HW_LAYOUT_LCD_ONLY:
+		{
+			if (plvds_setting_info->device_lcd_dualedge) {
+				plvds_chip_info->output_interface =
+				    INTERFACE_LVDS0LVDS1;
+			} else {
+				plvds_chip_info->output_interface =
+				    INTERFACE_LVDS0;
+			}
+
+			break;
+		}
+
+	case HW_LAYOUT_DVI_ONLY:
+		{
+			plvds_chip_info->output_interface = INTERFACE_NONE;
+			break;
+		}
+
+	case HW_LAYOUT_LCD1_LCD2:
+	case HW_LAYOUT_LCD_EXTERNAL_LCD2:
+		{
+			plvds_chip_info->output_interface =
+			    INTERFACE_LVDS0LVDS1;
+			break;
+		}
+
+	case HW_LAYOUT_LCD_DVI:
+		{
+			plvds_chip_info->output_interface = INTERFACE_LVDS1;
+			break;
+		}
+
+	default:
+		{
+			plvds_chip_info->output_interface = INTERFACE_LVDS1;
+			break;
+		}
+	}
+
+	DEBUG_MSG(KERN_INFO
+		  "Display Hardware Layout: 0x%x, LCD DI Port: 0x%x\n",
+		  display_hardware_layout, plvds_chip_info->output_interface);
+}
+
+void init_lvds_output_interface(struct lvds_chip_information
+				*plvds_chip_info,
+				struct lvds_setting_information
+				*plvds_setting_info)
+{
+	if (INTERFACE_NONE != plvds_chip_info->output_interface) {
+		/*Do nothing, lcd port is specified by module parameter */
+		return;
+	}
+
+	switch (plvds_chip_info->lvds_chip_name) {
+
+	case VT1636_LVDS:
+		switch (chip_info.gfx_chip_name) {
+		case UNICHROME_CX700:
+			plvds_chip_info->output_interface = INTERFACE_DVP1;
+			break;
+		case UNICHROME_CN700:
+			plvds_chip_info->output_interface = INTERFACE_DFP_LOW;
+			break;
+		default:
+			plvds_chip_info->output_interface = INTERFACE_DVP0;
+			break;
+		}
+		break;
+
+	case INTEGRATED_LVDS:
+		check_diport_of_integrated_lvds(plvds_chip_info,
+						plvds_setting_info);
+		break;
+
+	default:
+		switch (chip_info.gfx_chip_name) {
+		case UNICHROME_K8M890:
+		case UNICHROME_P4M900:
+		case UNICHROME_P4M890:
+			plvds_chip_info->output_interface = INTERFACE_DFP_LOW;
+			break;
+		default:
+			plvds_chip_info->output_interface = INTERFACE_DFP;
+			break;
+		}
+		break;
+	}
+}
+
+struct display_timing lcd_centering_timging(struct display_timing
+					    mode_crt_reg,
+					    struct display_timing panel_crt_reg)
+{
+	struct display_timing crt_reg;
+
+	crt_reg.hor_total = panel_crt_reg.hor_total;
+	crt_reg.hor_addr = mode_crt_reg.hor_addr;
+	crt_reg.hor_blank_start =
+	    (panel_crt_reg.hor_addr - mode_crt_reg.hor_addr) / 2 +
+	    crt_reg.hor_addr;
+	crt_reg.hor_blank_end = panel_crt_reg.hor_blank_end;
+	crt_reg.hor_sync_start =
+	    (panel_crt_reg.hor_sync_start -
+	     panel_crt_reg.hor_blank_start) + crt_reg.hor_blank_start;
+	crt_reg.hor_sync_end = panel_crt_reg.hor_sync_end;
+
+	crt_reg.ver_total = panel_crt_reg.ver_total;
+	crt_reg.ver_addr = mode_crt_reg.ver_addr;
+	crt_reg.ver_blank_start =
+	    (panel_crt_reg.ver_addr - mode_crt_reg.ver_addr) / 2 +
+	    crt_reg.ver_addr;
+	crt_reg.ver_blank_end = panel_crt_reg.ver_blank_end;
+	crt_reg.ver_sync_start =
+	    (panel_crt_reg.ver_sync_start -
+	     panel_crt_reg.ver_blank_start) + crt_reg.ver_blank_start;
+	crt_reg.ver_sync_end = panel_crt_reg.ver_sync_end;
+
+	return crt_reg;
+}
+
+void load_crtc_shadow_timing(struct display_timing mode_timing,
+			     struct display_timing panel_timing)
+{
+	struct io_register *reg = NULL;
+	int i;
+	int load_reg_Num = 0;
+	int reg_value = 0;
+
+	if (lvds_setting_info.display_method == LCD_EXPANDSION) {
+		/* Expansion */
+		for (i = 12; i < 20; i++) {
+			switch (i) {
+			case H_TOTAL_SHADOW_INDEX:
+				reg_value =
+				    IGA2_HOR_TOTAL_SHADOW_FORMULA
+				    (panel_timing.hor_total);
+				load_reg_Num =
+				    iga2_shadow_crtc_reg.hor_total_shadow.
+				    reg_num;
+				reg = iga2_shadow_crtc_reg.hor_total_shadow.reg;
+				break;
+			case H_BLANK_END_SHADOW_INDEX:
+				reg_value =
+				    IGA2_HOR_BLANK_END_SHADOW_FORMULA
+				    (panel_timing.hor_blank_start,
+				     panel_timing.hor_blank_end);
+				load_reg_Num =
+				    iga2_shadow_crtc_reg.
+				    hor_blank_end_shadow.reg_num;
+				reg =
+				    iga2_shadow_crtc_reg.
+				    hor_blank_end_shadow.reg;
+				break;
+			case V_TOTAL_SHADOW_INDEX:
+				reg_value =
+				    IGA2_VER_TOTAL_SHADOW_FORMULA
+				    (panel_timing.ver_total);
+				load_reg_Num =
+				    iga2_shadow_crtc_reg.ver_total_shadow.
+				    reg_num;
+				reg = iga2_shadow_crtc_reg.ver_total_shadow.reg;
+				break;
+			case V_ADDR_SHADOW_INDEX:
+				reg_value =
+				    IGA2_VER_ADDR_SHADOW_FORMULA
+				    (panel_timing.ver_addr);
+				load_reg_Num =
+				    iga2_shadow_crtc_reg.ver_addr_shadow.
+				    reg_num;
+				reg = iga2_shadow_crtc_reg.ver_addr_shadow.reg;
+				break;
+			case V_BLANK_SATRT_SHADOW_INDEX:
+				reg_value =
+				    IGA2_VER_BLANK_START_SHADOW_FORMULA
+				    (panel_timing.ver_blank_start);
+				load_reg_Num =
+				    iga2_shadow_crtc_reg.
+				    ver_blank_start_shadow.reg_num;
+				reg =
+				    iga2_shadow_crtc_reg.
+				    ver_blank_start_shadow.reg;
+				break;
+			case V_BLANK_END_SHADOW_INDEX:
+				reg_value =
+				    IGA2_VER_BLANK_END_SHADOW_FORMULA
+				    (panel_timing.ver_blank_start,
+				     panel_timing.ver_blank_end);
+				load_reg_Num =
+				    iga2_shadow_crtc_reg.
+				    ver_blank_end_shadow.reg_num;
+				reg =
+				    iga2_shadow_crtc_reg.
+				    ver_blank_end_shadow.reg;
+				break;
+			case V_SYNC_SATRT_SHADOW_INDEX:
+				reg_value =
+				    IGA2_VER_SYNC_START_SHADOW_FORMULA
+				    (panel_timing.ver_sync_start);
+				load_reg_Num =
+				    iga2_shadow_crtc_reg.
+				    ver_sync_start_shadow.reg_num;
+				reg =
+				    iga2_shadow_crtc_reg.
+				    ver_sync_start_shadow.reg;
+				break;
+			case V_SYNC_END_SHADOW_INDEX:
+				reg_value =
+				    IGA2_VER_SYNC_END_SHADOW_FORMULA
+				    (panel_timing.ver_sync_start,
+				     panel_timing.ver_sync_end);
+				load_reg_Num =
+				    iga2_shadow_crtc_reg.
+				    ver_sync_end_shadow.reg_num;
+				reg =
+				    iga2_shadow_crtc_reg.
+				    ver_sync_end_shadow.reg;
+				break;
+			}
+			load_reg(reg_value, load_reg_Num, reg, VIACR);
+		}
+	} else {		/* Centering */
+		for (i = 12; i < 20; i++) {
+			switch (i) {
+			case H_TOTAL_SHADOW_INDEX:
+				reg_value =
+				    IGA2_HOR_TOTAL_SHADOW_FORMULA
+				    (panel_timing.hor_total);
+				load_reg_Num =
+				    iga2_shadow_crtc_reg.hor_total_shadow.
+				    reg_num;
+				reg = iga2_shadow_crtc_reg.hor_total_shadow.reg;
+				break;
+			case H_BLANK_END_SHADOW_INDEX:
+				reg_value =
+				    IGA2_HOR_BLANK_END_SHADOW_FORMULA
+				    (panel_timing.hor_blank_start,
+				     panel_timing.hor_blank_end);
+				load_reg_Num =
+				    iga2_shadow_crtc_reg.
+				    hor_blank_end_shadow.reg_num;
+				reg =
+				    iga2_shadow_crtc_reg.
+				    hor_blank_end_shadow.reg;
+				break;
+			case V_TOTAL_SHADOW_INDEX:
+				reg_value =
+				    IGA2_VER_TOTAL_SHADOW_FORMULA
+				    (panel_timing.ver_total);
+				load_reg_Num =
+				    iga2_shadow_crtc_reg.ver_total_shadow.
+				    reg_num;
+				reg = iga2_shadow_crtc_reg.ver_total_shadow.reg;
+				break;
+			case V_ADDR_SHADOW_INDEX:
+				reg_value =
+				    IGA2_VER_ADDR_SHADOW_FORMULA
+				    (mode_timing.ver_addr);
+				load_reg_Num =
+				    iga2_shadow_crtc_reg.ver_addr_shadow.
+				    reg_num;
+				reg = iga2_shadow_crtc_reg.ver_addr_shadow.reg;
+				break;
+			case V_BLANK_SATRT_SHADOW_INDEX:
+				reg_value =
+				    IGA2_VER_BLANK_START_SHADOW_FORMULA
+				    (mode_timing.ver_blank_start);
+				load_reg_Num =
+				    iga2_shadow_crtc_reg.
+				    ver_blank_start_shadow.reg_num;
+				reg =
+				    iga2_shadow_crtc_reg.
+				    ver_blank_start_shadow.reg;
+				break;
+			case V_BLANK_END_SHADOW_INDEX:
+				reg_value =
+				    IGA2_VER_BLANK_END_SHADOW_FORMULA
+				    (panel_timing.ver_blank_start,
+				     panel_timing.ver_blank_end);
+				load_reg_Num =
+				    iga2_shadow_crtc_reg.
+				    ver_blank_end_shadow.reg_num;
+				reg =
+				    iga2_shadow_crtc_reg.
+				    ver_blank_end_shadow.reg;
+				break;
+			case V_SYNC_SATRT_SHADOW_INDEX:
+				reg_value =
+				    IGA2_VER_SYNC_START_SHADOW_FORMULA(
+				    (panel_timing.ver_sync_start -
+				    panel_timing.ver_blank_start) +
+				    (panel_timing.ver_addr -
+				    mode_timing.ver_addr) / 2 +
+				    mode_timing.ver_addr);
+				load_reg_Num =
+				    iga2_shadow_crtc_reg.ver_sync_start_shadow.
+				    reg_num;
+				reg =
+				    iga2_shadow_crtc_reg.ver_sync_start_shadow.
+				    reg;
+				break;
+			case V_SYNC_END_SHADOW_INDEX:
+				reg_value =
+				    IGA2_VER_SYNC_END_SHADOW_FORMULA(
+				    (panel_timing.ver_sync_start -
+				    panel_timing.ver_blank_start) +
+				    (panel_timing.ver_addr -
+				    mode_timing.ver_addr) / 2 +
+				    mode_timing.ver_addr,
+				    panel_timing.ver_sync_end);
+				load_reg_Num =
+				    iga2_shadow_crtc_reg.ver_sync_end_shadow.
+				    reg_num;
+				reg =
+				    iga2_shadow_crtc_reg.ver_sync_end_shadow.
+				    reg;
+				break;
+			}
+			load_reg(reg_value, load_reg_Num, reg, VIACR);
+		}
+	}
+}
+
+bool lcd_get_mobile_state(bool *mobile)
+{
+	unsigned char *romptr, *tableptr;
+	u8 core_base;
+	unsigned char *biosptr;
+	/* Rom address */
+	u32 romaddr = 0x000C0000;
+	u16 start_pattern = (u16) NULL;
+
+	biosptr = ioremap(romaddr, 0x10000);
+
+	memcpy(&start_pattern, biosptr, 2);
+	/* Compare pattern */
+	if (start_pattern == 0xAA55) {
+		/* Get the start of Table */
+		/* 0x1B means BIOS offset position */
+		romptr = biosptr + 0x1B;
+		tableptr = biosptr + *((u16 *) romptr);
+
+		/* Get the start of biosver structure */
+		/* 18 means BIOS version position. */
+		romptr = tableptr + 18;
+		romptr = biosptr + *((u16 *) romptr);
+
+		/* The offset should be 44, but the
+		   actual image is less three char. */
+		/* pRom += 44; */
+		romptr += 41;
+
+		core_base = *romptr++;
+
+		if (core_base & 0x8)
+			*mobile = FALSE;
+		else
+			*mobile = TRUE;
+		/* release memory */
+		iounmap(biosptr);
+
+		return TRUE;
+	} else {
+		iounmap(biosptr);
+		return FALSE;
+	}
+}
+
+void load_scaling_factor_for_p4m900(int set_hres, int set_vres,
+				    int panel_hres, int panel_vres)
+{
+	int h_scaling_factor;
+	int v_scaling_factor;
+	u8 cra2 = 0;
+	u8 cr77 = 0;
+	u8 cr78 = 0;
+	u8 cr79 = 0;
+	u8 cr9f = 0;
+	/* Check if expansion for horizontal */
+	if (set_hres < panel_hres) {
+		/* Load Horizontal Scaling Factor */
+
+		/* For VIA_K8M800 or later chipsets. */
+		h_scaling_factor =
+		    K800_LCD_HOR_SCF_FORMULA(set_hres, panel_hres);
+		/* HSCaleFactor[1:0] at CR9F[1:0] */
+		cr9f = h_scaling_factor & 0x0003;
+		/* HSCaleFactor[9:2] at CR77[7:0] */
+		cr77 = (h_scaling_factor & 0x03FC) >> 2;
+		/* HSCaleFactor[11:10] at CR79[5:4] */
+		cr79 = (h_scaling_factor & 0x0C00) >> 10;
+		cr79 <<= 4;
+
+		/* Horizontal scaling enabled */
+		cra2 = 0xC0;
+
+		DEBUG_MSG(KERN_INFO "Horizontal Scaling value = %d\n",
+			  h_scaling_factor);
+	} else {
+		/* Horizontal scaling disabled */
+		cra2 = 0x00;
+	}
+
+	/* Check if expansion for vertical */
+	if (set_vres < panel_vres) {
+		/* Load Vertical Scaling Factor */
+
+		/* For VIA_K8M800 or later chipsets. */
+		v_scaling_factor =
+		    K800_LCD_VER_SCF_FORMULA(set_vres, panel_vres);
+
+		/* Vertical scaling enabled */
+		cra2 |= 0x08;
+		/* VSCaleFactor[0] at CR79[3] */
+		cr79 |= ((v_scaling_factor & 0x0001) << 3);
+		/* VSCaleFactor[8:1] at CR78[7:0] */
+		cr78 |= (v_scaling_factor & 0x01FE) >> 1;
+		/* VSCaleFactor[10:9] at CR79[7:6] */
+		cr79 |= ((v_scaling_factor & 0x0600) >> 9) << 6;
+
+		DEBUG_MSG(KERN_INFO "Vertical Scaling value = %d\n",
+			  v_scaling_factor);
+	} else {
+		/* Vertical scaling disabled */
+		cra2 |= 0x00;
+	}
+
+	write_reg_mask(CRA2, VIACR, cra2, BIT3 + BIT6 + BIT7);
+	write_reg_mask(CR77, VIACR, cr77, 0xFF);
+	write_reg_mask(CR78, VIACR, cr78, 0xFF);
+	write_reg_mask(CR79, VIACR, cr79, 0xF8);
+	write_reg_mask(CR9F, VIACR, cr9f, BIT0 + BIT1);
+}
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
