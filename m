Return-Path: <linux-kernel-owner+w=401wt.eu-S1755798AbXIQJbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798AbXIQJbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754887AbXIQJbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 05:31:18 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:25098 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754853AbXIQJbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 05:31:17 -0400
Date: Mon, 17 Sep 2007 04:31:07 -0500
To: linux-kernel@vger.kernel.org
Subject: Radeonfb Xpress 200M RC410 support patch
Message-ID: <20070917093107.GB5013@adam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
From: Sellout Bessie <sellout@beautyisfleeting.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, notthing special, and this is my first pqatch so forgive me if my method is off, however the following makes
radeonfb work ith the 200m Xpress RC410. In my tests it was terribly unstable and would freeze until I set a refresh rate in the kernel argument to 75.

e.g video=radeonfb:1280x800@75

Now it is rock solid.

Please CC me as well as I am not on the list...


diff -ur linux-2.6.22-vanilla/drivers/video/aty/ati_ids.h linux-2.6.22-vanilla.dev/drivers/video/aty/ati_ids.h
--- linux-2.6.22-suspend2-r1/drivers/video/aty/ati_ids.h        2007-07-08 23:32:17.000000000 +0000
+++ linux-2.6.22-suspend2-r1.dev/drivers/video/aty/ati_ids.h    2007-09-16 14:08:24.000000000 +0000
@@ -210,3 +210,4 @@
 #define PCI_CHIP_RS350_7834             0x7834
 #define PCI_CHIP_RS350_7835             0x7835
 #define PCI_CHIP_RS480_5955             0x5955
+#define PCI_CHIP_RC410_5A62             0x5A62
diff -ur linux-2.6.22-vanilla/drivers/video/aty/radeon_base.c linux-2.6.22-vanilla.dev/drivers/video/aty/radeon_base.c
--- linux-2.6.22-vanilla/drivers/video/aty/radeon_base.c        2007-07-08 23:32:17.000000000 +0000
+++ linux-2.6.22-vanilla.dev/drivers/video/aty/radeon_base.c    2007-09-16 14:05:50.000000000 +0000
@@ -102,6 +102,7 @@
 static struct pci_device_id radeonfb_pci_table[] = {
         /* Radeon Xpress 200m */
        CHIP_DEF(PCI_CHIP_RS480_5955,   RS480,  CHIP_HAS_CRTC2 | CHIP_IS_IGP | CHIP_IS_MOBILITY),
+       CHIP_DEF(PCI_CHIP_RC410_5A62,   RC410,  CHIP_HAS_CRTC2 | CHIP_IS_IGP | CHIP_IS_MOBILITY),
        /* Mobility M6 */
        CHIP_DEF(PCI_CHIP_RADEON_LY,    RV100,  CHIP_HAS_CRTC2 | CHIP_IS_MOBILITY),
        CHIP_DEF(PCI_CHIP_RADEON_LZ,    RV100,  CHIP_HAS_CRTC2 | CHIP_IS_MOBILITY),
@@ -1997,6 +1998,7 @@
         if ((rinfo->family == CHIP_FAMILY_RS100) ||
             (rinfo->family == CHIP_FAMILY_RS200) ||
             (rinfo->family == CHIP_FAMILY_RS300) ||
+            (rinfo->family == CHIP_FAMILY_RC410) ||
            (rinfo->family == CHIP_FAMILY_RS480) ) {
           u32 tom = INREG(NB_TOM);
           tmp = ((((tom >> 16) - (tom & 0xffff) + 1) << 6) * 1024);
diff -ur linux-2.6.22-vanilla/drivers/video/aty/radeonfb.h linux-2.6.22-vanilla.dev/drivers/video/aty/radeonfb.h
--- linux-2.6.22-vanilla/drivers/video/aty/radeonfb.h   2007-07-08 23:32:17.000000000 +0000
+++ linux-2.6.22-vanilla.dev/drivers/video/aty/radeonfb.h       2007-09-16 14:14:05.000000000 +0000
@@ -48,6 +48,7 @@
        CHIP_FAMILY_RV350,
        CHIP_FAMILY_RV380,    /* RV370/RV380/M22/M24 */
        CHIP_FAMILY_R420,     /* R420/R423/M18 */
+       CHIP_FAMILY_RC410,
        CHIP_FAMILY_RS480,
        CHIP_FAMILY_LAST,
 };
@@ -66,7 +67,8 @@
                                ((rinfo)->family == CHIP_FAMILY_R350)  || \
                                ((rinfo)->family == CHIP_FAMILY_RV380) || \
                                ((rinfo)->family == CHIP_FAMILY_R420)  || \
-                               ((rinfo)->family == CHIP_FAMILY_RS480) )
+                               ((rinfo)->family == CHIP_FAMILY_RC410) || \
+                               ((rinfo)->family == CHIP_FAMILY_RS480))

 /*
  * Chip flags


-- 
~Sellout Bessie
____________________________________________________
Website: http://beautyisfleeting.com
    IRC: sellout@irc.adullamirc.net:7777
  Gtalk: sellout@beautyisfleeting.com
ICQ/AIM: 172570138
  Yahoo: sellout172570138
    MSN: sellout@beautyisfleeting.com
____________________________________________________
PGP Key: http://beautyisfleeting.com/0xA0631FD6.asc
____________________________________________________
 hackerkey://v4sw6HPRU$hw6$ln8pr8FPS$ck7ma6u9L$w2m
 5l7Gi52e4t1b9LOen7a2XINs4Sr4p-5.63/0.21g5ACGOPRTZ
____________________________________________________
___________Registered Linux User #446190____________
____________________________________________________
