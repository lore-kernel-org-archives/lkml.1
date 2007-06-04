Return-Path: <linux-kernel-owner+w=401wt.eu-S1760690AbXFDWNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760690AbXFDWNK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 18:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760684AbXFDWMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 18:12:55 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:53824 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760699AbXFDWMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 18:12:54 -0400
Date: Tue, 5 Jun 2007 00:12:57 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Krzysztof Helt <krzysztof.h1@wp.pl>, Antonino Daplas <adaplas@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC: 2.6 patch] drivers/video/pm3fb.c: possible cleanups
Message-ID: <20070604221257.GD5500@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following possible cleanups:
- remove the empty pm3fb_setup() and corresponding code
- pm3fb_init() can become static

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/video/pm3fb.c |   31 +------------------------------
 1 file changed, 1 insertion(+), 30 deletions(-)

--- linux-2.6.22-rc3-mm1/drivers/video/pm3fb.c.old	2007-06-04 22:49:25.000000000 +0200
+++ linux-2.6.22-rc3-mm1/drivers/video/pm3fb.c	2007-06-04 22:52:54.000000000 +0200
@@ -380,8 +380,6 @@ static void pm3fb_write_mode(struct fb_i
 /*
  * hardware independent functions
  */
-int pm3fb_init(void);
-
 static int pm3fb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 {
 	u32 lpitch;
@@ -935,35 +933,8 @@ static struct pci_driver pm3fb_driver = 
 
 MODULE_DEVICE_TABLE(pci, pm3fb_id_table);
 
-#ifndef MODULE
-	/*
-	 *  Setup
-	 */
-
-/*
- * Only necessary if your driver takes special options,
- * otherwise we fall back on the generic fb_setup().
- */
-static int __init pm3fb_setup(char *options)
+static int __init pm3fb_init(void)
 {
-	/* Parse user speficied options (`video=pm3fb:') */
-	return 0;
-}
-#endif /* MODULE */
-
-int __init pm3fb_init(void)
-{
-	/*
-	 *  For kernel boot options (in 'video=pm3fb:<options>' format)
-	 */
-#ifndef MODULE
-	char *option = NULL;
-
-	if (fb_get_options("pm3fb", &option))
-		return -ENODEV;
-	pm3fb_setup(option);
-#endif
-
 	return pci_register_driver(&pm3fb_driver);
 }
 

