Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbYAPXRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbYAPXRj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 18:17:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755531AbYAPXOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 18:14:37 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:10411 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276AbYAPXOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 18:14:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=C1i5GscxDiEWUn3RJcDjiRzVIz+ar8olOvoaUss/tg6tN8dmqr0caWjl+ZCpshx7kkkj6PvPvU2fwf9WoGBn9uReBuxGXqU8fRRizaeLkPXsCi1OoMyLryh/9P79yLvDKOYjVRydZJ3MUTsoImLsm9aUo2u/AQpcqVVVsyWirgw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 17 Jan 2008 00:27:16 +0100
Message-Id: <20080116232716.9166.83558.sendpatchset@localhost.localdomain>
In-Reply-To: <20080116232556.9166.13457.sendpatchset@localhost.localdomain>
References: <20080116232556.9166.13457.sendpatchset@localhost.localdomain>
Subject: [PATCH 10/22] ide: skip not present devices in init_gendisk()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to initialize drive->gendev and waste memory on IDE settings
for not present devices.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1194,6 +1194,10 @@ static void init_gendisk (ide_hwif_t *hw
 
 	for (unit = 0; unit < MAX_DRIVES; ++unit) {
 		ide_drive_t * drive = &hwif->drives[unit];
+
+		if (!drive->present)
+			continue;
+
 		ide_add_generic_settings(drive);
 		snprintf(drive->gendev.bus_id,BUS_ID_SIZE,"%u.%u",
 			 hwif->index,unit);
