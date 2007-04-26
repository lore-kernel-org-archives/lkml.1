Return-Path: <linux-kernel-owner+w=401wt.eu-S1755279AbXDZXuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbXDZXuP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 19:50:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755262AbXDZXrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 19:47:45 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:35845 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755257AbXDZXrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 19:47:35 -0400
Date: Fri, 27 Apr 2007 01:47:44 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: thomas@winischhofer.net, adaplas@gmail.com, linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/video/sis/: remove more kernel 2.4 code
Message-ID: <20070426234744.GI3468@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the remaining kernel 2.4 code.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

This patch has been sent on:
- 26 Mar 2007

 drivers/video/sis/osdef.h    |    5 -
 drivers/video/sis/sis.h      |   50 ----------------
 drivers/video/sis/sis_main.c |  105 ++++++-----------------------------
 3 files changed, 22 insertions(+), 138 deletions(-)

--- linux-2.6.21-rc4-mm1/drivers/video/sis/osdef.h.old	2007-03-25 20:41:24.000000000 +0200
+++ linux-2.6.21-rc4-mm1/drivers/video/sis/osdef.h	2007-03-25 20:41:38.000000000 +0200
@@ -58,9 +58,6 @@
 #define SIS_LINUX_KERNEL		/* Linux kernel framebuffer */
 #undef  SIS_XORG_XF86			/* XFree86/X.org */
 
-#undef SIS_LINUX_KERNEL_24
-#undef SIS_LINUX_KERNEL_26
-
 #ifdef OutPortByte
 #undef OutPortByte
 #endif
@@ -100,8 +97,6 @@
 #define SIS315H
 #endif
 
-#define SIS_LINUX_KERNEL_26
-
 #if !defined(SIS300) && !defined(SIS315H)
 #warning Neither CONFIG_FB_SIS_300 nor CONFIG_FB_SIS_315 is set
 #warning sisfb will not work!
--- linux-2.6.21-rc4-mm1/drivers/video/sis/sis.h.old	2007-03-25 20:43:55.000000000 +0200
+++ linux-2.6.21-rc4-mm1/drivers/video/sis/sis.h	2007-03-25 20:47:29.000000000 +0200
@@ -27,11 +27,7 @@
 #include <linux/version.h>
 
 #include "osdef.h"
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 #include <video/sisfb.h>
-#else
-#include <linux/sisfb.h>
-#endif
 
 #include "vgatypes.h"
 #include "vstruct.h"
@@ -40,12 +36,8 @@
 #define VER_MINOR		8
 #define VER_LEVEL		9
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 #include <linux/spinlock.h>
-#define SIS_PCI_GET_CLASS(a, b) pci_get_class(a, b)
-#define SIS_PCI_GET_DEVICE(a,b,c) pci_get_device(a,b,c)
-#define SIS_PCI_GET_SLOT(a,b) pci_get_slot(a,b)
-#define SIS_PCI_PUT_DEVICE(a) pci_dev_put(a)
+
 #ifdef CONFIG_COMPAT
 #if LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,10)
 #include <linux/ioctl32.h>
@@ -55,18 +47,7 @@
 #define SIS_NEW_CONFIG_COMPAT
 #endif
 #endif	/* CONFIG_COMPAT */
-#else  /* 2.4 */
-#define SIS_PCI_GET_CLASS(a, b) pci_find_class(a, b)
-#define SIS_PCI_GET_DEVICE(a,b,c) pci_find_device(a,b,c)
-#define SIS_PCI_GET_SLOT(a,b) pci_find_slot(a,b)
-#define SIS_PCI_PUT_DEVICE(a)
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,19)
-#ifdef __x86_64__	/* Shouldn't we check for CONFIG_IA32_EMULATION here? */
-#include <asm/ioctl32.h>
-#define SIS_OLD_CONFIG_COMPAT
-#endif
-#endif
-#endif /* 2.4 */
+
 #if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,8)
 #define SIS_IOTYPE1 void __iomem
 #define SIS_IOTYPE2 __iomem
