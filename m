Return-Path: <linux-kernel-owner+w=401wt.eu-S1755999AbZICQiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbZICQiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 12:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755926AbZICQiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 12:38:18 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:64399 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755910AbZICQiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 12:38:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=IBRshuDzxz758trpyPPCPNQ1IvNXnYF+ohte/h4V5slWwo6sUMvetyLfV2zTB2Krg3
         4/Rc5/A5Fr3lnid5GxanO0cUcKSU0ANierXYaFv4BnmMsMPzP25PKdukDt7vbprbaofM
         IAybMewLx9bD40dKGlNydye156lb5AHawQqlE=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH] Staging: vt665x: fix built-in compiling
Date: Thu,  3 Sep 2009 20:38:14 +0400
Message-Id: <1251995894-29585-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this build error:
undefined reference to "__this_module"

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/staging/vt6655/Makefile |    2 +-
 drivers/staging/vt6655/device.h |    6 ------
 drivers/staging/vt6656/Makefile |    2 +-
 drivers/staging/vt6656/device.h |    6 ------
 4 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/vt6655/Makefile b/drivers/staging/vt6655/Makefile
index 260c81d..7c7ee6b 100644
--- a/drivers/staging/vt6655/Makefile
+++ b/drivers/staging/vt6655/Makefile
@@ -1,5 +1,5 @@
 # TODO: all of these should be removed
-EXTRA_CFLAGS += -DLINUX -D__KERNEL__ -DMODULE -D__NO_VERSION__
+EXTRA_CFLAGS += -DLINUX -D__KERNEL__ -D__NO_VERSION__
 EXTRA_CFLAGS += -DHOSTAP
 
 vt6655-y +=	device_main.o \
diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index 54869c9..fa7f0fc 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -29,13 +29,7 @@
 #ifndef __DEVICE_H__
 #define __DEVICE_H__
 
-#ifdef MODULE
-#ifdef MODVERSIONS
-#include <linux/modversions.h>
-#endif /* MODVERSIONS */
 #include <linux/module.h>
-#endif /* MODULE */
-
 #include <linux/types.h>
 #include <linux/init.h>
 #include <linux/mm.h>
diff --git a/drivers/staging/vt6656/Makefile b/drivers/staging/vt6656/Makefile
index 4467bb1..10f7a28 100644
--- a/drivers/staging/vt6656/Makefile
+++ b/drivers/staging/vt6656/Makefile
@@ -1,5 +1,5 @@
 # TODO: all of these should be removed
-EXTRA_CFLAGS += -DLINUX -D__KERNEL__ -DMODULE  -DEXPORT_SYMTAB -D__NO_VERSION__
+EXTRA_CFLAGS += -DLINUX -D__KERNEL__ -DEXPORT_SYMTAB -D__NO_VERSION__
 EXTRA_CFLAGS += -DHOSTAP
 
 vt6656-y +=	main_usb.o \
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 33df6e5..b02ca2d 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -29,13 +29,7 @@
 #ifndef __DEVICE_H__
 #define __DEVICE_H__
 
-#ifdef MODULE
-#ifdef MODVERSIONS
-#include <linux/modversions.h>
-#endif /* MODVERSIONS */
 #include <linux/module.h>
-#endif /* MODULE */
-
 #include <linux/types.h>
 #include <linux/init.h>
 #include <linux/mm.h>
-- 
1.6.4.1

