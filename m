Return-Path: <linux-kernel-owner+w=401wt.eu-S1754949AbZEULqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949AbZEULqF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 07:46:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbZEULpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 07:45:54 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:50510 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbZEULpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 07:45:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=usYVIXfMQRQ+eKjN87T1GNd0SlRgwnxcVXBwi3Oyp5LZG1+PaxO+FJJ5JtfbECwqoS
         trIV0Mtky15KlYUqenP70v65acD5+VeqlMJE5PLfE6qvxNonTO6wtXFzwew7edBDTQbu
         mfIQBrhS/wPUKyUmGvTyWa8/e+6WN+GlkXahY=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH 1/2] Staging: cpc-usb: depends on PROC_FS
Date: Thu, 21 May 2009 15:44:45 +0400
Message-Id: <1242906286-7066-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this build error when PROC_FS is not enabled:
cpc-usb_drv.c:61:2: error: #error "PROCFS needed"
cpc-usb_drv.c:1159: error: implicit declaration of function 'proc_mkdir'

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/staging/cpc-usb/Kconfig       |    2 +-
 drivers/staging/cpc-usb/cpc-usb_drv.c |    8 +-------
 drivers/staging/cpc-usb/cpc_int.h     |    4 +---
 3 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/cpc-usb/Kconfig b/drivers/staging/cpc-usb/Kconfig
index 00924ce..2be0bc9 100644
--- a/drivers/staging/cpc-usb/Kconfig
+++ b/drivers/staging/cpc-usb/Kconfig
@@ -1,4 +1,4 @@
 config USB_CPC
 	tristate "CPC CAN USB driver"
-	depends on USB
+	depends on USB && PROC_FS
 	default n
diff --git a/drivers/staging/cpc-usb/cpc-usb_drv.c b/drivers/staging/cpc-usb/cpc-usb_drv.c
index 14aca39..d337a97 100644
--- a/drivers/staging/cpc-usb/cpc-usb_drv.c
+++ b/drivers/staging/cpc-usb/cpc-usb_drv.c
@@ -30,9 +30,7 @@
 
 #include <linux/version.h>
 
-#ifdef CONFIG_PROC_FS
-#   include <linux/proc_fs.h>
-#endif
+#include <linux/proc_fs.h>
 
 #include "cpc.h"
 
@@ -57,10 +55,6 @@ MODULE_LICENSE("GPL v2");
 #define USB_CPCUSB_M16C_PRODUCT_ID    0x0888
 #define USB_CPCUSB_LPC2119_PRODUCT_ID 0x0444
 
-#ifndef CONFIG_PROC_FS
-#error "PROCFS needed"
-#endif
-
 #define CPC_USB_PROC_DIR     CPC_PROC_DIR "cpc-usb"
 
 static struct proc_dir_entry *procDir;
diff --git a/drivers/staging/cpc-usb/cpc_int.h b/drivers/staging/cpc-usb/cpc_int.h
index dfdbed1..a0d60c0 100644
--- a/drivers/staging/cpc-usb/cpc_int.h
+++ b/drivers/staging/cpc-usb/cpc_int.h
@@ -15,9 +15,7 @@
 
 #define CPC_MSG_BUF_CNT	1500
 
-#ifdef CONFIG_PROC_FS
-#   define CPC_PROC_DIR "driver/"
-#endif
+#define CPC_PROC_DIR "driver/"
 
 #undef dbg
 #undef err
