Return-Path: <linux-kernel-owner+w=401wt.eu-S1751045Ab0A2QE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751045Ab0A2QE4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:04:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554Ab0A2QEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:04:52 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:8213 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966Ab0A2QEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:04:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Dgqnb7igMZNn2byPfjfOUqCjaG0TkztUWTdNplI7CFPrnk5ff2NZCyRx8TahsrGwBi
         XLOYBrq7LXs5CTkp/9e8NwcMlcPccP+jOGkmvvCMvBY9kbdo+zkTqYrqsymKan8Quyk4
         QvnjBbLlbH8UaBlSsxtU0CIlQ+2/VeZHn/HT0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:04:40 +0100
Message-Id: <20100129160440.21495.4832.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 14/68] pata_sis: move short cable handling to pata_sis.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_sis: move short cable handling to pata_sis.h

It is a generic code and can be shared between pata_sis & sis5513 drivers.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_sis.c |   30 +-----------------------------
 drivers/ata/pata_sis.h |   30 ++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 29 deletions(-)

Index: b/drivers/ata/pata_sis.c
===================================================================
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -45,35 +45,7 @@ struct sis_chipset {
 	   up code later */
 };
 
-struct sis_laptop {
-	u16 device;
-	u16 subvendor;
-	u16 subdevice;
-};
-
-static const struct sis_laptop sis_laptop[] = {
-	/* devid, subvendor, subdev */
-	{ 0x5513, 0x1043, 0x1107 },	/* ASUS A6K */
-	{ 0x5513, 0x1734, 0x105F },	/* FSC Amilo A1630 */
-	{ 0x5513, 0x1071, 0x8640 },     /* EasyNote K5305 */
-	/* end marker */
-	{ 0, }
-};
-
-static int sis_short_ata40(struct pci_dev *dev)
-{
-	const struct sis_laptop *lap = &sis_laptop[0];
-
-	while (lap->device) {
-		if (lap->device == dev->device &&
-		    lap->subvendor == dev->subsystem_vendor &&
-		    lap->subdevice == dev->subsystem_device)
-			return 1;
-		lap++;
-	}
-
-	return 0;
-}
+#include "pata_sis.h"
 
 /**
  *	sis_old_port_base		-	return PCI configuration base for dev
Index: b/drivers/ata/pata_sis.h
===================================================================
--- /dev/null
+++ b/drivers/ata/pata_sis.h
@@ -0,0 +1,30 @@
+
+struct sis_laptop {
+	u16 device;
+	u16 subvendor;
+	u16 subdevice;
+};
+
+static const struct sis_laptop sis_laptop[] = {
+	/* devid, subvendor, subdev */
+	{ 0x5513, 0x1043, 0x1107 },	/* ASUS A6K */
+	{ 0x5513, 0x1734, 0x105F },	/* FSC Amilo A1630 */
+	{ 0x5513, 0x1071, 0x8640 },     /* EasyNote K5305 */
+	/* end marker */
+	{ 0, }
+};
+
+static int sis_short_ata40(struct pci_dev *dev)
+{
+	const struct sis_laptop *lap = &sis_laptop[0];
+
+	while (lap->device) {
+		if (lap->device == dev->device &&
+		    lap->subvendor == dev->subsystem_vendor &&
+		    lap->subdevice == dev->subsystem_device)
+			return 1;
+		lap++;
+	}
+
+	return 0;
+}
