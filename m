Return-Path: <linux-kernel-owner+w=401wt.eu-S1756215AbZBWWvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215AbZBWWvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 17:51:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753890AbZBWWug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 17:50:36 -0500
Received: from mail-fx0-f167.google.com ([209.85.220.167]:34396 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982AbZBWWua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 17:50:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=Ol6LaTGImMdhbWZAFOhITlsbpswTmNUqK+zr8d4YOQY01TMwZgX8cHZ+oFAGHEQU1K
         glh4Rf2z2YrZz+ZeknzwHIhUDib6qC46YPXt4jBiDCNrqcGnkVF5qdm3QlpHBYKhvsnA
         PD07gEYeYOvwdkw9WJ9spcYlRifTzdu4xLT/0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide: remove CONFIG_BLK_DEV_IDEDOUBLER config option
Date: Mon, 23 Feb 2009 23:50:39 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-next-20090220-dirty; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902232350.39412.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: remove CONFIG_BLK_DEV_IDEDOUBLER config option

Nowadays it is not worth having a separate config option for
Amiga IDE Doubler support so always include it (it still needs
to be explicitly enabled by module parameter).

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Kconfig |   23 ++++++++---------------
 drivers/ide/gayle.c |   12 +-----------
 2 files changed, 9 insertions(+), 26 deletions(-)

Index: b/drivers/ide/Kconfig
===================================================================
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -765,27 +765,20 @@ config BLK_DEV_GAYLE
 	  This includes on-board IDE interfaces on some Amiga models (A600,
 	  A1200, A4000, and A4000T), and IDE interfaces on the Zorro expansion
 	  bus (M-Tech E-Matrix 530 expansion card).
-	  Say Y if you have an Amiga with a Gayle IDE interface and want to use
-	  IDE devices (hard disks, CD-ROM drives, etc.) that are connected to
-	  it.
-	  Note that you also have to enable Zorro bus support if you want to
-	  use Gayle IDE interfaces on the Zorro expansion bus.
 
-config BLK_DEV_IDEDOUBLER
-	bool "Amiga IDE Doubler support (EXPERIMENTAL)"
-	depends on BLK_DEV_GAYLE && EXPERIMENTAL
-	---help---
-	  This feature provides support for the so-called `IDE doublers' (made
+	  It also provides support for the so-called `IDE doublers' (made
 	  by various manufacturers, e.g. Eyetech) that can be connected to
 	  the on-board IDE interface of some Amiga models. Using such an IDE
 	  doubler, you can connect up to four instead of two IDE devices to
-	  the Amiga's on-board IDE interface.
+	  the Amiga's on-board IDE interface. The feature is enabled at kernel
+	  runtime using the "gayle.doubler" kernel boot parameter.
 
-	  Note that the normal Amiga Gayle IDE driver may not work correctly
-	  if you have an IDE doubler and don't enable this feature!
+	  Say Y if you have an Amiga with a Gayle IDE interface and want to use
+	  IDE devices (hard disks, CD-ROM drives, etc.) that are connected to
+	  it.
 
-	  Say Y if you have an IDE doubler.  The feature is enabled at kernel
-	  runtime using the "gayle.doubler" kernel boot parameter.
+	  Note that you also have to enable Zorro bus support if you want to
+	  use Gayle IDE interfaces on the Zorro expansion bus.
 
 config BLK_DEV_BUDDHA
 	tristate "Buddha/Catweasel/X-Surf IDE interface support (EXPERIMENTAL)"
Index: b/drivers/ide/gayle.c
===================================================================
--- a/drivers/ide/gayle.c
+++ b/drivers/ide/gayle.c
@@ -53,11 +53,6 @@
 
 #define GAYLE_NEXT_PORT	0x1000
 
-#ifndef CONFIG_BLK_DEV_IDEDOUBLER
-#define GAYLE_NUM_HWIFS		1
-#define GAYLE_NUM_PROBE_HWIFS	GAYLE_NUM_HWIFS
-#define GAYLE_HAS_CONTROL_REG	1
-#else /* CONFIG_BLK_DEV_IDEDOUBLER */
 #define GAYLE_NUM_HWIFS		2
 #define GAYLE_NUM_PROBE_HWIFS	(ide_doubler ? GAYLE_NUM_HWIFS : \
 					       GAYLE_NUM_HWIFS-1)
@@ -66,8 +61,6 @@
 static int ide_doubler;
 module_param_named(doubler, ide_doubler, bool, 0);
 MODULE_PARM_DESC(doubler, "enable support for IDE doublers");
-#endif /* CONFIG_BLK_DEV_IDEDOUBLER */
-
 
     /*
      *  Check and acknowledge the interrupt status
@@ -151,10 +144,7 @@ static int __init gayle_init(void)
 found:
 	printk(KERN_INFO "ide: Gayle IDE controller (A%d style%s)\n",
 			 a4000 ? 4000 : 1200,
-#ifdef CONFIG_BLK_DEV_IDEDOUBLER
-			 ide_doubler ? ", IDE doubler" :
-#endif
-			 "");
+			 ide_doubler ? ", IDE doubler" : "");
 
 	if (a4000) {
 	    phys_base = GAYLE_BASE_4000;
