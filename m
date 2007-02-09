Return-Path: <linux-kernel-owner+w=401wt.eu-S1946583AbXBIPjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946583AbXBIPjY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:39:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946573AbXBIPf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:35:29 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:2873 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946576AbXBIPfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:35:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=qeN64ecYl2FsM6LTsDGnsIZkcxYKvGpqf8MGWm5ZwocZQFAEX9WbAwBjDvwe2qTzlZnhftfLuem0VoWT0WkX5zlHTsW4sYEmcHpcEejf+2FxsH8bMuenx5usH8xl3xnjBCBOgiPY7s4QOdZpxeBuripwaCtJanleq22kFYaixNk=
From: Alon Bar-Lev <alon.barlev@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@osdl.org, bwalle@suse.de,
       rmk+lkml@arm.linux.org.uk
Subject: [PATCH 34/34] __initdata cleanup - video
Date: Fri, 9 Feb 2007 17:35:35 +0200
User-Agent: KMail/1.9.6
References: <200702091711.34441.alon.barlev@gmail.com>
In-Reply-To: <200702091711.34441.alon.barlev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702091735.36139.alon.barlev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Trivial.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Signed-off-by: Bernhard Walle <bwalle@suse.de>

---

diff -urNp linux-2.6.20-rc6-mm3.org/drivers/video/console/sticore.c linux-2.6.20-rc6-mm3/drivers/video/console/sticore.c
--- linux-2.6.20-rc6-mm3.org/drivers/video/console/sticore.c
+++ linux-2.6.20-rc6-mm3/drivers/video/console/sticore.c
@@ -289,9 +289,9 @@ __setup("sti=", sti_setup);
 
 
 static char __initdata	*font_name[MAX_STI_ROMS] = { "VGA8x16", };
-static int __initdata	font_index[MAX_STI_ROMS], 
-			font_height[MAX_STI_ROMS],
-			font_width[MAX_STI_ROMS];
+static int __initdata	font_index[MAX_STI_ROMS] = {0}, 
+			font_height[MAX_STI_ROMS] = {0},
+			font_width[MAX_STI_ROMS] = {0};
 #ifndef MODULE
 static int __init sti_font_setup(char *str)
 {
diff -urNp linux-2.6.20-rc6-mm3.org/drivers/video/skeletonfb.c linux-2.6.20-rc6-mm3/drivers/video/skeletonfb.c
--- linux-2.6.20-rc6-mm3.org/drivers/video/skeletonfb.c
+++ linux-2.6.20-rc6-mm3/drivers/video/skeletonfb.c
@@ -123,7 +123,7 @@ static struct fb_info info;
      * Each one represents the state of the hardware. Most hardware have
      * just one hardware state. These here represent the default state(s). 
      */
-static struct xxx_par __initdata current_par;
+static struct xxx_par __initdata current_par = {0};
 
 int xxxfb_init(void);
 int xxxfb_setup(char*);
diff -urNp linux-2.6.20-rc6-mm3.org/drivers/video/stifb.c linux-2.6.20-rc6-mm3/drivers/video/stifb.c
--- linux-2.6.20-rc6-mm3.org/drivers/video/stifb.c
+++ linux-2.6.20-rc6-mm3/drivers/video/stifb.c
@@ -111,7 +111,7 @@ struct stifb_info {
 	u32 pseudo_palette[16];
 };
 
-static int __initdata stifb_bpp_pref[MAX_STI_ROMS];
+static int __initdata stifb_bpp_pref[MAX_STI_ROMS] = {0};
 
 /* ------------------- chipset specific functions -------------------------- */
 
@@ -1298,7 +1298,7 @@ out_err0:
 	return -ENXIO;
 }
 
-static int stifb_disabled __initdata;
+static int stifb_disabled __initdata = 0;
 
 int __init
 stifb_setup(char *options);
diff -urNp linux-2.6.20-rc6-mm3.org/drivers/video/vesafb.c linux-2.6.20-rc6-mm3/drivers/video/vesafb.c
--- linux-2.6.20-rc6-mm3.org/drivers/video/vesafb.c
+++ linux-2.6.20-rc6-mm3/drivers/video/vesafb.c
@@ -49,8 +49,8 @@ static struct fb_fix_screeninfo vesafb_f
 
 static int   inverse    __read_mostly;
 static int   mtrr       __read_mostly;		/* disable mtrr */
-static int   vram_remap __initdata;		/* Set amount of memory to be used */
-static int   vram_total __initdata;		/* Set total amount of memory */
+static int   vram_remap __initdata = 0;		/* Set amount of memory to be used */
+static int   vram_total __initdata = 0;		/* Set total amount of memory */
 static int   pmi_setpal __read_mostly = 1;	/* pmi for palette changes ??? */
 static int   ypan       __read_mostly;		/* 0..nothing, 1..ypan, 2..ywrap */
 static void  (*pmi_start)(void) __read_mostly;
