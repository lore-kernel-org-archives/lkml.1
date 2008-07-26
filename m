Return-Path: <linux-kernel-owner+w=401wt.eu-S1756627AbYGZNoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627AbYGZNoA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 09:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbYGZNmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 09:42:43 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:35107 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833AbYGZNml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 09:42:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=TfGsDZ0rOKJGo2lJxHIszAtJT0d91vdyAkO0HBLA2b4/8NSfhrtOPTfyvLKeehBZqx
         2+TDlhjHRHKjM1HmWdJ1jQ9qPZ5vLlXjQaJZCqaF/JLwgigyoOrIZenpFv/n3i7jDNU4
         82aNJmIz0P5Di59R6vccR0DrJk/FII+beK9W0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 26 Jul 2008 15:40:37 +0200
Message-Id: <20080726134037.10589.58019.sendpatchset@localhost.localdomain>
In-Reply-To: <20080726134010.10589.51679.sendpatchset@localhost.localdomain>
References: <20080726134010.10589.51679.sendpatchset@localhost.localdomain>
Subject: [PATCH 05/10] ide: remove IDE_CHIPSET_* macros
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They just obfuscate the code.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |    3 ++-
 include/linux/ide.h     |    4 ----
 2 files changed, 2 insertions(+), 5 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1105,7 +1105,8 @@ static int init_irq (ide_hwif_t *hwif)
 		sa = IRQF_SHARED;
 #endif /* __mc68000__ */
 
-		if (IDE_CHIPSET_IS_PCI(hwif->chipset))
+		if (hwif->chipset == ide_pci || hwif->chipset == ide_cmd646 ||
+		    hwif->chipset == ide_ali14xx)
 			sa = IRQF_SHARED;
 
 		if (io_ports->ctl_addr)
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -482,10 +482,6 @@ typedef struct ide_drive_s ide_drive_t;
 
 #define to_ide_device(dev)container_of(dev, ide_drive_t, gendev)
 
-#define IDE_CHIPSET_PCI_MASK	\
-    ((1<<ide_pci)|(1<<ide_cmd646)|(1<<ide_ali14xx))
-#define IDE_CHIPSET_IS_PCI(c)	((IDE_CHIPSET_PCI_MASK >> (c)) & 1)
-
 struct ide_task_s;
 struct ide_port_info;
 
