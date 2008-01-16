Return-Path: <linux-kernel-owner+w=401wt.eu-S1758050AbYAPXVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050AbYAPXVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 18:21:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755933AbYAPXPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 18:15:41 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:10937 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100AbYAPXPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 18:15:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=C5+4DYOtyc7sct/i/sYa1y3AGiz76NF+QqyzdLHuNUKgQG2xXuAQnucNw30gv5aLeDqNpo1PjZNarYD1fKZ5tuB+QdL5XSLso1pgtjDEzq4ZnrmA3jwZmnxiHfuvBgn7Up+nrONcqxq5ZV04Tl2PGvV1dvmvyZqty9U6S3cF7nI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 17 Jan 2008 00:28:18 +0100
Message-Id: <20080116232818.9166.98150.sendpatchset@localhost.localdomain>
In-Reply-To: <20080116232556.9166.13457.sendpatchset@localhost.localdomain>
References: <20080116232556.9166.13457.sendpatchset@localhost.localdomain>
Subject: [PATCH 19/22] ide-acpi: remove dead code from do_drive_get_GTF()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These pointers are always setup in ide_acpi_init().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-acpi.c |   10 ----------
 1 file changed, 10 deletions(-)

Index: b/drivers/ide/ide-acpi.c
===================================================================
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -280,16 +280,6 @@ static int do_drive_get_GTF(ide_drive_t 
 
 	port = hwif->channel ? drive->dn - 2: drive->dn;
 
-	if (!drive->acpidata) {
-		if (port == 0) {
-			drive->acpidata = &hwif->acpidata->master;
-			hwif->acpidata->master.drive = drive;
-		} else {
-			drive->acpidata = &hwif->acpidata->slave;
-			hwif->acpidata->slave.drive = drive;
-		}
-	}
-
 	DEBPRINT("ENTER: %s at %s, port#: %d, hard_port#: %d\n",
 		 hwif->name, dev->bus_id, port, hwif->channel);
 
