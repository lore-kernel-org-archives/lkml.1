Return-Path: <linux-kernel-owner+w=401wt.eu-S1753308AbXDIVuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbXDIVuq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753465AbXDIVt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:49:56 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:27265 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030200AbXDIVXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:23:47 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Kai Svahn <kai.svahn@nokia.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 13/18] ARM: OMAP: Sync framebuffer headers with N800 tree
Date: Mon,  9 Apr 2007 17:22:18 -0400
Message-Id: <11761537921036-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <117615378995-git-send-email-tony@atomide.com>
References: <11761537431635-git-send-email-tony@atomide.com> <117615374683-git-send-email-tony@atomide.com> <11761537491968-git-send-email-tony@atomide.com> <11761537522665-git-send-email-tony@atomide.com> <11761537563620-git-send-email-tony@atomide.com> <11761537613625-git-send-email-tony@atomide.com> <11761537672719-git-send-email-tony@atomide.com> <1176153771729-git-send-email-tony@atomide.com> <11761537743905-git-send-email-tony@atomide.com> <1176153781321-git-send-email-tony@atomide.com> <1176153783637-git-send-email-tony@atomide.com> <11761537863183-git-send-email-tony@atomide.com> <117615378995-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kai Svahn <kai.svahn@nokia.com>

This patch syncs framebuffer headers with N800 tree.

Signed-off-by: Kai Svahn <kai.svahn@nokia.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 include/asm-arm/arch-omap/hwa742.h |   12 +++++++
 include/asm-arm/arch-omap/omapfb.h |   61 ++++++++++++++++++++++++++++++------
 2 files changed, 63 insertions(+), 10 deletions(-)

--- /dev/null
+++ b/include/asm-arm/arch-omap/hwa742.h
@@ -0,0 +1,12 @@
+#ifndef _HWA742_H
+#define _HWA742_H
+
+struct hwa742_platform_data {
+	void		(*power_up)(struct device *dev);
+	void		(*power_down)(struct device *dev);
+	unsigned long	(*get_clock_rate)(struct device *dev);
+
+	unsigned	te_connected:1;
+};
+
+#endif
--- a/include/asm-arm/arch-omap/omapfb.h
+++ b/include/asm-arm/arch-omap/omapfb.h
@@ -38,30 +38,47 @@
 #define OMAPFB_SYNC_GFX		OMAP_IO(37)
 #define OMAPFB_VSYNC		OMAP_IO(38)
 #define OMAPFB_SET_UPDATE_MODE	OMAP_IOW(40, int)
-#define OMAPFB_UPDATE_WINDOW_OLD OMAP_IOW(41, struct omapfb_update_window_old)
+#define OMAPFB_GET_CAPS		OMAP_IOR(42, struct omapfb_caps)
 #define OMAPFB_GET_UPDATE_MODE	OMAP_IOW(43, int)
 #define OMAPFB_LCD_TEST		OMAP_IOW(45, int)
 #define OMAPFB_CTRL_TEST	OMAP_IOW(46, int)
-#define OMAPFB_UPDATE_WINDOW	OMAP_IOW(47, struct omapfb_update_window)
+#define OMAPFB_UPDATE_WINDOW_OLD OMAP_IOW(47, struct omapfb_update_window_old)
 #define OMAPFB_SET_COLOR_KEY	OMAP_IOW(50, struct omapfb_color_key)
 #define OMAPFB_GET_COLOR_KEY	OMAP_IOW(51, struct omapfb_color_key)
 #define OMAPFB_SETUP_PLANE	OMAP_IOW(52, struct omapfb_plane_info)
 #define OMAPFB_QUERY_PLANE	OMAP_IOW(53, struct omapfb_plane_info)
+#define OMAPFB_UPDATE_WINDOW	OMAP_IOW(54, struct omapfb_update_window)
+#define OMAPFB_SETUP_MEM	OMAP_IOW(55, struct omapfb_mem_info)
+#define OMAPFB_QUERY_MEM	OMAP_IOW(56, struct omapfb_mem_info)
 
 #define OMAPFB_CAPS_GENERIC_MASK	0x00000fff
 #define OMAPFB_CAPS_LCDC_MASK		0x00fff000
 #define OMAPFB_CAPS_PANEL_MASK		0xff000000
 
 #define OMAPFB_CAPS_MANUAL_UPDATE	0x00001000
+#define OMAPFB_CAPS_TEARSYNC		0x00002000
+#define OMAPFB_CAPS_PLANE_RELOCATE_MEM	0x00004000
+#define OMAPFB_CAPS_PLANE_SCALE		0x00008000
+#define OMAPFB_CAPS_WINDOW_PIXEL_DOUBLE	0x00010000
+#define OMAPFB_CAPS_WINDOW_SCALE	0x00020000
+#define OMAPFB_CAPS_WINDOW_OVERLAY	0x00040000
 #define OMAPFB_CAPS_SET_BACKLIGHT	0x01000000
 
 /* Values from DSP must map to lower 16-bits */
-#define OMAPFB_FORMAT_MASK         0x00ff
-#define OMAPFB_FORMAT_FLAG_DOUBLE  0x0100
+#define OMAPFB_FORMAT_MASK		0x00ff
+#define OMAPFB_FORMAT_FLAG_DOUBLE	0x0100
+#define OMAPFB_FORMAT_FLAG_TEARSYNC	0x0200
+#define OMAPFB_FORMAT_FLAG_FORCE_VSYNC	0x0400
+#define OMAPFB_FORMAT_FLAG_ENABLE_OVERLAY	0x0800
+#define OMAPFB_FORMAT_FLAG_DISABLE_OVERLAY	0x1000
 
 #define OMAPFB_EVENT_READY	1
 #define OMAPFB_EVENT_DISABLED	2
 
