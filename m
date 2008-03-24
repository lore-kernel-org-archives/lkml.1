Return-Path: <linux-kernel-owner+w=401wt.eu-S1763008AbYCXSiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763008AbYCXSiw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 14:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761559AbYCXSi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 14:38:29 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:36760 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761256AbYCXSi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 14:38:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=rptINZo1EEsiyx6E+QPGMIALqJ+BfH0btcqsG4BybXQciJUxGD6S/MiiMN6aiX1SwWmGCELW2dF0qVSOQLJrnlK8LQ0UghQG5WmRSNy9xb9IYd9YxJaTpa4OSZs7tDcdWNo3CKveySdUZGH2Ydz5hiVUatjsJthx9DzmVmgayC4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 24 Mar 2008 19:53:30 +0100
Message-Id: <20080324185330.15320.19056.sendpatchset@localhost.localdomain>
In-Reply-To: <20080324185324.15320.23248.sendpatchset@localhost.localdomain>
References: <20080324185324.15320.23248.sendpatchset@localhost.localdomain>
Subject: [PATCH 2/5] ide: sanitize ide_unregister() usage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Remove ide_unregister() call from ide_exit()
  (host drivers take care of unregistering hwif-s themselves).

* Remove ide_unregister() call from probe methods of
  bast-ide, palm_bk3710, ide-cs and delkin_cb host drivers
  (ide_find_port() returns only free ide_hwifs[] entries).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/bast-ide.c    |    6 +-----
 drivers/ide/arm/palm_bk3710.c |    6 +-----
 drivers/ide/ide.c             |    5 -----
 drivers/ide/legacy/ide-cs.c   |    6 +-----
 drivers/ide/pci/delkin_cb.c   |    6 +-----
 5 files changed, 4 insertions(+), 25 deletions(-)

Index: b/drivers/ide/arm/bast-ide.c
===================================================================
--- a/drivers/ide/arm/bast-ide.c
+++ b/drivers/ide/arm/bast-ide.c
@@ -49,11 +49,7 @@ static int __init bastide_register(unsig
 
 	i = hwif->index;
 
-	if (hwif->present)
-		ide_unregister(i);
-	else
-		ide_init_port_data(hwif, i);
-
+	ide_init_port_data(hwif, i);
 	ide_init_port_hw(hwif, &hw);
 	hwif->port_ops = NULL;
 
Index: b/drivers/ide/arm/palm_bk3710.c
===================================================================
--- a/drivers/ide/arm/palm_bk3710.c
+++ b/drivers/ide/arm/palm_bk3710.c
@@ -398,11 +398,7 @@ static int __devinit palm_bk3710_probe(s
 
 	i = hwif->index;
 
-	if (hwif->present)
-		ide_unregister(i);
-	else
-		ide_init_port_data(hwif, i);
-
+	ide_init_port_data(hwif, i);
 	ide_init_port_hw(hwif, &hw);
 
 	hwif->mmio = 1;
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -1041,11 +1041,6 @@ out_port_class:
 
 static void __exit ide_exit(void)
 {
-	int index;
-
-	for (index = 0; index < MAX_HWIFS; ++index)
-		ide_unregister(index);
-
 	proc_ide_destroy();
 
 	class_destroy(ide_port_class);
Index: b/drivers/ide/legacy/ide-cs.c
===================================================================
--- a/drivers/ide/legacy/ide-cs.c
+++ b/drivers/ide/legacy/ide-cs.c
@@ -183,11 +183,7 @@ static ide_hwif_t *idecs_register(unsign
 
     i = hwif->index;
 
-    if (hwif->present)
-	ide_unregister(i);
-    else
-	ide_init_port_data(hwif, i);
-
+    ide_init_port_data(hwif, i);
     ide_init_port_hw(hwif, &hw);
     hwif->port_ops = &idecs_port_ops;
 
Index: b/drivers/ide/pci/delkin_cb.c
===================================================================
--- a/drivers/ide/pci/delkin_cb.c
+++ b/drivers/ide/pci/delkin_cb.c
@@ -87,11 +87,7 @@ delkin_cb_probe (struct pci_dev *dev, co
 
 	i = hwif->index;
 
-	if (hwif->present)
-		ide_unregister(i);
-	else
-		ide_init_port_data(hwif, i);
-
+	ide_init_port_data(hwif, i);
 	ide_init_port_hw(hwif, &hw);
 	hwif->port_ops = &delkin_cb_port_ops;
 
