Return-Path: <linux-kernel-owner+w=401wt.eu-S1757304AbYGCVsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbYGCVsz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 17:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754463AbYGCVsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 17:48:46 -0400
Received: from mail.macqel.be ([194.78.208.39]:9900 "EHLO mail.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753779AbYGCVsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 17:48:46 -0400
Date: Thu, 3 Jul 2008 23:48:41 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] video/fb : cleanup FB_MAJOR usage
Message-ID: <20080703214841.GA8189@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, linux/major.h defines a GRAPHDEV_MAJOR (29) that nobody uses,
and linux/fb.h defines the real FB_MAJOR (also 29), that only fbmem.c needs.
Drop GRAPHDEV_MAJOR from major.h, move FB_MAJOR definition from fb.h to
major.h, and fix fbmem.c to use major.h's definition.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>

---
diff -r ced66ca0044f drivers/video/fbmem.c
--- a/drivers/video/fbmem.c	Mon Jun 30 08:58:09 2008 -0700
+++ b/drivers/video/fbmem.c	Thu Jul  3 23:31:57 2008 +0200
@@ -35,6 +35,7 @@
 #include <linux/device.h>
 #include <linux/efi.h>
 #include <linux/fb.h>
+#include <linux/major.h>
 
 #include <asm/fb.h>
 
diff -r ced66ca0044f include/linux/fb.h
--- a/include/linux/fb.h	Mon Jun 30 08:58:09 2008 -0700
+++ b/include/linux/fb.h	Thu Jul  3 23:31:57 2008 +0200
@@ -8,7 +8,6 @@ struct dentry;
 
 /* Definitions of frame buffers						*/
 
-#define FB_MAJOR		29
 #define FB_MAX			32	/* sufficient for now */
 
 /* ioctls
diff -r ced66ca0044f include/linux/major.h
--- a/include/linux/major.h	Mon Jun 30 08:58:09 2008 -0700
+++ b/include/linux/major.h	Thu Jul  3 23:31:57 2008 +0200
@@ -53,7 +53,7 @@
 #define STL_SIOMEMMAJOR		28
 #define ACSI_MAJOR		28
 #define AZTECH_CDROM_MAJOR	29
-#define GRAPHDEV_MAJOR		29   /* SparcLinux & Linux/68k /dev/fb */
+#define FB_MAJOR		29   /* /dev/fb* framebuffers */
 #define CM206_CDROM_MAJOR	32
 #define IDE2_MAJOR		33
 #define IDE3_MAJOR		34
