Return-Path: <linux-kernel-owner+w=401wt.eu-S1757753AbXFSWPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757753AbXFSWPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 18:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbXFSWP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 18:15:27 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:35423 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046AbXFSWP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 18:15:26 -0400
Date: Wed, 20 Jun 2007 00:15:28 +0200
From: Olaf Hering <olaf@aepfle.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] fix section mismatch in chipsfb
Message-ID: <20070619221528.GA22413@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maybe this is the correct fix:

WARNING: drivers/built-in.o(.text+0x8742a): Section mismatch: reference to .init.data:chipsfb_fix (between 'chipsfb_pci_init' and 'chipsfb_set_par')
WARNING: drivers/built-in.o(.text+0x87432): Section mismatch: reference to .init.data:chipsfb_fix (between 'chipsfb_pci_init' and 'chipsfb_set_par')
WARNING: drivers/built-in.o(.text+0x87442): Section mismatch: reference to .init.data:chipsfb_var (between 'chipsfb_pci_init' and 'chipsfb_set_par')
WARNING: drivers/built-in.o(.text+0x8744a): Section mismatch: reference to .init.data:chipsfb_var (between 'chipsfb_pci_init' and 'chipsfb_set_par')

init_chips is only called from chipsfb_pci_init
chipsfb_fix and chipsfb_var are only referenced from init_chips

Signed-off-by: Olaf Hering <olaf@aepfle.de>

--- a/drivers/video/chipsfb.c
+++ b/drivers/video/chipsfb.c
@@ -292,7 +292,7 @@ static void __init chips_hw_init(void)
 		write_fr(chips_init_fr[i].addr, chips_init_fr[i].data);
 }
 
-static struct fb_fix_screeninfo chipsfb_fix __initdata = {
+static struct fb_fix_screeninfo chipsfb_fix __devinitdata = {
 	.id =		"C&T 65550",
 	.type =		FB_TYPE_PACKED_PIXELS,
 	.visual =	FB_VISUAL_PSEUDOCOLOR,
@@ -309,7 +309,7 @@ static struct fb_fix_screeninfo chipsfb_
 	.smem_len =	0x100000,	/* 1MB */
 };
 
-static struct fb_var_screeninfo chipsfb_var __initdata = {
+static struct fb_var_screeninfo chipsfb_var __devinitdata = {
 	.xres = 800,
 	.yres = 600,
 	.xres_virtual = 800,
@@ -330,7 +330,7 @@ static struct fb_var_screeninfo chipsfb_
 	.vsync_len = 8,
 };
 
-static void __init init_chips(struct fb_info *p, unsigned long addr)
+static void __devinit init_chips(struct fb_info *p, unsigned long addr)
 {
 	memset(p->screen_base, 0, 0x100000);
 
