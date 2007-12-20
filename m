Return-Path: <linux-kernel-owner+w=401wt.eu-S1760447AbXLTBlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760447AbXLTBlI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:41:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758821AbXLTBfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:35:12 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:11731 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657AbXLTBeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=N/cuN83Qx8+ZmAxjAKcyYB1DouOjmr+DTeczajOZfPbKO6/8q8dpdV+b1nQv7tGo/91mapOGN9w++DA6VmVR/q4uunOhV6QWmb4vWqxSo/7u84NJzPaEgqjA6WV1hsNwP2UkzxRq+CKeu9Z6z3T5Mg2EtS+p+dNimU3J7zmtS3M=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 04/63] ide-cd: fix error messages in cdrom_{read,write}_check_ireason()
Date: Thu, 20 Dec 2007 01:53:47 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200153.47923.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1062,8 +1062,8 @@ int cdrom_read_check_ireason (ide_drive_
 		return 0;
 	else if (ireason == 0) {
 		/* Whoops... The drive is expecting to receive data from us! */
-		printk(KERN_ERR "%s: read_intr: Drive wants to transfer data the "
-						"wrong way!\n", drive->name);
+		printk(KERN_ERR "%s: %s: wrong transfer direction!\n",
+				drive->name, __FUNCTION__);
 
 		/* Throw some data at the drive so it doesn't hang
 		   and quit this request. */
@@ -1080,8 +1080,8 @@ int cdrom_read_check_ireason (ide_drive_
 		return 0;
 	} else {
 		/* Drive wants a command packet, or invalid ireason... */
-		printk(KERN_ERR "%s: read_intr: bad interrupt reason %x\n", drive->name,
-								ireason);
+		printk(KERN_ERR "%s: %s: bad interrupt reason 0x%02x\n",
+				drive->name, __FUNCTION__, ireason);
 	}
 
 	cdrom_end_request(drive, 0);
@@ -1626,8 +1626,8 @@ static int cdrom_write_check_ireason(ide
 		return 0;
 	else if (ireason == 2) {
 		/* Whoops... The drive wants to send data. */
-		printk(KERN_ERR "%s: write_intr: wrong transfer direction!\n",
-							drive->name);
+		printk(KERN_ERR "%s: %s: wrong transfer direction!\n",
+				drive->name, __FUNCTION__);
 
 		while (len > 0) {
 			int dum = 0;
@@ -1636,8 +1636,8 @@ static int cdrom_write_check_ireason(ide
 		}
 	} else {
 		/* Drive wants a command packet, or invalid ireason... */
-		printk(KERN_ERR "%s: write_intr: bad interrupt reason %x\n",
-							drive->name, ireason);
+		printk(KERN_ERR "%s: %s: bad interrupt reason 0x%02x\n",
+				drive->name, __FUNCTION__, ireason);
 	}
 
 	cdrom_end_request(drive, 0);