@@ -498,26 +479,8 @@
 
 	struct fb_var_screeninfo default_var;
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 	struct fb_fix_screeninfo sisfb_fix;
 	u32		pseudo_palette[17];
-#endif
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-	struct display		 sis_disp;
-	struct display_switch 	 sisfb_sw;
-	struct {
-		u16 red, green, blue, pad;
-	}		sis_palette[256];
-	union {
-#ifdef FBCON_HAS_CFB16
-		u16 cfb16[16];
-#endif
-#ifdef FBCON_HAS_CFB32
-		u32 cfb32[16];
-#endif
-	}		sis_fbcon_cmap;
-#endif
 
 	struct sisfb_monitor {
 		u16 hmin;
@@ -538,10 +501,6 @@
 
 	int		mni;	/* Mode number index */
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-	int		currcon;
-#endif
-
 	unsigned long	video_size;
 	unsigned long	video_base;
 	unsigned long	mmio_size;
@@ -578,9 +537,6 @@
 	int		sisfb_tvplug;
 	int		sisfb_tvstd;
 	int		sisfb_nocrt2rate;
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-	int		sisfb_inverse;
-#endif
 
 	u32		heapstart;		/* offset  */
 	SIS_IOTYPE1	*sisfb_heap_start;	/* address */
@@ -646,9 +602,7 @@
 	int		modechanged;
 	unsigned char	modeprechange;
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 	u8		sisfb_lastrates[128];
-#endif
 
 	int		newrom;
 	int		haveXGIROM;
--- linux-2.6.21-rc4-mm1/drivers/video/sis/sis_main.c.old	2007-03-25 20:45:12.000000000 +0200
+++ linux-2.6.21-rc4-mm1/drivers/video/sis/sis_main.c	2007-03-25 20:54:46.000000000 +0200
@@ -1948,7 +1948,7 @@
 	default:	return NULL;
 	}
 	for(i = 0; i < nbridgenum; i++) {
-		if((pdev = SIS_PCI_GET_DEVICE(PCI_VENDOR_ID_SI,
+		if((pdev = pci_get_device(PCI_VENDOR_ID_SI,
 				nbridgeids[nbridgeidx+i], NULL)))
 			break;
 	}
@@ -4613,9 +4613,9 @@
 	unsigned short temp;
 	int ret = 0;
 
-	while((pdev = SIS_PCI_GET_CLASS(PCI_CLASS_BRIDGE_HOST, pdev))) {
+	while((pdev = pci_get_class(PCI_CLASS_BRIDGE_HOST, pdev))) {
 		temp = pdev->vendor;
-		SIS_PCI_PUT_DEVICE(pdev);
+		pci_dev_put(pdev);
 		if(temp == pcivendor) {
 			ret = 1;
 			break;
@@ -5154,24 +5154,24 @@
 			if(reg & 0x80) v2 |= 0x80;
 			v2 |= 0x01;
 
-			if((mypdev = SIS_PCI_GET_DEVICE(PCI_VENDOR_ID_SI, 0x0730, NULL))) {
-				SIS_PCI_PUT_DEVICE(mypdev);
+			if((mypdev = pci_get_device(PCI_VENDOR_ID_SI, 0x0730, NULL))) {
+				pci_dev_put(mypdev);
 				if(((v2 & 0x06) == 2) || ((v2 & 0x06) == 4))
 					v2 &= 0xf9;
 				v2 |= 0x08;
 				v1 &= 0xfe;
 			} else {
-				mypdev = SIS_PCI_GET_DEVICE(PCI_VENDOR_ID_SI, 0x0735, NULL);
+				mypdev = pci_get_device(PCI_VENDOR_ID_SI, 0x0735, NULL);
 				if(!mypdev)
-					mypdev = SIS_PCI_GET_DEVICE(PCI_VENDOR_ID_SI, 0x0645, NULL);
+					mypdev = pci_get_device(PCI_VENDOR_ID_SI, 0x0645, NULL);
 				if(!mypdev)
-					mypdev = SIS_PCI_GET_DEVICE(PCI_VENDOR_ID_SI, 0x0650, NULL);
+					mypdev = pci_get_device(PCI_VENDOR_ID_SI, 0x0650, NULL);
 				if(mypdev) {
 					pci_read_config_dword(mypdev, 0x94, &regd);
 					regd &= 0xfffffeff;
 					pci_write_config_dword(mypdev, 0x94, regd);
 					v1 &= 0xfe;
-					SIS_PCI_PUT_DEVICE(mypdev);
+					pci_dev_put(mypdev);
 				} else if(sisfb_find_host_bridge(ivideo, pdev, PCI_VENDOR_ID_SI)) {
 					v1 &= 0xfe;
 				} else if(sisfb_find_host_bridge(ivideo, pdev, 0x1106) ||
@@ -5194,13 +5194,13 @@
 			if( (!(v1 & 0x02)) && (v2 & 0x30) && (regd < 0xcf) )
 				setSISIDXREG(SISCR, 0x5f, 0xf1, 0x01);
 
-			if((mypdev = SIS_PCI_GET_DEVICE(0x10de, 0x01e0, NULL))) {
+			if((mypdev = pci_get_device(0x10de, 0x01e0, NULL))) {
 				/* TODO: set CR5f &0xf1 | 0x01 for version 6570
 				 * of nforce 2 ROM
 				 */
 				if(0)
 					setSISIDXREG(SISCR, 0x5f, 0xf1, 0x01);
-				SIS_PCI_PUT_DEVICE(mypdev);
+				pci_dev_put(mypdev);
 			}
 		}
 
@@ -5236,9 +5236,9 @@
 		setSISIDXREG(SISCR, 0x75, 0xe0, bios[0x4ff] & 0x1f);
 		setSISIDXREG(SISCR, 0x76, 0xe0, bios[0x500] & 0x1f);
 		v1 = bios[0x501];
-		if((mypdev = SIS_PCI_GET_DEVICE(0x8086, 0x2530, NULL))) {
+		if((mypdev = pci_get_device(0x8086, 0x2530, NULL))) {
 			v1 = 0xf0;
-			SIS_PCI_PUT_DEVICE(mypdev);
+			pci_dev_put(mypdev);
 		}
 		outSISIDXREG(SISCR, 0x77, v1);
 	}
@@ -5947,7 +5947,7 @@
 
 	if(!ivideo->sisvga_enabled) {
 		if(pci_enable_device(pdev)) {
-			if(ivideo->nbridge) SIS_PCI_PUT_DEVICE(ivideo->nbridge);
+			if(ivideo->nbridge) pci_dev_put(ivideo->nbridge);
 			pci_set_drvdata(pdev, NULL);
 			kfree(sis_fb_info);
 			return -EIO;
@@ -5974,7 +5974,7 @@
 					"requiring Chrontel/GPIO setup\n",
 					mychswtable[i].vendorName,
 					mychswtable[i].cardName);
-				ivideo->lpcdev = SIS_PCI_GET_DEVICE(PCI_VENDOR_ID_SI, 0x0008, NULL);
+				ivideo->lpcdev = pci_get_device(PCI_VENDOR_ID_SI, 0x0008, NULL);
 				break;
 			}
 			i++;
@@ -5984,7 +5984,7 @@
 
 #ifdef CONFIG_FB_SIS_315
 	if((ivideo->chip == SIS_760) && (ivideo->nbridge)) {
-		ivideo->lpcdev = SIS_PCI_GET_SLOT(ivideo->nbridge->bus, (2 << 3));
+		ivideo->lpcdev = pci_get_slot(ivideo->nbridge->bus, (2 << 3));
 	}
 #endif
 
@@ -6149,9 +6149,9 @@
 error_2:	release_mem_region(ivideo->mmio_base, ivideo->mmio_size);
 error_3:	vfree(ivideo->bios_abase);
 		if(ivideo->lpcdev)
-			SIS_PCI_PUT_DEVICE(ivideo->lpcdev);
+			pci_dev_put(ivideo->lpcdev);
 		if(ivideo->nbridge)
-			SIS_PCI_PUT_DEVICE(ivideo->nbridge);
+			pci_dev_put(ivideo->nbridge);
 		pci_set_drvdata(pdev, NULL);
 		if(!ivideo->sisvga_enabled)
 			pci_disable_device(pdev);
@@ -6331,70 +6331,6 @@
 
 		sisfb_set_vparms(ivideo);
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-
-		/* ---------------- For 2.4: Now switch the mode ------------------ */
-
-		printk(KERN_INFO "sisfb: Setting mode %dx%dx%d (%dHz)\n",
-			ivideo->video_width, ivideo->video_height, ivideo->video_bpp,
-			ivideo->refresh_rate);
-
-		/* Determine whether or not acceleration is to be
-		 * used. Need to know before pre/post_set_mode()
-		 */
-		ivideo->accel = 0;
-		ivideo->default_var.accel_flags &= ~FB_ACCELF_TEXT;
-		if(ivideo->sisfb_accel) {
-			ivideo->accel = -1;
-			ivideo->default_var.accel_flags |= FB_ACCELF_TEXT;
-		}
-
-		/* Now switch the mode */
-		sisfb_pre_setmode(ivideo);
-
-		if(SiSSetMode(&ivideo->SiS_Pr, ivideo->mode_no) == 0) {
-			printk(KERN_ERR "sisfb: Fatal error: Setting mode[0x%x] failed\n",
-									ivideo->mode_no);
-			ret = -EINVAL;
-			iounmap(ivideo->mmio_vbase);
-			goto error_0;
-		}
-
-		outSISIDXREG(SISSR, IND_SIS_PASSWORD, SIS_PASSWORD);
-
-		sisfb_post_setmode(ivideo);
-
-		/* Maximize regardless of sisfb_max at startup */
-		ivideo->default_var.yres_virtual = 32767;
-
-		/* Force reset of x virtual in crtc_to_var */
-		ivideo->default_var.xres_virtual = 0;
-
-		/* Copy mode timing to var */
-		sisfb_crtc_to_var(ivideo, &ivideo->default_var);
-
-		/* Find out about screen pitch */
-		sisfb_calc_pitch(ivideo, &ivideo->default_var);
-		sisfb_set_pitch(ivideo);
-
-		/* Init the accelerator (does nothing currently) */
-		sisfb_initaccel(ivideo);
-
-		/* Init some fbinfo entries */
-		sis_fb_info->node  = -1;
-		sis_fb_info->flags = FBINFO_FLAG_DEFAULT;
-		sis_fb_info->fbops = &sisfb_ops;
-		sis_fb_info->disp  = &ivideo->sis_disp;
-		sis_fb_info->blank = &sisfb_blank;
-		sis_fb_info->switch_con = &sisfb_switch;
-		sis_fb_info->updatevar  = &sisfb_update_var;
-		sis_fb_info->changevar  = NULL;
-		strcpy(sis_fb_info->fontname, sisfb_fontname);
-
-		sisfb_set_disp(-1, &ivideo->default_var, sis_fb_info);
-
-#else		/* --------- For 2.6: Setup a somewhat sane default var ------------ */
-
 		printk(KERN_INFO "sisfb: Default mode is %dx%dx%d (%dHz)\n",
 			ivideo->video_width, ivideo->video_height, ivideo->video_bpp,
 			ivideo->refresh_rate);
@@ -6454,7 +6390,6 @@
 		sis_fb_info->pseudo_palette = ivideo->pseudo_palette;
 
 		fb_alloc_cmap(&sis_fb_info->cmap, 256 , 0);
-#endif		/* 2.6 */
 
 		printk(KERN_DEBUG "sisfb: Initial vbflags 0x%x\n", (int)ivideo->vbflags);
 
@@ -6564,10 +6499,10 @@
 	vfree(ivideo->bios_abase);
 
 	if(ivideo->lpcdev)
-		SIS_PCI_PUT_DEVICE(ivideo->lpcdev);
+		pci_dev_put(ivideo->lpcdev);
 
 	if(ivideo->nbridge)
-		SIS_PCI_PUT_DEVICE(ivideo->nbridge);
+		pci_dev_put(ivideo->nbridge);
 
 #ifdef CONFIG_MTRR
 	/* Release MTRR region */

