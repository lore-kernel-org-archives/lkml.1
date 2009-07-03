Return-Path: <linux-kernel-owner+w=401wt.eu-S1756484AbZGCN7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484AbZGCN7z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 09:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757159AbZGCN7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 09:59:38 -0400
Received: from mail-bw0-f207.google.com ([209.85.218.207]:49731 "EHLO
	mail-bw0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756817AbZGCN7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 09:59:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=plbn8nfkjYzbosrZm20ugCVxHiyTq7syLJjdAhlz09d/sDjmcfqT69kyW+oIvEdVWN
         4saC0ZkQGXMxPYdXMGlx8b+zptRzS7YYwi345JB3oq7ALwLoki0dNNkiMC6EfhB2ndsl
         6w3divRqee+R61D82BtghwdntdmdxN1cwaY9k=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 03 Jul 2009 16:06:11 +0200
Message-Id: <20090703140611.7303.45808.sendpatchset@localhost.localdomain>
In-Reply-To: <20090703140605.7303.54416.sendpatchset@localhost.localdomain>
References: <20090703140605.7303.54416.sendpatchset@localhost.localdomain>
Subject: [PATCH 02/22] Staging: rtl8192su: remove CONFIG_RTL8192_PM ifdefs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH staging] Staging: rtl8192su: remove CONFIG_RTL8192_PM ifdefs

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rtl8192su/Makefile      |    1 -
 drivers/staging/rtl8192su/r8192U_core.c |   10 ----------
 drivers/staging/rtl8192su/r8192U_pm.c   |    2 --
 drivers/staging/rtl8192su/r8192U_pm.h   |    2 --
 4 files changed, 15 deletions(-)

Index: b/drivers/staging/rtl8192su/Makefile
===================================================================
--- a/drivers/staging/rtl8192su/Makefile
+++ b/drivers/staging/rtl8192su/Makefile
@@ -27,7 +27,6 @@ EXTRA_CFLAGS += -DRTL8192SU_ASIC_VERIFIC
 EXTRA_CFLAGS += -DRTL8192SU_USB_PHY_TEST=0
 
 #EXTRA_CFLAGS += -DMUTIPLE_BULK_OUT
-EXTRA_CFLAGS += -DCONFIG_RTL8192_PM
 
 r8192s_usb-objs :=		\
 	r8180_93cx6.o		\
Index: b/drivers/staging/rtl8192su/r8192U_core.c
===================================================================
--- a/drivers/staging/rtl8192su/r8192U_core.c
+++ b/drivers/staging/rtl8192su/r8192U_core.c
@@ -76,9 +76,7 @@ double __extendsfdf2(float a) {return a;
 //#include "r8192xU_phyreg.h"
 #include <linux/usb.h>
 
-#ifdef CONFIG_RTL8192_PM
 #include "r8192U_pm.h"
-#endif
 
 #include "ieee80211/dot11d.h"
 
@@ -97,9 +95,7 @@ double __extendsfdf2(float a) {return a;
 //#include "r8192xU_phyreg.h"
 #include <linux/usb.h>
 
-#ifdef CONFIG_RTL8192_PM
 #include "r8192U_pm.h"
-#endif
 
 #include "ieee80211/dot11d.h"
 
@@ -222,15 +218,9 @@ static struct usb_driver rtl8192_usb_dri
 	.id_table	= rtl8192_usb_id_tbl,	          /* PCI_ID table  */
 	.probe		= rtl8192_usb_probe,	          /* probe fn      */
 	.disconnect	= rtl8192_usb_disconnect,	  /* remove fn     */
-#ifdef CONFIG_RTL8192_PM
 	.suspend	= rtl8192U_suspend,	          /* PM suspend fn */
 	.resume		= rtl8192U_resume,                 /* PM resume fn  */
 	.reset_resume   = rtl8192U_resume,                 /* PM reset resume fn  */
-#else
-	.suspend	= NULL,			          /* PM suspend fn */
-	.resume      	= NULL,			          /* PM resume fn  */
-	.reset_resume   = NULL,                 /* PM reset resume fn  */
-#endif
 };
 
 
Index: b/drivers/staging/rtl8192su/r8192U_pm.c
===================================================================
--- a/drivers/staging/rtl8192su/r8192U_pm.c
+++ b/drivers/staging/rtl8192su/r8192U_pm.c
@@ -9,7 +9,6 @@
    Released under the terms of GPL (General Public Licence)
 */
 
-#ifdef CONFIG_RTL8192_PM
 #include "r8192U.h"
 #include "r8192U_pm.h"
 
@@ -71,4 +70,3 @@ int rtl8192U_enable_wake (struct pci_dev
 	return(-EAGAIN);
 }
 
-#endif //CONFIG_RTL8192_PM
Index: b/drivers/staging/rtl8192su/r8192U_pm.h
===================================================================
--- a/drivers/staging/rtl8192su/r8192U_pm.h
+++ b/drivers/staging/rtl8192su/r8192U_pm.h
@@ -10,7 +10,6 @@
 
 */
 
-#ifdef CONFIG_RTL8192_PM
 
 #ifndef R8192_PM_H
 #define R8192_PM_H
@@ -24,4 +23,3 @@ int rtl8192U_resume (struct usb_interfac
 int rtl8192U_enable_wake (struct pci_dev *dev, u32 state, int enable);
 
 #endif //R8192U_PM_H
-#endif // CONFIG_RTL8192_PM
