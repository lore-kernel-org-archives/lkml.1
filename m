Return-Path: <linux-kernel-owner+w=401wt.eu-S1756377AbZEVQ2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377AbZEVQ2X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 12:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbZEVQ2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 12:28:15 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:42318 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbZEVQ2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 12:28:14 -0400
Message-ID: <4A16D325.4030202@oracle.com>
Date: Fri, 22 May 2009 09:30:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Sebastian Haas <haas@ems-wuensche.com>
Subject: [PATCH -next] cpc-usb: fix PROC_FS dependency
References: <20090522185110.3f95b03e.sfr@canb.auug.org.au>
In-Reply-To: <20090522185110.3f95b03e.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt007.oracle.com [141.146.116.16]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010208.4A16D28D.006B:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

The proper way to check for and enforce a kconfig symbol
dependency is via Kconfig files, not by using #error in
a source file followed by 9 other compile errors.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Sebastian Haas <haas@ems-wuensche.com>
---
 drivers/staging/cpc-usb/Kconfig       |    2 +-
 drivers/staging/cpc-usb/cpc-usb_drv.c |   10 +---------
 2 files changed, 2 insertions(+), 10 deletions(-)

--- linux-next-20090522.orig/drivers/staging/cpc-usb/cpc-usb_drv.c
+++ linux-next-20090522/drivers/staging/cpc-usb/cpc-usb_drv.c
@@ -27,12 +27,8 @@
 #include <linux/completion.h>
 #include <asm/uaccess.h>
 #include <linux/usb.h>
-
 #include <linux/version.h>
-
-#ifdef CONFIG_PROC_FS
-#   include <linux/proc_fs.h>
-#endif
+#include <linux/proc_fs.h>
 
 #include "cpc.h"
 
@@ -57,10 +53,6 @@ MODULE_LICENSE("GPL v2");
 #define USB_CPCUSB_M16C_PRODUCT_ID    0x0888
 #define USB_CPCUSB_LPC2119_PRODUCT_ID 0x0444
 
-#ifndef CONFIG_PROC_FS
-#error "PROCFS needed"
-#endif
-
 #define CPC_USB_PROC_DIR     CPC_PROC_DIR "cpc-usb"
 
 static struct proc_dir_entry *procDir;
--- linux-next-20090522.orig/drivers/staging/cpc-usb/Kconfig
+++ linux-next-20090522/drivers/staging/cpc-usb/Kconfig
@@ -1,4 +1,4 @@
 config USB_CPC
 	tristate "CPC CAN USB driver"
-	depends on USB
+	depends on USB && PROC_FS
 	default n



-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
