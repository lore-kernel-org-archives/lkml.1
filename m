Return-Path: <linux-kernel-owner+w=401wt.eu-S1752503AbZAKTK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbZAKTK4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 14:10:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbZAKTKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 14:10:35 -0500
Received: from mu-out-0910.google.com ([209.85.134.186]:36460 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbZAKTKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 14:10:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=f01bR/N24fTEDCtk6Ioup3DDNO7KZe4BZzDVYxAWUnicvEHuVZsEfhros9cFLQiGv6
         Xcj32jfTP9f3km0gASLlJsVJ4iTIATI5rQWnEojps6e/CKHngn7XVNpkt3zaNZ33UEsB
         AbLbwbBG+YQFf/AXP/T/jSneTZTgymxIGPgaM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 11 Jan 2009 20:11:26 +0100
Message-Id: <20090111191126.17361.86227.sendpatchset@localhost.localdomain>
In-Reply-To: <20090111191120.17361.69981.sendpatchset@localhost.localdomain>
References: <20090111191120.17361.69981.sendpatchset@localhost.localdomain>
Subject: [PATCH 2/8] ide-acpi: no need to zero ->acpidata for devices
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide-acpi: no need to zero ->acpidata for devices

ide_acpi_init() takes care of it.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-acpi.c |    2 --
 1 file changed, 2 deletions(-)

Index: b/drivers/ide/ide-acpi.c
===================================================================
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -718,8 +718,6 @@ void ide_acpi_port_init_devices(ide_hwif
 	 * Send IDENTIFY for each drive
 	 */
 	ide_port_for_each_dev(i, drive, hwif) {
-		memset(drive->acpidata, 0, sizeof(*drive->acpidata));
-
 		if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
 			continue;
 
