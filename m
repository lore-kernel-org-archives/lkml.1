Return-Path: <linux-kernel-owner+w=401wt.eu-S932555AbZKDRiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555AbZKDRiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:38:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932509AbZKDRhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:37:18 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:7702 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932372AbZKDRhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:37:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=QBa/W8buE2dCHs7CDsCZO90v6t/RlawxIULsEyuH3vkZj6I5hK+l7eZMCOzuCQEEp4
         EKI+ORjgKRzzTDIvWE5jkwPmRhu+Cnws/mSW/6f0C+8uRLJAtdT39Bxf5xKaHtAyh3cQ
         zU7Mqa4hHIMmAm/KyG11IfYK1HWNq06allDGQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 04 Nov 2009 18:36:50 +0100
Message-Id: <20091104173650.28463.23162.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
Subject: [PATCH 39/41] rt2x00: move REGISTER_BUSY_* definitions to rt2x00.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] rt2x00: move REGISTER_BUSY_* definitions to rt2x00.h

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h    |    9 +++++++++
 drivers/net/wireless/rt2x00/rt2x00pci.h |    9 ---------
 drivers/net/wireless/rt2x00/rt2x00usb.h |    6 ------
 3 files changed, 9 insertions(+), 15 deletions(-)

Index: b/drivers/net/wireless/rt2x00/rt2x00.h
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -857,6 +857,15 @@ struct rt2x00_dev {
 };
 
 /*
+ * Register defines.
+ * Some registers require multiple attempts before success,
+ * in those cases REGISTER_BUSY_COUNT attempts should be
+ * taken with a REGISTER_BUSY_DELAY interval.
+ */
+#define REGISTER_BUSY_COUNT	5
+#define REGISTER_BUSY_DELAY	100
+
+/*
  * Generic RF access.
  * The RF is being accessed by word index.
  */
Index: b/drivers/net/wireless/rt2x00/rt2x00pci.h
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2x00pci.h
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.h
@@ -35,15 +35,6 @@
 #define PCI_DEVICE_DATA(__ops)	.driver_data = (kernel_ulong_t)(__ops)
 
 /*
- * Register defines.
- * Some registers require multiple attempts before success,
- * in those cases REGISTER_BUSY_COUNT attempts should be
- * taken with a REGISTER_BUSY_DELAY interval.
- */
-#define REGISTER_BUSY_COUNT	5
-#define REGISTER_BUSY_DELAY	100
-
-/*
  * Register access.
  */
 static inline void rt2x00pci_register_read(struct rt2x00_dev *rt2x00dev,
Index: b/drivers/net/wireless/rt2x00/rt2x00usb.h
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
@@ -39,17 +39,11 @@
 #define USB_DEVICE_DATA(__ops)	.driver_info = (kernel_ulong_t)(__ops)
 
 /*
- * Register defines.
- * Some registers require multiple attempts before success,
- * in those cases REGISTER_BUSY_COUNT attempts should be
- * taken with a REGISTER_BUSY_DELAY interval.
  * For USB vendor requests we need to pass a timeout
  * time in ms, for this we use the REGISTER_TIMEOUT,
  * however when loading firmware a higher value is
  * required. In that case we use the REGISTER_TIMEOUT_FIRMWARE.
  */
-#define REGISTER_BUSY_COUNT		5
-#define REGISTER_BUSY_DELAY		100
 #define REGISTER_TIMEOUT		500
 #define REGISTER_TIMEOUT_FIRMWARE	1000
 