+#define OMAPFB_MEMTYPE_SDRAM		0
+#define OMAPFB_MEMTYPE_SRAM		1
+#define OMAPFB_MEMTYPE_MAX		1
+
 enum omapfb_color_format {
 	OMAPFB_COLOR_RGB565 = 0,
 	OMAPFB_COLOR_YUV422,
@@ -78,11 +95,15 @@ struct omapfb_update_window {
 	__u32 x, y;
 	__u32 width, height;
 	__u32 format;
+	__u32 out_x, out_y;
+	__u32 out_width, out_height;
+	__u32 reserved[8];
 };
 
 struct omapfb_update_window_old {
 	__u32 x, y;
 	__u32 width, height;
+	__u32 format;
 };
 
 enum omapfb_plane {
@@ -108,6 +129,18 @@ struct omapfb_plane_info {
 	__u32 reserved2[12];
 };
 
+struct omapfb_mem_info {
+	__u32 size;
+	__u8  type;
+	__u8  reserved[3];
+};
+
+struct omapfb_caps {
+	__u32 ctrl;
+	__u32 plane_color;
+	__u32 wnd_color;
+};
+
 enum omapfb_color_key_type {
 	OMAPFB_COLOR_KEY_DISABLED = 0,
 	OMAPFB_COLOR_KEY_GFX_DST,
@@ -191,8 +224,6 @@ struct lcd_panel {
 	int		(*run_test)	(struct lcd_panel *panel, int test_num);
 };
 
-struct omapfb_device;
-
 struct extif_timings {
 	int cs_on_time;
 	int cs_off_time;
@@ -216,6 +247,7 @@ struct lcd_ctrl_extif {
 	int  (*init)		(struct omapfb_device *fbdev);
 	void (*cleanup)		(void);
 	void (*get_clk_info)	(u32 *clk_period, u32 *max_clk_div);
+	unsigned long (*get_max_tx_rate)(void);
 	int  (*convert_timings)	(struct extif_timings *timings);
 	void (*set_timings)	(const struct extif_timings *timings);
 	void (*set_bits_per_cycle)(int bpc);
@@ -224,6 +256,10 @@ struct lcd_ctrl_extif {
 	void (*write_data)	(const void *buf, unsigned int len);
 	void (*transfer_area)	(int width, int height,
 				 void (callback)(void * data), void *data);
+	int  (*setup_tearsync)	(unsigned pin_cnt,
+				 unsigned hs_pulse_time, unsigned vs_pulse_time,
+				 int hs_pol_inv, int vs_pol_inv, int div);
+	int  (*enable_tearsync) (int enable, unsigned line);
 
 	unsigned long		max_transmit_size;
 };
@@ -242,7 +278,9 @@ struct omapfb_mem_region {
 	dma_addr_t	paddr;
 	void		*vaddr;
 	unsigned long	size;
-	int		alloc:1;
+	u8		type;		/* OMAPFB_PLANE_MEM_* */
+	unsigned	alloc:1;	/* allocated by the driver */
+	unsigned	map:1;		/* kernel mapped by the driver */
 };
 
 struct omapfb_mem_desc {
@@ -259,7 +297,7 @@ struct lcd_ctrl {
 					   struct omapfb_mem_desc *req_md);
 	void		(*cleanup)	  (void);
 	void		(*bind_client)	  (struct omapfb_notifier_block *nb);
-	unsigned long	(*get_caps)	  (void);
+	void		(*get_caps)	  (int plane, struct omapfb_caps *caps);
 	int		(*set_update_mode)(enum omapfb_update_mode mode);
 	enum omapfb_update_mode (*get_update_mode)(void);
 	int		(*setup_plane)	  (int plane, int channel_out,
@@ -267,6 +305,10 @@ struct lcd_ctrl {
 					   int screen_width,
 					   int pos_x, int pos_y, int width,
 					   int height, int color_mode);
+	int		(*setup_mem)	  (int plane, size_t size,
+					   int mem_type, unsigned long *paddr);
+	int		(*mmap)		  (struct fb_info *info,
+					   struct vm_area_struct *vma);
 	int		(*set_scale)	  (int plane,
 					   int orig_width, int orig_height,
 					   int out_width, int out_height);
@@ -284,7 +326,6 @@ struct lcd_ctrl {
 					   int update_hw_mem);
 	int		(*set_color_key)  (struct omapfb_color_key *ck);
 	int		(*get_color_key)  (struct omapfb_color_key *ck);
-
 };
 
 enum omapfb_state {
@@ -315,6 +356,7 @@ struct omapfb_device {
 	struct lcd_ctrl_extif	*ext_if;		/* LCD ctrl external
 							   interface */
 	struct device		*dev;
+	struct fb_var_screeninfo	new_var;	/* for mode changes */
 
 	struct omapfb_mem_desc		mem_desc;
 	struct fb_info			*fb_info[OMAPFB_PLANE_NUM];
@@ -346,7 +388,6 @@ extern int  omapfb_update_window_async(struct fb_info *fbi,
 				       void *callback_data);
 
 /* in arch/arm/plat-omap/fb.c */
-extern void omapfb_reserve_mem(void);
 extern void omapfb_set_ctrl_platform_data(void *pdata);
 
 #endif /* __KERNEL__ */
-- 
1.4.4.2

