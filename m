Return-Path: <linux-kernel-owner+w=401wt.eu-S933186AbXAaMon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933186AbXAaMon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 07:44:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933200AbXAaMo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 07:44:28 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:41262 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933186AbXAaMoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 07:44:09 -0500
Date: Wed, 31 Jan 2007 13:44:07 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: James Simmons <jsimmons@infradead.org>
cc: Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/7] fbdev: move logo externs to header file
In-Reply-To: <Pine.LNX.4.62.0701311325480.14996@pademelon.sonytel.be>
Message-ID: <Pine.LNX.4.62.0701311339110.15066@pademelon.sonytel.be>
References: <Pine.LNX.4.62.0701311325480.14996@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move the external declarations for the various linux logo structures to
<linux/linux_logo.h>. As a consequence, I had to remove the `const', as `const'
is incompatible with `__initdata'.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 arch/powerpc/kernel/prom_init.c |    3 ---
 drivers/video/logo/logo.c       |   13 -------------
 include/linux/linux_logo.h      |   13 +++++++++++++
 3 files changed, 13 insertions(+), 16 deletions(-)

--- ps3-linux-2.6.20-rc7.orig/arch/powerpc/kernel/prom_init.c
+++ ps3-linux-2.6.20-rc7/arch/powerpc/kernel/prom_init.c
@@ -44,10 +44,7 @@
 #include <asm/sections.h>
 #include <asm/machdep.h>
 
-#ifdef CONFIG_LOGO_LINUX_CLUT224
 #include <linux/linux_logo.h>
-extern const struct linux_logo logo_linux_clut224;
-#endif
 
 /*
  * Properties whose value is longer than this get excluded from our
--- ps3-linux-2.6.20-rc7.orig/drivers/video/logo/logo.c
+++ ps3-linux-2.6.20-rc7/drivers/video/logo/logo.c
@@ -21,19 +21,6 @@
 #include <asm/bootinfo.h>
 #endif
 
-extern const struct linux_logo logo_linux_mono;
-extern const struct linux_logo logo_linux_vga16;
-extern const struct linux_logo logo_linux_clut224;
-extern const struct linux_logo logo_dec_clut224;
-extern const struct linux_logo logo_mac_clut224;
-extern const struct linux_logo logo_parisc_clut224;
-extern const struct linux_logo logo_sgi_clut224;
-extern const struct linux_logo logo_sun_clut224;
-extern const struct linux_logo logo_superh_mono;
-extern const struct linux_logo logo_superh_vga16;
-extern const struct linux_logo logo_superh_clut224;
-extern const struct linux_logo logo_m32r_clut224;
-
 
 const struct linux_logo *fb_find_logo(int depth)
 {
--- ps3-linux-2.6.20-rc7.orig/include/linux/linux_logo.h
+++ ps3-linux-2.6.20-rc7/include/linux/linux_logo.h
@@ -32,6 +32,19 @@ struct linux_logo {
 	const unsigned char *data;
 };
 
+extern struct linux_logo logo_linux_mono;
+extern struct linux_logo logo_linux_vga16;
+extern struct linux_logo logo_linux_clut224;
+extern struct linux_logo logo_dec_clut224;
+extern struct linux_logo logo_mac_clut224;
+extern struct linux_logo logo_parisc_clut224;
+extern struct linux_logo logo_sgi_clut224;
+extern struct linux_logo logo_sun_clut224;
+extern struct linux_logo logo_superh_mono;
+extern struct linux_logo logo_superh_vga16;
+extern struct linux_logo logo_superh_clut224;
+extern struct linux_logo logo_m32r_clut224;
+
 extern const struct linux_logo *fb_find_logo(int depth);
 
 #endif /* _LINUX_LINUX_LOGO_H */

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium
