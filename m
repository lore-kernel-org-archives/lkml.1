Return-Path: <linux-kernel-owner+w=401wt.eu-S1756058AbZF1OMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbZF1OMm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 10:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755937AbZF1OM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 10:12:27 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:43467 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755999AbZF1OM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 10:12:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=bm+TTolXT7vcLt83pP+cjWI76NBpV4Vm84njRgpTPFlCA827suWnICwSV5ZOVXPAlX
         f/tDsGPeLv4r5V22S1fFWmYp1cy8ZG7C2xH7JjzzKrjarC0ZKBFFV9jDt7BdlmQbD0qx
         iGUJlR6wxu68gf86KOukX9N3pBNpbL++pAhT8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 28 Jun 2009 16:18:51 +0200
Message-Id: <20090628141851.8761.44640.sendpatchset@localhost.localdomain>
In-Reply-To: <20090628141844.8761.8943.sendpatchset@localhost.localdomain>
References: <20090628141844.8761.8943.sendpatchset@localhost.localdomain>
Subject: [PATCH 02/18] Staging: rtl8187se: remove CONFIG_RTL8180_PM ifdefs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rtl8187se: remove CONFIG_RTL8180_PM ifdefs

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rtl8187se/Makefile      |    1 -
 drivers/staging/rtl8187se/r8180_core.c  |    7 -------
 drivers/staging/rtl8187se/r8180_pm.c    |    2 --
 drivers/staging/rtl8187se/r8180_pm.h    |    2 --
 drivers/staging/rtl8187se/r8185b_init.c |    2 --
 5 files changed, 14 deletions(-)

Index: b/drivers/staging/rtl8187se/Makefile
===================================================================
--- a/drivers/staging/rtl8187se/Makefile
+++ b/drivers/staging/rtl8187se/Makefile
@@ -15,7 +15,6 @@ EXTRA_CFLAGS += -DTX_TRACK
 EXTRA_CFLAGS += -DHIGH_POWER
 EXTRA_CFLAGS += -DSW_DIG
 EXTRA_CFLAGS += -DRATE_ADAPT
-EXTRA_CFLAGS += -DCONFIG_RTL8180_PM
 
 #enable it for legacy power save, disable it for leisure  power save
 EXTRA_CFLAGS += -DENABLE_LPS
Index: b/drivers/staging/rtl8187se/r8180_core.c
===================================================================
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -74,9 +74,7 @@ double __extendsfdf2(float a) {return a;
 #include "r8180_wx.h"
 #include "r8180_dm.h"
 
-#ifdef CONFIG_RTL8180_PM
 #include "r8180_pm.h"
-#endif
 
 #include "ieee80211/dot11d.h"
 
@@ -199,13 +197,8 @@ static struct pci_driver rtl8180_pci_dri
 	.id_table	= rtl8180_pci_id_tbl,	          /* PCI_ID table  */
 	.probe		= rtl8180_pci_probe,	          /* probe fn      */
 	.remove		= __devexit_p(rtl8180_pci_remove),/* remove fn     */
-#ifdef CONFIG_RTL8180_PM
 	.suspend	= rtl8180_suspend,	          /* PM suspend fn */
 	.resume		= rtl8180_resume,                 /* PM resume fn  */
-#else
-	.suspend	= NULL,			          /* PM suspend fn */
-	.resume      	= NULL,			          /* PM resume fn  */
-#endif
 	.shutdown	= rtl8180_shutdown,
 };
 
Index: b/drivers/staging/rtl8187se/r8180_pm.c
===================================================================
--- a/drivers/staging/rtl8187se/r8180_pm.c
+++ b/drivers/staging/rtl8187se/r8180_pm.c
@@ -9,7 +9,6 @@
    Released under the terms of GPL (General Public Licence)
 */
 
-#ifdef CONFIG_RTL8180_PM
 
 
 #include "r8180_hw.h"
@@ -89,4 +88,3 @@ int rtl8180_enable_wake (struct pci_dev 
 
 
 
-#endif //CONFIG_RTL8180_PM
Index: b/drivers/staging/rtl8187se/r8180_pm.h
===================================================================
--- a/drivers/staging/rtl8187se/r8180_pm.h
+++ b/drivers/staging/rtl8187se/r8180_pm.h
@@ -10,7 +10,6 @@
 
 */
 
-#ifdef CONFIG_RTL8180_PM
 
 #ifndef R8180_PM_H
 #define R8180_PM_H
@@ -25,4 +24,3 @@ int rtl8180_enable_wake (struct pci_dev 
 
 #endif //R8180_PM_H
 
-#endif // CONFIG_RTL8180_PM
Index: b/drivers/staging/rtl8187se/r8185b_init.c
===================================================================
--- a/drivers/staging/rtl8187se/r8185b_init.c
+++ b/drivers/staging/rtl8187se/r8185b_init.c
@@ -30,9 +30,7 @@ Notes:
 #include "r8180_93cx6.h"   /* Card EEPROM */
 #include "r8180_wx.h"
 
-#ifdef CONFIG_RTL8180_PM
 #include "r8180_pm.h"
-#endif
 
 #include "ieee80211/dot11d.h"
 
