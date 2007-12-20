Return-Path: <linux-kernel-owner+w=401wt.eu-S1762650AbXLTCAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762650AbXLTCAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 21:00:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758752AbXLTBiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:38:04 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:11604 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758407AbXLTBe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=QNwaZtJ2Uy7jWS98V/RC5aC2pFrJL0ZPEMy4Bj9GVaxNt5qdfXS0k2eqEuTiy6BJQHjuSTE3gph5Ec3wHtR65LITetCnuP0mUpM7zTWpsdQ78BVABQhlv40isJ0hAecfAR6FsE8l9/jjGeBB5JT8UQhLngY7S8/1JE5Tafc9Hl8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 23/63] ide-cd: cleanup ide_cdrom_update_speed()
Date: Thu, 20 Dec 2007 02:10:11 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200210.11607.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
-39 bytes
 drivers/ide/ide-cd.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -2395,19 +2395,20 @@ int ide_cdrom_get_capabilities(ide_drive
 static
 void ide_cdrom_update_speed (ide_drive_t *drive, struct atapi_capabilities_page *cap)
 {
+	u16 curspeed, maxspeed;
+
 	/* The ACER/AOpen 24X cdrom has the speed fields byte-swapped */
 	if (!drive->id->model[0] &&
 	    !strncmp(drive->id->fw_rev, "241N", 4)) {
-		CDROM_STATE_FLAGS(drive)->current_speed  =
-			(le16_to_cpu(cap->curspeed) + (176/2)) / 176;
-		CDROM_CONFIG_FLAGS(drive)->max_speed =
-			(le16_to_cpu(cap->maxspeed) + (176/2)) / 176;
+		curspeed = le16_to_cpu(cap->curspeed);
+		maxspeed = le16_to_cpu(cap->maxspeed);
 	} else {
-		CDROM_STATE_FLAGS(drive)->current_speed  =
-			(be16_to_cpu(cap->curspeed) + (176/2)) / 176;
-		CDROM_CONFIG_FLAGS(drive)->max_speed =
-			(be16_to_cpu(cap->maxspeed) + (176/2)) / 176;
+		curspeed = be16_to_cpu(cap->curspeed);
+		maxspeed = be16_to_cpu(cap->maxspeed);
 	}
+
+	CDROM_STATE_FLAGS(drive)->current_speed = (curspeed + (176/2)) / 176;
+	CDROM_CONFIG_FLAGS(drive)->max_speed = (maxspeed + (176/2)) / 176;
 }
 
 static
